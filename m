Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE753602447
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJRGXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJRGXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:23:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7966DA572C;
        Mon, 17 Oct 2022 23:23:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj/CFSHBYHnYgw67eFzkIVO5HfLlBJIZPOqmrQmzHz0yOjh6AEWF94R6eeYYTpEECTjgjVboGZt9kPfGniz9Es/DIoqAtydt64mlKZTp2gted67ojcX0v/ZExMDX8IJUBX8f6EWKBJ9wPJg0ZuGRxQSUzACaPQfowQz43T9kmKCZoHS5/4tEwQndLo/V+5sCs/Zsqv0UjGfi2gF2zuxonB7zGKfvaGLw5tVubXXp6Eg5qYkNiCCHAR1VsrFZW094zcHEe3S2nSJcwEmICtz8y/lqZ8LfxokiK1srQAdI/k3hN9erEdc9Q2/Z1GLcVAotFQ1Y5Gp4Bt+QeFQ7Ps4ZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdWROuxypSVzKqXt30Dg9mYcmstGVwU0v4Aih9zJreM=;
 b=EUh0X+HRs8dWVkYlaGJ4tgnVN4z7rYOimupZEHpa1daDJujVuqd+nIvvA3wARWi6J8MOOjaWP4HPsOw6XSmOlKtoZejwl1AhTS5Sv5CcLoaTt5O8DHCDyt4vSN4pEKXZgOF0ZykV9RJrYFa/ZBu4Zd4APSiRnI2wM1ToRp8HJkNTjC5BM42pnJCU5IcN1chuRPrflOj6dl+PUAoFuL1PGeKYCcuK3pozUA/pmokyZw/Vca0pW8msHbNorRCd6Gqn7fF5Rc58vXKPCkE5IurEqbKsKjPsz/SJqR8gV8JlQrHJ4uJGO82qWCik7RBRur1JEe65FQQ+fYganRxKyh+IRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdWROuxypSVzKqXt30Dg9mYcmstGVwU0v4Aih9zJreM=;
 b=tlsZKrLyEF84EI7xtuVfBV/M/NF+PE+qYlqPfSNDOxUDkupyexgiO9jxv9iQLWi7bfG6i3Hh0D/RcSsi/cE4/UFIUSvwK9t9py+xVFFZD1QzRA4uOyweKfTibpeaEHqrZqOA+HCa50CzuxUWCYZCNNgM6MZak3XKyPOw4Tau5eC28fruLo70uR/F1nHvCWOiBIlEEVRSWMbPLwUaanRV6jLwzz6W2xHhwirr7RICIOPYblkBJrOz4TgAJE0eUye1xPnQwsbjRjZ8ytlQGigJe1YH4agxVtZ8syq5JoHgbSXgQhnSK6WuFTZsRzlecFhMCWIgy2Yt7NCe49VKUUlCvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 06:23:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:23:04 +0000
Date:   Tue, 18 Oct 2022 09:22:57 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [PATCH v7 net-next 3/9] net: switchdev: add support for
 offloading of the FDB locked flag
Message-ID: <Y05GQWYu0vM+bx5t@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-4-netdev@kapio-technology.com>
 <Y0gbVoeV/e6wzlbM@shredder>
 <d314ba738b12e28694a955de1301e906@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d314ba738b12e28694a955de1301e906@kapio-technology.com>
X-ClientProxiedBy: VI1PR07CA0299.eurprd07.prod.outlook.com
 (2603:10a6:800:130::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: 55bda53e-f923-4b14-b651-08dab0d13711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emS78V0VJ9ya32iQudwG5VtFwpoPapKgcvluWn6O25TCMPtd7ejdE7DZTXhllbxqDLeUWuVGcQDPDkEuLmqHiIQts2X3TRhAJgfth6Mq/E4aOsZGN0iGCjWEV4ISWY2Ln6ebqNCIZLCZooEkgyGgSD4psO1xzUUxoNood+CIZzq96Mpuo6r6L0Vh3qqacjUDp7z9M57k7/nDwydb5Mb9AeFX/ltHiQp0Ny5IQ+21VPL7Tmw0RCh6iV7r6kpPx/KKTta/TxxOXca9DayOrgqASmDOXpbLwM4Ssz7NpGhFC5/XgXLqLGt9o2H3eAPsO/pkOaelAq72Lavspg+jPdBxtLmF3mDQdPt9wVUu27TiCZ5Bg26L37yu8visx7C1DlST89gfZzggII41fab4Nqw8eIpwCTTjhQd8dT8LMdYn+T7CZ5zL00UFakyoNKTIvQWkBfM6ZYnYraHjdgvULesPglFA1KwXa9Lp8Ks57MbWZ7d3GjWr/xW26+ep9pQHlkbpvtx7QO43sSrQooGT4GcCRyJFcOp/T1K4QHefimw26x/T4GrtLv6ZjL/uboVzIUiY5YqkSaYk286S86I26QIk+1Q1M+J7weeuUZxDhssrzy1lwSat0O2qh6L5a+xiD3JvGa/FZb2Bv68sEG8hsrpb6ItivVvIz4Gp8iO8uHf1jlxLmFvyFFMIg/b4qUIeulEIgKfwrG1oCGZYTkt9I5x3Bm8Uyg909sr2nhgT+F6IHAUVAP3f8Mu92GGtFiVLEeOP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(83380400001)(33716001)(86362001)(38100700002)(6666004)(66946007)(66556008)(316002)(6916009)(54906003)(7416002)(7406005)(5660300002)(8936002)(186003)(66476007)(6486002)(2906002)(4001150100001)(478600001)(6506007)(6512007)(26005)(41300700001)(9686003)(4326008)(53546011)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m43XdljETV1vhc6m6TnnbUL6ZsSkkmioK42u0yyIF7nsglUVMaYSb+8lpGdZ?=
 =?us-ascii?Q?t3BlfnBdmJj2zlnkFroop10PAZTrURzEm7fGvF4bDMJMrBkfTHHIaC/oKR/i?=
 =?us-ascii?Q?ByVZpCXVSJBhj+gey0PC2PLuMCZZODsIWBClFjfw/9yEHlCp9QZOmSd2e+5P?=
 =?us-ascii?Q?oQ9klGFPwUKUogvjotglI/iZpVqLnpLqW9oCp7yrvQEuBSHcSruUOmZ9Kv4e?=
 =?us-ascii?Q?PxASLB4cHLReDwB7Uhk3tWnyfTF85GW9gsQqL9lTAR4crh5ExCzvryfN7h/z?=
 =?us-ascii?Q?0sWe1j/YK1/4GhA1ZNTblpbUVgiD/BTU6TWYOHKUeTGFZpn7MLvz17ef86rz?=
 =?us-ascii?Q?MVFT+bWBFNbBcUJgu+/nbXLPqLlDKsxMiuzd0RZGb/pfvDzqoMAAk+LfB6HJ?=
 =?us-ascii?Q?3NLTrc+GzZLpM3eOWXB3LGZM/loFjzdUW+gz0aSHKaktxsuaL8PFVXUl1LaX?=
 =?us-ascii?Q?tFu4ygru0FQBRUcG69HydTKNOHmAMTyKDbzXzNjCJTwFxVcdGgWiunoIPqFS?=
 =?us-ascii?Q?wdXZlzfnfd/8d+07Ix3iOfwTkvKbDunCun8HMd6SB7nV6kWljoYGuNdlr6F3?=
 =?us-ascii?Q?KX7rUVO9wPnKPkC760f0rLd15iiS7zzg6cm2cfHBHyh4+3M+7YMfYD+A0bmb?=
 =?us-ascii?Q?QNS3kMrpTeETZ2N/Qnf7pTyeIuYOH9wq5sQhksYmMJoouazCg8vbStxbXaX3?=
 =?us-ascii?Q?vGfQkzljF43yGIa6S6soqWA4tMXP+uWoPK3vt9B73tBSlZZ49jgoljo8bwyX?=
 =?us-ascii?Q?yPJ+0//bsdvOfWYLyzA0EpbCb71JWbPS+lFpkDGG6cTpaASiXNx3r7dq5FWr?=
 =?us-ascii?Q?+5uJZ9YAnmT6kjzb1kvuSOpiZymYTVpbNf/1DZbL+6qeATgosLxzuGRqZx3H?=
 =?us-ascii?Q?nuHPRIYFKLX4Ov5G9Ar9nO1XzsxcQgjVt3gAnon2sJ8Wi4lZeEKYuxm4dZ+q?=
 =?us-ascii?Q?Vxnfy++OoQRx8GdTA+RJHQLXkuipWME9dbPFEhdrdbjdDLN7v3PF5hTJQOYd?=
 =?us-ascii?Q?1SyHaIgHwvrErWxapRz1wqREPI6PHsTOUbktROcVJ6kVVcsYAdJh8IVV9fjw?=
 =?us-ascii?Q?8q0HeIzdDv6V/HAreBJC+NBZdmXtbynZqduqZKuXKjDn55I/HTLt1WYFnwPn?=
 =?us-ascii?Q?meVxuU+klLxkNxzkCstgEHZg4mt8WL0HuUOx6HPCvH2K46y0XigHJd3eQYpn?=
 =?us-ascii?Q?Nmx69xfHHt0ZS9wldHjO7VJDt4aBf1X8zmcVF7Ufsp8D/25tVw1CSI2/eagt?=
 =?us-ascii?Q?NjxITjB7kKn3saE70gZdoT0cyPsqK/+64mKkkwLVqbR1BDE48H5/Xc2M/xb1?=
 =?us-ascii?Q?XSIITtmOx8PTl65Pj0Yx2DSC6tNl8gkp7aLMmt7wZw1Jn9TuH+3Zju8siLSL?=
 =?us-ascii?Q?IqOLfmFa8ZkIud3XVLlVXm63RSACtmJw+32nExLqWZdFDbNZZaakSNvLwsud?=
 =?us-ascii?Q?uDK+3xAFe6dPvprdhOrx7ByciKMhw9Rekdv+C6zxw3il9t9pe1Qre/SDtGDd?=
 =?us-ascii?Q?7xPLQnTblfub6Cph/vClDeDuzJ4NxLEH/Se08H8gNfRsQort6tpfEWIjtmv9?=
 =?us-ascii?Q?D01yZpGsBUt6OBVXPTYUVuj8apbVLe3bimO8j/5q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bda53e-f923-4b14-b651-08dab0d13711
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:23:04.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roVqlVWxHIKZzIDi0koUiHVOr3xfe4GOPeUT1aGmWQf5Wmbnjhd8dF+hYgJyjazBP/KAuuIXRZqnNrOYRYo72A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 08:58:57PM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-13 16:06, Ido Schimmel wrote:
> > > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > > index e4a0513816bb..eab32b7a945a 100644
> > > --- a/net/dsa/port.c
> > > +++ b/net/dsa/port.c
> > > @@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct
> > > dsa_port *dp,
> > >  					 struct netlink_ext_ack *extack)
> > >  {
> > >  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> > > -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
> > > +				   BR_BCAST_FLOOD;
> > 
> > Not sure how this is related to the patchset.
> > 
> 
> In general it is needed as a fix because of the way learning with locked
> port is handled in the driver,
> so as with MAB and also locked port in the future needing a non-zero Port
> Association Vector (PAV)
> for refresh etc to work, inheritance of the locked port flag is a bad idea
> (say bug) and shouldn't have
> been in the first place.

If it's a fix, then it needs to be submitted to 'net' tree.
