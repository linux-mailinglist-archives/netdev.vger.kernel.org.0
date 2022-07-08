Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB03056AFA5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiGHAxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGHAxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7106D70E47;
        Thu,  7 Jul 2022 17:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A7B60AF9;
        Fri,  8 Jul 2022 00:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181E0C3411E;
        Fri,  8 Jul 2022 00:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657241596;
        bh=TDiLu1rwvodJqPnwKWHyS0Wn+8q/Byec3xL72R5c0zw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aDOAjVDOPWxre5eCVFbyyvEtIOkIZ6cSftEAxCZIw9yYVDNicaq5/THlBg13JxIw9
         fPkN1ao0vaUR+FDEjAmkw01KpUijFK9TSzseg3s7l+ZE4+0xjvVgxLFoxMWPPVdef7
         ShZTn8fIjcIbH+ostm4flSc1rHrxwJbkyj9La3VkNjZIlNQowOn4Z28D39cnhlGMLP
         Aa7SEHQqj9e2mMKBeIyvWEdVKEqQ8iNogMORPxNoygCc/V8z+fWj8D2FgrdMErtJfT
         9sfC2o4bUYO32NksPZdw+B9pFyHyHHo62BOg9/AQQcT4pJzj1KSLIodYlfYOmZjnct
         eqxgGiZcHUjYQ==
Date:   Thu, 7 Jul 2022 17:53:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [net-next PATCH V3 02/12] octeontx2-af: Exact match support
Message-ID: <20220707175307.4e83ad48@kernel.org>
In-Reply-To: <20220707073353.2752279-3-rkannoth@marvell.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
        <20220707073353.2752279-3-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 13:03:43 +0530 Ratheesh Kannoth wrote:
> CN10KB silicon has support for exact match table. This table
> can be used to match maimum 64 bit value of KPU parsed output.
> Hit/non hit in exact match table can be used as a KEX key to
> NPC mcam.
> 
> This patch makes use of Exact match table to increase number of
> DMAC filters supported. NPC  mcam is no more need for each of these
> DMAC entries as will be populated in Exact match table.
> 
> This patch implements following
> 
> 1. Initialization of exact match table only for CN10KB.
> 2. Add/del/update interface function for exact match table.
> 
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>

Build with C=1 (i.e. with the sparse checker) we get:

drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:558:21: warning: dubious: x & !y

could you figure out which one it is and if it can be muted?
