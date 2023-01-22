Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410DC676CE3
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 13:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAVMb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 07:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjAVMb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 07:31:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623521115E
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 04:31:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F15CF60BFE
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 12:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDBEC433D2;
        Sun, 22 Jan 2023 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674390716;
        bh=lqttgCDSL2X9s0d4tv01ltdlcBeicdi4NPNZljnfFRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TxNMD3u83+LdiXa1IGSL27MFomkdRoDzMwKyzio7I4D5SDKYyVBUdKYOmVbMudYKS
         2H/XCcfy2MbeRnbTLg3Z6dvtY5aaT9BasJpbWfIo3tSLt6SDwMsUhjubD1zMlFPFn6
         N07f1+Rd6X4NX7+3OjLNiCNuoGsMH2evf5xWzeBNPc1D9if5a/E6FT3yyIwG1UIty4
         0vhnFb8oQgmnWXlvIHv3lJdQKweP/WYJKf8mHA5dWAJ+aatwHlUR5H5eqIfTGkEKLT
         NVHdhIdKidBuQiSN/FFRuN08MlLkOqx7hJ2GohbqXFkrTJNqykNZHv3FqO6rxyw8Bd
         wNbLxRJ4TiN7g==
Date:   Sun, 22 Jan 2023 14:31:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-01-20 (iavf)
Message-ID: <Y80st+qScpsNL2SN@unreal>
References: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 01:10:33PM -0800, Tony Nguyen wrote:
> This series contains updates to iavf driver only.
> 
> Michal Schmidt converts single iavf workqueue to per adapter to avoid
> deadlock issues.
> 
> Marcin moves setting of VLAN related netdev features to watchdog task to
> avoid RTNL deadlock.
> 
> Stefan Assmann schedules immediate watchdog task execution on changing
> primary MAC to avoid excessive delay.
> 
> The following are changes since commit 45a919bbb21c642e0c34dac483d1e003560159dc:
>   Revert "Merge branch 'octeontx2-af-CPT'"
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> Marcin Szycik (1):
>   iavf: Move netdev_update_features() into watchdog task
> 
> Michal Schmidt (1):
>   iavf: fix temporary deadlock and failure to set MAC address
> 
> Stefan Assmann (1):
>   iavf: schedule watchdog immediately when changing primary MAC
> 
>  drivers/net/ethernet/intel/iavf/iavf.h        |   2 +-
>  .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c   | 113 ++++++++----------
>  .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  10 +-
>  4 files changed, 66 insertions(+), 69 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
