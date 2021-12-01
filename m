Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61827464675
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 06:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhLAFX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 00:23:58 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31972 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhLAFX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 00:23:57 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B14j0AJ007291;
        Wed, 1 Dec 2021 05:20:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ByO4DXcb24a95O2TJihWwnHqGog4UStGC9bf1kL/fzM=;
 b=pvM2pJKVOB0tHDVd0N+58OFdmCmwSp3ljrwPCuoVMVEWq2A0Dd5vV672zjhP0GDf5O10
 qAVwxgPw6TbyOO/gWakZLTssonHsx3a5TPeI+RqJJjEH9ePYTUrnoj7S16oGy6RamNC2
 rBmb8Mgcq/qWB44pn6gMiZVCnkdIdS1NYMa6DD2rTLxtJcr8b4Vhe6zlWw9k22UDNSqb
 cHTfuiuyXTYrN6xuiLnHqJpCIYTQtiL0wB8UH2MMxqLwjGIyVX3JQ8iRPEd3ChwwyDMN
 xh5IbI6AIJHEys61KJRixeLcBggWkjBoZ0yRW0aR7zXCha+oirGhbmSF3k+EZkcixFa7 wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9xgmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 05:20:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B15F7sj195092;
        Wed, 1 Dec 2021 05:20:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3ckaqfxv0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 05:20:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3xL4FBjonKI+G0M8RWBy4Ib0kWanf7XnWM7EP7e9sp+TGXk4Nh8q0Q/jZfZPTeLdB7r2DrvXCN85Zx1rmT4J6SWSMbdlro7QSwpt99K46D+67RQUBG7MFhz4k0zg5H1awepnZW2wVxZeCzp+Ui6KFhlhCZu3N16/ZDPAcu4D+qBJdnMLa/VYV5a8mmeVLQQi0jT3WFnt6x6fapCHRwHfL1L6uoSx4YzRGlsmY1YmKLV9QDNjPukjMd5DDdrbXtq64iwpQt+wB0uekPM6wMGUnQL8LBbH7TiRy4IQ6q7ysDJELfeZey7sh4dhyzQvZV6n0lKEkq1yHwAHOF4C63bRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByO4DXcb24a95O2TJihWwnHqGog4UStGC9bf1kL/fzM=;
 b=ld4OI1amqiN0KfEHX1aCRKjrO9dxQRM/TSmitqgleB1xBlozVxltBkSqifCmW1XRHVcUHVWRBE73s/fQHgIFQq0mtFBm+bUrP5vrijvhHahblYiFTqmXsDqgPbOB/9FODuW1wQAoasDAKQM8/jVe7vVeBxrmrLQtIxaklZqt3Uat2ycJaLXHSqCdffFCK9ZtBAlEdXCo/zIkH2OKMgPxWt6vpiazf3sDdTGMyTy17OWS4qubB1hYXarS00eLXfkS/NO7iIaeElqYcwZ+Nc0WwETu6PEtQnDb40I/MADV3ZV0/vAEBWOfaZi8DV7UBKo9HduoDCPtdXayOsRiuBB9OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByO4DXcb24a95O2TJihWwnHqGog4UStGC9bf1kL/fzM=;
 b=VpbUZ0Ps/o2D0VOfmuju5SZJR15DB4WSqxM1KyXCcgBihs6CN/l40vItJiegfuHFT1aGKCws8g18NnbZRYO2sPO5W3T5Oi4VJRjNjAaEqn8dRmg07/iIOOVUrodsshZTaWQcs0QbHNCTukWN3DILC5RW6pxl7dINKy9JBDM3X1s=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1863.namprd10.prod.outlook.com
 (2603:10b6:903:11e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 05:20:27 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::b0e9:35ff:73d:b96]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::b0e9:35ff:73d:b96%3]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 05:20:27 +0000
Date:   Wed, 1 Dec 2021 08:20:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
Message-ID: <20211201052008.GA18178@kadam>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
 <20211201000215.1134831-2-luiz.dentz@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201000215.1134831-2-luiz.dentz@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0061.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::19)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0061.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 05:20:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2610327-806d-4d81-34c2-08d9b48a48e2
X-MS-TrafficTypeDiagnostic: CY4PR10MB1863:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1863A874F2A586EAABAAD4478E689@CY4PR10MB1863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiTQfK3jDH6atTSoEbOz3CF7CS5ycKAXHl6rDcNMDLkYUSEFxBh+tHvQPDrfDDi96b1DVoPnQwNwGRMfXz1HgiVAXmDC5ow6l2knRBuowWybxsBR7fFsFVb63iHfrq1PLMSiTK2XExVZxnVoYcn9kPr0UiWalzJZJQgfN+2UtHdgPVB71tbTLz57XKH9xDOV0ldfZ7/gm6ypge8m2A5b+O99WS/9iz30Q3OX5VeWYICvGyva8bc1JmdQp2sRQGR8TXQaxTgN+e4UCFFV1ktJyQKWMG0XAG3uaBZ5wnM1Dk+ns4zSn33wPyFaKwftiB0XsWw7FLMWkRe3dRTttjOrlDsDFyEGTZjwix1vLYcUDngf1EdOoyvVPwOjE02yTRPxWOYCaGMFo1NOXAF1aYr8aDsS8SHAAwtMl+u9KBuzAZqv4jitFe9zoVcilhNI1myVK6IcEOfwyElJipc6D5WgrEXYXlRrAy42rxv0BO1bkL5itPoguwinbq5I+j2EFnxVCQHaQLAq7WQ7HKuF+AMzbaJkFqz/7UFJEZ451RrG3QP0BInJPWQXMxBqBfMMK+7onq25875uyp05au2Oln3bSjTCxs7P8B38Rp7Ezsodihs4kbc6SFlkoyrkjkntOUhP5uQokWnDJZKNKbOUi5dhibkDWkL3PlzHdqM/xQF5gu6C6b3By2tJkLUkuY9sLax+cym+x98hl3FwOdXfJigIEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(26005)(6496006)(1076003)(956004)(38100700002)(38350700002)(52116002)(8676002)(2906002)(316002)(66946007)(66476007)(33716001)(66556008)(6916009)(5660300002)(6666004)(4326008)(86362001)(508600001)(9576002)(186003)(33656002)(44832011)(55016003)(558084003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VliB3Mz60JKLjtAynsz44qUaazeLW0lqopISi3y3POAj96Fgk04UPnNKNQj+?=
 =?us-ascii?Q?OGTw0QFSfR72cs8KKA293iQ5eV+Ir2MtoMJk9Gtgq7MIwXJ3OzLiCu+e7uVJ?=
 =?us-ascii?Q?jQL9Fczj//7icSm0jEnDY4oBk0E3ROLzXXRYI7ahRvBoJzNv7mJT5Go5Krfq?=
 =?us-ascii?Q?gDY8re5GWfUyA5pRBoob1sukCYVaxjMrZJ2Xd+SEY5RHyfA2sSEtM9kTlXVL?=
 =?us-ascii?Q?TlFP72tDMO3pLviot2+MmScHEDeTB53Y8T/BG82GQ7wdNI/6lVd5BuqYj498?=
 =?us-ascii?Q?mf+tEfpziXdaKhHLDwLFGIlUZ9YXiRHOAm2oq35RQ0iTFZqsz01GmOnUK4Sg?=
 =?us-ascii?Q?WfP1BWTUUMBctfiT4L+bAnG8MqhLz/al8fxLVRzNK27BrxUqHsRlP7uR+OL4?=
 =?us-ascii?Q?roSRRCI2Bjg/o+An5FxWRe4bZ6zgY99EGFLD03v9nErwsyIA6u6MeGdh9+kv?=
 =?us-ascii?Q?X0ud9EwWy/Sb5D5/9umoCEecPss1YPiMqSvBMAZYgJU3tHBHmqykKmRNdtDc?=
 =?us-ascii?Q?cIu5VZI5TqxRzAJlruY9IecvVBcmEExMHL5cRI792DErJjSn1iLwfieARiow?=
 =?us-ascii?Q?UWXVBU0g/KC64IPviWQDiGW7R/IsOu55RigxG6n2WPguTfRU3lNHebd/1wQo?=
 =?us-ascii?Q?4HNi9MkQj928cEBtVotspNhIkjAZvhUgrrun/ZjypYhR3gibywYkS4sB1XT+?=
 =?us-ascii?Q?CcVLvP8Fc3Zkg6W1GslNwcmbMW5q8+73t25rPj/FH3wn/olsIYpVgCiTC4Q2?=
 =?us-ascii?Q?LPrQE4AG+M5v5ma1en9yCUYKf4dAyRRHoo9T2OsOJFJjBgeAshfzjXZTlEB8?=
 =?us-ascii?Q?kcBZ2um262zdY4NN2PyvBmRjN1/79vD9Z8XxD7ZUBwEyczNzlvLXa+TYUUGB?=
 =?us-ascii?Q?9Ijw9KgTiNT0useDtSiLHnh0JyLqx2SPhNPh3RQ7+SxGUrv5jloNRAFslNEQ?=
 =?us-ascii?Q?QrEdazcKLofdUu/4gQwyX/z7rKIUv5L/bAFt7kY8BzucM9y1Y9CHILiClv1L?=
 =?us-ascii?Q?JsrbuOeXiDrJJfb7am8wpxSL0sC1dhnN6vS5xBgkCzxp2jyNQo/ngHYUGsbz?=
 =?us-ascii?Q?EHs036Jw1T/5OPCJJH2UqQ3rvSZhaetXdRyb90GuSSyaFhrc29bbHCH83MbA?=
 =?us-ascii?Q?CQTYRlFyABgaaRuShWzW/tzOjbcD/DyUhocsVmH4Px8EtAnLJ/J8OLhf8T1C?=
 =?us-ascii?Q?AwBnxpkhccL6r9OGbyaOHi/Tmgt2cHf+cgiQviwlfEuyYGLFJWQKIXCptsic?=
 =?us-ascii?Q?fLlFFQQCvAzgEC8D4dHxQC4kRligMb963sYOILfBHpiyanTCvrI1WbSwp0Uf?=
 =?us-ascii?Q?x69fUJhJl7Hfrz9YoNCcQtemmRmx4RewuBtbj9pMdlh0lYp/ak9W2re3h3u+?=
 =?us-ascii?Q?h1oe1O+5/bi4XaW8kWWhrXd9vYDUXgUrHFFVyQgl8FBdmfILGedIsfHOvQIz?=
 =?us-ascii?Q?ByU1jaCcLGqSi1X+uJaZr9FDPzY+rKN3r9yQQPXUZyWt2GamKccRlVbAPfsf?=
 =?us-ascii?Q?/z80nEIn1mycw0AuzE7MRgSNTg60nj+f5DLjOvpVHNLX1cObea7jX6SNzKwz?=
 =?us-ascii?Q?xRwFl55n7t2Rq7gWI5LA1lf4h93ZgBVb1ZGVER5am3IPLUnf7NdqXkEMK6gw?=
 =?us-ascii?Q?KhfTXQIPO2nVxnlkuSJ3OxeL4R0d2JVIQn2CyuhlylkE2RUSg5BIEvkjZI/N?=
 =?us-ascii?Q?MqDWdILg9x798ECeQLC0n66UCO0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2610327-806d-4d81-34c2-08d9b48a48e2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 05:20:27.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IoFShMGjv+lMT9EY53zpcmEnqJXCeCcrOHzMRTmWMlSiKAvAwL5an35yPBAoiALSiZIBLURaMjqxoJ2FHBFubVg6W1XVeBE7oQyR4eWOWz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=909 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010030
X-Proofpoint-GUID: xvXAwABqtC8a3iK5XS3AzNqJwb_RHaYw
X-Proofpoint-ORIG-GUID: xvXAwABqtC8a3iK5XS3AzNqJwb_RHaYw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for following up on this!  I had forgotten about it.  I'm really
happy this is going forward.

regards,
dan carpenter

