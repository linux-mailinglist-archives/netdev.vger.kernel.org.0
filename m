Return-Path: <netdev+bounces-9234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCF47281E5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DCED1C21014
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4345134C8;
	Thu,  8 Jun 2023 13:57:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA3947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:57:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D5C269F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686232677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g42i/zU9qA1c+YWptB82V5/SsHIjXPKWidObbvv1lmA=;
	b=GHrmMOWYa1tmpkpiod43PPT4Nyi1RMzV4P3AjcU6Sj8PoeB2hE1fAMdjLOtl7YzkgqhqaG
	qVsyme1HUYtbyhYopAG3x+aNRoA9YkOVo2dO449AULhKsNrp0kGJ/8GSVzSsVDATO8jOdl
	g/cFvrKgMa5anZthZlRep8KuUfnGIxs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-waM3LKTjO1yqL6Pe7Ojcvg-1; Thu, 08 Jun 2023 09:57:55 -0400
X-MC-Unique: waM3LKTjO1yqL6Pe7Ojcvg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62b67ff6943so1529826d6.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:57:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686232675; x=1688824675;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g42i/zU9qA1c+YWptB82V5/SsHIjXPKWidObbvv1lmA=;
        b=f5LYu0MJv47yo9YK69W9lbNovcnFWsLm4TrhWCwcjOn+BJtLb8KGAH+0ZDDrufCUTS
         PqH2coC+CRNgZLariWPyN0o7gWnmPJZsgarfnIky6+5Bs5Mi/BWapBpn/fH2N9rU3hJb
         DkKIb5ezpllVIgVQ5J4yDsVXc13MzVQ4rq5+Kyb9i/VB97Agrv0OWK6umcVUdwUP/iTs
         7aCjxYydeqHgZs0fFmBNLRdiI9ywPDWG4WmbtlqIRcgRrah1ahoiHqn9CJ60c2zttS57
         Ge1rg3d7sWjsMOtSmYvANXvnYGOkZ7Y/ZKCR247Y5EsWEKmI5Kho73tp/0uOnnvTt7kE
         P1yw==
X-Gm-Message-State: AC+VfDxWtaK+rFKIKUTJsPpS7upCrbpKggSvvmoDYrGiEveO3cJX5Hqv
	/D2TD5JV/1YGrlfOrpR3/WUX+qME4+68oR1OJSJMA2aiI4ojC+Z9Hr5Y6O7QBsATdKp11IAS98T
	HYyxBDKid+mhnuW5M
X-Received: by 2002:a05:6214:2a84:b0:625:8eef:1e71 with SMTP id jr4-20020a0562142a8400b006258eef1e71mr9635423qvb.0.1686232674813;
        Thu, 08 Jun 2023 06:57:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4bVJN/VdumR9tSUvby4B1H71TO9IHWdUvCd72/2KL56rdsiFNJK/08VDIyt5j+OKO/UzePvg==
X-Received: by 2002:a05:6214:2a84:b0:625:8eef:1e71 with SMTP id jr4-20020a0562142a8400b006258eef1e71mr9635397qvb.0.1686232674542;
        Thu, 08 Jun 2023 06:57:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-247-199.dyn.eolo.it. [146.241.247.199])
        by smtp.gmail.com with ESMTPSA id j9-20020a0cf509000000b0062618962ec0sm405431qvm.133.2023.06.08.06.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:57:54 -0700 (PDT)
Message-ID: <5bd6ced877e97ac674d1308eab0b8d2107b7ab85.camel@redhat.com>
Subject: Re: [PATCH net-next v6] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
From: Paolo Abeni <pabeni@redhat.com>
To: Breno Leitao <leitao@debian.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: alex.aring@gmail.com, andrea.righi@canonical.com,
 asml.silence@gmail.com,  ast@kernel.org, axboe@kernel.dk,
 courmisch@gmail.com, davem@davemloft.net,  dccp@vger.kernel.org,
 dsahern@kernel.org, edumazet@google.com, gnault@redhat.com, 
 hbh25y@gmail.com, joannelkoong@gmail.com, kernelxing@tencent.com,
 kuba@kernel.org,  leit@fb.com, linux-kernel@vger.kernel.org,
 linux-sctp@vger.kernel.org,  linux-wpan@vger.kernel.org,
 lucien.xin@gmail.com, marcelo.leitner@gmail.com,  martin.lau@kernel.org,
 martineau@kernel.org, matthieu.baerts@tessares.net, 
 miquel.raynal@bootlin.com, mptcp@lists.linux.dev, netdev@vger.kernel.org, 
 stefan@datenfreihafen.org, willemdebruijn.kernel@gmail.com, 
 wojciech.drewek@intel.com
Date: Thu, 08 Jun 2023 15:57:48 +0200
In-Reply-To: <ZIGUofpP4k24qfQs@gmail.com>
References: <20230606180045.827659-1-leitao@debian.org>
	 <20230607173142.86395-1-kuniyu@amazon.com> <ZIGUofpP4k24qfQs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-06-08 at 01:43 -0700, Breno Leitao wrote:
> Hello Kuniyuki,
> On Wed, Jun 07, 2023 at 10:31:42AM -0700, Kuniyuki Iwashima wrote:
> > > +/* This is the most common ioctl prep function, where the result (4 =
bytes) is
> > > + * copied back to userspace if the ioctl() returns successfully. No =
input is
> > > + * copied from userspace as input argument.
> > > + */
> > > +static int sock_ioctl_out(struct sock *sk, unsigned int cmd, void __=
user *arg)
> > > +{
> > > +	int ret, karg =3D 0;
> > > +
> > > +	ret =3D sk->sk_prot->ioctl(sk, cmd, &karg);
> >=20
> > We need READ_ONCE(sk->sk_prot) as IPv4 conversion or ULP chnage could
> > occur at the same time.
>=20
> Thanks for the heads-up. I would like to pick you brain and understand
> a bit more about READ_ONCE() and what is the situation that READ_ONCE()
> will solve.

AFAICS, in this specific case READ_ONCE() should not address any "real"
bug causing visible issue.

Still the lack of it will likely cause syzkaller report for (harmless,
AFAICS) 'data races' around sk->sk_prot. We want to avoid such reports,
even if harmless, because they can end-up hiding more relevant bugs.

> Is the situation related to when sock_ioctl_out() start to execute, and
> "sk->sk_prot" changes in a different thread? If that is the case, the
> arguments (cmd and arg) will be from the "previous" instance.
>=20
> Also, grepping for "sk->sk_prot->", I see more than a bunch of calls
> that do not use READ_ONCE() barrier. Why is this case different?

Races on sk->sk_prot can happen only on inet6_stream_ops (due to ulp
and/or ADDRFORM) inet6_dgram_ops (due to ADDRFORM). AFAICS here
READ_ONCE() is  needed as we can reach here via inet6_stream_ops-
>inet6_ioctl

Cheers,

Paolo


