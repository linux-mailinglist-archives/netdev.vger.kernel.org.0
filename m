Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A18F576B12
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiGPARg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiGPARd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:17:33 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA48688748;
        Fri, 15 Jul 2022 17:17:32 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnLA2026428;
        Fri, 15 Jul 2022 17:17:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tdzzS4zswubzNDPQxMmpkbGfiAddtFBhXQBFs4xNTw0=;
 b=kpeFF3QdRk8Bj+fn1+7kg3rcCPfmNtrpfZgEauZA/hRWZmYnQ5iCe9DK0RP+LeJp1i8d
 /t2jfQ0wl6ABsTu3hg6XyieOy4MXUwz+FzHABAVZxtju6y6hgqVetQRFPMnIhN4e9Y9s
 of1i87pce3dps7/oyOJQcceaK37Jd26ugOQ= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3haxdg6k7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 17:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GR2TeDGe92ANNJmXdRzhqG9yv2ozC1yMDwkZrH4yEj/s384M9Ls/UHtQ6rHYuHfp99cNvjjv0P7z6b57Gi58ZGj2SSXtTAR/FQbZ5zwvJoN3n4b65q98P27aCg6xUJZ5DmSAl7n9R1waaroHxPE/x6T6mGTzpCHtA/oZ7iM248DNlwQLtIPHvgk65tw4h69FKWUJNAe+2FLVBDQm0RtNFkW/eXKyw8WnWEFctNlyRQ6aGxNu9lRAjTu90KnV4DCbdhzIoiZNLzeKMuXRvc/WQrS0VovCjW5chFhO8nu/n26V5BgCCkLVDfmY6vJDxxafX6d6xlzBJyrjUFlks0m0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdzzS4zswubzNDPQxMmpkbGfiAddtFBhXQBFs4xNTw0=;
 b=fF9IjNFvz8Jduk+97/1iPlE9mvF9VyRyrDEQa4nc1HTjNE8lAmWcHCiUFhWq6aKdrZpSI8yifiN9o3keM7a3vUy4Hk30JdmlXHLKe5yldx3hLKk/e4epZ7FMNlqUccGQILg1bRGLBbntVML6yyGNnMe7GUzqddY/QBnMyolanH8Ll/p7rQcJWgGI2i1h25wy9fE90joPTOLawsScGRZ5dZiOnXvW/Nm5yZxL9GLxwwBdPoz43vy4AO6YPCpvtrgy2Bz6Q0Rp0yxCd+BXJWSQFfq/1y/LBOidHn+WYav4FYDxPzboUHFyzRnZnhIRjc82DYh/D+w3K12Q38VvoU6amQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CO1PR15MB4940.namprd15.prod.outlook.com (2603:10b6:303:e7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 00:17:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 00:17:09 +0000
Message-ID: <2b6d2fed-f357-9426-b6fd-cb4864180842@fb.com>
Date:   Fri, 15 Jul 2022 17:17:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 04/23] selftests/bpf: add test for accessing
 ctx from syscall program type
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
 <20220712145850.599666-5-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-5-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871357c0-3472-4c9d-7dc4-08da66c08614
X-MS-TrafficTypeDiagnostic: CO1PR15MB4940:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0g7ylut2wz0grAGr1FccE7VlDKL9LfeTGzYPXcDBD2cEFgJVwfxD0WTGIZuWqWfDGrscIE7mrhLs5qiCZ++CcYfRzasIyjwD00iGCFs3KN+c2NxCTBN3HI18Fd4AKbQW20kcA5nlORo954ldDLWHpCfy1Td2ikmAKNvw4f+Z7+02CO9Ii1j+1b7afrQROMi6WEIA5OiXccMxyXG50Kw7UO3Hux2qCuMoA2MUwBUjdjpUfl3Sh+/Y0w5JDQA+OiF3ouXQkQ2TETrgiJhYzxdc6hWYLLvMELjniKVmqblA2fUUJNYwuOtYW3o7xYsfHJDdLYUmp3zmyoCl5SMa3IDu8jo4xRmo1vqfi5kS2BSPVr8PK/4ZYnk7XXcY3A8eAcCDyGI1ODk01kcnSwe60rI/3n6fwJ1f33WL5nBGzG3i/tBJAhJQ2M/Ks6Xey7vl960I7QXtJvIFhRhnMhOkr/yrVrIf3sBH3Bh0FAn4rJlqlWgAlHYC0nrnVm/glMERsoupInuPGtTX7OwFe/YPZtFb/x65bsMWVhNt/g3azcN+/4Iv/Lqley1TJ7LUfBUVFEu9r3qmyFK1+LdzMNbOWJJHwO0U93OMYRtVG2ZWJGYE1NzzxI5HlkaY+BHjBXLxM99V+n3E0Rfa2b8Y0t5sbIYwtkYVbqLYyju8pzITkobzawWlPbh5DJkTCIlPnAqYgi220z58jvCWUrauCBnkM/3Ziy6onD2pbAvU/yv53KSjTc91+M4MAc4MYR4bw1Vr3T/gkom09scOH0Iq9zeCMBJ558BBNkOXgFKS3BcgL7Hh5jeM2vb+0mv7elr7FYJssMLct4ofrb6t9DDSCYtCX/pKErmeKUTt6NeA7tSUlNKrQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(83380400001)(2616005)(6506007)(31696002)(6512007)(86362001)(53546011)(186003)(921005)(38100700002)(4744005)(2906002)(5660300002)(7416002)(8936002)(36756003)(31686004)(110136005)(4326008)(6666004)(41300700001)(6486002)(8676002)(478600001)(66556008)(66476007)(66946007)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjNCZ0x5QS9CZ1Btb2k1TDBYdytKckQ2eExjVlh1ZUJDa1pmWGZTWXVGb0Rr?=
 =?utf-8?B?cTFxSktWdTdZSm1aeDVmL1lIWEJvYlVoT0QwN2ZjbDFkbmdEdWM3aDJFYW9P?=
 =?utf-8?B?ZWQrNlNQS0lXMUtYdlg2cmtoVWllTlQ1dVI2UVIwdHI2R3BVNEtiQUFiaWtV?=
 =?utf-8?B?UlZtb3V3ZUlpRkc4Nzc2VHpUc211TnM2b280ajMySzdtWThKS2pJS3BydkdU?=
 =?utf-8?B?SitKL1hHaTFWTjRtdTdLOEt1eTJMZ004SmpBUmh1dHJkREN2c2cyRksrZW1s?=
 =?utf-8?B?d0xyZ0R5Q3orOGgvWGNxbWRsd2V6REh0MHN3cUR6MUZMTEEyZXBtVGNUMVM0?=
 =?utf-8?B?K09PVWJXY3hWbUdNSUQ0cmdac3p3bGVMYmxUcC9TZDcxUFlDRFRzbjBLT2Nx?=
 =?utf-8?B?MllOZEJnc0NxTVp1R3c1cjNIL1J3alo3UGZudFlsaUY5T0pLaGs2Tk5pTHA5?=
 =?utf-8?B?QkFwTDErWENEbC9NU3RGM05zSjB1WjRVL1dzMGQxTitUbng0Zlh3aDBhY2hR?=
 =?utf-8?B?dGh6MW84UUoxeVRsMnAxME5sa2pKbmZsRlFSaHFhMUlhNkR4MTlkaWNiOGt4?=
 =?utf-8?B?WkRKbzVtbGVrTzJIYVNUbXZibGxvWmd6QXBwMTdtdTJIaEpKem0zSGxiY2t2?=
 =?utf-8?B?L0k5M1BRTDMzY3MvNWhpSmNIcDlLZW9ueGNDVHFNeUFYbldhUFhoUmV6elFm?=
 =?utf-8?B?Yk1BRzE0M1JpbTg2bHAzZVI2aHNQQnZ2cTAxbHFtcndDMEpCcXZ1ZVpkQzFT?=
 =?utf-8?B?NEtPTFY5SUhPZURwSDlvenI0b2Z6WVJ4SmFJcFRLOUdFaFpLaVBWYjFDU1V2?=
 =?utf-8?B?UVJ4WC9XUXljSFpvOGlKVVBKdTNIeWo3UjVzc2U2dnVzUlVjcFFFM2puc1Rm?=
 =?utf-8?B?TEVkYnNqcm5zRWozR0NKeWNnaTFwaUk3akM0ZzVUSzRRWTE4cXdvNHZ1amZa?=
 =?utf-8?B?RnZUQzNyOUI5bU96STdPUjg3ZDVaVkc5dUVWMUtSQUpqdTI1bSsrQVVVRzJO?=
 =?utf-8?B?SzlwaDN0OW5CMU1WT3JJTXlUMi9BTFVHNHhyRUQ3TExkZHlJdzJrTnVuaUJv?=
 =?utf-8?B?M0ZZdE9iTWd3cFJMckwvb1JxdHo0MlNlZk41TXBoWHhWZ2ZMeTVoN0ZDRk81?=
 =?utf-8?B?VEhuanJQQWljdC82MDJHMjE3bHRFZURtZm9SS1FySk9aaFNqQ1UvQ1hjQWxR?=
 =?utf-8?B?clMwNWNaeTF6ZU4ra3VWM00vaHg0WnVPNVdTeFVsVExqTzEwSkZNejJpNjJM?=
 =?utf-8?B?RHdIbkU4UWJXbVNwRUk5NktXTDAvYTRjd3JsbHU5ZVBIeXIxbDdhV0lzWllV?=
 =?utf-8?B?bjRhSVc0TUJhbXR4ME1ld1Y3dVVUa0dacmZhVEdSTDlyS0pNdjJJbzFpRW9n?=
 =?utf-8?B?cGwvN0hWb2FBYUFaTElTMnM4YlFQYk16S1JST2duS0N3cFdvZ0V2RW56NUJ5?=
 =?utf-8?B?SHVWMlJCNWJrM1dwVTIyaXBEeWlvcHFZTlArUW1hV0VQaWs1ME9NTUFDblVJ?=
 =?utf-8?B?bW5kSW82aW13VEtUZnhlbjVaWmxVSGwxYW1QY2I2ek0vRnBJcTVZWTU3WGkx?=
 =?utf-8?B?RDRSZGdNTW5WRjl5NnFOMDAzN25zWXBNSmRwaFF3QVN6MDdkNUhDdnFTTTF1?=
 =?utf-8?B?bGYwNzBtSEhpVFlib0N4TXlHOUtxdzJISWZmdW5vOXdhbW5ZZ00zMXFmTlhl?=
 =?utf-8?B?dUhOK3ErYjczOUpUcEFiRW1xclB3c3ZUeHRtR2NTZkhzdzdSTGl4SzZvc3RO?=
 =?utf-8?B?WHVBMU1GZFFZNnlnaVFVWjJ0R1ZMUkcvdzJPQklJYlJZNDdwTUNTQmF2dnVm?=
 =?utf-8?B?ZkpHTUhMZFdGa1pCU2EzSm9rczdCelJhNjdBNk4xa0h5U3JaSlBrQUNHKzhD?=
 =?utf-8?B?d0JGbjdrd0theWNhdW45UEFJaW5TY1lld3V2OGRzbXBDTGkwUWl6TTUzVjl0?=
 =?utf-8?B?QVNrMUlBUFlacFB3dktoMnEzSmNZNC9Ga1Y0TFVOeXJMOERDNUgraWxmMzk2?=
 =?utf-8?B?RjZzUTQ5OUpwZ0J5Nk4vLzIwdi9ReTVzU3BiS2krczJkV0VWd0dmdW53MXRj?=
 =?utf-8?B?dXNqU29NOEE2MUwyL2dQeE5LUmVjZnZ0UkFCcGxKRGRaV3BqT05jaXpCdmN5?=
 =?utf-8?Q?fo2HkgaA1js5cYsNIE6VrHWzQ?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871357c0-3472-4c9d-7dc4-08da66c08614
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 00:17:09.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+EHpJnjA8ashj9V4FrWF1j3/p7vFksGjYU7ccsk19iWjMGxWclYKj4YYuErxeQI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4940
X-Proofpoint-GUID: XJvFT_NtYROwnFUsr1ojBv24jYx1Slue
X-Proofpoint-ORIG-GUID: XJvFT_NtYROwnFUsr1ojBv24jYx1Slue
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
> We need to also export the kfunc set to the syscall program type,
> and then add a couple of eBPF programs that are testing those calls.
> 
> The first one checks for valid access, and the second one is OK
> from a static analysis point of view but fails at run time because
> we are trying to access outside of the allocated memory.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
