Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E31308409
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhA2DEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhA2DEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 22:04:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2FDF64DE5;
        Fri, 29 Jan 2021 03:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611889447;
        bh=dhf/x2rLiQfy3s9omFF0vyB+Nqr65MRVmtv+nAEcrwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sNPlMjZ2vun984JZNUAs1FpCwPjf7lOJgi8MYx9XVe/tKxzLX6+NCBwtIN1A/GR55
         xqbeO8tUnD0vcUX0PWzFFrniddH+t4dho2A1Y581g0dyMp/te5aI27zPU07m/Rv+Kh
         VCYlVPxqOswZoXUfJUEB+3y3Bg7wg7uUdrPpw+EtfBAEI1KBE08yPxdLLSe4pl4rKs
         abbynkTk2Fr+wD446L+vNBQfnJpxqcsxSlIzWw1lydWWvHtES8ktf3Ebrn7Gq9Wp/l
         F8c8gnSnBVqCVEky8rIcbZhMO61HdhRa6IePObgYyOXwGLrM6Xd6XjYWEvH3DUMX+O
         NyhNBExxvwjRA==
Date:   Thu, 28 Jan 2021 19:04:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Message-ID: <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126132311.3061388-6-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
        <20210126132311.3061388-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 15:23:06 +0200 Ido Schimmel wrote:
> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> are changed. The aim is to provide an indication to user-space
> (e.g., routing daemons) about the state of the route in hardware.

What does the daemon in the user space do with it?

The notification will only be generated for the _first_ ASIC which
offloaded the object. Which may be fine for you today but as an uAPI 
it feels slightly lacking.

If the user space just wants to make sure the devices are synced to
notifications from certain stage, wouldn't it be more idiomatic to
provide some "fence" operation?

WDYT? David?
