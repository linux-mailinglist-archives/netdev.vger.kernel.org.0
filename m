Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E003B2AA87F
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgKHAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgKHAGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 19:06:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4BF206A4;
        Sun,  8 Nov 2020 00:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604793973;
        bh=O6lSemrCPL/1daHZSPh63rX8/9WvDq0mEs7nccEtOtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ker+6/QLi3W6u+GsKg7Tu4sKydMQFZn8WqWJAnJwVTPQOB6UbXj70jUiFOtYOScPy
         o0Y7/5HTkjv+n7D1hgDv0yQZRqeBj/UfxmWeUH8go+M83ViYE2FPnDnU45oV+YiHiB
         mPTK0GXfZu4/Tz+CaVcowmANdoFls8MceCUpyqpM=
Date:   Sat, 7 Nov 2020 16:06:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-hams@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 00/28] ndo_ioctl rework
Message-ID: <20201107160612.2909063a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 23:17:15 +0100 Arnd Bergmann wrote:
> Any suggestions on how to proceed? I think the ndo_siocdevprivate
> change is the most interesting here, and I would like to get
> that merged.

Splitting out / eliminating ioctl pass-thry in general seems like 
a nice clean up. How did you get the ndo_eth_ioctl patch done, was 
it manual work?

> For the wireless drivers, removing the old drivers
> instead of just the dead code might be an alternative, depending
> on whether anyone thinks there might still be users.

Dunno if you want to dig into removal with a series like this, 
anything using ioctls will be pretty old (with the exception 
of what you separated into ndo_eth_ioctl). You may get bogged 
down.
