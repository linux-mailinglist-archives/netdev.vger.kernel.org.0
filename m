Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F809E3FDF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 01:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfJXXET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 19:04:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733193AbfJXXET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 19:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zCuE/IiEXkr6s5WOh0uCb0f5L7q4fGDCgdGiJqc0ULw=; b=hRd6kZEzsOgcxi09/QeIYWYg/X
        /Ikw5xve9hDGDMAmHFTtzTDMjWT0qaqD3MtkEn44pkd6dIy+bAPZBU9IVICXzHmnivjsWVqK2q4Ae
        c2g4uU3ZwMeoSyQqdbGTXG7zkvB1Ql+B/b0usFqoxSQEvG/pL7NMMQddwGJtvBz/Fhw0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNm9P-0006UJ-ID; Fri, 25 Oct 2019 01:04:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v6 0/2] mv88e6xxx: Allow config of ATU hash algorithm
Date:   Fri, 25 Oct 2019 01:03:50 +0200
Message-Id: <20191024230352.24894-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:

Pass a pointer for where the hash should be stored, return a plain
errno, or 0.

Document the parameter.

v3:

Document type of parameter, and valid range
Add break statements to default clause of switch
Directly use ctx->val.vu8

v4:

Consistently use devlink, not a mix of devlink and dl.
Fix allocation of devlink priv
Remove upper case from parameter name
Make mask 16 bit wide.

v5:
Back to using the parameter name ATU_hash

v6:
Rebase net-next/master

Andrew Lunn (2):
  net: dsa: Add support for devlink device parameters
  net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.

 .../networking/devlink-params-mv88e6xxx.txt   |   7 +
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 131 +++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
 include/net/dsa.h                             |  23 +++
 net/dsa/dsa.c                                 |  48 +++++++
 net/dsa/dsa2.c                                |   7 +-
 9 files changed, 254 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt

-- 
2.23.0

