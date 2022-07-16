Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4688576B01
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiGPAEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGPAEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:04:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C5214D2C;
        Fri, 15 Jul 2022 17:03:59 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnLCd026456;
        Fri, 15 Jul 2022 17:03:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YjEwYTQODu+htH+ET6TKFtzX0f8MG5w39Q/sUQ2uJXk=;
 b=jaW32/hRBtU89sJh/h/udKZBm1NiQh1/o/kQvLX4ZCI/bdy44CtalSPq3scFGEESEar5
 EWXFUzUEdwniEFOTGcO86SmUuNNyHhIdUITJtHvhBDiN/LuFEeoQqkQr6dNaEdes3RVM
 muJYhAbeWNH5JB8pebPyA0VVNi0Li3alqLI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3haxdg6hdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 17:03:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Erl0DP6P/mwZogE598eZZ6Hab4GC/CpAlBm/rAjWF9o+c3MfEuLYkyO8OShSfXhgG1pexMuoyBglUiXTJkEb2jzSGv0V2I3FNo9ncvbuFcQUuUW5Ie7Rw6qa8eDY0MXqCmdkvkw9M2aU1nxS5ZL9TJaQAAMhrcgvIs3rpB4tjuGnuRssKVQexN83sTnmDpefzH/57mHc4yNHPHk61bhNmPjIILGYOieGDGFElvKzxr4m9S6ylOsRFurpV5+dQPHnJ+jF1LNRBifx3jvY02+5j/PuyQi9sJuUC1gZEYfdyJqzXliwQEZ9EAIgp3KoPL+3mcqIoXaD0PUZE+0bkZc+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjEwYTQODu+htH+ET6TKFtzX0f8MG5w39Q/sUQ2uJXk=;
 b=TQVEArPCkXWd6DklYlvYI+ZOJ8MSyOhrDiUXq/4T9mDk0A2EK/gRqDH5gWYfPR4DqiN/8QGzRxGFkSe0L9sPH1cgAVVE5pTh3v7mMgwZXYyZwkJ/AT5kM9EEn7mb+k7O4MwinXQFsdt/X+3x0Z+5DkdZlftpHKhlGeT4Un7izxxY/W1Bp1qcoK+iJTLkvPDCSz6uByiXvZF1xUnFiechzO1I4Z4drIicHupxDpi5m6CmjZjy8pq18wjnAYn6sAh+hr1W0z2Lg2ZEMfC5eFF4eSdxggaihKjgIgwRqZ/mIAdErEH8jQ72pGw4l/fxR2Y4HS6B5FDRB43ZihiyZdfrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3448.namprd15.prod.outlook.com (2603:10b6:a03:103::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sat, 16 Jul
 2022 00:03:27 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 00:03:27 +0000
Message-ID: <fad1edd4-ac10-e913-5fc5-38863fd83c21@fb.com>
Date:   Fri, 15 Jul 2022 17:03:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 03/23] bpf/verifier: do not clear meta in
 check_mem_size
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
 <20220712145850.599666-4-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-4-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38a1b64b-a2a1-4541-5041-08da66be9be4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3448:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VldV/hRVrJF1j1aQArVoWuYhB74zjMJ4AkuvSvBu90jv0wlTSw/OKV1erWyJIj01mjGaXAl7c9sVdHB0XHPqQPBxNz4CrmkJ3LnjmFwtDIAEtJD1pVbjKz5d7Fd8Jtil/ggHarWaorFpKOfXa/HXgHtNCZFZqBi2IboAzEnIySH+GlCFxqVT/FfhTy7f6k7N1+K+fpqtFQyNEsfkfDeRTAzH5RnAEobtvliTNlifHvLRhJfyGcmhGePTQ+bT52GeQd2V+BNR1yUFoJp+GsXYO83+sZ4TFQ4ccVa9OAy9G1zMy1KvvhVy4v+c/VmeHm/CCSMZ7sVg6OFgclBClvJsN8FEp5tpR3EM1u3Xel/mrEhxaPnZtnyYqEU38AVcNQCY12fCwzAC77D/liQRjOCgqhPl6NiAhQkOLfQczdv2wtOKpNK+PQFipBwcYsK6MfPPghnNH7UekVOBZNnkbNH1P6pPho/Cc7yaEz6cM+05VZUkNr4tPAt54NE/UJKhhuVVka9hcm5rhM/S/NiMoNaTiGHxopzAmCCw7mCIYF7IIo3wdTpvzm0SvN8I9AyWQ/pVZAg3+iPtT1KyodV53SRQW4yUEfHfVEwpoNf4XNPu+T4wDbTVSFLudLSaoG8tPvB8OsDidf9arNeqBcHsoty34feVHHK7f6kgiwcLd5Y/B1jqf1laz57x7KmITCA15Ib53vHSkGNNutU6C4BMWydJZd/UpnMpRHNMfQcPPOtDXKYmksAh/4KgkypXOtCbapoJr6Olos/z5jex86ssq0inf440S9diiXP20UlVJai2gCRAbWfN13iLYF8sIpEF2KPmaFKvNauMqcoRScm5yLy39CqsUkuNsYdscTZnC2qPgcqhXe+fvG9qeM15IfyDFXsz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(31696002)(86362001)(921005)(4744005)(38100700002)(8936002)(478600001)(6486002)(5660300002)(7416002)(316002)(110136005)(66946007)(8676002)(66556008)(4326008)(186003)(36756003)(6506007)(31686004)(53546011)(41300700001)(2616005)(2906002)(6512007)(6666004)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHZKODZwYW5HZzJ3RWg1dGdLd0NxVS9aVWNLNWQ0Tjd0RmN6eStRTUFxY29G?=
 =?utf-8?B?cUZmcEVQeU5xZm03VHFxdUhqODQrVTE2NlNZL3dYUUYrYnh1S3VuaGgxRUw1?=
 =?utf-8?B?bWo5Zzh2aU95Nnh3R2lwM2JnNWN5a1dXcmNjZnJOSHJ0bTd3UitrdFhVcFRn?=
 =?utf-8?B?dVcrOHp1TkhvZFFQbmtac21NU0RzeFJ3WUR4eGdQZlY2Y0NvVHp3MWFVZlBw?=
 =?utf-8?B?Q2RxUjJZZ3BwRTIrdk9lTk9ZRFozTXJYL2tpczJGRTBNRUNLcU15QzR0Mk80?=
 =?utf-8?B?OVByaXB1SUdna014cHpxOEd1dXd0eGxnMEtVU1RTbGN5ZFVxd0o1L3VURkl5?=
 =?utf-8?B?VEJ1QXBmekhzVzIwQmFPMVdLRGhpdU4vaC9pWTk5SjViTjl2aU10QURhTU53?=
 =?utf-8?B?N3d4ZkVjSGRYWDJWN2dDYnFDcnBiVHB4MW91VGVyNWJQOEhaeGNPanZmRHNp?=
 =?utf-8?B?WWQxb1Q0UWx1Y09tSEJQdGkrOFY0NEZDajNXSkY0WHNTVUZpcDVtTDNzd05l?=
 =?utf-8?B?MXNqM0syTlcxSk85OGxhZExmVVZUblgzenBVNldRUUU3SncyZEgxME95SHZB?=
 =?utf-8?B?SzlmYU1XNnBlczREdnJQcTBjaFdBUnkyRE02NXNWMVlhQk81d0diNWJvSnJZ?=
 =?utf-8?B?L04rcUM2REk0ZFgyWml4V2U3bEtwc2t3ejJIQW1VWUJ0R1FFSjRaWWFuQ3hF?=
 =?utf-8?B?dDdpVEp5Z3FaS1UxbEVxYmJzeDZYV29FaTdoWkpvUkUzN01oR0NqVDRyS3Nt?=
 =?utf-8?B?d2ZRQVkvbE5XUFBaczE4eG5JU05VeEUyYWk4NzY5SXp6SHI3MGJTaWpRWGZ5?=
 =?utf-8?B?Q1h1bmpqZlgvT25Rb292bklxTWZmTTZyMVVhUXlSRklST1lPUnBHSFI5K3Bh?=
 =?utf-8?B?M29aNzFuQXczMmhCRTAzL3ZSL3lSTDI5OFpiTlBjVEs4Uks2UVprQjhieTFn?=
 =?utf-8?B?MnoxYzU2Q0syS0VmcHFKaTJhTmZEemZKdFZ0TlBzWHhiNGlDU0lCbi9KbFVz?=
 =?utf-8?B?Q3d3eXZxRVR0SUNGellwcXFCNTVBZk9VTXMyWXRHYitxMk01Z1FGYklSSE56?=
 =?utf-8?B?a1VaeW1QTGZwOUkvN1laVVlJNkxlVG5RaWlDMlM1ZXR2RkNZQnZpTnFFTGVR?=
 =?utf-8?B?clovUUMxMklFc016TU42cGl5WE5LclBRRVlJelJtbDNXQmVNQm5reFEzOTlW?=
 =?utf-8?B?V3Vpd3owb0NwT0ppS3Q2L3ozZ3cycko4QzdhNllwdVdxWVlNSElOb3dCUWZw?=
 =?utf-8?B?MXNyeTk4dHlvdDd5ZmZ1dVRaZjN3cUsrRnNGeWZ2dXRCTEpvdnlhbUdTRjZ5?=
 =?utf-8?B?emk5dlNFbERQc01yN21XSGRJd2huaGxYUHpucHI4b3M4QkFtMCs2a2Z1enM5?=
 =?utf-8?B?c3ltZzVtR3I5djM4YW95NlpDUzZ3aDBiaXZlTTNkc0lTbGdZRlE4RHkxQ2w3?=
 =?utf-8?B?U2laQmMyNU1iRytvbkp3aGpTMkpBNVhjcytmUmR5WkNKNEtJY3ZkMTdmU2xV?=
 =?utf-8?B?d01hS1IwM05LeCtHcW1ZV2dMcS8xMzZTM1lTK0tCdURHRjFpTXVBdEpPN3U5?=
 =?utf-8?B?V3dFM0U1Q0ZrZVhyb21aZVlzVTgvSFc4d2Y2aDhDeitCT0RVdTBqV3dzaFdM?=
 =?utf-8?B?SVVsalBnZ3Rhb215RFMxNDZ3a0t2dEZrZVg3Vk5EY0V4ZXE5MEtseWJPSFZn?=
 =?utf-8?B?TzFZZzlUVTJVUEdhWGdUVlR6NEVBd3BiWGEvUjFvNktOR2hwSk5nKzVTNmRr?=
 =?utf-8?B?Tk9QZ1BUU28wTis1UUNYeERJYklldVdFdVhlT0RPMFM1SFlYeUVxMEdDemRp?=
 =?utf-8?B?ZW02SkZSSVdlWFMyb3hsUlEvdGxhR1BIdlhpUExUejc1ejlOMVl4ZVlIMjdw?=
 =?utf-8?B?L3RpTGFacllPNHJJSDZYUXpmYXpUcFBxRDhnRnF3ZnpJZjhaY0EyVW1teUY5?=
 =?utf-8?B?RWVLVlNpeUtlYldmeUdzZnJLMzZiTjhrUGlvUEd2YmY3SHUyUWZCOUFSaUp1?=
 =?utf-8?B?MWZwNEtaSGdTbHl4bWkvK2JBb3o3Q0ZKV0JxQzI0N21ienRjMnFsbDB5YUtn?=
 =?utf-8?B?a05zWmFiOEswQTRoT3UyNDVoalVNaFlRd3IySW1HbVk4a3pPa3RhM2FsaHBi?=
 =?utf-8?B?TXlySWZNZHFMQllPTDd4b1VKajA0bkFYaUEzYmliTjBKMVBwQlk2eUdKcExC?=
 =?utf-8?B?NEE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a1b64b-a2a1-4541-5041-08da66be9be4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 00:03:27.3628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zytoKnwQm2bo4Z/a8PQeYij7x46XTxdM8M6NXl2c3qA5eU+HSEgiTkJ2MaDt6Ht9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3448
X-Proofpoint-GUID: ZGrSHWwx4ttG7yDUzq9c8mE11eNY0Opu
X-Proofpoint-ORIG-GUID: ZGrSHWwx4ttG7yDUzq9c8mE11eNY0Opu
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
> The purpose of this clear is to prevent meta->raw_mode to be evaluated
> at true, but this also prevents to forward any other data to the other
> callees.
> 
> Only switch back raw_mode to false so we don't entirely clear meta.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
