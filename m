Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1B354C467
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbiFOJOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347068AbiFOJNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:13:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F538DAC
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 02:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh5ktBKsy2N7lwz4wde89l4IMH9IfokBtEG25bqe3wCAO8jTlkn5NMi7NvoIem9jV5UrS2aP9mUuu5u9tpLDoW2JuxBZEGk/3vX9YxIlmfxZ1U/dpAcmxmI6BOGhExEJ8ptKyMgWbkpD7TPuw8eJFnS0V8PGC0XjqBFIqttVdVTqpfEjHmoqIHTIrEtAeQ6yngLZnlVPNYLrbhDdNQGsdlqig/srP95bdS9F5AtoTgprMWcZNAtO+VpCMLDpAYSwiaFTAV8GLoXYchFdRzUluMe12b+zRlaZUvZfCPTMllzZTDgW9T3sokeh4l3U31GQJ0nuWQktoriXE8adcDe4rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LM6ftBYIZ1Mknvuqcw18WrRGof2NQQozDfDaeiYrc54=;
 b=Lu4gNUCY07dJJyq2Ul8RAXoZFKP+Ia0g1pnLrtvZUs+mzqHg3LY4EH3ugRikgJvpXPrZcnstmOCCCsnHOv+73SqzyHj3Uwb9eYJoONVSUKlBQQcNXmBj8svVtEZQCEdbmjy0ryjWSHZBbCzBN68kKFMqOsu1Wi++ARzR9MRCIJXu9eOMcXMmtu8hoybve/LWeSoDpvNtCuUalveHm3RGDfeWaR0Wh183hfCl4RnncDPX9in+ccyvvW6aE+TBDn357Qhcz8vQfMSFqDDISJ32wuft5FsovniJguxzUjXf8ktAk7IXNx9UXFxObyEwIX6ReTYVzfWlEu8DSVdOOfea1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LM6ftBYIZ1Mknvuqcw18WrRGof2NQQozDfDaeiYrc54=;
 b=bC6Rc8UlhRwwDDTbiu2UbliepAyjDkx41J7XM/WRDuOC+kGZT2vBM9C6Iu0cr8WOzVIf7QhOMywTD67HglzBCFwdTonoM8WZEawaMkSIrsYZC9jtXaSMc78nXx4kCj0hxdyrS0TfNrrJ59riPlJDfZ9fHIN1MvTZaS6IKhRHVMxckpBChJ2s6ytdPlOhxsAiM9b0aQL4Qe5Q+5fINDXNge8SZdf5EmkP7hfYA7XcHFX58LIJcnNOoYUuKD1vJmlP4FjHzkzdBO3cdkNVinptzHIG9sfEUNDtyD+ogngDuwspwvQ4DpsgXKm5g7dLk5rdXPNTtEPWwUEEtmGh3PN87A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4469.namprd12.prod.outlook.com (2603:10b6:208:268::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 09:13:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 09:13:41 +0000
Date:   Wed, 15 Jun 2022 12:13:35 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <Yqmiv2+C1AXa6BY3@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0501CA0039.eurprd05.prod.outlook.com
 (2603:10a6:800:60::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ea9b8e5-a032-4b0d-66e2-08da4eaf5710
X-MS-TrafficTypeDiagnostic: MN2PR12MB4469:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB44699811858D985AC2768989B2AD9@MN2PR12MB4469.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVxEwG1jtfhq7L53CwAHVbOtMN6L0W4++u+vpJpQoAXZeJuNbnXxNPPGCEb8q++DL7c7d0DQSUgVUgtbehCuS9edTEn/jXzrVNVQ4ClObUSKqLQ9tiuVrHmQr+JljBr519b8eioYuP7SOy0tfA0Pf4+iPFdkxNuuo2Jvq9dMQmdvpDvW9S5l+6tp3IKp3BCt5KfvnEAugZDE+5tuX1p79YD6Rw3+5X85ULpWe92SYF3f27tomsj5ivXPomRPzdapJ0504T1tHbYctLJbkEO0lB5amH3CKYIHQ8PJSNM2TFDIl6yCkQFgyJIBnslcF1741zX7/6Pj1Qw8q8TWCHBUruGasawksHMFtTxCkmRBLZVb+lfy1KVOkN3VBMXfexLnx9m3IUlUbk2qNGp2z2qjSpZoQh2WnWIPavDSqTt+oMk88N7zuQwusOgSyAng4+MdnyUwme8xDyiafnLV1WXlPCJAy8ui2vwzn6aRl3vcX2yKSCaqFZHI2YH4FdWEgMDPBWKrBl800SoijOLECSMGmP5VKQ9I1rpwdW2/QIjdMoe44FdryToR7c3dhsmz0igR/qoPMnX/Bmo4NaNghG3cVF9zKAmeKo33pUBuFFz21S/9smiW7l2U6SMIdRzbzLckNixiE70jOabf1Cw5jqSEVrH9lneFqa96Q+Oj5L3oP9lk8L1jVOlCXKZsHlKcurBSGvk/HhsuhRCqOzuIPwtpgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(66556008)(66476007)(8676002)(66946007)(4326008)(2906002)(86362001)(5660300002)(8936002)(38100700002)(9686003)(6512007)(26005)(186003)(107886003)(6486002)(508600001)(6666004)(6506007)(33716001)(19627235002)(316002)(83380400001)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fgCkm4i0xE0jDuqmcSp18FbRrIiRyuUMBEHshWWgyFQKl6Lg7E8rzWVmLnns?=
 =?us-ascii?Q?JI7IqGF6hFPTh2B1Gsjo4hV6JXjkoX42zdk/zFz/6NaaMHXm9VtruVxuU8Y0?=
 =?us-ascii?Q?RCIw/Oo7FQ7tAm+cNzTcFJ+Gao9ZH3TvtF2tAIr2XLGROfYTmKZ4kNL+Bvra?=
 =?us-ascii?Q?zd8gJTtc5ISkn8c0bCkQ9+BJBBNr/mHLo9O8uTCYoKPAvpSyRsciSuRYyKpm?=
 =?us-ascii?Q?V7l8VyIrUNDZDzyYZtn+eL153Vzz/Ioj5HARyCPm2wAqO1qeOQa1XY3m58KC?=
 =?us-ascii?Q?UJgoWSzRHNueg9heDVg/VIwq9iIQROUYKamL67Zc4pTGrPz8bDS0Mkx3ebKS?=
 =?us-ascii?Q?EfD1lvmkXMhlnlBSVuwPhLSsFvMlIc3o4wnsH0kC95LDb7JGC+qxjrvNjJ5U?=
 =?us-ascii?Q?gi7xfPP9vdsr5QzRBtTcEuYK5JS4gox2QL3s8rrkG0HJrTIu6EmlEga9Ep86?=
 =?us-ascii?Q?xSmwipy3A+DnQchVPO0ZTDhuATjJSgq4m4L5y7Wj7VEbEpLavqJWntTSAnM7?=
 =?us-ascii?Q?HaTbfvwL/C3sH90HgI5h99bZcB+vxVu4CSS9PSEo3XmdNXm73xLFMz6uyHwH?=
 =?us-ascii?Q?Ke2rTLuSDYg7jyQtwrjIrlZwACNulsX5jTYa4nFfUdVf+H/LPkcb2twgqn65?=
 =?us-ascii?Q?VDKGHvwroguAFiK6eRqBGjvxedBvS8/m3F4re4VcQPe14l6+NzmuvTVUbrJX?=
 =?us-ascii?Q?aVkciwZGJay2v6CC6WR/cm1epGHstIcTCTV3ub5R+U89RzqAYxekNYPfeY/3?=
 =?us-ascii?Q?RznCkouffmCO5SKegpKRwnm9sfo3xblc+HCitjAwKrvhVDkT+XvZtsznD1dZ?=
 =?us-ascii?Q?WsaibxcCuJEpRf5fY7EeAyVruNNDkT3YHtqYSfV9W8Gp6s4mPQegAeTUuZDZ?=
 =?us-ascii?Q?UFEx8R3zF2dghoDQD7J+j6em2dZIXoTzQgKo06eA1de1uk/o2H7pScMsqYeO?=
 =?us-ascii?Q?NeL1rTs5J4xpsz+fwXEHKIg/8AxrvTn9Bsn4uIu8Od2+mHvDzuEL21iBEK63?=
 =?us-ascii?Q?7A7HuIKYwa1KsL/+RBHKFVYl6/woNb1ncwBD2IIQ+JT8eA4svQlt5BNo+8RY?=
 =?us-ascii?Q?GzNj5bpDEVe0Jqzul+68HTZvNFHS3qrUQxU9tLKiN+5V7I2LqZJbfd4gnnQa?=
 =?us-ascii?Q?eUO5kr8fUGC2tuoa/ZQap5v6Eth6c0Ui4f3uQya5SK+SD/PbjWZ010V0cToO?=
 =?us-ascii?Q?s9ADdXpUwDeQJVYZPztiAvL2LMphaPIdL9JO6qxDSNObllW2i3pEFql6PRIB?=
 =?us-ascii?Q?Y64tufW7umfE6UfT0953rXy/LK1zK9gYjmlKmdLrPJDpNogNvqRbnL21sclE?=
 =?us-ascii?Q?SwyTvnMjO0JqT658MAE6m2x7DwgYdqovBs4M2Bk6ljfmunHIRxjTYVRjZP1A?=
 =?us-ascii?Q?ojEntyhF7j/DxGPqJNAOmtdfIWmhffprk2bAT5Mo060WHnB4p2PLQQTZYenN?=
 =?us-ascii?Q?tgbit5sXJXJbMa/bGeREaggLwnktJCOeBA/wKd7U42lhkvxnKircwbJMAaaX?=
 =?us-ascii?Q?f+NzxTvdZtVJGTPvCYDVHXxyIxQitT9lBNYonlfXras1YCMWeVFOYSnedGJz?=
 =?us-ascii?Q?fEzE7KrwSIPD7jUb7cr0cQkOzR85Bz01ANzyu7BaOn4sAUf2x+lWNcJ2GTwl?=
 =?us-ascii?Q?ndP75Xq+VXo8PBUEMz3JcVj7d2RDlMBSvs+qOcDnrQv6GiKUelxLGLeVuEF7?=
 =?us-ascii?Q?HYoFChTFoElEiYOCZ85CONvRcREPx2udKQoQ6Q3Q4JZvgA/H2wX5fo/0XPD3?=
 =?us-ascii?Q?v+jcFyycjg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea9b8e5-a032-4b0d-66e2-08da4eaf5710
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 09:13:41.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXH4hwOOG+PhXa9qQDdCW78bk4wJ4htc7TdtL0OKDwQWyxjO1PyxKZxtuRaTPL0jE3bPDTDktzidXFHJKDS4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4469
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset implements two features:
> 1) "devlink dev info" is exposed for line card (patches 3-8)
> 2) "devlink dev flash" is implemented for line card gearbox
>    flashing (patch 9)
> 
> For every line card, "a nested" auxiliary device is created which
> allows to bind the features mentioned above (patch 2).

The design choice to use an auxiliary device for each line card needs to
be explained in the cover letter. From what I can tell, the motivation
is to reuse the above devlink uAPI for line cards as opposed to using
the "component" attribute or adding new uAPI. This is achieved by
creating a devlink instance for each line card. The auxiliary device is
needed because each devlink instance is expected to be associated with a
device. Does this constitute proper use of the auxiliary bus?

> 
> The relationship between line card and its auxiliary dev devlink
> is carried over extra line card netlink attribute (patches 1 and 3).
> 
> Examples:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0

Can we try to use the index of the line card as the identifier of the
auxiliary device?

>     supported_types:
>        16x100G
> 
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0

I assume that the auxiliary device cannot outlive line card. Does that
mean that as part of reload of the primary devlink instance the nested
devlink instance is removed? If so, did you check the reload flow with
lockdep to ensure there aren't any problems?

> 
> $ devlink dev info auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0:
>   versions:
>       fixed:
>         hw.revision 0
>         fw.psid MT_0000000749
>       running:
>         ini.version 4
>         fw 19.2010.1312
> 
> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

How is this firmware activated? It is usually done after reload, but I
don't see reload implementation for the line card devlink instance.

> 
> Jiri Pirko (11):
>   devlink: introduce nested devlink entity for line card
>   mlxsw: core_linecards: Introduce per line card auxiliary device
>   mlxsw: core_linecard_dev: Set nested devlink relationship for a line
>     card
>   mlxsw: core_linecards: Expose HW revision and INI version
>   mlxsw: reg: Extend MDDQ by device_info
>   mlxsw: core_linecards: Probe provisioned line cards for devices and
>     expose FW version
>   mlxsw: reg: Add Management DownStream Device Tunneling Register
>   mlxsw: core_linecards: Expose device PSID over device info
>   mlxsw: core_linecards: Implement line card device flashing
>   selftests: mlxsw: Check line card info on provisioned line card
>   selftests: mlxsw: Check line card info on activated line card
> 
>  Documentation/networking/devlink/mlxsw.rst    |  24 ++
>  drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
>  drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  44 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.h    |  35 ++
>  .../mellanox/mlxsw/core_linecard_dev.c        | 180 ++++++++
>  .../ethernet/mellanox/mlxsw/core_linecards.c  | 403 ++++++++++++++++++
>  drivers/net/ethernet/mellanox/mlxsw/reg.h     | 173 +++++++-
>  include/net/devlink.h                         |   2 +
>  include/uapi/linux/devlink.h                  |   2 +
>  net/core/devlink.c                            |  42 ++
>  .../drivers/net/mlxsw/devlink_linecard.sh     |  54 +++
>  12 files changed, 948 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
> 
> -- 
> 2.35.3
> 
