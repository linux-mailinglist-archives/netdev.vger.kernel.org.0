Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF5D22A3E6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgGWAwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWAwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:52:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494AC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:52:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 591E512662B52;
        Wed, 22 Jul 2020 17:35:50 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:52:34 -0700 (PDT)
Message-Id: <20200722.175234.1233062940950818707.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] enetc: Remove the mdio bus on PF probe bailout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595428812-28995-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595428812-28995-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:35:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Wed, 22 Jul 2020 17:40:12 +0300

> For ENETC ports that register an external MDIO bus,
> the bus doesn't get removed on the error bailout path
> of enetc_pf_probe().
> 
> This issue became much more visible after recent:
> commit 07095c025ac2 ("net: enetc: Use DT protocol information to set up the ports")
> Before this commit, one could make probing fail on the error
> path only by having register_netdev() fail, which is unlikely.
> But after this commit, because it moved the enetc_of_phy_get()
> call up in the probing sequence, now we can trigger an mdiobus_free()
> bug just by forcing enetc_alloc_msix() to return error, i.e. with the
> 'pci=nomsi' kernel bootarg (since ENETC relies on MSI support to work),
> as the calltrace below shows:
 ...
> Fixes: ebfcb23d62ab ("enetc: Add ENETC PF level external MDIO support")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied and queued up for -stable, thanks.
