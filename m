Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA3920BC19
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgFZWDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:03:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9DDC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:03:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 543B512732081;
        Fri, 26 Jun 2020 15:03:08 -0700 (PDT)
Date:   Fri, 26 Jun 2020 15:03:05 -0700 (PDT)
Message-Id: <20200626.150305.1841670809009065570.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] enetc: Fix tx rings bitmap iteration range, irq
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593188249-22686-1-git-send-email-claudiu.manoil@nxp.com>
References: <1593188249-22686-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 15:03:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Fri, 26 Jun 2020 19:17:29 +0300

> The rings bitmap of an interrupt vector encodes
> which of the device's rings were assigned to that
> interrupt vector.
> Hence the iteration range of the tx rings bitmap
> (for_each_set_bit()) should be the total number of
> Tx rings of that netdevice instead of the number of
> rings assigned to the interrupt vector.
> Since there are 2 cores, and one interrupt vector for
> each core, the number of rings asigned to an interrupt
> vector is half the number of available rings.
> The impact of this error is that the upper half of the
> tx rings could still generate interrupts during napi
> polling.
> 
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied and queued up for -stable, thank you.
