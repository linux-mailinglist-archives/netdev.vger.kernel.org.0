Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F3B1439B9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgAUJoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:44:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgAUJoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:44:08 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1816F1502E6CB;
        Tue, 21 Jan 2020 01:44:06 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:44:05 +0100 (CET)
Message-Id: <20200121.104405.1161878965169136462.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH v4] net-sysfs: Fix reference count leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120075103.30551-1-jouni.hogander@unikie.com>
References: <20191118112553.4271-1-jouni.hogander@unikie.com>
        <20200120075103.30551-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:44:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Mon, 20 Jan 2020 09:51:03 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Netdev_register_kobject is calling device_initialize. In case of error
> reference taken by device_initialize is not given up.
> 
> Drivers are supposed to call free_netdev in case of error. In non-error
> case the last reference is given up there and device release sequence
> is triggered. In error case this reference is kept and the release
> sequence is never started.
> 
> Fix this by setting reg_state as NETREG_UNREGISTERED if registering
> fails.
> 
> This is the rootcause for couple of memory leaks reported by Syzkaller:
 ...
> Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
> Cc: David Miller <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Applied and queued up for -stable, thanks.
