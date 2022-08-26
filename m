Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185D05A1F39
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242390AbiHZDDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236557AbiHZDDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D528EA260F
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52FCD61E66
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D38C433D6;
        Fri, 26 Aug 2022 03:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483025;
        bh=weIXKDVs2cIXMlkBGehk1vafXu74lpYwY1MxRvwWQvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N2gTSZyUkA2YcVSZeiJoQa6ilSuRqhJa2oRyR71WM/NQdwMnClI15gLNT4Min0X2r
         iT/9eMA2w4dvUeul2rJR5fE6bfUzHYQc8adPsvKXTQgK8iSWQmMHeRYCS//ncW5PGj
         ODHEJsdoQHI3eSPZBgZWWUXd/y8qXKNeU+DX5Ul0RS7HFjiFDSjaD1bojh/ubCty3o
         uSncMoP42HFImStiEhEk2vyRFOvTYAk/HKXI3Ec86Ye2xqNFjiE/SL64RqgMQgXYso
         k909zzpDCbPQUDA/6xJ5rb/F2CB0kGUYnF/LbVN0uo1vxnZ9O0o2UnqUV6n8n1rO8R
         iVLJY0iPySnAA==
Date:   Thu, 25 Aug 2022 20:03:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, Lukasz Plachno <lukasz.plachno@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/5] ice: Print human-friendly PHY types
Message-ID: <20220825200344.32cb445f@kernel.org>
In-Reply-To: <20220824170340.207131-6-anthony.l.nguyen@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
        <20220824170340.207131-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 10:03:40 -0700 Tony Nguyen wrote:
> Old:
> [  286.130405] ice 0000:16:00.0: get phy caps - report_mode = 0x2
> [  286.130409] ice 0000:16:00.0:        phy_type_low = 0x108021020502000
> [  286.130412] ice 0000:16:00.0:        phy_type_high = 0x0
> [  286.130415] ice 0000:16:00.0:        caps = 0xc8
> [  286.130419] ice 0000:16:00.0:        low_power_ctrl_an = 0x4
> [  286.130421] ice 0000:16:00.0:        eee_cap = 0x0
> [  286.130424] ice 0000:16:00.0:        eeer_value = 0x0
> [  286.130427] ice 0000:16:00.0:        link_fec_options = 0xdf
> [  286.130430] ice 0000:16:00.0:        module_compliance_enforcement = 0x0
> [  286.130433] ice 0000:16:00.0:    extended_compliance_code = 0xb
> [  286.130435] ice 0000:16:00.0:    module_type[0] = 0x11
> [  286.130438] ice 0000:16:00.0:    module_type[1] = 0x1
> [  286.130441] ice 0000:16:00.0:    module_type[2] = 0x0
> 
> New:
> [ 1128.297347] ice 0000:16:00.0: get phy caps dump
> [ 1128.297351] ice 0000:16:00.0: phy_caps_active: phy_type_low: 0x0108021020502000
> [ 1128.297355] ice 0000:16:00.0: phy_caps_active:   bit(13): 10G_SFI_DA
> [ 1128.297359] ice 0000:16:00.0: phy_caps_active:   bit(20): 25GBASE_CR
> [ 1128.297362] ice 0000:16:00.0: phy_caps_active:   bit(22): 25GBASE_CR1
> [ 1128.297365] ice 0000:16:00.0: phy_caps_active:   bit(29): 25G_AUI_C2C
> [ 1128.297368] ice 0000:16:00.0: phy_caps_active:   bit(36): 50GBASE_CR2
> [ 1128.297371] ice 0000:16:00.0: phy_caps_active:   bit(41): 50G_LAUI2
> [ 1128.297374] ice 0000:16:00.0: phy_caps_active:   bit(51): 100GBASE_CR4
> [ 1128.297377] ice 0000:16:00.0: phy_caps_active:   bit(56): 100G_CAUI4
> [ 1128.297380] ice 0000:16:00.0: phy_caps_active: phy_type_high: 0x0000000000000000
> [ 1128.297383] ice 0000:16:00.0: phy_caps_active: report_mode = 0x4
> [ 1128.297386] ice 0000:16:00.0: phy_caps_active: caps = 0xc8
> [ 1128.297389] ice 0000:16:00.0: phy_caps_active: low_power_ctrl_an = 0x4
> [ 1128.297392] ice 0000:16:00.0: phy_caps_active: eee_cap = 0x0
> [ 1128.297394] ice 0000:16:00.0: phy_caps_active: eeer_value = 0x0
> [ 1128.297397] ice 0000:16:00.0: phy_caps_active: link_fec_options = 0xdf
> [ 1128.297400] ice 0000:16:00.0: phy_caps_active: module_compliance_enforcement = 0x0
> [ 1128.297402] ice 0000:16:00.0: phy_caps_active: extended_compliance_code = 0xb
> [ 1128.297405] ice 0000:16:00.0: phy_caps_active: module_type[0] = 0x11
> [ 1128.297408] ice 0000:16:00.0: phy_caps_active: module_type[1] = 0x1
> [ 1128.297411] ice 0000:16:00.0: phy_caps_active: module_type[2] = 0x0

Is this not something that can be read via ethtool -m ?
