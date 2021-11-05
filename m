Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3E4446503
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 15:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhKEOhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 10:37:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41212 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233105AbhKEOhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 10:37:38 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5EYV1p020793;
        Fri, 5 Nov 2021 14:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=E+3CdnzOeq9vI9rli4wW8Ou8SGT2nRLCnZyIxboepfo=;
 b=i2ClcUBAb0RzUmKE2LUJzpQQq39MDwewCEWZScF9YBhyWtlzWIyXOwzbhzKVT/EPFRVi
 64GPq0SD9h1x2VAXAuR/piEa2+TTArTwgKaxAIpahjBiL2hnPkw8zwHvjl4Al0tSMaXg
 lqvkV0mUS+Mbn+nixQDtzSDl8lS+cm8pUIyAG89m6k5UyM8E3GpMcjkrJzL0icxrgKiJ
 9Tv/WM8YBkvKO6Ob4cAyZ+vAfxaRxse6+b5Xc4uZ8mccKshK5pnKptyq6RZ1SV+6Wsoi
 IYRqUMvmaZa19nCx45ekOVKGWwliHu7bKuvcRTKQG9DvYQKQu481jT9doVN6hf8fZ48F NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7f2r5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 14:34:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5EHBqI166077;
        Fri, 5 Nov 2021 14:34:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3c4t5d28b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 14:34:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNpwcKgjqwsVXUah+tPTvE6iZ4FF+TDQbsbrl8N4F2v8aBnBtzpiTU45bdCnKZTb4zhiDFYOXaenW/hWIiyZhTw24MMnnSPrzV0cTEr5An6WmFxUvvxFR8QdArc/rcNIoTX8ZRVdLcRA6hhLZ/lvnAbPyrwjLuSXs2+Daz9GFRAkFciYR9ey+ME1g3Z33JT74Bw58urCdMvNKyfAN6BLKLR4jaXqlyRy37zQegz15OGzkENB3IqcE1iA52+iHVzahxYEJB2w5iCFYhAJPrW8otyjAtanMm+EHD3M132nJ9bTBLS966B3yD9lHqp4cBUyJo30np5X+qAeDAAQNOz00A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+3CdnzOeq9vI9rli4wW8Ou8SGT2nRLCnZyIxboepfo=;
 b=dleXUc1jwY0+BVXmZ5gBiD0UTa7+Rx5MewPBrwTeJoUeFtVW1rDyttX0gl2pEFH80nmp4tbbk+89i9DNFNxgMWuWNVaLZ6sL84sR64E78Pitr6qlUfoMo4gNEM9VtKo7y6O84tD5Z2JN5X1fa+i5QWefJTw04yH9i8CckBzz9gR340zniOnBq8h31VdPm8aXdcFj/R8nMw2IE7vSiWU6OaT8BLEwUhsAIwH19llsDHcQwYXeHXqXR16NT6g9mv06O7IUZkzptawGExtHXzK15dnwNejk5eYst4LKnn+qngnXZa3C+mEp0GvysUNSMOsne01+b5AxB5+BU/VFAchIYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+3CdnzOeq9vI9rli4wW8Ou8SGT2nRLCnZyIxboepfo=;
 b=pFQjwWua6DaIsTqodwCX51EBMU7xlCysCeAb0RCXzza1EfCt7gBlL7/JFVNSqR54JY4BiSYEB3DhHw+33XYtQUFNvu1oewOjOTPWNTje8ellFoUreMFsqyUW/fxaCXFP7mll89Lg+5+6g1F5FGtfGs9CFLfNqISEoLhI0P+YQ2o=
Authentication-Results: connect.ust.hk; dkim=none (message not signed)
 header.d=none;connect.ust.hk; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4578.namprd10.prod.outlook.com
 (2603:10b6:303:9e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Fri, 5 Nov
 2021 14:34:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4669.011; Fri, 5 Nov 2021
 14:34:42 +0000
Date:   Fri, 5 Nov 2021 17:33:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chengfeng Ye <cyeaa@connect.ust.hk>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, wengjianfeng@yulong.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nfc: pn533: Fix double free when
 pn533_fill_fragment_skbs() fails
Message-ID: <20211105143355.GC2026@kadam>
References: <20211105133636.31282-1-cyeaa@connect.ust.hk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105133636.31282-1-cyeaa@connect.ust.hk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 14:34:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6eccc6e-d11d-4511-e4a0-08d9a0696720
X-MS-TrafficTypeDiagnostic: CO1PR10MB4578:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4578FCF8AA30A0185CDA5E858E8E9@CO1PR10MB4578.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yLCMKrCD8eVviWJnwStD3uNSX+1ZVaaQo9IEm8vXj4CSvYk3RE6UjawzP+9REImBLkXQRCvH4L38ZEKWPdRkOw86F+TyBPBkCTPIH5ux6S5lPxd0Ue4zhZyvIkqSSvucF+QDcEmtlJthAwj2q6LgXKoSTtH0oJToMB8U6AH+HGJN5AbQVJsIYXbmWJmI3jxDT/REC4bUG1JPXAByLYWIKKoEPe1gyQnbVXUzduGoGAIfqMKmP9+pFz6dUkSH82aBNSsXz5ttQoqOLUXBgnZTXjCOz8A8n93BYj8kFgNLUCGJ4F+bh/Fsyfz/wW8nKi+k4OZHheaLAvk2QdmRqcpVbB3pxFXDdbYVHDrzgh8yle6yootkwBNPHH/Z3L+vyJMItAL3G8uxUSI6XBLxgJnVRSEyXUgwNG8AO3zdgZ+akaFPLLpUB0Y14/oSM0WrjEXEJBxo7EGX+IcgqGbOgvVt6ciZ9tJVNYyPvX9rwN6XbIB8kbQ0uJM3F7hvWtX7SolmU5ajS45f0PTxYRYzU9rg0vIfN1nAoxDu9tAISFkstVrZY0t+aVovfmtjAJDr8OeDvA7K5huatTiQgoYg/IFP3Qe2+OEoz2ycw9aW7s6q7y14Lh+KBA8iZhVxV6RDoOBo7TaEiRAdR4BtVyp8Dwx0XVQFDBqGmhaRZs+0f+RZuwX3r1u6yi16oSBV+21t+IdPsGfdU3hoCZwToYBVBmSO6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(38100700002)(38350700002)(44832011)(55016002)(508600001)(33656002)(86362001)(956004)(26005)(186003)(6496006)(8936002)(9686003)(8676002)(66556008)(66476007)(52116002)(66946007)(5660300002)(316002)(4744005)(33716001)(9576002)(83380400001)(296002)(2906002)(6666004)(1076003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwmD+AITMeOOZyNWBlv4x6ccoGGQGnqzQAYND5ihfKXzz6gzPW4rVezbXJNd?=
 =?us-ascii?Q?3doRCS5JBzjHi6e3JhCJIpRGTz2oqyiZ6CsZCaWhR0GsoMlLKqs390DG3Wit?=
 =?us-ascii?Q?dA3+dkURYQJRpk+lhiSEU85iSu5UeQse6GalPVxvmKe34eNqHpbWD83f064+?=
 =?us-ascii?Q?/sz19mLiy06sULLwEHCwrebL4oJAPZINxJFkDTxhOJlbTHoDt6NIag5grmDD?=
 =?us-ascii?Q?l5ndBlq9F/d/5y49JTRsvODTce5SKPpgRnTd5LNduF6+WCbOyezeXOLqqg+x?=
 =?us-ascii?Q?dCVn67y3KfNIZafxuIjzbej+BvdbWDxlecMwCVpzCNT+uSdWtSbAkY4ChHws?=
 =?us-ascii?Q?obNcoyyDwVcdVa/ah3u9l7FtzB8J9fkyu/gafvPDgi3Jv+/Zq0lf2t7o5fhJ?=
 =?us-ascii?Q?lXdTLY/vZqrU3DkaCowlzu69dLVj25jM6iqNrL3Fn/6E/CbkwnqIz0ksoSeP?=
 =?us-ascii?Q?Mv2bM62yFKkqMI4PRJ4dKDIePe17Hsq2EMBDGdMSbK38zNfhplTtK/+71SmD?=
 =?us-ascii?Q?T1GLFZ7PbKJZYweAp5E8VLNIgipgGcNm5ovSTKb/UfP6zSUNbaMQGAxmdBx+?=
 =?us-ascii?Q?Ey6t4sXNdD4qjF0GM3QZ+jkm7e8SUxSLHI6yt17tjSrntVccI2nJE5YHC3xh?=
 =?us-ascii?Q?Qqt8RGmz0KMk/Y+RZtcUFDAUakhV+MaNBPXjRt4haP7RRE+tUCBE40r8eoNX?=
 =?us-ascii?Q?G/BgZ/HhKsC1UFu7a8yk3zhmMR/C+sl/sMVJP2qdh6z4ApbXw8xJpC1Mku14?=
 =?us-ascii?Q?bNlD+FzyZinQ6vJ2FbCU7cK2yEkUPcDiA5D5N0P1FvtbDnMpk5lFFYEeqMga?=
 =?us-ascii?Q?BQ0/rZAh8fgPm3+Ap0gq61YiQmPKcKcVym128vmUigrMVRXvZvoSQPmWJ5G2?=
 =?us-ascii?Q?m4J1uv1xQFftbx/NvpA2XHrFUYm0F2bimsfVU08SL6ZSJBJs/4pBhhtDBx7x?=
 =?us-ascii?Q?9g1f0mNYfWJCH0tT7ZHNe/Cj2Y18SJy37e+T93RSd37Qg1TZVMvWKJlz3B8l?=
 =?us-ascii?Q?UEaDbQuSaj92kjJXvDK26Sbb1aOTaRVCeCKhJFa+JkVG69nFNnTAAfbnN2VT?=
 =?us-ascii?Q?wiI1nYelVJ8b1M3j7lbkPbvO9YPXZ7OmHjMd9pnAlmRX/dolro60vJ96ut/m?=
 =?us-ascii?Q?YEq+qPRPJc24noshzSMhvffZ2ooEPOTr0f5YJQ7WzXXC+TseaiSAWexo8XqW?=
 =?us-ascii?Q?Ttef1M0LvgwpHPXTh5WF1noQaxQN1ZANZqG9sshLykdu+lSPn06x80Iqsk3F?=
 =?us-ascii?Q?D4UDiJwV0ZJvELYYoKEud2RPB/Piogiew1qf2P0ABmJYJ/kxn7J86QBrcEq1?=
 =?us-ascii?Q?LIov434dmo+FkGZYYp0meWskUAsTPeBb/giBZ/RFW2URhkJjT2/Vs+XS1HTP?=
 =?us-ascii?Q?1YeyXsGqCCWpazbvO8uSd2xUZOZNzOvkqNMWB+rdPOzAQrrXb9tmneI+gmk5?=
 =?us-ascii?Q?R/KbcFZO0SKNCbWz9TMmuXlSh2URN2HTByDppeFphuTgnqaFeD7aYi2o7XiC?=
 =?us-ascii?Q?VzD7dnXUioDvkLc5Ot/TZMsSNKWdETTz//cLDHqO5bak0zFAE69anwjsHFtp?=
 =?us-ascii?Q?kMgqXpmUl559pszKS9ZttEci2eU4UwEI/Ow5trjL7UsxiQKUWfwoI1SfOkxX?=
 =?us-ascii?Q?fPy4EqeQXI/N+9IV4N1zuNO8Q4PJQkBmxXnKkjCAH+rskOocxBKs5ViMvSW8?=
 =?us-ascii?Q?QKhY1ryvLGwSa8gs1VPz5Q2tPQE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6eccc6e-d11d-4511-e4a0-08d9a0696720
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 14:34:41.9954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDHICFI8SW9V8nIEe/VwPCJbIS08z3kpYdJqqAX6vef/rSHBL5cpt3PZLMyaO24/Q+qZuy69PQtEt+m4dga3bqK9feSd4++sND1no91/t24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4578
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050083
X-Proofpoint-ORIG-GUID: SrIxraNbYen_dCzP-KYrzdhP0MPEANA3
X-Proofpoint-GUID: SrIxraNbYen_dCzP-KYrzdhP0MPEANA3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 06:36:36AM -0700, Chengfeng Ye wrote:
> skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs,
> but follow error handler branch when pn533_fill_fragment_skbs()
> fails, skb is freed again, results in double free issue. Fix this
> by not free skb in error path of pn533_fill_fragment_skbs.
> 
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>

I sort of wish the commit message talked more about the how this changes
the failure return from 0 to -ENOMEM.  But the patch is good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

