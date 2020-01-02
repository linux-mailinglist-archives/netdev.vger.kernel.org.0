Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5638412F1CC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgABXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:32:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgABXcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:32:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82CA5156ED157;
        Thu,  2 Jan 2020 15:32:00 -0800 (PST)
Date:   Thu, 02 Jan 2020 15:31:59 -0800 (PST)
Message-Id: <20200102.153159.1629304420356427596.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     baruch@tkos.co.il, vivien.didelot@gmail.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, d.odintsov@traviangames.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200102223641.GI1397@lunn.ch>
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
        <20200102.124556.1780903980066866154.davem@davemloft.net>
        <20200102223641.GI1397@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 15:32:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 2 Jan 2020 23:36:41 +0100

> On Thu, Jan 02, 2020 at 12:45:56PM -0800, David Miller wrote:
>> From: Baruch Siach <baruch@tkos.co.il>
>> Date: Thu, 19 Dec 2019 11:48:22 +0200
>> 
>> > mv88e6xxx_port_set_cmode() relies on cmode stored in struct
>> > mv88e6xxx_port to skip cmode update when the requested value matches the
>> > cached value. It turns out that mv88e6xxx_port_hidden_write() might
>> > change the port cmode setting as a side effect, so we can't rely on the
>> > cached value to determine that cmode update in not necessary.
>> > 
>> > Force cmode update in mv88e6341_port_set_cmode(), to make
>> > serdes configuration work again. Other mv88e6xxx_port_set_cmode()
>> > callers keep the current behaviour.
>> > 
>> > This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
>> > GT-8K.
>> > 
>> > Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
>> > Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
>> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> 
>> This thread has stalled on December 20th with Baruch asking if we can put this
>> in for now as a temporary fix that solves the given problem whilst a better
>> long term analysis and change is being worked on.
> 
> Hi David
> 
> It seems like a reasonable fix for the moment.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks Andrew.

Applied and queued up for -stable.
