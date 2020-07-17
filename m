Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB652241F0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgGQRhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgGQRhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:37:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E03C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:37:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7FEC135984B4;
        Fri, 17 Jul 2020 10:37:12 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:37:11 -0700 (PDT)
Message-Id: <20200717.103711.2273998579805096655.davem@davemloft.net>
To:     echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next] net: openvswitch: reorder masks array based
 on usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159481496860.37198.8385493040681064040.stgit@ebuild>
References: <159481496860.37198.8385493040681064040.stgit@ebuild>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 10:37:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>
Date: Wed, 15 Jul 2020 14:09:28 +0200

> This patch reorders the masks array every 4 seconds based on their
> usage count. This greatly reduces the masks per packet hit, and
> hence the overall performance. Especially in the OVS/OVN case for
> OpenShift.
> 
> Here are some results from the OVS/OVN OpenShift test, which use
> 8 pods, each pod having 512 uperf connections, each connection
> sends a 64-byte request and gets a 1024-byte response (TCP).
> All uperf clients are on 1 worker node while all uperf servers are
> on the other worker node.
> 
> Kernel without this patch     :  7.71 Gbps
> Kernel with this patch applied: 14.52 Gbps
> 
> We also run some tests to verify the rebalance activity does not
> lower the flow insertion rate, which does not.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Tested-by: Andrew Theurer <atheurer@redhat.com>

Applied, thanks.
