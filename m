Return-Path: <netdev+bounces-7282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D8971F86E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5BC0281973
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FDCB15AA;
	Fri,  2 Jun 2023 02:30:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6B915A3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:30:44 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7001A6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 19:30:39 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so19865e9.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 19:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685673038; x=1688265038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKpa7IwyuB0Lgg6Zs3jYEbAih7ARmAA82JnGBoxXg+4=;
        b=4ARljDPD/l2yhdwYryZKhP7vjnNj2VM9CoGXtjoyjL/cJs0Gw1w60xPm7WTbz4VVqj
         +Mzp0Q3UY52UEOH0EsF481Q93Bh9QM0IA/5VTbRggHHlVnFevu1vqMXGBaOeD1t9WhXc
         de0XS29c8BylU+psYxVfz0XTCJpeQjS1h/mfWfaPgGQaFZnhKjmm91Q0VzTp9WWMzrBL
         zOFSrnZ5W5FQGnSaxLQd/9FgRYcJnsdlJdexvpIqIqmByhwR31RQIFmUqyvWitJMzdxm
         k7AtXHECTngr49lDgfWUDxaTaf8VjAOm5DwmMw95EHIomLWL27Q3b8Kf6z+T8i7+kOSS
         dWBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685673038; x=1688265038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKpa7IwyuB0Lgg6Zs3jYEbAih7ARmAA82JnGBoxXg+4=;
        b=QN+9q03w3LfspROQqZkPGedltz7kRnwwseWAMK3Q6319IWONbz4uRvwcJxdU6tC3Dj
         gpWJ+U+Z/ZJ8TXHq0hpPwKJfXu7pC71QuljqWwkyc48xCWObSkJnQ1+FkQpsR92Bi/+G
         lkwOQKCRs0sFyo71FhV0Dw5f0D6bS9pA4wuaKFBaxXQkqBa4gHARJUeo6mydxWVLzaR9
         etaN8nNY1IUzeYMSEe7MjQ/fQvgAyBgua42xyz+ISYxO2B8TKdpbhqr4o+NKhRvn8kA/
         JbbWEhLSCoOmbDTz2xddpAtMzQoTwQ7pkf4uPusNjLMLT3HWO7A3f/dPDdfeR7oBOKs3
         BFUQ==
X-Gm-Message-State: AC+VfDzinqSpLkgkY5kCy1dP389cyaKVz14+P2g+YcW4NJ9HkvwoAF1U
	U8KxOg2/Q4kTvJaM6MlP0CkYbcTUcmCzKPpY8vx2eXoGt0Z7cWjtylAX4w==
X-Google-Smtp-Source: ACHHUZ4UKMpUecmWll+vOCrRJ3WtZjbgvb7IoyZcKzNz7fnT/qfU2989Qjbg3aKVH1/fn7mHNKwPAErkJ3kv3O7GLYo=
X-Received: by 2002:a05:600c:4fce:b0:3f1:6fe9:4a95 with SMTP id
 o14-20020a05600c4fce00b003f16fe94a95mr114767wmq.4.1685673037659; Thu, 01 Jun
 2023 19:30:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601211732.1606062-1-edumazet@google.com> <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
In-Reply-To: <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 2 Jun 2023 04:30:25 +0200
Message-ID: <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: gso: really support BIG TCP
To: Alexander Duyck <alexanderduyck@meta.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	Xin Long <lucien.xin@gmail.com>, David Ahern <dsahern@kernel.org>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 11:46=E2=80=AFPM Alexander Duyck <alexanderduyck@met=
a.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Eric Dumazet <edumazet@google.com>
> > Sent: Thursday, June 1, 2023 2:18 PM
> > To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> > Cc: netdev@vger.kernel.org; Xin Long <lucien.xin@gmail.com>; David Aher=
n
> > <dsahern@kernel.org>; eric.dumazet@gmail.com; Eric Dumazet
> > <edumazet@google.com>; Alexander Duyck <alexanderduyck@meta.com>
> > Subject: [PATCH net] tcp: gso: really support BIG TCP
> >
> > >
> > We missed that tcp_gso_segment() was assuming skb->len was smaller than
> > 65535 :
> >
> > oldlen =3D (u16)~skb->len;
> >
> > This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO
> > problems.")
> >
> > This leads to wrong TCP checksum.
> >
> > Simply use csum_fold() to support 32bit packet lengthes.
> >
> > oldlen name is a bit misleading, as it is the contribution of skb->len =
on the
> > input skb TCP checksum. I added a comment to clarify this point.
> >
> > Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Alexander Duyck <alexanderduyck@fb.com>
> > ---
> >  net/ipv4/tcp_offload.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index
> > 45dda788938704c3f762256266d9ea29b6ded4a5..5a1a163b2d859696df8f204b5
> > 0e3fc76c14b64e9 100644
> > --- a/net/ipv4/tcp_offload.c
> > +++ b/net/ipv4/tcp_offload.c
> > @@ -75,7 +75,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
> >       if (!pskb_may_pull(skb, thlen))
> >               goto out;
> >
> > -     oldlen =3D (u16)~skb->len;
> > +     /* Contribution of skb->len in current TCP checksum */
> > +     oldlen =3D (__force u32)csum_fold((__force __wsum)skb->len);
> >       __skb_pull(skb, thlen);
> >
> >       mss =3D skb_shinfo(skb)->gso_size;
>
> The only thing I am not sure about with this change is if we risk overflo=
wing a u32 with all the math that may occur. The original code couldn't exc=
eed a u16 for delta since we were essentially adding -oldlen + new header +=
 mss. With us now allowing the use of a value larger than 16 bit we should =
be able to have the resultant value exceed 16b which means we might overflo=
w when we add it to the current checksum.
>
> As such we may want to look at holding off on the csum_fold until after w=
e have added the new header and mss and then store the folded value in delt=
a.
>

I think you missed that csum_fold() result is also a 16bit value.

Logic Herbert added years ago will work the same.

Here is the pure C implementation of csum_fold(), I hope this will
clear your concerns.

static inline __sum16 csum_fold(__wsum csum)
{
        u32 sum =3D (__force u32)csum;

        sum =3D (sum & 0xffff) + (sum >> 16);
        sum =3D (sum & 0xffff) + (sum >> 16);
        return (__force __sum16)~sum;
}

TCP ipv6 stack populates th->check with tcp_v6_send_check()
->
  __tcp_v6_send_check(skb, &sk->sk_v6_rcv_saddr, &sk->sk_v6_daddr);
->
    th->check =3D ~tcp_v6_check(skb->len, saddr, daddr, 0);

Thanks !

