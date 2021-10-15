Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D878842E665
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhJOCRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbhJOCRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 22:17:41 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E2FC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:15:36 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id e144so6097886iof.3
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 19:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pVSpxqhDALlzCArMOmJVph69fVseoSZHFaecjnsiN28=;
        b=kGltuUjnGonydE/UUPsN8ss9C6hc/HVjuerBqXeLPSGuLZqKAcSoVWyXB4tIj69UT4
         NTh1jL+uRrgTnoJvs7ZrT0r+nT3HhA5c09saf6DGH+xB8pJmYvrJQM3FBg2IrUXPSjHU
         LRhlbvryfnO4Ftwo816kHD/8egAnsm9DA/NGNy8L1HycTpuBio06mLSh0Nzt47IcXLvH
         8LBXEscF6qkQn9vOAJWbZhUtkk/ZsXPpl+TGwg2krEWNn5/cleNwo8gD0Fc+/dDsVrxn
         QWqW04+sj5/0soUGxZ7eD/r2soetC1wrZACVmxLAy3GKIol9YsEjOwsm+XFr1PmznxMp
         vOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pVSpxqhDALlzCArMOmJVph69fVseoSZHFaecjnsiN28=;
        b=CWj7Y7VcT4uMBdKkuoF6X8LBSj9NRT7F1YqsAtxdWH6q2XTUIR4Y3q9iVuLJntwfDS
         eNlfiGCRbUNwxbZqHmihXIdPk4TPjzncak8eZ1C5GciueBeOR+0JJrSUyteqBI1hglex
         pJTxMUHZ9jMXOaSzYTde661011k/lJb0rgt7/8k3cgCEoS//8XSk+nbC8W7NmgvJiVYV
         mVfZUE/T/MNyzcuW0dgDKI4tXXsdJsLl6cgiyOrmW7gBHW6H1EqjE37oVQFePPvlIHqU
         fu3FaNWw3Uu2XcJCxyc7lEKe/nHmiFWn0MPCy9FU+eueKEdXqffDOAucq8Vq+IEJU4zp
         LHFQ==
X-Gm-Message-State: AOAM5325PFPlGS9CYGFSRVGa0ftdq5oNdqgrxBwenKzASE2I2AnW8wlS
        qAoDqszq8pKzMFi8InrwlRgCRZn5SgoOlA==
X-Google-Smtp-Source: ABdhPJzZMP8evm4TE6/Nhld+HyKAAOQJ5cXCeDNqsTCnyRoWt7f4e13/6OeHo73RyPdN0DmNfIcvjA==
X-Received: by 2002:a6b:7415:: with SMTP id s21mr1834203iog.168.1634264135832;
        Thu, 14 Oct 2021 19:15:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id 81sm2022329iou.21.2021.10.14.19.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 19:15:35 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>
Cc:     dsahern@gmail.com
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
Date:   Thu, 14 Oct 2021 20:15:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211014130845.410602-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ added Ido for the forwarding tests ]

On 10/14/21 7:08 AM, Stephen Suryaputra wrote:
> Commit bdb7cc643fc9 ("ipv6: Count interface receive statistics on the
> ingress netdev") does not work when ip6_forward() executes on the skbs
> with vrf-enslaved netdev. Use IP6CB(skb)->iif to get to the right one.
> 
> Add a selftest script to verify.
> 
> Fixes: bdb7cc643fc9 ("ipv6: Count interface receive statistics on the ingress netdev")
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  net/ipv6/ip6_output.c                         |   3 +-
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  .../net/forwarding/forwarding.config.sample   |   2 +
>  .../net/forwarding/ip6_forward_instats_vrf.sh | 172 ++++++++++++++++++
>  tools/testing/selftests/net/forwarding/lib.sh |   8 +
>  5 files changed, 185 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/ip6_forward_instats_vrf.sh
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 12f985f43bcc..2f044a49afa8 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -464,13 +464,14 @@ static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
>  
>  int ip6_forward(struct sk_buff *skb)
>  {
> -	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
>  	struct dst_entry *dst = skb_dst(skb);
>  	struct ipv6hdr *hdr = ipv6_hdr(skb);
>  	struct inet6_skb_parm *opt = IP6CB(skb);
>  	struct net *net = dev_net(dst->dev);
> +	struct inet6_dev *idev;
>  	u32 mtu;
>  
> +	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
>  	if (net->ipv6.devconf_all->forwarding == 0)
>  		goto error;
>  

This seems fine to me, but IPv4 and IPv6 should work the same.
