Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB483477045
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhLPLbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:31:08 -0500
Received: from mail-zr0che01on2116.outbound.protection.outlook.com ([40.107.24.116]:62688
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229996AbhLPLbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:31:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzDJXWWqr1zyX20kNd3tiMBNwCzKh4jNKww/tc40ZoNqk2KaztgIR+dXR9FKmRwV8pcyd4F6QKlA4rKikcAtSXduOkSLFwi0H1jF6jC1UZ+5YmEEnByGBb6DSW/AsXp1FvI8ACHL7woKayzC7v675ORVa3RPk5Dan7i7N/V0Iw4vE8SOj2DtwejiNYmiz8w2noEBBxQRimMnGc66G2xcqwBYolLcI1BXFZiAOyXjWPpQ55bfO5kRB/NsNlNJH7dqEpDw180lTf96qkVC8W8jUPXwLyqd97e+c7QGya2+gTpbZv6xICbBuQmDndOIql7akxi1BT5MBJn61s/vShNmyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4o80wvUBKcgbYzLp+0GZ720X97Yhtr28NPdigoyrWbE=;
 b=l5SzmZK6MRDvhREQlL0Aiw852EcgsNCD0I+dkhlvmG38YGJ7G/K4oU19PVFLe+MvWAd2jjCx6DaPMgwcNFT+pNlD37+J3kwh5AlswMXAS15HxNTU/x6HT4AGVM3NnG8oqjMrzMoYXw5bobd49HTsZ2rm1XfEXw8cp/rcl/tKlAB/goHPlh+xV+njpOTWwZN8MRJ2DRO/Zg876CVct7z+aIdRT59RDcn/Vo16MQ4PgA9w6XwomDrze9zFGqR+lWIA5pf3elDIu+vFlUxqDozK67ICyUmf5k7ngs/MNbZkfhRmcmvU1ykCAROErfMwGOpi4YZ7QHkzQKbgi4Sp/qoT9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o80wvUBKcgbYzLp+0GZ720X97Yhtr28NPdigoyrWbE=;
 b=H2ARqK3+SwkO+rzvDoUPwt6O2neNNJgiVYaRaktrCuLn/TCBDYzvYMgRgaA6zHM6rtjI7bnmH9FrP04CKhiAvBdD92L1ltTynnPPLPOXz0FL0/yWxXweMK519sRDvI9b0mJPW7FU/UwhRxSfXXspQfDz4X3d7P7wxYZrwmmpCOI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0123.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:19::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 11:31:05 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 11:31:05 +0000
Date:   Thu, 16 Dec 2021 12:31:04 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211216113104.GC4190@francesco-nb.int.toradex.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20211216075216.GA4190@francesco-nb.int.toradex.com>
 <YbsT2G5oMoe4baCJ@lunn.ch>
 <20211216112433.GB4190@francesco-nb.int.toradex.com>
 <Ybsi00/CAd7oVl17@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybsi00/CAd7oVl17@lunn.ch>
X-ClientProxiedBy: GV0P278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::17) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e374c254-b4af-427d-8b6a-08d9c0878bd8
X-MS-TrafficTypeDiagnostic: ZR0P278MB0123:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0123A5F2737F5AFC85520B99E2779@ZR0P278MB0123.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDrG6zNTj8UiNsDn2dKh03/QW8vzjhMmQbqvrlw4W8FeI9HkN5fy31TJdTRHV0NM1mA67hdguzMbBSU1AgXUkuS0FsYkKQ8hcINme5T21zAxX5TKP6VV+9STCMijuQo7fDX+rMHFlDdEVuLXDwLASVFtpvYVWokEIWR831OBLoXz6aLOeWvG4ItdE2RqOC/SExmFSpdAFExRJJJbRH3MjdSkOBnWKn7uT6IbA+BTEa4rrTLuWsSuksvYhR/hRZ79V7ira50BUCWiredw+gxFzdRm+myJiDE7Oc+3twN8pMeugWDxmnKI4gK0+ru6CfdPpdO8ENSWQLx6sRHKrgJJF/CtQq5Z1aj/ee8Pq8bvdC3sktEdH4zUoPET96AsHfXv1tiRVXMfMvJeo0iNoMQoFzruB5qhYSMQ8qcAGBFVaFaMm+5bChaHlR44k+88W1y1vRQBa7+KfbC2P04lf4tP2188T1vl37sBu/ipFgjkUmRZQMmOrIkA78UNvX7wqyud8e0kRWmgQLiVg0NRdLY9R+7y3r2WfhdD/7NEW2hOKuN+jOW8tSDbT600cUw8o5zOUrNNlUi+ZmrLPp7FT7CmihN20/e1RjW8oJpWB6hRuSrq6Fvs6RprIfcPIq5F2Tl7qha8EWL3iXrEGn2oV+SSkwXSL+KgMbi6DIS0ZQzHbUh1TOaIT4UloeYXZzu6sR4e1gh8FJZrGy8jPF3iaZF90Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(39850400004)(396003)(346002)(316002)(66946007)(26005)(33656002)(54906003)(6486002)(52116002)(8676002)(8936002)(186003)(66556008)(6512007)(66476007)(38350700002)(38100700002)(44832011)(6506007)(2906002)(4744005)(1076003)(508600001)(4326008)(5660300002)(6916009)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jq5G2oCWo8vrh8dVuhu7GMlmPCWgdvib6P3mia7ifeDEeSBeDCwx7zdCmjnc?=
 =?us-ascii?Q?sPFBXVHimbDpKlSnsijdXBdgX/NMcQff3lnIaN1Io9df8G1TvwX4ZXU+Rvq/?=
 =?us-ascii?Q?endumYAL3AglrCaFSPxQ8WLOkIAdjE+wRb4GzdCQR0rOKsm5ZZrqoiC3t4Eg?=
 =?us-ascii?Q?U4jIzBAnQlgi3aJfIWT85edRojySEh6JsD/+1+UUN2uv/d7oW/Tl1m2yuNOs?=
 =?us-ascii?Q?vThCzUsJ/WvCiRImeQ/PKh5F/PnIEthzL1WuA7QWYUYDQJa1m0UGnGU2jLVS?=
 =?us-ascii?Q?iSQ6jtjjkTqdoPHU2wrNn+bOi47d07qcOoEp26PgGTqORXUvA2GQbmfM2sWq?=
 =?us-ascii?Q?Q5HdXKrD1lWWsBhkad2htdWoMVazLm7yNfx07JqByQ/5PtIdNz77UCsDF3Sx?=
 =?us-ascii?Q?O1PExl2L4i7U9bvcxQ0BqdeiRU3l4k+u5T4xjtiBOVPDmwQigpGWPSWRPSzA?=
 =?us-ascii?Q?3Vg8eG4uK/tYd7SQfAakCk1VNSb8Y+OF5T8Kl1bc/8tXkuWDlWhpt1MZRW1p?=
 =?us-ascii?Q?xllh/C83jPSV/1BSZN2lx0PBBLbfm/1i9HNlamaQ3zZpMsbCoPPOF4hmRp+s?=
 =?us-ascii?Q?tmXFyC88T+5XkNVYfkDRhADvWvRcGu45egmpMgp7+KzNYzp1pHmMic73SiW4?=
 =?us-ascii?Q?jGXNHpjP418LoAQR12oVPPv+DAXwiOJUaAD0hXV5HOJ8RHVFTMfd0EMQrs4P?=
 =?us-ascii?Q?djWcej+OG+HP9t7kNejtqusEd/vnoh5tc+W4XPxLkW+uy8IVDPyB/72Wz3RY?=
 =?us-ascii?Q?KaQbAn/EA3rluTW+ahsgxrFpuKTFev/lVw0duUNOMoO2I9UeHzvjec+UMRXe?=
 =?us-ascii?Q?GvvCY2gymYCJur+ONRJuihH03thEuRzSK9l8Zw62mkmdnoaxgcB2Ac2xKvBL?=
 =?us-ascii?Q?2V5qunDAjt+FOdfg6kTWUKvV+t79urjZ+Bbe6Epwmr0MksQJLZldjs8d1PN3?=
 =?us-ascii?Q?deiM7HcjIPCqGIFek5u6lUuQ33ABxem824Q/KqkyKAkpn8E8XF7rg3wUUdhG?=
 =?us-ascii?Q?RLjwdjB7mm8mvrWvidP1a0Ok/rrUK05avE4jlqO7vcjGNa84SlTwtQbIUlhI?=
 =?us-ascii?Q?lOmdHmsV8F6uAmRxw8r/Vqwdxgn3LWFmcRnFcpnDHuYyRMZAl+sjZ0q2bb9J?=
 =?us-ascii?Q?8gza5jOL/T72eW41snReNTGns8YzK35++E793kzhjbgeFvO14M7g0SdKe+LE?=
 =?us-ascii?Q?neyB9H/uJXCPf6JWolujXz87Sf811GasRAV03Uu7s4LXR5hKIIj3CYidgeE2?=
 =?us-ascii?Q?WXanEsgwkL9pPkIzcSSCTbSFFZKNdYMxFCidrJkryzuXq5+HbaA+3jlH+zX4?=
 =?us-ascii?Q?YcyTWrbSif94OQx9jikVrtzW0sFhJDx76qaZijBhhORWqu2hxY3mBL0avsdk?=
 =?us-ascii?Q?gsaHO2I1wHArPDADg2UyrrSlt3kADt0moQe9Nr1r4f107CkIa9u7BlmLmXqH?=
 =?us-ascii?Q?f8nd0hsXHthPBT4knDYhkQUIV2Oae4pVU7oapuhLYzW5bnSert0FbOyCqNKn?=
 =?us-ascii?Q?wCr8nNu7uJc80TbNvJ4R5ZGBp1KtaunpQP2YT7PqKGhDnGJMgt2FtjD3xiu1?=
 =?us-ascii?Q?wyk79zg34g+PMq3OGr+WjFit2t/fmhRrEJ13hceDDqGd/tdTAgfTJDpIhIcm?=
 =?us-ascii?Q?f4vdxksl8tgm/G0OCX9m2LbSgCNaGb8qBnmh2XM9MELi9w5pm/SN63wafUwU?=
 =?us-ascii?Q?1DHgLsYwIuIKJ0BIsC509+1m0o4=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e374c254-b4af-427d-8b6a-08d9c0878bd8
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 11:31:04.9575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s8c5qTDOxknQIiugbIIIUMArkqQza27vb9fbi4cAzvskHeeN4fCYPgkf3MRXuF7wVgCDEtLVrAwfYPcMQe2ueGD89ZrXVbcIqI4YAWHHVMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:28:19PM +0100, Andrew Lunn wrote:
> On Thu, Dec 16, 2021 at 12:24:33PM +0100, Francesco Dolcini wrote:
> > On Thu, Dec 16, 2021 at 11:24:24AM +0100, Andrew Lunn wrote:
> > > I think you need to move the regulator into phylib, so the PHY driver
> > > can do the right thing. It is really the only entity which knows what
> > > is the correct thing to do.
> 
> > Do you believe that the right place is the phylib and not the phy driver?
> > Is this generic enough?
> 
> It is split. phylib can do the lookup in DT, get the regulator and
> provide a helper to enable/disable it. So very similar to the reset.
Sounds good.

Can we safely assume that we do have at most one regulator for the phy?

Francesco

