Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6268E3E86B0
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhHJXrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:47:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46980 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235501AbhHJXrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 19:47:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ANkmgc001619;
        Tue, 10 Aug 2021 16:46:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YLtYe+/cd8i27L54ShrA17+jVIR8QfpJ00M1FHcDAGc=;
 b=daVsg4ajGS/NRs62irP6dXUt0hGbkeZshp9l3eq2xQr75dTD1b4hQoISl72ds4DGyD5Q
 8T0rVxo0zzeTPnDbnOWaTMYiqeCXGwvJY4XIOTq4SHLRI6Lrl3ZDUrt26KWps8SlHod4
 ZdG2RJqPFbh0ZSNa2/+s33DxQUIksUq/fW0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aby5v9q6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Aug 2021 16:46:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 16:46:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoUDjnjvNt67i1D+aqVdOIRedQt8JBpMB70Wrz5LwgBE8CKyQ5vy6lbIjutOOMZFsEiLiDwbVFp1fE9w3ldhWkpiRt8U2EQ3Fwl3r14ssMJJXjnIb5anprQtrJCY4qvtrEkrZQkog29LEnJTUshnNA7drIUo2KTRaObIethktrOcrzgoHd99/KrEzQcQ+4jnkyyIxkLEvtAh6Ij2p+TtrZnUakJ9LjLZ6xTiBjiBjTUjbAmf7QDvwR19tvfbYq10WDNaFr408Ca0UxCQrOS2aDsa1/P99vRJXq7xtcCRa6/sLIM+3dZKOtFDNfIs27mkxq2WQskYdjcb5aMmE8QnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y85xpa3i4Svx3jTih6o5jAUY3qbMaqeNqdcxvs2WM+c=;
 b=OhzWZiPVan7YwZhfaJW5dopWddX5l4ggFnGVmUhEUGA7a9+qcRLQBOR7aQMN3SUPasm6L7YcEWZ433FAIZgixBgDOtp/n87Pou6dO4cpvBPF/j+gxmOQBIWDsS2XoCh5lCjy7sC0RbKCC1G6bf3GHvOjsBoLPdakWKdoSUSC2ejyCvCtzN6mgFPPzjcjDSTq+mL3mMZ1zn359Z0rhMgk2m+qIoxt5fAjTm7z7/ZPs7Wc/NhMdbZBDPgOhAMAAYRaaIKpAlf7HKOEvQocM4m4Ai97p28U+g9VOJ9a7mzC2WDVLumhNSspFE8PklfJimA6+5T35Yw4F0Zzxq5z1J019Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3903.namprd15.prod.outlook.com (2603:10b6:806:8a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 10 Aug
 2021 23:46:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 23:46:52 +0000
Subject: Re: [PATCH v4 bpf-next 3/3] selftest/bpf: Implement sample UNIX
 domain socket iterator program.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210810092807.13190-1-kuniyu@amazon.co.jp>
 <20210810092807.13190-4-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6ef818ee-ee75-b2f0-5532-7cc3fa4eb68e@fb.com>
Date:   Tue, 10 Aug 2021 16:46:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210810092807.13190-4-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:a03:338::7) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1572] (2620:10d:c090:400::5:d180) by SJ0PR03CA0152.namprd03.prod.outlook.com (2603:10b6:a03:338::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 23:46:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e82c8372-be4a-4fa2-1123-08d95c5920d8
X-MS-TrafficTypeDiagnostic: SA0PR15MB3903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3903815CB17DC03747058D58D3F79@SA0PR15MB3903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f82g+i/c+nJTpvQcKGDsQSBzn+UuySaykdlk8VBgFJqDHp/xp9euXLcN7WFlT5VXOzpG8i1pCY4sE0An0d2OLyZQ0LIwgTZkSfQQtsr8LnV6pD6sAkfLP6VLL0f3Z5pb8v63u2qomxwbOAHEwSipNi3RLnhOTgVOoYKnJ5dwsvOmciogDizWtRC7iUe74OdRJe6nubrBfYzUOx4OrgZl+V/qjTOoLr5/vr87ufAxLULSpuEld27gaWfC7mjtQEsSpUvlcNXCDRjop9WVO1Cz+pKu3s22f7TmrnhEA0PX4ruU7YOsuoI1FtQLRkVo8TXC54lnYNz0sOdos+8rcjBBQkBwJGCzxSxvY6u7dbZbptL+Z04Z6X25lbsd4Cq8vaBHSoCzwk2PcNjBjdwCQsSU6kXsZBzuQCbADEQYJZPD0JsX4E2tvfROMXqO5XRxhkNMAhF5UJ8elWJlrnMnTJx4+LlPoEDKbFy9uqMoq3P2M/IHBzvQOptfSHKNQ/F19IyjpNz6GRrh0F2kJ5uoJo+06Ngi1nx5V3C0MnuQXiO3NngiMkFm7BkPeHgFOCUhT23om8jNv78gbY85JT4qhqhLVss4vRwK2luHl8IDoXb6spptIQG28AMvFAc32+AHHZROI+VMOsLdCIlFQY+3ACtaCw3i2J0Ny4GCWvC6on9TkYeTQbZksfFqG16bE7bjAD/1AMgz5lIjBoB7m8v3mPUXaefIcF0SmV+qjG8U+mkfkF2Y20KCLk5F4tJmGdD7tjb8sG8rlkD7V+Mt8VZEIk2l2fgljqrPzBma74cwu0RFgbABi3+2C4q/FwD0Y6j2XR5MqmoUifKdCpp/oTug0NmHkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66946007)(66556008)(66476007)(86362001)(36756003)(921005)(31696002)(2616005)(4326008)(2906002)(54906003)(8676002)(6486002)(110136005)(31686004)(316002)(7416002)(52116002)(508600001)(53546011)(186003)(8936002)(966005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkV5SDJFSCtlUWVkK2RJMGtrRHQ3UGtkZEg5TlZIYUFxZnpDMXRxVzVyQko4?=
 =?utf-8?B?amZ1SkRxVUNzVDVlQlQ4N0RuajU2YjVBOTN0OHRBSktNVFlpOGhBMzBaNmhi?=
 =?utf-8?B?cks1dGFDVjBOUnpXQjd4VjVsQ0NWTVBLVXorMUxORUZiUjNwTEE5RTNyZkNv?=
 =?utf-8?B?eVhkSks2ZmppczAzdE1tdlBhdmpTN3hyVmIwOG9XbUtLV3BMbWNJRUZ0clNP?=
 =?utf-8?B?bTRaSXZHRllQS243U09jRkt6ci85TXoyREpsYmFRWXZBSXhrMXFqdzNIWTVT?=
 =?utf-8?B?VzJ4RGZ4WU5CbDJCeTI4THlaZnowbWR3cWs0UEY3WDNhVVJOMzJMRWc1VkQ4?=
 =?utf-8?B?UmhoWTBiVmhSWkplVUMwNXJoOUFiMjlyWHA3cGJIbXNYcEcveHV2RGtYbHJJ?=
 =?utf-8?B?Y1pOcElUNTZ3VThkd2FDcy91YUJmWWRySFNNMFFzeXROSndYeUpSNy9iTVNI?=
 =?utf-8?B?emxxZ3ZSN0FnQVpFbXpseTRha2dxSEorWHFNRmszL3VPOE90Z1Y3RDM1M2RK?=
 =?utf-8?B?VTNDT2ZCMm5LR1FCMDI1Z0oxRnlFb2tqV0xSZ3JuS3l6T3dlaURNTVdsd2xo?=
 =?utf-8?B?cTJ6TXlSYy9oMWxMZC9rTUQ5dUJXRUtIeGlVUUNtbUZyWlNJdDN4cHhGU0RC?=
 =?utf-8?B?T3Q4RUozQmp5UW1DUUZGaFJWMWxFWm5vUUZaT0p3OGc5MVl2UDQrdEJqVnBH?=
 =?utf-8?B?V0ZhZUlCWWh2RUcrU2xxenBobzRLT0dYYTM1ZDBjRHlZdXBRU2t5QnNsUFBw?=
 =?utf-8?B?aUs1aGZBS0VRNHBGb2g5bHVjNzRrcS9zcjNOZlFLVEoxRDBlTDBKc1E1Mzh3?=
 =?utf-8?B?Q0NmdEJmVnZrcnRERTVUQ0N1YVNZcWZTYXEwRlVJc0VyTk8rWkJNQmhQVHhZ?=
 =?utf-8?B?bnZZQ0F5ODQvbGJ1WjdnZFVzdEtDMS83cU1HdTJaMU1iSkJ2V1Z1Y2xuVHBn?=
 =?utf-8?B?V3hLa3VxbG0rd3hDK051SHVibDd0TVJWQTQ0VC9LNXNJV0NrV3Vnd2ovc2RT?=
 =?utf-8?B?NDBrNGsyVWtGTHBnaXhEbXlRcE9abXphRHdrV0R4S0J1L2VSdFlLRVdzUmIr?=
 =?utf-8?B?c1RsVXZNNWpWaGVXTmJ6QmJ3OXZUK1BQQXZZbi8wd3hLWERhZnF6bEdDcVNq?=
 =?utf-8?B?dmpMWEo5M1RmWkdvZTZSUjNoYVB1N3dvUXlvL3NyNWVNRWluL2xseXRiaUhi?=
 =?utf-8?B?RWZPUElKSjF0Z0ZvM2hYVXVLTldaSE9LTi9GTHgvUVUvZ0ZCWkp5cFFudlZQ?=
 =?utf-8?B?MzRPelNidkVvVGQwUElJdk1CczNzM0J0Z1c0aXFXWWxoeWNsdVJrSTgwTlkr?=
 =?utf-8?B?YmRWQ0w4aXRzd2lBQkFpYUdXenBLY1A4cW5XYTlvcVVYL2JlRGJhdXdOa0M2?=
 =?utf-8?B?czFsSUhZUTY5M25YVXFoYldFdlVacE5qRk82WUFMQWRneVprTWJseEo2TGZC?=
 =?utf-8?B?QVo5aVozQ3p0a05iZ3czMTM2YVhKSWdSb0hKUDIySTZFdk56SVpXVjF0MzZn?=
 =?utf-8?B?aVAvN3hZSGcweWdvZGQwT0llYllPandWUU4wSnZRUFFtdVFJZTFBenp1TEo0?=
 =?utf-8?B?eVVlSjVLY0JpdWhvMTVPcDdFR3U1eVFidjJnRVlKN0xTOWllaWNydGdlanpl?=
 =?utf-8?B?NFN4a3BDYWFNY2JVTW5jV041NWo0TnRmTzM5aUJHS0QyM000dUloa2tlSGdm?=
 =?utf-8?B?eENwdU1sTDF4cUE5dGVDVEUyRlgrdmFidXkwM0JIWnNPSEN0dGpDdzI5d0lM?=
 =?utf-8?B?OWc3dVNMTDdqdGNWdjdjZTBzb3RoeVJ6VUNsVTIwczVoSm5PRERXMW9WN0Uw?=
 =?utf-8?Q?u884s/GQGKL099NUdN7Z0S/eKrI2aGmD1Q9Pc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e82c8372-be4a-4fa2-1123-08d95c5920d8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 23:46:52.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BbPWlpYohzd8s1xsmr1ziVfyxqzr7tzcTWUON3iLQHinxiz1vKah4ZJvpKCfcUi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3903
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0imHxm5LdvveSwm22ResnbFDB7cS7Wyd
X-Proofpoint-ORIG-GUID: 0imHxm5LdvveSwm22ResnbFDB7cS7Wyd
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_08:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=612 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/21 2:28 AM, Kuniyuki Iwashima wrote:
> The iterator can output the same result compared to /proc/net/unix.
> 
>    # cat /sys/fs/bpf/unix
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer

There seems a misalignment between header line and data line.
I know /proc/net/unix having this issue as well. But can we adjust 
spacing in bpf program to make header/data properly aligned?

>    ffff9fca0023d000: 00000002 00000000 00000000 0001 01 11058 @Hello@World@
> 
>    # cat /proc/net/unix
>    Num       RefCount Protocol Flags    Type St Inode Path
>    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
>    ffff9fca0023d000: 00000002 00000000 00000000 0001 01 11058 @Hello@World@
> 
> Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
> Yonghong Song for analysing and fixing.
> 
> [0] https://reviews.llvm.org/D107483
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

LGTM. Thanks!

Acked-by: Yonghong Song <yhs@fb.com>
