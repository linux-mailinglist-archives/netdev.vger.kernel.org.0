Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746AD33F758
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhCQRpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:30 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:58097
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232478AbhCQRpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C14YoO1JSTLUMR5q0NN4vsHfbVvWgyoJtNtXvG8m5DHGNxjESNQulYApNWx1NlMxgtaO0GyE2OvmfZ+s0CHgnREflWFBzBdyWYXTe51+vQKd6lymPbJLpY7c07UFInPZ+9NVm6wGou4Vhz2gsdeqM+sqYTkuF2IAygSOect0G5zh0lef4zb07eJ8TG1IyjnH4pw30BstYJpsUMJVi2bao38jInmp03FbhO9+X55iaVz17UEiulCM2WiV/WPubUBhS/62L+ZLXlFWzxXpnjTNHM/3JJxpknF2kVHzItLQ7b+xUPiUQFt5Cuy3zkqMbjgNO4Rki7zuHwkQxSKVSC8yWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5wcGEJ07XR1ymkJju7e9Tj3ME9u2rg67Z4wU6Yh6Wo=;
 b=E2AgU7iLWsMTj45KSZX9tQ6+ArUIrPM9KuwJcsvs8Lb4gohQcVzoPGtAyVgUrzrEB/CpzSC0KTl6BtWUFGzKa+DRkxupcXc+wjugFssKAfZDi9Cv3kub0kK0+r7dG7mPya/g8+kOTF/q+hEwWIoFdYnD6aDezv662XDDKPHA7F++GoyFNd9kRR3z17Zfz3/PJJkJ6bGF5sImwL5HH3XWP1NLeaHgl1B5dvPnX0EHLWSQmdLQ/BEPJuB2gPU/3jgajZVLLmX97HI5NDQPii3l+V8CnfUlXGK1YL8Fvnjfrt+YIdZQ6VAIVb09OtwTZsvmOCPLOsoNqq5aFXYkLKBD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5wcGEJ07XR1ymkJju7e9Tj3ME9u2rg67Z4wU6Yh6Wo=;
 b=M1pqT0x5MuRpBes3K/jj71FLYMA+zePcklUgg5asEraigrextPGO+BKIuUlfltdzA3dHYurKID/KB28Q/TefG83Eln0Zw3lvE0rBP3lTtRV1QEjSci64IN6wbNZpuvDWYiWuE0awe/xid0ZRY7eP+Y05I5izIduf1X53K+XImRs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 1/5] Documentation: networking: switchdev: separate bulleted items with new line
Date:   Wed, 17 Mar 2021 19:44:54 +0200
Message-Id: <20210317174458.2349642-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a8e756e-831c-43bf-bd44-08d8e96c6a61
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB71191CDB71A360BC6C40CB3DE06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PajYJ/hTPb5LFm62G03TBR5SpIgAqv5FVBLPHdKpSRheiSULWkhNmov4d4pQB1D86FfeXbWLrRj/Otetq5Dkh2GelvfFDe/v0guZmcTt8ZmzlqY2BNuO9z5Zqmv/wZsdFueTFdosi1ZpQAuvWiEnx5VHbi2OJSalNzGNuIWRyg8fOnHair01iDUAD+q2VZcJlF/K6aODIooQrkj3d+t5v+nDbdLWUtHPouMBc4avrK5hMKtnif1EE4B7U6itZbVkwZxTXgJo7iZDLrkUCIUi/bIyv/HZ0U+zq3HiRT7YZWkEME4nLLTW0v1P3r4nTi7vEgFi0Juxp6VEFmjXzSPe3oNeR7oHqgWUKYtZ93klsLrJK01XnFFNhGyCEjvY6Q5+A8AiUBF8iVpKikw3aropLijVFSpgK/5FG72cO7H+sMX6KB/WtnVU9k9WSRE+zFJSaZwfbQKYNI+t9+c6KtkL7F/6UYPXN0g4pVY9Zr+trFAtSZakqmw4mn7HBL2I+UTt2Oh2i1viA2qgbwGAuwkrmjYxzI0nPo9BXqDrADYL5EKD7/gTYm7lwtVkY+iJl4qF8CeLzK6BuYneuEjd/Z5Q+xxbjLqyPN6M2atyKZUXOyIYLuWkyyFj9HZRG9kLzskX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(8676002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7/SVE2puIRwQA8G89TRtFpCD52lroqT9tXgYrvLvCpoEXfzqiF9AHEcyDft0?=
 =?us-ascii?Q?Tdtv7ifzHBC4FJ+UZe97rnSHV7CQh6cU8RPYQ0OrMnOnI02AxM0O4RIY1oge?=
 =?us-ascii?Q?KpWT+FFE6TZXT3JblSehcXK2VQRUa0UL/cE60cacziHlGPu/1OpVDxSVzieF?=
 =?us-ascii?Q?lAlxMCid/hr3Mv386JcaAWlT3MiJSNuUXNH+l2awcPY7NySSGZ3FtRWTjuO7?=
 =?us-ascii?Q?WMmZ1yHiE7vzzSCY366870Q2fXnlIydX/JJ8FacvWdVm0/f87wnPQjEknfEb?=
 =?us-ascii?Q?nSCWevRS62TK0nJuHQ4PTQhc0JehIhC730o/Uz7iyfwK/ZcoaB9PxdVpd+t5?=
 =?us-ascii?Q?KyAVhYYzdqAUbvvI6ntDrdhlIoTj1Hs/JtZO4wK/XCnsl+NSZrZ68TSBp7Ho?=
 =?us-ascii?Q?/iswHo5HGFYSh46Skt9Oa19EKzPfSxvD7XbXDOQt++Mh0RuH3cjT/b4l40Wn?=
 =?us-ascii?Q?B1HEbLuXdO+9H7UKoOlZ446pTzsXtyZvBikUAvWfkwb/1mIII4Tb6Ah4/pt0?=
 =?us-ascii?Q?8rjrRGmrUYmx53SRpnz/aW8pQBhNu2ZjNGFOCJoUYL+HssSh8oy0n9/QdLDL?=
 =?us-ascii?Q?cApuluMinjNMVG/CvgWrWNGK8eVTiwQjtJ78DgsQs5wMGrW1N93Qxdv8TlTO?=
 =?us-ascii?Q?HB6OzGeSA+dqBNPWVuRBDOkwlUZtkwlbvvRigm3CYUYl4gci1vf4IcdYvdc5?=
 =?us-ascii?Q?H2eLLXavhBYdrUSWcl8tNRL064gcaT32CRLdb0Vo8hLmcJ8gdP79nXd4uBnX?=
 =?us-ascii?Q?7bN50cRb/vK8RWna6E0BPuHlPedEHTQ76WkkeU3eYDlwG/QDloWv2AJmcOs2?=
 =?us-ascii?Q?VJB5mdTk108VFutjy7yz6yj8rUQVHsnrePDeH9vRmZtjvp9g6c4z6TsXmKH1?=
 =?us-ascii?Q?VgqOwIOwAyHnK6HJfmX1essO432O+fVpQQB804JpiKaUv8iAGrDXhCPo9Egp?=
 =?us-ascii?Q?rDHGiK+pYCzrdKHoSIYKh3w5OuuRviCCv7g4+Gww/9Kl626S7r4VHUinZCe3?=
 =?us-ascii?Q?OnYrTLt5/Ao2Y4nPF+TQkvcxqkPb2MWp5bsB9TTyQoqqlsywIUvNaTawgsBG?=
 =?us-ascii?Q?vL11koAWlkoWcX97lZX7nVH61kC6b+i+enEyX3zGmZMNXtrGD7ztJ1LPHi6u?=
 =?us-ascii?Q?g/gJcoR8tExHe9tWhjH3QgByIS7QTfLkQrmwmCpfA3QZxmChr+EHWjLsEWuZ?=
 =?us-ascii?Q?EOf000h7BOOsvuP0GAwPUr5k138xVDyKEzZLHA9zBxtB3UZX7QUVMMN3xATS?=
 =?us-ascii?Q?Oe0GKN88INpO+FVU9x0Tb8/zc/jDRxYkopRSATn2vAHBLB4OBuiL8wGHeA5M?=
 =?us-ascii?Q?uKrlGU1c4iZD/7AVsfAwMpRF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8e756e-831c-43bf-bd44-08d8e96c6a61
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:12.5334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juy4qgvUBE3c7riKA5QB5dkbBJGJomBrzH+9V2bvAiT5D5ToSnQsOJCMYq1BuvfACbCmWaanqK+zdogZ4ROVVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like "make htmldocs" produces this warning:
Documentation/networking/switchdev.rst:482: WARNING: Unexpected indentation.

Fixes: 0f22ad45f47c ("Documentation: networking: switchdev: clarify device driver behavior")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/switchdev.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index 1b56367d85ad..aa78102c9fab 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -479,6 +479,7 @@ is not possible.
   be added to a second bridge, which includes other switch ports or software
   interfaces. Some approaches to ensure that the forwarding domain for traffic
   belonging to the VLAN upper interfaces are managed properly:
+
     * If forwarding destinations can be managed per VLAN, the hardware could be
       configured to map all traffic, except the packets tagged with a VID
       belonging to a VLAN upper interface, to an internal VID corresponding to
-- 
2.25.1

