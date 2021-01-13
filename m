Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C072F43FD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbhAMFgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:36:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbhAMFgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:36:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Y0Pg073539;
        Wed, 13 Jan 2021 05:34:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tY5jlh7p6ovlIAmbHQa/sM9dxNVff0dmzA98JE7ykuU=;
 b=naICQ/PlL1sUIeNeyRZU+qNyx0lJZhwTStIbtPh3MNzqB/tDZbUNtShgc0QVmJO7RJMw
 OWX3D+ERVWv8qxnawxB6XfqH+S8hOq2SJQ+dkwjySw1qo9BZCPWb4AEImz/rRhtBrIfa
 PmdQZ3UZO1X0FBx7XrlhIHiAR0HXOII1/MIsWjHIHSXgxve2DDcyexkNZ7TW4vaPpYEm
 8RTG6Ss6dX3wROE22gCv+q+T9YeeWA9ycaacmmEUlfplv4PkbIjpYQLRx+PHfKq4cY73
 ybN4lgv68iyQtfvMhmW35DGuim7od6j5++N5CdclKr4ejfnUPVUXFfSbWyeaVzwbWgcc Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 360kcysmys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5Q49s102719;
        Wed, 13 Jan 2021 05:34:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 360kf005fe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJKJvqWC4HldAVSXEo61y2LPw5bwI8QB347JYCsckvpME3SI6E4sQqi1oPtINANdscX0jkrHPAHim0pDneKH6BEvjEsFapYMdDQsyKOTFrJpi2K9vdjMXADgMlritDvOhcgn3jtvtGpTRwT92VGij773xBrCEIuF5NdaX+qNg/A6vJ2OXnccuyY3JMsqWrZHW+RRQMd1SrHQY7FA7rR3vUmJed1MSNIUfwK8rgsKCyK08RZKmDey/t/2tjtX0vhiM4h1VifaZkWQh7ZqmBXrPluwwL2i4DSiiBqMadub9TOT5nn09i8/MWVisOOf4nDTfxJuwYbPsbMJr8ZfDHfWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tY5jlh7p6ovlIAmbHQa/sM9dxNVff0dmzA98JE7ykuU=;
 b=Ju6LLa6bzJQSgkzIGL1MhHCwDIfHCF//A8/ebbntywrA2pRmd0JKP07BIPTUsAtAPnh8GCxJiqPptZkefQccXeG7tpLpYXT2bGVjpz3sjIhaCr++Ak8SENbaMMGmCwIhJyyKmcqBz3nekMnIhz5R6nv8LE779NIOTX6biCvxEZvDlHphuV+AXLY5dmpGzg/760vt3kVNByKLfe2rkqhqK4hVwWVRwW1ObTpYenoP1yZJkJ8zS9qfyix6p+sX5IbS4r5I1Ne+oQaqYbqNZSdDB4+z5d2K8hlfuiBPWhwQ+GJqQY/d7gxFrw7orOprHxTBHqNUKYx+KLlQgDzPbT49PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tY5jlh7p6ovlIAmbHQa/sM9dxNVff0dmzA98JE7ykuU=;
 b=c8HIUDO5TblzQBjyBIKbAqTbhwTAuD05jc5348FyqbC/pLvrkZw8nj13EVI8UG6ALhCNj/9y8pHDOx1XkzeOupXNgiYprgngSr6kbntADh6g34fq9RqF8y9PCFkVaerqZ2ycFF1U+ylVT3I4MTsCKKQa4fkHJv4ZgRKFRpsaDxg=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:34:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:34:41 +0000
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux@armlinux.org.uk,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: style: Simplify bool comparison
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn291jto.fsf@ca-mkp.ca.oracle.com>
References: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Wed, 13 Jan 2021 00:34:37 -0500
In-Reply-To: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        (YANG LI's message of "Mon, 11 Jan 2021 17:29:28 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR2201CA0019.namprd22.prod.outlook.com
 (2603:10b6:4:14::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR2201CA0019.namprd22.prod.outlook.com (2603:10b6:4:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 05:34:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53fa5221-9b73-427e-7c2e-08d8b784ecf1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584590DD6C1CD71A89FE9428EA90@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jF+uwUw4f2MLeRsqex7pIJLpGoi+yW/wgYXpaEf8YbDcf02JVbvjC3S2vHbPGwmqAMOzFAZgi50gLawxczDrDfiy1lfmvl28/x1G06ghL6eIKs8S2IAQF7RSeJ9J8inGXVk2E9JIklrvj1FiU6OfxVJ+dQ4Dv/KO8J/xkCMw/xdVtFno5q0qpGlkei5gwtyH3vQ2FCy5tIhsQiRXrwsJPod2l/Ul1AUF83Bzdee2pJBAblaEcj7NhIS+IPRTs/fS/Mm3Yl8xd71nbBHn5+5BPA/8NZZ2Bh9alV3Dv1mgJpWzkf/5fk/3SWNdyy1P8KrxAaNody58JENBDMw0urmaARce19X5FRoBi9pstJ/fAffOfgA5h72AEt7pfEMHLN6syw7T9GL51UEJFKzQGqvjPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39850400004)(376002)(396003)(346002)(52116002)(956004)(4326008)(8676002)(558084003)(7696005)(316002)(478600001)(36916002)(6666004)(66476007)(26005)(55016002)(6916009)(8936002)(5660300002)(66946007)(66556008)(2906002)(186003)(86362001)(83380400001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xPxNXv5CH+WJTkGPLcu1hrOkKfdL+zAB2D6SflQ+VnRiArckkIAZhwjaL12Z?=
 =?us-ascii?Q?4GUWPEwOJhatyVmvBk4wJVuzOuMTfC5fem1dGuaT0M/Lt/nfYX3i/JOR+Bua?=
 =?us-ascii?Q?PkdRLvcIhnQ88963J+4JxlymueLVpDp/rOoMPMs1mlVgKLRFKh47L4COP0wn?=
 =?us-ascii?Q?AMFEPQPKI77f9pkI+uVKZPm4FMZBdSPFyPrTatExoF+VarvncTyZQIWXApIG?=
 =?us-ascii?Q?fAxg3gDEQNaLwl6upentuU8bug+TAYLyYIZkgF/rWylYgriehuGAMhdgw9ln?=
 =?us-ascii?Q?Cki9qmtLPEWDojwCsa9ezmXlYJFI5oLLf6mn6q9kjhyl7SFCgN0CKWHkgINi?=
 =?us-ascii?Q?YWwkavClqfqoR9u38tU964OOcYOhtSU5mpFna+owk4b9PhLJAZwtom8VhGMY?=
 =?us-ascii?Q?R9YERKTQ/UjZwV/UCpJz0ummp10EUnEQRCEWz6Gjn9WwFShO+MZPW5nUKZVW?=
 =?us-ascii?Q?N6YTPjKtaZpoCBrqq+xqTpgEcq87Ny8Tnr0ffaBOtnutuyOkFKxWqlcQ2+bK?=
 =?us-ascii?Q?Tt5Iur6pemTvGebpEHcfNVSk6mKpa3+40UXzBIqiFPdW3e41CM/J65BfCX+E?=
 =?us-ascii?Q?ZxqR8Px6eFordzkZ2K1kDN99izRbMfIfwdSJtcHuuCTz7G0q2sGe7yYKUVV/?=
 =?us-ascii?Q?WOkHdh8dHnuKkMnYrYLApSADx0TFHyUbCh8z+cv3HNmUAtw1I2+XmHmbL+QA?=
 =?us-ascii?Q?hVI3QHFJYsUTByHymrWIEdeLc7VYHaLGDdMfiauWRkIA6ReLTCPegTVsLwcL?=
 =?us-ascii?Q?BJVeOA0f7uhaloIwxsTWNqoVo/gpKMVrBTr8EU+R6ajhkO0/DjhmHw62ak/z?=
 =?us-ascii?Q?+otAt6yHYKQmfKojU+qJ4ACt6Gd26nFV+8aESSOKQ75Sr6sr5NPD/x88hhoW?=
 =?us-ascii?Q?0a67RVx8DmRUXFA5ofcFAArV4aWDLzo3BqtyGG7amnsK2VcjPtk3Onxfpxpk?=
 =?us-ascii?Q?FSxMkhh1EvcQvF2j3hPuf2lAtYZtLhXqiu0rcWfvbCfcynClTaaJ8TOJ6jJX?=
 =?us-ascii?Q?OWLF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:34:41.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fa5221-9b73-427e-7c2e-08d8b784ecf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bndykdNK62uFFR0GkErNpfY+qDibzHRF2VabxuZ7dd5SYaeAxOqshYsEi8XCVQhWhQg6JJ8Tnt/InsTiSJG/STdfcnpH1hlAOonIULOCbY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Yang,

> Fix the following coccicheck warning:
> ./drivers/scsi/qedf/qedf_main.c:3716:5-31: WARNING: Comparison to bool

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
