Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3625C3E5
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgICPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:00:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56477 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbgICOGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:06:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 074685C0127;
        Thu,  3 Sep 2020 09:42:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 03 Sep 2020 09:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=bkVYf2
        2PLzmqFvPMcyupd5gtohNhrzzDxKCFnus4QnY=; b=sDn4jdzO1vS8agsVG1aa4E
        F2PWOS34XBBaU7WjCVBMqYzgsZ8h5DWu0zFtVAw1Jc8acfV+Ax4cdLuPt4Gn7yqC
        V7a6x703VAoN4jBrm127WcWFMG+Sp7t4OPRM6mxrSI2J6rxGJ4MnhyF6JdKU1rxV
        AHft/10uvhc+DFH1CdgD5eh06Yh5D1Y5gIgbCfe5GIqS11+e0hQP0crWGRHF1FT8
        nJfT1SCK36AMpdWiNKjBEPdL1xKkESqfA2HbBq8Ex4cj2JDtWabPtUinPdwAkqJd
        vIzTnqDozRGUcCCl6quO/DRmCqKfMJvzLORt+4tkN/0Sp60sJLO+2omb1VKDt82Q
        ==
X-ME-Sender: <xms:wPJQX4ZgmabBbVhm_zN0bJ2wErRcy-keHHTUN3NlSP5BlqBYYcBLEg>
    <xme:wPJQXzaZhDMn4c8TMf1JRqv1iZxJHTLANWl11Jbkpemn16IbVkmpKZSZxrQyZ3lvs
    QlendZomoW3gjY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeguddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofggtgfgsehtkeertd
    ertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeeiteeklefhhfefudfgteefledtueduke
    dtteffuddtjeekjefgueeuieelheehvdenucfkphepkeegrddvvdelrdefiedrjedunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wPJQXy8YRBpBJt2zrsZ8fqpDJZZSshOQnawikf4vYDn8v3z2uUS8yw>
    <xmx:wPJQXyry764BE3mGgJ9Yw9ox2umY0YYKaN_zg5AwkTqUS03Wl1tLAQ>
    <xmx:wPJQXzqct_bUqoKkrSZO8HSmoFTdjF0Dead-TOJfFhhMg50RRjfd4w>
    <xmx:wvJQX0fz1yc1fPMIIboHUfsVHFnW4ZbWCm3VLNtB2_jKJK4dTuwYkQ>
Received: from shredder.mtl.com (igld-84-229-36-71.inter.net.il [84.229.36.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77056328005D;
        Thu,  3 Sep 2020 09:42:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, vadimp@nvidia.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/3] mlxsw: Expose critical and emergency module alarms
Date:   Thu,  3 Sep 2020 16:41:43 +0300
Message-Id: <20200903134146.2166437-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Amit says:

Extend hwmon interface with critical and emergency module alarms.

In case that current module temperature is higher than emergency
threshold, EMERGENCY alarm will be reported in sensors utility:

$ sensors
...
front panel 025:  +55.0°C  (crit = +35.0°C, emerg = +40.0°C) ALARM(EMERGENCY)

In case that current module temperature is higher than critical
threshold, CRIT alarm will be reported in sensors utility:

$ sensors
...
front panel 025:  +54.0°C  (crit = +35.0°C, emerg = +80.0°C) ALARM(CRIT)

Patch set overview:

Patches #1-#2 make several changes to make the code easier to change.

Patch #3 extends the hwmon interface with the new module alarms.

Amit Cohen (3):
  mlxsw: core_hwmon: Split temperature querying from show functions
  mlxsw: core_hwmon: Calculate MLXSW_HWMON_ATTR_COUNT more accurately
  mlxsw: core_hwmon: Extend hwmon interface with critical and emergency
    alarms

 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 152 +++++++++++++++---
 1 file changed, 134 insertions(+), 18 deletions(-)

-- 
2.26.2

