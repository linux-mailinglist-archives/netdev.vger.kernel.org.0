Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F48757F97E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiGYGfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiGYGe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:34:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8CCDEBC;
        Sun, 24 Jul 2022 23:34:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26P6MGVt010345;
        Mon, 25 Jul 2022 06:34:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=DaevZI/IrTHjZRpnX3Pz0DWDuSUlnciDWnCzVqaz+Q4=;
 b=3eeq75+28VlcIOT3gEY7kAQwECKXybzdsUKTU2sIzxdSGxZ3dNPazDmiT4Z/ulvwWWlp
 V0l2whoT4tD0sVCKpmCS6xvdpCLDT4kFbYkvVbZIrOTphWeyxgd1G1H5UGsnn/urWG7m
 9HwvS9/flWesAZSz1myQ22EqYLchwfSTheJrNNJCW6wo0jvYOTfUrpyCJGuqo7yII3nV
 2fhoibk32rzz+5lbgky9KqXch2D1ncdkRhL79Id2vLQHJS4M/sWiw8xIiJCn6xVaef4O
 8TwhQNEYoymd7aNSLA/XINuM5uYY+5CKYmccANuFx57OLFKruDjmjHwnIRULpYJeOjuQ WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a4jbcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 06:34:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26P5W4xk006211;
        Mon, 25 Jul 2022 06:34:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh659uvte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 06:34:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3rUtEtpkPb5fM1fWFMbhoWSLNjbCZDclaoKy+aWuZ+hUiVaniHQbqBtzyJYYjxwGOXTIhS5iuszDnyoSdN4CbcOOZVy3UCTVVzt+bSEaN/dZPrq0PEizCPjAA950z4O59XQYLJpua3xVppPvwyoF2pxzkoD4e8TLBjutF96fmJ2Fpjq/dStdVW/Qr9l2KpJNFmzWN5m7h04x2iHNXkGLY4KgO3pKnvT5LBUZ751ySa4G6iacLtTyppv34NB89bsc68i/5bOcReOxFtIW8Pif3bqX5Q/4BpUA2lrGZFl69nAjHnfbgM+4tqPmeMJK4jzpYqJ12SaUQs11cWyIaNc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaevZI/IrTHjZRpnX3Pz0DWDuSUlnciDWnCzVqaz+Q4=;
 b=bhCzjPkxbqMRjh0jKae5Qs0wKmTmnhEcBwDHNGRaQwvglfJlsJvl5TOl/NGfpqJGEp9G0P/Jf/9ZARXPAs/sFJV5JzWCag1Pd23KzipJoRXmL9NjB2BlyNbKgxTJWJjq0yJ4RBKJp05Tr8IgpPJUKO6wjRP2rnCUCE9ILlxWywPoMQndJuyZyC3R70l65b/YnAR8nmyKtEnygwCX6bXjtPgw6vT7oeuxrYRWObt5lWmf3JG6kpGLZJU5ClpaJx0NDoWIzgCc3O7+g6jlNEu+ZI4CZds5mTnOteIS1Ys4xU4iWr15cQBE/+q9nO1xHKLbbZiRFg7O0OuUMyQg0E7osQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaevZI/IrTHjZRpnX3Pz0DWDuSUlnciDWnCzVqaz+Q4=;
 b=ZBm7UA/MSAoAnQ2WtGhddeeiRgQw5TYJH50errc2kY0jg3DeX/ukqwMk7kL6dxaL8pMMtlrL4za5sDC/ZROg1enuW1F8Y5xQyCWNv+4oxT93RhW08EhrR7iRpSHAWrxxD4zN0mOXvij6hvkEpQhHcOzsmNa5DOq30DcpUnsQLgs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1313.namprd10.prod.outlook.com
 (2603:10b6:404:43::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 06:34:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97%4]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 06:34:23 +0000
Date:   Mon, 25 Jul 2022 09:34:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Kalle Valo <kvalo@kernel.org>, Kalle Valo <quic_kvalo@quicinc.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] wifi: wil6210: debugfs: fix uninitialized variable use
 in `wil_write_file_wmi()`
Message-ID: <20220725063410.GO2316@kadam>
References: <202207250332.5ud26AGE-lkp@intel.com>
 <20220724202452.61846-1-ammar.faizi@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724202452.61846-1-ammar.faizi@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0010.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c32f5ae-f7b3-42fb-e762-08da6e07b6b1
X-MS-TrafficTypeDiagnostic: BN6PR10MB1313:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJUH70NGQTjdb43hiYYMe9MjVe0MSQVLA0j/v7rY7azU12DuL4fxWc1Hb0K2J1K1DauXdfyx+d0pqyTBfLGO1+59rCSmr++hp6loJhNtKj5e0lHw7RTZJbphOw306GLIR3XMc+euIb+bLK/wxayyKRIFTQBHqT+pFgZLIdbqGhCzuH5CXmsz4iDQjjH5veSOXHGJRN/G6XKGIJwk7OaFVfVlGmk6Myt7tWX+TuRTmHysOmODlYPwKbYAMvGZ4pT0hVSP5noZK8XM4/8uB0jEm6VIOdLImR951WqV9uXZgHbLCgisTR5LmzS0jC0RHZyaaNF66O6S8Ja8UvKyOlfhZd1lsAttKWDmSRmyq7zBGmlYsQBSMdreJOp+HDIXdYW+TEqe3Z0iT6DyyQmEv7G7vsCUkCaPEqaosbcYcc16zcXwm4kx03x6ryz0BCNsDqDxYHNHL2dbg1o51LcbTnDLsjeY/ZjddFK0HNxFlE6Pugh9l85/fNP2tZ6f6x32cMLJDEH5SF5L97lA8HSoQ9imfH7+5CtLEL2A60vQN6kWO5FP6+yDP0b01Ch83wzAc7fljKgGV0FOwa406S7fB96Uf/hoa23pR1T868JvSpIGHCQLtxhNsANWxS8s4LaRED6WnsXmX0jOylsT2sxlu7nV/KJKg6dCEqIFrGL6/N1Orl0jFCfu+IIoEdquiy9e9+cZZ5oqWhZOxcN33Aksa5OVKTbIiz8SByQ+OiXKyjwv+BnlvDJXU+qL6tjP7tf3kuqb9cebyUj6HWzQ7DKFCfVsico60Vg5CfxYUdPxqYFEIzROIqhVF042doG59EKDBx98
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(136003)(346002)(366004)(39860400002)(38350700002)(4326008)(6486002)(38100700002)(8936002)(8676002)(5660300002)(86362001)(478600001)(4744005)(83380400001)(66476007)(7416002)(66946007)(66556008)(33716001)(33656002)(44832011)(1076003)(186003)(6506007)(6666004)(26005)(41300700001)(6512007)(52116002)(9686003)(6916009)(54906003)(316002)(2906002)(81973001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dU8W89Hu4oCQ2CiuSiHb3C4Bf2PnGmtWBzpDAwVhbdyq53kGzhQLn974g2Dt?=
 =?us-ascii?Q?4ZfIImfePy823pyyCOY8IVubKFoLn3RTPUJnSGgr+B5/7DfDclaUw1aqo23Q?=
 =?us-ascii?Q?VgPrpu4u6d21j39LI3wMoRCvgwYJqp/7JzNtNHvgq6uqLOU5rLF+RF9eu218?=
 =?us-ascii?Q?68UzLgHzPZ3508WestJC9PJNHy//5ABRfN6I9X/FFB4OmSmb5rSEs8kE727R?=
 =?us-ascii?Q?vCiuEW1gKXOGJKjudGwanbOylxQjyV/BmeWLoM1VF26K0V+QqjP56G8t1t2t?=
 =?us-ascii?Q?DBi3hSpK25MeJeVRfT+oiRP8R6w/2OYQJptsVymsQgBi067ZMV6kUsFcquPv?=
 =?us-ascii?Q?WJ98wtSNxndcxRJl3fsaqSejudjKqq+AkenxkjmH39RhdTQwWa7kA2amXCkS?=
 =?us-ascii?Q?ceWlcgM2C+rpggw7Wg/nILsrqWeWE6q0uHBbCHDX4E7m3TbD+QVUFUogVh6B?=
 =?us-ascii?Q?IFXeDq5GoQtgZuDIfbMT1432R7FUPyuW+a2bMQFhigq+THWnOirKq3ZdVUCM?=
 =?us-ascii?Q?T/4dkxa6I7WZCJ46P0TYf9aEMB0tqsnHGCAVW4BoplvT19sHB1MB/EyRwnC1?=
 =?us-ascii?Q?iYQOexlEM+6WihrR/csZmv6iNSVb+mRo6lkS2xxTf7vvkwFmOdh4TylxZTWm?=
 =?us-ascii?Q?q7rHY77pRDj8ZEr1WUS2r4ioSC5onRXnP+Ad8yZswJX+K0MHv1w32R3UrK8W?=
 =?us-ascii?Q?95ZiCojIA1dt8BR/mNHRNv0X8W2Tm0QbfsgjYiF4K6jXNy7ESKBbCeBMXpD5?=
 =?us-ascii?Q?VTalxWhfOFgvGYkxfoiTyyKI3+GJ4awShjnnOA9PItw0o19TUyz2L+jNa5Li?=
 =?us-ascii?Q?5C019nY1vzv0bUax+4QC3Ihb0bi+qaJbpbq7XhFa3QJKHpLUiJmeqNVail93?=
 =?us-ascii?Q?KRkTunRIu7kdqrKo1gNizH9/OnIxt/1d72UvqLPTaHEs0LtqPy/DQEcUElxr?=
 =?us-ascii?Q?IFQGdlwc8w5wd+48bG5I2PmcmJZKoWfbnDaStugq8hTt4sBnnc4r8CcEkknH?=
 =?us-ascii?Q?AKKQWPM7WU2tLLTPa0u6Q6WpHD2o0QF+ed9te/+J+Ebkudv41w9g/a7DQFLY?=
 =?us-ascii?Q?lKKI2uigQiKrCYi/du6sRgJljV7fxB1ezqA4AF5IeUDW840XWlgDXrE6EN2t?=
 =?us-ascii?Q?EW7v23vFsW37+Gqlt5GOBe6HqJzHY3tbgo8DVjAxAhoX51RKPfvqAdj9AFRd?=
 =?us-ascii?Q?1WjEasKJubsYGedFddZ0YijVUW0w0HXENbf7HaKl35IU8cZs8zcgBoiZoByp?=
 =?us-ascii?Q?vAoH/OgZYm7M18cQ5lTSfQVA11ouhnP6mP4f4Jv8c/Uj84LBWR6f2sJc9PIf?=
 =?us-ascii?Q?LQJyk7ThLAxAQZKm8gOl/1UABOIiMUFL/W2tzRmz2O+dEZEUKyr833+L8STl?=
 =?us-ascii?Q?FanauAa66t20radDHZajeSGGNmxfxEfYwFkJVzjLKasUYxnV31rd2vUjpjO6?=
 =?us-ascii?Q?WGRibayVt12OseJYQ8XHyHFzxSp7nSnJCbtdG/OGvGumCyEb1h7Ms9Zzu3+z?=
 =?us-ascii?Q?AkCqPnrjrF/kwubjKPv2MzeAYsjET11DOAm0/H+sqsuO4qH5sSGSDOgYRtkS?=
 =?us-ascii?Q?E/TLBVUS5bR2ujngvTMmegn89oooxMHGPfWEWimf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c32f5ae-f7b3-42fb-e762-08da6e07b6b1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 06:34:23.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zurXpY+xR2+O3VCq12s6navRVOqVpjW96QAcc61RreTiV98CZ175WN3+HxA9nqEgqjnTR1OnByDNMchCLF6xC98kUR12UQkLA99sEdmDcPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207250027
X-Proofpoint-ORIG-GUID: kz-mboZuM1_4JiFk8hT10DtbaM-CEOgl
X-Proofpoint-GUID: kz-mboZuM1_4JiFk8hT10DtbaM-CEOgl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 03:26:18AM +0700, Ammar Faizi wrote:
> Commit 7a4836560a61 changes simple_write_to_buffer() with memdup_user()
> but it forgets to change the value to be returned that came from
> simple_write_to_buffer() call. It results in the following warning:
> 
>   warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
>            return rc;
>                   ^~
> 
> Remove rc variable and just return the passed in length if the
> memdup_user() succeeds.
> 
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 7a4836560a6198d245d5732e26f94898b12eb760 ("wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()")
> Fixes: ff974e4083341383d3dd4079e52ed30f57f376f0 ("wil6210: debugfs interface to send raw WMI command")
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Oops.  Sorry!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

