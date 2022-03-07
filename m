Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023D84D04F0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244384AbiCGRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiCGRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:09:02 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D6431DEC;
        Mon,  7 Mar 2022 09:08:07 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 227DNCK5010083;
        Mon, 7 Mar 2022 09:07:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BPav4V5tC+JFnlhVXpIKicn0huC/C/iW0swT1SwzuS8=;
 b=b/2dBknSgKTD+4bouYbDU4I1DVBrB5u6vXU/v9eRY9aHtJoXe8LsybDDv2OGhOxQr6Nd
 3IT2QPv8lboS3d49afbesTxbSqgvGC80vvcioAwnwxTLK4vPtsB4nI8CbzgT13M/mbkk
 2anUgD1XeLCJC/E2oOW6hcUeGiCI/vS5gwQ= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3em6esb7yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 09:07:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lItUig+ieNVei3h9dHVPuehKfYDGKs0TSEsFFekA4NBgB7CPLpa5rGXo5QcePNoyN9AbjvD7tu76QgwLvUaA0CBeCXHSm2fTH8hbGauHWH42/4btRZ2Mout/UfUD99Q7TeZKUlKIoTPuhDZS2li7d1ztr9Wgv8mhuAmhQQrEdnOU6EpOtv1RCXPbUWbDA/VW2Ld4tacP6YCwiHRLR9LVqL68akWwKstuEhtIv/1Io8BzwH66nDVPnGbnUsKbNtdvwB09LroalRtle9VjsyiaCUeH2ogCslBfTxE3N4joRZZ3W8/bfO6AR9S7iVddZYgIKacklZiBgaU1LdofUwoRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPav4V5tC+JFnlhVXpIKicn0huC/C/iW0swT1SwzuS8=;
 b=hvSvf/oVIzR0aFbN491rCPlM9ansNtBt7BeMzNPqW6ZWz3IM07SZtBipcD1QF4aGG4AX0GfyrmqfGh6a/BIplIxXbcBWeyncTMlxPLIcBUdc9aUQPaPvHyoqSPP6rCSqIwur9H1aM9ueSksE6aiJorTouyKEWHHdTZo2NAbcohxzV2dqNisn+y8RkcTcY8EWic5PPsjtaZBGvqOSxLmy3PpffCNbCJ9b4BfpvB2X00owqsV7aHnuL+pr2CJkp+4Wv4m70mtOZgY56NaYLKP0jfZcJ7pWKUzbVQtExf6G57lj23qAgKaZ2co/ls8i21BfVxHxRCCx0YJEgGpUrEFxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY3PR15MB4883.namprd15.prod.outlook.com (2603:10b6:a03:3c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 17:07:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 17:07:47 +0000
Message-ID: <b4f443bc-665c-379b-b73c-a6ca1ce5d701@fb.com>
Date:   Mon, 7 Mar 2022 09:07:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH bpf-next] bpf: determine buf_info inside
 check_buffer_access()
Content-Language: en-US
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org
References: <YiWYLnAkEZXBP/gH@syu-laptop>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YiWYLnAkEZXBP/gH@syu-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:303:83::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7f5b7a5-1468-4856-b2a1-08da005d0108
X-MS-TrafficTypeDiagnostic: BY3PR15MB4883:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB4883915E08A77BB116444A01D3089@BY3PR15MB4883.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UguSrihsrQEPFH6t6VK/bWVaJA8ptc/94zEK/KbQWKIaXOQASqmVdfzydjQ9i4ZIp6ax30Wtz3+mWHx05m5JHno/nru4RNGTvgmWZbPbx1OTaBRcghak/k7JeyH86dTK0KLffDiaPxgvJTXZdYMf9+rstP2XFifJzpbpky4vRdcqCHvgy8wb5wDNZspjRw+fP42gSXo4U5mzyJu3LnPUTSB2nbMbj8D/0opI7n/SG2/O7roYE2ma9lAdkyTUy8Fs+I09LvaXuOgXNN2QQvNMX0yCybidUKQnFPZy8A5EueB0sjcKBWBgAvQ6VGb28bmrDYMzVmNM2vP/ckE0FsqbH7fMOwEl9ENBF4UE7NeVmbOS9f+W6+1i3ZcmvMO1HSauJr4aZZ5fVxUwAZURJL/psT+DcL3wcNzFZuO6ZnWYM0/ivnPziBpPoYBNbqXOZ2D2ASTVPfbhF8judDLIyPpuAa2kpasOzK7RvVLFs9TsARYJdWEbCn0wWqKm8KmaUdkITodWw0+S7+Xi16xF/rukcMS1GS6RDbgvwdH5enmeFYUPWjkINYbR6RP0GEDycGwStp4XT4jcuBemE1PxsuRCNtvQptuX2WSWp9fjSUS23rSHkFhAg4pc2shDVpq7S57XkLs9S7riuoVMAzyNF8g5ZY7n2BYjpzgo9YKbiOgPLfNald6aueHfVY52Z5dQYBq/exFgPd42xnPnjsZ+Q9pu2C2d2aGnf7F0V2OlQoYdSn4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(52116002)(53546011)(36756003)(38100700002)(2616005)(31686004)(83380400001)(2906002)(66946007)(5660300002)(316002)(54906003)(66556008)(6512007)(8936002)(4744005)(31696002)(6486002)(86362001)(186003)(6666004)(8676002)(4326008)(508600001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3ZZWE1qcVFjOEs5cG45cStaMTFUMFQ2Yk05dmJ2QTBhcDBwRDVCVkRwZEVG?=
 =?utf-8?B?Snhob2MzQ0pLd1czNGlhZFZrdVpobXA4RGdlT29MQnhYQ0dYN0tGcEZyWEIw?=
 =?utf-8?B?QWFsRVdsT0dJbGhtS2twRDNjTnV2K0R2L3dpN1JBcTdIbi9tVExKZjJYUlcy?=
 =?utf-8?B?SktKSWZ3WTA5cjd2T3BSa0VXTXc1TFVqZmZoTWVvRHYvSk1GNk82S01GMVUw?=
 =?utf-8?B?SGU0SllkMkx6Ujd4amlWYk11OWxOYkJUbVY3M1pOdVZKVUNYaDl5UHVYazJE?=
 =?utf-8?B?c3B0QzVPdVpTS0NmNis5TnYrbFk1eDdPd01LaFptRHhMeXJUV0Q2S0pmYmdp?=
 =?utf-8?B?UE1OVTJkNEVTY0x5YnpGdkpEZDYxcVJ2U2NwQUdlZk0xM3JGZEtTY2ZXSjBP?=
 =?utf-8?B?WnJZd0V1M3p1Y242QUxndHVUc3o0MjRwYWJyZDhHeFRMSjNFQ2dtZmRHZS81?=
 =?utf-8?B?R0JnRWtPRUtUaWVLMUIybkE1QjZDZU95WlFWTXdJbFZGaFBXQWI0QUM5QW5P?=
 =?utf-8?B?SlkwNUVJSW1iNkhsR1A2akgrNktYdStvV1gra3dSU0g0YkZoNVlsVjdpdU1T?=
 =?utf-8?B?YW1NVkhFUUJHeUFiZ08vWk1rT2RrKzgwOEdodm84SC9vOEE1bmd4KzVtKzdZ?=
 =?utf-8?B?aysxT1pvT1IxL01xUFc3ZFUzM0QvWHgzbTRSczJRdGxDMGUxZ05jRXVZamVK?=
 =?utf-8?B?dEhWZFhQY2xMYUN6UWZjRWpOVk15RHp1TGxpTndQTUtWOU05STIrTzRZQUQx?=
 =?utf-8?B?NHhzOW1va0RFdXFVMnBsTmhPZDkxT3VsaW1XZCtSVjdlWFRHMk5Rd0lyVUU1?=
 =?utf-8?B?R1NyOVBOdzkvYWdLV2xyWFJhYkFzUE1uMW13R0ZmSXVCUCs0UkdnaHhqdXdV?=
 =?utf-8?B?RjhLVHNhNm5tWEo3UHdCdXNFWE1SV1hlZ0ROSDd0TFlxcndTT0pOUlh2VkU5?=
 =?utf-8?B?RStvVGhxd0FTNUR1NHFYaEhLb3lQdHF0ZDJUejlYYkZmbEh5dU9YWVJPdXR4?=
 =?utf-8?B?SUZ5emtHR084MEhLQWZ6WkM0cHRRME9DNzhaRU9QK3E1Z2M2VjNyc2FZS2RR?=
 =?utf-8?B?dmJYZ0J0RFRvYVZtdmhpMFZjYXhmYjZNZzVCSm5sQ1ptVG9vbHU3cXVFNS9J?=
 =?utf-8?B?eFY5Q3VWaiswMlFMZWtLU1ZaN2JTN0tPMXVzdjFmdTdQZ29wdVlFR1pDc0Jk?=
 =?utf-8?B?ZUQvUFpDWlBqUWowNXBpVEZwMmVoMnk2Z1dvb1pWWnppbmJ6OW90MU5OalBI?=
 =?utf-8?B?ekorb3RESmtDWTRzbi9zQm0zbFVqdlZEOVg4YW5mSHBUV1c5M3hpd0RBWnRx?=
 =?utf-8?B?MVREVEtnQ2pNV2tkMEorT3ZrU1lHcVorc3FZUTZvMXZUY0R4UytWZ0tKa0ww?=
 =?utf-8?B?cnZ1d2gyT2RKSVpZK1p6MXhzTTE0aEJzSFBoTHIxYWE1OExlZXNNMU4xYUpm?=
 =?utf-8?B?c2dQc2lFSmtLWU5kQkczRGQycEFzcXpFTlJsMEVTMm54Mk9PV1B0ZVA2NmlR?=
 =?utf-8?B?dVhjeG42aWpPK3lCMXdoeDNyendCT3RvNUNrczNxb3VoNUR0Z0VJU3NoRHFn?=
 =?utf-8?B?cENsT0gwNGUwOVZibE9mbkF6dWlXdUNsUXNEUlpONENhSDZkUVRmazM1bXkr?=
 =?utf-8?B?SVZ1b3R2U1dHRUI1MlEvSHhvcy90T3ZDZ2dXTHh1MHJMcU5TbkU5dnM3SmUz?=
 =?utf-8?B?dXpUUEgrUDRrVnpGdTE1VXl5RlFpenFhNk1qVjlLTFFsQjFVcWRGQThqbkJB?=
 =?utf-8?B?T0xwbDY4dnUzMUtTcThqYnJuaExhTDM0SjlUV3lod01teEQ3MG5RSzJZNllK?=
 =?utf-8?B?K1pPK2NjNXlkOEkzWkV0aDhiSDdCeGFjaHRNVVdPQmEraVpuSzRoclo2WnZO?=
 =?utf-8?B?SUxaVmVSMVA2UytCd2taUFMzcG54em1rT3RGc2NPSld6Q09HTlJsTndmazZj?=
 =?utf-8?B?UE03ckJmVUhCSTFIcGRrUTRUc0t4ZXFLTU5sR1RLdHVxTTQvY3B2UzJBY1Fu?=
 =?utf-8?B?ZG41cjF4QVo2QnJoaFVhODlJdEg4TTd1cWJHNVllc25sVWdtaTJtd1hWNkpZ?=
 =?utf-8?B?YjVLbVRNcmxjNWkzVzA1dm5PaVl6dEFCM1ZqdjBwakRWK2h4Yi9IQWdiTmQy?=
 =?utf-8?Q?ZyvzjzfWqrKEQ3SIYgyBGxaQU?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f5b7a5-1468-4856-b2a1-08da005d0108
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 17:07:47.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tix4Ydb2g/FGdc5QsGjhv1d7oPYfxNqWIM7UpH4//UMH5EGqP7NZQqWNjVsx/rDh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4883
X-Proofpoint-ORIG-GUID: NwSH6XRZT92_yGKlKUuBCIZ_rsLPgqEF
X-Proofpoint-GUID: NwSH6XRZT92_yGKlKUuBCIZ_rsLPgqEF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_09,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/22 9:29 PM, Shung-Hsi Yu wrote:
> Instead of determining buf_info string in the caller of
> check_buffer_access(), we can determine whether the register type is read-only
> through type_is_rdonly_mem() helper inside check_buffer_access() and construct
> buf_info, making the code slightly cleaner.
> 
> Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

LGTM. Thanks.

Acked-by: Yonghong Song <yhs@fb.com>
