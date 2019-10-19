Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84189DDA8D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfJSSwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:52:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53984 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfJSSwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 14:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G2eCqvz0itTvdMCSxflnan9+fRptCzD1xTEXR/ZXSi0=; b=K8xstA52wUE9UmyaSg3l9iVw6a
        jehgK4VNyb4kXxd2czvJ2Vt0e3kOLgRmfTh69qC0wHWhj4x+JunjzB1vLSQE7k1/wpQK8FYTd6AdV
        2U49Nzw5R4GyhiXnYZadFazDDhHY84Y4zcotwzoQZTvYU/cbi0EwxITienPaQwe4/oQ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLtph-0006Vf-Dq; Sat, 19 Oct 2019 20:52:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 0/2] mv88e6xxx: Allow config of ATU hash algorithm
Date:   Sat, 19 Oct 2019 20:51:59 +0200
Message-Id: <20191019185201.24980-1-andrew@lunn.ch>
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

v3:

Document type of parameter, and valid range
Add break statements to default clause of switch
Directly use ctx->val.vu8

v4:

Consistently use devlink, not a mix of devlink and dl.
Fix allocation of devlink priv
Remove upper case from parameter name
Make mask 16 bit wide.

Andrew Lunn (2):
  net: dsa: Add support for devlink device parameters
  net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.

 .../networking/devlink-params-mv88e6xxx.txt   |   7 +
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 132 +++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
 include/net/dsa.h                             |  23 +++
 net/dsa/dsa.c                                 |  48 +++++++
 net/dsa/dsa2.c                                |   7 +-
 9 files changed, 255 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt

-- 
2.23.0

