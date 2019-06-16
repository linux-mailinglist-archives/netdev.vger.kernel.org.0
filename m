Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D31476C8
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfFPUpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 16:45:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPUpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 16:45:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64197151C2844;
        Sun, 16 Jun 2019 13:45:30 -0700 (PDT)
Date:   Sun, 16 Jun 2019 13:45:29 -0700 (PDT)
Message-Id: <20190616.134529.452171251313252288.davem@davemloft.net>
To:     gvaradar@cisco.com
Cc:     benve@cisco.com, netdev@vger.kernel.org, govind.varadar@gmail.com,
        ssuryaextr@gmail.com, toshiaki.makita1@gmail.com
Subject: Re: [PATCH net v2] net: handle 802.1P vlan 0 packets properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614131354.8287-1-gvaradar@cisco.com>
References: <20190614131354.8287-1-gvaradar@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 13:45:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Govindarajulu Varadarajan <gvaradar@cisco.com>
Date: Fri, 14 Jun 2019 06:13:54 -0700

> When stack receives pkt: [802.1P vlan 0][802.1AD vlan 100][IPv4],
> vlan_do_receive() returns false if it does not find vlan_dev. Later
> __netif_receive_skb_core() fails to find packet type handler for
> skb->protocol 801.1AD and drops the packet.
> 
> 801.1P header with vlan id 0 should be handled as untagged packets.
> This patch fixes it by checking if vlan_id is 0 and processes next vlan
> header.
> 
> Signed-off-by: Govindarajulu Varadarajan <gvaradar@cisco.com>
> ---
> v2:	Move the check out of vlan_do_receive() to
> 	__netif_receive_skb_core(). This way, we do not change the
> 	behaviour when rx_handler is registered. i.e do not strip off
> 	802.1P header when bridge (or rx_handler) is registered.
> 
> Previous discussions:
> http://patchwork.ozlabs.org/patch/1113413/
> http://patchwork.ozlabs.org/patch/1113347/

Looks good, applied, thanks.
