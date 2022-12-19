Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDB3651222
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 19:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbiLSSmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 13:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiLSSmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 13:42:00 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C1412AAC
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 10:41:53 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r17-20020a17090aa09100b0021903e75f14so3903718pjp.9
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 10:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUe/HAilA5uQeCY16YFaRupilsMtPutRzDO3+Pp/Z1I=;
        b=VTq+9e6lK/+M/Nv1j25mTFqCS9fuVM/WZbUbgu9tZwrcHrGxG6PntyfRkU+FvADdee
         L0xvjCh8ckvZGB6cpfeUe4IQ+bLunDiizoaASo0ZdeouOvfyC8sCV83I4xOMAH3E6WU7
         Aj+J1oFcyo4meAB3Bb46FiIEDj9uk0KT6FDP1rRDVb3xXMWE9BG6l8Ns3MWoI+MpdxXQ
         TskENOsmgZE4LMzu47cNdQOiUNZGML+2W/luhO9bnIQhrLYcSJ8J0GBJIcCLgpGqEWsn
         95p/WYoGDRcovc4hNTHXLYcyx5cyylfxnAxPf3ukjrC4zFee3ni1ji4qK1wkaqsU+T+U
         SREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUe/HAilA5uQeCY16YFaRupilsMtPutRzDO3+Pp/Z1I=;
        b=TR5wt9stto1IygC3sr3JaQxKObnPj3ARPxGYoZbBFEmF/oH6i+jNdFjZXs/Jg8Ti3W
         eFOiOAVsaNcwmkqk1/sg4Eo8fV16rlhdQIx9sn/58cxydjuabSjSSX/hWfPtwRt8a6UO
         s6JmpwGi4GdZN3k8uYZ5UbSKNg7iNX7GozbM2eWAZA8GygABjrYErUdt5Sq1mQEArLRU
         7XLRWVn/FCqGRiSpZn3Bmetmaun7fmOwcJcRk9JIC/zeXIpaHbiAQdOEZQG7R2XUfDpC
         XA2V0AJLG205pnE0Q8aDliNu5lhEZKjmyNVehluk2CtL5j/Dpg5FF+U1MzP3C/e4sk/5
         gu7A==
X-Gm-Message-State: AFqh2kreQDuWyXHQd+Bammp6oYrVsHbIIgxntcvyJyvqZC/het5j0hg4
        J2TQ1bqGTx/wJMMa991RrALKnUI=
X-Google-Smtp-Source: AMrXdXu0/MeW/tiiga+F2SHL+s2785/arVi+FMGPK3PZ0NYpYry9ow01VET95wyHYkhhD3EfIoUOJNk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:fe08:b0:218:770c:9a40 with SMTP id
 ck8-20020a17090afe0800b00218770c9a40mr2448017pjb.158.1671475312904; Mon, 19
 Dec 2022 10:41:52 -0800 (PST)
Date:   Mon, 19 Dec 2022 10:41:51 -0800
In-Reply-To: <20221218051734.31411-2-cehrig@cloudflare.com>
Mime-Version: 1.0
References: <20221218051734.31411-1-cehrig@cloudflare.com> <20221218051734.31411-2-cehrig@cloudflare.com>
Message-ID: <Y6Cwb875k9sJyBfx@google.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add BPF_F_NO_TUNNEL_KEY test
From:   sdf@google.com
To:     Christian Ehrig <cehrig@cloudflare.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Paul Chaignon <paul@isovalent.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18, Christian Ehrig wrote:
> This patch adds a selftest simulating a GRE sender and receiver using
> tunnel headers without tunnel keys. It validates if packets encapsulated
> using BPF_F_NO_TUNNEL_KEY are decapsulated by a GRE receiver not
> configured with tunnel keys.

> Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>   .../selftests/bpf/progs/test_tunnel_kern.c    | 21 ++++++++++
>   tools/testing/selftests/bpf/test_tunnel.sh    | 40 +++++++++++++++++--
>   2 files changed, 58 insertions(+), 3 deletions(-)

> diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c  
> b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> index 98af55f0bcd3..508da4a23c4f 100644
> --- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> @@ -81,6 +81,27 @@ int gre_set_tunnel(struct __sk_buff *skb)
>   	return TC_ACT_OK;
>   }

> +SEC("tc")
> +int gre_set_tunnel_no_key(struct __sk_buff *skb)
> +{
> +	int ret;
> +	struct bpf_tunnel_key key;
> +
> +	__builtin_memset(&key, 0x0, sizeof(key));
> +	key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
> +	key.tunnel_ttl = 64;
> +
> +	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
> +				     BPF_F_ZERO_CSUM_TX | BPF_F_SEQ_NUMBER |
> +				     BPF_F_NO_TUNNEL_KEY);
> +	if (ret < 0) {
> +		log_err(ret);
> +		return TC_ACT_SHOT;
> +	}
> +
> +	return TC_ACT_OK;
> +}
> +
>   SEC("tc")
>   int gre_get_tunnel(struct __sk_buff *skb)
>   {
> diff --git a/tools/testing/selftests/bpf/test_tunnel.sh  
> b/tools/testing/selftests/bpf/test_tunnel.sh
> index 2eaedc1d9ed3..06857b689c11 100755
> --- a/tools/testing/selftests/bpf/test_tunnel.sh
> +++ b/tools/testing/selftests/bpf/test_tunnel.sh
> @@ -66,15 +66,20 @@ config_device()

>   add_gre_tunnel()
>   {
> +	tun_key=
> +	if [ -n "$1" ]; then
> +		tun_key="key $1"
> +	fi
> +
>   	# at_ns0 namespace
>   	ip netns exec at_ns0 \
> -        ip link add dev $DEV_NS type $TYPE seq key 2 \
> +        ip link add dev $DEV_NS type $TYPE seq $tun_key \
>   		local 172.16.1.100 remote 172.16.1.200
>   	ip netns exec at_ns0 ip link set dev $DEV_NS up
>   	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24

>   	# root namespace
> -	ip link add dev $DEV type $TYPE key 2 external
> +	ip link add dev $DEV type $TYPE $tun_key external
>   	ip link set dev $DEV up
>   	ip addr add dev $DEV 10.1.1.200/24
>   }
> @@ -238,7 +243,7 @@ test_gre()

>   	check $TYPE
>   	config_device
> -	add_gre_tunnel
> +	add_gre_tunnel 2
>   	attach_bpf $DEV gre_set_tunnel gre_get_tunnel
>   	ping $PING_ARG 10.1.1.100
>   	check_err $?
> @@ -253,6 +258,30 @@ test_gre()
>           echo -e ${GREEN}"PASS: $TYPE"${NC}
>   }

> +test_gre_no_tunnel_key()
> +{
> +	TYPE=gre
> +	DEV_NS=gre00
> +	DEV=gre11
> +	ret=0
> +
> +	check $TYPE
> +	config_device
> +	add_gre_tunnel
> +	attach_bpf $DEV gre_set_tunnel_no_key gre_get_tunnel
> +	ping $PING_ARG 10.1.1.100
> +	check_err $?
> +	ip netns exec at_ns0 ping $PING_ARG 10.1.1.200
> +	check_err $?
> +	cleanup
> +
> +        if [ $ret -ne 0 ]; then
> +                echo -e ${RED}"FAIL: $TYPE"${NC}
> +                return 1
> +        fi
> +        echo -e ${GREEN}"PASS: $TYPE"${NC}
> +}
> +
>   test_ip6gre()
>   {
>   	TYPE=ip6gre
> @@ -589,6 +618,7 @@ cleanup()
>   	ip link del ipip6tnl11 2> /dev/null
>   	ip link del ip6ip6tnl11 2> /dev/null
>   	ip link del gretap11 2> /dev/null
> +	ip link del gre11 2> /dev/null
>   	ip link del ip6gre11 2> /dev/null
>   	ip link del ip6gretap11 2> /dev/null
>   	ip link del geneve11 2> /dev/null
> @@ -641,6 +671,10 @@ bpf_tunnel_test()
>   	test_gre
>   	errors=$(( $errors + $? ))

> +	echo "Testing GRE tunnel (without tunnel keys)..."
> +	test_gre_no_tunnel_key
> +	errors=$(( $errors + $? ))
> +
>   	echo "Testing IP6GRE tunnel..."
>   	test_ip6gre
>   	errors=$(( $errors + $? ))
> --
> 2.37.4

