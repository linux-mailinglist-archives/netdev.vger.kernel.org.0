Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE45147E63E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 17:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349155AbhLWQPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:15:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41660 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349131AbhLWQPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:15:17 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BN9dIP3004513;
        Thu, 23 Dec 2021 08:14:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sWvMoXTFh21er7VuvUXEDO06poIyvLEyCPHhf16ONA0=;
 b=Zn1rDlsO4H5A6wZHqty3w6an+C487AtRuhzYH7wn/DrdGqJXAagbFH8sBpBiZsjtF+g4
 ZTi86ssdFNxaL8Pk958XwmMTLAYM6b8tCVgzCJfQbgicC4rtYjj6g6skusd7SmBOSdYt
 zcAcnDEhcYdrM0eGKrna1tdUIVHc4HIhGsc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4pnrtes4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 08:14:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 08:14:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhlgQ47A7w3J1+A93QGJJVdmsln0k4uII9fouW8YqGbZuTCIFL/6eChy/OWjDXz1I5fnHq7PCLQWrpUMs1Lk0NFs82foBJIs+MawFEksSZSTjoBsug9+/8QMp7ApSEc+ofYkaM2m1ysKCu38X47oJxZriCnztSlASmkrze/y8dUgPOAXVvCKkmIZdgyhkqxlNr0oRdngXdl8MTW6/4XUquQIIT0CCFHPkR73EvTWrBaoe0o2r+xGiZt6leGBR/e9DdFzM1E/QUegpUdt+H9W1xv9nlWjZSte5ZNI9z0wtv5qFuTbhqiNW7ehy8Z8bFdMDTK8GMjHbw4+hCWe/VRXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWvMoXTFh21er7VuvUXEDO06poIyvLEyCPHhf16ONA0=;
 b=JOKXMuJT3ZtowvU0oumGJRyDgGm/9ZrFeGfmg7bM45sY4+yIpLRuQZMACLjWE2+AoN5jpVzRQ3txmzwqm6nCtgGL28SYRAFUtanitidSAg/LAQFXhAA3YCL/XtwgDZiSH0xSHJvSuG28zQAQjyfZq/z5O5lmlWT1PrR35CtL50ShZTSqwAJerG2oGrIMufnA5oIiUV4Qvv/c3SfAPu/g1qb7XXn6oxybF+6M0HosYuG8v6Ys01GOHPvBv8JyxUZPxX2bjwM1YGpuBEKFQ23zTTw/eYIuzGHW3NsHJ0VoKZ6i+G4eGxc7pyevCL6PMt78SOJ077W//xixzXw+askqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4159.namprd15.prod.outlook.com (2603:10b6:806:f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 16:14:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 16:14:55 +0000
Message-ID: <5a60e93c-26e4-d35a-b849-e09d002c4c40@fb.com>
Date:   Thu, 23 Dec 2021 08:14:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: Add btf_dump__new to test_cpp
Content-Language: en-US
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20211223131736.483956-1-jolsa@kernel.org>
 <20211223131736.483956-2-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211223131736.483956-2-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:300:ad::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99e8c825-6d45-43c2-9a6e-08d9c62f5bda
X-MS-TrafficTypeDiagnostic: SN7PR15MB4159:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4159F7FF41256BDEF77E8ECED37E9@SN7PR15MB4159.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1rVZ6SDFXR0u+/G+sq3ToiiXMgnnHz3j31i6BGiLjYhp+gx+l8CdWN5TqFDmrEww8Ns0cIzEMyfNvsXtqkCZRPGcHtAcgLSUg1mvbDKAZXdiw32ArnVwybAZFwpjftoxLPLes6hqhTmLHqsN1MtWi+kQB7uMSjZhTAj49QOPKa4RZ2c/7x0tYZI05iUVc1kWpxlBciPa5iZogiQpafON//arhDVtHEi2zrrFcSbOS9LngYWdvU66MXndewqth9YRg6YaQ9Bm2Kwai5TFMYcyrk/xVUZaE5f45i+tLIOkP/J21/kkd6axWHBrfq8Wp3NdkYKV/PW0IWcaKnBgHZAo+zFECEKsRILUSNPe+xm/64ZsP32uZCN7AcwVKvg90NXV6yo/9UM6gxdV3CEL2gxWpzyo/gbUV3FkYnU6m+t7ButMPW0tIforYtHE0r3wv59+s+MSTTX+dZlXzgWcACVz04tGYvAbTtDBkPofe85NdV39bNA6nVjDTZWrg+kaKUpFSfZGfL690pT5+2bx7hGgh8+LRX/7/KHbrgAgDcXpWSdBYil3bJ+FXCW1LILbrYHCFU9sst1Qm9xql+ZwsRVLjyCOYtwMBAlf1L/oOLYx8ljo4FVudfICYIgqEZr8G1C0wOdZs5gXLeHV5JghfID+Qzvb+AgwxaZAz9e+KTi+SzLjkEPvk0chgMgNSv1rA6q+zHQhaEpcofYC+mFyQOoWrODWVLJ3dgTbCJY1F+63Ibjbmk1M81JQa8IsrsmekOnl5As5P2U0BZQchQM6e+psA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(31696002)(54906003)(316002)(110136005)(66946007)(6506007)(2906002)(558084003)(66556008)(4326008)(86362001)(6666004)(52116002)(36756003)(31686004)(6512007)(5660300002)(8676002)(2616005)(508600001)(186003)(53546011)(66476007)(8936002)(6486002)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0N4KzF0bTExKyttZDlWcE9rU0tCdGYvNHRUSGoyano0VTlvZlBNZnJCWkVS?=
 =?utf-8?B?SjUrR2NRZG1ZSHhCOW9KZWw5T1hsOE1vYjcxbDAxbmdScWRremdDbkgwZk94?=
 =?utf-8?B?aTVSQzFNZk1HYmx3QzVaVzBsRVpFT1lGL3p5QnhXWnVFcEJNSzZPQ0hLK1JC?=
 =?utf-8?B?bnE4cnlKc2IvcGY5RDdjUW04TDlGQm1rb0dmdkNadVBEYVVHVDhSQXM3UWMx?=
 =?utf-8?B?U1krMHNBb1hIa2hNZTZ0QjhLYTd4bHREQmtwN2dVaUZtMVBtWmkxMkFqRVVz?=
 =?utf-8?B?UHdvR0twR3Z5SElJL1YyQmFpczJYSXhobExza0dmdHFhSjNnaWpHVDc4SG85?=
 =?utf-8?B?WVZNTGN5ZGV1U3lHTHNSU0JGdkR4YXFxendPYVZqaG5hd3FjUEdzckc2OTlV?=
 =?utf-8?B?clM1c1RWZ0t3VHhZTXlmV3l5TmwydDZYRncyNzd3ZW56SUtTUkhRd0N5bHhW?=
 =?utf-8?B?bEJpamg3TVpGbSs5UHIvazVJdElMVUlaMERJbTNkUVNta05HdTVySFB5MGJR?=
 =?utf-8?B?eUhNb1Via3RsTjR0bEkveVJxeXRJRm14T0RNYmpOemp2OFlIbG5OeXdUZFZK?=
 =?utf-8?B?NVJFSEwxb0JZZDhUb25pQmw4U2dRbkJZbWZxaSt4U0NkeG1rMFdIZ29LUnYy?=
 =?utf-8?B?b1NOM2dmZFlTOUFaTFBTd1N4MjZHVjdhYjhGc2tmQ2YySDZzRmVqVmdSQTVm?=
 =?utf-8?B?Mm40QmNNR2tVcWlGaTgrT2k4V2xvcmtWZTlncEkrZUlGV2hMTGd0eE1lVHkw?=
 =?utf-8?B?SW14cTRUZmlaWVAyS0FHV2JjT0tHNTRReXJTU3FmMGtmcHc0V3FNekNJR0cz?=
 =?utf-8?B?UWhGUW0xOHJtejR6ZWF1aTRPMU04azhDZmpZc2J1YW10VWlmMm5zcm5KUTJn?=
 =?utf-8?B?SkJ5WUpTallqa01QOEJtb3poTjBYcnNrS3NWYk84TTZ5eHZDeVNYNkJYZkxi?=
 =?utf-8?B?L1d2Q1A3K0d1L1ovM3lBTUhoWHY0ZEVhZlBjYlhXWERaSDZ4a2lwRzIzTHdI?=
 =?utf-8?B?VG9uYzF5Yk5oaVVmVjg1TXV5N3hxVyttQlIwY1o0RmtqaWU3ajB5WG00REZo?=
 =?utf-8?B?OHdITkp1bnlhbktCY0F0TGptdmYySUdQKzczZ3hvSHhmNzR5NXBpZGg1YXVz?=
 =?utf-8?B?TlBWNmVoOENFZWhBQnJGRlVndlk0Tmp1d1U0a1FuMllueXVjTkFhbS9rblJ5?=
 =?utf-8?B?QXVaUFROS0kyK1RlNktKYWxuZnlJVWZUZkk1QVFZcFZhejJaRHlvR2ZiQVZR?=
 =?utf-8?B?WXBiSTBVRkxVQmJEZEdRY0U5VEd5K2xxdE9BRndObzlTZkFQNkN5bXVIR0pW?=
 =?utf-8?B?RXZTWHlRNFYrcHI3N2l5SmIzWGlYc1BjbzF2d1luTnZna012eFk0RDZKcnZP?=
 =?utf-8?B?YmhZUVNhemJkZ0N0aEZZd0pUTTF2MUM3Q3BHTnlTSDN6UWhxK0sxc1Z5RXR5?=
 =?utf-8?B?dCtBenJyNE1sbTFwdDZUMmV3M0pvK2hBRUxnMTVUTWdoWFg0VG9rcHQ4ODVI?=
 =?utf-8?B?SmtGTm52UStCaEp1UVZSKzJWWXVHZG9ndEZvV3RtVnkxUGNhb2JZam1mcmxh?=
 =?utf-8?B?Q1dtY3c3RmVkc3hrKzZWZ202U1FJY0RoREYrYWhJWjZYd29vLzNEQmxyQ1hL?=
 =?utf-8?B?ZExnS0x1UmY2VTMzcUdFZzdUdkozWHhGNU1NUlRnenZKZXM5VjdrNG13SmVT?=
 =?utf-8?B?YTQ5T2hxa3ZVOUVrWGMybS80b1paSURtQ2pYV1VaNVYvZ2dnbTZzMmd6YVVK?=
 =?utf-8?B?VnZpdDVhVzJNOU1pVzVrL3FEdWlBaC9PSWd4MW9Zc2RDRVpTSCtSYUpMUWR4?=
 =?utf-8?B?L3VYNXc3TnJ5dURtai9QRDBkTjl3bWVhVGFFTCtLNGVXT1NkREdmZG9tWXJa?=
 =?utf-8?B?aCtiRkxDcUs0bDgvUjkxdUNhT3NSQWVvd05wL2lWK3RHQ3gxMTN0cFYzZTIz?=
 =?utf-8?B?d3FSaTY5TjZVZDZSN0VYRWFXakt1bmMyNmh3TnhkWlZxbXRscXVTYmtHN1Bx?=
 =?utf-8?B?UzRJdy9xcVdvSkkvZGt5WXA5WTNoZndLK0t1LzFJdWhFZFRTYlJrelRZOFdE?=
 =?utf-8?B?SmlGb21qLzREb3lIRVRaVzUrdFh5UVJTZklYV01kUkQzL0tpZDJXejNXSXE3?=
 =?utf-8?Q?Vi8HWn1Vlavt2cx2B1slNmX7S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e8c825-6d45-43c2-9a6e-08d9c62f5bda
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 16:14:55.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UiL6od4kTLPEnZikfoAcG/r7Dgwbk5JoYJq7lmlyCbTXFKRmx+VRVnXQAZ8Yjmky
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4159
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: -FFJw6F3s1Xv1VIqi3ffdO6LZJ6pAaZO
X-Proofpoint-ORIG-GUID: -FFJw6F3s1Xv1VIqi3ffdO6LZJ6pAaZO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxscore=0 impostorscore=0
 adultscore=0 mlxlogscore=435 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112230087
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/21 5:17 AM, Jiri Olsa wrote:
> Adding btf_dump__new call to test_cpp, so we can
> test C++ compilation with that.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
