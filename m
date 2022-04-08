Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB654F9737
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbiDHNsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiDHNr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 09:47:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B5760CEF
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l/rHa6KSYM3v7lGcXZZnhQUMZgjH7v7FYy5FkiGllFI=; b=l/HT8IWFVpmiyM+4FLdXAG7mOF
        4aEYamAygC/ly5JMyIfMzIQkC/hhapm/U2bfNPbCdfqgRzhlHDuj0EcXdhYlI+JL1qyGRAhhu+qgK
        NsZrbcO2bwLFLN0IF66DA+/u9txT+6zxUCXeCvVCLc0wB9z2G9ij6biaplGRe3pQWk5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncovw-00EptX-GM; Fri, 08 Apr 2022 15:45:52 +0200
Date:   Fri, 8 Apr 2022 15:45:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v2 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlA8kMKK3VpJTjxx@lunn.ch>
References: <cover.1649405981.git.lorenzo@kernel.org>
 <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> +{
> +	static const char stats[PP_ETHTOOL_STATS_MAX][ETH_GSTRING_LEN] = {
> +		"rx_pp_alloc_fast",
> +		"rx_pp_alloc_slow",
> +		"rx_pp_alloc_slow_ho",
> +		"rx_pp_alloc_empty",
> +		"rx_pp_alloc_refill",
> +		"rx_pp_alloc_waive",
> +		"rx_pp_recycle_cached",
> +		"rx_pp_recycle_cache_full",
> +		"rx_pp_recycle_ring",
> +		"rx_pp_recycle_ring_full",
> +		"rx_pp_recycle_released_ref",
> +	};
> +	int i;
> +
> +	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {

I suggest you move this stats array out of the function, and then you
can use ARRAY_SIZE(stats) instead of PP_ETHTOOL_STATS_MAX. That is a
pretty common patters for ethtool statistics.

       Andrew
