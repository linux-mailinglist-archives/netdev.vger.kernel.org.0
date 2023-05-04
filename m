Return-Path: <netdev+bounces-313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C14D6F7033
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 087EF280CEF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC128A94A;
	Thu,  4 May 2023 16:49:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9923A7E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:49:39 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D03146AD;
	Thu,  4 May 2023 09:49:21 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344DO7CK013839;
	Thu, 4 May 2023 09:48:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=zdXbLe4Bz/24jLJMp1N+ygWYhYTl3gaGkigGnxCzWDQ=;
 b=T+DPBJA0FhhltfVV4Px5UmqdZDzvEp1NxQ7bAmemEWWe22krmEiMxmQjusJtjI49eVm9
 qra7FT5jMgtsP+QhoCXXG8BFBfmqdZv4uTh5/gPEf6q/rwVPZYUsFPkKBXGhVFTE7+d/
 seFY97R/i0PjSB5Jp3mdmwJ41Byd+BmRZsxkWvbNnVcYfrmxYvucTCDLPWYLNJ+JQYsp
 npFgnFGZbFfIt4HLL8SB4aJ+AxNF0Lfnvi5Xq66dIXOLGkF32yS1kndFQoIJImzADPyw
 l6rhORW5AM4fk2Dcfcg+EeIXcgUnF9KfFxg8bUulheSCYQ2MEgyPnOJxIA3R7ZVGwsOP lw== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qc2g1dba6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 May 2023 09:48:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAFRyrJHNfjdrf/+K1Utr1Ls9VTQBshEP6Kt9AqmjNmMuL8RBBo7PnZ1vbHv+DLvmCLquZ8eOy5/a/zylMNC65U0IYgKENYRqCBL5S8TbxSiA6jXkE8L/r/3owm7uQBwo2XPwunIbYXWEj6MNyIb4huLtk6MJeNect8zyThFU3jSlB6ZbIHpON9Pcjz+LBYDCca/Nf6bB76Ek9aFf6+Gh89S8/i2KrkUSgDn/BB8g6mWFiHp8sMF8U09ax4kLQc0bz0sFOmFABr1jrD39mjJI3sYoSRHwQi4aU3hDMj0AhRzzVt9HVNhmFGc+AhRF99Hm99dNIU2pIvfpgVKRdeZRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdXbLe4Bz/24jLJMp1N+ygWYhYTl3gaGkigGnxCzWDQ=;
 b=hRl498Jv3XFW7Rh2nL/KnPSbL8QWLtpgzb1vj8Caqn9nG+t3rKdZm1s4YftOhPMv+ZJqwRTft6sUvP+sXeZ7bYEmCUmGx81Ws6kWGcEHip98rMz1D0D/25MW65Fu/UQS5ZBs9JYvaT0OJ70qsR/X15oQnBAo8ZtEmK1VfYELYqzbiiD3fS12AFbQ3jt8xgafSgLL45Ur4CErX/k7D2Op5xMx4kpM5siahYEB9VNLKtEODtRV2lQkBnPBar/Sq8OmjDdE9ClVAr16jvelcoqjqtozOEr/1zoD5D53LVDKMVaWIzejdPC5FTg/hFNQSQBclHFXJgjwRS6HzEjFP8mnSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW5PR15MB5241.namprd15.prod.outlook.com (2603:10b6:303:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 16:48:27 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 16:48:27 +0000
Message-ID: <0de3722d-7111-246c-b558-b26d032dc5d0@meta.com>
Date: Thu, 4 May 2023 09:48:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH v2 bpf 02/11] bpftool: define a local bpf_perf_link to fix
 accessing its fields
Content-Language: en-US
To: =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Quentin Monnet <quentin@isovalent.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Alexei Starovoitov
 <ast@kernel.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi
 <memxor@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-3-alobakin@pm.me>
 <20230414095457.GG63923@kunlun.suse.cz>
 <9952dc32-f464-c85a-d812-946d6b0ac734@intel.com>
 <20230414162821.GK63923@kunlun.suse.cz>
 <CAEf4BzYx=dSXp-TkpjzyhSP+9WY71uR4Xq4Um5YzerbfOtJOfA@mail.gmail.com>
 <20230421073904.GJ15906@kitsune.suse.cz>
 <CACdoK4+KdM-sQKMO9WXk7kTL-x=Renjd0MuvSRT3JKbtzByyHQ@mail.gmail.com>
 <20230504081858.GV15906@kitsune.suse.cz>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230504081858.GV15906@kitsune.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW5PR15MB5241:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d3e39c6-b5ce-4bf5-3103-08db4cbf61fc
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	v4mdsjuBngR+0Cv2csNYH/Q26EISdpD+RVPTway1jGXHhZsacEQ6WlPrtIZJjhe8tPa75DvD2NvhpKki8NJuPx2jUfpQwuVMQyljptadpDo3iz3YrMgfRj2obDNXd1WR6JJr+/5mRDkyeoBMlX1CSBU2F1jpMOcty2dgLgo9sWvuelFOXuPkMvCYflh+iJjUyT0D+cLfeC77wpsb1fiNwx52EiBlPRIcjkSCtFTZ3HvlGKwnOVqfokxb9eD9ILgtB8bMxgyyqemMSduRCHVcu6NivjwHLiRy4s6334ixaGTSwNv0Y/6LsMFs2hnWXRmkel7jbKrWz0qF9wiJEuu6f7XEudbhjy6IX9aT7ajJ6ELr7i5okvpdqln2jGDVJuf2k7VF3+p3w/Lx1wp2AUmNBfzK6QC5nt1dmb+1oLvwbO0jHsysZu4Sbshe1OYSI5evYy5bSuNnLx4C70onzjIcC5HwbSUVWqdJ8MYbTDpzLBQFoQfBh7jsjtAxEx87ey0FCCli6fNu85rLRRNyqnqDNfidRbgtmKYFkdWPY2dhaIGwLLsq4G3AL93/En6iPBm/zNtc4dEa39SKPuFWzwvfy+/AFkPIocMbNeOpmeaGOsweLizCB/H4qQmUUKVAxOz/b46IdWLo6oi8XzpmyO++Xw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199021)(31686004)(36756003)(38100700002)(5660300002)(7416002)(2906002)(8936002)(316002)(86362001)(31696002)(4326008)(66556008)(66476007)(41300700001)(66946007)(8676002)(83380400001)(66574015)(186003)(6512007)(6506007)(53546011)(6486002)(478600001)(110136005)(2616005)(54906003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VlBhNDVXK01mckVkaWVPY1JuSkFiVVpUNlRJNzdRN2V3UjN2SHlsUWhrZnl4?=
 =?utf-8?B?TjNGRFpKVDR0bXV5TzJlVkFRa1ZKV3loOE9ueFBsMjZFdHM5YlY3OFpRQjNw?=
 =?utf-8?B?WU1KRHR3STkydUlEYUg2OTljRksrV08vdm1BT1Rsck1NM0NoVytlRXNnWTNY?=
 =?utf-8?B?dHhHYjB5WTBPRGNOcjRxZUJUeG5VZ25tMVdSVXZzSTc4RFpCdHU5dDZGckR2?=
 =?utf-8?B?MHcwYktoZXR0Mm1tTkphTXRraTIzQnJlQjZtM1JCeUZoWVhxYWZ3MmFhY1R2?=
 =?utf-8?B?YWZBV1hxZDcwVXVDanB5b0liTytwd2REc3J2SFo3NDQrUzkxTVltOHRGSnlW?=
 =?utf-8?B?RENSU01vSEVDZDFJR3FXVitjQlRyUnc2Zmd5eVFPZEh4SHNDVGp3M1lVOVlK?=
 =?utf-8?B?UG05YTZFRUMyVG1ObkFma0tBMGJTWnJhQWVTRjhQeEF6TnQ3ZTkzUU84TDJB?=
 =?utf-8?B?WWZqNUxIa1ZmQnQ1ZDd6L01wY2dTSnQ4ZDBIWitXbzFCVlU3R3F5bGhMNDRK?=
 =?utf-8?B?MGJBekFiS0lWTFM4Z0NLTVV1N1FpOWYvQzJneEg4ZXFLaWNkREF5OEJ3ZEJE?=
 =?utf-8?B?di9aZHpjeVMrY2UzdWd0SFBySkxlajQ2cTBTTTlqdStMdGdDWG1yOEVXUFlK?=
 =?utf-8?B?akwrd3NRN240OWNnYkk2TFBlYTVzdGxJUjVDcDdyMk91V3JKRFJtb0x4WlAx?=
 =?utf-8?B?SVFEWGN2TXJtTjZFMVhtb201RzBaSC9iOU56cUJrVVVCY3RxdktwTVdkVUJj?=
 =?utf-8?B?L2IxZy9ybVp0SGo0K3RwQlpaMUR4dko4dzdkK0o1Mlc4TXpQajk2MXVndmZ2?=
 =?utf-8?B?SG1meWUxMmVIRGo0amZDZGFrdWhibjVJVUp1aEhRYzFaM3pjaWRJbnRKNjdR?=
 =?utf-8?B?bTR0amVKMndBNUZscjBoYUFSb3pHK211UjRZNW11RlVTQUdpZXpaYW9kQW5a?=
 =?utf-8?B?cERXZmNHcTVTQ2ZHSGMvYXU1Q1ZLRWxuN1dFVStRUjFBVzJQRDYrWFlrSEEz?=
 =?utf-8?B?MVlxaGo3WWdDOVFsU3dIS3FiME1xVTZwNmFsdnpyNUMzSzBrUTNUaGl2bkNX?=
 =?utf-8?B?elZhZnF5a09TR0RocUw1bFpsdDNLeFJXWUNOUldXL29qN096TTd4dVBFUllI?=
 =?utf-8?B?RVY5elFlS09lamFpV1hzTnkzSGtpeTlkT2tLSkdqaGZ0R2NHTkRWZU93eklO?=
 =?utf-8?B?OWJIZHZSRGoyc0hJUnZJV1FWOEFtTi9oaEZPMWVYamdXZzdtNkJYUHZzU09L?=
 =?utf-8?B?MWtyMlBvZ2o0T25tZGhrTXlLc1RGdlVqb0hJUnJLNDVHU2VxYy96NENuSXBk?=
 =?utf-8?B?NzdlOTlYKzBBY29RZXVmVUNjMWJtOUZ0YmhVWEo3Snp2UGhzWktKYlhobkxt?=
 =?utf-8?B?Z1lDcEVvaEJwb3lhWEQ1ZzhEOWVVTTJUUG9OVjVBQ0JKdGh6NmVmcXlvUVVk?=
 =?utf-8?B?dVpsek8wNGtNVmpYZkVWT0xSNVg5RFlJelRydEZZYlRUa3hkWlgvUFAyRm5J?=
 =?utf-8?B?anZLNWg4RWNTR0cxSENwMEdMRkl2Vktkckp0STEwVk9zeXFyU1FmRUNCd0Q1?=
 =?utf-8?B?eksxTFNhM3p0TzhqZysrMTB6TW9kZUZSWXljdHpVQzdnejZXUExpRVZDakdk?=
 =?utf-8?B?S2NtSmFIdzRUdVNVcm5Sc211U05DajFBa1YxVFNML2RsakYxUFAzL1RVbE82?=
 =?utf-8?B?cGZLempIeTZxc1RlY1NvWWVEK0ZxRER4b285eTk2UnBTdW54OVhSYUMrbEFw?=
 =?utf-8?B?cTNXQVBpakVlSEZuY0JzckI4MzhHeDJNRFQzdVA0ZEFwSHBIcnhWUWlsT0I3?=
 =?utf-8?B?cFhJK1o1T0E0VHB1QWZiS2EvRUR6VThWOE5Za00vQTJYMDhWRURMYXljR2Rn?=
 =?utf-8?B?bzZhQ3FIaGRMZEdrdEhNYTFiWFI1ZEhhRCtETWxKWVp5K3JCQzJMZmMwc2pP?=
 =?utf-8?B?YlRlRzNPM1ZzbnFqZ1VpblFzQldJTU5wZjIvb05WT1krZUFlRm4yMXJtcUwz?=
 =?utf-8?B?T3NzRlVhTy92djQ0blpqc1B6TURSeFc5U0FaU2x3Y1B6NnozVUs3MlpxTjRE?=
 =?utf-8?B?VEcvNmJtajNUeHBLZzFWYXRxNUhrdXVTQTRsQ0ZNS0VvNTVJQlFhcVdlZHBY?=
 =?utf-8?B?c1NlM1pSdklWQnltZXNoNzByMVB4alJwZjJaWXRQRE1HQkd0QktvRXVrNFhz?=
 =?utf-8?B?aHc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3e39c6-b5ce-4bf5-3103-08db4cbf61fc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 16:48:27.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRCebHqp83qkwj31GekiQirQw+Ne7MqsGISAWqmf4GCrgTRWzWEEWfiUH7AzpceR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5241
X-Proofpoint-ORIG-GUID: yX2BxgCNVJkDWTZnVRAhBxEZYf4JipHm
X-Proofpoint-GUID: yX2BxgCNVJkDWTZnVRAhBxEZYf4JipHm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/4/23 1:18 AM, Michal Suchánek wrote:
> Hello,
> 
> On Thu, May 04, 2023 at 12:43:52AM +0100, Quentin Monnet wrote:
>> On Fri, 21 Apr 2023 at 08:39, Michal Suchánek <msuchanek@suse.de> wrote:
>>>
>>> On Thu, Apr 20, 2023 at 04:07:38PM -0700, Andrii Nakryiko wrote:
>>>> On Fri, Apr 14, 2023 at 9:28 AM Michal Suchánek <msuchanek@suse.de> wrote:
>>>>>
>>>>> On Fri, Apr 14, 2023 at 05:18:27PM +0200, Alexander Lobakin wrote:
>>>>>> From: Michal Suchánek <msuchanek@suse.de>
>>>>>> Date: Fri, 14 Apr 2023 11:54:57 +0200
>>>>>>
>>>>>>> Hello,
>>>>>>
>>>>>> Hey-hey,
>>>>>>
>>>>>>>
>>>>>>> On Thu, Apr 21, 2022 at 12:38:58AM +0000, Alexander Lobakin wrote:
>>>>>>>> When building bpftool with !CONFIG_PERF_EVENTS:
>>>>>>>>
>>>>>>>> skeleton/pid_iter.bpf.c:47:14: error: incomplete definition of type 'struct bpf_perf_link'
>>>>>>>>          perf_link = container_of(link, struct bpf_perf_link, link);
>>>>>>>>                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>>>>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:74:22: note: expanded from macro 'container_of'
>>>>>>>>                  ((type *)(__mptr - offsetof(type, member)));    \
>>>>>>>>                                     ^~~~~~~~~~~~~~~~~~~~~~
>>>>>>>> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:68:60: note: expanded from macro 'offsetof'
>>>>>>>>   #define offsetof(TYPE, MEMBER)  ((unsigned long)&((TYPE *)0)->MEMBER)
>>>>>>>>                                                    ~~~~~~~~~~~^
>>>>>>>> skeleton/pid_iter.bpf.c:44:9: note: forward declaration of 'struct bpf_perf_link'
>>>>>>>>          struct bpf_perf_link *perf_link;
>>>>>>>>                 ^
>>>>>>>>
>>>>>>>> &bpf_perf_link is being defined and used only under the ifdef.
>>>>>>>> Define struct bpf_perf_link___local with the `preserve_access_index`
>>>>>>>> attribute inside the pid_iter BPF prog to allow compiling on any
>>>>>>>> configs. CO-RE will substitute it with the real struct bpf_perf_link
>>>>>>>> accesses later on.
>>>>>>>> container_of() is not CO-REd, but it is a noop for
>>>>>>>> bpf_perf_link <-> bpf_link and the local copy is a full mirror of
>>>>>>>> the original structure.
>>>>>>>>
>>>>>>>> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
>>>>>>>
>>>>>>> This does not solve the problem completely. Kernels that don't have
>>>>>>> CONFIG_PERF_EVENTS in the first place are also missing the enum value
>>>>>>> BPF_LINK_TYPE_PERF_EVENT which is used as the condition for handling the
>>>>>>> cookie.
>>>>>>
>>>>>> Sorry, I haven't been working with my home/private stuff for more than a
>>>>>> year already. I may get back to it some day when I'm tired of Lua (curse
>>>>>> words, sorry :D), but for now the series is "a bit" abandoned.
>>>>>
>>>>> This part still appllies and works for me with the caveat that
>>>>> BPF_LINK_TYPE_PERF_EVENT also needs to be defined.
>>>>>
>>>>>> I think there was alternative solution proposed there, which promised to
>>>>>> be more flexible. But IIRC it also doesn't touch the enum (was it added
>>>>>> recently? Because it was building just fine a year ago on config without
>>>>>> perf events).
>>>>>
>>>>> It was added in 5.15. Not sure there is a kernel.org LTS kernel usable
>>>>> for CO-RE that does not have it, technically 5.4 would work if it was
>>>>> built monolithic, it does not have module BTF, only kernel IIRC.
>>>>>
>>>>> Nonetheless, the approach to handling features completely missing in the
>>>>> running kernel should be figured out one way or another. I would be
>>>>> surprised if this was the last feature to be added that bpftool needs to
>>>>> know about.
>>>>
>>>> Are we talking about bpftool built from kernel sources or from Github?
>>>> Kernel source version should have access to latest UAPI headers and so
>>>> BPF_LINK_TYPE_PERF_EVENT should be available. Github version, if it
>>>> doesn't do that already, can use UAPI headers distributed (and used
>>>> for building) with libbpf through submodule.
>>>
>>> It does have a copy of the uapi headers but apparently does not use
>>> them. Using them directly might cause conflict with vmlinux.h, though.
>>
>> Indeed, using the UAPI header here conflicts with vmlinux.h.
>>
>> Looking again at some code I started last year but never finalised, I
>> used the following approach, redefining BPF_LINK_TYPE_PERF_EVENT with
>> CO-RE:
>>
>>      enum bpf_link_type___local {
>>          BPF_LINK_TYPE_PERF_EVENT___local = 7,
>>      };
> 
> That's the same as I did except I used simple define instead of this
> fake enum.
> 
> The enum only has value when it is complete and the compiler can check
> that a switch uses only known values, and can confuse things when values
> are missing.

Currently, enum value CORE is done though a llvm builtin function. So
if the enum value is used in switch cases like
   switch(...)
   case BPF_LINK_TYPE_PERF_EVENT:
      ...
CORE relocation will not work in that case since the compiler
expects BPF_LINK_TYPE_PERF_EVENT to be a constant.

> Thanks
> 
> Michal

