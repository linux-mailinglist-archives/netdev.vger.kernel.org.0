Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3693611A0A1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKBng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:43:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLKBng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:43:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73FD7150470E2;
        Tue, 10 Dec 2019 17:43:35 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:43:34 -0800 (PST)
Message-Id: <20191210.174334.2001305350497606544.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, scott.drennan@nokia.com,
        jbenc@redhat.com, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/3] net: skb_mpls_push() modified to allow
 MPLS header push at start of packet.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8ff8206cc062f1755292b26a32421a66eeb17ce7.1575964218.git.martin.varghese@nokia.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
        <8ff8206cc062f1755292b26a32421a66eeb17ce7.1575964218.git.martin.varghese@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:43:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Tue, 10 Dec 2019 13:45:52 +0530

> @@ -5472,12 +5472,15 @@ static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
>  }
>  
>  /**
> - * skb_mpls_push() - push a new MPLS header after the mac header
> + * skb_mpls_push() - push a new MPLS header after mac_len bytes from start of
> + *                   the packet
>   *
>   * @skb: buffer
>   * @mpls_lse: MPLS label stack entry to push
>   * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x8848)
>   * @mac_len: length of the MAC header
> + * #ethernet: flag to indicate if the resulting packet after skb_mpls_push is
> + *            ethernet

Why "#ethernet" and not "@ethernet" to refer to this argument?
