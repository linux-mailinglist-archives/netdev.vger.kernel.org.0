Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230B55136DF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348363AbiD1ObX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343852AbiD1ObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:31:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A293583A5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E37BB82C16
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A7C385A0;
        Thu, 28 Apr 2022 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651156084;
        bh=g2rCw4e07sG2e3kgZCak+tnpdC3zVgAX/4FSDKcQjOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uRP0x5j9C2UqLFaC9ToFFsD+gC/Foldm47tWEY26N/7GIi//7JbPYYzKupkTYeLIJ
         yPmKDkJg7Lo5vSFVWY+8egVx4F0kgKLZoAxDUcwV6dejrKFzdbwMrr1663HNz40Cg4
         N4H9Cd4ZjZsCAfE/E9c8wMC0kk1x5HkXyOCb2o7bpQ/fEx/XJBvxoqrLOybZE7fxJq
         vcjA5B1Qaa3jgKkhLzJTsqMtJX05TUPFNQoASCo9tEL+PtvsdrzXd7ktpZaqijLeOp
         k9lqmgOBsCda3SAZdTC8RzQPdKcMq7YmQzXJBiWutlwYS2gQDG+UEvBtkVxtuh1WuZ
         BnDRHxsJmzQQg==
Date:   Thu, 28 Apr 2022 07:28:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Message-ID: <20220428072803.76490cbd@kernel.org>
In-Reply-To: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 18:05:36 +0300 Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Without this delay PHY mode switch from XLG to SGMII fails in a weird
> way. Rx side works. However, Tx appears to work as far as the MAC is
> concerned, but packets don't show up on the wire.
> 
> Tested with Marvell 10G 88X3310 PHY.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
> 
> Not sure this is the right fix. Let me know if you have any better
> suggestion for me to test.
> 
> The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.

Let me mark it as RFC in patchwork, then. If the discussion concludes
with an approval please repost as [PATCH net] and preferably with a
Fixes tag; failing that a stable tag, since you indicate 5.10 needs it.
