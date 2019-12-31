Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB11112D611
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLaELE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:11:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaELE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:11:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A991C13EDD471;
        Mon, 30 Dec 2019 20:11:03 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:11:00 -0800 (PST)
Message-Id: <20191230.201100.615691797362262269.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Take PTP egress timestamp by
 port, not mgmt slot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227005954.25268-1-olteanv@gmail.com>
References: <20191227005954.25268-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:11:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 02:59:54 +0200

> The PTP egress timestamp N must be captured from register PTPEGR_TS[n],
> where n = 2 * PORT + TSREG. There are 10 PTPEGR_TS registers, 2 per
> port. We are only using TSREG=0.
> 
> As opposed to the management slots, which are 4 in number
> (SJA1105_NUM_PORTS, minus the CPU port). Any management frame (which
> includes PTP frames) can be sent to any non-CPU port through any
> management slot. When the CPU port is not the last port (#4), there will
> be a mismatch between the slot and the port number.
> 
> Luckily, the only mainline occurrence with this switch
> (arch/arm/boot/dts/ls1021a-tsn.dts) does have the CPU port as #4, so the
> issue did not manifest itself thus far.
> 
> Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
