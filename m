Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788A132B4F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFCJC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:02:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:37074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbfFCJC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 05:02:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 201C1AE12;
        Mon,  3 Jun 2019 09:02:57 +0000 (UTC)
Date:   Mon, 3 Jun 2019 11:02:59 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] devlink: fix libc and kernel headers collision
Message-ID: <20190603090259.GA29017@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602128d22db86bd67e11dec8fe40a73832c222c9.1559230347.git.baruch@tkos.co.il>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Since commit 2f1242efe9d ("devlink: Add devlink health show command") we
> use the sys/sysinfo.h header for the sysinfo(2) system call. But since
> iproute2 carries a local version of the kernel struct sysinfo, this
> causes a collision with libc that do not rely on kernel defined sysinfo
> like musl libc:

> In file included from devlink.c:25:0:
> .../sysroot/usr/include/sys/sysinfo.h:10:8: error: redefinition of 'struct sysinfo'
>  struct sysinfo {
>         ^~~~~~~
> In file included from ../include/uapi/linux/kernel.h:5:0,
>                  from ../include/uapi/linux/netlink.h:5,
>                  from ../include/uapi/linux/genetlink.h:6,
>                  from devlink.c:21:
> ../include/uapi/linux/sysinfo.h:8:8: note: originally defined here
>  struct sysinfo {
> 		^~~~~~~

> Rely on the kernel header alone to avoid kernel and userspace headers
> collision of definitions.

Reviewed-by: Petr Vorel <pvorel@suse.cz>


Kind regards,
Petr
