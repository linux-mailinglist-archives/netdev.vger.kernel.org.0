Return-Path: <netdev+bounces-7463-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC6C720664
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F2381C20B94
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436C11B8F2;
	Fri,  2 Jun 2023 15:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3219819E63
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:39:31 +0000 (UTC)
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97680197
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:39:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-25690e009c8so1051194a91.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 08:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685720369; x=1688312369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MxgwuqX/EKenWNiWaeTayEGxDqXyCuG1c9Ng25PtVIY=;
        b=XHPsCbDSPOCFDP8xJ1fktbJmcWZPxJnAsiz23vHY5tgucxLEoj1Iua/4UDEkUKdVP2
         MNCTdASyRkClpvnjYqDLQVsHxbmpTVUNKDuXpTcvrr5BE6itKRhMI9f4X44i7uTBp9L6
         AniRSgIFMFHbTxjK6CTqpZkiadVfMvBc0hYvpTXkq72hLe6VA3hj/P3OFgKKcb/kRUQZ
         DMzEt+B1zD5ZP18SJNWCEotnAUtZYnHCW6h6dBpn3dQCmRSOyaiZdjgGZ94F4iSV68KY
         tUpt4fopyfdURzUtTTBlxcq4MijxiSRYSgO4W8W6yll6BTzgptgaOn3MeDFeZD6pA/dd
         R7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685720369; x=1688312369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MxgwuqX/EKenWNiWaeTayEGxDqXyCuG1c9Ng25PtVIY=;
        b=UD05KWB7kNUu1VcE9BpHKGsKks43s8cL2r9qaLEwQJsiQrNuWLFznDsdrC+++bYdTx
         Jh/6R1NlElT8LBYZ84+BgOkC2M3fVl8MJv/8/ArdfpZATrtwJakvvY7+qu7cR2zkIsPY
         JsCdsW981JxSzH9qHaPMRautj/awZA5uEs6Z56C2a8JZ/LYwJgTouIJNTfict43nQtWk
         pRaRqUWtFlGf9A49PyjmSCMzSnOxy7NSiLNv69LSVhw7UIbTIs1h7Wl1yv+sTQWu7IIE
         wJ9EVhoavwN4ldfTUl6u5VR8Vu7PUbX9vBp1xgadRrhk4rL4E544tugThwJZyf6BKBcN
         qC3A==
X-Gm-Message-State: AC+VfDwY/9TCiJhiVFaoXeOsdBCOfraQRVUryWhcq05i7xHpzjy+0c7T
	1bwx9fpc+e6SRgAtU1ZRtIttiHlEsilUG4t+WWY=
X-Google-Smtp-Source: ACHHUZ60hTbiSxu0Qz7aKwagObE8nw4Wx40Bd4TJMKDsbpy5+VewOpnY2Caz2Y1YJjFuWzS/FZe5HcbEDREHoyrZ6Ww=
X-Received: by 2002:a17:90a:de8e:b0:255:6133:f561 with SMTP id
 n14-20020a17090ade8e00b002556133f561mr295269pjv.10.1685720368821; Fri, 02 Jun
 2023 08:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601211732.1606062-1-edumazet@google.com> <MW5PR15MB512161EEAF0B6731DCA5AE80A449A@MW5PR15MB5121.namprd15.prod.outlook.com>
 <CANn89i+uOpwoboVi_K2MSn9x=isakxLaz1+ydTfEfGtK9h4C0g@mail.gmail.com>
 <db5f5b88ccbd40cadea8417822a3722239b7fc04.camel@gmail.com>
 <CANn89iLDzPcD-ASM8266dELMqe-innWtU2wgBV2Vfv1pRYRbrw@mail.gmail.com> <CANn89iJoA7U_j6pPX1CXmRtZG2XNGYhFzjRyNUBn+BbfM1gfbw@mail.gmail.com>
In-Reply-To: <CANn89iJoA7U_j6pPX1CXmRtZG2XNGYhFzjRyNUBn+BbfM1gfbw@mail.gmail.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 08:38:52 -0700
Message-ID: <CAKgT0Uffq97JF7cpkyQPmFh0mreHx+yKxgExnOGn6KzEoQ0HyA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: gso: really support BIG TCP
To: Eric Dumazet <edumazet@google.com>
Cc: Alexander Duyck <alexanderduyck@meta.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>, 
	David Ahern <dsahern@kernel.org>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 8:25=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:

<...>

> This was the WIP (and not working at all)

This is way more than what I was thinking Some of what I had stated
was just pseudocode. No need for the addition of newlen for instance.

> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 3568607588b107f06b8fb7b1143d5417bb2a3ac2..19bc2d9ae10d45aa5cbb35add=
4aa8e9f6b46a6ab
> 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -60,11 +60,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>  {
>         struct sk_buff *segs =3D ERR_PTR(-EINVAL);
>         unsigned int sum_truesize =3D 0;
> +       unsigned int oldlen, newlen;
>         struct tcphdr *th;
>         unsigned int thlen;
>         unsigned int seq;
> -       __be32 delta;
> -       unsigned int oldlen;
> +       __wsum delta;
>         unsigned int mss;
>         struct sk_buff *gso_skb =3D skb;
>         __sum16 newcheck;

I wouldn't even bother with any of these changes.

> @@ -78,7 +78,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>         if (!pskb_may_pull(skb, thlen))
>                 goto out;
>
> -       oldlen =3D (u16)~skb->len;
> +       oldlen =3D skb->len;
>         __skb_pull(skb, thlen);
>
>         mss =3D skb_shinfo(skb)->gso_size;

As I stated before I would just drop the "(u16)". We are expanding the
oldlen to a u32, but don't have to worry about it overflowing because
skb->len should always be greater than or equal to our segmented
length. So the most it could reach is ~0 if skb->len =3D=3D segmented
length.

> @@ -113,7 +113,9 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>         if (skb_is_gso(segs))
>                 mss *=3D skb_shinfo(segs)->gso_segs;
>
> -       delta =3D htonl(oldlen + (thlen + mss));
> +       newlen =3D thlen + mss;
> +       delta =3D csum_sub(htonl(newlen), htonl(oldlen));
> +       newcheck =3D csum_fold(csum_add(csum_unfold(th->check), delta));
>
>         skb =3D segs;
>         th =3D tcp_hdr(skb)

I think all of this can just be dropped.

> @@ -122,8 +124,6 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>         if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_SW_TSTAMP))
>                 tcp_gso_tstamp(segs, skb_shinfo(gso_skb)->tskey, seq, mss=
);
>
> -       newcheck =3D ~csum_fold((__force __wsum)((__force u32)th->check +
> -                                              (__force u32)delta));
>
>         while (skb->next) {
>                 th->fin =3D th->psh =3D 0;

So the change I would make here is:
newcheck =3D ~csum_fold(csum_add(csum_unfold(th->check, ()), (__force
__wsum)delta);


> @@ -168,11 +168,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb=
,
>                         WARN_ON_ONCE(refcount_sub_and_test(-delta,
> &skb->sk->sk_wmem_alloc));
>         }
>
> -       delta =3D htonl(oldlen + (skb_tail_pointer(skb) -
> -                               skb_transport_header(skb)) +
> -                     skb->data_len);
> -       th->check =3D ~csum_fold((__force __wsum)((__force u32)th->check =
+
> -                               (__force u32)delta));
> +       newlen =3D skb_tail_pointer(skb) - skb_transport_header(skb) +
> +                skb->data_len;
> +       delta =3D csum_sub(htonl(newlen), htonl(oldlen));
> +       th->check =3D csum_fold(csum_add(csum_unfold(th->check), delta));
> +
>         if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL)
>                 gso_reset_checksum(skb, ~th->check);
>         else

Likewise here, the only thing that has to be replaced is the th->check
line so it would be:
th->check =3D ~csum_fold(csum_add(csum_unfold(th->check, ()), (__force
__wsum)delta);

