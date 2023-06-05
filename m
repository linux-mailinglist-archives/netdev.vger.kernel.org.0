Return-Path: <netdev+bounces-8046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D537228EB
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BE642812B2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5078B6FD7;
	Mon,  5 Jun 2023 14:36:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A41A5238
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:36:07 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2101.outbound.protection.outlook.com [40.107.92.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E17F1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9C4KZ3NcR23djtssbW1JW3cryDgGj8W6p0pt/WIrI6RYrqMG8rw3OT0C1sqqlre3iiBbNV29ZhCLAnHbxsSVlk5UNCYu2s2vytIxgdjyaMEjLiRrF75Ef3m/AqoaOOwLWzkrE0mu+BUZ2ft9ZQRMaN/vMa2cVhRfIjaiLL88SP6dnZiTcGfhKehbCSn+Gkacyf5bfuBFVBbwsvVQwUufj4R+31Yi9mdeGDeTEL68sE8PQ+excXiQkhsaGwekLOw7uvDNVncJa4tdxhYCWiVc/popQ76uhFxaXNEuTmB8nDGKYPefxuQveHdL3MJcVIYTyUwEOnySjMJTKnBk61BqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPXD8UPS9JcsqJJUUVmDyAYBRZuHfQd872FArH3d/L8=;
 b=g619A8+T58MiQQ0/QWehjJ22tdGDWrSOv/oqXJkquuyGHCnFRkzkDMib5EJ7CbZ19Nytim3hxFcXuQPHDXhsdRahe5boPNxF14fQVZjhqrI7qBTbILqHqytBf15qpHIgZhXE1jhgtByb027sQ0Gkk853lqBRXZdg+KVGdJbeAjQ6iUgBu6/1JNy+8wULv8YrYluyVTYC2TqO2LaN8WxoHP3rhqpKpmTQet4gHvP0JuGC91cmuXRJVPNi+xikusJ1tqRXYJJxOgSjEvVLzX6UXHpwAG+MA5BxJnD27+NZ4x7XzGQJUbBIJxSfWiZq6AUVPY0H2LhGPmHpIYWpPuvxKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPXD8UPS9JcsqJJUUVmDyAYBRZuHfQd872FArH3d/L8=;
 b=uL+rhbVaJqbw4QPRYs+wC0YRoCL2tZQvO1+hneg/NsfjN55qLxgbWrgZt91i4NYi9adoQnE42/SFeX+WegZvfJfAtoAwprTtDn1zdE+AtE6UbByu3Ugl8460mTMYoKMtSNUtYzJqIEsJ8PEP7qwQTezfxW+5O/2MiPt8NFrm7r4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4468.namprd13.prod.outlook.com (2603:10b6:208:1cf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 14:36:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 14:36:04 +0000
Date: Mon, 5 Jun 2023 16:35:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <hadi@mojatatu.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
	deb.chatterjee@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com, tomasz.osinski@intel.com,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, khalidm@nvidia.com,
	toke@redhat.com
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 10/28] p4tc: add
 pipeline create, get, update, delete
Message-ID: <ZH3yzbbkoQVSLuFL@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-10-jhs@mojatatu.com>
 <ZH21GzZ6HATUuNyX@corigine.com>
 <CAAFAkD8psofYNvFdKhT48NH-4SF+4j6b=3+L9X9GibuUejFeaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAFAkD8psofYNvFdKhT48NH-4SF+4j6b=3+L9X9GibuUejFeaQ@mail.gmail.com>
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db62493-f4d6-4d98-3f24-08db65d230f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7rII9B/vT5Kx82CFAhZCa0hnt5o7lmOrnh1KHXoMR10LhRv2IyqijGUF+JimI2CI8RAwa3djo9WzJO2S53I1KDMFk+nW0CzkzRfjrwdXMRPXOCSCYTlASMzOHDgEZ9KKZNVJZ5yQ33rynnXY9yTLxRHLlkIBn8xG0+izRzaaLB8bN+PI5hbnWdu+nxT9zZ8rQyUE6tlWJ8AeTvKk51Om011EB+7MBRwX6XJ1mtr57AaVkS3MeGMO2zVg8cb+rFkKiFg7rrpBfZzhLpI+1piRHkx+3b53g68eOGUtFXQYGuNC6ApaxQQFe2iTl+c4fj1TOVCVsTYlN0VKljTjjs902sWq4XoZiyEv+/wFnRUPrRnnIKtVUm80i3kD2HDaSRe1ncqUO/KpEOQhhvCeqDbqK+89PIB5uYbVCYXPnfTzCtgabTuXM0iozc970b87gbEf29H8fU/PsJsKaBfBwpGnjyoPe8k43zFovTu8kBnjncNSVuMMbJeJPIl4b6qkSS8kMBrm2JpE2VxKWhgI526ZzlV0szt7wyn5gJZNy4/PZtUocazTI5wVNQoe+sqjWmBBFZ+yvVa+Uf0I6vSRUfspTC/0sedyBh1RNBHMrco7cJo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39830400003)(366004)(376002)(396003)(451199021)(83380400001)(4326008)(6916009)(38100700002)(66556008)(66946007)(66476007)(6666004)(6486002)(478600001)(36756003)(186003)(2906002)(2616005)(8676002)(8936002)(41300700001)(316002)(15650500001)(5660300002)(86362001)(7416002)(44832011)(53546011)(6512007)(6506007)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWtaczdZWDI2Y0ZhS2FYK0wzM3pzdDg5MnppeEI4OUxwandWT3lrRmFmMWpY?=
 =?utf-8?B?KzM1Z25ZLy8vRXdSWkpKRlBweFRCTkFxVVlWZENHQVJYclA2cGN6YTBSN09I?=
 =?utf-8?B?UTcyMnJvd1VzRytVUlBTK3lwZ1Y1cE52dFdmblREOCsrTU5aSlZvVnhWRFc5?=
 =?utf-8?B?ZnJFMGc3c29MN0xKVC9FRjdhOVdFSEpmN1VIaUpiVWNiM3RWNkJsMW1xcDl1?=
 =?utf-8?B?U3FLeHcwOEt1c0N5YXdTOVpWR2hwa2h2SVYxUlA2bDY4WjdLRmZ6eHhaQWt2?=
 =?utf-8?B?ckY5WXRobEFQbk5OWVR4RE43ekdicG4wZGpzN1dkV28rdHUyR3RxWXN2T01m?=
 =?utf-8?B?VVV4RGVxTG9maUs4WXdwcG9vblJLVG56NTFQNXpHNDJ5VFVuTUx2ajJRS2lD?=
 =?utf-8?B?WExscWl5eUxwTEkwZUR0VmV2TXFMbmFJbDlWdGhQQXZiVXdaaDY4cVpWR1pX?=
 =?utf-8?B?UjRBM0t6RTVQL3FUNVE0V0FCTFJTRFZKd1F0amZ4WnhqSkhEQ0kxeVVld1hq?=
 =?utf-8?B?VGFjUE96QVYxaTZ4cmRxYk9RQytGZ3kwdHlZeG1OeXhndlMwVkNUczJHeExO?=
 =?utf-8?B?NG1pTGNtN2Rwei9SS2RjeVJ5UzVxcG5CeUpoVU5ia3VJcEk5cHVoSC9od05o?=
 =?utf-8?B?U3F3bThjYS9oeUkwMkxhRWZPZTl1YnFGUmZkbWlLOXB0Q2dNZy9yU1R5YU1o?=
 =?utf-8?B?cW5SdVd3cmRJZW5XZGQzUk5wL0hkV3A2M2hlK2Q2MHFYV0c3cjNGVVJBRHdX?=
 =?utf-8?B?UENjbDh1Q2xIWG5JaVV4cmMxQjRORjNWYnBrRTVhdHJYTzBuWnpaK0k4YktH?=
 =?utf-8?B?dWZQcmVOdm51ekJnaTM5ek0wTWd1N3ZWUTNKRURFOEFiVkxMbFJkNitGN3BK?=
 =?utf-8?B?S2ZaK09yRFl3Y1JTbVpCbUNXeDFha2xVZ1VQTDI0RWNmbDRYd0pla3JXc0l2?=
 =?utf-8?B?NHN2WGJHOHIzN1JUTjZLK2lIdXFBU0tBSVllSU80ekk2VVVEaU5OYXM0UlJH?=
 =?utf-8?B?c1Vnend1UUtCWVdFNWkyam9zakdIdU01ZWFoNlZ3aDk0R3JsTUlZTlVyL1Yx?=
 =?utf-8?B?WjZTQVp0WGduUGNFYXdKdzE2YUdSSjRnSDR0c0F0TkFxemdIV3p2UzVmenIr?=
 =?utf-8?B?M0xUWmVZelJWUkNyOEE3WmZzZkx5MHlhcENkK2ZIaGFwdmp1S3ZydDNMSmhU?=
 =?utf-8?B?U0U2L3UyYTJ2a0J5dlRjSzBZdDEwN0JNd0xYbEd5aTN3RlFLMVJMd0JaK1or?=
 =?utf-8?B?N3lUVXNIVXEwWi9sdFE3Q2RrT3d3SEJUempsa1hWRENhLzBvclNINlZIWFpx?=
 =?utf-8?B?YnRycmY0aGJnMjlJNWwzRU44THd1N0ZjZFc5RnBCeEJCdHdBWWo0YzFPME9w?=
 =?utf-8?B?RElnbWtJN2xpcHlrSnppdDBjMG5LakUvVkF6K3U4c0dkRWF0bXpjdUNNQUxt?=
 =?utf-8?B?dDkyaS8vMStzNGFVM3EzVndQN2doNTA4eEIwSkJxZDVZUzhOL1pXczRJWWpJ?=
 =?utf-8?B?V0svYi9TcUl5TUt5M0p4Ujl1amJrMFVpOGlxMUFXU0F4WEpnY1FtVFcxWE0w?=
 =?utf-8?B?UDZ1dElKRHlFMVI2Q292dnhBWFFDUGNPSWNudDBxaU1FVVJGWkUyVzM5WGRp?=
 =?utf-8?B?UXEwbE1ETWRKeXR4YlhkcEJ5OFBZT09pVFp3UHFTeGxZVlFhUjlsWnp4M1B3?=
 =?utf-8?B?eUtINjJyNHhhYmpUaDd5eHI0VmVkSWg3TDd3R0N6WDhOdFExM0VrbTd4TjBK?=
 =?utf-8?B?TjRlc0tyMWVPNDB4Z2N2WHk3YWJoODBYL2d5Q0RDeU5GdkE5MnFlejZVZ3hL?=
 =?utf-8?B?QnhtVmlmT09QWHhWK0htcHN6aFlCWmMvVnV5Q0lJSFBDaHZkSXhDcjUybEE1?=
 =?utf-8?B?Z1JtU1FQMTVpSkxGMzMwQ3pLL0lHQUE2aXFJYkpvK2FYN2c3MWlHaEpISGw0?=
 =?utf-8?B?N1ZLbFFKL1JZd0w2M0ZIL1VJMytuZlNXWEVCWEM2NjFPd2hXbnFVVGpzaVBI?=
 =?utf-8?B?NTB1SURhMFl5bFYvZlowMzROZXBvb05jVEcxVnNLcjU3cDRrWWI0WVYyeExw?=
 =?utf-8?B?V3RaeFVaSHljTVJFVkJqbDROeWsvRDhMY0MrZTVjRUY1TWRNajNMbXRuUmJF?=
 =?utf-8?B?OHJwRTdZOUNQRWp1T1Z0WmVaZ2tNTXNiRnJvV0d4YjdKY0NzTU1zMkd5M3Yr?=
 =?utf-8?B?L2lMN3dBK1hoZXVtVktvQ1JlR20zWkpzK0tCSG1QMllHNTZLeGZjMEFJK1po?=
 =?utf-8?B?ZWtvejhhelp1aFkrZk91ZnB4dHNBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db62493-f4d6-4d98-3f24-08db65d230f8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 14:36:04.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsjotC39DcezswEOlQ3EsNZMaa06TRX2nLnctDE5YfSNVjrgCazUUS3DBoqH0W9WU0DafijMSGfdN4DjPPQEx/jn1K6V2YN/ssumOYh7vzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4468
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 10:32:20AM -0400, Jamal Hadi Salim wrote:
> On Mon, Jun 5, 2023 at 6:12 AM Simon Horman via p4tc-discussions
> <p4tc-discussions@netdevconf.info> wrote:
> >
> > On Wed, May 17, 2023 at 07:02:14AM -0400, Jamal Hadi Salim wrote:
> >
> > > +static void __tcf_pipeline_init(void)
> > > +{
> > > +     int pipeid = P4TC_KERNEL_PIPEID;
> > > +
> > > +     root_pipeline = kzalloc(sizeof(*root_pipeline), GFP_ATOMIC);
> > > +     if (!root_pipeline) {
> > > +             pr_err("Unable to register kernel pipeline\n");
> >
> > Hi Victor, Pedro, and Jamal,
> >
> > a minor nit from my side: in general it is preferred not to to log messages
> > for allocation failures, as the mm core does this already.
> >
> 
> We debated this one - the justification was we wanted to see more
> details of what exactly failed since this is invoked earlier in the
> loading. Thoughts?

Yeah, this is not so clear cut as the glib remark in my previous email implied.
I guess the question is: what does this extra message give us?
If it provides value, I don't object to it staying.

