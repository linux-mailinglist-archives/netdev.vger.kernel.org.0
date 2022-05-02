Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14221517560
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386482AbiEBRKk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 May 2022 13:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386462AbiEBRKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:10:18 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEA345F83
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:06:35 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2041.outbound.protection.outlook.com [104.47.22.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-ocgk_dvZMxClGYiN2kp9TA-1; Mon, 02 May 2022 19:06:32 +0200
X-MC-Unique: ocgk_dvZMxClGYiN2kp9TA-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0031.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:12::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Mon, 2 May 2022 17:06:31 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.014; Mon, 2 May 2022
 17:06:31 +0000
Date:   Mon, 2 May 2022 19:05:27 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Andy Duan <fugang.duan@nxp.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220502170527.GA137942@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
In-Reply-To: <20220422152612.GA510015@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MR2P264CA0113.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::29) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4c34fce-db9c-4ede-ce65-08da2c5e1ad5
X-MS-TrafficTypeDiagnostic: ZRAP278MB0031:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0031C19A45CDC0755AD9B38BE2C19@ZRAP278MB0031.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: UG8/RwwjeTSwJ1+F9fi26R6QfP9lgDrR9yYlfzP1Xv/U6UJ6PqdtOvEQzzDas7xHAgqp3R+v3Dcg1GL6KXmWZH4xtatKhxrjuS3FiED1LL4L9BvOb14ajdnUJl3+ahc/IzVE5brwyHNp1FiVOCzojv6V+AcQL5xiN7C+Lr15LiVcML1ywPUkeMO/5gLavu/JLlPyKdNLE8WitWh15zd/xlxBv8/cr0kCuTQ0WOObbgh/AAPZ75/KVQUSJQnWAIlFn04+uCyWRIpRfWF/txXscMO0w6T1otJp4eFIsICHV76eDAmpV1n5SME5D4tPqRYc+XXpPLvze9fAttRuAf5+PG5qVXPqFGUhBCSJLXwuxUi6+wag48Ar1qhXGV/NRrnjbMgScYmIQ8CqI9e/Cz+qRhz+UvREOc9M1koKldTssbFzRU01svYfnHCfxSYB+qKWu5kmtez12FTfq1oAOXGZUQhPYcF9yTPk09ZGg0gDkiZUWbFo9sOchROtgkSS7IU88HRD0mHDwG6x+WKxOtbaNjj+BNmfp+VhF/ApGGFTwWjrsOy4t88CK+z017KI2DwIExNNXj9e77VIQgRwlRKJqdaUy9YfIjiUav18vTqvP7W02GZHQUay7UUMiNF49yZ5WZuO+wVuHiaTW1/nVxpOHJ0s0jqQXrHllKGCPob2Z/xHucwQc3/lDg1bI9jneXZYzy+gDSEmMzG+xwI4wmEIyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(33656002)(83380400001)(1076003)(2906002)(4001150100001)(5660300002)(66946007)(44832011)(86362001)(8936002)(8676002)(7416002)(186003)(66476007)(66556008)(6512007)(26005)(110136005)(54906003)(6486002)(316002)(6666004)(6506007)(508600001)(38350700002)(38100700002)(45080400002)(52116002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?onoKvXEZimsHum2oFPShZPxQ9SOq5oCs6yrQ11Cae/t20hM67HwizJWocsVP?=
 =?us-ascii?Q?XASCNdfxF1Q2zF1AeLV2LBwHeEWBZPnxhE8AxeGSi9UBTE+5h7YNku2vZHME?=
 =?us-ascii?Q?JzlS3j+so4uNHKqOnJaj943vtMFFk2hG8ZXFhLrAhfPUCKmMPFEKCIzYejk+?=
 =?us-ascii?Q?Bl29BVN/9WeIgoMjFSHrcEEa8J+6xH5FLrXW42YaJEUeE9vpHVTDLHRU4ftY?=
 =?us-ascii?Q?4jzggw4KLvb47sobTJMMFSogCYGAU6U7PKzBLAFy/lkMB3Te7IS0zCqvkDg6?=
 =?us-ascii?Q?cuY7V6C8wRzPfcqHzfAUnTJnk/PVNyo9A9k5bHzhiWWeDPOrD3V73eFuNcnI?=
 =?us-ascii?Q?Rm6sn1RnNg2dYWRfvzOJEILKj4oU/NRILURrEP8VV1Z6mWoHcyu16yFwdriR?=
 =?us-ascii?Q?5Wb23kNm9k4+acyRDuoIC/YkCrDyFOxiWzgc1/975pkNhR2yXZbdN4PyzhTr?=
 =?us-ascii?Q?DphmUGqXHo8U9pLXE4xEvK+bw/n8NHFpnIYGW3GbXO3klniA1gpGj9OoCQFE?=
 =?us-ascii?Q?DkaYGigXg4f7CsY1mEU7M4MC5//brdyrLGZOuh/nq2CbVy91CcX9mXm9wBHR?=
 =?us-ascii?Q?rIooESB05NVYDQUIdINi0LoGcO7em0tU5U9TG7RgqWXGs7Koo0czHbfMAd9m?=
 =?us-ascii?Q?r2Zac1a2xEhjyVEaDNoHfNNFfnGgFf1nujqwLRu0FqJVMtLGwQWJvJf/DS7h?=
 =?us-ascii?Q?AAlEn7OZiT7VkRIzEhzSroAYc8SodcvhdRLdJ1IEttWYbxaNpw9cO+U1yyLf?=
 =?us-ascii?Q?ddHYKyncAUyNvN6ea8NrhopA0EER+0IrKlunsVBZQiyNI/Yyqn2veYQKlzwq?=
 =?us-ascii?Q?x9BQWqoZ72SQkKKpksBUuMgJN+J7fDWX5U1rw/rAW0QdGWcrZE4/oml30dEN?=
 =?us-ascii?Q?07/eJypsp1HBNF175XCjFtoC6WgLJsNhki3IorsgK+bbnEdHmI8gi7/6XTUu?=
 =?us-ascii?Q?MWva/0F4uk7V+uTUY/zQ8LDJ1HxQMcrKjsjSTpU0GCXjuYoEbZQpqD2XwlLK?=
 =?us-ascii?Q?pLI7GnzG16n57J0MU7QDYxlwgFi/g/5IOgrl7NugLikNUWtof6rorsEd/asu?=
 =?us-ascii?Q?ctZHXjPAu8beMTYURYHpkrywt7gmjjLmh32CZclAPbqfC+dUMMilTg2h5xsh?=
 =?us-ascii?Q?H+Zm/BLex+XqCqW4piZz6Xr0xRhsLLmQTZi4tbwX7AP2NjDov47abqIUisq6?=
 =?us-ascii?Q?UiVgit3RsC/0D3mBYP/aoo+XVhyWvfWjMDSc9hF+Wt45GQRcqRzT67vhNioR?=
 =?us-ascii?Q?S0naKXVkz8u7WXwg2p2t0knCrG07x4GysRcAgp46w1qn2Ob6lmDf9FoM7Ml5?=
 =?us-ascii?Q?wHphrf9kEfRYDNNWDDBudJ4VLi738otffA7+826OaXdz2xyiuqLdgBA0oj5Z?=
 =?us-ascii?Q?9Z/iUzBdTnJKdJmdZMNXa71RCOigifk9EjvrnKR0AKoHrlLTEgTu+atVMr8Y?=
 =?us-ascii?Q?1KvEf+YqX1XGCZM/eJxVSQ1wFTN64PetyOcQAVpjcBT8nkLoqVMdPAL/4r+I?=
 =?us-ascii?Q?7UUjrRieY+9T0bHDL95AwGP5Zyu5zulP+HLQeFo1HhIi68cf7uv+uC9Gw8px?=
 =?us-ascii?Q?FBGB2nSHcHrhWnksmc7WWbZ0csjnS272yjOsW6ewJeEP0TG1GiQvrxVntSkE?=
 =?us-ascii?Q?C6MCP9LjQbnACOkxffQLAkiLiqyk+8xWCERdRk9Y9ZHrjl1Tl6QhCI+MEa9r?=
 =?us-ascii?Q?GT7CBdX+X/AztRCCFlQzA73++5U5CawR74Z0gTfkMgs7/LSeNbnnfOnsIcZ/?=
 =?us-ascii?Q?FfM5tAsVsTrWhctn/ZP2uiQddyUoOiE=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c34fce-db9c-4ede-ce65-08da2c5e1ad5
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:06:31.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnVv6TDjCtjquTDi0UsSG4JUHgSzjR1PncCfWvUXn1rN1XGZ95lC4JX0opGWDiPHfCrUdK/N8qp2etLJJBNhzAVc3mAljDG6OW1qR7XSQrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0031
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew (and all),
I have some idea that this issue might be related to a recent change
you did.

On Fri, Apr 22, 2022 at 05:26:12PM +0200, Francesco Dolcini wrote:
> Hello all,
> I have been recently trying to debug an issue with FEC driver erroring
> a MDIO read timeout during linkup [0]. At the beginning I was working
> with an old 5.4 kernel, but today I tried with the current master
> (5.18.0-rc3-00080-gd569e86915b7) and the issue is just there.
> 
...
> 
> Could this be some sort of race condition? Any suggestion for debugging
> this?
> 
> Here the stack trace:
> 
> [  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
> [  146.201779] ------------[ cut here ]------------
> [  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
> [  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
> [  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
> [  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  146.236257]  unwind_backtrace from show_stack+0x10/0x14
> [  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
> [  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
> [  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
> [  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
> [  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
> [  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
> [  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
> [  146.279605]  irq_thread from kthread+0xe4/0x104
> [  146.284267]  kthread from ret_from_fork+0x14/0x28
> [  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
> [  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
> [  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [  146.318262] irq event stamp: 12325
> [  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
> [  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
> [  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
> [  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
> [  146.354447] ---[ end trace 0000000000000000 ]---

Could it be that the issue is writing the MSCR in fec_restart(),
`writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED)`?

I do see the issue on link up/down event, when this function is actually
called.

From what I can understand from the previous history:

  1e6114f51f9d (net: fec: fix MDIO probing for some FEC hardware blocks, 2020-10-28) 
  f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)

writing to this register could trigger a FEC_ENET_MII interrupt actually
creating a race condition with fec_enet_mdio_read() that is called on
link change also.

Do this explanation makes any sense to you?
I'm testing at the moment a patch that should solve that.

Francesco

