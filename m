Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111D5641C96
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 12:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLDLVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 06:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiLDLVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 06:21:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E0A140A2;
        Sun,  4 Dec 2022 03:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B01360DF9;
        Sun,  4 Dec 2022 11:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07299C433C1;
        Sun,  4 Dec 2022 11:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670152860;
        bh=qJqhP6XK8dsdvrn2PwKJvrIom0XMMHhvRQlCW31oCgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MH2NmrX8pdmpi7sHzYOwh8Wp9CxfSLhxSOwN7MJH0GrTdLS6h6vZQs7AMvyt6DtYr
         QQmA1TLoCbXKnHsiAxIj0FznfmCysD8jSHOUfMcORcycanAk4xdQ55zKftddux764x
         fG196F6gte5huO5q4HvoyuL5zh5j3yJ2syhDVRz6DMIdANN5z5MAjOktu0q4yay5jp
         ENAbuxwdMPQxS0c3BdaL5VAVmrQhJEmdm2H9sSZokRIMF6OXeODX1bc4N8Ew9bzgtQ
         qL51RBBHN8KyAjaEtCpIN1tFQUJA+XtytQoDq1r+3PDhKXu26lERruFV5EcqfehQ+S
         fHOBvC9L753OA==
Date:   Sun, 4 Dec 2022 13:20:49 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net v4] igbvf: Regard vf reset nack as success
Message-ID: <Y4yCkQh6F/qtsAct@unreal>
References: <20221201102003.67861-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201102003.67861-1-akihiko.odaki@daynix.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:20:03PM +0900, Akihiko Odaki wrote:
> vf reset nack actually represents the reset operation itself is
> performed but no address is assigned. Therefore, e1000_reset_hw_vf
> should fill the "perm_addr" with the zero address and return success on
> such an occasion. This prevents its callers in netdev.c from saying PF
> still resetting, and instead allows them to correctly report that no
> address is assigned.
> 
> Fixes: 6ddbc4cf1f4d ("igb: Indicate failure on vf reset for empty mac address")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> V3 -> V4: Removed blank lines between cases
> V2 -> V3: Added Fixes: tag
> 
>  drivers/net/ethernet/intel/igbvf/vf.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
