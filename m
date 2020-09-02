Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AC725B683
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgIBWnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBWnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:43:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25AAC061244;
        Wed,  2 Sep 2020 15:43:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C42E4157347A0;
        Wed,  2 Sep 2020 15:26:15 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:43:01 -0700 (PDT)
Message-Id: <20200902.154301.2111662696967293761.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     khc@pm.waw.pl, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan/hdlc: Change the default of
 hard_header_len to 0
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902120706.3411-1-xie.he.0141@gmail.com>
References: <20200902120706.3411-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:26:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed,  2 Sep 2020 05:07:06 -0700

> Change the default value of hard_header_len in hdlc.c from 16 to 0.
> 
> Currently there are 6 HDLC protocol drivers, among them:
> 
> hdlc_raw_eth, hdlc_cisco, hdlc_ppp, hdlc_x25 set hard_header_len when
> attaching the protocol, overriding the default. So this patch does not
> affect them.
> 
> hdlc_raw and hdlc_fr don't set hard_header_len when attaching the
> protocol. So this patch will change the hard_header_len of the HDLC
> device for them from 16 to 0.
> 
> This is the correct change because both hdlc_raw and hdlc_fr don't have
> header_ops, and the code in net/packet/af_packet.c expects the value of
> hard_header_len to be consistent with header_ops.
> 
> In net/packet/af_packet.c, in the packet_snd function,
> for AF_PACKET/DGRAM sockets it would reserve a headroom of
> hard_header_len and call dev_hard_header to fill in that headroom,
> and for AF_PACKET/RAW sockets, it does not reserve the headroom and
> does not call dev_hard_header, but checks if the user has provided a
> header of length hard_header_len (in function dev_validate_header).
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks.
