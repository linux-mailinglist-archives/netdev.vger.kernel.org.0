Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2280E1D640D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgEPUuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726584AbgEPUuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:50:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AF0C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 13:50:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1865C119447BD;
        Sat, 16 May 2020 13:50:13 -0700 (PDT)
Date:   Sat, 16 May 2020 13:50:12 -0700 (PDT)
Message-Id: <20200516.135012.277283823891648494.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, sean.wang@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-mediatek@lists.infradead.org, linux@armlinux.org.uk,
        matthias.bgg@gmail.com, opensource@vdorst.com, tj17@me.com,
        foss@volatilesystems.org, riddlariddla@hotmail.com,
        szab.hu@gmail.com, fercerpav@gmail.com
Subject: Re: [PATCH REPOST] net: dsa: mt7530: fix roaming from DSA user
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513151016.14376-1-dqfext@gmail.com>
References: <20200513151016.14376-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:50:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Wed, 13 May 2020 23:10:16 +0800

> When a client moves from a DSA user port to a software port in a bridge,
> it cannot reach any other clients that connected to the DSA user ports.
> That is because SA learning on the CPU port is disabled, so the switch
> ignores the client's frames from the CPU port and still thinks it is at
> the user port.
> 
> Fix it by enabling SA learning on the CPU port.
> 
> To prevent the switch from learning from flooding frames from the CPU
> port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
> and let the switch flood them instead of trapping to the CPU port.
> Multicast frames still need to be trapped to the CPU port for snooping,
> so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
> to disable SA learning.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Applied and queued up for -stable, thanks.
