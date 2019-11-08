Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8CF5A96
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKHWIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:08:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39286 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfKHWIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:08:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62205153B4324;
        Fri,  8 Nov 2019 14:08:42 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:08:41 -0800 (PST)
Message-Id: <20191108.140841.647087207980890676.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 1/1] qede: fix NULL pointer deref in __qede_remove()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108104230.9833-1-manishc@marvell.com>
References: <20191108104230.9833-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:08:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Fri, 8 Nov 2019 02:42:30 -0800

> While rebooting the system with SR-IOV vfs enabled leads
> to below crash due to recurrence of __qede_remove() on the VF
> devices (first from .shutdown() flow of the VF itself and
> another from PF's .shutdown() flow executing pci_disable_sriov())
> 
> This patch adds a safeguard in __qede_remove() flow to fix this,
> so that driver doesn't attempt to remove "already removed" devices.
 ...
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>

There should probably be a cleaner, more structural, way to prevent
this sequence.

But for now this fix is good enough.

Applied and queued up for -stable.
