Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137412F8B48
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhAPEhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPEhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:37:33 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE99C061757;
        Fri, 15 Jan 2021 20:36:53 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d203so11883765oia.0;
        Fri, 15 Jan 2021 20:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BlqeqK9wTksAgD2a/ZAPhDPWkNZFCYi2+FM4QG1cpWU=;
        b=jPX5qW+kkUmViBqBOpkM5uFR5te3xnSYlu20llkjP3Wv+8HL3Tsvm9Oby5fGzzVb22
         Md+/8/Qu0YWRSEp5A/fq7az7qC95xHxk+Kq9pQkoksxp8nJXu72k9vKR/XN+/MN5SwPh
         VW7e7wdUMBL8uw3HLBjSL1xGPV4GDhc8x6GTOufeAvMr3KNnTjPCL8kHTYD/dBvB67EC
         GU4ApzHIrqKUT2Qxv40hjWMCQEpbW0creBMeTIRq/meuWPp9bwf1FL64tHOWklqZzCyO
         /CFBNELl3IAZX9zN5EjngNSHFe6Zt9wA5EX1N5velT15WA8E/7PonEQXD8GiDfALxpka
         lcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BlqeqK9wTksAgD2a/ZAPhDPWkNZFCYi2+FM4QG1cpWU=;
        b=AfgT/TGp12biqZU0POzyUuzc6OwDPKUBlMUzy3vdVsNUUZKI/BNU+kMUxnYyK+27ad
         9PqtB2dDvBkTMVS/ye3KEJ7UdnCc81UtABnr8RL3llOdYUZiFK6H9vu3p4n796vBn4wd
         FlBk1N/xn7FxfMDOi4i23/6KuphvBehnMNUKs+hL2A4j8Ic6yaMQQkJ0QEBhUjb5NWxl
         j5oR69U1iQpFiAucmjQVzv+frXy55Efq7bMcxJyvCvrvhlxzvic+5uR3Bh81GdLlNetE
         Y36mid6rLE+wa4KnS7dCCFS+5/dalUzh7PTyf1C1Bcfz7rRDEacqmmU2OSz98fHWoIBo
         CLZw==
X-Gm-Message-State: AOAM532ZhgdRZSnQYQyB1v84rnXDqtvHpyY+jqvaVIc1dfDbXH+YZDyi
        PpkPiYZJ1HHxpxaXX+VtCCe25S0fA0E=
X-Google-Smtp-Source: ABdhPJxW3VM7pLY9g37IyPNGmfblCLM9y/rxa1IyDqSuYsO0CyH07LlQf3DIxHe2u3Ui/Lvmyqw+qg==
X-Received: by 2002:aca:cc17:: with SMTP id c23mr8031954oig.80.1610771812674;
        Fri, 15 Jan 2021 20:36:52 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.224])
        by smtp.googlemail.com with ESMTPSA id b188sm2075313oif.49.2021.01.15.20.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:36:52 -0800 (PST)
Subject: Re: [PATCH net 1/2] ipv6: create multicast route with RTPROT_KERNEL
To:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
 <20210115184209.78611-2-mcroce@linux.microsoft.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5a553d08-2b3f-79a2-2c0e-b1ad644a43d4@gmail.com>
Date:   Fri, 15 Jan 2021 21:36:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115184209.78611-2-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 11:42 AM, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The ff00::/8 multicast route is created without specifying the fc_protocol
> field, so the default RTPROT_BOOT value is used:
> 
>   $ ip -6 -d route
>   unicast ::1 dev lo proto kernel scope global metric 256 pref medium
>   unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
>   unicast ff00::/8 dev eth0 proto boot scope global metric 256 pref medium
> 
> As the documentation says, this value identifies routes installed during
> boot, but the route is created when interface is set up.
> Change the value to RTPROT_KERNEL which is a better value.
> 
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  net/ipv6/addrconf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eff2cacd5209..19bf6822911c 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -2469,6 +2469,7 @@ static void addrconf_add_mroute(struct net_device *dev)
>  		.fc_flags = RTF_UP,
>  		.fc_type = RTN_UNICAST,
>  		.fc_nlinfo.nl_net = dev_net(dev),
> +		.fc_protocol = RTPROT_KERNEL,
>  	};
>  
>  	ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);
> 


What's the motivation for changing this? ie., what s/w cares that it is
kernel vs boot?
