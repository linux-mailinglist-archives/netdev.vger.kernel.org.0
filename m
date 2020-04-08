Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4851A2B21
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 23:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgDHVbT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Apr 2020 17:31:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729613AbgDHVbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 17:31:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6BED127D38A9;
        Wed,  8 Apr 2020 14:31:18 -0700 (PDT)
Date:   Wed, 08 Apr 2020 14:31:17 -0700 (PDT)
Message-Id: <20200408.143117.436896098376081766.davem@davemloft.net>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] l2tp: Allow management of tunnels and session in user
 namespace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407111148.28406-1-michael.weiss@aisec.fraunhofer.de>
References: <20200407111148.28406-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 14:31:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Weiﬂ <michael.weiss@aisec.fraunhofer.de>
Date: Tue,  7 Apr 2020 13:11:48 +0200

> Creation and management of L2TPv3 tunnels and session through netlink
> requires CAP_NET_ADMIN. However, a process with CAP_NET_ADMIN in a
> non-initial user namespace gets an EPERM due to the use of the
> genetlink GENL_ADMIN_PERM flag. Thus, management of L2TP VPNs inside
> an unprivileged container won't work.
> 
> We replaced the GENL_ADMIN_PERM by the GENL_UNS_ADMIN_PERM flag
> similar to other network modules which also had this problem, e.g.,
> openvswitch (commit 4a92602aa1cd "openvswitch: allow management from
> inside user namespaces") and nl80211 (commit 5617c6cd6f844 "nl80211:
> Allow privileged operations from user namespaces").
> 
> I tested this in the container runtime trustm3 (trustm3.github.io)
> and was able to create l2tp tunnels and sessions in unpriviliged
> (user namespaced) containers using a private network namespace.
> For other runtimes such as docker or lxc this should work, too.
> 
> Signed-off-by: Michael Weiﬂ <michael.weiss@aisec.fraunhofer.de>

Applied, thank you.
