Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C306484461
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiADPP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiADPP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:15:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE821C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 07:15:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E72EB8160D
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 15:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29717C36AE9;
        Tue,  4 Jan 2022 15:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641309324;
        bh=G7o1NH0vPO36lQpL/V0qaERBWZPnS8KktOk317wXY0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BHwQwU61cONzqrlrt+GxfNFrVCzWQ3DB/f8kBG8NgdHG/3+xMg5MzNFqPUBzX4ZHm
         hGdsCyuED0vVxy9saW4/eLeC3dmouxazGqmBHYjuLSwgOwUbnSX8NQZV5j/g8Yt2gJ
         BMBpL1K+TQDsX9y/iNZSX/IvnSJrUXd/DlNG5ljLEV+OrnBr5falKxkWlCvzmCoy7Z
         D7HFhoxRQDfP4XmCwm5Cz6cBvk9BUQKf6SaRXbqu0PXR0BhVy2u4vYwn8CYYx4wurL
         ZdOs0xLgRtaRfNzWefXzKPVBJGaPVlIWCn0dA1x5UEiKJbJbDwsbuKH6xNpupu25j0
         WFciepNSaS6Ug==
Date:   Tue, 4 Jan 2022 07:15:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH net-next] net: vertexcom: default to disabled on kbuild
Message-ID: <20220104071522.548024b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104082555.s2ngia5hqvupplzi@sx1>
References: <20220102221126.354332-1-saeed@kernel.org>
        <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220104082555.s2ngia5hqvupplzi@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 00:25:55 -0800 Saeed Mahameed wrote:
> On Mon, Jan 03, 2022 at 08:43:21AM -0800, Jakub Kicinski wrote:
> >On Sun,  2 Jan 2022 14:11:26 -0800 Saeed Mahameed wrote:  
> >> Sorry for being rude but new vendors/drivers are supposed to be disabled
> >> by default, otherwise we will have to manually keep track of all vendors
> >> we are not interested in building.  
> >
> >Vendors default to y, drivers default to n. Vendors don't build
> >anything, hence the somewhat unusual convention. Are you saying
> >you want to change all the Kconfigs... including Mellanox?  
> 
> I didn't know about the vendor vs drivers thing! What's the point ? :) 
> Now as i think about it, Yes, why not change all vendors including Mellanox? 
> I don't see any point to visit a sub-tree where nothing is going to build,
> and waste a chunk of precious build time.
> 
> Anyhow, I can add the default 'n' to the driver and revert the
> vendor back to 'y', Please let me know if you'd want that.

I'm not sure what the origins of the convention are. Maybe when 
the Ethernet drivers got split by vendor we were concerned that 
if we default vendors to n someone doing olddefconfig will lose
drivers?

In any case, my weak preference is also to abandon the convention
unless someone can point out why it's good/useful. The fewer rules 
the better.

FWIW I think that if there is no default set explicitly in Kconfig
it will default to n so if you're writing the patch - you can remove
the overrides rather than setting them to n.
