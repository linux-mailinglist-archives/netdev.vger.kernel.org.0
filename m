Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02AD71371B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEDDPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:15:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfEDDPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:15:05 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DDE714D44B36;
        Fri,  3 May 2019 20:15:00 -0700 (PDT)
Date:   Fri, 03 May 2019 23:13:08 -0400 (EDT)
Message-Id: <20190503.231308.1440125282445011089.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-rhine: net: Fix a resource leak in
 rhine_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504030813.17684-1-baijiaju1990@gmail.com>
References: <20190504030813.17684-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:15:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Sat,  4 May 2019 11:08:13 +0800

> When platform_driver_register() fails, pci_unregister_driver() is not
> called to release the resource allocated by pci_register_driver().
> 
> To fix this bug, error handling code for platform_driver_register() and
> pci_register_driver() is separately implemented.
> 
> This bug is found by a runtime fuzzing tool named FIZZER written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

I think the idea here is that PCI is not enabled in the kernel, it is
fine for the pci register to fail and only the platform register to
succeed.

You are breaking that.
