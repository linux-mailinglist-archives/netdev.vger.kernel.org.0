Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255F61731DB
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgB1HhF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Feb 2020 02:37:05 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:33704 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgB1HhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 02:37:04 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 90990CECF6;
        Fri, 28 Feb 2020 08:46:29 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] net: bluetooth: hci_core: Fix Suspicious RCU usage
 warnings
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200225130809.32750-1-madhuparnabhowmik10@gmail.com>
Date:   Fri, 28 Feb 2020 08:37:03 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com, paulmck@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <182A4E2D-86AB-4C81-8ACB-AC8033BAFDE3@holtmann.org>
References: <20200225130809.32750-1-madhuparnabhowmik10@gmail.com>
To:     madhuparnabhowmik10@gmail.com
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madhuparna,

> The following functions in hci_core are always called with
> hdev->lock held. No need to use list_for_each_entry_rcu(), therefore
> change the usage of list_for_each_entry_rcu() in these functions
> to list_for_each_entry().
> 
> hci_link_keys_clear()
> hci_smp_ltks_clear()
> hci_smp_irks_clear()
> hci_blocked_keys_clear()
> 
> Warning encountered with CONFIG_PROVE_RCU_LIST:
> 
> [   72.213184] =============================
> [   72.213188] WARNING: suspicious RCU usage
> [   72.213192] 5.6.0-rc1+ #5 Not tainted
> [   72.213195] -----------------------------
> [   72.213198] net/bluetooth/hci_core.c:2288 RCU-list traversed in non-reader section!!
> 
> [   72.213676] =============================
> [   72.213679] WARNING: suspicious RCU usage
> [   72.213683] 5.6.0-rc1+ #5 Not tainted
> [   72.213685] -----------------------------
> [   72.213689] net/bluetooth/hci_core.c:2298 RCU-list traversed in non-reader section!!
> 
> [   72.214195] =============================
> [   72.214198] WARNING: suspicious RCU usage
> [   72.214201] 5.6.0-rc1+ #5 Not tainted
> [   72.214204] -----------------------------
> [   72.214208] net/bluetooth/hci_core.c:2308 RCU-list traversed in non-reader section!!
> 
> [  333.456972] =============================
> [  333.456979] WARNING: suspicious RCU usage
> [  333.457001] 5.6.0-rc1+ #5 Not tainted
> [  333.457007] -----------------------------
> [  333.457014] net/bluetooth/hci_core.c:2318 RCU-list traversed in non-reader section!!
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
> net/bluetooth/hci_core.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

