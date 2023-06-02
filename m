Return-Path: <netdev+bounces-7436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC86672044A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 609612818DE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECD819BA3;
	Fri,  2 Jun 2023 14:24:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB017748
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:24:26 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9B71A6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:24:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-52cbd7d0c37so1202537a12.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685715861; x=1688307861;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oRvfzI4tIS65XyGMZCfwdyr4WcJK0/cI5Vk9HR/zdb8=;
        b=KnruU6wYM2d7fETZ52P88lqxtME5VMLCpRBHVy9+6ODs14kr2g4Aetl5Pwcj17fO9y
         g9RBVcY1JCLOjzqOxkwW5W0+rxDywD4E7nJ4vevontmrIfMlYoSMuRRJ2davRjLiRmtM
         fcPoyO7EPKbuMHscRFOiaq9fZBYtZe/uZEbvgO2K9kexrTY3Y8hzTOXBkVyocQMid3uF
         2pcNH3I2hvMvxXCgt0lJO2fIHaRIPG/iQ2T2VTxQyG9Rg1d+4npvmw9IJ0tvftDvZpLO
         qvriwdYlBRq7E77plz4ww7tN1pclHC3fkZoX2gq8vqQ6crmpTrQtwCIXTDiuQjq6ZLft
         uxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685715861; x=1688307861;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oRvfzI4tIS65XyGMZCfwdyr4WcJK0/cI5Vk9HR/zdb8=;
        b=NsPXGIXOdCJd+ubRKNlwGZbt7DQdawi/j5q1UTHrsnIXjAQrvuFvb08MV6y3gmP3Ae
         1l5DxspIsvJYaAXfgWxuRGVIE7bWISjBF+4v+M27Ik5n5S1Ji4k4wqwQTykLyGk2FZab
         qn3RVTM5FPNoi79lLagl6sYbkHpKgMKSaDf7zf+UEzB+rMuxYyNnCCjljgqu9QvxRMtJ
         leHc3N8naBWyH0htB5TUXzXRrnlMhpYq5YGSNw9gM0cc96CdvidFOGHqfUiBJqRFXFxk
         NVCHmncW7Gw4UbwMmwalMAhtiqJQxgnRPorx3AGGqHEcuF1byAd0tbdOuyZmNOPZoKW0
         hx7Q==
X-Gm-Message-State: AC+VfDweSdWbQKA7p99wwt6NDrlRYwH2qpePiAm+2i3iF3Oq8uZD9T6O
	TG4lgtDPrUaUYpn2bXe+XdM=
X-Google-Smtp-Source: ACHHUZ6KsvmVK8IzezWj8vEjTBXRIVojQvJ9jNeMu5QDZW8hEXFRufIyzgaPlHDotkJ/HsdxkkbyuA==
X-Received: by 2002:a17:902:c94e:b0:1ae:4c3b:bb0b with SMTP id i14-20020a170902c94e00b001ae4c3bbb0bmr133974pla.5.1685715861119;
        Fri, 02 Jun 2023 07:24:21 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id c1-20020a170903234100b00199193e5ea1sm1441028plh.61.2023.06.02.07.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 07:24:20 -0700 (PDT)
Message-ID: <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com>
Subject: Re: [PATCH net] tcp: gso: really support BIG TCP
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Eric Dumazet <edumazet@google.com>, Alexander Duyck
	 <alexanderduyck@meta.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Xin Long
 <lucien.xin@gmail.com>, David Ahern <dsahern@kernel.org>, 
 "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Fri, 02 Jun 2023 07:24:19 -0700
In-Reply-To: <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
References: <20230601211732.1606062-1-edumazet@google.com>
	 <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
	 <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-06-02 at 04:30 +0200, Eric Dumazet wrote:
> On Thu, Jun 1, 2023 at 11:46=E2=80=AFPM Alexander Duyck <alexanderduyck@m=
eta.com> wrote:
> >=20
> >=20
> >=20
> > > -----Original Message-----
> > > From: Eric Dumazet <edumazet@google.com>
> > > Sent: Thursday, June 1, 2023 2:18 PM
> > > To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > > Cc: netdev@vger.kernel.org; Xin Long <lucien.xin@gmail.com>; David Ah=
ern
> > > <dsahern@kernel.org>; eric.dumazet@gmail.com; Eric Dumazet
> > > <edumazet@google.com>; Alexander Duyck <alexanderduyck@meta.com>
> > > Subject: [PATCH net] tcp: gso: really support BIG TCP
> > >=20
> > > >=20
> > > We missed that tcp_gso_segment() was assuming skb->len was smaller th=
an
> > > 65535 :
> > >=20
> > > oldlen =3D (u16)~skb->len;
> > >=20
> > > This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO
> > > problems.")
> > >=20
> > > This leads to wrong TCP checksum.
> > >=20
> > > Simply use csum_fold() to support 32bit packet lengthes.
> > >=20
> > > oldlen name is a bit misleading, as it is the contribution of skb->le=
n on the
> > > input skb TCP checksum. I added a comment to clarify this point.
> > >=20
> > > Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > > ---
> > >  net/ipv4/tcp_offload.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index
> > > 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204b5
> > > 0e3fc76c14b64e9 100644
> > > --- a/net/ipv4/tcp_offload.c
> > > +++ b/net/ipv4/tcp_offload.c
> > > @@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb=
,
> > >       if (!pskb_may_pull(skb, thlen))
> > >               goto out;
> > >=20
> > > -     oldlen =3D (u16)~skb->len;
> > > +     /* Contribution of skb->len in current TCP checksum */
> > > +     oldlen =3D (__force u32)csum_fold((__force __wsum)skb->len);
> > >       __skb_pull(skb, thlen);
> > >=20
> > >       mss =3D skb_shinfo(skb)->gso_size;
> >=20
> > The only thing I am not sure about with this change is if we risk overf=
lowing a u32 with all the math that may occur. The original code couldn't e=
xceed a u16 for delta since we were essentially adding -oldlen + new header=
 + mss. With us now allowing the use of a value larger than 16 bit we shoul=
d be able to have the resultant value exceed 16b which means we might overf=
low when we add it to the current checksum.
> >=20
> > As such we may want to look at holding off on the csum_fold until after=
 we have added the new header and mss and then store the folded value in de=
lta.
> >=20
>=20
> I think you missed that csum_fold() result is also a 16bit value.

I saw that. My concern was more about delta versus the oldlen value
itself though. Specifically your folded value is added to thlen + mss
which can then overflow past a 16b value, and when byteswapped and then
added to the original checksum there is a risk of potential overflow.

The general idea was that ~skb->len + (segment length) will always
technically be less than 0 since the original skb->len should always be
larger or equal to the new segmented length. So the code as it was
would always generate a value 16 or less in length.

This was important when we computed delta and added it to the original
value since we were using htonl which would byteswap things so we could
potentially generate a 32b value, but it couldn't overflow since the
two addends consisted of the upper 16b and lower 16b.

That is why I am thinking we are better off just dropping the "(u16)"
cast and just passing ~skb->len as the old_len.

To address this we then have a couple different approaches we could
take:
1. use csum_fold on the "delta" value either before or after the htonl.
2. use csum_add instead "+" for the addition of (th->check + delta)

I'm thinking option 2 may be the better way to go as it would just add
2 addc operations, one for newcheck and one at the end of the function
for th->check.



