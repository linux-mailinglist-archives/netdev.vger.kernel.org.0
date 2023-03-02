Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C736A7A7C
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 05:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjCBE3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 23:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBE3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 23:29:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8531350A
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 20:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15866147B
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 04:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFBFC433EF;
        Thu,  2 Mar 2023 04:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677731359;
        bh=n/5dqKcbbelpxhBrgskYlat25V8ox4xx/d4tNu9C6gE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A4EU+ObIzFhwoid9ORGIlC/Etqeu/XBGdIWAtPiVLpy1zsPiN+yW3kXeYq5cxErHy
         j2PCaVNvweZV8ls5TdDBFh1T++g+qWh7UqNtCQlpR77fURIt0cQBUKmic9coKewIE6
         6eXgxz7hX5WUE1zR9kcrbuv64RJg72499FcTxkGY8FC4gbLPMjDitNoChf9DOgPPdP
         bpAb0tlEqWisvusq5HM9xLfYN/8GrQ6VR1ILKEk7IpZN9ykZpwiapGtgolYRlpEsLt
         B4tQhdwCWht3w/C9vurMPO0hIUY9aHUg2hRCCN+ZV/y2akqoXnClM5UzQXBSop+liw
         dnw84PeIXJWmA==
Date:   Wed, 1 Mar 2023 20:29:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rongguang Wei <clementwei90@163.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        xiaolinkui@kylinos.cn, netdev@vger.kernel.org,
        Rongguang Wei <weirongguang@kylinos.cn>
Subject: Re: [PATCH v1] net: stmmac: add to set device wake up flag when
 stmmac init phy
Message-ID: <20230301202917.5960b5e3@kernel.org>
In-Reply-To: <20230301074756.35156-1-clementwei90@163.com>
References: <20230301074756.35156-1-clementwei90@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Mar 2023 15:47:56 +0800 Rongguang Wei wrote:
> From: Rongguang Wei <weirongguang@kylinos.cn>
> 
> When MAC is not support PMT, driver will check PHY's WoL capability
> and set device wakeup capability in stmmac_init_phy(). We can enable
> the WoL through ethtool, the driver would enable the device wake up
> flag. Now the device_may_wakeup() return true.
> 
> But if there is a way which enable the PHY's WoL capability derectly,
> like in BIOS. The driver would not know the enable thing and would not
> set the device wake up flag. The phy_suspend may failed like this:
> 
> [   32.409063] PM: dpm_run_callback(): mdio_bus_phy_suspend+0x0/0x50 returns -16
> [   32.409065] PM: Device stmmac-1:00 failed to suspend: error -16
> [   32.409067] PM: Some devices failed to suspend, or early wake event detected
> 
> Add to set the device wakeup enable flag according to the get_wol
> function result in PHY can fix the error in this scene.

Please add an appropriate Fixes tag and repost if you consider this
a bug fix, or repost next week with [PATCH net-next] for inclusion 
in Linux 6.3 if you're okay with the patch being treated as enabling 
the feature on more platforms (i.e. not a fix).
