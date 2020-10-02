Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAC7281E7D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBWiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJBWiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:38:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B870C0613D0;
        Fri,  2 Oct 2020 15:38:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A651111E48E3C;
        Fri,  2 Oct 2020 15:22:02 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:38:49 -0700 (PDT)
Message-Id: <20201002.153849.1212074263659708172.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
        <20201001.191522.1749084221364678705.davem@davemloft.net>
        <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:22:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Fri, 2 Oct 2020 17:04:13 +0530

> But this patch is about ensuring that an uninitialized variable's
> value (whatever that may be) is not set as the ethernet address
> blindly (without any form of checking if get_registers() worked
> as expected, or not).

Right, and if you are going to check for errors then you have to
handle the error properly.

And the proper way to handle this error is to set a random ethernet
address on the device.
