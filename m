Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27EC2EBE59
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhAFNMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:12:08 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:48736
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727021AbhAFNMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:12:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1SjZEcn66/ojufPv6iAHRPE/VlCYRtHZnCemJT+Cs3q6NV7HFuDOne6SSJdzsR/n6JXDJil2Dw6DU4NF4xgQHlY7+ADjYHrSgx0FQbWngQlfrgT0n20x4E7PQ27B3CztaYKwNXkIxBfV5e5ROkEj3HxZliPfrET6il+ACSJGdcqaA54dSG9ccgyFFetJ5A05SQQorbhZ+DkFsdOZEuV2at0tQbP+VxtaOkdy7TNnEHJqNcGyPJauc8KTFZyJ8lbhAc9H9QzWulbg3+y4t2hTc7iTcSkxEeDKnK5/fsguKJ6jLHFf1lJ3dxzIITxmwABrBFx+FizSMCBglFDy+p1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPIZ+gK2HhX0CnY/Wbars+Enryzwai+AM2LXSnSlQ9c=;
 b=F2g92dS0mMWtp9+frLIAmzSvFaJc8a2i3QjO6ZL5to+d2hPsgjUm5rOW+UVKMTsIHRUhJMGO/OfcnwZplVQRVOaxmRKHFDzXXRsbQWMyoaK+hgJDrjACWiMUO7kOCSNiHKWhv0yWCCQ4h0xtPm/wnmA+O7z7XCNSE5xOmfeJd3tZBvQwkPHzsLJJ/xriYhzCWwOwrhnsQgKCBGSpi0vd/pVp3Z8exuSAdbU5c3hK+ePf8lzMg3E928TI8OcAPhJ+/lKY/DldzYW+IZrW7d0A8yCdERgsmbGTTRO178RHPAGCn4LHkrFRbi6g+SfwFGzYGZpDt/8GhXy8E7qr9TlPmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPIZ+gK2HhX0CnY/Wbars+Enryzwai+AM2LXSnSlQ9c=;
 b=pJzzg9b/PiVnDRH/Kd9cgQfU9iQfwMhWQ657VIHBD2uiuuV2OraSAhB80pog1l9DS48HPGIJGvdhdpWjAt1ykNq2XLJuq1tgFKCsEEPRR+2gSQpsXKHnxf325/BFCtUcvBpxpMFHIo9e6AezlRsuCoTSkVCccvf1fuz0IeKc25s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6418.eurprd05.prod.outlook.com (2603:10a6:208:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:10:26 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:26 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH ethtool 4/5] shell-completion: Add completion for lanes
Date:   Wed,  6 Jan 2021 15:10:05 +0200
Message-Id: <20210106131006.2110613-5-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106131006.2110613-1-danieller@mellanox.com>
References: <20210106131006.2110613-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f66ff544-8409-4271-e6ad-08d8b2446f5d
X-MS-TrafficTypeDiagnostic: AM0PR05MB6418:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB641879EF8E7CB81C57B04692D5D00@AM0PR05MB6418.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2vNsZOMTIlXNFILkqRMwZ7JrnqAI6iw2BJ0vFa/s+JmRHDTTenv8rfScNKkfGPkWoVuSo4kbtb5suYYlBQGyegOzzvJ/Ct68MYD5hOaE1oHtl34n4ECMwLI+CKBfY6b9Nx7j32Uw4FUhpSew0YV5ATOS7ETj/mj0hCSWiyvoiSF+RloMZvwz0gfe710gJQeT7CRlwJV5TKo58LPCy8JIEQQKq01VghDDDAIs2vLtsIzVtTBvwqjex6GteV/yz1N7zKkfXu4VPL6fXlZ/cXcWosDLECXXn2Bki9R+aKS4mIFjPZt4ycRz7HRvVKTUjv9PmcFvahbBABBrU4+vAI6OeEN5rqNe79z0/d6wIYbkOHJgWbTXWQu5I4K3uImmax+rpQG1jjtLCXQ1G4p4PzMOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(4744005)(26005)(8936002)(16526019)(186003)(107886003)(6486002)(6512007)(316002)(6916009)(5660300002)(6666004)(4326008)(2906002)(6506007)(956004)(2616005)(86362001)(1076003)(8676002)(66946007)(478600001)(66556008)(66476007)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Cb65zsABIXwsvMB7QPerYkSUUw0Ws0SFHLGkB+ZI79WBjydBCDLASYMCbdZ+?=
 =?us-ascii?Q?jroIwlG0i0B9TQkSCu6z5yZWtrmpL1EcH71ophpSX5OnP8DUI8juCPFGk7Y8?=
 =?us-ascii?Q?zB6XspNli0xVGnK4T0nUFdKfuVB+V53WKOtjsyv0kIRxlUBNDqBJOotr1xXi?=
 =?us-ascii?Q?s3LIJJjz10g53li0UXCHMpltaW6is9peLzcqWpZjae8kV0hJH2SIcq41JK7I?=
 =?us-ascii?Q?rhJ4dxvqiPA1R2Tz8HzBA1dRXJU5N3WkH+zxbqqAKHbBQfC9xHW3S5zP3bKY?=
 =?us-ascii?Q?l4FtVuA5QtS7ERxRG1yOKaOUCqCb+9SIcbygIEWyGJR9v9SSHE727S/GurBz?=
 =?us-ascii?Q?NXjMeRM3Ee65QqzOPUXza1Kk2AGSbOEHAbx99JAdu9cmxI7COmeN0TWJlkJA?=
 =?us-ascii?Q?cFDINZ1HD0SnsunirUY9UGmNAsBFv+PrbNrpxDmAYrtVfaT5hC9EgbQ4kW0T?=
 =?us-ascii?Q?QixSUKT243Ahn8O92vNaq8t0hRHAtuTGMkhzsUffDCgWjOiGCVrVJuzXavOG?=
 =?us-ascii?Q?GSSUsj2ibU83KWJef9pm8TJPPiQum8bEmRil77hmifml2jlQgYyRxOFzpOdo?=
 =?us-ascii?Q?nicH/3xHREx819Kj0AQoWj3/NngrJe0mxe6HQpvGbwiUDB+oPSU9DLJPbecy?=
 =?us-ascii?Q?GpykUzriopQgi5oU8LtSN3hQrVXyG8HzvFbT5bXP/atMMuBes0FKOmCPa0+w?=
 =?us-ascii?Q?MmUt6gez9dEpLzfMvNLVMwgaMq1ZVC720+3iiMm4qN/outkta9iqd5Oua2Fg?=
 =?us-ascii?Q?zcTdCR0qkZqSBsdrm2vIuenYEGN5l7MDhg+lZKOeBj2eQigeaTpVcgimeZN8?=
 =?us-ascii?Q?0jreGLqbdW0pQKv97x7zm/B+E+RcdFYmMO9UHcGmFtxO4DkmY1CXBm/r8XKk?=
 =?us-ascii?Q?ZBYn9pMSrpdOEKxjO81x15hlhfhpwWgZW3pRTA1QZ3m/KFEmTzSabKHpO6LU?=
 =?us-ascii?Q?sUnI+jY7VvBqC/gvVQAyik8U9rsDkZK500AsWuhjTUI0AAcUoZPbgZ2KYiHh?=
 =?us-ascii?Q?LHmR?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:26.8630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: f66ff544-8409-4271-e6ad-08d8b2446f5d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48HQhft4Ejy/5s3rKIodd5rM1qQNjvFlyL5FSVrjwRYq7c2WX3ikknqNxviNFPvep9QONu+omTXkCQy9YoFPbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lanes was added as a new link mode setting in ethtool.

Support completion for lanes when setting parameters.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 shell-completion/bash/ethtool | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 5305559..4557341 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -97,6 +97,7 @@ _ethtool_change()
 		[speed]=notseen
 		[wol]=notseen
 		[xcvr]=notseen
+		[lanes]=notseen
 	)
 
 	local -A msgtypes=(
@@ -175,6 +176,9 @@ _ethtool_change()
 		xcvr)
 			COMPREPLY=( $( compgen -W 'internal external' -- "$cur" ) )
 			return ;;
+		lanes)
+			# Number
+			return ;;
 	esac
 
 	local -a comp_words=()
-- 
2.26.2

