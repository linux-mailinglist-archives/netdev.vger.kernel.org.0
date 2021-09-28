Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2B541AD29
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbhI1Klb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:41:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35596 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240177AbhI1Klb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 06:41:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S9oI6w003199;
        Tue, 28 Sep 2021 10:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=vFMFSjHwVjcuYO/cJBxx0ZVg8RtgGftAJeqS5XkrzZg=;
 b=DpKb10ydoH9tORH06FQHAhOeF4/W+qXqZUDAD8UuCOZd0dJn0QNa7SxYrsEXsqTU5pV/
 +6vO+5jrOzgDaO9hEMFjbF3rAWALWIWYnnvzr6Vp9ovjNHbivNPmhk/3j4dyAyI5G8DR
 dT/NTkWq0lzGviEJM0p3Fl4vOYKPPU+1jpLPe0j4D1YT0ac5fY/rcv846fEz2u0mNxhX
 HndW2ZHbL9prTX8nnl0IMeDTdv6ZWhjQOcyQjw6PKgXJ2ET2MqDohAynEcEfWg2pMe7+
 khZWHl3H3bwIe+UNXtuDoC7d1HWYIgwxugiyl/MIj1uovM/VH2wLQDWvv+chvdCyyHlD SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbejeg0yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:39:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SAYaKx018525;
        Tue, 28 Sep 2021 10:39:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3030.oracle.com with ESMTP id 3b9rvv79hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCKAO4804X05ULku7/pZR9qEGcc5GVGSw8lcsYcUdGFoWeXgCKUoSn2CJN1xDY1MZfRofC6sRU4H5pRgx8YFZzz/zEG6WUgzJrvgLDyZY4Lzwv5R9HvbV4RT7IU/A8hXZiqsZ67dvOUyW7Oaqon0d+mUOXE8RuU2/I0obFPAB+nQew7wkcCZTTesT3WUURAmAz1wlH+OIANG3dZS0quJP7Ymy7xxtBw/PrBY9xw2B/+WiRDLypJW2kQlZrsCnIfr2gVv4jPCzM50wkyRY/ClnOxvjSMvMR6NeSgYAypa56TJXf/E9zBxUBbTl50SfwR0QtJCCmzZYCKdU5A3qxKOBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vFMFSjHwVjcuYO/cJBxx0ZVg8RtgGftAJeqS5XkrzZg=;
 b=cI8XwLkT+FIR8rMKhezTQw/+ISQgNT3/crrV7cJsTJY/+UhV1MAIaAztQDGDtC6rQLkZQxL7xWmI6PYZFnvo+G84ACi4QCOn+h/VEGxtJQx4CoQxMWiM50OqmzMSkS+Ni4pN1NdFiRH4UuUQFr/VK7F/LuoRKHfQz3zyV78ZH+d78Q1qf3SKcVhz7z7XJH64z+I6iIvjzFXmo9c7alDOvxyueV3h4C0o+mciDtMF1PF7CVQILL5oZ7RaOxJ0Zz95fxbu1grhElxbDtBLKrHht3OE+r7LRFqSoVU6tdTTaryLjIDyR50BT6mlABcQpApfsbiaYfthulN0ApZgvzxuSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFMFSjHwVjcuYO/cJBxx0ZVg8RtgGftAJeqS5XkrzZg=;
 b=uJbOYHiF1RyzWDNR4XjaY6A/J/kp51EMDO397Qd3SXz8pK2FH96oCQA8zP5nDkNez6CDID347+k0Q4bO0YXkfciwHhUe2p0ctHbtKN4H1r0nGPEDj/MXjLs1XHDXqLDwJ36g99GF3BctpR1iajbO+aQz4Nr3cYR8PEJS7AVtFDI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1423.namprd10.prod.outlook.com
 (2603:10b6:300:23::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 28 Sep
 2021 10:39:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 10:39:28 +0000
Date:   Tue, 28 Sep 2021 13:39:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928103908.GJ2048@kadam>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 28 Sep 2021 10:39:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13a95f5c-44a7-49a1-d194-08d9826c3f67
X-MS-TrafficTypeDiagnostic: MWHPR10MB1423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1423D1AA3788067A1397B3BD8EA89@MWHPR10MB1423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:240;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfx47+0ZWHuRLTLG+dcPnyiGqvVfynoS2sgZ4Nd/97gOmCUKqlwQ0S7QzXX3DtnIDk6eph5dmghMdRXaZJ61Xuku4cQ6RTSFhZRZCmAW73FSX2cQzBe0vpORXFSbswo7RWNPSmVwOdWqcsXa86gNb+IrGbCq4nb7nO3FhZEqB+QiE9qgNSGbHvM8fpxhUZO2C53IgefGX7mdSPOpQUTZa7Edl5wBijSk8RPkYXMJZwhN+eoZyYYlPsg0fY+G+8EXTFImJs/pJ1kxU5ysuaIweygsoY5BzCvpXleGfvi9vDhlqmiDJyBFywTaVxYIKNGpdo6mm/Jm+1CtYGWgA+MxjjeweLJZtBHhOEBO9nbzQQDmF1rXWrebooWsHz/diQmFVzw6FkqvMgNwjn9WGbQwBb7CLAvJNoqzPFK6dGaDtRzOBZSCYXEJsr2n3DRiheyDsokJEH3XjJwOR7Y10zNQ5IfgRVzMa+mbFhZG5pxlPrVDzmm0OgkzkZ9fIJtKs3clzXfOCCe/mX1vKfoJkfXLHswA5FjZOK2L7nRECOMZhEGu88YRx5o1hQxjt0KeYmmjPClotgwhezKhQri+Px7eWim4h7pwj1ZWy8TNW/6RMNDbKpjIoUIlzJS4uNn7453ktIC2osEZOxVuNUMSdkJQ/MNPMcgs4B028c6fytZwy/tL9/0gClqHhWS94SMPPFfjtypenpErscSjNnn06gNqeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(33716001)(26005)(44832011)(55016002)(66556008)(52116002)(66476007)(6496006)(66946007)(4326008)(7416002)(4744005)(316002)(38350700002)(38100700002)(956004)(1076003)(2906002)(54906003)(6666004)(5660300002)(508600001)(9576002)(8676002)(86362001)(9686003)(33656002)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T+EDxo0kn+lvgIGYlhLF05ccAv15q9c4HviTgo4GWemto1A+0igVbFNBu+H8?=
 =?us-ascii?Q?E1iCV7Y2UL9J83gbil/DWsrkeQYnp0fPu/jlcj+UIOs95HrxuDxCAZkzt+/J?=
 =?us-ascii?Q?w1rdrmRUbWuWyVJBPI8CQui8vqyEANjJibFP5aDIxsj/X/FB1ByUkwdu+lnS?=
 =?us-ascii?Q?V1avhzvfex0DGz1UEaRtZevvhcolvGbR1ZHqzv8wV53BTihNxxX2J+OVORBq?=
 =?us-ascii?Q?I9CVqpor01LvUq9Tg86wL608FL59Qz/n9Hrl76eG+cAy82I7QZWM0DU2N6kP?=
 =?us-ascii?Q?aKe1+3frv4QducrY2/D8eMxH+Ro/KxPOSCtoYx1vrGlCrtSTO17tRP1WFGoK?=
 =?us-ascii?Q?hmFBLTEbMkMNJHsVMJow9Cy3FCCKTNySS1PRXcFUbh+kusoo/5oKHH+0W6Jj?=
 =?us-ascii?Q?A+MM73FnYZAT/T6AbeG6nm+do/w13gnjp+SGDLCIJ4olCPMjXHfxAPHt4XKG?=
 =?us-ascii?Q?diYN2jIW2idNe0HyRXW0zj2d0nfzUR7rFaoruU7tbPk8dPRSc28MFT98/z8k?=
 =?us-ascii?Q?0qdfBQCwr+G6EcP+W5EDE0X20p6/i++VRKbptZ+teeLWgc0rrw2YyERlbXkb?=
 =?us-ascii?Q?EGxJUkjh5SG4Omjyvkg+Y+L5LUH4ekV82RaqOiy5FfqSOb6QGSmGjNq575Tq?=
 =?us-ascii?Q?GUQZw11+JMI+OO2J65PPGTbX+7G3vhQII5KqAeKx0v5LnP5c7JT3+FxqYr/B?=
 =?us-ascii?Q?omPlbPSDBvx2sdEulrPUAMeVa76UFhZ8Er3sah+Du+e3jaHFe6+1wtauHbI1?=
 =?us-ascii?Q?SvUTm5iRAsjhap9HbfE3JMx55Ki5qXnn42Kz0rT5tTCuKCnYulTAMKpDnkba?=
 =?us-ascii?Q?254RG/rmYdYW6H6sgFzkgcFybhj5NDZQ5L2i8BsKLqhloAc/BWaBDg08BuBr?=
 =?us-ascii?Q?rQJhXQHi+tluIhVyRqTLGxJ00LZXmpjIvbQfsxAOrcbKi/IsgoExL9hXUKQB?=
 =?us-ascii?Q?cOLX9UdhXgJzUyX/Eg2NmeMdnlMNpHJUhYnLn/eh1T6YzGU4pUO+ETYPXv+v?=
 =?us-ascii?Q?LSHDCR37/h2Oo0mSvQVqGygdeOlbCGBZne6biRYovbtrAsNhqcHYmox9RLCm?=
 =?us-ascii?Q?tDacSdoqn8OlkvK54O9YKvs7y6fTrZsTKougKJ5HLzUPrEzvJxDROjPVgl0R?=
 =?us-ascii?Q?mDhV4tlyKRpMlRLzCZ9ikerIVYeFryt46J7gjmrkH62GpUSHD/rjoEdGffLl?=
 =?us-ascii?Q?RQUtZ7kF3248SoKCocPbufH2aZZ5Yhmf9ST0nsRlItKiYsLEQdEmp75tOyVJ?=
 =?us-ascii?Q?n3evH5w3+cPWnykxAKqgs7FlJVBZKZ7ECbU6uIOoRZ52dTkoud1Sw2o1K39P?=
 =?us-ascii?Q?3EXK4YxX9Tqtkj1ETRu9LnQ+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a95f5c-44a7-49a1-d194-08d9826c3f67
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 10:39:28.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTqn923AnCciKkAcaA5otQoMEwSBnACF50R5+48PQ4B2nUukwh2Qg/K4XLoA3yZUw7jBpQNigaQiFARxGoAfRRJO99FH80wTvK5QbsxZlTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1423
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280061
X-Proofpoint-GUID: -sI-vAOcKarMU_Z_TaDJnwO2nMgvxZXP
X-Proofpoint-ORIG-GUID: -sI-vAOcKarMU_Z_TaDJnwO2nMgvxZXP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No, the syzbot link was correct.

You gave me that link again but I think you must be complaining about
a different bug which involves mdiobus_free().  Your bug is something
like this:

drivers/staging/netlogic/xlr_net.c
   838          err = mdiobus_register(priv->mii_bus);
   839          if (err) {
   840                  mdiobus_free(priv->mii_bus);

This error path will leak.

   841                  pr_err("mdio bus registration failed\n");
   842                  return err;
   843          }

Your patch is more complicated than necessary...  Just do:

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index ee8313a4ac71..c380a30a77bc 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -538,6 +538,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	bus->dev.groups = NULL;
 	dev_set_name(&bus->dev, "%s", bus->id);
 
+	bus->state = MDIOBUS_UNREGISTERED;
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);


regards,
dan carpenter

