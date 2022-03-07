Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC34CF1DC
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 07:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiCGG0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 01:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiCGG0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 01:26:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96AD37A3A;
        Sun,  6 Mar 2022 22:25:51 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 226MhrbZ022298;
        Sun, 6 Mar 2022 22:25:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ugzOqAJQK7y0He1mIowjQIWYon16A6AygNmbNIPlo1w=;
 b=OiH3aAgOlwt160NqC3VlZ/mGJFD+t0YxGonGGTTzRg/Od9/MfUAkKTOrGCOalZBqew7h
 H4pcD3fbe8Mgbcb6cwaA1wUltL05EqShAi4/r9aeUtnSL2g8J7w1nCKzu+gP2YcsUYHO
 d7V82gN0R0bx4bKdaR0i9z6RyTWIIIIfXm0= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by m0001303.ppops.net (PPS) with ESMTPS id 3emrxqv5nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 22:25:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwmAf7Kur9mTLp2mwwQ3lHrrh95dEb7m6zz1Ml5k3PQAWb46cUxvFtHJpywLlctRnVPITVn6D16u6IPVppCtJlJKQIv4v2fjjYj3CPmWWjXYiWswVN9EhFpChYtwgnV4b1+IJrjyhHuFrYs5f+49r0LunbnrJQ/gfY1j9myFF4dklJxyF/gFCIlh/2sahqXPjKmOGJEHuwTzVNlEbduiCam7DcRfS48HlvjI51MoAETLGxZaGJvL8A7UA7G/hJbNBf/gDBxWHLg1BRTEKl1KxBGUIEOCbbYzUiiKdls5l56xrbo2+7ItvGw5XFPhPfvS04gg0I+dgqSu3TsSPjM9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugzOqAJQK7y0He1mIowjQIWYon16A6AygNmbNIPlo1w=;
 b=Vhv5dOjUlgXwh/rcCodPDq49gf9m6f3zIixICan5iqrzR3iakjnnK1UfoP/fNiTGr2wvjMlQuGBsUDfVQkXSYldHkQv3RwbABZJTs8Q8U78e7PRtjPuD7pdrI2N3SMhf/gkruhzlXyQQ5lXAxBAboSY89D15TB2THBteXONnBwEqe2oLKA3ugywQcXmtThMV1bnnavEek5DP07BX1TmGHxZ4OlZMQ1tBovKCFpVwLegfkVK6Xe8t95C2J4yiQ+gfeHx8KfOcriHtMM/hvwo0NTNht8ZI9UYllXD6dhfcY9pOxxqc57pbJNW8AWIhcuGX9zVcARNFkp8c3PI2lrw5rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB3577.namprd15.prod.outlook.com (2603:10b6:5:1ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.26; Mon, 7 Mar
 2022 06:25:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 06:25:35 +0000
Message-ID: <1ba6e143-d79d-e750-5cd8-62f3323fb22f@fb.com>
Date:   Sun, 6 Mar 2022 22:25:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH bpf-next] samples/bpf: fix broken bpf programs due to
 function inlining
Content-Language: en-US
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220306121535.156276-1-falakreyaz@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220306121535.156276-1-falakreyaz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:300:116::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3887fb3-9679-4ab6-1462-08da00034a03
X-MS-TrafficTypeDiagnostic: DM6PR15MB3577:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB357700A2C2262F0BDCE712B1D3089@DM6PR15MB3577.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDUzaCVAx+oMTtaGYK+lF4QI6z5Isjm+SsHma9UVmgNLs2DGShSm6Sk9Y05hY00gYdMmOWI+WOxeCtxjhlUQAsnaMOxUQV4H0WQmTlNT6ITtiaAGCBvaA0YHE1FWvui881FwJD2MfUy2ytPi8IT8tlpfLdSWfvIwktkmKvkayHk395zObLRrMkmlCyF3JtpoFSG/SjnGDzh7SkbHwgMyIiETc5hhRfaJePmjThwFG3JqyeqCwpVcfj52HEyxJmiyCxWGPF6eRXUaqUsG7Km0AOyvNlm5PSAFSHI8Q0xKTF24BK23OZSU9oh1HGFxdeC6i4aQQ0ffvevDN/LB49uPswc7L0HmvWBvZDffp8sXFf+23WMEbpdLX6PFrCAu/yaYy7qbOrTcBePgGqHtoIdWWDrI1MfSbWCqlIYm+t1+cru4Ew7n5Njea+gv3MMCPgtOCNaQbTWSAEp/Gu/jA3l8rEqamafjdEyIGwdXiqExYS2YUWZFVH9Zxndh8MbqvQ1UBSy0eOoBQYyyz86EdUZyxmJ7u7bOHBkI4kKOd7j0vxtNCTpAOWtbh8F59H/LhXxtTqBOhUthON/mNLH9oCqzptFTiaOyqUtyQp8FwffESZmh7dE6MEb+quZMHQ3tna/lbAnHkwhtMgFpVJyVL6HyjyTHd7x4XoIfM84Yf1onTDir2QqmULFBGfoa9z5h2NDJfvmmDygM2lhp5d8119IdjfYl4lSwifaLzHU1TKNpujY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(31696002)(86362001)(66556008)(66476007)(66946007)(54906003)(38100700002)(110136005)(8676002)(8936002)(316002)(6666004)(4744005)(508600001)(2906002)(6512007)(53546011)(6506007)(36756003)(52116002)(2616005)(186003)(31686004)(5660300002)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlZjMisrQjdySURhYzkyN2FSRytjcjdua01meG1LSGV3dElHYjRKbW5VQWNB?=
 =?utf-8?B?NmdqbnhLcHlwckozMWZCWkhBRGJSQ1VUYWUzRWdKaDJ1dEVGUklzYWE5bFRq?=
 =?utf-8?B?WEl2UncrTVQ2eWkzaHZkQVdqVGRyRUpyVEdlcXBmZVFuN0puNERZRk9GS041?=
 =?utf-8?B?R0hLZHN0R0dUcEYwRzV4MlRUcngwcEx1UVZUMkFOa0xYNU0wOGtRd2pzaU1N?=
 =?utf-8?B?Q0FlV0pOUTVBWEdrM2pFTzRIUTBoeitKTUtHUGFody9PbTN2RktheWRJeTFu?=
 =?utf-8?B?RXU5N2cvVVpINmRlb1V2OFZOVXNHZkIvYXZUbkg0MjJjOEZyZCsrdUttZVgy?=
 =?utf-8?B?VVROR3NHdmtXRHlPN2IxNHpJc1ZMM3NDQnpvT0xjMHVDTWZDZU9MamhzQ0V5?=
 =?utf-8?B?M3RHb2t1TkJkaGJvUkM4WEd5Vlk1Snc1R29aaHRGditWSDVJN3JnYU96MzRZ?=
 =?utf-8?B?MzZSeGpucHFJYnA3WGZXWkhsUGc4d2JFQ3RPRFdEWExhTXFDNDE2NFBocXJP?=
 =?utf-8?B?cHlTbmdEVG5iRHpHemluSEVRUEs4T3dmZW0yRVlxWkptTlVjeGNvN1NPOGVr?=
 =?utf-8?B?MXVjZzg4ZUlJcnhETWFFUHFqUzBSSGlZUWtFZy8wVFpjUFZQY2tyL081cDVj?=
 =?utf-8?B?V3ZKTkVBdDV2WERCUW5SWk1KNEQwcVpKaFdKZ3diN0JrMXl1OWpvY0hwSVdK?=
 =?utf-8?B?N3FzbTNQakJnUm43VjJmc09qSXJmRUZVMDUzVlRhVzdZT2JLTGhnRmZsZXZT?=
 =?utf-8?B?ZlRMMm11dk85T2t0a2FtKzcySTJMR0dEN0treXRFajU3TEpJeXFWME4ySE5L?=
 =?utf-8?B?RXptV2NzME81RjBwb2xKU2svUHVvYk1jZ3VnUU9QcVVUMXJka3o5dDUzS1Ro?=
 =?utf-8?B?Wnd3UmRBdGNYRTZKVWdKVFcyaklYb3BYclBLWFljRldBVFEzenhMcFpIdW1M?=
 =?utf-8?B?eERQaDV0em8zNm9hVUlFUWhTdEMxVTdVN1NYWG1HL05yZzNrdjJ5RVUvNHZn?=
 =?utf-8?B?OVJnUjhTb3hwZWpyZGU1ODBDbnUwZENnYWYzSnBaMHZqT3VjN3laa21Zd1Zs?=
 =?utf-8?B?VSsvMEY1b1E2UUNGdWhLMXcyZ0NRbUh3YU93NC9Fc3kvbFMzeU9CYy9OZkl2?=
 =?utf-8?B?eUVYcGQ0R0cyVXRYbzZRWTlhMk9LMnMvdkUvQjdFZ2N4NW9mMlRSd21WeGdI?=
 =?utf-8?B?MktPYjZFQ2RjUzI5TWxnYVl1T2JOZXpSalFEZGxZUVhmNFhoMDBHYkZINkZw?=
 =?utf-8?B?bEpyU1dFUzZsclhTOU9UamdRV1o1M2d6enBlK3F2WHpSWW5nWlp0VStZelRB?=
 =?utf-8?B?OE1PS3IrR0ZRcFgraGxuM3VHT1NOM2xVY1ZVWUJRUkJVV1hvMXorNzNFcGdh?=
 =?utf-8?B?b0ViQ05ZSGdWL3F5d0ZrZk5UakNmVU1pMWQ2UEh0OXd4c2Z4QlQ3Qm9zakdP?=
 =?utf-8?B?K05EbG1RNlpLRGFyMVdFRHA5ZEp2UnFSYjhFZHFTdWpzTmZ0VFZyUWYzYjdp?=
 =?utf-8?B?SmxETmtKVmNPMzdRQ3ZNVFNpb1NCRlFRUm5nVTd6L0hMSzFIZHdDRkdUZmpu?=
 =?utf-8?B?RFdadnVPT2hiREdTM1pHUlN2ZXh5MDNIVVV6SnIvbE1HdUN6TkRFeVNsTFpY?=
 =?utf-8?B?ekJ1NXphZVl1aTdaVkpwYU9kMVluamxGWmZSSlYxaCtVeE1teXd5VkNyVUg1?=
 =?utf-8?B?MWlENnNobVI1MUE0S0oydzlUNEhMMEVrSUVoVEpPdlExWDZabE5EOFkyZUg0?=
 =?utf-8?B?Ump6TFpWQnRYclFjNElWeURseklDS0o0SkFDTzl4TC9TL3B1Z3lJczYwRk5K?=
 =?utf-8?B?T2x6M0hVVkIvNGluRFNFOE4rTkhONS9wQ1k3UE9uUXZTcmVJaDZKR2dzaDJP?=
 =?utf-8?B?Q0pqS3laNU1CTWJnVmhzMk9RK2xxUHlxc2RoakppeURCWmpSMXcxRWgwRDNP?=
 =?utf-8?B?MEI1RTB0dWRkNHNEZitJelhjWUxMcytpdzBGOWMwcEcxV0ZyZ3dpcUp6a0dH?=
 =?utf-8?B?aXlLcWRuL1FWUEc0MXZOaDdFQ1JYN0YrMkN2UjM2VjRrTEhra2pEV0dobmpt?=
 =?utf-8?B?SVNsL0NZUWp6NWZIbVNpM3poNUJ4Zlo0R2Q0V0JINXJtNGVZaXBZcUs3YURG?=
 =?utf-8?Q?6HwMYWboB8pp3UVakAe5UyQGx?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3887fb3-9679-4ab6-1462-08da00034a03
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 06:25:35.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6Qfk0Ir6k/Og1WgYBAerKjI0i8JqE5pfLc4GdmH3sy45d3baVMId+iSfVonpFdl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3577
X-Proofpoint-ORIG-GUID: QThnY50r6JKZaZdugyXkLMWYfV7WnV9-
X-Proofpoint-GUID: QThnY50r6JKZaZdugyXkLMWYfV7WnV9-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_01,2022-03-04_01,2022-02-23_01
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



On 3/6/22 4:15 AM, Muhammad Falak R Wani wrote:
> commit: "be6bfe36db17 block: inline hot paths of blk_account_io_*()"
> inlines the function `blk_account_io_done`. As a result we can't attach a
> kprobe to the function anymore. Use `__blk_account_io_done` instead.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
