Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22ED641CD9
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLDMRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:17:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139BF60D9
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 04:17:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAE4BB8091A
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 12:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B52C433D6;
        Sun,  4 Dec 2022 12:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670156234;
        bh=CYD2MRvXJk6zfEXRR6OnP4dpB0r7+F6/68+zYQb02aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TOvvwcIUSPr5P0kggBuBeqzO0+4bOM0/ZHODYYcOaqDVESmg+sjIwWxWlhchprVG0
         goQpG1nD4BPCBvLW9l98B9s9swPXiNwd8/W3N8N1tKb9CBcUkj/rPi/9Xh9IRn6ehn
         siffWEI+/qOnoGdbmQGqY9rb8kfXDpmTyAR20qSOJGnAgVbvNfqrko13Iwiba6Z5mG
         p2XSWNuF457BH+ykm8TqmNoP705EWSNKVcHMgOM515lVV0wdt24H8eeQNMRjVdo/Fo
         9F4nOha+rkxqLLj9CFx7NA/TnvIvawdkmmIubLbxg+ZWlb5niJU2fLsJw1jyJqCAj+
         bIyRPskolpVMQ==
Date:   Sun, 4 Dec 2022 14:17:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <Y4yPwR2vBSepDNE+@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 04:25:55PM -0800, Sudheer Mogilappagari wrote:
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
> in ioctl path. It sends RSS table, hash key and hash function
> of an interface to user space.
> 
> This patch implements existing functionality available
> in ioctl path and enables addition of new RSS context
> based parameters in future.

But why do you do this conversion now? Was this "future" already
discussed on the ML?

> 
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> ---

<...>

> +	u8 *rss_config;
> +	int ret;

<...>

> +		data->indir_table = (u32 *)rss_config;

Please use correct type from the beginning.

Thanks
