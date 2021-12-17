Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4128B478564
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhLQHIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:08:25 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12454 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhLQHIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:08:24 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2oM8W012922;
        Fri, 17 Dec 2021 07:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=JHkz229itE7g5GwVcQ8KWWS9WaAWiyorqc28FYRQ0jI=;
 b=TxgX3Lg+1F2/9Efq7KjX1/bJVNWB+tMhULWlQP9EyePyGbPpf/pNUcTI/eJBfWfVT6aQ
 YIXbvUs0/apQEPg4Aa0BjYbX6zOYVcx+tP10uX7Wwejd7ElzRLfTFBZKpMyfXcIqCIDn
 0L2TOBB4CeOcozsSBL1QQKdi/rWphQifxHEpsOCukfg2W+uWqyltC5nMTRwsVTpCgrQs
 3iNd9LkePo9nEBkAJcdIl+pUpcLUPzEMAwDuac0Dlh2qAxteN/VepSwGHMUjIcODovE5
 HKA9UFfSoJ4RyNt3HV8gST+qHLu27OWvzPK9Qwd0LDodqbvxNeQyJmQ2cvsensBPl4Dk sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknrmv6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:08:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH75t8J122130;
        Fri, 17 Dec 2021 07:07:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 3cvnev56jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:07:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nzr7kfMUYo6jDFWJvJ3HdghSgO7/ms/uHH9C6zprL4Y8U1QEtJC/i2t2F4gM1QNxlxZXAOw3M/XIDcpR+pPmQXXLWam9AWDU4FL6JR0vQ+EV8j1uCxppebhBeJIvbR9RiXAoXqERgsIJa6lN5fPHln83svlxcc20tB9e4s/1YwoW0gABAKmnc0gPkt5amrYGBT5Lo/eUzRwTBD6C2gAvti0iqI86ryLbL8kKKTFSYGzpfan4hrX6UM3BvectqLLo+VcjKUWVquHRsPuDU5OrTii2Uit/PvUYlQMSk4aDVrK3zorAUp8IXg390evU47rWiSaBs1aPj3VjvkiIpj59TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHkz229itE7g5GwVcQ8KWWS9WaAWiyorqc28FYRQ0jI=;
 b=fDDItrREWfAisx9iMEq39XS4D+zGs8AfQkYxeGnXr4Spv398ffRpqLMfkYh2MK3zDafqyVSEyKYlcfo42fsOxE6Jv0oEcaegfIVIU0WMe13BZTz9t1Re/23l/wDaLYOLuPDE6THS3V4jIQeZ29cKVuoKdhfkUO4ESYYJULLnhaBlpZ0Ax2MmjLN4hmBk4ua/bppDRzObL4pzKtE5OUb+ecgf1himpfg3nr5PFUX5xPT/Bxf9NcSvnF1Mg1rFHEaxYVbm6VMU5DVEGgaJmyrEIIQ+XXgG3vA6FYoAGCKC5Fko1x9xxVHC5urHzSROcHFi3/2KZsasQMMcOkpEFcsFNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHkz229itE7g5GwVcQ8KWWS9WaAWiyorqc28FYRQ0jI=;
 b=iY/uIeB6GREBxuwNRvxuZlrfZGF5cjnhrPS2SAQ5lcNpp/ODxvIMZsVx9ovUe2CNVtiYrf/L8rDSx/uhwiFzLdZSVc20mhwgvfIDaKUl8kJkb9+Mj5Hx1qiQPMRwH+24I8fsanCLhydMKv0r+tpaNjVMopWP443Boj4nvwucjVs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2367.namprd10.prod.outlook.com
 (2603:10b6:301:30::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 07:07:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.016; Fri, 17 Dec 2021
 07:07:49 +0000
Date:   Fri, 17 Dec 2021 10:07:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: mtk_eth_soc: delete an unneeded variable
Message-ID: <20211217070735.GC26548@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d56c6da7-6ea5-495b-da1f-08d9c12bef1c
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2367:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB236779B55592080AC8EAF7D28E789@MWHPR1001MB2367.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hyd+cCW42Sq8VAqP5eoxEv5xIOBFYMxLq00eo+GeI1urVrGMJYrohxPXeJdZYxqpTR7tE657P+dTw1OArDXsofgOxba0RbN5hx/ixpZZ7Cc4Xzo4xtPXIb3BzlR+zGE/VswzaL0mfjIWkQmI5Kj7Cv+VFPHjSyL78eeeUbnmOfYzl6+P4kOkp+J6RRs59t1LpYECz7D6QwEavfKB4my1K3SAHBrzrLXqlUfTqFP0Z6UWOOK4GKeu1CQQJE4x+iQyvIH7cXVffil0VkpG2ZLWr4wc4tLOkKMUdJxOUw5WMGnu4AwIzx4LX4Q9SZjNxjz9+CV/blpLP0xRnrwE1QWntEjNO33Brj6EL+q8a+BZGe7vfAD83EyuQc+g/c4AtnCdELxN3WLaxadx5LvtQyqHWzmlwhZCWFW35eMI9CvCwGx4kTbPZFxf5qsscMJFHHb7KIcRgH2ncgmnjXKk81mECchPlMY/UYmnL8jdxcEHhnYUIsQNe7bBcYYqn1oBdcgjiWwksfViGJdi54qoppyeSP58iMElLpmQZfoFPKxxX6D1kk8UJroVc9xQD0yZMAb/QQyFNWbna9SMN3LVsAiSaEhQ6JIG6+91shGOQEiPVVsXdvCPPf/ZB9GmfkpyPupKr9vEF6fBXxnES37F2Z7eI2SnE9OZ/Rq241UZV6604AK4U0KgsJpjrgLDXFC23uSSzatOpNH242HNtDfwCjXnAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(508600001)(6666004)(83380400001)(8936002)(66556008)(44832011)(2906002)(33656002)(66476007)(8676002)(66946007)(186003)(38350700002)(6506007)(316002)(38100700002)(7416002)(26005)(4744005)(6486002)(1076003)(52116002)(9686003)(6512007)(86362001)(5660300002)(4326008)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2fW2y8eRzQR+BXb4I2Xlkb0CM9rCD3i/KOaknjlwGzADBUQ+dMkjCTEswJuk?=
 =?us-ascii?Q?v9+Ifg4V5BeZ5A6FptCKeqXJrD/6mow4i5RdNRG5YyWrvSXCzVh/+56eD5uM?=
 =?us-ascii?Q?4te6xyp/hHoLgkUo9WlEW0I7VWdSDLTw9YKDCbjZM2vJotwi/POUN16O8kTE?=
 =?us-ascii?Q?WLbtsOHc+DCfqq7ZZuZ3+Fl7OWKRUeCL361ycnzdrgvHvm+IEDiBhh4HKB+q?=
 =?us-ascii?Q?eFvFMF1QPPLxt6isI85VPIP8mp0jBDXKB5e46HFkoff+JVHHcW/eFJVy/tuf?=
 =?us-ascii?Q?p/OVYHaNUNHOQnkbBuJgRj7yC0xPo9KXWp8HgGfLUKflr8TpOeEIHlFwOGs7?=
 =?us-ascii?Q?NBW8TJ8cmzRm51p0p0gdN5eiqPE5i5XJDFRlZylJMyEaVEqJ6M2pZKowoogd?=
 =?us-ascii?Q?xQ3bcMe01Hg/4yBXHWXobpszwSQeSAQ2+PaoqA1SGAnlX4LwehB44Zb9k4kB?=
 =?us-ascii?Q?Mbgtbu+zb8wrBo/xMtT3lXp/Te0pQ2mrk+XE93XFvHIk5Q0yhxYTD8QzCNkT?=
 =?us-ascii?Q?PDnvWXjwHKRl7VJ4FIpF4B92fJEPZOzq0220pYG0PnjYzucAnAO2z56iuY8t?=
 =?us-ascii?Q?+6YXhDUrd7DhQbRX8A7geNZ2TmBfpCwHJVA5BRTysnY134rb8VgCfXG+SoNx?=
 =?us-ascii?Q?ECSG6FJihHGJ01W2s60IXcNvYWIu2n9xlca9CndrwEr+RHs9QmqsKMNDG0p1?=
 =?us-ascii?Q?adwsfthccSB0sURfKEeFnu1wI73w7wZeGMFcCns2/pYy7bGY18mbSRyDLuJj?=
 =?us-ascii?Q?DL0kYt2eDl5N9PrZ1hH25RVsyrF2/Aq+u7QF0koBpg0wjTyY7lWR91RWaThx?=
 =?us-ascii?Q?TV9DWd3ZXnuzMHbOdK/0QdsQqefhZPhKNiEE4gA5uSw4vNVOzTOt1NKKQddQ?=
 =?us-ascii?Q?exmKKcKRhydhEwTB92TZ+nz1V0k+0a+xfoQzB5YS+IALlBGtrrBQpVT8AhPt?=
 =?us-ascii?Q?KD6Wh73bUWwuquirANpqmH6CTTNaK+L9QUR8Or7bH8kzFZpjVP+FutJHojm9?=
 =?us-ascii?Q?1+DBIE5COYH6SXovFPPmDaNFI6HoWc8yML1Ozb2RqmyTxU/T5TZOaTRtOzDv?=
 =?us-ascii?Q?5Kp4z1llrxH0DcrOcgcW36+JGNFOuE2XSCL32JXC2CRzGFO3lFzto5ROEouk?=
 =?us-ascii?Q?fO8lq1AG2VX+JOiZLPgwZfrAzZTQgfH8fWB/Y3vZT9AzfCgwowIVXtORaZ2m?=
 =?us-ascii?Q?aUUA8IGOnl1V9Ds6sbOnsXtlYJDkkOtdUkxOGugRf2cPCK6fd1Aara6Eas0+?=
 =?us-ascii?Q?iQD+SwZ9d34ipnSURwfwsZcdQIIIguCin4xKE0bEDw7ad+axpZxGqUGFJssO?=
 =?us-ascii?Q?JNgHIth0pm7hLEo+3NR4PzuUz3XwOK8G5eX1AfnSSpw8vu3L/FXy8Qtr/x4A?=
 =?us-ascii?Q?v6Y3TFjrRW6sJHHIeEQvfUwCDgKTpwrzPzToxccDQm6dAPHxsK0IXh++aknn?=
 =?us-ascii?Q?5p7LdgCdoAFLqLHZOZjSzcZMUNCyQ0ENWaweAF2u/0TEpxrxHxRyOqfoAuTj?=
 =?us-ascii?Q?d3vU8iUJLW+D4TOSRs5e5DOmKBfUqIcFyKdTCNmxsVdvCyQZwXPfdPYtiEYJ?=
 =?us-ascii?Q?qKoRleS5ZCDRPRwx96ChZSpLNyYVXQES77Wu2l/L8706JaaxgHRw3T6hSqT+?=
 =?us-ascii?Q?JIxeRJH1MvA49xPdwkl26TZ/vw8GO3DBqWunFlDpbrg2jLhPw0OAU8PRXbh1?=
 =?us-ascii?Q?ysNqgnX6OSa3R5WFMPMA5W13cfM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d56c6da7-6ea5-495b-da1f-08d9c12bef1c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:07:49.0504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCo9SRtM34O0pHheHGn7qJs0e/J+5Qyjut3GZ9Xf6tVDeRdCppIQPklEmvWZPjmTiw07to/HffYZ5EUChwh5p3l4PGhTg/bkA4JGtZAgoxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2367
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170039
X-Proofpoint-ORIG-GUID: gavGfaLB9EGLxmcSybuACXvRYuG6cKEG
X-Proofpoint-GUID: gavGfaLB9EGLxmcSybuACXvRYuG6cKEG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is already an "int err" declared at the start of the function so
re-use that instead of declaring a shadow err variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a068cf5c970f..bcb91b01e69f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2211,7 +2211,6 @@ static int mtk_open(struct net_device *dev)
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
 	if (!refcount_read(&eth->dma_refcnt)) {
 		u32 gdm_config = MTK_GDMA_TO_PDMA;
-		int err;
 
 		err = mtk_start_dma(eth);
 		if (err)
-- 
2.20.1

