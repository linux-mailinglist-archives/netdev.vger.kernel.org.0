Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419271987E9
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgC3XQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgC3XQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:16:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7B820409;
        Mon, 30 Mar 2020 23:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585610210;
        bh=tkSEErbO83631xByF1pcztT2JdgxnfTJrknnntp1vRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8r3mbcoVemp6L+fSfsA9C5ZZQvEr67zzd59JrSv8NpCpxXPijBGTmmUDUznqwE+d
         w18+h3dIYl5t/5n9aVNuy2+BRXGIRUsr02039eQ+cxQQ5zOU9yXVVGrCfa8rv5scq9
         lGbg9M8AXJPibgAvYCp8psToaR+zwKmHiNWAXIqk=
Date:   Mon, 30 Mar 2020 16:16:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 01/15] devlink: Add packet trap policers
 support
Message-ID: <20200330161648.4fb4eb9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330193832.2359876-2-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
        <20200330193832.2359876-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 22:38:18 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Devices capable of offloading the kernel's datapath and perform
> functions such as bridging and routing must also be able to send (trap)
> specific packets to the kernel (i.e., the CPU) for processing.
> 
> For example, a device acting as a multicast-aware bridge must be able to
> trap IGMP membership reports to the kernel for processing by the bridge
> module.
> 
> In most cases, the underlying device is capable of handling packet rates
> that are several orders of magnitude higher compared to those that can
> be handled by the CPU.
> 
> Therefore, in order to prevent the underlying device from overwhelming
> the CPU, devices usually include packet trap policers that are able to
> police the trapped packets to rates that can be handled by the CPU.
> 
> This patch allows capable device drivers to register their supported
> packet trap policers with devlink. User space can then tune the
> parameters of these policer (currently, rate and burst size) and read
> from the device the number of packets that were dropped by the policer,
> if supported.
> 
> Subsequent patches in the series will allow device drivers to create
> default binding between these policers and packet trap groups and allow
> user space to change the binding.
> 
> v2:
> * Add 'strict_start_type' in devlink policy
> * Have device drivers provide max/min rate/burst size for each policer.
>   Use them to check validity of user provided parameters
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
