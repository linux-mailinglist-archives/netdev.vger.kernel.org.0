Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F1067E5C1
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbjA0MuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbjA0MuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED08E17CF1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 04:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D99EB820FD
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21D6EC433EF;
        Fri, 27 Jan 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674823819;
        bh=Q9B/Mt2qJzV5xWmNYsCp1uGdb9wTNmmCE0qQY6OSa+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJs36ptL01J2jjJOiFWPj0LvEaJNmD9e8cVLlo2mZOIKE+QnBqgIJJ8nhNy7Q68MP
         XnkP8ADjmrTy1S3U7qgq6iXBHJEEwDv0Q8GhjS5IU/gvtXEVdZ8mKrgxEPhKuzOSrl
         nb3gQ14r0tE1qox0qHAQG8L3/EdfIzR/rvKAqsWYn+4jJbARXH+L/RXhmyG+VIe7mx
         ma6RJDS3aJM13UnjZSjzYJPLxf1zQXZvpnvkTSHBc2CcOjjR0svtgU7krBP/JmiVGy
         kDkD8OC6pvysZJT62D9LZ64fxP87rs4NBfsmdIGBbcO3PQVwD+Otc2gr97cn6sn09P
         +O28iiAIHZsRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05004F83ECD;
        Fri, 27 Jan 2023 12:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2 00/12] devlink: Cleanup params usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167482381901.15666.2800630597243633345.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 12:50:19 +0000
References: <20230126075838.1643665-1-jiri@resnulli.us>
In-Reply-To: <20230126075838.1643665-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 26 Jan 2023 08:58:26 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset takes care of small cleanup of devlink params usage.
> Some of the patches (first 2/3) are cosmetic, but I would like to
> point couple of interesting ones:
> 
> Patch 9 is the main one of this set and introduces devlink instance
> locking for params, similar to other devlink objects. That allows params
> to be registered/unregistered when devlink instance is registered.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/12] net/mlx5: Change devlink param register/unregister function names
    https://git.kernel.org/netdev/net-next/c/c8aebff4599f
  - [net-next,v2,02/12] net/mlx5: Covert devlink params registration to use devlink_params_register/unregister()
    https://git.kernel.org/netdev/net-next/c/a756185ac3b9
  - [net-next,v2,03/12] devlink: make devlink_param_register/unregister static
    https://git.kernel.org/netdev/net-next/c/020dd127a3fe
  - [net-next,v2,04/12] devlink: don't work with possible NULL pointer in devlink_param_unregister()
    https://git.kernel.org/netdev/net-next/c/bb9bb6bfd1c3
  - [net-next,v2,05/12] ice: remove pointless calls to devlink_param_driverinit_value_set()
    https://git.kernel.org/netdev/net-next/c/2fc631b5d75d
  - [net-next,v2,06/12] qed: remove pointless call to devlink_param_driverinit_value_set()
    https://git.kernel.org/netdev/net-next/c/6fd6eda0e65d
  - [net-next,v2,07/12] devlink: make devlink_param_driverinit_value_set() return void
    https://git.kernel.org/netdev/net-next/c/85fe0b324c83
  - [net-next,v2,08/12] devlink: put couple of WARN_ONs in devlink_param_driverinit_value_get()
    https://git.kernel.org/netdev/net-next/c/3f716a620e13
  - [net-next,v2,09/12] devlink: protect devlink param list by instance lock
    https://git.kernel.org/netdev/net-next/c/075935f0ae0f
  - [net-next,v2,10/12] net/mlx5: Move fw reset devlink param to fw reset code
    https://git.kernel.org/netdev/net-next/c/c2077fbc42ae
  - [net-next,v2,11/12] net/mlx5: Move flow steering devlink param to flow steering code
    https://git.kernel.org/netdev/net-next/c/db492c1e5b1b
  - [net-next,v2,12/12] net/mlx5: Move eswitch port metadata devlink param to flow eswitch code
    https://git.kernel.org/netdev/net-next/c/d2a651ef18c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


