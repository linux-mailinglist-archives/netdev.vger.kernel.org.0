Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6112F41BF1A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244353AbhI2G0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:26:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20458 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243959AbhI2G0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:26:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T4oQIK005976;
        Wed, 29 Sep 2021 06:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=cTCm3wqcqo977+EdF0rR4gATOAWbx+Ocr1vcuZk1dPE=;
 b=E33udLQ2bCU2i40f/oC/7Bb9BKnoeytehWr2IglThra+ZRVwWlarJnn/p3mEmchy53f7
 NCYKJJbj9H9nVmVYgLp4YNLfMNijq2KzsEaoTUkIkunDHw85VLG9Y30nAZfhzSmS5Ibf
 FSAX26Jl+5L/IGcUB3eiJo+tKy5fIAKf0TaIup9waRNW5pTJPuNYanNi8vFV2vsij8Ti
 HUGa/yoEYSLP9PQQVmNcmAyCwVnAWVHzOjGKto4nFYrLXtYe9umQujU/6tC2ieYveeb5
 sbfr2sv6TNZ979XY6xuXsNrZiWCvdWaQ6azq/12CH9cNJBzig4nU2xatQ+3buoq2A6T7 Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bchfkrc9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 06:22:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T6AQGv034629;
        Wed, 29 Sep 2021 06:22:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjetmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 06:22:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsOrWLyEydcLLiLFfowVw6m7ze0fLpqUvZkYrezZidHDACkegxDwzlFzbGU3PqlYONI2KUfrR5FfPfzb4+oHlVzbDdEL8m50fPRbzkYsUzVfefQe7oqb9WrVY333TNWV88Ecn4+CE7BA9qPRqfzMt92vj9y6GXVnIIMUYZreptcXrkKy+osm9RQo1zAfLQYEnU8utehIdvmimkaz8aASki3tl5mXG1eUvam1kkIzDrySVOe+9uhGYnY7ivSZIBRZZX/IpalZEqXx3HhB2Z2bH4ECCjscCIomC4eL9BInkICw66CDYRvnrhsKCwemGYEVVe5jTFgRmuTbwI93OMLzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cTCm3wqcqo977+EdF0rR4gATOAWbx+Ocr1vcuZk1dPE=;
 b=MeJ2Caw8ryd6tGVyg+c/Tas99Rsk5ppPQxcdFCwJwP3+UEzYHDvamOj+4Kk0KXTbAegPpQxNg2q+mpaZExBTKzWD9S7ymL6Wpg8ROyZVonqGwKbmqEWqI5Oba1sp5IiYDfxUf+iKtZGbCp0bJpXA7qjmTLGNotugryVVtgcltKaHIcAlGipCPZBAVMnCViFUcwLk881iGCv3IPR5NZfcHwsWbwAu+fkgAa90FGSAvogDZMTQg6lSq4NbXmLqRLKZIiRq/n5zN3Tu+s7/V0Ger5B0c/PvHKil/ZKFe3nRPYUhSciPmuZwOe+nNwuaxZd/J7lGVnBMsAmckxnoyVOxBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTCm3wqcqo977+EdF0rR4gATOAWbx+Ocr1vcuZk1dPE=;
 b=htifoA/WKRyFLuQ6F1Z+5WHwufcj9WQl+sJGbmw7t992gN3ETJxUqCOhSgl8f3PEUm+flsHTk++sjxOpjx7BKDGuW1p07OQAx5S4+le/juAjkh6deM1DDz2FRl6PUIWuSshYmalPglVMSDwCwj2y57waCntGFjud2ip6s7Eqlt4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5571.namprd10.prod.outlook.com
 (2603:10b6:303:146::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 06:22:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 06:22:45 +0000
Date:   Wed, 29 Sep 2021 09:22:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 2/2] phy: mdio: fix memory leak
Message-ID: <20210929062226.GR2083@kadam>
References: <2324212c8d0a713eba0aae3c25635b3ca5c5243f.1632861239.git.paskripkin@gmail.com>
 <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e9785e2ae2eae03c4af850a07e3297c5a0b784.1632861239.git.paskripkin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0032.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0032.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 06:22:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 247ac3ed-1719-4bfb-0d1c-08d983118ca9
X-MS-TrafficTypeDiagnostic: CO6PR10MB5571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB55715D584E733DFB083AC7558EA99@CO6PR10MB5571.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5OeiulEMKLJ+tHUwpqerfR98q47eEm6Luw/FQp1KzvdFDQa5NN4RnOXzYaU6Elry+fsjducftg9ocxVw2EvkIHkOo5z+xUdd7Ts40tTiEBp8y7bZPxeGFR7y6AGTAeIHGEuuDjx13qMCt1Leysr7sP9LWKYATtP2jstq15LWQLhtJh0ZrK+EGbuNfFZ7HfmUTV/czzQP4j44fvdZfpTqUUM4Ahf4HBP4qUT6MDFyuNkvBhZnBYTn4QMmE4ReNgOfYnCz/wrx6nDUf7CiWv6GOT5q62frs7noq97ZjKSS+xbvtm/2CxXX7U4xm58h9ImWLDRX2w4Viz5Jj5hbiGQBzEzS5J/k3c7k5DVbdUXbeUdizCBgwlsucFLT9Fr7CxH2Zp0Oery+Uzj01noh5nhhxqo6af/IelCIaQAGy7xc2YEfivQWTX5fDzUMFsFju9KSyWNhEFKZQBPGyrkVtCubBExJACcIgM+6gLOQZleXv7Sv8R2LWHgj9muEl5G+wo6Ho60liXxppVBvEKgvVbMV5X71kDTIiXgLc0UD2tR/y9SarVGRwgn2EQiWaTr4E5jEPTlpVU11luGk7Hbz8Z/k/BwDT2QaLWQXPmXo2eMcaFhdeihTYn4fs+blp6TMyPCx/N5nj+5XUb3X3t7kQZs+oc/ZOJnV2qube3ihGruv7wVTMYl5YqiNqng52EE572qGyLiE2qlG58aHl4U8sn85/jV6UgoGGxLIU7DwBoCH9CYMPHO0r5cy0nrcmNpeHxQVu7f/e1d+qfEc2JMdE5jP1Q/jDvgZru73acMY7WsV4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(6666004)(966005)(86362001)(8936002)(66556008)(8676002)(66946007)(956004)(9576002)(4326008)(33656002)(66476007)(52116002)(6496006)(38100700002)(38350700002)(1076003)(508600001)(9686003)(2906002)(83380400001)(7416002)(55016002)(33716001)(26005)(44832011)(5660300002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ESkR/2FaC8dshSDHpShN/MqW/55/4ldrn+REMGRzStJth1C1V6bFYT6H//fh?=
 =?us-ascii?Q?QQOKRBuFBT2X1skOE5WUWtVPkv6BBg9kBRV1ImekVtHoZmRQmcIPr49o5HhB?=
 =?us-ascii?Q?QkW4/o97mrt94tPAMm7KiUoWuTQXU/nYwUzrCjUvsyOMeOYfiPzsMibIGQsQ?=
 =?us-ascii?Q?tvWsIZmu8eR0MbwFUX3Xd21/ma7LczfolGBTkcUGtO9d/TRBeZPHtkTqvuw/?=
 =?us-ascii?Q?1p9gSmsssrs5gI8sosmIIS5Azt9rSK2g9kwoT5GXpwL8OEcbyWx549JoxUNM?=
 =?us-ascii?Q?Vio3aOPysv+spC583KdZz0RmsGN8wTX7fFUpPXTKoiZfrn0zpnwTnEPyB1OK?=
 =?us-ascii?Q?08rBA6gfpqGM3ORH6LcbckJmAB1vyARZOm7B/1nM93iXwghHeRDHbcKCVaE7?=
 =?us-ascii?Q?+2cqm6FQ9hl8/cHhtX+WhdMsjmfKAC9eZmpj4ZuBSyUCAYexTBsbF3Gffyx6?=
 =?us-ascii?Q?EnJFrtJXm5ia8FDjUYptO9cm0/DKXW66iyexs8PtFQCdoVzMRD8yDHsA4NYi?=
 =?us-ascii?Q?LL8N783+h9u5yM2psWkKzeZsPgVjxkgifmKT+E8s3+lpAcbsDAfAmHeRn7yk?=
 =?us-ascii?Q?7/Rq4WqOaoAfKDM9bWVZzEHgYfCVMoFpM5vgYO1e+CWhJj+8KOD2L8DbriUI?=
 =?us-ascii?Q?qnxwFi8LtzrEfW2M4Rp0HMClta72ofnSAqYF9iKCucZJlpnGXT9tMp0kHx0j?=
 =?us-ascii?Q?aGJ8YcuUMqW4aKW9TkQExeYclaFXKT3H3f8GOTUVy1MhS13lW3UiKNUEYSG5?=
 =?us-ascii?Q?QAZhYBODVxy40KclbzaAnmZ1tZ2Tmt0s43aZu/q27p27gcbPdg5qOesUOH9i?=
 =?us-ascii?Q?dnPu0+qbriHeF2YWCuRsz6NOqT29EGx1gvL8CVAQd/YTPSDs6OTHLCvNTUs0?=
 =?us-ascii?Q?OpeENA/XzwYtsLdKAqNx494TO56Ff4aqNzDnSiUBnLXC6r3fd3SWARdIU7oV?=
 =?us-ascii?Q?mgqxXOOA0S11LiyqSBFzlnJakhKlgu2I+/8WWYen3hPKoK1YL7T8dxdtZiWi?=
 =?us-ascii?Q?OwKoW+I0E2ZHiw41AUGwYfbu61xnzngjsQMKgw/YWvHoE/6jRxSTe01Cu7/2?=
 =?us-ascii?Q?xZFd1M+aRBp9hH/qr0BNMksPjNU43Vy2DOPwSiuykiFd/kXS2PVHOpubIGtA?=
 =?us-ascii?Q?cT6eaN4kEadThnA5WVrqqePPHB3r04pEMaZ+EJHV2UEJz2Qnii7ru0LPqgD6?=
 =?us-ascii?Q?sbmKMdSE5pugHv9NyB2e+HxkffefCoAYN8T7sqCb8B2yNrLc0jCOhh0PzwO9?=
 =?us-ascii?Q?gg3fN+YTyCPUhASTC5OFE11xoMwo3XOGlIryQ3GGW0L122FDAm2PsVZXudkF?=
 =?us-ascii?Q?txjuF32W399r1UPHz1Kc0jxI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247ac3ed-1719-4bfb-0d1c-08d983118ca9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 06:22:45.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0egyFbPT4tQNBC6Mre+4XwqvrJPrG9V4Jpm1tqCsSlvliUAHYSTU35YpD91k4jOLGn3QkboRV/+iVt3TYS3X0f+9R7VIRjuwmYxyoWsOO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5571
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290037
X-Proofpoint-ORIG-GUID: TD63KVpMhPvADrFqekozpQtnKqzgUspl
X-Proofpoint-GUID: TD63KVpMhPvADrFqekozpQtnKqzgUspl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 11:40:15PM +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in MDIO bus interface, the problem was in
> wrong state logic.
> 
> MDIOBUS_ALLOCATED indicates 2 states:
> 	1. Bus is only allocated
> 	2. Bus allocated and __mdiobus_register() fails, but
> 	   device_register() was called
> 
> In case of device_register() has been called we should call put_device()
> to correctly free the memory allocated for this device, but mdiobus_free()
> calls just kfree(dev) in case of MDIOBUS_ALLOCATED state
> 
> To avoid this behaviour we need to set bus->state to MDIOBUS_UNREGISTERED
> _before_ calling device_register(), because put_device() should be
> called even in case of device_register() failure.
> 
> Link: https://lore.kernel.org/netdev/YVMRWNDZDUOvQjHL@shell.armlinux.org.uk/ 
> Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
> Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

