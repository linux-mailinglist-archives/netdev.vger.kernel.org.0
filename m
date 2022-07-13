Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B950573AA5
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiGMPzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiGMPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:55:48 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F424E872
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:55:47 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v202-20020a6361d3000000b0041615ebed02so4180246pgb.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=piRb7uQECeW9RYchBFA8MO5mKI1hZWhBSuPsCcsEFoc=;
        b=TjHjMkxHdrjtTtLaLLkPMs792kod3mIYtSimCy6NVweAsJU75rtvhot4VpXsblBqly
         qHRf5/L3tn7yMu364MBoudvFOE15V1qz4sWU7IX1ZmSnyAtwoN3kNYw02DuKnsDO5gjp
         M7RQmANYsVuNDbgNtkXvd3a8DnuUQH+hZV3ikimvffMZd8joeIgwo7GaoFBX8DFrddDF
         llsAFJQV9aU6qv7H1VvM3a3PUKiZyeNUhvRUKDT5CnUoj9OxYRKgWhY0+MNYPlyo3vp0
         JKfjLrkj60y7DnOnKgIUy/4L8UmsN/TA25iA1sJPVSruP4sBdSbj5QDwOKoVzrQcwL4a
         C7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=piRb7uQECeW9RYchBFA8MO5mKI1hZWhBSuPsCcsEFoc=;
        b=EyW8+YElzsKISCeib+1lmBg/nqf4MKJEyr7WpQes+H77TAgN+4A4o/bsk8pOJRVXbi
         S/ttvs/AvR571dvquw6ObX/dUtJ0F4zUi4K4zS50LOldpzOxJAGfPgrFr5GgCIMQnI9U
         CNM/Y/u87YvASIiR90k/vyOm9Amc6ZdkMxmiwOJxR9hSR7fJYmzbZPvqn3MAlTWqam9M
         hbjz6iVvdejE5ULwQy2alXcrMukQz1srUbUyYRQPZy6BWXIKt7HhShXjvJWfB04EGMz/
         a8lHRW9oP/f1tcPfx1yx3tXSTz8vnchaXkrAxrCq057yYlv+LE3ZkQUzexGSR8ewGyMk
         1TZA==
X-Gm-Message-State: AJIora/WcDTKpqD6wwaIluva+kK1Rj0VkoaBG26W2GcherGZ5912Xnd5
        Vqe6G4eCDQQoENaLTcaeRhMhbGs=
X-Google-Smtp-Source: AGRyM1vCSrU7O6O9FOIV8kUv1lP2Lkoiv9Ln98VM/44THqm2zXjHACWzfrfMXWhmXMTgZeZAsBg2f70=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:db02:b0:16c:5568:d740 with SMTP id
 m2-20020a170902db0200b0016c5568d740mr3785558plx.100.1657727746774; Wed, 13
 Jul 2022 08:55:46 -0700 (PDT)
Date:   Wed, 13 Jul 2022 08:55:45 -0700
In-Reply-To: <20220713011000.29090-1-xiaolinkui@kylinos.cn>
Message-Id: <Ys7rAaRKbTEzvjFY@google.com>
Mime-Version: 1.0
References: <20220713011000.29090-1-xiaolinkui@kylinos.cn>
Subject: Re: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool functions
From:   sdf@google.com
To:     xiaolinkui <xiaolinkui@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/13, xiaolinkui wrote:
> From: Linkui Xiao<xiaolinkui@kylinos.cn>
                    ^ space here?

> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:

> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
> return of 0/1 in function 'decap_v4' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
> return of 0/1 in function 'decap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
> return of 0/1 in function 'encap_v6' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
> return of 0/1 in function 'parse_tcp' with return type bool
> tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
> return of 0/1 in function 'parse_udp' with return type bool

> Generated by: scripts/coccinelle/misc/boolreturn.cocci

> Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>

This patch likely needs a resend with proper [PATCH bpf] or
[PATCH bpf-next] subject to end up in patchwork and to be picked up.

Take a look at Documentation/bpf/bpf_devel_QA.rst section "Q: How do I
indicate which tree (bpf vs. bpf-next) my patch should be applied to?".

Since that's a cleanup, you most likely want to target bpf-next.

> ---
>   .../selftests/bpf/progs/test_xdp_noinline.c   | 30 +++++++++----------
>   1 file changed, 15 insertions(+), 15 deletions(-)

> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c  
> b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> index 125d872d7981..ba48fcb98ab2 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> @@ -239,7 +239,7 @@ bool parse_udp(void *data, void *data_end,
>   	udp = data + off;

>   	if (udp + 1 > data_end)
> -		return 0;
> +		return false;
>   	if (!is_icmp) {
>   		pckt->flow.port16[0] = udp->source;
>   		pckt->flow.port16[1] = udp->dest;
> @@ -247,7 +247,7 @@ bool parse_udp(void *data, void *data_end,
>   		pckt->flow.port16[0] = udp->dest;
>   		pckt->flow.port16[1] = udp->source;
>   	}
> -	return 1;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> @@ -261,7 +261,7 @@ bool parse_tcp(void *data, void *data_end,

>   	tcp = data + off;
>   	if (tcp + 1 > data_end)
> -		return 0;
> +		return false;
>   	if (tcp->syn)
>   		pckt->flags |= (1 << 1);
>   	if (!is_icmp) {
> @@ -271,7 +271,7 @@ bool parse_tcp(void *data, void *data_end,
>   		pckt->flow.port16[0] = tcp->dest;
>   		pckt->flow.port16[1] = tcp->source;
>   	}
> -	return 1;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> @@ -287,7 +287,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   	void *data;

>   	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
> -		return 0;
> +		return false;
>   	data = (void *)(long)xdp->data;
>   	data_end = (void *)(long)xdp->data_end;
>   	new_eth = data;
> @@ -295,7 +295,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   	old_eth = data + sizeof(struct ipv6hdr);
>   	if (new_eth + 1 > data_end ||
>   	    old_eth + 1 > data_end || ip6h + 1 > data_end)
> -		return 0;
> +		return false;
>   	memcpy(new_eth->eth_dest, cval->mac, 6);
>   	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>   	new_eth->eth_proto = 56710;
> @@ -314,7 +314,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   	ip6h->saddr.in6_u.u6_addr32[2] = 3;
>   	ip6h->saddr.in6_u.u6_addr32[3] = ip_suffix;
>   	memcpy(ip6h->daddr.in6_u.u6_addr32, dst->dstv6, 16);
> -	return 1;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> @@ -335,7 +335,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   	ip_suffix <<= 15;
>   	ip_suffix ^= pckt->flow.src;
>   	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
> -		return 0;
> +		return false;
>   	data = (void *)(long)xdp->data;
>   	data_end = (void *)(long)xdp->data_end;
>   	new_eth = data;
> @@ -343,7 +343,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   	old_eth = data + sizeof(struct iphdr);
>   	if (new_eth + 1 > data_end ||
>   	    old_eth + 1 > data_end || iph + 1 > data_end)
> -		return 0;
> +		return false;
>   	memcpy(new_eth->eth_dest, cval->mac, 6);
>   	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>   	new_eth->eth_proto = 8;
> @@ -367,8 +367,8 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value  
> *cval,
>   		csum += *next_iph_u16++;
>   	iph->check = ~((csum & 0xffff) + (csum >> 16));
>   	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
> -		return 0;
> -	return 1;
> +		return false;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> @@ -386,10 +386,10 @@ bool decap_v6(struct xdp_md *xdp, void **data, void  
> **data_end, bool inner_v4)
>   	else
>   		new_eth->eth_proto = 56710;
>   	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct ipv6hdr)))
> -		return 0;
> +		return false;
>   	*data = (void *)(long)xdp->data;
>   	*data_end = (void *)(long)xdp->data_end;
> -	return 1;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> @@ -404,10 +404,10 @@ bool decap_v4(struct xdp_md *xdp, void **data, void  
> **data_end)
>   	memcpy(new_eth->eth_dest, old_eth->eth_dest, 6);
>   	new_eth->eth_proto = 8;
>   	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
> -		return 0;
> +		return false;
>   	*data = (void *)(long)xdp->data;
>   	*data_end = (void *)(long)xdp->data_end;
> -	return 1;
> +	return true;
>   }

>   static __attribute__ ((noinline))
> --
> 2.17.1

