Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6D117638C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCBTMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:12:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52426 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgCBTMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:12:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D19491457E372;
        Mon,  2 Mar 2020 11:12:49 -0800 (PST)
Date:   Mon, 02 Mar 2020 11:12:49 -0800 (PST)
Message-Id: <20200302.111249.471862054833131096.davem@davemloft.net>
To:     socketcan@hartkopp.net
Cc:     mkl@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stable@vger.kernel.org
Subject: Re: [PATCH] bonding: do not enslave CAN devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
References: <767580d8-1c93-907b-609c-4c1c049b7c42@pengutronix.de>
        <20200226.202326.295871777946911500.davem@davemloft.net>
        <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Mar 2020 11:12:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Mon, 2 Mar 2020 09:45:41 +0100

> I don't know yet whether it makes sense to have CAN bonding/team
> devices. But if so we would need some more investigation. For now
> disabling CAN interfaces for bonding/team devices seems to be
> reasonable.

Every single interesting device that falls into a special use case
like CAN is going to be tempted to add a similar check.

I don't want to set this precedence.

Check that the devices you get passed are actually CAN devices, it's
easy, just compare the netdev_ops and make sure they equal the CAN
ones.
