Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1D7574416
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 07:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiGNFAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 01:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiGNE7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 00:59:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15317DCE
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 21:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqzSHAI5HQtWvtKREp/Bn6JIJLAT6OXFpb/Qv6ZcVkdVbxVn4lRsoyxY59PrskCUysfw8Eho0/EZEb78riE9vzJKkATXBoc9yE4Ilwf3dEc0R5ZqenSYW0qk4EDFFt0A06pXyEPLXaHAsgSNS1dmrjoncTfiRU/wwqIFgIxeCsACaHBhsU1Anzdt64M25/BWTG+HSJ5L59LJ2j1T9joFYsxyI6Zit2/V6mAmtwBKqXBm5qWCgXoBP4peHPQDxnrY+a94ms3ZOnacFyrcv8WrcYn6psk9GqK59V1ePz1o0XCDtUU/7a9WFnA0A4mPoi7RHXVkIRMqa+c+pM9FyeQZ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6i3zzkZK7zU4Gz2RyNRbWZGfQmLIaOZR8c9Bm6hTiMg=;
 b=F6d8FaQLJOMd5VkhGCuJv4DSv7Dpc/XYhMdEpd9sIL6YCPBdQ9IH+HDzd+s751C2sZ+tYayjQjlScPxPF6PcY9AYz/LsCEkRqoEX81dBdkWpMfx640oROnn6kUbYPKlyKm+b62nY/Q5////befxKGiViX80szEsbZwa3vvTBBhUDO33hv3Oc5E7gwPOAR6o9J5gCdEwtnjHlGupZ5dutzrtS04zFNwQycP5D+Jtli70DOK6ouGxzu3efKV1gXJvG/hGc/2WTI0n+xqz5GXZENt1mcBMyBF/JAkoAoYfoH2i/l5Wm8z7OAdB54bsOxB9Rx7R8wsSBpxVfAkUM6Qohzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6i3zzkZK7zU4Gz2RyNRbWZGfQmLIaOZR8c9Bm6hTiMg=;
 b=WLaJ9kqvITMI1kqatFFicnK+OcuufdIPrK25IlaCuO7HTDxNCIj1k06afE0dQzn19SyhokxQ1djxDj4bsy2lSdFeAzDxYjO6FsYXf8uCEOwwrILzm/0h3nTp7QxKf2OUyrlkaXj3Hz55zf/aps+Tyx69gvunmmsCVQP9CAz2fkKg/ZuqNcPKFcilVxHIik4HBpiwFWDJ6uN4A3N9lUXeZMSVz+bG0xNNX4I6dG5VGzEVZbCjncmyU9fxq6yCIv7aid926OmYUjP+zcB4BVc3oB8mJWlyCPKK3AzNOJIz8j+vErQxjFya/pcRtZTPnoM3044gZRaXtbMaKiyZRCd1Ug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Thu, 14 Jul
 2022 04:55:08 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 14 Jul 2022
 04:55:08 +0000
Date:   Thu, 14 Jul 2022 06:55:05 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <Ys+hqVopaCODxihw@nanopsycho>
References: <YsbBbBt+DNvBIU2E@nanopsycho>
 <20220707131649.7302a997@kernel.org>
 <YsfcUlF9KjFEGGVW@nanopsycho>
 <20220708110535.63a2b8e9@kernel.org>
 <YskOt0sbTI5DpFUu@nanopsycho>
 <20220711102957.0b278c12@kernel.org>
 <Ys0OvOtwVz7Aden9@nanopsycho>
 <20220712171341.29e2e91c@kernel.org>
 <Ys5SRCNwD8prZ0pL@nanopsycho>
 <20220713105255.4654c4ad@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713105255.4654c4ad@kernel.org>
X-ClientProxiedBy: FR3P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::13) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad92bbf7-de53-4c59-f4d0-08da6555069b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4390:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiKaEHqvP+r8bY+MVzYJyIOPivserR3KFShtCTpBnmexK5s6yAHDBe/N/3jP4DUfJPcH9VIxBQnNemSLLb00XMgkL+1Rdlbn1y2avFXrRSIyeAB7PVJk1vRNBF7dYSJjy1M0joGrjRFirV8FE14Yu+b/roymxCZJxfBje0b/B/KaMJHl7nyiQRPUCIh1p66TUpHUZUuSXsxwHn/0xyhz3nHVr7JRTIGVb8dga5ZwppB0nyq1dAFNzEsxjgV+NET+v31pV2WGIPsG/1GA5M7cwMaOQq/rZ+jazLmJG+5DC2XRoFV1TfCcH5uRa5GCFNoiZ+e5C7TyJU5FwkEPFMuZQ7bD0R8g1AsjFwrHW4HQJSsOVUgTKmrvsppjCHpdyzAcZxRot6d13KK3JrsYm6lFjXq3UPbcjWDIn+y4TckIkojyy+vlQ9U+eLZirUvPyzxLyrOUJirQv9BDJwuOe4AQcdhMX3ci+8uWoVU7KjOyGdjy71raK8ccTBcWQce6z7RPj8fugbfpSZxsrxpSQTSpGSkC48VW7Zf2poZOpEpeuNd5Hnygg8RjBeXYazn+Bm5rCz8easgNtrSXPi1053qMaUgM8ThX9hUH+ffQKbXBI+sdM9Y65sp2tNNKnwGT7+WxyLaZHmcPFf//v0Rk+e8gvZk5XRl0dvpWfbn+29FESPlO0CXWjPdILVofJcN645Ngku5t1eGAts0Qu/Nfrij0o3edVZE5vd+Af6Uxv1bJ1Q2U0SOD2BQ3y4IwysFgMvcb1QiMK8pJsX9MekXw/h01qJFcj9Ci0TOAv2735sn7gsT6lTV0v7/NPPKbyGWri11f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(8676002)(83380400001)(38100700002)(66556008)(33716001)(4326008)(186003)(66476007)(66946007)(86362001)(8936002)(6506007)(6486002)(2906002)(316002)(478600001)(6916009)(5660300002)(54906003)(41300700001)(6512007)(9686003)(6666004)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wNv7K7VI41RbU9lTc94mZnJvuLJ8Lrl2YvRZwH7H95RO9kfPRrX1ueX5K7gG?=
 =?us-ascii?Q?HpJw/w5oDB4AmCU4etDhZ/ghC5TfPz5c0vZ6ZBAdi3jYXczN9wMaINjY89fo?=
 =?us-ascii?Q?0qpA4bM46Z8Gly8O6shCLKBw3HCkV+7tdyQyJHQiUY0HFcAqs+yDUmptqWE3?=
 =?us-ascii?Q?YLwyITh9e9fzqXA9n/Wv7cjhxiJId3/E8GA/BCwJTNg06bu9VHQprKlg9yvm?=
 =?us-ascii?Q?RAU8oL/NRx87FmmytVd0c5DufyT9hMA7Elfu5g/QU2c1V8tNbY6DfNgA3TRy?=
 =?us-ascii?Q?SytQY4+MX65qtmTzkSq/clxUG2GErIxyOHr5IqTB4iSV1tAfb5kJPRwbSN5R?=
 =?us-ascii?Q?aaszgjvxPna1PXVC1kg/S6ToM+p6pvJzIW1H3DLA4OckRjaMLb9cw/mwOI3z?=
 =?us-ascii?Q?SaQmYs9v52pif3C1IBCg9nIZZpj1ffCc2r/iURucZXY1hHgmGMrsxDV+mq3B?=
 =?us-ascii?Q?757HfX/dWQLnv3cEoRTFsNvKnsqYxQLHDl2M7+yYcFLKBF7/R/f15t6MoYTw?=
 =?us-ascii?Q?sjB6b3CuL106LQ8gQaATP3y5zzuYdnZ/VVamFKUrxg4At8etzN3+yLvZHPW/?=
 =?us-ascii?Q?80/bcEdoodCuQRkGTvxrZpHw+39y2od+/VDQ1dZoyv8fLDqLQ/ziI8uNIQYk?=
 =?us-ascii?Q?u22V7WkWr6bqy43UHCKWq/ODqXKxZCS8JQ7RZsi3qqvm+s5fnW7sYO1xB3bO?=
 =?us-ascii?Q?Xm5VM1HXso6Au0YQ3mFCvHSSroO39AgrC6rBHd6IHt4gmoMvcjmFpgYKtXH2?=
 =?us-ascii?Q?32jIOqnrMQeVxr+ZCK94zAEVsxu2NEk8z+FgqiozDeE++E8idaCK8gz9RJYP?=
 =?us-ascii?Q?kcbTkDMW55WJxCMqM6+qA3sdjuWz727HHTZpLWiNWfwteSVMj059qUDSOsnC?=
 =?us-ascii?Q?k45wO/zWJHo5/ifkwrS3XmAV9CyrNZtvlDjuG4OHa25onesv2O4c2yWaNvxN?=
 =?us-ascii?Q?DwEMrOkw86bnr4ol6rgBzaw9WIHBZaO/ppTY8M3EqPRPIuDGYYs2AB3B71b/?=
 =?us-ascii?Q?XyLhCGZwYgqwAy5WD3j5R5lPtxr91rn8BZlAp9X8pO8xwi8G71v2oDRvF3oD?=
 =?us-ascii?Q?4x3QM48JNC6x5Y4WWh8wqmf51a822+pvAkior1/Yxhe5tNKDc8T0ymEVr+IS?=
 =?us-ascii?Q?mpY1cOK6hC5LAsFR/IgKeETJCQFsBkyT1r7OAtRm54sWaa+CsJM6rdg3xFRt?=
 =?us-ascii?Q?LSzKQ0tTYEnMRODPeKpxKyDJCr42hq88rV8VlDQV9S1I+jOk+nMszEkS12WC?=
 =?us-ascii?Q?+7BiQemWJYHRriWPV2/MUkm0nvee910N5rmKyviL1SYfnYOIfeq6h8Z9Ql9k?=
 =?us-ascii?Q?ngldPq2H3NDUDMTALvVDsQsIDW4VYV86redfXV0rT3Rj5+mFcDTbD19Y3deX?=
 =?us-ascii?Q?3k1p8CkvRF/WjmgDn6xBxcG/WSjmeA/dKe3ga4ttiLEIVy2B+qjbltC2P6E8?=
 =?us-ascii?Q?FfYdU99NYj60PLjBvfbFIDCWOOhb1UXdNvltq5uU5/ETsS7648xtqq89DYos?=
 =?us-ascii?Q?PbfzW+082BUjKC7blVtd7dr1VPfkFvGjSmyzEGFVfRboLNrt447gA5mh2iN+?=
 =?us-ascii?Q?3CHQi2yW1w70h2W6gQxooH/b/AZ87TryMM72IGiq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad92bbf7-de53-4c59-f4d0-08da6555069b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 04:55:08.4949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwkiTZJIyNOR40Ht1Vx52lkJ6JdPkXxD3+KIDqUOEhvFKRjWlROe4w56sCj82Gsj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 13, 2022 at 07:52:55PM CEST, kuba@kernel.org wrote:
>On Wed, 13 Jul 2022 07:04:04 +0200 Jiri Pirko wrote:
>> Wed, Jul 13, 2022 at 02:13:41AM CEST, kuba@kernel.org wrote:
>> >> I don't think this has anything to do with netdev model. 
>> >> It is actually out of the scope of it, therefore there cannot be any mudding of it.  
>> >
>> >You should have decided that rate limiting was out of scope for netdev
>> >before we added tc qdisc and tc police support. Now those offloads are
>> >there, used by people and it's too late.
>> >
>> >If you want to create a common way to rate limit functions you must
>> >provide plumbing for the existing methods (at least tc police,
>> >preferably legacy NDO as well) to automatically populate the new API.  
>> 
>> Even if there is no netdevice to hook it to, because it does not exist?
>> I have to be missing something, sorry :/
>
>What I'm saying is that we can treat the devlink rate API as a "lower
>layer interface". A layer under the netdevs. That seems sensible and
>removes the API duplication which otherwise annoys me.
>
>We want drivers to only have to implement one API.
>
>So when user calls the legacy NDO API it should check if the device has
>devlink rate support, first, and try to translate the legacy request
>into devlink rate.
>
>Same for TC police as installed by the OvS offload feature that Simon
>knows far more about than I do. IIRC we use a combination of matchall
>and police to do shaping.
>
>That way drivers don't have to implement all three APIs, only devlink
>rate (four APIs if we count TC qdisc but I think only NFP uses that
>one and it has RED etc so that's too much).
>
>Does this help or am I still not making sense?

I think I got it now. But in our case, there is no change for the user,
as the netdev does not exist. So user still uses devlink rate uapi as
proposed by this patchset. Only internal kernel changes requested.
Correct?
