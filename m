Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94E739DFCE
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFGO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:59:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231277AbhFGO7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:59:18 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157EiqDd018308;
        Mon, 7 Jun 2021 07:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OKiUFXMeeiL7WyBWC/C3vCAaK2MBFww+mQeAzYWHIXs=;
 b=VOzOPy9mhzRF6l84olPNnA0veNCrDA+tK16arOWcVV0D044vNzXIau4jdbbldj6JKaOl
 Yhuks6dYe1BSohK1z9y6SNceXwfDDW+ZIqXWrCIRGOuI2kaRzlR6kSkKg+g02NePEzat
 rHLRh/nCuY64WfYoOW3gaww8cDOhUweexio= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 390s14p23t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 07:56:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 07:56:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUp5P5NsYc3PAK3rG/yp9aCZ+mV+LL8dg3jcT/5C5lGGMGltlrPNMVwdrANRgHk7EL6lbnrj3Zs55wX9Nk9txdWeutoYzlcQ2ycV++NMubE/dgNTh6OROaJCCBkHLs0sSHjRxMCQEBboWammZxRvyTbWHIciXBIP6AO4uivCGe8UVnEiCsZoMaxZVX5Kg0MBJVkG2vQx++pkZdUTCF/mi6INqd88RAXWjMK9BIYnqJbBik7OnhWQj7i8pSB9oJ30cEJ8Zwx//lh+kyhxSoCoiawBxvBz5S5G0bMthy7hEhiwh4xkxwHvjmjBh8CqpwM+9srNZJMv4hFUVAqdu9QvhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKiUFXMeeiL7WyBWC/C3vCAaK2MBFww+mQeAzYWHIXs=;
 b=DTaLflDlFKk6nuGBieH1WRXzYq+3vQrKnvjaFoULOJNt3RttGi0Cmik2YsmNiAsz1mMkcIQYoRCQjy9pwu1C7XDqKa8GDMn9Y53kUX1WjhxrKKCmHHX7bwgOa2jhckMnSCQOujUbD/QoTclRxN4XUFNh3in7pySGM27gD/rsD0cko8canD+bgchvBtMJIgSYUycGeI1UzKUF7OjF52vyC1aOk/hGqWxRhDaNvrKDcFh0uMb+fsEsxLC2AoO1SE1WyTwD9sWtabiwNzfY65JO4hoJMMBku4BL3b6pjYpBEUSQVwNSbRe1Y30+3d42+og6X7i/28fFSJ8guU+YuPRxXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4014.namprd15.prod.outlook.com (2603:10b6:806:8e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 14:56:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 14:56:25 +0000
Subject: Re: [PATCH v2 1/1] lib/test: Fix spelling mistakes
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210607133036.12525-1-thunder.leizhen@huawei.com>
 <20210607133036.12525-2-thunder.leizhen@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e788d0c5-51a3-4cb1-52e1-f57d0d17d7be@fb.com>
Date:   Mon, 7 Jun 2021 07:56:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210607133036.12525-2-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:db22]
X-ClientProxiedBy: SJ0PR03CA0311.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:db22) by SJ0PR03CA0311.namprd03.prod.outlook.com (2603:10b6:a03:39d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Mon, 7 Jun 2021 14:56:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 218db573-26ca-4b45-e717-08d929c46c08
X-MS-TrafficTypeDiagnostic: SA0PR15MB4014:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB4014655B1ABC3A96402A6E06D3389@SA0PR15MB4014.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:538;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WP17DvnpvuVgDdlhg9500iYvZ+KHF+gxnYK0veqKXo1oC576cJdPyGi+CMHIPTDycffpN9K6Bda+N/s6xwoDuJfQ4G32oada6HpIQPKlLew3sW4FbqG4kuhWPpeYYXt2zbD6Vcaw4e220c7AZuXnMuRzNqtHzzt5aJWroia5XSPR8FqqzpB97TBMKUyPN6BI/w1X3fnBnhljXo/+F3ININV7e3wbeBc1/xUXiN2w0yTZJ1bYBeld90eBKRaomgSo3+pBYnFkq2kzyeo9hfR291HlP03eYKZWueuzxP7sKQ42BTUopOSn23iCFijskNiRuLGUlBTxCX/LNPo/Zuxxu8umeQSOgAKRjybI+p8/8+kFcyzgCSBW9iErIdAkrV6AicAbRAswDYnxN2OUPBRz0gjUY6nWgyUxGlEzXEYEr7WZM3NOBSTc8tVID3HB1XFBkEHpfLgw5ctQQcw/Za2HOh3VQgw0Zf4i8FhjIF5Gp5y7XfdeP3+2pZqBGVX6yaBkuuN6Z1xxt/u1WSN4LwpkAhvtMFR2+nRHxdclGfGBp1+co8019ebFYOqXnomZVPmNtnE0eGI3x1ahMH2bG0HyPOzgHks2rRub6XMN+IurRDnr/bBU0c0JxTevagd3FtL2EPxa4bgFmLJedb/qjWlwhwKa1x1cZZ/VnJbBNq94l2JKwdbLL0jYfYXGh9nKQCr4SSvaQUp3UW4Sc6HtJfnDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(921005)(7416002)(478600001)(52116002)(2616005)(53546011)(2906002)(31696002)(38100700002)(316002)(4744005)(16526019)(186003)(66946007)(36756003)(66476007)(66556008)(86362001)(5660300002)(8936002)(31686004)(110136005)(6486002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MkdrTnRlOUdwLzhkRHR3a0ppRTRkblhNU21CT0orNlVYZ0NQaEFqYXMweHRN?=
 =?utf-8?B?bVIybjRFMWcwYU9EeDBaeXZvZ1VDYlBQSWxiS2hzd3djTkNkbnRRSGIyWCsr?=
 =?utf-8?B?UTNVTXhOd2U4UWRxS3NLdXZGSVFtKzJvMlVBN3RvRkllblUxVTNQNFVLc3NT?=
 =?utf-8?B?Uko0T2hISzRSM1I4cFhHMjcrYVZFbkVnRnpHSEtMbWFudmZVWkFpbDhkSE5n?=
 =?utf-8?B?TTRXVTBVZTdPWktMMGFZdm9iWG1ab2hVdm1VVHE0TldyemIxTmNvQ1EzQVlr?=
 =?utf-8?B?dDhhbUcvZUlzeTA4U3NlaHRCblgyNXpYejh5bWo1VTVxUXBOeTZBSWpjaC9F?=
 =?utf-8?B?b2lhSW1ScW5HUGNGU1M2cVFOMVlzd0NvVWJ1MFdVcG4zdTBXZE1RZml5ZGoz?=
 =?utf-8?B?R3labk1LcVNiYmc4NHBqSlVMUlJkbzAxb3dkY1ZUalNYYmsyci9nQjV4Zmll?=
 =?utf-8?B?Y0JwT1hDTGNZdnRNb0lsMmxzQ1ltWjdQRmZZalBQdXlYMHV1NTFNdnF4MVpE?=
 =?utf-8?B?MWZVcUducm5PMS9rZ3hwYmU0Ukx6SzYvOTJnbFhaejNNZFdoRlRIY3BDa0FH?=
 =?utf-8?B?ZW9LOUJodlJxRHg3L2pTZGt0L2dubUkzWmpBbHpVYWlwbE83K3Y1VnZ0K1Zh?=
 =?utf-8?B?cXhRTFRpcnNhQjAzM3IxWVVvZEtxYW10c2xobnVEcDY0TFYwTDFJUUVvZFEy?=
 =?utf-8?B?djJveTI4WHdsM1VHSExsVTlIYmgrRVN2TjVJYmk3aS9OSlRMQ1RDTXYreDVJ?=
 =?utf-8?B?SFNxbEJrSXBXQmh3em1QZUZHcDFGVHp6MnkzMWtkWkNCZXhaVmNFSFVJVHlq?=
 =?utf-8?B?SXV3MGxMVE1sQlFrR1k2MWZWRk5tSCtWTmdhSUFPSit3TXpXUWFLWkVTOWRG?=
 =?utf-8?B?UzhnaWlCbW96QnhhYlF2UmFnNE9kRnpWdm13UEliR2FpMlpYZXprSkxETmJi?=
 =?utf-8?B?cFJWRi8yTlVZcmdHZEh1RFMybThUT2p0UVl5VjI5YVZzaU01NWxySlZiZnk0?=
 =?utf-8?B?YzAzQm5xRWZmK2x5WCtMRHZ4NnNNb3pzM29lcnl0RnN1S0pSUVhxSDhiUVFZ?=
 =?utf-8?B?eVVWcXRzbXNKVS9EcW1yWmdBRE95RXpUOXFTeExJNUdSWmVEOVkrWjBhOWxk?=
 =?utf-8?B?VFZrV05zeitOeENRV0dKdFUrQnRDS25ZMEpCaGRRRG90Q2lIZWRTQnRYQWE0?=
 =?utf-8?B?SGFmNjJ5UjdrY2ZnL08xRmM0QXpvbFdtZittUWJUWGhtOGlHUG0yR2E0VnNw?=
 =?utf-8?B?TWFYaGQzOHovaG80S3FTc0YyZGVjVHJqSGRwTCtCa0Y4bGtLQWFqSE9pQ0Y2?=
 =?utf-8?B?T2VVbE90TXFNS1pmNW9NMVprQkFkZG45RWpLNG5YclZDZWZlR2Y4bmxUQ3Bv?=
 =?utf-8?B?WW1UR1d4K0VCaTFkeDVSZVJHTlBLUHVRTG41TCtaT3VwSVVGZnVQc2tEayt0?=
 =?utf-8?B?OGxtUThpWHpwN1R6U1gzdDRiWVowdDB6OVYwUVh1Z1BHYkFpK0twSnVYRnEy?=
 =?utf-8?B?L0k0Umd5ZUV0WER2eldwRExYYjRjKzJxN2lxbG9pcjFab0dncXFJN0Zjblk2?=
 =?utf-8?B?MHhzZzRod0FVMTFINEdxUG9nMWRENGNOY3hwTTF5ZFZFTGtZTllxcDBSRytm?=
 =?utf-8?B?UE9GUFE4Tllna0w2aHBRdEs1UlNPa0RtYzB1T0RaY3AzanlkUGovSnozNDJH?=
 =?utf-8?B?ZlY2U2dKSjVlM0owemtEditCQmNvSnFWWDlwaUpZWXg2Uk8vT1JiYmZBY3oz?=
 =?utf-8?B?YVlTOFBNZFBBZ1ZNdFB1azlkSlNvRE9ualNSNlgxcGdzS1V1Y0J3V0ZOSzNh?=
 =?utf-8?B?WHpWcmpkdGFVZTlaMS9UZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 218db573-26ca-4b45-e717-08d929c46c08
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 14:56:25.6625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6VcF4x56nhCPhr3ajtgZZlUIs0di0gJoGnbBjpFBou3gn+BMj/mXy+GcbaExW+K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4014
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: i2WKBEe7YhsiBiYAZBvRC80Sx5X_6OvN
X-Proofpoint-GUID: i2WKBEe7YhsiBiYAZBvRC80Sx5X_6OvN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_11:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0
 mlxlogscore=968 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106070108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 6:30 AM, Zhen Lei wrote:
> Fix some spelling mistakes in comments found by "codespell":
> thats ==> that's
> unitialized ==> uninitialized
> panicing ==> panicking
> sucess ==> success
> possitive ==> positive
> intepreted ==> interpreted
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Ack for lib/test_bpf.c change:
Acked-by: Yonghong Song <yhs@fb.com>
