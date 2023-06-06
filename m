Return-Path: <netdev+bounces-8403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1C3723F02
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D03C28162F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE172A708;
	Tue,  6 Jun 2023 10:12:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851262A6EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:12:02 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C96196;
	Tue,  6 Jun 2023 03:11:59 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3f7a8089709so22427265e9.1;
        Tue, 06 Jun 2023 03:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686046318; x=1688638318;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PjZD64nD9uDw2ysYWjBEluXV8UBaLP33LjAprrSBmFs=;
        b=e26A0YwrFbBuZYyZFRc/EKk6+KmfM3WVuxfPJAoj3p1pVup17RaiYZo1f6cxIiDsO/
         yaaM9yqUXsAyiQ3a5XyBvoCqVoZaB2TdKehR2na3U2fdJ9CYw4BjDolM7GRPD4uqNw8y
         Go8WZpYgZ+QclFKRPuKCDoRxQMaCQ6luL4NfllCdR24vKRdx6waJB9YoR//cobyilsX4
         agj8G0H/OvVVZ4u6DKE/bNRR7bRrzLGpvVKlZuEKiUwwZZzBf8GhJO6ily3SFAglFX6H
         vcYJKl3mXGnRdpc8ioRqHyQH3WinnQwrREGKWHqqIZLgGxBMg/DnJfOJN5+FqOrKX4Ku
         jZVA==
X-Gm-Message-State: AC+VfDwmaCkWkWJYyWKBNZ9eBBONEMNNoJU0aL5jtmFr5PcL511//V4z
	1gUYSnvpoBZJxbdTRFaPfVI=
X-Google-Smtp-Source: ACHHUZ5VuRy6tj2/a+/ZVk3bcFIrCucyH/hLYU0AvfurxedS1PxfbUZxr/R70tGP9osBH0Iu3y7fBA==
X-Received: by 2002:a05:600c:114c:b0:3f7:6bd9:2819 with SMTP id z12-20020a05600c114c00b003f76bd92819mr1701438wmz.29.1686046317704;
        Tue, 06 Jun 2023 03:11:57 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id z19-20020a7bc7d3000000b003f7ead9be7fsm1323903wmk.38.2023.06.06.03.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:11:57 -0700 (PDT)
Date: Tue, 6 Jun 2023 03:11:55 -0700
From: Breno Leitao <leitao@debian.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	David Ahern <dsahern@kernel.org>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk,
	asml.silence@gmail.com, leit@fb.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZH8Ga15IFIUUA7j8@gmail.com>
References: <20230602163044.1820619-1-leitao@debian.org>
 <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
 <ZHxEX0TlXX7VV9kX@gmail.com>
 <CAF=yD-LvTDmWp+wAqwuQ7vKLT0hAHcQjV9Ef2rEag5J4cSZrkA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-LvTDmWp+wAqwuQ7vKLT0hAHcQjV9Ef2rEag5J4cSZrkA@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 11:17:56AM +0200, Willem de Bruijn wrote:
> > On Sat, Jun 03, 2023 at 10:21:50AM +0200, Willem de Bruijn wrote:
> > > On Fri, Jun 2, 2023 at 6:31 PM Breno Leitao <leitao@debian.org> wrote:
> > > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > >
> > > Please check the checkpatch output
> > >
> > > https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdout
> >
> > I am checking my current checkpatch before sending the patch, but I am
> > not seeing the problems above.
> >
> > My tree is at 44c026a73be8038 ("Linux 6.4-rc3"), and I am not able to
> > reproduce the problems above.
> >
> >         $ scripts/checkpatch.pl v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch
> >         total: 0 errors, 0 warnings, 0 checks, 806 lines checked
> >         v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch has no obvious style problems and is ready for submission.
> >
> > Let me investigate what options I am missing when running checkpatch.
> 
> The reference is to the checkpatch as referenced by patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20230602163044.1820619-1-leitao@debian.org/
> 
> The 80 character limit is a soft limit. But also note the CHECK
> statements on whitespace.

Right. In order to enable the "CHECK" statments, we need to pass the
"--subjective" parameter to checpatch.pl

That said, I am able to reproduce the same output now, using the
following command line:

	$ scripts/checkpatch.pl --subjective --max-line-length=80

> > > > +/* A wrapper around sock ioctls, which copies the data from userspace
> > > > + * (depending on the protocol/ioctl), and copies back the result to userspace.
> > > > + * The main motivation for this function is to pass kernel memory to the
> > > > + * protocol ioctl callbacks, instead of userspace memory.
> > > > + */
> > > > +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> > > > +{
> > > > +       int rc = 1;
> > > > +
> > > > +       if (sk_is_ipmr(sk))
> > > > +               rc = ipmr_sk_ioctl(sk, cmd, arg);
> > > > +       else if (sk_is_icmpv6(sk))
> > > > +               rc = ip6mr_sk_ioctl(sk, cmd, arg);
> > > > +       else if (sk_is_phonet(sk))
> > > > +               rc = phonet_sk_ioctl(sk, cmd, arg);
> > >
> > > Does this handle all phonet ioctl cases correctly?
> > >
> > > Notably pn_socket_ioctl has a SIOCPNGETOBJECT that reads and writes a u16.
> >
> > We are not touching  "struct proto_ops" in this patch at all.  And
> > pn_socket_ioctl() is part of "struct proto_ops".
> >
> >         const struct proto_ops phonet_stream_ops = {
> >                   ...
> >                   .ioctl          = pn_socket_ioctl,
> >         }
> >
> > That said, all the "struct proto_ops" ioctl calls backs continue to use
> > "unsigned long arg" with userspace information, at least for now.
> 
> Ok. Perhaps good to call out in the commit message that this does not
> convert all protocol ioctl callbacks.

Sure, let me send a V6 with this information in the patch summary.

