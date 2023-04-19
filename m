Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996E46E8519
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjDSWmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjDSWmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:42:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940EE1FFD
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 15:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E0163948
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4AAC433D2;
        Wed, 19 Apr 2023 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681944084;
        bh=VNAeJKSf0WB9Zmr5h597RkOUy+pDR7sKGbWSWM6pE0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRW9egPiCKCTpLAVj8dLsTLoBWYN8+cDzvHn2C3crqlKpIYwXoBVbPU+4g1hGg6Dc
         yWOtpBg/CzgMYgjBeXMk3W3eG/iX3FbsjO4gg/mdokP4N0aoyGv1Jr2Gl2a6dvF9ex
         M4WrRRh3/J144N9whzFCmRXX3oFadknNpZ0M/ck67iiSxFcp773v7/7ioV9H+GRR+T
         qgd/pNP0RPF0eCtsWZR2sAV6o2mElrdfRJ7zbk7sExvNoOv8+8XbANBWAOhqoSa+ZN
         jLJAVBOKaX8hl7QtNgu/w5p4UlZqAJDE8QCewmn9jJhFCWhPWcOqg/T02G4KGs0Zsc
         +hnGQ20xageIg==
Date:   Wed, 19 Apr 2023 15:41:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>, davem@davemloft.net,
        edumazet@google.com, tglx@linutronix.de, wangyang.guo@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dst: fix missing initialization of
 rt_uncached
Message-ID: <20230419154123.298941e2@kernel.org>
In-Reply-To: <20230419085802.GD44666@unreal>
References: <20230418165426.1869051-1-mbizon@freebox.fr>
        <20230419085802.GD44666@unreal>
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

On Wed, 19 Apr 2023 11:58:02 +0300 Leon Romanovsky wrote:
> It should go to net. Right now -rc7 is broken.

That's not true, right? The bad commit is in net-next only.
