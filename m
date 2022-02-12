Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973E34B37B1
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 20:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiBLTqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 14:46:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiBLTqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 14:46:33 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0C7606D7;
        Sat, 12 Feb 2022 11:46:29 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id h11so9438891ilq.9;
        Sat, 12 Feb 2022 11:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uWPzs2Kwa+OQUJqd0T1uRpWkUrcQE/x+6H0l4Ba0Rk0=;
        b=W2dGCJN6W89vs/eOxv1VHrzadO6ACtTxwsbdgU7YnLMu0X/Frmrl7woWq1uD2DGmU9
         1g5ANlcA8YpaGfEBt8iW+Cyk/KBDJuH1kxwuReeIp/l8GJi20dJ2wxOk1v4l5Kq+tY1u
         9SMtiiiltgLQnlBKGlk2CHKCShwJodmHbC6qlDyz4/dhF1ZbzY6afS8bxAngAcaVhXx6
         DPSBbrujfOheXbbb55etKmHYD5Ks8Ad0Nuvr1WtImFvw2ozTFB0Pj4lXt5dxKRFuvYQJ
         4zqV/0szq/xLQt0vxHfIu1bxgkgBulagaRlxG5fbX3Opeo2j26vumOdou82jDnxI0Ck3
         uj5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uWPzs2Kwa+OQUJqd0T1uRpWkUrcQE/x+6H0l4Ba0Rk0=;
        b=iVVC/GW6tzXIK7+NSgMC2wz9rZYSCVkYGq7QmjjMq8bSl1y1YRj0MNZYM0vW5Ta4WC
         7KVzL+I1XizM9syhLeY8ELS6oewuooWXDXICQv9RNTF6fpOQtnn/MNqiHdFUWGSHhC+J
         FtasgOp0s/5xwMFUobGA+1evpJ5PQpIGsUYIFzPbBaIxEymD+cPRY4yLZmSHYukXgRM3
         kmp6KmcjZCMRSLCwRkZ+yXq61Voh4vm2oT14GmKwzekKgcgstyu/LaFOlqIyQrx6hRJr
         vwgE168KqirucyzpmfsxmhPgDIwiN335UNZStnbfhFaWUGkCDxkqlVravT2HGnqDuIQ8
         1Jmw==
X-Gm-Message-State: AOAM531HsGL6S+oun3t3lohv98ZxrolcmrP8V0PraijYFJN8RUJwwvHZ
        fo0wY034R0wChd0Cb5fHL2A=
X-Google-Smtp-Source: ABdhPJytgD56tvj/eueYc72YFtAAGzg4mRqjrJw/6jHRDOA2XkNUESISjsJxrJonfd1g8rluhqYGiQ==
X-Received: by 2002:a05:6e02:1ba1:: with SMTP id n1mr3894440ili.99.1644695189011;
        Sat, 12 Feb 2022 11:46:29 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:b5fd:e5f4:5f5e:6650? ([2601:282:800:dc80:b5fd:e5f4:5f5e:6650])
        by smtp.googlemail.com with ESMTPSA id l12sm17543578ios.32.2022.02.12.11.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Feb 2022 11:46:28 -0800 (PST)
Message-ID: <717c68c0-f139-b6e5-aff1-3a4264344eeb@gmail.com>
Date:   Sat, 12 Feb 2022 12:46:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH] ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()
Content-Language: en-US
To:     Ignat Korchagin <ignat@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, dpini@cloudflare.com
References: <20220211173042.112852-1-ignat@cloudflare.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220211173042.112852-1-ignat@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 9:30 AM, Ignat Korchagin wrote:
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f927c199a93c..3f23da8c0b10 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -1839,8 +1839,8 @@ int ipv6_dev_get_saddr(struct net *net, const struct net_device *dst_dev,
>  }
>  EXPORT_SYMBOL(ipv6_dev_get_saddr);
>  
> -int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
> -		      u32 banned_flags)
> +static int __ipv6_get_lladdr(struct inet6_dev *idev, struct in6_addr *addr,
> +			      u32 banned_flags)
>  {
>  	struct inet6_ifaddr *ifp;
>  	int err = -EADDRNOTAVAIL;
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index bed8155508c8..a8861db52c18 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c
> @@ -1759,7 +1759,7 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
>  	skb_reserve(skb, hlen);
>  	skb_tailroom_reserve(skb, mtu, tlen);
>  
> -	if (__ipv6_get_lladdr(idev, &addr_buf, IFA_F_TENTATIVE)) {
> +	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
>  		/* <draft-ietf-magma-mld-source-05.txt>:
>  		 * use unspecified address as the source address
>  		 * when a valid link-local address is not available.

Why not add read_lock_bh(&idev->lock); ... read_unlock_bh(&idev->lock);
around the call to __ipv6_get_lladdr? you already have the idev.
