Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B77B1149442
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAYJxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:53:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:53:25 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43B4415A32105;
        Sat, 25 Jan 2020 01:53:23 -0800 (PST)
Date:   Sat, 25 Jan 2020 10:53:21 +0100 (CET)
Message-Id: <20200125.105321.1408762540319080985.davem@davemloft.net>
To:     mpe@ellerman.id.au
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com, vishal@chelsio.com
Subject: Re: [PATCH] net: cxgb3_main: Add CAP_NET_ADMIN check to
 CHELSIO_GET_MEM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200124094144.15831-1-mpe@ellerman.id.au>
References: <20200124094144.15831-1-mpe@ellerman.id.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Jan 2020 01:53:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>
Date: Fri, 24 Jan 2020 20:41:44 +1100

> The cxgb3 driver for "Chelsio T3-based gigabit and 10Gb Ethernet
> adapters" implements a custom ioctl as SIOCCHIOCTL/SIOCDEVPRIVATE in
> cxgb_extension_ioctl().
> 
> One of the subcommands of the ioctl is CHELSIO_GET_MEM, which appears
> to read memory directly out of the adapter and return it to userspace.
> It's not entirely clear what the contents of the adapter memory
> contains, but the assumption is that it shouldn't be accessible to all
> users.
> 
> So add a CAP_NET_ADMIN check to the CHELSIO_GET_MEM case. Put it after
> the is_offload() check, which matches two of the other subcommands in
> the same function which also check for is_offload() and CAP_NET_ADMIN.
> 
> Found by Ilja by code inspection, not tested as I don't have the
> required hardware.
> 
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Applied and queued up for -stable.
