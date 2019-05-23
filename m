Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9693F283E4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbfEWQhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:37:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWQhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:37:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A5C61509CB01;
        Thu, 23 May 2019 09:37:33 -0700 (PDT)
Date:   Thu, 23 May 2019 09:37:32 -0700 (PDT)
Message-Id: <20190523.093732.2092755980021095694.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next] Revert "dpaa2-eth: configure the cache
 stashing amount on a queue"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558622302-6931-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1558622302-6931-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 May 2019 09:37:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Thu, 23 May 2019 17:38:22 +0300

> This reverts commit f8b995853444aba9c16c1ccdccdd397527fde96d.
> 
> The reverted change instructed the QMan hardware block to fetch
> RX frame annotation and beginning of frame data to cache before
> the core would read them.
> 
> It turns out that in rare cases, it's possible that a QMan
> stashing transaction is delayed long enough such that, by the time
> it gets executed, the frame in question had already been dequeued
> by the core and software processing began on it. If the core
> manages to unmap the frame buffer _before_ the stashing transaction
> is executed, an SMMU exception will be raised.
> 
> Unfortunately there is no easy way to work around this while keeping
> the performance advantages brought by QMan stashing, so disable
> it altogether.
> 
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Applied.
