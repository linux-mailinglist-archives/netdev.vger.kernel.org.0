Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62921973C1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgC3FPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:15:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33334 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgC3FPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:15:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F023915C69792;
        Sun, 29 Mar 2020 22:15:11 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:15:11 -0700 (PDT)
Message-Id: <20200329.221511.1223080276940838200.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next v3 00/17] Multipath TCP part 3: Multiple
 subflows and path management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:15:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 27 Mar 2020 14:48:36 -0700

> v2 -> v3: Remove 'inline' in .c files, fix uapi bit macros, and rebase.
> 
> v1 -> v2: Rebase on current net-next, fix for netlink limit setting,
> and update .gitignore for selftest.
> 
> This patch set allows more than one TCP subflow to be established and
> used for a multipath TCP connection. Subflows are added to an existing
> connection using the MP_JOIN option during the 3-way handshake. With
> multiple TCP subflows available, sent data is now stored in the MPTCP
> socket so it may be retransmitted on any TCP subflow if there is no
> DATA_ACK before a timeout. If an MPTCP-level timeout occurs, data is
> retransmitted using an available subflow. Storing this sent data
> requires the addition of memory accounting at the MPTCP level, which was
> previously delegated to the single subflow. Incoming DATA_ACKs now free
> data from the MPTCP-level retransmit buffer.
> 
> IP addresses available for new subflow connections can now be advertised
> and received with the ADD_ADDR option, and the corresponding REMOVE_ADDR
> option likewise advertises that an address is no longer available.
> 
> The MPTCP path manager netlink interface has commands to set in-kernel
> limits for the number of concurrent subflows and control the
> advertisement of IP addresses between peers.
> 
> To track and debug MPTCP connections there are new MPTCP MIB counters,
> and subflow context can be requested using inet_diag. The MPTCP
> self-tests now validate multiple-subflow operation and the netlink path
> manager interface.

Series applied, thanks.
