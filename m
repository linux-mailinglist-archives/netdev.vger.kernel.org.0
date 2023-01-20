Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5F0674A88
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjATE0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjATE0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:26:23 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191318F6F4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:26:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWCvQ2sjDba2VxxR69c2H31WNt4yxFiNK8OEW1ovZuY4LHFYeNRw6QsoEPhwwUNlaY+oR4fBKlpeknhehqgJvtGq3tb9mf8r+kyYVW+lPGW+WFikbwB/EbA4GYMa997huBb+5kATWshfx5D9ZIIHqp9UWQC/SflSoRa7f64yoS7nSf/yg3rgpFVjXuUbygs5oi0oIRu8XdouyvJtVjWS279xnzaYfn3CTy0xGmfraZNtvGcKSu8Yyd7AUeI7XbkyF/3KygV5kyti+Kcr6LeXba0xRD4NmikCnwpoV83XLpwS5eWsmAYt75mGbF+QPKCQ3lg9s/NcVBrnniZ5Qu/qww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cBzhCoOhGEqgdNrPmrH3Fqcaf0Ev0mjKyZaeSmgLr4=;
 b=OJUEvflW1CZjWjoeiRuQmUaGQRgvhioueuc/R+58EzppnjZHfBVgxdVPZIoZuFDLSL1Q9ZyRtYvEXa7jmep2g4GAS4+1GE9liurhZ+RXFK854qvQcfZZf1Uv7l5AaFEeoCsHIcK5IDyEE6dOdPLO2LZWeAwbOscyzwzME2UX3V42j6qAmZWye6ko527QxIEYbYJsl2GvaxI3GnefDjX61jfOYhIpg8NmwI7EMKOhfhJYZyFMPFxRvZB5Eu6vDdhq6hrkzhzFYsdg+UNRPxu1mIM5SCMq5Hao1wrQ7ROIMj3AGuvoDrvMSDO4R+HK6yWkbXxNdUyX286mT0f0PjvbwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cBzhCoOhGEqgdNrPmrH3Fqcaf0Ev0mjKyZaeSmgLr4=;
 b=Sg0czNXcokjuiwxJDffpKvsftZdiy3YEe6Q7qVtQfCQN0zaVcJCgrkhwOyXEU37HOUtEAHv26XsjhiM9rEblFyHoj5Xj/0Zaw0HdGVZmIRiFml5qt4vmysDtK/LmUHVNSN+1FV8HrBNT/CD+UiXyRYCJHHHNeetStzsRCbrgAM9rdYYgaGCDwHsjBwoZG3sWSbdLYp1Xa8/ZYl3CboBJ4Vqkrgt2bVhszCJu1KiEF9bQRd+cxkd/p9U6O/kGLBCcK4HkY+OoHClE30RBClrjCGYWEDJAqm2BGEtm1J8wqQi/FlHCuufbLJBMiZQdmoSUb0vRduwnUE3DjJNCF1zjdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MN2PR12MB4127.namprd12.prod.outlook.com (2603:10b6:208:1d1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 20 Jan
 2023 04:26:17 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 04:26:16 +0000
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
        <20230119200343.2eb82899@kernel.org>
Date:   Thu, 19 Jan 2023 20:26:04 -0800
In-Reply-To: <20230119200343.2eb82899@kernel.org> (Jakub Kicinski's message of
        "Thu, 19 Jan 2023 20:03:43 -0800")
Message-ID: <87pmb9u90j.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MN2PR12MB4127:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a4414b-d07b-405f-c03c-08dafa9e7867
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYPD4rzhPV6BQyQ44UIrjY/UW7HKohYpTidKs0K9J+oLepbC6shib2U0XLUgcG2jeueHlKcyeRWoYGYP0yBCtAGoz4cORD2wgxW+LsKqc65DeKs36xerXLap4/RYDKtSM8RKje4+I/AXUPzhb3iPzgxo+6Bzt/u81Dz2sYwM94q3ylN4vkjbGUV8elW3P4iMcV3UU2bZz7o18rO5+tcNZSUBO9fIPN5emppDJXs/jbcvlKDBtbuiy0oWPYFNSbaL9GIYG+qGlAYpYaVVU4qW4SHLwd/614nqfEMEbB28TaG+15BTDVx//TlV5SAqwudFm60Puti7Ai8J/zjnDbMsoCOib6wr+Fxj3Gfv6wH+C8GLKOQbLkUPkPMTXlmch7uPkofJBrIySduBomdPMkVHIk3CHNV2bzoY+fxskFJKi8OXdRZfwiSNS764iZvDLCxbvOiY6RmIzZo4izGS3GXJhEcYU8V17/hCuCWqMx3g5z31gV4MtphTL0qrtEGD+aP0Je8Y2Kx0hYKov7AxF2dZjdrom9BNoEc/pPjnUmT7PYrGAaf80+J5p3VUWpUzBS506gGgNExbUO1rwr76P9pFrUGxiqdzajI/GZfbM7c/DE8LE+L+6iWXFBfbyKB4VRL2NzfzS1xSOkG5oPzQt2lN2dSp47oPgptcYqCK6eEh+GCLCaqeDECh8AGvlSmeYWhtGNmVlCHVWm14Ahs06iavJU7dfP1bA02qWVKiS468Ekg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(451199015)(6506007)(8676002)(4326008)(66556008)(38100700002)(66476007)(66946007)(5660300002)(8936002)(36756003)(2906002)(41300700001)(6666004)(2616005)(86362001)(186003)(6512007)(316002)(6486002)(478600001)(966005)(6916009)(83380400001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xehj6FHQiSko5iMy3heAV479cudoYHICLbXTyaJo5eAmT3Xoxb6txH+4/yYm?=
 =?us-ascii?Q?BpV/1pHLyzWHC2w9AcSHefV22v25+WyG+ovhaRV5zOyn0E0rdiIDEH9oYqwb?=
 =?us-ascii?Q?YjkE/3ZpLxKAnov9hyVyN2lzD2NHwsEJVt52FT5VlLlFcWBc4UCATV4ytjQr?=
 =?us-ascii?Q?le9YBxwbC0wSq338RMdr3ifS9LdH0HyuS5uyLmSTEOMNKq2RmLedUx2H32hX?=
 =?us-ascii?Q?aWEqct0Of+FgNY899VXoxAIoWjA1lqjPTtmTuIlC66u8cJGdWYuNq0NFbXyM?=
 =?us-ascii?Q?mSWqnDUeykO9MQem2euM1/xkz1IE5dA0uXFTrb4Ppx9t4wTfK33iY6bZQ4hH?=
 =?us-ascii?Q?ecyB1plvXfRSZR8DJejJ0yJzafpoRg8kxfuaRdTVhEzR4Kc3C4PM74prMOqe?=
 =?us-ascii?Q?P3IzHKrtdy2afCTYvV7m/4y47VcBbKTi+DiRovujf7g7ypO8tTT6AKSaSMnl?=
 =?us-ascii?Q?paS7FJFMsH7jMKb6n7vnoKFP+WuuDHhZfL/Z9rZReHwMoSe1JJE/JtjCTTar?=
 =?us-ascii?Q?iDSHEIPxqOqx83az92unvsGuVb616jV9vM/zHayN2qbd6iVzEn+vsfn4+4wJ?=
 =?us-ascii?Q?ynR78xP61JwBacK1pZp05DHm7XyUkn6L63DoP85orkPTjcmsYovoVEzGv5PB?=
 =?us-ascii?Q?guEyEKc9+z/kvixowMy2sX+6qer6P+O5SoWDoo/ReNoxq/J9uYaf03MqY+dz?=
 =?us-ascii?Q?JpTEStD4wcaLF9Ta7ICi9qQh1qB4ZGBBNkpdRNEHZ6v+z6TiZA5J/v7BkG+r?=
 =?us-ascii?Q?hNxuS5WF7VeS+NeuN23gPQyNshV3Y9xy0BI5vFt4LZHP4pi1LTuyH6m3FQS0?=
 =?us-ascii?Q?UCvg2KRGSd7ZsDDee+teC5Ers7dm5c6QO/3nNihwUa6UF2tsh9O1PRolqzmh?=
 =?us-ascii?Q?ugQ09C6UcPoA/w//dV2PxkOM12TVjhAHDCwGpsvDdeCdRzZDYoUAxH7r3JVz?=
 =?us-ascii?Q?5IjaZlo3/ILSLVePUwhF50CzRHgo3yhzDtQUC7+soMkTZVtWPsQ1KvG44eCT?=
 =?us-ascii?Q?A14MLE542OqewhH02OMvpHBDVmZZ26xBbuEMxl27AwOmNW5hARxhHTIlzDzg?=
 =?us-ascii?Q?FVGsG9YhmgwdP0Y6nRxhj+Fr1HCbTIbLaqASijQjFxkrVVZJwDd9PGgsPben?=
 =?us-ascii?Q?xQb6MOkxozhKqX49HXTkRbUEnq+TDEOUsegW993YjmlIGEowqlXQiio2NwRS?=
 =?us-ascii?Q?cKo7YE5J9Qbx9jYmpa7a/SIcmsZsEO/y+1YtBkqT+1tHXBRXIdsU7qVCHEtx?=
 =?us-ascii?Q?FsVLvYRBWGlar1GRKC+vJoshDfNlfqLQUN4AfLnfZsP6k4fsL+1qc2zLpN/L?=
 =?us-ascii?Q?Z/Y8b/zdo+6Z0/ragxTdci7fC7dx4ehAJeY5TMPs6ZmlEA2nTjpu51cUDWTD?=
 =?us-ascii?Q?cXiw7YxeLDuEXC3qgVG6/D0wWgvfzfrfM2TEWeIe8Xcc63lqJEGIc0EOsmlN?=
 =?us-ascii?Q?3yD87D2wSYw94Yxdr8o2gyB9bGMrl5BySw4KCvJfYd102bEG5XFnjL58h8qB?=
 =?us-ascii?Q?AyAWmfs2Ay8Zefb6frUSD3sUM8N9P/muqkN6aDj5L+uGv/PhvTz68rLWyo9P?=
 =?us-ascii?Q?dOXhrmMs4P5bsSgce3Cy1wh7LkQ4kOy0BMPFwoT3b2BXfP5+3CqHh7lF2rNR?=
 =?us-ascii?Q?DC1WyshuPvVA1h3Fe2kQK97dux5a/q+2ICqIRI2ZFIv9BROVuhEFGDa2r9kf?=
 =?us-ascii?Q?c794jw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a4414b-d07b-405f-c03c-08dafa9e7867
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 04:26:16.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0G2MzeDiPCGAUnF2RLHFOQ1rxGWJTLx1C67cA56nOxnuT2j+J6claPYAWJZOcWzabvmlaTZTgHEXZXycT6XEbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan, 2023 20:03:43 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 19 Jan 2023 19:56:24 -0800 Rahul Rameshbabu wrote:
>> >> Makes sense. Once you've verified that the delta is within the accepted
>> >> range you can just re-use the existing adjtime function.  
>> >
>> > Seems like we should add a "max_time_adj" to struct ptp_clock_info
>> > and let the core call adjphase if the offset is small enough to fit.
>> > Instead of having all drivers redirect the calls internally.  
>> 
>> With guidance from Saeed on this topic, I have a patch in the works for
>> advertising the max phase adjustment supported by a driver through the
>> use of the PTP_CLOCK_GETCAPS ioctl. This is how the ptp stack handles
>> advertising the max frequency supported by a driver today. In linuxptp,
>> this ioctl is wrapped in a function call for getting the max frequency
>> adjustment supported by a device before ptp is actually run. I believe a
>> similar logic should occur for phase (time) adjustments. This patch
>> would introduce a "max_phase_adj" in ptp_clock_info that would be
>> handled in ptp_clock_adjtime in the ptp core stack.
>
> Nice, can we make the core also call ->adjtime automatically if driver
> doesn't define ->adjphase and the abs(delta) < .max_phase_adj ?

One of my concerns with doing this is breaking userspace expectations.
In linuxptp, there is a configuration setting "write_phase_mode" and an
expectation that when adjphase is called, there will not be a fallback
to adjtime. This because adjphase is used in situations where small fine
tuning is explicitly needed, so the errors would indicate a logical or
situational error.

Quoting Vincent Cheng, the author of the adjphase functionality in the
ptp core stack.

-----BEGIN QUOTE-----
  adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
  adjphase modifies the frequency to quickly nudge the 1 PPS to new location and also includes a HW filter to smooth out the adjustments and fine tune frequency.

  Continuous small offset adjustments using adjtime, likley see sudden shifts of the 1 PPS.  The 1 PPS probably disappears and re-appears.
  Continuous small offset adjustments using adjphase, should see continuous 1 PPS.

  adjtime is good for large offset corrections
  adjphase is good for small offset corrections to allow HW filter to control the frequency instead of relying on SW filter.
-----END QUOTE-----

https://lore.kernel.org/netdev/20220804132902.GA25315@renesas.com/

Using the mlx5 implementation as a reference, the mlx5 stack provides
the adjphase offset to the device. The device is then able to make the
sudden shift small offsets internally using the device's internal
functionality (offload). For the larger values that are handled using
adjtime, our devices perform just fine when we get the time from the
device, offset that time in the driver stack, and write back the new
time to the device.

>
> The other question is about the exact semantics of ->adjphase
> - do all timecounter based clock implementations support it
> by definition?

My understanding is no (though anyone is free to jump in to correct me
on this). Only implementations with support for precisely handling small
PPS corrections can support adjphase (being able to adjust small offsets
without causing same or worse drift).
