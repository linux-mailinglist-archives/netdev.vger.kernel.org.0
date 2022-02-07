Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B520C4AB6BE
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 09:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244284AbiBGIbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 03:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241620AbiBGIXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 03:23:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C02C043181;
        Mon,  7 Feb 2022 00:23:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178ACxD009053;
        Mon, 7 Feb 2022 08:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=SAK2bulSqWVUqCDX1sWm0a0IvAIJdWUekZd9WSQTlqM=;
 b=SR4YvTOqCwhUkRFVyp/+gATevWqelVt7eNIaLPONIzP+ZIOdppDO5Lmr2XNr7Zn3MVEy
 ngY7/aZNaN0QWRfhyqko+42+Z5e9epkRW8ceyqLgoPPeeSCoHfd7cWDsYHQ8fcK/QR77
 N5pfdchDQgxiq5Zv+6bcQHu2bR4TH5W2WKuV+aBsNmZ4/mwiiUkeI6gdXjJ2chzPxI1g
 nLXcGB3YzdqwZn6Kk5EwX3RmqghFL0PQt6L4JGf13G0RyvbAyGBcHk2YSnoyCwQTN/Ya
 WP3/SnImoWlQQXQmTKJObWA73KJ2+a2UrsdfKK2KYXaThV9C9z+yVztULz92nFUsE5sC 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1fu2ne6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 08:23:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2178FhUN029939;
        Mon, 7 Feb 2022 08:23:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3030.oracle.com with ESMTP id 3e1ebwndqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 08:23:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vuqwcfc+sKrI3T6159zwW4qXu+WInQ2suCRigo23Y17BksyOqUKqyTaw3hK/Jx0zL0L6UwuA0DlZ93pookRXvGqtwAnaxKct/0ccyYb1opebVdxSeqLN7rU8ths0Z8WtwfGfJSgqQmC9EhnWgiamNq5xUajm5VkhDNsqjhZirUzDWyLOUuY+coJIHLgcdUs81mXxg85rk6Z7HCwk4Ci/JiVSNgBWIaJNktc5zNBbOBqgf/SrTS1zRqncrJQcVOunhbgpx9KZ2RnMdPLGiif653OK4LSEGsosBX9GafVRyz2+PX4HBjSsjW/cSInXCP9fnYVRoNnhlEpqG8JY5aXjdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAK2bulSqWVUqCDX1sWm0a0IvAIJdWUekZd9WSQTlqM=;
 b=L1Msr9JywWWSVuXM2dPu17itqHj6bYXEYssO07KjssZHELUmPp/Y/wO7qYJaezEv1U5CtD017To+tBhhOtFT3lGziRlGNiVknjsn/g/01dQrg3wx8o8og7OdQzVZXOWxNeRt9f4nAvkeSEND0xu9Rri0BBFY2yWzJJdO0zPwHFZPRHyoE9GcffJ7R2wLqEfLAI1RKV5WXvCfEE7t1QnWM2ON38Tu3SVExXglXPtNKcIcmbOLa7wgoSWQb7Jsn0D504ifhx3ekYARFb1fV0akHyKGAKvfdBZGeYa6eMAFApi0xJXE2J2uf+36DCFqBcsoIxUQPZtI+99CRhjQxnWZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAK2bulSqWVUqCDX1sWm0a0IvAIJdWUekZd9WSQTlqM=;
 b=TVQnGsKWFzQ9PhLsZ0OjNpIXLV5wOzyq2d7+aQqnldsBExwBtQnockQmnd90obkIzi7vjVymsZHDG/3QbHfW4VkDtQyuVj+V9UH8binCTmwv1Xx1SboqFn6j7nGo94NHP3nB4mWWC7MGtVzZ2mpDpaNt4aDaOaJkXGBQpZI6znc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4986.namprd10.prod.outlook.com
 (2603:10b6:610:c7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 08:23:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 08:23:05 +0000
Date:   Mon, 7 Feb 2022 11:22:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net-next] net: dsa: mv88e6xxx: Fix off by in one in
 mv88e6185_phylink_get_caps()
Message-ID: <20220207082253.GA28514@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0146.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::7) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0df8781c-fcf4-4dc4-7e0d-08d9ea13102a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4986:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4986E1838FF9C176633723DD8E2C9@CH0PR10MB4986.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijuacKKkvi4Gxa7noWQ53e6mje+w/e9qpF7ZIOp9ZEni52L64EamsTOOBO4S1ffF/JPcSwVk+Ne2j7Owuq/EYrjuPMTkh66TFgutk4+6q9ia3/iabeZXhgvWz/j503Oy2WyapItq4x4M8nwgY2srIayw+I3euwsj9tUFAhIQG8quTC5yVAAqk+b8HM8IPppBQYr9HqZ9/9qzsENFQW3VfB9zDCaLhZjtXUd51AQYbObDXCKFRzYfQTr7TN7wTDncKlMVDtQFA46BJR/4cADNHJzDACsNT9dkoiO2h/sz65JwYGA3KMRU1KVA5JwEKedcr+cqQpr6ZMlEls5jJCkxTlDxJ4EX46YMfi8XVoUqrqDdbootL5PF8VfnK6PVZBJdCWRIYiMs2od7dldF7YkXqN0yUP/KKuaSAIfnKWl+gslNp5tjx1sT3t+PDAU6sVtnfDQ6jeUrFo1w2fCG0hGDHcI9DZNNC5GAZeyILNxhTsDq/ZOGPPOAJ2aDwWB/Ivyl5Tu9XmwAG3bAK+tqCDoGM2aIyT+mCn1Cu3rp/o/NgvtjQRJv1tg7zGNk0VyPPtPYxeU578rbMgupZMUgo3mnT6v4wRNixPccT0N/Bd7Hp12QrN0iwbN6U60WLvOoKpDJTjKMQmp+88eA5uSL0ercAgk9Cx/XBwC9u3NhK7sACAEatFYJxU/n0k9bNPDYklMID30cRNE9YRZGOPnpTEBvdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(4744005)(4326008)(33656002)(66946007)(66476007)(8676002)(66556008)(110136005)(54906003)(316002)(508600001)(6512007)(9686003)(7416002)(44832011)(5660300002)(52116002)(6506007)(6486002)(6666004)(2906002)(1076003)(186003)(26005)(38350700002)(38100700002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6vEAG2MNmD1tRlmjKjvLguy33ssz9WJzS2UFQt+P73qEn3HmDq5JMhgn18N8?=
 =?us-ascii?Q?jBHUcLvN9T2qGQ5UI0Xf5kZyCLewr1yOF1+YD2XFLfDKIkpEBm31+XMReMQh?=
 =?us-ascii?Q?qYZ7LhxBQi8zabTeT14qqBWz5xEDmcAvVNMhICqdXnBaYsdZyBK8hBW1HQyJ?=
 =?us-ascii?Q?F0RSLxb6y7ju2yfsaPG9gSOtqSRY8iohyLfPxYJzWJ5xB3KUQKpFW7evyFh0?=
 =?us-ascii?Q?RJLIuCR9QeuWhysA8MklCPEABstrdxunSXyjeOGHCwnWvbzQ9qFUEy3cX1TM?=
 =?us-ascii?Q?50sVR/8cukapDsXe3cWrVZR6fdEaB8u3/TpP7AiKF6WP8SisueOb/ZFfPiNU?=
 =?us-ascii?Q?mGx+negP9BIGjiWfuSOYepA/PS7A8mi5C2TInIJpBD/hY2MvlfEo/gNYFfQq?=
 =?us-ascii?Q?Ss/03HaBl+DdKiFyaUHocPIuu17Jegzj4vwu4Owv2KPQ3xTPwkO24mTm6hwJ?=
 =?us-ascii?Q?NnhT9N25VRXaePPGufzAdEMXI4ghexqtZgJmuFoPLnurHFu0kLuifcbk9qb2?=
 =?us-ascii?Q?zPWsWDv+FcojQR0zttEElhqSJ4Ae0na8r5SVZPOxPj5DOlUFacUje6KrGpY/?=
 =?us-ascii?Q?bwr/LdjCZmOmYaVftZPMB3qZf2Yog6ijfeAJx5wzcpma3WDRRsSUUclQ3Ui7?=
 =?us-ascii?Q?3Vg+bHbr9RvXF+9FiYzKG1Sr8fPzNJcDqeP7OgGqtkjrwCfPaS9vt3GxfINk?=
 =?us-ascii?Q?NUYA5m/bXco3lc3jzPLxow4dHBixhFNJ5VxlOhbaYkmYnj6f3/cCyIMrMp3b?=
 =?us-ascii?Q?Eh5kXzbBVhsg1r3Z9W50t9h9v6KaXzPqJC+OOA8AuxMTooeiWtW71+RehrYo?=
 =?us-ascii?Q?2xGj4ZCoiqfs7jYxve1VcawpUF5s8ghMvlrVOzO5nkpbb0AFhrWc2ziTe8j8?=
 =?us-ascii?Q?uJpf6qWD/MhXS7wkzuWgu3fpL8Pzn51xdU5+MKv8d/cwuQSI8uHsq/sw80TZ?=
 =?us-ascii?Q?T+r2mJOlrXrVV3qP00Z8mVbdhH+/+CXaoaU1pst4xMylgf2JVVd9R2nFO/cT?=
 =?us-ascii?Q?WvCp2ZddOvr/sGm6P8zJxulybTxtmluKg8rJmgmtIIu3FJ+rsmNFlt3V691s?=
 =?us-ascii?Q?dWXnH0p0t/rFxdcG+ml3AcXEbG/FHo6hlG71qLK2Hu6R1oJfOiEl9awy6vv7?=
 =?us-ascii?Q?8gmF8NA3d9L0KZMHIN9CwCWdzFWMEbuBwK7gI4lWKiKWS7u3u0ULc77FQ4pM?=
 =?us-ascii?Q?UzakT5jPt2XXCJiaUTZiPgRncLbPprdTCqpG0IkB//CG2rxJ+OlIXYSXKzhu?=
 =?us-ascii?Q?xUW88A7SfMk/tTkLqvaGONYLpc4ByJD1foOG5XnOQAhcbEe+x9wp7I1Ejiie?=
 =?us-ascii?Q?o6CFglGTOJcW7H9/uUSXljVXFD/yzFzULgzdopGYqrxK+N+li+az/moE7r50?=
 =?us-ascii?Q?TVhnl/+aUjPOk0ny/iSC5c9q/3rLQSSfeZjfne2hyMgGlYb/zG14djc58wZ7?=
 =?us-ascii?Q?t/ZwRsOLkOiyoKh98HHwvzMY0gi9hVH7HcYjHZ4wSi3HaKpXZ5UW1eQeji94?=
 =?us-ascii?Q?WQCIYavC+N8BhR9rp3SZ+s5lAKO1bJugtszEisiwbNZmWy1I8/AB1H/e7yfp?=
 =?us-ascii?Q?9SBkAtaZiUQJss7kouQ07akc9FzrGnJAu+4du8sITUaxFfF54Qk2/JSKTAOP?=
 =?us-ascii?Q?8xtIhjRTa0FM5TMSLmYFwC998ypCttmeFmGPklnK2Q8vQZ1d0eSxnIS86uWo?=
 =?us-ascii?Q?CqzgQQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df8781c-fcf4-4dc4-7e0d-08d9ea13102a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 08:23:04.9259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMTQ5kp/o8Tyx+rP+4UBIBAYWSDwThz0VG+Col1553ABcaO+6YggHqlelUIp5AQMN0m9hRYjdfq6GAhmOfXouEAbvsB8wsNeGdpFUW+jUto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4986
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070054
X-Proofpoint-ORIG-GUID: KkgBuoB8y0liUbBoDrR49fwunxqqpefM
X-Proofpoint-GUID: KkgBuoB8y0liUbBoDrR49fwunxqqpefM
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The <= ARRAY_SIZE() needs to be < ARRAY_SIZE() to prevent an out of
bounds error.

Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7670796c2aa1..192a7688b4df 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -585,7 +585,7 @@ static void mv88e6185_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 {
 	u8 cmode = chip->ports[port].cmode;
 
-	if (cmode <= ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
+	if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
 	    mv88e6185_phy_interface_modes[cmode])
 		__set_bit(mv88e6185_phy_interface_modes[cmode],
 			  config->supported_interfaces);
-- 
2.20.1

