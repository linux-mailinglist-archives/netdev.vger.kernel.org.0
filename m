Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52964890B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 20:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLITit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 14:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLITiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 14:38:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A18DBF6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 11:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 705C0B828E8
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD8CC433D2;
        Fri,  9 Dec 2022 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670614723;
        bh=byO6EYGlZsHqFG9qR6Ej+ZNcm8//ujyvuDi3G7ihcCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rSp6+oFypkdIy9+UKxUqjqKc7iYPGmUD2pOSl8XQ2pKDj20jm6w52ciDjyOrqYZB2
         yBpEBp/rEdIqF7DUNKVoh6gTczErXHZ3fV1qY8mqAESk89Dbf/N9dOTgU+ozd4qj5r
         35ZeOmxsquBuNShd/X1zCjM9U4sMJj/VFMdAqW5p8NbSdYHuaUFah94YhH0DPgaF7q
         hHBKZQbQCetap5RvNJ7Z+kGSzGtcr7kZFAuCIJWqLjcP3l12917t22FVB1WmhHI5Sj
         +ECqIyJCyrFEk8dV1DRzHlARi9FDK63q4D+p7XBD3ZeKwWg+udY29soCa4qXc/Acdc
         b8DAK1kGYTt1g==
Date:   Fri, 9 Dec 2022 11:38:41 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: replace ATU
 violation prints with trace points
Message-ID: <Y5OOwWIT/TL800aw@x130>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209172817.371434-4-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 19:28, Vladimir Oltean wrote:
>In applications where the switch ports must perform 802.1X based
>authentication and are therefore locked, ATU violation interrupts are
>quite to be expected as part of normal operation. The problem is that
>they currently spam the kernel log, even if rate limited.
>
>Create a series of trace points, all derived from the same event class,
>which log these violations to the kernel's trace buffer, which is both
>much faster and much easier to ignore than printing to a serial console.
>
>New usage model:
>
>$ trace-cmd list | grep mv88e6xxx
>mv88e6xxx
>mv88e6xxx:mv88e6xxx_atu_full_violation
>mv88e6xxx:mv88e6xxx_atu_miss_violation
>mv88e6xxx:mv88e6xxx_atu_member_violation
>$ trace-cmd record -e mv88e6xxx sleep 10
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

My knowledge on dsa is very limited but for the tracepoints logic:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
