Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD53674C46
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjATF2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjATF1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:27:36 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21E7AD18
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:22:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXHWRknBAU8gZ7/wCDA4Q554rigRA8STdKnTGqGfOh0rJ5wtvPJQSLhjIImswvqp1iu0wYVIKAuNQlFa4WelUK5+13xc+qnfbHbTal8m2Ot4YHFxwwtjiPJoVm/xbNRiwPXYQAIq7hBs+j5pApSIlCSIweLCjr7D+/FupOmhllcOXCgL4l33GabWBRUpMFqS/x4XkmjrXkCnufusZ2aIcwMYKaoIjHCQf9w0vdByQtlDbwATt1nhGrbrY2U8A5O5GGwN4t7cJZR3sm1cks/sAQkGRNiVnaAhe6AUzkC7bgyjUCLobm7lldSH+JujXIdG8kx6zANGNANzT2Ch7N7prQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEnd/i7wSJzIq5WylTkNnto4fLZy3tZYso7ANh0iGVE=;
 b=VfZm0TAK8kbovlpmZ3E+W51INzEON/hdDjeuBZB+FFcSALCZ95/xDCIoxjhGaeh0+N0vKnh7raAr2TuMxHLLaQnYcAbJiL9zuRmu32/k6boT1qwOjvnv1UTy5Szr1hZKoCJzAP9lLbdJnrf3XA3fGiFOXaVbNiy1fI8O2Sls0lHE23SD7VUGdHLU2A+47lhXiqgaCY+Y58aOaFEgJrDQJK8wo2Nh4CEcx3YpLlAATMIQbtBlRjJ88sUX6Yyz8dUq+CABhRuvArG7e+xPRIuurl1oYYMrktHJzBC63GfCJFl7dg8vUmmGlgXPVAcVPnCWwVrd9VcRY9C3D10SeMr4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEnd/i7wSJzIq5WylTkNnto4fLZy3tZYso7ANh0iGVE=;
 b=X27CxhT/soU8X+VIyFvNRjkzfqnfGC6if4TUWH47O1H77pAmnegIJQd2LdANsF2INgD7KR2Yvf8mxyA52O1utiH8I+rQp5RyZLwHj8z7vxqzf3IX52xuWRjZ4ZlB3wV62PU0hBve+waUzl35GyDV9xr9POxYAi4FpwuNCFuZLsRyofv1aMuJagUN52dQT8PmpvnFL9v05TWCugbZa0AiARSO0P4X5rJZw4F2lIlKTHsy34QhFzmwISVZV/3BPoyJ8h7KsV5882i/ng/kTQsVlpRX1fAXCF7UELQp26biO49HBtOs8tCHF0IgV6+OtkTz7aDJR2Oi1EQvYrKMJ6u04w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 05:22:17 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 05:22:17 +0000
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
In-Reply-To: <20230119210842.5faf1e44@kernel.org> (Jakub Kicinski's message of
        "Thu, 19 Jan 2023 21:08:42 -0800")
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
        <20230119210842.5faf1e44@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Date:   Thu, 19 Jan 2023 21:22:00 -0800
Message-ID: <87k01hu6fb.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|BY5PR12MB4322:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2aba88-7b40-446a-02e8-08dafaa64bb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2qFL+J2bF7LO4XKJUoq67XRsnb4u11ELjsYPwXeqeUWTBiGWqUmqzix8Po6KpK6NoVPf2oNH5h3zfsu990qijgO1co8xvcBnCOAZ4UQnIUwoTq3yKows2prnoPQIjSwvGB0gfI2KT9RtXMNfYCmEASTjuaDqZJdidP5brqLQnpHPMHVnFUzA/Vt2wooojreqEOuOGAl9I3nhoVmtOMRn6HScbEuwnVkFEv88OmyjIXI4M/YVC2LVZwewhuiJvmNOdIFDg1PXRCi+BM9lKNzbaqzGvAWHbXRYm12OzyRy9sVlmP6p+dLda+9SEpMy5TFNjfbJNhqRPUnudcuG/JxzbOWyTre+lUm7KDFmVAtxHqqWBp0azTdnFtMuSWZ4dQgBfI5HZFgGva6BoGNbv4fvdAQAIX28XQBWtSTn41tfJihleDs9l0hP0HQuCi3CU4Ajk8LRsJM2fxtGazLG5TPxIsHQ+uSte8fqFhcEhvY99/52oyVT4izvMS3zaDkjuw4OpllvGm1zgRLYWqANv3rQEob27zW+OqThILPTTvhtiNIHvYZzdmvroD56fNV/OLfAAxpK0e/r9E1HKW9l2GGdR1jPnMhL3j3K5Awrwd+KHbWbr13cQxrqZZWCU/MwljqZHnJvp2KGYkUk/L1Pxj93A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(5660300002)(316002)(54906003)(36756003)(2906002)(2616005)(38100700002)(83380400001)(86362001)(6486002)(186003)(6506007)(478600001)(6512007)(6666004)(66556008)(6916009)(8676002)(4326008)(41300700001)(66946007)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kM6jvT05dtDIztKNWVBHHE3SnJ9FJe2a6/mO3LTDBYsgsp3qVhuoi2Gjnew1?=
 =?us-ascii?Q?r0dgqfmVyD6aRq/TFTF94tbdJgL/cYXq8J+dMZEACk8/rBOd/32dWYNB9Bxo?=
 =?us-ascii?Q?LZftDXpLf2wMgSiK8e5KpedY0tHv2aFTbYN7J46UX7YfcvFJmsi/8W7ayQbg?=
 =?us-ascii?Q?WIhGptn3rHuL8Ggx2JnjrfA75ggzGcc8ZGbQ4METKCR1wTKYz4FI7FGBLpx3?=
 =?us-ascii?Q?CtcMaJ8LK4PkE3jsMY5bWCuaLOyS0zJFKE/P+0Evv8LCUajxZdpuFNcuBTDV?=
 =?us-ascii?Q?XNQqfl5MYnZAHa22BVw3EtTv+DYXwdka6g4M0Y4nHPx+uf+E7DdZoyI3Hfe8?=
 =?us-ascii?Q?SbK4KeQNib4hDHyq4R7RpekkZtqBFKWbKtgbmxXKIt0WI2Swvni2XbonMg+V?=
 =?us-ascii?Q?UoEublWaDROFwpAB3sWMaauN8Fk9xlWplCcoi4EK947W3x2e6dLRP5IxEtOo?=
 =?us-ascii?Q?KJ9Cs8Ol83YtxsM3EqeBBYeM/YgJzBgFdSuPCUda14qRnrA1H8pncPs5AL6Y?=
 =?us-ascii?Q?QrQNin7BeJ7wg4e1ck0aRlseujWjG5BtKaqKW4NK76VYusGV+WwfuYQtOd2i?=
 =?us-ascii?Q?SnHCeQvtn5szmvZ/lLhLVANUFuHxsGNJgrQ6OzZ0mNFbliI1z24yOcNlnEOq?=
 =?us-ascii?Q?EMTAH3PyZk92KznoMm6lqLdLoqZrtC60PS943f7gnbM5f/7sFcFns72Hwx75?=
 =?us-ascii?Q?xKeOuHtYCKh4z+Lx/5x+FyVbWPNAdc7jpaLvMFVG57JhTd9kSgTCX0YYaiOv?=
 =?us-ascii?Q?AwpR68MaIgeyvHp3q0Q3Oosqe9TOtCpgRq7sSLeh2qBgvxMZ7egzVwFTdSeX?=
 =?us-ascii?Q?ruj/j5bcZetzTT1rD5Fhy+VjwBbZ97B6stUdXCBKRwuuioc6zGrhIrTpC8bP?=
 =?us-ascii?Q?UGP7Bf8ryXCdOJ8YpmCsBeRiZ+5MgGE0qfq57QCFXqfSGlbK5E5EtAiEBkOI?=
 =?us-ascii?Q?6XqwXqzbkcgWxu2mOgxdwNYrCsPlil1B3reKgS7F/gq7jMB+9XU+avR+DCI6?=
 =?us-ascii?Q?Zzrbcu8H4pFTu6YN9GGlZ74ffJOgTnfHnoUU1oDhtkcl3QlF9/CjYhLUOUAK?=
 =?us-ascii?Q?dm+W01vnkFq5BPAKll9hnkj5il3VS6MGobfE0OJURNdrJ4SZl+z+00dehATd?=
 =?us-ascii?Q?1AO6RfoMzyx7tBD/Bo4eFYLhZ+r6Vekn/uK4PWHNXZj2GrxrsVzqM5T84iTh?=
 =?us-ascii?Q?HzZla6UUjorjX3NU/24Lf9mnvcBOus3o68qQ2uvu1RKRxW+Ra2CB1dDZLsDT?=
 =?us-ascii?Q?J/EDscVRLjlw99OeT7qR73Qr04bWYnq9N7KLz9yEL5D3ma58TX+ptsbiu1Pr?=
 =?us-ascii?Q?7RDbH9khsmQkUZWOC1s2FroZKLzSp8M2PpgfDKHRqYAwv7G+CO7ST8TXzrKK?=
 =?us-ascii?Q?fEJmwegbDWhBD7p3GSacG8VWBxEOgDxTgDeib1N3eyUFF/MhsnqOKyuy9wXZ?=
 =?us-ascii?Q?iAA1MSP6PIT22LtVGvzf3tUUVyHsUI3M+DFq5NMRKrcRSUtnMAt4fYN3G0aq?=
 =?us-ascii?Q?TcE23U6h40fqLZ6JXgNqFU63NSHRvzTAK9KmnGhn1dXNoBdhMhsrQ9w1lOeO?=
 =?us-ascii?Q?Hv9nq5g54gABeyVXTC1Hlo/SzCfzTCWd1oyTvJUPUwkpD0qI/G3Mm0CA6FHc?=
 =?us-ascii?Q?fmq/RsruNHmjFAMbXNhQGJc1wUzAgeHXAr+ERybSLXxwmnyw8rXWg7jFUu9i?=
 =?us-ascii?Q?tlZEhg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2aba88-7b40-446a-02e8-08dafaa64bb2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 05:22:16.9850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvfmjr9IdNpRUw51ciWMltFyAcCZqaYsh4hD1nvRLlPhi4QU8Y+BDtmUgPIdog/FzQip7PiIRJ6ryN0E4OUTaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan, 2023 21:08:42 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 19 Jan 2023 20:26:04 -0800 Rahul Rameshbabu wrote:
>> One of my concerns with doing this is breaking userspace expectations.
>> In linuxptp, there is a configuration setting "write_phase_mode" and an
>> expectation that when adjphase is called, there will not be a fallback
>> to adjtime. This because adjphase is used in situations where small fine
>> tuning is explicitly needed, so the errors would indicate a logical or
>> situational error.
>
> I don't mean fallback - just do what you do in mlx5 directly in 
> the core. The driver already does:
>
> if delta < MAX
> 	use precise method
> else
> 	use coarse method

Oh, I see. I was thinking we were discussing ADJ_OFFSET in the
ptp_clock_adjtime function in the ptp core stack. The suggestion you are
proposing would be for the ADJ_SETOFFSET operation, and I agree with
this. Thanks for the clarification.

>
>> Quoting Vincent Cheng, the author of the adjphase functionality in the
>> ptp core stack.
>> 
>> -----BEGIN QUOTE-----
>>   adjtime modifies HW counter with a value to move the 1 PPS abruptly to new location.
>>   adjphase modifies the frequency to quickly nudge the 1 PPS to new location
>> and also includes a HW filter to smooth out the adjustments and fine tune
>> frequency.
>> 
>>   Continuous small offset adjustments using adjtime, likley see sudden shifts
>> of the 1 PPS. The 1 PPS probably disappears and re-appears.
>>   Continuous small offset adjustments using adjphase, should see continuous 1 PPS.
>> 
>>   adjtime is good for large offset corrections
>>   adjphase is good for small offset corrections to allow HW filter to control
>> the frequency instead of relying on SW filter.
>
> Hm, so are you saying that:
>
> adjtime(delta):
> 	clock += delta
>
> but:
>
> adjfreq(delta):

Did you mean adjphase here?

> 	on clock tick & while delta > 0:
> 		clock += small_value
> 		delta -= small_value
>
> because from looking at mlx5 driver code its unclear whether the
> implementation does a precise but one shot adjustment or gradual
> adjustments.

The pseudo code your drafted is accurate otherwise. The lack of clarity
in our driver comes from leaving the responsibility of that smooth
gradual transition (to keep in sync with the clock frequency while
running) up to the device.
