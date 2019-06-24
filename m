Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0A5194E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbfFXRJ0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Jun 2019 13:09:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbfFXRJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:09:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C200150614A5;
        Mon, 24 Jun 2019 10:09:25 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:09:24 -0700 (PDT)
Message-Id: <20190624.100924.819846587872121764.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        hdanton@sina.com, kristian.evensen@gmail.com
Subject: Re: [PATCH net,stable] qmi_wwan: Fix out-of-bounds read
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624164511.831-1-bjorn@mork.no>
References: <20190624164511.831-1-bjorn@mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 10:09:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Mon, 24 Jun 2019 18:45:11 +0200

> The syzbot reported
> 
>  Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0xca/0x13e lib/dump_stack.c:113
>   print_address_description+0x67/0x231 mm/kasan/report.c:188
>   __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
>   kasan_report+0xe/0x20 mm/kasan/common.c:614
>   qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
>   usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
>   really_probe+0x281/0x660 drivers/base/dd.c:509
>   driver_probe_device+0x104/0x210 drivers/base/dd.c:670
>   __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
>   bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454
> 
> Caused by too many confusing indirections and casts.
> id->driver_info is a pointer stored in a long.  We want the
> pointer here, not the address of it.
> 
> Thanks-to: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Applied, thanks.
