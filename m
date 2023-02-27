Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF466A49FF
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjB0Sk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjB0Sk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:40:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DAF24CB9
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F19E60DD0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 18:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9920DC433D2;
        Mon, 27 Feb 2023 18:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677523255;
        bh=cWOBNpfzQBiDhzOVUT0xmKQN1muHgq/7YXf8/bdMpQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VKe+Ulj6rjadX80va7S2/AWW+8krSe22M6jr6j5NrWiHfEDOVBONgPXLxojIdfk5O
         sfof6KiH4z7ytT15u53shI3AllWypkG4l9iEBAmGkyu/F8GzDrxlz+mVTTt/LGHwqG
         GFtlizxHH1PXTXod9aV5xryPOzdfgCHrIxc65pz1dCMhcnNw32GbsMUGkyc0tNVzFC
         YptisAXrMNHr99waxgLQFqsJ511kZK12c7q/fdhJGUaF79XXqQG0rPHdpT4WE27iD1
         AxvrBaGRx9UmNPezBSPquX0y/i0AMXo8nKfQS2jBYSYq1kXGP0YOQv59xq1zR+rWAW
         QgT2+Qba6PGyQ==
Date:   Mon, 27 Feb 2023 10:40:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     nick black <dankamongmen@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <20230227104054.4a571060@kernel.org>
In-Reply-To: <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
        <20230227102339.08ddf3fb@kernel.org>
        <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
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

On Mon, 27 Feb 2023 13:29:54 -0500 nick black wrote:
> In that case, I think a comment here is warranted explaining why
> this stat, out of 24 total, isn't important enough to reproduce
> in sysfs. I'm not sure what this comment would be:
> rx_otherhost_dropped certainly seems as useful as, say
> rx_compressed (only valid on e.g. CSLIP and PPP).

How about a banner before rx_otherhost_dropped? Maybe:

	/* end of old stats -- new stats via rtnetlink only */

> If this stat is left out of the sysfs interface, I'm likely to
> just grab the rtnl_link_stats64 directly via netlink, and forgo
> the sysfs interface entirely. If, in a modern switched world,
> I'm receiving many packets destined for other hosts, that's at
> least as interesting to me as several other classes of RX error.

Right, I wish we could just remove the old entries since no driver 
from the last decade will fill those in, anyway.
