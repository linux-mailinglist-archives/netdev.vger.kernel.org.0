Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABF2F0BB2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbhAKEE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:04:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22701 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725824AbhAKEE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:04:57 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10B3urbj007722;
        Sun, 10 Jan 2021 20:04:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wWxBG7t0HRxIcSlQ1Jq5GNlfahEiTL3d3BTJYXF5oMg=;
 b=g/iyDEo6rJBBWDi42L2P3zIrLQjGDT3+eGOCNWPUHqPDVl0QuqDCpw3uLctLDJIal7WC
 2CmhiJnEg8hMcxotUZ4sWX2wvwFyvZk/teSpcuXZrIWXWdiIRc/VZSeZig+TT0tM1oku
 Z2iy0mls/QxmrthsxZOxYrvklkmRwqWMxrw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35y91rnr8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:03:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:03:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAjOHp74SCvrx21F1Rfzs+mQSmehRuzMldRa/Id0/2DBb4HSRyPfeJUmy/LHgsOB+iTbbSQ/qHWQij6SluHul8KrGRbQTa8PO0R2caGVCBjPjTSF3YDTXtIzUiehluX1/pkVNMCNpCH/m39/UvRmGZuGnFo1+dn03awqpurEfJzKnAgBGBpxG8MRt7ZNOyUD8yHUko4/AzWCbvJoUsUCNotWgjzrhVnh7KKoR84qBnZOJgTUPVIL3TCQASteS6GaoY0n3UIn5lAdkwfB8aIJp17xNuGmN1A+4y+DO7IvJC2D1+1IjCvrmYIlVRFrQahhq7I9cbMyeZXRAccJUo+TYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWxBG7t0HRxIcSlQ1Jq5GNlfahEiTL3d3BTJYXF5oMg=;
 b=Sj89OgghlyKDtrxiwvtcKplQZk6LH5mPpqDWJmMbFV4g9WAzo/XvwENrYabgZzdCjqGNRy7b2qgQoca9I7CdeRSX1hDeA0+c5S72ixjqqoyQmrCbJJR3IYx6E9pHMVFdi8s2FbV+aDTSWwjwgJAuLDF9CEvFiCiq4tzerMIWEv5XX+mKq/Q1WKQlscuBZzk30J+CksUJWoR3awmzXAzY2+JBR4rINWZTaxrCy2fgO2bL1qJAB5sGFtQ+YVGpKDl8aIO+JNe7LyS1hl6psxrItUXV1TiNbAZKUbqGeX2fwGZhEu9pykKLfIWRIz8LGOFXLX1CkFp/v3rcGIo3CvWXFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWxBG7t0HRxIcSlQ1Jq5GNlfahEiTL3d3BTJYXF5oMg=;
 b=CXplCG6Ns7ZUsIEBVq0TDAFjeuA6WmaNl4FlHvvvgS/7DOzLk7s98X1KvDqaj1Q+Bj9gS5g5662SNlswHxkI9nkVoq+V3QfLRIaoglEk2DEC+r056Dn/GmQ2Apx7qotUtHxPnXqS/el4G+x1+7UoRGuQ8FQ2vZtT9s89PesFrus=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Mon, 11 Jan
 2021 04:03:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:03:58 +0000
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: declare __bpf_free_used_maps()
 unconditionally
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-4-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <450b1d44-aeef-7e93-40fe-a7893b9047d6@fb.com>
Date:   Sun, 10 Jan 2021 20:03:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-4-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by CO2PR05CA0092.namprd05.prod.outlook.com (2603:10b6:104:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Mon, 11 Jan 2021 04:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d56f0e5-c666-4d94-09fc-08d8b5e5ebfc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773F0B5A22AECE73FFC4837D3AB0@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P06srYGupWyUSz4K/akB7Gju6LR32PE0IgLCvSjivW5cjvn5Or408UZ4T6nAlWaNX1xw2+X7w++59jpcCBS6Waa+8IEYB2OKPK6pjju7r/8u0v70qLoihys/6qzxpOwD+EXonMtKURIUnUve02jmhGRDCFnwVhWKz/P4uNQxyyr8MXCVTGXwxJYRRFVZVj4hFSNQbqlSJPg1YJVDkE64ZfMxpdMd4QB6BtRC3iy5b4j/zzxOVRr5CZRBuJPJbYKymwtcBHFfMrVfqebRCZmnVHsbbBjhSQ0jEy2YifAPOjtxeiH+ZMG1f7C3evJ6/C8YmRM4smVMfvbkj0Sl4NaCeZYwF0ANCZeAkTym3F7GoL+lNNwcCp2u7GDAWajRM0z98Ha8KsLud2yVs+3jWd24kEfR/KugIdJTmTXnFz1if6CsvbmM7XIqaeEtXePgH4Kw3xQZ8I+Jd8K5NONeumEs74lCIDcB3bpRfjgjWAnLeME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(478600001)(6486002)(2906002)(8676002)(5660300002)(16526019)(53546011)(83380400001)(31696002)(2616005)(8936002)(4744005)(66946007)(66556008)(54906003)(66476007)(186003)(52116002)(4326008)(31686004)(316002)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ekl2dEVMVjlLRWY0aERIZWZmMVFsVUtLQUdva0hZQ0FObHd2Kytsck1MU0V6?=
 =?utf-8?B?ZzBHS3ZRODFaZjJhazZxcG1zS3NSL2dPeGpndmJMdnR5RXV0K2V1KzBBVGxU?=
 =?utf-8?B?c1RvM3c3NWFiVWRZSCtuZ1ZkcGxXV1kyWlY3bkV4S0FDc0Z5ZTlaKzcxNWUw?=
 =?utf-8?B?YWIzZ1dFUWNmSjdkR0cySkw1QnhXWHZBU2F5Rlg1Y1BNV0FOQlVOZmJKT3lH?=
 =?utf-8?B?Zk5JL2EwV2gxREdBRkxRbnhCNDdsOVk2eHN2Szd0R0IxQm1ZNTNTSXJGaTZw?=
 =?utf-8?B?REo5azdqR1Q1ZTJJWnBWOXlrM2N1ckxtVEVqMkxxR3B1ako5NGtwOXJJU0hz?=
 =?utf-8?B?dVpjQThERExTakZrK08wWWJJZUZvNVBXZndDQ29ZMDQ1YUp5NHdYdnZxUlFp?=
 =?utf-8?B?Z3d1WUowRXpkZGJDdnJjRzIwN0k3SDB4MWVOWDVBVVozWVZHV0NlR3p2NmE4?=
 =?utf-8?B?ZDNoNnNidDVuQ2FLUXo0NDIyS1ZIVXFKdFNQTzZ2RlBOR1FTNm9TQTRRM1FL?=
 =?utf-8?B?MExGTUcwUkwrbmxXYm9uSnhPdFNiMktQTldDOUZrdlJrdTlOeERDbVlVRi9B?=
 =?utf-8?B?a1RuWC95VUVDYUZzSVY5Z3RsRmIva0VnSVpxTVArbnI4MmtTZllGV3BTU2xj?=
 =?utf-8?B?NjVGcTN6bXNjSzVQRGJIa09RN1Mxd0x3Ty95NUVUUjVGWStaREx5QU9OTERa?=
 =?utf-8?B?ZDYxYms2VTV3U1lTN01iaDl5VUpOaE8vN3kzUkJPczhTNURQSWU2cEtpNHNN?=
 =?utf-8?B?ekdqNXJINUNpTG5RcU9xQWhYclo1Z1RUY3dqYVBYVUpkYmxLT0RiYkhzc2VB?=
 =?utf-8?B?QkkxU2Q3bDZHUDNrMXBTRjFTSXlzbERVbVNiTXpIRHYzYXlqU1JRRjZUeVlF?=
 =?utf-8?B?RmNqdCsvL2xMZzlvWUhoYXhqT2VHNVpiRGFCdEcyeTRCVm9MRGxKVUtTajgw?=
 =?utf-8?B?OExZU2kvUm9HTlBYeVVoUEVxM2lrK0xnaFgvWmlkeDB5elJCamZuVUR1WUJQ?=
 =?utf-8?B?WUVaMU5abnVjRGVRMTlpOTlBc1pSNnZ2V0V6cEJXdmFQaW5pZEw5dS9PKzBK?=
 =?utf-8?B?WHUzK0RBUllqTlp4VGw1ZS9pSUN5Tjllb0ptQ3ZzcWxnKzA4VnhJNEdiWmRQ?=
 =?utf-8?B?V2RvQnRxbG9YV0NHNGZvNHVRM0xxWis2NnJ3V1lrekhqWllVVHhZUmtCd1Zu?=
 =?utf-8?B?dW16bXpaN3FtZ3lncjk1OXBOREllcE5SLzU1aTA1VXFlMTU4UVNCcUJRTEhR?=
 =?utf-8?B?dzhWQUgyWXQ2N3BOdTNwUVYzMlhJdDIxNjBxalN6OUFNT1FNZGlyZjNZcHBq?=
 =?utf-8?B?eVp0K3J1Y3RUd2U1WnQwQnFHM2tBMERENjlGckdaVGl5UGhMaXZWNWxmRnNS?=
 =?utf-8?B?L0oyYjFGdzFaMHc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:03:58.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d56f0e5-c666-4d94-09fc-08d8b5e5ebfc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2VhOuAGpzKZao6qehQeGJiRbzls/xasdncMjwYwmy63Bd23kUTfjtCkue42nuEA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=809 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> __bpf_free_used_maps() is always defined in kernel/bpf/core.c, while
> include/linux/bpf.h is guarding it behind CONFIG_BPF_SYSCALL. Move it out of
> that guard region and fix compiler warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: a2ea07465c8d ("bpf: Fix missing prog untrack in release_maps")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
