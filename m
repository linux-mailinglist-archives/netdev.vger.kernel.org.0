Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9357B6C0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 14:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiGTMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiGTMuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 08:50:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22F414D25
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 05:50:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1krJKkyENgoJP0x6ZOfMc+/bU/mvWEDPvUh8YzbJmmPDiJh99S+kwjphKVj2P7zurAyE2D6WHEy5uxb5FGqfNYtSqsL8XSe+0LQccA4tmH2GMfW4ZOMd75+0OTKCM9S5toFvFyWY1EtCa4s7CDrCxbvpWIrqfgJR5zxJaz2HYKBtMHerJCMtcLXAirJNHr2pqZ+DF28Dsh1F53MvYq2Rz+CQKl70Yu4L3vgyy7Udk0ekUV93jfArP13aHoWy7JdeYfKojUY5vAsxtIULfmFFPV2LBkRFRkmJ4wOD1tjMj8V9KCxfx8UiYzDajq5buTH0KIIYC9ziRBA3S/E8UXyNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cjpPmqkpqcVKWI0UCA+hogFgSvWwcV07sokpElc428=;
 b=hrkFxzjCOBzMeunCspdFZVjaysd+syM8UY1Ng8qitpMn8qTau09kYVvPJzn5mu581w8Nwlt3rXlxFhEVNgJDjMiJ16YgHjP5qlVkcwo+pizhx3jeTGap4yMtXOs/XHr+PC3te+VP/VcebQ7Yoc3BKlWw+tMj5KL4ZywvE7gX9UaClinhQZx0QKIBYYT5/0ykHy1VYQINcxGKeB9EdwwPe+n2rCarIR1cj25IX7SRUJNCU9haHu0BFPR9XGgHw5hE2DBJmbh5MdCGV6RMxgyd0OHgOi3IKi96CxigeCH5PKgh5OFh+WVJKNptkb2xwkyfGwukQHuCJHaL8JP2QVCGYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cjpPmqkpqcVKWI0UCA+hogFgSvWwcV07sokpElc428=;
 b=XISryuVVBU7/EqmGtbFUjQnFXzrr3HmT5BTwRG1e4Qy0t3pWYQBFy2bkVK4O/539YeR5CQYbQ/DBZM/tip3W95rnYyscsn1AXxdy2+63sqJVFBLyzU2L7GXrF67YLwTXjjAh+9oLoCGL2SsrWkrs9xxm7cLRHM/wp7j2DuQgx63m8X242Iie7MlYtEsg3R1gtUW6FpYox9NpE+bsyVuKW3UvcfH+EurhA3g4icgMQfMfuta3/at5+18of5rfjp5/AdIvqe9as1QPNeU/7xMqQc9IZftItJlyphsQ/ZMP1st+mxzmnnZ0CI5bTGAvlGWw6TH9KQ20m+STQ2aeH2PRCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 12:50:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 12:50:15 +0000
Date:   Wed, 20 Jul 2022 15:50:09 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <Ytf6ASAXTFItHcT/@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
 <Ytf4ZaJdJY20ULfw@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytf4ZaJdJY20ULfw@shredder>
X-ClientProxiedBy: VI1PR0302CA0022.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3438b39-0516-4233-abab-08da6a4e647a
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5674:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yd3smQCVPyOTTEn1Mgu4k2xIgLkTVHm0yNK74WUvfS8wxnGJOlyubc73bCYYs+yv2YOvAPM1jilFXvihWgGXfJWTeaVVe2AXXB+MXBOKt/gS8IDix6p2Ys6jgYHYa5LtJ4SyfUKkqhw2SwoeRYOrcD+5zoAnl5ZW0zWsCJUk7B+rbJgWsxaGAJeiHoHp7ojfcp/dS6LINmyB7EkszTGamLwhZrI20qc1SuKh4j1XOVMpjJKi/fUI7OugCiyDeIrIElPyO59mmnXI25TWJ1G5OaflViqDX30o6HOx8HChtRzUWCb4hEHH08DfRmsuxonClegEn0mSTqx46ulWhsHJphnTwt4AezXzVsb7XsCmWCgkH/olcP5txUAyFnT1F9YdWAYrzqa6raepX0xcsFc2TfTJMIUPBnzwt6Vy6/zIySPO9oS9AIXXexXnCN7aKL0Z5AwNBtYN2bs3md5UKfMwOZ1XxMqhhN706vm/kXAtLoPnPYxily1Aihz0pPHl9fCs2f8JXcR6b1Da9+jsuEU8sDcNND7Bob/lgP/D58SGEHs9bBjKtNTahG6Qsl2AsH2xPf/ccn5lfdfzA1FycAiV4SfA+SsksU1NYuNdjfQrGy0hYTQe+g4eL9LyGjfYKSa49yrkA6hhq+7Fs6Pcxi/rzdX39NiI95GUjgvdwkrBrboy46oOEr9rZORCZ1avuPx8iWLyfg1iv460B+ubdRuNQkP2PFynMVqu5WEhpw8a3h9YlySev4wNyk+WYAlVwopP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(86362001)(38100700002)(8936002)(2906002)(66946007)(5660300002)(4326008)(316002)(66556008)(66476007)(8676002)(478600001)(33716001)(186003)(41300700001)(6506007)(6916009)(83380400001)(9686003)(6486002)(6666004)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RAOu/0uerDcZ7uc3UwcZvoeY78sEcNi88stXrmjnLt3hcAwbQCxj7VOvWjvS?=
 =?us-ascii?Q?3OIpk2ybcypxt+N4UrfkEcNNmsUEeEJcoyVWycjZQZroFCq32laoNIhiznTA?=
 =?us-ascii?Q?hrbfAnlz6QTxjEE+lmYzW1xQdwblMM4fZSn1vv53iTqkWyIPdFeguEThSdbY?=
 =?us-ascii?Q?+IbSFF70jwQCjZmuV4x19NGOGrieBB3Q5roaKR5huoa5sgE+SCWKqAUhsq+Z?=
 =?us-ascii?Q?uGzizKQnwXZ3BSeCB1oO1lfMgpzq/EeAssCp10DGZIXSc9DPtn7o4ICn+w6m?=
 =?us-ascii?Q?yYZFAwdiYuUNCTnWy1ieYcDR1NOGVuSBMMqtgCeoVvujYgWr3vsu/IVPMDKU?=
 =?us-ascii?Q?C2j7JXYBJBJbj2hVVaHoyr3dTf2XkHctWu2Pga8xtsEUf6EObzD/Qrd2oFxA?=
 =?us-ascii?Q?d5O5TqR0ZseL5ef5/o86RaW/kqRb9BMUaNd7yo4Radb9f5VSon1sWJO8rLIY?=
 =?us-ascii?Q?JxzGFup+K3Lr3taZJWUj+ISyq/dC8I33t8Rgk8m48gKnZ6H7C6+jMX50TVSE?=
 =?us-ascii?Q?zrKwMfjgVqaOLkH1QDMz5uzIKl6kJVdW8qb4M7Y7LLsrFFPfS8ZYoNqS4NNX?=
 =?us-ascii?Q?egsN4awwXFxr0mQSU2K90vv+C2LDdLoHHRObvTEsuFdACFAskppILwDWUKv3?=
 =?us-ascii?Q?0YA501w1taLN2b/PlPW7WlRCA4XWwI17FZkypLq1i5cf8kvKiCB841erQy/J?=
 =?us-ascii?Q?zuVsH1ZaJ9salUuFE4Zq4ev7HhCNdfBPQ0Gbi8gMmdV2wRkZnTDEROuqBW3+?=
 =?us-ascii?Q?DwB1EjEt27TAxTiUDmuyPPmzYQ49aSESoX3bKTUuY94oyo6lvKPb4OXzPgRi?=
 =?us-ascii?Q?+5SRtcUiNp3662wbZm+M0CrByj1tCCjdyErx4ohKJR4myW8Rh9uXqPm3F/6i?=
 =?us-ascii?Q?Zhn0jGeT5luQSywCaRUU8yuGEZ411neTjBH6+Lx1ZQhaolT4TanAHG7W9Wjt?=
 =?us-ascii?Q?nMMbECnXlYQ8YyNVgH5AAcGiVXLDJPBEtpnmkHSwT53vvI/ZAzDKxthtfyNB?=
 =?us-ascii?Q?K83nQMuI1reS0oXHG8OUkyfV+S1AHLdEwSpIQoPoIZlzqF+8VhnB/jNTmcqH?=
 =?us-ascii?Q?kVdhgdXeUebhfYaVZEVvu5hJf9D1DRk//aWJFYJvX695gtTqVP7vu/D57Kpo?=
 =?us-ascii?Q?OHx8gHAvDFPN2gYpIomkwhCYnpCb+x9RnERdVIylO2L1kH9ee2AFJOJSQ0AA?=
 =?us-ascii?Q?HzEtU7C8IBpX0agC2w2uVzG7/qU4E/ybkzfl4VPAD7KmGAQ0r8XgjeuhBEj7?=
 =?us-ascii?Q?VtbfWELMXUWZtkgZPwj20YMSPwAnFPlfJzXR1o2afmZI7EH4QHR6XeA6rzh5?=
 =?us-ascii?Q?DLZv50GpXXbYdfMDJ94JsanG12XlBN52pRTZWmuT6z0mOy9Emg1Y3I4d5mbQ?=
 =?us-ascii?Q?/kMXEw4QeBpVMZ9bAJhOaJHMvz/5DDN95OxV/stUZdFcTCQBhSI8bXL0NHLI?=
 =?us-ascii?Q?43Z4kbsfXeKBa5rSGrjKnfQUvwZG6KgV0cebWicrUqKsLyjJIRsX04C+ahng?=
 =?us-ascii?Q?c0gQyiwgYLoOpIj8TDGM5w/SCJKA/UX2k+L1PvZMXRoYIh2YKjb20wWNJij1?=
 =?us-ascii?Q?cAKx8T0qbhW64IBtqXdQ2MiEiCkumB65L9HVy8L4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3438b39-0516-4233-abab-08da6a4e647a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 12:50:15.3350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IpIqu03YpA9k8xnoze/591y27oaVa0jO6h28CsJn3Cm0b7edAd2lmNAKK7hkjTWVT5PXhyL9OotkCYFItXZcRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 03:43:17PM +0300, Ido Schimmel wrote:
> On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
> > Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
> > >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
> > >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
> > >> +				    struct devlink_info_req *req,
> > >> +				    struct netlink_ext_ack *extack)
> > >> +{
> > >> +	char buf[32];
> > >> +	int err;
> > >> +
> > >> +	mutex_lock(&linecard->lock);
> > >> +	if (WARN_ON(!linecard->provisioned)) {
> > >> +		err = 0;
> > >
> > >Why not:
> > >
> > >err = -EINVAL;
> > >
> > >?
> > 
> > Well, a) this should not happen. No need to push error to the user for
> > this as the rest of the info message is still fine.
> 
> Not sure what you mean by "the rest of the info message is still fine".
> Which info message? If the line card is not provisioned, then it
> shouldn't even have a devlink instance and it will not appear in
> "devlink dev info" dump.

How about returning '-EOPNOTSUPP'? Looks like devlink will skip it in a
dump
