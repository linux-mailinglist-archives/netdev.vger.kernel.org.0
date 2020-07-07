Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06888217B3C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgGGWtL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Jul 2020 18:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbgGGWtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:49:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581A7C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:49:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B24BA120F19EC;
        Tue,  7 Jul 2020 15:49:10 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:49:10 -0700 (PDT)
Message-Id: <20200707.154910.182089612829642491.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        dcaratti@redhat.com, jiri@resnulli.us, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net
Subject: Re: [PATCH net v2] vlan: consolidate VLAN parsing code and limit
 max parsing depth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707110325.86731-1-toke@redhat.com>
References: <20200707110325.86731-1-toke@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:49:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Tue,  7 Jul 2020 13:03:25 +0200

> Toshiaki pointed out that we now have two very similar functions to extract
> the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
> that the unbounded parsing loop makes it possible for maliciously crafted
> packets to loop through potentially hundreds of tags.
> 
> Fix both of these issues by consolidating the two parsing functions and
> limiting the VLAN tag parsing to a max depth of 8 tags. As part of this,
> switch over __vlan_get_protocol() to use skb_header_pointer() instead of
> pskb_may_pull(), to avoid the possible side effects of the latter and keep
> the skb pointer 'const' through all the parsing functions.
> 
> v2:
> - Use limit of 8 tags instead of 32 (matching XMIT_RECURSION_LIMIT)
> 
> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thank you.
