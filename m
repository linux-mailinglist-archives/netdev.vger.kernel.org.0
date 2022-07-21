Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90CE57CA31
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiGUMEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiGUMEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:04:12 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48FB85D77
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 05:04:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUWZH0UiW9bGB0pQX82kxdDvyX3RB3VKm6RiTYYj7HVPf7D0uA4JzTQSumLqH02XTj0uwYPyBaiZrRqg8PRM3VR1dOKyvSJFMOXt9P9teftHl8D1iplpyUy4WXto+9APqrPoKp42Pv8/iYIbgkWKYaIj4g2aBFw37xYbC+ENTWxvVAe9ybVFkbKRkVtNwgMSqJ0WpBW1whWFhv3cd/1bUwDF2P89Tqqe1mHF1zllFBw6Rh6/vtt3GC/7Kc4FLj3LrqZbysymgupmIb7ScWNfEGmdLHSWjDek/dLsBkHy0UhNS1Amy53dpYka8jih/nnt7S+RdjaDmUFdjVojfEKXMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1M6d/Vs/UHqN9UjFDS+zG/Zu9fV13Udo5ifQ6hFPCSg=;
 b=bCVDdbju5qeERJENtfhIrgLaTjEtPFyxqwc5O+wgrRdIBmmlOgkrjJnpJSCy2EkDUiRO0bYC1kJA9YpcLSV+oTUx62aRe6S9mmbltt/3BSfrMqdw9hctdIwCWWpOP/aMqIQ/761N+heXCwqAfok52OBAavgqK0LAAaqcO4q33JweWu3idnAS4Y7JXZICPE4PT8TgO7BpMa2HobEtluRJYsmn6mPB9TwcP/JXsi7V7fQKQPSX3aH4Sss/XfhubifmGKx+tqEf3yBAFu/4jOyNhFbpX2iyQCMdctwAV+9mVGSIdrM+m8qXAgJ+gYZNqMs0VTsql4sc0eE6KGP+F+ZyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1M6d/Vs/UHqN9UjFDS+zG/Zu9fV13Udo5ifQ6hFPCSg=;
 b=ZH8Np2b6KbPXvVG0sl4cJqf+qi/KRa0kwAxQK1OTiCT+dJvVX0kwD27XoR3lWDM2MQXyJHu0bLXSPK92pQnmVtxfRhgwVxn0Jsv99xfI8ZGDJBW7t4sLPJhlLwJypSM2wrNojkOUTV2CK4u3hHtKG+5OpcoexnzbZEryt1Syca5H/vUglMw/2qncFruKUehJo6n9Nc+hPHkRMejYB6rqXyyM7IM7fXq5gnaAgbg0QenuIqj5om4Us/yAZ8T9Qt4UYW53RuurYVjYGjCKsfkFIlHw0J2nfa5EzDJiIBx7Wpn/NX1WceRu8s14qsBrIHdc829qM2mSqE1z75MnxfaIoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 12:04:09 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 21 Jul 2022
 12:04:09 +0000
Date:   Thu, 21 Jul 2022 14:04:04 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, idosch@nvidia.com, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtlAtO7o4ksMOF1F@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <20220720174953.707bcfa9@kernel.org>
 <YtjpaRtkOwX00azI@nanopsycho>
 <20220720232258.22139059@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720232258.22139059@kernel.org>
X-ClientProxiedBy: AS8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::8) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6652682-a901-4b30-7ea3-08da6b111e28
X-MS-TrafficTypeDiagnostic: MN0PR12MB6296:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hszXTJCXjsLZeQYyMXdLMiFQlTOG7ZLdgZmt0kuJy+TO5r/azwMUqqnPK94Pcg0AMLmkkryCw0UUuFnD8jy87FYeXr+t+veANnxWYmq0viT/tHXVi9FVNateSXzCOLSPMtsC99FNjzd8oDzIxEWbgZdCA9oe6WyEIIDdTLdO1I6c0iF71pN8bgDew1uAhkDLWgOPmL6DW9NDfB0oJOzM5KCbnw/kJMh1rQt1kScvtAF4UmC9/qju6YI9vt0Mfk1E52bvmGX3Lt7re1ntepQXpNT6i9SmIljBrfo59a/lCUDPn5CT4hA0Lf8kE/en0Jk9lxtxGpERscHzCCz1ypZPxTVobH3uS3s2Dmv5voE+ciNcygnZQ4SQDv87qfhYrwdqrV/61l1TO9EkL7WGrQMixjOdSH05q15U4fTGqYIKnfhsB8MT4jIH5Ic1KxhW8V7XgFZ0ea5eI28mYRuXRYwGFgO4d1+KA+aVM9+FiUkgsSHtJLpDgcefnsF4tsJeKgA2zgNOOfP8JdaussSfnxM7aNZwUUdHHDCa9gnV/78vzhl8Fha4VsFZka6n81qvU9jp00OxcBVS7xiIBSB6uAaITWFpRAEY3gxj9c03YLxv0BM6GvvRWv4ep5W/WDSAvMZ5jGsuKppiA/75lRI9XeiOuYn4Jd1x0AobPrufcl5wl1m5Aan3CwScG62HJEecvyiH3SIacHp948r4nyx+EwMCFy8d04cKVfyc4heAGzmU+gx0Y23mDJdh19UT3kKeU7O5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(478600001)(6666004)(41300700001)(86362001)(6506007)(186003)(26005)(6916009)(6486002)(6512007)(83380400001)(9686003)(66556008)(66946007)(5660300002)(8936002)(66476007)(33716001)(316002)(8676002)(38100700002)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DxWnD602cp2yvrctCX2SMQiAo1+CQ5zxdFP34ZiZiUInaNNtqFaKrRrvC1r1?=
 =?us-ascii?Q?1JPux65VpwENHYGvYCV2NBdxhqVcDcSMXaw/XcYfwrNZ/do1htVGdDOwaG1Y?=
 =?us-ascii?Q?mXnuS1a9722y07Vcl/VyoXWF7zTmOQCe5jy0k4d5hiFgCfyxgDETmce0q/QY?=
 =?us-ascii?Q?cDgdP6SetN7BEKGJMdBzwaS74bRrkoOczWqjITfMojUVXI+6bnKdUDuNVYhJ?=
 =?us-ascii?Q?slZkHVWrq9naepbfL7pDZSnT+KxKdDt3CaHCs5QAKTUubpZB9HKm/RQEXwbb?=
 =?us-ascii?Q?CF+9xV9TU3gvEjZU8Uv+m5EtUk20gljaxeGwDR6TmfHksqBwbVKknN3UKff6?=
 =?us-ascii?Q?BkKt5RZmnJgH9FwHGKnkKT7FDJivUNK5FntUMDIaXbL6RFLMGvQQFo3jV6A4?=
 =?us-ascii?Q?2zND1xJWcHpleG4atD0WODxVm0QuZE358SY9CwZ7PpQTvP9JRK8GY39b8x8M?=
 =?us-ascii?Q?ehG5FnA/QcTMkN4Xw7+qnzxWsGhhjh9XnroOPRlmzf3LRhMJtkae7T++2FlY?=
 =?us-ascii?Q?lUwiYMoJFtIx1WV7l6pf4eFh1UpBiIkdjTkNSh8mDHbdt1KI1urAG1fxYQz0?=
 =?us-ascii?Q?j900xiGDP07ZfO3E82+Bds2dCtxler6Rcrq2ixPZHe5GCXkURtpAnPrV3SK3?=
 =?us-ascii?Q?BPAU/a51KnmW6VbvOp/AwrqOAmgGjhhbKIOQZ6WlZd1L0jYFrXtum9cL0Z6S?=
 =?us-ascii?Q?UrYGVH4Il1cVg0GrA2bL+QCHTalfI/0kkCv28CKOzT2PqjY8V/K/y05WBg4T?=
 =?us-ascii?Q?tmMK6d3aR4mujaz8Eq9PAZICg2xpxUztTLtfpcd6kSominEKi+euilU+gPa+?=
 =?us-ascii?Q?RyieE2bDt1AYylotxr7QbPkZ2Tstsv+grgBfPslC3JfvBjrayf790x+OaSRL?=
 =?us-ascii?Q?nSBO1JZE1zQ+7ykcA/hebvZ9Zmu2K0pK7tCE/+7XF12GXCW6Gc7VW6PFQWWN?=
 =?us-ascii?Q?4NW1uR13Cb8BXBHEvieV9k6ZCdv6c2B6WieiWn99v8okgtCh/qBSlntu5VIo?=
 =?us-ascii?Q?bfqCGvlXwFAU3PyWeMnK0uec+YRw5GcGosgUBoId7ZmQN07I5rIXC9BGT8EL?=
 =?us-ascii?Q?oc6BMREbm9hnfXUQbT6AqVJ2avq7ufBZk7Ok1hC7mfpUWiOYKoGu3usCPDN7?=
 =?us-ascii?Q?AR+q2c6EU5xyDDun2KikPOsca3v44Z4yfaDHuuATIYw0GfuaSuM3D5/OXCHx?=
 =?us-ascii?Q?JcbztDFc5mRpldKz9YGWfm6c/ScNc1YTjVOC+nLyGv7jtoHNccEdxlYtJwQu?=
 =?us-ascii?Q?BjHtNrOn6c18yaV8nm/yvxUYAuWsFXnn6dVkYfetpF2pGFNA0otrFI+pcIJU?=
 =?us-ascii?Q?aCIh+iGCCIBGYnaczP9Yur3gqk1KjwvayL3YCemtouiBPdBPwFJc7JFUrNMO?=
 =?us-ascii?Q?Zlb3RKwXHeirg6Cm8v55wVnLoBtNkcQT9XbLhIqKdO7U5JM+J1bkVrUsIso6?=
 =?us-ascii?Q?PZO/00BrxFYs1upHHeng9WTNiNYiIKpRToZSk2wyx0VXIuafO/V9VodqPl4R?=
 =?us-ascii?Q?UqfHmOkCLAUAAs8xngvJ59DkuBRwSu+8q7Q6YRe6fuZY+5ZBfH7VuznqzD1y?=
 =?us-ascii?Q?U9EU8TyZKpg40FTO+m2y+VkxJK0ZevYxjH7o54Pw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6652682-a901-4b30-7ea3-08da6b111e28
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 12:04:09.2338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mblMZfrT1lTATO1u6a1F5dogbgjoccbdN+4G6tOFQeZw8kp2CZetJsrvldW52k+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 08:22:58AM CEST, kuba@kernel.org wrote:
>On Thu, 21 Jul 2022 07:51:37 +0200 Jiri Pirko wrote:
>> >Hm. I always assumed we'd just use the xa_lock(). Unmarking the
>> >instance as registered takes that lock which provides a natural 
>> >barrier for others trying to take a reference.  
>> 
>> I guess that the xa_lock() scheme could work, as far as I see it. But
>> what's wrong with the rcu scheme? I actually find it quite neat. No need
>> to have another odd iteration helpers. We just benefit of xa_array rcu
>> internals to make sure devlink pointer is valid at the time we make a
>> reference. Very clear.
>
>Nothing strongly against the RCU scheme, TBH. Just didn't expect it.
>I can concoct some argument like it's one extra sync primitive we
>haven't had to think about in devlink so far, but really if you prefer
>RCU, I don't mind.
>
>I do like the idea of wrapping the iteration into our own helper, tho.
>Contains the implementation details of the iteration nicely. I didn't
>look in sufficient detail but I would have even considered rolling the
>namespace check into it for dump.

Hmm, okay. I will think about helpers to contain the
iteration/rcu/refget stuff.

Thanks!
