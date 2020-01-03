Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20ECF12F22D
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgACA3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:29:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACA3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:29:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2987A15724172;
        Thu,  2 Jan 2020 16:29:42 -0800 (PST)
Date:   Thu, 02 Jan 2020 16:29:41 -0800 (PST)
Message-Id: <20200102.162941.1933071871521624803.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 0/3] Add vmbus dev_num and allow netvsc
 probe options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
References: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 16:29:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 31 Dec 2019 14:13:31 -0800

> Add dev_num for vmbus device based on channel offer sequence.
> User programs can use this number for nic naming.
> Async probing option is allowed for netvsc. Sync probing is still
> the default.

I don't like this at all, sorry.

If 4 devices get channels we will have IDs 1, 2, 3, 4.

Then if channel 3 is taken down, the next one will get 3 which
is not in order any more.

It is not even clear what semantics these numbers have in any
particular sequence or probe situation.

You have to use something more persistent across boots to number
and strictly identify these virtual devices.

I'm not applying this.
