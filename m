Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1913D492FD6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349464AbiARVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbiARVAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BCC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73FA5612D0
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 21:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740F9C340E0;
        Tue, 18 Jan 2022 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642539616;
        bh=JuXBUyasRkgJ8rBkGNlxs8nSsbRRJKJ2aNxeRJeVVLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sRozXST6/vyN782yroTsh4yXU7VFDnCadq0sC0yuMQjKHO/C3+2FaQ+ok/QsjuB+E
         +IQjeqDkffY1HY6vNsvJ7S4KP8BhH32QinqG4Gvxx30wGQYjPNQM9vClm2bodJd9/X
         HRr6WSQEPP9cjeVQ18Q6dnZgufB24RXZQ67b90Pi2Xm3Arq5XzvbivLY6rSo6YQGMr
         pW3Wb0NuLYTP3NWpfOpTiMNncimHnK7TSjDvfcMPNxttzXtkppAbK+ZnHyH0xz6JWG
         HQhHU8qevii8r+5kXzo2QPL6qnfPJuEYl5VPX6l9hoh5sIb7CrfqWDb+upTv8W3EmK
         zk8Yd+LIwu4Xw==
Date:   Tue, 18 Jan 2022 13:00:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ariane.keller@tik.ee.ethz.ch" <ariane.keller@tik.ee.ethz.ch>
Subject: Re: [PATCH net v2 0/9] Xilinx axienet fixes
Message-ID: <20220118130015.3118e0de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <5a5b1c7d58b81b2a6ab738650964ea7a1c2cf99b.camel@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
        <5a5b1c7d58b81b2a6ab738650964ea7a1c2cf99b.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 20:45:31 +0000 Robert Hancock wrote:
> On Wed, 2022-01-12 at 11:36 -0600, Robert Hancock wrote:
> > Various fixes for the Xilinx AXI Ethernet driver.
> > 
> > Changed since v1:
> > -corrected a Fixes tag to point to mainline commit
> > -split up reset changes into 3 patches
> > -added ratelimit on netdev_warn in TX busy case
> > 
> > Robert Hancock (9):
> >   net: axienet: increase reset timeout
> >   net: axienet: Wait for PhyRstCmplt after core reset
> >   net: axienet: reset core on initialization prior to MDIO access
> >   net: axienet: add missing memory barriers
> >   net: axienet: limit minimum TX ring size
> >   net: axienet: Fix TX ring slot available check
> >   net: axienet: fix number of TX ring slots for available check
> >   net: axienet: fix for TX busy handling
> >   net: axienet: increase default TX ring size to 128
> 
> Any other comments/reviews on this patch set? It's marked as Changes Requested
> in Patchwork, but I don't think I saw any discussions that ended up with any
> changes being asked for?

Perhaps it was done in anticipation to follow up to Radhey's or
Andrew's question but seems like you answered those. Or maybe because
of the missing CC on of hancock@sedsystems.ca on patch 5?
Not sure.

Could you fold some of the explanations into commit messages, add
Andrew's Acks and post a v3? 

We could probably apply as is but since it was marked as Changes
Requested I can't be sure someone hasn't stopped reviewing in
anticipation of v3.

Thanks!
