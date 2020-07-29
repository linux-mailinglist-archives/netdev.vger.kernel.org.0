Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77F2325A2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgG2TuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jul 2020 15:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgG2TuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 15:50:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28082C061794;
        Wed, 29 Jul 2020 12:50:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 319AB1275BD75;
        Wed, 29 Jul 2020 12:33:28 -0700 (PDT)
Date:   Wed, 29 Jul 2020 12:50:10 -0700 (PDT)
Message-Id: <20200729.125010.1457267567599420810.davem@davemloft.net>
To:     ioanaruxandra.stancioi@gmail.com
Cc:     david.lebrun@uclouvain.be, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, elver@google.com, glider@google.com,
        stancioi@google.com
Subject: Re: [PATCH] uapi, seg6_iptunnel: Add missing include in
 seg6_iptunnel.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200729104903.3586064-1-ioanaruxandra.stancioi@gmail.com>
References: <20200729104903.3586064-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jul 2020 12:33:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
Date: Wed, 29 Jul 2020 10:49:03 +0000

> From: Ioana-Ruxandra Stãncioi <stancioi@google.com>
> 
> Include <linux/ipv6.h> in uapi/linux/seg6_iptunnel.h to fix the
> following linux/seg6_iptunnel.h compilation error:
> 
>    invalid application of 'sizeof' to incomplete type 'struct ipv6hdr'
>        head = sizeof(struct ipv6hdr);
>                      ^~~~~~
> 
> This is to allow including this header in places where <linux/ipv6.h>
> has not been included but __KERNEL__ is defined. In the kernel the easy
> workaround is including <linux/ipv6.h>, but the header may also be used
> by code analysis tools.
> 
> Signed-off-by: Ioana-Ruxandra Stãncioi <stancioi@google.com>

This doesn't belong in a UAPI header (it's __KERNEL__ protected after
all), and it's only called in one place in the kernel, namely
net/ipv6/net/ipv6/seg6_iptunnel.c)

Just move the helper to that foo.c file, and drop the inline keyword.

Thank you.
