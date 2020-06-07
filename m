Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1321F0C3C
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFGPAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:43 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgFGPAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqBYfzDGvT4+FntNoAfGoplaCzAPxzLUIHMgi6/4QF3idMvjzvjFbEXNrIBciroVfhrpXb/bQnwM1b49sqP3eI4Dq4rL7ytENVFKR7DQ/aPmCYPv8k+goJ4bAFd/7+RR5KaIZU88ex7+HFw2lTQKd6vjnl92eNOZApmzjJy8lecePrk73cs0m/NqTZeEg+AaPFNcYNmd2wiO72YD85K58dhIBVErRVV6Er5IQIaXic4UCSrSR+BrFzQ0N7PbnrvIEzuQe0kp89BVurMWORmWB3ZnLhOOlU1pDJg3DTyFsk/X+Kh3ZJ64bsMzT0BQvVN/iiGbenr5SArwZ7Tn49rtow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUA02MnIJi1yWIUDfjwhpUqwargFuAa89P7bZBBDcLA=;
 b=COVOVjIK58ic8XA0VxMTCbC+6fsbUJB0U9bpOFQQGUk7Lm+uj953ldce7kh20zUTkewh2YKDguQa0ceSC7PXbOAVUeFVhrcT7pl8TijeHzUM4BrmlhoLE+D+xD6wQ/q4tTxrUw92NGQ+eVg26S8namQw60tM5nA7ffUsbbMUImkzAbDg2HpGQFe0wbpZwUvl4J2n5JbMmswEojMLbovzsXeuKTkq9+zUPxtol8SX0QcWDdXgVx7HEGMoULoR3NNtyDgTf/qiy27y3QsC6CDHh0ETXueUt+0tc3zbMCm7AQs6xK37ZUf+8Ty+8L2FUy5ETXuhIWFVgzVMN4ufXltWag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUA02MnIJi1yWIUDfjwhpUqwargFuAa89P7bZBBDcLA=;
 b=LUsrEfTK92NoN7U9hafiqqPjDGHeLCTcOJBbwKOPJ060awusLwwAEKZzPEkP+K0jYwpdJULWAdQCeW0HTx1ol0qhx5L2wEYuRaoytwfIs/1CwXyJ43GapZmJCbW0EDsSfaQfgGGvJMABYh3ihdaBa1OPaxxTsbRsBFplTCu2cDs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:18 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:18 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 05/10] Documentation: networking: ethtool-netlink: Add link extended state
Date:   Sun,  7 Jun 2020 17:59:40 +0300
Message-Id: <20200607145945.30559-6-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:15 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c529cf93-8c12-43d2-c6fe-08d80af37db8
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4003B0C6A5E509C578E7D4FCD7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69SD8wCfEQBf8bdoSvpNpJhDCMSeDBObMSyiMl0wtTEIdUhjF5xTGeknJrQbra/h/XIcLSeGo5czdGk4Rqti+iycmuX3JeqNBMq9qbYXgHUiPS8mwH1+pzrpxrdsHXoObTDfbW0cKAnh0OyNH2560w3yr28Sk8uf8uHeovCNQ1uZhAsBn/5/FFP/HT+KgIdhgmc4djlAcR7QNrrHHYpyv8hSvkqpI1kXnNZYTEcbrU8XtNKtYNjiyR2HI/JGKhWKfuVmEbAc0DqvAUZ7RbhwAqa75aR3LSN2huUu/6mWPpwSxHXrSwEkVrcuM1oRNGPkmjGLQITJmr/s2Zx/0M14iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gNdhPDvs5TFlVFUZfyRfuv2W8C/YpsVdGmUc6kll9PA4SntVWB1GKJpIMwH/x+AqJheya8AZVq26masRjujUOvdvvLOclGco+xY6cugB70eYbyr/cshR1H4HMjaKXwxiZFdjXR1Q6d9KCdy1prvVGfzTNblivMaynSuNro7fgQRxtGKVOuCjelo7Dnii56sEGx+nOHwI/nPcaHlMaoi+AqEe+4EuHp5zYqgR68vcaS/ZRlJqgv9gmVYh95JH81EqgxHfu0UZ8W4n8F0mbxHMwTo/qU2gKFa2pbFYZXXjUm2TgLnOjFf4dr0vfrIsSwlJ6uel0WOcTb+To6BBNOd8vu0dI9/+cp2AKjlz8zCW4yfyYIIxvAcmL2wmn1Oy8h8SmzYyRXfq2ngMMGNJN3I3q36KuDuRQXxqz+RR1XYDjJFTTuPhxyfzsySP+rXuwYeHWe1pTn/P0hZrKydfwutcSKO+cdhZuDfvLw48CyAW0rg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c529cf93-8c12-43d2-c6fe-08d80af37db8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:17.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqmkXyaJgaQ+fR/xeUuS/VAhXmxDeumUWXVr1ISvr/7SphBoLzJb9oOxmpRm5z0L+0ynUTbZ3cq+JBPRLsqknw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add link extended state attributes.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/ethtool-netlink.rst | 56 ++++++++++++++++++--
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7e651ea33eab..4e4570ebbc4d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -441,10 +441,11 @@ supports.
 LINKSTATE_GET
 =============
 
-Requests link state information. At the moment, only link up/down flag (as
-provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
-extensions are planned (e.g. link down reason). This request does not have any
-attributes.
+Requests link state information. Link up/down flag (as provided by
+``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended state might
+be provided as well. In general, extended state describes reasons for why a port
+is down, or why it operates in some non-obvious mode. This request does not have
+any attributes.
 
 Request contents:
 
@@ -459,16 +460,63 @@ Kernel response contents:
   ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
   ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
   ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
+  ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
+  ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
   ====================================  ======  ============================
 
 For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
 carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
 define their own handler.
 
+``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE`` are
+optional values. ethtool core can provide either both
+``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``,
+or only ``ETHTOOL_A_LINKSTATE_EXT_STATE``, or none of them.
+
 ``LINKSTATE_GET`` allows dump requests (kernel returns reply messages for all
 devices supporting the request).
 
 
+Link extended states:
+
+  ============================    =============================================
+  ``Autoneg failure``             Failure during auto negotiation mechanism
+
+  ``Link training failure``       Failure during link training
+
+  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
+                                  or forward error correction sublayer
+
+  ``Bad signal integrity``        Signal integrity issues
+
+  ``No cable``                    No cable connected
+
+  ``Cable issue``                 Failure is related to cable,
+                                  e.g., unsupported cable
+
+  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
+                                  during reading or parsing the data
+
+  ``Calibration failure``         Failure during calibration algorithm
+
+  ``Power budget exceeded``       The hardware is not able to provide the
+                                  power required from cable or module
+
+  ``Overheat``                    The module is overheated
+  ============================    =============================================
+
+Many of the substates are obvious, or terms that someone working in the
+particular area will be familiar with. The following table summarizes some
+that are not:
+
+Link extended substates:
+
+  ============================    =============================================
+  ``Unsupported rate``            The system attempted to operate the cable at
+                                  a rate that is not formally supported, which
+                                  led to signal integrity issues
+  ============================    =============================================
+
 DEBUG_GET
 =========
 
-- 
2.20.1

