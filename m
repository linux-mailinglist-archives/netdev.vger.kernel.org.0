Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE74648919
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLITjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiLITjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:39:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F42DAF4FF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 11:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FC206230C
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09CAC433D2;
        Fri,  9 Dec 2022 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670614746;
        bh=rByQOU7mR/J2q1O2TLAlHUBJu6n17XRUbgOaq1+/iBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fy3lGd1FA2g8VfmRU6mfyBTyf9nGV2tNd1aAv9CSuufOPMhBwVtg+WDtOhsMyzuby
         QYE3FCm1OudxPMO6aga033mzMACGZvf3oUkt3m5h1jwH0pD1znq8GbrVIPz0RD4/Ue
         IW3b9DTMa+PhZAP9pOqZ4amy+7OqtAFX0Qg74uRYMeOBYD+MOeRScMZiIFBsxaV72J
         3+nuE1UgtCyZNRRRnh5IF4sYfsLZz6e/XzCj+50V/SIpO0z8z7nbdqVY3JhC6avxln
         6RiSfzRS9CILo9BjEr8jWoMpCb47lHggzCElOhiWXXnW4vw9H6cIHrpAsVGlBQHJeq
         1LC3IHn9kLZMA==
Date:   Fri, 9 Dec 2022 11:39:05 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: mv88e6xxx: replace VTU
 violation prints with trace points
Message-ID: <Y5OO2RgzWntMGOPg@x130>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209172817.371434-5-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 19:28, Vladimir Oltean wrote:
>It is possible to trigger these VTU violation messages very easily,
>it's only necessary to send packets with an unknown VLAN ID to a port
>that belongs to a VLAN-aware bridge.
>
>Do a similar thing as for ATU violation messages, and hide them in the
>kernel's trace buffer.
>
>New usage model:
>
>$ trace-cmd list | grep mv88e6xxx
>mv88e6xxx
>mv88e6xxx:mv88e6xxx_vtu_miss_violation
>mv88e6xxx:mv88e6xxx_vtu_member_violation
>$ trace-cmd report
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Saeed Mahameed <saeed@kernel.org>

