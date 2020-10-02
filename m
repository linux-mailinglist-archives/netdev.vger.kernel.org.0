Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B3280C41
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbgJBCPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733275AbgJBCPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:15:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC043C0613D0;
        Thu,  1 Oct 2020 19:15:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6314712875578;
        Thu,  1 Oct 2020 18:58:35 -0700 (PDT)
Date:   Thu, 01 Oct 2020 19:15:22 -0700 (PDT)
Message-Id: <20201001.191522.1749084221364678705.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH v2] net: usb: rtl8150: prevent
 set_ethernet_addr from setting uninit address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:58:35 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Thu,  1 Oct 2020 13:02:20 +0530

> When get_registers() fails (which happens when usb_control_msg() fails)
> in set_ethernet_addr(), the uninitialized value of node_id gets copied
> as the address.
> 
> Checking for the return values appropriately, and handling the case
> wherein set_ethernet_addr() fails like this, helps in avoiding the
> mac address being incorrectly set in this manner.
> 
> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> Acked-by: Petko Manolov <petkan@nucleusys.com>

First, please remove "Linux-kernel-mentees" from the Subject line.

All patch submitters should have their work judged equally, whoever
they are.  So this Subject text gives no extra information, and it
simply makes scanning Subject lines in one's mailer more difficult.

Second, when a MAC address fails to probe a random MAC address should
be selected.  We have helpers for this.  This way an interface still
comes up and is usable, even in the event of a failed MAC address
probe.
