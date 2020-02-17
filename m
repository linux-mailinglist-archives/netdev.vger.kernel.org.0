Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8966161D0B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgBQWDr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 Feb 2020 17:03:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgBQWDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:03:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 862F915A32847;
        Mon, 17 Feb 2020 14:03:46 -0800 (PST)
Date:   Mon, 17 Feb 2020 14:03:44 -0800 (PST)
Message-Id: <20200217.140344.810813375227195875.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] ionic: Add support for Event Queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4386aa68-d8c5-d619-4d38-cb3f4d441f56@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
        <20200216.201124.1598095840697181424.davem@davemloft.net>
        <4386aa68-d8c5-d619-4d38-cb3f4d441f56@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 14:03:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Sun, 16 Feb 2020 22:55:22 -0800

> On 2/16/20 8:11 PM, David Miller wrote:
>> From: Shannon Nelson <snelson@pensando.io>
>> Date: Sun, 16 Feb 2020 15:11:49 -0800
>>
>>> This patchset adds a new EventQueue feature that can be used
>>> for multiplexing the interrupts if we find that we can't get
>>> enough from the system to support our configuration.  We can
>>> create a small number of EQs that use interrupts, and have
>>> the TxRx queue pairs subscribe to event messages that come
>>> through the EQs, selecting an EQ with (TxIndex % numEqs).
>> How is a user going to be able to figure out how to direct
>> traffic to specific cpus using multiqueue settings if you're
>> going to have the mapping go through this custom muxing
>> afterwards?
> 
> When using the EQ feature, the TxRx are assigned to the EventQueues in
> a straight round-robin, so the layout is predictable.  I suppose we
> could have a way to print out the TxRx -> EQ -> Irq mappings, but I'm
> not sure where we would put such a thing.

No user is going to know this and it's completely inconsistent with how
other multiqueue networking devices behave.
