Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1C247861F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhLQIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:24:16 -0500
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:46400
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhLQIYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 03:24:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/QXLby0x65oMCjFrDBcgc68zL+kjYVbu40qx2IHA9COxfqQYbv1j8YcTJgmsJeqbLIY//sIM33Ve4r0tTfoyNj4orm3Sc2l5XwSTYZ+bIi0j1uzEOxbpnG/+RYcVr9ombYfJWKX0clc4oKQkhXG+WqAfgHPItNy7DdS0VTeblD1TAalpk4xddXAz55asEnGI4U8NhoisfGURHsp/YYK+pm+9Ac2JlV93BnOejUB+8/bPdCLPxMDx04u8G+Fs5O8gqWKIeZt9nIKEj8r5swla/nAXrCInIeo+9GFzKdp0qwi/1YRhtWPbYed2D6eiibEJIVmkJSRXjbPczenVS9XhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ3qIUfgVJOJuTLbqlZNMp7RKgZri6AqksaDVatVMx4=;
 b=YWs2IImPY3ImHnDsBZLrGmECUF/jM3IEQFAsdpLPt9G+TBorBX6d8vO9L6d+/LbGn5+NEk69TKw4AR6K7zjAxHP7++o1GDfwU0rEtE6HJFT4eGXFZOkdcD1L602DLx9Q8Mx+UrcN4y4gTREmNUMb7mtdBbRzBOFrLUfkVuprN/tLgZbY1zqZmLTUvFCzAckOmxdJX4UOu9NVsHzOP7gruF79ZHHwewVpVaUCtU7dDPNhLH/ZK7C5geWlcbkFRQ3F/4dWqNPM+d40CRqDOI6nxtx4kpQYt4H4Xmn5mwTSRWh2rBP1GETQDG+A/+oofFreVqowNvnCRuBsGfTJcb2wXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ3qIUfgVJOJuTLbqlZNMp7RKgZri6AqksaDVatVMx4=;
 b=Ea0idqoSsFRR1tntGhraafl1vlLLs2Z3FvYstVcJchWPWOPc/U7vbQnVrG82KM9aP7pNmkJky8WPCdttogmt+SG62fmAgH4MQ/onBhRMR1SA3VYgdkP8XqRtpiHc0ZYZiBbJH8lz+dzmkvVPpYpGY//DNW7Qb47Q96wb0XlQJ7c=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB4318.namprd02.prod.outlook.com (2603:10b6:805:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 08:24:12 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::b9c2:c09a:cf61:2389]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::b9c2:c09a:cf61:2389%8]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 08:24:11 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Michal Simek <michals@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Thread-Topic: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Thread-Index: AQHX8ntH3hIc4ElK302hVEgJxlXyIqw1OnuAgAAd6QCAAQE74A==
Date:   Fri, 17 Dec 2021 08:24:11 +0000
Message-ID: <SA1PR02MB85609F657BBBD0BF62D070B1C7789@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
 <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
In-Reply-To: <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42c5cacf-d5c0-413a-320d-08d9c1369ad7
x-ms-traffictypediagnostic: SN6PR02MB4318:EE_
x-microsoft-antispam-prvs: <SN6PR02MB43189EC37050004CD0236CA8C7789@SN6PR02MB4318.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gUSq/x3F0qn738eWahF69PWX0gfsTwrQs4IhNnVlshAo6v1dFpmECmDBA0sYnbmSv0f1etNu61r54zTzUBKH8FcHb5EHhHs2TgdRpVKX1qEjj/2QBzAjDxwCw1h/H05mjhXVhYUiluo1GpLlu+6QyJa1vf/qqSn0i3J2vGAv0g7Tf1dgeont93ndprf+kZ5NU5FpmG6A1T6T8fXN4z9RlYyofTDyhz82j6iqG/HlaaNT415143XQtId/QE8MPVhPUgI9FQe7oRhFw/VR+PajvbPEK8Wob7pjZjIHRHwgJfv0k+lPtlD7e0SOSbG/V12A14Qg8eiv+JwwO6MGJpgkdu3RboVvLhbL8TyusM5iL5nxk68Ko9ouAcR5n6jokFIQ5GScuSWTJVTShsPvZjvkbnRJNF0nM7d7KQqo968p2XTxnBCRXU/lx2qBG+DeUG6JTxTAkxAkgyleITzDpOk9w1hZijLqI/dX60U7SVcJpLNvOGcmd5yArB64vTscQy2tFE6Hh4xiSlrQd5VXclHSIEbHtfxZw3ujB2A7eKa1bKxMmP53fLRC0JFZX/iBA92/cNaYmCW1OAC+gj/YwPFACfXa+AO/JY0aYMTBFz7GHgGLK6yYk8wY9apD2+DPub/x83jnciKVvKRrCFK+7llHZCP0B95rNLaVPjgr26zQe311nKDf9BSypsCCKT3mwiW+OFBk+4I0sLQsUZzBiXN3eFZ1CVlbz4/YKGYTl4Yjecj4WkKd/LOEQsrcCNYNFeFyWYoKhWxmVQCmj01pZRcdVGx8UslnDHC2d+T1CWx0UV8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(8936002)(66476007)(66946007)(54906003)(8676002)(5660300002)(66556008)(7696005)(110136005)(316002)(966005)(66446008)(64756008)(26005)(52536014)(186003)(6506007)(53546011)(508600001)(38070700005)(71200400001)(33656002)(86362001)(38100700002)(55016003)(2906002)(107886003)(122000001)(4326008)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DbN7TBSOEX298X1KGp8dyw2u7jzQF0fQWeoSC2G7rgFm0/haqpClrYPF/utb?=
 =?us-ascii?Q?gDSl1y9g48ub+xFbOYX0rV0NYCMOLyRD/KRQJup3Rl04FnBtp5A0ZzdRWNIc?=
 =?us-ascii?Q?FCJBc/EQBJqukY5+9AjCve0QawuQD+51noCSBpikwHjwII8Y0ibxVZNKTUAi?=
 =?us-ascii?Q?3ilMTTaW7WPmvwYkJPnO/o/wnLzFWnUvIjAqwCVJS0W6/aM2ttcxLMpWjV5X?=
 =?us-ascii?Q?6eaa46CQlSBajN/wJUuU4XGqeAYWCo9+20Xn0hgPOtRGMiXBrIY1WeHmBQ62?=
 =?us-ascii?Q?Lm89F67zDNgSOMCNd7n65iTdCaO9yRnsLO11nedsXCwzY+W28O58ai3+HBh8?=
 =?us-ascii?Q?1ZXng/8Vm8K+F+JZJXWtPv3GH+STRcE2fyQ3ZhUMRauCjCbs5PdSGqqk+O1j?=
 =?us-ascii?Q?VOhypsqZA8tikTkj109TkanoR+CScWnkr4lGuVXg72+RYUfOMO5Jrdeh5L9P?=
 =?us-ascii?Q?skt9ORXEElfBRIrHlLJSLCyRhOvZx9psOgXp+wFVUv0bU0zuPP2+srjZstli?=
 =?us-ascii?Q?izaxxugkbTWMB8MMQJgvy95sc5BZzanhkgntBBivKZ1iKLtxEXpxyAf8sJfA?=
 =?us-ascii?Q?wQRgIFZTf8e0AreHogpf/ZMNDt9903MpAf4Y1PZ6x3HQjcLqSd7vCFHPwHNX?=
 =?us-ascii?Q?dpfzGGbup5vV6BG+41Uu5l5KWihtDJgeQUycLcRH7cvsL+XOKXaQj6eRFKG+?=
 =?us-ascii?Q?Ad8FY+1vos554U9SUzCYlVomZTea+L2l0qVw7TXLCCVTXYkQKPxSsFFMhMbM?=
 =?us-ascii?Q?JP+K5GLTn55zooYvVXG9CAJNgFnFId1NDdJkQUe8+2xvUYl+q/pXMaGiFCEP?=
 =?us-ascii?Q?pOTrvPGpO7gQ8BmfbhFLDVwxPvjy90XrJyOVtQ5Th1kXY/xYn9uySg8t/eDD?=
 =?us-ascii?Q?pGm7w2Y/Nkok9VQ39evgaXSJMj+0EQL9qsz7LcjvdlRWlVR3KqFr89qMk2EW?=
 =?us-ascii?Q?//vT7Cf7uKLHzRc2A4Ei6GTwmtK0lRmuhWvgQ1lXgaJ0H4ELmSiSX8NMLuzg?=
 =?us-ascii?Q?gGVWKiyFnEPkwG/uj16cehrCiwk7KiNo4XOTkKAt5uZ/Qkjy4lHtWJcf/iha?=
 =?us-ascii?Q?JKn/1i2IcswZNAFCU97r0w4zsk0mrED9Ca694XXHd6cXfDaM3YZy9GHuJ+mR?=
 =?us-ascii?Q?VIwD/lkTo96p/4qwIJeu1ZWyMMeNEUF8YFOegfGCxNG/h/T4dfYq0Cjql+p/?=
 =?us-ascii?Q?JRGmH6KbRfCjSxvcevE7jMm3DoP+DRLUWIATkxE80Z8LEHVsOEeY0XWIkO6L?=
 =?us-ascii?Q?s2eiRI/BsCOmOdzsWzllBX5Zw+i/DU2t9OzfI1UaVMR94D9w6UKe7NFV/C/W?=
 =?us-ascii?Q?jhvqXVd6wZGCu7AiTygWmKvW0JFGb0TGOPhLka/MO2jL/r6bfcT4d+kUfFyt?=
 =?us-ascii?Q?RIAUHWkumbxLHW7kLULPuR/CqIfYbLhLV0E+e/38NbkpJjLnrxLOOA3NBxu7?=
 =?us-ascii?Q?ibE5IIn4/Pd0XaF/EyRUpqfGD0MiaBwLSpVyiKDk1h5aro4r95GYfaJEwXpQ?=
 =?us-ascii?Q?ESPnvnQYUXAfjTpuMmaJ4ltkWh6tWA85nAH0IFugFebmFi3ADLiZcg3XcA3K?=
 =?us-ascii?Q?Gd/dno5x7+kNL8o/nOLD2nkKi3WLkXNKtf+WJsWzPNNOTmnpF5RzE2MnWZLw?=
 =?us-ascii?Q?/3xsd7mQZXOFf8gjO6BlYGM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42c5cacf-d5c0-413a-320d-08d9c1369ad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 08:24:11.8887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B8yGUlZBpJG4xYF/p7oWBCi4qBfEXkdjLKBcwRlQewOQleB1Qkwzb+DnFNgOauxRa54TTbvghWBn0o8d1W1TrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Harini

> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Thursday, December 16, 2021 10:32 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Michal Simek <michals@xilinx.com>; Radhey Shyam Pandey
> <radheys@xilinx.com>; Sean Anderson <sean.anderson@seco.com>; David S.
> Miller <davem@davemloft.net>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pc=
s
>=20
> On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > Convert axienet to use the phylink_pcs layer, resulting in it no
> > > longer being a legacy driver.
> > >
> > > One oddity in this driver is that lp->switch_x_sgmii controls
> > > whether we support switching between SGMII and 1000baseX. However,
> > > when clear, this also blocks updating the 1000baseX advertisement,
> > > which it probably should not be doing. Nevertheless, this behaviour
> > > is preserved but a comment is added.
> > >
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >
> > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function
> parameter or member 'pcs' not described in 'axienet_local'
>=20
> Fixed that and the sha1 issue you raised in patch 2. Since both are
> "documentation" issues, I won't send out replacement patches until I've h=
eard
> they've been tested on hardware though.

Thanks, series looks fine. I have added Harini to this thread and she will
confirm it on hardware.
>=20
> Thanks!
>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
