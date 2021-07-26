Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE13D5148
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 04:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhGZByM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 21:54:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2050 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231429AbhGZBx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 21:53:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16Q2VXP2001174;
        Sun, 25 Jul 2021 19:34:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ps3JRr4ltCrZafZglL4kW61pDlWtMvw6H9wmoH1CWhw=;
 b=nlcvOstwK7KacnTNp7/01SNtz5R87h/aHMg8j94vA3cltOEzdgMKfREkVHyGNML7P/vA
 vKdz6080rsVETqBMSath7GKAr3Hw1kE6fOkz3Ad5EBilZaqSKuCLw/0/WRVubTsY4C0W
 oPP1E0PuEeaXVCIYVgq0PEZF9njQWS0n880= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a0e6rq9k5-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 25 Jul 2021 19:34:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Jul 2021 19:34:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGU2GKUshshe7ZrWT/vo1kmiiqIaTaUtYvUf393Lin1ZrWtutR0wVwlROzcoUwp3mVrFDmrLO0dfKVHSku4ezkf6tO0WaB036eeEhErVInOqihYUDHHkNTN0alLmjDR4HheXexmqBZnZbBwAMqJYHBq/2ZHXXiyrezhsZIWAU4qg0jgTU050pHGgBQOK85ckmK6Vh/lysfmchP+a4SQkKzp6ksX4OPRKM9k2NpC5u9CoIm2dtour1b3cEzjinr8NPd4LARJmYxQZ8nUv2m5SJInpQYlgbY1y2xyUiEIFZ1HlbrOGtuZpgX4v/FU7hPXeXWnfDxCLjxXzcVupHe1LfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ps3JRr4ltCrZafZglL4kW61pDlWtMvw6H9wmoH1CWhw=;
 b=W2UMXmsj5oVi6my8VzVeNGd4tt7xI30kExZc1snEUuJdC96P3J2qWvCE28Y5EkT9QFPU++tmS+HSGNUZZ6EXpMF5VSw3Rf5CgQIzwRYhu1ArxNRRMXS5hyWlo1q4QWCGNXpEKbYEtLAOxSYuY+Kmo+JxTBbYD6wYqQC2fJaGRgMut7s5m2HcEIMo6VNp6yD7es6fpDjjbNUriXRTdjabeMPLYQuHYWwPsW3ajc4MVx1rsijG6YKUrP5uRZcxM3xugjBZ5jR2BNL7s8f+ueFeQmRNa69niMMNYgBHsS0CxvP5dei77Cnu5wpyhvicMXbvWGncFsqBzG+ymjLE2UVrXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4417.namprd15.prod.outlook.com (2603:10b6:806:194::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 02:34:08 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 02:34:08 +0000
Subject: Re: [bpf-next 1/2] samples: bpf: Fix tracex7 error raised on the
 missing argument
To:     Juhee Kang <claudiajkang@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20210724152124.9762-1-claudiajkang@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6a73ed66-feb8-d85c-dfbe-4ae7005608db@fb.com>
Date:   Sun, 25 Jul 2021 19:34:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210724152124.9762-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:300:c0::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10b9] (2620:10d:c090:400::5:cf4) by MWHPR08CA0037.namprd08.prod.outlook.com (2603:10b6:300:c0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 02:34:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a17c8e2e-24e0-4cc1-bef6-08d94fddd7d9
X-MS-TrafficTypeDiagnostic: SA1PR15MB4417:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4417D7D7A2FB7CD83694ADFAD3E89@SA1PR15MB4417.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmdImA8Znnzzj+RV3QNL+b9PwmdV4KInrtlyASli+RPvbZ0vqynXcb3Yj+q6eybXb7Kv3owVRVt1G4Y6i4bxVq53qHXmJOhwPfdox/DmtEcCTjaw5E3rrOPFAwllntEu4503JuExYNiL3OavUy978ZQrTzidUJ1YmIw0P2POUkbcowtQNlpe4Xojq0xdMmXUhiPhQwyojdra/oMtTFJSvlDl7mbW6am5l9KmMhVjaainiLn8RCKnG1q3UXAHSuWStYD1rFbwLZ09hl5th2QAEi1baEY+tBYY94ZQ6gw9PUbDvxcUTEC/HDUr67Vl2rqQmnjiofC3G+3nWEUFTOnkHJG9+VjWydYrqiNasCWgN8xU9ibTvENqQUvI4om+0vn+kUN2Reke66mCWw9kFQgH5prK1ORLFz7HdA4DtdPrA1oQg9jmdx1o+/3m+0xkn4JOGituDjSjMqK6LvDNhOFgV8CqYzZS0hziGtxm9wvmtqnpa1tOaan5j9M2cYfQzXCnWFsqc135qO7TC3SKzjAeLNIwCqPsRJ8MHqf/GxMx9w19LleWgWML35KqZrnX5H/aDcfjTSa+RiDA/a9nn68AB/A7zSCljaXeh8Tm2B6haT+bG0gGuJxy1kbfXssmTfKtR8R3zBC31NTPs8VB2HNmANQ/bs6CBdK8t6g1ye72A4K/wEQYdx1B+N87Jml9jtB4IfAL1M3RGvKWlkEUyPp4/mh9rS0AIzkpah4TPE957CQMdIjGfIKoRETvhE+EJLbv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(83380400001)(36756003)(6486002)(316002)(478600001)(5660300002)(2906002)(186003)(6666004)(66476007)(31686004)(38100700002)(53546011)(8936002)(8676002)(2616005)(4326008)(86362001)(110136005)(31696002)(66946007)(66556008)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFR5UnQ0WDFFcnI4Vm55d0syZzlRb2d1dDk4RHYxK2ZuVWlVWFovTmRvZ012?=
 =?utf-8?B?SHplTDI3MGpCcjFVQUZPOFI5SUNyeDBtbmxocEI3VGdxbmVxZy9NWksxMUpl?=
 =?utf-8?B?YXhiZDh3MkUxK3ZRWmdvSFNTNXhWVksrZXR2cWdJZkozUmxkK0lzRFFZYlNT?=
 =?utf-8?B?TU4wWS84VDlsRFcrMDBRWWUwTzVXcTc2TnhmWE9QLzhiSFRrRmVDenlRZjEy?=
 =?utf-8?B?NjRUL2psY0RKTEdDVFZTMGNaNW12bElBaHBMSStMdlZUaWFDZlpNTXVHZkcr?=
 =?utf-8?B?bm9vU1ozUVE0aWZWUVZjSTJLcUhJT05Od0xSL0p6eVJYZ0s0MDZhWjZaMzlq?=
 =?utf-8?B?OTNERjlTYi94ZUtlNis2SGtpYjgySDljYTA2K3ZlMDZhcldUanAvbDZ0SUpy?=
 =?utf-8?B?WXJxUkFZSHFDeStYK1Z1b09jenFEcUhzME1mQVlaNW9vTld2alRnV0g3cFc3?=
 =?utf-8?B?dnBUc0tENHZpaExjbzdhdHZ2TnprbzQ3RjRFQWpOcXk3R1hQenFoZlEvWFIx?=
 =?utf-8?B?MmVXajdlQUxXTHVheWF1eFJkOGJuekJNRDVtS21ub1AvR0ZhTldjYkpiR2N4?=
 =?utf-8?B?bzJlUFh5UFVnZEJsUytFMDR1SXNmNjhmai80eWw4N05TS2xKZ1VIeXprblZT?=
 =?utf-8?B?ZVRLM1A4NzFtUlZDRXJlbnd2MStLaUFRdUpDT1ZDNFlYTWpVamVSelkrTGhD?=
 =?utf-8?B?SEF1elppYS9sRFZtT0dqQ3J6dDVTZHpHVWdyVDdnemVNSE1SMHRNS1krUUFq?=
 =?utf-8?B?U2dkcG5ZaS9iK21DZHFOQmcwUCtKUWRtZng3NDF2U1VGaThMWnk0dTljOEZR?=
 =?utf-8?B?QWRpNllDdXRBMFhFeWsweEtOZkVEVU1zcDRxOFc0cXVkS1dDZHJEd0VnWk4w?=
 =?utf-8?B?VTdnMnhydjgweEpnbVA4eGdSaG15RUpKUllrMUgzTklWSmtwSjY3cjNGMEJ0?=
 =?utf-8?B?ZHRBbjY5WWMyOHU5VXRVN0gzdEFBM1BTSlIrcEc1Q0sveUZ2ZGtSTjU2QVJD?=
 =?utf-8?B?dCs5WkRiNWZZUitGRTdtK2I5bGkxSThBeEI4MFV5bVg4ZWJVMlBNZ0YzaFpR?=
 =?utf-8?B?K1RZRzIzTlpuMmVpNW45UXlkbW82T0NXWjZWbU4wQ1N3YTF1aVJza3J5djZm?=
 =?utf-8?B?bXZEREgxbk5xRTZuZzBaYnV2cTY3akwvY0s0V3JxN3hKeGFhZUYrcmk4RThH?=
 =?utf-8?B?bjhHcUErT0ZRRERlSHFRdlEvNjUrUmJiU1BaUDVYSXhRa1YwUk55TVhWaEpy?=
 =?utf-8?B?dHZFYmNzd0FwOTJiWFhtVnozbk51bDZOWUM1bHVGNmVJdGl0TkNDMlJtdEE3?=
 =?utf-8?B?Vjk4akIrSmNkb25VSnJsMExqSGlucXNBZ0hJb1NLdWNaRXRIZUxJbEo5cVlr?=
 =?utf-8?B?Y0dKVkxzMXg3VDVVSnFjanY4OVkwTjhSQ3ovUW5KQjJwSG12ZitjQjFWbTZa?=
 =?utf-8?B?QmsyNnJpRmEvRVJsYXEyTUNZZ081SytmakpJN3dDOFk0ZHBBbHY0MGhBeEJx?=
 =?utf-8?B?REVSRWhZMS9ydlFtSEwvaENNOThjcTZ1azlYOTNsSk5NUTZwZU04S2JFWEFV?=
 =?utf-8?B?d0tLMmxNbzhhK3hiMmgwNUxpdWhTTTB2aUZwb1luR2h5eHF2U245WGFrenY4?=
 =?utf-8?B?TXR5eHlnby9hOHhQeWsxQU03bTNaVm9nWEx2b3QzUkRXM09HUW1hUW1HS1l6?=
 =?utf-8?B?WmFSUFpNT3pCVzVhaWtlSUhuZk84M3BjVkFWU2NIYjRUakswZExtb1FDVzJM?=
 =?utf-8?B?RTd0TkY0MEJna3RqVi8xenhiZWZVN0ZUc0d3VFFNckNHbVVWRjlrNXF1TWJP?=
 =?utf-8?B?YjhhSmFJRDVKcStiR2pWQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a17c8e2e-24e0-4cc1-bef6-08d94fddd7d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 02:34:07.8883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIj5XenTviB5U2b4WVc0UgRcvSNvCxz+nJwAtpfhc1ZTAAnIq7ccGPSXYnvGwtj7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4417
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: psdvaEc7l-m7hEw80NZYJOXqh7Bnf4Ad
X-Proofpoint-GUID: psdvaEc7l-m7hEw80NZYJOXqh7Bnf4Ad
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_08:2021-07-23,2021-07-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=826
 suspectscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260013
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/21 8:21 AM, Juhee Kang wrote:
> The current behavior of 'tracex7' doesn't consist with other bpf samples
> tracex{1..6}. Other samples do not require any argument to run with, but
> tracex7 should be run with btrfs device argument. (it should be executed
> with test_override_return.sh)
> 
> Currently, tracex7 doesn't have any description about how to run this
> program and raises an unexpected error. And this result might be
> confusing since users might not have a hunch about how to run this
> program.
> 
>      // Current behavior
>      # ./tracex7
>      sh: 1: Syntax error: word unexpected (expecting ")")
>      // Fixed behavior
>      # ./tracex7
>      ERROR: Run with the btrfs device argument!
> 
> In order to fix this error, this commit adds logic to report a message
> and exit when running this program with a missing argument.
> 
> Additionally in test_override_return.sh, there is a problem with
> multiple directory(tmpmnt) creation. So in this commit adds a line with
> removing the directory with every execution.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
