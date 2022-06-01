Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B983A539BCC
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbiFADuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiFADuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F6D5FD6
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B40E2B81768
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D2DC385B8;
        Wed,  1 Jun 2022 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654055412;
        bh=hFM7UfiSrad7nKJ6d6CNHGBDDgXT7uxEepqTa0NzhjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oqI5aiEOCUUsMdXAw2RNvp5W8zInl/zm/EXyAT2F9k/iRUtkdg5RUgtei6Dsa2p4W
         fPD/Fvha4DUhYlZa2YvhVHKafTS+QuHihG01SE3NTPZrnCofXTxA8HHtVLGbF9cbgq
         TJm7CNTKMU328N9z3uVlruK0THoMyC3KryZnadbrCci6LYea8AEwrMpcK+dviQIv7n
         W8OS3PCDADHriyDJYkZo4moHDBdZS/1xNgJC5oB6XOHs6TpuXV7gcBnJBTQIMkeIzb
         docp6KJT//LhjNk+TnlUhDE+zDgosOJ9QASY7dz2GsEpHg5VDn1u7MSLNLx/9QWw4m
         34Nfhb/Ye4eMA==
Date:   Tue, 31 May 2022 20:50:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Tham, Mun Yew" <mun.yew.tham@intel.com>
Cc:     Joyce Ooi <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: eth: altera: set rx and tx ring size before
 init_dma call
Message-ID: <20220531205011.4e17bc11@kernel.org>
In-Reply-To: <20220531025117.13822-1-mun.yew.tham@intel.com>
References: <20220531025117.13822-1-mun.yew.tham@intel.com>
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

On Tue, 31 May 2022 10:51:17 +0800 Tham, Mun Yew wrote:
> It is more appropriate to set the rx and tx ring size before calling
> the init function for the dma.

Improve the commit message please, this tells us nothing.
It's hardly a well know software design best practice to set some
random thing before calling another random thing.
AFAICT neither dma implementation upstream cares about
priv->[tr]x_ring_size, do they?

If you're doing this to prepare for adding another DMA engine,
please post this patch together with the support being added.
