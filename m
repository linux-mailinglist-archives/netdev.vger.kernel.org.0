Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C6F1C0B56
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 02:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEAAqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 20:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAAqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 20:46:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ED0C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 17:46:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B158B120ED55C;
        Thu, 30 Apr 2020 17:46:30 -0700 (PDT)
Date:   Thu, 30 Apr 2020 17:46:29 -0700 (PDT)
Message-Id: <20200430.174629.548555772744348705.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        kuba@kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, s.priebe@profihost.ag,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] net: bridge: vlan: Add a schedule point during
 VLAN processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430193845.4087868-1-idosch@idosch.org>
References: <20200430193845.4087868-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 17:46:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 30 Apr 2020 22:38:45 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> User space can request to delete a range of VLANs from a bridge slave in
> one netlink request. For each deleted VLAN the FDB needs to be traversed
> in order to flush all the affected entries.
> 
> If a large range of VLANs is deleted and the number of FDB entries is
> large or the FDB lock is contented, it is possible for the kernel to
> loop through the deleted VLANs for a long time. In case preemption is
> disabled, this can result in a soft lockup.
> 
> Fix this by adding a schedule point after each VLAN is deleted to yield
> the CPU, if needed. This is safe because the VLANs are traversed in
> process context.
> 
> Fixes: bdced7ef7838 ("bridge: support for multiple vlans and vlan ranges in setlink and dellink requests")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Applied and queued up for -stable.
