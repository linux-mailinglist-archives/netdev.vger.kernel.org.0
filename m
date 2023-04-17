Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CBD6E3EAC
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDQE5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjDQE5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:57:40 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734D81FEB
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:57:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a5158cff37so13561315ad.2
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681707458; x=1684299458;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQ2gshH4/aCZhlG2BB2SngtL8XpumcJLw5HG0dcuZLQ=;
        b=GE4kR3sifv7Fu3ED9vPiLYwCMFJ06zXf4GpRQbArlZef+q30cUwy7GR9K1tMhMFIbV
         0Ou1IQUI8GcJ1Q6VlFmTSGh7zMbsWcL8eGY8mm6BmvR6o+TfKOISgbBR5C2cRjSULg4A
         XhAI2uBwH5SEgKzYoRZRyRNkrug57bfD98MrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681707458; x=1684299458;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cQ2gshH4/aCZhlG2BB2SngtL8XpumcJLw5HG0dcuZLQ=;
        b=UlLbQu4KQ8MRoAmp7XFkQ6zuhAMBMNUXeMRPPbqltwGn7zTfUwMI0jQ5YmhFco9NKh
         +wtLoySVd6JVaFy2xtdDUO6KbnLkJb7fVXUQz0EZZ11yjNTIeuFNZrdCx+Y3IPnc0Q4q
         3TugTLqleLwKkx35Vne2qBptySfXSPHnfP54m4YEDY5yFR6XWcJMKwQ4jSJM5RQjDymw
         PZAMSspwDYAVGtJYXHI6yo09SUvP2+Y9MxpKzWoLFV9RMWqQN5gERYv3zpjaoEl9bwBt
         Xpx3AhyUMriOFKRFt6v6PorH1a2zVDWMFghoskWQN9v6IA9wOWVSMSEIreP/Zb8U5Phb
         YUGg==
X-Gm-Message-State: AAQBX9cZ2GJkrMx9DUzQ+j6ZtivQz5krZ+jIOjnku8w5ZV/bIxEISHGO
        3jGbdYoWa1w7eGtUtPaZzXVZjw==
X-Google-Smtp-Source: AKy350ZYHpIepWRtN3k9kQ19yynNJyiqDe2ySdGp7mo8KQCzt3ajVQh7ziUtJngm+4Iz0OPEnkaGAQ==
X-Received: by 2002:a05:6a00:1a16:b0:63b:646d:9165 with SMTP id g22-20020a056a001a1600b0063b646d9165mr12728795pfv.26.1681707457694;
        Sun, 16 Apr 2023 21:57:37 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id c17-20020a62e811000000b0063b8f17768dsm1209102pfi.129.2023.04.16.21.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Apr 2023 21:57:37 -0700 (PDT)
Date:   Sun, 16 Apr 2023 21:57:34 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com
Subject: Re: [PATCH net v2 1/2] ixgbe: Allow flow hash to be set via ethtool
Message-ID: <20230417045734.GA43796@fastly.com>
References: <20230416191223.394805-1-jdamato@fastly.com>
 <20230416191223.394805-2-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416191223.394805-2-jdamato@fastly.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 07:12:22PM +0000, Joe Damato wrote:
> ixgbe currently returns `EINVAL` whenever the flowhash it set by ethtool
> because the ethtool code in the kernel passes a non-zero value for hfunc
> that ixgbe should allow.
> 
> When ethtool is called with `ETHTOOL_SRXFHINDIR`,
> `ethtool_set_rxfh_indir` will call ixgbe's set_rxfh function
> with `ETH_RSS_HASH_NO_CHANGE`. This value should be accepted.
> 
> When ethtool is called with `ETHTOOL_SRSSH`, `ethtool_set_rxfh` will
> call ixgbe's set_rxfh function with `rxfh.hfunc`, which appears to be
> hardcoded in ixgbe to always be `ETH_RSS_HASH_TOP`. This value should
> also be accepted.
> 
> Before this patch:
> 
> $ sudo ethtool -L eth1 combined 10
> $ sudo ethtool -X eth1 default
> Cannot set RX flow hash configuration: Invalid argument
> 
> After this patch:
> 
> $ sudo ethtool -L eth1 combined 10
> $ sudo ethtool -X eth1 default
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 10 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9     0     1     2     3     4     5
>    16:      6     7     8     9     0     1     2     3
>    24:      4     5     6     7     8     9     0     1
>    ...
> 

Sorry for the noise, forgot the fixes tag.

Fixes: 1c7cf0784e4d ("ixgbe: support for ethtool set_rxfh")

> Signed-off-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 6cfc9dc16537..821dfd323fa9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -3131,8 +3131,8 @@ static int ixgbe_set_rxfh(struct net_device *netdev, const u32 *indir,
>  	int i;
>  	u32 reta_entries = ixgbe_rss_indir_tbl_entries(adapter);
>  
> -	if (hfunc)
> -		return -EINVAL;
> +	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
>  
>  	/* Fill out the redirection table */
>  	if (indir) {
> -- 
> 2.25.1
> 
