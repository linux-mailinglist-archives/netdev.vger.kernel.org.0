Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC51FA574
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgFPBOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgFPBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:14:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8604C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:14:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41CF512358238;
        Mon, 15 Jun 2020 18:14:08 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:14:07 -0700 (PDT)
Message-Id: <20200615.181407.504559925309112695.davem@davemloft.net>
To:     geffrey.guo@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        dsa@cumulusnetworks.com, kuba@kernel.org
Subject: Re: [PATCH] net: Fix the arp error in some cases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592269250-36987-1-git-send-email-geffrey.guo@huawei.com>
References: <1592269250-36987-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:14:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: guodeqing <geffrey.guo@huawei.com>
Date: Tue, 16 Jun 2020 09:00:50 +0800

> ie.,
> $ ifconfig eth0 6.6.6.6 netmask 255.255.255.0
> 
> $ ip rule add from 6.6.6.6 table 6666
> 
> $ ip route add 9.9.9.9 via 6.6.6.6
> 
> $ ping -I 6.6.6.6 9.9.9.9
> PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.
> 
> 3 packets transmitted, 0 received, 100% packet loss, time 2079ms
> 
> $ arp
> Address     HWtype  HWaddress           Flags Mask            Iface
> 6.6.6.6             (incomplete)                              eth0
> 
> The arp request address is error, this problem can be reproduced easily.
> 
> Fixes: 3bfd847203c6("net: Use passed in table for nexthop lookups")
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>

When David Ahern said you need to more clearly explain the actual
problem you are seeing, he also meant that you need to add that information
to your commit message as well.

