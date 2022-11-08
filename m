Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CCE620E0D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiKHLCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbiKHLCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:02:50 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34980450B3;
        Tue,  8 Nov 2022 03:02:49 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id E87E732003D3;
        Tue,  8 Nov 2022 06:02:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Nov 2022 06:02:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667905364; x=1667991764; bh=nP2DN9huvRZCwj+EeirHvDaYlV3K
        zWuv19wsVeFnYlg=; b=nPTarOnIxrW/zamDmNXsZG4ai+ApYSZmmzu+BhtbT5rw
        mtbLXtnZ91Wsx6cYX7aQe4jZNZCZsGJC2Mla0GEjFkbCGOJ0KBcJtDMhDKwLl2qA
        xaOoirLqqKZ47HBzkKP2M5j76dDIFWFnVqIqsP9aY5MXXANWgjOnEYn4r2NdpYtA
        eIrKIfH3WTwPLnB+RkwhAu7gPi2pBocGLuYYuCxZ37Yy0ZkfWkf3aIyWlg2KfItI
        fMMe5Ex/coTrt3s6VoIfzZS7AryQmV2ko/ZWtQmxKcO8hjv2Nz70dTdz6ifpHEZp
        1rdY7PjtxERy0Q0Niv606EEZIHGhJMdtMiFBZqSRHw==
X-ME-Sender: <xms:UzdqY1hDCSISO_-tueqlv65Y-WT_by5RX-iY4Ks0vXO6BVm1TInShQ>
    <xme:UzdqY6DYiH1jBu5p3i9vMHEdK2-4ppT4mhYlRGf9-8zqlnPHTBDTgXN0NbEFsvbtS
    zLCMQh0zQpRTRU>
X-ME-Received: <xmr:UzdqY1FUxNDg1EKaGIKEFlwu8n9f0aHEgH_ktHJyHrIG3Nfq7Pts_ecTuHbXqhjLAVUYSbUIN1n-K5SXRB-pYNAEYQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrfedtgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedthfej
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VDdqY6QY6IRVvS7SoRrZrc9OVQxuCMX-yqC-_VGfglqi2aj1Iptghg>
    <xmx:VDdqYyyaaUhuHCuo7VOmKuyeUPaPEquhT5Xgch_f2n0DWNtfriLfFQ>
    <xmx:VDdqYw7J8H6KkbKUGE7Dk_PaNtjh_YA5u9eNYUPoWMDKw7x29dzckg>
    <xmx:VDdqY3Lw9EuSetC5HmwinjJF4KgSYqFnlwzwvtxQZtZHdjcE_Ao8bg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Nov 2022 06:02:43 -0500 (EST)
Date:   Tue, 8 Nov 2022 13:02:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, andrew@lunn.ch,
        dsahern@gmail.com, sthemmin@microsoft.com,
        sridhar.samudrala@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev
Subject: Re: [PATCH net-next v3] net/core: Allow live renaming when an
 interface is up
Message-ID: <Y2o3ThYXNADKiwRT@shredder>
References: <20221107174242.1947286-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107174242.1947286-1-andy.ren@getcruise.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 09:42:42AM -0800, Andy Ren wrote:
> Allow a network interface to be renamed when the interface
> is up.
> 
> As described in the netconsole documentation [1], when netconsole is
> used as a built-in, it will bring up the specified interface as soon as
> possible. As a result, user space will not be able to rename the
> interface since the kernel disallows renaming of interfaces that are
> administratively up unless the 'IFF_LIVE_RENAME_OK' private flag was set
> by the kernel.
> 
> The original solution [2] to this problem was to add a new parameter to
> the netconsole configuration parameters that allows renaming of
> the interface used by netconsole while it is administratively up.
> However, during the discussion that followed, it became apparent that we
> have no reason to keep the current restriction and instead we should
> allow user space to rename interfaces regardless of their administrative
> state:
> 
> 1. The restriction was put in place over 20 years ago when renaming was
> only possible via IOCTL and before rtnetlink started notifying user
> space about such changes like it does today.
> 
> 2. The 'IFF_LIVE_RENAME_OK' flag was added over 3 years ago in version
> 5.2 and no regressions were reported.
> 
> 3. In-kernel listeners to 'NETDEV_CHANGENAME' do not seem to care about
> the administrative state of interface.
> 
> Therefore, allow user space to rename running interfaces by removing the
> restriction and the associated 'IFF_LIVE_RENAME_OK' flag. Help in
> possible triage by emitting a message to the kernel log that an
> interface was renamed while UP.
> 
> [1] https://www.kernel.org/doc/Documentation/networking/netconsole.rst
> [2] https://lore.kernel.org/netdev/20221102002420.2613004-1-andy.ren@getcruise.com/
> 
> Signed-off-by: Andy Ren <andy.ren@getcruise.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
