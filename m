Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53E6314D6C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhBIKrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhBIKnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:43:25 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555FC06178A;
        Tue,  9 Feb 2021 02:41:47 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t25so12208435pga.2;
        Tue, 09 Feb 2021 02:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JvfA/LJIleSb9j0rSYyHAJ/5yGWi0FFleE6u6qbY8iw=;
        b=u0Yzpsaf7WWHwMAG0+z4czxMu7iL/3xkEr150rmGUrIQWJOYdBPS7h75VXXcso60Kl
         DPu3VEMZG3kL+WZzup7v3/b5nRMJfmgkoWfV7Y8eI+vyq0GUzN2PqxfR5l9617pL9c5v
         VMuDSOJ85rFPrdNXDcnLctv9hi/dsO/uoImQg5pjj+DcYF+T9IGATUoKeU5QHMc4SUyx
         K3Tnw65ZkG7qSJQ6d2VXLWyybotmI6I34lktOQfvWNCM9ECyiSLnhh2/i0BXpsiRziAW
         uWvCF47P/FbzKUZ7jmRgXkyyudPeUNymBUmKPDlGZWqf+H+LzAhVfE/INJzioyPHeSxK
         i86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JvfA/LJIleSb9j0rSYyHAJ/5yGWi0FFleE6u6qbY8iw=;
        b=DBeVS61gj3gYciQ0cFdz34QmwLop9v7brGOy82HTI5tqBgyAOshDw7NQLqJNG7jkGp
         8b6ntNihbvYMTzqyd//rPEhUYwovZoxC+AgqqajGxeAXvRXZzE062pRxct1PdbmQX83U
         7e+tkJwNuzlYi61IU6Rha/g3vCv3SYvBPSJ+TJSvJVDOd38dEr7323Kuvb12DjJySerb
         tWEGwvj9FaRmrtDVwWwGdByYLbeSJICLNr3GTrC+9hoZGtR7R4x4LOMiSvPeGi1VU1iF
         GqGhsd28avjBk36ecQIeF6LUQyq6NApjUwJsdYbCNNVBXR9DREVehduAEvu+pqf3Io7R
         fbRg==
X-Gm-Message-State: AOAM5318YW4h+jo1h3i53LNzsCRL1UE8Lqshv11PKKzdjLMU3WUPIwXx
        YaRN5GR/bxoI440nMRwi2sbOiEDE7FNRgg==
X-Google-Smtp-Source: ABdhPJxLGPjTbaFdsoacNGBPV9gdIeBJbiolzVXTvl1ohN6RUq6ZyUxUVlVfznhzhAknqg6+btBh/Q==
X-Received: by 2002:a62:8c05:0:b029:1d8:7f36:bcd8 with SMTP id m5-20020a628c050000b02901d87f36bcd8mr19154743pfd.43.1612867306644;
        Tue, 09 Feb 2021 02:41:46 -0800 (PST)
Received: from [172.17.32.195] ([122.10.101.134])
        by smtp.gmail.com with ESMTPSA id c24sm5543375pfo.209.2021.02.09.02.41.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Feb 2021 02:41:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] bpf: in bpf_skb_adjust_room correct inner protocol for
 vxlan
From:   =?utf-8?B?6buE5a2m5qOu?= <hxseverything@gmail.com>
In-Reply-To: <CA+FuTScScC2o6uDjua0T3Eucbjt8-YPf65h3xgxMpTtWvgjWmg@mail.gmail.com>
Date:   Tue, 9 Feb 2021 18:41:41 +0800
Cc:     David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8552C5F8-8410-4E81-8AF4-7018878AFCDC@gmail.com>
References: <20210208113810.11118-1-hxseverything@gmail.com>
 <CA+FuTScScC2o6uDjua0T3Eucbjt8-YPf65h3xgxMpTtWvgjWmg@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Appreciate for your reply Willem!

The original intention of this commit is that when we use =
bpf_skb_adjust_room  to encapsulate=20
Vxlan packets, we find some powerful device features disabled.=20

Setting the inner_protocol directly as skb->protocol is the root cause.

I understand that it=E2=80=99s not easy to handle all tunnel protocol in =
one bpf helper function. But for my
immature idea, when pushing Ethernet header, setting the inner_protocol =
as ETH_P_TEB may
be better.

Now the flag BPF_F_ADJ_ROOM_ENCAP_L4_UDP includes many udp tunnel types( =
e.g.=20
udp+mpls, geneve, vxlan). Adding an independent flag to represents Vxlan =
looks a little=20
reduplicative. What=E2=80=99s your suggestion?

Thanks again for your reply!



> 2021=E5=B9=B42=E6=9C=888=E6=97=A5 =E4=B8=8B=E5=8D=889:06=EF=BC=8CWillem =
de Bruijn <willemdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Feb 8, 2021 at 7:16 AM huangxuesen <hxseverything@gmail.com> =
wrote:
>>=20
>> From: huangxuesen <huangxuesen@kuaishou.com>
>>=20
>> When pushing vxlan tunnel header, set inner protocol as ETH_P_TEB in =
skb
>> to avoid HW device disabling udp tunnel segmentation offload, just =
like
>> vxlan_build_skb does.
>>=20
>> Drivers for NIC may invoke vxlan_features_check to check the
>> inner_protocol in skb for vxlan packets to decide whether to disable
>> NETIF_F_GSO_MASK. Currently it sets inner_protocol as the original
>> skb->protocol, that will make mlx5_core disable TSO and lead to huge
>> performance degradation.
>>=20
>> Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
>> Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
>> Signed-off-by: wangli <wangli09@kuaishou.com>
>> ---
>> net/core/filter.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 255aeee72402..f8d3ba3fe10f 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3466,7 +3466,12 @@ static int bpf_skb_net_grow(struct sk_buff =
*skb, u32 off, u32 len_diff,
>>                skb->inner_mac_header =3D inner_net - inner_mac_len;
>>                skb->inner_network_header =3D inner_net;
>>                skb->inner_transport_header =3D inner_trans;
>> -               skb_set_inner_protocol(skb, skb->protocol);
>> +
>> +               if (flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP &&
>> +                   inner_mac_len =3D=3D ETH_HLEN)
>> +                       skb_set_inner_protocol(skb, =
htons(ETH_P_TEB));
>=20
> This may be used by vxlan, but it does not imply it.
>=20
> Adding ETH_HLEN bytes likely means pushing an Ethernet header, but =
same point.
>=20
> Conversely, pushing an Ethernet header is not limited to UDP encap.
>=20
> This probably needs a new explicit BPF_F_ADJ_ROOM_.. flag, rather than
> trying to infer from imprecise heuristics.

