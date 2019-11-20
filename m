Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20571103100
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKTBNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:13:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfKTBNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 20:13:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8900145487B1;
        Tue, 19 Nov 2019 17:13:35 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:13:33 -0800 (PST)
Message-Id: <20191119.171333.624799505921966746.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119095121.6295-1-jouni.hogander@unikie.com>
References: <20191119095121.6295-1-jouni.hogander@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 17:13:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com
Date: Tue, 19 Nov 2019 11:51:21 +0200

> kobject_init_and_add takes reference even when it fails.

I see this in the comment above kobject_init_and_add() but not in the
code.

Where does the implementation of kobject_init_and_add() actually take
such a reference?

Did you discover this by code inspection, or by an actual bug that was
triggered?  If by an actual bug, please provide the OOPS and/or checker
trace that indicated a leak was happening here.

I don't see anything actually wrong here because kobject_init_and_add()
doesn't actually seem to do what it's comment suggests...
