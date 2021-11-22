Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACBA458A49
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 09:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238735AbhKVIHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 03:07:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38680 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232258AbhKVIHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 03:07:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AM79nxO017078;
        Mon, 22 Nov 2021 08:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=t0p95NoTPJ11/PWt+avgDtK4FES4WsEBaiKUa3ZoUYI=;
 b=FEl4IvfrViwAW4eAU7PXWtMDuQHALYoKWwKMtGJBPBCPFgcHFDr+7ym+MlgKCqjzW0k6
 woxvoerh6YaOQ2AcbtT3HTrPqEmCSvBxoVslJj9Fn+olDRMDXBeJUJgy6BuSACy3fGLb
 GpPsNH7KVTUUpiup/H6VKUt5Sd9yNZ9DKnXUBc2zZWIkK4HjVKN583yOepySLRoDPa40
 ROGFmFrT7cD3okr7f/Pg90DkM6oFA7tLA3xUHiVTKijJDOUOl/m9eSmO1+pucz3ALxNR
 4M1DaZPBi5bs4bCTI+5bvEiWMJiRaRoJDWkecyNqNycvMXX8+mh5iCuIGQRI4lAKr5vg dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46f0n42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 08:03:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AM7tMNg005507;
        Mon, 22 Nov 2021 08:03:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3020.oracle.com with ESMTP id 3cfasq9kmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 08:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5rHjruwNDiT50UI1Mrq7AFgMg1Sjellm2KzULm6COb0AenlVrkK13teNwBxIQM5hBu0PhsLUrcFRg887zUkv61eLLFfdy10jI9o08qtrnoHHjTpEA4QqhWRYO0+v53ScqMdZVDOasDSwJC0v7+t6Gl94xM+8S1lqVvRWYNF+8J17/stkuwyWsLpsVjuYXR8Jmh948PQaHV8IIvdEyr4rFWrgS3cjnurO5ZyX1aSDAxBMPEi7D5+1wiuG8TVLolhWhp/L/nQ3/WltQBym9XLRHXbAAb2Tpw12TPL/CI+jA7V5rVBm3ibGkJbVoIuC2rd0mx9xp44e3rYjyqIMIjSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0p95NoTPJ11/PWt+avgDtK4FES4WsEBaiKUa3ZoUYI=;
 b=XzjMbkkyAb9hkVeVwzYHaUfRsUuu7yDVgp7I2hgoJOEZIbt5kCHV2k7zVIe1VxOeCo1+xazrh9QpUCc7yCob7Ke+s80D3H6xXGtkzzwDfGmWi+qEUm0DB1b+feaQl4aPjZbTGtAofkn/147g8H/LH5Irr+AOWtp4b7N/hyxStLRkz5bMYkXo++mLCa/fNczIEF0PWALDnrZudvMTMC193n9yaQVsjkxGQlB/6BddNU0CUrcHv8e1ZO4ksRRvv6lwu0MLIZtvgBaxEm+Ba9SPHXOZ5Ki4avCXGigDWprY8bcLsC85QKSNdad0tAYZBa2Rf4vehU6GojtaYnxa6C+jCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0p95NoTPJ11/PWt+avgDtK4FES4WsEBaiKUa3ZoUYI=;
 b=CsAXSIcGzwqi7p8qAliT1Z5lpTz4ahZ+RJt7DcWi/YKHu9uBQpU3QC+trpBrOY+7kpeVt2VmjoO45j2XrVB1S8YN7XXXxORqInHAeIyM85VrMA137NEJa5FU8X2bLHpIPlLxPliC1Lv+AJ3XCcK4Vj6o6w3pPcgrY4tXsmmy9PM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1247.namprd10.prod.outlook.com
 (2603:10b6:301:7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 08:03:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682%6]) with mapi id 15.20.4713.024; Mon, 22 Nov 2021
 08:03:42 +0000
Date:   Mon, 22 Nov 2021 11:03:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] can: sja1000: fix use after free in
 ems_pcmcia_add_card()
Message-ID: <20211122075938.GA2815@kadam>
References: <20211122075614.GB6581@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122075614.GB6581@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0032.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0032.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 08:03:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f825e195-418b-4128-43d5-08d9ad8e9993
X-MS-TrafficTypeDiagnostic: MWHPR10MB1247:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1247AFBD83BF8F6585658F1D8E9F9@MWHPR10MB1247.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gofw8FMfHNYHkGXcmtMZWQ97wDtTveEcs+ov+Uccn8ynz+rWOrSxtAMoMuha7G0gIRSZBfqLyONcQycllsrtqTdTcb5I1H9YahjdyLmmmfFeebzh7DSDcSznfPfd6EgzDRkSRZ6VCPSBQfyp/Mp5tneyfSQo5EGdGj4MIQsKHbyF8Me6FndctZjtlxlKolx71i9FSA/qYWl7fcPU5iMA9fnNyGtVo/7T9eQngPU1KwYSnjymTtllV6N+hsmzABi40YpZB/xp9DdWliw6G410xurLobZWX1dbU2wP4TLwmlrL7FkssnnSwwiZKgZipDlw1Tu1LRAyBg2MSSI6/BikIqsHBmR0tVxQHC7OK7kkhKibK7ryX1Z5YPZ89PO+v538P8YkdBFqgNRUZnPSzLkF4wyvmR3ZaqHrsgBoI9X4MeHYTrvqmtTM0ksNe6A1dW5/J6BcYd0V1OA9k/USbIT3pI7g4GC6zX/eZ4notjDaDrREXggBOfzFLO7uzmz0eKcyXaUaZ2clL0m3XurkHVDZ9/a/i7Rzz9pE7CgaXet16t0c08kwGoBpoGR/bThzQIBKR1CZmtB9B+jck0L6wB9uhGM1oQiOGq7nPTSMGbUGgyHz/GRBGX/IV45TvJvZeTWiIYrpPV48w63YiTnI/l8T6G7ALDZNzd+O08zn50EmqqYXZ72f6KyGnxeOVjV6XEJsZYNwY5LZUMy0GhGS/24SlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(66946007)(66476007)(54906003)(66556008)(110136005)(508600001)(33716001)(6496006)(1076003)(38350700002)(38100700002)(44832011)(86362001)(956004)(33656002)(2906002)(316002)(9686003)(186003)(55016002)(8936002)(558084003)(5660300002)(6666004)(8676002)(9576002)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/toqrutVvuPbye9VC5sLWxOGdlcvCmYz07mMtGZ2rezwlEZ5UkrTot/9YeMz?=
 =?us-ascii?Q?IAKS8pae6TN9VDfWjKERsZ510QeUeAMxPlyrdYylfdnX/8snQYrzk8tbPOXY?=
 =?us-ascii?Q?aV9QAjQ7T1rf9k20ihgBdF0iCBJZamL0KK/MjH1Ej2SG6Y+PrqvCq5/Igtuc?=
 =?us-ascii?Q?pvjCbI12wAofX5gtJUqxBP/vhPh9yzKZ5MaoBgONzcNnH38Q3ccq5TwZMzgz?=
 =?us-ascii?Q?8A18Ifmqgpeg4crq8ThLUuVLU2dlonk/wZ9szaeWtnLAnsAzQ+QsdxBcj8Am?=
 =?us-ascii?Q?lyFux5MoXSW5E8+R3w0wzePKrEXGNXo25dkQRoi54ZG9aiVqcQKdfNQfDEuf?=
 =?us-ascii?Q?PplVEma9dX7r+SX8O3ObJbJa6MbGUc2Y3rbl56UtLDHixaO08xXKi5gIuB/2?=
 =?us-ascii?Q?rM3FQDd7ZlID7F9hztdDw3puBzosxNs2RZGsW1XSEUEP1mQHsLTnHH24SHos?=
 =?us-ascii?Q?qmUxDt9s02MvAHmQLrQ0ShsuxXtq/YPv+G7Hu9Ihf2YhuBVdlZJrMAq0IWCO?=
 =?us-ascii?Q?xEhJ0HIXWcWbK44MNCeF5V9HktYSlTHhk9rfTslyVCVejZN/A9xya0yCk5q9?=
 =?us-ascii?Q?Rbd5KrwxeiGwRInhHgrADrkgP/44OuJZvBpcmPDGcYfQL8QHIAKeBALrFXP4?=
 =?us-ascii?Q?AH11St/z8+ZmF2YQdM94g4Jvg1RXbAlxvKLlqUKXPSQTrXXMmNkafBhfse0C?=
 =?us-ascii?Q?oG8G5JTDR+DwRATz7wASDrsYnLrCUf4QvbAP6VBz3s40W3RiNKufWB9LPFqX?=
 =?us-ascii?Q?qGg8qdEU2SGJGM/PQybvKHlsYOZ4CRI+pn3N5l9uKwqKKTVQzIty59MykyVg?=
 =?us-ascii?Q?8L6J0qgst8QFIel4VChogOvQDv0Unkg/Z5aBZKAfaXalmot7BhUHENyh4jKU?=
 =?us-ascii?Q?R5lG9ENiG9roZR0Gue/feJMlAhiAWRd82CdVpIODd2+rAbFNuIP46gblSzcz?=
 =?us-ascii?Q?GScdIyR4eADMp+Xn41/c9YM+wVL1eVlUnwW4xY2ROI39HlEdqnsnulaiFBsx?=
 =?us-ascii?Q?U6fP2f4c8Wnlj5J8Czn3Y1k86GsecmiZnMLNMes7dKiInt1uNZahGT7ZLlqT?=
 =?us-ascii?Q?oJvMcDuql6JQxHXaSKeqFSmZMPlq/TKs/CXhUhvPRZKv2ibAYPpUw1PIcLeO?=
 =?us-ascii?Q?vaj5eS/WLO0LavhQba9NU9R3J0GP4FzH7WQAT9NzeyRO0ipTKDrZ7kB8v/Ba?=
 =?us-ascii?Q?zC1MbewtZGlsOEHyvCjkk+GOXC2LQ0dyCqT1y2xMdYGB6ssvI+BNLltAuo7x?=
 =?us-ascii?Q?48a/FtyPzHI/tyHgX4lyO8gUH0BmP//MgKx0mKZpY4JQZGPWHKgFewxSrODL?=
 =?us-ascii?Q?+sN1XIphHojUKLLurli/yO32S+VPAy9FMWLOz83yeNZXdUorav8K/zZswAKJ?=
 =?us-ascii?Q?TFcp3XxFTJdfd18Qa3TNHlzse/SVQ9iF8YP+seAhCXdEWnbz1fiGwqwhVncs?=
 =?us-ascii?Q?stsT4JNjLINzK/tV+4C+AgQ5pCpf4HVp/A6QuHsuWzXt20MlYLoelknhXOxO?=
 =?us-ascii?Q?j5ycv1IWlsELe9B9t9EqjY9Zvgw6dS3oMJkSlbrf8vNZ2cMeYIEiRLYlCnsV?=
 =?us-ascii?Q?C9QgF1fQESD0Y1f7vAOLjvIIbuQbBa+5wbAuAHXy/rLraH7Dgt+t0Pcy+3Iu?=
 =?us-ascii?Q?jK+n0xq1L9yL0QOCHBJivf0/I0eiBzPYmq6adzwajTdvMB9Jp8bI+4BTr1AO?=
 =?us-ascii?Q?bN0nN4hfXJXt83s/a33V1ZGgiJI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f825e195-418b-4128-43d5-08d9ad8e9993
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 08:03:42.4401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7UGN7/CwqwrPRgiRSKCf1AgzqDlS7WiDiIIqURGLqls5gEryqXHtSwntxiWvBMJBYkavVypYH0d2kAxSt8jP70LUbwnUXgIZRi8QARBoc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1247
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=557
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220040
X-Proofpoint-GUID: YMvMkeeB03Yn0yPWRLwcUB0m4YhB4pWx
X-Proofpoint-ORIG-GUID: YMvMkeeB03Yn0yPWRLwcUB0m4YhB4pWx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry about I meant [PATCH net]...  I was in the process of editing the
subject and got distracted and hit send by mistake.  :/

regards,
dan carpenter
