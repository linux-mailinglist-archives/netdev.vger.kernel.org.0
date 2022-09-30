Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714BE5F0E6B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiI3PEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiI3PEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:04:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A4F1E72F;
        Fri, 30 Sep 2022 08:04:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgc3uUdee0sGcnzFP04wj0MqfbncwztQJ88UVbGWYROWUWcG/59crSdGIzbAglolqX6JgApgJnT+Vc8VUOFUaYhNFJRfYILI0NTEIhfKuSJqoJt/1kT+lmd9CaBunfzuZhJyJyXSiEoCahHuKmScMScPN/HgQEnZgQsigNq6VsWJTfiSFgNoNDAXFd2qdedsBucv/SUScfHry8vKc1Itd8P8vaLS1U1TXoQh4cJgG+1sg9tZV/mJUklzfbmOWB9oqP5vLmjO1+H4+A5YwHATUWGZtaJxUeKqTPC32rsWh54MLfW34F1tF9RJGFTOpg6bYlCzVsulrXUDBp2GMDT67Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LertkcbjgdOGHDxrwbfYgpUhXa4RjIH8m2oYBaX8Ygw=;
 b=iPmUGma7jhzwc4thCXTLcFIAVi1DlymuXqpsXR8QvC8/iHKvGsTEGxLEb8W51F7uFO5oAsBeInWEbZmXrCG6ZsUX11sjKMozKRGvAeWjZITbNHVQFECCqJtz3CHtDR5vjv51U1hX4/crS2IfCzdTkQ3J0OrhObrTQV07B3fSwEYcwUHMD20XUa+vXapyr5+unMNNhdxw7BLXIr2Y+zYq1waRcbJLAlw7swRPPdEZHFqw412c0FdXl8hc6Lalmk/GTM1sUR4Z6yd92RUNCeTw9AjdK3Jre174Ife2YnCQy3CFha3k5SiRsCN3wjz8IEKvP9TngyQJnBevmJ3IQZw/DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LertkcbjgdOGHDxrwbfYgpUhXa4RjIH8m2oYBaX8Ygw=;
 b=mO08Ba89gdIeN0WF2qF3YlumgEvG+U+KjrR/8Qqr1pXfDW/r3CSarL8cAv78epwVKuQ8rMbOLDaQGKeUj9RfIO3ROEu2YH2spdZqnWPaCF3jCcuYGTL1tEnqyIenCShdeF0hwSSMvCaAuirZPeMBbSMZOz8by4Px9k4PRXyAfTt+56+RBjy+lqM8njVXQQkqLvW3N4/5na2CMA6SbB6ZOANgQILbwXREKFtYhQsG3mmSiYdBrbuFB8YzuUO+YB0dL+/Q2NAtsyaBYMXZ9+wWJy3imGS8y1+8uh1ENSl4oGtTo+6YOTMmH5bLjdFbqv+34AehCjR0h/hgjtM3u9lGkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN0PR12MB5763.namprd12.prod.outlook.com (2603:10b6:208:376::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Fri, 30 Sep
 2022 15:04:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.017; Fri, 30 Sep 2022
 15:04:18 +0000
Date:   Fri, 30 Sep 2022 18:04:12 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@kapio-technology.com, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/9] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <YzcFbH5lX3l1K8Fu@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220929091036.3812327f@kernel.org>
 <12587604af1ed79be4d3a1607987483a@kapio-technology.com>
 <20220929112744.27cc969b@kernel.org>
 <ab488e3d1b9d456ae96cfd84b724d939@kapio-technology.com>
 <Yzb3oNGNtq4GCS3M@shredder>
 <20220930075204.608b6351@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930075204.608b6351@kernel.org>
X-ClientProxiedBy: VI1PR04CA0111.eurprd04.prod.outlook.com
 (2603:10a6:803:64::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN0PR12MB5763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a3af579-ed36-4c5f-07ad-08daa2f50c34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdHHYKgA5zUzQicURZbQNcODLvQGgSS6HuJ2pH9Zodaw7kV/rARwHt4cx12Wey4KVfHksVb2Q+DmFJJizGBNZVxKuJmyioWaGna0iHh11pl8gHIkggssmMNhtoLjE/cA7nqLdMA8WdsJKMJuWzlHfCNmj2ZF2zcaMXJ0XYmFvwfbqI9z2lHHmp8hk4wKWzrOQSBv4zar64nT8O7AJGIB76zM4EVpZcPK/4aqw4ugyqkoTejBrQz7QDzuyWn69rZUdBd4O2J3pstWfaaZ3F3FO+0PlGTLU6xgWmgKvPyFvIb0wkQu+yYkZH8wFKI1j9bTQY9sbc1M4cM8TF8qlXWw9v8Ak7pk9uVhQyoQI1pKSyHDxtfpnov2T6PNP3yIeqiV13lsVS71Wx6a/eAkDfep6MH2HiN6N2TTjm2Tdia0zVKGFHSaLaStS6i/srlfjEbMBx4U0wxlVd+ncb/A5tTOz+hz8Trs82MuxJfVjqmFEPOq0P2gBzs3/6t8OHmuw0vU6oyLvaHnJTqgkP1dj5+8nY4ct10ADO4h/7pIHouArzzW0lUrAC18YAkP2ECIX+RM7jxqgdcjrpX/55y5/gqWDPTmwCG+7vpQ9jhVa01sC8ieLy2peCbT98TzBrBjN/hczprhtKlPlOlG6qwFeBkR4cWlDRsGdLLu7I9uTOsNC1Et66kg1V+jHT6JJGja79oe/ZttMFJugcw330B2xWroLnyazEmk78OGq4B9S1OYpOMHI9HfQLzrGqYTlp09nkSVj6GNdxl9VigrLFMZlN6WxRYjFFwuin5MG5h8/Kq5jFc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(8936002)(54906003)(6916009)(66556008)(8676002)(6666004)(4326008)(5660300002)(66476007)(66946007)(86362001)(7406005)(966005)(6486002)(478600001)(33716001)(38100700002)(41300700001)(2906002)(9686003)(6506007)(6512007)(4744005)(26005)(316002)(7416002)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z4ANIwmG41vLULiSsP9Agh7vK7FXPoKtKtaHCWP8zwaWtRVx3JSJMPR9VXA7?=
 =?us-ascii?Q?gFTJ+v/Sozb9lcw1GxVWawSE5REdb2fEEVVrs7JYmgX2GmYqSYuyg1O+9G0N?=
 =?us-ascii?Q?W6cob/uRin6f8OdTe6XPB3vdhbSoKVmcJIVmQrYpCPaCrSJSa2ntW1TmQLb9?=
 =?us-ascii?Q?pOV6YUD+8eKnBSZfirrkFmCg/Nz4rqKydfviHMUTGHD8zT9geBjTnnDDnIr/?=
 =?us-ascii?Q?cvTlh/KTsPB3mUqo4APc9P8t/jZ/Hjo5b879NJ1W+0FHvLsNwyuBrYjobeZk?=
 =?us-ascii?Q?TCaQCmDyA4lceRbhMAZ18Uf/MdId1qAL3r0WnrsfqUJuErCB4LK3L/tzllhW?=
 =?us-ascii?Q?8JrxEWgxDsf5u3kBVE2ZIGkMdECsZh5vbywdo7g4bW8Y2539KTDqIxpiLWki?=
 =?us-ascii?Q?p4XykovNQyxkA+wFIDUlduTiIMKLfKNSe9XGBIbS/O7XtnxY/SP9nk6d3N+j?=
 =?us-ascii?Q?Vp5+iklBdLB4K7kO3Qzaoh/SP8RyaHu3hEy6rnGL00wOfy6/6zbYuY7rJmfg?=
 =?us-ascii?Q?iZ+2jZEGUHqPiKKlOLjxZY1404IPE9VI0qVZwBX0Ha/Zrsddb5osOg33VFtc?=
 =?us-ascii?Q?f6vXs8V/axq6q6Gq92bjmSXwhmYZI/t3eRLiEOPP3iMbmbSAAySnisuD9asp?=
 =?us-ascii?Q?e3l27z9G2QuHFqj2z7uoQIEltfMZqdd7PM4G2u+mYWkZ9Ui/ByNm9t6rrm1g?=
 =?us-ascii?Q?Yw7QGSYvWPy6qx+MKdUFES62FMNyMrs6SGQBiHNv8EfaB1yhUgpZCWIjASJz?=
 =?us-ascii?Q?QlKlGWKch8fKwApb72ICrA0CFAIEzebq+Ygs72jo7P+ZALCeTi08udaGI5Lf?=
 =?us-ascii?Q?33m8x3kHfO41KYErkmJNzCvKBa9rkSq8c2WZI3I9lpqvxytUxAKwuIsn581H?=
 =?us-ascii?Q?w3tNgivtDGy43DhG1wcb5XKEqbPDbkgw145rqRmP7sJfkUMVeQRRVgb59cmx?=
 =?us-ascii?Q?yKOQ5WuHIXmkemZN6vrgPr7juVYGzJF4CCEymKSfLZcxn/VeZNde4vj9VAzC?=
 =?us-ascii?Q?oEaf9wbWAjK35XZ+Q72FSAgohGhJzo6MuTirZHEqBy0oMittyqz1cG1ZFuYm?=
 =?us-ascii?Q?0beGLpQCMMdhsikcSIW1ZRpgX+QeUSxDGKxkDIRBfWqGUgOglY6RUDcEbQyR?=
 =?us-ascii?Q?Wwb7G0j09GfgUbJHKDw5IE0GozgqTsARo5QCx81jZoNq4rID8xrP/+tkoOlO?=
 =?us-ascii?Q?9g+3zqcgpNHBLJ/krduE9wzb8ZGCE+Ic/yFr+iVzeOIV84YNySuPSaYHUDkN?=
 =?us-ascii?Q?8jdiHcfn8m5fj5LHRpS5UcZQKZPYRYMqaecPMLAdM6dWSny2SpR9PGlbHVwO?=
 =?us-ascii?Q?uPyqirOa4AZtFFgnMS16y2Z/y8qYlxFa5gfVv2vMSHqA/2eiTN/YWFmQlu/i?=
 =?us-ascii?Q?qHCt1RZp9LeVvU1RScLnvvsdKCaeL0mkjxpDTDruUfLQYnOuSD3+Tweh17VI?=
 =?us-ascii?Q?yxpROaDV0/mBgMgj7rNukqjeaemTJ/bWdOXQA/nGuW94N8406pMDW0wefuAf?=
 =?us-ascii?Q?ZMIUeqwK7szvxYXfzVCgIX0zTMoBgJCj+TcXsXNh+qw8m9HB5DfKRDLgNM5G?=
 =?us-ascii?Q?/0i/LBp0zPSSmGWrignNtTQHbsyPXjjIX9Ug4RX9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a3af579-ed36-4c5f-07ad-08daa2f50c34
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 15:04:18.3488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGEjAC6q929K4l0nDmOdNlvTAInsSOdId7NqLSLr4tl7atwegA6a09w0NUtMSV43SAr3NZeD4GT5vU506VmtZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5763
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 07:52:04AM -0700, Jakub Kicinski wrote:
> On Fri, 30 Sep 2022 17:05:20 +0300 Ido Schimmel wrote:
> > You can see build issues on patchwork:
> 
> Overall a helpful response, but that part you got wrong.
> 
> Do not point people to patchwork checks, please. It will only encourage
> people to post stuff they haven't build tested themselves.
> 
> It's documented:
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them

Did you read my reply? I specifically included this link so that you
won't tell me I'm encouraging people to build test their patches by
posting to netdev.
