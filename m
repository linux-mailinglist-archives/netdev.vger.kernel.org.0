Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C43689AC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhDWAPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:15:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62544 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231605AbhDWAPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:15:08 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13N0DC67021616;
        Thu, 22 Apr 2021 17:14:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GnFHq3hkaZjv3Y7N7w5nHrAmcL/et/GWygbDzC1yko4=;
 b=ISiOGMXSr51psqP/f5q1zBURyACgF7Zqd34WSVJLP8Y8CuICV1SfCIZyzLF+tRNcAkKe
 7FdzXnTbsNSOpOMSwT9Jr8ZV+WSJewpGt/Jyml74fZ3/fdRS1h7eAGMP4/26RAq9rnmG
 +MRP2LvWGlCAirl6jycAt7Y7AmOy4ziEEns= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3839vuknnv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 17:14:21 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 17:14:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APnScUXOtFNCyztYrmEEBYm/1QlRIPxMo0mJunM0BoH4hinKnyWydF5vU/HNOzGWYBx1qzMgXgYRNHe4VBu43Wngm1MQ51ChHqsWkSGDTFJ4YdJCgGCLDymMWZz5K+xB3rfQ7RGg9unhQyKlJjtF1sNyNXtZrh7oSZ+R2TaYv0VNd2LCdOZxuskpsrNU0tKlyIF+H/f/GD7sEfWuJNYcJcuEzSc4Nh/xFkpv/D/iPgiqrK/ohE8GpJxfJEsmwaVCJDTxI7vMTZPL6jCoMasIquhbObPOdfTrn/QQ43bStTc3Fd970j5goq4yG/lAe+S6Lm7AE23FYUHOSH8XdWTRSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnFHq3hkaZjv3Y7N7w5nHrAmcL/et/GWygbDzC1yko4=;
 b=ey7fqBM5OWinZAz0a9gj7hu1q7iqAi4P8xeoyaUyi9RN6ttL7lJURBpaRl/WpWrY1OqZU+Rj7KqLzUprZSi6M15srJUDBKcin6YOdhrffw32v6MmjEiTn6wpKWepo8L/qRq98Ch6iM0gYqxWpw+hOht6V5q81cOZk3eT0BRtK2tHHPdamk/DKxZTkKRN/Oy4clW5nvopqYae1ARqGe/Kdly4Re1zFIFoin/1cIvMbHP1tNAQpnYPlR2oIoDHX3Ti96GYDlbEPZ4tt5N9hW+IECT+znh93aaVa2/VJa3ubDGGKjbfeag1eWjjrB/ro3SHDQ8e/w+++8EIWBzzX/iF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3965.namprd15.prod.outlook.com (2603:10b6:806:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 00:14:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 00:14:19 +0000
Subject: Re: [PATCH v2 bpf-next 14/17] selftests/bpf: omit skeleton generation
 for multi-linked BPF object files
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-15-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <46159a14-9470-883d-e948-b09ef9bd122c@fb.com>
Date:   Thu, 22 Apr 2021 17:13:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-15-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR22CA0026.namprd22.prod.outlook.com
 (2603:10b6:300:69::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR22CA0026.namprd22.prod.outlook.com (2603:10b6:300:69::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 00:14:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ed23168-f7f2-4279-0962-08d905ecbcde
X-MS-TrafficTypeDiagnostic: SA0PR15MB3965:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3965790F56205BC949A6B24ED3459@SA0PR15MB3965.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANJf9wtcA+CfMv/H+Za3vCALOfLVAiz06q3YMoFgyrhI2i3JKdEcndAX+v9iQKPbjH5/yLQXIQNChpVru0CBzSHt0DoqC9dwoulTGLppV6CjOrvkN5H8br4XKk6lFqpAtlsxyPq6VGBbbkpawIcjD7EO1ECV7FtizKsWtctUTR93DOgzYmORp1oX+FqAGN1Y/L3MPbHfp4c6mYfhG471JoS6RaLZjI56A0tBnjK4cYPLqlfJXbvXArYM86xWmkRi702rWFrDwWx8lyoxy8XCeAuhwuihEZXliEK3pCuMhLAjO8JopzMewnkEXc5WFWhHN01drQ3Md5fQgfsHfO2mOLP2ZuP/2PjufmNWBMx4OcEpnetD8AkeeJcjmSJ/CNT46nwHRwUdQ5Mc5ja2mxlk0EnAFR6M198NPROjmlseYVhXXfejwerMx39EspG7bjFpM4By+mpaQH55y3NKHa1bG77msB83e4xwVBq328/krOhzbijYLg8BPiuWUg9AUuvNUTtwmFDTSCsV5GxitWVRLw5a+VjJap+ZCiK/Fpt9wzWjrwbb+MgqjY4XELxXeWS73XOtttI3cZJDYBbB5NhIK/UNf8Jv3fmiDXodfCXH50UG1QpxMkPe/f7eLKDk8R030c9LmqqZ8OGlCysAVyWibiKzyklxv2tHSdpq4z8bFbSU6j5TeHvR4VTrA2pnpX7R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(366004)(376002)(136003)(66476007)(66556008)(66946007)(31696002)(6666004)(8936002)(316002)(8676002)(31686004)(186003)(16526019)(2616005)(6486002)(86362001)(83380400001)(4744005)(5660300002)(2906002)(478600001)(36756003)(53546011)(4326008)(52116002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEx2Sm1jZExLMFM4djVKaEFzQUl3YkhGV1RxaTgwNGtoZDNNSVY3ZDhDdmI0?=
 =?utf-8?B?MHRrdXpNUmZhTVg0ckVCN2szNnQ5N3pEQmlCbXZpQ2RzT3l2L2xlQU15TGli?=
 =?utf-8?B?cGxRRk56aWNJK3RhWWRwcEpzRFlaTHl3MnpNR1RKdTVEVlRkSVJuUHU1Nmt5?=
 =?utf-8?B?WEg2NWhBTnpQVjFhcjR2WG5MaWY1cFVhcWNYbEg3bytBbVZZRU52bkFKclJp?=
 =?utf-8?B?U3dBVzVsQ3pTK0diZ2ZKK0pHSStJQ0d6MDczdGZoWk04ZlBhS2c0MUhYekVx?=
 =?utf-8?B?YTh3cjdlYUROTTlCWmpnR3BycHFOd21MT2IzWFBzL2hLVURkaU1oQWhwRlBT?=
 =?utf-8?B?RVJ3VVVFajh6WDc5WHhoRC9PNDdJRkNpVmp0cjFORXlMNzRSUDdJd0tEaUt1?=
 =?utf-8?B?eERLZjA1aUhQSmVFRitqZ2pmS0hXWS95ZDhhTTZ6eDJTZHYzWTlyRVFTeFJE?=
 =?utf-8?B?bDJRK0hxN0kzakVDb09rcWg5Q0ZBbEYzMUQ5cGRMKzRBUjkyUWZUWnNGUyt1?=
 =?utf-8?B?VXN6MHE1dVZaL0E5Zm9qWXQrOFNZQ0pOdndsamJtYnJGKzJ4VDhXUVRyc29i?=
 =?utf-8?B?cmZQeFdzMnY3eG52d05paHFodEppQ09uaUpteS8rRy9xUmxlNlB4ZXhPWmJn?=
 =?utf-8?B?SlpPaHBMQXJjK3VWTHNTZnA4QWFnNnhWSm1UdUM4SnRoUzg5eE5VR01yMThP?=
 =?utf-8?B?L0NFQ09uc0MydUFLM3piL0FNQkg5Q3lnNVQrTWhaSXdrUnMwU0k2Z1lBQ1Vw?=
 =?utf-8?B?WFQ4TmlpanpCZjlmaEJMN0hUSjNvS2xRak1kYUo0c3V2eUtLdlViRGhQVDJR?=
 =?utf-8?B?OVlZQk43am92TFFzS0hnb2ZVQ1I1VjJJNUJNTmVWZ3FpdmoyaVhkSTk1dzg0?=
 =?utf-8?B?Yk41cUs5Nm8wUG0vSjc4bWZIMERFRHZJVGh2S0g3c1VPcGRBTThhS1hVQ2ow?=
 =?utf-8?B?djJYNHVNOHY3b3pkZVpra2tLVmE4QnNzZ0xqWG1hcldPQmU4ZXBzQmxvaEN6?=
 =?utf-8?B?c1BSKzUwR3VRV0oyeEZMYVJ1YWJqbmtGeWQ0SU9tMGFEbTBvL3Z4RHkrd2Rn?=
 =?utf-8?B?UGZ3OU5Kc0MwdzlwSXJNYkRubG1RUi9KcUYrZ1VsR2ZaK280ZWVaZWJVUkdt?=
 =?utf-8?B?cnBTS2hIYldId0tmMDVPR0YzYVZFMTlHeTBjVG03RGpkMzBBNkc4TmVXcWVD?=
 =?utf-8?B?VHltMnZFTmJ0UnBsQXBMSXhVb2lqSVRTNnhHUVIxdjZVRzRtcWtyVnovSktu?=
 =?utf-8?B?bWl0ZEcrVkJ3UHN4bGEzNW5sRkVHVGpBRHV2WXJxbTF4TjFRcXc5dDFaa2Vk?=
 =?utf-8?B?ZENZQ1VLOW1NZEF2ZHJNNGxxT3NjQVlDVXhhdXByMGJWWGgrYWQrWmluVnB3?=
 =?utf-8?B?dE5pLzR2ZU1kZnRHUkJWcjBIN3hiaUNiR25rdU5qMHVzNU05UXhkdmdJRWl3?=
 =?utf-8?B?eXExRVdTanVsSEhmUmJBNDhlZUJ6aG9MbnREbk9WTGQwYzA2eVdQMlpscE9m?=
 =?utf-8?B?b2ZrRzE5WENZaUhwSlNvMDlMVVJSOWtIakJMSHFSS3VRTm5NcndzbjB2ZU1T?=
 =?utf-8?B?VkdBV3cxNUg5RzhzU3E5TWloakFvQXNmWjVYN0lkNkZScmozTzhjcmhwd2tK?=
 =?utf-8?B?d3l2SFlnRXhJNmsycWJCUkxSN0tzUzNmMHk1dHl0Ny9PN1F2bmJ5QXE2OWVv?=
 =?utf-8?B?RVZTTzBoSWtieEsrZ2ZwbkxUR0xtYmw2QzRIYXMrVldScGthWjFvNVRNVFE4?=
 =?utf-8?B?VFFuKzY5YnNjWUZqV3I5MGFsOWpqcVhQdEFZaGpJK3A3eHNrcjVoOTFhclE5?=
 =?utf-8?Q?H6DVcR7UVxILYQxG9XKjmhRu+qgPRvZH4/1po=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed23168-f7f2-4279-0962-08d905ecbcde
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 00:14:19.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1ohUwGQudtru2h5zujrqtLJMCMnGGHMlTbP9TXNcTYWqgxf4fAUxggeE6RBWGAd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3965
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: XBS_y_TmhFsd7RJrwqC4hbb5dhutS-S3
X-Proofpoint-GUID: XBS_y_TmhFsd7RJrwqC4hbb5dhutS-S3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> Skip generating individual BPF skeletons for files that are supposed to be
> linked together to form the final BPF object file. Very often such files are
> "incomplete" BPF object files, which will fail libbpf bpf_object__open() step,
> if used individually, thus failing BPF skeleton generation. This is by design,
> so skip individual BPF skeletons and only validate them as part of their
> linked final BPF object file and skeleton.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
