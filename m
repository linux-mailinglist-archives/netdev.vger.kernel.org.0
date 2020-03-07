Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23817CC02
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 06:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgCGFNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 00:13:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCGFNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 00:13:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D80531540C175;
        Fri,  6 Mar 2020 21:13:36 -0800 (PST)
Date:   Fri, 06 Mar 2020 21:13:20 -0800 (PST)
Message-Id: <20200306.211320.1410615421373955488.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     socketcan@hartkopp.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stable@vger.kernel.org
Subject: Re: [PATCH] bonding: do not enslave CAN devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <03ff979e-a621-c9a3-9be3-13677c147f91@pengutronix.de>
References: <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
        <20200302.111249.471862054833131096.davem@davemloft.net>
        <03ff979e-a621-c9a3-9be3-13677c147f91@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 21:13:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri, 6 Mar 2020 15:12:48 +0100

> On 3/2/20 8:12 PM, David Miller wrote:
>> From: Oliver Hartkopp <socketcan@hartkopp.net>
>> Date: Mon, 2 Mar 2020 09:45:41 +0100
>> 
>>> I don't know yet whether it makes sense to have CAN bonding/team
>>> devices. But if so we would need some more investigation. For now
>>> disabling CAN interfaces for bonding/team devices seems to be
>>> reasonable.
>> 
>> Every single interesting device that falls into a special use case
>> like CAN is going to be tempted to add a similar check.
>> 
>> I don't want to set this precedence.
>> 
>> Check that the devices you get passed are actually CAN devices, it's
>> easy, just compare the netdev_ops and make sure they equal the CAN
>> ones.
> 
> Sorry, I'm not really sure how to implement this check.

Like this:

if (netdev->ops != &can_netdev_ops)
	return;

Done.
