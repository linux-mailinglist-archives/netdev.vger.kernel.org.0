Return-Path: <netdev+bounces-7460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5DD7205EB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8242D2817EB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8555219E7D;
	Fri,  2 Jun 2023 15:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F3A19BDD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:25:14 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40157E40
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:25:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso66455e9.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 08:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685719510; x=1688311510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hh0YDA1ZFgZULjoXwrckQIitm8tyqKffAZs62xGu2ao=;
        b=59dyhFmOc5nzlHduYMj+LoMNbm7uWZ9trp3VUi/z2bq0IZO1A1yLe4++mDaQPuRJzc
         R38ZkAzgq1Tqx3CuM4agnRW3MiUIpiEVHzndQXCNks4sbW+lIflpof3NNYAcYNUxbL2W
         M1NMH/zlgwMkhi0yoSYAOVckD9Cjz02Wqa2W4lyipkNyXag7Ax3V6za0cJDAfQjSm3tA
         0J2OHnXByzgjZBgV1OUrBcRqXJ6oF1TQmkfQmwQ/UYmHRbLke5nQ8lvACj5q9a/iFW6n
         ZRiWGCVKeLyNe63760ykS8ry/oxmPJIi9/IT2PcYTTQ+Huklp0p1SUMHNKCmRcAN3/GO
         Z6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685719510; x=1688311510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hh0YDA1ZFgZULjoXwrckQIitm8tyqKffAZs62xGu2ao=;
        b=J+xZnig/THnVNqfPcOf5sM72mYk8AAEQ+fZJlUt4CWRS34b4JTTjZuhWZHFkO43yOH
         YWjss6vO8WwFJ+MU51aOpWaXSfPsOVqi8PridtEFB4OwakmKbDClL/3ROvMGbQ4Qv/pj
         5kR/OCmXo2C+mVqAKdT2/0cYfq1gsy6fOCC+bx++7AkQxRdUJL2FoVsgQ+v3uIIJh2cX
         HJq9UtKPRnZu/k/MEpy2BbNFbwH+r/9mZfZsKnjWXVavIwkqF3Hw9Ok4BKA1JQQFeGLI
         T04nG1/CTLf1ptk4hfrSWaSSHBGKjoFhXyD5k8ikZ+vY/aq4bnFfnsHc/h3i2RRqqgpO
         JHHQ==
X-Gm-Message-State: AC+VfDxxvrlOo35puClG1Xd6fIreLckEQ25Q/409uwYSs6jmmmiIfM71
	qtsLQu0UDWg2HScm22Q7SEvGdNsdXxIxc3nh4oMSLw==
X-Google-Smtp-Source: ACHHUZ6PH3HTU7NYq8QMBn6WTyziVYLo5Vs8zMeCG/TfrKaF/+I28KwOVosA1ui9h3ssNIv+9SL+/InqHefktpJR7Bs=
X-Received: by 2002:a05:600c:3c9e:b0:3f1:70d1:21a6 with SMTP id
 bg30-20020a05600c3c9e00b003f170d121a6mr231296wmb.0.1685719509607; Fri, 02 Jun
 2023 08:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601211732.1606062-1-edumazet@google.com> <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
 <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
 <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com> <CANn89iLDzPcD-ASM8266dELMqe-innWtU2wgBV2Vfv1pRYRbrw@mail.gmail.com>
In-Reply-To: <CANn89iLDzPcD-ASM8266dELMqe-innWtU2wgBV2Vfv1pRYRbrw@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 2 Jun 2023 17:24:57 +0200
Message-ID: <CANn89iJoA7U_j6pPX1CXmRtZG2XNGYhFzjRyNUBn+BbfM1gfbw@mail.gmail.com>
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

On Fri, Jun 2, 2023 at 5:21=E2=80=AFPM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Fri, Jun 2, 2023 at 4:24=E2=80=AFPM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, 2023-06-02 at 04:30 +0200, Eric Dumazet wrote:
> > > On Thu, Jun 1, 2023 at 11:46=E2=80=AFPM Alexander Duyck <alexanderduy=
ck@meta.com> wrote:
> > > >
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Eric Dumazet <edumazet@google.com>
> > > > > Sent: Thursday, June 1, 2023 2:18 PM
> > > > > To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > > > > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > > > > Cc: netdev@vger.kernel.org; Xin Long <lucien.xin@gmail.com>; Davi=
d Ahern
> > > > > <dsahern@kernel.org>; eric.dumazet@gmail.com; Eric Dumazet
> > > > > <edumazet@google.com>; Alexander Duyck <alexanderduyck@meta.com>
> > > > > Subject: [PATCH net] tcp: gso: really support BIG TCP
> > > > >
> > > > > >
> > > > > We missed that tcp_gso_segment() was assuming skb->len was smalle=
r than
> > > > > 65535 :
> > > > >
> > > > > oldlen =3D (u16)~skb->len;
> > > > >
> > > > > This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW =
GSO
> > > > > problems.")
> > > > >
> > > > > This leads to wrong TCP checksum.
> > > > >
> > > > > Simply use csum_fold() to support 32bit packet lengthes.
> > > > >
> > > > > oldlen name is a bit misleading, as it is the contribution of skb=
->len on the
> > > > > input skb TCP checksum. I added a comment to clarify this point.
> > > > >
> > > > > Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header=
")
> > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > > > > ---
> > > > >  net/ipv4/tcp_offload.c | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c inde=
x
> > > > > 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204=
b5
> > > > > 0e3fc76c14b64e9 100644
> > > > > --- a/net/ipv4/tcp_offload.c
> > > > > +++ b/net/ipv4/tcp_offload.c
> > > > > @@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff =
*skb,
> > > > >       if (!pskb_may_pull(skb, thlen))
> > > > >               goto out;
> > > > >
> > > > > -     oldlen =3D (u16)~skb->len;
> > > > > +     /* Contribution of skb->len in current TCP checksum */
> > > > > +     oldlen =3D (__force u32)csum_fold((__force __wsum)skb->len)=
;
> > > > >       __skb_pull(skb, thlen);
> > > > >
> > > > >       mss =3D skb_shinfo(skb)->gso_size;
> > > >
> > > > The only thing I am not sure about with this change is if we risk o=
verflowing a u32 with all the math that may occur. The original code couldn=
't exceed a u16 for delta since we were essentially adding -oldlen + new he=
ader + mss. With us now allowing the use of a value larger than 16 bit we s=
hould be able to have the resultant value exceed 16b which means we might o=
verflow when we add it to the current checksum.
> > > >
> > > > As such we may want to look at holding off on the csum_fold until a=
fter we have added the new header and mss and then store the folded value i=
n delta.
> > > >
> > >
> > > I think you missed that csum_fold() result is also a 16bit value.
> >
> > I saw that. My concern was more about delta versus the oldlen value
> > itself though. Specifically your folded value is added to thlen + mss
> > which can then overflow past a 16b value, and when byteswapped and then
> > added to the original checksum there is a risk of potential overflow.
>
> I do not think it matters. Herbert Xu said that what matters is that
>
> oldlen + (thlen + mss) would not overflow a 32bit value./
>
> >
> > The general idea was that ~skb->len + (segment length) will always
> > technically be less than 0 since the original skb->len should always be
> > larger or equal to the new segmented length. So the code as it was
> > would always generate a value 16 or less in length.
> >
> > This was important when we computed delta and added it to the original
> > value since we were using htonl which would byteswap things so we could
> > potentially generate a 32b value, but it couldn't overflow since the
> > two addends consisted of the upper 16b and lower 16b.
> >
> > That is why I am thinking we are better off just dropping the "(u16)"
> > cast and just passing ~skb->len as the old_len.
> >
> > To address this we then have a couple different approaches we could
> > take:
> > 1. use csum_fold on the "delta" value either before or after the htonl.
> > 2. use csum_add instead "+" for the addition of (th->check + delta)
> >
> > I'm thinking option 2 may be the better way to go as it would just add
> > 2 addc operations, one for newcheck and one at the end of the function
> > for th->check.
>
> Are you working on a patch yourself ? What would be the ETA ?
>
> Thanks.

To be clear, I spent a lot of time trying to code something like the follow=
ing,
then I chose a much simpler solution (patch as you see it)

This was the WIP (and not working at all)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 3568607588b107f06b8fb7b1143d5417bb2a3ac2..19bc2d9ae10d45aa5cbb35add4a=
a8e9f6b46a6ab
100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -60,11 +60,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 {
        struct sk_buff *segs =3D ERR_PTR(-EINVAL);
        unsigned int sum_truesize =3D 0;
+       unsigned int oldlen, newlen;
        struct tcphdr *th;
        unsigned int thlen;
        unsigned int seq;
-       __be32 delta;
-       unsigned int oldlen;
+       __wsum delta;
        unsigned int mss;
        struct sk_buff *gso_skb =3D skb;
        __sum16 newcheck;
@@ -78,7 +78,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
        if (!pskb_may_pull(skb, thlen))
                goto out;

-       oldlen =3D (u16)~skb->len;
+       oldlen =3D skb->len;
        __skb_pull(skb, thlen);

        mss =3D skb_shinfo(skb)->gso_size;
@@ -113,7 +113,9 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
        if (skb_is_gso(segs))
                mss *=3D skb_shinfo(segs)->gso_segs;

-       delta =3D htonl(oldlen + (thlen + mss));
+       newlen =3D thlen + mss;
+       delta =3D csum_sub(htonl(newlen), htonl(oldlen));
+       newcheck =3D csum_fold(csum_add(csum_unfold(th->check), delta));

        skb =3D segs;
        th =3D tcp_hdr(skb);
@@ -122,8 +124,6 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
        if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_SW_TSTAMP))
                tcp_gso_tstamp(segs, skb_shinfo(gso_skb)->tskey, seq, mss);

-       newcheck =3D ~csum_fold((__force __wsum)((__force u32)th->check +
-                                              (__force u32)delta));

        while (skb->next) {
                th->fin =3D th->psh =3D 0;
@@ -168,11 +168,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
                        WARN_ON_ONCE(refcount_sub_and_test(-delta,
&skb->sk->sk_wmem_alloc));
        }

-       delta =3D htonl(oldlen + (skb_tail_pointer(skb) -
-                               skb_transport_header(skb)) +
-                     skb->data_len);
-       th->check =3D ~csum_fold((__force __wsum)((__force u32)th->check +
-                               (__force u32)delta));
+       newlen =3D skb_tail_pointer(skb) - skb_transport_header(skb) +
+                skb->data_len;
+       delta =3D csum_sub(htonl(newlen), htonl(oldlen));
+       th->check =3D csum_fold(csum_add(csum_unfold(th->check), delta));
+
        if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL)
                gso_reset_checksum(skb, ~th->check);
        else

