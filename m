Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7AD6DC701
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDJNCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJNCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:02:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCB55598
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:02:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m8so16473885wmq.5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681131734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMNuHyCwxEK3koi4pqvJhsXicfoNWbhWnmipyaVju4M=;
        b=HvOuBNyOgjfr39JAQKFugdJgk+1juTO10dWCflAjcDyn4yZGvd1kNMmiyjY7+CGS54
         jeE2r0TqRfOeqgfw+tqd9yvPEsiwVv0TXT6ujNobEJLF6WCYTykfyiDmzBio+oaRsWJU
         4N3DWcpc0fjpjENmCGR9EbQh20OqIWmjwkK9VuKj5bwyaJbfJC/XzWKhoUqLhjWHXJnZ
         T91p+lVTw0sAtpWhZqGO/etjxdfrv53IfTmC/rsjNUw4HPkkECCpGCCIm7TLSJFsCfLs
         E3+FAnvadpQkdy61hcHq4TLylSoQNa1L3Gt4XFpsmU1CGezXg4XePiagbdh7U6wuUZ/y
         sWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681131734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qMNuHyCwxEK3koi4pqvJhsXicfoNWbhWnmipyaVju4M=;
        b=Qr21iZtSfLYevQk2XBzQP5k77LvvAAJoSO+YCccynPJwXhgq9k3NIKfoMVLbeKunLH
         bwOXP+bGgz0/grbCvAUsU0HjAU2tMoEEgicDWRkxEs3W5nqif55q7AkwRq/sjz+J2wBB
         t4AHt5eFWr1IKI33qBy4PuS4uaUFwTAAtPb8x60qs+yZzE45eT3i03LZfnOd8bEf6ca6
         95Dj1XIS3nuNs/MinG/Nf+u/+9iA9iE8scHTs8CFf+vcak6IJpn5uUNQLIun3ugtJb1E
         pMlKwL/4XuUO752miFO5wjEVnHwzPSusMRcQ1D3rd6MhiOpMrQ1klqGFVUhrgkhuZeq+
         a/Vg==
X-Gm-Message-State: AAQBX9dObsYs193Rp3cnjqAFb6J/VHuamGbEjV9eIM9nyZjSglPuEUHi
        v9Los5AXCJi4vB8iAezoQdlT7b+laALGNimA0YKM7A==
X-Google-Smtp-Source: AKy350Y4nHCIweRVkZTWk9jjjvIwFqjS+ub19pC4j1YPV18prcWr/gTyBF1xUcEhBaPM7Z9AGCY8d3X+iNEn36z3uIE=
X-Received: by 2002:a05:600c:3c9e:b0:3f0:7403:6e63 with SMTP id
 bg30-20020a05600c3c9e00b003f074036e63mr3314026wmb.2.1681131734216; Mon, 10
 Apr 2023 06:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230410022152.4049060-1-luwei32@huawei.com>
In-Reply-To: <20230410022152.4049060-1-luwei32@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 10 Apr 2023 15:02:01 +0200
Message-ID: <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Add check for csum_start in skb_partial_csum_set()
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com, brouer@redhat.com,
        keescook@chromium.org, jbenc@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 4:22=E2=80=AFAM Lu Wei <luwei32@huawei.com> wrote:
>
> If an AF_PACKET socket is used to send packets through a L3 mode ipvlan
> and a vnet header is set via setsockopt() with the option name of
> PACKET_VNET_HDR, the value of offset will be nagetive in function
> skb_checksum_help() and trigger the following warning:
>
> WARNING: CPU: 3 PID: 2023 at net/core/dev.c:3262
> skb_checksum_help+0x2dc/0x390
> ......
> Call Trace:
>  <TASK>
>  ip_do_fragment+0x63d/0xd00
>  ip_fragment.constprop.0+0xd2/0x150
>  __ip_finish_output+0x154/0x1e0
>  ip_finish_output+0x36/0x1b0
>  ip_output+0x134/0x240
>  ip_local_out+0xba/0xe0
>  ipvlan_process_v4_outbound+0x26d/0x2b0
>  ipvlan_xmit_mode_l3+0x44b/0x480
>  ipvlan_queue_xmit+0xd6/0x1d0
>  ipvlan_start_xmit+0x32/0xa0
>  dev_hard_start_xmit+0xdf/0x3f0
>  packet_snd+0xa7d/0x1130
>  packet_sendmsg+0x7b/0xa0
>  sock_sendmsg+0x14f/0x160
>  __sys_sendto+0x209/0x2e0
>  __x64_sys_sendto+0x7d/0x90
>
> The root cause is:
> 1. skb->csum_start is set in packet_snd() according vnet_hdr:
>    skb->csum_start =3D skb_headroom(skb) + (u32)start;
>
>    'start' is the offset from skb->data, and mac header has been
>    set at this moment.
>
> 2. when this skb arrives ipvlan_process_outbound(), the mac header
>    is unset and skb_pull is called to expand the skb headroom.
>
> 3. In function skb_checksum_help(), the variable offset is calculated
>    as:
>       offset =3D skb->csum_start - skb_headroom(skb);
>
>    since skb headroom is expanded in step2, offset is nagetive, and it
>    is converted to an unsigned integer when compared with skb_headlen
>    and trigger the warning.

Not sure why it is negative ? This seems like the real problem...

csum_start is relative to skb->head, regardless of pull operations.

whatever set csum_start to a too small value should be tracked and fixed.

>
> In fact the data to be checksummed should not contain the mac header
> since the mac header is stripped after a packet leaves L2 layer.
> This patch fixes this by adding a check for csum_start to make it
> start after the mac header.
>
> Fixes: 52b5d6f5dcf0 ("net: make skb_partial_csum_set() more robust agains=
t overflows")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/core/skbuff.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1a31815104d6..5e24096076fa 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5232,9 +5232,11 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16=
 start, u16 off)
>         u32 csum_end =3D (u32)start + (u32)off + sizeof(__sum16);
>         u32 csum_start =3D skb_headroom(skb) + (u32)start;
>
> -       if (unlikely(csum_start > U16_MAX || csum_end > skb_headlen(skb))=
) {
> -               net_warn_ratelimited("bad partial csum: csum=3D%u/%u head=
room=3D%u headlen=3D%u\n",
> -                                    start, off, skb_headroom(skb), skb_h=
eadlen(skb));
> +       if (unlikely(csum_start > U16_MAX || csum_end > skb_headlen(skb) =
||
> +                    csum_start < skb->network_header)) {
> +               net_warn_ratelimited("bad partial csum: csum=3D%u/%u head=
room=3D%u headlen=3D%u network_header=3D%u\n",
> +                                    start, off, skb_headroom(skb),
> +                                    skb_headlen(skb), skb->network_heade=
r);
>

I do not understand this patch. You are working around the real bug, right =
?

Otherwise we would not have a net_warn_ratelimited() ?

csum_start should actually be at the transport header, so not
considering network header
 length seems to call for another bug report when syzbot gets smarter ?
