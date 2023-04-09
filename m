Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CB76DBF72
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDIKds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIKdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:33:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA26744B8
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:33:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 743AE60B9B
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C39C433D2;
        Sun,  9 Apr 2023 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036424;
        bh=xm+3DjVWD9JGNIP9xZXESfsK9loFeRstBnM8TUlsOEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nrlPwHRqf1DTXQSlwxJWJM+v0gQ78850OXM8kHfm7aA8e+7Wc2SCWa9PyJfs8dANc
         fljDuFRxDA9X1kVbTjkBxQs9c26Fc0tCux88p4Wv8CbWOgJvVPxOAun/8VoFuBEs76
         TpP/iHO91p1Dq20wV7/uJgI6ElS/mpup28dcXQM0xZ5j4fF+J6BkpnmT7yrQ2mDoet
         C8WOAWBKJTrPeHBE49qeUA6YI4t57RWk7i08ICTv/ZUg9m9g9WHdrYBFklWVLqob0z
         T05PgzyJVHYRR4prgS2ptBSkXs5YYxMx3v9Ic9xq4SP99UknAF9UvubcGf/a784Olz
         wrmp6WS6B9LAg==
Date:   Sun, 9 Apr 2023 13:33:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 1/5] ice: define meta data to match in switch
Message-ID: <20230409103340.GJ14869@unreal>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-2-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-2-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:15PM +0200, Michal Swiatkowski wrote:
> Add description for each meta data. Redefine tunnel mask to match only
> tunneled MAC and tunneled VLAN. It shouldn't try to match other flags
> (previously it was 0xff, it is redundant).
> 
> VLAN mask was 0xd000, change it to 0xf000. 4 last bits are flags
> depending on the same field in packets (VLAN tag). Because of that,
> It isn't harmful to match also on ITAG.
> 
> Group all MDID and MDID offsets into enums to keep things organized.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../ethernet/intel/ice/ice_protocol_type.h    | 186 +++++++++++++++++-
>  drivers/net/ethernet/intel/ice/ice_switch.c   |  11 +-
>  .../net/ethernet/intel/ice/ice_vlan_mode.c    |   2 +-
>  3 files changed, 183 insertions(+), 16 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
