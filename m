Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E08B161F20
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 03:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgBRCwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 21:52:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgBRCwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 21:52:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E550D15B19518;
        Mon, 17 Feb 2020 18:52:35 -0800 (PST)
Date:   Mon, 17 Feb 2020 18:52:35 -0800 (PST)
Message-Id: <20200217.185235.495219494110132658.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     zbr@ioremap.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217175209.GM24152@zorba>
References: <20200217172551.GL24152@zorba>
        <16818701581961475@iva7-8a22bc446c12.qloud-c.yandex.net>
        <20200217175209.GM24152@zorba>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 18:52:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
Date: Mon, 17 Feb 2020 17:52:11 +0000

> On Mon, Feb 17, 2020 at 08:44:35PM +0300, Evgeniy Polyakov wrote:
>>    Hi Daniel, David
>>     
>>    17.02.2020, 20:26, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
>>    > On Sun, Feb 16, 2020 at 06:44:43PM -0800, David Miller wrote:
>>    >>  This is a netlink based facility, therefore please you should add
>>    filtering
>>    >>  capabilities to the netlink configuration and communications path.
>>    >>
>>    >>  Module parameters are quite verboten.
>>    >
>>    > How about adding in Kconfig options to limit the types of messages? The
>>    issue
>>    > with this interface is that it's very easy for someone to enable the
>>    interface
>>    > as a listener, then never turn the interface off. Then it becomes a
>>    broadcast
>>    > interface. It's desirable to limit the more noisy messages in some
>>    cases.
>>     
>>     
>>    Compile-time options are binary switches which live forever after kernel
>>    config has been created, its not gonna help those who enabled messages.
>>    Kernel modules are kind of no-go, since it requires reboot to change in
>>    some cases.
>>     
>>    Having netlink control from userspace is a nice option, and connector has
>>    simple userspace->kernelspace channel,
>>    but it requires additional userspace utils or programming, which is still
>>    cumbersome.
>>     
>>    What about sysfs interface with one file per message type?
> 
> You mean similar to the module parameters I've done, but thru sysfs ? It would
> work for Cisco. I kind of like Kconfig because it also reduces kernel size for
> messages you may never want to see.

Even the sysfs has major downsides, as it fails to take the socket context into
consideration and makes a system wide decision for what should be a per service
decision.
