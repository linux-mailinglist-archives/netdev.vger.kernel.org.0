Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577793D7A32
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhG0PuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:50:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48876 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhG0PuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 11:50:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16RFfRTt021591;
        Tue, 27 Jul 2021 08:49:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OWoDjjrjdyLC6r5eEQJwLjoQN+5bnDyviSysYA595hc=;
 b=QVIMrjVnOJfKU27vHvRdDTl3lplzMEKHd34+N+1dC19c2Pm+5bxRGGaicwguJXkz0jx7
 JLkUzygIiO6F4ZWybQzyzEgc+6UZwsK3wpmV/HXNsqsnM8Ga417Fs+9D/IArGsIJCOcl
 0aZai0pjPGv7Ua/zvL7D9ZFuAcnytaorMi8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a235hdynn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 27 Jul 2021 08:49:57 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 08:49:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OA9BN/wPfV8aIVNw9UCbCbdZPyh6Bz/QY094miiV+6uQeK1i+YeAdSx6D9HMg/QnqNJs1tpI6VRRsVbqTAof509m8hpTABlNYbOEZKA29EPLOTXIIizAb5hFd/z0iRF2zm6voB87p264rwVCeN7W/8SZn4BOjvFV+1nRhEG8gDTu+mnVTx5xkmprBHnCfCNt1e63cQcFwDmyAXCijnp0PQqgGkKpqr9/1GwElWT02Wk/VWa06W/T3GNaFmTN3qildzimpEWDTCf4rKBVRmWPmTcQVtmWim0ubdGSc0beoUaT/pvTZzQxFnLR4mCmT3NU4GOAKn+OaRJt3XrTAp2gbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWoDjjrjdyLC6r5eEQJwLjoQN+5bnDyviSysYA595hc=;
 b=QWtZd1uNk2+HGOpyA8EdbRT8WrZ5x7niGcVJff3lHqYDquAOoG4Ka9Ai3bnlurP8IyvoKBR25n916jn2uOWtqt0zXArUghVOkz7HcfGWobDGQrnphr7vNIuEtSjFhMprk6xYD6tK7A9lnccVc/PcKr14wohX+RzpPxzItKf4oTt8Ye2dGl9LORNgSEjsODM1p4kLam7OxO9VjenHIxSUnWgQPxkf4zKb8v0oz31/N1r8R9az86M9dlp7bCmP3keZFatEso5naCyLIGnJFljYJzJXHQp7dS5HdmDXOCAxkXefbyhkK3MLAurbZ0Hhkopi8rECszaYiaU/BGHyU/wrXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (52.132.118.155) by
 SA0PR15MB3760.namprd15.prod.outlook.com (20.181.57.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.25; Tue, 27 Jul 2021 15:49:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 15:49:54 +0000
Subject: Re: [PATCH] libbpf: fix commnet typo
To:     Jason Wang <wangborong@cdjrlc.com>, <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210727115928.74600-1-wangborong@cdjrlc.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <16d5c24d-5a5f-5a33-02be-1f61a0ba665c@fb.com>
Date:   Tue, 27 Jul 2021 08:49:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210727115928.74600-1-wangborong@cdjrlc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0098.namprd05.prod.outlook.com
 (2603:10b6:a03:334::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:4698) by SJ0PR05CA0098.namprd05.prod.outlook.com (2603:10b6:a03:334::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 15:49:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a90767c1-6e7b-4437-c706-08d951162d76
X-MS-TrafficTypeDiagnostic: SA0PR15MB3760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3760D31F4592CB64F6146BDED3E99@SA0PR15MB3760.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHRo07kPROp8zpU0Y19UEXlqwI9wsM6/ZHRve7BxwNnFHzWb30lOVXh5gL9beTPABiWpOe/5zIrnSRovYcKcWdSlbSoFCXySZxbNwiAuGyHlDA3J7+pMHmnoXQ2SSYgXi4IEzOyCwNm8WxX5yiodEDSx5vxnokDwxVWoJn1P6gb0vOpPldg0PdQLQLO+f1FEcQwp+m5EvolspeCl6iVH05PoyszekDuD6M/QYsIhvx6unuaZGSRpdyZ3rB9SxjYbNmLhzW0/G5rOyn2rZRVMU3t432Hi0voAGBuTtH3s5S6NthJ9ALuFJ7kVxrASs1ES0m8YJ2s/KnBYFaBfqFR+MCGB+jC1vRnNj6yHCJeJfZQWWYN7cQWkyshjmEBw+fPafjQ0fJh5ONe5woeygzG1KQglqKIG4nRP51GcbEsIa2+WfLLEA61hSkuvmU6FQ6OHx8Qiq0SOKIIfj6PQlUHoHXBTdXRek6Syyh6W6rR6Hv79lwnHAEjE1dzJWKBq9oM2k/mIJISLYNMfgPHskMpkoFaJm3Ccmb2WhcDURcec+5lU8cCK/rWPkySAy53OAtLgMB4RO1qXog/6L7RSiXWa0lUUFyLuUI0+KpBLxSeTJsws42mB32jT83tb41Arp50rRXnMVuMflgPZ4xf0VWz3/mQXZCVeQcDph5IE93/atJ3tbbTfEc//ye1c1CQ+hlv9aEKfoyQvHhEOzI0Vzt9YquqmcW2qhvNFhBZAleNZ3HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(558084003)(66476007)(66946007)(478600001)(66556008)(38100700002)(2906002)(31696002)(8676002)(52116002)(31686004)(186003)(86362001)(8936002)(6486002)(36756003)(316002)(53546011)(5660300002)(2616005)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3VaeE1OTzBZOVFCb2J2VWNWQWltblc5d2VaVmZOS0FiSUxNQVBpR0VDWEN3?=
 =?utf-8?B?b2xDaTFtVUFtQlp1ZlNRKy9CQlJ4Z1dEWVpUOFJrdlNIeVlCT2xkRmw1NzFY?=
 =?utf-8?B?clIySmdKaWgwQXhzaTBRTDM2WG4zaDkwcGtjNWduSm5qNndnQk5VbkdPYlVp?=
 =?utf-8?B?dS9DRG40V1NpWDdtM2hWaHJpdG1NNzJ0Sk1vUldkbEYvb0w1blhhQTc3L255?=
 =?utf-8?B?UU1oTmVXbHlINjlEU0Nma3JLaFVneFk1RmRjNzJCWGlBL2hhcXlWaVRsL2ZQ?=
 =?utf-8?B?YmN1Zzk4d0NaMjg1RllSbHd0WlljNXJtVWVQRUpvY09DUDg4dW43KzRFSUw0?=
 =?utf-8?B?cmxLRGtnT3VVTUJ5ZVQzcjg3WXcxTE5nQ0tQOGhIUGFaWitIaTljQWhUZ1NM?=
 =?utf-8?B?cWpHSmhmUHRydXVSWTFENmdPVmlpaGpMT2haem4xblBjT0hicjJNdDJ4YXly?=
 =?utf-8?B?ZFJEK1RkTUhxNkVtTUkraVVRbVFTY3R3OEptN0lwNWQwWXlVU2twMHpzNUR0?=
 =?utf-8?B?S0VrbVJDSVVDbm5sMUlnbUl0RXcwSnN5RnljR09DTkc1SzhteUQvRU5BaTdQ?=
 =?utf-8?B?ZUdVTVBoRkFDak9MenQxNVF1clR2ZWEyZ0lMZzBxOXdub1Rjb1hwTEN0YkVC?=
 =?utf-8?B?VHJTRFlzUDVhQXJmdlVsVXVJSXVvTENydWJtU0xnaGM4MmM4dGc5M1ZDNUI4?=
 =?utf-8?B?OEdGME8zM1hMaW1Ga3QrNzhLbWpiZzRSQmNZMzU4UGFkcGtianUrM1lGVkdR?=
 =?utf-8?B?RVl4SDh4MDU5VDllUFZJNnFmSFduWWlmdjNjZGVkNm8rb2hhV3NTNCtnZldk?=
 =?utf-8?B?dUVFdXJNcUk5amVHOGRCMmk1ZUxXNHE2VmpOM3NESTllV1lzZS9wbzBOdERu?=
 =?utf-8?B?UGR2c1VMZkNtWkY2V2tpRTBBQU04WlNzUFBud1JlNGk4cExQOW1HK0J1ZTdX?=
 =?utf-8?B?RWhzOHFIM2pja1dXa2ZBT2xvSEJYTVhFVUwzUDBFUER4czNFOFpmOFdrTDVF?=
 =?utf-8?B?S1FMeHNieXo0dWM5cTRjdVMrU1BhWFRhbmxKVnBKME5GNGhXdVVGZGlJWkYw?=
 =?utf-8?B?OGhiMzFaOXlCemZVbTJEVzVTMHZXa21XaVowejkvMHBvUDhpVTkyY1FwMTRV?=
 =?utf-8?B?Y0xSM3pyZ2NjL3VsM0F1cHRvQ1dQZmp3dWhwVjlySlVBR21TOUpqWGcwS2RJ?=
 =?utf-8?B?K0djaTNUVTN1czBJdDAxL29Ya0tMb2E2Z04rbG90L2N0MlZCZzVIWk44a0ZD?=
 =?utf-8?B?TTlGellTQmgxYzJidUtZdjhHaWIzTTRzV2JyK3N5MC84bjhxdFBvMFFCSGlQ?=
 =?utf-8?B?VXZlMTNpNHpYNmN0eTE2Vkd5YmQ0MzgzVk5iQzV6TFMvOGttK2FxYnFSR3Q4?=
 =?utf-8?B?RzlFQjc3VkY0bVJ3OUo3UzgrM2tyRHJEb0dkMWNwZzNvdVVjK2FNMUNVSEdM?=
 =?utf-8?B?QVRyWWdOajlEb1A4T3NaSUtKZjZGandDd3hkTVZQeU5ZaGx4YnRFY1gxKzFV?=
 =?utf-8?B?R1ppQjdmUnNGSTFQaDF4RGxVUi80NFFydjEycUtFbDF2cjgvcjBxWDVpSHdU?=
 =?utf-8?B?QkFBcEVQREZUWkZkN2kxRGJjTVBTMitPNEhHS1NReUl6VjJXOVJENW92MGdU?=
 =?utf-8?B?emcwRTFJc2xlV3VnQU5MS1czaVVJU3VGalcybnFEdWpoMFpGSi8zci9jZmpQ?=
 =?utf-8?B?U1JBM1NvQnhiOEdhRzhRUW5ma2Rsa2ZzSUFIMDN5bjdGN2pOTjB3d0ZqRi9t?=
 =?utf-8?B?aXVKNnhFWUM3cmMvUzB4VzdQL00rYmdwSFpYa2J1WFFRYkw0cHQ5SmtGb1J5?=
 =?utf-8?B?TEgxQVhFZUhOYzltQmxrUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a90767c1-6e7b-4437-c706-08d951162d76
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 15:49:54.5354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/LIV8+/6UrEtxipQSpe77v1fQ4yf/GGpseQVVtNQhOZOtJH/fxMk+8iT8QSC3Gg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3760
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4yF3fPebINZY-A_NwQFop7Z3_r7XUbK4
X-Proofpoint-ORIG-GUID: 4yF3fPebINZY-A_NwQFop7Z3_r7XUbK4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-27_10:2021-07-27,2021-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=662 spamscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/27/21 4:59 AM, Jason Wang wrote:
> Remove the repeated word 'the' in line 48.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>

Acked-by: Yonghong Song <yhs@fb.com>
