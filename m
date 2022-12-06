Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DDE643DA6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiLFHc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFHc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:32:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E01F585;
        Mon,  5 Dec 2022 23:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670311976; x=1701847976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JDnWzWk/On+IeTTBQchNvsk2btD8I+nKjEfdgZsjTvU=;
  b=PbXOa7kPfEbPcFeC6/3lvoLQnXk5yjX6b4WxFudI0XegQd3yTtr2oHEi
   udmtZRZo6z5OclvD3ZK0qekXg7HnO6YeB81rjVwXi4PDOKO6dag+SAQ7K
   7ozgIx17Jp6Gfe3hPQwKGp6rqmQg2Nmgy0p3AbCPnHQQ+OnXInRbFV/5+
   rcev6j0GszAKed68TTtDFPv+rV2lcmaWDmH94sPXorHHtkoeFG1z5BChO
   +YjiSF0WQkCl4MmGTLNkxOV6leKakEDywgUv8G99x3k1h6QwOwqt1jopH
   ErMFs6WBp7Ke6XP7VaDHZ1ac0ozBZVc+mki+hx7McVpL9HlwmO145Dg/G
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="186719222"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 00:32:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 00:32:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Dec 2022 00:32:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVVjPSRkT3/qWbdf98ayL4aroWiuqgOKkkrmR5Z+70vijhczWS+W8pbycrZEnOa7/5j0EUHagmYF9+3/EvUOeeuj9xS38my4R+ZxKdbcCXraOQTIrGWJgVnA5byC8/tpSYePQd6Gn+Ue0T+VSOmV7wK1UXRKDeaj/O41NZh5rsdoK+SW5KvGAB8NgaXugODqb+r4SP8JbzlnOSrWz+VRFHbrHDC6ErDEA4MSqfuUMrxCkyqMb0adx1o3SrTWAhLWL8iIBWEH1R8iWq53M+dibodl+8CVNFGwtTJPZ5PJDGxka5EMdB2PlWQdvZNN+6xyxC0DQduaizsIgB83dbVLHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKnMNpGlJ56kyyTkn7QyngXcSAZoRNrrJXJkbhRPj1E=;
 b=DZLoSMWk4pDhiP2C2JPTuZq1Cm8BD3AT3RuTTQyib65yLKFnZ/3caTGgwvVGhAPb1up5GcuCaC9FdgFZZXVKvZ6EjC2JTZScfvWClJHdUy4UkIFZy+KmNiwJQ54pPB2Bg6Q944zQXjLCGjISwW5dTitq7qmSzpquyVPft/i3/mZPkYBtQm6Skw41uyvuxMyDN2n4Xj/dXmhZZsWEjBsnBVopXdLBeawnQI018ovIieekP+6HKw6+kEI7bDxSLo41rLOzBCc/9U/LV2NMRkWSRjYEdOKF3yc/Q9S8Pz7M167iLZFThgez1Ijvy5VYXE3gzULDvTQOx7IL41PG2E3eFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKnMNpGlJ56kyyTkn7QyngXcSAZoRNrrJXJkbhRPj1E=;
 b=AB02NoAXWtZkqEQbltNyOod67YEPU3rFt81d8oHVSZtsqWO9sZoANCmKfktEjePfENUNI62RTBFFXVjS6DPNAMhiSX0WisN35LR3IONME1k2pYuwDX8gbEfkWchvvK5GEbUIgE3PnxZdcvtTJxZO1sigJFAxHf6cTgZwcWFfVU4=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM4PR11MB7328.namprd11.prod.outlook.com (2603:10b6:8:104::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 07:32:31 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 07:32:31 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: RE: [PATCH v4 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Thread-Topic: [PATCH v4 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Thread-Index: AQHZCJVqIZPw2JVcBkmfFVdUaVU49q5fTBiAgAEsSUA=
Date:   Tue, 6 Dec 2022 07:32:31 +0000
Message-ID: <CO1PR11MB4771E12DCF6D65E568627489E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221205103550.24944-1-Divya.Koppera@microchip.com>
 <20221205103550.24944-2-Divya.Koppera@microchip.com>
 <Y43z8+grm/TM3ype@lunn.ch>
In-Reply-To: <Y43z8+grm/TM3ype@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|DM4PR11MB7328:EE_
x-ms-office365-filtering-correlation-id: ff544ad5-184e-4ca9-d3ce-08dad75c0907
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JoLL+pvV2JmLgOnPVKYD7Vvv0SA9t+NZnE4xyxQo7qabjz2xlI+uGIvHK0YrfQ7gPHAXBJBVqdOA/W6NOEokQsJBTY1ismlyfqRoXhAO5NZdsDG5K7zbnQn0zjc0D/dx2B0FOjn3aCSPJ2rBovzHhHHdL1xy7rDiAv+uoO7Oz2vKbI1xIbS4Pfp+lPLpRXzqLcGZhj1RFD+5otJWi5Us+a8sZM5qdkiP7lfeE3QL/86YQrvrCihrdSy4iWUV36CPDzTxPcx2tGHov3I+Kyjnxtpu/HEt7+tY7UNjIPUVvYPJj5cM28PrPlhhLyjg1W9ZgK6BAHvyQNCs5Q4saxWXorzViUNa6nDtHists28gOFnxCXnwqtdma+VA8lfSRYc2zGrEN0LJXechSc/WDq1cOmLLYMusYl7xLhpAqJ2wrK4QmToAtcu/1Pkwt9oIH9zJn4TIoeXzN0y5zI3e9bbPrUH/V4GmLHvRcQt8pdKuXC3g54M38Mz6t6v/NvuYGB7Enuf1LFqpvQlzxy4fFTqj5WfDuycfOqMBOs1J6StvFAwKzZRUj7nvJSLDW+/eC1RA2N36XkJy9+1Fs47+NIhj9lnUB8NKngx4rI+pMdDjIW2RiMfvYGdbBQI4TH2usJJ5YWNxrFuLKgtJI2R9B/EoECjjo3X0qqRffkR6DcVSRuCOV7W0o70LDyFKanY+BKxCpe4mqNpe1o7J5Lx1rWUiPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199015)(5660300002)(7416002)(64756008)(66446008)(2906002)(8936002)(316002)(41300700001)(4326008)(8676002)(66476007)(66556008)(52536014)(66946007)(76116006)(71200400001)(6916009)(54906003)(122000001)(478600001)(107886003)(26005)(9686003)(53546011)(7696005)(6506007)(33656002)(186003)(83380400001)(38070700005)(38100700002)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0NxXy2eQzWHBAB44DfgvYE0VM/PV+4akSUnuuyUOZ2UWsGZUUAnGlWCdIjw?=
 =?us-ascii?Q?hUPaYU9lx+8f8yp0QXTCXBJ0GiU6HihoRzJzuvMDdDI3Qpu4zvc3HTaPKr84?=
 =?us-ascii?Q?YM79sYPS+LAt9jmaShZygWEedqM5ri5DtrynsQRmD9bgwjAe4LHvsgKj8fbl?=
 =?us-ascii?Q?N7QnsSt6mUoH+S3yL+vZSELfRq+7aT8WtZOYOHN3JgLh7keONkmN0RxydcHb?=
 =?us-ascii?Q?HVfHxHZqrV+e6KLa4GQBmCiKIijOfk1M+yWs/MI212QPkbmFrSyzuRNZzLbh?=
 =?us-ascii?Q?fCmeD6lPMAfEtUlYQVkX4zRBuREF5OvwAswcFvdIslvau8iG6APoLv7k9KUh?=
 =?us-ascii?Q?rmkvON1+coKhpYNv5FlvjwA0fjJ0vC/W4Qb5mezsf5vVT8XBlrQzfF9HgqCr?=
 =?us-ascii?Q?2IwK4QS9H5S84/Rw4SzzA7B0lzScSNpe0TVepHpvK6uXBjQFekxSF3vvwNqF?=
 =?us-ascii?Q?I58IMdsouNxeTqakT89MB1dbZZTVLq1V3RVnSLhwtRP/1rTaP4kgMBWG3571?=
 =?us-ascii?Q?17KvJnBHVEIJPLGMzthkl43cPvKSxXf6fvT2BTaPqkUoHX36HO6reopYNuQx?=
 =?us-ascii?Q?I81VjvwuOR5mPiIPEJqFwaZ0mprWuYjEWyFii0/uW2LNiUibNj/yQI4mx6xF?=
 =?us-ascii?Q?lhnA07eEm0kMnoUFIXkT86SeEUq0vtmZpIH4aq9PlkiEmlYKsTg9NBBmkTXh?=
 =?us-ascii?Q?aQ25wiQcQz/uIv9eyJvcMM2GVrI+3zyfC5EWAusVWMxukH8mzgwz6dZemyDD?=
 =?us-ascii?Q?yju8EkyJWmEjlRDBztGLZalx4GtsBe8cBThWltKV6RXN4OxGje7pTmQ35iL7?=
 =?us-ascii?Q?IChwVfeFEipafRzeDmHcpYP0OhXhJvBAqiAdDuW7s/wpyxQrfd++ZreJ75q4?=
 =?us-ascii?Q?PMIqgMhkb4dvTMV+XbH4rB01zBook5/2hIerw7IpiwjzsNcybJkBw24FDhf/?=
 =?us-ascii?Q?Scq+S3qNXYBwLAip9K8Bt2xlo+Zge/COEld72pMnqQiDkYSGOA97Nb37O2fl?=
 =?us-ascii?Q?6w6zh/QoABOhh7VCiORYnJTnptUUrYMnjCT2LiYxLkkcMdma/Nyt7uPgSRFF?=
 =?us-ascii?Q?hTgJIUn2INOV9pJtpT8lCMXFPFOBC4u//pUKdngEIs15ITY/xKVKXE6QXkAq?=
 =?us-ascii?Q?PVHojaDnLwM4pUBZW8zVmDs0gIe9YEB/9jpcYkRPlIDDy6aFloJLLoI/rMcv?=
 =?us-ascii?Q?ChhmwMK/r2LDoyA1VqkRUhXJDhNsjk8s2+rEAkn82oA2DUbRjo6wWsiH0Bd6?=
 =?us-ascii?Q?Nwc25d044HIYrvj4AQhcD+Um6i0JZ4u0cgluREGg7P98ZjfCNWRbzyDvyTFI?=
 =?us-ascii?Q?+GH8ILTyEs/C15aNzdfl/ThUQNST6wGKQSmPKyhcNQOtVVltaU/TK96jRfsz?=
 =?us-ascii?Q?t0dCClDJ9Tdz0U7PLZcbgRMkfYy9DeIp4Tl9GUYIfrGa9zGbiXi1olP0PTUm?=
 =?us-ascii?Q?COiY5HUvj/jfneYSFGwHtO+tEPYdF4/+JUcNU/r+8SGK7DNpra69fD3EQHT6?=
 =?us-ascii?Q?XX1OS4wg26tahboVTGB8sJjit5b1OgV8PJyAHYSwISaJoWyXx2LOqW6udyuT?=
 =?us-ascii?Q?MpKHOIxtkVXvCJYf8jTkZw+09Fiv+j3SASgJfzAUEuSR+7BntSAUwJfYRXuN?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff544ad5-184e-4ca9-d3ce-08dad75c0907
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 07:32:31.4192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xd1+1IJPsJUwj/yHNenOYhfmNRJumOjufcVtIZQrKt5RGqO2KeBtWrXrEPo4UFKQquLt+TdE8Q3sO4HOTeLCdeiFMV16sJHccnAYRHc5cOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7328
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, December 5, 2022 7:07 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> richardcochran@gmail.com; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Madhuri Sripada - I34878
> <Madhuri.Sripada@microchip.com>
> Subject: Re: [PATCH v4 net-next 1/2] net: phy: micrel: Fixed error relate=
d to
> uninitialized symbol ret
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Mon, Dec 05, 2022 at 04:05:49PM +0530, Divya Koppera wrote:
> > Initialized return variable
> >
> > Fixes Old smatch warnings:
> > drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
> > uninitialized symbol 'ret'.
>=20
> I guess this patch has been rebased without the smatch warning being
> changed because line 1750 in net-next/main is a blank line between two
> functions.
>=20

Yes, rebased without fix.

> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814
> > phy")
> > Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
>=20
> So once i looked in the correct place:
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
>     Andrew
