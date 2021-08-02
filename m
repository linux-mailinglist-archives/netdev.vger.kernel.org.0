Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375923DDF9C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhHBSvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:51:42 -0400
Received: from mail-bn1nam07on2137.outbound.protection.outlook.com ([40.107.212.137]:35294
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhHBSvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 14:51:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6efxr7m00M18m3bdzU/jX0ZevYUi6yM622Mgwy2LEewqFGlpWWzDsL83X3DYi+Td7PEdAtYP6Q7/6uNXwUB7YgEDDti7rxaB0DPYu/dfWQM9QCNXjRzRJ7RNvLduoFVwF15gnnMEN6eiZL1Qc3kCVdmNgkJBnALbqcD28fX2WuKoweutRDXINNwGguJ7l4Z8fMDfKOHhq0R+0JWT2xY5Q93n2IFXmQo2I3TdFCi7yw5B5HeFaAa2CTTVAuUQ7IvwghjZjNG/ClUE3uCGzubhx+J8YK1AiyBOaXZdPb7lzJHOimL7T3/Q2qO1PARuk3kGr2yQEAwIOW/IQPMDy6/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CI9zlDKqjLkq94xNE9OXXOc41++OvMfqbRe/wIPNxM=;
 b=ccCYsOT6wvm2in7l6wL9EOxyn8YVe5H/tPg2c8TrYYTYc7z9Ez91+sJU2Oibszu/O3wdHYbvwPvOKDciQMdsC7eMu4sTsCwfP0zkBcm+E1WckkTxsraDjz8qFHgmCe2FzXvrTMJLgupjF2tsezOJRCDTx2BtOCLdxWqrd6EM01t7vXpYp0Wev+eXvgssYSNuZsOIljFBffBEMhrIcDLpT/0FEwcciHkfDbT+xD5Z9S1vW8B+NfgrGB3vydRnQOPLJy42xoiiMGoLtzXIHQf7Pbl10jiQqFqJVtsP5OtotOWAtCb3Da8Vs7CqtvJ8u2I8ekAHDptlYNEQjFcvx52lKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CI9zlDKqjLkq94xNE9OXXOc41++OvMfqbRe/wIPNxM=;
 b=bthCr1s1SO6ahnkU9vccdhpdVMfi+rIwBXk0ccZWwyedYokl6zQdNsR3XKGtgoobYsalDNcH/cq4aA3ymFDn/2AjzIEt2sJDqhx+7NrHSQdkeWt1cOCjZjpqCA6ggrXFkpbKadPynN5bkRI1u4P1MRlTMkidxVhnBG7mjAu3Pag=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4796.namprd13.prod.outlook.com (2603:10b6:510:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.14; Mon, 2 Aug
 2021 18:51:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Mon, 2 Aug 2021
 18:51:27 +0000
Date:   Mon, 2 Aug 2021 20:51:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        oss-drivers@corigine.com
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
Message-ID: <20210802185109.GA16761@corigine.com>
References: <20210802144813.1152762-1-arnd@kernel.org>
 <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 18:51:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a603cc02-0367-4b07-47dd-08d955e688c1
X-MS-TrafficTypeDiagnostic: PH0PR13MB4796:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4796536C6C81603265E986CCE8EF9@PH0PR13MB4796.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9FNFSmr5owuoOxlDG9h2UbmQR5jrpKAuQXasMOMGFKZmMgNXnOh+TnmDT+eNRS/Fze05dHOHD5xSzTNhkmT8L42C3ijyay7xfHnJ0lVukzKPhPypbr163+fQpvoc4bz6uSuni6P3/guPbj+qQwFOr2/9MsQkoRXkkv1vzgPxLQrGnsV8wY3b+8Htu0oxD5hyFmKYwFiT5QpkbTrWk/Hz1QEs/mB3/xoqCjGJYKC3Nm52ZWchAhWunaq/Drxe7zncpQG/pf/tReRGSDMNEQFWRiCQPZTaGdMSXbnhz67CDBWW65usWVbEqjDhwm/03qiZUtTktkhWXnmzDfelh/qceAxD0zTVO932L2UMfnodW5z95yc+iJvChChSsYiisxJOP+gUsosSJUvURCCPbHbCOysTNvJImQ8yjyHzgx4g6BgVduJ8IsZZTOKGYTxkLfXbkFv2TbrFgAP/OaPfNpoYOTp4z0yusuNT8i1rX7tPLqEJ4C/fjeFxlkUuCmDPMgTtYaPyU+sEaWxsHAkwX/IAWYDlxzxC4P9rS2Bq+2kcVOXA7ga20YguZCMVRY1ERDZydk5EioY0Nqi+bYHfYSPFQFoNYvXLkYLz4WlydM1eA4crOvriP3IZq3iKivlteisKFuEUIx5u2x95AztY4cZOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39830400003)(366004)(86362001)(8936002)(186003)(53546011)(66946007)(6916009)(8676002)(52116002)(7696005)(7416002)(38100700002)(1076003)(33656002)(36756003)(66476007)(83380400001)(316002)(107886003)(6666004)(66556008)(44832011)(54906003)(508600001)(2616005)(5660300002)(2906002)(8886007)(4326008)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcBm3E8oJnI7bumLvI/CMRatHsbbxJSkiviNQ80W3w22xObSPh/6xP6j1uI3?=
 =?us-ascii?Q?HK/XwMB6Fx9dxFO0vkhnYqdQLL24//ROYJhhcgkKIjZchO5bWVeStufVjyEY?=
 =?us-ascii?Q?Rm6yXNI3qoQvKc/gv7P6PDWgoLuTB0buA2LXdusjoVNPQ2FfedDta3s/t6zs?=
 =?us-ascii?Q?Vsi2tqKpcnZVc6iSHLh/td6DGfM2T4enVN7INLSG+9WG/rK1DMd85dLzfFJM?=
 =?us-ascii?Q?DjmojIJJELOPOnoum+w1gzgGxjBZtfXqTebB9KC6ojD++DhPEefCdPwnYv4n?=
 =?us-ascii?Q?L45m8UKQMoNH3UJr7gaVdmu/9M4Nj80fgvgOHsv6Nd9ABBdd8IFFp+nxYIi2?=
 =?us-ascii?Q?o5355B4HECRIOmt4y8jOQ4lXdxd7XPzF2Ur3yDTmyslLnepZoE5avEOUg0v0?=
 =?us-ascii?Q?FvMDSwU8dVTGXp0ogQDj3EOdcuOn1/i1UEgcqGgb2scu6fDkICSCfe8sOUzm?=
 =?us-ascii?Q?Gu3mS7zyfZroHMlrnzYDddoKStoCHjktorA8Vr1QzHDT6o3V/9amtRg7BeGh?=
 =?us-ascii?Q?WxduaLTuMoXVIfVJ1EEje25vyP3LtY/IyjnuVo0cYZVUO5ICXgZdFiUMEgb3?=
 =?us-ascii?Q?v8rslxY0Oqdcn9ZMVi25WIGjENOH5vs/6zZE35hCkJZCV3DrrtLOBJXLAR4J?=
 =?us-ascii?Q?Q0/wnm2F6cxUDK2Mifgq/gZYYEvpV4rScNOz82ou/uCYi5vrweKSE1uF6mhZ?=
 =?us-ascii?Q?Ionvreg2bj/RPNKqJG7G9YIrsUJsukE01+j4nvDcnZy2AUjIFZnmkI5JiAqJ?=
 =?us-ascii?Q?aXNfLol/IRrflXL/oHdVU8QR8AC6pJmOLX2y8lqPt/eQEdjOgbpw1hf33pkR?=
 =?us-ascii?Q?ebSCgUwWN628ti+3L3n8hVpQHTIMYYPLQPpLkwBOCZWIv2Dse4N5zojmpFb0?=
 =?us-ascii?Q?tm1gqUJXp82kjNn2qJymsZPHCESKkpy/QcsINpBCG/mvgX8J4EIkXO1K7oe5?=
 =?us-ascii?Q?PFnecYkXm9bJfdSCQht4fwLtWnYGSJ4nmKQILLc7yDUHGqNmedsOj67n3t9S?=
 =?us-ascii?Q?KPxZHfqr2ZR7U96KDILbptP8RvdeTS2wI2X+icxJop4t6zQOSn3vuexUJxPo?=
 =?us-ascii?Q?2TQ7BOdmtUYMwCw5NKKL9RZGxkT1E1NBhhkrYZINRJDDQnPZQkvC24gV06i9?=
 =?us-ascii?Q?YOfVTuhzigA3wcIarUMz9cdMmtMcCH9V4ubYL/LcMB1XxcZ5j3LZ0Vv/7UkX?=
 =?us-ascii?Q?w3e2V3L8aUVjntanQjjk6iqsnY98q/YxOtVgTa4w2ieWF1Desoyh3XFC2gS+?=
 =?us-ascii?Q?F9wMbHJNhzvunrcCPP+5kuZHQ8RN6hSXMVtUrZ9cJtuRd5mmLboCbivNFURa?=
 =?us-ascii?Q?/ondbc8E87nXKA83m42PrzC+p6WYCztAOBMDikf4pUwTn9M0u+jelk25+Ran?=
 =?us-ascii?Q?fNYob5f4y7KDADaT8Lm+zjW/0esZ?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a603cc02-0367-4b07-47dd-08d955e688c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 18:51:27.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJLlGwd4zDntpMdarECOHtodkgXSnXCoGXaTwMmwRohjJMC9Wef6qRoYboWNC3rWQiBWwoy2CIvRHAl5cegF0X6dYvDecqhK+pMTyOMPk6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:29:25PM +0200, Arnd Bergmann wrote:
> On Mon, Aug 2, 2021 at 6:23 PM Simon Horman <simon.horman@corigine.com> wrote:
> > On Mon, Aug 02, 2021 at 04:47:28PM +0200, Arnd Bergmann wrote:
> > > ---
> > > This version seems to pass my randconfig builds for the moment,
> > > but that doesn't mean it's correct either. Please have a closer
> > > look before this gets applied.
> 
> Thank you for taking a look, it seems I have done a particularly bad
> job rebasing
> the patch on top of the previous fix, leaving only the wrong bits ;-)

:)

...

> > > diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> > > index b82758d5beed..a298d19e8383 100644
> > > --- a/drivers/net/ethernet/netronome/Kconfig
> > > +++ b/drivers/net/ethernet/netronome/Kconfig
> > > @@ -21,6 +21,7 @@ config NFP
> > >       depends on PCI && PCI_MSI
> > >       depends on VXLAN || VXLAN=n
> > >       depends on TLS && TLS_DEVICE || TLS_DEVICE=n
> > > +     depends on NET_MAY_USE_SWITCHDEV
> > >       select NET_DEVLINK
> > >       select CRC32
> > >       help
> >
> > This seems wrong, the NFP driver doesn't call
> > switchdev_bridge_port_offload()
> 
> Ah right, I actually noticed that earlier and then forgot to remove that hunk.
> 
> Also: is this actually intended or should the driver call
> switchdev_bridge_port_offload() like the other switchdev drivers do?

The NFP driver doesn't implement /use this part of the switchdev API.
It is intentional given the current scope of features implemented.

> > > diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> > > index 07192613256e..a73c6c236b25 100644
> > > --- a/drivers/net/ethernet/ti/Kconfig
> > > +++ b/drivers/net/ethernet/ti/Kconfig
> > > @@ -93,6 +93,7 @@ config TI_CPTS
> > >  config TI_K3_AM65_CPSW_NUSS
> > >       tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
> > >       depends on OF && TI_K3_UDMA_GLUE_LAYER
> > > +     depends on NET_MAY_USE_SWITCHDEV
> > >       select NET_DEVLINK
> > >       select TI_DAVINCI_MDIO
> > >       imply PHY_TI_GMII_SEL
> >
> > I believe this has already been addressed by the following patch in net
> >
> > b0e81817629a ("net: build all switchdev drivers as modules when the bridge is a module")
> 
> I think the fix was wrong here, and that hunk should be reverted.
> The dependency was added to a bool option, where it does not have
> the intended effect.
> 
> I think this is the only remaining thing needed from my patch, so
> the NET_MAY_USE_SWITCHDEV option is not needed either,
> and it could be written as:
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 07192613256e..e49006a96d49 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -93,6 +93,7 @@ config TI_CPTS
>  config TI_K3_AM65_CPSW_NUSS
>         tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
>         depends on OF && TI_K3_UDMA_GLUE_LAYER
> +       depends on (BRIDGE && NET_SWITCHDEV) || BRIDGE=n || NET_SWITCHDEV=n
>         select NET_DEVLINK
>         select TI_DAVINCI_MDIO
>         imply PHY_TI_GMII_SEL
> @@ -110,7 +111,6 @@ config TI_K3_AM65_CPSW_NUSS
>  config TI_K3_AM65_CPSW_SWITCHDEV
>         bool "TI K3 AM654x/J721E CPSW Switch mode support"
>         depends on TI_K3_AM65_CPSW_NUSS
> -       depends on BRIDGE || BRIDGE=n
>         depends on NET_SWITCHDEV
>         help
>          This enables switchdev support for TI K3 CPSWxG Ethernet
> 
> If this looks correct to you, I can submit it as a standalone patch.

Is there a conflict between your proposed change and the
presence of "depends on NET_SWITCHDEV" ?

BTW, I'm not sure I know how to compile TI_K3_AM65_CPSW_NUSS.
So I'm perhaps not the best arbiter of correctness here.
