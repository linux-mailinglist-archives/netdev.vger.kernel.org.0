Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5281B4D9AB7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348073AbiCOL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiCOL5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:57:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B30517F3;
        Tue, 15 Mar 2022 04:56:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FBQ0cV008016;
        Tue, 15 Mar 2022 11:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=mbJ/NTO8WCpdBgnxiv60Nu/RQAPt/pVSPwgKA9pI1fU=;
 b=P1vYpNQgWavPwpEn/08Nzru4J1w5vSczsoPofTHgtAPt2CToeRP7xxrGppp1sjSn+X8j
 S5xNwDi6xfeD5V01nsH4RvASjwIutWQRF9SqGa7o/9b5avoZPBwIz+lnyPV3ScJVuusT
 u5WYOASpAvv2gNvK9LHeBioWGhmu/rXzwnV1r4FbbxbkQgCJOxBfRE53I3LsaKkXaHKQ
 u1KbJDgmSrQS3AcohosDGeXBMxhycHAGSB6dn8X1WMok5vZcD3S7M1QXmYltIFjNFBH4
 QuYXWji/V8RokPG8KnObF1f3ci0d3oBUcPNiXsjrxRmPxT3WfPLK2uDakEg7LN+yP26a aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6jxhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 11:56:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22FBu0UH186789;
        Tue, 15 Mar 2022 11:56:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3et64jw5w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 11:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feO3GNbx1WDz3WhBXJqRcktFXRmolQEgNxKnHdzxzKa0AGMMl2NMOitjbQCUietTaTklRgdAhYCdEKITcpAUceQFeEt9gyy1mg6VCQZlUaLQsCuh18YQkJjmZ4WciL5BhZ2j5g6oVjpDX4XBEueBYwwzDUVyRLuQF2TtGGIbCvRg9T8B16jAzuzmno5msCRnJsMwCi23OWfljZvZlCNl40fWbzDsSK/W+sKuT8RBN3vCypKAz+oKGJgXYxBymVby3SpQ5AzPTnsPgkgR9YllsY7LibVYdqcf//sVPzXyBYZG9FgdcqbATW/6APupw5we3qLo8a3lh6gn0cyQAt8csQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbJ/NTO8WCpdBgnxiv60Nu/RQAPt/pVSPwgKA9pI1fU=;
 b=cpXJNnN9x6+CvShciOd+reYOrfrwpjj3rPF04Q18xmU3JOpU5AMuZk79Kq24kBYmr1Q6RICb6LyYZgISPhqENZV6unHPvuDrhz5I7NqugLoBQtUN+gUw5+eg/YCo/yFQO6Dt01DGeXETUfU8rHPDGmqu2/CqdCr0KLhgoJOotIo7VvW00CxK1to+0omhqz+UL+fvZlhgL1H+WjB1jrAglUAJKLj8/7PVJDZkNnVAlq1c38A3NN90GAQdh+iBtXb05OBeguMDyM4wOjH3OHyBHn/EQATE1hdq//Y3D4YoaSqurCcwxVRj7CbgRjC9KhVDqbS9AlIPH4tCixUAhcbg3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbJ/NTO8WCpdBgnxiv60Nu/RQAPt/pVSPwgKA9pI1fU=;
 b=mB10RmNODhA8HiC43R281phjcVdWBf5fzHmxZOEHuvDHlP8vdk2S3nP4cvI88syc2m43cgwfYFPYGZrVWPPyxBjjlWeVZEf8Ttd4jq8tHNSHlHwg9JLs3uJMbyTiN34OkixkkxMA0Z/X5Rzdk0tG3z/3fperPgvIQJS5ZHB3lX8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1714.namprd10.prod.outlook.com
 (2603:10b6:405:7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 11:55:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Tue, 15 Mar 2022
 11:55:58 +0000
Date:   Tue, 15 Mar 2022 14:55:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     t.sailer@alumni.ethz.ch, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hamradio: Fix wrong assignment of 'bbc->cfg.loopback'
Message-ID: <20220315115536.GN3293@kadam>
References: <20220315074851.6456-1-tangmeng@uniontech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315074851.6456-1-tangmeng@uniontech.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97ac4284-3360-453d-c4be-08da067ac463
X-MS-TrafficTypeDiagnostic: BN6PR10MB1714:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB17147F72D8495B3F47DAEF398E109@BN6PR10MB1714.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfZVVux3dtCVepqrimfJ3QMemva2DpktofyK6Z2zHeLZ8seKCIrBQCJ9UMe59pcIC6ciqmZcdfeAhu9wJwcM1Al8BIrGS3muTk26i6eborX9MuskGVGKrxVdRbkMMJgpXGrsCWoc1rMUgQPQ1Q6z/7YI764Ks1QUXXz9LRVU62swcajWCO0TdT++txB4m6T5MaIpQDluAwfLPwFyCTbXXqApf5swSp5uxKWz6WCVJP66BAOHoyxAn1UaZiODILR+y3SUcFgo+vuXiB92usNr/RdekneHjCiZVEbwDuWSs4SEu1RRmaL6BDEhVoQze+vT1lg7up4U91PAmUkoSW69EbPky9rdXzRBztAI4SiH5BGaF+crvO3FdjOF15whD3SLppJrhDXU2wQb4ATokSXLEqpQu/m+1lu7sqrLe9vF+OBlpK8ySV0926HipOHbqTgNuSf+fZVlE0qOoAasWJlnHO6rpvX3c91LXGZOH5JGPu4vm6CEz5tuYMigSSvVor7nIO78YRuxEceuFwikpx4BzkWU6tz8d/dHaGheb0nIOlumqZkgx4jwNbJbtNRef2Du2UXmjBMP+SDedhbzdAJVWneI7eLMnv+IPLT7V0HWvozAlHZlSqh+Vdj8K1Wr0BvBGjVQ73TVS4Ai2kvMS4+Dwt6PkCsg/50SGP+71jmnln28AjVXxWKWfQLItTy13+1M20d9+qnCL67hbnwIiDQHhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(66946007)(4744005)(2906002)(5660300002)(508600001)(66556008)(52116002)(8936002)(66476007)(38100700002)(83380400001)(26005)(186003)(316002)(8676002)(38350700002)(86362001)(33716001)(44832011)(6666004)(6486002)(33656002)(4326008)(1076003)(9686003)(6512007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dr7RwxnWvsG1ypZAZ5c08Qv0sICiHTw5FDgClHcVGIAzMZ3McJBprk0tbUA9?=
 =?us-ascii?Q?kq9XEXgKN3RCcylu6cbOGKq5UnFodvERP/ir230frS9wC3jva7fQQ790RT/x?=
 =?us-ascii?Q?7m11lKHqsRrFuhlpJwKEmdlNSIKDCMhdS3fravY/1HzRwM+QuN9YnShapU/Y?=
 =?us-ascii?Q?6pCGA1h2A/ZqEq2U5zLynG8T8FCYwMllGRFnkB4nrMdTjtJ5rLxDLQ++l4Ws?=
 =?us-ascii?Q?xT6cxOgAVtKQxjiDOBJ9U2JuggMls1NNmuF5mDBFo76ZC56j52h8DazAzdGT?=
 =?us-ascii?Q?O9tHRCjuyM1/1VoHFpnPS/ylj4sRskN9yGME1kkWtaVidlV+DVJuPZOhmoRR?=
 =?us-ascii?Q?IAVmGA7bfr2o+OKnB0wpl3erXlxRfCaE2Q5iQpm79QzBwmaGcUoo4wzqZzPA?=
 =?us-ascii?Q?vOFnyoUE77FdwOTyrQ0aTKKGWjOJoB1/w2AmziquvNn1qnYSMgzfPZ6eccIz?=
 =?us-ascii?Q?GjHzdf9LzzWIoOw6X+iK/tYFB88+DCb6kyABJSVQCZ3qBmt726LTiy+s9VJ2?=
 =?us-ascii?Q?SUEAALVWAa9mVTcA8xMGJBcR8/M7y8wUO6rYprWFZldQsKO9pTc2IcZwhxrA?=
 =?us-ascii?Q?lDbRSIVrwe+q84PAZ2zZtFFszqIVl8nEO2x4gI1HAqkiRwvBtGaxL9+2X/4z?=
 =?us-ascii?Q?As/7CFsw9nxU5jZ/HxgHvczXuThqort6A7ZkSSCtF5hFV7bb/PQHJnJ/xLrq?=
 =?us-ascii?Q?bcwiGFGcL9XKUcRZrtNDlHhwu1b2JLkcRLbFXncyxkTk6CwO6PWlpxQafwQd?=
 =?us-ascii?Q?cCiXOmdpJmc0XF05AT0+V+MzWZebvlpQ/LN4qJCeIla/Rc0iUHGrKVmLeB+p?=
 =?us-ascii?Q?meS4VbqibA3pRy9MJlabDYih5pv6CLiUcCZ513csA/FEtgBUYPA8cVrt+cFh?=
 =?us-ascii?Q?35frRYt7P4nA+glybR2y8DdvUQFre2XKuEa023zivLdWEfWDs1HdpaVr1ISh?=
 =?us-ascii?Q?Khby1YkPh8ZMYa7Y6hvXaSeLR3dhNonf/RMqJOzqX+w5N6znxNW7prgnknXb?=
 =?us-ascii?Q?6pBUkHKKu+35JZG1+/PNvRCExYgQEb5+KP7V5gEZGBbjtJshn2l7aqFdWmbm?=
 =?us-ascii?Q?qRqxkbb6LBiGoETBmpucCqb53vEJjOzMYpwVLxsHQ8F9Vg8NMIA9lu2fwHbY?=
 =?us-ascii?Q?O9SAjUaqPzk82kQ2j5LAlcHos9E0fYJXKDZwn7/C2syqn5HHfqLMADco5GxP?=
 =?us-ascii?Q?Hbi8B1PXHIXrA6MWs/3SkVWW39PoVOukf9rbq7J4YEHOStJKpzTSzti1SbgL?=
 =?us-ascii?Q?o+gI4ZSZMCjxCTlDkTGfPCSTX1Lhs9ERU3Dsu1XPsoWdLVDMwZbmM0KIyOTp?=
 =?us-ascii?Q?kuxeyqYFzUgfh91NqE5GDtdg1Tn3VC/S6IRwmUzx85UCTYshwKku0tc79+eC?=
 =?us-ascii?Q?DkJCXLexy6XeYUJssedFByEsRTEOagKNeBj+YqhOuPS1nap6V+J6MtV7Eir4?=
 =?us-ascii?Q?MYt49Qs62D8jkTLRC+X30p9WKmtlSxl34ihLruWFtpvJeuhXXUnmuQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ac4284-3360-453d-c4be-08da067ac463
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 11:55:58.0745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGlJDsTia5BSfXWjpDQUapgJIFe5ip7D2FlMRiCYkfR3+PeWOUvhYXQU6vlmRI8+B/o7ko2IvXbtc2A/GadFhLMJwwA7WXCW5mCyWUdjglI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1714
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150078
X-Proofpoint-GUID: U4sXCmhNIhlhlaSguec04rvEsC_jNcpR
X-Proofpoint-ORIG-GUID: U4sXCmhNIhlhlaSguec04rvEsC_jNcpR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 03:48:51PM +0800, Meng Tang wrote:
> In file hamradio/baycom_epp.c, the baycom_setmode interface, there
> is a problem with improper use of strstr.
> 
> Suppose that when modestr="noloopback", both conditions which are
> 'strstr(modestr,"noloopback")' and 'strstr(modestr,"loopback")'
> will be true(not NULL), this lead the bc->cfg.loopback variable
> will be first assigned to 0, and then reassigned to 1.
> 
> This will cause 'bc->cfg.loopback = 0' will never take effect. That
> obviously violates the logic of the code, so adjust the order of
> their execution to solve the problem.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

This bug predates git.  :P  Did you find it by testing or reviewing the
code?

regards,
dan carpenter

