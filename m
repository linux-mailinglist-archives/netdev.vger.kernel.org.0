Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF48C4569
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfJBBU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 21:20:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfJBBU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 21:20:28 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 169EE14D3AC7D;
        Tue,  1 Oct 2019 18:20:28 -0700 (PDT)
Date:   Tue, 01 Oct 2019 21:20:27 -0400 (EDT)
Message-Id: <20191001.212027.1363612671973318110.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 18:20:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 30 Sep 2019 18:02:12 +0200

> The goal of the series is to ease nsid allocation from userland.
> The first patch is a preparation work and the second enables to receive the
> new nsid in the answer to RTM_NEWNSID.

The new reply message could break existing apps.

If an app only performs netnsid operations, and fills up the receive
queue because it isn't reading these new replies (it had no reason to,
they didn't exist previously), operations will start failing that
would not fail previously because the receive queue is full.

Given this, I don't see how we can make the change.
