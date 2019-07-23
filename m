Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853BD722BF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfGWXG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:06:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfGWXG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:06:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24A5A153CC23C;
        Tue, 23 Jul 2019 16:06:29 -0700 (PDT)
Date:   Tue, 23 Jul 2019 16:06:28 -0700 (PDT)
Message-Id: <20190723.160628.20093803405793483.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
References: <20190722214023.9513-12-snelson@pensando.io>
        <20190723.143326.197667027838462669.davem@davemloft.net>
        <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 16:06:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 23 Jul 2019 15:50:43 -0700

> On 7/23/19 2:33 PM, David Miller wrote:
>> Generally interface address changes are expected to be synchronous.
> Yeah, this bothers me a bit as well, but the address change calls come
> in under spin_lock_bh(), and I'm reluctant to make an AdminQ call
> under the _bh that could block for a few seconds.

So it's not about memory allocation but rather the fact that the device
might take a while to complete?

Can you start the operation synchronously yet complete it async?
