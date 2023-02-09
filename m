Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24A5690007
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBIFuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 00:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBIFuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 00:50:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1742384D
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4539061912
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D7DC4339B;
        Thu,  9 Feb 2023 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675921808;
        bh=2EYHf755LTvdnPbW5x3Dxf0qyucyHbbys+MJzrrPuFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gNvar6pplG5qqesOFrIT4hTDNCPjesE/+ZI/EOdQeRw+5HOpkGlOjjyiUWLWcJxhG
         vFmIPjvYYDONml7TUSfuzFkYaeKm7I2carSK8tcPtM7f2PvRzoGZaAFw4uTPjXeZkD
         fAELQ5nCrgD/lTseubP39iYsSr9Z137XnuhmfGD+4UMKiqNX+FEU+VshSXm1hD8XmZ
         iTHoVgZTjFt+hS4y22CFK6Ac5mYoeu1J5jtgsMgYWHsqqCJmmvqzaCFqaD8Z7HPUa5
         J4x5jcXi/dyLDnT2JeMldt2n2Cu4klciAfC5JXxvBcTn8c0ECdGngXhkDUhF4pDyfP
         0awnFtQ2OZxVw==
Date:   Wed, 8 Feb 2023 21:50:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <drivers@pensando.io>
Subject: Re: [PATCH v3 net-next 3/3] ionic: add support for device Component
 Memory Buffers
Message-ID: <20230208215007.1c821ef3@kernel.org>
In-Reply-To: <20230207234006.29643-4-shannon.nelson@amd.com>
References: <20230207234006.29643-1-shannon.nelson@amd.com>
        <20230207234006.29643-4-shannon.nelson@amd.com>
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

On Tue, 7 Feb 2023 15:40:06 -0800 Shannon Nelson wrote:
> The ionic device has on-board memory (CMB) that can be used
> for descriptors as a way to speed descriptor access for faster
> traffic processing.  It is best used to improve latency and
> packets-per-second for some profiles of small packet traffic.
> It is not on by default, but can be enabled through the ethtool
> priv-flags when the interface is down.

Oh, completely missed this when looking at previous version.
This is ETHTOOL_A_RINGS_TX_PUSH right?

Could you take a look at what hns3 does to confirm?
