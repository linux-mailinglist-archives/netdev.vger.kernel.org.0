Return-Path: <netdev+bounces-5411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC330711339
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78D741C20ECA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED094200D4;
	Thu, 25 May 2023 18:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC9101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:09:46 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC4DE67
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGmhgkQ8egsTeUzhZ2zi85TO7j/i0WHfVddVDIcHYd3eufhS93m1/Brqg8I6vNCtbipNKQKuoWfmGV8px2HHGgpeTSBaU7vrcCfFjrmJQ6CEmyu+kQ7/t0LTlSI9knbARgoUqe7BLB1SumdsMVPlKKXX17lWMVIPPmxb7ohT792h22XgJZee/a6ASCK5L8QfV9DbSx2adAFLw+neDXmNmVPDlTYZsABZXX1Llea0F0wi8KD+qERMXbmecu/Fr0vnGkS99EFpRv+P0U6o8tVJlV7GBP7CPHTXuy8yAtUyjpeF/ConzgW9AxzczOl9usfQVHvEi/jtVzIqZ6kXKzNnhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJLy8E88BwgBlAm8f2PrnNuqEHeaYYaNwy5q7sjWfvU=;
 b=kk2OtBrPdDXmQ24tyhmzfUZNXAYg1MSa5GFapbJIDthK5qJgOdJYyao3E4Xtm89Lac0jeoW+5XDmSviY0xsnAYRQLYVyaA2ghd4YWlUwuzXPDjvs+1C1y3ygwMo2VRldwKOquJ5jU6yNxFClhLrUNP2rmYTr5G6tX66fEPsQFTB+PKjvLLRvTH+ITZWzX02RmOIIfM3aI8jKsuFLogDvn9IqXqnc3t99cNJhqE2iD4FXvqCoDylEYjcVSSXHfxqGIZNYQBVx9O7cm/ZgIIOGgbNwFxuHDu2DJEdvBU3JXDtPwVV7ZKc92X8yxFpaSaolehuz20WHjVTB7Z1y3mJYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJLy8E88BwgBlAm8f2PrnNuqEHeaYYaNwy5q7sjWfvU=;
 b=CIMNj0Wf7qScM6sL4E3vOnUFiKH/6aI7H5TRiTwhN2aLwbWtf5mI66XCns7jT90adJRapcF849Dbzxf1ZIoVuCeNOhKD41OsrYAtSg02aG6yiHVYPKH7Aq2DbYedf8w0kHyTM28SSyDnY/q1AlUnhyBzVHpmaTv9oXN/L3m/PZlXCxRCy7WDC/+0mr65YzIqmrVzvLswxxyHUPyK7DfPjXkt+k7CwyAPL6vgz+laRWmrzwa3sxsZyxHzF5Zj6BBVEVF9ttHZTOp76mg3ErXEkAWugQ8bkEJpEmJCpeKU6Vrhnd5Jz/8atRywPxV458nndxndOGrjM/UHUDlHRsnKWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SJ2PR12MB7846.namprd12.prod.outlook.com (2603:10b6:a03:4c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Thu, 25 May
 2023 18:09:30 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 18:09:30 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,  "David S. Miller" <davem@davemloft.net>,  Jacob
 Keller <jacob.e.keller@intel.com>,  Gal Pressman <gal@nvidia.com>,  Tariq
 Toukan <tariqt@nvidia.com>,  Saeed Mahameed <saeed@kernel.org>,  Richard
 Cochran <richardcochran@gmail.com>,  Vincent Cheng
 <vincent.cheng.xh@renesas.com>
Subject: Re: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase
 ptp_clock_info callback
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
	<20230523205440.326934-8-rrameshbabu@nvidia.com>
	<3154076e84914b061de4147bb69b5fd7c224980a.camel@redhat.com>
	<1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
Date: Thu, 25 May 2023 11:09:17 -0700
In-Reply-To: <1936998c56851370a10f974b8cc5fb68e9a039a5.camel@redhat.com>
	(Paolo Abeni's message of "Thu, 25 May 2023 14:11:51 +0200")
Message-ID: <87r0r4l1v6.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:254::7) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SJ2PR12MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b6ec3a-9579-487f-ec12-08db5d4b2f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	60NAUbhvxpdw31UqoqJLMcDBR80gKdXyY9/hUfcXUQuF0JhyNQJlcwDDJEnaBxY1wYHgmCbt0z0Opkz9ZHCliqLigORZ2MYsKmbDNayXxmJU+KgewF/07xojhKO5jMs4XQHm/7dwen9Qi6Gh/IxWJ7QqTlfiTG4DjD6FCryJu5BpLqEmJ882GhKkppkUztkk3Et1k6SCa7Njm9gVI/qPssku02yKgIiq+Cy2HXW2Q1RuQxzpsQmbNnGa6+bV/iPWX+y5x3sab+ludV3TPlJpuobsh1IWBPV9+4j1xcJ+V/+x+zocrNsu7j+rsBbE7QNa8bN5b/CjC5kvb7EOfX7wN1xe2r7YZDxM08skmbLFsdeE156G1UD3vnkk7SKDcxtZvD6KJymTmVG+3LNQqZ6CAivCaM3D74f1vcLwQ/U4Y1eAi9UfDWL5PIX6MCtCs2CG6H/UOkAP/kmzVNckxAksZHALnH7H7DmsdNkvRcfrUpPhmDhfM9XfB9EQySBVmGsKaG+gQInBmcH6R2RiH+ie1qo6vWHP8y1zvTnuyb2vrhOt1cYYGzVcVsyI4+KSFy9tOjOkoF2kHtxRHttKtabr6q++bfZauQFIiTEBurEWL6Z6RMRqL7DZblBkN/3Gtzt9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(54906003)(66946007)(66476007)(66556008)(41300700001)(6916009)(4326008)(6666004)(478600001)(6486002)(8936002)(8676002)(5660300002)(83380400001)(186003)(2616005)(2906002)(316002)(38100700002)(86362001)(36756003)(26005)(6506007)(6512007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hMoLkls/ObcWh/e7fYFMBHeGNaCYR94a8L9pGlXQ0o4TgFjXmOXE3bL33JcE?=
 =?us-ascii?Q?htelQa+fMQnjnZHHe8u9RrUC70MHVYBv1iZ+3utuVbNXTZt93Xs8XjTNmT5w?=
 =?us-ascii?Q?U8jqn+FHMh8tzOtpzeAalZzJwfwMyl2zeFLZZqHi6mrAhzwsckWgkx+XHzJU?=
 =?us-ascii?Q?u483KvkpE4ODTQOVBPVQZbkQYSzTRXg2QXyBRnG4DxD9APxS338InYDlW/qs?=
 =?us-ascii?Q?AfXXagbcNBmgQ6xeJbzQ34mcRPKgNeJX9Hhv64vb8DwaCZncxWlcbja22ISd?=
 =?us-ascii?Q?33Alq143yhMFo93NAJpYjWoExKOhgvu2X9foU+mfy2lq+RdMLTaq38DDYZR1?=
 =?us-ascii?Q?nGkqgubu+rcXJiMVgrEN1Y7RkkKEED8Jv4LP6L4gSP4MRo/dS+nRY5nZb3Tc?=
 =?us-ascii?Q?XejtkBwSaMYXWC3KXE7L9uqeX5rgbyAu9aa5HIU+vrXqCMYZPR0mFMPP/7Os?=
 =?us-ascii?Q?bQAHvDfvv6iYSp6dVhqEjGCgncMElPEm3d6xyCLUsHBpJAhK4D6J+HAxPp1O?=
 =?us-ascii?Q?0y8sG9jQfhDPOMpSvtWVtxoyP9hhFIg0XixybPLQfSATIpQ5gU/1Z0qrjFTZ?=
 =?us-ascii?Q?1XX4N8h5CuZzslhEbzlBe3Oqzh3FK0f0995P9OuVqPJMcOPTdUuq7/boA3DH?=
 =?us-ascii?Q?zJZDUNG2c06CZJow0Aj6oYzmrZIlkK52SCR0AOMxhq9M1Ta4QOWxddFfUClo?=
 =?us-ascii?Q?oh477lsNXC67KYvnI+t3L1P0bn77M/NuwDddyiG11saBwsnecmH4LLrFjeAw?=
 =?us-ascii?Q?fZ/McPlPTxs3QBgzmSQfqaTMEWcRzwQz0ML/nUBse6hykjzirOoWS9csI5Xr?=
 =?us-ascii?Q?WmyGC7CUJlLN+E1Oq9tizzDrzV1JmURo9zI6Vbqd0crx8N17VBatFRW8iJfD?=
 =?us-ascii?Q?Lr3RjqP79L24IGdTK35YvsBQhO29/2C11sJDoErQe87e6UjsrpMZ6tpuiO4M?=
 =?us-ascii?Q?Onxmbn1eAoAPUEPM38ek+icRZ9et5+n7zg95GA7TtNgP2udAKzvmMqCgXKBt?=
 =?us-ascii?Q?tTLcEPPP+EEyU8JEUXxBB/WpfcWn/AfHmXhD+Vkd5WfjBBkd8MmPjjMUxnwJ?=
 =?us-ascii?Q?J9ciSWuMLzRVCMTG0Wtlx+hqQUmXH3c05b5uvHW6khmQAcsujBgSNX4N5k7N?=
 =?us-ascii?Q?UHemNjTU2byR1C9XAufGeEM2aQq5hJQG+gOFnmDf5J1zMepG7+kUavPslRQx?=
 =?us-ascii?Q?nns62iYzSgwHouaF4q6h/vxi6OTa0iJpKtaxIW2X2zexutJl0d+toFZR43EO?=
 =?us-ascii?Q?01Pj+rLZZR1apykASEmzWBjOw0zSXQFHfvvV/oF2/Z4WhohdduZlMuksXS/7?=
 =?us-ascii?Q?wCEUSmcawDi7kYaYp8jmTDuFr/iliRjisA06OC2C9FG4kGL0r4U/ujOTumOx?=
 =?us-ascii?Q?vByYDHzbP5Ej6sY3YLSl/X2mSuoNoLtW4SljofrSHGst0UxXWKkqpSCwsurE?=
 =?us-ascii?Q?/io8vFAg77a7wvWkh7NpwYSW8lUYLh8/BhORz07N82RvIOIFvhXSPYwxnZuN?=
 =?us-ascii?Q?jaxI6jXCq6voHuKyNkArMwM1s/QVGWmYTpsKR/as9LuNAw0TTxuzrncjLvk3?=
 =?us-ascii?Q?F0qbQp7MV5Z1xAt8BvTk6mLwWn/OxSn7ey8RVcUvcmtr2kAfLFEgiyFjf7ef?=
 =?us-ascii?Q?tg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b6ec3a-9579-487f-ec12-08db5d4b2f44
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 18:09:30.2374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VECmxhSPijDcFR6fPRhvSA2itGRwkYjqz46IELPnU1l5IF8DKpp5QcbuYJrhkg2WP7+350EP8ENVNiINBNMeZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7846
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 25 May, 2023 14:11:51 +0200 Paolo Abeni <pabeni@redhat.com> wrote:
> On Thu, 2023-05-25 at 14:08 +0200, Paolo Abeni wrote:
>> On Tue, 2023-05-23 at 13:54 -0700, Rahul Rameshbabu wrote:
>> > Advertise the maximum offset the .adjphase callback is capable of
>> > supporting in nanoseconds for IDT ClockMatrix devices.
>> > 
>> > Cc: Richard Cochran <richardcochran@gmail.com>
>> > Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
>> > Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>> > ---
>> >  drivers/ptp/ptp_clockmatrix.c | 36 +++++++++++++++++------------------
>> >  drivers/ptp/ptp_clockmatrix.h |  2 +-
>> >  2 files changed, 18 insertions(+), 20 deletions(-)
>> > 
>> > diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
>> > index c9d451bf89e2..f6f9d4adce04 100644
>> > --- a/drivers/ptp/ptp_clockmatrix.c
>> > +++ b/drivers/ptp/ptp_clockmatrix.c
>> > @@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
>> >  /* PTP Hardware Clock interface */
>> >  
>> >  /*
>> > - * Maximum absolute value for write phase offset in picoseconds
>> > - *
>> > - * @channel:  channel
>> > - * @delta_ns: delta in nanoseconds
>> > + * Maximum absolute value for write phase offset in nanoseconds
>> >   *
>> >   * Destination signed register is 32-bit register in resolution of 50ps
>> >   *
>> > - * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
>> > + * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350 ps
>> > + * Represent 107374182350 ps as 107374182 ns
>> > + */
>> > +static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_unused)
>> > +{
>> > +	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
>> > +}
>> 
>> This introduces a functional change WRT the current code. Prior to this
>> patch ClockMatrix tries to adjust phase delta even above
>> MAX_ABS_WRITE_PHASE_NANOSECONDS, limiting the delta to such value.
>> After this patch it will error out.

My understanding is the syscall for adjphase, clock_adjtime, cannot
represent an offset granularity smaller than nanoseconds using the
struct timex offset member. To me, it seems that adjusting a delta above
MAX_ABS_WRITE_PHASE_NANOSECONDS (due to support for higher precision
units by the device), while supported by the device driver, would not be
a capability utilized by any interface that would invoke the .adjphase
callback implemented by ClockMatrix. The parameter doc comments even
describe the delta provided is in nanoseconds, which is why the
parameter was named delta_ns. Therefore, the increased precision in ps
is lost either way.

>> 
>> Perhaps a more conservative approach would be keeping the existing
>> logic in _idtcm_adjphase and let idtcm_getmaxphase return  
>> S32_MAX?

I personally do not like the idea of a device driver circumventing the
PTP core stack for the check and implementing its own check. I can
understand this choice potentially if the precision supported that is
greater than nanosecond representation was utilized. I think this will
depend on the outcome of the discussion of the previous point.

>> 
>> Note that even that will error out for delta == S32_MIN so perhaps an
>> API change to allow the driver specify unlimited delta would be useful
>> (possibly regardless of the above).
>
> What about allowing drivers with no getmaxphase() callback, meaning
> such drivers allow adjusting unlimited phase delta? 

I think this relates to the idea that even with "unlimited" adjustment
support, the driver is still bound by the parameter value range for the
.adjphase interface. Therefore, there really is not a way to support
"unlimited" delta per-say. I understand the argument that the interface
+ check in the ptp core stack will limit the adjustment range to be
[S32_MIN + 1, S32_MAX - 1] at most rather than [S32_MIN, S32_MAX].
However, I feel that if such large offset adjustments are needed, a
difference of one nanosecond in either extreme is not a large loss.

The reason I wanted to enforce device drivers to implement .getmaxphase
was to discourage/avoid drivers from implementing their own range checks
in .adjphase since there is a core check in the ptp_clock_adjtime
function invoked when userspace calls the clock_adjtime syscall for the
ADJ_OFFSET operation. Maybe this is just something to be discussed
during each code review instead when implementers publish support to the
mailing list?

>
> Thanks!
>
> Paolo

Thanks for the feedback,

Rahul Rameshbabu

