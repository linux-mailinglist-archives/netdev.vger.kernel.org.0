Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D769728EBA6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgJODhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387414AbgJODhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 23:37:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14213C061755;
        Wed, 14 Oct 2020 20:37:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so856219pld.0;
        Wed, 14 Oct 2020 20:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/mQ7jx+jeXIbaNrpQPCSMXM92HTMwnXaMr1S9Xsvdic=;
        b=msNV6Orz5tIcLKfH6tSrRA8png2sZHaShdmQ1xxAJeQJLL6+BOcFhBDLCmQYy7Ccgk
         CMfuUojr0tcTQEI2DZ5tqRQTnzMTKJLpfYdVdnEntexlbFyP4IiuRNcYpXCvlHQ7qZwP
         aRvK/Za9yzAm8eDHzqHIfWJ5mCpBphYxO9fkGUEQOHbABi4tQg/J2foybXPm/y+42/tM
         ouJWFMH95/rjDyMkdZVigErfi0FGaLW2dvYO73H70LMGb7YhQfzvoZnKk0zt+My/YkNt
         Izqdj38ZzRRd2qXUJjZdvchXZMeBkkYPNjP8bvdGO3qbCR7cvHqmOBNSWRvAsaZM1X5h
         a+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/mQ7jx+jeXIbaNrpQPCSMXM92HTMwnXaMr1S9Xsvdic=;
        b=VmCdVvj4S7nTOXcbQwB9CZ9/IoVFXDWqRJiH1QAOIOhyxZGNNOWhULfXZ0FavsUwr1
         2mCIViPVB9AaxhuNoV9XWmx0S7VzkKVOwt77pHVrEYcy3cg3D4SM0UCZb4yLOE0qQdrJ
         Z2h/o3HNqo9+/0K9uGmGWtjFz+lVvgDYyTk0Jit+6q86OullIk0D29BgLwBa/F8Efdh7
         wMMdkBbhgSg4eARh2NGgYLjCpQNuMTKzVvSsJ9QQ7FdUcUYTTL1C+S1NZFKep6z1uNV0
         0oyLevkoJDhxCbvAV5cuQqV77fYbTFj9hnetHXt7C7KP+sBNi43p2YO1LPIN6WQFIQCE
         DUbA==
X-Gm-Message-State: AOAM533QiAN/1m6hKsiGN8HiXUgQxRhUa9xo+tIg8R6W8yU5euVmrm4j
        bwZOhgEF4rqH0yOohSRBe+s=
X-Google-Smtp-Source: ABdhPJx5y3SL9k8GNspZ7+P3F73iyidQ4SjpBOapqyGYzsEDF50l6W/lTYfck8vz2QBQJsWYY3ImyA==
X-Received: by 2002:a17:90b:11d6:: with SMTP id gv22mr2397850pjb.159.1602733074647;
        Wed, 14 Oct 2020 20:37:54 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a19sm1099267pjq.29.2020.10.14.20.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 20:37:53 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Thu, 15 Oct 2020 11:37:32 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201015033732.qaihehernm2jzoln@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
 <20201010134855.GB17351@f3>
 <20201012112406.6mxta2mapifkbeyw@Rk>
 <20201013003704.GA41031@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201013003704.GA41031@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 09:37:04AM +0900, Benjamin Poirier wrote:
>On 2020-10-12 19:24 +0800, Coiby Xu wrote:
>[...]
>> > I think, but didn't check in depth, that in those drivers, the devlink
>> > device is tied to the pci device and can exist independently of the
>> > netdev, at least in principle.
>> >
>> You are right. Take drivers/net/ethernet/mellanox/mlxsw as an example,
>> devlink reload would first first unregister_netdev and then
>> register_netdev but struct devlink stays put. But I have yet to
>> understand when unregister/register_netdev is needed.
>
>Maybe it can be useful to manually recover if the hardware or driver
>gets in an erroneous state. I've used `modprobe -r qlge && modprobe
>qlge` for the same in the past.

Thank you for providing this user case!
>
>> Do we need to
>> add "devlink reload" for qlge?
>
>Not for this patchset. That would be a new feature.

To implement this feature, it seems I need to understand how qlge work
under the hood. For example, what's the difference between
qlge_soft_reset_mpi_risc and qlge_hard_reset_mpi_risc? Or should we use
a brute-force way like do the tasks in qlge_remove and then re-do the
tasks in qlge_probe? Is a hardware reference manual for qlge device?

--
Best regards,
Coiby
