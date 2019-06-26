Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D73657353
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 23:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZVJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 17:09:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZVJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 17:09:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D77DA14DD9E46;
        Wed, 26 Jun 2019 14:09:58 -0700 (PDT)
Date:   Wed, 26 Jun 2019 14:09:56 -0700 (PDT)
Message-Id: <20190626.140956.1543752418469724857.davem@davemloft.net>
To:     palmer@sifive.com
Cc:     nicolas.ferre@microchip.com, harinik@xilinx.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: macb: Fix compilation on systems without COMMON_CLK, v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625084828.540-1-palmer@sifive.com>
References: <20190625084828.540-1-palmer@sifive.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 14:09:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Palmer Dabbelt <palmer@sifive.com>
Date: Tue, 25 Jun 2019 01:48:26 -0700

> Our patch to add support for the FU540-C000 broke compilation on at
> least powerpc allyesconfig, which was found as part of the linux-next
> build regression tests.  This must have somehow slipped through the
> cracks, as the patch has been reverted in linux-next for a while now.
> This patch applies on top of the offending commit, which is the only one
> I've even tried it on as I'm not sure how this subsystem makes it to
> Linus.
> 
> This patch set fixes the issue by adding a dependency of COMMON_CLK to
> the MACB Kconfig entry, which avoids the build failure by disabling MACB
> on systems where it wouldn't compile.  All known users of MACB have
> COMMON_CLK, so this shouldn't cause any issues.  This is a significantly
> simpler approach than disabling just the FU540-C000 support.
> 
> I've also included a second patch to indicate this is a driver for a
> Cadence device that was originally written by an engineer at Atmel.  The
> only relation is that I stumbled across it when writing the first patch.
> 
> Changes since v1 <20190624061603.1704-1-palmer@sifive.com>:
> 
> * Disable MACB on systems without COMMON_CLK, instead of just disabling
>   the FU540-C000 support on these systems.
> * Update the commit message to reflect the driver was written by Atmel.

Series applied, thanks.
