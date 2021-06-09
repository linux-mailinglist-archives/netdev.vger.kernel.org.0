Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63753A0C57
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 08:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhFIGY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 02:24:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24828 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232164AbhFIGY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 02:24:58 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1596DH4c002704;
        Tue, 8 Jun 2021 23:22:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=d1fOJtHz0De3Z3nKTJY67Z4ooGxwP5BInduaCHArfIo=;
 b=aHpZExXRZPdYbD7ZsQzmmKsAcKsnDOD/FQt/+YdNFBGMzdMcCDJ43IH9W/gGuNzgWOsi
 1mbsD+InY8smmuow0Q2meRwGtCESRlZ0CU6hbmGiTvNEF8ZJJq2kXSn1PKaYi4JKN5WM
 7SStoe0uM9ZB10VN8SlFFnp1cgnOyCRC//I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 391pw62ybq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Jun 2021 23:22:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 23:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcmsG6kHENbZLn41gV4Lf4MfTvnqZBwwGTAQMeSami5C3YONya/vfT7YQAcilGFsTPDOFksqI3+tyJvxPLtS3VHdUC5pQXbdsmaiiu1uXfOj8cH2u3e69rOncxrSBwnm/JBHkT4gZSyopNSbfSF1bZdZ4krzJD9LpZNeOpdWnynLkAunl8D5f9Zp+tSb45M5IYboAmDphDQV//ITcv4hH+RwVfWJXBktnYiDb38jkFY8PM88ZSk7omC1UBIlHY2sBXjLV6aFyZRrBq3LTOCJTL40g6qKJdsgC+UPLZvBiQ7MB1qkhtzQEIBX8zJb/lP+H17L1mgedmqeGqz1RvQoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1fOJtHz0De3Z3nKTJY67Z4ooGxwP5BInduaCHArfIo=;
 b=Mv8+ktSTR6uhic/eCopWbzEdaqoO5P1RYCjraX7UNNVxZwCYZYu9AFyIiyxYiFIyJj3rirGIfGItX4SoAAgCLps/I5uLILDBDEu/xToHXNbbkCHxhbALiK1rrsE70dWhxT0r+q15vHKw8M36LyyLsYx5STwL4MLvE0PC1+1v4cUhuIVFvTbqaKOPgXqFVjivSz/WycfpKLXSkRhgZA6OT65BXG+A1gfcswn0ZTcwpD9bAoGf5baMOrDYA/TrHM32t43MweSTXOZdJnPaMpe8pv119Of4WJK36wLUJfbLvKS8UQ8cFH3OHsM5avOQDx/zbeuTj1Vei48039vzrYNP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Wed, 9 Jun
 2021 06:22:48 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 06:22:48 +0000
Subject: Re: [PATCH bpf 2/2] bpf: selftest to verify mixing bpf2bpf calls and
 tailcalls with insn patch
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andriin@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <maciej.fijalkowski@intel.com>
References: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
 <162318063321.323820.18256758193426055338.stgit@john-XPS-13-9370>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6f30cedf-c792-f1ec-fb02-39cfd035b46a@fb.com>
Date:   Tue, 8 Jun 2021 23:22:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <162318063321.323820.18256758193426055338.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bb78]
X-ClientProxiedBy: MWHPR17CA0071.namprd17.prod.outlook.com
 (2603:10b6:300:93::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:bb78) by MWHPR17CA0071.namprd17.prod.outlook.com (2603:10b6:300:93::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 06:22:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acd7917c-f54f-4784-6d4b-08d92b0f008e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB46572592695AA3954E16F6B7D3369@SA1PR15MB4657.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bc/jP7pgmg7RZD0dLAA8Z3ou6f+YFiQt4Fo8TxnDp9MBYOiBEuqZcFCHIXXr5b3hTR5h1NIVR3VAIfvFcaTUCh+TD4Hz9+2sk3MZPM/0n0IYpwO98S3uzdjnAEwUOmYmAGcnSqRBL23nNRaGKKhG6mPBd2WgML0tgS+bUmpzw1/MEE1wlkgP2TLuUyEZ0EXq0jVWlcZjDcHmimAC3pGoMlmcIN/97xT2CzX4oIJcfPKtFe2B7v15k1efPGhucn7txjYTKprcELS9BhenSda7KVHaRODSaaqTv15Npfy5BkHRrY9zSLuIpjv4x/GBxBLpCCsjZ5hq7mHyqPJXwJLiOwVkMtvkOINmVK02uDSEPEcrRMu5DGb2Lr2Z7+qMV2CCV4u3evbV7pUw13E6hT4llpRrOT1/wrI8azzcVhUQ41/Voya1zzH/eXN4W+Wuf9tGJf43WV5/t3REPG2zZiKhMGIaKZHxqKrfnQjecF3WRLxQ52gsHjnFJ6a94znV9rmgy9/E5Q/Ejh2cQMep9i6T8jeHDIWS7esmVAp8gMapXp/+CIxm+oRfz+FfDzo3Akylg7rBI0wcFRrEE7GfJZ5vyj+hs18803a5quLoZjIh1tlhOoNHCMh7Klm5QumWqsprpmqiDrpOm23l2eiKQ5FQSDFuA+ImyyQvI9/xTXdgU2oEy/gAtWneJGuddCYoRvYq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(16526019)(186003)(4326008)(2616005)(316002)(4744005)(31686004)(6486002)(15650500001)(2906002)(8676002)(8936002)(53546011)(86362001)(66556008)(66946007)(66476007)(36756003)(5660300002)(31696002)(478600001)(52116002)(38100700002)(6636002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTAxVFhQVkJEbUVTNTBYWVZBcW5jUW80Wlg4QVIvbTNUNXZ1Z1E1V0JhaUk1?=
 =?utf-8?B?eHk2RUtQVktxai8rYzNuTzhUWHg1cHhJcDRUallWbTA2a1ZPa3pPeHBHYWJX?=
 =?utf-8?B?RmZOTHJvNnlFeitYRlljZ2JmRG5OcEozNlJ5M0VuWFdsQTZ5UEdiTWZUc29i?=
 =?utf-8?B?QTkxVlRWdHNGRzFBOXp1bHpVWktRTlV0NzM4SSt6RmpUMk9Hc3ExcnlPVUMw?=
 =?utf-8?B?dTFOMU90WHBxMWFjVGV6a0c0MUcxV0lQcEV1TFZ5ZjBoV01oeFR0VmYxSXlv?=
 =?utf-8?B?Y3p5K2lXTkQ4RjBQRitiWXI1U3pwVG0yb2FaWFU0WTQ5SjY5b0lWRjg0dTBj?=
 =?utf-8?B?YmlPMTgxOWpLYTZBQWdlVHQ5U2prODdKZWkzL044bTdRZnZvYlJvbGxKM2Zk?=
 =?utf-8?B?Q04rR0dSNkZEMDNrWWEvN0tLYUs0akpxV1Nnb2Yrc3NZcU5IME1nTjVZc2E4?=
 =?utf-8?B?czg3QVBoMks0bnJJV3BBK09LckIwdXFRSVhrSjM5WnNUSXM2eEhnL3ZnUGhB?=
 =?utf-8?B?ZGdNN2Q4eUZuMTMrRG1wTFJkRnQ5Y3k1TzBLOE9sZ0toWFJZV0pGNnhGMkU3?=
 =?utf-8?B?Y2xmQXZDbEJwQ1VEaUoyaWRPTExLUlpsdUlET3h4MnBJeWduaU1BL1lBcHhu?=
 =?utf-8?B?ZVJ5Y2t6bkpDNlVoeElxaGEyYmVkMHB0OWFESE9JaHgraWxlRHo3eTJHbHg5?=
 =?utf-8?B?K29kaGwxS01NYjc5TXlPVE5UNjR5LzJySTFwbVpzNDZKeWMyUHlHWW80RzMr?=
 =?utf-8?B?ZkVTdGYzc1pWOUV3OVU5NUhLQ1dncVdlZWxNMEhYQTYyd042T3J5UEQyS1U0?=
 =?utf-8?B?WmdZcG5iM1lOK1pIb2FtMEtudUN2ak1PM3RCNk4vbkVoTy9TOFRhUE83cFhw?=
 =?utf-8?B?UUVSL2x4d3MvN3EwWEorUVdyWkhrN0hnMDluNm9KcnZQaXRuWTFZYnlFNTYy?=
 =?utf-8?B?VnB2TDU4Zm0ySWFMN0tsMVJyVnpsUXFMMXFOWHVnUCs4NDkvRW9BQmtTUkRD?=
 =?utf-8?B?MzBtQzhJNWtQcythalNkSWJYVjVLZU44VzRhUTg3RWtmKzNKYWhWci93b0lS?=
 =?utf-8?B?QnFnWk9qM1NHYnovcGkrc294RW1wVDcxUUdyWi9DTkZOcHlWL1pOYWxObndJ?=
 =?utf-8?B?TmNXWkkzajl1SWxicVVjR2VESlV0OWE4UHZtN1lyMXNhNTBtV1Vtb3BOSEpi?=
 =?utf-8?B?Z1JpUnI5OTlNQ0NZOEJoS1FCNmphRmNENFEwQ0NhRXIvbWwydHB2ajRYVEFh?=
 =?utf-8?B?QjhWcDdlTHNTd0FQZDFlNk9CNWNPSS9kNlF0SGM2aVBxM2k0cmVnbldaQzRH?=
 =?utf-8?B?MDZsMEp5WWxBRUk1SE9kVCt6OU9xZDkwaWU2dGNOd2VJcTAyTm8vcUk3T0pl?=
 =?utf-8?B?N2M1UzROZFc2TXJlVEhlREhESGR6RVpsT2F0djl0QzdNdFBRd0lFbUxsbUFS?=
 =?utf-8?B?bzVscmFhL0ZmclU3cFBLeit6NUFHODBQNWxwb29ZZ2VJU1FtZWtZRFIwZlBv?=
 =?utf-8?B?ZnBvNUhxWXBoam1DRHVZUlJBMy9WYmdpZ2svZ29TSVhxRzdVSWJmVDVjUWlT?=
 =?utf-8?B?U2tEOEFma3VzR0pXRkxONWdmemFUb2t2YkEvS1RxbXo0ajZOMTBJNG50ZUJ1?=
 =?utf-8?B?NXNaR2NaWHI3cWx2cTlYc0tzdDhEa2p6ZjlRTnRBM2dYVjFTdUZMWVBpMWJq?=
 =?utf-8?B?bmdGcFBHb0RPcTYrbllIWWEwUWZDY3c2VktWL21lQjE2dlNjM2paMU9YelFC?=
 =?utf-8?B?dnd3Rm82NjN6ZUF0cU9pTXZ5SHZWam5BTWdFVlcxenNCMDJaNitlT09rOVZW?=
 =?utf-8?Q?GCXH/4CMPy0MSqfpbpnSCl/EWw74Z54Ai8mPQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acd7917c-f54f-4784-6d4b-08d92b0f008e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 06:22:48.5632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3iDzp70q3uBfW3SBbrusj4shuGwsv+OmoLjz+fMU1h/dk51fDmOpA/nWQ4YfdfuE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: XyAiqfD-8liGygAOIxzkSGy_kyDHKROo
X-Proofpoint-ORIG-GUID: XyAiqfD-8liGygAOIxzkSGy_kyDHKROo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106090021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/8/21 12:30 PM, John Fastabend wrote:
> This adds some extra noise to the tailcall_bpf2bpf4 tests that will cause
> verifier to patch insns. This then moves around subprog start/end insn
> index and poke descriptor insn index to ensure that verify and JIT will
> continue to track these correctly.
> 
> Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
