Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE946B96BC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjCNNry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCNNrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:47:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179952F798
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2099261791
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A403CC433D2;
        Tue, 14 Mar 2023 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678801442;
        bh=qFODynco2GHDmXkEdNU9cQZUekw6s62rB8CZDKA+AV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZfia5qnZlj+hO0Yii/coTs/MgKgC/OIPK6ILhadoFxcBfj6wE+J0OoFEpUGLKG6n
         BnQ7evIULf7K2v9I5AOWqVhB/UMG7RV0FJkAirSR7mAy5F97LIQY6d1CgOdodc7G8D
         E9lmb1kuu9FAFaqPfQu+a30Sp2jTWwjUBOg9qaoVgafqTVSqy6ukN6UgKKv51ETS5x
         tU8JJLOTmHnfun+uWU+JDcmhuv1s05bDsV+yqM+kUfj7qNLoYTiUzFuSBDpS6jE77A
         DQJ5P8Ep/aLEBmZ709nk5cDJipZ0RLqEpT4OK0ul2geCknV1BotLF39J0dTwlYZCmx
         Bi7TdCrgQocog==
Date:   Tue, 14 Mar 2023 15:43:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net-next 03/14] ice: track malicious VFs in new
 ice_mbx_vf_info structure
Message-ID: <20230314134357.GH36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:12AM -0700, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Currently the PF tracks malicious VFs in a malvfs bitmap which is used by
> the ice_mbx_clear_malvf and ice_mbx_report_malvf functions. This bitmap is
> used to ensure that we only report a VF as malicious once rather than
> continuously spamming the event log.

I would say that idea that VF is allowed to spam PF is very questionable.
Even with overflow logic.

Thanks
