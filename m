Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DA91DF26D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgEVWuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbgEVWuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:50:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936DAC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 15:50:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2563D12744E72;
        Fri, 22 May 2020 15:50:55 -0700 (PDT)
Date:   Fri, 22 May 2020 15:50:54 -0700 (PDT)
Message-Id: <20200522.155054.352367636201826991.davem@davemloft.net>
To:     valentin@longchamp.me
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        kuba@kernel.org, hkallweit1@gmail.com, matteo.ghidoni@ch.abb.com
Subject: Re: [PATCH] net/ethernet/freescale: rework quiesce/activate for
 ucc_geth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520155350.1372-1-valentin@longchamp.me>
References: <20200520155350.1372-1-valentin@longchamp.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:50:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Longchamp <valentin@longchamp.me>
Date: Wed, 20 May 2020 17:53:50 +0200

> ugeth_quiesce/activate are used to halt the controller when there is a
> link change that requires to reconfigure the mac.
> 
> The previous implementation called netif_device_detach(). This however
> causes the initial activation of the netdevice to fail precisely because
> it's detached. For details, see [1].
> 
> A possible workaround was the revert of commit
> net: linkwatch: add check for netdevice being present to linkwatch_do_dev
> However, the check introduced in the above commit is correct and shall be
> kept.
> 
> The netif_device_detach() is thus replaced with
> netif_tx_stop_all_queues() that prevents any tranmission. This allows to
> perform mac config change required by the link change, without detaching
> the corresponding netdevice and thus not preventing its initial
> activation.
> 
> [1] https://lists.openwall.net/netdev/2020/01/08/201
> 
> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
> Acked-by: Matteo Ghidoni <matteo.ghidoni@ch.abb.com>

Applied, thanks.
