Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44E46D8C2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbhLHQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:47:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28300 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237175AbhLHQrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:47:47 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8F9brq025815;
        Wed, 8 Dec 2021 16:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=t1K6tH58dLkcF1EnkTl1/GQKb4bMoxMht4Ja0SWcTik=;
 b=KNbJqnV+uWM5VnqCCmfnhiWQfn5sOIE68++gX8VjM3K6l4hLsAMkGsETqaeebMgdWGIr
 NPv/Uz2/SDRG8mNDW2FNaaSw1RowZpVjTqouGH0ZyOdWcqHk2AuB+bgH9236JCTPgqpJ
 NozeP834ylUTkLu/MAlskF5xS81p9v/4YNNXIOFKFnOJSfhWFj1g4eTl5kBKabVZJXcI
 gpECPdX4MtxEnUASdxzTmD5zS6jMFBMLblFpeOY/NitMITheIfS0Ooihc+LhRRwWFcXl
 1xCYmw90zT8sy+RN7i5wThmSdxnoqj7ohq/M6XwrT8EE1sFKz3de/M2P3wvZqnqZF7qM Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctt9ms02m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 16:44:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B8GKAkI143866;
        Wed, 8 Dec 2021 16:44:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3cr056jybw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 16:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFX9o2et4w93PAWoKkQGLScPbIVMiRsKu39ZUajbkpUFsWSafeOP8NXE7PzXDMUafMVnOGTMy4Q+0Hbayw6lmFtmnEj8op90Qg5oW7I3KX2RpWrGacWxA6d57RpxrWNh8iA+ysYPEdk2t96NVrNI+4gEm4x2l6RqY4fP1XOtNHg5SPGI9Y3Ajm4omnzRpadlfg83nEhTX1f0sSzXp85xVjGPp+OYlWdJE1yc1C+bbDNhRTdfLwtQ4x3BlsFiZJXxeYIGomHlajIxQGzRcjebTo0nl2St5bXXF5bKkLHdaTo69ucJPXrgnVlEY1IaPC4BxiCI2d6oGXv2gHhubreYng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1K6tH58dLkcF1EnkTl1/GQKb4bMoxMht4Ja0SWcTik=;
 b=FttwmS78n++JHh9hM4mhV/bH5+PD3jnJ5m+iEyH0Z5BrA0jZA7heDN5ScwaVx93Jl2QFbw2PyXCx0CxLc8f7QGZjXpecTgk16RjsCOA0VUhfH2/JxZHzcQKayngvlakqJgZZoIi9R7VzUcqf9hd0IwFf2FHE59zb9PIww8PietgbeKOi8BNcPTFO/0sO2pzld4qg3OZ6xt/2AGDKtBvmwgtmhv4EKuVDTt5nvY8Gp0qm+CXu5EZVBR/Pfc19f8G6G14bkR1wgkH9VXa33Fdy4R5WuKfBCOT1rcRteFnBZaHjQzmPko+cegHgnmkCaq4SdzDvcFw/XcgIL0FN1PNk3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1K6tH58dLkcF1EnkTl1/GQKb4bMoxMht4Ja0SWcTik=;
 b=FsfCfM0m+FLVrNB1io5qUk0qZPXKRuZDio3BIqPqRqxEibLOCPj9DXWQi3/Ew389kUTpKzAUpC0wWTfSK5OxK72fA93evGFQqjf7BZcwm+GatOYgdr7Dh80xanXsisxIrciNMYC5adQyRq+mt7YMTmf8uKWCUBmGWGBmRthwevI=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR10MB1380.namprd10.prod.outlook.com (2603:10b6:404:45::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 16:44:05 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 16:44:05 +0000
Message-ID: <b141489b-780c-1753-2a83-ccb60c4554d0@oracle.com>
Date:   Wed, 8 Dec 2021 11:44:02 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Content-Language: en-CA
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
 <YbDR/JStiIco3HQS@kroah.com>
 <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
 <20211208083614.61f386ad@hermes.local>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20211208083614.61f386ad@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0071.namprd02.prod.outlook.com
 (2603:10b6:803:20::33) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.220.103] (138.3.201.39) by SN4PR0201CA0071.namprd02.prod.outlook.com (2603:10b6:803:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 16:44:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0812e4-4f18-4f91-8a43-08d9ba69f262
X-MS-TrafficTypeDiagnostic: BN6PR10MB1380:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB138099D2111B4F49B5990EEDE66F9@BN6PR10MB1380.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0uCieHj2KiTSpI9LBTdBtnL7xhTcJjQu/i4iaZuGoePmiPfMIwtjgS2j9RHSaQpY1u0gGbSbD05foTg7FgO7JK75xwcIuWPoCn9FwjVUMx0BHA9AlHW46TE6om1o5EP0N0sI6gVN4wsZ1KmxvwOuYOqL7LTBx/hg3r+sP86AUip08TlQcDKcNUs6pLik9dzyy6KM1EDriHrG/MkEQN00WCmMSGhmbznrk097WOsIm4LkI3B1lFlR4rlt+NMR5oS3nyV02KSmaq8z/hjwtMmdXu9t/eNTx41TEasr4CD1j+TOiGKx6gy7ANVSBi1Gmqw6I75fPDqQdO3asbpL3koMe8+qGK1BGpq+aQGzawWTiPOASxXau5wIxxMB5qS9I+CRl3/jPMtGpFWojk4WzMDE8ZjzlZ2zsFWE7K5wSEbWAdvZ+nVq5HhVcLddw+Kp5VF3WY/oRNWhv/Jsn4lFkVHsfpMcEnVpgseP7MGwyj8lfpw5lC0K23FmEtzR+c+DHOegAnpuAiGhMU2Z2LGp6RGgB0kLLagKPYboZosFWt2+rwiUcmFmqvcqQ99LBhJwiO3Xuj20gC/YvZn5E/uHYGnpbpCGpQOveDPs03YhDgIN8J/ORUmrQV18z174OIvbvC3iJb3KNZAgObDUxRwSH9v7+aURjvG6mtIpkCrQOI9YF8FAlFYAcJ91046peHsI1u8pThvcHwJ44fGOZQSQrgsDZtPNUB/6o+oLvBnst8sIDFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(4326008)(31686004)(38100700002)(66476007)(66556008)(66946007)(316002)(16576012)(6486002)(508600001)(6916009)(956004)(2616005)(186003)(8676002)(83380400001)(44832011)(26005)(36916002)(31696002)(53546011)(2906002)(36756003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3Q4MEwzTmI4eUZjYjRKdjNCRm4zb2U5WEJQQVpwbXg1bDNmblh6ZXdheE1R?=
 =?utf-8?B?eUl5MjM3Mi9vTHZaaFNib0xQNWR0aHpNeFFYaS9icmhkcFJJd2tLU1YzZkRP?=
 =?utf-8?B?SmlhajVXY3JsS3BXUHhZRmh6WDdYTUFlanhqT0U2SkEvaEoyM2lLZ1pTZzgw?=
 =?utf-8?B?N1h4cUthNTdIL1lSVTVRREl5RExtSmFlYkZQeDlLNU82Y2JqSWRZczBqZGpW?=
 =?utf-8?B?bG81YytkOU5qcldOWUZ6UGo1eHY3WlI1QkhoMjJua0JZL2Q4WisvWlVyYStM?=
 =?utf-8?B?ajl6SmJ4NHRFTHRYUWNrbS83elR5dmQ0VVdZUExsUG9YRm5mcXpneEYxOThZ?=
 =?utf-8?B?SENkcC9hUVpMOHBNSkJ6bE04VThDMHVCZkF4TGs3bkhpWVI2b1B2TzkxMHU3?=
 =?utf-8?B?NnR4bTUvQkVpcXo4cXk4ZkFjWE5BZnhVL25mSVgzV2FGWjVSeUxhcnp6MTRY?=
 =?utf-8?B?MFNXY0hBMzVCbWxqOUZiQ0k4RmdzTkRPSEZ1NUVDdVc0ZFhIOGFCQm5XeGFU?=
 =?utf-8?B?V2V2R2diTTJ3OWFwYVZSUllBaVB4NmR6aWV5U0hLNmtQZmlGTXU2SE5YcUIv?=
 =?utf-8?B?THYyTitvcG9RRUMxU3k2TEJDbVZSays3bUMyMmFFL2xqVDkweXlMNkoybkpF?=
 =?utf-8?B?eDU2QUlQeHJ3MEtHNXVEQVhVYlFpVno4WEJrMHpVYzZkaEQwOGpPVndNamRv?=
 =?utf-8?B?dWhES2JJNmwwelFDSFhzdnRjQ3NyOEU5aDlPRUFxL0tKMVJRR2F1OUVXcXNl?=
 =?utf-8?B?WFVSdlB3Zkc3QkU3WnppMXRGUTZPTDlzODg5MVg4NmNFTjliZFN4RkNHcXVB?=
 =?utf-8?B?MkhCYTJ0T0F0VkZudU41UUt5cXZkTnlDVW9qNGorclhEcGJBa1RZVERZTFM3?=
 =?utf-8?B?eGx4MVpaZEpQRjV1Nk9jaE0xVlp4Z0hKZmY1VjQ2Y1JhRXh4RGc0akRMZ0k4?=
 =?utf-8?B?SjdFWHFqMk9oVkVCSmlPL3hwU0prdTJGaDhDbzBSckVZbERhc0VWWFR1bnV0?=
 =?utf-8?B?YTNWUWdBNTRwSTRXTitiQ2EzZy80dXN5c1Bsa0VZSnAxejFaTHlpazJWV0hL?=
 =?utf-8?B?RFpkUGZKQW9keWxIYjFBRHYzUXpyb1lNK2RhRnNtWjBVbXV0SldBeVpNR0lI?=
 =?utf-8?B?czJQQloxYUF5aGxKWkFESkxSM2EweWNYU0tYdHJYbXBNU2U2Z3MrL1laWmU0?=
 =?utf-8?B?b3JQMmpudXRISTFaWGlyZHVwRmR1WFhKcnVkNGV6L2EzSmxEZFVYeVUyNURa?=
 =?utf-8?B?V3NqRkk3YWZGS2pzQWdzZ0NlOWxoSlhkaThweVFhd2s0ZUVWRFlNU3hUNnBD?=
 =?utf-8?B?SDdUTjZhWGg4aVlyR0l1S3NjK281NklKNUZycHhWM2lWamZuZHg4ZWVGbmNS?=
 =?utf-8?B?SWh6NlBiVEFUMG9xYXVoZjB6OXB3V04xM0VYeFp0YVhrN3FFVFB6YlY2M0Vj?=
 =?utf-8?B?NEZ6OHk0cGk5a1hQNFhSWjh6YzNNVmF2andoUmx6cHlxQm9TSjYrd3JkTUMy?=
 =?utf-8?B?TitKV2N3cE1HV3hpc2V6Vmw2TXJiOG00UmpBZ2J3OG1MbHpGK2h2bXpNcU9v?=
 =?utf-8?B?L3pRakRSZmswc25DdXFONG5QSUhtc00xOXlKRW1uUkExS0x2Vkl5bG14VTFR?=
 =?utf-8?B?OWI4dmFHcW1YelNPL08zNTBWZEwzOGl3eWZVZGxRSzBFSDhkSElHV3F6cWpB?=
 =?utf-8?B?Rk93Ni9WYzRNakxJcDBUNy95K0NkWWcwUmZiNzRWdEZyY0lvaFE3RE1kSkYz?=
 =?utf-8?B?S1RVc3NDQkU5L1R6L05LMzZBbllrSHU4d0NUUWdaS3lkUzhRR2tiK0pwdzY3?=
 =?utf-8?B?ci9pMmNLblJIa2ZqWlZGQzBibjJ4YXF1YmpDbkp5K0x0cXpWeFNONEZwMWpC?=
 =?utf-8?B?MFZFeHdrL0ZyUnhIU1dSN2NlRm11b3VieW9TRmR1NjhLc3hoZ3JYZjlWR0lR?=
 =?utf-8?B?SFFTaXZXaG9Ta0xoL2g0Skl2bVNmOGx4a3daUHJ6YTJNc082MUdCOEM0QTly?=
 =?utf-8?B?ZjFnQ1VCMmFLNjNsU1NzM3JiSTUxajhkRmFzMmEwU0JvWWQyYlUvZ3BzMEZE?=
 =?utf-8?B?dCtjcVdpeWVEM0Q2SHJwdTJOelh4dUo2ZDlpTExrVVltTHRTK2poS1JXQXpY?=
 =?utf-8?B?Z3hZY2J6Q2ZGQnNLK3BId2Z0bVNnTDVpcVdicnZxdTd0L3lhaGJHYmZWQlVB?=
 =?utf-8?B?QzdRL3ZXVzIzZjFuTW1KUHlsbUcyelo4N3B6Zi9xQjQrR250ZDAxcnliNmtx?=
 =?utf-8?B?TUhOU0ZYL1U2WWdMY0RRcGw0aU9RPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0812e4-4f18-4f91-8a43-08d9ba69f262
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 16:44:05.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7wJGKQwwucMoZkeoMJLQBrng8jWstVxxuc9+7q1aqbwarpBAlh2uCvicKgOuc+eGV8Y8u0nwVrs+o6roKD1n5n12OA4yHHAQeWg/oIP/D4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10192 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080097
X-Proofpoint-GUID: 2QEz6vChMayYmrwWVVT_Q42VoLetLO4d
X-Proofpoint-ORIG-GUID: 2QEz6vChMayYmrwWVVT_Q42VoLetLO4d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2021 11:36 AM, Stephen Hemminger wrote:
> On Wed, 8 Dec 2021 11:29:47 -0500
> George Kennedy <george.kennedy@oracle.com> wrote:
>
>> On 12/8/2021 10:40 AM, Greg KH wrote:
>>> On Wed, Dec 08, 2021 at 09:43:25AM -0500, George Kennedy wrote:
>>>> Avoid double free in tun_free_netdev() by clearing tun->security
>>>> after free and using it to indicate that free has already been done.
>>>>
>>>> BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>>>
>>>> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
>>>> Hardware name: Red Hat KVM, BIOS
>>>> Call Trace:
>>>>    <TASK>
>>>>    __dump_stack lib/dump_stack.c:88 [inline]
>>>>    dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>>>>    print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
>>>>    kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>>>>    ____kasan_slab_free mm/kasan/common.c:346 [inline]
>>>>    __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>>>>    kasan_slab_free include/linux/kasan.h:235 [inline]
>>>>    slab_free_hook mm/slub.c:1723 [inline]
>>>>    slab_free_freelist_hook mm/slub.c:1749 [inline]
>>>>    slab_free mm/slub.c:3513 [inline]
>>>>    kfree+0xac/0x2d0 mm/slub.c:4561
>>>>    selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>>>    security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>>>>    tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>>>>    netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>>>>    rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>>>>    __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>>>>    tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>>>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>>>    __do_sys_ioctl fs/ioctl.c:874 [inline]
>>>>    __se_sys_ioctl fs/ioctl.c:860 [inline]
>>>>    __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>>>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>    do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>
>>>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>>>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>>>> ---
>>>>    drivers/net/tun.c | 11 +++++++++--
>>>>    1 file changed, 9 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index 1572878..617c71f 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *dev)
>>>>    	dev->tstats = NULL;
>>>>    
>>>>    	tun_flow_uninit(tun);
>>>> -	security_tun_dev_free_security(tun->security);
>>>> +	if (tun->security) {
>>>> +		security_tun_dev_free_security(tun->security);
>>>> +		tun->security = NULL;
>>>> +	}
>>>>    	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
>>>>    	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
>>>>    }
>>>> @@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>>>    
>>>>    err_free_flow:
>>>>    	tun_flow_uninit(tun);
>>>> -	security_tun_dev_free_security(tun->security);
>>>> +	if (tun->security) {
>>>> +		security_tun_dev_free_security(tun->security);
>>>> +		/* Let tun_free_netdev() know the free has already been done. */
>>>> +		tun->security = NULL;
>>> What protects this from racing with tun_free_netdev()?
>> tun_free_netdev() is called after err_free_flow has already done the
>> free. rtnl_lock() and rtnl_unlock() prevent the race.
>>
>> Here is the full KASAN report:
>>
>> Syzkaller hit 'KASAN: invalid-free in selinux_tun_dev_free_security' bug.
>>
>> ==================================================================
>> BUG: KASAN: double-free or invalid-free in
>> selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>
>> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
>> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29
>> 04/01/2014
>> Call Trace:
>>    <TASK>
>>    __dump_stack lib/dump_stack.c:88 [inline]
>>    dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>>    print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
>>    kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>>    ____kasan_slab_free mm/kasan/common.c:346 [inline]
>>    __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>>    kasan_slab_free include/linux/kasan.h:235 [inline]
>>    slab_free_hook mm/slub.c:1723 [inline]
>>    slab_free_freelist_hook mm/slub.c:1749 [inline]
>>    slab_free mm/slub.c:3513 [inline]
>>    kfree+0xac/0x2d0 mm/slub.c:4561
>>    selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>    security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>>    tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>>    netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>>    rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>>    __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>>    tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>    __do_sys_ioctl fs/ioctl.c:874 [inline]
>>    __se_sys_ioctl fs/ioctl.c:860 [inline]
>>    __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>    do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x7fd496f4c289
>> Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89
>> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
>> f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
>> RSP: 002b:00007fd497632e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 0000000000603190 RCX: 00007fd496f4c289
>> RDX: 0000000020000240 RSI: 00000000400454ca RDI: 0000000000000003
>> RBP: 0000000000603198 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060319c
>> R13: 0000000000021000 R14: 0000000000000000 R15: 00007fd497633700
>>    </TASK>
>>
>> Allocated by task 25750:
>>    kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>>    kasan_set_track mm/kasan/common.c:46 [inline]
>>    set_alloc_info mm/kasan/common.c:434 [inline]
>>    ____kasan_kmalloc mm/kasan/common.c:513 [inline]
>>    __kasan_kmalloc+0x8d/0xb0 mm/kasan/common.c:522
>>    kasan_kmalloc include/linux/kasan.h:269 [inline]
>>    kmem_cache_alloc_trace+0x18a/0x2d0 mm/slub.c:3261
>>    kmalloc include/linux/slab.h:590 [inline]
>>    kzalloc include/linux/slab.h:724 [inline]
>>    selinux_tun_dev_alloc_security+0x50/0x180 security/selinux/hooks.c:5594
>>    security_tun_dev_alloc_security+0x51/0xb0 security/security.c:2336
>>    tun_set_iff.constprop.66+0x107f/0x1d10 drivers/net/tun.c:2727
>>    __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>>    tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>    __do_sys_ioctl fs/ioctl.c:874 [inline]
>>    __se_sys_ioctl fs/ioctl.c:860 [inline]
>>    __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>    do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Freed by task 25750:
>>    kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
>>    kasan_set_track+0x25/0x30 mm/kasan/common.c:46
>>    kasan_set_free_info+0x24/0x40 mm/kasan/generic.c:370
>>    ____kasan_slab_free mm/kasan/common.c:366 [inline]
>>    ____kasan_slab_free mm/kasan/common.c:328 [inline]
>>    __kasan_slab_free+0xe8/0x120 mm/kasan/common.c:374
>>    kasan_slab_free include/linux/kasan.h:235 [inline]
>>    slab_free_hook mm/slub.c:1723 [inline]
>>    slab_free_freelist_hook mm/slub.c:1749 [inline]
>>    slab_free mm/slub.c:3513 [inline]
>>    kfree+0xac/0x2d0 mm/slub.c:4561
>>    selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>    security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>>    tun_set_iff.constprop.66+0x9f9/0x1d10 drivers/net/tun.c:2782
>>    __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
>>    tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>    __do_sys_ioctl fs/ioctl.c:874 [inline]
>>    __se_sys_ioctl fs/ioctl.c:860 [inline]
>>    __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>    do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The buggy address belongs to the object at ffff888066b87370
>>    which belongs to the cache kmalloc-8 of size 8
>> The buggy address is located 0 bytes inside of
>>    8-byte region [ffff888066b87370, ffff888066b87378)
>> The buggy address belongs to the page:
>> page:0000000003b0639d refcount:1 mapcount:0 mapping:0000000000000000
>> index:0x0 pfn:0x66b87
>> flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
>> raw: 000fffffc0000200 dead000000000100 dead000000000122 ffff888100042280
>> raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>    ffff888066b87200: fc fb fc fc fc fc 00 fc fc fc fc fa fc fc fc fc
>>    ffff888066b87280: fa fc fc fc fc fa fc fc fc fc fb fc fc fc fc fa
>>   >ffff888066b87300: fc fc fc fc 00 fc fc fc fc fb fc fc fc fc fa fc
>>                                                                ^
>>    ffff888066b87380: fc fc fc fa fc fc fc fc 00 fc fc fc fc fa fc fc
>>    ffff888066b87400: fc fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc
>> ==================================================================
>>
>>> And why can't security_tun_dev_free_security() handle a NULL value?
>> security_tun_dev_free_security() could be modified to handle the NULL value.
> It looks like a lot of the problem is duplicate unwind.
> Why does err_free_flow, err_free_stat etc unwinds need to exist if
> the free_netdev is going to do same thing.
Maybe instead do not call security_tun_dev_free_security(tun->security) 
in err_free_flow if it's going to be done anyway in tun_free_netdev().

George

