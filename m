Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C623C4B8
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 06:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHEEpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 00:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgHEEpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 00:45:52 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECDDC06174A;
        Tue,  4 Aug 2020 21:45:52 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u20so20555pfn.0;
        Tue, 04 Aug 2020 21:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MKiOyh7sU1UdF9wEbpnkg9O1/J44+9D3nI3ZBZJJL0A=;
        b=s94d7Zx5nz53iXJ/1H77qdOVZ45rkoL5cLNNWjCGXKgBcPWypBB+uTIOUG9mIywYQA
         pUgolTIFfeHZk44vXBDAMKDT4glFMv2eYdhZbT+BM4IOhm7NHT18TS+v5Nu8Zibi7qYy
         oysef81PccOcHeywR2N5Bvb+qCUhPe6lddPQYPtEQ4zoQg2h3FcpIOqcZOITJ88sjWre
         EdnNLBr2T7MUzxipnozbCSZDaXNshLbwNI65oCW1CRMnT6gMDp/vx/Bdqj0mZ2SC4jcj
         qzwmJGWWNoE/BaWpMeQZqB07M9ynSblCHU8aY0qHVQVWYJUEgRhI7bM5Brp3vqhbP8lO
         Zhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MKiOyh7sU1UdF9wEbpnkg9O1/J44+9D3nI3ZBZJJL0A=;
        b=au0oddbKKaTusUGCWKn5kuenCEBbozNH+kRuCKjVtz0unyNWdWZQPClmTtYuRC0Azo
         XIq4lnSuAu0yCix8oRGb0F8IwrKV/Iqmb27seqQQKFwpprWT/ch8BohRaRXWKkDTk9nL
         9O5as7XgtNWVMucaM5yTbDQ6mShWKHE2uk8B+Jmgm5MgBdB88tW4dynCZER9ZV7rD4Pb
         nNpUGrDUGSzC/at0VYSDG/hX0OeHacKw1dcV++oalhLBu58I1rE7hyS0V+5mTDKjPHiN
         PYqlu4ruUCB1DmSzDuFkXOxQOYUgZ32itianvXbAsYwsxeCRjdBkt3QdvD/I2ECVa1Mb
         j3fg==
X-Gm-Message-State: AOAM5317AoM40ZctT3PwY1keUbdOdf9vcdnmXYJjQpCnQ9lzCem582ap
        OJLEpEHJ9wzxibvLxzK3sq0=
X-Google-Smtp-Source: ABdhPJwf/y7erWhZKCi+ktObDF2e3NG8q0KhWHMP8vacvhMryXpk08jMAuYqxXhTTGfPRy07vJAQxQ==
X-Received: by 2002:a62:7ac2:: with SMTP id v185mr1588560pfc.277.1596602752302;
        Tue, 04 Aug 2020 21:45:52 -0700 (PDT)
Received: from [192.168.97.34] (p7925058-ipngn38401marunouchi.tokyo.ocn.ne.jp. [122.16.223.58])
        by smtp.gmail.com with ESMTPSA id 21sm1231734pfa.4.2020.08.04.21.45.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 21:45:51 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.15\))
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding lookups
 in kernel FDB table
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
In-Reply-To: <9420fbc2-3139-f23e-fb6b-e3d28b9bee5f@iogearbox.net>
Date:   Wed, 5 Aug 2020 13:45:44 +0900
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
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
Message-Id: <3D4E5E32-7A96-4803-8B6E-ECAB0D6EDE0E@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
 <9420fbc2-3139-f23e-fb6b-e3d28b9bee5f@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
X-Mailer: Apple Mail (2.3445.104.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 2020/08/01 6:12=E3=80=81Daniel Borkmann =
<daniel@iogearbox.net>=E3=81=AE=E3=83=A1=E3=83=BC=E3=83=AB:
>=20
> On 7/31/20 6:44 AM, Yoshiki Komachi wrote:
>> This patch adds a new bpf helper to access FDB in the kernel tables
>> from XDP programs. The helper enables us to find the destination port
>> of master bridge in XDP layer with high speed. If an entry in the
>> tables is successfully found, egress device index will be returned.
>> In cases of failure, packets will be dropped or forwarded to upper
>> networking stack in the kernel by XDP programs. Multicast and =
broadcast
>> packets are currently not supported. Thus, these will need to be
>> passed to upper layer on the basis of XDP_PASS action.
>> The API uses destination MAC and VLAN ID as keys, so XDP programs
>> need to extract these from forwarded packets.
>> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
>=20
> Few initial comments below:
>=20
>> ---
>>  include/uapi/linux/bpf.h       | 28 +++++++++++++++++++++
>>  net/core/filter.c              | 45 =
++++++++++++++++++++++++++++++++++
>>  scripts/bpf_helpers_doc.py     |  1 +
>>  tools/include/uapi/linux/bpf.h | 28 +++++++++++++++++++++
>>  4 files changed, 102 insertions(+)
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 54d0c886e3ba..f2e729dd1721 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -2149,6 +2149,22 @@ union bpf_attr {
>>   *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why =
the
>>   *		  packet is not forwarded or needs assist from full =
stack
>>   *
>> + * long bpf_fdb_lookup(void *ctx, struct bpf_fdb_lookup *params, int =
plen, u32 flags)
>> + *	Description
>> + *		Do FDB lookup in kernel tables using parameters in =
*params*.
>> + *		If lookup is successful (ie., FDB lookup finds a =
destination entry),
>> + *		ifindex is set to the egress device index from the FDB =
lookup.
>> + *		Both multicast and broadcast packets are currently =
unsupported
>> + *		in XDP layer.
>> + *
>> + *		*plen* argument is the size of the passed **struct =
bpf_fdb_lookup**.
>> + *		*ctx* is only **struct xdp_md** for XDP programs.
>> + *
>> + *     Return
>> + *		* < 0 if any input argument is invalid
>> + *		*   0 on success (destination port is found)
>> + *		* > 0 on failure (there is no entry)
>> + *
>>   * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct =
bpf_map *map, void *key, u64 flags)
>>   *	Description
>>   *		Add an entry to, or update a sockhash *map* referencing =
sockets.
>> @@ -3449,6 +3465,7 @@ union bpf_attr {
>>  	FN(get_stack),			\
>>  	FN(skb_load_bytes_relative),	\
>>  	FN(fib_lookup),			\
>> +	FN(fdb_lookup),			\
>=20
> This breaks UAPI. Needs to be added to the very end of the list.

I figured it out and will move it to the very end of the list. Thanks!

>>  	FN(sock_hash_update),		\
>>  	FN(msg_redirect_hash),		\
>>  	FN(sk_redirect_hash),		\
>> @@ -4328,6 +4345,17 @@ struct bpf_fib_lookup {
>>  	__u8	dmac[6];     /* ETH_ALEN */
>>  };
>>  +enum {
>> +	BPF_FDB_LKUP_RET_SUCCESS,      /* lookup successful */
>> +	BPF_FDB_LKUP_RET_NOENT,        /* entry is not found */
>> +};
>> +
>> +struct bpf_fdb_lookup {
>> +	unsigned char addr[6];     /* ETH_ALEN */
>> +	__u16 vlan_id;
>> +	__u32 ifindex;
>> +};
>> +
>>  enum bpf_task_fd_type {
>>  	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
>>  	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 654c346b7d91..68800d1b8cd5 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -45,6 +45,7 @@
>>  #include <linux/filter.h>
>>  #include <linux/ratelimit.h>
>>  #include <linux/seccomp.h>
>> +#include <linux/if_bridge.h>
>>  #include <linux/if_vlan.h>
>>  #include <linux/bpf.h>
>>  #include <linux/btf.h>
>> @@ -5084,6 +5085,46 @@ static const struct bpf_func_proto =
bpf_skb_fib_lookup_proto =3D {
>>  	.arg4_type	=3D ARG_ANYTHING,
>>  };
>>  +#if IS_ENABLED(CONFIG_BRIDGE)
>> +BPF_CALL_4(bpf_xdp_fdb_lookup, struct xdp_buff *, ctx,
>> +	   struct bpf_fdb_lookup *, params, int, plen, u32, flags)
>> +{
>> +	struct net_device *src, *dst;
>> +	struct net *net;
>> +
>> +	if (plen < sizeof(*params))
>> +		return -EINVAL;
>=20
> Given flags are not used, this needs to reject anything invalid =
otherwise
> you're not able to extend it in future.

I added this flags based on the bpf_fib_lookup() helper, but these are =
not
used at this point.

I will make sure whether this flags are required or not.

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
>> +	if (dst) {
>> +		params->ifindex =3D dst->ifindex;
>> +		return BPF_FDB_LKUP_RET_SUCCESS;
>> +	}
>=20
> Currently the helper description says nothing that this is /only/ =
limited to
> bridges. I think it would be better to also name the helper =
bpf_br_fdb_lookup()
> as well if so to avoid any confusion.

For now, the helper enables only bridges to access FDB table in the =
kernel
as you understand, so I will try to rename the helper in the next =
version.

>> +	return BPF_FDB_LKUP_RET_NOENT;
>> +}
>> +
>> +static const struct bpf_func_proto bpf_xdp_fdb_lookup_proto =3D {
>> +	.func		=3D bpf_xdp_fdb_lookup,
>> +	.gpl_only	=3D true,
>> +	.ret_type	=3D RET_INTEGER,
>> +	.arg1_type      =3D ARG_PTR_TO_CTX,
>> +	.arg2_type      =3D ARG_PTR_TO_MEM,
>> +	.arg3_type      =3D ARG_CONST_SIZE,
>> +	.arg4_type	=3D ARG_ANYTHING,
>> +};
>> +#endif
>=20
> This should also have a tc pendant (similar as done in routing lookup =
helper)
> in case native XDP is not available. This will be useful for those =
that have
> the same code compilable for both tc/XDP.

Thanks, I agree with your idea. On the basis of the bpf_fib_lookup() =
helper,
I will try to add the feature so that the helper can also be used in the =
TC hook.

Best regards,

>>  #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
>>  static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void =
*hdr, u32 len)
>>  {
>> @@ -6477,6 +6518,10 @@ xdp_func_proto(enum bpf_func_id func_id, const =
struct bpf_prog *prog)
>>  		return &bpf_xdp_adjust_tail_proto;
>>  	case BPF_FUNC_fib_lookup:
>>  		return &bpf_xdp_fib_lookup_proto;
>> +#if IS_ENABLED(CONFIG_BRIDGE)
>> +	case BPF_FUNC_fdb_lookup:
>> +		return &bpf_xdp_fdb_lookup_proto;
>> +#endif
>>  #ifdef CONFIG_INET
>>  	case BPF_FUNC_sk_lookup_udp:
>>  		return &bpf_xdp_sk_lookup_udp_proto;

=E2=80=94
Yoshiki Komachi
komachi.yoshiki@gmail.com

