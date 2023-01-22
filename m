Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F92677299
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 22:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjAVVMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 16:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjAVVMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 16:12:17 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6D714E82
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 13:12:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeEsbl9138JIdq+bcYjDwTEzv1+CX5pHtlyEy/28t0a4lKNp5fb/MeZEkze4NPv3hFVTohSqRgwLnQQXBT3FaOzShgZVNUR6wVXWf3IagIDBYNkgQoJDLKJUlqck02FLUnMx+lIaI7T+0MZ/0FUMb+oWrUqnaTvilsfY3T8fPSs7nn/DUyQJXl7NIyIa4UaRsSps+dLxg45EXKFuY+9Raf1drC/EMSh2AEBMaRaOzK66KshEBJnd5XKiVLou+t4tRDYFfdNKGZl9e9ZU0gxyNNKUomB4p1NdTX2p32ANkqf7UyugyuT/CbuEH71hDPTRj/fnBwYypXgcQygWW19EEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+BjfNQIx18qwpdvsCR0xl3EJOhuV3JRkeWFf7QYd64=;
 b=JHoLaelk8stPXOd4uvloOq7C/1sh891W/gI9U+k7+vxKyk+D1mCiS98luoA2+nUFbzsQDO+/k7gpomjvTDN5GxEb5rjiFykqIWYSlTYAPEpV37krtZLUM5+6nx1k6rR62L0uxOD6MpTvfCHsXQl1mPnNkwbTzUr9ylvscfQ2U8hHyznsSPz17FgeDXxWMCAcOxLGM1VZpSfvem1e3lXeVUU9+iVoPWEyJOQ2dKFd4GX31z4uDU07KbxmsnqhqzxdoBe4HH1oeY3ouxZ1ACEWW98odZ1k9cjHkdVqvnFXwif0BQKqIxP4XQw5bXlYZbHRCH5RP6ySBKPDMm6W3Tol7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+BjfNQIx18qwpdvsCR0xl3EJOhuV3JRkeWFf7QYd64=;
 b=IsdqREyjYJuyRV9K+21hoXbQPcLH2wej/FbFQyBKYRZe9ps9JBam7edV+EDmavE0EmbKJ36upqG9MGwW+WKAb4+HwsgeQTk2TKhpGNAle6fKfrohO1qVaS8RZ3q4l46jKH9gPcw625/evuG52YS0kczVSUNdksL7h4QfmN7NRHU/V3h3cNX+a+s2AoQ5Tgn+0JJW9J9tQd+OPJAOlbnbgdKy/Nz/hqxjX+6DEi4+uBkoGnDXtRBJRC26qpQlhZeyeUx9TP/Fductp7DL/QmI6c8xG4yoT7q6MP7oEzIySnRpzdSz5Xf5Y9ZA4IbIo53GPKTRpeoz3mRiGU2/kO6DfQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 21:12:10 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.028; Sun, 22 Jan 2023
 21:12:10 +0000
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
        <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> <87r0vpcch0.fsf@nvidia.com>
        <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
        <20230120160609.19160723@kernel.org>
Date:   Sun, 22 Jan 2023 13:11:57 -0800
In-Reply-To: <20230120160609.19160723@kernel.org> (Jakub Kicinski's message of
        "Fri, 20 Jan 2023 16:06:09 -0800")
Message-ID: <87ilgyw9ya.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0136.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::21) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: e22cb187-d9a3-402c-f32e-08dafcbd52d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKX1tmy/ScVm/t2LJjW/Qx0SRAmzvd10tYPX1CqlzUAvbphhtV/BPlpTcJbk0W/aBCiZURFaq5B0wIzXtHxoGp/CYnL7LF8XH/47bBpJPVNV5CVqMMk1VRGvSGUKEkPMONlgW2zOsV8lL1nmJrfeATm8AsBnVcjXg5J6vD9V2RWNJCi9RVDyvGckFX7BoeFczHUJ04na1EZXerFn/55pEjJeVm13qcooMnAsy7DN49sGuyTNRtO6qNsEJdv3n+8JE+zLpUHbBYALyHHLTR5BgGmPQ0fgLvUTGoaDJTZsjm+nIJ/4/U1lzC77/ElnoRcKFAOotMVEbgbprMiT9tEUApkCb++SOUENWD8EkEpFogL6nUJetXfDoWwuGNuedEl4ryBUyzxxU87jNMiPsUX/y+s5sLkjBDuz/I9X+wj+lfwspFrpKFkKb1vzD2sSM0MS3q+BVI28ne2PR8+0IeCSz49gtNK8CmN4Ew1+OWpp5lChzETaKdjfMA7luvEsBx89l2YuA2yyknoMd62/jdTG4SIEioH7gT+7lkFUHU/FfTKWNE8iHgzE3bhvQTgdiZil0TtsxdFbt0Sj7RWNInb2eTM8IrDgIWwRWy+c0ZXlnK34f9GFA5jpP+J4+Oxo3TO3rdyE7UlormY97fYhcopgfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(36756003)(6512007)(6916009)(66556008)(4326008)(8676002)(478600001)(2616005)(66946007)(66476007)(186003)(86362001)(2906002)(83380400001)(41300700001)(54906003)(6506007)(6666004)(6486002)(316002)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4uj3aHIaQo2fFDYHv0+RxaCDFJn1tE+VyDyq3oKroQbUbyn8DpvqfbNwnOi8?=
 =?us-ascii?Q?1c+D3LDTfgbjNinUcYgB/z7BERV5n1A5FqrZxUofi/0NdJ6oJEAIkRe2Y0Ju?=
 =?us-ascii?Q?cXp6D27X4C9bBIaWUIHX8m8UkQzCcol5Yg3QEvxVO6ofg/pHvxr+HBBPIYBI?=
 =?us-ascii?Q?Rto8nMOX5gMavHCoqW0pkHN7+TyQMltaAa/Z3XcLXqi28nN+nRpLILcj1d+v?=
 =?us-ascii?Q?D3ORTbO5VrWZu9GVlCkDLmJo3kLQOdZq08xv7Q35QB+9RfznHRVJSeeM2pqz?=
 =?us-ascii?Q?R5wy3m8lL4QpNTzoqc64o/kxpCCjk56WRUZB8Nvu9az+GRoRUPAcaChADSRt?=
 =?us-ascii?Q?qn+hheMbwWtDGeO3bWDACpyEaq98wg7Mij+u8aW8euytxn7QbHYEMviDINZs?=
 =?us-ascii?Q?hZkDPa72mgHNCbz918lFDpXdwl2SsQbOh2BtP0umdiGvO7judJPLb5Az2ny6?=
 =?us-ascii?Q?zclJAY6IYzrm8X3BoUu33K5T1kwqehWTozpPuA2rZTkhU8rXG8dU9Q+EQDEh?=
 =?us-ascii?Q?12LqxGkqOFWoWiw6ScbEZ1CiDR31B94mVvkJ+havsC6GP4+bRce9Xn6gWVu6?=
 =?us-ascii?Q?9l9YXT4BiYt3KN+4i9d4c6toTASosUJENrFlG0xMDZd3sbljJ6IYjAYJfDDN?=
 =?us-ascii?Q?dU3K6dzDR+ckGnAhG+pyjQ8sxm2xOSwIhZigTq0GO/jKTU5YrgCX9kRaVbH/?=
 =?us-ascii?Q?lSoTiXjchgxEEh7vgDBfclkhCQhlqhW7EQjI72NPDsRMXw0qu4T0XtYJVrOM?=
 =?us-ascii?Q?EpP9Hibe1cinUhFqrAnqfQCjGrPM0dYmex7reVqq7JVM9sJksmN69p+2jMha?=
 =?us-ascii?Q?L5XBtxsuq2AV45tl70uVBuppkihlEnKTIko/fGeo/hPEfPD+4p/RzP5+Jsfw?=
 =?us-ascii?Q?HaIPam6ttxa35ISlfxCcOSy4oJOZLPn9XJ/fpsBcS4llCCOLr3IK5eWmB32s?=
 =?us-ascii?Q?jkxNzhND4kCmNiZ3l9R6vUpg+VT0zcmT5BcFnADpkLz3ot/Mnf1HEyzmKhNS?=
 =?us-ascii?Q?qMQB9XDUpWxqDEgJe+tFEmxg85TrRB/77V0GnZ4mFzuYvOtqMdF8/hBFmITO?=
 =?us-ascii?Q?iBlv7Mr483uwUfFAdE6RovlWvrp4ymUuWxEewE1mtD0IlldQVYuC+VYVlmFg?=
 =?us-ascii?Q?gngiswM5wUpHEVZ+VFolANpDhSnSk2xBq5fIukzJfiH4rY65TgYXnLRpytzr?=
 =?us-ascii?Q?gnzOkuaRmErh19fZnBhn+Y5oSCmDP8ivAdHrkaMzoDiwbPaEaf5jOi2KlsA6?=
 =?us-ascii?Q?99dFIgUlKR5dHBP38awLNCBheTiJfYdQXfRT0AKstU9CUh7KbPtXVtZ58RW6?=
 =?us-ascii?Q?2v5IplHBxi/YU4c+SjmXffnrvSsfMcga7l1L1Q2c3dCEScLSXPaYRQvEYLra?=
 =?us-ascii?Q?xWsZm9LNfGaW0AfIeX7jxTfl4WbVnidFC9RdajgI6R4C1bgEAiAF4y/Djqif?=
 =?us-ascii?Q?JjBonhs+rie4WDmCtxi6/TibJU4QV8dmZzs/kZXfNfob/VePFmpBZ/F6Qa3i?=
 =?us-ascii?Q?SwULtJ6TJ3UcW2TRbjlcVzsXCqwIhFo0zI15BMxML22p3LkslUvoJMcLKQH1?=
 =?us-ascii?Q?FP6doAg/KxwZXKpMtXCOegV0tq82s2rX8RkwWAoGE6G1doewOci0ssyrjnE+?=
 =?us-ascii?Q?9BqpZ6MsIbb61ygKkQ4Un8KH0jejDQBwVKpWiuBb2JGeLbuL4uTYr4LttH+Y?=
 =?us-ascii?Q?w2SHrw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22cb187-d9a3-402c-f32e-08dafcbd52d4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 21:12:09.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z89UnfflTU88hUnQbAnSr4ZRPQ3dZLQBGMXF6lSVNSwB7rE3rPNfNcgDVguw1ioLt1BhqbBqpXR43BHB58Z03g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Held off on replying any further till I verified my understanding with a
PTP architect on our side. Looks like my understanding was correct.

On Fri, 20 Jan, 2023 16:06:09 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 20 Jan 2023 15:58:25 -0800 Jacob Keller wrote:
>> Sure. I guess what I don't understand is why or when one would want to
>> use adjphase instead of just performing frequency adjustment via the
>> .adjfine operation...
>> 
>> Especially since "gradual adjustment over time" means it will still be
>> slow to converge (just like adjusting frequency is today).
>> 
>> We should definitely improve the doc to explain the diff between them
>> and make sure that its more clear to driver implementations.

Our PTP architect also was subtly confused by the differences of adjtime
and adjphase when the adjphase patch was first introduced. Vincent's
follow up helped with better understanding the difference.

The way NVIDIA devices internally handle adjphase is to adjust the
frequency for a short period of time to make the small time offset
adjustments smooth (using some internal calculations) where the time
offset "nudge" is applied but frequency is also adjusted to prevent
immediate drift after that time adjustment. However, we aren't sure if
this is the only approach possible to achieve accurate corrections for
small offset adjustments with adjphase, so I would suggest that the
documentation be updated to state something discussing that adjphase is
expected to support small jumps in offset precisely without necessarily
bringing up frequency manipulation potentially done to achieve this.

>
> Fair point, I assumed that the adjustment is precise (as in the device
> is programmed with both the extra addend and number of cycles over
> which to use it). Yielding an exact adjustment.
>
> But then again, I also thought that .adjtime is supposed to be a precise
> single-shot nudge, while most drivers just do:
>
> time = read_time()
> time += delta
> write_time(time)
>
> :S  So yeah, let's document..
>

Our architect used the following to compare adjtime and adjphase.

  time adjustment is a 'jump' in time while phase adjustment is a smooth correction.

I think the thing though is how that smooth correction for small offset
values is achieved is not very well defined/something the implementer
can define. Will update the comments for adjphase in my patch series
based on this.

>> It also makes it harder to justify mapping small .adjtime to .adjphase,
>> as it seems like .adjphase isn't required to adjust the offset
>> immediately. Perhaps the adjustment size is small enough that isn't a
>> big problem?
