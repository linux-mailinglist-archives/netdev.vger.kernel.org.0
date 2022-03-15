Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7037D4D965B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiCOIdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346382AbiCOIdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:33:24 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352254C40F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:32:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 203843201591;
        Tue, 15 Mar 2022 04:32:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Mar 2022 04:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CYfNEez282iJloAl9
        WYfCI6lfpBXAnrdq5ChykR72DM=; b=NHmp7CgALrmBUfNGEBFVf13b1pv1AX6F6
        /PZ20XxsdAE8ra4yppnnVSwu5sJQ7WlU6yubPFF4N4oXADzaxUdNqt2CUMmsC7/T
        a1YrUuq812eB/teXTfW4M9KoCaatZnUtKH+F+tYVZnbaKb1ATgsov0xigDrowsEp
        pNWW8hxCw3/OGCNq+xhdNxM30xn9/Iv0H6zs5Os2TbtfklY+usoBIYbrURU0d1YX
        of4ZZC4Y+h8Ib0nhZTmwKZIXpuK+Y/73NkqQiTak5gOJEh/c6LoCFfPn/MP/C/nt
        U0Ujw+ao3hoq+PssDDh0MssRpaCskZEdGZKdTogWndz4JlgK/ZJ7Q==
X-ME-Sender: <xms:C08wYoMTQnI3aqrJLw694O8EY9oHOrZg2YE5_CbfgYB4elyXufJQ9g>
    <xme:C08wYu8cZOJuTYWM0UAQO6ggbCQqyKs-xs6JFD5QoMY2UMrWZMwkEgJmvaieKbM7C
    b9AW4k-KguPJgQ>
X-ME-Received: <xmr:C08wYvRjUzznEd8m4QOAW3Ys8MzXKQ4rHUjwRO2y11EK4lNQmrYUSNM6KwZ_GuFXzcXt22XOECfVvtkCZBmmEniIwuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:C08wYgszIp0GVbPqEu35uqjj1H4_A-uzEH05NwKhnLqlctOedOYkog>
    <xmx:C08wYgdi03Wd3SFSyCBWzaCuWKPrntglTjHSjPL_LH5sSvMay2GHLA>
    <xmx:C08wYk2jbQbDgJ8i-RDACBOL2PizCMIcH3Hw8NIuZ-V_9iLlgGMvDA>
    <xmx:C08wYoRftyk_GCXoPR3er5R8o_JQ5VO2Z5UOUp_Gb4r8qrUaltcSyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 04:32:10 -0400 (EDT)
Date:   Tue, 15 Mar 2022 10:32:08 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com, leon@kernel.org
Subject: Re: [PATCH net-next 6/6] devlink: pass devlink_port to port_split /
 port_unsplit callbacks
Message-ID: <YjBPCAPAe+Z9r25i@shredder>
References: <20220315060009.1028519-1-kuba@kernel.org>
 <20220315060009.1028519-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315060009.1028519-7-kuba@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:00:09PM -0700, Jakub Kicinski wrote:
> Now that devlink ports are protected by the instance lock
> it seems natural to pass devlink_port as an argument to
> the port_split / port_unsplit callbacks.
> 
> This should save the drivers from doing a lookup.
> 
> In theory drivers may have supported unsplitting ports
> which were not registered prior to this change.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
