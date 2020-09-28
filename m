Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD127B7E5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgI1XTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgI1XSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:18:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AF1C0610DF
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:01:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 885671274F423;
        Mon, 28 Sep 2020 15:45:07 -0700 (PDT)
Date:   Mon, 28 Sep 2020 16:01:54 -0700 (PDT)
Message-Id: <20200928.160154.653590366401035900.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     jishi@redhat.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ip6gre: avoid tx_error when sending MLD/DAD
 on external tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e63a72579b88602442650ba38764c0beeed05ada.1601215294.git.dcaratti@redhat.com>
References: <e63a72579b88602442650ba38764c0beeed05ada.1601215294.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 15:45:07 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Sun, 27 Sep 2020 16:08:21 +0200

> similarly to what has been done with commit 9d149045b3c0 ("geneve: change
> from tx_error to tx_dropped on missing metadata"), avoid reporting errors
> to userspace in case the kernel doesn't find any tunnel information for a
> skb that is going to be transmitted: an increase of tx_dropped is enough.
> 
> tested with the following script:
> 
>  # for t in ip6gre ip6gretap ip6erspan; do
>  > ip link add dev gre6-test0 type $t external
>  > ip address add dev gre6-test0 2001:db8::1/64
>  > ip link set dev gre6-test0 up
>  > sleep 30
>  > ip -s -j link show dev gre6-test0 | jq \
>  > '.[0].stats64.tx | {"errors": .errors, "dropped": .dropped}'
>  > ip link del dev gre6-test0
>  > done
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
