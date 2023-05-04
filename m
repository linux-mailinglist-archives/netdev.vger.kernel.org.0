Return-Path: <netdev+bounces-286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 302086F6DB7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C78B91C2113E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237FDFBE9;
	Thu,  4 May 2023 14:29:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140407E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 14:29:56 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F9E86B0;
	Thu,  4 May 2023 07:29:55 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344DO88S013857;
	Thu, 4 May 2023 07:29:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=JA4VX07eIz72LE3ztyT2Tl2Nxt/s0M6KeMMrnvrHR2E=;
 b=JcT/Na7CpulVBc/IYXFA6vcrl6JN73Gqn+CyOcKf/gYD/4USZA6qo2bAXmh55TGHwoEf
 rv/+RKlo6kbHtK7V5OkBAMxRgOn6LMWFf2/HpC8seU/PMmeAr05tThkudS3elO5OtYMu
 AEsfCxOzF0ggWMN7EYPcbX56tnhA89+v1OMmKRtN8tYD3OaIhMeCVgQigZdp1C1vAiZa
 L7bLY1zUIadlyxsvipr1Y3uz4EqseeALnV/DDIsSuCJ2bwXWtUWB+2WpqWigzlIM5aG9
 phjZxPd0XuRcLeyVvGPhNqmAqFZLwlxNb+vcuXdqaSbCRdfHUP6LwTFaBCuAAmdo6oEi QA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qc2g1c8f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 May 2023 07:29:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFMay894JPFSFH1jnFKmrvKHIQW+RnGRm7uuEHdOQRKSVMIHNHwnnY5SgXUU+TV3fQWQZes+ZhNulbAufazJFtOBbvRXHSAW8rBsg6ww6HjGqti5eSuaFIGfJRNKCNXgCCo2cE9JFWebVBpUE5ALJEBKh7IG2casroSPORZn9dOpbp6CilVGRjv0ZNsU/UlmT4Q5OGIacoiYyod7XteQvmpS787OyvCaPjTTz/In0lnUHZYsnYIaRBftev1TMxLHW5JtPLZrDYg8QgXgB+4VfNz8LfSjjnruhdJ5pyxbmgKZqtvnpeQIZdqrhYOcuAcRB2SkxTKOI8QPiusNWEXveA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JA4VX07eIz72LE3ztyT2Tl2Nxt/s0M6KeMMrnvrHR2E=;
 b=b2pquQrWggu56zQDVtzHy7GmglUOgHGJwVUPzRj7EZbziSi4ZqWcT8u+q7HXn/wLfpF9NYg19suKTPZA1ivYGZ+RTijD6WhoA56/nCZTM1NX1UfZLiiIcchaqObgNGKJWQjkET4HFY0LgrS8i/2l2mIKEW/Tc55TFGp69mla20mVLZ8zGQ0DX2qvcQSyXIBnJxh8emD9gV+DFGLUPjhIQWcLEpjoI+Mb2eZUmLDBpXWsqwGK8Obf1dchzMB1jGN6lWPBx15BcbcmQ2HgUAECQFXX0+G9vajOyB8SMITBctWXYzgZbncOJB5Ovesx+Kq3aP2uy4Ll/G1eQnbe1SFdZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY8PR15MB5899.namprd15.prod.outlook.com (2603:10b6:930:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 14:29:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 14:29:18 +0000
Message-ID: <72f73a40-d793-11dd-af34-f1491312d3b5@meta.com>
Date: Thu, 4 May 2023 07:29:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v5 1/2] bpf: Add bpf_task_under_cgroup() kfunc
To: Feng zhou <zhoufeng.zf@bytedance.com>, martin.lau@linux.dev,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com
References: <20230504031513.13749-1-zhoufeng.zf@bytedance.com>
 <20230504031513.13749-2-zhoufeng.zf@bytedance.com>
Content-Language: en-US
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230504031513.13749-2-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY8PR15MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d2538a-1393-43ee-592c-08db4cabf1cc
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IIi7Tt0EoOzlCeAK3mzj00GoyIAThdnnSzuTqPO2MDG1DHwAqU1hiuYQE+fh//NVAeNMH+JcK1FRSNy92t8pMIgFy4Vb2Xc9lltPx/BJZ5aLzFDJLIVXDAg+MNnZtCABPu/dKbbstUpRXBa9js7GmPfxkLizcXBOwhG2bFxFoQDhctIQ/A5ZEw+Haa3qP+d9eQ0cQvcItzAGcUxetY6zZzC84McTXsZoqz2CWx52+hJkCmSY9WmIWrQxhWQK6Yz/1EpDTGBhJ3EzIBDU9TkeocZSTGyOueo2OGX/F3wb9U71lDKXPvCImw0oxEHuSmHZlSvnDIhUcaBgBluerC2eLxyQV4nplbqK5SE4UTEBSy+2khnFAqUA4iT9fyH8T+ZOQJa96wDWUkXJwj4+blFOC2Cj+xjneN652zFdr4odBSFhwo4TQs0RznmhXCfjhKnP7L+xb8diyBRwrqZnTWCv+JaPwXBOj7d1Jb8wr3Sf0knF0i1aca/Qu9RSO2ssnomd6XIX2ZQdUoNJUpxYl65S99kfH6wEb2aQfzPF2lOK2wAN5+1IHFISu4YEqcIZ5Ynhc13LlUaUGrgb54UZmJkCv6rC8SrKeFU9h3C7iTScjYjoWopNsCSPGdk7cJxbJMgzegghTF4j+GduU/ZCUCOOSoynLHKKzCvYzzSL3O5/Phc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(478600001)(2616005)(6486002)(31696002)(6666004)(86362001)(41300700001)(316002)(7416002)(5660300002)(8676002)(8936002)(921005)(38100700002)(66946007)(36756003)(4326008)(66556008)(66476007)(2906002)(4744005)(186003)(31686004)(53546011)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ajdEbloxRS9tOEFmaVBMcnhxWHlnbXhoMmsvSyt3OEM2b2xWRzh0aWMvWlZp?=
 =?utf-8?B?OXdnckIzTmFnM2Z2azBjbC9ueUExdXB2NTAyUjlLQSt1YWRNMlVJb0E4V0x3?=
 =?utf-8?B?VkF4UlBJY3QrVWlNS0Fka1pVYUhGb3lCOHMrVWIzR0JOTTlEaDNwQWRuZkdV?=
 =?utf-8?B?bklwTEpJZjRuZDZEY0hDdWhjRzA2UFpoZjVxVmdlSFc5eXIrdHZtWXFFR2t3?=
 =?utf-8?B?ZTcvdG1MRmhmV29xYm9tci9WYnVHdnhkSzhuYXhTYkV5cEU2NUN6NWM1WnFO?=
 =?utf-8?B?MXh0TXNDdWg5QlhHeHNOT0VFSDVoajNDVUJ3SzMxRzlNUWUrMU1tc0RaQkVk?=
 =?utf-8?B?N2thZ0p4Slo2TkV4bEpibCtXRnZ2UndDMWpaczNJMWVYY0lPSFIwZDRwTi8w?=
 =?utf-8?B?QWpVMFIvTC9SV2hGdWw4SGZQOFlGVFZ6UnhXOW9sRDRsc2h3UGZFTTUrTFAr?=
 =?utf-8?B?OGNUUDB6RUF3NC9mZXJoa2E0amFUQU80cEhURlhPUHkrb2w5bmVRWVJ2NDM5?=
 =?utf-8?B?dlI3d2tSYjUrVHhXWEUyWjVnaG5XWXNVV3BuNm41N0xVOXVCNGZlYnRZZ2tN?=
 =?utf-8?B?SE90UHAzajAxTzdXSHZXdzZIZVRCN3Q2dUYvZFlFTk50UjlGOE9GZDlvN2NJ?=
 =?utf-8?B?QkQrakJJNXBZTThWQk9mS1ZLSzdUMTdIVmdJUzhMV1o1YjRkbjZMWGd1MURD?=
 =?utf-8?B?QmZoSUN2aUsyRWlkM3dic0tUTXpQN1dnalFxMWZyT29CMWNuOTlHVlVGazM0?=
 =?utf-8?B?aXVmNllIcXFNdDM3azZyYkJoZW9kQStEeS9xV3diZXpTTHlMU3daL09JeEha?=
 =?utf-8?B?VSt4TG11WTcwbnNkZUNJUnYycVdxeW10S0tCU1BrdmxUcE9kZ0xFcWdOR3BN?=
 =?utf-8?B?a0ZBc2dVeDk3M2VLSWhRdDRGMU5MbjBjTEtxaWp2NlYwbzRMcnF2dm40WGhC?=
 =?utf-8?B?MktMR2tvNmppYmdhSW5hbVc3OVRaVmQwNS80Vyt0MzRwRHB5OERkMXVnSFpB?=
 =?utf-8?B?SXhyUEJsTUdiblRBN2JtZlNDVUNxRElkMGhrc25aMWNta08zUjlnYll3a2kv?=
 =?utf-8?B?ZVhEWjFDWVZtN1FSdjY4YmpGOUk1a0ZMWkZkYVlKZjNHdkpXS0p4Nm80YjZV?=
 =?utf-8?B?Qng5MVJBK0xJQWtqaDc3ajAybmdudytOMmNHclByZHNBN1I3U0h0dXhtQUVr?=
 =?utf-8?B?eHp4YlhTM2kwcHdKamNXMGpobEFqdVRSTE5wQ28vd21QZG9XaG1GcUl4U29E?=
 =?utf-8?B?Sy8yR2V6K0ZkM1JYQzhYVkdOcWNVS1hxSVBTbWE3c2JxdWdBeVlRQXI2RXB5?=
 =?utf-8?B?ZDVrdzFQQzVuVjd0RXk4eE83NThCSXYwU2lnbTk2b25ZclZYcEt3NmtjeEdX?=
 =?utf-8?B?UkxDbml3YzVDMkFTUnE1N0VPL2dnVEhZalZKOXJ2UVdkKytVMGQrNTBQK1o1?=
 =?utf-8?B?M2JwdWNyMXY1TWhSQ3hlRmVyOElvQjNHS0tzYWlGc21jejdtMVA3VGs3ZTVB?=
 =?utf-8?B?eFVwN2J1cnE3TVp3V3o2dkZIRENYbm95Sk9FaU12TmZtVjVVWmtjZXUwSlN6?=
 =?utf-8?B?Tjk0aUh6Y2xRSEdMWllwT1drT3BVWVdGaUFtOGQwS0Y4eVNVMkVoeGFhVU9Q?=
 =?utf-8?B?SnBWWmp0UUdmQ3RVSzJHK3BGV3d1NVFMZGE0YlNseG1meE1GbEk4MGdiVXNl?=
 =?utf-8?B?SmVZWTRqaWdWQ0FiaVc1MzZpRDh3VTR6MTJELzRTdXNNYlMzaHlaV1pMRmVk?=
 =?utf-8?B?bjNGZkRtd0RYdGV5V0d1bGJsRklpNE9WM1loQXI5azgyc3BvS2lrNlI2M3la?=
 =?utf-8?B?VlB4TW5MTDBMUzFTL3cvb0xybjViT0d4MUZrKy8zZTdsSisrQUF4WkhpSk4z?=
 =?utf-8?B?NTY4MzhhaythSjgybkFHRGVvaWdpaG9HS1crdUFRWXFKSDRZY1JqMzBvVzl6?=
 =?utf-8?B?a29HSmFHWjdrSnhDcDk1R3RaMjUyMEk5RnpTb3pjcGc0dnBIVnI3bVJTd3M4?=
 =?utf-8?B?YWtnNk9iQ3B3MmxWOEc0WHdkbENDUFVDdktydzlQMW5JQWNDWGRDVm8ycGVX?=
 =?utf-8?B?YlN2MGRnWjFMZWNtUHFUaVptWkhqMkRNNS9mZmN0YUZGNlRCamNNRnZ5MTcw?=
 =?utf-8?B?M0oyZlY2SUhiNkM2bTVkT1NwWmd2SmoxK3NWY1lJMCtiRU1NQ201WXdxUkFC?=
 =?utf-8?B?bHc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d2538a-1393-43ee-592c-08db4cabf1cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:29:18.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YMiwzMVSELf5rLp2g6O+DUYPiTnQ/NhHhGbCUwFy0mU7hvrNDKQbUx87i2DtyQy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5899
X-Proofpoint-ORIG-GUID: 9bCAJVvOrCV2Skos8n0nGvB8vHHUENPk
X-Proofpoint-GUID: 9bCAJVvOrCV2Skos8n0nGvB8vHHUENPk
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



On 5/3/23 8:15 PM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Add a kfunc that's similar to the bpf_current_task_under_cgroup.
> The difference is that it is a designated task.
> 
> When hook sched related functions, sometimes it is necessary to
> specify a task instead of the current task.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>

You can carry my Ack from previous revision since there
is no change to the patch.

Acked-by: Yonghong Song <yhs@fb.com>

