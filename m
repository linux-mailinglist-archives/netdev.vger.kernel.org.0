Return-Path: <netdev+bounces-7738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD8C0721572
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DE3C280D32
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6976915C1;
	Sun,  4 Jun 2023 07:59:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC29258D
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:59:38 +0000 (UTC)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D378EC1;
	Sun,  4 Jun 2023 00:59:32 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-973bf581759so585956866b.0;
        Sun, 04 Jun 2023 00:59:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685865571; x=1688457571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5qs9/6uJ8IloMQNdJLVtRnVIUUbYS4OgcobJioBuxs=;
        b=IOyS9YJN2q1l5k7+XFWXCLD79i9Fon8o6PvMP92XKembdHx7SWcjy8rnzijOan0sjJ
         mxmK6KPk8iC/hYJQKbH0RpXFMW9/1VerLTbgjLKrJre8wEFidMkgCwD4KetTJIv4gfx3
         YMa9ujX9mzlMM3VS5Ghak+Wplq8ksfsvNYmaX4M1wMeI2CQmWCg1quH1J+k6kKjO6ZtD
         DScuzKKtAv/RYN5hHxlsXAMlv1dOjv7nctV0W7clSD8F6P+cwQFEOQ8CkIvJFVWGqBig
         HGTyGDtVDPGWm2ltlo3JEPjvQUV6t/cgx+Nb5fa4QGdCQRgiDMFIlP2wFV+nOpbF6cbR
         L/AQ==
X-Gm-Message-State: AC+VfDwkQLnopZfQH/oxLWHuBu2xFynCK5zE+Z7+feKunigi1tE64ZtL
	ikOeSmEszCk3vE2FxrmpJ2/KNl7AaCLqaw==
X-Google-Smtp-Source: ACHHUZ5YcxrSr3RoUr9BpB/eNrGolI0P3RzHaj6jkcll2hTu+W/ZqJE8aYJUHyyTtYhUyjhQJWqKcQ==
X-Received: by 2002:a17:907:3f1f:b0:974:5480:171e with SMTP id hq31-20020a1709073f1f00b009745480171emr4761698ejc.32.1685865570735;
        Sun, 04 Jun 2023 00:59:30 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-011.fbsv.net. [2a03:2880:31ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id u12-20020a05600c00cc00b003f7678a07c4sm383178wmm.29.2023.06.04.00.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 00:59:30 -0700 (PDT)
Date: Sun, 4 Jun 2023 00:59:27 -0700
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
Message-ID: <ZHxEX0TlXX7VV9kX@gmail.com>
References: <20230602163044.1820619-1-leitao@debian.org>
 <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Willem 

On Sat, Jun 03, 2023 at 10:21:50AM +0200, Willem de Bruijn wrote:
> On Fri, Jun 2, 2023 at 6:31 PM Breno Leitao <leitao@debian.org> wrote:
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Please check the checkpatch output
> 
> https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdout

I am checking my current checkpatch before sending the patch, but I am
not seeing the problems above.

My tree is at 44c026a73be8038 ("Linux 6.4-rc3"), and I am not able to
reproduce the problems above.

	$ scripts/checkpatch.pl v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch
	total: 0 errors, 0 warnings, 0 checks, 806 lines checked
	v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patch has no obvious style problems and is ready for submission.

Let me investigate what options I am missing when running checkpatch.

> > +/* A wrapper around sock ioctls, which copies the data from userspace
> > + * (depending on the protocol/ioctl), and copies back the result to userspace.
> > + * The main motivation for this function is to pass kernel memory to the
> > + * protocol ioctl callbacks, instead of userspace memory.
> > + */
> > +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> > +{
> > +       int rc = 1;
> > +
> > +       if (sk_is_ipmr(sk))
> > +               rc = ipmr_sk_ioctl(sk, cmd, arg);
> > +       else if (sk_is_icmpv6(sk))
> > +               rc = ip6mr_sk_ioctl(sk, cmd, arg);
> > +       else if (sk_is_phonet(sk))
> > +               rc = phonet_sk_ioctl(sk, cmd, arg);
> 
> Does this handle all phonet ioctl cases correctly?
> 
> Notably pn_socket_ioctl has a SIOCPNGETOBJECT that reads and writes a u16.

We are not touching  "struct proto_ops" in this patch at all.  And
pn_socket_ioctl() is part of "struct proto_ops".

	const struct proto_ops phonet_stream_ops = {
		  ...
		  .ioctl          = pn_socket_ioctl,
	}

That said, all the "struct proto_ops" ioctl calls backs continue to use
"unsigned long arg" with userspace information, at least for now.

	struct proto_ops {
		...
		int             (*ioctl)     (struct socket *sock, unsigned int cmd,
					      unsigned long arg);
	}

This patch only changes the "struct proto".

