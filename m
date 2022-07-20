Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78D57B335
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiGTIsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiGTIsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:48:03 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF61C65597
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:48:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHUhM45QvC/1tZQa26ljX3LqET7BKmyA1KQprvVNrUhCj09LBcJMJoMliZl6F0HMV1nVqi6BhMSj6rOgCGdpx8g2IJhfEuTJ0lBIwUxt8xqGuDK1lAOYb0Vch1kSUmFMiIqXcFnkSXmJ90ePzLjAWhiNrA4FC177fxT8sEO8FvHTbqhlghGL0vH9WJWIthbn60MRgoTphphHbBuE943CineVZtjrizacvJE0Go2OMVwp7JqlYSpsAMCSY+zXrmEgX2WrUNqM98XA1DOoWkIwZ5pKQGFvDT2cXCDuQoguXShADfEXmKB1ESAbJVCSLGGE/E6GTk3M7EwNnQ526DwtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BriMybkSDIeR7KSFd6ca/Q4rpaocPkUODa4/KpVjf0=;
 b=mgn1uYl9d5J+v64veGd8KAtBfds9BKMwBZISSxMNklO9ZChaRBoIwKfGOP1Ruz/RVQTP3OdJZBmDKRnRLjavfP1Q/FsNVnk81iLORgvej8TZ4TrwBXuSh15baLCtStgb7MGBqs/e6O+WDjJsZqjrTDlJ3z3/uiTlAJwrHfNU4y5dEPEH/s3yriTaIyy0VvzP1jk2dP1VNeslTpfuY2FJTrvz1IG+fEPLFTJ4xsrUZv76OH81b4P2DiQGOMnDV2s41JqUrfU1564jsA7hjRZ0lxKMCSahVoowqDS+WKSuAjj2pWxcqT0ZiLOwILe3k1tIf71056e3smGk2FQ6cGAZzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BriMybkSDIeR7KSFd6ca/Q4rpaocPkUODa4/KpVjf0=;
 b=YC0WRE6Yptr3u57Bpwd8A1RQY8xC8qbhL04r9N/n/86luKcCWJ2tvxDwl2DizF4GBH5sIfAYb40ot9zfjjMoQh0WoqzxT71fbiF01DRMkDxr9efp781UHI1noV+EKEhTcmv6LnpOubVjVv5C6WvfDAsfwu83PL+rg76V6fg+ZjYbtGaE/eAqVAXoU94/2nNa6x0ZCCPVxiUIDd9ohMnx0NJlTHuTK43jeUdJ8uaPbQVmP5U1ATFNHzgigyYKSrjI7B3LvSow2xtw01EQO7coSNL2/NEm8KKeGWPD7rLUB/uJRT6Afu/82PuwyPVfDI//Cc/8mInRAqWa+H3bGo1dMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN0PR12MB5812.namprd12.prod.outlook.com (2603:10b6:208:378::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 08:47:59 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 08:47:59 +0000
Date:   Wed, 20 Jul 2022 11:47:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 04/12] mlxsw: core_linecard_dev: Set nested
 devlink relationship for a line card
Message-ID: <YtfBOUbUVGhHWxmh@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-5-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-5-jiri@resnulli.us>
X-ClientProxiedBy: VI1P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aad0bac8-cf8c-4ba0-c4fd-08da6a2c8c52
X-MS-TrafficTypeDiagnostic: MN0PR12MB5812:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cUhtj1rfE6DjhFwwSE3z1AvYfJW/CKC3MACl1MoBpzLpPR4HEBEkSYWU7/9nA3v+NeQR3OvwiEKH/+nT/snhpu26IAmHqV3QuUOcI56ZzoDRTbp2YAQpDGLun318vCXm1vWO8NMzze0LL2TuQophsDjJmaQbiYxFBV9upYaRb+vtrnV6ioGsnr/kh9lg/NrRE6QgvSz0KaqL3+udOG9ESiwT2oXmKxiYNNkQAXROEUrQqqHbOiHUPiRLL6FQc+05e3S4gnrJBtLmBrmsVi38biWuN67QtzxupGn8Ao0enJXLfF706HqB1IToawdT9TocrE5J0UkOD0SRpP4LZOvp1F3t5Ym3OEhIFEa72CB9TSzFSgHM9YA+hZRCG3xORtKeuJDzTAXRqMatYM3znWhkLF9HDoYI46K7YUXhQLxtUCvDmtC6vBi4Wc/EJmUY6/EXWjmKQ9Vt/GDY5CZ0pXIcpz1Y+RYxp52eMJr91vPNxEsRcznw6MJFIGL4Abuk3TDgdRuYpX1t5GDNGmM3QsinWv07k3wpIHgA/TbIc817mMFgofZxH00f107xBn8VSV4Lxp8VGccsMC9wPX+Kl8JFcGhEIGcIsvliLNmZ0GHbY0OXABJyj/lm05jk1aZXmA3re8aNIW/ylR3iuTUcG98jJYt9C1u7rt82zeUKnQDdQcBQRqVlpB/NRdRB7Fb18/WRQa/61NvCANnlbOaroR5elFgPYk4A2khjdOHNvSSAKR59yUAuE18fTvQ06VzmudB/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(346002)(39860400002)(136003)(366004)(66946007)(4326008)(2906002)(5660300002)(6666004)(66556008)(66476007)(41300700001)(558084003)(186003)(26005)(8676002)(8936002)(6512007)(86362001)(6506007)(478600001)(9686003)(6486002)(33716001)(316002)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ImsQyrjgqoWNtwAyBQ4ku0E/TikgmXICRWxeLzaEf4fPZstSzXaBTG1GxZo?=
 =?us-ascii?Q?J3SOYE6bTEt5Pr/+VQ2kczPLrkBmjDZHWf+KSVn/Xy8Oxww1ncc4k4a6h3vV?=
 =?us-ascii?Q?nIIDAiIULzsbVRWiz58rceqLvRDXiW37X71YOmjkgkY1uAMGyiVju6CGhxW1?=
 =?us-ascii?Q?iLcYy+f3JryelQrub88qdjaUC0nfcITxe3fW+4umB/NUbhVUQiKbjg5HW0PN?=
 =?us-ascii?Q?q9S2P1KDwVRfLO2/aVxOorMPyYcdIg5+gFz8tFDqtqDdfpGkRJtDYZr6wJsJ?=
 =?us-ascii?Q?R2fFSLwEsOMdRXs1LjKVpkPoPT9j0qVcdwPmAyrRJqVL3Io8ezh4yCPjJAiN?=
 =?us-ascii?Q?+sopBS1YI9tkDXK6D/Sg5OK9r01rvttrNzWFpA4pKgT12LyIbWRALKe+S1s5?=
 =?us-ascii?Q?QEhDLA3249uZftTsqE1ZlKFlKFdvqLHA1/AowzXAGycOmk7ihEbLg6v1+iSp?=
 =?us-ascii?Q?VDKzEZEfMbeosrQeEg/G0H8Dl7M3ZKLo2FK9VwMFsIY4Vsom3onb3qD8d3Jc?=
 =?us-ascii?Q?hn00r9nzujukgTQHK/P2prl+puYVHTfY3ZmQokq7KBqW14/hIoIg8M5AbVgC?=
 =?us-ascii?Q?2LBoWsGRRwpXsDqDuAtqCp9Ii4YM6sYidL5M4j26Nry4p2Dpomvdn1wl/Vuh?=
 =?us-ascii?Q?EyyvZDI82Y02PfwCH4aRm7exg01cKAl3esIsAhBT90tzJTuP+1+Dlw7RpNOU?=
 =?us-ascii?Q?UFA1Gw0A6jLegiamdX3FHVsoCFw5B9GTmjvBF/pvXeIWQtvTzq5243AtgUoZ?=
 =?us-ascii?Q?5KqO5w/qSpDiYgKkh0yvCeDQuuTPI5h1YX/Zf0jrYa5MjKLau/Onp/27LZg/?=
 =?us-ascii?Q?L74ryi+VP1QoYHQ2oA7ku8CdWcnuTB/RNqEuia3aIviIomaNZMD3bArS6tMM?=
 =?us-ascii?Q?KgX4uP4i0hFANEW1nT3zPOt1jabvP854ZvWrb8BqXjwIvTyTlO+pI4Mfr/+5?=
 =?us-ascii?Q?a3eyKfVAXj54Jyz6lZR52lgPQ+zQWmoXbXPBhgFw/J2d95/8erGL7kmg4XBk?=
 =?us-ascii?Q?0enWXsjcBE/hG9BEkpeDKCy8F959IkdN+YhvF9foETiV0/A0FOpwIfP0jpO0?=
 =?us-ascii?Q?spLeGDGGLiWhxxJjXnXv7AJeyu4OboGEO1l8dqJIAEuuFgMEYjqAp8BPhOWU?=
 =?us-ascii?Q?dQ0peLj8/At8VbM2nGN79f5klejObuR/zzNwEnjmwV+FIABVQVVdcgQTp8Mr?=
 =?us-ascii?Q?8oU+tJObXdfVuTjajacj3EEHtpzp2/8X73yuioB10FXW4ldLfA1q3e0CtHxQ?=
 =?us-ascii?Q?MNbGefEO0AvQe6rVCi/KlGKBheYMPtDnGir5n4iS9GvMKkd9Ub3zSkRMP7Sz?=
 =?us-ascii?Q?ghn5qqBqS0oWuBaOIwewQ+6iACMssTL5PekrzwkiDBepJ29wiIdic4e3lJuq?=
 =?us-ascii?Q?H7UuOvE+vuNQyI/ypLCtQHF4ANJWzzrE40Dm4WbPc5np9eksPa3eRszr1+Un?=
 =?us-ascii?Q?Kc1JV50IzK0pXYhDwcVCAC1Z9wLDfAKBQOLzU+aZ+ld7R8h5sVh2iALGBs1w?=
 =?us-ascii?Q?4wkW0uG9I8VpO0a4Jas8ZtpAX5uO+2yZJAny1JDmcLsk+o3g1dPXmywnLquL?=
 =?us-ascii?Q?4IE/9bQVne2CUhMSOoam94O48TfU0PX+1dckjbmx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad0bac8-cf8c-4ba0-c4fd-08da6a2c8c52
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 08:47:59.2935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pO37XmQkh8wSsXN7d1FupPcMNLNUevQ9uqEpodEkASFxZJLj6XsEkBwUnDYVHyUn7UYB6J7zlM3SmVNbZx4opg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5812
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:39AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For newly created line card device devlink instance, set the
> relationship with the parent line card object.

Can be squashed to previous patch
