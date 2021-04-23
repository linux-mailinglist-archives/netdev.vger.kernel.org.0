Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E173699DA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhDWSkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:40:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30680 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:40:21 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIQ2aG019898;
        Fri, 23 Apr 2021 11:39:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CHzgLa46Y1Y8Qb8qY8TkPMNOcxU8+2uX7lkWEhFoeBk=;
 b=iEEfj/mI1ZEJCDQ823z4odWEBhHAS9e3sRngib3UsHFau0LpFv4jvyjAo8RuglQL9Ao+
 9lsqmco3kYCRtBZRs4dcmo2FPxL9OyqH0lRpu6Rke6faRXWssr/M49/6Z9xVULbZXPSa
 wPRkc7hIFV5nCeEJ/bQ4PadYStipbaneGpw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3841bqgxwt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:39:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:39:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7kstWzGNWAaDeAll0WZBHF+Ykbe4vVvI3T6p1DhoW+rPo4I9QSJYXv6gE0JYmqG+B4GtSddCzS7ZTBCdV1myNIvbvS5DoyB8oBOcmqp7E+qFJO97cDBRX9Nf2Jqh+gKotwF+qCqBQbCY4NrGXewlxnoZY1er6NYKg9aiwr496Jqf2Eh92+RyVEXZTVMjvVjHHKfS8ik4luUCPvMtp0vHwd+8QTes9gJyqlO7bp6m62x9UVqIMRa2tYHsWy0eUVI0ydhthqzNIseYJupDBXGdDinWRzRXjLK6oRUGVV+zsS9RQwChGA0dCuCFj/LP2AZ0pnHxluLs3AGdt/vLMXYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHzgLa46Y1Y8Qb8qY8TkPMNOcxU8+2uX7lkWEhFoeBk=;
 b=Bq996YnOV22UK4ww6CetQ7AEcAimLqmstCfet471uat7otXxX2PWUsZG4Av+kCgxjhZGK2j722QF2bNuh07yRhNaQXhSIQssOuwBZ4UJk42iwfGet47zlKhSWs+q3+8K9bkhsjkH/Na64cj1+eIFAdJJwu+IcB1hUTdUnvH4HYgRvlOVtOcfEU7Gfcc6PTHndLFZ2cnSPnewusix231qE4XWhqlyTk5Dz6nRpkWoV+9lPgPgktcVhSc9OHaaeEKpVunnOmBvHgzqH2SEkneli9ZuMylvnORvZ+J0YKNWd/GgXX/HRGrv+9f+CQdzpKcnogz5bbVE8t5Ug0nB2ddXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2061.namprd15.prod.outlook.com (2603:10b6:805:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 18:39:29 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:39:29 +0000
Subject: Re: [PATCH v3 bpf-next 09/18] libbpf: extend sanity checking ELF
 symbols with externs validation
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-10-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3ef6ec65-d111-760d-bb33-aad8bed1f243@fb.com>
Date:   Fri, 23 Apr 2021 11:39:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-10-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW4PR04CA0311.namprd04.prod.outlook.com
 (2603:10b6:303:82::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW4PR04CA0311.namprd04.prod.outlook.com (2603:10b6:303:82::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 18:39:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9c68612-612b-4b8b-9642-08d906872122
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB20615C8A7866F6B989AF9703D3459@SN6PR1501MB2061.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gORInini0hdb0EizrAo4a76CeA40wTi3p5luOBHc5gsddM/PzSITy3Ku3PPp5BY1oTRhErMFUGHyNJmBBDussejZLgcdCRYtm893ddyIMnV3rrVi/Ugomxesk0UYIpUfHheVTu9nZ4gpmA30x119p6IHvmfaf9B/q5/H2eITjTcVCI5GfTpD5eOBe5tIOtxuL+hrKKbWwnHxH2nTLJ4CLGBQVC7DIjUGcAz4K/vlYGF4bIgqp/ceSoy+jfFeBAd7DEv4tIwJjQgiBS6m3Ypd53SzUAnTIX9yAn0kySkKu8e2tjtlLX7GvOcj+DqclxFS+XiRQzhiFIhBrCoTdk13Vc1NffDgVT8PisSAMFn7kh1/UI5FEbx/1rkYfaC18PGljkYqC0qSOCDrviO9o1y1pCYIwtUw6RQ/qQKXx/Zvbx9u2fE/JA/LfA6BlqpSUzTCwNUKsCIvSHLKDRotI4ZN4cUOQZd7aDFlm+YpyTyGShgm7l5aGSGnZ/xYIXkh1csvsMJgB5Y+nIi74wvIFZKDteDgyRP5Y8su5i4SobBgtbE5JGPsC+H49atqjNPLJYKYmW5WwrhOy7EDu+2Q2uIhqI06jb6hCIwowH+y1sIdpUAqYorfWe4psdxY9a1vLu0avx1IDapOJ9lGg5FlNj/l44rWjA68VAo5XNSVz+hgxELyxdRlvp+GwvjF5mkWgtY+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(38100700002)(66946007)(186003)(16526019)(2616005)(36756003)(8936002)(2906002)(6486002)(4326008)(478600001)(66556008)(52116002)(8676002)(31686004)(66476007)(316002)(53546011)(5660300002)(86362001)(31696002)(83380400001)(558084003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDhibGpTenUrVWdZWjRadHEwWDlVeTlDSkx3QkYwNWI3SEdjYU5IZFNpeUo4?=
 =?utf-8?B?Z1VNZEJQd2wrbmpNNXlZdk1tNHEyMWNzL0VUZWpCM1dqSmJiUEZjcDRIbEVJ?=
 =?utf-8?B?Qm1IWlBPTmRva2Z3T0ZxbEt6L0ZmNUtkcU9HN2QvcWYwWUlqaG5Rai9sT2hq?=
 =?utf-8?B?TmNyNW9PY3dwa0lqR2hkaUlCTU4rbTdrUytpUXZjL0pTYTBYVW9mS0xPOEJT?=
 =?utf-8?B?UEdZOGdvNEoxOEtsWHpuM01GS0tqa1pUbFpPRUxOd01OWGdwaG1lWDlzeTRq?=
 =?utf-8?B?dXRBbmZWQnlPMXg0VGdZQ3ZOajdiVEFLbjNTMzFDUnVNV0hVbGZ6WFZqNVpF?=
 =?utf-8?B?T2x1MllVRklLcGU3ejVxOXFJN2orNk91Q2ZBZzIrd3VnOG8yZkt3eXJ0WVFz?=
 =?utf-8?B?UCtpWkRNdjAvTEpWRXZtZ05TMDdJSGNBMVZSQnlJQ1RSWVV1L3daZkI2Sk1Z?=
 =?utf-8?B?c0dES0dyakhsZW81NTBFNUp0YVVwUWlrblVXMk9BS1lzVUt4ZmMzcFBSZ0xj?=
 =?utf-8?B?UEpaSFFEbVB2WkIvb0c5QnZ1ZURwSEJlSTMvSWxQSXh0Vnh5U3FLbEFBSjda?=
 =?utf-8?B?NDFuT3pFS0JpdjNscHJsWGJRTmx2cyttZzllNDRoMTZGUmFVQkRvTXBkWU9i?=
 =?utf-8?B?QTZiQmd1RnAvbXNWTEVrdFNYT0d5a2FzdFdmaVN1VEFCZit0ejFKWmhNa0Mv?=
 =?utf-8?B?VFREMEdYWDAwTEJCbDJXT1ozcWZNOS9zU2dGYnBDS1VVOC9WT0U5RStUT3ls?=
 =?utf-8?B?WE1weGo2eTA0cGFNdUR3SHkyRHVNM0NwcXRwNXVmeHZFMzM4ODdYbU9DNWdG?=
 =?utf-8?B?S2ZEMWFhd21qaDVkWHNnZStrSU1PODNsSHZ6ek9nTGMzOGYwRlhrbkNrYTll?=
 =?utf-8?B?RXk3cFdKOEM4L1Q2Yyt6cW5hbkp4VmtUVEhnRExvZVMvMndtaVl1Sm51eGp4?=
 =?utf-8?B?N253cDN3bnlOOS9Dc2FDRFZuL2U3RnEwWmtFMWE1UU5pdHhRUG5pcWlIMDNN?=
 =?utf-8?B?UkN2TWpvOVRoVit3MnVCcUJFWGNJeklsK2xPdDhOTmxMMm5yb0Z1VHlqZXcr?=
 =?utf-8?B?cWpHWnJZdmt0bU5uVU9HbitwNDcwVXdrWXh2N1hwZjRUMnBtck1hNnA0T1hu?=
 =?utf-8?B?a0htYXlQZ2tJeWRldzc5QXM5R3FnZHVjL3pBN1JwUjgvMm5oUzRHQVJDdk92?=
 =?utf-8?B?NHY3amt3ZWFJbHd1MDA1N3pvQXFmaHpZTVRSclBCNjZTRzJFTDBjNERqVzlO?=
 =?utf-8?B?WTIvKy9Td1ozMGFsS21RM2JRWlJQWG5rUEMvT2d0NlZXMExDc3lTc0hqSGZX?=
 =?utf-8?B?dktKZU0ydW5uc29tRTZjT2FGYzQ5ZDlzM3pJazgzeHFOVU9waERBbGdVZTZC?=
 =?utf-8?B?djVyamFRbERJdTJjei9EajdBZGhUUTVVRHpydzFZblM5azJLV0tERk9yTG1Q?=
 =?utf-8?B?djNzL2E3N3V5d1BDcW9YQTJxbXNzcy9weVVma1BFWFdoMzdSdGVHZUsrd1hL?=
 =?utf-8?B?WXpZdTRoT0ZITjdpdit6ckFxWmYrT1UyVFpWQ3dZdmwvUGk5K09YaHZORW1U?=
 =?utf-8?B?VXVPYlBKQjhlUHg5SExpUEI2RG5pbHZ3WTZUY0Nhb0J4TTlxaHdSM3lIYWZV?=
 =?utf-8?B?K3hVcmtEa1MrdGhjYS9IclB4OUQ0ZzhWVDY3MGVyZERCWUt4cmorU0YvUDdr?=
 =?utf-8?B?VDU4cHozVURQSzNwcWtQOTlpUkJDU0dUclNpdURuVXpHNlMvODBjUUV2ZVRi?=
 =?utf-8?B?YkdrTVFZU2VuM0R1OUl2NnJJUjZFNXFwRm9RYWdHV1Vpd25HMkFYWGs0UUhG?=
 =?utf-8?Q?IzQXDkHIYWQcTYjpuqn4xBlgIGzUsLKWxfFBc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c68612-612b-4b8b-9642-08d906872122
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:39:29.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LpxrPKhBM+l2QkLoXX9qT1tvfJFs9+NijIFkuj1N1pUxWnLc0RMcv+/OoQ9ptnKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2061
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ZpDpinTLldOoYrUCaEzy-jttIhMeFdYg
X-Proofpoint-ORIG-GUID: ZpDpinTLldOoYrUCaEzy-jttIhMeFdYg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Add logic to validate extern symbols, plus some other minor extra checks, like
> ELF symbol #0 validation, general symbol visibility and binding validations.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
