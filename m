Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03200325A7C
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 01:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhBZADG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 19:03:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhBZADD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 19:03:03 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PNwlVO027465;
        Thu, 25 Feb 2021 16:02:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8mZx/zszlsTt1SHRiquv9UdeIg2vSsLrk3P517iv9Ew=;
 b=h1/T2AkVxPOEkclA0wZxvPwFLni/o7nH3AZZarI28TcqoQXP8dFSIC1BqBFQSAj1NBFG
 00OYDRnbJSjeWm9x/658CzNwBzU2InB9bKLFrsMAeIMQhAkygrJKs0E8vQEMxpLbzAdx
 D0WkeMa6s8hw8EsZjAwOYv0yXxcLLYZ8tMM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36vx7s9svh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 16:02:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 16:02:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mlyj1wJXE/lv4kiyjbNaR3xsr5srlQgXpm0OnJtcRTCvpqYVs4/7RBvEPODERpVgJ6CsewNgs/+z53KqbTCfVtnLqpZj++gbAL/XbLL1rWALddm4iYuNzg/nYzQyVAxwnMf9vODKjnN90mNMSa8fMl1DpSx3TDCiudfBA3Sv5djg1RO5rjHGiRVJkat8mRd62fr0UfmSWcckHraNfm/518U9kT353+DRMJkUKqNQXiUeE1pM6XOP8VWXK8rp4U4Xmh7L6+3pSiZrmX2S5wtFRLpe7G+teQV6gFwc1kM1D70H7lRXdU8q/KhUYlIk9KuRxr907kRW/iH61RSNnjUw+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8mZx/zszlsTt1SHRiquv9UdeIg2vSsLrk3P517iv9Ew=;
 b=dKZqh5z/1ifqZysLcKvT2Rj1bjZfBuk5UCB5oa8iBJP6BHJKrb7yBogd9PZEQ7f1AasTxLY8rCgyJeH++fxGe2d3o/y9O32oH0vobMS0KuV1EC4GWnvbgqWmu1YvBjt1wVTDQg2Rzl43jOihPAzNii1cOZblRjhbegQJMix9c1cNZx6Sie9Lw+KHcNX2C1WEa6P55bJiHZTLrMMKV9Sbd7SxpTqcIt9KMla8Ltbua6di57/2bA9nA4aROoP/FtIayCT2OGb+TdEj4sPOoTYZRUfbovgzXDmG7UrZwVwGZOIGhB70mA9IixI315L69x7dBvNcsB/1RCJEmxdYT14sNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Fri, 26 Feb
 2021 00:02:01 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 00:02:01 +0000
Date:   Thu, 25 Feb 2021 16:01:57 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH v6 bpf-next 2/6] bpf: prevent deadlock from recursive
 bpf_task_storage_[get|delete]
Message-ID: <20210226000157.yoe7hbzocavn5udk@kafai-mbp.dhcp.thefacebook.com>
References: <20210225234319.336131-1-songliubraving@fb.com>
 <20210225234319.336131-3-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210225234319.336131-3-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:fa88]
X-ClientProxiedBy: MWHPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:300:117::31) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fa88) by MWHPR03CA0021.namprd03.prod.outlook.com (2603:10b6:300:117::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 00:01:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d266738-319e-4df5-4f21-08d8d9e9bda8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2646628FE347D92023D3E224D59D9@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CXR7KUA7UfCYtBKgIdmo5xXQxwOP+yiSO3aLoe+RLky2RWF8QDDUdtfm80BLrDZUjuvlHz4cs497QVg9VoHCWkOzI+iYxT+gQXMUBJ9IaKHjZv4go0ZPaDHX02KEtRsbjgwNbKWrmfYXBoBfhEaJnvNFB62Zwz00bmpV1mRRtDUP/wSjeXrohy/1jKmkjjRsh8VvhgvAhBCsLj/R43JJrjB0Nm6adSWzUShU+ppP+wmpywlmfIMbIT2qEJV85K15P0O1kA8O4vmOzR3zUXVJS+7r1hPUtAgzykS5emvv2fYjE2ioO6sKrRupp9hePaxwxg0UV8fc/QlZy9BRrLY1c9ymK65HvrmvaBjPsd9yn8fC6/yCdOrWKa7ufJmIv97BnDbbTxoJM337SmvCJZCg2jjz8XkaL0QITICDqZXQunZSBsVMt5uVQoBRNd8RNA1+R9n9oV/C8lMgtl40QVulE5GOlozpV1Zibppz/kx7n5gsGNHsgG4bucYDP1n0c6arUj3MK2fST5HhFr3LCcB7Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(4326008)(316002)(8676002)(6506007)(6862004)(9686003)(5660300002)(7696005)(52116002)(478600001)(86362001)(8936002)(66476007)(2906002)(16526019)(4744005)(66556008)(66946007)(55016002)(83380400001)(186003)(1076003)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8J7CGLJi5e4u8JG81xNBzEFucbzqdfnEyfvHBY8oMmh3pY80b9JyPXc81PN9?=
 =?us-ascii?Q?A0MKPV8/N69vo7L3mBeB6iq0tInDUOKaQALQ9nWaSv/JIgtAERz9ieZOYUl0?=
 =?us-ascii?Q?wgMYtBoJunNy1cZq0Pp0ZpiZOUy56tdaLaLCmJn6UzNgnclRUVEOoATrHzkD?=
 =?us-ascii?Q?KqCbD3ux0094FyYTrm8glQlJoCr8O36NXIcimO1whR4ceFKkRHYw75Q8j7T8?=
 =?us-ascii?Q?WU80L8qlHinHDjuNjn7w6i1DtFuYh2gdexwQcDYar9AVllofnxJ+4lufKxLy?=
 =?us-ascii?Q?nql3UoCrBUPC2s5un3vr7lenWlV9QyBWIgArNLAbC02FGRnKoOYr4sd+wB1G?=
 =?us-ascii?Q?Pwh5Q5pjIcTixLXZa2YiJvEcK93PpKK2rSybDr4k7Q+z9cJ+czWN67FCKzuA?=
 =?us-ascii?Q?ocnBtmA/14s5d6878dmqD65+5OSxtAA0kU+5OnNfeX8fvAbI3nte51rORQrE?=
 =?us-ascii?Q?vpB5bbmVQLNSSccYp6ViR+bjzo/9cbnPJ2ZWBPDEZitaI81BY4C2JUUdL3c8?=
 =?us-ascii?Q?gr4CEiuGDS8CWwRH+fmvksxy+zcV9yWdoeFqsuoCQyLx25QprcmFw9LCK0F9?=
 =?us-ascii?Q?PvVFFey/6v4iCjxJUliFVSZoDmiV+yl53Np312rMBu4eqhZZ61fjFCloDg7L?=
 =?us-ascii?Q?v11tt45tuE0xCyMJMKc3oB/IUInIlHuxI27B0d/y28PB27SI5Uc3A+XyuRkh?=
 =?us-ascii?Q?QjjhRfEgtfgA2bOKw5ZN0vknVQu0d3wjicSZ+nrS+03BAToZf95VSpuLtrD0?=
 =?us-ascii?Q?SohgTMwOlHyQsI/DQcVB2vKBMxBs+1FTBYJXjFuHMiSZzDV5zuBMuHvMvXs3?=
 =?us-ascii?Q?79+V7Rf5Q9tcuQ2flyqZL/i90HCzP8d6UOs9fp4GH/rWnJMUUk1MoGrUAH61?=
 =?us-ascii?Q?7ax1JtL/2kbyOqtiqEcLqsB4pkuod/oKszC/6FupNq4Wz1dlHu/Y92svs/0J?=
 =?us-ascii?Q?YL67ozRpIJSpBe8UaopMweWT0SLZ9waMYYyYD9mC+l51WQfePEgI6qNF5JJU?=
 =?us-ascii?Q?h5xZjeNHbvqh433gVOm+pKqxq9/bJNZSrvmwT0nsmJhjxvvFqjAN1sa+58Ck?=
 =?us-ascii?Q?hcXu4O+Nng4A2HPl0cJ87lBl1dCi1zhqYOXd1cun6j33fe/zgXkBBxtqcsmj?=
 =?us-ascii?Q?NY66y9NTRFMH1BsLC7wxKjKCydbMhHAUOAbFa76FAlvqzCG0zgRx7pb9go9J?=
 =?us-ascii?Q?ZuLTIRFn2i2peAnfcOuMZaxKqH6taRp+UasNiEKtdv198aj6ObonQoK9xRmU?=
 =?us-ascii?Q?FNR7/WPD55daUqG52Dt+fluVIaHaaA3TbrrPoLpfNck6YQpoK+kk50DVB7Is?=
 =?us-ascii?Q?bRhshqrQaQ9T6EilorbF8EjI70tVHQRP7DxwbZnGTvsKqB1eDZwJFidlJqEr?=
 =?us-ascii?Q?U/SmCvc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d266738-319e-4df5-4f21-08d8d9e9bda8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 00:02:01.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6tjpBu8Dt6ndbbYmJ3jrVhRz28S+LE/MJevmyJCVYYbmvEiNhaJB48XmvV3xpZY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_15:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=859 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250183
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:43:15PM -0800, Song Liu wrote:
> BPF helpers bpf_task_storage_[get|delete] could hold two locks:
> bpf_local_storage_map_bucket->lock and bpf_local_storage->lock. Calling
> these helpers from fentry/fexit programs on functions in bpf_*_storage.c
> may cause deadlock on either locks.
> 
> Prevent such deadlock with a per cpu counter, bpf_task_storage_busy. We
> need this counter to be global, because the two locks here belong to two
> different objects: bpf_local_storage_map and bpf_local_storage. If we
> pick one of them as the owner of the counter, it is still possible to
> trigger deadlock on the other lock. For example, if bpf_local_storage_map
> owns the counters, it cannot prevent deadlock on bpf_local_storage->lock
> when two maps are used.
Acked-by: Martin KaFai Lau <kafai@fb.com>
