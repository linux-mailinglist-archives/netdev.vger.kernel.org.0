Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C613956DC
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhEaIZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:25:36 -0400
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:54925
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230070AbhEaIZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 04:25:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdFk8ZAjKzXuqxd+73d5KutAo3UXT7SdGmJDt061grjK/jCH1Dj8Ri3sYrv0tzpn2eKqhlj2YPJyRZn/wjhGRuw81Rc819McLv7ZAnWNXR8NawYqY6NRSN3kiRdhTNySM7R6PQ/7gyGdIlFISHYdEwqDP8L23swePSgIEi72KP4aT4ou5Hamsm8BhQsceW6wNkW4oAL/tRcCpvOubWGwWRXK7TQYvpV93gwJS6Hig0ENp/lPiqY8v0Yfz1MqbM4MQcpS4ryHO+M+pD6HH+t9vjdEotq8tvDSdThUHgC/bpv0bmdPxqCu+i+FMmV0eUrzIdB6eXLOkneDji50Ng+DCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uu/VxkNi6OFQQgE+Xg4K/Y4lKODdCRa8/gvimEf2wPQ=;
 b=czEI1w+QbF90+c2l2oq28PWZoJkHC1uq96qX4B/f6V1WHTxqyTPyK8SLULqC1b4SmDHUNbeipPyEEUvQ8wamnHsfRgLhem6TDUrtOz7nfqQzaNf1tXoAvUFGhMduQ9vjUhX8ODOuaZSdtksmLiuPxTf/hBLEH53nIronaLtcCPTwaMAo61VjCZY+3ZUcSHnLmH3LThZQQ0CHMIYRIRfVb4HJQyhF+8IZEWmBXc5jc1SNhDruCBhDBR5GhNzUC680ZO7rPurEE+KfxuCF6SN2JAaMiQNCUnHtsN74xZg00Ypx1E3QrM9MnIazW51O62TNcMQ+xgIVvR7XcIdhq6HNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uu/VxkNi6OFQQgE+Xg4K/Y4lKODdCRa8/gvimEf2wPQ=;
 b=XKhv9Ll5e7i0VOGOaJjPGUFHIEcyPc6LA4KEpS1soq/uQGfhCT2veRJi4Y5IE2ACIXTex99WbYMq2g4pHZXX1+792PSahuFb3VjfVsfVFzH2kmVBUO72XFh/zZYW3lHLU4hr0eLcNGRfmqOKVH8yj4dbAjYFbChYYW+j3JadEq8=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN7PR03MB4449.namprd03.prod.outlook.com (2603:10b6:408:3f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Mon, 31 May
 2021 08:23:54 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::308b:9168:78:9791%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 08:23:54 +0000
Date:   Mon, 31 May 2021 16:23:42 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <frank-w@public-files.de>,
        <steven.liu@mediatek.com>
Subject: Re: [PATCH net] net: Update MAINTAINERS for MediaTek switch driver
Message-ID: <20210531162342.339635bb@xhacker.debian>
In-Reply-To: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
References: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:a03:331::22) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR03CA0077.namprd03.prod.outlook.com (2603:10b6:a03:331::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Mon, 31 May 2021 08:23:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c58957c-8233-47d9-b751-08d9240d6d7a
X-MS-TrafficTypeDiagnostic: BN7PR03MB4449:
X-Microsoft-Antispam-PRVS: <BN7PR03MB4449242023DC6DCA51EC17E2ED3F9@BN7PR03MB4449.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SPQ8yRRZ3l1LzMYRarixEyH8rsta+phVZXixXpsreHbJAbDYkstjLwbdwVpCZh7bbQTXcI6oUqfWCvKD6/0q2NXRVPZrGg5FJnuiJunx9BjMFliT28b9Xkv87mUrm+HShwZgxubbpEmQN9ajDghKYgobardA2qx9LMhALu8KIYf2z9AHGDNRTKNevJE4m/9ZecH2qy3BXHSWMv5GpOXn6b+a6JtlptWYpSdvvGLH/cb0WhNFHcD+P/GdoeMaGcOOgjotILn4gkwWk+t8y9VT1mpxhTyRTrfQweVdtuklW+U1Tu2X44GkyugM3i1mafx92VTr8MzlLXZsfS3FPacx7VZEo74oMN3XbsdA0nutFp8DOB0mhhjjGAAJVi8e912fqgGkZbP+eiKgzQ2Lzfy75LtM3CmCxhQS11vMNMkLa4GmYM4+oJM0EZ/kKB0DjG1xEDn466ObY8701uOr7Ujlt0oOyFGxCaJRpsRgXEzwvdjOpn00CKg9ZRpJmOQeRB3Yw98drIKPrdEDQNZ0W4m4fHMHxJD2yNdMZ4pA/j3w+iqgK/oWD8dssrWDVo28Ap/VGQvT2uXeJpOEuUgYdcb0FdtoP9RwPwIXpfi2F+k2c1FUbTpR5UjTWotXISh/lzfDIKzwaORpgRY70lSNmP/To+88FFoYtzp8PHQWWZBGWwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(26005)(86362001)(83380400001)(186003)(16526019)(9686003)(5660300002)(8676002)(6506007)(66476007)(66556008)(6666004)(4326008)(66946007)(7696005)(6916009)(52116002)(7416002)(4744005)(54906003)(55016002)(15650500001)(38100700002)(316002)(38350700002)(2906002)(956004)(1076003)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DJxAZOitTCGiN7jJX7QG41ItsFDjMC2jVEra2u22G+JDEvFkGS6pPXAXBcSk?=
 =?us-ascii?Q?ugTv8XySs4B5DWdtvLYRkgtaFmdkhWl8neH7zL/JS/dsNsKiYRe6SGBHbc+H?=
 =?us-ascii?Q?F3n5RDv01QjrmmRj/iO1DZq+Ic8HRBk5eSI64i3ZONkTHB5/DLmSiYQ9nQ8b?=
 =?us-ascii?Q?iqhqdaE9VToItWWe5U5ZTutC/LSCUMq0Fm+5XkJ5s58pCm36g342I9ntqVWk?=
 =?us-ascii?Q?ejY8ZSic6OIJpWeC2Mb2sEJyX1lGFhoKz0VBh8C/Ym9TDrfXCGLA+eB1A15O?=
 =?us-ascii?Q?t1CTpPwUIMF0WjA0t04wvUY0w4J7xWrCpDEoShktl0P8eGaUTIXvfwppX84c?=
 =?us-ascii?Q?IgROSjJgcAiVt9PZVordh39Kf/F1NNtKg6jL/BnqF9Bfo1knWYmaiGmVarL2?=
 =?us-ascii?Q?3yt5QN7SHCa15Pi9m8P08vqISU63gZT09QOk8Id4yW9BT9TiabjWbsUq8o0t?=
 =?us-ascii?Q?l1n9TQdWB8yzQLRrBwF4Z2XROq1vKKoEkj44tXfzukH0nrwaUCIflCFMYMZL?=
 =?us-ascii?Q?BivVeFTFOJYXubfDidQsY3CDpibS7I+KhV7P2hUV1bNcWWCDOsQ2vI+hPBJd?=
 =?us-ascii?Q?UFO0/2HUoq33palACNxthgIjEcgMAv1QXhBpNVKlge5eB1pbtr8e++Q8wfgY?=
 =?us-ascii?Q?gPOrwqq8MwXkJXUb9dpm5jmyEaKGlOEuOmF9PIVnz754shxbWb+ekwPUVLuD?=
 =?us-ascii?Q?0bJl/vZRdIEyRkYE7MTteRZtHNufFhCK7QGnn9o7nXBHFHkzvKhal8sePchj?=
 =?us-ascii?Q?kxPdbZaxRnN1bUKxLISkeGfue4It+Z55vo0GqqCf6X24HMUH6PLaiVIYfLcg?=
 =?us-ascii?Q?5bJNwPOsQipEQKyVAQrPtFDk5ZPIntD4828co9JJWx4t9rQmbR6Sx/DHTxNV?=
 =?us-ascii?Q?ovYttz/3TkEwF0fSeLFthksVj5S7qsy5GRl3vjJzt+2DFhLRF8azCANPKCXP?=
 =?us-ascii?Q?I4QLQg8Tl6ErEomcvbjU16i/dhadAU5uNXAOYkibwOlZ0CETyDylIz+2+bE9?=
 =?us-ascii?Q?m2hthhaZJoUeRu8uajb//1Fp+8avmfP8uhkTtVlkfyHkQSDf8jc1bOz/y1ML?=
 =?us-ascii?Q?/kLNk4aSmj4ineaIXQPx8FJywjMRX+lqxc8+4JzXOkkfYtkjd9KOky5BAoEH?=
 =?us-ascii?Q?UHVrm6m6/5Jwf6oJBBDmsvTO4PyO18RPTrBfqJsLfKiie0X/BEGeg6Gd/y+T?=
 =?us-ascii?Q?F+StltPNzXx6sYpT3SQ1SO/Y3DKSYntBbil80BKGhp4EDp7iad7tgdHFfVoY?=
 =?us-ascii?Q?Kj5CwdvvGHzreVOxaMxtjTsezDvhYO9B92+7wLQUqenHsuLtDFlE5ERS1Ff1?=
 =?us-ascii?Q?FxHj+c97O9o/8Kv6VwXa7vfL?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c58957c-8233-47d9-b751-08d9240d6d7a
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 08:23:54.0664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nMW+YWiV2WXmvh/FeE8fLaV4QU73lhZQst2td51q5yCrkH1QmFcFBagS5zr1bI9I0m4owmKDuue8Ls8qFBNqoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB4449
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 15:59:39 +0800
Landen Chao <landen.chao@mediatek.com> wrote:


> 
> 
> Update maintainers for MediaTek switch driver with Deng Qingfang who
> contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
> enhance MediaTek switch driver and will help maintenance.
> 
> Change-Id: If372c1a0df6e3ba9f93b1699dbda81f1fd501a7c

do we need to remove this Change-Id tag?

> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bd7aff0c120f..3315627ebb6b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11588,6 +11588,7 @@ F:      drivers/char/hw_random/mtk-rng.c
>  MEDIATEK SWITCH DRIVER
>  M:     Sean Wang <sean.wang@mediatek.com>
>  M:     Landen Chao <landen.chao@mediatek.com>
> +M:     DENG Qingfang <dqfext@gmail.com>
>  L:     netdev@vger.kernel.org
>  S:     Maintained
>  F:     drivers/net/dsa/mt7530.*
> --
> 2.29.2
