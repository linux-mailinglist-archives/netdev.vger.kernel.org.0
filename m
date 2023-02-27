Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5286A499E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjB0SX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjB0SXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:23:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B10825E18
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24C36B80D55
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 18:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BB8C433EF;
        Mon, 27 Feb 2023 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677522220;
        bh=sOQmzverC3PvSKgHGK56Lh3S+zRh+ZRqpwdmqGbYFOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L2sJof4eJnJc47hWsigLzIc/p/CWP5OC+JxG3wTRcZL1jR1lI4T9ygZT7bnmuPzyC
         0pTtNU0rGPtNVP/65fkyBsVHNNNMIlW0z74wfVjPqdG+ow55npocgZ1VGQ+beROe7i
         cZmQwrzROtJpvFUvBkElfrGSkFtOIbV7ft9bUBJs6E+/hCAItYgPmJ6mK/CThId8Qd
         HsMrsxnH2wAwfzmnhEQkxg+S031gRmqU58Sfjei0GGji7aYB9oS8nVXHTdJb/05Y31
         WhalXIHJgSj05e0AZhLDW1mjR3XBvg75eTNALl6weHjBoY5hy+mRoI4gQTI2jduayc
         JfjKWv9gXDP3A==
Date:   Mon, 27 Feb 2023 10:23:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nick black <dankamongmen@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <20230227102339.08ddf3fb@kernel.org>
In-Reply-To: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Feb 2023 16:12:16 -0500 nick black wrote:
> Add the sysfs export for rx_otherhost_dropped, added
> in 794c24e9921f ("rx_otherhost_dropped to core_stats").
> All other rtnl_link_stats64 entries are already present
> as sysfs nodes; this completes the set.

"All the other stats are there" is not a strong enough reason
to waste memory on all systems. You need to justify the change
based on how important the counter is. I'd prefer to draw a
line on adding the sysfs stats entries. We don't want to have 
to invent a new stats struct just to avoid having sysfs entries
for each stat.
