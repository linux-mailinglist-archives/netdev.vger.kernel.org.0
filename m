Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EBB645F36
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 17:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLGQrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 11:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiLGQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 11:47:48 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E803206F;
        Wed,  7 Dec 2022 08:47:46 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7EoEmQ018398;
        Wed, 7 Dec 2022 08:47:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=UhB1+uMsEq+/IEPOUN00MW3NiEgco4q0Rmk86sWWTVk=;
 b=eSuuN7A6t/22e1LRMg++w6mBVXSmjSboKqj7CUet5Bg4mfuhbIQ6Md8WjendrvRFRSUM
 4qXmuI2FebsG90JyDUUKSK7Me6ZFh8KrAQHUJ33vFPKjbTuC29veZ9YStLABUD0FfoYN
 ZxjluVY+F/DGe/B35RdiADn7UXBKqti6++hNQ8eIAhoaFsGuDFB6kqhRKtxEEZDCAbyt
 852GEYFF/7nVxUIUZ+4tPwDus9A2TC412enQlvUBZHImuO4HeVD6S5juQoDeLyLQCWHS
 ceCrwwgecwpOJ78LttMB5QrWB0jGYMuLBYIE6zFgYvzd+4drRebIJw07K5l4RP3IIHoj Qg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m9x71462k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 08:47:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4M2/vkR9J00ynYu0h4Ylx2ENdLjUmNiiP4nhQCjUOksByjYrv5CxXS40lztyZb2CyylBWXRiBpox/k6F59nP+Sa3EdvCxPx0t54fQJp3IR9gZqagxsW7UPOZ9J5CN0IpfpKrlurgntMsD4s5nfFp1AiOI2daPwx35EBYSIDPLZ/oxp6kMbESCSp30q2t4rgHPCWyo0cIdlM2UreDncgZIwPfRMq3JgdMq5f6aDdY5P2QbU8dOslINGDmoqiYdmeysVfAw0f6FWXeALSjkrdIArQRa1W7HNVqan6ESvCkbfggTUJafwSykifZozmitOjHHXmKXpJmc6aThOTEpvCoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhB1+uMsEq+/IEPOUN00MW3NiEgco4q0Rmk86sWWTVk=;
 b=Hzn7o7AJo0Ud2W4HNtZ+qFuwhN+Bg1pGARWDOtzsTSXLFHuytcO6ER8Sl8P1jvU6BSIz0/Q3fs3rsgcoG385dieXT1nZl7DIuXyXFjsnVHweqlysMR56MnL6sQGSoe0tvFzp+1itRzju/7/xf6z2hEfdvrmzAbOoLdXCWaO1GmdFPRWlz3aMFZUX9e4oG4IOY3TPYY54C7jc0cg7PT2OoOaT8OSuWFbuOlWwXofiRkDoGkvNji9mD5hwSgW3UtfZDyMp7wwDPSIRo7pQbmgOeeUns7MZT0QxAtRyrVRD2U5vOVugMJzINi9io6jtYhdc85AWApMROOVv7+RaRDxWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1274.namprd15.prod.outlook.com (2603:10b6:3:b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Wed, 7 Dec
 2022 16:47:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 16:47:16 +0000
Message-ID: <886b6647-fe65-39d7-dd78-86a5f5d2acc6@meta.com>
Date:   Wed, 7 Dec 2022 08:47:14 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH bpf v2] bpf: Do not zero-extend kfunc return values
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Brendan Jackman <jackmanb@google.com>,
        Yang Jihong <yangjihong1@huawei.com>
References: <20221207103540.396496-1-bjorn@kernel.org>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221207103540.396496-1-bjorn@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM5PR15MB1274:EE_
X-MS-Office365-Filtering-Correlation-Id: 599994de-7dfa-4f8b-8e5f-08dad872b2fc
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDU+OrUt0eSbaKiGOjsCFP2P0z88upzYB3aQPS1Tpoj7mQ/ZqahcBBocZRcY3L+qbcMeH02pJ7hYUVZ/HET7nvqxjeFLINtKQQGwN2kfzm5dWtLYNUEMZh0uVOJViauCVgUIqnbf2FKE65a/XkpOWjCC22lPv5XirZdoLdV4FEtWq0T/2x/OR3iHDkLTp9sXwkhXW5ZE7brhY57HoP2aGJhWwR7UBGDZg1mc8i3r+svFzI9hYFSt5qYeg1pVnABJu6x5qbuQO8vJO/xKxbkwUKXDiTTtWKh+fmOV//Qo8fzp3ndpcO3Tebk+qlfpH7IeEHSHUXcfwypKG5yJ7TJa6cq32SNq+twscskc+eV3JAaQcvc2oaoAibwLivfpYXeGIiZ0UcewohDus2UyuzKxIuHkYwmdrrVrnfoibpB2adVFGpyrinzhFDdoSnNhdHzcc/sfeD/me0S2E1/OHSRxVNzFKZSXOaHBuT5+oCPKQwUZRya2U4cvfLjSFs60VkAXeQa9WcJbmxeO2Z6hYrKiZ/Vpd//7HR0cWrzHLMykbahCaVPDSnA8FVby9o9lUsAdUj62NEcm4ok5Bify1hmfyNDwxxg8U55S4mUpUBSzVmsSSYDon+2mlxwf6B6MhHu4Yx5jqD5H7Sl9bJ4xZcLeus2Vb8jkXx+O5fY7uABiEUGAM5CsGJL4KIIqN7JQKQ3MWtLKtXb1MJtUPNIcTwwOQQiVbpm7jrMjsu7UI2uZMxkZiVnZg8HRg7h/bXb4KLOB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199015)(6486002)(2906002)(316002)(4326008)(966005)(31686004)(53546011)(478600001)(6506007)(110136005)(36756003)(54906003)(66476007)(8676002)(31696002)(66946007)(66556008)(86362001)(66574015)(83380400001)(6512007)(7416002)(186003)(5660300002)(38100700002)(41300700001)(2616005)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1F5VkNnVEtKL1BlQU5UNzJQTUlkSTloYUs4c1ozUXdYcWpRR3dvNVNyemhN?=
 =?utf-8?B?MkVOS21rWGtqR1ZoVmRDbUhHODJXeDE3VTZVTzZuNk9sTFFmWWVEbkxicDVI?=
 =?utf-8?B?ekZvZW5DQTF6UXliVHpzcjhROFBGZ2R6M05HbCtjdHRValhvdkZpZmhXRXd1?=
 =?utf-8?B?SEd2RUtrSUsyKzF3SGIzV2ZxbzVTUzVQK1NVU3FGZVJFbTBmVXFTKzlEclZa?=
 =?utf-8?B?Qk15U2pneFZyNzllVFdOQzZYclNxck9yTXkxcmtDSHNsUjJoa2F2a3c1YldB?=
 =?utf-8?B?eGpKWlJQRlk1N2NEeTFncml4T3IrK0tDU1RoZ1VGajFLL0xSbmgrVmNXQWlQ?=
 =?utf-8?B?d2N3MjNSbUZNUUhGOTZ1cjJraG80WkNWN0VIalRuOWxHQ05PTnY1dnR4Rito?=
 =?utf-8?B?OU1yTSt1ODIyd3RwcjNycnJhbTc5elV0cEhZd09BdWZIVHhvUzlLNzYzRzFL?=
 =?utf-8?B?NjJhK3RvQWFUUHA2SC8rQ2VnSytlWi9ENSt4R0E0V1F0SitWTWlFQXZyVXk2?=
 =?utf-8?B?OFhkcnlNSTlyd2VITE5IeDBvSTdnKytERmJxcjNWMmRDUmtqb3owb1IxcHFO?=
 =?utf-8?B?OHA2TlhCYXhCYjV6OG02ZEdVN0tJTUVZdGxvcGplSGpBK05ock1wU2JFV2hX?=
 =?utf-8?B?U011QWozVDJKdFJpYko2dlVqTitYOWVLQ1R5TE91Y1BrekxEcXpJZ1k1T2o3?=
 =?utf-8?B?TmJURTJvMElhZEpYSlpoVk1sWmhsVVlXRXJXWmxxb0dSNjFLcGMvdE9VaTJa?=
 =?utf-8?B?NDFLZ1FQbmZBVGxUQmN0QUFPVGx0c29TVzF2QUNqck9sVmJMZFlZYUE0aHJT?=
 =?utf-8?B?NTY0c2UwR2lIZzJRcTRJQlhGd2hjMTZmTVlLNnFKVWZQY0NOTVhSbWx2QXJS?=
 =?utf-8?B?L0NtTWJLci9vR3pVQVI0ZU9GUUM0RHdpa1Z2Sjl6WlhpT1hDWG83MlAvcE1h?=
 =?utf-8?B?dUM5ekxQaXIxOWhVSnB4cEhEU1hoZFBiYkFxSEVVMTFzaDh6TU1CN3ZUQWJM?=
 =?utf-8?B?c0VmQnh3K0FJSjY1RXY3TnZTMVBTRERTOHRIL1FpKzZOcXdJZE5YYlFoWVMr?=
 =?utf-8?B?cWh4Q29lQlFFTEhBd2k3Ky9vZXlwTkkrWC93cUFKWk9jTExJNXVYWThGWG04?=
 =?utf-8?B?NlNZVitnc2tmV0lTY0RYcGdCRTJkSXQ2TW1WbHNOSVBKeW85d1U0ak5yakRq?=
 =?utf-8?B?S2dVVmtFS2owWFZja3pTTG9scmliYWJpYW5wbnZNZ0JScktEV1JDek9rZUt6?=
 =?utf-8?B?MGhYYXNLNEg2eHFLLytqRkpoSUx3ZXNlYnZUQzVXMHlORFgzekpMd0ltY0lU?=
 =?utf-8?B?SEg0d2tUWWRJK0tucFAzdHhXRDlUcHVkTldDL3pVNlBKa1M3OXRqdHlEOHJP?=
 =?utf-8?B?MXg5RGpRYVdQTXN4VVpUVHN2M1NUMWJUWER3U2VpejFqT2IrQ1hBSWJnMlRS?=
 =?utf-8?B?OFVIRlJvSTB5RHg3RWNTSUQrUUJQZlk0REMzM2xkUktKSnBMT3hXWkxwU3VI?=
 =?utf-8?B?ZlhIZm9GdDZXU3pyWVZ0aFhONW1ZL2c1cjVveTJzVThMbmR6OXhPUE9Hak01?=
 =?utf-8?B?LzYzRW5oQjJnT0hCR2UvYngwRnpYUUR1dUVtUHRVYnZkR0tHZTVJQnZucUZx?=
 =?utf-8?B?dVdQMU1DbzdaZEMwcTlySTR3bU1sOUpLSHk1WXBFd2x4NVlYeWNvOUtaN3Ro?=
 =?utf-8?B?bkVwSDNvZFVLOGx1TFpqRFJ4aUphbGRvN3F2TXVQWDF6ZVk0UTlXblFDY29j?=
 =?utf-8?B?bWVnU0dEU21xV0ZGbC9QRzlVSDB5bEQ0bXU4d3RVS003UmdSQnR1eC9YZmJy?=
 =?utf-8?B?eFZ3MHNoRjAzcEluOUFnNmpsMDZJR2pqdFhoK1MvamxJSjkwOEdyL3F5UUh5?=
 =?utf-8?B?RUtqUndCSk4rL05ILytmakZJVjZaN0VqWTlOTFVnZFVkYUxuay9xQXVKZkRq?=
 =?utf-8?B?dTk1WHdleGY2azJWZTZMb3ExMGVGSDl5V1pnVzk0TTZocUFITytWK0d4MEgz?=
 =?utf-8?B?ZVROclFYK0JVM3JQZDRmN05Lblc0ank3cEJJRXdmc3QzSGNPR1BZdEsydXdx?=
 =?utf-8?B?Vm9UeW1TT3F4Qmg1Y0VQN0VYNmJudWUwQUpqU1FBcFBOMkIyQnpxSHdqbHU5?=
 =?utf-8?B?NklqNm0zUU4yZloyNEtFMnBDalJrRk1URkcrVWlRZkRvNG9sWFRTSlVjWHpW?=
 =?utf-8?B?dGc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599994de-7dfa-4f8b-8e5f-08dad872b2fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 16:47:16.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrEU58Nroo5GWQqM5MyaRzAC+w/LgXQM+LmddJh1F/IXMcMBqqSBdrtSdnp8Z+EO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1274
X-Proofpoint-ORIG-GUID: 9-oUcnEN8fi-5PxJufgcBqFPzvylgOAu
X-Proofpoint-GUID: 9-oUcnEN8fi-5PxJufgcBqFPzvylgOAu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_08,2022-12-07_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/22 2:35 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> In BPF all global functions, and BPF helpers return a 64-bit
> value. For kfunc calls, this is not the case, and they can return
> e.g. 32-bit values.
> 
> The return register R0 for kfuncs calls can therefore be marked as
> subreg_def != DEF_NOT_SUBREG. In general, if a register is marked with
> subreg_def != DEF_NOT_SUBREG, some archs (where bpf_jit_needs_zext()
> returns true) require the verifier to insert explicit zero-extension
> instructions.
> 
> For kfuncs calls, however, the caller should do sign/zero extension
> for return values. In other words, the compiler is responsible to
> insert proper instructions, not the verifier.
> 
> An example, provided by Yonghong Song:
> 
> $ cat t.c
> extern unsigned foo(void);
> unsigned bar1(void) {
>       return foo();
> }
> unsigned bar2(void) {
>       if (foo()) return 10; else return 20;
> }
> 
> $ clang -target bpf -mcpu=v3 -O2 -c t.c && llvm-objdump -d t.o
> t.o:    file format elf64-bpf
> 
> Disassembly of section .text:
> 
> 0000000000000000 <bar1>:
> 	0:       85 10 00 00 ff ff ff ff call -0x1
> 	1:       95 00 00 00 00 00 00 00 exit
> 
> 0000000000000010 <bar2>:
> 	2:       85 10 00 00 ff ff ff ff call -0x1
> 	3:       bc 01 00 00 00 00 00 00 w1 = w0
> 	4:       b4 00 00 00 14 00 00 00 w0 = 0x14
> 	5:       16 01 01 00 00 00 00 00 if w1 == 0x0 goto +0x1 <LBB1_2>
> 	6:       b4 00 00 00 0a 00 00 00 w0 = 0xa
> 
> 0000000000000038 <LBB1_2>:
> 	7:       95 00 00 00 00 00 00 00 exit
> 
> If the return value of 'foo()' is used in the BPF program, the proper
> zero-extension will be done.
> 
> Currently, the verifier correctly marks, say, a 32-bit return value as
> subreg_def != DEF_NOT_SUBREG, but will fail performing the actual
> zero-extension, due to a verifier bug in
> opt_subreg_zext_lo32_rnd_hi32(). load_reg is not properly set to R0,
> and the following path will be taken:
> 
> 		if (WARN_ON(load_reg == -1)) {
> 			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
> 			return -EFAULT;
> 		}
> 
> A longer discussion from v1 can be found in the link below.
> 
> Correct the verifier by avoiding doing explicit zero-extension of R0
> for kfunc calls. Note that R0 will still be marked as a sub-register
> for return values smaller than 64-bit.
> 
> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in insn_has_def32()")
> Link: https://lore.kernel.org/bpf/20221202103620.1915679-1-bjorn@kernel.org/
> Suggested-by: Yonghong Song <yhs@meta.com>
> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>

Acked-by: Yonghong Song <yhs@fb.com>
