Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E825D4E95DB
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241933AbiC1L4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241571AbiC1L4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:56:23 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F18F205F5;
        Mon, 28 Mar 2022 04:52:35 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 33E9F2223A;
        Mon, 28 Mar 2022 13:52:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648468353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CT9vNlpty7jzFYreukJyjTlzhIu97loT7wE6CkBFGYE=;
        b=QzitOIhEEkmaafVhIrvvpTwOkgESkVPoXelSuJ4I7G0AgxSrCzwGcPblDaiNlnByuEYCUA
        KBFKjCPS0iNCa0Jw/1SUMsG/nHBPrrCv3NlddMoo47MH60JDXG4VRpGJVygwptrgSkTIDs
        DIGp6x4eKUZ9nCcFI64YUaCF6TT7sVI=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v1 0/2] hwmon: introduce hwmon_sanitize()
Date:   Mon, 28 Mar 2022 13:52:24 +0200
Message-Id: <20220328115226.3042322-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During development of the support for the temperature sensor on the GPY
PHY, I've noticed that there is ususually a loop over the name to
replace any invalid characters. Instead of open coding it in the drivers
provide a convenience function.

I'm not sure how to handle this correctly, as this touches both the
network tree and the hwmon tree. Also, the GPY PHY temperature senors
driver would use it.

Michael Walle (2):
  hwmon: introduce hwmon_sanitize_name()
  net: phy: use hwmon_sanitize_name()

 drivers/hwmon/intel-m10-bmc-hwmon.c |  5 +----
 drivers/net/phy/nxp-tja11xx.c       |  5 +----
 drivers/net/phy/sfp.c               |  6 ++----
 include/linux/hwmon.h               | 16 ++++++++++++++++
 4 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.30.2

