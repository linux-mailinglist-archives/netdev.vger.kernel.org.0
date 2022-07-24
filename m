Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7D757F41A
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiGXI2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGXI2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:28:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B722612F
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kx6ewtBVWfD1Kk3c0PBNC0KL4ypStGkp5yA3ee/u6fcrLSGm8KmgKG+sR41dOIHocg9/KJfwkWQB3jS5DnEmfZsdoqy1rxngrjEExhps10fDSPS4+kVOil/IStSzMRH84Zw2O6O4b1/T3oCoaGDTXi6yX0hpkgICtNKx+f7AP65G9Em81bSvtC/HTy60PYd3zMxwpoU4t+WnsTb5og6Ei+/MJ12xRJuJxNYEiJnoaf8hXDGXwl8wvBkZbjSSfgBlEL5JnZtEGekpXxZJlBy/CtgqKyrhJh8A5rhg6bH5mBv/SLzjo1s62LVH8xekx+I8SaYhMXeqWcqIycK5AwM4Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/aLyqYnHX4mJC/l9dgYU3iSqKd1IrUySVNM5JNEWBY=;
 b=C7jUqaWDRV6t/HppztJQNXG6n0XPkTLZBFAyYQXnIW/Ju+TirKsUubNMxorYNE8WO/XCPflmavqpV4jZFWYhR0y22ioqMTqS7ZwUKOcu+uQKUhnmnpdj0DHqVK4sQg6fNFhWP1CyQuK5EW7+Gjy5MqD5vhAqfZ8FGsLpDwtqxRVjw2YM6dn2zGzpByAhWJIlO+HU4P5p3oyDryaRPB9fCW3i0nHcJ8jCGWq33JF1qkbFHdGeV+GjR00OQllOTobX3Vb0Y6GsYeYXFAQxfLj5qe/VO1QhKHHhZxed4dO7juMoq2/4ihsJPtbv+v/eVNQC2I+xG2mseNfB8ocKa4/2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/aLyqYnHX4mJC/l9dgYU3iSqKd1IrUySVNM5JNEWBY=;
 b=CRO+Z67806lPEh0DsIWCetQjD/9wWGxwhm0slP9+8qIXX7xUkhPF0JuTedi7kjXkjTe2++R36Wz4ury+uw2Ih6Zid8tY2QzeotN6FYQHKavRTLpzb0hvyTPG/UHC6OWvxcJDr9Tyu9SyYq8vJWOV9kpV+lDn4iKhY29VXdV0fUb1YD6NVwQY90MBqwf9MrDwIVhI19KzNtw/Q6Kr+yh7tnOMzA3f3ggW7bCxCOEUM0rgaAdrjsR6mihbR7SB1Gqcln3K9gr3RxDjAVAO8bnbzj0KCrReImuTMcMvHsIe9J5fhWw5ITwe14n47Xz/I+UnoUITziSQYKhx1gtWd/tEYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB6762.namprd12.prod.outlook.com (2603:10b6:510:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:27:51 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::548c:fcf:1288:6d3%9]) with mapi id 15.20.5458.021; Sun, 24 Jul 2022
 08:27:51 +0000
Message-ID: <66ac3774-216d-d97b-1ffc-362bb5d6a6a4@nvidia.com>
Date:   Sun, 24 Jul 2022 11:27:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220717213352.89838-1-saeed@kernel.org>
 <20220717213352.89838-4-saeed@kernel.org>
 <20220718202504.3d189f57@kernel.org>
 <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
 <20220719135758.29ba0579@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220719135758.29ba0579@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::20) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 565ce153-4aea-4e95-243c-08da6d4e65dd
X-MS-TrafficTypeDiagnostic: PH7PR12MB6762:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QgRa0ZENscRc1KAClriDzRzqAFb8/U235yLnetNxokoojiRnmnOz/U1SZfA05Puy58tioB6xk3WknHcQvmHRT8R+5jSKVb64lkYuDcCj7Rv32+A1K1VE8vUnvL5PUs4QXTBoqFEPAhKld/msQsEyEQfHHAJ5ebX54qCUty+tu7/O3Qy+vhccMd1Rs2fTTAYD+yZmVhIhqxi82scOXcGHLKiYjG4CpWb5Cb/F93b0+ynmxxVBRvMvYm8r/a2HU/8G4v44dmS61BE+9ACJLWD5jSULOg/WBncqHWE1uNaqcSJIm1A+FUcSUMowiy7a+7VC5MW/5rTBhqqLpJgcFNXpppJuJMlJDOKhfimIYVxtNFBoFDrrv7MBvrRAxCypUKRsul0srqGyyX8qsImNF02iMdO7BA7zRMgLIMzsgbRL17GpbUd7hT5ueYPUOsfj0TxtWQAqDPEABKDGmiQb+fk15bqjobM4cKU2YdiDPY7UrPMH30NiXtDa6y8oiswLGMLtXVBLFpyegQYigZa7ft/fFwPrjXfw8fwuFgcjebSlNLT++6PIuAxowCze9+/ELeAOowpvqA6EvnKtw7vVz9B2pcWKAreUGxdfT/zGHr6Lkpn8sUtwqGI91WVucTVhdVNdn6T52foyg0gUEETL9GDQROTWgUs1qG5kfUpGR1+DONvTdNMuWUv9MAfQR4jh+bFizLH9ocdFsgIGUWRSkQU2oOjxJuiXPFd9lXY81OZ2t2u59Fljsu6NKsncccMvy2DYcp6rDV+AwUQ0j5BfBcab7chM/FOF8pe7XpRrSAKFLk6t56DXEnM8gq0nK9sE7gMwS0k8LMwgfrTgG3po7qIwig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(38100700002)(83380400001)(107886003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(2906002)(6486002)(66946007)(41300700001)(478600001)(6666004)(6512007)(26005)(53546011)(4326008)(54906003)(316002)(8676002)(6916009)(31696002)(86362001)(6506007)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0d1eGtkNFE5bWF2U0FvR2pkekhxZHk3Q0w0cWM3R2NOcjFPWDk0b3JvTjZ2?=
 =?utf-8?B?WS9vUUtFYWNDbUFYM0N4S2Ztc3ZCUzVGa0dVekM0MjZJM2ZGUFdJUG9uNXQx?=
 =?utf-8?B?cGNSZEdlVDJTVFNlY3piaVlBWFE5L1Q1WGs5aXBrcTFuRDBnM1RKaVJEVGx3?=
 =?utf-8?B?ZVVtcmlKN2crbTJPblhpVHVyTmFNcDd3WmU2OWVtRzc5UFFYeWJ3WnBrNk1Q?=
 =?utf-8?B?SFNoRkh6UzNwQmVQK0srV2hhTUp1eVBCSG9rOW9VQ1FoeU40Z3lLa1ByY1lR?=
 =?utf-8?B?eGREUzh1TTZScFJZN2tVY1cyeHkwRjNKZzVLTjVBZWxDYXd6UEpaaW9WOVds?=
 =?utf-8?B?am0wZ1FiSndRMXdVNGxwQ2tWQ2YzWmlCa3lvZWg5K2hmbTBzVjZOcjJwMmll?=
 =?utf-8?B?dm14dXduTlR0VW14bWxwZHJSeFBHUEk0Y3NUd09sckwrU2cwV0hXNzdFeEQ4?=
 =?utf-8?B?QVJQQTg0RmIweGV6NDNBNXA5bDA5QmwzajN1czFWbTVNSDIxN0FUdklPdEVR?=
 =?utf-8?B?SEJjY0liVFM5TXorNUVpem5YM0Y0ZDh2YWU3bWtqV1NFajVQMENPYkZQalBI?=
 =?utf-8?B?ckJSSStkTE0rNzlkeVVObFA3Z0FiRWN4UE9YWVVwQ245RU83WGg3Vy9pdlZO?=
 =?utf-8?B?ZCtrdUhYeGxnc1pOQzVkUFdWZmJvRVBHN0hibGhUSStUcG9PR2hDRTkwVmJr?=
 =?utf-8?B?aWVqWCtLRXFaNUJJaEVsbFR2TTNVQW4wR1lFVFdnMUN4eFRNOHBJREZ0eG9n?=
 =?utf-8?B?K25zbHlWU25pWGxQejYrR3J6T1ZpQVdjbXZmYVNrSktlZDZjaG1NaGwxSFBs?=
 =?utf-8?B?L3hYZWtKMmJsZ0F0c01KMVA2SG5EUDdSTy9mdklaQVBpZFpOdnVJWVZ4WVdr?=
 =?utf-8?B?dDB4WjRZeWdJbHoyWmcxNUNBbityVTFSaitGSTRvTWRxVVU4T0t2SlJOaTdZ?=
 =?utf-8?B?Z2RoR3ZLKzMva29iOFJKUVpzeHlHbXRYYkF6Zy80MmRGR1JkYytxZzRxSEVJ?=
 =?utf-8?B?YzFUc2wzaSsrMUxBcWpqVHNaYVEvbDBnY2o2dU9wZkpzVHZJV0wyWS90MUF2?=
 =?utf-8?B?Z2lFamE0UnhzTy9MTWNCUy81cTBxUG9Ub09hZC9kWHh2RnVTaEFaVitHbDZ6?=
 =?utf-8?B?YVZ2S1NwLzlSaU1lV0VYSnJsc3VFMERXOGgrM3NWZmdleGppN1V3SnFOVHNj?=
 =?utf-8?B?VDRJYi9ab1pJL0VTSzFkN3FER0NTWUdwazhsMWk5SXBNNkNTUFNZYkczamRB?=
 =?utf-8?B?dU5Ka3czN0RnQnNGdXo3N0Y5d2JPSlo4S0xRMW50dGJmZ1EvZW9oUnQ1cVR1?=
 =?utf-8?B?eFltZUN4a3BReDdialhUYlZYQ2Jod0pLa1FQb2h2MlYvQnZBbXl3eE5mczkr?=
 =?utf-8?B?ZDZZUU5CMWJvQXFiNGtNaGEzd2tqVE51K0VaMEt6YUJVYnYxSERiUnZKOG03?=
 =?utf-8?B?TkFndXVGMzhrZ2w3YS9RVmx2RE1IOWthR1NPeW9MN1hKZ3E0TmlYdHZib3NI?=
 =?utf-8?B?dUZJYldLQndZMmlCaGxsUEFlNFFnRzFiUWNWSXVkV3ZFUzd5S29hNjQ2YjI1?=
 =?utf-8?B?ZEdtUmVlU3IrZHkvZXdyelFWeFNQb3paRFpEMkoySDhtSzB3dklTRm9CZENv?=
 =?utf-8?B?cjdLM0FVREdxOEF1UVVvd2pYR3VEU1dPTUk5a2hzZFBxSGNvd0FjakxSa1Bn?=
 =?utf-8?B?dnhNeHpUdXM2YksyL2IxUmhacFAxRGYzUFp2a2RRTTRNUDVqMmhuSktteGgx?=
 =?utf-8?B?REVhRTg4anVuTWNGVng0MlJuTG9IZDY1UWwvZFRIa0sxNFdPVVNwTGNwaERT?=
 =?utf-8?B?cDhpSk16OVlOc2t3Rk1uWFJpc1lJVWhoblg5WkVkSzdjZXlxT3pmWkFZQlBn?=
 =?utf-8?B?YjJmaXQvNWZRRGRxMmR3NHR2ZmwraStsRktUZkNqOVJqVkl0VXpYemFydUwv?=
 =?utf-8?B?MnRWeDJRU0tNajJIbEFIMGJWWHhTVWdTWHJ0MXRLOTQvTkRWU3FLOXpOTktp?=
 =?utf-8?B?VDVpTjlSRXlmbTArcjJNZ3F0a3FjdnBGdzJRV1lVWlJBNkxJNmplTDVDRmpz?=
 =?utf-8?B?d1RCTEphS0JtTVZVcmJUZjc3Mk5XcnIrdEp3cjhwand5SURPZ0w2RzRxM3J4?=
 =?utf-8?Q?ex58zxf5/KYBoF0lLfhHcWCY2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565ce153-4aea-4e95-243c-08da6d4e65dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:27:51.2870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVBPFkZgp03Am8q71VJqrWJjYeAAOX879XVXt3zDzS7J7jYXIsSAXPsWpWsHYTnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6762
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 23:57, Jakub Kicinski wrote:
> On Tue, 19 Jul 2022 14:13:39 +0300 Gal Pressman wrote:
>>> Is it counted towards any of the existing stats as well? It needs 
>>> to end up in struct rtnl_link_stats64::rx_length_errors somehow.  
>> Probably makes sense to count it in rx_over_errors:
>>  *   The recommended interpretation for high speed interfaces is -
>>  *   number of packets dropped because they did not fit into buffers
>>  *   provided by the host, e.g. packets larger than MTU or next buffer
>>  *   in the ring was not available for a scatter transfer.
> I think I wrote that based on what 3c509 or some similarly ancient 
> NIC was doing. Since then I've seen too many drivers using it for
> queue exhaustion to hope for the interpretation to take over. 
>
> But yes, not the worst choice, if you prefer that works.
>
>> It doesn't fit the rx_length_errors (802.3) as these packets are not
>> dropped on the MAC.
>> Will change.
> I don't think rx_length_errors says it's MAC drops anywhere. I put the
> list of IEEE eth counters there as an example.
> rx length errors is a catch all for length errors.

Ack, will use rx_length_errors.
