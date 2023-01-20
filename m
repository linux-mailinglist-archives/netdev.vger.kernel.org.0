Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A230B675C5B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjATSBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjATSBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:01:33 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A4E94CB2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 10:01:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jzh7+EZfcvD5QvaaewgVRFjVcsXFl9Ti1oWWz8y9Zg7EaQREG3qiNIsDHvriz0FtQVaDlF5jXVSUzNmCH+EGUbyAJSuO7jNETgHTTfilYhqgrM/whvgFZ9bzPwH/GgjGWPnN3ikai8oHOVPybvWX/vJMruBtGyVda8HiZ1c1GDlAAYTaMcs2KAT0XIposSznrsg5Aydk9baFJtbLeFHUwpGpq+iRc9WhBHpvHmJk9jbDSl0ui7wOh5vzkJbVrsstMJH7oo+Ls7phzF4ZbvJQkMUM7kHHTQE1R9guxDFOhZ2AzRXtONLtsLK/F6LH9vWBEY5e8T5w8Cn17DmdExJXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6NDHYXYP/bVucxMbnETc+rPuraPYgPbZ/jmfR9T8Wo=;
 b=Gc6wYV+DkQxpgUD/s9CsrAmOH+SdSEXwXyLmFkZ+FujHk36QrwpxiETOYhqSNTbS20X/XS/O18kSx2wDrhm87IKlA46nj4bCBnaXXUJZKaCXqMD9OERgICAA/tbrYKXwfTstyhkAiD+9GmsDn79wjqAiGDz7lcFG93CVp8kpaxAAnwwuhw3G9FnyikGhhyZ/mdbF2FuVekv6O/ZxoWlfGCWdzOIvdnIJ5kS587dOgs40QSsPDS7+ZqPqatYzZTc+kH11h3sd2yImdG4wZJS5+qpEdU9dzWNTMI0SzcEowZAge8xOzwgjhs6r/zGuOpWrREBPOs1GsiGE7biVk9j41w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6NDHYXYP/bVucxMbnETc+rPuraPYgPbZ/jmfR9T8Wo=;
 b=Z1kPFZ4U6TIf1Qa5wgl3hRWatKRoAXFENZFL+/v5BozXqU2A9BiChU0HClzspYixXqdQzLUroiSthgmW1rtB2n1fu90v/QKsJNJ6GMX+u9GthGL3PpOsP34XTKNZlwOtLbxTT8Ahir5ZpDQpUjYPp2dR406ZP0NaUeJdiqdIAd6HV6/UxmOJcqJNwVIL3AQ51Wuxmfw5FsYK4i5boErkJDlUk4Ks24Ilz2BpD2pTGUM0F5FGJIcVYSPFvFHGVnU+2V6awuKvmS7ciGsYKlbCm3VBZeAgfwljgakpbAeWI93Psl1iCJEF6NKswW12/vJEC/Fq9GGZGvxBLvFzK7jM8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW3PR12MB4508.namprd12.prod.outlook.com (2603:10b6:303:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 18:01:12 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 18:01:11 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
        <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
Date:   Fri, 20 Jan 2023 10:00:59 -0800
In-Reply-To: <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com> (Jacob Keller's
        message of "Fri, 20 Jan 2023 09:21:09 -0800")
Message-ID: <87r0vpcch0.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::19) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW3PR12MB4508:EE_
X-MS-Office365-Filtering-Correlation-Id: a34c7ddd-2c7f-43db-8d13-08dafb105083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xiYQZXSNIuQiKhkqQzoH3Zl8OVeNf9rEP//UD/H0EHGi4WdFA1+Wqgw3OmW7u+dyTz1HMp7q6wySUxsyfKnLE7kYBVatQhHKigHGzdwr2kktyy6OswifzxWlqGGa/6hFY/kRll3My4cZwmQE+LOkiN3y/bbRxF93/LbwAsUstU8c0Pm8vXhbaL6+1MUov42LLIU7Q8U87KNNYIRByfVJNYmaz+6ltN1MqdgjspN+lf/v3jzkkPlkEX+fORHybu5LwgcMkX+9cuYJcxtOB2qu4EZkRh9ygv4HVi8no8Z40RkGsfvAMEyjVt92E08a/iWRuofa7FXDuXp4ik974R/NHzzsE6EA3rT04Iel49YEShcSodsqf11fe9ttu9qPuiqd//sG0dx4icxeSz1YypBKTTtc7yoxAACHQbfMS7faorwqflr4J/W+cdL/kl36pUMAiA93vYIZFDpWoghcpFH3k6qgDPwHFh9TIIOWB6tOXh8/XLETLVBITnewYOEYPBrQV8rCSLEcq+lYmDXoDtZAI0LIaKuDc8hwCtVktycVBKWlKO/G8PKmjUmgYv4MTE3qwt/mdZy62ijU3jvaLTl429iyU8JskHsA1Os+klxZbrWpwnRz+XCef57+JgZz1cXPUQ5O3Evekr/LMj09HeX6UP5epwCXyxwHCISUGqv3Hr70YDgcm+rFOX9keFXdLTQ9oVVMoCUW0AV6Sm0quuvsiQGZa4UQ//L0rDZkgYMTDAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199015)(86362001)(6486002)(53546011)(6506007)(6666004)(966005)(478600001)(83380400001)(8936002)(316002)(5660300002)(36756003)(38100700002)(66476007)(6916009)(8676002)(66946007)(4326008)(6512007)(41300700001)(186003)(2616005)(66556008)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+XtvF8AyOFt6XSegSCexTbggbMqxQVTsc7ynihfoaDfvhsM5ukkhSnRNHMV8?=
 =?us-ascii?Q?uJ4igUTfTTL5rTyQUAheTQzJOSPTeb1gwQI+PWQiy8IVbfmitSTAZmTVL3nc?=
 =?us-ascii?Q?l8KNENm2yjaTn0Q4T90iQKEOYvcPH/iNtwrvXR99M8RnbRTVsNnyiZkm+HNN?=
 =?us-ascii?Q?QdLuwNeaZdYZvwxKc2b4isDy5CDRAuQB89vGQcN+31ToX8HjmfMM3+6Pk7Yt?=
 =?us-ascii?Q?vIQIBa5kR4fvWWhA/aF2oXEjDzebI7hZMi2Z6KO3xHDFQyK5Wkr/6Wne5lSq?=
 =?us-ascii?Q?PU0lGEC7BamV34KBvLjxw96gEkjf59Cqx9Vqts8qk/NKtG8C5Wh6JSCVOBuL?=
 =?us-ascii?Q?aIx71U7WRmBcZrsMOZOhm9iFrAf1sQDq8wAy001pb02Zcbll7PDMAtZPPLDV?=
 =?us-ascii?Q?UDRoNr4h123LrzAfpmDyYjO+k/vzl7H8F7QiDVx2tw4PfvtBIhv4hqRCQiam?=
 =?us-ascii?Q?qeULesnGBKC4R+Rrcg3DDIO7aXsT++0F+zMhNTU1yab0mKoWG5q50E1zx1H4?=
 =?us-ascii?Q?C71oaMVOhlenvBku9NQkoq/14zSL1AicCmfF8OvDRaFbaCU8DvSUuc7mVAky?=
 =?us-ascii?Q?4QkWGy3J4ecebpN39/tt8BbEMuoGvAlnmsdBqOstzYcDycVoZahnqpgmMUZQ?=
 =?us-ascii?Q?yoA7IP+e+np2rwwtXz7eB9QhyqiX/uhijeilf5uokaAxI5FQzQqSpmw3iNZ6?=
 =?us-ascii?Q?RvW8Y7iAWG9kHkL0q/Dg5eedOYwhl26bMtyxUnvR7PgEBA9qDi0TwvwRndSj?=
 =?us-ascii?Q?DFt9wj+TV/t22v4gHwHGAG3MTEdzGys9em72BPJOe5cu9AYmFwP4ZnxeSZ11?=
 =?us-ascii?Q?Wm5wf/Kv+D4CrXgQzFIos2fJshrtxPJBT8Sg2ZQdxE7F0nuqWECrHcW1zTTK?=
 =?us-ascii?Q?df67fBY3cSrt/3Ju3FOuYsOT8wEvt/YU/iu1p5nkUZH7S8y5n2JUnDHY4pqQ?=
 =?us-ascii?Q?mCS9DdSnQPKiHvHQnvNqrpw6bfh4gy20Z8ZyHxrhTzeT0sXt+WspfDHbQYdo?=
 =?us-ascii?Q?7Z6RCA27NBl0i4nlLDwV2Q4KW1rX9shNmK/eIHQTxX+PwtvtSb+w/HZ3OpKA?=
 =?us-ascii?Q?9YlZYwEmqhabmSStj2LZsXyQ6ld9FZEeNRxU1enyWoOrj1OtXXfDlfOLkcBo?=
 =?us-ascii?Q?AEOaj5EioDfsS/dIIUMTpbrW3KwugENESpGafJ5xrffxoLlxEN3RVCxjkLQJ?=
 =?us-ascii?Q?UOsvf00P/CxCRUFDWoMovRWqX5cdV1+b3LDo2Mm+w0SSymGRi5L4ccYyciHj?=
 =?us-ascii?Q?IeS7g1a/dTFzHGsa9yort6khSs7uSwxlDxqEc77pIYHDxAOuzwhYPa7QO0Cp?=
 =?us-ascii?Q?YdXQ7dG2VbS9DVnyOO9oF/+g08jS6vAV1pXz3gcNOXv7FL06wZPX0RhokAiI?=
 =?us-ascii?Q?oBCogjNxB03q8xssmo/Jc1bHjc36+nay6SpvEJmC82wRl7cgBgELjbFRfi1/?=
 =?us-ascii?Q?7pw+YVOdEeh1qf8NBEY+p5t/tb+2njpUA3iYZzQpFvOAeng0UWAUxQSRJ34C?=
 =?us-ascii?Q?Fo0PV+MF/YA4FtnHxFIbafdHQkVW9fB8K9PquFS5hh+UBr4+YsYokq6J3UWK?=
 =?us-ascii?Q?cAe6CooMzh6MOunk7VlykXXw4cam9Zeq8NaG7U02DIZyCgB+x53Gjq3z+eLv?=
 =?us-ascii?Q?RXG09wvvEsno1nuNiTMgcX40Y9qJzbYkoqz5ACaJk/CM1rfQwn2SNym3eAmH?=
 =?us-ascii?Q?6Hhtxw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34c7ddd-2c7f-43db-8d13-08dafb105083
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 18:01:11.7380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Bp56UygjJUCbBXNQ7iNlkQWp+y5+THkzbuOslYqJ3NgcTFcfYik1otlhz0TVk8X6uqZ+gXuMuWbSr6/tJRH3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan, 2023 09:21:09 -0800 Jacob Keller <jacob.e.keller@intel.com> wrote:
> On 1/19/2023 8:26 PM, Rahul Rameshbabu wrote:
>> On Thu, 19 Jan, 2023 20:03:43 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>>> The other question is about the exact semantics of ->adjphase
>>> - do all timecounter based clock implementations support it
>>> by definition?
>> 
>> My understanding is no (though anyone is free to jump in to correct me
>> on this). Only implementations with support for precisely handling small
>> PPS corrections can support adjphase (being able to adjust small offsets
>> without causing same or worse drift).
>
> I guess I'm missing something here? timecounters allow adjusting time in
> an atomic way. They don't lose any time when making an adjustment
> because its a change to the wrapping around a fixed cycle counter.

If that's the case, wouldn't adjphase be implementable by every PTP
hardware clock device. I agree with the description here but not all
devices provide this atomic (phase offset control) functionality from my
understanding. More details in next section.

>
> How does that not comply with adjphase? and if it doesn't, then whats
> the difference between adjphase and just correcting offset using adjfine
> for frequency adjustment?

  Some PTP hardware clocks have a write phase mode that has a built-in
  hardware filtering capability. The write phase mode utilizes a phase
  offset control word instead of a frequency offset control word.

The above is from the original patch description for adjphase. My
understanding is that some PTP hardware clocks do not implement the
phase control word. Hence why I responded with no in my original post as
in no, not all PTP hardware devices are expected to support this
capability.

>
> I guess adjusting phase will do the small corrections in hardware
> (perhaps by temporarily adjusting the nominal frequency of the clock)
> but will then return to the normal frequency once complete?
>
> So adjphase is more than just being atomic...?

I assumed the phase control word is more than just a simple one-shot
(atomic) time offset done in the hardware (at least internally what the
hardware does when implementing this control word).

  adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
  adjphase modifies the frequency to quickly nudge the 1 PPS to new location and also includes a HW filter to smooth out the adjustments and fine tune frequency.

  Continuous small offset adjustments using adjtime, likley see sudden shifts of the 1 PPS.  The 1 PPS probably disappears and re-appears.
  Continuous small offset adjustments using adjphase, should see continuous 1 PPS.

https://lore.kernel.org/lkml/20220804132902.GA25315@renesas.com/

Looking at the mlx5 driver implementation, it does look like a simple
atomic operation. That said, I wouldn't consider myself a ptp architect
and am mostly going off based on what I read from the patch series that
introduced the capability in the ptp core stack in the kernel. I do
think this needs to get updated in ptp_clock_kernel.h.
