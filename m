Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B0521754
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiEJNYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiEJNWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:22:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0AA131F22;
        Tue, 10 May 2022 06:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 31EBDCE1E73;
        Tue, 10 May 2022 13:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C273C385C6;
        Tue, 10 May 2022 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652188580;
        bh=AF8f0jb7qkvLFv99Dq0cae5Ierj3mwBV4xeYFX7j/to=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1WQ767a4CyRETpSiw7+hPRRaT0NORCeJudNoGE6O2gPuRKS9GgVvE1zui9xfyJuv
         9mMkDiYaVJIITpyX5JLIcJC8ayXgpiec0WQWro6/xzfPMp9W4KvssPB09HsED2/fYH
         /8utkb75YnAk/KSdPQOuCPAevrry3SiwZAI94+oOLU7IKHc9xeiea7Ow8j2tp3GFP1
         C1ydSwJ2okBL32ULrerNuPUNHPW1naXnb7jRz7L45w1py6C5DDyloT1eE3UrDkokFA
         lzR9w8jYhXdVJ6PEyO8ld9UL+TPEFma5sPTa7U1fzsKUtT84irEw4UuUolLf82+GII
         hEg6yvFkZk0xg==
Date:   Tue, 10 May 2022 16:16:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com
Cc:     jgg@nvidia.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH V2 mlx5-next 0/4] Improve mlx5 live migration driver
Message-ID: <YnploMZRI9jXMXAi@unreal>
References: <20220510090206.90374-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510090206.90374-1-yishaih@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:02:02PM +0300, Yishai Hadas wrote:
> This series improves mlx5 live migration driver in few aspects as of
> below.
> 
> Refactor to enable running migration commands in parallel over the PF
> command interface.
> 
> To achieve that we exposed from mlx5_core an API to let the VF be
> notified before that the PF command interface goes down/up. (e.g. PF
> reload upon health recovery).
> 
> Once having the above functionality in place mlx5 vfio doesn't need any
> more to obtain the global PF lock upon using the command interface but
> can rely on the above mechanism to be in sync with the PF.
> 
> This can enable parallel VFs migration over the PF command interface
> from kernel driver point of view.
> 
> In addition,
> Moved to use the PF async command mode for the SAVE state command.
> This enables returning earlier to user space upon issuing successfully
> the command and improve latency by let things run in parallel.
> 
> Alex, as this series touches mlx5_core we may need to send this in a
> pull request format to VFIO to avoid conflicts before acceptance.

The PR was sent.
https://lore.kernel.org/netdev/20220510131236.1039430-1-leon@kernel.org/T/#u

Thanks
