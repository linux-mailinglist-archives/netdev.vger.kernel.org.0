Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E35198307
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgC3SKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:10:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgC3SKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:10:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B134015C49511;
        Mon, 30 Mar 2020 11:10:48 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:10:48 -0700 (PDT)
Message-Id: <20200330.111048.1955833442768668334.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com
Subject: Re: [PATCH net-next 1/1] ptp: Avoid deadlocks in the programmable
 pin code.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
References: <2f3ba828505cb3e8f9dc8a7b6c5a58a51a80cd90.1585445576.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:10:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sat, 28 Mar 2020 18:35:30 -0700

> The PTP Hardware Clock (PHC) subsystem offers an API for configuring
> programmable pins.  User space sets or gets the settings using ioctls,
> and drivers verify dialed settings via a callback.  Drivers may also
> query pin settings by calling the ptp_find_pin() method.
> 
> Although the core subsystem protects concurrent access to the pin
> settings, the implementation places illogical restrictions on how
> drivers may call ptp_find_pin().  When enabling an auxiliary function
> via the .enable(on=1) callback, drivers may invoke the pin finding
> method, but when disabling with .enable(on=0) drivers are not
> permitted to do so.  With the exception of the mv88e6xxx, all of the
> PHC drivers do respect this restriction, but still the locking pattern
> is both confusing and unnecessary.
> 
> This patch changes the locking implementation to allow PHC drivers to
> freely call ptp_find_pin() from their .enable() and .verify()
> callbacks.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reported-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied.
