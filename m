Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABB05ED82F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiI1Is2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiI1IsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:48:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AAFAD98F;
        Wed, 28 Sep 2022 01:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbJu3zpcCgzQ8L/yes8MedsXP8p0Q73YYJBMu56c2TtuoNLroBCbsmRYLLAnFRzV/5eKMlj7aMicVauztSo9tiHeUcSc5NC84iRrnns6wb5a+08BS0/VR/e67dFooTrQDgHj6vZWwQYNIJyNY5KAqMGCImpNl3nrhVmcaVtZanHk6Fak0dKGeAxtYrx6X1XFd/9lzFVavVWU3QOi6aQx7DQ+Vy8RQpfwRM8RU1L4eeWS5h9VijSR2SiXxO1SHytwR4s3NJr3gl8vrbBgqDnD+iQ1fX4zt5zJgjvMZtmSzMTjjM1SG6RH3P8WUWfSLGljJzBb/ErBoIWv9v35TOWdsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RmojUwGvuBPC2+8KcDSWClnwjj6lQdxfL7qXg2y2ooI=;
 b=iqZwhchCNXs6DvWFosUxZjOMt1WxwX8HMEDBmCw0c26AQ3Z64FzuJ+dtjBJ1T3+WLV94Lb6F8/XNiu9ECKaUuCUXfpqUTYhcbRLfm4J/qVoUojQV+g/mFI/hAZA/Yfm3M70Wha90YhDRgfvIjFkA5ggsxQEj7/z191R4MDMJUudz8mtCR49PwJ5gZENsOmPYROxmolGRUq29VaGZbm17yLt7l5GADP6JCXVaz+Ky+z0ormf/HVxIWOsuns+XJqJXzNUCPEtzGF/pq2ONRr9WhwVMwoYZq4kZ+lIX96RYtU0JLxbaqwSSHUdUidWGnv8HgvWRz/FoKKQSc6uvyrShUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RmojUwGvuBPC2+8KcDSWClnwjj6lQdxfL7qXg2y2ooI=;
 b=T4gGqb3F1OLoUxY8FM8Elw8glVtmg+LcRgWJo4xS40DmiOD3s10o9eh2Qf1uP3B/T0tymsVA1Za2Sw+2PTqJ6Tmou2G8R94prKLEdDgKuXB0f3kwJJxMJITLidNyw+56+10K/pixROrELd7n2TS4/Bd8c24RIFIgmkcsHseTOoz1iQsZTe7Ca6XN0onY98vQQ1zIM/F6vrSALD84GklzBakTRQh0+D9gQTcABhjCH1CxLKtIvqNTzTLmMNIpsYwiREYmznzZoO4WgXtWsVbjjNA+EH9oqp6Xbh70LOMaJkw1FAtcynhS41V5BbZ/Vbp+enfK+fynU7eC/jsR/DD3IA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6021.namprd12.prod.outlook.com (2603:10b6:8:87::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Wed, 28 Sep 2022 08:46:35 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 08:46:35 +0000
Date:   Wed, 28 Sep 2022 11:46:28 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YzQJ5MRSL/ShRSgP@shredder>
References: <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
 <20220911001346.qno33l47i6nvgiwy@skbuf>
 <15ee472a68beca4a151118179da5e663@kapio-technology.com>
 <Yx73FOpN5uhPQhFl@shredder>
 <086704ce7f323cc1b3cca78670b42095@kapio-technology.com>
 <Yyq6BnUfctLeerqE@shredder>
 <7a4549d645f9bbbf41e814f087eb07d1@kapio-technology.com>
 <YzPwwuCe0HkJpkQe@shredder>
 <0c6b93c828d9b52346ddb3d445446734@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c6b93c828d9b52346ddb3d445446734@kapio-technology.com>
X-ClientProxiedBy: VI1PR08CA0095.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: f00b164b-1fa6-447d-95dc-08daa12df32e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbLB7su9N8hiNxrgARxdmpq9xuj6oyOWpWQwSjLwQm21iyQj0Zq+yFuHCSX+xdOTfl8P5bMbsvi/3Gq1fnpBYc1dBOk9DWpSrygphGltrYvrqE1HyHVqM7ksEkvEeUydm/tiPk5Xj0DRv71JrCsgmHSjWwKwcMfkor8D63jxaClPn/PXyF2qfqche5dDiUHHhKIh7VBSvrmp9XIhTQedp962P3EfzdEEMY7MIoGXLX2EIp/6X5GrCm6HIayBM9AT5wuzm4yNQX9YVLs3LTEebFPcU5MAt06h16dXGbI6q4TOZIdofjh5XNUUe1wDjRal4Zk151l45iDl6/sYpvEQ1jl0VzHvMYQGoPqMPAi+ic8AIL2Pzsn7mTFWwKXnF/+G8BRqpSs3lIwANaJRvwcxH+F1bgtM+Vmz/r5NtVgpatWzS8rp6XZh01/kDpBS4PguMhT7Qo3cAL7WgP6KZC9wjS4Kksw42vhIOdy521JVNYLtn1AHNaUQhBGkKUb+VN/mv1IKKn1Y/9s8QbbbdZtpI9BG+e5Gy3JHq9YkzVeJ8wLgehYnbGJakKrJyvsuFkWanIesY/wPJ7QvLBz1ynwJ3T2KHsNrtXHM7Hz8BcNSHlSczOW+yCSiROq/MDngpW7789/x+NVuqbM6V4tD4QSV6YHrjAeGA41tWO4/XvtZaiFpp0960i2OBH9rHiWZ4AsmGagXwKK7H+0yElogIpontP0yc+LQ0K+bX9zU3Gwj/oLcx2ZnmtWm8WceFf0vpqKoikshF3qmyIM1Gpo5JvRSKm3vcn/S0mgaLfWG8kKYEhQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(54906003)(966005)(6916009)(316002)(6486002)(478600001)(41300700001)(66556008)(66946007)(8676002)(4326008)(66476007)(6666004)(6506007)(53546011)(7406005)(26005)(6512007)(9686003)(7416002)(5660300002)(2906002)(8936002)(186003)(33716001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YfrkhFCOE877aDZIHsyF2fTrqTkTQhEnb093Hv6wIVpktPw9p1io1bCmScZW?=
 =?us-ascii?Q?MdbqyM7rjF7IwGpjd2qGMYsjUPBpTAs5uR1b0UMeo3iypJ56jL9uRE01Dnpn?=
 =?us-ascii?Q?He49ipv3UoOmzg9aBxbBMZ4VHqA+Bbsue70fRWtj0T09BD+i7me52qL53FvA?=
 =?us-ascii?Q?v4m3kKB2g685HQuMoHADL9DgCpyvhXzhi+BjbKf6RAumGEO97WQvJQRVmlVZ?=
 =?us-ascii?Q?EEX07UQWDQbJV/+zZb5oZ+UiGpL7RT6OoQy6Gfszs4ilwe3J8eJXyKWhNGx3?=
 =?us-ascii?Q?m93gQrLYGGm8mFWmgE4NfFKF4loi1dmvUcgqEhefUgcIHsYRZo3lOIBlpNr+?=
 =?us-ascii?Q?oxF4i3FsVXNZ7wN4J/Y1VakYEG4l1PxgN4+koVVcDOeVG9VDfYkkX8CF56DH?=
 =?us-ascii?Q?HS4GRsEIxlZKvLZ0PEG7r7jPQSf4n2d+JJP59Hdb2r0ybUWwZUVZyD0DM7Oq?=
 =?us-ascii?Q?JVB/Y/03/FbOKBpdbWBtFGmeyJvljwrunZ6h6BnTOswtqISC+VlMLRc5iI0R?=
 =?us-ascii?Q?RMJrsEmvwtpknFGvKKuhWMeTKDb2kO0Cp9hzsMP1xikNsUpb7ob7PCduSm2l?=
 =?us-ascii?Q?z9O/Sp6ejHhUolrv+Nv4kCrvPyPGhheNCguEjox/OL7+FdMkbHtDAhHpZQrI?=
 =?us-ascii?Q?eRoNmwekmb9rQ10a25Zwxed7fKXrxmSRpzwlDanZH0hOf3c1RMd5tKMm/3t5?=
 =?us-ascii?Q?/KGr1hDo01zeMdBL2RspaE+94GGKZZafYK8P7k+hFPG3RNMHtamolBzNnDCM?=
 =?us-ascii?Q?FdQjxP0woK9f8Y9N9/WhNLlHoW/Ig7SIYQjL265ShbLLPAuw6UIMN1diVVxb?=
 =?us-ascii?Q?CpyROQuIb6dlK+/C11v41S49UhEdH5HisbM2DvEUDZyfVOs/E5mcTOVBKdvo?=
 =?us-ascii?Q?yglYoSI5zEGw8lvrJ5zo7O6BXrS2a2kLhrrO4vRadzHlElWkMfKKJbakvfxi?=
 =?us-ascii?Q?dWMf0MkyLlvIUIhrIIeXF7lcuUHh0aDk8mIclGYMkNhWYSRoYxW0L8kZL95Y?=
 =?us-ascii?Q?ufNLBita+5hpoP33JBERRTnuxQv4ZbcsAjMDNIyCRPKVjQRKKpiqVLt4HCkA?=
 =?us-ascii?Q?DIe0zG1YcssmeebpN5icXUBsszmmzXYCHddplyYk47IHbm3nRJLgoCKx2xec?=
 =?us-ascii?Q?rUMm2HQeKQLkb9jXNI2vmDGbCimMtxhsoZD4oNhxSs12edBUmqWFP89UL7JQ?=
 =?us-ascii?Q?D2zmfP5kuQLsJmCNc0CRwubp1lH4VJ4Ep9ZCNSdalynSIskuh1qGCtIC0iwk?=
 =?us-ascii?Q?Pxy5pQxITXiNmumvHr4M/QklOxK1xL67W4hK9KJUr7Mt8hDIFw0eXkMp8py6?=
 =?us-ascii?Q?+T9db7DNEFGLl6lB8i2w1WUQJwm8+SQNC0Tiikry6fOmlarlSsv8bqTmYRUz?=
 =?us-ascii?Q?R/1m4XSmSgs5EMkXgv7BjEkvPdWoA+ren4QOueJ20Ss66JoPdb1q9dtQQZHS?=
 =?us-ascii?Q?SQyTGlgxITfRlLeCaZuEhIIjKAf7Q4gzepWZD0ownDB1sUwAkYBrGohz+nXs?=
 =?us-ascii?Q?M5msCHJJVYc2NQxnBRzxw66d8EhifJCQGu8xChQR/DKlwpDER4/abmi064w4?=
 =?us-ascii?Q?hniuXqKzalwZDT9tL3IiUcCA+GlSPuHvXEImRcaD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f00b164b-1fa6-447d-95dc-08daa12df32e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 08:46:35.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGgdJj3HifIRN8zBTzcsg9XSXP3E58/hzFZ2SZOOwsojNuGZyJu/nNtHcc1dexnmmoE4aHjoyTT56CqtzFu54A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6021
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 09:47:42AM +0200, netdev@kapio-technology.com wrote:
> On 2022-09-28 08:59, Ido Schimmel wrote:
> 
> > Why not found? This works:
> > 
> >  # bridge fdb add 00:11:22:33:44:55 dev br0 self local
> >  $ bridge fdb get 00:11:22:33:44:55 br br0
> 
> With:
>  # bridge fdb replace 00.11.22.33.44.55 dev $swpX static
> 
> fdb_find_rcu() will not find the entry added with 'dev br0' above, and will
> thus add a new entry afaik.

It needs "master" keyword:

 $ bridge fdb get 00:11:22:33:44:55 br br0
 Error: Fdb entry not found.
 # bridge fdb add 00:11:22:33:44:55 dev br0 self local
 $ bridge fdb get 00:11:22:33:44:55 br br0
 00:11:22:33:44:55 dev br0 master br0 permanent
 # bridge fdb replace 00:11:22:33:44:55 dev dummy10 master static
 $ bridge fdb get 00:11:22:33:44:55 br br0
 00:11:22:33:44:55 dev dummy10 master br0 static

"master" means manipulate the FDB of the master device. Therefore, the
replace command manipulates the FDB of br0.

"self" (which is the default [1]) means manipulate the FDB of the device
itself. In case of br0 it means manipulate the FDB of the bridge device.
For physical devices it usually translates to manipulating the unicast
address filter list.

[1] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/bridge/fdb.c#n511
