Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AD1093E2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKYTEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:04:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:03:59 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECBA81500C564;
        Mon, 25 Nov 2019 11:03:58 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:03:58 -0800 (PST)
Message-Id: <20191125.110358.1439071254106161440.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] slip: Fix use-after-free Read in slip_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125122343.17904-1-jouni.hogander@unikie.com>
References: <20191125122343.17904-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 11:03:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Mon, 25 Nov 2019 14:23:43 +0200

> From: Jouni Hogander <jouni.hogander@unikie.com>
> 
> Slip_open doesn't clean-up device which registration failed from the
> slip_devs device list. On next open after failure this list is iterated
> and freed device is accessed. Fix this by calling sl_free_netdev in error
> path.
> 
> Here is the trace from the Syzbot:
 ...
> Fixes: 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
> Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com
> Cc: David Miller <davem@davemloft.net>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>

Applied and queued up for -stable.
