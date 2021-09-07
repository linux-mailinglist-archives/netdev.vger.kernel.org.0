Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A4C402EF7
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243501AbhIGTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:31:07 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:46666 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbhIGTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:31:06 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 3BFDF20F0031
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <a610ac4b-eeb9-50c2-4b88-0d77d1c83d47@omp.ru>
Date:   Tue, 7 Sep 2021 22:29:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/21 2:29 PM, Yoshihiro Shimoda wrote:

> The cur_tx counter must be incremented after TACT bit of
> txdesc->status was set. However, a CPU is possible to reorder
> instructions and/or memory accesses between cur_tx and
> txdesc->status. And then, if TX interrupt happened at such a
> timing, the sh_eth_tx_free() may free the descriptor wrongly.
> So, add wmb() before cur_tx++.

   Not dma_wmb()? :-)

> Otherwise NETDEV WATCHDOG timeout is possible to happen.
> 
> Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
