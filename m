Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0986912D613
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfLaEME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:12:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaEME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:12:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CF2F413EDD477;
        Mon, 30 Dec 2019 20:12:03 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:12:03 -0800 (PST)
Message-Id: <20191230.201203.1386622878252432008.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Really make the PTP command
 read-write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227010150.26034-1-olteanv@gmail.com>
References: <20191227010150.26034-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:12:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 03:01:50 +0200

> When activating tc-taprio offload on the switch ports, the TAS state
> machine will try to check whether it is running or not, but will find
> both the STARTED and STOPPED bits as false in the
> sja1105_tas_check_running function. So the function will return -EINVAL
> (an abnormal situation) and the kernel will keep printing this from the
> TAS FSM workqueue:
> 
> [   37.691971] sja1105 spi0.1: An operation returned -22
> 
> The reason is that the underlying function that gets called,
> sja1105_ptp_commit, does not actually do a SPI_READ, but a SPI_WRITE. So
> the command buffer remains initialized with zeroes instead of retrieving
> the hardware state. Fix that.
> 
> Fixes: 41603d78b362 ("net: dsa: sja1105: Make the PTP command read-write")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
