Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3A595338
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiHPHBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiHPHAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:00:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF5418C2FD
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 19:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65ECA60F9F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E0EC433C1;
        Tue, 16 Aug 2022 02:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660618592;
        bh=5UrRngxHnfkv4OKvR9HnijavlIM8qwYFDtEC2pj33CU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZNFJ/dC/H1VBMux4AmmcmgTS9Y1FJTwsjzDuO94WRfvWtFXP571HomiM4waa0gICk
         K8QRK35wvGUoiJf3oJUuLJvntczlvkr7BsO21O0x9jz5v++SvDP11HjvDaVhX7sGRt
         P9pNbXso+Yz4WqFyGVZncvlN0dw8CrfE/yy0vAxi8XIS4KsR6gelWA6DYPqtKrKsxv
         JIqRXhtrA6UZUp3o8kzgm/FLqGPRM3kY2Kk7cZkXCVU8d+YObhDN/luD4KmK5pWvcv
         NT+mulTssK1JKwfVCEsh563vRKLCUJw+tTUpgcmUYyjgJ4ESgfLLQcQEtiNXANJZnl
         2k4YRARUshCtw==
Date:   Mon, 15 Aug 2022 19:56:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH v2] net: moxa: pass pdev instead of ndev to DMA
 functions
Message-ID: <20220815195631.1ca64b3d@kernel.org>
In-Reply-To: <20220812171339.2271788-1-saproj@gmail.com>
References: <20220812171339.2271788-1-saproj@gmail.com>
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

On Fri, 12 Aug 2022 20:13:39 +0300 Sergei Antonov wrote:
> dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
> moxart_mac_start_xmit() which leads to an incessant output of this:
> 
> [   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
> [   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error
> 
> Passing pdev to DMA is a common approach among net drivers.

Thanks! I slapped 

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")

on it when applying, please make sure to provide Fixes tags in
the future (and CC authors so they can review).
