Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE421A8AF
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgGIUJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbgGIUJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:09:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3290720720;
        Thu,  9 Jul 2020 20:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594325366;
        bh=7WX1ILd0dshu6yJFE1jDhBfT8Dpii3SViG15P8i4kzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BcvmC0FSQFEfCblqNg6k5p/Q93X6JrCWIHbvqeEYdMAifEWs7eJ60kIWfrISiML3n
         bYVZkiGB6gTuitF8g8b8rxzj9g9rjatxjnUxBPcWsqwDXb6h4C19gebmpOvsF5Gw4b
         0qdC1qZRNV47fzpcCUV9S8kQyOe/jBPLRYh0at1Y=
Date:   Thu, 9 Jul 2020 13:09:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        snelson@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 0/9] Expose port split attributes
Message-ID: <20200709130924.0460d8be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 16:18:13 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Danielle says:
> 
> Currently, user space has no way of knowing if a port can be split and
> into how many ports. Among other things, this makes it impossible to
> write generic tests for port split functionality.
> 
> Therefore, this set exposes two new devlink port attributes to user
> space: Number of lanes and whether the port can be split or not.
> 
> Patch set overview:
> 
> Patches #1-#4 cleanup 'struct devlink_port_attrs' and reduce the number
> of parameters passed between drivers and devlink via
> devlink_port_attrs_set()
> 
> Patch #5 adds devlink port lanes attributes
> 
> Patches #6-#7 add devlink port splittable attribute
> 
> Patch #8 exploits the fact that devlink is now aware of port's number of
> lanes and whether the port can be split or not and moves some checks
> from drivers to devlink
> 
> Patch #9 adds a port split test
> 
> Changes since v2:
> * Remove some local variables from patch #3
> * Reword function description in patch #5
> * Fix a bug in patch #8
> * Add a test for the splittable attribute in patch #9
> 
> Changes since v1:
> * Rename 'width' attribute to 'lanes'
> * Add 'splittable' attribute
> * Move checks from drivers to devlink

FWIW I fancy my:

	lanes % count != 0

from the nfp cleaner than the:

	!is_power_of_2(count) || count > lanes

of mlxsw, but that's bike shedding at best, and at worst 
I'm missing something ;) so:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
