Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FAC5F3A55
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJDAF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJDAFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:05:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5D1220FA
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8FE5B8172A
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54110C433C1;
        Tue,  4 Oct 2022 00:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841947;
        bh=H+3cTgDceGMHQfls6A/ueExISh/VjcgyUYxeLtQs8FA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FagFpS3SQv1P3XiWbxGL3ZzgbYah+Suw3oBTQfjy3IoB6JkV2YLmdayAnptKJF3/4
         15H7bmPkIZA/QePRwQQZYfHE/RKmd/hZO1dauroQ9AgMkY07bjaUstrvwkLD2d3GfE
         y4yCb8Pxm3h9XbKzlqzscG3wlS6UzeBH0JdGf3hwD5EgugCdjQtpTQowHxqVxI4ve3
         dWy9vP6IyVRjXdfvPWhf2buF0pQxNQ/ZprkaVX3eh5Yezt3eD4TbI24y3qJAdR3FPn
         Mmzf+KL/5twmUn2v7DRVhQN0BMLP9bz9fZ7wDjOzVSyGoFgo0j9Y0tRG8q5rHb3eSA
         oewF/AKUJH7Hw==
Date:   Mon, 3 Oct 2022 17:05:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chunhao Lin <hau@realtek.com>
Cc:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>, <grundler@chromium.org>
Subject: Re: [PATCH net-next] r8169: fix rtl8125b dmar pte write access not
 set error
Message-ID: <20221003170546.1b9ca44f@kernel.org>
In-Reply-To: <20221003064620.28194-1-hau@realtek.com>
References: <20221003064620.28194-1-hau@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Oct 2022 14:46:20 +0800 Chunhao Lin wrote:
> When close device, rx will be enabled if wol is enabeld. When open device
> it will cause rx to dma to wrong address after pci_set_master().
> 
> In this patch, driver will disable tx/rx when close device. If wol is
> eanbled only enable rx filter and disable rxdv_gate to let hardware can
> receive packet to fifo but not to dma it.

Sounds like a fix, could you resend with a Fixes tag and [PATCH net]
designation? net-next is for new features and refactoring, net for
fixes.
