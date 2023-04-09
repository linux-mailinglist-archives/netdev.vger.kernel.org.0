Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C2A6DBF7D
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDIKk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDIKk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC68C3594
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D1B60B24
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D17C433D2;
        Sun,  9 Apr 2023 10:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036850;
        bh=i+CfACV444wnveH+XkdNRMwBK4Yqr89KjI7V+Qz+elY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCo0UQ/DsgzFZRO8IzteHIMcExFrECh/AMRpLazTemoLCwepwzmOf291BE64sLJZH
         125RCaufld05B/N4UYxgbdy/P5Ue7ucGPo8TxRZIG7CQ8P9+OqdJrJqRDeKQWX98zE
         D47rvkoIlCzOwJotopR0O1kiWV2IareOE7AjqSTJtmsnv6ANwviMxHELHb6Xwj56TO
         PUd9mlhSykeAj5rgSUB6vB6stD2Rllr+WtafImP6t4nbH91Jwm90zqS6/EJhpgxoOF
         15V+/yVi+dRZbbr7go09OdGXqy8BowtptWsuSxNnbdbKHiBCAzpMrTNO8JskQW2u9W
         2jZ4JABab6OHw==
Date:   Sun, 9 Apr 2023 13:40:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net v2 1/2] iavf: refactor VLAN filter states
Message-ID: <20230409104046.GO14869@unreal>
References: <20230407210730.3046149-1-anthony.l.nguyen@intel.com>
 <20230407210730.3046149-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407210730.3046149-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:07:29PM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> The VLAN filter states are currently being saved as individual bits.
> This is error prone as multiple bits might be mistakenly set.
> 
> Fix by replacing the bits with a single state enum. Also, add an
> "ACTIVE" state for filters that are accepted by the PF.
> 
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h        | 15 +++++----
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++---
>  .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 31 +++++++++----------
>  3 files changed, 28 insertions(+), 26 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
