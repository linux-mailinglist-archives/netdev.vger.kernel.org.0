Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5405179BA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiEBWKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387818AbiEBWHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 18:07:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE8EB18
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 15:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C802B81A50
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 22:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E23C385A4;
        Mon,  2 May 2022 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651528987;
        bh=N0fFh3oKbqHtkDFjmMdksNNizB+j3t2Ua9aLr9H74Ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UEfXkzKQH46X3FvA9NLmqTwspA9H+nFI99yjpIIV3pm/6p3tweKgOn4eP9SdDznKq
         J1xWduNGuC5KVjhMz34OQa/pC5Njj7wyckUTl6YxTTD4z44tw3IyPT2UK+/9zm3/Mf
         O1awUqXfK2uTN00QkLSctLu+GVxDt35NhrG2sUPFONviO9IDuT18HCacbn2ThlgRzq
         gKpJ8W0xMEjbMGyQjPkLpyHtrQM7FxAEKOksOspeIMMB6XStzu72eyiJHYQI4l6rv6
         Un6JvgxaazIOjG05syn1bTxG8CeAZUOyZ1wvl5Y8Gg9/xxpp+f2FcwR/+5cvzD/K9d
         1DmClP1ldM/Ig==
Date:   Mon, 2 May 2022 15:03:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nate Drude <nate.d@variscite.com>
Cc:     netdev@vger.kernel.org, michael.hennerich@analog.com,
        eran.m@variscite.com
Subject: Re: [PATCH 2/2] net: phy: adin: add adi,clk_rcvr_125_en property
Message-ID: <20220502150305.6f71f0d4@kernel.org>
In-Reply-To: <20220429184432.962738-2-nate.d@variscite.com>
References: <20220429184432.962738-1-nate.d@variscite.com>
        <20220429184432.962738-2-nate.d@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 13:44:32 -0500 Nate Drude wrote:
> +	if (of_property_read_bool(of_node, "adi,clk_rcvr_125_en")) {
> +		reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG);
> +
> +		reg |= ADIN1300_GE_CLK_RCVR_125_EN;
> +
> +		phydev_dbg(phydev, "%s: ADIN1300_GE_CLK_CFG = %x\n",
> +		           __func__, reg);
> +
> +		reg = phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			     ADIN1300_GE_CLK_CFG, reg);

Looks like you could use phy_modify_mmd() instead.

The print could be removed IMHO, it adds little value. All it does is
says the register write was performed, not even old an new values.

Please CC the folks and list pointed out by Paolo and Josua from the
thread pointed out by Andrew.

Please tag v2 as [PATCH net-next v2] in the subject.

Thanks!
