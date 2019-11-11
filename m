Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB15F817F
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKKUpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:45:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfKKUpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:45:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E0A1153D649B;
        Mon, 11 Nov 2019 12:45:48 -0800 (PST)
Date:   Mon, 11 Nov 2019 12:45:47 -0800 (PST)
Message-Id: <20191111.124547.236986272765072975.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Unlock new potential in SJA1105 with PTP
 system timestamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191109113224.6495-1-olteanv@gmail.com>
References: <20191109113224.6495-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 12:45:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat,  9 Nov 2019 13:32:21 +0200

> The SJA1105 being an automotive switch means it is designed to live in a
> set-and-forget environment, far from the configure-at-runtime nature of
> Linux. Frequently resetting the switch to change its static config means
> it loses track of its PTP time, which is not good.
> 
> This patch series implements PTP system timestamping for this switch
> (using the API introduced for SPI here:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg316725.html),
> adding the following benefits to the driver:
> - When under control of a user space PTP servo loop (ptp4l, phc2sys),
>   the loss of sync during a switch reset is much more manageable, and
>   the switch still remains in the s2 (locked servo) state.
> - When synchronizing the switch using the software technique (based on
>   reading clock A and writing the value to clock B, as opposed to
>   relying on hardware timestamping), e.g. by using phc2sys, the sync
>   accuracy is vastly improved due to the fact that the actual switch PTP
>   time can now be more precisely correlated with something of better
>   precision (CLOCK_REALTIME). The issue is that SPI transfers are
>   inherently bad for measuring time with low jitter, but the newly
>   introduced API aims to alleviate that issue somewhat.
> 
> This series is also a requirement for a future patch set that adds full
> time-aware scheduling offload support for the switch.

Series applied, thank you.
