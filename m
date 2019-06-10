Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAE63BEA9
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbfFJV2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:28:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389193AbfFJV2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:28:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A608150FC739;
        Mon, 10 Jun 2019 14:28:13 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:28:10 -0700 (PDT)
Message-Id: <20190610.142810.138225058759413106.davem@davemloft.net>
To:     gvaradar@cisco.com
Cc:     benve@cisco.com, netdev@vger.kernel.org, govind.varadar@gmail.com
Subject: Re: [PATCH net] net: handle 802.1P vlan 0 packets properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610142702.2698-1-gvaradar@cisco.com>
References: <20190610142702.2698-1-gvaradar@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 14:28:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Govindarajulu Varadarajan <gvaradar@cisco.com>
Date: Mon, 10 Jun 2019 07:27:02 -0700

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

Under Linux we absolutely do not decapsulate the VLAN protocol unless
a VLAN device is configured on that interface.
