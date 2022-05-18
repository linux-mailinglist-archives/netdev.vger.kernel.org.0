Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03A452BF1E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbiERPou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbiERPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:44:40 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB6F267D;
        Wed, 18 May 2022 08:44:35 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IFiBr8014236;
        Wed, 18 May 2022 08:44:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ACd8YjF+oPDTpdUbk/qw6ki4siKgUq7M9hAGz1OFIw8=;
 b=VIIIndu3pZWSLD7/LEZtfSmTliZId+1VUsqPDMncU1o1lA3xHqgUcP20S96uo74HuWgx
 aA2GnXt5NouxwpCkdOzBvGDeWzB35RU3WnmivL+bC2FnXbjiIV3wQ0WeqX2modcGYExJ
 Wm3hG6LbQhD+FTjZ947LbblsuM8qdJ/ED+o= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ap6sr4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 08:44:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rzj0mbsI2F9lpl9M5KIREG2BHAHqJwUD7JjPqfIg30tmSQkS987x2rYbWFj25Vm2djforWIEBiTpgXm+yIef8mC8DQ3SnOm4cUTj/moaS9x42dOhVigvHtdCdm1KWTA2w+8aY9Gzf2gt40h7JtG7gUiY0jisGAoFAS9VLPbpktiizeblldalO3kbEM6rKxUBPPz1guN1GkTdAS1IGETOAZUQDLY4FVhKfxVINoKnQUJ5SwiUFD19gc8mq86iUWmBz1YRfoUSF/MNC3JMQ6uWXZJ7dWdn6YzH8U94e96VQ3GCK12abBCFARNLNL5/Ol78WtL+hLd95kVW9uwWh38odg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACd8YjF+oPDTpdUbk/qw6ki4siKgUq7M9hAGz1OFIw8=;
 b=dz98h04Gv3Sa1qkVgmcotfgIPewD0YIlV/EGMwUS+0IdbpiJCnDarzScVsQr5mkWy8qWyvp3LjobVwiYwdcBi+9uQEkVtMaw7uNMGogJtxb28hPa23S0eUHiTyXbVjX1WZ+MjOj+KeO81mZPWyRFLgFTbABnU2yUDZjUlapA4wieJP5+E35EedYA2yNFp8W1E2xP0KzoXGCrCm4D92Y7xf/5shqLFqWcgypGfdjIYUADgrjk3oPLMNJaHjBCoIhFNwmzBveeLdeDNFZcMp4F7mjuJ5gFSk1lsQKvxsratyBmETdpzi/1vBhTII04auBZgq8xVkMLtKlsbiXvjUhVjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5187.namprd15.prod.outlook.com (2603:10b6:806:237::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 18 May
 2022 15:43:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 15:43:58 +0000
Message-ID: <cd5bb286-506b-5cdb-f721-0464a58659db@fb.com>
Date:   Wed, 18 May 2022 08:43:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
Content-Language: en-US
To:     Feng zhou <zhoufeng.zf@bytedance.com>, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        jolsa@kernel.org, davemarchevsky@fb.com, joannekoong@fb.com,
        geliang.tang@suse.com
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        wangdongdong.6@bytedance.com, cong.wang@bytedance.com,
        zhouchengming@bytedance.com, yosryahmed@google.com
References: <20220518025053.20492-1-zhoufeng.zf@bytedance.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518025053.20492-1-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR01CA0058.prod.exchangelabs.com (2603:10b6:a03:94::35)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c115aa4e-8228-4f07-cc99-08da38e53882
X-MS-TrafficTypeDiagnostic: SA1PR15MB5187:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB5187764D9A49D95EC097124BD3D19@SA1PR15MB5187.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkOhgqj2n1CJOJJUVJNQjPz7zosQUFT3KUZSIsYDwhgXmWQULi66H++JzEHCchjDnr90TzkHHwfBDlCMEzUmu8ldUve731C3QyW+3pRCXEhIQuFN0oLbobJcEd/BlTonFMjOM3uWy6cndRCCOq3HN3O5VLhAB2cNP9kC7UAqw1YFhBCBsdryAGl03whRTd9yHcvUjYPigFVFMevb5ASmo3p8DAf0fdxAfWSyJom3349FwkJG+eRjnDiH1febY/N2ul/j0JL08kFnyq3E/n5pNuWA1VqO/mQruq89tb95JQLzkeHb/pjSlv4JVe2IJrhywVxpnEy7agNNhgLxm6GhDgiDKuFA2HdFwVpuWY7yhWcXjyRpd4movNVbOD9gMtSsPvNWX1iNgRwt+i70bWDer+2k2QhnKdb+knozxuDUy+o0Q6SIztunyqb49dZsFhk/259zzDrJLFD6iFh0u6oInbyB9SAOe+NXtj9XeWi5qaw8/6MJMnWjVO3ddQDXz5Emkum4+zOCC48yob6JCHjDbgHfQv2nPjyfkWdmogvskc9Cg4B/FAHyGZF40OA9iQELyOkQDn2L6NlJQemjnXFc2pBaJYjttv4ihRB0/xtM/gS4HumFqbcNxxsRZV2LHja0pU+NUhPgpsN1oSF33VlZmvQSPwZJyF1g2ayl1pUJWlMEd8TGOGmoaYSTIckgOr8MmlVCqs1NMOrHfkS2H4XhFULcG5VO6Arr30kap/DAd+IUiRMWdWoghsaL3MjQXHWtLzHXitCK0xHwjQuigwvH28DAlgUf5q535KImp6hDxiOuz+1yyObsUKt8s9lNFELIk0mCEyPJVxFpPeJZHHZcqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(38100700002)(52116002)(6486002)(36756003)(6512007)(4326008)(186003)(966005)(86362001)(53546011)(4744005)(8936002)(921005)(2616005)(6506007)(8676002)(508600001)(5660300002)(6666004)(31686004)(66556008)(66476007)(66946007)(316002)(31696002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm1PZ012NzhIa2J6WFF3UkhuOUs3NEZFcmhJZlBPTzJLT09TakxuK28xbUs0?=
 =?utf-8?B?TlNDVGN1QXQwaGVUTUVtY01vQ09YVjkzeWJLdy9aQUVuY1RTVmlSNCtyNGhz?=
 =?utf-8?B?bjJqRFNiRnorVU5SN1N6NmF3T2ZSbHdQYlZxOUNXME84TnZQcC85RGU3ajlt?=
 =?utf-8?B?bkVodU9sS3B0cjZGUWVoS245U2FHRDh6ZHJjK2w5U25BUjVxb3p3VURNeEpL?=
 =?utf-8?B?ZysvSjFEQml5M3BxZk8yejcvYWZVSjFFNXJxNFQwV3pIbjduNTdESzJ2OTM3?=
 =?utf-8?B?MG1kLzJBaVB5bk9ORWJZTnFwU2k2aU0zOWF4Q1FoeEZHN0xBanJYbnhsVHk4?=
 =?utf-8?B?TjlaalduaUtvOFBZMkZtWVR0dXJCbDJXSE5OWjdJVWtnMHRnSjljallpRWxB?=
 =?utf-8?B?eU90d042WU9kSG9MdjlqRER3eFo2R2xUVHQ3N0RFU1N2VVhWeHJiRUE1cklB?=
 =?utf-8?B?V3JJUllLNUhoWGREQWxvT2UzSFY4Sk5BU3I5WkVtMnhhVGdOUW9HbEx1bHV6?=
 =?utf-8?B?dU12cU9ZV3R2TW5DajZsQXVDYUNoUG1WM3pMR2VKblRPTnhtL0VENVJBNE1k?=
 =?utf-8?B?Yys3REJKRENudEQ5TWthY29sc0VCS0NtTmxYanhqL1kycjFXUm55SEcvWFV5?=
 =?utf-8?B?NW9Da2FWamo3YXRadTBwV29STVZHejB1U05aakJOaUVqbjlUdVNhWnc5R21a?=
 =?utf-8?B?cDd3RjllVVlBc01UZWVFWWNhc25iVS82cnVFb0JzcGZtOEgxaFhpa3FZc2NV?=
 =?utf-8?B?UlpNOE4vaUI3WWVKdWdtYkx5TWUvbmJGU2kvMlVIWEQ0Q3h3KzlzczQ1RVNy?=
 =?utf-8?B?MTRBYzJza3BacldnQ1F3bjlvd3ZyamRTYjZTM1pQZTNybXlyVmFGT1dxTjli?=
 =?utf-8?B?VXVUaksrWDQzblF1M2VxTE9FWDBaZ2xQNnRWNENxYXdGNWZ1ZE5ac29TWEhh?=
 =?utf-8?B?WCtiZEdyZnlQaVhBTUt2dTZlV0xuTklmei9NeU5ia1M0TVhmUHc3bkZQakxn?=
 =?utf-8?B?cFdjR3pndHRXRW85VWQ2c1BaRVVoR3Y5dU40MlloTGpXVWY2RlJaK1dETG5D?=
 =?utf-8?B?K2xRcko3NjRFZ2VCRDJWV2orK3hNT3cwdHhSY251QUJPSmRZelAycEhIQ0Rl?=
 =?utf-8?B?bnJXV0M1R0UzNkZqbS93VWNMMDNkangwZnV0emRFd003d2VpVk1rOWZDQm5L?=
 =?utf-8?B?djNzSXhoTXFlellWR3VlMVpRNmdYVGtpbFF2TGRGWkJUZkFyVDV1aTRScGVw?=
 =?utf-8?B?d0xWQnI5WmIydlJ4bzU4by9wMUVqcjl6S2ZIT0tZOWNXbExobi9wZW5tb0tC?=
 =?utf-8?B?L2Q2aTVic2I4WTFYbzRpNkFUb091U3FIcHVNM1EyV2paVGc2U0V0cWhqQzMy?=
 =?utf-8?B?c1d3K3hJVmt6NGRqUzByM3RqQUVhblZTSzl1RVJYU20vL2tKT3RJclFENU40?=
 =?utf-8?B?WGRsamdOTkdKR2RZOXlSMDRyWXVsQ3ZReURFL3RMRTBmYys0VWVDRGZIQW9j?=
 =?utf-8?B?dnNZNitKMko1S1ZzdTdKN0FqWHJtQjNHRkE3azhwejkxdDhSK0xtR2NpMXk2?=
 =?utf-8?B?S013VFJSVHkrWG9lc3RRUnlZMmxKRTZJUDlvOGF0V0p1eGNjNXJZVzNaZjVj?=
 =?utf-8?B?OVFXelVKbGhpUU8rVHVnd0xNdFVEcW43Q25hQVQ2c0UrVGMzUEV3dldablVS?=
 =?utf-8?B?QXZ1SGNubkpwZ0llRkpqZC9mYjlKd1hFNi94Y0VJa2l5ZG1oWVFFbUZlODlW?=
 =?utf-8?B?OFZDenhNdnNCTnpzWWU5QW1tUDFjU3B6UktxMXlHSWpCVzFZUmhNSkxXZFJn?=
 =?utf-8?B?T0xQaGpUcDBpMjdhYzBxV0o3YnJXNUw3R2cyTnJrMHNselY0Y1Bad0Y3a2RM?=
 =?utf-8?B?N0Y4eVhlWnpLOGFnMWVWWERUS25CaEdRc1V0RzdDVjFqUmhIeGw1bDFVcmVQ?=
 =?utf-8?B?R3p6UVNmMW8xV0w1STVpNmVnSHFTMHoxTWpwOTdtV0tsbzJnbkU2VXUyNURw?=
 =?utf-8?B?aXNLbWVFU3ZVNnljSmxacmkzRVJNS2hYaHQ4UVFmc2xsVjh6WDRSbTMxeTJQ?=
 =?utf-8?B?WXNtbW5nMnJkemZoQ291SXBxa0xGeXBRUU9nd09jSXdiZlFSeUJMSElUSThS?=
 =?utf-8?B?d2prc3Y5ZDVnbmNPd2x3dmdoeVNXK3ZQeEpTeXJxTEVBc3hMQmFoYUR1TGM1?=
 =?utf-8?B?M0hMQno4YkJaZXNqV3BpWitFYkxmeC9ZVE15VE9LSTRPdHFyK2l4U2FabWg5?=
 =?utf-8?B?K0plcnRBaDg2ZzBiMi82OFQxenFSRFhvQ3FMVXd3REJuZStPUGxVWHBzLzdx?=
 =?utf-8?B?allTS2lhZ0tJY092YlljMWU3WnNuTkFHUEFRUndmNlNXTjJ4RWxqemUrZmt3?=
 =?utf-8?Q?bFoyhpjzY53MnsVk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115aa4e-8228-4f07-cc99-08da38e53882
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:43:58.3420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1j6BcqFbaQosyISAHYO/44iqUwBPNONEdzS/qkhIrIQe66VhEn+o7FH3Z3ErIZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5187
X-Proofpoint-GUID: Zbe5rTmJQtN52jeZvChME12dm2rBDwCC
X-Proofpoint-ORIG-GUID: Zbe5rTmJQtN52jeZvChME12dm2rBDwCC
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/22 7:50 PM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> comments from Andrii Nakryiko, details in here:
> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
> 
> use /* */ instead of //
> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
> use 8 bytes for value size
> fix memory leak
> use ASSERT_EQ instead of ASSERT_OK
> add bpf_loop to fetch values on each possible CPU
> 
> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>

Acked-by: Yonghong Song <yhs@fb.com>
