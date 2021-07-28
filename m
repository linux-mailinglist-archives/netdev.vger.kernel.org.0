Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2527E3D98F5
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 00:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhG1Wgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 18:36:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18450 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232154AbhG1Wgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 18:36:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SM9PvK028351;
        Wed, 28 Jul 2021 15:36:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bdhn4cLc7b0K8Hs0/pXvCu6GVjOscbz810w4aGsAtmQ=;
 b=ojON6phLtIZOZiJLF3xFY7uPYDMoAqDiRHzpLC0NGHDFTpVWJh7YnwHIBVo9NdFBaY1E
 M2TPF6NsIunRtBE3GOLu5JNNlLu7JGHzk94bk1hG+PvlOIyZzGsHYXARa58KCPzx9Re1
 Azxk3mJ21HE1XEoeacst1BL+xlAFSh0pX3A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3bu99n3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 15:36:21 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 15:36:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hli9mcuyLcJQFzDVOVxFUDtBf0jbHK4BqAEAgyWDGEOR2KTr14yVwYEAo+8hifGdTOqyb65eqedAy9sIutvLnPFwNb/HUwzumuA9F53Ocs8nV5upxTZUmxqkla00IeuBD+DmL1lbcOtLzDwLIxaeco1V3Kwd5SLCsdi3wezFVb41f0Cf2XZxbM+EEYbJYoztjBNjwpiCO/QoyrU7P2lsOIfpT4o/a115DpUo6muvMBLCqUIbqtB3iIOZkjuxxjqQVOR+dV4fPU3vmWCA1IG8c+PqAmCdhcCNqRh3LY3mQMVzLiqFAvz/b45N0cWViAAvFVV3K0S6G5sZuknOXetFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdhn4cLc7b0K8Hs0/pXvCu6GVjOscbz810w4aGsAtmQ=;
 b=RAAJSNkILbzG1zbI/zDUp9eddJojHKrx4yX4bVPwr095+qo0Ap3nLlwT+FYDT4b+aE5xGrRzVk9eImBLSmqC20NZOXIDpO/nCIrKnLrNroqk6uIJarXGh38hgY3o+3NH79OfKq9BxqJxHiI9yNxRLFK+XtQA+hZ3zmv466YQQm/x1IuUYwV+mU4eqnk3P+QsMZQignG7DNLEvCtTLwQaONKm+YrupJAp5BqEY8YrFKrouEps/FV+ncWnUWxJF1u3u/LlaXg1G61NiGsPt8E3dHyEphC2cNRiKPXG6zTwfkZt85fVQnb1FiXsbzezMdinY1xFT8BUK4DPeNZQiVdVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by DM5PR15MB1147.namprd15.prod.outlook.com (2603:10b6:3:bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 22:36:19 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::b0e1:ea29:ca0a:be9f%7]) with mapi id 15.20.4352.033; Wed, 28 Jul 2021
 22:36:19 +0000
Subject: Re: [PATCH 02/14] bpf/tests: Add BPF_MOV tests for zero and sign
 extension
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-3-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f91e2557-e4b6-3d87-b0e4-c0c9244c0fa1@fb.com>
Date:   Wed, 28 Jul 2021 15:36:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728170502.351010-3-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0088.namprd17.prod.outlook.com
 (2603:10b6:300:c2::26) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by MWHPR17CA0088.namprd17.prod.outlook.com (2603:10b6:300:c2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 22:36:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96d86e7f-e34f-4a24-6182-08d952181e6e
X-MS-TrafficTypeDiagnostic: DM5PR15MB1147:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB114703462F58B9C9FFEACF48D3EA9@DM5PR15MB1147.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dsSFXUwghAKSNoyrYjLD2f7j6knDREXOZGrFaWs2238Sqj9gW5Agw0LnbGwObKSR/bhA8X4IVTaYUeQAZRnHcy/3jf1DilIkRJQqOSRXGBMdA5bbvANd2tpgFJ1S/ptxVsQ6Eu/HL/2vLMxa5WvJWV++kalSObVFVEO015vBrAH7GIPOWmqUfnXxC5Yz74HXhsD33ybWSMOw5L78qJsd/Y29G6M/MNXs0adRhoysEYuNP6OGbRtmS2cDA+kmWZ2B3gEWdHDooQ0xYvg1+IWrU4+sO4iyPobtkIXB7KpTNYBOBI+vBkKpazT6yG/ddSIcVntWlLcNIvnTwbYhO0rfy7yo+1vBTTDGglrJN/Bhe4arB7bBeTjvRkx9jiO/K+p30eqMsTeoWv4WODU0MxxagYlA85QSWlMDMLWRtbPnOdu1bD6nJS57DM5pPsEWVaRVTlXTPfkI7Ibn/P6N2YK2Zg1gP4rm4/iKSDU56QM1b6liI6+kc4bVF46U9rhDzZnauFxAeH5A9uu82WZFzS5Yr0WJaSXrwoCd37ykX9J8jnNZRib+X1d9J+Z7ijJ0US2M8YBcuJxUH7sDVOjFv9dWkFsa30aoRquVztEerNbT0FtoQUFlXqS+fNFnln9nSpIaddR5wGUVEzAAaSeP+TmeyF0d4xWB1JBVBDxSvXO5JBP78N4NGTvR31ns8Mzt3jlSVvoQ0gE7KqyIqtZqp2ICA+f+pdFoyrk/LCB1VzvOds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(478600001)(2616005)(86362001)(66476007)(2906002)(31686004)(53546011)(66556008)(66946007)(4744005)(8676002)(4326008)(31696002)(8936002)(38100700002)(5660300002)(52116002)(36756003)(316002)(6486002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2xFQUFOTm5rQzYvUUx4MmtPYklGbDNDa3B6WE5wVEhNbWZITWIwYXlTbkg5?=
 =?utf-8?B?aG54SkVGcTJtTnV6UzBkblZWTE4vVGFxY1libkUrVmxGeEhNRWducFlySER2?=
 =?utf-8?B?V01VVWhyTGErdm9oRFRLUnlQV0FuNVVMcHM5ODFDN1IrMU9tdEhnd0Z2eWU0?=
 =?utf-8?B?aFd1b1hSOXhWeXUzbXhtcmdzL2MvRlVQSU15a3IwbENydGd3YlRwcGw1UldH?=
 =?utf-8?B?c2l0M3ZpOTUrcGltMnNQMHlXUytRQU1zQlFabGJRTGh2emIxeGFlN1diZ1dB?=
 =?utf-8?B?aG01VGxtVDRIWjF1YS8zRFV4LytCdEQrR2ovdEJkSGpoU1pXZjdKNnpvWjF1?=
 =?utf-8?B?aHI5Sll4b21pcnY5aUlCQytPRXlRNDJCT0RHOWo2YWlldE5Dd2xHMlNKVUhq?=
 =?utf-8?B?ZTFnMWdtNVRKSVYzWmJwWDBPWWM5MjdnS1g3bFlWK2dVanlJRkdNVThHOXlh?=
 =?utf-8?B?aEdVQlpvN0p2SmlSOWlLaWRWTFhKR3NSbkdFNHRXT1RvakoxalVwRFF1dWRr?=
 =?utf-8?B?VkY1TEk1VkdQZGh3Y2tIUXhLOEdEMklJTkFDck0zY3hpZmYxcUpIN1pjbkth?=
 =?utf-8?B?QWZaZlhHMGg1NW1zUGlrZk1jZit4MFJlZkZIakNxaEhjSEFtU2ZuZUpIaVBC?=
 =?utf-8?B?Y01veFNQdkhhNHZheS90L09oWGxTSTkwVVMyWUp0c2pTdzVXZTFWREdJS05i?=
 =?utf-8?B?VVgrNFFYUGkydlJ0M2dBRW0xVmJYS3JBRjRCcDVHemFIaGpIaEV0dlN4NDAy?=
 =?utf-8?B?RUxkd2JQZkc5ZXluQkppVHFoYm1aMkdMZ1BSZXlTbTVXV3dwRkszZmZtWU5Q?=
 =?utf-8?B?VHVTeGNTcmU0NWlOWnhoSjZBTklvek9TUlRhWUR3TEVuNXJObmtVLytOR0Ri?=
 =?utf-8?B?MmFrVm01a0k4ZWxybnFubzUyQTJQVzJlMmpoQWtlVDBDVThFdXVmQytFZ2tY?=
 =?utf-8?B?Mzk4SEVtSDZxYi9xblkvNjFDcW5HNkl6bWhQWEgxMXR6SDRzU0xKTWN4aEw2?=
 =?utf-8?B?dkxIakh2dDJoS2xQYjV3VFpSekxjeTgyWFoyYkdsdFhUWnZJODkwRCtNcXpk?=
 =?utf-8?B?WklvVzZkUkd5eGpmS3pRUHoyRmd1THROMXNyc0dwRk53WTFNZTIrbzFjelVv?=
 =?utf-8?B?akI2Y1piVzhBK1hNeFZrWmI2NmNHenl5aVU1aWRib0FxQmhVbFdoRDFDaC9y?=
 =?utf-8?B?eTU0TklOWHNGdzFqTWRUY3FSM0dsNm95aUxYbVBLZDUxR1NKQTBPVDdZMlFT?=
 =?utf-8?B?Nk0rclh4K281THl1V2g4MmRqSEpWTmtxSUptRUZJbmJGTlZyZFFOWHRzRmZT?=
 =?utf-8?B?YU16SXJ5M2FYNEtmcHArOW5ib3Fsdm9kQm9QWTk3bk5Cbm5FYzhTT3N2U0pO?=
 =?utf-8?B?ekRKNU83OS9UaW1iSFVHY205SG05SFdpbHBzYm5Oeng5c1NhaW4vd2tMQkw1?=
 =?utf-8?B?VGpsVDVKUnQzc244ZGNqcXNUQ0FCeXhJaytaYmp1ZDRyaFBBWUVCWXJRVFMr?=
 =?utf-8?B?em43N3E3bmUzS3llOG5zUjltVkhQc3FXMVVMMFo4K1JvSXBOQ0s1T09paTA3?=
 =?utf-8?B?M3VkbFM1MjNvNWdkNjlycnREKytqbVYzdGNvSWxLcGF2RFNROGFuc3dlK0Z3?=
 =?utf-8?B?VS9FdWpnWTBmVG1TY2xBTms3ZFRMS2QzNFFxYUhCanoyaGRsUnd6T3BObkRB?=
 =?utf-8?B?ZERPOFBLOHAvUE9ZVG92eHFxQ0VhRlM1OHJMQ3JNOFZQblRveTVkVTZVOHVD?=
 =?utf-8?B?R2xjMmQyOGMrc3h2RjhyYjdOU2FnUHNEVFRJVUpoMUNjMjlZWE04aDFxREpH?=
 =?utf-8?B?VlFHazFXWkFvVUQ0TnFSUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d86e7f-e34f-4a24-6182-08d952181e6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 22:36:19.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UTA787Q1A2puv8/UBkpbtBxMZFP9+bZYWRPrn7FAS4sSjb09EueADj5vdTjIs6k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1147
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ilhhm8QyebnH8DYXLMQKZR4LiXdNCv59
X-Proofpoint-GUID: Ilhhm8QyebnH8DYXLMQKZR4LiXdNCv59
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_12:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=898
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 10:04 AM, Johan Almbladh wrote:
> Tests for ALU32 and ALU64 MOV with different sizes of the immediate
> value. Depending on the immediate field width of the native CPU
> instructions, a JIT may generate code differently depending on the
> immediate value. Test that zero or sign extension is performed as
> expected. Mainly for JIT testing.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

Acked-by: Yonghong Song <yhs@fb.com>
