Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890B66E3EAD
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDQE6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjDQE6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:58:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A5F10D8
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:58:51 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q2so29245158pll.7
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681707530; x=1684299530;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mA+zvZSeTro/W/zKL49HqImDv+6gr9fahAFA7D1nBm4=;
        b=KEBs+/mNmcUMNLfoAnLgCnkMD/H5zMbb8ejBV0RZW4HLHQIfAcxC7KaVyLUA+7KrPU
         XvI+x51DCTezlzi6pO55dNdc6Pgy/2jjB3XueEXUXS2UGRM0dcbY+cXqXQ/h4Qc7WJ62
         B3EisbCG9FGLP6Wvgpw26DybJSABBYonPELrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681707530; x=1684299530;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mA+zvZSeTro/W/zKL49HqImDv+6gr9fahAFA7D1nBm4=;
        b=N00DOkzUcfJQhVwKPn4sS6lDBzjxwUEIgBl1/9zZ4hamQeGxZytcma196LDT2w8kJ5
         qjDA3YNAbi2Ms7mPVwWhObvUOyK8Mj2s1bFmGvi4x8x3sm/5zfPHTQG3yJ7S13zkG15g
         5Mk3WQC24z3ZqF+8pWuUUFyvl/UlT6vhcQevrK0/w48w9uSk5ohrua7JA9dI9Vktk8OT
         CPGSP59Y7aLFgmvTgTPMKRLYcwmlLZVB0Hk+PQezBoY/DEwJtGPtxBkczJirMlRN9aBJ
         Gp7nLWO9H4KfMh/6oOrQvazVSv4/nJgFn3zR9N2uPEZtZDvYlSlaVXDHwArtHuuGflIp
         LXZA==
X-Gm-Message-State: AAQBX9csdMY0T+BEiC8Toc8UDwp4qzmN4BDc0sA5zjzrB9uQgN42iziU
        hUXGCcVWGCG8izxRhcAYcikfoA==
X-Google-Smtp-Source: AKy350Y+gA00hNvHY7bE0uJKvpa1y5qWUXMvBE6UUJKf10RwOZ5IBBYKkasGbbgRjIP2zRN9IRKWrw==
X-Received: by 2002:a17:902:e5c5:b0:1a2:9ce6:6483 with SMTP id u5-20020a170902e5c500b001a29ce66483mr13306564plf.64.1681707530615;
        Sun, 16 Apr 2023 21:58:50 -0700 (PDT)
Received: from fastly.com (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id p11-20020a1709026b8b00b001a6467cfbeasm6638460plk.53.2023.04.16.21.58.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Apr 2023 21:58:50 -0700 (PDT)
Date:   Sun, 16 Apr 2023 21:58:48 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com
Subject: Re: [PATCH net v2 2/2] ixgbe: Enable setting RSS table to default
 values
Message-ID: <20230417045847.GB43796@fastly.com>
References: <20230416191223.394805-1-jdamato@fastly.com>
 <20230416191223.394805-3-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416191223.394805-3-jdamato@fastly.com>
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

On Sun, Apr 16, 2023 at 07:12:23PM +0000, Joe Damato wrote:
> ethtool uses `ETHTOOL_GRXRINGS` to compute how many queues are supported
> by RSS. The driver should return the smaller of either:
>   - The maximum number of RSS queues the device supports, OR
>   - The number of RX queues configured
> 
> Prior to this change, running `ethtool -X $iface default` fails if the
> number of queues configured is larger than the number supported by RSS,
> even though changing the queue count correctly resets the flowhash to
> use all supported queues.
> 
> Other drivers (for example, i40e) will succeed but the flow hash will
> reset to support the maximum number of queues supported by RSS, even if
> that amount is smaller than the configured amount.
> 
> Prior to this change:
> 
> $ sudo ethtool -L eth1 combined 20
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 20 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
>    24:      8     9    10    11    12    13    14    15
>    32:      0     1     2     3     4     5     6     7
> ...
> 
> You can see that the flowhash was correctly set to use the maximum
> number of queues supported by the driver (16).
> 
> However, asking the NIC to reset to "default" fails:
> 
> $ sudo ethtool -X eth1 default
> Cannot set RX flow hash configuration: Invalid argument
> 
> After this change, the flowhash can be reset to default which will use
> all of the available RSS queues (16) or the configured queue count,
> whichever is smaller.
> 
> Starting with eth1 which has 10 queues and a flowhash distributing to
> all 10 queues:
> 
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 10 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9     0     1     2     3     4     5
>    16:      6     7     8     9     0     1     2     3
> ...
> 
> Increasing the queue count to 48 resets the flowhash to distribute to 16
> queues, as it did before this patch:
> 
> $ sudo ethtool -L eth1 combined 48
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
> ...
> 
> Due to the other bugfix in this series, the flowhash can be set to use
> queues 0-5:
> 
> $ sudo ethtool -X eth1 equal 5
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     0     1     2
>     8:      3     4     0     1     2     3     4     0
>    16:      1     2     3     4     0     1     2     3
> ...
> 
> Due to this bugfix, the flowhash can be reset to default and use 16
> queues:
> 
> $ sudo ethtool -X eth1 default
> $ sudo ethtool -x eth1
> RX flow hash indirection table for eth1 with 16 RX ring(s):
>     0:      0     1     2     3     4     5     6     7
>     8:      8     9    10    11    12    13    14    15
>    16:      0     1     2     3     4     5     6     7
> ...

Fixes: 91cd94bfe4f0 ("ixgbe: add basic support for setting and getting nfc
controls")

> Signed-off-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 821dfd323fa9..0bbad4a5cc2f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -2665,6 +2665,14 @@ static int ixgbe_get_rss_hash_opts(struct ixgbe_adapter *adapter,
>  	return 0;
>  }
>  
> +static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
> +{
> +	if (adapter->hw.mac.type < ixgbe_mac_X550)
> +		return 16;
> +	else
> +		return 64;
> +}
> +
>  static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
>  			   u32 *rule_locs)
>  {
> @@ -2673,7 +2681,8 @@ static int ixgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
>  
>  	switch (cmd->cmd) {
>  	case ETHTOOL_GRXRINGS:
> -		cmd->data = adapter->num_rx_queues;
> +		cmd->data = min_t(int, adapter->num_rx_queues,
> +				  ixgbe_rss_indir_tbl_max(adapter));
>  		ret = 0;
>  		break;
>  	case ETHTOOL_GRXCLSRLCNT:
> @@ -3075,14 +3084,6 @@ static int ixgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
>  	return ret;
>  }
>  
> -static int ixgbe_rss_indir_tbl_max(struct ixgbe_adapter *adapter)
> -{
> -	if (adapter->hw.mac.type < ixgbe_mac_X550)
> -		return 16;
> -	else
> -		return 64;
> -}
> -
>  static u32 ixgbe_get_rxfh_key_size(struct net_device *netdev)
>  {
>  	return IXGBE_RSS_KEY_SIZE;
> -- 
> 2.25.1
> 
