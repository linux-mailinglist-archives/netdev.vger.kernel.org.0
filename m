Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC96D9B71
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437121AbfJPUSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:18:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733249AbfJPUSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:18:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 968D81434B98B;
        Wed, 16 Oct 2019 13:18:04 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:18:01 -0700 (PDT)
Message-Id: <20191016.131801.2242669095837757698.davem@davemloft.net>
To:     liuyonglong@huawei.com
Cc:     hkallweit1@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
Subject: Re: [PATCH net] net: phy: Fix "link partner" information disappear
 issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571193039-36228-1-git-send-email-liuyonglong@huawei.com>
References: <1571193039-36228-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 13:18:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>
Date: Wed, 16 Oct 2019 10:30:39 +0800

> Some drivers just call phy_ethtool_ksettings_set() to set the
> links, for those phy drivers that use genphy_read_status(), if
> autoneg is on, and the link is up, than execute "ethtool -s
> ethx autoneg on" will cause "link partner" information disappear.
> 
> The call trace is phy_ethtool_ksettings_set()->phy_start_aneg()
> ->linkmode_zero(phydev->lp_advertising)->genphy_read_status(),
> the link didn't change, so genphy_read_status() just return, and
> phydev->lp_advertising is zero now.
> 
> This patch moves the clear operation of lp_advertising from
> phy_start_aneg() to genphy_read_lpa()/genphy_c45_read_lpa(), and
> if autoneg on and autoneg not complete, just clear what the
> generic functions care about.
> 
> Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>

Applied and queued up for -stable, thank you.
