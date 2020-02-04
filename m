Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA2F151802
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 10:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgBDJhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 04:37:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41370 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgBDJhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 04:37:52 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D91971577F51A;
        Tue,  4 Feb 2020 01:37:50 -0800 (PST)
Date:   Tue, 04 Feb 2020 10:37:49 +0100 (CET)
Message-Id: <20200204.103749.1474392609351299440.davem@davemloft.net>
To:     harini.katakam@xilinx.com
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH v2 2/2] net: macb: Limit maximum GEM TX length in TSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580735882-7429-3-git-send-email-harini.katakam@xilinx.com>
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
        <1580735882-7429-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Feb 2020 01:37:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>
Date: Mon,  3 Feb 2020 18:48:02 +0530

> GEM_MAX_TX_LEN currently resolves to 0x3FF8 for any IP version supporting
> TSO with full 14bits of length field in payload descriptor. But an IP
> errata causes false amba_error (bit 6 of ISR) when length in payload
> descriptors is specified above 16387. The error occurs because the DMA
> falsely concludes that there is not enough space in SRAM for incoming
> payload. These errors were observed continuously under stress of large
> packets using iperf on a version where SRAM was 16K for each queue. This
> errata will be documented shortly and affects all versions since TSO
> functionality was added. Hence limit the max length to 0x3FC0 (rounded).
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> ---
> v2:
> Use 0x3FC0 by default

You should add a comment above the definition which explains how this
value was derived.  It looks magic currently.
