Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0741EFD154
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKNXJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:09:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55476 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfKNXJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:09:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A005B14AB3192;
        Thu, 14 Nov 2019 15:09:03 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:09:00 -0800 (PST)
Message-Id: <20191114.150900.1936363085147930639.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        vinicius.gomes@intel.com, richardcochran@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] PTP clock source for SJA1105 tc-taprio
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112001154.26650-1-olteanv@gmail.com>
References: <20191112001154.26650-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 15:09:03 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 12 Nov 2019 02:11:52 +0200

> This series makes the IEEE 802.1Qbv egress scheduler of the sja1105
> switch use a time reference that is synchronized to the network. This
> enables quite a few real Time Sensitive Networking use cases, since in
> this mode the switch can offer its clients a TDMA sort of access to the
> network, and guaranteed latency for frames that are properly scheduled
> based on the common PTP time.
> 
> The driver needs to do a 2-part activity:
> - Program the gate control list into the static config and upload it
>   over SPI to the switch (already supported)
> - Write the activation time of the scheduler (base-time) into the
>   PTPSCHTM register, and set the PTPSTRTSCH bit.
> - Monitor the activation of the scheduler at the planned time and its
>   health.
> 
> Ok, 3 parts.
> 
> The time-aware scheduler cannot be programmed to activate at a time in
> the past, and there is some logic to avoid that.
> 
> PTPCLKCORP is one of those "black magic" registers that just need to be
> written to the length of the cycle. There is a 40-line long comment in
> the second patch which explains why.

Series applied to net-next, thank you.
