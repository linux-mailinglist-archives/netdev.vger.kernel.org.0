Return-Path: <netdev+bounces-7210-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF5B71F130
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E79E11C210B2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A62A4822E;
	Thu,  1 Jun 2023 17:57:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489042501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:57:02 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236AA8E;
	Thu,  1 Jun 2023 10:57:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4U9Q021401;
	Thu, 1 Jun 2023 17:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=U2++qzXKQni2GjWl9L+qlU5VRCXxd1n4od/5SxJDPZY=;
 b=mCOA1tlzNA8HEnYszQeYUCUpIIvGrm1YYAmiskB3agc0R9CE4VsUTWk/TdmrgXfFrSyg
 WvM/vJrRxt5xWeNl2uVtRfVxwEqB/jWYLNXW8ADTGQhvk9UCda38nbdENUEwn/SViyg2
 p+ZT9+3zE1pxr7OOkjYkDRPHkvpe/2N40axywww+C8D/t13R6NiKFUgqpL01dPo7JXYD
 BjmF09ap+aDvSfO0VgeUO0qZ0EVzoPxMvTmVYH2RnzvsKChN5YscnZicAHOIN1tStDNu
 FpRIOl/4m9PxQSq9q3ej9TdHE4Fzzph4rVhXKOmwcmfslX4oH8B/x26FF/flVEy4v61B /g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb99cs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 17:56:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351GRTiU019723;
	Thu, 1 Jun 2023 17:56:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7sep2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 17:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWkcxD2+diRYejCp1sJGQYkkfeVLfe6xQo4ENFKJpRvPObIsBg59vWbaQ3BipfJY2juh8OldRnwwbx/hWzhmTEQZOIksr7i668Wns6BtAuZ1oXRCFAguz5h0Fdj+HWqxqM3pidniw1inLvJjqW92ngIqi48TZp7+wUoV15sKnivLv8LhQEDIjduxImjQHfgrJmKzmJ6XA8eFuWBtbQO9BX0HdtxEpq5ZvjKTjjP2AHeiILxemkCBFlA42FcxGYQ6uA8Wxk42w6Y5KC3AsovfsCNo+o3QVjErT1ycoHDK0ZxgyLlf9NOglL2Sm0GQ8ardEGRM6Fy1b1mg011gOBJLGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2++qzXKQni2GjWl9L+qlU5VRCXxd1n4od/5SxJDPZY=;
 b=LFpVAn97UwRRui2N5MNM3Kl/cD3hPah6CbCxMTisz3NMvHA8ycFPdzKPFm0CVjSm0ch0DOHNYsVvE3Qq7d+5g5AMUokdEhltMluHb8tk8UXbKL7KI5J2cB44cJFp1tmQRbBo/YuoG2i54kVTk2QM02MC1xW+5heUaAGYq8gHxiBCZxRf7fkoyxpfihVV6dVwJiA0Hwz9rASg1SHgWZmXSvRDqmSOPw9cGlwF6E7tQDg1upJSe6gkX3Apw3TGsmf5eeqH0BV/EWQQVDLtWDcs6VesuXXUJBVCEKucTgFtNl13w853eCHSXgpORp9d6wrZXIk1qmfwVJPXvBBhQQTedA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2++qzXKQni2GjWl9L+qlU5VRCXxd1n4od/5SxJDPZY=;
 b=PpRCMYjQFB3nFPMLU1RdYC5leivgHXjF+00tWJ2BlEiZJLD3l8Ik8/RsPlHPuQbOAMQ9usAzMK9HHd2VxPt4OstfgALnVZj023JSP8m8coR92jk00aiGGZ/7U9B2MCUO/sX99i2ROcr2tVuV572eKGQvDUOgnUiyfg6hLarZy1k=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by DS0PR10MB7176.namprd10.prod.outlook.com (2603:10b6:8:f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 1 Jun
 2023 17:56:25 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d%7]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 17:56:25 +0000
Date: Thu, 1 Jun 2023 13:56:21 -0400
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 1/6] netlink: Reverse the patch which removed filtering
Message-ID: <20230601175621.ugsgt2ta4c5b6wim@revolver>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-2-anjali.k.kulkarni@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420202709.3207243-2-anjali.k.kulkarni@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0013.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::12) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|DS0PR10MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: 115b545d-a86d-4847-0927-08db62c983fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	LNincEXDZ/p8pK2ZlsQz0dgRuaAruyEae6fM9gumawi5yH5ux3ZbiRRZ3/C7BVA1zhU4HXcM9AW71HSa4x1Sus4DoQLZByxnZipK1twAT1tImBljQ2k84MCms60Deqva1Dcqvpz2KlwABCnfrmw/GawWbxllaGW4Zp1NNWnuHROCRRwGYhZWihIOTIHPojNjSYdkbE0CNC+wY3A4v1JNldTzMYe7/yQw1dPN8n/dZ6Yt2Q8Rwogav1NBpxNwV49A569a1ags8Zl1kEcxdu/z7iOIGUVAiOkXnlPxeae2fmoxHD/J9TqOLNpSkwqp7xvGghmCb1DCfwBls9PQYwUPQWekpiPBwDwpnjpj+dwUaLdFofruJOInL7b2kiCy2GsKOm/cIhdk0Bc9eZZWRZLb/P7ITcj5t1pcDDm0viCPFVEmuSTOr8XTC/yYPof4SUy5ggQPh4RsKIbrzTlgtemGOVESZqbTJJXlQ6mTV+NDz/CkuotxZ9ZwZj19DW5nLegHFGqlDlnT99G/2aMxChI9Q51NOjgvb4u8RIb+Oug2RsE19eL02Jz48bT6LRdvN5YH
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(38100700002)(33716001)(86362001)(8936002)(6862004)(8676002)(41300700001)(26005)(6506007)(9686003)(7416002)(6512007)(5660300002)(1076003)(6486002)(186003)(83380400001)(6666004)(66476007)(66946007)(66556008)(316002)(478600001)(2906002)(6636002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BMTJeuc0QgeOsgsBnSVjF0Xp29tyKrXnF3pqFE5waC3AuyCGhe0caUD1I+aW?=
 =?us-ascii?Q?dYxV7SKAcbIrQwfvZ92nNMWJeMs3XDpwgUj47hPVGqMKNQPphnHHNLJV7tAL?=
 =?us-ascii?Q?RlPnUufmha7Qyup7ROlbh0BNcf3EI0xF1xQ2hpaAHMGkagTRyYi514hufCS/?=
 =?us-ascii?Q?7dPJ9Rx3N0MvvRAWzWBMK5gCLBqZ85ePKorC2NfHcnRD0CF61iQ6YoY/x9jx?=
 =?us-ascii?Q?v3Qjo3slloY39z9n5bhkrzpWdylskeozI2WNpQcydu04Hx/4xvXaLa7GHtEd?=
 =?us-ascii?Q?qYQX1xaOq5sIlxozcKGbvfeqYKfRz2BNmZFvKFwIfcXJwqzFZfBpHcBUHl8g?=
 =?us-ascii?Q?bhzA9RS0AfmP1fyAP5DgkGp8pFcY+yH7F2t2xKO3tgsU8lQSOVGXL3zEyZL5?=
 =?us-ascii?Q?8vkGPYIEcN1mzKICkdluX4UKZ3IOoBQ4PwX3r9tS2XeZ0LTMyPjg7y+hfyH/?=
 =?us-ascii?Q?CcUPM2tam0ZzV9FLr4djnuNxjMxFNpMjE34xtfwZGhopljK0gTFjvfhtn9E3?=
 =?us-ascii?Q?TK+baNKYFHuAP03lPYhdgNIzt8ma9WdM1XFji4cNf7RNlEynJCeMLKJks9vY?=
 =?us-ascii?Q?KRqgVqqKKyLzSbnTF7lADnzKsMQELde0G1T8XVuNE09GHB0sVzQYFoVYaAVB?=
 =?us-ascii?Q?AEA7wn/TdRcEN1p6s35WVUQf8JIp3cKMx3151OpmXqBAbo//pa7VW/aozGwq?=
 =?us-ascii?Q?dS4BXGdCgERGZhT7kVMV+/6Ck6/0USsE1ZU/mpFMNd3F9Mw7N6Z5V59jnmJo?=
 =?us-ascii?Q?Xogdz7WrUlSDAIziaP+qjMVf4vspaLCzaGRXM3R7bWyevGxfLC0GscyIYxZe?=
 =?us-ascii?Q?7HOP1MAK2ryr5CB+HjpBkJs2Y1pBdhussd7Y2ImlUZSdzAcwyRM4aBsDhxYX?=
 =?us-ascii?Q?RhDBm/8zn5LIl8qR44T0UJNRJJJ+qMA/hHo0hm+RAsTV4R5JiOWBI4wCWzzK?=
 =?us-ascii?Q?Ow0Sbb405Ru2/RTq3K4QE4IPgf64fpEa+BSWtoH88uMQXG6zVJ22ca4EP7J3?=
 =?us-ascii?Q?noxNNgzWjeuEwv6vpqe0OxiW2rT8b6nhHWROLd64OnWV57h5Ta5YgshaGIby?=
 =?us-ascii?Q?1KCQFA6nxR42iQwIr1x3EtwfH/SBCZ5KWvL+gDpO4Hlsj/CRNvepXj7KK/o3?=
 =?us-ascii?Q?VYMKXJRqflT6zOlmrykP17Fq5zSNnJKD5kNrqkTELf+rO+BVOPh9ptCkQJZv?=
 =?us-ascii?Q?+aK4wfStPHm9G9BjsSvvFf7lVdiOEdmePDEYYUWh3kYiE5VrqERkdmaqiYct?=
 =?us-ascii?Q?ez95MNpkq/RMBowtnokT2jINg0tQx7b9bRfpg62ADK5c9IMXNSZYWkjw2FdD?=
 =?us-ascii?Q?brLwU//4NupqrpqOQmziNXJ5K96xXGEAupDiOnt0HcpNhjTYgBsBYruvxcAl?=
 =?us-ascii?Q?CRW01ynW0jU88ez1o3zPyB7DOeJjAE+3PnuKgfnjG77ibV5JCQuC9QrPn9c0?=
 =?us-ascii?Q?UxYc0J7IPJl6cDUI59CPqg4EKcHE6Hs0RzaZ01MBmT/kkGLnkBwZZCwIpLjq?=
 =?us-ascii?Q?cZ34wb7XFj5DmnlmF9upNrqFx5bszCp8x8k1GX1P6YboCzzBLMYPwYe0qOlk?=
 =?us-ascii?Q?P4bfP3nDn53OQO4AZ8jViIxI7YEgcJxY/xBTVsDUIklaY1kbwjSIW8/Ix3mE?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?rnE+ZxxytR7ogS0eyh3pCOstwpPT/XNmOnAWLhxHjQ5BLlGcI2/hI83f+KvN?=
 =?us-ascii?Q?Tje9+SYJKM038JVk0WPbzvv1nv+UAIXhOKXueRv+OKndM84CRg7NNwvoNSkx?=
 =?us-ascii?Q?K4IHYpqvR9lASou6LFFgD0YvBTG+At/Sbbzlb8DUVBspXY6RXaDTF004wC1w?=
 =?us-ascii?Q?PQdDlPgrSraACKeEHxb+Y+lhkSBpTEknoT/j2I3+OvV85TA0MWZ7qtKAp+3o?=
 =?us-ascii?Q?ThigTgPfEjxBakhPKCYujj8KFb9DOYwO7eIHllIDKw27S5dgS4KcNYrihlpr?=
 =?us-ascii?Q?P+3tyNPAtQTLPR8bKBnmF2xa/6u+7N9jDDujrsYW0E5QHTxvjO5/w3oraQ22?=
 =?us-ascii?Q?jksShrqHD6iSOSR9+zTcsFGGvnAjM4Y8veuYPGAYhiv85w7ivVQYPhBNGDZK?=
 =?us-ascii?Q?HVCm8KhBIu6SGAd+x8L8aVu1vHUpnBnz/djBGTCwT393yLK3YAjmX/XRJgiR?=
 =?us-ascii?Q?gZ64TnVaz+pnyF9axLvHKQOqELV0GK8p8AZ1i+fU8xpOx7K/9np2kWJ4tQDo?=
 =?us-ascii?Q?2WX4ndBYm90DyUPnOl1GH9M+9n0/xTIAMY0tvjlYMP/A0Gv7Rg4cZOfu7Wc7?=
 =?us-ascii?Q?fL92eYvCSERGul8I8v/E1HbVBTOXbwKwNtL70Pu/DomjihkVc36O5jjNqYJ3?=
 =?us-ascii?Q?Rf6k8uK92G+aAZBu05CGLJmFZsRL4qwabT8xWdHCjHedLgxkGhU2f837rktj?=
 =?us-ascii?Q?lbsqnh0BxmY7UR6EPOq2HV99qq80Rl6lM50DgZ2ay+WSDF+gmobaz4wkc4O/?=
 =?us-ascii?Q?GVPI1A4/zBzx7fGeitVm7dkgP4vLmbU6nteltFWuh14FASwtJsh0i3MQnSeo?=
 =?us-ascii?Q?RDMWRiSTfq7YYPHXG0KGdgg61XbFvOjo51fv0Ey3VucAix//NxHvOTpvlJgE?=
 =?us-ascii?Q?ti0i96jL++nyRCX8cyYNdLu0G0DFq7QeTFDKakyj8EVPvzXyH3M1RDMG65JC?=
 =?us-ascii?Q?9m4mIlDKlh0ikETQ5nCP/hQkmHYLLRmDfMYYIOQA1X+8vv+OUMgq12Bq4t3B?=
 =?us-ascii?Q?bNajHfXQbyAB1zpU9kO776GzvjCDMN1grPMRjrnzWKGY99jvKtDN59nLjzRe?=
 =?us-ascii?Q?/CTzgM8Y0RYJf7fBh5flcFoOHu3UTM4QBdRJqLydRL9swEJrQuE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115b545d-a86d-4847-0927-08db62c983fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 17:56:24.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6azLIM3DWnl1aaitM2qG2YUjZBsi9SIaQaGJxqxWbD8hcrSZYl8iCXLJ2C08wpwD22RGzLONMQ2loC5vlEicw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=919
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010155
X-Proofpoint-GUID: BolLXZZHR08Bog64Nue7qnmZGrq6YK3e
X-Proofpoint-ORIG-GUID: BolLXZZHR08Bog64Nue7qnmZGrq6YK3e
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
> To use filtering at the connector & cn_proc layers, we need to enable
> filtering in the netlink layer. This reverses the patch which removed
> netlink filtering.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
> ---
>  include/linux/netlink.h  |  5 +++++
>  net/netlink/af_netlink.c | 25 +++++++++++++++++++++++--
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index c43ac7690eca..866bbc5a4c8d 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -206,6 +206,11 @@ bool netlink_strict_get_check(struct sk_buff *skb);
>  int netlink_unicast(struct sock *ssk, struct sk_buff *skb, __u32 portid, int nonblock);
>  int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, __u32 portid,
>  		      __u32 group, gfp_t allocation);
> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
> +			       __u32 portid, __u32 group, gfp_t allocation,
> +			       int (*filter)(struct sock *dsk,
> +					     struct sk_buff *skb, void *data),
> +			       void *filter_data);

Nit, just a personal preference that if you indent with two tabs for
function definitions, then it is clear where the code starts and you
have more room for larger argument lists here.  It also helps when
changing the return type as you don't have to redo all the spacing.

>  int netlink_set_err(struct sock *ssk, __u32 portid, __u32 group, int code);
>  int netlink_register_notifier(struct notifier_block *nb);
>  int netlink_unregister_notifier(struct notifier_block *nb);
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index c64277659753..003c7e6ec9be 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1432,6 +1432,8 @@ struct netlink_broadcast_data {
>  	int delivered;
>  	gfp_t allocation;
>  	struct sk_buff *skb, *skb2;
> +	int (*tx_filter)(struct sock *dsk, struct sk_buff *skb, void *data);
> +	void *tx_data;
>  };
>  
>  static void do_one_broadcast(struct sock *sk,
> @@ -1485,6 +1487,11 @@ static void do_one_broadcast(struct sock *sk,
>  			p->delivery_failure = 1;
>  		goto out;
>  	}

new line here please.

> +	if (p->tx_filter && p->tx_filter(sk, p->skb2, p->tx_data)) {
> +		kfree_skb(p->skb2);
> +		p->skb2 = NULL;
> +		goto out;
> +	}

new line here please.

Since there are now two times that the same steps are being used for
unrolling (yours and below).  It might be better to make a new goto
label after the successful one?

>  	if (sk_filter(sk, p->skb2)) {
>  		kfree_skb(p->skb2);
>  		p->skb2 = NULL;
> @@ -1507,8 +1514,12 @@ static void do_one_broadcast(struct sock *sk,
>  	sock_put(sk);
>  }
>  
> -int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
> -		      u32 group, gfp_t allocation)
> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
> +			       u32 portid,
> +			       u32 group, gfp_t allocation,
> +			       int (*filter)(struct sock *dsk,
> +					     struct sk_buff *skb, void *data),
> +			       void *filter_data)

Same comment here about the two tab indent.

>  {
>  	struct net *net = sock_net(ssk);
>  	struct netlink_broadcast_data info;
> @@ -1527,6 +1538,8 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
>  	info.allocation = allocation;
>  	info.skb = skb;
>  	info.skb2 = NULL;
> +	info.tx_filter = filter;
> +	info.tx_data = filter_data;
>  
>  	/* While we sleep in clone, do not allow to change socket list */
>  
> @@ -1552,6 +1565,14 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
>  	}
>  	return -ESRCH;
>  }
> +EXPORT_SYMBOL(netlink_broadcast_filtered);
> +
> +int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
> +		      u32 group, gfp_t allocation)
> +{
> +	return netlink_broadcast_filtered(ssk, skb, portid, group, allocation,
> +					  NULL, NULL);
> +}
>  EXPORT_SYMBOL(netlink_broadcast);
>  
>  struct netlink_set_err_data {
> -- 
> 2.40.0
> 

