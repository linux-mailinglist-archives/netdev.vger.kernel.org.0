Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3340177853
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfG0K5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfG0K5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 06:57:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B8782075C;
        Sat, 27 Jul 2019 10:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564225028;
        bh=cpJMrc3qMr4KHohtCrL/fLwxp5ULQWrOB7thhG7IwNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UWsJavDNt0XqCqL6uQQajCRQQnrcQ0Lmw4ExVFAdoSzqh5MWipbS3hkau5gtUIG+O
         +xZl1XljBp4HAH1B+mEKtakyx5XP5evOf46kfHRigyPbhLeG3xGq0eymr/5iAT2fJG
         1eWVYohJ7vvZPx8TDqplbq7nNVWvgLwKRCoBGKTg=
Date:   Sat, 27 Jul 2019 12:57:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, aaro.koskinen@iki.fi,
        arnd@arndb.de
Subject: Re: [PATCH 2/2] staging/octeon: Allow test build on !MIPS
Message-ID: <20190727105706.GB458@kroah.com>
References: <20190726174425.6845-1-willy@infradead.org>
 <20190726174425.6845-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726174425.6845-3-willy@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 10:44:25AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Add compile test support by moving all includes of files under
> asm/octeon into octeon-ethernet.h, and if we're not on MIPS,
> stub out all the calls into the octeon support code in octeon-stubs.h
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/staging/octeon/Kconfig            |    2 +-
>  drivers/staging/octeon/ethernet-defines.h |    2 -
>  drivers/staging/octeon/ethernet-mdio.c    |    6 +-
>  drivers/staging/octeon/ethernet-mem.c     |    5 +-
>  drivers/staging/octeon/ethernet-rgmii.c   |   10 +-
>  drivers/staging/octeon/ethernet-rx.c      |   13 +-
>  drivers/staging/octeon/ethernet-rx.h      |    2 -
>  drivers/staging/octeon/ethernet-sgmii.c   |    8 +-
>  drivers/staging/octeon/ethernet-spi.c     |   10 +-
>  drivers/staging/octeon/ethernet-tx.c      |   12 +-
>  drivers/staging/octeon/ethernet-util.h    |    4 -
>  drivers/staging/octeon/ethernet.c         |   12 +-
>  drivers/staging/octeon/octeon-ethernet.h  |   29 +-
>  drivers/staging/octeon/octeon-stubs.h     | 1429 +++++++++++++++++++++
>  14 files changed, 1466 insertions(+), 78 deletions(-)
>  create mode 100644 drivers/staging/octeon/octeon-stubs.h

No real objection from me, having this driver able to be built on
non-mips systems would be great.

But wow, that stubs.h file is huge, you really need all of that?
There's no way to include the files from the mips "core" directly
instead for some of it?

If not, that's fine, and all of this can go through net-next:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
