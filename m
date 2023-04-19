Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029C26E7B6E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDSOAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjDSOAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:00:06 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F4012D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:00:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNsn2LJa1Br1FX7TEnwRJnV8cAtCbJvj4KeP/GAtGvL/dB21gh4uYeABED8cjkMtCs0xVZ/mZLiRDU2Mle9/WjsIXHAF7gb+37ux16uzUhSORlTpFI9fHRm1nFwPIMMW/jI7zmjXF0PUvVVJmGdFWvnBJ9K4/6nIXJ3XP/fHnIXSSoFN/sO13lIxv0qEFZqYU7CxVI/9Nf45RFQPd7Or05kkd4mutGLz7GIP1b+rn+iwdVUgg1JoyJTjorv6caMgx2WkswIkrCB6WQrSYtH56xd7I1GyPkw8qQ20g/ZIT4dqhS9R7BMwx1yIWeewrudLV7W+1CsqIuMNsPRt65fD1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqIbGP6mp/ZxQk4giRd1XBT/jy3pHfCXDuDgWYQGelA=;
 b=PTLxEqtbPfDnglaVIQ8ne5v7KwcFLvDa0VRRIq1pvReuxzj382Zrv+Q0LK7eJRGStr48YR5xCkTVw2zIs5kGdUTzqkYjJug0slC3fT7FsZL1xCzrTm4oibRo+RZ6wxJZ2drJo8ZS2mtdCuPK5BBKkO4pDyItClE6QThO+hNqMz/DvIQ5025bI8zhQFUg7SDXbbXHsYNvqz9vMRApeisOOUza8+X1dwWM2KfiEMvG3ckp5XykpFfylzZcu8Q2XdjkolVThdspyA1YZ8KOj4/gZn2H4Z5hhSscQqM1YfXwEO59O1RLn5iPZkfxH+pej0UXuDGo3+5Ga4UbfVybkSgBLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqIbGP6mp/ZxQk4giRd1XBT/jy3pHfCXDuDgWYQGelA=;
 b=bZ9q5saUMvEjxT8Za0JVYHL3SOsjMoWEYhVG64sW9G/fhX8Wdzl4X0wmxlBEgVj5mCqTKBuLWYQRbT82e/Z2rnzK+7e+eumDNPCECLH+DwYOi1+WDHYy2z+7yDnKmXj5H3FavtLWfIi12Uu+bNeuZTrdQN/O+QqItEZ7SSRyBpp/fXgmSlldEkdgCWH2mrHCiv7bmVWb0ABdJv+HUlfzNcQYyn4TTHmOY1gYAPXKHtBEDD4FZPyMsZX+Be7L0J2Mr0vwhT1r1HA9MVM3xrM8jB7VRFE6wE4NwxREnyNZApYS4IjykYXCZux8/+EiyeJBj2mVK05USkgI0TKe3B4MkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:00:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 14:00:00 +0000
Date:   Wed, 19 Apr 2023 16:59:54 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 0/9] bridge: Add per-{Port, VLAN} neighbor
 suppression
Message-ID: <ZD/z2vI5ab0zPdRf@shredder>
References: <20230413095830.2182382-1-idosch@nvidia.com>
 <95a773f6-5f88-712e-c494-9414d7090144@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95a773f6-5f88-712e-c494-9414d7090144@blackwall.org>
X-ClientProxiedBy: MR1P264CA0214.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:56::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 4844e676-70cf-4b3a-c90d-08db40de5d81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CMhv9YHaYVQXdZWtqL32AMR8UYM0NYclegEXhXKPrlJIbker1ZVwAoYY6chW+ZTHOFOeBLiWzltvsTk0vuJh3AhZ5/Vv9xcPOOU2iUq92QGHSDKyrTCBKLLw8EYhPeEMelw8cmjYlLBCCeC7O3SgG5EST5klmkTybvrd4j7HmoYKxsnUzJYfD6CO4jJBD4TT4bLwsiQp40sRb1myCSr1XL8OGFJnln5VgRsMvQI49kl3Penat6jWbfUTyopwyQaSGFvPCD6NX0/CMUWYNZCu/bEJ+zv1d9fsdKgqfdyiEtRBsbOjlvZuA4DWK5DBHVE3WSS5UOC3Ki+8A1k1f6GHroXfDzniM81B4TAYu5Al4l4u66SRkv0fYM1GQ+9p+UPOntQ8qAQe9rNQnAxZxtWahpwGyb3SDfGot5dv71GfsMdsQyFEAG6VueDwiB3/jGp2Qn7Q2N4D9yP/T5QL7/nJ04mjnpMNsU4uHNUnSnubRncaasmNTCS747YCXbCBvkLeYTurz/8aA83+kptcXajkt6U75ANE2UYWbswgaiS6Glaf4L2jY4EMc7Yht917z/cK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199021)(6506007)(33716001)(26005)(9686003)(6512007)(86362001)(558084003)(186003)(107886003)(2906002)(5660300002)(6486002)(38100700002)(6666004)(8676002)(8936002)(478600001)(4326008)(41300700001)(316002)(66946007)(66556008)(6916009)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4u/69nTGQJzX4e5+skxe3uT9G9mAveJk0GTh0BRm5YWHO23uH2AJETXg2wMs?=
 =?us-ascii?Q?qdM561Bxmy0nWvX9GQ1b32wLDP1XStiL5yvgvJMGj08XTjvo40kRPzxcEs0I?=
 =?us-ascii?Q?YhK1KeR7msw9nbWqU6UTrGC94eqvIJ0XXqjE4yS74lZULR+0zR665Ngc4Q9X?=
 =?us-ascii?Q?JJ9AwjsIz/t5ANyMG+MpAZng8LYaWtSNdx75nKXsLdsoNLDyyPnn3ZlMO1UN?=
 =?us-ascii?Q?AVWaonLjrIYOgcFd6SLZWu4LzkiGDTbLuksyDDVh+mRp+/MfVBB38NR0ZlDD?=
 =?us-ascii?Q?8akEoiKRAiW/NYAYL/5Ytcj3+lYR2XHpawC6ImyYIbIzBiCCezlqppb307iu?=
 =?us-ascii?Q?gRkyp4fIlMr07xoG/2+RGn1EF14Ad7FxW1Pdd6OyE3JoWE9sUYVTlhTzme+v?=
 =?us-ascii?Q?UY1T2b6S08StPgy7HcIRij610diAQcmki7JyI+r0txYKcNSEBvhPXQBq+TqG?=
 =?us-ascii?Q?oy5B7vuHn25zglXlfx62Rf0Y6XHhMYrcS04yVOBlBnsMqZh4fOORW+a+FTss?=
 =?us-ascii?Q?WRX3UNRY6FUeJNnMxCOH5lw1KULzI6ZTR8grKcp5qDqAAojrub+GB7sIkT4K?=
 =?us-ascii?Q?gO3QuVttVl0M0a+HPKWw1B2kuVzH7ImDWTUz1vhdW8C23rj5JfLTSdmlzYZo?=
 =?us-ascii?Q?jk5jqRcr4aoITDZRE9nA2rudX8QIjNYDZ/6fJnqzG6K0Xf6jItniLFjh5Iq+?=
 =?us-ascii?Q?TS0afa65RMr1DROpN38sgvPLkg8u/SeNsYxLNUjXePad2BwuPbfG7oZi7H3u?=
 =?us-ascii?Q?kcv4IYlXJAudFtFb97kE4JTFbd7boyjUtvrWWRzJmiZ57HNiEpS8guk6hTxZ?=
 =?us-ascii?Q?NTZY33zS8oFwzguxbLJLZz+Uma31oopf5Sy02KC61ZUomzP1DJScB4fqUSmO?=
 =?us-ascii?Q?w7y+wffGvc0JEChjhMKZuS5lJWmGwriVliXYviUP1To0MrtH1vf+1le/R41U?=
 =?us-ascii?Q?nHd8oTd77lhJn/POC1L4DeZEpgjtHAuM/e4t2cqIJ60wSfMZI2hDv7cV4OJg?=
 =?us-ascii?Q?Qb07kck7i4Ev8tdnZmNSSG90sDnaAg5eB8lvmwHhIRX9A786LIETiVDrrRaR?=
 =?us-ascii?Q?1YgWCVikpPi72JAKv+7lkcOnHECSFnbhyP4qsK7qx7Ini/BB8GFGJC6hKcXL?=
 =?us-ascii?Q?LUdIkl12qPwu6KbObtvJcSLhJp6ARwS6R1iidVoQoA2NXr8lx7dLeKM9OD9z?=
 =?us-ascii?Q?FSJooGYvTF/bHzW09Z59GxRCAta9FN82nf33vmpjqb4RSgOXcIKZ8/oHcwv6?=
 =?us-ascii?Q?dsCM9Y8Z7KfwdrNRlI5BBzkaelqs4wiggAhVjDMG7Bs7wSW6GguTDrhCpeqQ?=
 =?us-ascii?Q?ioG3N+FzTy4H/EBx/mVTNyodjbfPoeaorPU3E0YDgqXJ00nVVdLTtOdiJSaP?=
 =?us-ascii?Q?ivH8+8p/rBQrVpaF4aqtooftGr3FbXHM6QhqnMKyughq90Pzeixf6Wdhl4Gm?=
 =?us-ascii?Q?FWzePMKVnGT5o9aO1GLLyo9/HfJxj2V59iB3BH/4XGwOagyhNzJvNF0xKJUe?=
 =?us-ascii?Q?qtz8JmneQaiUoCExdgcyd+dlYTVSiQZ73IODfAVmrVX0wJssVPUws0gYtnYQ?=
 =?us-ascii?Q?NXOuivUFHMJo3yZba4JbwkE79xvc/M8Cgef1g4Ek?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4844e676-70cf-4b3a-c90d-08db40de5d81
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:00:00.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgOxyNtbEB7KgcG7zuV2JnYGlzPW5tES9DnPNlowYDjySuOLzeZL7Znir1yiGeaz1GpqY7n16Nfw0d/y4LZahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:30:07PM +0300, Nikolay Aleksandrov wrote:
> For the set:
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks! Will rebase, retest and submit v1
