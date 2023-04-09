Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354846DBF76
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDIKeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDIKeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5002944B7
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDDDC60D3A
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF634C433EF;
        Sun,  9 Apr 2023 10:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036441;
        bh=2jtZu1Edncu6aACQD010tyMWQ63PHORjITCIJrYVIV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZENUTnZVkMu7J9cnR3T+PZDP462PHtxWhPWOzt8qqwXELbKTcp/CyLtMNE9uPC1T9
         Xku70rdE5obYB3N+apgMhEKcRgZIG1SDDuXBHa6nCYU4V4GcyQPrGGNnIbWhqT/LIU
         1+cnC22Jwh8FZJlFFAmHZqGTCBAniJXLwmUYwDVSFzidOL0WaJYtQd2A+k5oX1th4G
         owErGraD31wjivLYTkOzmTqUJnagWV/UUPuesG7AEo7s2F+xGaFcBt8VeBbvP8ooP7
         5G01PkPzynGNZz+y8IeH4AWgay5oIrNBE74uKKvrqeoQkwiL3n/c6gaOrkjaPcN9mJ
         S7qwj/HtoahiA==
Date:   Sun, 9 Apr 2023 13:33:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 4/5] ice: allow matching on meta data
Message-ID: <20230409103357.GL14869@unreal>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-5-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-5-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:18PM +0200, Michal Swiatkowski wrote:
> Add meta data matching criteria in the same place as protocol matching
> criteria. There is no need to add meta data as special words after
> parsing all lookups. Trade meta data in the same why as other lookups.
> 
> The one difference between meta data lookups and protocol lookups is
> that meta data doesn't impact how the packets looks like. Because of that
> ignore it when filling testing packet.
> 
> Match on tunnel type meta data always if tunnel type is different than
> TNL_LAST.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../ethernet/intel/ice/ice_protocol_type.h    |   8 +
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 158 +++++++-----------
>  drivers/net/ethernet/intel/ice/ice_switch.h   |   4 +
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  29 +++-
>  drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   1 +
>  5 files changed, 95 insertions(+), 105 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
