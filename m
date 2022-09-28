Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266E75ED16C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiI1ALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiI1ALg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:11:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61642E6A16
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 17:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB2EA61C3F
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 00:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A6C433D6;
        Wed, 28 Sep 2022 00:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664323894;
        bh=nQ03Qy7c64PkcHAC2OFXKdvbEwognZwOc02ZO4R5rp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvqL45utcplwzT1WjjH0T8mYT77UgbrlDLyE2anhuXdYrhbD8mWIktoUd+rI99tvB
         3uRJM02bS0mgG7nccwNMBk54lNDSju2PUYYxlLr9QVHfLDp4bHwc07N26Clrrs9v7g
         sZmiNpH4yolLLRmCmAtvNOXMhKQsd7L+4Llh8fU+shgOdvKdt1Z3bLhIsABJELhCx6
         sjmcyz72FU7OjfHNeKlGRC52zmnbEVHAcobmnSWH67zh9r8yAJI15kQYBU/iZIPT7Y
         L+VOV4/YlYC7iSdIeIbRwZ4B+Q0ID5Xp7BPacj60W6WeNBv1kCyI503ys6DgSl1V+D
         YY54yZ7Wh7LbA==
Date:   Tue, 27 Sep 2022 17:11:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, vinicius.gomes@intel.com,
        aravindhan.gunasekaran@intel.com,
        noor.azura.ahmad.tarmizi@intel.com
Subject: Re: [PATCH v1 1/4] ethtool: Add new hwtstamp flag
Message-ID: <20220927171132.2b3ca71a@kernel.org>
In-Reply-To: <20220927130656.32567-2-muhammad.husaini.zulkifli@intel.com>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
        <20220927130656.32567-2-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 21:06:53 +0800 Muhammad Husaini Zulkifli wrote:
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -675,6 +675,7 @@ enum ethtool_link_ext_substate_module {
>   * @ETH_SS_MSG_CLASSES: debug message class names
>   * @ETH_SS_WOL_MODES: wake-on-lan modes
>   * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
> + * @ETH_SS_HWTSTAMP_FLAG: timestamping flags
>   * @ETH_SS_TS_TX_TYPES: timestamping Tx types
>   * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
>   * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
> @@ -700,6 +701,7 @@ enum ethtool_stringset {
>  	ETH_SS_MSG_CLASSES,
>  	ETH_SS_WOL_MODES,
>  	ETH_SS_SOF_TIMESTAMPING,
> +	ETH_SS_HWTSTAMP_FLAG,
>  	ETH_SS_TS_TX_TYPES,
>  	ETH_SS_TS_RX_FILTERS,
>  	ETH_SS_UDP_TUNNEL_TYPES,
> @@ -1367,6 +1369,7 @@ struct ethtool_ts_info {
>  	__u32	cmd;
>  	__u32	so_timestamping;
>  	__s32	phc_index;
> +	__u32	flag;
>  	__u32	tx_types;
>  	__u32	tx_reserved[3];
>  	__u32	rx_filters;
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 408a664fad59..58d073b5a6d2 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -452,6 +452,7 @@ enum {
>  	ETHTOOL_A_TSINFO_UNSPEC,
>  	ETHTOOL_A_TSINFO_HEADER,			/* nest - _A_HEADER_* */
>  	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
> +	ETHTOOL_A_TSINFO_FLAG,				/* bitset */
>  	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
>  	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
>  	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */

You can't add stuff into the middle of an enum or a struct in uAPI.
What's worse for the struct ethtool_ts_info you can't actually add
anything in, period. You can reuse reserved fields but even that
requires extra legwork. If the fields were not previously validated on
input to the kernel (ie. kernel didn't check they are zero) the ioctl
path can't use them, because some application may had been passing in
garbage.
