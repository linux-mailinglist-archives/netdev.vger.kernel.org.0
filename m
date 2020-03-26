Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED71946BB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCZSpx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 14:45:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgCZSpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:45:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 266A515CBBAC6;
        Thu, 26 Mar 2020 11:45:52 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:45:50 -0700 (PDT)
Message-Id: <20200326.114550.2060060414897819387.davem@davemloft.net>
To:     brambonne@google.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        hannes@stressinduktion.org, netdev@vger.kernel.org,
        lorenzo@google.com, jeffv@google.com
Subject: Re: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address
 generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326094252.157914-1-brambonne@google.com>
References: <20200326094252.157914-1-brambonne@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:45:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Bram Bonné" <brambonne@google.com>
Date: Thu, 26 Mar 2020 10:42:52 +0100

> This patch extends the IN6_ADDR_GEN_MODE_STABLE_PRIVACY address
> generation mode to use the software-defined MAC address (dev_addr)
> rather than the permanent, hardware-defined MAC address (perm_addr) of
> the interface when generating IPv6 link-local addresses.
> 
> This ensures that the IPv6 link-local address changes in line with the
> MAC address when per-network MAC address randomization is used,
> providing the expected privacy guarantees.
> 
> When no MAC address randomization is used, dev_addr corresponds to
> perm_addr, and IN6_ADDR_GEN_MODE_STABLE_PRIVACY behaves as before.
> 
> When MAC address randomization is used, this makes the MAC address
> fulfill the role of both the Net_Iface and the (optional) Network_ID
> parameters in RFC7217.
> 
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Cc: Jeffrey Vanderstoep <jeffv@google.com>
> Signed-off-by: Bram Bonné <brambonne@google.com>

I think the current behavior is intentional in that it's supposed to use
something that is unchanging even across arbitrary administrator changes
to the in-use MAC address.
