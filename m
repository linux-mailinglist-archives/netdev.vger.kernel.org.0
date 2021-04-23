Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1186369D16
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhDWXFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:05:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4216 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244171AbhDWXEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:04:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NN07AB022234;
        Fri, 23 Apr 2021 16:03:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=q2U4ywJfntvZNalFTWw5dww3RFCCsVS9Vuj5Xk/PhFs=;
 b=knnlRBATC6n3KcN0Xzx90Fgtm3S84vM5YSgcvUyyjoTO5LMk5N96afe1WJ+ltSNFOVux
 9Idt3fYeO3L5uZKntPYBPhlHwZhX+LQZdQpzvyeAmxTOLAD6wtT2xjBB/+vFYvDuDRG1
 bdrajQsF6rF+vnAbANPFFuYV76nWf1srszM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383an29m43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 16:03:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:03:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATOSMPQy3Xfs32D/zm0TtkLhpV2WPsBVQ4H9bSI7EfhaSFDnXhs/D3cMdYoGpgrYuSRxWiK8eZliJx7yT3ei5xm7AZko8tOeR1m480amzYtv6Oynhy/O7hQxdajeaeV76ebGTeq/aHdfeWLT/tlQR48BMn8k9aFSh25m5DHSKEXx/tBdymFtGv1EfvhrbXAwCtaVlL4rr7UiBkO/QrCI0WkuRmYjpfKDPtFvCu1avgM+67d95V8lSgoXs9F59hxHnADbw5HMusxVy4fbewENUWcY2T1hqaKE8haunixVUvpGF9kiZ79OV9dnAqETriaEaRnT4tbU9GuLIrGRH0aU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2U4ywJfntvZNalFTWw5dww3RFCCsVS9Vuj5Xk/PhFs=;
 b=HXmn1s+pr2vr72n9eGT4R6I4RPRaCGZ8dWAgd8yVHwSV916Qk3x4eMQEOgpQxa6ttuvQILAuyuuuHvWk5DtT7xpF08CEMgJbQZXk5pL2oGqNP+5n6+a9ixf3qZE5e2qZnk9TylNPF/m30+web2AWHGtSmSQmbITQll63G95bWxTE+oEmj5Z0w2H9SGPAE1L1B3ZzqiLpTuGIDOqBwOb8bHtzJEOzBupX56IFU/IsCb0kjR8KsDMR3zFF6+L8xlVRzQZ4QwBmfx2UalrUOqSrzF8nfKBdNskFIf54VUVG2OJG8UOK4GzG/0k2GD6x1MVHjbkCN9b9RSFEA6bJOWvawg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 23:03:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 23:03:54 +0000
Subject: Re: [PATCH v2 bpf-next 5/6] selftests/bpf: extend linked_vars
 selftests with static variables
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-6-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <43f34f6e-1424-88c8-54fc-2e76d99bb20e@fb.com>
Date:   Fri, 23 Apr 2021 16:03:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-6-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7ce]
X-ClientProxiedBy: MWHPR1201CA0008.namprd12.prod.outlook.com
 (2603:10b6:301:4a::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:a7ce) by MWHPR1201CA0008.namprd12.prod.outlook.com (2603:10b6:301:4a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 23:03:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a01fee9c-eb6f-465c-1202-08d906ac1167
X-MS-TrafficTypeDiagnostic: SA1PR15MB4657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4657D6F098B303204CCCE764D3459@SA1PR15MB4657.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRiAMFtZQQy8cx3rEXi/SzhiTQJQISgjvcoqXKzDEXZhnFIKIKN/6xhjK6n2u9Qbf14YKkpc0Gl9/yb8LhTLsDl+rOiSHRbbaUlx7tzILH2bmhx18sB4wXFVObZR7OLYiEeleKGZLv5fp+G1qxEKqAjQs0EoJVJ8G7pTtpsDrdHRSflipHbfdcLXAUzWfbsKtTO4XGfgHGWMO8o4D2qjCiBAztYiN9noxgZQypFUWbCoBdEX7WY9VOthDrt4pc4Hw959Am3mXK+j0kKg4GncpihUfNuaAyF1D9dPVmIqCxh7HOilwTvdfd5HkRjNB2CYecG7TCms72mz8YseUiMi5jFLkeM4yoyezghnl3l/aXFs1b4Jb4f0MJw1UHDV+nASKAmRIZBEYkyYNkAZhElAEaG3mJEAtXUrUe5tAfrEaK46U8MXLfWAN9+2MLDa5axwgGyPVJ5Qx4c6zaOcvAKuV7kRkJPsCKwrrrqXl287PTVoWCqzjIjblM8LBthA2AB1xle+AQGr/e1jp+lbwHBYn/STPzXenu0kDQkVD/FvN0Pyw80HxsSmkZ0j3p3rLunVm7XmstApK2PWaaX7aAs6nEMhXZNAl4MnCaJjK/5FaDifDEwDlG7k2CkIWmiAMWKfOWOlC1AhpTyQTkU5CvBKk4npOXD9jyDgAiQ79GXp/lSsmgTNLerOwcopbxy9gSFV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(38100700002)(8676002)(36756003)(52116002)(66946007)(186003)(498600001)(4744005)(2906002)(66476007)(66556008)(53546011)(2616005)(31696002)(5660300002)(6486002)(4326008)(86362001)(8936002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXVEajE1NGNHbktzbWJPck9qSlZDMEV0V1ordFlVV1JkS1FiOFROOVBsUDVN?=
 =?utf-8?B?UnlrTEdraDVpYWxEWFpjQVE0K2lIc1cwS2M1L3h1Yy9vcUVZRzdsR1Eza3Rp?=
 =?utf-8?B?Rll5eWlCTnZ5cXhsQnllLythc0tBS1dscUJGRC9la2pKRElqVU5VMCtUcUdh?=
 =?utf-8?B?NllhZ2dERFJXamJVY3Z3M2VMMEw1UHBDd1ZTenJRcHl2Z1FoaFVmblRyN1lI?=
 =?utf-8?B?SC8wOTAxYXRmakJGa2MzaU4zSDlSajArZTZkUW5xald5c1k2eFpUN0tJVDdP?=
 =?utf-8?B?aXg2Nlc3SElVM216dXlMaUFOVXRzSmJxRXNWdEx2Nk1jb0lwZzIzekplSjlE?=
 =?utf-8?B?NGtlSHpRb3l4SDhSeTRaQ2c1b01CVVNjRnZhdjlVd1pXR29mYkNqVlRKYkFi?=
 =?utf-8?B?ZUxVaDVWbGEyT1h3UTZpUmh1ZjVHdFVKUEFUUi8vY2NpQmI1cGlHZzFwaXB0?=
 =?utf-8?B?SGNYbzhHc3JaT3dIWmcxNDJDZ05NcTJjUDNud1VRa2RybjNJd0dFSUJIZVA3?=
 =?utf-8?B?a2pibEd1bUd5WE5kQkRCVTR0WWcwQ2JxUlhvUC8va1ZIbmd3M2N3UmVZS2hR?=
 =?utf-8?B?bnp5V2xRRWdjVlhPYm9ROExMbkJrVUxuektJQThkdlRiWlluR2ZTcUdCcGl3?=
 =?utf-8?B?ek5wSkdET0lRYVpZcXVCWGYxOEFyeXNWSVpHQU9RUmxlUlNlaGRnL1JPOTc0?=
 =?utf-8?B?eXZQOGc2TjFja3VkNnk3THNNTXI3akQrZElsYWtWQ2hhTGJUSG5yeDlJeW0v?=
 =?utf-8?B?cjNhT3E5WjVBZExpRG1rT1ZMZWkwdWlLUmdhaW1ZNWJIUDk5clB5Wk9kQ1ll?=
 =?utf-8?B?WVYxaFJHWXNWV25hcUdPMzV0S25obTF4eXl1ODRqK3NTUlpmUkNUcU1QRWhE?=
 =?utf-8?B?N3krRjM1M3UzR0lVVHcvMjQwZ29YZnRMZFZIYkRnNjRPOTZ2T0pQUENna2s1?=
 =?utf-8?B?emRVWDBxYjBMeGFIREpIQ2w2RkVwaFpIblhEWTlmbnVBSFdvUkhxMnVURThJ?=
 =?utf-8?B?Z3dKYTQzOWFWUEUyaUxoSENuK0ZjWmRwZGhTVFVLa0xZVVd2YlluNkdsUW5m?=
 =?utf-8?B?MHBIanV0aXhFNnFudTRhZDVCWGszTDB4d3hVT1RYOFdyN1lhQ1c0R1hDRXkr?=
 =?utf-8?B?aDZZalZnZEpnRTRyK01hRCtndDlRM28xOEdXU2J3RzBNR3V5aXRWTEFUazM5?=
 =?utf-8?B?aUM0K0UrN0JqeDlHdVJWYk5CYk9PUCttV2FYVUR0a1N4RDZyR3pkQ3NOemY5?=
 =?utf-8?B?YVI1Z2tkMmR1L2QyMDdlS1ZBQ0JSaDN1Zm5aNEVVWTBzMklzZG9IN2MrbjFj?=
 =?utf-8?B?elc2bU01Rkx5a3hWWVIvSXBBN05xRTh2REF3VWlJKzBDMTlyUm1pbnpnVnB5?=
 =?utf-8?B?b2gwYk9tZVNvUzFpb0N4V2M3MjFUWjFXMVBva25BdEhYL1JJRmcyMUNVMmtC?=
 =?utf-8?B?RHZ6Q09TWG8yOEVpZTdPZDM0ZDRrS3hhejV1QUZ5Z09oYlpPOEQrYmFsU0Mx?=
 =?utf-8?B?UmllazlGT0tMOGhKRFV3a3dHbVZCSndJcWhKVDBMcWg3ZHU1NDltTEF2UWNN?=
 =?utf-8?B?QXBMVmdYYkFZQnJMQy9ZbUR3SnZya1hEUkZwQ1ZBdUt4VzVmMWhydlpuZHF4?=
 =?utf-8?B?SVVlWEVMUHFkKzlDM3ZwZWZ4dmpFN3NiVW5FZlllMXQyMDVqb1NqUzg1Zkdq?=
 =?utf-8?B?S0hnQ3M1TklnM3lSUEVmWWp5Rzllb0Y1Y0dNNFUrZG5qbDlwa3kvVnFzQWRC?=
 =?utf-8?B?TC9QdllkS0ZmeTRVMXR5ZVlaVnhpQzFNUEE2ZFB6RXFHNk5JblUwY1lxMmR1?=
 =?utf-8?Q?ntZZGu2yS9T2ArZh4ad/5ovL9wUAFZXREpbdA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a01fee9c-eb6f-465c-1202-08d906ac1167
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:54.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TtGEWBVJPhJaq9dOHwbN+XZeaMvmaO6Q0NgNt3rp0KC3sNX9ble0M71GN+OsQ2e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: M00C4l_uho4SpdYdEpB1vaCexJ5DaAEB
X-Proofpoint-GUID: M00C4l_uho4SpdYdEpB1vaCexJ5DaAEB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230154
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Now that BPF static linker supports static variable renames and thus
> non-unique static variables in BPF skeleton, add tests validating static
> variables are resolved properly during multi-file static linking.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
