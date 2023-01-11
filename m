Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38E66550A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 08:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjAKHOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 02:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjAKHOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 02:14:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3F16168
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 23:14:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku5vgsfqJrNJ+BP8IPrWE7QwmTxr9Q60uWGzQx6Xo67u6Cp4DoihLgQILmxySs3f6xKmS+kkD5NTurGkF0rVy4Wcjid4ZHlp3qXbGTgN7KV7Ob/b62sOziajWdF1TUSgZeUjGGXdist+arqi/n1pu50ckcpFbjTQp/txwK1WhNl1gk/0TD9Z/3flTa1qeF1pxNIvOgWKb6+qg7KCbIiqEyu3XMOk9j1Y9SuGXnTsbmbRntfoY8oSHFVqobk8xA62CF/A6fWIxfwBybYYut0fDBgiLK9asnz/MrxEWYqG5dTtcZfEWz3vx1qqQpICUMeNL0JOne3oGs1W8y5CvZ4Q1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAecLI2hwdcmJsJBHNXkyPgPouPz5iw6qmOJ+wI5bf0=;
 b=GUpjirveX4dxR0ZmvLLfh9aAqVjazrLVvHa4g2cYdH0vHBol5h3JaDYFGeskAUrPempgY4kP/CVFLF1igUKeEqyaGywc56+gm+IDPTCkTPY4vwRIiPYrUAMnrTu1ib8NqxksPdjwC6AA+RWm+0h4u3wbSYYAoHC/Jl7NLIwAaNDUIktSaj6p8Bx1MS/awAgZTSAah7lDjqpQe/54PMk0UuSktwwaa53mzsSQPXKlILqWsa0N4BmHN2ii4PeAkD+8xuXhR6Qhtp7iws3VpFcqtzrmZWKtckRvju80vp2tludjrS9nw9M9wfk6ZuW84Pwa675rXiqRSiWknTomS1Fzow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAecLI2hwdcmJsJBHNXkyPgPouPz5iw6qmOJ+wI5bf0=;
 b=tB2JUeNfPTUNBywhBbfN5Yd5Q3kTdVF1cInJ3yWUqxeiWDyNIbsqHwQWR2ts8VP9yRlI+UqisBnKyPohzh6z2MUxSuru8yGhuX03DZPPY45WhKCIXNM9SoMqWzUXKQZrEJMPybXJgRd+G0TgMCvOtbuDeGa2BcN4rVQm5DmQmWJJEUGneFT9Ryc5mxkLmrGlkX9dmPnMCGE+Dhu4f6B9J7V9Xv8T8MizoOH0Q/TRoIKW44bpzysX7MjoNzr2D/XPWwRefnQPphcrIkuu80CyNGq20EOJLEmrwAqTP9LJ2Q3zoRg3royhAMOn96kqNk+BnuEsY4S6ynjmuoHXu4Q3Gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5870.namprd12.prod.outlook.com (2603:10b6:408:175::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 07:14:45 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 07:14:45 +0000
Date:   Wed, 11 Jan 2023 09:14:39 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 00/11] devlink: features, linecard and
 reporters locking cleanup
Message-ID: <Y75h3842vBSCLLrq@shredder>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <Y70kij7+UBsHcZZA@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y70kij7+UBsHcZZA@shredder>
X-ClientProxiedBy: VI1PR0701CA0067.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d537985-6cfd-49fa-5b65-08daf3a38461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6YGLu9SbTuQ1gDxI53zUIAr4EO7NMEHC9akfQGjzZQ1o0G3gqO8sz8ZTWlYsjcCgmjbjQIkJcoMv1wv0BIer+mvT9Lk3rTMEvY6+IpS/aQd38hr+o2+IUJp0Xm68sCNUFpCzEM1D8Q9J/a/NsA1kTxpBwvKF2dwmupXa0y3uLY5PKiGnl/BDRVqpgN1hf55JkTmcA67/USE5k6/TsSVGGtnnV+OUWlrDVc0XZb6K3idwoulmOFsdg4+rERqTjT+6seX8O8YNpjLB+g6bbMb+2XOyxxAoOh9rWh4okCYV2HKVAq2ODWsuT4RlFgRNW+7D3fgPEtFcXLQDYKenHxsqoBwgQYWRD1KLyQT2UwNU/Fn0d8H4McVZiExgfINI7hjeVs2CcHz7RP5l2HZkCCQDPW5fkgcyjj+qqMf24ErADON0+Cyw/1At9BPCMWyT5eg2+/EQk9jkbdARSZVT0oJjFt2Y0Eo2LnaoPKUry1VAyOR8H11VKlJ4FuZU8ChwH9BcDBEKVpAna17+8h1iNfTfg191dU7VPuqrKRwN4tCvNoQSms3b9uWHEK2E7qbiBXevdmT1jM2uGYX6nLUZjHM8f6zKucBX0Z3RsRsooJt7G0Tjon5ECfBVg+9j2JqbHUl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(6506007)(38100700002)(6666004)(107886003)(2906002)(6486002)(478600001)(33716001)(7416002)(4744005)(9686003)(26005)(186003)(6512007)(5660300002)(316002)(8936002)(83380400001)(86362001)(41300700001)(8676002)(6916009)(66556008)(66476007)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?793p8dHSfpO8AEYSeIO/EMAx68z+sAzosBYNAEQ2aLNa2gNYLzoa7QpM92zy?=
 =?us-ascii?Q?TSdawVnjZkZVvQpuYUMCMB5CgZdGzhWHVN00hZ+O7wJr742Jdfhv3EDCU3X6?=
 =?us-ascii?Q?P3VZTmQVGOx5m45zH1oZbc/shyduRJYJe6ZpEg4CqjN0eXnBrxsnwPd1pY/v?=
 =?us-ascii?Q?8cz+5glmm2xkh132AyV8Pak++J5NCN1PNApCf6w8PnmPR6lNi5JKMdWZeTVO?=
 =?us-ascii?Q?uBItuOWbK94Cm//ajHGBmz2S99w/37nySbsYmGv57N9bv2kABcs768X7fC02?=
 =?us-ascii?Q?qxVGRS/0YSGixi7TNu9GgtissSsWFJ2FuA+C2O1wkicBfCs9riTHb21zgdGx?=
 =?us-ascii?Q?Uo87TDMvDlDwAwn0WhDFMWfNK1L8cSmjCUAj0wSipv37kk5tQtgV9kh+E7Cp?=
 =?us-ascii?Q?CDs/D7u7JlrLn07VDVMZoN/3KZS8ymoQCz85WtcSPk8I/LqWk+jX0F1ORfKL?=
 =?us-ascii?Q?uxvrSHwnMolRNgjM4TrgLO3sfTpXYM8CI5afLqc6clL4nl3I3CdhPlyYI/VP?=
 =?us-ascii?Q?SDCp3sStTaW5fy2/ueM9ppqnUHLKIuzBZaja0HByX4TKglUbFAP/vqwcr0AS?=
 =?us-ascii?Q?cRGQYve/1wmHOb4hXFt8K0+9mGrMKa/vQnQxDHlvEah8biBp7dj94Bq6YwuR?=
 =?us-ascii?Q?u/aD5r8R+dM0jEhf1b+yDGUCO41hC00I5BN33chkWJLtlb/GQ45pUf/A0Kqo?=
 =?us-ascii?Q?1vXbrl0W61rLWhXQVu4KOl5BeWJt0wXxCQWJfpYVZoalshUQtl6M3cYWnh/n?=
 =?us-ascii?Q?X8BLpUbHdxWimYEUCp85bX3ZcYdD3Jdk5XS4pnbcUkJxqaWmoi6wQEMDU8GI?=
 =?us-ascii?Q?sgZ3Xjx2R9i09ZGNtjIuarld/GiCXSzuZDdkzdQqDlRHBSXuSUpQQI5WtlNz?=
 =?us-ascii?Q?3xD911KlF587cg5ONVC9j3iUoHac3hUF+Zjzso+b1cxWNn4jqwLm9v+IsFeb?=
 =?us-ascii?Q?m30oIzkLOMKOyU/HXwUFEDtsbyGrjyJMxLXtXxg7j5cCLOaA19VCIP90Lz3z?=
 =?us-ascii?Q?rSOjKmhivi1xT9xLndx6Bs8riPUUE2S+YCIEAqeTNTJYZ7HPfyhy9sp6UvVS?=
 =?us-ascii?Q?AHSOCqDjE9FwSFZF8l1FeBwpp1Hwm5LcHsvGDJKnW3UQNcbv8I9mi9wBB/B0?=
 =?us-ascii?Q?hrb7Exiohji2f6Nc+twIZT7+vLrxPQ1opYsHADTGXih6iIzDzLn/xKK/U7SG?=
 =?us-ascii?Q?5rbO9fqmtlNxSSJZihA7X3iO1LMZ8wg2JnUZsRz1AW54Yx5SE4smd+WN4vQm?=
 =?us-ascii?Q?ylkh8+q03mA445N4fTQ14Z6dvOwjk1B0UOlOhOtPFgpM0K+G7O28iNg3Ekzi?=
 =?us-ascii?Q?04UM3VQKQjanMxYslu/7JvVhWJTr3MKORb1wRsjiqt0ePAR3HLkBKnpbDnc4?=
 =?us-ascii?Q?xq6iTl3MOGFIQcvRorDISrlqc5I8rSOjSv9YjEmot/lrq79xITeC3dBYW94n?=
 =?us-ascii?Q?mwkVAYdItODQSJwUsKVsOhYCLNIlqABimGMTUoCNLonPlILC2mnAE2Hswf6k?=
 =?us-ascii?Q?f37hFnnOhYI74Y2BGW69sG7f3Yz/3z8UM3tHb8Rsay5M1MBOC48cGcYWQDzg?=
 =?us-ascii?Q?i2lSJw3VeY+qVVXQ7Y3bkmN8fjvJuNGbeqC8Va5V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d537985-6cfd-49fa-5b65-08daf3a38461
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 07:14:45.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAJx1yhip9fZM0qMJuN3llbLvplftByZOj5f6451XCm4bZjiplwwLD2Awj168W2NsLZJXZgqXjkdJjl7o414og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5870
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 10:40:42AM +0200, Ido Schimmel wrote:
> On Mon, Jan 09, 2023 at 07:31:09PM +0100, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@nvidia.com>
> > 
> > This patchset does not change functionality.
> > 
> > In the first patch, no longer needed devlink features are removed.
> > 
> > Patches 2-7 removes linecards and reporters locks and reference counting,
> > converting them to be protected by devlink instance lock as the rest of
> > the objects.
> > 
> > Patches 8 and 9 convert linecards and reporters dumpit callbacks to
> > recently introduced devlink_nl_instance_iter_dump() infra.
> > Patch 10 removes no longer needed devlink_dump_for_each_instance_get()
> > helper.
> > 
> > The last patch adds assertion to devl_is_registered() as dependency on
> > other locks is removed.
> 
> Asked Petr to queue this for testing, so we should be able to report
> results tomorrow.

Looks OK, no regressions.
