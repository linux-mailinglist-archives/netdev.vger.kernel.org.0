Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE2161D57
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgBQWbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:31:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgBQWba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:31:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EA0415AA812C;
        Mon, 17 Feb 2020 14:31:30 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:31:29 -0800 (PST)
Message-Id: <20200217.143129.203038317799977639.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] net: vlan: suppress "failed to kill
 vid" warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217122758.9995-1-jwi@linux.ibm.com>
References: <20200217122758.9995-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:31:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 17 Feb 2020 13:27:58 +0100

> When a real dev unregisters, vlan_device_event() also unregisters all
> of its vlan interfaces. For each VID this ends up in __vlan_vid_del(),
> which attempts to remove the VID from the real dev's VLAN filter.
> 
> But the unregistering real dev might no longer be able to issue the
> required IOs, and return an error. Subsequently we raise a noisy warning
> msg that is not appropriate for this situation: the real dev is being
> torn down anyway, there shouldn't be any worry about cleanly releasing
> all of its HW-internal resources.
> 
> So to avoid scaring innocent users, suppress this warning when the
> failed deletion happens on an unregistering device.
> While at it also convert the raw pr_warn() to a more fitting
> netdev_warn().
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied, thank you.
