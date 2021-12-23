Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B75C47E693
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349353AbhLWQ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:59:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349310AbhLWQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:59:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D97AC61C04;
        Thu, 23 Dec 2021 16:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14CAC36AE9;
        Thu, 23 Dec 2021 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640278785;
        bh=QPwau80pk3UraYb+vqoVcwXOj+oK0+cKYssBIEF/HoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H3py8MAESqwKAXYzesMo4Dyke0NuI8jwgvdGoDpJNVLAXQjgp4zAu48A1LZMywN/3
         obU1dv28auI53r7Zp18vCzsmvxpZ4WIfBju18KthXDrdmNDuz+x7EpqyPlGdakhVRs
         zBSi2UCQBsfcOsRHSqXDX7UjyY+HWHt9+Z3qtzY1YBEaOPOAvjvGyhKI4kfSTR3I0h
         ufalNYdcLXXM8ka8+Y2VGLP37soqBPxpTkIcRgDIDAvreNgtIy2iPnbZL6vHUqBXzo
         T96H43Kfr0RlT3DznY++BW/t9q/YbyxIZ3ffplyFUpmudFIWkMZk1KeuAGDxpKo81J
         D4+v3pOIvyu4A==
Date:   Thu, 23 Dec 2021 08:59:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl
 working in compat mode
Message-ID: <20211223085944.55b43857@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223153139.7661-3-repk@triplefau.lt>
References: <20211223153139.7661-1-repk@triplefau.lt>
        <20211223153139.7661-3-repk@triplefau.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 16:31:39 +0100 Remi Pommarel wrote:
> In compat mode SIOC{G,S}IFBR ioctls were only supporting
> BRCTL_GET_VERSION returning an artificially version to spur userland
> tool to use SIOCDEVPRIVATE instead. But some userland tools ignore that
> and use SIOC{G,S}IFBR unconditionally as seen with busybox's brctl.
> 
> Example of non working 32-bit brctl with CONFIG_COMPAT=y:
> $ brctl show
> brctl: SIOCGIFBR: Invalid argument
> 
> Example of fixed 32-bit brctl with CONFIG_COMPAT=y:
> $ brctl show
> bridge name     bridge id               STP enabled     interfaces
> br0
> 
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Since Arnd said this is not supposed to be backported I presume it
should go to net-next?
