Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A523F60C2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbhHXOnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbhHXOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:43:01 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD29C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:42:17 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q3so9234964iot.3
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FwbKzIHfOUcOHLQOCoMjPPJ39zypjy/jBf8c4OAsOC4=;
        b=IMBvfBTGP0rgkTV9Ly4yXPRhv6n82+4zUKI4dUNOn5l7JSdlu5Ljw+GLWItYfTglfj
         hl9dRhTpuDUMR8Ggc1PYWqnqrDDt0+Rt+u9ooWFILBODRXZnAf5XvPNUDwh44ego36Ti
         EkTCNd09fluwejVub3lNVkdjRYdbezUO3A0/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FwbKzIHfOUcOHLQOCoMjPPJ39zypjy/jBf8c4OAsOC4=;
        b=IYuCdmh2DidHeM1/zndd1lfOvFQk4HHp2qta/pOFrkEYGMY4IutCD5v1koE5krihm+
         IT3Pksj/HaFyU/RMzEIDd+gcjSY25F5aRd8mitm/N5KP7JtPfRZsYhMr+dhYlmhCLp5C
         wZ5kMQaM3fqhszJcCur5FiAuiOxoT3SXoFjIXyavUgx9xKUWmgbbKMD3LC4igO4Pux+O
         CJzgXv+hKW55iNSECPHHbtoEsEhQeTBhY2Neo2ammAfkp42nOF5raOl0EXVoFPOACy7X
         xKBYij4R0kLXzcP3gcjHyj439IxGvVtkIwyKiG7UbRsJWmDHYhxXL74Tue8lv7Z9r7xR
         tc3g==
X-Gm-Message-State: AOAM530SxPYZfIYFvEsr1hoycdQQyTRbD8+lvP0TbAh7d0BA4F4kWIkT
        biSQF03rr38RCsfyexvZ525v+w==
X-Google-Smtp-Source: ABdhPJxQqu8mETyqzXRwMvnGEqy/vUzqQMc7CKp8pg0AuUJ9ABYvX7tg4YhSapD5b3Uqbgkex9hkBw==
X-Received: by 2002:a6b:5a04:: with SMTP id o4mr1540398iob.44.1629816136793;
        Tue, 24 Aug 2021 07:42:16 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q10sm10318395ion.3.2021.08.24.07.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:42:16 -0700 (PDT)
Subject: Re: [PATCH linux-next] tools:test_xdp_noinline: fix boolreturn.cocci
 warnings
To:     CGEL <cgel.zte@gmail.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210824065526.60416-1-deng.changcheng@zte.com.cn>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2d701f13-8996-ed7d-3d41-794aa8a6e96c@linuxfoundation.org>
Date:   Tue, 24 Aug 2021 08:42:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210824065526.60416-1-deng.changcheng@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 12:55 AM, CGEL wrote:
> From: Jing Yangyang <jing.yangyang@zte.com.cn>
> 
> Return statements in functions returning bool should use true/false
> instead of 1/0.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
> ---
>   .../selftests/bpf/progs/test_xdp_noinline.c        | 42 +++++++++++-----------
>   1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> index 3a67921..37075f8 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
> @@ -239,7 +239,7 @@ bool parse_udp(void *data, void *data_end,
>   	udp = data + off;
>   
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
>   
>   static __attribute__ ((noinline))
> @@ -261,7 +261,7 @@ bool parse_tcp(void *data, void *data_end,
>   
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
>   
>   static __attribute__ ((noinline))
> @@ -287,7 +287,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>   	void *data;
>   
>   	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
> -		return 0;
> +		return false;
>   	data = (void *)(long)xdp->data;
>   	data_end = (void *)(long)xdp->data_end;
>   	new_eth = data;
> @@ -295,7 +295,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>   	old_eth = data + sizeof(struct ipv6hdr);
>   	if (new_eth + 1 > data_end ||
>   	    old_eth + 1 > data_end || ip6h + 1 > data_end)
> -		return 0;
> +		return false;
>   	memcpy(new_eth->eth_dest, cval->mac, 6);
>   	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>   	new_eth->eth_proto = 56710;
> @@ -314,7 +314,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
>   	ip6h->saddr.in6_u.u6_addr32[2] = 3;
>   	ip6h->saddr.in6_u.u6_addr32[3] = ip_suffix;
>   	memcpy(ip6h->daddr.in6_u.u6_addr32, dst->dstv6, 16);
> -	return 1;
> +	return true;
>   }
>   
>   static __attribute__ ((noinline))
> @@ -335,7 +335,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>   	ip_suffix <<= 15;
>   	ip_suffix ^= pckt->flow.src;
>   	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
> -		return 0;
> +		return false;
>   	data = (void *)(long)xdp->data;
>   	data_end = (void *)(long)xdp->data_end;
>   	new_eth = data;
> @@ -343,7 +343,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>   	old_eth = data + sizeof(struct iphdr);
>   	if (new_eth + 1 > data_end ||
>   	    old_eth + 1 > data_end || iph + 1 > data_end)
> -		return 0;
> +		return false;
>   	memcpy(new_eth->eth_dest, cval->mac, 6);
>   	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
>   	new_eth->eth_proto = 8;
> @@ -367,8 +367,8 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
>   		csum += *next_iph_u16++;
>   	iph->check = ~((csum & 0xffff) + (csum >> 16));
>   	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
> -		return 0;
> -	return 1;
> +		return false;
> +	return true;
>   }
>   
>   static __attribute__ ((noinline))
> @@ -386,10 +386,10 @@ bool decap_v6(struct xdp_md *xdp, void **data, void **data_end, bool inner_v4)
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
>   
>   static __attribute__ ((noinline))
> @@ -404,10 +404,10 @@ bool decap_v4(struct xdp_md *xdp, void **data, void **data_end)
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
>   
>   static __attribute__ ((noinline))
> @@ -564,22 +564,22 @@ static bool get_packet_dst(struct real_definition **real,
>   	hash = get_packet_hash(pckt, hash_16bytes);
>   	if (hash != 0x358459b7 /* jhash of ipv4 packet */  &&
>   	    hash != 0x2f4bc6bb /* jhash of ipv6 packet */)
> -		return 0;
> +		return false;
>   	key = 2 * vip_info->vip_num + hash % 2;
>   	real_pos = bpf_map_lookup_elem(&ch_rings, &key);
>   	if (!real_pos)
> -		return 0;
> +		return false;
>   	key = *real_pos;
>   	*real = bpf_map_lookup_elem(&reals, &key);
>   	if (!(*real))
> -		return 0;
> +		return false;
>   	if (!(vip_info->flags & (1 << 1))) {
>   		__u32 conn_rate_key = 512 + 2;
>   		struct lb_stats *conn_rate_stats =
>   		    bpf_map_lookup_elem(&stats, &conn_rate_key);
>   
>   		if (!conn_rate_stats)
> -			return 1;
> +			return true;
>   		cur_time = bpf_ktime_get_ns();
>   		if ((cur_time - conn_rate_stats->v2) >> 32 > 0xffFFFF) {
>   			conn_rate_stats->v1 = 1;
> @@ -587,14 +587,14 @@ static bool get_packet_dst(struct real_definition **real,
>   		} else {
>   			conn_rate_stats->v1 += 1;
>   			if (conn_rate_stats->v1 >= 1)
> -				return 1;
> +				return true;
>   		}
>   		if (pckt->flow.proto == IPPROTO_UDP)
>   			new_dst_lru.atime = cur_time;
>   		new_dst_lru.pos = key;
>   		bpf_map_update_elem(lru_map, &pckt->flow, &new_dst_lru, 0);
>   	}
> -	return 1;
> +	return true;
>   }
>   
>   __attribute__ ((noinline))
> 

We can't accept this patch. The from and Signed-off-by don't match.

thanks,
-- Shuah
