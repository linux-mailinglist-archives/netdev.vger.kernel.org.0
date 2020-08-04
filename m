Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5800723B983
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 13:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgHDL15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 07:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgHDL14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 07:27:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2673C06174A;
        Tue,  4 Aug 2020 04:27:56 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l60so1794055pjb.3;
        Tue, 04 Aug 2020 04:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XtwssimjTTniuQl7LijmcNMg2apAbM55NqsMay8jLHo=;
        b=A9fr5HFU3lf8zSg+CMCJqO5u+Rhus37sWFZBf/pso+4kMD9Fv+1sdUpvwYClICy0zM
         /rfOHlQ7Y+7inApqU6w6O+j3zte0QSP7uQIdg6ZHeooAVfgStadr/Ntiza7mYYTmKCWo
         S4MwxfjfeD9U5bmSvg51VEw+aIKInU9YwTNnK8VrKbKCBF2xrqiJFvaviOoSPorKtxr3
         IcKc/BRbvVxzdS8u7KPEEBDS23ecJKXSG9/nlpw0uTU5iK0spuTOn2Y0HL+tx4j2hmqB
         4a1XHahqhwx9a2DXP4/u6RS1d9rkOrdIixjgYntLANqgwWWHFSq0T+ZpYhTW/ppGp5GW
         6IUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XtwssimjTTniuQl7LijmcNMg2apAbM55NqsMay8jLHo=;
        b=qYc/jRz+XdKdPH8sK7lw0lsOoQZ4fJ9aOaqMJjvHP3ghjZcNfOLPRV9GgEz4QlnRMg
         mbUtZuR/dciXfDOUAqcCGZHzvDf0yaXsRzgifw4boIhySAwpDla/6k31WShbl3jqhOvL
         tRsTbj87NM+EmQkMjiZSBRNX949IJj2dPx0cJ4V8V2UdCfawrc5mKrVKYAUrE0Xt932x
         LwSSDRRJIpZrF41u6GiUh/STsP7oMaPmRsu1M2tBHFdpBlzXqM88wXq9s1NBfMtUn6vs
         FMAWu2d/qBeOGkKowzMSV9HYnBNZwQYVzR+71cU4jyKjxN3fHhJuMBxkJHiCCnTS2Rks
         ipyA==
X-Gm-Message-State: AOAM5323hWE8hgVRfyrzO2SIt3ayu3wXryepdNdouPLaLO6GDKnwN6Du
        xw/+GAMwIa6c73k8or5Sscc=
X-Google-Smtp-Source: ABdhPJwsfFZK8aQeNW4ZbNv7QRfGEMuHZOB7C8ZEo5CdZNGJGZVbDMyxLfPFSk4iwVWkMzsEvSRkGw==
X-Received: by 2002:a17:90a:e2cb:: with SMTP id fr11mr3903893pjb.236.1596540476311;
        Tue, 04 Aug 2020 04:27:56 -0700 (PDT)
Received: from [192.168.97.34] (p7925058-ipngn38401marunouchi.tokyo.ocn.ne.jp. [122.16.223.58])
        by smtp.gmail.com with ESMTPSA id bt10sm2162713pjb.39.2020.08.04.04.27.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 04:27:55 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.15\))
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding lookups
 in kernel FDB table
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
In-Reply-To: <5970d82b-3bb9-c78f-c53a-8a1c95a1fad7@gmail.com>
Date:   Tue, 4 Aug 2020 20:27:47 +0900
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F99B20F3-4F88-4AFC-9DF8-B32EFD417785@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
 <5970d82b-3bb9-c78f-c53a-8a1c95a1fad7@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3445.104.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 2020/08/01 2:15=E3=80=81David Ahern <dsahern@gmail.com>=E3=81=AE=E3=83=A1=
=E3=83=BC=E3=83=AB:
>=20
> On 7/30/20 10:44 PM, Yoshiki Komachi wrote:
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 654c346b7d91..68800d1b8cd5 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -5084,6 +5085,46 @@ static const struct bpf_func_proto =
bpf_skb_fib_lookup_proto =3D {
>> 	.arg4_type	=3D ARG_ANYTHING,
>> };
>>=20
>> +#if IS_ENABLED(CONFIG_BRIDGE)
>> +BPF_CALL_4(bpf_xdp_fdb_lookup, struct xdp_buff *, ctx,
>> +	   struct bpf_fdb_lookup *, params, int, plen, u32, flags)
>> +{
>> +	struct net_device *src, *dst;
>> +	struct net *net;
>> +
>> +	if (plen < sizeof(*params))
>> +		return -EINVAL;
>=20
> I need to look at the details more closely, but on first reading 2
> things caught me eye:
> 1. you need to make sure flags is 0 since there are no supported flags
> at the moment, and

Thanks for your initial comments!

I will make sure whether this flag is required or not.

>> +
>> +	net =3D dev_net(ctx->rxq->dev);
>> +
>> +	if (is_multicast_ether_addr(params->addr) ||
>> +	    is_broadcast_ether_addr(params->addr))
>> +		return BPF_FDB_LKUP_RET_NOENT;
>> +
>> +	src =3D dev_get_by_index_rcu(net, params->ifindex);
>> +	if (unlikely(!src))
>> +		return -ENODEV;
>> +
>> +	dst =3D br_fdb_find_port_xdp(src, params->addr, =
params->vlan_id);
>=20
> 2. this needs to be done via netdev ops to avoid referencing bridge =
code
> which can be compiled as a module. I suspect the build robots will id
> this part soon.

I guess that no build errors will occur because the API is allowed when
CONFIG_BRIDGE is enabled.

I successfully build my kernel applying this patch, and I don=E2=80=99t =
receive any
messages from build robots for now.

Thanks & Best regards,


=E2=80=94
Yoshiki Komachi
komachi.yoshiki@gmail.com

