Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004413E8693
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhHJXdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:33:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44268 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235242AbhHJXdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 19:33:46 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ANApSx023465;
        Tue, 10 Aug 2021 16:32:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tHOX06X+51fM76PUFSKvA8r/EppslZCwdkcxoSzWda4=;
 b=hxciaoTC2veNeqWPfxgan/3bL9874tAqUGPnVy5dZ7YtpFSPp32ArYkmvb1K5TIk+uKR
 M20Q0Sa2TGW/O4gG6hkzJSLjts9nvZKu8Jb2DeCZFTdFdl4ACco40YAnFdZI8ISeelpu
 HoNd7r+xNM9Uw/I3ouAfvV9QOMCObv6JubU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aby7k9nbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Aug 2021 16:32:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 10 Aug 2021 16:32:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMtQ7rn3KzWkV+JWLHWDdrsYRDzMOzfw2e1zxSKgwsoklASmzj1Mh8GKJ6cTxnXRQd9/F6EWnFZK1sqCd+qeNFEPdwy/wXIp7usPyD1BDFoXJiDbb9RJtAPQypB6y8WNlVL/lVGwLF640ZyzqHr4vFFop/PqGFpF3XdKg2CIRclEo9PB8Sl3JTt4BrbY06kUvDNIURC4O5Wdwm2KjPdsGiBH+vlk7n5m52yemnrj6/x/fbS4ZlRl2mqj/WEFfVjZZ+2BPrt8onC7fhCDoXkX0lfTpbmsEx9ATvKc4VNPetoUQMlihUp6wm4rWg3zXxE/1e0JJeaT4bP7JjTVtLoiIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHOX06X+51fM76PUFSKvA8r/EppslZCwdkcxoSzWda4=;
 b=LCxiHzWji0TiKF2J+AhGWoRQcifLoNcQcv9mriwFt5DiB+ISCD8IwNyNGArmidNNV5op8c0jnXW40GSzUy6/5wLBZD3ITMNg2CoY+HM1xhGo7utwwFOvGjugAfAkxgRLio8epDMxNNaJ3MJMXmUiC+0OoU2d3eWvYoAR2Lu+nqvFAMEiHomnIn4yE5zh0s1oqeiu3FgGC61f12gEoBpHJHhJZjYXB+NahABdDv5p+ubd788I4RFo8jNrJRz5OAKUslp31jb23HVvY62okfQiW9A7Qh1UGNqj8ZXuOj11/NLYvoESAwnL1a0CkffgVU0wtSouBAHgwyrv3OjMdiIqiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2413.namprd15.prod.outlook.com (2603:10b6:805:1b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 10 Aug
 2021 23:32:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 23:32:45 +0000
Subject: Re: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in
 bpf_bprintf_prepare().
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
 <20210810092807.13190-3-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <498d3ae8-bcc9-511d-d8d0-7f5a847123f2@fb.com>
Date:   Tue, 10 Aug 2021 16:32:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210810092807.13190-3-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1572] (2620:10d:c090:400::5:d180) by SJ0PR13CA0048.namprd13.prod.outlook.com (2603:10b6:a03:2c2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Tue, 10 Aug 2021 23:32:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8af8abc-a719-4842-4a1a-08d95c572820
X-MS-TrafficTypeDiagnostic: SN6PR15MB2413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB24130F4D4A0D1E2D0DBA6CD3D3F79@SN6PR15MB2413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpz7UWgkNJAjQwpWHz1wF5bAYVDm2V7l/Az3MDNNLBGLlHHLnfVRZaBuuWdSai1S2ygCqw5ANg77sLUse2Bp706COw2reSEHiytT6BG4c4VJSonvUG+D3QIBYRso8j/QP1PNzvGT//xyAm0/ChE8zcJkJ9RnCrGzr963xJd0WeFIaWSpTGLhjVtohyKp3+PTa71f+GsoXNwY5isM2E4z4fUSYlIlETloNtdgLG6vrn1rSYnu/1z9ao9wz7SjJUOmJkFd4XCO8C1a3fFi4ZpxkKiXYiSOpAam3qU1fhwdSFlDxpE+ziYFLd54X5VfzTH/9RSRkGDYWNpjzO14dzOPLaLRiQg2d8PuZ06KrNnjgkX6IXoYc8F3hkYcgJS4CK4i6IlJyFTrsxKW0fiUXOkJyZLqIa22Uqzp00UsCQ9YoVLSPJvrHns2CULYdD0+qVWG19XlSH1l5ADVlg9OT8YgHwHXKZ5pA608oayg2t0bhyRYDSoBdFIW+djAxfqEeo/vOM4MsKk5GAWmJwvoDMiImLzoVEuMfp4xRcjkcRVx3eaX7usjWhPetYa1gn04nJzKDeYiC4+AVVhFzCKcwyafaYwZopLse+TkP8Uconcahanv1TWwUCet3k7XqoA1CNaOOpoayCgkd249FBJfQDCXAqmgU3+bgP9K68IbBnR3omm5mJyjEtjh1YFf5cy0C2APFG3cWZldtCjGZlrKMXf+ohTsd2DDRXwUXXEO4V+8MooGhD12CBXJD2spQ/ps2hWA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(4326008)(53546011)(2906002)(8936002)(38100700002)(86362001)(921005)(508600001)(4744005)(5660300002)(36756003)(316002)(54906003)(186003)(110136005)(52116002)(66476007)(66556008)(6486002)(7416002)(66946007)(31686004)(8676002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkM4bGIzdGRubzdxRjNJZWdnL000bFFiYXNYdXlYSjNuc3hKWTNzVnF1cUlU?=
 =?utf-8?B?TXBobjR6RlBHMUd3bHAvNUF6dS9vY1R6ZTJ1MDI0STU5WHhZOGp6TmVTSVQz?=
 =?utf-8?B?QUV5UXdUenRGZ2JpM1BJeXZtc2FQVW1XWitQZ1dMK3RiU2d0c3FVY2hXNmNB?=
 =?utf-8?B?UVp6MEM2Rk9pVnBVMXNqa25QWUxuZ3owYWJsTC8zenhFQlhiL0JUSTg5Y3VP?=
 =?utf-8?B?Y05HVDdqY2YwTUJBZ3hmQy9kTE5vN0dhV1BIbCsxNU9tVjU4Mlc5Vlc5cXdk?=
 =?utf-8?B?Q2IvRTA4YVVCcEwwKzdtRm9WUUdMWnRzN1dGT3lRbGk0dTNWVXVDM2N6RDJS?=
 =?utf-8?B?cmR3Tk0vV21oN3dxOWtTcVo4cUNabnlzd3hkME1RN3hrODBKMHZic1ZMaVFY?=
 =?utf-8?B?dm1NRzJFR2NzenBzOXlLN21YTU5STjUyazQzYys0U1d4bHJGR3RCRzl1MUd4?=
 =?utf-8?B?RFp2TEErWEVMcHVSczQ0RVRxeG9rUFBVT1dVS0VPK05OTXdacmtzZzdzUXJ2?=
 =?utf-8?B?RXhPaUFKWVRyYy8rcXVXQksrQ0wzZ3VUNm12empvUGRxNkN6T0lXbGwxczk3?=
 =?utf-8?B?d1hCRVdFREJGR01jNklzdEtBRnloWTAycFdNa09zL0JQRnlERlAybithQ2pI?=
 =?utf-8?B?cVJvd25FMGdoWE5FKzlNaUE1YTNGaE1vRitaRW9NNjE4TFNBSGxZbGxHYTQx?=
 =?utf-8?B?clRsTmVSWXUzcEVsQ0pobWFqMS9zQWhFWUtsUERUYitBampQcmxPM2Y4TExT?=
 =?utf-8?B?Z0xwemxoMnBnL3BxRVk1b3BWcVhjbGQxSHowVnZIVi9lT25ScGlBTFlObDNq?=
 =?utf-8?B?OVcxSDduWkZMTTJUTFV3Q042WENlSzhINmRDSVZkdnNOR1o4U2ZoOTZpZXFi?=
 =?utf-8?B?dTliVmwzZkJ1L1IyR2dNb2xlc1k5MXlWSXlzcmJaSE50WWtWTno1L2tJYmJx?=
 =?utf-8?B?eWVZN0RkUGJoeXErUm5jSEcrNzg5WDdMK0J6cjIwSXJPdktrZjhaODVEWkZy?=
 =?utf-8?B?cm5lL0hhTTMvcllpS0ZMN1dRaWFpMDk5aHpEOFo3TFlheTVQS3pXK21Qaldu?=
 =?utf-8?B?K0d5a01pNm56am5helpIVjNYelJHQVArd2xDQkYzdFNKT1FBd2gwK1YwUGFG?=
 =?utf-8?B?ZXhUc2w4UGx4RmIwRGdkSktEMklEV3hCanJxbmxWenlJaVNITXJhTytFQnho?=
 =?utf-8?B?RGVoV1N3RTFwdk51Tjk5YWFseHF3eXpNaUFsZ2xOUzJvQ1FIRGRnb25RNUc0?=
 =?utf-8?B?SzF6Qnl0cHg5VkR3T2RNY0lpK3QzeG0xNTZLalpzTWs1K1phTm92U1llZEFx?=
 =?utf-8?B?cXhPbTNNZWZyNG9tSmtZTGlJVG5oWXZ3UWhJL1BsdnE2V0lBbmlNSGV6eGh0?=
 =?utf-8?B?ektjRzNkVnQ4eldNWW9pa0JMb1lUMU9FWE9DNkpxZWVjQnpPa2cwbkhXMFlB?=
 =?utf-8?B?QmFmdjVrNjZ4djJzc0ZzZHhpMmZvNGd3OW05NUVQZzRpcDc3QzNMQzFSYmFs?=
 =?utf-8?B?M1AxMjlRR3lURUhtOUJ2T0MySDhQZ0xMTmVUTiszZFF6Z0VlSkJLMU9DaDNC?=
 =?utf-8?B?Vmszb0pXNXVWY3ZVNDRXd3dCMEd5dXlnV1JtaHZWNDBsMFBsb295UVBucTNj?=
 =?utf-8?B?cHI4Z2w4YmZKb2k2SjRGTUFocTZLRTFKbmp4VDhJenlYK0d5eGdFVlh2c240?=
 =?utf-8?B?ZHh1ZGs4SlFnYlppZlUwQXpraTJiSmxjYm9MS1JyNDZWRlRmQ2RvOWhTQmdy?=
 =?utf-8?B?MGwzYXE0YlhPREhoL1BHTG5waXh2TG0weHhidmRpRE5PSjIxdFZtTWlVV29J?=
 =?utf-8?B?UXhHMkltOUNVVFNIaS9NZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8af8abc-a719-4842-4a1a-08d95c572820
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 23:32:45.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKgAF2otu8eSGmY5Smx14Lr0oImrKmxwKCNGB+e/+oLwd+3RhGLNS5Tz1LGzbcr1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2413
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: m3uktfkHNUJA9LvY8HYk1_2zH3jYpLX9
X-Proofpoint-ORIG-GUID: m3uktfkHNUJA9LvY8HYk1_2zH3jYpLX9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_08:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=964 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/21 2:28 AM, Kuniyuki Iwashima wrote:
> /proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
> the name of the abstract UNIX domain socket.  The following selftest uses
> it, so this patch adds support for "%c".  Note that it does not support
> wide character ("%lc" and "%llc") for simplicity.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Acked-by: Yonghong Song <yhs@fb.com>
