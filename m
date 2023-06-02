Return-Path: <netdev+bounces-7459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18FA57205DE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4422F1C20B19
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D3C19E79;
	Fri,  2 Jun 2023 15:22:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC4F19E63
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:22:00 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5321BB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:21:58 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso66105e9.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 08:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685719317; x=1688311317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fb9Qs13jW0KbvZwNBjqq0Fl4mbJFibQOch8MfOsmEVI=;
        b=gGE7dJQNf/wPyyTlwinS+fECTlfSOWFdCeRJFzlXf735hXiXNmvTg6+sSx2zFKVaSa
         MjdSVTGfpmEksBXBcKgkGX68ewRyIuWUSLxjGUJauVmzGXyqF/Rd4Dr1vMtfckaYEgBH
         K67UBJLBeR5yayo5DgrqfVfkVQl72xynzhvo/79NHFqMpFu/NgvARtRpmQhLMLxI9gIf
         diaRB3tKreUDxX64+OpD1rz7KVcZG2wwQjOXPnRYRMpK7rar4xeoaMkNbzzDwHrvniPI
         9ma1YdJNF4ug+Vu6sccCtN8MzvSK9ukCPQHhSQEn1PXyDY9Cbq66+5n2pF977Nc20E9y
         LxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685719317; x=1688311317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fb9Qs13jW0KbvZwNBjqq0Fl4mbJFibQOch8MfOsmEVI=;
        b=kq6IkLcdwxlTA4YMuQpMXGOEqBwtgLtD8NLqSQtN7WlU/s/1C5qlTmIAW8z425dY5b
         Xg102BQfD3hRZlT88VWbKAMU3sJOi4QMG7zdOrrAosKXN9kerOyr8FgQg9NtXku5tSZB
         eiqvPWByWq8NTQqCAQCsJ9q0KOEUqANTGAqy6TD/FA5+9xhOrr+iBNf4eDlhEMLHzq99
         z76+tEZtcm/f0Bv4J1ww9dr4sJJShzFcgYXrMawz9dsF2U/WA1AQxidgbqAqngXV4ZMb
         iEmeBriK5HoVXofWajahLRpU6M25u0ki9A5H4iWuhlBUArrLoGVf7lqhOV3QveP2dPWP
         qMcg==
X-Gm-Message-State: AC+VfDw3DtTap7jYXFK4GI+72HS4ha+iwhT7pu83Y8uyQ8loFDiA89bC
	IR1f5doymvWy777pNcRzmN1dWCKASNGIsk17/5+8FA==
X-Google-Smtp-Source: ACHHUZ4ynveM2X0kuDP3Hx2P0Wd5lwgLZrBilq4Aw3ajCp39Q4NrzFj4HZADo8YyQ/ZlMLjbf9Xq3Txz1tUw1bidvzE=
X-Received: by 2002:a05:600c:510b:b0:3f1:9396:6fbf with SMTP id
 o11-20020a05600c510b00b003f193966fbfmr229498wms.4.1685719316576; Fri, 02 Jun
 2023 08:21:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601211732.1606062-1-edumazet@google.com> <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
 <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com> <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com>
In-Reply-To: <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 2 Jun 2023 17:21:44 +0200
Message-ID: <CANn89iLDzPcD-ASM8266dELMqe-innWtU2wgBV2Vfv1pRYRbrw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: gso: really support BIG TCP
To: Alexander H Duyck <alexander.duyck@gmail.com>
Cc: Alexander Duyck <alexanderduyck@meta.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>, 
	David Ahern <dsahern@kernel.org>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 4:24=E2=80=AFPM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2023-06-02 at 04:30 +0200, Eric Dumazet wrote:
> > On Thu, Jun 1, 2023 at 11:46=E2=80=AFPM Alexander Duyck <alexanderduyck=
@meta.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Eric Dumazet <edumazet@google.com>
> > > > Sent: Thursday, June 1, 2023 2:18 PM
> > > > To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > > > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > > > Cc: netdev@vger.kernel.org; Xin Long <lucien.xin@gmail.com>; David =
Ahern
> > > > <dsahern@kernel.org>; eric.dumazet@gmail.com; Eric Dumazet
> > > > <edumazet@google.com>; Alexander Duyck <alexanderduyck@meta.com>
> > > > Subject: [PATCH net] tcp: gso: really support BIG TCP
> > > >
> > > > >
> > > > We missed that tcp_gso_segment() was assuming skb->len was smaller =
than
> > > > 65535 :
> > > >
> > > > oldlen =3D (u16)~skb->len;
> > > >
> > > > This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GS=
O
> > > > problems.")
> > > >
> > > > This leads to wrong TCP checksum.
> > > >
> > > > Simply use csum_fold() to support 32bit packet lengthes.
> > > >
> > > > oldlen name is a bit misleading, as it is the contribution of skb->=
len on the
> > > > input skb TCP checksum. I added a comment to clarify this point.
> > > >
> > > > Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > > > ---
> > > >  net/ipv4/tcp_offload.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index
> > > > 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204b5
> > > > 0e3fc76c14b64e9 100644
> > > > --- a/net/ipv4/tcp_offload.c
> > > > +++ b/net/ipv4/tcp_offload.c
> > > > @@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *s=
kb,
> > > >       if (!pskb_may_pull(skb, thlen))
> > > >               goto out;
> > > >
> > > > -     oldlen =3D (u16)~skb->len;
> > > > +     /* Contribution of skb->len in current TCP checksum */
> > > > +     oldlen =3D (__force u32)csum_fold((__force __wsum)skb->len);
> > > >       __skb_pull(skb, thlen);
> > > >
> > > >       mss =3D skb_shinfo(skb)->gso_size;
> > >
> > > The only thing I am not sure about with this change is if we risk ove=
rflowing a u32 with all the math that may occur. The original code couldn't=
 exceed a u16 for delta since we were essentially adding -oldlen + new head=
er + mss. With us now allowing the use of a value larger than 16 bit we sho=
uld be able to have the resultant value exceed 16b which means we might ove=
rflow when we add it to the current checksum.
> > >
> > > As such we may want to look at holding off on the csum_fold until aft=
er we have added the new header and mss and then store the folded value in =
delta.
> > >
> >
> > I think you missed that csum_fold() result is also a 16bit value.
>
> I saw that. My concern was more about delta versus the oldlen value
> itself though. Specifically your folded value is added to thlen + mss
> which can then overflow past a 16b value, and when byteswapped and then
> added to the original checksum there is a risk of potential overflow.

I do not think it matters. Herbert Xu said that what matters is that

oldlen + (thlen + mss) would not overflow a 32bit value./

>
> The general idea was that ~skb->len + (segment length) will always
> technically be less than 0 since the original skb->len should always be
> larger or equal to the new segmented length. So the code as it was
> would always generate a value 16 or less in length.
>
> This was important when we computed delta and added it to the original
> value since we were using htonl which would byteswap things so we could
> potentially generate a 32b value, but it couldn't overflow since the
> two addends consisted of the upper 16b and lower 16b.
>
> That is why I am thinking we are better off just dropping the "(u16)"
> cast and just passing ~skb->len as the old_len.
>
> To address this we then have a couple different approaches we could
> take:
> 1. use csum_fold on the "delta" value either before or after the htonl.
> 2. use csum_add instead "+" for the addition of (th->check + delta)
>
> I'm thinking option 2 may be the better way to go as it would just add
> 2 addc operations, one for newcheck and one at the end of the function
> for th->check.

Are you working on a patch yourself ? What would be the ETA ?

Thanks.

