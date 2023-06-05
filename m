Return-Path: <netdev+bounces-8020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B277226E3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EA0228107B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B722419908;
	Mon,  5 Jun 2023 13:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C0F18C1D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:07:33 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E73DC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:07:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDAGklhIlTT+gdbHczrHVJ1Sx20jwZ0ZJJeKa6Hh+VDsyqPzlUf/lPhhMU/5XL9SFzsPTzRpjq81dZfxfLhqy2CMmoHBOTsCNPG4ww46fIPgiU12M0tgFdRHh242RZ6f/bHktxGaQxvzpRRQnjCtabFZ60DDsFUHoPSshssN5fWX1LWc6rggQuu18YWtMMgQWSv9EK9QBZlCJ3ictAgd4e7VeHo5UCDzDfcvHDoYIgzgm3axUrv3CIUS4TBiqRymI2I8E7Qmkptq7ipjuoC6CAK6vkqOog/bgGkgLVswA3vfQ1HKaoEIUUcFSPHryzPKU2/SsvUe09nguSg3qRxw8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezO6LNCoYZYI7UvNzS9lVgGzeuKBPQ/u8Tmpv0Tqcc0=;
 b=dBlSdkMRxAvbvILRarKu+62cTo1T2OzzyeyxWowi2+mmvVHSvFn9ZIlojZtRhqQoDHD4Y9WmVhL08LNCrazmaw2/sNwpT09+5osYFJnuwqoUybS8CHltA6brX63KUYQj9+DsjDcHLvB8EqGiGXTVw7sphYZBzRsOQLGwd7FwhheVKpKjU3OquQz3ZnL4t+JCD+Qw3GPxVLM6jmsJ8/eLHwSlqdryWkYKXIttCk3RYOAn1D2UKc+PNbPQ/9hGyG5ee5aJnNprOvG+sfub1LlnSSfD7/l+nqJLP2HnIZnU7lZ8fzfzPjjRTJ9AUDYDULcL1zZQAjPZtqUVp36tdhqpCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezO6LNCoYZYI7UvNzS9lVgGzeuKBPQ/u8Tmpv0Tqcc0=;
 b=V4A4KUn5ntUkn+3GOc+3VJyWLd7XpCmlVyCRpeYHGChEV6c1gk8xWazjkq1LwonzaNtxbQWrB4P1lUA5co+S1R+KNKg85epZ7IDlV95jOooRACVKgrbjF5s2Al/pk+H+YjToXumFCfdLxW6T14wTr8Ov5Iq+2I2ZkA7T6Rfizgk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5318.namprd13.prod.outlook.com (2603:10b6:a03:3d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 13:07:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:07:26 +0000
Date: Mon, 5 Jun 2023 15:07:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eelco Chaudron <echaudro@redhat.com>
Cc: netdev@vger.kernel.org, dev@openvswitch.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: fix upcall counter
 access before allocation
Message-ID: <ZH3eCENbZeSJ3MZS@corigine.com>
References: <168595558535.1618839.4634246126873842766.stgit@ebuild>
 <ZH3X/lLNwfAIZfdq@corigine.com>
 <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FD16AC44-E1DA-4E6A-AE3E-905D55AB1A7D@redhat.com>
X-ClientProxiedBy: AM0PR04CA0113.eurprd04.prod.outlook.com
 (2603:10a6:208:55::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: dcdee112-85ec-49fb-1f03-08db65c5cf2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zbvK4c/igV8WLV+RHCa/Gacbz9b470iNBRk0gDYNQxBAm0GZo2OJW2S1OWJl7A1bS2bSy0NMZwu9z8q2KIr/N+8HpD4kjoPti7SNOUzkHg6QmymagE9hxKsiTauCJdBWT4Jloa7FAIV1rXYgiFb4wRBXKu9UBdtLEdISY0fV7JM0j0OEX8KKRl9A9N0+jeZwYiPvh/ZeK3t7Y/eVJSvoRQcXy5Y1Hm7I7vOvg4a/bRx96NMAxnK3rQujh7WhcamOEXTbQLjijdGTE0dRvJfC8oe5s/2Gkdt/75WBpyGtAprctdsGH1LPcL3y8djmN/FoQOzbYYveCeosEma8ieKzj3vN1jL+/M2oyg2T3J4BA6rvgY/hyYuHLzo4rjse4jYrXCvknlzo2sj6h+yM4qy6XiAYx5LTcxKRMiWIstIGASmZpBMU/8PGJWgBz7b6VCKCdpW5vWA+hZu3xSubMO1AMy010bVr9dSnpoqU4GE4gCPMjxPLA3GGa6uOhRrYTU9RVUDUQMSnbawjlPmcoxnnCQAOPQlsxsNCVPnDKjadGiwim5Sh+XhX4OUp5ckAJpvO0fmlAQCv9rCsqU3jqV+hmmDfhIr8VyWzw+eU24ieQrE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(346002)(396003)(366004)(451199021)(53546011)(6512007)(6506007)(36756003)(83380400001)(86362001)(38100700002)(186003)(2616005)(41300700001)(44832011)(2906002)(478600001)(66946007)(66476007)(6916009)(4326008)(8936002)(8676002)(316002)(5660300002)(6486002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1JZVnNWSHVnYlVEa1FtQ2dKT2lOWnprelhGSjJYVGFFZVROTTJQS3VremdF?=
 =?utf-8?B?OC9DaW5KSm5Kb2cxNWxxZ0tiVjV5dXVCUEo0bkdUZUJZQkhaQzY5cG9lSFdy?=
 =?utf-8?B?TThRN1ZyWXB6RzE3L1BsZ0daam1lekRJbmxqNEtISmFsODdjZ2FuN3VIWktW?=
 =?utf-8?B?MjNXTWFsS3lvUlpsWW5MaHg3aUZyUkJFbUF4V2o5NERyZk14aHB3dFFyL1Jm?=
 =?utf-8?B?Qmlic0ZWeEhhenRTQ1BaSURHKzViRGlmbFBPZ1lHYnBHUzhNQWR6LzdQbEk2?=
 =?utf-8?B?VlZqdmpmNkhlc0FmZG5oelNCbE82ZWNUSzQ4RmM5d2lSQ1pheTRyRVA4RHlO?=
 =?utf-8?B?akZqU0I2YmFiN1VHcEUxbDNiQ05BZm1mSUhEVVUwcGFOYTA3dHRtQ2hscVJm?=
 =?utf-8?B?M2R5WXp4MkxjZXlmUlNzNW5vdlB0bXptS1dNWmVzY1dQR1BYYytkSEtBT0R4?=
 =?utf-8?B?cFFxZk8wU1l6Z3Z6Z3NrZEFHZkVhR3lYOUtOcHc0V2RXYmQxbEtIY1dkOFMy?=
 =?utf-8?B?MWpYZEdhOVBHWW1Ea2VuQzk5Ly8zejMvcjFyWDk4L3Q1N09iRGZka2NibVdw?=
 =?utf-8?B?RWZsazRDNmE2eDg2dDd6aEZwQXN3emlGQmhBckZGck82Q3cwNm04bFljbElw?=
 =?utf-8?B?VlRJRWRkS20vWGF5L2UxM1JOWWZpbk1UenNqT2l1bTEzaGRONWNzQzBaWGhV?=
 =?utf-8?B?dkxqNlFwanB1T1dlY0M1Rzc1U0s4NGlWVzE4OTVWZERmWUNaTk5TVnB5Uzlh?=
 =?utf-8?B?dllGSmIrWU9aTFBtbE8vWDVlTWJGOXgraG5zV0tDU2ZLZk5iS3gzcCtvdXZC?=
 =?utf-8?B?V2RKV2p2c1l1dkU1eWQ2elhYNDViQWMrLzdtZXlhZURKaldraG96R3B5Y1Fp?=
 =?utf-8?B?MjFHRmYrMzNSdHdmd3RzTS92N2oydEk3ZWxQb3dadWNhUTNzS0Exd2R1WDhU?=
 =?utf-8?B?RVM5RUgvWllQSWh1blJHdlRDSytTS3FvMnY0SDlFbDYvc3NGSlNkem43cHBo?=
 =?utf-8?B?RGpwUVpYdFVWcmt3eXdKVTdGTkpzV1M0d0dtQmU0ZTl1cjRtTUxBTy9GMVpa?=
 =?utf-8?B?QllaWXcxNnZmM05KZGtEdDI1UCtKZUM5NllUVEYzVmVUbkgyKzl3MVRpb3dN?=
 =?utf-8?B?OWtvYlVpcWJ4R1N0QmhwSGk4RnhIMnhEbzZzWG9QNUlPTDYxZERlKzBFMzMw?=
 =?utf-8?B?ZDcraDB2emhCMFJSS2k0YnFCUDBkNmxiSWpaVzB1MDBGaTdYc2NJN3JpN1hN?=
 =?utf-8?B?T3N3T3JCUEhNUVYxQTI3UG9pRjJGOEN6RVoyZzgxQ0ZRaTZBSnUxZGJEWGlx?=
 =?utf-8?B?STFtSFpWUVo5RldCODJjc3QzRVN3WkhhRlRRZE9oWFNZVE1QcnpSWE45UXBz?=
 =?utf-8?B?c0RBRDhFN29FZHJWK0Q0MjhSc2prcEFmeVlLSTNPTW1TL2lLc25XQ1hEREFy?=
 =?utf-8?B?aU1OOEN0R1JKY202dmlleXFTeDRTbVJWY3U1OHg1NmUrSW8xNFlXZjhBaEY4?=
 =?utf-8?B?dVJoQ0VWdXdUUHh2UFU4UnVhbXpZNjlXdWpHSkh4ejZLd09jNjlMSy9SSUIz?=
 =?utf-8?B?Qk1MN09Nb3grK0VlaE9BYkZ3Z29EbFRQbllacjJpWEdTRmRrWHphdUJQdDhP?=
 =?utf-8?B?dDBnakJUei9WMCsrT0VKYkllWUVNdlBkelNWUGV2K0crQWc5bXFLU2VYNVNx?=
 =?utf-8?B?NXh4SGhFL1FSOTV1ZFRja0RBZzdaSTFVbkpFRFBhZnpNREJFVmsxdmRNQmtv?=
 =?utf-8?B?aU04UmZtQUdtRkFrWE4vR1Uxc3lFcU9ReXVTYUZtRDNlTkFSNndFb2dyWG4r?=
 =?utf-8?B?eDQ4TU9lM2dvNU5BS2E5WnhnbmhjWjVFazc1ZDl6Z0tkVWhMWGdzZ3hkZHRL?=
 =?utf-8?B?ak5pRmsxTnB3aldqNWV5eEw0OW5EaHpNeG9XZDlESTZQdWFqVmkwVlY5d0dV?=
 =?utf-8?B?RnZuMUtBaytxN1BFcytsMGYvMnlEWElTQTEvMVpuQ2Q2em43NzJKTCtYUGcy?=
 =?utf-8?B?R045aVZZcTM5a1k5VHl0SHdka0xlU3hCeGlJaldXVnB0aFJVeWR0dndleDVT?=
 =?utf-8?B?Wm1QS0VKNnEyUHllMkx4clF1TE5xOTBBMlR6ekszZ0RYc0xWNmhsZk43K0dP?=
 =?utf-8?B?eHBRMmlLc25Fc3l3aVlKaHZvMVNLYjhSTFgxMmNGeUplZWxSTGVkZDdsREFq?=
 =?utf-8?B?eWlIbzB1d2xUbkhKQllTVHRnaGlObXloNXN3c0hZQnFTNzJFVGxVd1dDSGtQ?=
 =?utf-8?B?aXRoOTRmakRZOFNGcW1SUkR0aUJnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcdee112-85ec-49fb-1f03-08db65c5cf2e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 13:07:26.3593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcl1gP16EusAF9WxjftpZ48xADeNkohViNarc933wYD3dqINjwk8qjnyQKkNVRPRC2wv9tNuQprqaQUWVuIfIwMiITPpuZzAld0iQ8pVtvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:54:35PM +0200, Eelco Chaudron wrote:
> 
> 
> On 5 Jun 2023, at 14:41, Simon Horman wrote:
> 
> > On Mon, Jun 05, 2023 at 10:59:50AM +0200, Eelco Chaudron wrote:
> >> Currently, the per cpu upcall counters are allocated after the vport is
> >> created and inserted into the system. This could lead to the datapath
> >> accessing the counters before they are allocated resulting in a kernel
> >> Oops.
> >>
> >> Here is an example:
> >>
> >>   PID: 59693    TASK: ffff0005f4f51500  CPU: 0    COMMAND: "ovs-vswitchd"
> >>    #0 [ffff80000a39b5b0] __switch_to at ffffb70f0629f2f4
> >>    #1 [ffff80000a39b5d0] __schedule at ffffb70f0629f5cc
> >>    #2 [ffff80000a39b650] preempt_schedule_common at ffffb70f0629fa60
> >>    #3 [ffff80000a39b670] dynamic_might_resched at ffffb70f0629fb58
> >>    #4 [ffff80000a39b680] mutex_lock_killable at ffffb70f062a1388
> >>    #5 [ffff80000a39b6a0] pcpu_alloc at ffffb70f0594460c
> >>    #6 [ffff80000a39b750] __alloc_percpu_gfp at ffffb70f05944e68
> >>    #7 [ffff80000a39b760] ovs_vport_cmd_new at ffffb70ee6961b90 [openvswitch]
> >>    ...
> >>
> >>   PID: 58682    TASK: ffff0005b2f0bf00  CPU: 0    COMMAND: "kworker/0:3"
> >>    #0 [ffff80000a5d2f40] machine_kexec at ffffb70f056a0758
> >>    #1 [ffff80000a5d2f70] __crash_kexec at ffffb70f057e2994
> >>    #2 [ffff80000a5d3100] crash_kexec at ffffb70f057e2ad8
> >>    #3 [ffff80000a5d3120] die at ffffb70f0628234c
> >>    #4 [ffff80000a5d31e0] die_kernel_fault at ffffb70f062828a8
> >>    #5 [ffff80000a5d3210] __do_kernel_fault at ffffb70f056a31f4
> >>    #6 [ffff80000a5d3240] do_bad_area at ffffb70f056a32a4
> >>    #7 [ffff80000a5d3260] do_translation_fault at ffffb70f062a9710
> >>    #8 [ffff80000a5d3270] do_mem_abort at ffffb70f056a2f74
> >>    #9 [ffff80000a5d32a0] el1_abort at ffffb70f06297dac
> >>   #10 [ffff80000a5d32d0] el1h_64_sync_handler at ffffb70f06299b24
> >>   #11 [ffff80000a5d3410] el1h_64_sync at ffffb70f056812dc
> >>   #12 [ffff80000a5d3430] ovs_dp_upcall at ffffb70ee6963c84 [openvswitch]
> >>   #13 [ffff80000a5d3470] ovs_dp_process_packet at ffffb70ee6963fdc [openvswitch]
> >>   #14 [ffff80000a5d34f0] ovs_vport_receive at ffffb70ee6972c78 [openvswitch]
> >>   #15 [ffff80000a5d36f0] netdev_port_receive at ffffb70ee6973948 [openvswitch]
> >>   #16 [ffff80000a5d3720] netdev_frame_hook at ffffb70ee6973a28 [openvswitch]
> >>   #17 [ffff80000a5d3730] __netif_receive_skb_core.constprop.0 at ffffb70f06079f90
> >>
> >> We moved the per cpu upcall counter allocation to the existing vport
> >> alloc and free functions to solve this.
> >>
> >> Fixes: 95637d91fefd ("net: openvswitch: release vport resources on failure")
> >> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  net/openvswitch/datapath.c |   19 -------------------
> >>  net/openvswitch/vport.c    |    8 ++++++++
> >>  2 files changed, 8 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> >> index fcee6012293b..58f530f60172 100644
> >> --- a/net/openvswitch/datapath.c
> >> +++ b/net/openvswitch/datapath.c
> >> @@ -236,9 +236,6 @@ void ovs_dp_detach_port(struct vport *p)
> >>  	/* First drop references to device. */
> >>  	hlist_del_rcu(&p->dp_hash_node);
> >>
> >> -	/* Free percpu memory */
> >> -	free_percpu(p->upcall_stats);
> >> -
> >>  	/* Then destroy it. */
> >>  	ovs_vport_del(p);
> >>  }
> >> @@ -1858,12 +1855,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>  		goto err_destroy_portids;
> >>  	}
> >>
> >> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> >> -	if (!vport->upcall_stats) {
> >> -		err = -ENOMEM;
> >> -		goto err_destroy_vport;
> >> -	}
> >> -
> >>  	err = ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
> >>  				   info->snd_seq, 0, OVS_DP_CMD_NEW);
> >>  	BUG_ON(err < 0);
> >> @@ -1876,8 +1867,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>  	ovs_notify(&dp_datapath_genl_family, reply, info);
> >>  	return 0;
> >>
> >> -err_destroy_vport:
> >> -	ovs_dp_detach_port(vport);
> >>  err_destroy_portids:
> >>  	kfree(rcu_dereference_raw(dp->upcall_portids));
> >>  err_unlock_and_destroy_meters:
> >> @@ -2322,12 +2311,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>  		goto exit_unlock_free;
> >>  	}
> >>
> >> -	vport->upcall_stats = netdev_alloc_pcpu_stats(struct vport_upcall_stats_percpu);
> >> -	if (!vport->upcall_stats) {
> >> -		err = -ENOMEM;
> >> -		goto exit_unlock_free_vport;
> >> -	}
> >> -
> >>  	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
> >>  				      info->snd_portid, info->snd_seq, 0,
> >>  				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
> >> @@ -2345,8 +2328,6 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
> >>  	ovs_notify(&dp_vport_genl_family, reply, info);
> >>  	return 0;
> >>
> >> -exit_unlock_free_vport:
> >> -	ovs_dp_detach_port(vport);
> >>  exit_unlock_free:
> >>  	ovs_unlock();
> >>  	kfree_skb(reply);
> >> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> >> index 7e0f5c45b512..e91ae5dd7d22 100644
> >> --- a/net/openvswitch/vport.c
> >> +++ b/net/openvswitch/vport.c
> >
> > Hi Eelco,
> >
> > could we move to a more idiomatic implementation
> > of the error path in ovs_vport_alloc() ?
> >
> > I know it's not strictly related to this change, but OTOH, it is.
> 
> Thanks Simon for the review…
> 
> I decided to stick to fixing the issue, not trying to do cleanup stuff while at it :) But if there are no further comments by tomorrow, I can send a v2 including this change.

Yeah, I see that. And I might have done the same thing.
But, OTOH, this change is making the error path more complex
(or at least more prone to error).

In any case, the fix looks good.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


