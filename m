Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1162F5658
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbhANBq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:46:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbhANA6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:58:42 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10E0OdeY001233;
        Wed, 13 Jan 2021 16:49:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HT5ja9GODtu2yfpMU/QPk11VfLllQZJcvevyPc3MoOM=;
 b=g/lSWO9XhpCG55hPn3KLR2gHGRjX0C6QyCQoIihyXPrZLkzzFduzIdUve8vIPkJERwL3
 dac3xKk1BfO93x/4slS1254FuA2dKMSzk0UIyxrEWm4PI05Q8/eZvMWTTyfoLcT0We0/
 eGEOBkQc8FiEtAumM4TDpJVGXtdKhfF6xE0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 361fpqrdbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 16:49:47 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 16:49:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7eFMcbXY2CvlmzIa5dEu5In2usm5GG5gPhKDVJrFU0v7UwvjaLWwe25MGOn81cHpqnDRuWKUfrM5O4m9O0Q80heAFkTiC/jm/nYYUoXiFJNS4fEowAv+kyrQKnfkPN69o+evFcC7oHfr0Puwo1pvtvXX1YhA6g5jOKJaowoOYF0rUyA5aB7jmLQe9u9AHufFahMftBrUyDG/pqRJmOxqril1m6OA52mVPAIo153pcO1NDIKjtyCLWs4ux4HEdRfatdwVm5ypwHM5/RV0zQOyOggrdqyNoHryttNPIv2cKl0W5/4Km9LlNcwvVkJiqVRXXvLjdE4RuQhXJ7kdoO5gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT5ja9GODtu2yfpMU/QPk11VfLllQZJcvevyPc3MoOM=;
 b=dJa7hMwh5DH0L4vbOd50VchqxWrT1cvBC/wcZnMuMpKExVvhe0h4OKalocIJkejeNVTluo+Zyin07nnSuXc4uZroxhtw7XjMu15/FZ6kw0hHfgcg/jyYfnNa9xTDxfLssDjd8zXlmfUTph/JCsIpm8cTesG5iIW+J9HJWhSdrC0KcMA+bFELM3eNX36Ip+6LJZ8ZAp2BQkNxmbGP6ZNTHbGTjq+RkwoTqfrH+stLE95++MuXsPQxjS3uBQzYPVHRptrgXuNxZaugm1p0di3Td1JpSgriniOb/uQICzZtYcqufT2Us9WBlIAHhd7/7nUQMVPajJWflrhZwY0WlNmhNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT5ja9GODtu2yfpMU/QPk11VfLllQZJcvevyPc3MoOM=;
 b=XsZ5nyS/V4ByIXJ6cid+OtgMeVJKYRHl8tKKuqYrN/hI+xMZXgpLptOm2wo0htnFdZJgcK5mZSfKS+BjF8cHJLDUaOA1xHkALAeXgWcXN8soLar4bm1MlpxEHeEMad8bybhDa9PCZ0nIiASoFTWnKGrkapDiMQTbVwAsXBJheAk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2263.namprd15.prod.outlook.com (2603:10b6:a02:87::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Thu, 14 Jan
 2021 00:49:43 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 00:49:43 +0000
Subject: Re: [PATCH 1/2] bpf, libbpf: Avoid unused function warning on
 bpf_tail_call_static
To:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210113223609.3358812-1-irogers@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <31869464-ec5c-fb3c-a6c7-c4d3ce50c1de@fb.com>
Date:   Wed, 13 Jan 2021 16:49:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210113223609.3358812-1-irogers@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bbd5]
X-ClientProxiedBy: MW4PR04CA0230.namprd04.prod.outlook.com
 (2603:10b6:303:87::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:bbd5) by MW4PR04CA0230.namprd04.prod.outlook.com (2603:10b6:303:87::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 00:49:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68abdf04-7fb5-499a-eb32-08d8b8264844
X-MS-TrafficTypeDiagnostic: BYAPR15MB2263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB226364502F43CE2D690BD756D3A80@BYAPR15MB2263.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lo+hu4OhrHeOVRFNmeWWzvKeeezqTkcMMvsKfDqLmQbMKaW/pAPcFGr2D2Q/4x8WlHWVFoWJkV24ymtZuGX5RqdNIAvI+ei+mMex/bf8gJf8FYWPe4VXCuBWBSAmtC8PTXZvUwwBsJ/W1Ta+gBdzC58FNNlpotJ5lCP7morPIyfTofp6yg5Q0bfywBncf43NI/2V6njJJK8uBRkMJZCCuwOfj9FNG+WoxMYV1xaMod3lxSOCrjw2qsHR8gIfp7modBgan4UJM2VPo/4/gyiAN/tm4/C9H36V6ZXUJ1wkfryIffsmP0r46NfYxjPPfmLBYltqhuYbXBq4s8T7YEZ+dnvuCYW3tBFTSzOC06jnAh8vR9mqQejvOV6znKhYf2YVLYaEHt06Y5aXexbRxMOTeDkI20Op4M2FD13rA6heOpy5L8R9TPYU8Wq773yOCe4YzikuCDpTh7JxKB74BkHqFKsqkVbyFLn6GHhetUjHxVvGQJLogXYfDGwyQEc0TnTJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(376002)(39860400002)(2616005)(8676002)(52116002)(31696002)(31686004)(110136005)(66476007)(5660300002)(16526019)(2906002)(83380400001)(36756003)(558084003)(6486002)(7416002)(66946007)(478600001)(86362001)(921005)(316002)(53546011)(66556008)(8936002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVQ5Nm5mUW05eGFzeEJFbVlKQWFFdGlzMGZjb05lR2RIS0pVT2FYSDBvZnY4?=
 =?utf-8?B?WVBLeWhBOHFFcDk4TnRjZitqOWV0VVZXMXk5SzZuWEhjSFJac0dBNmRSUHJB?=
 =?utf-8?B?S2tGWldaYmlPbGF0TmMwdkwyT2psdk5jNUlYVXNIKzNVZDIyVEhEaVpjU0xm?=
 =?utf-8?B?dmVkR3JNczNrYzVQOGlsNVU1akQvUlhNM1F2NEgzelVSN1BxUkFDMVFTTVdx?=
 =?utf-8?B?RjdlWjFXdHFPT0dPSEliazV1VjVDcUg3UzNvTEdsWkVDdjZZckpvbkJ6N3Rl?=
 =?utf-8?B?TUJaN2pPRG1nVzZhYXdwZlhZbmlxbDZJUzhmYk1JUUk2akRxUDV6U1hTSzRI?=
 =?utf-8?B?VmhqT0VpcWI4UEtCQUNyanBidkh5K3JWNmpZR2JxRmdwY29ZNWN1eWZ5ZkFG?=
 =?utf-8?B?QzB0M0Z6Y3BpUkpZNTRGdXJML0k0eEdjdnphZ1d6anNra3czTXNKUGRmaHY5?=
 =?utf-8?B?RDA5UnltcFFsUmxLYXh4c2JHQlc0eGVWV3Aydnc3ZmRyVnZlMXlrZ05sSG9K?=
 =?utf-8?B?Zml6TW91UzlMdTQyZVhkUVZJUU1pRHcrTitMUnRROFdMaFNoOWk0b1djOEF1?=
 =?utf-8?B?REt0cFBkRmlTbmp0aTRPZlYxUkRBTlU4dU1FNFZqbVV2Y3lhdkNDTmJHaGhn?=
 =?utf-8?B?UGQ1RnFmMktReTdpeXBMTDNUMS9FcGhId0NnMUEyUHQ4UFJwUkswbHozUkh1?=
 =?utf-8?B?T1JoWmx2Wjd0SVNNM010d3RBTHp3RVJ0VTFDQU1ZVzV5aTVxRitPaTVHeE80?=
 =?utf-8?B?VDRQaEN2UWNRaFNCcnNQUVlYYk9jVTcrQzBxcWszMGZxSnNyV1FudCtnYmFj?=
 =?utf-8?B?RFNudEhNREt4cC9zeGpmQ1FzdkxmNHRqWi8xY1c3c0VVaytyZURsNlptNHh1?=
 =?utf-8?B?VVhCcHU1SnltNDFhZmczazN3dzBrVnd5Vks0Q3RJV01JcSt1dGJUVnlHaEdU?=
 =?utf-8?B?Nnc4S2ZUYUtHNDRpVUs4eVQzVUI4cmV3YzRkNUNzLzJZa3BTM3NTanNZVnpZ?=
 =?utf-8?B?U0RGaFFXWGdBUnJuNVMyb2hsbVUrdXNrQzZDalAwS3hHaXphU2FnbHVhV1li?=
 =?utf-8?B?UjRXYUxqQkhFWFV6Rm9sdld6cWd6RVJxUUo4S25aWmlwSDBKKzZKV1pTYjhi?=
 =?utf-8?B?ZnBaWmpDZVJ5UzhvbUZ0QlA2dmxnQU9ObFgzVnBzZlZRSWlnc3BWeDR1V0Jy?=
 =?utf-8?B?L0VmdFNsZWc2Qmsxd2did1NGQ09zT3JlZGV6RkpjZ0NyejZtK0s0eXRIdERF?=
 =?utf-8?B?NEhObzdWdjRUSXN2WmFRZnR2N2FEVjVVWEpHZDUrUXpObmErQmtTNHFqNUZa?=
 =?utf-8?B?UkVUMlB0K2R2aHhOVEo5SXVCVUdpdnNvOEZpS0tvN1NKbkRpNkZyNW9DTUJS?=
 =?utf-8?B?b2lFbmtOTnlFR2c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 00:49:43.2200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 68abdf04-7fb5-499a-eb32-08d8b8264844
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMIo6qhzwsUhvyhkl9OO/cg/oxVnKHEK7f6LJucf3UjQ4RyLPfmdcF3aJDnv+/E+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2263
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_14:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 2:36 PM, Ian Rogers wrote:
> Add inline to __always_inline making it match the linux/compiler.h.
> Adding this avoids an unused function warning on bpf_tail_call_static
> when compining with -Wall.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
