Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A799399EEF
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFCKbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:31:42 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:31222 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229746AbhFCKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:31:41 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 153AM85b023774;
        Thu, 3 Jun 2021 03:29:32 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 38xd5c0nhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Jun 2021 03:29:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdwz756m1X1vmLsDgyHQGHVJ4l1FKzviJ2hu4xgdzWybBLqh2M9tdkYRPAn21bmuV/S/heaRFBpufqHPFlXek1TEfsVjik2q5PID2qD3j2MuCBVcq9GrYx3xa9iW3MofyNRaDdQP36qiCYZ4M0AWQM+ZwzQApHw3N9ddiu3CoGgHSn0n2OTQak8NF6nOjiiZRIT5YyA8BDCVs5Tk1BcqKlkp7cfgQn6DcPnnj6DYYGGBBPVtKR3DjXV7/1nr1xJZvfYcgqW+YmTRjcMSNCnvSbftwoKIppRP/2UFe87+NZ74+JqaGftZOg5rtezVeaAi+n9Wdc41pgFwX9TK8SBlPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L1t8jttGVAKsd3M81MHsSXrtXeZCcyUEfkz7eYUgEE=;
 b=mk4+N8zwpOswEI3DEFTF8i45tbIeszX0hXlxGYmZKcajk6O68bkUekxn1pMlZRpay6SDdbbIbjPgaWXq/qKuww7cuiNmd9eci6t7J1vLm+/9wUn/OvtEpcIqlPd0eaPPOda3QoEHXo7+Qi8eM3gc9quKEPy+BxlCYH/50/8ahNTgcjqqXL34DSo/NNyDuHnk5IGYmZ0qsYiArTLM9gKuEl8sKnvs8KwwBQtYTtLnrA3iX34g5nihitjhxk1qb6E4gGKcTWjPdYfeZTrRUqWT73vEEHO/70dv+ez9F4ozbklGLiXUMuBjZil5GKEGIQy5siBcNZXdrd/v9OYe65noFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L1t8jttGVAKsd3M81MHsSXrtXeZCcyUEfkz7eYUgEE=;
 b=Vp56ppawJb/+GfZ8V8pm7+Dk2nol9dPYtTze8Gq/BbjT+lEgH2NawHm0yTLyo+BPEnMrH1/2N99gZTjknJokS+/oOkjrETUZIL1LRm4NioRooFekzMNXgE7oIXF36fB9ThWdT1b04mDYubdrMLDBKYGXFMKTaXEfhgBekRJR3Cc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 10:29:28 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 10:29:28 +0000
Subject: Re: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
To:     Will Deacon <will@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
 <20210601150625.37419-2-yanfei.xu@windriver.com>
 <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
 <20210601174114.GA29130@willie-the-truck>
 <7637dcdf-12b4-2861-3c76-f8a8e240a05e@windriver.com>
 <20210602172603.GB31957@willie-the-truck>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <895953fd-d462-2696-0ab3-72a069ba5a75@windriver.com>
Date:   Thu, 3 Jun 2021 18:29:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210602172603.GB31957@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0080.apcprd04.prod.outlook.com
 (2603:1096:202:15::24) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK2PR04CA0080.apcprd04.prod.outlook.com (2603:1096:202:15::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 10:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d36c869-b071-46f3-8fc2-08d9267a7782
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4814:
X-Microsoft-Antispam-PRVS: <SJ0PR11MB4814C47224EF5330395E1734E43C9@SJ0PR11MB4814.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnB6I2Vj6xevAIpkptkDBGmOf8boI7IzbrjQJ5Be4oyj3n2D3pFggVy8c6PNhiUs/Lq6fHg92llxtyAYAoLyvajgyZIgvjAGBQ+gmhB1/ADW/8jViSjcNvt6PEDUKYsoZpeJVXxv2nFnxanpZjzng9QdvOqAOwbYJp0hPx59spfhUG9L/kogwCx09zzbw46lJlahMHh02VnmJiPS0VooAckjn44YJha8J9SnAEMv3XJziZ9jkR4Y5xou2O9DtREB2xFuMuqx2TWAtRU1bbjL71gxNmJf0Ku4A+D9qEl0ksViNeUNrhXIMWyZfLuulfNF+CTs/K/FA9o+fp+5YEpBQQZHi73CDRzmJUy36FybIy2HDMnut0H+P8mZYN+0q9Swrwhu0DveAvsnV/yEkLyJQlAB12/CgXspxMyqg3vIoKAbg5M07olvzY0c30+bxMG8mFnMMlYh1Chkz2NU+ac7Iw/gVudh7b2qm/FPdB2l0aoA2oRmQrMdAWgZ1XA9oi6PyywbljZrb9iM3DCHbPUUD4Lp0c2PGjzNk0Soj0uJJlbA/qMWlVLUcNW3MqLDrbYVSGvxaW8h+ALHoqnIGNAOFTCbxg9C6EgY6sJNfmKWLy7uFE44BcqCUTglvDIX1bRoJhyyB/6deu5Jo9N4SIdnW7+F/tBqPzhWYoiOLQ4eHpO+axsBwr9CuSkgjGv38b7/jVUn/+H2xRc1Ysrbjz/8zZIMSHNoCPRdX72YMKGmMpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39830400003)(2906002)(7416002)(52116002)(26005)(16576012)(6916009)(6706004)(316002)(16526019)(31686004)(186003)(36756003)(8676002)(4326008)(5660300002)(2616005)(956004)(6486002)(31696002)(6666004)(53546011)(478600001)(8936002)(38350700002)(38100700002)(86362001)(66556008)(66946007)(66476007)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZmtPaWFHUkVJb21ISC9iTmEreDFPeHZ0akZTRGs1ZWdkVkdsbUR5aTNObUh0?=
 =?utf-8?B?cHBvNGpGR2ZlNHZRVjdkYTk4NUVMRkdyaStvL1lEVkdNQktVZ01Xb0w5UHpO?=
 =?utf-8?B?Z1lFQjRxZG1uSGNCcU1HRk5IYW5Rems1UktDcjRlVUYrblRsZytER3JhUzBC?=
 =?utf-8?B?TE9SZTBUNFpUdVNZVEtUdUVIK2FtZ0NpUm1xRk1pckNVaENDQXNUMjJQQytU?=
 =?utf-8?B?UnJTcE1MWnB2cnMzOUJGYmsyeS84N0NHYkY1WlUwMjl3UklMVjBEZXd2SUUr?=
 =?utf-8?B?TngrbDNSSnFaaGhDaktWSlZJbEREZ2dFMWlxQTBaeittNmwvcDBReEdCV0J3?=
 =?utf-8?B?dmdabXcxUDB4RnQ4Rjd1Nm1ySllrcXFQZFNndlppSFdRS3Y3UCtxOURtMk05?=
 =?utf-8?B?MXJISGx2ZE9naUpoS0Rua1U1WnhVUlo5UUExTXh3TkxWMXRXendWN3F1MGxV?=
 =?utf-8?B?WDFWbEtWdGZ5NGZOSHFiYk5HbVZUdXdoTi9OWElVQ25NVW0yRDdsV0pRNGQz?=
 =?utf-8?B?T0FlZlIwbWtoT0NseWlxYUxoYkwwZ0hIZy8rcnZXVlNVQ3VvR0VZZWR2czNv?=
 =?utf-8?B?L215MDBLYXFWTzhsNzg4TUJwSFQ1bGpKK0QzVTVNYTlSRkZxRHdnQzNDbmpY?=
 =?utf-8?B?WEZINzVhMGVPT3BKOG16QWxPZTlqMGJmOEQ2K01qVE14MlJpelZEWDk3WUhO?=
 =?utf-8?B?TmJWeVZIcklQbnFUVFpseDYxWGdiS3FlSXlDZ0h1OEVHZ3VmNVBFQm9mV0k3?=
 =?utf-8?B?bjBLYm10czY1aldpSG1ZS3Y0eHY1RkcycU9tb0tPQzFtK1grRFNzaTgwNTVU?=
 =?utf-8?B?UzBtOXF3TnYvYlRHaVdjV2dodW5ZQ3hmYXQ0OWl1eTF4NytJNXBpdkhaTFY0?=
 =?utf-8?B?MzdoWmZJQ3QxZzV2ekN6S2tkOFF0QUZUblhneGFoUndyZFhBZysxK2VucUZV?=
 =?utf-8?B?SjE4YW1pK1NCbGU3WFNBL0FiV2JqQWdpY1RPVlVnY1lsVmwxNE9kSGZud0RJ?=
 =?utf-8?B?YmZZRWNabzU1NEtjZ3NkZUFIdmdwOWlrdVdhNU5DNkswL1ZQY3FsdFQyWDNl?=
 =?utf-8?B?NGsrQk5iVG05ZlVEL0x1Tkx2UTNLd1dHSWE1ZHFFNlJuNDh3aUtrWDBjWURy?=
 =?utf-8?B?QUZMZXNUVTlkYnlYb0lyZXh0b0ZlS0ZnWHhrYWZvWFYvOTNyQWJQbnZmRnNn?=
 =?utf-8?B?cVhUQVNHZkp2cFRwd0lYWmVaNzVFSVdZR3hSYTlnS0tUd0tOTnZVVHl5TVBh?=
 =?utf-8?B?NlhvL3dDKzdvaGJhS2I4ZkJrbTJWVU9uZnlGaE4yamR6aktUZ3hxdlFGeVpD?=
 =?utf-8?B?QTJaTFFNeWZUVmUxdU83RkxVS3dwaytvdlJLYUxIYzZlRlIzNXcwMGxHUkVq?=
 =?utf-8?B?cnNGOVZQSWxNcGJ2T2hiV3Fyd3M0bUZuOTZuZXA3RTFPaGZ5S1JBQ0xQSEFW?=
 =?utf-8?B?Vk1TQjQwcTVvL0dvb3NwSnFLeTJpMjNSMHBSTURucWFjVU5IaCtRaGcvSEpF?=
 =?utf-8?B?STJZd2FWUzltby9iTWpJTWN0RitUYXB6MWZTdWVHSXhwM0ljOGlHa3Rsemgw?=
 =?utf-8?B?M1BPbXlKd1h4dFVEZFJRVVRxNERHR0dXRzFYR3lBWjl1NmNzdmh3eStRQ3Zv?=
 =?utf-8?B?TjVvNlpDN2dQUTBzTkw2QTIzN0YxSmtNcjYrN2V1ODRYSzZoNVJMNlpHdE8y?=
 =?utf-8?B?SXJYelZ0SjF4TVFpN1UycDZIWFM4YVNSSnUzdkdDM1lJc1MyRHF3dC9IWk1L?=
 =?utf-8?Q?Svi5ngUO6I2ghVZifkX9DssVFbV9HHq0FMgYBLn?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d36c869-b071-46f3-8fc2-08d9267a7782
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 10:29:28.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k/deRI4XiinQEmFayn0y8/g/auDA6uV0lrQ/lKyfOlO/io0jce5ep9/Fbr+MvZZ1zSMzZgxU7RBC7mXhYGbdNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4814
X-Proofpoint-ORIG-GUID: sPb9lkFH4kCSSiOPEgr7DDgoJY8OX4Hj
X-Proofpoint-GUID: sPb9lkFH4kCSSiOPEgr7DDgoJY8OX4Hj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-03_06:2021-06-02,2021-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 1:26 AM, Will Deacon wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Wed, Jun 02, 2021 at 07:26:03PM +0800, Xu, Yanfei wrote:
>>
>>
>> On 6/2/21 1:41 AM, Will Deacon wrote:
>>> [Please note: This e-mail is from an EXTERNAL e-mail address]
>>>
>>> On Tue, Jun 01, 2021 at 07:20:04PM +0200, Daniel Borkmann wrote:
>>>> On 6/1/21 5:06 PM, Yanfei Xu wrote:
>>>>> It's no need to trigger IPI for keeping pipeline fresh in bpf case.
>>>>
>>>> This needs a more concrete explanation/analysis on "why it is safe" to do so
>>>> rather than just saying that it is not needed.
>>>
>>> Agreed. You need to show how the executing thread ends up going through a
>>> context synchronizing operation before jumping to the generated code if
>>> the IPI here is removed.
>>
>> This patch came out with I looked through ftrace codes. Ftrace modify
>> the text code and don't send IPI in aarch64_insn_patch_text_nosync(). I
>> mistakenly thought the bpf is same with ftrace.
>>
>> But now I'm still not sure why the ftrace don't need the IPI to go
>> through context synchronizing, maybe the worst situation is omit a
>> tracing event?
> 
> I think ftrace handles this itself via ftrace_sync_ipi, no?

Ah, Yes! I missed this...

Anyway, thanks for your reminding and very sorry for my noise.

Regards,
Yanfei

> 
> Will
> 
