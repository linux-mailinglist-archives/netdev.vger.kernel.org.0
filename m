Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9456AFB4
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiGHAyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbiGHAyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3926A71BC5;
        Thu,  7 Jul 2022 17:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB28EB80315;
        Fri,  8 Jul 2022 00:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5897DC3411E;
        Fri,  8 Jul 2022 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657241677;
        bh=0ikl6M9LpLlUr62WdpqX+N48a9lRsyWn0/7qj/fKUe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QqfFuuuK8MkseChkRSGcyxXrP8H7Ozn+rzIZ2963niTJ6yHyJmjtFBuM0pavQ+STd
         LCIW/IYvn57LeE8TEB5UqDbYSVa4veqeaCYtf59oxrDktqHFrBCR9I3p14MXj7F+y5
         RVxJAYuhx4+sSgSA2h0WTJPtUJkXgRhgxtnv107v2S/PFLdD9OugbAlj1SI2rdwqML
         rJKiYjRvSbGG2E6HPCjBzXQ9VdW82MLmbyoOBDM7f3csmDHpyx8GSyj9ZVE+S9+1UZ
         gb8QWx/It3S1jrOnOiUPBaxy+v2gBNz/fS3HzgvWGft2hrEW3c4EOxQ/7ActknT+AI
         AcQt82PdnqbQw==
Date:   Thu, 7 Jul 2022 17:54:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [net-next PATCH V3 06/12] octeontx2-af: Drop rules for NPC MCAM
Message-ID: <20220707175428.127006ba@kernel.org>
In-Reply-To: <20220707073353.2752279-7-rkannoth@marvell.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
        <20220707073353.2752279-7-rkannoth@marvell.com>
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

On Thu, 7 Jul 2022 13:03:47 +0530 Ratheesh Kannoth wrote:
> NPC exact match table installs drop on hit rules in
> NPC mcam for each channel. This rule has broadcast and multicast
> bits cleared. Exact match bit cleared and channel bits
> set. If exact match table hit bit is 0, corresponding NPC mcam
> drop rule will be hit for the packet and will be dropped.

kdoc:

drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1462: warning: bad line:         u8 cgx_id, lmac_id;


clang:

../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1228:6: warning: variable 'disable_cam' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (entry->cmd)
            ^~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1232:6: note: uninitialized use occurs here
        if (disable_cam) {
            ^~~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1228:2: note: remove the 'if' if its condition is always true
        if (entry->cmd)
        ^~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1201:18: note: initialize the variable 'disable_cam' to silence this warning
        bool disable_cam;
                        ^
                         = 0
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1308:6: warning: variable 'enable_cam' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (cmd)
            ^~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1312:6: note: uninitialized use occurs here
        if (enable_cam) {
            ^~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1308:2: note: remove the 'if' if its condition is always true
        if (cmd)
        ^~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1275:17: note: initialize the variable 'enable_cam' to silence this warning
        bool enable_cam;
                       ^
                        = 0
