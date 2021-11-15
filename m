Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BE444FFC9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhKOIMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:12:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35212 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237647AbhKOILz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:11:55 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AF7ECMC003214;
        Mon, 15 Nov 2021 08:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9IRBF7O5tmsbIxe/IFwGkVOS2ign4fjOVOFvG1y4VRw=;
 b=l92+sSQjwatf7SSORfE3Jh88j81VIqnjPJQjRUh7jQi74yHUlNH1JXjx0RgpNa/ONf/B
 9xoOXen8RNjxkw6ODd3X2rQx7tgzNgVBjE8s8bc+frRRmerI2cJg+vMdI3U0whQtvp1q
 y8PCZS5SAX7Oc10xuc3doRvig9RYgm7VxQf73x/nHR/W92ZJuhx+jek6QZ6ZTX5+5VTi
 FIJvm5v80Xj6TmtCPoTPUky1/+jt8B3MX45FrLejtGlvj6iaxgDafyUqf+/vFEakC7MV
 MH1g4RATIMAhGCOEhsFu9n0b1wUYzcqgb0Un19nHJ8PZiqkEW81kn+O9sNcCE1Q94LU+ Ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbh3drq4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 08:08:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AF86LCQ176168;
        Mon, 15 Nov 2021 08:08:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 3ca3de1btn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 08:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDAYFcu86sOQh+Ayj+eDAm/BolIIc6gaC/LURJg7HwpSLK671RnHn1GbssIzrW5Gny7rXn21hexw5EtySjAdO+MXAxMzIEiN/q/0b9jutHrHszPXIdieTVrCoPPhMMHUz3xH3ERc4QTMn1DyE8Vgj80fnDNwZZCuxD18sFhgBYrQxLlNA9eEfqW5L8xY6YcBqZIs8HfFSs3iILLf9DuQjZQDLz5K6wW/YRmZuVPWP6IzggSd44W8xSVrdQEc5scEiKFqpj7YV4tdjefHSUy3r8M00EAGL0CAUJ6eMZQuD7gREU1cGedP0d0CdzyT/1g7SwNknofv7ERE+uANUNz4hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IRBF7O5tmsbIxe/IFwGkVOS2ign4fjOVOFvG1y4VRw=;
 b=K8Gnsmjk3FtDyTG65gqQREWvABLpsLp0HJewD6VXTDVSh9AUt274VwZUszP7ylr0xSVzP242NtZc6TUurhAM16aCwYG4R3jUUs5xWecj7LjS4HSWbFwNh2cwWI2Y3dsNjG0s9K/CpqLHJCH8tlQJvn+prieky1s3cMYMfwNQlGYHFLknyh+uxMU491UjXYlDfnKFxsTYkgxVhQAO4iXlanDfUXMWFU5ZfUfsF7vu7g0+/fvWvdTLJI6Sr0cAlo3iP9TBsVwuesF+4NC+3qcxj9e0qXF+OpvO4oRdnTOJhZOQwiHXkIHdUAkvaiwVq9KZxlrNL1MXeSX4ERJNub2svQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IRBF7O5tmsbIxe/IFwGkVOS2ign4fjOVOFvG1y4VRw=;
 b=yrtMyEDlospRsOvi6YN3qNu4kCYfb05TB/ZfheViRSLHTltT9uj9DkPwNnoYGaiFG2lzchNE7vkJ8l10pTye9veMKccZr+NkJrD5gSH+YM/y8Zd8/9aym0Lygp+kyRiYAwHtFE5zxKRFJ3LIkfjLaMiXq35eZUeCfGpXyca3yhY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2398.namprd10.prod.outlook.com
 (2603:10b6:301:2f::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Mon, 15 Nov
 2021 08:08:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Mon, 15 Nov 2021
 08:08:49 +0000
Date:   Mon, 15 Nov 2021 11:08:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Message-ID: <20211115080817.GE27562@kadam>
References: <20211113172013.19959-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211113172013.19959-1-paskripkin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0030.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 08:08:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3698cb62-011d-40a2-c1af-08d9a80f274b
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2398:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2398E570E9143DB48BE0DFE18E989@MWHPR1001MB2398.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rWY4R7VlQYH1xzkYSTMAyPWwvCJrFyiFCrtGPARUJz1MqemBcL2B9xSUudx5k/Q0QiSrvAL4Kh6vII/XFt+UBF7H89gLbMCfxmV5b+J6sQ97DaPpXejQo4WWO+Qao4qs5+fu5BdeP3jSjp3lrTZKSTlHJF2rZh6X6eAgDtiD/xF6GZpQOOBcDNPAYa3nBJZidmwzzPmv8Pe99AiTQKlpYhLD6sPypynFexWfpqR0QpeGU95bbdJzGDrMR+3wfjJ6HgZk5TOGT/Ixhjkr/xVI58EKHd28mx+sGT616IOfpbAm411HtKA3uoWWtDZM+OBTsnm4Y9eefdkNyf+br8Wj412NRZXMELrYZ/WtK0J0w6IRgKvumu3umG8iOkZI1L1NOJSDkcVrjmm857e8hFcNuAMAT+uKKA5XFFBnFqoQ92+OzVFTx0xJrrG/DwNOphnjM0ZIy+3r4l3GxOujjfhEqkOKBBUDmTnbEzxXAF8M8P8WW8lvzZQBEnm/IVUlIdr08XtHIFWIuce9hRkY6JhJc7jee6RZo8guEOtZ4n14bPAVb5ivWY+tDOmZqmMV95QNcv6/U5DVHtNgpmGug3iVDYCTedpXOhj+cK3iyN1GCJ3Z+6lX4F/KyHPQCbjbrv5CKCl+ZqPRq1tlbHNjMzNGpGheUndJ7wnMLGkf8RsHXDohhyFZqIC7/LjFB/dk5zTZLdVa3ZeuBXwctR+6Gm0AWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(66556008)(38100700002)(38350700002)(26005)(508600001)(6496006)(6666004)(33656002)(2906002)(66946007)(66476007)(8676002)(186003)(55016002)(6916009)(316002)(5660300002)(1076003)(8936002)(52116002)(44832011)(33716001)(9576002)(956004)(83380400001)(9686003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42Sw8dJxhFLkIETJzhrFddy8xfp07Bwaze5gFlqbFr+OCLL1LcVj7QKFK5Ln?=
 =?us-ascii?Q?zAGiIK39vF+AKSCxVViQzgpe8pYD7Q5QF5g7DZ3ZWWoG0xjE0lky4jFtvQTr?=
 =?us-ascii?Q?4lShPqF/vbJM05ZBqE10znFpCjMeGGhUtX8R7SxSFrEBQFCu03r2VWUlWJpf?=
 =?us-ascii?Q?yl9uHU4FUvGF+b8L6pWQK5KnMcmlUf00lOlBbbqzHLefGtFwwiToLBQYhFuE?=
 =?us-ascii?Q?701dS5X1cDsDteQSwsJfdccaMVdyuBQyouyIEi00sk0tFCxgO9Yl/NQO0ThK?=
 =?us-ascii?Q?bFSATW/2HEgjAABMCKu9GK+gJMvOBUhWprmZL5j5kOabjuXpurdvlTjSIAl3?=
 =?us-ascii?Q?C0OHQ4s3BnmOOe/Sj+U6BocDmOTs2Iha7X4qKMm0dn82h4HGYryCom6UcQLy?=
 =?us-ascii?Q?KODudeNvB8LYbH1/R9aDqXgO8bsxU4TH7ze7W6YULIaiwa2nHdexcOcZ8j5i?=
 =?us-ascii?Q?VgesJwiU/9rAbPkLHndW3jt9ZISyjFxKELaDZOP3ePixaS5CilA3kpDGhYYt?=
 =?us-ascii?Q?E2klpZG1lbT0bUKGfy/ehXZV9vPMVzPPcsfF4dre8MgSwCFVXKw/cVG3RHJh?=
 =?us-ascii?Q?ieX5Brp9KdFsXi9XcFf6GWulTY5pl2O3KuZ3FqBfOpfq86gGuFgry220mb2c?=
 =?us-ascii?Q?M2/6hpZNLFxaA9D6WY/d8rxIhB/LmORMsSahxGZxynOvvbZutTEQRNF9VdhY?=
 =?us-ascii?Q?0nL+Z8UbMQNGBFaDPihYBrnYsU3SfbliwK9I/YNx88AW+jwuBE2Ma3UJ6u9x?=
 =?us-ascii?Q?e0b8YfoyUMhfoYFBxYcYf8fDXhrlBeSv04Hp5nE/HuZRVjC9W76WUvwOULR2?=
 =?us-ascii?Q?yeGim3LS5nKkv1uijNZDsSVmd4cjDE9+9sCAcVhnnK8pePY9/bKe0/f4ZRMl?=
 =?us-ascii?Q?w/2cnRyXeLOdnYz/AjgDr6I/Ia3Q5mAB6cs3p+HWVpbxdiFr9nPKeDUbkKal?=
 =?us-ascii?Q?YLzDsUl1Vwa6ROAHX6Um+LCiVAg9AwudpLUnsML1Yin+1gTbxVhy9Mh/HNeW?=
 =?us-ascii?Q?gN2sWJDEgtv/90OS+aMOnOLTwA0k6/nY0bDdvQ+Kyoq6UYAJeMR5kxomqMKs?=
 =?us-ascii?Q?5R2JBHqDCJB5HCdOFawFi1dTMdksejHo9kMszDKhU9mmpHVc6p6eD3V8RsQA?=
 =?us-ascii?Q?/W10Hh6oQTDJafEs5lXYSfQlqlq+ArhjdYhHTO+YSerruQ+BqGX8aLWzTbof?=
 =?us-ascii?Q?3UDT3BokvNxIKQood4QYGp9d5YmlHSC29pxSCIaqV1cpwvtRNn3CbWeqA5zO?=
 =?us-ascii?Q?DDc4mgOI3BcMIDjOvIxeo+h8BR1jINYG8smSvwpn0f5TnUUd2/NviK+ds1Eh?=
 =?us-ascii?Q?Muo11HV7IuujDLMgNnsGIAvbzSPm0I9vgR7Y82vmfFtYHh/Pb9ImIRbnvrjB?=
 =?us-ascii?Q?1KSoYQFGwQ1EXh+slACOQKImO0q0RbtV6ZqSSWaPeiI6DmcucSEtHrq0TKR7?=
 =?us-ascii?Q?1irQJzKHLBuQZ4s914sBEOwuHimySaS035CcOPlXGWExEfxv0TUQhftsRSqw?=
 =?us-ascii?Q?GCPiPtPM/YI8u1ee4J0RrnrGvwY/Rq3U+oobZ6jIXkIj32hxAEL8WX66jm0O?=
 =?us-ascii?Q?2dK01UYbA8VjY1Zr9GsfNEUO13etm26U0FARhxxpjMiaWuNaUsrwKhKRbj99?=
 =?us-ascii?Q?hwYJQiMXCKexqKY62HBswTumguJKTTQbcYivZ0a+tuNm8fsCGYe+GohlJjao?=
 =?us-ascii?Q?4i1KVVWgFLpsdjGN3y8eaZnN54o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3698cb62-011d-40a2-c1af-08d9a80f274b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 08:08:49.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsmRC09S1YX2pqVOrEh1JB0Vgd6Kd6XfpnDMwLr8GlCDtnCqwfrDFDzjZmcezJjGD7rhwsiZa3Ssn5DodReTB3VTtizbUN1Gr9JT2YKkOj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2398
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150046
X-Proofpoint-GUID: 8wO5kPUUJXLFwzjdFrb7CHTV8YAmFPZQ
X-Proofpoint-ORIG-GUID: 8wO5kPUUJXLFwzjdFrb7CHTV8YAmFPZQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 13, 2021 at 08:20:13PM +0300, Pavel Skripkin wrote:
> Access to netdev after free_netdev() will cause use-after-free bug.
> Move debug log before free_netdev() call to avoid it.
> 
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Note about Fixes: tag. The commit introduced it was before this driver
> was moved out from staging. I guess, Fixes tag cannot be used here.
> Please, let me know if I am wrong.
> 

You should still use the Fixes tag.

> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> 
> @Dan, is there a smatch checker for straigthforward use after free bugs?
> Like acessing pointer after free was called? I think, adding
> free_netdev() to check list might be good idea
> 
> I've skimmed througth smatch source and didn't find one, so can you,
> please, point out to it if it exists.

It's check_free_strict.c.

It does cross function analysis but free_netdev() is tricky because it
doesn't free directly, it just drops the reference count.  Also it
delays freeing in the NETREG_UNREGISTERING path so this check might
cause false positives? I'll add free_netdev() to the list of free
functions and test it overnight tonight.

	register_free_hook("free_netdev", &match_free, 0);

regards,
dan carpenter

