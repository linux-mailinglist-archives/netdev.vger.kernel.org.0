Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12B4BE33E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355121AbiBUKgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:36:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355153AbiBUKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:35:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0661E55B0;
        Mon, 21 Feb 2022 01:57:21 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L9b7Ff009721;
        Mon, 21 Feb 2022 09:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9Hn9+RYQwRIK01MycwAEbNfKPbOeqhjm6X4Ea9pjFm4=;
 b=V3n9DlRRkb7YZTBpvXT60qQG3hDH4HjXa9F34sknYIWQXnjIs3NT+TkusIjL/oK8c7fv
 c9E4Yc5dExbWUdqaoQ8HkDy+4eNSqfzgIc/EUbxTEYuHPk3msZPEGuLtJT36OP1pbIgf
 ZKBlZnjlLz0N5A1sjQlYk93YpbcIvEjw+0h3xo9840puXdaeVZFtxeVxN9iMcl/SfI7P
 y/V/Nwf6O5UInhdmuL5gThLRIINmUGpokDKXKPKbC1vICNftsYz7k2Tx14K74jn825q/
 LEGX7bCQJCkDvLN6+zGkQxebd58dOV7R4VqsS8KPY3s5/Jl5HrebFe4Elce1HeXEvfay Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eapye3qx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 09:56:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L9oONL124378;
        Mon, 21 Feb 2022 09:56:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by aserp3020.oracle.com with ESMTP id 3eb47yfex9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 09:56:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVrC5MjlIYJdig1kd5ve7NVhGOZPlY6oPimKkhBq1Bq/mW49TfoNlp/EjwE0DmZQ9ztyKqeUQNR/rQNIG8s8/Xq50xmYMFcfvF2cH/qPZ8oUQQey34Q1OPVIVwcj2307ZKgnb/sSOThMUsP/gSbal9s9ZrdIKK7OMgI0zvvwGh9DqMIub2mHoH5owHNf5jbbBjpy9LA0v7nOy2769wsZagF7Bgk9KL1aLsruMAs0jSsh70cLvD0pEO/UJkosSz1uuvRkXnND8YkdnnTwdYHDmuIy0dsY5rkUchssXaMzi4cqXWK1kFN59DwbFLySdmmNzG1snmMroyu7BOLLat6SRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Hn9+RYQwRIK01MycwAEbNfKPbOeqhjm6X4Ea9pjFm4=;
 b=H2h9aqsYKo9rAEOsuDnClsNdyZaoKYs1edvS1jTdkI5IaXHyE0bKqBmo9ohk1bNo+wlpdSZk0Wg05ixJ3+0r//S5AGW37mEkbIFoL/AOXrnNYly4EO286Hl6+ox/xupSpouz2ItFBdf84dBAJ4tyOTGk7GgXnEmsJS5xbfpKpSGU/VMsHckOW0gXO6OgyYeTHL/dZlOdOkaHnYEx7+qH3ouq9XYgzIEdKMwDMZewLHPcyPDNvXJzxm2OjADWf+xkTunY95mfnLjPapjs523dfMraDNnm6zmnzpoCE3keTQbZGTxi7ErRqLxlk6YYcM5ZF/LNteyhp+G+GMUbOpuEkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Hn9+RYQwRIK01MycwAEbNfKPbOeqhjm6X4Ea9pjFm4=;
 b=Mi1QWaY8jVPsnk3g/4L7YaydQeUvKuxjsEDX8QeLp/ooJ3KLFIF0GHGx4zRx8zTjT3aiSPrIqbGNUyitxn9TjD+KgHShfhCveH3h1YLBQSyQN4zm5aI7PHzcoIvrNdS5fix1Z4cjSrV9QwakUhGKtxkNYYOPcSrqBuuOrxtL0xs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5093.namprd10.prod.outlook.com
 (2603:10b6:408:12d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 09:56:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 09:56:41 +0000
Date:   Mon, 21 Feb 2022 12:56:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: add unregister_netdev in qlge_probe
Message-ID: <20220221095623.GB3965@kadam>
References: <20220221022312.9101-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221022312.9101-1-hbh25y@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0029.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0772f51-dd6e-4218-26ee-08d9f52075fa
X-MS-TrafficTypeDiagnostic: BN0PR10MB5093:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB509389F943B5FB19EA38C4268E3A9@BN0PR10MB5093.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiKyHN44gp29jIjwQ9aZvLWOJMf+Kv1eTkSigUMqQfQHeH6wP4vJaREMv1hey1aHI8r4vP4N/Ohs5Jd0lPLs7hdv4AlSCFfnDIB+1/7mIMJucHZN0wKICQ7DU4/DCbgHb889i563zClszQPUYrALTesuNbkuk3QAB7R/em2ZNUp0W87fhzr6CMWEa/FnMp/m3wzxUFe3fl4UP5vZX8OqjENmvEQb/TQyQwSPZanvutVVlUtJZzFpEQPp5R3d2v7X2R/OIO+W8GbZex4bOgpsSWLeoB8WIYwFW11IozzjABJkEflcN75jIni9TY5M7w//8fHU3tP1T9oxw3EFvsBWwCJKgKHNHfVA6SeQYtc5JDiSaIPyt3/PMREicT7tnagem84l+SeMdcaNqhR6btj58i6U/B2yzLFaG6/3nMY1AB8V09qFcoJyjEo/WPBo8jVqVl5DSTF8NNbkLPLEqEaOfsoKmMZrxYwba/PryTmQBkj2S58IAHWYcV49ubbetWS4FS/FSj2XzmiI1S/ZTtAeGMbjsjBGYehL8d4M7YwjTV+pLnIk+Jd0PMHSgxdLBSCp3uCLA9gKFBxRR81KsxWiTujPEmTYvzmGKoGSIY1y/RGcwC47npdlSmW4i9zPk0/RRJn1s1w426d7Q8S/ze8apS6CToGZbMrv3JyvQKz5Uk1VeZEPaHzoO7E2fRkDRdvtsvyyuj9SFr5DvnYzzXKHZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(33656002)(6916009)(316002)(4326008)(66946007)(1076003)(2906002)(66556008)(66476007)(6506007)(9686003)(6512007)(38350700002)(6486002)(508600001)(44832011)(38100700002)(6666004)(5660300002)(8676002)(4744005)(186003)(86362001)(26005)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/4Xwh06QufzDPE+FYSIScyOW1rL6bTEf3Lus7qJK1eusdUebHUsJyy/cHt8?=
 =?us-ascii?Q?8mODES36XM3gTkZr5gF+Rn6G8bxqndNTfKyP9ore3YKLOPTeFrBJJzDYhG9A?=
 =?us-ascii?Q?l1NVG9ElfwPW2FjjUCcm7VWwj2LTPfPElNob0MmyZx6YrW46iJeDHklbEiq0?=
 =?us-ascii?Q?qHKTJzfy9oIOtH0Gmr1H8sj3tzZzPJgrb3BZT/z5nn8DCiMLlBq9MfrbYSPm?=
 =?us-ascii?Q?5GyYRS9VUaEQVj9vzqyC5CuUhvLCvwT0bsIvh9TMPzJjStI07V+LnmTNlp2/?=
 =?us-ascii?Q?sMDvD8qhC+1PPGYHjjVJH1nNzdi9bYw8xY1q4S+TiD/tOHPB20RcoQUkMctn?=
 =?us-ascii?Q?BrQe3ml9VZed56idomDOLxmUTFA8cVsT/IwiNL+xbzQn3MCad5nSI+qyKFwe?=
 =?us-ascii?Q?MFdKuNqSC/zh/fIA6C8PolCb4ZkMmi40Biz4ywrBnfZMNlNJE5h2LDqLXo42?=
 =?us-ascii?Q?N+Retd3Roej6jDVVvZE5CxpPLhSlcbvB9YcQLAq1q4o08tuRXyOTVcLtRd/c?=
 =?us-ascii?Q?BdAuC8CZSapwzJ/hEivw6R5jF4OKA964QFx42beZud3Bp4KP28BGua1VMa9l?=
 =?us-ascii?Q?VW2sEf6xARFezNEBTzC92uH/Kgg4mRXz/We9dvLumRab/c7KUVzBe0NhCQmD?=
 =?us-ascii?Q?vUR2TEJnPJGs/Fe1szX2ZXZcRNBahQufA8t7seCle9gdoIXv6l2gcEFUhzjl?=
 =?us-ascii?Q?toFkqEcfWZON2o5mcSC60Ks+jyuF9z0e/9z/a/qZj/15QBCGAxwf6qpvp8Mu?=
 =?us-ascii?Q?4CVB+kB9Qv6RYjh6QIwc6VFcAFQbPn2qqP3oIb7h+9h+Ok1HP1uWBtkrofxQ?=
 =?us-ascii?Q?V+oa5DN2TmamJ1JNA2g6SaZIhYWxDSS8b+1dSbo8s3yyFDLz0gt3J4eWG1jj?=
 =?us-ascii?Q?W5lUPVI7vv+38vtem91pjPX7ggFPm4nGXDaGw1qXyO0ch+UfyA0pG9KMAHdA?=
 =?us-ascii?Q?cHgttxO0mNDpqOVRtn2bQxL8kz52AFs7xJb0LFlIszUdEtmKJ/nvFNb608Uo?=
 =?us-ascii?Q?fFNsBmG9w9NiPfk51s1E6DEY8K892qFUYBQCzXieY+ZK+WsVpU4c3anTGGpR?=
 =?us-ascii?Q?g7zF3fpT54ni+/i38NqcS9xc76upVas8ciP6Z1pPURepY/xFG32ECaa7JHEr?=
 =?us-ascii?Q?owJ+VXdnn8YC6KHT41pRMWIa+mKSfMM+1PwOzvXjWhIymyxEmgOpWrwz658P?=
 =?us-ascii?Q?ZWVOq/ofPXaDOGgWKm98liPu2SUZ1ibZBIoIDTxVve6fcV9Jh5PFewlN2RWK?=
 =?us-ascii?Q?/wAhtZbOdd3Tt/2dvVfbBFu1DqAuLk8TDk3q6/c8zVRe4IVxbemTDchvDvxv?=
 =?us-ascii?Q?d87YkcdfsjMzad3qPv5nxpIExNsua/dxNvlcFcZC9pgFXAxUwQ+8CryUEfgX?=
 =?us-ascii?Q?YxmY1oNyePfOnDum27NC36PxF8Cti0AwzR74i43IywWmn3e4emNGxrYUky59?=
 =?us-ascii?Q?h7hCJb7aIkbo7XUBa/XIxzuLMLofOElTwJDq49KniLYWgkMYzaJdwyRtzwAi?=
 =?us-ascii?Q?zL0XpZbyPhTdSOisjXNOHx4fyokPfRaHCtVRwtL/42ZyTqhVydgNWz1cD4Nw?=
 =?us-ascii?Q?nVs5i41gOq6hnZTFdg99hnHPlnOkMRgMTAg1JtP1YZlQ89PG0ztZOQ7NpVpk?=
 =?us-ascii?Q?Fi+4IrMiUzsnYMEeM83e26lziO7upadHhhxBVnXGbTiHDEHvTRX5IHLDFWRT?=
 =?us-ascii?Q?xckywQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0772f51-dd6e-4218-26ee-08d9f52075fa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 09:56:41.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v19LDCaSkn+NzbFkyG/kXK5ZPftgUbrZBR58BuirxBPysvapbb7udAA0UMlDWlI06LL7qUWE9iiJ6wNI86FiFQwVwaLgOZiawoA7+1Gq7ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=844 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210058
X-Proofpoint-ORIG-GUID: XMTLzcneGqPem7S2fl8GsQ74A0GLA59p
X-Proofpoint-GUID: XMTLzcneGqPem7S2fl8GsQ74A0GLA59p
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:23:12AM +0800, Hangyu Hua wrote:
> unregister_netdev need to be called when register_netdev succeeds
> qlge_health_create_reporters fails.
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> v2: use goto to fix this bug

Hey Greg,

Don't take this one.  Take v3 instead with the Fixes tag.

regards,
dan carpenter

