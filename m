Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFB4CC499
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbfJDVKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:10:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730341AbfJDVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 17:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ugWEY20ur+Nm+WiMRd3k/E2SbJGZzgnsyheY4gXCAno=; b=BvPHZhVqYTcTxw3v/0/G802M9V
        Ki8AuDuoHgsh+pED4r2GEUHN6dJBVzc77y1VPHq4PFwLAWmGumzIo2dU9Egz9m/ARFLHWYre7AFFd
        HcMdQcPzaaqD8VXLtlxFROYZntee5gwwd6ZIkC2hZM8u0VVZMuxAFXmDwdCuSnEzFVq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGUpi-0003LQ-Dm; Fri, 04 Oct 2019 23:09:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 0/2] mv88e6xxx: Allow config of ATU hash algorithm
Date:   Fri,  4 Oct 2019 23:09:32 +0200
Message-Id: <20191004210934.12813-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell switches allow the hash algorithm for MAC addresses in the
address translation unit to be configured. Add support to the DSA core
to allow DSA drivers to make use of devlink parameters, and allow the
ATU hash to be get/set via such a parameter.

v2:

Pass a pointer for where the hash should be stored, return a plain
errno, or 0.

Document the parameter.

 .../networking/devlink-params-mv88e6xxx.txt   |   6 +
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 134 +++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
 include/net/dsa.h                             |  23 +++
 net/dsa/dsa.c                                 |  48 +++++++
 net/dsa/dsa2.c                                |   7 +-
 9 files changed, 256 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt

-- 
2.23.0

