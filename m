Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A43267A421
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbjAXUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 15:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjAXUno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 15:43:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF54A14EA9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:43:25 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OGNj9F015069;
        Tue, 24 Jan 2023 20:43:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=zprLdHwEadxj4gdtJCdVbshYPC4IbFnhbSaFBFfqQpY=;
 b=CrslUibrX8sYojX79kt7Dtmw3Otz+xX8V0wPQ95d53BgWv2VdzjmFyk4lmdB0y4gvlUI
 rvkn7g8VAsy0f76GkbWpOi4I2/vKWtueQOXINwDxhZIk9I2p1oMBNXr4PXFqByagUanq
 AId81+Ft3hERJdSwiJrT4qwL80irR/G68FLSFiR3iSbvhfEkPBd0USZQ5OPL5M7vbNqE
 cgLmWQ7jh5H0Aos8KPpesJRPMqLm5hZCS6cCDInqf+rc6BPF30wH224lc6XvJBDl/JxC
 PUZH04v9llGAfTj5tg/C1TfxYx3QqLsbgRAADS/guaYpn/NKNO8qL4gR+kJSC6hC7mVX Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2xgpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:43:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OIsfeG025312;
        Tue, 24 Jan 2023 20:43:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g507qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:43:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqGu/WA3ahS+zCdFJfg14dOJqA3X2xmIcLIJzuGSw7VmQh0vB+/WTlAntTV7bPWCiore3uDnqtewOLPmGxzBDN504jqM7YMAYXm56riImOu3F0J9aLPAhtmgihXzV02STr8IkdoJ9Qj5CutuNg2tlpVLaZBZvUwoFRuy6hhJl7w6IGnog39XnUd8affMxp1qV0PmQC6GWcfbDKDh0o/027YvvdwgN/TjBPLmKtyeplMfeLDfYoNLROsCPw4a6y7yT2lz8jLYimp7T1QGnu1NzVSlN1I7dhoPKTDH+tMB/7hT0B+pBZceVPJI26MmlOLNC3pGGH3AynNaaG4h+Jcolw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zprLdHwEadxj4gdtJCdVbshYPC4IbFnhbSaFBFfqQpY=;
 b=J/W5uSvH7RF/xHLzU8NpodzJQosSbWmGh4DDEG6Q6YvuyyvGq5S6ep5ZUhLZD2Qzjf6DVkJMyEZk1JYxl6ZFtqafetMHiNnDnVKLyCnBDpZLMI6qh7CxjRMU6rSaovC41VXbDo/etoeDT8w9/UwN1ls2VvnALQkf0ljwa2jzIVzfMm3SkCdVCP4YBSIJlKschJWwJm5Dhos91p0fn1lMkFNQgzbCCRjjLtUDJrXzMwjgvxjBk/1c2kYN3BUePMk2/yLxNDeb30rk+1mUy2F4Y/zPl+Sq/SaHM9br6Jdm822S/4xX8w9kSnA38qZWZjibhdfiDn8ulKIMm/XuwwWQQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zprLdHwEadxj4gdtJCdVbshYPC4IbFnhbSaFBFfqQpY=;
 b=M08aU7G4io89UamXk6ZmTGHWmQGoVPfU3AcMBnAQ3GUVl0BPkP9T5CrGAIaMCt5V3mXJb/G8XvaG1RbMFyKuBxEnFq9mz9IGrSynqyGmM8Ukm5LgH78nq+QivSf1T33rMZZAotCiRvlPi+6KphVN+f9BDfVYievrQOABGNWgBv8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA1PR10MB6615.namprd10.prod.outlook.com (2603:10b6:806:2b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.16; Tue, 24 Jan
 2023 20:43:05 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6043.017; Tue, 24 Jan 2023
 20:43:05 +0000
Date:   Tue, 24 Jan 2023 12:43:02 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 a54df7622717a40ddec95fd98086aff8ba7839a6
Message-ID: <Y9BC1qpHDXXeXafk@monkey>
References: <63d00931.j+gAM+ywiXvJX7wP%lkp@intel.com>
 <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
X-ClientProxiedBy: MW4PR04CA0256.namprd04.prod.outlook.com
 (2603:10b6:303:88::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SA1PR10MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 608ed63a-c0bb-4dd1-bfbe-08dafe4b97f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7fW6Ao6gO1pkiDJYCV1E8AJsKAgtqtCHX9pvGOW23gqT0AC20e3JS8w91U5I51QqMFgIGv2s+TQCP+KwqTVNBtKFQYZ9uVynXoJvD9hJDqtuscsYPgzT+d/1/b064tfkkAghgxojwYwe+U/XUTWAPWFICE0/HPcDO9xMPQSNSZH/sa5b4xuxRqBkJ459tA+9xY2qAy7Fa9Swg4xsshl08R149ORFbBCm74weaHKNYqvp+iRe9cRoOfFYTPjvIpvasto73wax4ebpmjB1owni57R3FBaT/gnpC7zK8+lO8NXl2W6E4sXXd8bayNZ1pTKq3K+INabMpYjQo1XCpvDHkYr7gQq05Ugtaqcg5PLitOuR260w9B3ikApqOuCnclmmjELJ/Ha5zQj4MT5S2SJvcEAaWuPkFegIgOIjAMmytEbfEF5zrbRXoMvXOwGe2f6f9yd1/3qlhn7x0hpLaw/ZWrJX7ZqUFocgoqh/GyU4WjMo+eGYlWJj8lkJxnPTyKrDKRTdWnGXPxZ/nN/q4UWzGSOzY/ZUSZcCPCg/4jhaMgn7kQU3DCbUQaYptddQyGiSL07q1ToKfcdfZ5Z4cwUtDNrzXxaUWf6vDm4Pda02hvOeCHZEHvFPpWBY0rnE767iPs6iXeIBuqMIRKU1FPUw7XhiYlkLgytOG9SMXiD7cU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199018)(316002)(33716001)(86362001)(66476007)(53546011)(54906003)(186003)(6512007)(6486002)(66556008)(478600001)(9686003)(26005)(6666004)(966005)(6506007)(38100700002)(2906002)(41300700001)(8676002)(8936002)(44832011)(83380400001)(6916009)(66946007)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?udQx28KrYa4qUgBbGWvjp7nxjlCazlrPXhA+t5NQg0dBeP1PEIE+UYUZ0SbP?=
 =?us-ascii?Q?uvvbgnUux7XSnVgVLbUZDB7bYlbXtjUnYsmG8EkmfjwGFBtNnPPb0ow/SdL1?=
 =?us-ascii?Q?0S//GRHvgRwCp1X9oFNSbsfYs2UexRvRp2Tx1HadlyPsgsL9vg+vRlWwo4gr?=
 =?us-ascii?Q?Q1t3RhWKQtV/ZO/b5dD0h/q8FEpJF1PAObCg2GslnwL7a7NxTU4X2YU+Cg2W?=
 =?us-ascii?Q?sEYjC1ADE7SjdCsXDWb5ADfq0N3BUcvk8M6dYR52MXPfqlmSP4zUVjM6GY13?=
 =?us-ascii?Q?5jomdRQnpvJvuML4+s3IovDyYB4PNyzZJt0pMvcwYwBnipoP0dlB8c5cQFoo?=
 =?us-ascii?Q?HkfE3lNeMi5Pp0GNy45yy7VyGo0nsI/d8y3ET9MYDI2W/x0hRB7+kNv1jzfZ?=
 =?us-ascii?Q?GsbsgKp/1TIMAsy63UP1qOPGMKHtk8d2RyIfAuYz93kT1ALOVNIKexQoDxFy?=
 =?us-ascii?Q?GKLygbYxWYKR8U47Wvcdz6kHzDR9vZQo0UC8LsWO9r17eGJSfqVVGHbyVLDE?=
 =?us-ascii?Q?MHjpnbO5LZ/Hl8EO7cc19oNrnguUFz3Nrfs8pAHx84x4ENghLU9uQivSn/w9?=
 =?us-ascii?Q?oatmy7MRAMbfNt2tZPLcjdeH7C6XMzbo+G99lDvh6w9id+xCHR6fSqt6b1qf?=
 =?us-ascii?Q?2hp5am3xSh8ZF66bXocRzc3fj8ysPAjjh9jL8x2iEZaLlReftUoJszZPHkKX?=
 =?us-ascii?Q?eOslX5Nyq5P3ag92JWXUMUqXpUvmQEuBFfMbZ7WUXWxklAKzISK3AWxJAUVr?=
 =?us-ascii?Q?TiqN+s37NCl1P6LaJZ7HZJC0KavXNOOOjFzH0rETdrdgWk1bJgKH6FLy3c/H?=
 =?us-ascii?Q?R1NVSwKr8S+Sfzg8JkeTEely4lyMYnjhhOH+rZRaQo4WtgMkPLXtIRwuGvq1?=
 =?us-ascii?Q?wqiOmpP0GffQNRalIRjAg2TDFuBGAD9fFI4Rhwk5k54Hrfpf0fU6jUdU909C?=
 =?us-ascii?Q?HzAM5cgIMXfiPq0ACGt81Lg/Dl/5JslRqTiuUyR9HADyhHJ0NTzg4QAKOfHg?=
 =?us-ascii?Q?5ktSo5psViaH/cc1YENZ1x3QEgFurLdW3A7VwqqLlPo1u6IpXE2+IJ/x1Om2?=
 =?us-ascii?Q?rIEbSf0B8txjDbXXYRcB9Nb9p4+La1WjASZsodvwmKgctsq/imMHl+pKgHqq?=
 =?us-ascii?Q?HpVy988/hyHugLFOZ+h5GPYaUZlb+zTJKbx8ONJx2/30zE5L9CFX3vzD42KY?=
 =?us-ascii?Q?6ce6cEGLQV6xEx2dzqrIggqS6O/f+VzH/0spwIsv+gBh9Jwb2RIQ/0upBZbK?=
 =?us-ascii?Q?o3l5hxq+nH3cOK8D3HiwXh6gy6xqH12XexFPC1iMVwVib8a66T8A7Qj4DP0F?=
 =?us-ascii?Q?7JivgGBGUqqKobMzK68EqUfCpb6+wb/evlfftXCGg3qWt2XK9jAwYYntriek?=
 =?us-ascii?Q?q70q8abAmGB2Ex44IryKtUwqNB/RIGo9GkLpRBF5a0BqjmdL/6xLUUn06eTd?=
 =?us-ascii?Q?meNftRIOy68u/IXJamohVZNpXCWFk8gr/JeZiUc6O02vAj7q1vW4wDnTitZE?=
 =?us-ascii?Q?HAiPbW9WYQnTHV808GxdeUYJdEfVHeAqUbXj+DM7ecQ44eokny7nrD+9MEYY?=
 =?us-ascii?Q?+ee7XFa3ZRvm1Q20bNy1Xjg6tYO4e+IfM3lReBKVhSiBhNBptdsS2cDuvBuH?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?u5DNksGnW+wQLh2nHJ7qU+x3jLDo0XskMOycbgvxnLnU2SBCzPo0bXrh91ox?=
 =?us-ascii?Q?lh7KzNmby+HNmCwpcdpgFupkTGHhsNtXEVzrVFU4x3OXNpRNOw52FFQ1Z4jZ?=
 =?us-ascii?Q?+Lp2UblaqUilS/Nhe9wE91zZibcEfgQ0Rk1ZQ87iBNKOF32oaaRheYmvYP0h?=
 =?us-ascii?Q?BCvzGlNSXp3SkkyLJ5kvvxqfD+Uar0hKhCLBXBuEQzxvtST2dg3p3kw4u+aQ?=
 =?us-ascii?Q?qTYotR6eCJBE4kIpj/jafy4RR59K9Pmgk+gCKsviiYgl3imo/puTmon/fFAN?=
 =?us-ascii?Q?a3GonyJs4v0ovBIO7gKg4u0JSZpC6703tDYtiI0CfVyy1jo0RFZdpIqi4T+V?=
 =?us-ascii?Q?pIQ713/5Cwjx4zoUKkRGPsDLkykI/sf8yTMtawOgpAh1kbiXPeRPpi4KWatY?=
 =?us-ascii?Q?walSjLHZpptazTLSS/F58IPrXie9aLbsaUls2xqhVp3eg7ztFL9IwYKVLFG8?=
 =?us-ascii?Q?2RwmGkQGmbrRIJr7LTkUsEFu6jdbHVoR25gbT9ERANFw7QXrY2Qkau3ZMRQE?=
 =?us-ascii?Q?5YCZfUYdnfw6IrZfG9JIJp00w+ekoXzZcNprWZyuGsFZEOqNoJgKhrp6yi15?=
 =?us-ascii?Q?5KNe5TMdJpShx2qHBTrxvxdlmc3kvY43g5WL+ZD4zc5tOyCAD7mT/Y3IxpRQ?=
 =?us-ascii?Q?pcUYZj154LLBI/KudfgQyWASKTSa21O1mNA2OySjN8Q5xDsSKlh/7SrMimXn?=
 =?us-ascii?Q?JjzIM4ol/D2Vkg73Fr1a4jBtIhFMAwDpuR7Ha5/eiCAiySjgDZTLN6sChyYT?=
 =?us-ascii?Q?l2tawHDQpJoWVMj1PzsIl+j6kkxo/BJmTYvvkiAufratrtwa96Q68TDZFOjS?=
 =?us-ascii?Q?v34nuxINGxZKBdoszU/FM562zGB86AX9Kjvlp+psTf2CZ+djrezXeoRDD63V?=
 =?us-ascii?Q?JOhV1YnpDv9ZaA8Y3aO7ebUDIzseVzxK5GO/smOnRO1ngIgDWVtVbKZ11D0Q?=
 =?us-ascii?Q?cCmMlm1NTHGcmS8d/0hfiLQpn7Wmi/2lxfqOU3UPT7WLQkG0WfYcTvooBast?=
 =?us-ascii?Q?/LwhAvjOKXtyvscV27DmiwCzKjHQE8ozAYGZBP741fKxdIhEhS/+vo3MhbtR?=
 =?us-ascii?Q?pdiPk6CSjZMnsTXAdwLp5AB3z9Wl5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608ed63a-c0bb-4dd1-bfbe-08dafe4b97f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 20:43:05.3482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1Iafd8yDmfh8UKJDU4VhFpWQ/w/62QX8PZDKdMwN05ikGpXcCHGZoDCHeAHIEAQk65UuQhVhQ6O+WdkcN9aiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240190
X-Proofpoint-GUID: uRADl8ls5hJ8KkuXv6-Fc49HQAOd-coH
X-Proofpoint-ORIG-GUID: uRADl8ls5hJ8KkuXv6-Fc49HQAOd-coH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/24/23 12:28, Andrew Morton wrote:
> On Wed, 25 Jan 2023 00:37:05 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > branch HEAD: a54df7622717a40ddec95fd98086aff8ba7839a6  Add linux-next specific files for 20230124
> > 
> > Error/Warning: (recently discovered and may have been fixed)
> > 
> > ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
> > ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
> > drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dp_training.c:1585:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
> > 
> > Unverified Error/Warning (likely false positive, please contact us if interested):
> > 
> > ...
> >
> > mm/hugetlb.c:3100 alloc_hugetlb_folio() error: uninitialized symbol 'h_cg'.
> 
> 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
> 
> The warning looks to be bogus.  I guess we could put a "= NULL" in
> there to keep the compiler quiet?

I took a brief look at that yesterday.

h_cg will be initialized, but not in this routine.  Address of h_cg is passed
to hugetlb_cgroup_charge_cgroup which will ensure h_cg is initialized.  TBH,
I am not sure how the compiler would know this as hugetlb_cgroup_charge_cgroup
is in another file.

IMO, this was not introduced by Sid's changes.  However, I can not explain
why it is showing up now.  Neither can I reproduce with my compiler, otherwise
I would have sent a patch yesterday.

I will send a patch to initialize to NULL to keep compiler quiet.
-- 
Mike Kravetz
