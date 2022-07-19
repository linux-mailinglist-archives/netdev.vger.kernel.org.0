Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0345797AF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiGSKav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiGSKat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:30:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFDD3F311
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:30:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wnk13oySOHFwD8VHwVanyUr90rfqiCbVRESncuWLjbcaNBU+Rz2Y3RK7K+WBYE/FlO18m3qg+D7rMjfZOELr1v94Rts4rBYQ+bAteN9DBdIGoIVzLgz7zuIXY7QU1O0juB2l4L94DTIpK/tXkAJYkJJxWzrXfq1VNMsVqokyYN+5hEcnGapiXL34v+c55CH+bI3Qx6ZqK67urCW5oHEmEO2cnvfZ/j2ALJUG9+izsnWRpY+p9QjUILD5Spl2NCzwxd08+GWmCmaoB7CRAfJkee6DkGhxD0XGqXPAw7v2pZ8n6ou5ykyyuTzgOP/h5g0jtLBAbhp0jh0LeaMC6x7NcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWBD25OVqg96PsCn7UWWGRvPmVghcZvulzVm457+z2s=;
 b=RitTgD2RtMbELQ9PQ9iOlLETPYvyI0kY5SCtNWsY/iISvrUQ3KAPO22ykyPpK31uiK8XW+RI1sCFbLi9yVArdYaJZlEauxcXuxEvBst4ApQLnt+nbbq4Vu7C8jwTqes0NWeGp203kzwhx3PxSiWDV+56KFJRDBYTajPx/Okpq78N/ub9xNz5ANnSnOpEou1b7C8bAWvWjkyBJ6vSsOX8F5Gx8fDqpPFRcMJ9FGOy8Vlp6YQG+1LR9KvQhdQ3ayqDXvxo5TBKetsAAKmFLAMf1vc1wdwirN1suBrhXprnLsF6XwV4w9HTrEmoprgeM5y1MDgO2SjVZyGOZABcdyi5TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWBD25OVqg96PsCn7UWWGRvPmVghcZvulzVm457+z2s=;
 b=Gt9ghcXuyPk7qEGZUy3wSTBhxhQMS+SDpe3Qmco43uI9v27mYyaIKU7TFJ/VgSpGvNdNwby+FNjuOpzgVICY5YKbo7tNyf/3zkxFnRHLmyKYlJ/dP5vYMlSws98DdZChcl3Q1ZN2TJGMhwjabcsxhES1HlJ/DJyJ/hmnqgDLO8t3M5AnOou9FX35J2OwJoctjF2qwwPyD05b+D1Cm8kcBBiAkaVsvu5Oni0ubIoaY0Yq5XrfyhMbHN1ctqUpSfObEMQjezHLZzz6c8zh4KCWYzR2bzZFpS7ssucKoAx6m5YTurvcX07Kc5sCn6/SV5SPocBM5fqgPFhOn92rWyJONg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2752.namprd12.prod.outlook.com (2603:10b6:805:78::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 10:30:45 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Tue, 19 Jul 2022
 10:30:45 +0000
Date:   Tue, 19 Jul 2022 13:30:39 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 00/12] mlxsw: Implement dev info and dev
 flash for line cards
Message-ID: <YtaHz4xU0hCZjVmQ@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0220.eurprd08.prod.outlook.com
 (2603:10a6:802:15::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d6afee4-d4d4-460d-44f4-08da6971bd21
X-MS-TrafficTypeDiagnostic: SN6PR12MB2752:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNgUyi0EOE7lrnUL5xv3h6kK4KQu5wDNJSwrYVr5fLXiT/2PvZ0hvdbmZoDah/BWDTC2xfMvE+6x7OUIl67rp/yR9ili/PqKVvzrq3CDM9UQAfyZ6JTJvnkfxs568czYIL5DgpA85DtnevSqtIri5a0/D7bSsOaiykJaHu8oAdR+Vgp0RYektxC4/duKdrhjdAND5WxE5D0GmWxBR1Q+joK4MKrSC0O1wxmmH+vfDhVrRPCs9Xn6PEwyOsjggjil9D9OhZv8BItjD+bTSOGXFRV3Y+sGqBLupG9f570B+WbQDaoDPPSgXJ+gHNrOoyy3Yed5+Scx4uDfSgGStEtffHv0Opr7ehB8OAHzD2zdA/EMKXKeXLE8kkr6jUIN5OO5ItNEojq4HyFeDDtNqU5c91j+nYui20LUZsCXS6Y5jayDvcp8QAUU79MckPBaBrsqvP9VxQIq62ZeQR+VFrKOkY9ZXCNCPyVHC4d0EZFLmZkGURPUci6HfqydRzmFQwJrwD6MzlFD0Y9SmDriHuZDzpC/rvs5K9xbuBwGGxfYWwc99/ecapLrrVWx0cZ1zGN/Gems+MQyuch0lZtCHIt3SbmxFn5+q9ZF7y/yqsoZlQDQkVQv4sRqgNSZjWicY1ss1oJc1SyNabCujrX+hKLLMRT/hFaGrFOtcI30dzIPrxEwsBEhR8ZJfxdddEcAFCiJMLz034ez+iVSfGAq5n8QBB1E+8AulVgK9VRdtIX7slb0cabK0GU3lBv0INoVf5Ra
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(6666004)(6486002)(478600001)(186003)(41300700001)(6506007)(26005)(38100700002)(6512007)(83380400001)(9686003)(6916009)(2906002)(4744005)(8936002)(5660300002)(316002)(86362001)(66476007)(66556008)(33716001)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gjPMclwUyPAXccUh9IlZ6sXnxTWeP2J18PhhBwul+m9mlLzYBwRz6Za0LRN8?=
 =?us-ascii?Q?y7+d2YiMwp2XA6GlmfSyF7ridcx4JzkPRjcjTUNN9JUKZuGBxlaZ2vZq0Dim?=
 =?us-ascii?Q?HSEqJINQ4eo+D+83TBykv67gXgBZLNqRk/tf7QX82y8ISbOTis8pqWu23xRM?=
 =?us-ascii?Q?OLQ66d6A0qHnTJSccGYA4Nm+U2HLUyfZH4QImECVwynkudGrIyVCkhaCzpuS?=
 =?us-ascii?Q?pKeFf8fYuNMOqu5adKFasIBmi8P4RbOrRgL3xCx8WFWaAzHrhyK8D0ESqRon?=
 =?us-ascii?Q?OxWsxWJZiuGj/Cu/CLY/YOTmBdbkrBl5n3dtZMIwry/uOfMrXf1f3Hf4jTvD?=
 =?us-ascii?Q?/G+qEScIejTSdeTrreTprLd8UVUgmM3N8KykBBrvpTAHm/2ffpZfWXKTJPa5?=
 =?us-ascii?Q?aqPbITtmdkpiqGIhZxBaNecpdqKPq/W1cgKvRkHyt19vIyOLjfBNvx+6Qer+?=
 =?us-ascii?Q?s8746NgUxA372F0NAlm3NvC2Kfv7lRB+coXeSPL8sK5b8UuyxbVOegrz5cFM?=
 =?us-ascii?Q?R8Jryl/rYYzlCehulurPDS6x3yTP6k7JtI5/eD67JodM5LXrdGIJz9ayRlh6?=
 =?us-ascii?Q?xuKcO/iWwJqUhKR+wQgNICMFJf9XN9NQLyoqGz8ICyaugLt+2Cqj+DWhq3fC?=
 =?us-ascii?Q?GlLHWvgPiLtfXph6TrTr7u0BMDVkjF+l9rlvNPO9YqzVGK7zyr059TPtcHh3?=
 =?us-ascii?Q?JN17+1o+7eCY9PcUNMx3nV+ZXPAz1szJS/N+wUZnesFsa/0JQq3hlQD5mdFM?=
 =?us-ascii?Q?0r7k3l4zc+jJ2c8y+eM4+xaC1TY0RkGqTU2NCV+jTbgkBERIr2DAV14vcCA/?=
 =?us-ascii?Q?7B5E1Sh7ioeqgDVU5ghOYDkvX9ZI+AC35ayzfJK1RVGzWVSofjM57ZeceX4P?=
 =?us-ascii?Q?m2XGrdbwceeungTNKxonxTkNwGzgWdM3AsYbUCN7Me7Yu90Ezm0dTB+raxrI?=
 =?us-ascii?Q?mBrQcoq/xt1enHavBhXx4baYv0Ix0ozpMurRr3+VlCzkG7j20wwVeGSi2Ccy?=
 =?us-ascii?Q?M+TOPk2K6HqktttrQKxLOUvlKXQbMmWLnFVr7UPCULbVpL+9LwtAqORwwF9Y?=
 =?us-ascii?Q?F7JTu9nZM3fc0Z1hhvYsQRQZtPCy5ov1iZhKPS1rWIqEJ1XY4bygbiWIBzjC?=
 =?us-ascii?Q?CVYz82U2osif/sECGF2ruebhFi51quFUx1rnYNsGK9LuOR0YyMpopTUCEa90?=
 =?us-ascii?Q?5sQTFtukDkr3hbVPFgfnLxoGExP9zZyn4cGQlEJwaOpWcy6Q5r1OGgMRb31X?=
 =?us-ascii?Q?rcn3gg/oCq7+nGIEL57B+ASaflJnYpEKEAO4fod2AtJH3B5JVO3EAXE4ocqC?=
 =?us-ascii?Q?SGS9SJzqdHFvZSz9dsr+ePbyj4KGsHAUryPhXwgYJ5915bEDrl7TUwUuUSmJ?=
 =?us-ascii?Q?h/j2ntuAOEa8Ds3NywZXR/aCe3GZzx0PXRN6tHbWKlw1odyRV+6rs38oXcRj?=
 =?us-ascii?Q?4n3yGG/L/BRMpUfrw8KvypkJJ7Km7fo7CMdxJ+bq8SKtMM7GZtCht29PioPn?=
 =?us-ascii?Q?nQNGb1bUH87E5YZu7LBssfoVlvjgEDfc2tFhJdv0kK/m2kptMhrTIkLhZq1v?=
 =?us-ascii?Q?0x1kLtu1KGiiFIXlO/25heXEUE0O+n6SIo/f0Uev?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6afee4-d4d4-460d-44f4-08da6971bd21
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 10:30:45.3515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGetk2aslpYEbsT/9pfgwQflMiAdAS4Sl1Wl7yrSEG0rSopFIUWjltbUg1ZGNJllT+EMiFZ8SHOZEbtFXaMTLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2752
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:35AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset implements two features:
> 1) "devlink dev info" is exposed for line card (patches 5-9)
> 2) "devlink dev flash" is implemented for line card gearbox
>    flashing (patch 10)
> 
> For every line card, "a nested" auxiliary device is created which
> allows to bind the features mentioned above (patch 3).
> 
> The relationship between line card and its auxiliary dev devlink
> is carried over extra line card netlink attribute (patches 2 and 4).
> 
> The first patch removes devlink_mutex from devlink_register/unregister()
> which eliminates possible deadlock during devlink reload command.

Will review today/tomorrow. In the meantime I have applied it for
testing.
