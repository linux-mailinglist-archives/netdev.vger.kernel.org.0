Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AAF674CF1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 07:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjATGCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 01:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjATGCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 01:02:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBADEF8F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 22:02:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7YCxOfLil0JW4ovk937D9c6vTP11ES9reJ4+kEIoS8OLLq8SpobgYY40ydyGtcK8Ng5p5VrndMvbvS+lfDbBbi4Ymke+wmsfZWzNzDTR3Qu09avGl21bbp8Y0n7sPGyPZ1HwO3g/ueMJSETtboYvYy1Vcp1JeofFfzHzJ6w8ZpcHO6mB9SqNSzoF2zY2Ww79hOuGYa20RX67uTEHgWnUMNI9F4jbynVdVgAuqjFHyfk/HstX/tRCGMOqiCwNxWXkQqZxIVvp4c5wQa4qTtRYOBxEr5nkR3RELDyMNv8Ibjx5Po71Fq45XeMZljyqM0fObj2acTjHjd6aVuVYnrLZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoyGhVvsTnRj9RumZ44mt8Rb1XjGolZVAXZ4lJPX6oc=;
 b=PR3rnUs0fCoAY7/9tYNNJzfP1+0Mv12Q90dgs2q3ANPyIMQamjTh8x1vls51bkYh8hVNuFtlodYpoHtvZNoWJsHFSmUEpyF7ftMZO400eP6ZM++ODc5cFaQSI70CwtUfaf7jEwBVbKY27cCVzEPggIdfHvgpyh+J4SrLJVyAzlhzvICni/OdvLxlaiNVnWILAwzTEC01uq1Dj+gDSrnOZsOOrKqBKh9PEKj5+aw/od+3Mpb77mm0b3slfcQt6llCg8Nk+XgRIrEGYGp/Ced3BRmUmMILa+lCsvqVjQXKKne5NoOstASQeDrtHsrx9T3beFX+ZWHJQbW2+x4QNQLRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoyGhVvsTnRj9RumZ44mt8Rb1XjGolZVAXZ4lJPX6oc=;
 b=LXKaONuCrR28b+I8vhawXK5VCG3r4v0LaAWVt8OErtRSNsyRD8rc+o1WGGgmmttmN3+m/guScIZyOp8JPo1RqZU3k/LRPhc99lzFSb508ZwXRvl7AwxLstl6vybHAPm+3VbgBiB7xpzW5n55YuD9r/fYXI2En8irnksjHmM66KKNFA4dC2bXEIJozdx6+LDBcYVdt56iQn/SW4WJTWBVHMkDfcyNKUmRa4fOHCwk1/6YWrQKQpMn8iTm/iQt1dGXYju9To5AgsynRLcqhRaBOFU6fmTUOTIofFkDobpfNPReA5rX5lgir5HhnGo3/WqVvgZ1yD2FoOiYhU/kbXSiVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 06:02:27 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 06:02:27 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
        <20230119210842.5faf1e44@kernel.org> <87k01hu6fb.fsf@nvidia.com>
        <20230119214516.59adab05@kernel.org>
Date:   Thu, 19 Jan 2023 22:02:16 -0800
In-Reply-To: <20230119214516.59adab05@kernel.org> (Jakub Kicinski's message of
        "Thu, 19 Jan 2023 21:45:16 -0800")
Message-ID: <87fsc5u4k7.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: ba801066-23b1-407c-d772-08dafaabe868
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Ugx8qcB1oC6BvvSzdDrHZCVj/4FJbkadYaXhpAlaSIySV8qWLvdKbHX8/oyw/xVar5y+HneCU4TmX8gqEwH1XdvVQ+GWk4b8gP2vKKErfihzrjffNJ4Wzbh6YPI77wjv+gLTH9Ul6++Cd7dsVit1x8qcPRQtkq8tvBqFY8uYQNmAJtlnpaGMHcCJ0wAj9foFlMMs7E7FhSc7rYxcWared8lYRVO5L0oc6oaELqJLzugC1AyjTIVlGGZLPt+rkQyH5jVjYQwAGlRi4QMyIrt1cVWfSsnsOufZIPNrqGodXPvmSQFe0ElZGrjjH1Mx1irG9DPObYU2I+8fgjMSTwsKG0fRGO06qEARlko+oR8lRrRWlKzRmomFiphCVZyV30JVsHRT2X2CcZ8FFl+dXez1tVmK/1U/n6dsm7W3dHgUxg6GEbrFDo9Wil01vhIxLnFmwFAEs2DiyGL3ut6ksFjG4wOVom7/fIaKqv4I5i8YC4Ciy0dgFE/BWdSaWcMHJC8YhwhGJX7lIbDiUd1nFVZxIhL9k2mg1MDE+Ai6sTbxbMzDbsD+T0R4uYrvrbUdWinAuJd9I699Bv9KezeF20UOUQRLrTS+N+rhQ2qbiEQnGLQwny1PMwyT9CZP/pxbc03LJSQ5WzgP9wbRVW8KsJ6gdX+/fTAWls1E7Th9ZDBbRH2SrmjHwrLoOvMushDlwNMHohyTrk4ZBVgML2sKYM90Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(6486002)(6916009)(966005)(6506007)(54906003)(5660300002)(86362001)(6666004)(8936002)(36756003)(316002)(478600001)(66556008)(66946007)(4326008)(8676002)(38100700002)(66476007)(2906002)(83380400001)(41300700001)(2616005)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aF7uv3ItusgYtTJJCD0oWzCOY5DNfpBGXodqW4xQhVzg0/kHnsWvCoSdHP/P?=
 =?us-ascii?Q?Q+8cbH/ZZ5IOSwWKnJibZzxFtK6HVEZMKJr6CuH2ugq/+fGH8BcqcHiCaTlt?=
 =?us-ascii?Q?18JhA5xhjxormOJl33cLysctD40c0MXk/D2yD+8ILJFAz/LkyTPWbhSS4BvM?=
 =?us-ascii?Q?KdljupWBvAZrg28z/RDfBkEbt9LjM1HdTVH80HdKr/zxv3UadKvFuHr61qDY?=
 =?us-ascii?Q?xxiXjP5eN4XX+vw+Cj04r7VR42xMfNaAGk0USL/bjGgr/4TLXnAMYxW3/RzV?=
 =?us-ascii?Q?eYuzS5xVFzXATdTjKXw28eFRtr3JWoEWu+w+WCOL1tCm75pQxI8IwxmBXjNJ?=
 =?us-ascii?Q?m2Y+1mkh+K/7rz2PAOGOcLuwtdKX7kDH07rH3l22TFNNSPWGJGuW0IqdM83h?=
 =?us-ascii?Q?NgoQsB0zrizLSEidAlc5Z6n/OAUxH0Xx7Haxpc0alK4Px76JbwD8Oom4gfyE?=
 =?us-ascii?Q?N0jlUZKJubm0Aemw/z0iS/FK1oO16GrUey9z8v9Tbx2i/WSQNjriCrYFKAHs?=
 =?us-ascii?Q?at0FyGDsbpds4Ajr6BTZAoNzynOkDVi4YHZmMnU70PoXUDhnbr4tJ0SIBAny?=
 =?us-ascii?Q?CgEG2NYO+t8ivJsNwSc1sD6Onw6lExgeh7cEwJaIwF2VBTwH4qhGAz1k05zg?=
 =?us-ascii?Q?3T2OtqpEThzWmGaounbcAB6Z2SGRFeB4ntdokA+j5zmafu8ZvzO2MQZl0jjK?=
 =?us-ascii?Q?EXSKjqwZ2yvNz8Xuyp3vvDJF3/GpVvaYvzkEwoyhE4tcnCX+ZvjblDmH0phE?=
 =?us-ascii?Q?Cg5PvRYqa/JAfBQLEdkVKewUiEFhf6RnERC6xVXTYyDav6xoGib10qePfNGR?=
 =?us-ascii?Q?oWQ52r174u6vMlHabZD4COmhwKFjywLZJoi0qJy+nBzfCmv6x7PI3R2L9hlN?=
 =?us-ascii?Q?rTtnY07DRY0gSHRDfrX2qZNMcoQuexnlg/Dru/hDZxPDZyhMtbdrWEgoLQQn?=
 =?us-ascii?Q?Mv2jIZgfonBVK76PXuGBue/wz3XV6YdmcqH98I6AUtdGkN5d75L466dT+4Bw?=
 =?us-ascii?Q?iOrio2YU+PkP8w+M/eis3Ztvs2yUMLcmi4Z7xjIimsy8sp1mQ+upMDI0rcI6?=
 =?us-ascii?Q?dXOlJs/S+prP1+DQgAGX63VHBOWYPcOmTE/2gwMq8KaUF8/xdtAZxwTZFsRI?=
 =?us-ascii?Q?hgneLh4E9iN1KbCDAeXWofOWaQd1L/939WNF+fgb/BscbSoc/5Twk49pFUXO?=
 =?us-ascii?Q?wXa+7WlKzbJUw6/CUhb2hAvoupgAdn1AD4puG14EUoPBpxUv7/1aqc8KKOJu?=
 =?us-ascii?Q?bGRQ+DaQQRMCLH5ZLy7YHm8YDDQ/5EVTxXT8f8p/VORMX4wmQOKEyTMH9FDf?=
 =?us-ascii?Q?haOMRakzNnG7aCJnz5F0ioQAIY9h2C0Y3OpRsUFRGjeXx9VbadsSSwmoYPlD?=
 =?us-ascii?Q?x/1rKf+y/a7BXcQnH5fgt+ZwkF9uhPFwR5tqDuLLpBsO8rTnNghSIQ26c4OM?=
 =?us-ascii?Q?4evTBzSDC03ZCNZjTjovJeEQV0oKbq5XjeadMWC1n2pVw1Zpd4Dbz1Aa2/bh?=
 =?us-ascii?Q?GlDPkLCEA39TPXmItMKWRZpDaVuAe3iRPslsPz6eoE175eKdlGMYTpmHxNUQ?=
 =?us-ascii?Q?u8V260ISsIwX+BsCWEv/1oRyYn7apKiuF37N8PXiItB8fMNbySoOx/ygrL8q?=
 =?us-ascii?Q?zK9POy5PW3NF/V983JGwTIogT4oGFcahIivex0yLc0clgPuqaHAHnAsHii6H?=
 =?us-ascii?Q?HsViFw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba801066-23b1-407c-d772-08dafaabe868
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 06:02:27.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyWqrKy++ppRGhH/QPy2a9cJj9K3YVV3bzAxMepTpyuXe1o/fRIBc1LPBkQG+attLYxNln7xcit/VkoaNyMnqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan, 2023 21:45:16 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 19 Jan 2023 21:22:00 -0800 Rahul Rameshbabu wrote:
>> > Hm, so are you saying that:
>> >
>> > adjtime(delta):
>> > 	clock += delta
>> >
>> > but:
>> >
>> > adjfreq(delta):  
>> 
>> Did you mean adjphase here?
>
> Yes, sorry
>
>> > 	on clock tick & while delta > 0:
>> > 		clock += small_value
>> > 		delta -= small_value
>> >
>> > because from looking at mlx5 driver code its unclear whether the
>> > implementation does a precise but one shot adjustment or gradual
>> > adjustments.  
>> 
>> The pseudo code your drafted is accurate otherwise. The lack of clarity
>> in our driver comes from leaving the responsibility of that smooth
>> gradual transition (to keep in sync with the clock frequency while
>> running) up to the device.
>
> Ah, I see. That makes sense. This is how system clocks react too 
> or is it a local PTP invention? I think it may be worth documenting 
> in ptp_clock_kernel.h, most driver authors may not understand 
> the difference between adjtime and adjphase :(

I think this concept was uniquely proposed for ptp core stack. I do not
think I have seen this explicit differenciation before (but maybe
internal implementations do take a similar approach).

I agree with improving the documentation of adjphase vs adjtime in
ptp_clock_kernel.h

 * @adjphase:  Adjusts the phase offset of the hardware clock.
 *             parameter delta: Desired change in nanoseconds.
 *
 * @adjtime:  Shifts the time of the hardware clock.
 *            parameter delta: Desired change in nanoseconds.

This doesn't really help much in terms of understanding the difference
of adjusting the phase vs shifting the time. The quote from Vincent I
provided in my previous email was in response to a question raised by
Aya Levin who was working on timing related features in the mlx5 driver.

https://lore.kernel.org/netdev/228ceba4-47a8-49ef-994a-fe898cdc7fc1@nvidia.com/
