Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972E56251E8
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiKKDum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKKDuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:50:39 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6C663D2;
        Thu, 10 Nov 2022 19:50:37 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALjIRs016405;
        Thu, 10 Nov 2022 19:50:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=3v5wq4QdIHF0yqi8aQlAss+hK2Dd28mvzpIvMdnnR0M=;
 b=gKE3E29Q2BGnjizn/Cg6TMXiKju0BGvL3Dh7LQWTehmSXJ7I3BtafDZ7XU9Xmt/j0Ov7
 rRI4hzG1KUpXVIBd0sB/DG2ysyac0sJRqVRMKCm3CEqPsQtI0p/XO1sO5E5F3uoFRORh
 j/K8h7rw+YOTqFkkP7aRHbEGuOBN6eaS0/jjma0fLx/zw/L784hwitpzHvHanRNEgpui
 l4qUM3pSD4OUbfQx+/8NokS2bFP9RnCxwqYiemVLv56u4aVXuJt4E5GbMvxMiWSRb/FV
 KQRrDqCBfgiWoXpdUC2lWe/wL0PcfMwn2+WgAYwPtGmYw+OfgDOSFQVqkLcw3QemPxp6 0A== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ks8pn2phe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 19:50:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7NFbGMyRzpvaQCp0WcFeawIIvGu+L1wOo6h48K41jVnxmahHK8iUgCD4vYaESn4Nw8EnT8z8PzNO9JcBtF3XCoxVfjXwctGEz99maXz8EyTsQHv/k9QtS2NiaevVI2aAUAd5STlX6odS3VGNCJioUfJeXErxasAujfOpOz33+r4pa7K0dJ+6vo/u/o0EwWCa1fa5suEMaIfmPiFlvrNAFVYldMe0exBxZWqCZYSfDCZXfQN0lj+LEescvvTgSBeaJha21bhlA+D1cTlYT8gFAnAgKKzIwx3jennQKW6Cq71JnXZ7UQ5qb9fX+AJlXJvlOJfEq2+aAG37CYiH2vC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3v5wq4QdIHF0yqi8aQlAss+hK2Dd28mvzpIvMdnnR0M=;
 b=W4LSRQvVjkWFAg4J4ILzodtRrgskhOTbCNiu4+TvA7Uw8UwlzpPLpw4hNkQTZhDdPDKgn02F8Bxd4siIRg8Fj7gPHccSMi3KguKdG3usDcGtN5rHuazUacVpjmFSGHB74LlxqrsXMLoQMXN1JlSa1QbSDQsS6cvd+8fnjTOandiU5DP4PIs2xm2u+8Gyg+C/VCLDgAYiwufwGSSNvscwLXAr/YxhLhyT8ThZmNnZxuGBQ/Abc04MSoixPL/g0bWxpv4+c/RlcFYEp0eZOdan4vQzPELxEUBlxvYGDtr2Dc7GeLQovvGY0EIZj0ZZFTNEP76ChnvVQ99AQ5xvWairng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by CY4PR15MB1608.namprd15.prod.outlook.com (2603:10b6:903:136::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Fri, 11 Nov
 2022 03:50:00 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::ba78:8112:150:d384]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::ba78:8112:150:d384%7]) with mapi id 15.20.5791.025; Fri, 11 Nov 2022
 03:50:00 +0000
Message-ID: <ab2cd7e4-fe35-63a4-7fe3-4d98bf8ce4e1@meta.com>
Date:   Thu, 10 Nov 2022 19:49:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] lib/radix-tree: Fix uninitialized variable compilation
Content-Language: en-US
To:     Rong Tao <rtoax@foxmail.com>
Cc:     acme@redhat.com, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, rongtao@cestc.cn
References: <4ed2ebee-26a8-f0ab-2bc4-a0b6a29768af@meta.com>
 <tencent_754AAA6CBDDE8DB223CE1BF009D566E55E0A@qq.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <tencent_754AAA6CBDDE8DB223CE1BF009D566E55E0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::15) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2055:EE_|CY4PR15MB1608:EE_
X-MS-Office365-Filtering-Correlation-Id: f1862810-d6f6-4ed9-0388-08dac397cee2
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Q9UTWpFYHZKJ3PXfbjMHbvVyFJgG96G1NuEZb712MK3fuVkg7hURV3yu6p5f75oLp9kUwuAm69tcXxD7K7paB/ZdIVfCtfx7nNdVCcpyWAvR5O4r4VH38tWtlXwjMxd0irP17KuWHMk7uMRkIfqf2ptEOASsz6RNJC4I5EY1f/HNxiSz4piA0LXBstT8TlTQN9/irNWsTpS25rF+5E5aT9VzGA/qsz4XNhqJffcBOpo9sQIzUxwSGulb2PBfz6OVkUU2RhdiXmH/0vKCuZAGUbjzKbterWrm1gDujJUn24//UD5gmF3X884iDi8FwktV/lEP8YPRHiTBSXuzfgA1RhnIkdclbzsVrwFRUfsJ+OdGxLMuQJ/usXrGtOsxmdWuCrbmNltXyyt7dLff7dK7E+VEDiNYR3SMpduwqu2FW1rAhKsxOFHOnmsyXPrd9PrPc5/fsXoYTN+/MEXz0E6LMhLrWfnapwR8U2ERysL3agExQvGJh48n3GKgwgCRa/oCqXIb/iXQqANIvdwGXOB2rl/ljeT/oDjm+8C2nElODfi3Ebso40mB4adv5PWkiMaWERpkIImPY0AJXWVcUR+o3nihGGfa1fkE/nB6apANM4Lm61+qS01cQsaQAhMWutVTBFosgXHaffJ+Fr3ZXCx0P4lbShcvQGBwJdmlXaSPhW3qLZkbxVbUQ9yDLaELUI1KCY+yO1zrHMcuObmGGxfsTmgvdy3EvKu0LiKXxkzEvP2y14oHnWt0++gam4mqWsQ0FlwTPVmAbTXq+JqN7451b6RDf1lL/+gm5vycaEnDQY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199015)(41300700001)(6512007)(36756003)(66476007)(66556008)(66946007)(316002)(186003)(53546011)(38100700002)(4326008)(4744005)(2616005)(8936002)(7416002)(6506007)(86362001)(6916009)(31696002)(5660300002)(31686004)(478600001)(6486002)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkgwdmVtRkgxdzluK2hQclVyeDRBbDRwRGd0OG1xSUNyNHFyMnJRQXh1OGx2?=
 =?utf-8?B?R0hVcUJPamhCckwyTi9pemc5NCtqaDR2UDlhdjFaSDFXdkRhUjZ5clk2TVhr?=
 =?utf-8?B?UlQ2WlI2TVoyVnVWL29CcWhQOTBDeWs2UDBIVjNYVUNPa2NLWWhST3h3aVkz?=
 =?utf-8?B?S01NcHBPRHVWTk9RSWk3R3BseHVHamFkY2xOWm4zNm5GNEw0NlJVQzAyUVNF?=
 =?utf-8?B?TlJ0VHFtRGdCdGM2SWhnVUhLOEN2cVVmK1Q3L2F1dmNrM1FlS2p6bnFydGRD?=
 =?utf-8?B?cFJ1TGtLd21KcGdtNnhKZ1BkOHZlYkUrVGVtUmlaZm5nRnFDd002MW0zSDFs?=
 =?utf-8?B?S3JxUHhZK056UTd0clNBZVQxcFhha3YwS3ZPK0IrYzhKYlNic0lrUVdvaVky?=
 =?utf-8?B?NnhWV1l6ZFZSeFUxRG9BVGRNZlk1VjZOZkxFdFgzYWJJRFJzdmJHdE4vc2V0?=
 =?utf-8?B?WkZHNVhKNUdmd3Avcm9qR0hoL0dIc1FHYkd2L2xEaDBmVmUza0UwcWQ5T21a?=
 =?utf-8?B?VUkxbzd4N3h5U2J3K002WlZUUXRxYzFZWWJTM2Q4a0EwZmQ2bE1jT0FmRm5F?=
 =?utf-8?B?OVFzNTBwUVcvMzBnY2haS2d1NDZicWRkd2dCTzFENDB4QW14S1JFcVJxYnpR?=
 =?utf-8?B?cWhJcWE5TS9KNjVlN3psV3dtRU1IWk0zZ2o1WEJXUGs5ZTd1ajdTaW1ZTGk1?=
 =?utf-8?B?YXJMNkF2dWRLUTFFY2VKWFY1SkxOd3Z1cHJCTVJrdDBVUlNDZk5OMmdGMkZJ?=
 =?utf-8?B?YWxkT3FueWFtSlZjU1FYWkNCQnJHSTRZNGVqOFRsSHdVZzl0RDBkbXFObFBs?=
 =?utf-8?B?dmo1QU40QWlnZ09FRDFDL1VDc0ZhSDBmLzlyQWNyUjdFMkkzYVJCbnR4OTBp?=
 =?utf-8?B?UUpWemV0cmNORHM3U2czaEJ3MlNiTysrbFZEeTU1c1BHM1NFUHhUOUlpL3JY?=
 =?utf-8?B?TEh5Y1ZWRno5U3FXS1FxaGRocThGQ1hJTGpjejNHdkdacWc3bTVIZ0ZXYmpF?=
 =?utf-8?B?V3NkcUVnaTRCSVdCVk9zVjBiMDlTaDYyNFJNRWpyNE9DRDd6d2ZQY2JpZkF6?=
 =?utf-8?B?dnRhb3hyazJ2YXFNa0xsT0x5NXpuQzhRYTN0MTVqazRZT1RybWRIY1JSYURw?=
 =?utf-8?B?ZGFXQmR2Y00yODM3NHE2MUdRWnlScTkxOEQyRGNHdlk5bjExYm40OUFXb1FQ?=
 =?utf-8?B?ZDU5clY2T3JCaFpSMmhmckY2Mmw0SGFSaldqdWVFeTN6Ym9YVHROKzhSb0pT?=
 =?utf-8?B?VElqVDRQY0dUa0lBbjBCK2xOYUhpWlcvZ0Y0NGl6TGZWaEpZcTd6SzJBckUy?=
 =?utf-8?B?aUkxWlNtMlRMc3R3YW5nSkh6U2YvUU1FNUYrUnZ4QnQ4RnFVS080WW13VU43?=
 =?utf-8?B?NlREbzVMWFJITU1yVUFOajBVbUwvZWdOVWwrTndEdWkrbGpVckhnL2g2dHly?=
 =?utf-8?B?bXQ5VndHb1NCZU5hYlpTdVJIM25lRFpSclpiL1JjVHo5UHBmQTMvR3pzVnY2?=
 =?utf-8?B?Zk1sOFd5dDBYNjZDcnpWQVR1enBOL292QnBIbVlUT2VBTk9HV2FaNWl3RVlu?=
 =?utf-8?B?RXYxNFI2WDRaRWFUOGJwNUg2Sk56ODhUS25Mdk9EZFhiTlh2bUpFQzJYSEJm?=
 =?utf-8?B?OFB2WTRKZ21NV1lIL0VsMEFwOUpwSHc4K0RYZStESXJWL1NKR0VnY2syVHNh?=
 =?utf-8?B?OVZUbnd2UVlnTFRUUjR4dy8wemdJSitoQzRKRDQrRmhwSzZBdWpNYTNqKzZh?=
 =?utf-8?B?N01hSUNGejlCUEhHUm9aTVNNK1pvSGV1elJQSlRldTFaMG4yUTlYOHdUSEFX?=
 =?utf-8?B?cnhCN2RSQ1VFbDI3ZVVhMXFmdFA2TWVCM0huK3I2UWw5WFVieUZPMXJYZG9V?=
 =?utf-8?B?R0RkelA4emVMYTAyZitmaVBBdGhFTDFROWFQb1F1bU1LalZHZ1lac2h1MWV6?=
 =?utf-8?B?Z1JRV1VWUjBaclRqdEpqdkd6ZC9uNlpOa1dsbGRuNlJzeXJlY1Vnd0lpZXNl?=
 =?utf-8?B?N24vUGx6RHM2TkxVQnhqMEZVbllVcGxycGtuNmNCQzBlWmZqaUYvYTUzOWhj?=
 =?utf-8?B?aUtyNytQKzU4S1FwN09ESHdEK0NSN3M0bEVTQ3NTMU1HVXBJQTJxSDdhM0JP?=
 =?utf-8?B?UXlrSzNaWnNUV092aFFxR2NQTGNmMVJPdnRHd3hWL1pTV0JDc3VQellzcVNI?=
 =?utf-8?B?ZGc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1862810-d6f6-4ed9-0388-08dac397cee2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 03:50:00.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJEWlMclmpDeoT9PW94m+bU2ZKzZQ98RJtmI7lmcLyqgGzobRQob1QWJZFM50Cir
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1608
X-Proofpoint-GUID: UM6HnEd2iyslTDdXr7Vw58dSnkas9ax_
X-Proofpoint-ORIG-GUID: UM6HnEd2iyslTDdXr7Vw58dSnkas9ax_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/22 6:18 PM, Rong Tao wrote:
> Hi, Song, thanks for your reply. I'm wondering if i want to fix code in
> tools/include/uapi/linux/in.h next time, should i just modify
> include/uapi/linux/in.h, and it will auto 'Sync' to tools/include/uapi/
> linux/in.h? Or i need to modify tools/include/uapi/linux/in.h at the
> same time?

Either way is okay. If you do 'git log' on tools/include/uapi/linux
directory, you can find examples for both approaches.
