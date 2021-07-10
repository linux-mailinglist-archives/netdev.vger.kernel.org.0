Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37613C34E6
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhGJOqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 10:46:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34570 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhGJOqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 10:46:38 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16AD48vi023583;
        Sat, 10 Jul 2021 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=og1ycYBvQV9vm/Le0vzWRwthF1t/bFjoT1xJ8xgj+nI=;
 b=iZp4p+jMjyOebXLGHoKMCvehNaMc8JOx2p1kKIcyuceGAXBQFe7bNHOcR2cNR/YspcIq
 zy1vBU6GoNoNz+cmkNN81UbWBe4rvB//ZZXrov8AeyMZZ/9prWrIri20mOc0IyL0YNk9
 jwv1IXQWWNwP+JFXL6x5oRWzWgxv62VyubTKvVSv8F63vcgklVRSXPENN8dxoGFc2Tps
 MZePG9UpHQJOv+nyjn990mCpDir+OP8urvorbqEvekjAUNhpKiTsRdL4mjdxGRPQk98P
 pjB/aJ8Gt9hPFkrUJkErk3SgBJYPLQwFjBPk4mZzXXuK1PGGTAIAOfc1zr0DFfVYGLDc tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39q2b2gfbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Jul 2021 14:43:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16AAe4pQ037968;
        Sat, 10 Jul 2021 14:43:34 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 39q2vkp4sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Jul 2021 14:43:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmR5aptZYyDySqaRECRp0LP2R/xVAUhAHNugvBgkDHj0uZf+iPIhKmdxrZHYGLeijHUYcsP+6k04Fm7alfzkgT7iK+qm0Q6sIHwNP4Ug+eN3W8+kqRuJeqi4vVuRZR7CsXlaOjn44JLHFtpL6ZB74qAbIpvb77YMPRigP7Hgy8U2UCii3T5AAzl7c7AjwznErPrqAWHpSkZg42Y/dTuoemM0fLe/o6Ds+B0ChCcpdUeBngmIaFvb+y4GgPwVbDhx1DK1P2fNvnFJY6RWHONWarpyewlXrncFy/py/qj1GNqFVlneZllP01gmUCMIMuiK5cnID3ZTaHY3p+TC48BXvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=og1ycYBvQV9vm/Le0vzWRwthF1t/bFjoT1xJ8xgj+nI=;
 b=fyIvOSsCBGgzecWhR475fTVA1MUwRG7KPOHTOkKGp3/LRNsY/PKp5vB8HiZyLVCzTteUVmYjqi4/r9Kn5PqzK2RAasPIT3memvbBYsMWcYmNaWgzjKmbBc1C9q5TQ2gYDD7f5Mc46Ld8tywNyjDQKD8U9DtAsTUMSVmDn4nwn2weLuSoZgmpAOUirR7fb8nZKLzmcWzoGpelTlLUcrxEfq1DlEpFvgVVrdsyvfx6jpwDpobf5mi3DPAkcxS8O8B/8v0iagpwpJWEPAdb3ppbg1X3TyEtdalGdPxvN4UvgS/SYTrvu3Wdb58gVSd6Skzli2YiB04iHwOcL5HL94OoGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=og1ycYBvQV9vm/Le0vzWRwthF1t/bFjoT1xJ8xgj+nI=;
 b=QL+U+vl0T2rOeLyQEk7WIK4xZgadEg5K3dENGTCRHkFNRDx5Evw0CATWX8EI8Eu4Atb+WRXEmhoDzRD/w5nRvLWhCKRp/GfD9Nf9cCC/kRxQ977reQcBxUEhh9MYdscUr5mFy3oc7FhNP8zDixj53h3ofef+azil1sutcENqVzI=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4706.namprd10.prod.outlook.com
 (2603:10b6:303:9d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Sat, 10 Jul
 2021 14:43:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 14:43:30 +0000
Date:   Sat, 10 Jul 2021 17:42:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/2] libbpf: Fix the possible memory leak
 caused by obj->kconfig
Message-ID: <20210710144248.GA1931@kadam>
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
 <1625798873-55442-3-git-send-email-chengshuyi@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1625798873-55442-3-git-send-email-chengshuyi@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::23)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0046.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 14:43:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19946d22-cc1f-4e52-41b8-08d943b1156b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB47063EAF72E9143A74591A638E179@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:357;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8XfqzTxlT2uiC4dMzZM9AXb7gYnEe0kA5hg6t7X9+b3jWDfUpM7KklV0+JBQZunRDBU1z+0hVUKQl9weF8OSVRR1snhoyXGd1/RoYnhhPj8TAaWCQiCF+x1af5CEJ/cWvmBaaz35ovDFDbjsTftg0XvAk9P353hAu6ciwvZ7RVVddXN520JEOiHv5HceqMHj3OcvJEW8bxd1pBG/+pnRG6yXKTFPAV3cWycBV6g0CWXWcZMF9PeePmTWJF836at4IsyI2uTF/AEL/DFzdBWSrwz4boyxvk2RpftNmLMtqvIO4eMmhFOa/MNiEIps0jCOr3Bb4Ct4NLjrl9dz7HTzTj/FJa7NcrcSXwzNMZeQ5kAqYPIBzhoU0+5WUM4r/Hr8+wZAC3RinzJV879UW0kje29+NDkcxIybpgFsfA/KtaeJiOM51xlMsfrmPWzHwhGtDB7M5V9FQ+kDuzI/4pEsRLgNbOvrby51kpoKnHqIoqnO3hiHXnONNfc5+2s4THC/wU/AH48AtyqUVvHjOzAWCX4fZyJFuRRcy2wstgRhbZNPZave/1pEnqgkeRQZGg5QPa2hZEkaQyEfMSHjsRoZ/jUtfWu19NYJmNa0lp3iu4ojmvEXkrijB0dYHxs9GgF3y+Z8KapfO/kz0CW04y9uHYdLMnxdKw6oY5SjluUj3bbC8ux9OTOCUbSGY/6dhGz4SkJKVbzL92k8piNBY4jc2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(396003)(376002)(4744005)(83380400001)(6666004)(33716001)(66476007)(186003)(6916009)(44832011)(66556008)(66946007)(5660300002)(86362001)(38350700002)(38100700002)(26005)(478600001)(6496006)(7416002)(316002)(9686003)(4326008)(8936002)(9576002)(2906002)(33656002)(1076003)(55016002)(8676002)(956004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5sa2BhtJEHOS+BzP5/8NBC7ShBAZV1mGfIvIBNWZU5OxPplmSLK9rR7lSmBp?=
 =?us-ascii?Q?7O1M8JIbvdFCLtndikqWuZ3qlDEn/8U+Fit3hCsyDmcX5OU1MPzBN3fqM6zb?=
 =?us-ascii?Q?gT5KVnm8bjLOquVLvcIatRkxE+qx5AW0jcuN5ZHSXu9NQvOLLCVujrinrvo0?=
 =?us-ascii?Q?HhnRsoemm+J35ZfVUllSmHjJH6Fc0pE3UKvds7fliNidlLBIucY6CIOnINcK?=
 =?us-ascii?Q?Zi54VKp0tFN/hyma3flbJqZhS8UFZniCfVVlONQQoglXsTvfxDstZGol3ygW?=
 =?us-ascii?Q?QUGFM1z3WC70vF4S69d8rTl9hFJT9Spa1RZiCcTwTEi4scLBCS9K8vaECJxO?=
 =?us-ascii?Q?VdVWf1SK3QlhG1dcHqLeSR+wmKMnmUUpceJxx6+ispXiCxoD1e2e5fyyRF3b?=
 =?us-ascii?Q?nPSAJnT7VgWH3DZ/J3H05Q7SRFRZUCcna9me7AjlQHiDkzBafbYNDDwbACFV?=
 =?us-ascii?Q?mU2zQQEXxPCoyEqnfUSus80McGcb7l9gsCMrp9+DKeAmN5ZmldG7EHJb1i/A?=
 =?us-ascii?Q?xj/fdZ3ZeFwKh1xIwP8ZR9NUEOPwvKXNqtGvmRO1KCyNlEUxu/TFJkuK/yfL?=
 =?us-ascii?Q?44p1wxuHAdh7Bj3DzreTXZnHmtbxlzZ/WEal94PhaHBiJ7K//5TMnU4CJg2+?=
 =?us-ascii?Q?U8b7weY3IUawiBVAQ2jKii+jZYPLL8DnFrAEEzucYoDMtgEAG3QF369n1ld8?=
 =?us-ascii?Q?kD8HkNfcMaXGwupWHfIG2+7t997HdFp4s9NtfsOpHB8ZEr6jYP7t2HolRRJz?=
 =?us-ascii?Q?7PqAKG1LRY4Me2u/xxvAf7+5UAYi5MXSiBMv3tZSeik+9F6tR763WOHJwJlw?=
 =?us-ascii?Q?FPNdLeDWYUJcw4qKL6iiKH0IMzYIV1WyOj8kWWzd+AERd1wSs6NEg7Z7GB4z?=
 =?us-ascii?Q?ejEm5f/K0wuklHH2L3BJKdASoEWIfgEism05QjbTC4O9mcbuMLlJaZpwq9yu?=
 =?us-ascii?Q?c49gYkzvIEC0R6hlL/tyTNEojKMaliEzc34C2T6CW/zU1JG4fO/f1OL3ECPk?=
 =?us-ascii?Q?Yhwp7Ub5+KGNMKPL81tWYGwI23Y2KbCh+kLIhOzaR7va/EMU/kv9S/noDSQu?=
 =?us-ascii?Q?tMh/RH++OJgCqByMiaDQnWD98NqxsiFoCbY2+4cjiYwvGnGPSba4jWTDyXdQ?=
 =?us-ascii?Q?btpDyF3+h+3VhkVYA0eN2ZvKd7Q338sFHY0aDAZxHn6XSVVY8hLCqAUq8B4b?=
 =?us-ascii?Q?BKyPaXvq8+W/g0+c7TOmvbD5e0b09neR9UVkLjeQxW4en8I519dC2Vke3yjY?=
 =?us-ascii?Q?Wn7P11x9b4oVwCP/h29iV7/Hq9osk/i2BtjAV3xOIgsuzQgZnZzTl5VRs0+Y?=
 =?us-ascii?Q?4Kzuk+sfzKJc5Nq8XAQhIiQI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19946d22-cc1f-4e52-41b8-08d943b1156b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 14:43:30.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVaOGgOCs6XO7q2edd7kTaMF59PVwhz+0F11fPUtIDkm1YdGXIe3XBFOZ7sBC9vyZ9MopbrbmvyS6fsxYI8wXzGpTkETUQ2cqOnYlI5CoZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107100024
X-Proofpoint-GUID: k7qmlPS5cASjv27YkkpVlJ0KBZIMgXR7
X-Proofpoint-ORIG-GUID: k7qmlPS5cASjv27YkkpVlJ0KBZIMgXR7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 10:47:53AM +0800, Shuyi Cheng wrote:
> When obj->kconfig is NULL, ERR_PTR(-ENOMEM) should not be returned
> directly, err=-ENOMEM should be set, and then goto out.
> 

The commit message needs to say what the problem is that the patch is
fixing.  Here is a better commit message:

[PATCH bpf-next v3 2/2] libbpf: Fix the possible memory leak on error

If the strdup() fails then we need to call bpf_object__close(obj) to
avoid a resource leak.

Add a Fixes tag as well.

regards,
dan carpenter

