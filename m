Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D50571618
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbiGLJsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiGLJsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:48:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DE21CB3C;
        Tue, 12 Jul 2022 02:48:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26C84b48030511;
        Tue, 12 Jul 2022 09:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=tdaHExUSjJudctnnNbnOV6jcCaLpVYdyFQx13qUZHx8=;
 b=HwbHrZlQ03w/es/nIeIVZzbkOivbzSUk3kD3U18kn772larF5VoyQMTIiSQhaar5Teyy
 DUlNQ9J9T1spd5D8PZLxvbNZyexk/B8PpurqOtgNFTMM3edxIBl0UOQf+d2759hL6f89
 +No2aHfcVySTX+Z3kIUsg+ldQz0mndLOcg0xyvubgDa/PryYQXCJGJ5uxhwI7yTsuACZ
 qUWlexAg/JXsGYSKNGib8HU+SpwcHzKMNNu1wB6pxfQBx724MkDFrnptpYzz5K7O9N9m
 pht1q0eiEZ6RYmV0NitmcVUXhvzE/L0HLJ7YUUCLp91jiiFoi7cVrbpO0RTu3yQsPVhD sw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sgp073-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 09:48:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26C9fO9L008457;
        Tue, 12 Jul 2022 09:48:06 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7043g33e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 09:48:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBUTk6YgMvPcqpTxm7odMZiX2TR/+oc+dmVdpZJREE5lBz+2sIeaLL4q0GWEwfVU5dJWsZScVQvOozwCCltUGzgh7qtb/XmcsGJ6q3AU6h3dhCTGOrvPQT52Jkp5fFuwBHh+p3tJ3ukpWcU9nPFK7IA6HLU44EL/s89DEeUJhcY79z/79lcDqMrBeOWbZNYNmqfdZ6EW9u0MBBRTn9p7/QBMb9qsRCUKrWCuZJSsH7xz6jCo00KVcYUL6y5KxH+I/mZ3PYp2cnZH77n7UPib9u5eCM6gDStahWiBkVHWqh5CdK51sVsdChSlRuN4x86m47kHt1+imjcVTlLwtouM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdaHExUSjJudctnnNbnOV6jcCaLpVYdyFQx13qUZHx8=;
 b=FPaVj/Xsl7JaIHdci0aCVtI+jD1wMdqcno2Xy2Vfvn+zTBn0MHgt1yC7FevsEbGNuwn4DB/FtiQM4RbS7CNH4reCk/AYurj6Yyg2/LoMUgGK7jrrmiEn1L05w2Ah7mWkd07/ePLtfWYXnkVa1RUr8yRUtSCTJVW5s9NspI4MCPY1dampTI3IX2RvbVqXo0zvNw0jBo7n1JUzL6CUJu7dt/7cT9EzVVKnluwXHsrJ7Bsm2ai8LcUsNwvPwNJLjVeIj688EmK7Hw5BRO3GGMYOFeYpcN+xAmCe/OBpxM+UGX1si/rYFVcFofYzTNy6m2MA2jK4rKnrkq5i8ysHdaw9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdaHExUSjJudctnnNbnOV6jcCaLpVYdyFQx13qUZHx8=;
 b=D7BphNjoUSqO9IrvvscU0UyxhYZiVt2yMIVlCYbhw4Lfj+M+LJSfA64Gm7rCSdHKuNdZ/Dp+ndy7CwkoyONeSnjV6IPct1lbui+BC+CEF5ErQgbJ0iSXqhHZUx3H9AnRMDDu0idsBoZvcVfJ9LhiT1q3RejAgk7101AnNEfVdQI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1525.namprd10.prod.outlook.com
 (2603:10b6:903:27::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Tue, 12 Jul
 2022 09:48:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 09:48:02 +0000
Date:   Tue, 12 Jul 2022 12:47:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        andrii@kernel.org, ast@kernel.org, borisp@nvidia.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, guwen@linux.alibaba.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        skhan@linuxfoundation.org, 18801353760@163.com,
        paskripkin@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Message-ID: <20220712094745.GM2338@kadam>
References: <00000000000026328205e08cdbeb@google.com>
 <20220709024659.6671-1-yin31149@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709024659.6671-1-yin31149@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0178.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8f86f4-0b44-4989-911a-08da63eb9ca4
X-MS-TrafficTypeDiagnostic: CY4PR10MB1525:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmmRMrdpwP9mq70U5XEJo5qx/PDvgMDpE4/qTIaZrgs7rOb2JrTXbnndXO6D3Sv0Bl7syWKrS/iUNJwYaYBv6y+EyPelBjWCV/vPXqT8hEirPPdjKKA1PsFGmqQrIuQ/vv1KYjYPNJMIR5HlNjrkR0RIscu/7CuainT8rKbYL8kf9l+nstnYVx7rGXQEYMuRN0WVIpGVBCXSKMGSoEJP6khCfwgWoxZz8TH6tDLcjZHHrAks0m12Xrng2CTobJtKZMNGw7FLSqd+AuQfYy+ZFLS43VA3lYfbWCM+cnA47yfrRj3Pun34gLMsYffcIZF9Sedm8qM7z6tsaTPE24vmgFje7ooWa9J92xS1s99BTqIfk96uIh4SKkJWCl1MrnQji9XA4dLBy6kLSklrAIo7KhJpN2aIH5XVci9NP3H7PvLgrGGtjwKVopIrxoxyqRRRtCsvqSu14WXZU44lUGYuOJwHCnRhAr1B5bEbQbn38u3aQMn90iRXt/e/5SqNqVFRTCQIybODoifpWy6phAzoPI/LspJrI5sGn5gItXJreUFAmlq9gQVT74nT1EZ12h9NUChIMxVpEJFY6+In334wVsJASZ4kttgJfvx+rzgAS6RxR1AWjTxm30b0oNyBGyTOndRK7OVDKsiS9a6eG1h4j2Ca1Thsj5ApCiceVdmHRFgF9rrW0uXiV6AmhbbP+GuNgPXfLQEbCFbJusApVaxTX/Orp+dQgzMrwfhP4nHoA6DH2hTzJubltyN5mwG9Ej2xKGdkNEdJneRihTEtwNgsZ4AONtJyrc/JMnhyUC47VQduLl2taKzDkDcCVC0PmYj+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(396003)(366004)(39860400002)(346002)(376002)(83380400001)(86362001)(38100700002)(38350700002)(186003)(44832011)(6916009)(66946007)(6486002)(4326008)(33716001)(316002)(8676002)(66556008)(8936002)(7416002)(66476007)(26005)(6512007)(52116002)(9686003)(558084003)(478600001)(6506007)(6666004)(41300700001)(1076003)(33656002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQyg3juU1P8GRzfUtCv0Gf2HglbinCPrHzIgfY/m+Wx2qB+q9o6AeiG5lvSc?=
 =?us-ascii?Q?LK26IY8a8ELLoyNTlESWi33Wx/ZA0uH59ae//EC98KJ3g26A7tx3R5mbem6e?=
 =?us-ascii?Q?FQjIzdc/+6dTHIUcEWEBkvhyliwW2FOojpXHthRBFEr6SQ6zpkjqqHR4gZmU?=
 =?us-ascii?Q?afWtCPMPSa/gGwxYSNA5ck4yb6gT5IPOb6wPUjbhpsRLKfGSz6eqKyCcx2+C?=
 =?us-ascii?Q?Nz0GIxmo7kWdhzSX9VlGuO80ST3yTg6rcrLDplPTOiOUnmFWnEDzRHBRkH7H?=
 =?us-ascii?Q?ak4qcAXdFewmZI0MC0rJitHQ9OmKQqYijn+sJnN8Dq7waIVkP9uNH9lW0w5U?=
 =?us-ascii?Q?fsSv78kUmOXgwGTcasCQMMdxHk7BO9ycmQzeWOBP+1be27ga2EqKM08zKXYh?=
 =?us-ascii?Q?0kzvPQx+fwmxbXkq5qk4BY2L8oWwQYq/QZL5oilZyn2lB5QgYy17FQ1r4yTP?=
 =?us-ascii?Q?LCN35KT+m/gD9yGvUvzBxAL12uhvN/kl2yXg/iWRiXtnPS76Kj30n1f7hNkO?=
 =?us-ascii?Q?PLpNXoDNDpUrMcDxjHUUmQ5tSNtf6NFcdDwyXDX0zc35h/HNEFzcqKfrrB5N?=
 =?us-ascii?Q?vPrxRDp5aXb4VwfbLLlOhmmj6gV52VFWGFgvF6vct74sQV7URYnKBUh8vFlU?=
 =?us-ascii?Q?+nA4PgioCE1UxKTXhLj3+FKwYLMoMpLKDIH2LUqsSynFhvBXT/R0gCVeocc4?=
 =?us-ascii?Q?KhFE5cvPt6USrivIb1bFA7iRIYTQmqJxjAfv/iFZZRanK33DHhCgzmX7M6y6?=
 =?us-ascii?Q?dlImy6ex1hXpdXekktTADfiQF1FUGQ3kblQH3jZZp5FIL7oYP6LKqgDuvJ09?=
 =?us-ascii?Q?YQ4syWQoDfCrJynQiFSbzgYrOmr3IsAQZuCEOJyPNBL5+82lxJ6DX0qtbFnO?=
 =?us-ascii?Q?gBcDJEQSj6Z0u7GoRa9lO5o2S90Uv7ESWA+v29RxgkC2x3wX8k0zHSqn2c4S?=
 =?us-ascii?Q?bKKvsAmVihrsSjVocBw6eohYS/donnOVpgRkGOcDExPKvRhm5xwUkeyYTZtr?=
 =?us-ascii?Q?UyIra0utaDuJCu+exzk+Tgfylz4bwrGQEg+ZF+/qRup0ybhey/6aJqhRV6ZR?=
 =?us-ascii?Q?fUeZKrDoaILNCfJxfcQvv1t2MekPUTjzgyBeJN2vJ2RkwL+2BGUL16cVk4c3?=
 =?us-ascii?Q?YY3/jZ8v2IBIxiHlQokPCeapXlzvAG8zqjOWH3QbNjyhmXnDqTJDpBn5ooUR?=
 =?us-ascii?Q?FZ2iVsknKLKu4oZ+A2p6zZNEb4zDo6uLF5JH5bXLnfDKTon1DVSsJ/YeF39X?=
 =?us-ascii?Q?ZMGdoXKIZwdMTLRvs+O/HoVmFryP70k0o+m8erJJV0LGjGESsa2WiG6gvcVm?=
 =?us-ascii?Q?BGpgTDDdb9fUEFF6f+pukC6MzweS9SIiCR99q0225c6D637WGf+8bQQVgjOL?=
 =?us-ascii?Q?S4QSz5s4oMTAKFQ/2lgHKF1B3i6kzevPvd7nQUJ2BxW6KsVpUn5hzbVCVd7K?=
 =?us-ascii?Q?q+7jScFxucN84DBSr0sHBfOlnlrWrWO5DVIZmPgDm5NXZPVx1pdsWO/zf8eQ?=
 =?us-ascii?Q?wdTEAbHTa6LGePX9+XgL9vaueFZlIzJhFCfaNeRyOoDJ1FlFX/5dfaLnJHAT?=
 =?us-ascii?Q?xYQuqpKFCdyZx7zk9S5EecpA71+tJaXYqo2pi7z9Fd5PTT1ZrT+smxa9KE1V?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8f86f4-0b44-4989-911a-08da63eb9ca4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 09:48:02.5810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzTU/YZEanP5XpcguOXFWo+NzNvfjvgSnyx4UHwM+ic/nvEXJcZwaFHr3FsRlxCeeclarbCInhqlnzJJoFPgokGRdbXEfpPSLojalNQmF+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1525
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_05:2022-07-08,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=973 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207120036
X-Proofpoint-GUID: weWgy6M75EszfCx-IcGwbd2mpgckcYsf
X-Proofpoint-ORIG-GUID: weWgy6M75EszfCx-IcGwbd2mpgckcYsf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 09, 2022 at 10:46:59AM +0800, Hawkins Jiawei wrote:
> From: hawk <18801353760@163.com>

Please use your legal name like you would for signing a legal document.

regards,
dan carpenter

