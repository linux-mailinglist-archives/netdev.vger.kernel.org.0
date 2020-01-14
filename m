Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E537013B287
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgANTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:00:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANS77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:59:59 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90FC21516584B;
        Tue, 14 Jan 2020 10:59:58 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:59:57 -0800 (PST)
Message-Id: <20200114.105957.1581554720765705127.davem@davemloft.net>
To:     vdronov@redhat.com
Cc:     antti.laakso@intel.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, sjohnsto@redhat.com, vlovejoy@redhat.com,
        linux-kernel@vger.kernel.org, artem.bityutskiy@intel.com
Subject: Re: [PATCH] ptp: free ptp device pin descriptors properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200113130009.2938-1-vdronov@redhat.com>
References: <3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com>
        <20200113130009.2938-1-vdronov@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 10:59:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>
Date: Mon, 13 Jan 2020 14:00:09 +0100

> There is a bug in ptp_clock_unregister(), where ptp_cleanup_pin_groups()
> first frees ptp->pin_{,dev_}attr, but then posix_clock_unregister() needs
> them to destroy a related sysfs device.
> 
> These functions can not be just swapped, as posix_clock_unregister() frees
> ptp which is needed in the ptp_cleanup_pin_groups(). Fix this by calling
> ptp_cleanup_pin_groups() in ptp_clock_release(), right before ptp is freed.
> 
> This makes this patch fix an UAF bug in a patch which fixes an UAF bug.
> 
> Reported-by: Antti Laakso <antti.laakso@intel.com>
> Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
> Link: https://lore.kernel.org/netdev/3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com/
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>

Applied, thank you.
