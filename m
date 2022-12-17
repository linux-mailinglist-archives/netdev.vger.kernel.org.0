Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FDD64FB62
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 18:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLQRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 12:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiLQRtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 12:49:04 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AB963C4;
        Sat, 17 Dec 2022 09:49:03 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2BHGWXnh018116;
        Sat, 17 Dec 2022 09:48:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=50XclNBj/t3XAQnjTU7XULC9hE8F1sgpl31Wk06ebVo=;
 b=X0I3dljhw5R7tLBD2k5Sp0un4MpZUhY/UjDStFH8w1Cxl1ew/2GVi4syWKQ/odxDL2X6
 5HxMp2kuvyCBGBV88L20dWbdlJS67psg4r3eLZXXqc6swwNU60T3+X2ljojMtuv9I6qt
 uyN43r8zuBbQe8Qw4ZbES/7dZAXsLGBpfhGcLCedztlibKmK7zw7TpVVzFMYDj5qxdvI
 S3rZ077jf4eBB5uc9/67LxRHOt3yxoAv1WCD/NqKd0ja1XWGU8Ye6CI2wXvbmXPeA6pv
 IztOCAdiTb6KYs2yIDJpMLjtRgRMKSzv4eRO+KG/v3azg+FgPyo8HYkQwnd8vgoy0qD3 Zg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3mhab01fbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Dec 2022 09:48:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFvJzoLUQnCJBQBcHuHBsEfeuaJVlioywchOBI0NdlvJK/b0LE2K9fy84lChNxJX+9EPIteK1XXsMTNfqWCSPShbLbWm/ynpP8TaI4VwwTt80n3M/zhM+VlG6Gr4Srnxs+ap8DEO2U4DohWeiefZslBIURqwQJQAF+ZUaeYApfguUDllzJJ4+fAdUkTeg6iGf1cJW0ROoh3eZAK/fTGFGBiIQ5gp5LUUll0+tsYTOPxybV5aN6LXYrCRJAF/8ZXWGmCPDloBrUWb//RReefEc/0p8Y7QrfYaYc7ORubAd+ZbFVp203tuUGEL72cJAwMSuhr9i++6Q3EZJUcygqgRgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50XclNBj/t3XAQnjTU7XULC9hE8F1sgpl31Wk06ebVo=;
 b=Aus/QOWxcNrQaAPkxfqqk6wFoW9Ecmi57d+qdDqysJEraMt6APkadiaOYwC9XHAj1cvcmof3zI2UK/zIuFeuGQy2MT7d9TEXcpByjFu71K8u7+5ajF8Qlnx7VOJlu8W8RRKMZe0ERxAV3KZV3lROjl1syCnFymESu7pyy9KjvkhgKE6prCtQlUVOnr89Gio9wva8mCdDnARMMi1Kt0IcWoBUF+nlMc1sJ2WN2zDgbY69zZFY9aw3bhnPvib1ckJSMiCiXHXQPICLU0VvFUBna1kNJ3lXrEezVgfNtJIkR68nc9lF2Lvi/YAESpZ/DhDhQl5Mbl+qff9ywM69NIcOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 17:48:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 17:48:47 +0000
Message-ID: <e7fd2a43-300e-68c2-1551-ed6c9cb921f8@meta.com>
Date:   Sat, 17 Dec 2022 09:48:45 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [bpf-next 1/3] samples/bpf: remove unused function with
 test_lru_dist
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20221217153821.2285-1-danieltimlee@gmail.com>
 <20221217153821.2285-2-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221217153821.2285-2-danieltimlee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e48f02-20b9-47be-2b57-08dae056f2e0
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpS6LmGkwYCz0e7t/Fb4mlr1lG3S6WWoJmhzBJnNQXO4geluB5ho2V+jNy25sKSqkuUTNpJBfeYNt0XUXPhXG57mXHHGHx8uoF/pSz7x4GL83DWLVd6tPiQvvjPZ9FclFDw2quR3kMlhOIPEzEoszOLXi1IAmcZ/EuUQ+SVII4WdWnHWLqQnOKCDDoWFEtLqwSj/Xpv0lYb6p66qukcPUuljYuh2KkvyV1uIf9+Xu5Ak5qtu47GvF5qASGDCLL7nCEmCsCjAlGcvgoqhr13QMn6XtDwycduHwQ1cR2Q7rhSsrTggxBkEvOmeh4Npr3EtIcFpb8h/6hy7IBlCc+EtVO7QP/JyN7dBF41djE2rOyJ3FX1MGC7ifWu4+C8X2YqklxU0cBwmW2SGGEYqu3l6upyJtks8mm+5M/uOEnSqgqtE6aGnJwMKpaB6rbJO05oyfOZsowLgxeaJ3yLRqbeXMSrrvEndfuOe+vvnPR1FQH8/9ef/Lgq7wQyNVcCEVri2n1CRD962xoy/CrBl5SS8c5y0bdkD2LCNcRMc2yarP8O6HmKvnB8/iJqhW5pjhkQzuk8dtnSWPgcA5QdV5wKK4gSo+F22UoMM1HOdI01+PWNagxXliR6jvgxlgv0aTkuDGyHPuVk5UnSdPqFbYko2js2D2+AbfbRkYOj3EuupVQ2cNhVhNA+Y7kJ9fpshVsTpnBS4QJUzPV5C4uc1APGboB3PX/mIhZP86PBCsupe9oU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(41300700001)(4326008)(8676002)(36756003)(38100700002)(5660300002)(8936002)(2906002)(4744005)(83380400001)(31686004)(53546011)(6506007)(478600001)(6486002)(316002)(110136005)(66476007)(66556008)(66946007)(2616005)(86362001)(31696002)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzRqT3J3WGowVlJsSTM5alBYc3Rva1BaRnpuUFlQd3ZJM3FFTlczcTg0elJu?=
 =?utf-8?B?czd2QlV4RTFOU3d4RGlBTnlzRVJzZEdFU2N4RFNFamNoVy9QaWxMUXZuQThF?=
 =?utf-8?B?UW4wSEpCVlc5c3dhKzhZMmRyWURlb2lSektDWnNNWFJMbTFUa2dHTTMwdEFa?=
 =?utf-8?B?K3d4ZUJVemlaeWVIL0QwdnpIdm0yM0xTaithTGlzRlJmclhXRk40QU9BUGNi?=
 =?utf-8?B?M2daeFgzU0ZiR2gwT0V2clE0S2gybzJWVHhmSnUzYWhLUWFuVXlhbnZ6dHRo?=
 =?utf-8?B?bTFRT2pkU1JINzEwYm5UcTdKdElkQzg0d25NUm5CRVZjWEIrLzJ5YVhtMXUr?=
 =?utf-8?B?TnNnNHFqZkdNMzZaTW9PS0VaTGlyOFY2d0dpTFFlZ0w3ZXROdjlvYmJKNTlY?=
 =?utf-8?B?eWFkdkVhcGZnbCtpVkhqNENPbm12OUlyWi9qUVVialVVa2xjUlduSXk2UFg2?=
 =?utf-8?B?NWpCeGV0OWVSa3gxYm1pUEF4MWdxZE1uUW02ZnFBNkJUQml3dmUybDg3QjY0?=
 =?utf-8?B?WmZZT01oaCtHS3lzRDRKaDMxTzB5V1N6RDcyTUN3NmU3TytZbjNHb3lzb1RB?=
 =?utf-8?B?UUpsQ1EwRW4wVHVzUGVRM2h5UldZTmRWdWptdVdmRksxbk51U1RuSUpKcTVY?=
 =?utf-8?B?eWpjWmx0dGxvSFdMVGZrY2xRSU8rSll0R2dBU2E5SkorTG1LQU1Jc0h1dWk1?=
 =?utf-8?B?ZmFTMzl0b1l5M1ZXNmJQUXN1VnUrVm5NNFdIUGR4S2RXMnp6N0sxclNrUEov?=
 =?utf-8?B?N2xLWnlMTUU1WWV6RHdzSlR5cWFyWkVPU214TmVUWG9oajB0NlBqNEtFczlj?=
 =?utf-8?B?Y1ZTMlQ1bXY1QWxUR0Y3VWN6aUVvU1dLeCtTN012ZytpTVRpUVdqMENLYVov?=
 =?utf-8?B?UlJEQlA4WDZlWVpuUVYxYVBnQUNLeGN4Sy9KSUVGS0UvWWhEYU9tWTNyeTFX?=
 =?utf-8?B?aVJxYlZwTVRCUzBQRFhWci91d29yZ1l1NTd3VzRRMU1oRmpUYk1HWnI5eExl?=
 =?utf-8?B?dENhNTRTc1p0R3dZbW1QaUtBUnEzM0JEMTlCWFdoazJTVFQ5dEJ3Nm9YdmxM?=
 =?utf-8?B?eEpqb292OUFEeDZDWmJpcVZlOFpwTWN6ZHJTOTZVK1RDbFZncTl5NUZaT2Zx?=
 =?utf-8?B?cWtvdVk1UXhvMWo4eHpoSGRtdlQvZzR0YXVEanJiZllWQUpBb2dGUXhXekNh?=
 =?utf-8?B?ckhtNitHYWVOVDJwYXVsRHZ2c1JnRU1sWDJIZXJjQ1pQWUV3OTJmbGFaSkVW?=
 =?utf-8?B?RTVCRStiYW5JWXhIeWFIdWZ5cDR1dW4rNEVhOVBhS2RDWG9jekVmek1uS0hK?=
 =?utf-8?B?NEYzTjY1WmY5QmZrYkhJYmRkVTBDbTNKMVFLUm0vaFJuQ2ZQcUJxZVZvM1Jp?=
 =?utf-8?B?MlpFWDY4R1U3bkUrRVB4bnhuZ25MUXpNOHpzT1ArYVhIN0tlVFdSVGpyOHBq?=
 =?utf-8?B?cEc1VTBFQzZJKzB1azVEdnN1eGF0b0Q0Ymw4UlN0eEltSjNOYU9HU2w3UC83?=
 =?utf-8?B?T1N5TzUwYlh5ZUtpaFZLODk1aUNibUtPU20wbnp3bUFFZTI0YzMwOHJPZGR2?=
 =?utf-8?B?MzdPT0krUVBEMm1COEVZVWRXOEJFclVOWFpISjg4SW9uSlFIMStFK3laSjNL?=
 =?utf-8?B?L3JmVnU2NkFUNTVSSWtoSnBYZGRDa1NJSStETE9yUGt5d080U0p6Wk9DcXFF?=
 =?utf-8?B?WjlRR2FTU0lhZ2t4dG1EcXdnVEpSckRScWxCWDluYmFIYXp0M1kzU09Edzkx?=
 =?utf-8?B?Y2NMMXNBOEcyRlBjVHN2NkloazRBNER4TlAzeFE3MXFEbUg2aWtTTHhyUTY3?=
 =?utf-8?B?SEp0OFZjUmFWQ2tXU2RhdnVtcVRjU3RmcWhuQ01mNVVzMkdjQ3EvVy91YzNO?=
 =?utf-8?B?aW5zVkZOQWovdVJ6NVVzaTdPZ1FiVzZZYUYwSjZjQ2ZQSWZYMVJqVVVlQmlI?=
 =?utf-8?B?aVhJbjV0UFZ5K25sQWlTamE1anl0YWdYdm52ZUZrN0dNTkp0R2xpU3lLWjdu?=
 =?utf-8?B?VWNNWlRzYTVOYTIwZ1N5MEJCcVRnRVEwSStWNmJBV2Q0SEhzR1dqb3VUSld0?=
 =?utf-8?B?dTdnNWhmTHR2Q1VqeDNYWkh2MmZrMlJveTM3ZHVhK1hGTW9IQXFTRXhnOU1n?=
 =?utf-8?B?cDg3Mks4SGYrMFJTVmRkdEx3TlpSQTJuaVNPeXFlSnpqa3Mwby9CVElEcFJp?=
 =?utf-8?B?dXc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e48f02-20b9-47be-2b57-08dae056f2e0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 17:48:47.3870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XYvl2RAoupQOXSN3PnuxRQZrYGzZK5CKRbxcCE1WwvPxq47pbTqJosdOqR3VeDx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-Proofpoint-ORIG-GUID: tscDqTWGYCcVSwkX6xVU3t5JjKvDqvXv
X-Proofpoint-GUID: tscDqTWGYCcVSwkX6xVU3t5JjKvDqvXv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_09,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/22 7:38 AM, Daniel T. Lee wrote:
> Currently, compiling samples/bpf with LLVM warns about the unused
> function with test_lru_dist.
> 
>      ./samples/bpf/test_lru_dist.c:45:19:
>      warning: unused function 'list_empty' [-Wunused-function]
>      static inline int list_empty(const struct list_head *head)
>                        ^
>                        1 warning generated.
> 
> This commit resolve this compiler warning by removing the abandoned
> function.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
