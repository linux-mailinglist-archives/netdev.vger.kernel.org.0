Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3E1228687
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgGUQzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:55:32 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:56928
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730110AbgGUQyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:54:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJeKN1fo+Iquf0wVQqqgSuhudZ42dhHa4+MqS+83uXm0VpPNgfSRiRtOMczrUwd5qrd8pUsTgNLpUrot5EhoSEBfQ3u+4pev/RJxcWijVd6sSP6QI/6Mo5bTgEX+v3/AKhDQzj47NZ7ovqTejDs7Td5qDdO0vesdtufQRjMwflG3hrBeKurgiFqlVf8yzINwjr6o+W0rAurpNJsw90R4pRIQW8qAImB0uK3JAcn94LqhLjRUep+ZT5sjhYRgOmwEMPncQKW3/Mv0QGD98QhkT7/FnKtl9u+ytSvhboTnmilBoT6eJhVXqbkaqemFbqLV9vte9DKk9eNzxLK+94fn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk5smDIIsCCAW52lKEJxGH0DrdOE8DaTDVgO54U0q4g=;
 b=en7rddHqLB5cIDhRx6yN78RQo3vWb4Y/I0XWwjVyNghkc3Xui+vnYi8Ni7Vzpoq37qapJa+GQaxfU2WdQf4aRmJamS1NLcN8NBYx6cVlLCDyEote3ILSZNQG+wnWZfqVF912OE1E9nDgK6Tv6vh1ANp643ephFshHmoYNMJIEEZ28+ggJ1QwTJ6iaK3J4DjOf7nT+ZCKYBlOXkIwBqoZj4bhYb2RU3krhR8YDtv0y1EAKk4EzGpTyqZ7nMMookofvrUqxv6eZU0z1V3xiTG946pQCY5NYRQfspkq7Jb/+pqriVP+Mywp0enPevsz8bfX4jGZnl4lrP/tg39rPZ3uQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk5smDIIsCCAW52lKEJxGH0DrdOE8DaTDVgO54U0q4g=;
 b=DFIxVSpQquUIFccM4mYMGZi+eXhj3twi0IScskifAm6WgnU48dm3lTyPzNuJhYsobjCnfS1ROudu19i9YwI96rvc8kDxixWDBMD40HIDKupyXnLgvQeGyAus4Z9TbTg82v1Jnxav87XxWRyl5rENfJPJwsoaEC1oTqGX8Yf9qRA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4739.eurprd05.prod.outlook.com (2603:10a6:208:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 16:54:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:54:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 0/4] devlink small improvements
Date:   Tue, 21 Jul 2020 19:53:50 +0300
Message-Id: <20200721165354.5244-1-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:208:be::14) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:208:be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 21 Jul 2020 16:54:08 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce7c480c-4bf9-41be-c43c-08d82d96af7b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB47394B9410BD133699EBE56FD1780@AM0PR05MB4739.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QQlWJXHNXCdkXyLM4QDqrLGGCsL7X3e+9IyGBRcW7qQcA8JglIP/NcnuKrP8dkFrky9S5v34DWMlsW3f0jaMjU0u6Ro2AfLo1qdv1eiOb2m7EhuBWPHRFI5KztVnlgKb2FK1Kjh8xENYjT9JZ5NaXNF8rgALny3DuvHqsUPUjIDy2J8V/XRR6+gDwXMIxrIyIr6NiHOBcxhV/fKiQFmJVhOoguauzsT/vrHS3WbfvyxRt/icBjkdKLolkJ5jhlm9y8wenHl8X2QtgOf5QpUH0rIPDdJFxSWA6qWzJN7RFOqealqZ0GKz9kor08KC6hbX5edmIFRC+OwiV9WXoWU4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(1076003)(66556008)(2616005)(956004)(4326008)(26005)(186003)(16526019)(107886003)(8676002)(478600001)(8936002)(66946007)(66476007)(5660300002)(86362001)(6506007)(83380400001)(6486002)(6512007)(52116002)(2906002)(6666004)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gUt/eXNK0h1g2Lt6hOCUNtbeyT/e5PDXl+q7hWt83HVB8tdDbu/Dk+zDITfoulL9AKGAe+vk8QztrSZaA7fAqgeKiTEtagPHj1nXu+OSm+d6HxqMnnvMkHwVXh+jBPRilUPrTiprWNPza/NHkuE3XOWHkIvz4Bxx7WhBtXta7GzscTRAJQn+L8KeLJSlhoOIoY8FA7I8/YdG5/044cEKQF6Rxp03/ldWXrJQZ2g2OHo4fpT3t+lEyhivNnHIzyfbohH/dl8yAPmT88SzvtNMuKTV2yfy7wZr+uVdl+UmGNQLGYl8I7wyI4vYLaN3FIGirEc+QN5ySqaIfcDIHkICYHK8LPCHTNDf8DW1xuB9z8WTOEfSwXE+KDScniaLAUbNwPCbtwjQOOx0A4UxvlHBLhm1YFBTVQDv5BLcx7E5md/RKipJqeh2NB3yMv24NwJu+XlEg+fGTWouPrERhVV3Tdp6gn8tBJG7dsastBGEHL1xFPW1Rzc0X36HBf3m8uPz
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7c480c-4bf9-41be-c43c-08d82d96af7b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:54:08.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ke4Uf63DCiQr6fuLdvX4k2Dxh98kuH3TB28bTfxx2NfEE95FJl5YEbLU0/D6K/tCB+R8UjVyaTZakzmGVD8Vaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

This short series improves the devlink code for lock commment,
simplifying checks and keeping the scope of mutex lock for necessary
fields.

Patch summary:
Patch-1 Keep the devlink_mutex for only for necessary changes.
Patch-2 Avoids duplicate check for reload flag
Patch-3 Adds missing comment for the scope of devlink instance lock
Patch-4 Constify devlink instance pointer


Parav Pandit (4):
  devlink: Do not hold devlink mutex when initializing devlink fields
  devlink: Avoid duplicate check for reload enabled flag
  devlink: Add comment for devlink instance lock
  devlink: Constify devlink instance pointer

 include/net/devlink.h | 4 +++-
 net/core/devlink.c    | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.25.4

