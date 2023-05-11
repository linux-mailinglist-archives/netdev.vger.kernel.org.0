Return-Path: <netdev+bounces-1945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2A66FFB41
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 483B51C2103A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B614AD53;
	Thu, 11 May 2023 20:26:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E8206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:26:28 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64EA49F9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuUUMBCTXdzr9LYdo5DafwLpCrC6GFMWmSGr4iV1weQrp4yHtDVFqcDJK+rXv9/QBYsZYNswi3/d9F4/8HAFKDK/ZKKebGDJXxSqSPBcrhBV7X34GXZAvAVLWgKeKFix3E2fs0k+9Zx+n7A6qHrEU8RkM4x/JghDuZovgr8AK0bGjesLYCAzhtLMCcvRWMnEXeWau/TtNmvwug2BE2NHnlkDecfOm9DiugiFr12BrIHb5lzPl2Ra2SIsF9LW1hSYBWFKkWv+tDAWHl2+Aos7FtZWOiQuCYN0M6aK9zTTEfbxKS2JC+jLWDkPn+C4Zxz8zdwIB9DSRh6vyOQbxb8rGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URG4e9C8Yfn1uzjOkQWT6JQmSsuygb7IbrOPOp76pSk=;
 b=g3dLylZW+VqZOqdk9MXswiNzaPXDIVBbvwXUycMZWCM06wjDLuayUVPVRYff6rFyTFFIZKNlaIXpC4u3SW06L9qOFas4wU7o0u7KYR3S/zz/WZyF9xGuF8odYVFwZJ0qLk00DDbxOTrY09vq8EBFQ9B86HT8K3rzd9gRJehGDGxjhm+E6omASR6gm1vwn5Ydoh1uu9FD6Mjy8ky+YYYmhQQsekTHP4L1hN9mTHn624/wDrtk9+vDLqHN24MFyIpLPRhp7EQ8llcSopybnwxnhSNVyiIpfGMlk3Mug6bm5xhuRJyaJUFgelHiqgWeGS+nodTgL3T1NQMORKytom5OCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URG4e9C8Yfn1uzjOkQWT6JQmSsuygb7IbrOPOp76pSk=;
 b=Wga0gnfAyb29afXad2x9X+AZ0n+ximhRR4PvoXutWfjO3iwSAF8xZu5DO8cUtt8zSoI8Sz5wnZRzIzEJRvKMM2g+ToeVfT/z0EmNIjkAd0rouQgvA3TCkD7zmWxgOdORt5vVofz9ceA/oogNUkWgHJ8DvK/8sgcI9Sz8UiQ/GiHfwl/Ln8Wj07owGrq29SsTPQ3GNynsxhMlsuouLpDMfdeoF2/clgws7RB2/MFNifvOnxljCwE8X0SwEXfYWjzj06QOQnZPOGAVubMs2dzdd4vsrdIZ2sxjEaCSeeKRarGOARItvlGn/zJ41Bkffqt9mHnOPkjpiRzIpXztLIR3SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 20:26:25 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:26:25 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org,  Saeed Mahameed <saeed@kernel.org>,  Gal
 Pressman <gal@nvidia.com>,  Tariq Toukan <tariqt@nvidia.com>,  "David S.
 Miller" <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>,  Jacob
 Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 0/9] ptp .adjphase cleanups
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
	<ZFxRqRUT9XazAl8B@hoboy.vegasvil.org>
Date: Thu, 11 May 2023 13:26:08 -0700
In-Reply-To: <ZFxRqRUT9XazAl8B@hoboy.vegasvil.org> (Richard Cochran's message
	of "Wed, 10 May 2023 19:23:37 -0700")
Message-ID: <87pm76zkbj.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:a03:332::23) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: acc04655-d6ca-40aa-2636-08db525dfe47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FMsMhLyaBH22KTYo41mfzfFzNapP0+G4xJTkTrHTPAPxIxxBNYEGJ5hfu04yuzHL6Bl+fMtmgTqt1UakurMjtiWPNu+uwjVd66L7Xgek/GGXZ3v5nMNS1DP0jbYWJrxJdpPC22PwfD5XGtQ8qp4FCuYUpjVkMZYFQKR67yM8EVwTQqvnENoBBS2I0Jn3hk4w7hX6VM7G0XUJSknDXOH2OGm5SGRkTDMU5/Xw1nH2tfhnorVbusQ1j7lKTqwZht5lmIdi4i4u7UsJyx/3JuPc7KV3mW1+JmYJUIMTngCf9brtIrh1X2y/BOgLgWCVOePlOONgppICbYTnHIlyfYGUmj3fnMhfT/R6nme96+LZBwNWQtmkb1kYRoTHi9iE+8BVC237Jswdv66QxdwkAa9h+qust4KLdFlIrXaAtsKNRQQTo7WPT2/wEChfP183YiNxBvn4e66ODaaJ6v3w6PsVQ9mIMZPvvra9A3r83igLh9rn5cCz3PLzRsx8UckHH60ggXJP3GNZqyXd37s/ldcbGldiMZbnFPAvXjjH2g9Xq5VmsIGRybVLB4GorsAScrNn4rwZSiGWn6JG4Y7xhgTNK6N7MXRDJUxgDKKTzAUDKb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(54906003)(83380400001)(86362001)(6506007)(38100700002)(26005)(316002)(6512007)(41300700001)(5660300002)(8936002)(8676002)(66556008)(4326008)(66476007)(66946007)(6916009)(478600001)(186003)(2616005)(2906002)(36756003)(6486002)(6666004)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enU1VmFJTDgyZGwxenhFbU8wZm1HNFMyT1NJa0FRWXR3Z2YvUE5FcWtJWm03?=
 =?utf-8?B?b2J4M3g2U2VuTWpmd3dEQzRiekJtSmtVS2VoT29HNzBERmNCK29SeGFoQXky?=
 =?utf-8?B?SmVuTU55N2twWnExQzB6Y1VpbzI4N3o0ZWlGUFJrUENiN09JUUVDdFlteFA5?=
 =?utf-8?B?TE5sU2o3bWxhU3VsaHZYcnk0MGJIVVVYc3FpUkRHSVFOWFV2dTZ2b1pvbE1J?=
 =?utf-8?B?NHFKMld0amlSMHRaTWhIcnFrZUpBTmpjeHF3amw5ajByekdQeHNGSGk4MGs3?=
 =?utf-8?B?bVkxU1RPNml0aVVuTThQZ2ROUjVtTjk1cmptYmF5bHk4YmJlc3dMVGpmdHV2?=
 =?utf-8?B?U3hibzdWYWxLTVEwMjRCZmE2WGJMQkgzSVBrWk9CZGVkNjVmTzF0YUk2d2pW?=
 =?utf-8?B?UmJvNVdvZDkvWDhXUjdibGxZNHJFa2pISlJ3WU1ncGRlNHo0K1hjNVp3YkZo?=
 =?utf-8?B?am9vV0hVeURtb3JGay8wbVpvanpESHd2U0NRNWpxUFFwdUtRb2YwQmo4S244?=
 =?utf-8?B?eXhpbFdNTWRlRW9YQW9aTGVaYUVaNFMza1c2UjVqOXVra2R1VXBrK3RRVHo4?=
 =?utf-8?B?akNoYkljSVFZa2o0ZkV1NlMvVVkwOHVVTkFtaGRUenhyYVBMOVh6RDIxR2dB?=
 =?utf-8?B?NU5jM0ZSdFExRzBoMTRPVGgxOGc3MFlKTE9XMGRyeGlEcWc0V2JVcVJGVThs?=
 =?utf-8?B?VVdTMENOSWxZb2ExWjE0cjZ6M094QU5wbjRqbUVmdHRQTU56RURqNEhJMVk2?=
 =?utf-8?B?bklYdDRVeERMUTJ5ZUxGNDVYNTJZM2hwNktyeGRjbk1pWlJvUjNMUDh2K3lT?=
 =?utf-8?B?MjQrZUlGb1JtbktWRGZ1U3RYNTBGNXVWNHBJVExPdjNScENUMHNvZURySC95?=
 =?utf-8?B?SDlDbWZFYTcwR3phZWM1SFpaazdmZHZES2RhZ3BEVzdYTFcrS3FZMWl0bExO?=
 =?utf-8?B?VUhhOC92YzlNMWhrbFBMbUswSEVZSFI3OGdFdk1PSHJsdjVMMUE3YlgvN2NN?=
 =?utf-8?B?RitsQ2Q1b1Z6RllXOVkxYnFaSU9YNXI0bGZ5Ymk1VWk5RDdGeXNaempmdG03?=
 =?utf-8?B?K2N3REtiU2JRZUl6dkMzL1o3ZnBDTDBTbWIrWDRVbWtLNHVTTG0yL0NRYkxz?=
 =?utf-8?B?WmtWTHBQK2ZzVWNGM3l6YWVKVjZ0cU00MjYyZGRZNzJlaXY3R0VEVnRURERO?=
 =?utf-8?B?ZkloUno0RUQ5NGViTTNSYzBUVU1TYVFqMVd5ZFNiTXdWbkx1aFZ3WktzOWVU?=
 =?utf-8?B?azBEOXZxQkVOa21zSkhEWjRCK21zRUJXZ2xrMEpaSjZkdmEvMytEem8yUG0x?=
 =?utf-8?B?djBwa1IwRTZpUTZhSldhVE1qVzdVM3FKR25SM29pN3NiSlY5a09NUTlSZGtT?=
 =?utf-8?B?Q3hnaFRaajVZbW5EM0RjTjZIRmczbUUxUkFaUnh6UmhWZ3ZKZlY3NG5Jd1kz?=
 =?utf-8?B?UUpzNXlyV0JFYnYwTGo1aGNEbU9oNGNnWjFpSWJkd2x1aWhnemFVUHE0RlI5?=
 =?utf-8?B?dHdIS0NHTTZTZURqWGQ3cmtrTXQ5SzF0enE4TVlnSm5MUlAwdjUrdjY5bEhz?=
 =?utf-8?B?YnNFT3V1UCsrN0lBM2VFQ3dZWUpBOXBzOC9MYXFMS3BmSjIybE9hTUdLZVpB?=
 =?utf-8?B?bDhReHFaRHRZK3VWNTFPTXYvTTQxY01sQlViU1pyVjhacmxjcHFKTldwQUVN?=
 =?utf-8?B?RDhDcys3cFlhMWVVRGhSaEtVUUMzY2NQbHo5S01oRHFQajM3Z2FvdXNNRHk2?=
 =?utf-8?B?YlQ0MWdoYUdsRmtZeUlldm1BT3RCUDg5WVVFVXlTOW0wVFVpRE0rZnYwWFVR?=
 =?utf-8?B?Vm52ZWx2cmNJMGlVRXljN1p6VHNlUldqYXBPQnJWNllIMy9LQm9qbUFkdE1R?=
 =?utf-8?B?TkRNK2s0WG1VbXVsdndBV09kbXpCZVJnTEFobGpDREE1YTV4c3h3RnpIMFRw?=
 =?utf-8?B?a2VLS0VDOFZDL2ZTd2hrVDZocWN4SG9XQjN2TkhZWE4rcmhkU3g5dFA1SEp1?=
 =?utf-8?B?bVgzaTk4YlVTc3h2YlNoY1JuYkZQYm9xdUNnOWcyNU9mWGtQSHB6QUg4UE1U?=
 =?utf-8?B?RkhJTFhmZTZuVm5QUjMrZmErRmt4cEFlN0Ewc1p0VHNhWCt2am00ajVoS0ky?=
 =?utf-8?B?RFRXdmQzbzQvUGxndVVBUm9waVVuSk04YlNxOTI5aGM5c01vZnRQN1M4Uzdj?=
 =?utf-8?B?MFE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc04655-d6ca-40aa-2636-08db525dfe47
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:26:25.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7xVda6vo0d92Gb+oOcqt/f1r5ACM3QHticMeMWYKg43CxXnGAruOVazSFXheZDiUTQDQW6+YRYRXjhBhjb3oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 10 May, 2023 19:23:37 -0700 Richard Cochran <richardcochran@gmail.c=
om> wrote:
> On Wed, May 10, 2023 at 01:52:57PM -0700, Rahul Rameshbabu wrote:
>> The goal of this patch series is to improve documentation of .adjphase, =
add
>> a new callback .getmaxphase to enable advertising the max phase offset a
>> device PHC can support, and support invoking .adjphase from the testptp
>> kselftest.
>
> Let's make sure to get ACKs on these three...
>
> 3600   C 10.May'23 Rahul Rameshbab      =E2=94=9C=E2=94=80>[PATCH net-nex=
t 7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
> 3601   C 10.May'23 Rahul Rameshbab      =E2=94=9C=E2=94=80>[PATCH net-nex=
t 8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
> 3602   C 10.May'23 Rahul Rameshbab      =E2=94=94=E2=94=80>[PATCH net-nex=
t 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback

Yeah, I had a small PEBKAC issue when the git-send-email command was
invoked (still had --suppress-cc in the commandline from test runs in my
shell history)... Will be sure to verify the CCs on each patch when
sending out the v2 for this series.

>
> Thanks,
> Richard
p
-- Rahul Rameshbabu

