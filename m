Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651E0476B39
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 08:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhLPHwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 02:52:19 -0500
Received: from mail-zr0che01on2138.outbound.protection.outlook.com ([40.107.24.138]:9057
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231932AbhLPHwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 02:52:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDu1vdMG4D+PWQ5d0wbzxmlOJwSRkmdqi9VW1k0ZOTov5IT1LJlmehwQE0+ZmHhaZwVHh+IjLdVjxk02PBDmGTke83gN/2jDZ6dyPjH5VQIBY1YNi46bbNxETWaXcb9a3+d26FCp3kt8kFZzKfDc2FzkkBEfM9JMoQOSoKi2kgfxunEpzrKYh6qwVPYxcG/KjBgUtBJbyxxMr8RL1uP4zIk2LAEs2NcvLF9mqYwsuSm1yclHqdNeI5bv6qiWHeeo+9PAVNeC1v+xwnz35W5T5pa0a2r8patrr25cJAJrvYt/mcI7fU3kBTAgjGrxG++ezNIgpWupUREEKfs3VL+3dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lKtzqdjUO+0q5kv4KT24dRZUv8gOCaM4DFDScbcinwI=;
 b=blOEM5VKtd9pWOslKWzO6yWV6AGipqvENy4/BIgOGsoJD0zeX+dLh/mMi91AJ+InF1mpIGcKso7XlEJbxtU1uajxjFdl7/W/05cPLv35irkdZ9e1VwwYZ5gEwxpEHf3T0Z2729oKRExf12e790UU+pY6QJxP92Ui9ZN0wSHqweoJis5Wv/he64mHc3bTLjjQhFh+bC0ftGgIfSemOqLQPK9WmLzIzpV6TIygsNfURvvxd/vdSaYsShBVmlYYvdy4agTUWcMN+9XSFdgGTr4RQkfvx64YYveMTyi9iE3KyRieJP3uJnJi9pR8CUPX2k0F1HHMYMxKFKOOxkLfmLBBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lKtzqdjUO+0q5kv4KT24dRZUv8gOCaM4DFDScbcinwI=;
 b=TyBPOMSyfOrYVKTXYIzDbRASQ2ohzSKwDQbahk7CoOxADEpw4junGM4ARp5LJyKYwm+0XMgxXxX/d2dxviRSqmP2N6MTQX4pRR3EJJ7ifid/pluSB/gaaN2FHTq0hY5AhiEOWTMEYjwfDp7JNkYKHEn9HNB+ifTYPeqbFzFO3EQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0379.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:30::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 07:52:16 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 07:52:16 +0000
Date:   Thu, 16 Dec 2021 08:52:16 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211216075216.GA4190@francesco-nb.int.toradex.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1832f4ae-cd9e-4f7b-70ea-08d9c068fae3
X-MS-TrafficTypeDiagnostic: ZR0P278MB0379:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0379FE23DF66D883A0DDD705E2779@ZR0P278MB0379.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hr3Ke3vI2gztl+HSX1OVO1wxNCQiXPx5HxtgaUb/kIpnNJUuoEaFaraERNNwjckzm0NBR0tInEiPU+VTg0LruYtMa6LbUbONKO2/wxhtPc4aMc51x+u5WbPJ+eSvUQfkUVNUNpKpP/i/HyYsbCvOB+v4PBxxPtM1ZQUu4+XG2R1+TCiUXWcGR+ohhP4yFigCn+xnihYbA8hu9Bj7HEtAjTN5JMvdC+zknxeT5nXHCLjYfSLL71FpbDcMS/5IbTqR0PyvTgzULH6qQNh1j7ykLj2/mDEZNb+e7OqO6mrPV6o1Fh7jiaDEXYmHdRe8zIqKbkuNtlPaurZ4L722ofOxfm+QJSQHpiDFTfNS1E5lfhixVPeEZOFf4rHxW4AL9SEBzFWyVmn1D0CeekgvZwCz0bSsh5m0xRiR/lAqP1Of80ArIu7tYjEhQTBRw/xw+TLmmzDwNlp/q85srKPgpNpZm2EI26gZiKZzNEmpMQOa5B9NZEKwTf3AWsSj+k4mipPEZdLr84PGg9aJ2rN3sOW4ybb1LCMby2B8Eg8msgNeBzdBtnu+0VRhnfVmEunPx5+rFRRbAcLZI8o13AFyfoda+RhaTuuvirHSS8D5rHNfOk9vhXUpMTGEMIpU49rP3uNLAbjgAGse/iKNV0cFxZU9y5qxAtZAxZiY8dGc4Z+9gx8+3UzDRNl3wcPwT9QtntyAWNoCj3FvR9wuIc5ljSujsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39850400004)(346002)(186003)(316002)(8936002)(83380400001)(44832011)(1076003)(6506007)(8676002)(6486002)(66556008)(66476007)(66946007)(508600001)(6916009)(5660300002)(4326008)(54906003)(38350700002)(26005)(4744005)(86362001)(38100700002)(2906002)(6512007)(52116002)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OVG5c01/tAI8TqE6zBcaJzLep8i/F+d2qOolgonnyGex83prKTTCqGP8+qyk?=
 =?us-ascii?Q?NQ5lIn+vzaCg2ajc/xbgVTqWZWnecHdz4PGVSpwkrXYCmEaaIOM+EUxos9NG?=
 =?us-ascii?Q?NRkZNl32X9kbBYPzrd5KjmUUJnS0X5K0t9wEtA9kjqkOufCqpvArM3q+vxY1?=
 =?us-ascii?Q?3xPdNLqq5NrAdnC4GWUoZX38isL2XxizyJm+2nnWJKhKRt64zC9pt8TL+bbU?=
 =?us-ascii?Q?9FEBLT7C0hOCmQmmjesGNapLiogv8VW3dXx2JVFF3Gx98qNyGZgpo/VusU0P?=
 =?us-ascii?Q?NEFAsr1po+s1DJU2OALwXgqKSz48KzlcvdLgQCR6S+7us3yj5Lv/LkJdunTG?=
 =?us-ascii?Q?OfZx2Scv2fMoZymd4kwbWiuyMuQdsiqCEw8mXgoAhrk1pCKCk21YyIAY6s+b?=
 =?us-ascii?Q?yj3nmaKuvhVmPaize1QGVuoXGIootkA/T/d9LR85fHZckajpF1HE2ThbM0+T?=
 =?us-ascii?Q?4ldXDJc48glAa3K4/46M1Y4v0O7OgC3aYcFAXvnR1OOXQdCdb1LRn6KnVxx+?=
 =?us-ascii?Q?iFeMs+IjYxhb4LeSB0YtcuTDvFWfR7bJdryaG+18K9iqCUtlfnYv+ogrQtA3?=
 =?us-ascii?Q?qnOIJn7yxg5akCZJ2iD3Nps67b4r2z4le8bdfaF4B3NSVC2wqWF8jrbLC4f+?=
 =?us-ascii?Q?BdVau3f6Y+xnEKH16ge51X3Wo3O2X9BNPICkUlqcMxsOjoBM0X0Bvx5iam7s?=
 =?us-ascii?Q?vkOdd1jyqcjh/IWzCpbsCvHQPGEfiBEhraPD3wc+mefHvo/BJaDWlJ0Ywhwk?=
 =?us-ascii?Q?dOBSh+13jw6Kg+EG9RJFWhaLqmDClB4K2cJLrIayK+2Xb014ZV7p5hRB3sUm?=
 =?us-ascii?Q?lUwHPZJaz9z1iJsnwWfwVzNEHPn4mfT+Yx3SeDcRek0uv9Agc0rIBsevwK2S?=
 =?us-ascii?Q?XuPQ2oiEN3PpIxsahueaU7HxaTrMai9agf3boKfqNrR9DShlWYumtnVYMaSt?=
 =?us-ascii?Q?kqa4grxcTDSp0GcWXdrHiWvdrvBlfT7HAaY5eNJr5zqRgj3Wa0hvwFXwl3mg?=
 =?us-ascii?Q?48ILZ4ld1hzd9gwD5R6wUFIDs3Pez6gUswvS+w8cP+gK5ZzFyhAKoD2onCGh?=
 =?us-ascii?Q?SzJTS7OUSV94c/d1UUpk6Ai2/oXP3LHihgz0DbxDXo4stBaOZK8lYoTehx5Z?=
 =?us-ascii?Q?Pa3SAssPsB0XVl/FKG4syNkNBuaT13noLB58gFmPrynS32iJqcI86g4rFekP?=
 =?us-ascii?Q?/L+Qr1Gd1oFNhBvuX1TTmFZe/jQJzTlI9uvEuhxb6kfBaa3nzc1ll4YWsYY5?=
 =?us-ascii?Q?7bssHEq3kGf9QO9nJTtH358D0e0jk99Yag9QQ6UYao2GkZiOy+F5MGao7R7T?=
 =?us-ascii?Q?L5FXELxDVxcU2wfVLHcl/NIBRUpkm5VnSBjqmUKo+K0FTbnkGI5TexVVFybr?=
 =?us-ascii?Q?t1DShKJRNRu7hMtHqHM7xWfZrtHFAJrL6Aq0Pb4h0YD/JMJyLpr6NAuTtjM9?=
 =?us-ascii?Q?HiumIlEMex9TBx1sX8iiomei17dgJf9JWEOLrYbbSwm49X0y76HLeKe5DXBU?=
 =?us-ascii?Q?qAxTpuRcyDueNPdIMUt8m8FXkVoX46Goww/J0na5M2t/0l4jI/IQHtpQQf66?=
 =?us-ascii?Q?ZJtxfMNkVBuJaGHLhY8A2k+VONo0QkoU7HaQNADXIWcdzbJidC2WSfL8/DE7?=
 =?us-ascii?Q?gDV9iWKB/Se0tFy1BVfHPYUYjMt5ZSNzzYur1pSBGmqiJGNbyG8pDy1ldD5s?=
 =?us-ascii?Q?lwOum4o+or1oWax1ORze41/0U9M=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1832f4ae-cd9e-4f7b-70ea-08d9c068fae3
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 07:52:16.8733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTSphw/o9jq4DDfNssUqUtCcBFqqQKSSV+mngp4XA0PhLOtf9wnEQVh1EVULzdSvNko4feS/eOx+wYFFwk8liMXHkibMaaeFKXN4MHjy/j4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0379
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 04:52:39AM +0000, Joakim Zhang wrote:
> As I can see, when system suspended, PHY is totally powered down,
> since you disable the regulator. At this situation, if you
> assert reset signal, you mean it will increase the power
> consumption? PHY is totally powered down, why assert reset
> signal still affect PHY? 
In general there are *other* use cases in which the PHY is powered in
suspend. We should not create a regression there.

Francesco

