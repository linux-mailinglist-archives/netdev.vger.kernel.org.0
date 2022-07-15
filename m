Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562B3576AF1
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiGOX4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiGOX4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:56:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA4097A28;
        Fri, 15 Jul 2022 16:56:18 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnKIH011904;
        Fri, 15 Jul 2022 16:55:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zao8aTZgqvrUe+ImKMEBtGS2B7kydB+wCjILluFRoCo=;
 b=bwiAzEnJl82k8rNHHa0TKedVjNCqs+uJp4rALa9KcSS0XbLBq5Ryvmf11T1pP5PwNrwu
 u+UMBzCWcBlNh/NUdbBru/Nv46DFASX8Az/mJHeJ2WZpYZdSBu1scpCtUVJZjQKyta6a
 ErcVewBlQVbVQgoXF5HbzK61NiDm5Hf15zc= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hae0wchpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 16:55:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feKasl3z7fkjhBVjblAUhshJyOhFnlmg3MtR5JetTZDHoJgfjwQXR4Eufm54LZqluhZLUKtzq7Jn4b5m1R39iNqa2zlzDa0ZyTUUBh4ADUYIRQpXYM1Np2Pgo1aCXw9bpvo4K5DCkG+RS7sB12ZcEq61tRcRK+eA51uXhYWFf1cjiF6lqRUA36ejCxfBEAhPezyt6EoR10tBXJgKS0FWJG2DPo8XJCl8QHws/i3dtfTq4umGb7HpdT4/iT5coeZ/lK7OAsxY5uwhiicgPTgobBpntrweW/BNQWsApLJ+DjSzltO5n4DEn5QWsKMybJ7kcq58Jsqf4ClJX2Kc4bgo6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zao8aTZgqvrUe+ImKMEBtGS2B7kydB+wCjILluFRoCo=;
 b=ln+wGYczaCRyueLAyPLCeQyLNtmzftK3bI2P8kl9T01/ApAzySl8+pGQhhzuoi+MkPyZXy3+rXArdQv4sxlR2E8eCj4R7SPZ4UMNC7isPKD38LlLBDylZ83x7HcVlWvz1H+4oPJDnfgGEa8bf0PcANaMnYAOB4RwZ2dBPEcdMbSqLbja/0g0JYQjqxNVEjM6jag8IiWtlukDTunxLoNl3an3HQbNufNoQqI8YMn20BYHibvQmxPBJqqTpfG/y+3jccARcqyMa6BbwnIS7uE1/nyDl6xiVoTC3/O7prze7kn9v/LeEtOHqmlBOlRPuyllnNRnMmpthCX3Wr2WRu708w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 23:55:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 23:55:43 +0000
Message-ID: <e8415c81-070d-304e-4068-885f3ec3cbb8@fb.com>
Date:   Fri, 15 Jul 2022 16:55:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 01/23] selftests/bpf: fix config for CLS_BPF
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-2-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-2-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0130.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c48b15b9-cbbd-43b7-2aeb-08da66bd878a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Kf8h6hyX6VeF39JxiP8pw4Mz2u+mGAdUj8KDU/q6qTbIDNEfdDH+GZ/rShCEB4W0TmpiuLeW60C+foFJHCY0CHBynBcSmqErjypQH4d8EBVe0RgVTI3Bzw/i94WnIU55BEcWGD/lyMsOZ7IBiM+lftFuJzGj8oG3p2VIhdsSh/ppSIpGHLmAgp1SRhkho+gPm4VwepeHU2TS9XXsRSNQvHEBqzdRdSnPhh51ugDB+E8mntN1lFbHSkZyhsrKtELl2TmRAiH5BneRmVgYv2Y7gN43Lh5hWUBJ4G8TV9x2n+sPaRf8JBXnhsrKId3qYJQ2JiFmKXphjVKZl4tubK3wYfNgP7Mtg7GXSm28W/YmSBznWEhLvh8YhGeV5o6al3kX5PDdLHNSKzqKuJjkJGKEHiSUI/upbiYTSUUf9EBzRsBQ79iWriTItvLAOQDdOyO+vtQCjanc9WOpHj/cIMjv6D2hmlpxPvC9xmayyF9JjKJokZe7kvGKRxRuRaO0BHmid70FFiWRJUHKIBdL3vubuyawH28ZEWr5hrhF7hgvvn0MgEt69YGvt8FOJqlbQ73PwBQT+QlJEqemT7UHMiTZ+bIt1TL/go5KcgTW5kNDxrDIDxHVsbTEn2UC2wEeAwWp91VUmZryHTuQlTKxpl6SHWLg5xVEwmt/ID7+26ei3GX/t3iQPcgmbnrICH2KcL8jmLjFg0Bt1pBoohGX1/49L8brvxzUvtNMrUD60JSWhAyFNRSS5fvoAps3FLCHkS6KO0ZoUFH2KXd+o3h5gFopXS/8Bow0ELuoJe77SiJzSH73OoaK9ISRZakeWHK14gm8THIUwBUomgc/HnlZkKqazxC5U79MmXYZcelYTSIP26SqU6CalF3Nnhbv1xBvyEw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(2906002)(316002)(8936002)(921005)(8676002)(66946007)(7416002)(66556008)(110136005)(4326008)(4744005)(66476007)(36756003)(41300700001)(86362001)(186003)(31696002)(53546011)(6512007)(6486002)(31686004)(6506007)(38100700002)(2616005)(478600001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmdHRjVsZGkrZzRCNlR2YU1aSjNWYlVWc2ZYOUhTRmZkL1BqL3RSUStHRXkz?=
 =?utf-8?B?MnNlWVVrRzdlOU1pY0lPV01SWlBlVkRhd05OdjFyQWtKdzZUUkxRaVdJbmt3?=
 =?utf-8?B?YTFnT2RuNG9BU1dWbnVBRFdRZDdCcEZwVFdvYWorOUgxS3A5ZERHQ0FoTUNB?=
 =?utf-8?B?OUVBMGtXajZMeGp0T21VL1hPL1lOTTNJS1lBeXlPYnVqNEdPdlAvZUhRajEz?=
 =?utf-8?B?dE5NWEFYMnNkSlVFNWl3T0Zwb240S2tkZ3dEWUVXV3NqYlI1VGhrc0hrVHVX?=
 =?utf-8?B?Q1ppWkFVUVR2UjBGUlFvNUdJN1F5N3JBQUV3a2dWL1Q0cjRQR1JTOGJpYVds?=
 =?utf-8?B?YUxkTE5WMWV0Ulh3NW5Pc29IM1poeE9qSXF3ajZXblVGemRma2YrM25UbW84?=
 =?utf-8?B?NnQzSnFtOTVPdDNZTjBkYWxjQ3ZNRnY3clJsd3ZkeW1VVEVhQ3NTQ2xyZm5F?=
 =?utf-8?B?ZnBmOTUvbndkUFhZOFMzTFpaUUQxVklNMnZoWHBJeFo0VHdiSTRmazhIK09z?=
 =?utf-8?B?cmxWWUFHajRYWjhUdDVJQkdrcXd2VXNjNU5zYnFpdWIzUVdiUXQ0S21UTDE1?=
 =?utf-8?B?OVJSYkRxNjcxWnNyZ05JbUtVMWNrWWkybEFjRllVSkdUdWIwSENmSitNYnlk?=
 =?utf-8?B?dmJuYXJDQWZNZmk3MkNDdlozRTI5UDZXQ3h0dTMxd1RPbWJDQmFsMEFJWUc3?=
 =?utf-8?B?VWNYWWxjeVpsaWVYZ2lrYWJMZHB2RG1wR25jNDJzb0FwQWE3UXYyUWJ3SmZN?=
 =?utf-8?B?YzMyN0lWZE5qek5EeUk5cGN5L2FqMVAyVE54bVQxSkRPSEtaWlZXalBQazNL?=
 =?utf-8?B?c3lYZnVDNiszeEVUOWdLK3RSQXFoVmZmbGJCTTYrR0t1RVI5V25NUk9hU0I4?=
 =?utf-8?B?WnA2STJ3MUFJSTR3ZWMyNVBOUHBYU2dNd2V1ZUxFOXpZdEJpTS9NMTliU3dy?=
 =?utf-8?B?R2FJRHVNQ0dpZlI4RklZMTVCNFA0S2c1aE9JRnMvbUduR2NHSmREM1FNMkVu?=
 =?utf-8?B?TFQ2dUpNKzVoQmozeFptbDQvU0IvS3ZYWkYxMHdnOXNhYy94Z1h0dy8yamhy?=
 =?utf-8?B?SEkyUm8rR3diQ1p2Qkxrd09BRVp5SkpJVFkyM3JVNFF1TXd3ZERvZFpIb1Nv?=
 =?utf-8?B?K2pEdExvM2lHUytYWDRkcWEvNHpGckFVRWMraUtmU0FPcDhNaWVzTzhBRkI4?=
 =?utf-8?B?aDQwelRLSFBtakZtU1Y1MCsxMUtDdjJjZzFKcXJ1T2ZaTk5LWi9GeGxUbjBM?=
 =?utf-8?B?MURZUUFlUUZ3bTJtdjcxOUIyNk9HVDNYUEtCVytyMEw4TEhOOTNSVVdSc0Z5?=
 =?utf-8?B?MEoxL3VQQWowRFRJemN3by9QOEY0eEQxazF4YTN3Q0YyRFpPRVJ6ZElFTThs?=
 =?utf-8?B?TWJURTc0ejR6bjNvVFRwMWUwMEtad1VOd0RqRWU2aWQ5ZzZsbW1SN3NKbjEz?=
 =?utf-8?B?Ny9iajdnb0pTS0lRbHgyYTZlWGVWMC9xT3d2T0JJTkxyVzlOOW5pWGtEVXFa?=
 =?utf-8?B?WmtBSHVIY1ZEeWtIdzFzdmU3UVZYSkhVL2phNWx6M0RjWXRNS3hlejZqU04r?=
 =?utf-8?B?bG9Sa00wU2ZyVkFDWWVmbmd4SG9QRGI3Szh2WVdRQ0syWXN3MFV6cEpPUDlS?=
 =?utf-8?B?ZzRxdjZPUGhYVk9NWm1SVTQxMmdjZlZPMnZXRHIwbzROeC9HRno3aU81bXls?=
 =?utf-8?B?ckp1RkhmZGx3dVJmTFozYkJtWlkvbUEwRmtZMG0yWFErWTdJSWthMGFJelhn?=
 =?utf-8?B?emhQcHJ2aHBUd0lHZnNrNCs5ekowME8vVHlhVGk3QTIvQmZvOG5aNm1TbXVM?=
 =?utf-8?B?T0NaNTdIS25pTDVJV2FZWHVSL1QvdEZ3azJWVU4yYTVaQVFaUE4rdlVoQlBk?=
 =?utf-8?B?emphQ2c0eUt3T3pFNFNQWEpLQzFTazMybW8rTVJ4SzEvMEIwbnZqK2RxNFEr?=
 =?utf-8?B?bWx3VXRVbzMrUi9xTXlicXZPQkVxOWN2TEVwclBybTRVTzV2OG90bWt0Vkl1?=
 =?utf-8?B?cHBRMk02NDkzZ0ZkUzB4RUpxcEVFd1c4cWEvbi80Q3VmUXh1SHlJN2ZmRjBO?=
 =?utf-8?B?dUNnRE5va0VyMFJlRHpvMWpFd3N5TU43TDIrd3VhelNGQTlkblZqbGhRM2tR?=
 =?utf-8?B?SE03T3k2eWFlM2tneUp2dDRPSWlSS1g5UkJ5RUZlNis1QzBpcmwvL0dIWmdw?=
 =?utf-8?B?V3c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48b15b9-cbbd-43b7-2aeb-08da66bd878a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 23:55:43.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jzn4hlBYHrNA3eWjVDKiFXVtJj5h5Cc8cUc1PgHY6tTa9AFZfKD4IedA1KiYNwk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-Proofpoint-GUID: 6ZZGH_6ZGNW4cDRpbsaYUX3ZwO50IFK8
X-Proofpoint-ORIG-GUID: 6ZZGH_6ZGNW4cDRpbsaYUX3ZwO50IFK8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_15,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> When running test_progs under the VM (with vmtest.sh), some tests are
> failing because the classifier bpf is not available.
> 
> Given that the script doesn't load that particular module, make it
> part of vmlinux.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
