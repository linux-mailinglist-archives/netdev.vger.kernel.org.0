Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE08A294116
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395153AbgJTRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395149AbgJTRJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:09:18 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6DE82177B;
        Tue, 20 Oct 2020 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603213757;
        bh=9okKdgs6yArjf4mMDWyzMJE+o/l8srWvdz0xqyEZXDM=;
        h=From:To:Cc:Subject:Date:From;
        b=YAPZcXyRNuKo5/htm7wVkuHtE/Z2QvRAmqDhwd/CE72dDZaTf/TXoS4RWFEhJJzUQ
         gtzm825v938NSfMZ/7yWqcseywLe3z5H/Zt9yZZNmWVEXycetSaeenkWSDLatNANiY
         eOuVa9Q0rdT+VklnkXlcHU6R06mjWllapJ/Xd+4g=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue 0/2] net: dsa: mv88e6xxx: fill phylink's supported interfaces to make SFP modules work under DSA ports
Date:   Tue, 20 Oct 2020 19:09:10 +0200
Message-Id: <20201020170912.25959-1-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

this series applies on your net-queue branch.

It adds a new DSA switch operation which is used to determine a DSA
switch port's supported PHY interface modes to fill in phylink's config
supported_interfaces member to make SFP modules work under DSA ports.

This operation is then implemented for mv88e6xxx.

I was thinking whether this method should be renamed to something like
serdes_supported_interfaces or what, so that it is clear that we are
not interested in RGMII and other non-SERDES modes...

BTW: You once complained that you don't like that this needs again to
add a new op to DSA switch and for mv88e6xxx driver to add a new op for
the each chip... So maybe phylink_validate code can be refactored to do
this?
My opinion is that it is cleaner if we just add another op, but I am
open to other opinions.

Marek

Marek Behún (2):
  net: dsa: fill phylink's config supported_interfaces member
  net: dsa: mv88e6xxx: implement .phylink_get_interfaces operation

 drivers/net/dsa/mv88e6xxx/chip.c | 57 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 include/net/dsa.h                |  2 ++
 net/dsa/slave.c                  |  4 +++
 4 files changed, 65 insertions(+)


base-commit: a32e90737c1c92653767d3c95c63c16b9b72c6c2
prerequisite-patch-id: 74af250a98f8d7d48da6b7655000995dd9d9310b
prerequisite-patch-id: 1ab9d0fedae2be621a821aac01ebf680627279d3
prerequisite-patch-id: 24af4837bacf2f8c9afcedd497a7d61c7cb7cdf1
-- 
2.26.2

