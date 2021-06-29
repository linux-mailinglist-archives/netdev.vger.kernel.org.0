Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D62D3B7733
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhF2R3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhF2R3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 13:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63A7A61D8A;
        Tue, 29 Jun 2021 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624987626;
        bh=r3jJ1rmIJNDqLVCdtJ2SDrTume/hayVyLkhHYVffaA0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mrJEAOq5NH0KW1gJMNCrYGD54E9nZRj7syzCSa4V+XpsC7eHwPM7WP68zAQGYbyZp
         RUpjEjit9xjShwF/nI/ZSMrx38215rpJmgBvEur3lUUuS9xyNwde7z9S1Gbc9pQ5TL
         FdC0TBuwC+0vy3QGHxtaXZr6e4XzIj/QOCLqofPremUgg3Xrd8qsyHnom0N7na5Aji
         OYCo9c7yNjPXTrWTy0rAH6ke/cDIeHpM+2LGKH5WKNBa579+hd91RAx2tNSaBV/xk+
         XsqYP+nFucZVph6YIHPMTib2vbo0HnP47JKcIZRmWB4eWkLVGoh6IGr9AoxXn9ceN0
         qKDtDMin5svhA==
Date:   Tue, 29 Jun 2021 10:27:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, vladyslavt@nvidia.com,
        moshe@nvidia.com, vadimp@nvidia.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <20210629102705.6685704b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YNTfMzKn2SN28Icq@shredder>
References: <20210623075925.2610908-1-idosch@idosch.org>
        <YNOBKRzk4S7ZTeJr@lunn.ch>
        <YNTfMzKn2SN28Icq@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 22:38:27 +0300 Ido Schimmel wrote:
> > I also wonder if it is safe to perform firmware upgrade from user
> > space?  
> 
> I have yet to write the relevant code in ethtool(8), but it should be
> safe. See more below.

What's unclear to me is what difference does it make whether the code is
in kernel or in ethtool.git. If modules follow the standard the code
churn will be low. And we have to type the code up anyway it seems it
doesn't matter where it lies.

Where it does matter is if one wants to reuse existing user space built
on top of raw read/write interfaces.

IOW it shouldn't matter if we put the code in the kernel or user space
from effort perspective, but the latter is more risky.

You mention some limited sensor resources, isn't this exactly the
resource management the kernel is supposed to perform?
