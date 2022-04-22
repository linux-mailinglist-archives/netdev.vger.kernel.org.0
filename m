Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5778D50BC89
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiDVQHC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Apr 2022 12:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiDVQHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:07:00 -0400
X-Greylist: delayed 2268 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 09:04:06 PDT
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F2625E15D
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:04:06 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2040.outbound.protection.outlook.com [104.47.22.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-8mBC9YBePV-DFLBMWkHB8Q-1; Fri, 22 Apr 2022 18:04:03 +0200
X-MC-Unique: 8mBC9YBePV-DFLBMWkHB8Q-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0385.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:32::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.13; Fri, 22 Apr 2022 16:04:02 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 16:04:02 +0000
Date:   Fri, 22 Apr 2022 18:04:00 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220422160400.GA527505@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <CAOMZO5B6nBH_fFGsg+EKZGTOqqTjztvpGNNCJ0wpbcTq+2vPDA@mail.gmail.com>
In-Reply-To: <CAOMZO5B6nBH_fFGsg+EKZGTOqqTjztvpGNNCJ0wpbcTq+2vPDA@mail.gmail.com>
X-ClientProxiedBy: MR1P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::9) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be29c074-bb76-4ac8-f628-08da2479b7d5
X-MS-TrafficTypeDiagnostic: GV0P278MB0385:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB0385C0CDB6AAFEE3E9D330C4E2F79@GV0P278MB0385.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TADO/84oEp7208qRmtNtNgfh1B+B73LKMMH/qACz7udlUR9bGcshQdW2g1YY3tzRgHbckGxGKFHALB8pkcpVQeN2e2E+PRm51WpqqPLxD9Ynnc3kwP31dN6XCSpHtDkj1KEFUrVXWEip26xpZnUAA/DcX/yZijc/6SDWzDahsH/TKV71sOyx5BhOnLKW+TEhqEvx5/aRw/+C58RBnocbG15YfwAgllWVpeN2mUgsn5oaX5NztPCY4D1+gxKxrdYZh0/uUAEcFhso+Srtdw3ev+lwd0pwQH5GTd5weOZynDYccI1MMF/Yh3WLZ1Tnlf0+7YEdnUewTw6wBSeNT1Q3WwDTPiFtNgUhLrD+C2Ir7FHE2TRXKEWx79RNffCLTquofRi3hHsuDYfrxHWZV3ozRbslOFrAmU30cUR9DuboTQCT4rgU2DfGHBfRcC+dktXezxVLRuwn9wmxyzplBCKZOq8kyfR6ltd48vlMJ2eTzzC31YBTCG9txfgWLQx/xJioZ0zB0fEx0k6uvsYFesXVHq0LKKnkSnnfHXYcfzlj7StXVrx+Pu58lUugLVEKF6GDs3X+PG88MjwRyL4rdTq6obPD/tuQXfMiLTZ9GEK8Mr5a0pEzTm++fUnBRFymo4QYAyJOZ9nSnwTXt+7z61b37X5rv4kJZLrsuJFTPhy+w/H7cZHdNF2d+1NvEJRkDaro2qyGa5F4ojLj0LHlVaahTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39850400004)(366004)(346002)(136003)(396003)(376002)(38100700002)(66476007)(8676002)(66946007)(38350700002)(33656002)(66556008)(8936002)(5660300002)(6512007)(6506007)(2906002)(316002)(52116002)(44832011)(53546011)(6916009)(83380400001)(54906003)(186003)(4326008)(4744005)(26005)(1076003)(6486002)(508600001)(86362001)(7416002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VKSBDj74WwaEE6s93m7HV9ojPP9S2ycl6FCM5umfMOBJ0zSGxmnZfb6lPEBR?=
 =?us-ascii?Q?/axV506FaiUwDyzgmAUVCXrXl2kWayoluj0KrWKYmX7+FkkxQW4rwaoIbVAU?=
 =?us-ascii?Q?i2GHYyXKNxWHt355tcGXKLDPjmh7kTg47ikK9eH/sdQ09DVpJqPMH4TW2RD/?=
 =?us-ascii?Q?MMFJt4DfM0ddS2QIXKPSztgba6bNDzlL+p7z/v2DnNFMP3h4xoST9tq6si80?=
 =?us-ascii?Q?uCpxXgcRZIdxKcrA7yGwaUv1e08pyEkD8w4nRlQzOqXrWwU16Y+4rpwbgkkK?=
 =?us-ascii?Q?D+Wd3vbSeRniTDHSNWWEsD3iYPMx3p2merjQsn4YuzJjtl0hfUazsD+TmVTJ?=
 =?us-ascii?Q?4UefGaBGjZeQbLvv8Z3pI2dns+RexhNhUPYZiMm0NTKfU21EWVzwiqVeEl7A?=
 =?us-ascii?Q?R+plM1U6MLStn/tspFOsfQzfoszw5apWTAOtbuMmmFrTUgp8YO8hlxfQ3byD?=
 =?us-ascii?Q?8Qe/Bpw1Ry57DotWeEYsTxDqtEQLp/ClwpsJ+TYyOsmAu+J8+3FKB83zKZ48?=
 =?us-ascii?Q?k6YgE+aFp7QhfUse8n4gGCk7Mi25x0/d8Arn1NVPFgoCkqdSX4q3YHQCE/mK?=
 =?us-ascii?Q?mZ5hLZdl6pFkPMVYJ6G29J3h9ecTq710zCu/GWBMFaMvynBw6nO2ZbI2r6Ys?=
 =?us-ascii?Q?0x9srtNPGFSZuZCNuookx/6IW7RDVfR3mJlRLF3Y+3GuTsS/WxyU3K4jP3hE?=
 =?us-ascii?Q?UiO7irCMcqnI0ERP4jlog+7hDaj10n9LcmiOLXpMLxzfq+ty6EK7zsD6JCAt?=
 =?us-ascii?Q?zPrzKtWeEndmbjlRQokMy6272O4CyV3v6WkGY/rV2kywO4TJ1rTdyaqA8LHu?=
 =?us-ascii?Q?qe1anbwrWkcIO4dE0kF5ehbQkJbuxIoAORlOHA9hM5w9W+y11mDT4eNll4Xg?=
 =?us-ascii?Q?zAxqUwqrDCj5UW/NXvF551EYGgxQliBn27MpGYJhoKznxTfd/6egYvCwMOPe?=
 =?us-ascii?Q?2n3uVrY3XFXsfVHAR1nXQNXZbyaf1E/c04i4F6EY+ZKq6Y+3wSsF1OqI1RLJ?=
 =?us-ascii?Q?EQDmy4triu2X/x2w9FVFF2Uhy1WmPfy/ibGlquPbBjHbDUbMQWkRg54MM+8/?=
 =?us-ascii?Q?IEFsxT77PAgv2AGJhL7OSbvlOrB1oAKRPoyFPqmXijSnF2M0tpNO7o+PGcUj?=
 =?us-ascii?Q?9/VVv8EpeBtWr7AdalHb5w8JnDOeytyB2X4tNOCB0c9+GMAMfNtmQUwjDd1t?=
 =?us-ascii?Q?Mntcz8Qr3HkitoWzmcmRW8zlh7sv1RkQuwfqqgLNRLGzQo4XQKjrRDmE6Sqd?=
 =?us-ascii?Q?TDJFKbLACPVH6L778J+6xhHxAMwNEjccZXeGRWgTBoC+ezM27EEQKjizjllP?=
 =?us-ascii?Q?CUAUOYr979LyAAyqbHzoXBStPwx2fThp25DSxyIRuCD2RZ11Uiqu95Ei3sRz?=
 =?us-ascii?Q?hBAIoMra2svybFmKB/18VppC0UMDvp+u2Tmj9eNckSZFBa7mOjbF/KNA+dWP?=
 =?us-ascii?Q?j8EH53z+HYO3vGWZP71/mVNAgx6gBz4koWCL6wxDJJVKykBqxV8cZght0SCR?=
 =?us-ascii?Q?0fh48oKm1IP4XMwHzszBKE40YUOG0EUr6anmDULrQG9I+0gnAaUo9q2JVHt3?=
 =?us-ascii?Q?Ba2cwE7QFSNoVO1QMPQQp8+fTUKb/ZwAoZPaJvMX7Fj1RfTjYXQqtdUDtUYS?=
 =?us-ascii?Q?eOVfO05EiJ5Tom+iEE4RJiDH1FaABz9X10GbwJQtKPF5j4Sm35acjoZ+QM6X?=
 =?us-ascii?Q?wE5fMVPeaIWk7+1M849c7uU+rY79Vk+Metd/PwZctgi+I2nuVTwchBlh7hiT?=
 =?us-ascii?Q?2jHOi8J+ZpnMTqzMY1MHsqNeDCIC5r8=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be29c074-bb76-4ac8-f628-08da2479b7d5
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 16:04:02.0866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzrh7C8rlduL0lzwME8tg8PWQAM/6e36gHwTKOcDZ0G/35WwiPJhRCyG5HxMuveJS1NHj7VtutPnX5Ulrq6yRiu9z/e1g3Eym//TxoIKcUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0385
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Fabio,

On Fri, Apr 22, 2022 at 12:55:22PM -0300, Fabio Estevam wrote:
> On Fri, Apr 22, 2022 at 12:26 PM Francesco Dolcini
> <francesco.dolcini@toradex.com> wrote:
> > What I can see from the code is that the timeout is coming from
> > net/phy/micrel.c:kszphy_handle_interrupt().
> 
> For debugging purposes, could you try not to describe the Ethernet PHY
> irq pin inside imx6qdl-apalis.dtsi?
Yep, we'll try to see what's going on with polling instead that having the
interrupt enabled.

> Looking at its pinctrl, I don't see it has pull-up enabled. Is there
> an external pull-up on the KSZ9131 pin?
yes, we have a 4.7K Ohm pull-up on the board.

In addition to that I just tried with

@@ -4151,7 +4151,7 @@ static int __maybe_unused fec_runtime_suspend(struct device *dev)
        struct fec_enet_private *fep = netdev_priv(ndev);

        clk_disable_unprepare(fep->clk_ahb);
-       clk_disable_unprepare(fep->clk_ipg);
+       //clk_disable_unprepare(fep->clk_ipg);

and the issue is still present.

Francesco

