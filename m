Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FB7239CE1
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHBWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgHBWsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:48:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD8DC06174A;
        Sun,  2 Aug 2020 15:48:54 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so18875819pgh.3;
        Sun, 02 Aug 2020 15:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U7VViHsjGekDZtmJigNuVCVgDWbw1OtT+DsWLHj/xLY=;
        b=pwIsan0Gct33J0tEdHQf3jxaRcDLxqXC8TWUMlt19PIJmTQDPJfFfRfgUB9Jl4RJBU
         9HJL+tlRsEJO34G9ECu8/htLhT/15zOfqLzeR+8zmc5Em1vlnA4HG3DsOb8gZnm25P40
         9jSwJc1mDmAgeCrJiGenGrh2ZR3KEC7EdkYsofW2CAmI9GPeIj2beKWTp/WxuddDInZy
         ppgd95ln5x9SZmzsOD5O01EjCfCllbuobqLvRxm97JQAuPKRp/xZgjcGWTDH82115Bvp
         isgWZ4z9BuOY+FkbgyxYwJ3ceMmrnS2BEAdO2+ex/w9gcjxY4NPKIJpGuCVBOAyX5Tr4
         kbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7VViHsjGekDZtmJigNuVCVgDWbw1OtT+DsWLHj/xLY=;
        b=L5Vfwll6hOU7JY3K7so+x5+3IrOFxKy7yqcybCNyvwlRQj/ZOLlriGkKK/r2RQx2M0
         jXpEbYgcpFVt4Q5P7geLLXTvwAA5Ta3TXTpFtKB669rEUEca5RXv0yCUFL+vP7kGwEBa
         m6aWsBSMvGcqk1OdmhC6JGSbrgLHhm4dUxnIEmU2V1VnxoDM0rV6ytMIyrtMxcK/srQ4
         JIX0nisw9ftXsL1J/Tl1zkuuQfgrPdTpSM/Xh/9fPNpWL/QVPrQPvSuIzT2PGAHBE2L9
         KNDdkyJRmpGDZ/AgqToo0wRHmoTYSkcGE5lnp+XZROV3rojuJ6yQdncN2TcWE2TMSkAG
         H0pg==
X-Gm-Message-State: AOAM531Q8myPl4Bzm7yeWN0Dat/BjVlBP0cZaq/vQzEvVw+dBH/vQAdR
        2+YsAKakSrMTVSvY3MKlCwg=
X-Google-Smtp-Source: ABdhPJxsUuPPbdXcqFd4Qb84J7TpcnHx5XZWmXiuR/Z8cF+ifP8XjFQ+2HJWoBsZdN29xb8B+cTiuQ==
X-Received: by 2002:a63:5d1:: with SMTP id 200mr12753738pgf.59.1596408533487;
        Sun, 02 Aug 2020 15:48:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:65b5])
        by smtp.gmail.com with ESMTPSA id a7sm10480331pfa.19.2020.08.02.15.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 15:48:52 -0700 (PDT)
Date:   Sun, 2 Aug 2020 15:48:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        sdf@google.com
Subject: Re: [PATCH bpf-next v5 1/2] bpf: setup socket family and addresses
 in bpf_prog_test_run_skb
Message-ID: <20200802224850.ezn6tmcz4657ia4z@ast-mbp.dhcp.thefacebook.com>
References: <20200802213631.78937-1-zeil@yandex-team.ru>
 <20200802213631.78937-2-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802213631.78937-2-zeil@yandex-team.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 12:36:30AM +0300, Dmitry Yakunin wrote:
> Now it's impossible to test all branches of cgroup_skb bpf program which
> accesses skb->family and skb->{local,remote}_ip{4,6} fields because they
> are zeroed during socket allocation. This commit fills socket family and
> addresses from related fields in constructed skb.
> 
> v2:
>   - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)
> 
> v3:
>   - check skb length before access to inet headers (Eric Dumazet)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  net/bpf/test_run.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index b03c469..8d69295 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -449,6 +449,27 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
>  	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
>  	skb_reset_network_header(skb);
>  
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		sk->sk_family = AF_INET;
> +		if (pskb_may_pull(skb, sizeof(struct iphdr))) {

skb was just inited with __skb_put(skb, size);
Looking at pskb_may_pull() messes with my brain too much,
since it should never go into __pskb_pull_tail path.
Can you open code the skb->len check instead?
if (sizeof(struct iphdr) <= skb_headlen(skb)) {

> +			sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
> +			sk->sk_daddr = ip_hdr(skb)->daddr;
> +		}
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case htons(ETH_P_IPV6):
> +		sk->sk_family = AF_INET6;
> +		if (pskb_may_pull(skb, sizeof(struct ipv6hdr))) {
> +			sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
> +			sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
> +		}
> +		break;
> +#endif
> +	default:
> +		break;
> +	}
> +
>  	if (is_l2)
>  		__skb_push(skb, hh_len);
>  	if (is_direct_pkt_access)
> -- 
> 2.7.4
> 
