Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FCA690ED5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBIRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBIRGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:06:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B234A2D67
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C52D61B54
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 17:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC2FC433D2;
        Thu,  9 Feb 2023 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675962391;
        bh=Y5kQ0Oc6KHCWjzXRSQa3XTM+kpi9FjFk9SGRHjym0UI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ChzunPF/uNl+ckD6HADgnvp4KTOWMmW5I+GtJZNqvUARwGb6gRRXGwc5alAtvSzF3
         8RmLQ7PzqJvrWiYEJP9XzZMtk3i81tK2kh4Eln6L0mVXcTLULQAf5BTBgsZ8jEt6C4
         +JHfXt5nMWWgrttaElLWm5vYjqVQ07YcSCUfGXPuUwCRh1+sSO1SgENevtAgh7Faby
         xNxVpqdukXC+V+bdAAxnZLxAo/fEg3yViwyNeMSSpY1Y2gSHOSb1FuoHFWCVTZFbIe
         DDK2L2JlJUu/VK5A6lJ2S/OhgRFek2eUVNwNpb7HC3YEA+Dyr2UUIiN3ptVY6fH7Cw
         S3l84g7vobIMA==
Date:   Thu, 9 Feb 2023 09:06:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
Subject: Re: [PATCH v3 net-next 3/3] ionic: add support for device Component
 Memory Buffers
Message-ID: <20230209090630.1d68d7f8@kernel.org>
In-Reply-To: <c2cde083-3d7a-5fda-5970-ebfc6413f43d@amd.com>
References: <20230207234006.29643-1-shannon.nelson@amd.com>
        <20230207234006.29643-4-shannon.nelson@amd.com>
        <20230208215007.1c821ef3@kernel.org>
        <c2cde083-3d7a-5fda-5970-ebfc6413f43d@amd.com>
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

On Wed, 8 Feb 2023 22:52:59 -0800 Shannon Nelson wrote:
> > Oh, completely missed this when looking at previous version.
> > This is ETHTOOL_A_RINGS_TX_PUSH right?
> > 
> > Could you take a look at what hns3 does to confirm?  
> 
> Hmmm... I hadn't seen that feature creep in.  I guess I'll have to hunt 
> down an up-to-date ethtool and experiment a bit.

Or use the yaml thing :)

https://www.kernel.org/doc/html/next/userspace-api/netlink/intro-specs.html

> Yes, on first glance this looks similar, except we do both TX and RX 
> descriptors when CMB is enabled.

If Tx looks right we can add the same knob for Rx, FWIW.
