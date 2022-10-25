Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809F460C2B6
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJYEjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJYEjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:39:51 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2133.outbound.protection.outlook.com [40.107.113.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F229FD2D;
        Mon, 24 Oct 2022 21:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzlxq+Tvx+RhfeZ3RHj2CM7s74lghfJIvsv4Opz67Q6cyv8IaTGmr/amnDFhUhLg3WlTZvsmVB6n5bwdUw5kQVJpjNN34bi4Vcb9ULXie86kVibOJn5/IX2rlUF1+g6BFjOAQZDEoUtZTSxlpkg/YFzVnYZ9YDLyCUf7cRyUuIy/BJUYEhLUe1Ay9bD0FBvZtVANJy94S3WaKZbZv0gSHURo8o0I1H0WbCrIZDWphJLgP3uZhQ2l8iHquBMhmOTMXVXuFHtrhK/bZOH2G3v5sj7YFhWgLKXWwNI3pJSlbF81HPU23+cWsJaZjbOOtvtu40ymtMWUa0F63+H1rXu++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jq/etOaewVJEG5DF5mCZBzWWdwmpAppjZqLHIbYeHGk=;
 b=liNDxgAx/wcLAv7SWTdOduNFPWQIGey/BPmxgMgMggpFYx270Vg+Xw9R3qvGDA8aab70yWW92+pNzsZ2aRdwxIbx9qtpzklgu+TViPeYCiylc0sbFXXN259VNuZXs3KwCCH8kgxU98K/Uj1vBO0FW6PDxg0U10pFNGHRTK6fSjrjHSUjFmtndDeaEBgWXFYWRvCx9QYitrBb89JqAGtzFkXmJ2a6Jirms8Ru9bgIPXwSANlVlcCTJUkSB2L1ugU7wwBXHWnp92rZo9lixDDgrrr5jT3doTN/UybgZLBvg/qvd7hIW/8ApjpKPLvOIg49CPdVGUQsLKUWUncFK5v4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jq/etOaewVJEG5DF5mCZBzWWdwmpAppjZqLHIbYeHGk=;
 b=CcSHkoRTWRg//5qm4D43TtZmRrUuswtYCcu5S+smtuexwkb50t9VITgt+SOzY2bJARPxXRgb6jFaYG8LyrMs444hFUa3PH2TOS1WYVJNkZCt2VDJkWf0EzQBVFQbUk9ooN2M+TeD1USh8OcwnqaGT16wSZQX+J9pSa2j2iHJXJo=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB9661.jpnprd01.prod.outlook.com
 (2603:1096:400:231::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 04:39:44 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::e28a:8db5:ee6a:34a8%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 04:39:44 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHY45W84OTfYE+kgU+A+iXKytdlb64Vg9sAgAgvUoCAANcrgA==
Date:   Tue, 25 Oct 2022 04:39:44 +0000
Message-ID: <TYBPR01MB5341E2B5F143F178F0AFD1CBD8319@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <202210191806.RZK10y3x-lkp@intel.com>
 <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXBT2cEqfy00u+0VB=cRUAtrgH9LD26gXgavdvmQyN+pQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB9661:EE_
x-ms-office365-filtering-correlation-id: 57da748d-0209-48c6-f7ed-08dab642f083
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1XLXwE6Tdm0shCEjYatZsNFMKJ7W8YCu/zVsMUbpCB0uXp6Yg66XMGrrPRkZeL5eMWdw09NeM51ZL/FRNWmkq3sfH5vA4ifY02eKDPADCUyrZQSkOnwkt3Dn2UPGdtDUFDcYWdMb5Os9Wzkquu1v2b6tBCJyvpHUHyRDaQ1HSfGwHKcZEhV7DiRBY0hwXrejxu7gfutcHZmyfLQeBdcPVN+4G0HNVJEpehP+JpSP0Ja/JQ1or6ryszYfVu6msQn7w40951M0WB5MPmjafw60QdaqxGRHoOBDQOm7fbtJX1C37S69MfF+/GOks+g1GCmr4zFP25F+8qGqMl5hvKhFhpOTnf2hhyLyhKFjEm8uc04YRsBACyHtV6Ecwfl/X8quc75T4+aVYSeWVzvg55FWz27b3iiCBfIITHCezREK6XPa7lOOlVp42G/8L+B+kmbuueAj650yxVt4Dio0c1azwAdy8STAgugC3IXuzCcY3z0tQsn6fAkBmJ4if3KYhY0NcU/hSZU6V5UHe6CFx41+XGefoxXaWKpw2kcqC5vm93pSuDPnPm/6YWEepWVPVeynahaQriFe89eV8XihKtrPJkZ6DEDorC05bn31UiaZWVvkE/PBvZWRTHRAjqoHHdRamnYdRBtegaG6ScUODy8ajaM8+jrFJOQrSLZJ6bBlAHU2AmVptwQf3KEYThYx2JbRz7uBVmJ4aBXxx13eJOYJuxcz59kpncrlKxvGQwgreNdNmpMfT9ekOUZXbiPndY6WLZLgb6q6M25w9LGcDY8kcMMmKp7UBPlvOgfUbyKIop0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(83380400001)(122000001)(53546011)(6506007)(7696005)(33656002)(478600001)(8676002)(9686003)(316002)(110136005)(54906003)(38100700002)(71200400001)(55016003)(86362001)(38070700005)(186003)(8936002)(52536014)(41300700001)(2906002)(76116006)(7416002)(5660300002)(66476007)(4326008)(66556008)(66946007)(64756008)(66446008)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?niSBlZy+oZ1Q8xXOdufAGr3ePP2tj00Xl1dIq1K12UjZE/gfqAMFk6uUwRtY?=
 =?us-ascii?Q?UUC5XaQhc4ERXlYcJRH3jnbKzAKufYP9oNhL91MfvUMrb2jZ7RhS65zeAOrY?=
 =?us-ascii?Q?S/ugQpqkqEdjScGF1vYa9wRKbBRDPqjxZ4WNeq3zdkglLRDw6hXocwKBDTFr?=
 =?us-ascii?Q?qE5RmwubDnQQYLpEci4ZKUqyZxF+e4sgLZ6mScKUgKyiNfr3mArmSCu2Y/uZ?=
 =?us-ascii?Q?/lfnaMhqD36eHAkyI2QeM65xEj+PJGpLI55QcViSMn8QCq1Qe6Z2FsHbLXV5?=
 =?us-ascii?Q?ohEYyWMlViDdM7yz+9KseGZCe0mV1YEd7ixZ+BW9XZklwts+Rz88A6ad+3SH?=
 =?us-ascii?Q?+uGmLL7Q/C4dIJKlyZteNMZN6G9eqmWYIYzu+tLZMGByV3cpDPIGVvoKfjXO?=
 =?us-ascii?Q?epwFF3GaqxYhTkOLsNnoN/hWOS/Rdqq9hsYYkkUAdSagMMaDgB4Ch+bIx1Yo?=
 =?us-ascii?Q?exiuaJ+b3wC5Uiq3W+gHQUD5gX1X+3hMoPDU9PEcy51T8gTBWtLC8b3HAdWb?=
 =?us-ascii?Q?EJKLZs4CdcWzhnoqiaWTdm4wR8Utfjjx9hhJMUUibbN+MG8NozkHh6BgoFcm?=
 =?us-ascii?Q?GlRyaoKgaBU2MxPzj4mtg6Niw26MpxSKOPHVYjgUSXCQ5Ee9QbZbo8Mdgw+l?=
 =?us-ascii?Q?Ljuj75LLy5hOoGZnFUhztVeUyO68MuyRE7SwHhHuGtbGwAF4QohA+lCQdp/a?=
 =?us-ascii?Q?PjHp5s4YJO1vZm+Ru4NUEvAxKnKnXNdV/JSW4dw93D21c07ZfscohJBC9D7b?=
 =?us-ascii?Q?pfbxRJBSKXRV3HH6W99uoytyRJUpHq9dhcWVfH8e4YRN9PBjmzSeQQdOKxzV?=
 =?us-ascii?Q?j+4NSFXQwQkrO8VWWSCOqjZoKNN7SsAfKMygcqLkhogEsLzQCAYTru91eJqi?=
 =?us-ascii?Q?nWPWCXjG3kSu+Q36bhXSUuO2oyN0azvVvn0HbcVbyxu46VjM+95b7DLibSJd?=
 =?us-ascii?Q?WjdUMvPgv5QJFzngCS/kVJofRwF9rWJjIvEKNTV8g3gEJ5q8120U+xeb1xKv?=
 =?us-ascii?Q?bZtkFyP/PigfbAoVRgVH6Cs9dKGiBM7T01y73C16xrFnJe4u7GceWbseLHKN?=
 =?us-ascii?Q?MiNOxuG+PM2P41PyUBM0r75mHMdufRed14UIVe4da9i/UuLHgV1jFg5eTvci?=
 =?us-ascii?Q?RwgSarOq+rAgflUmcvVj54wQLmew6lgOMnrh/xuuKCNSsH1aMKmtD6fB32w6?=
 =?us-ascii?Q?kyBTtwrBeQZlgD9j6Orc1Y2s5pKZUwFHtZg48jtPUEfZKaHpWuT0W5owmKv6?=
 =?us-ascii?Q?UKAIgaq6SsvuJxEYWzb8Mx34HLsSPloJ1lLxsO4S6BLfN1QhDJjGLT1C7DVU?=
 =?us-ascii?Q?IcVt6oaEk0i3AlM+wK3+WyiOsDLT654eqEHiUwG/BhhLQEipgZXntUIoxlmp?=
 =?us-ascii?Q?o7i+jGJ/qTtwBIbRLQMvT7+pSC2wNIRPONH4TY95bEjT/O/By3JxpUpoomUo?=
 =?us-ascii?Q?0mGlh9ooO5z82PVNQk1fPuMQP050vZrPM43HHcJL9cZt3oYAR01v0mBJdEhC?=
 =?us-ascii?Q?Sh2t5WxBQVLigsRTC7qp7GHBMOh056z2VsL0KM6cSkmcfVTtjnD7yUZdh40D?=
 =?us-ascii?Q?XKIr9JEBdmZlvZm1ajYJq6dYZZB3aVz4KZHrdxDldrAZvBMf8rmfrjNWG77z?=
 =?us-ascii?Q?IqPKvaQyOfiPDzVmi4Km2x5ND9sBmOOOt6lpSGBBX5ci8WfsTv5vaV9znypJ?=
 =?us-ascii?Q?e0rN+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57da748d-0209-48c6-f7ed-08dab642f083
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 04:39:44.5311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NWK1fMyYDHSf07KBsQ0d4NI/TJPPLBZ6wdrL38T//vqUh4UYaGlvjeLD2F5nk2KNxYTSh8zXNA80Kx/rWy2rx/zTAcgc26yT2tihXaWg9RepaoDDWRvizTxwdW2Xso6h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9661
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert-san,

> From: Geert Uytterhoeven, Sent: Tuesday, October 25, 2022 12:28 AM
> To: kernel test robot <lkp@intel.com>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>; davem@davemloft=
.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;=
 kbuild-all@lists.01.org;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-renesas-soc@vge=
r.kernel.org
> Subject: Re: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch d=
river
>=20
> On Wed, Oct 19, 2022 at 1:17 PM kernel test robot <lkp@intel.com> wrote:
> > I love your patch! Perhaps something to improve:
> >
> > [auto build test WARNING on net-next/master]
> > [also build test WARNING on net/master robh/for-next linus/master v6.1-=
rc1 next-20221019]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> >
<snip>
> >         git checkout f310f8cc37dfb090cfb06ae38530276327569464
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.c=
ross W=3D1 O=3Dbuild_dir ARCH=3Dm68k SHELL=3D/bin/bash
> drivers/net/
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_des=
c_get_dptr':
> > >> drivers/net/ethernet/renesas/rswitch.c:355:71: warning: left shift c=
ount >=3D width of type [-Wshift-count-overflow]
> >      355 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(des=
c->dptrh) << 32;
> >          |                                                             =
          ^~
> >    drivers/net/ethernet/renesas/rswitch.c: In function 'rswitch_ext_ts_=
desc_get_dptr':
> >    drivers/net/ethernet/renesas/rswitch.c:367:71: warning: left shift c=
ount >=3D width of type [-Wshift-count-overflow]
> >      367 |         return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(des=
c->dptrh) << 32;
> >          |                                                             =
          ^~
> >
> >
> > vim +355 drivers/net/ethernet/renesas/rswitch.c
> >
> >    352
> >    353  static dma_addr_t rswitch_ext_desc_get_dptr(struct rswitch_ext_=
desc *desc)
> >    354  {
> >  > 355          return __le32_to_cpu(desc->dptrl) | (dma_addr_t)(desc->=
dptrh) << 32;
>=20
> A simple fix would be to replace the cast to "dma_addr_t" by a cast to "u=
64".
> A more convoluted fix would be:
>=20
>     dma_addr_t dma;
>=20
>     dma =3D __le32_to_cpu(desc->dptrl);
>     if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
>             dma |=3D (u64)desc->dptrh << 32;
>     return dma;
>=20
> Looking at the gcc compiler output, the both cases are optimized to the
> exact same code, for both arm32 and arm64, so I'd go for the simple fix.

I got it. I'll fix this by a cast to "u64".

> BTW, if struct rswitch_ext_desc would just extend struct rswitch_desc,
> you could use rswitch_ext_desc_get_dptr() for both.

Yes, all rswitch_xxx_desc just extend struct rswitch_desc.
So, I'll modify this function like below:
---
/* All struct rswitch_xxx_desc just extend struct rswitch_desc, so that
 * we can use rswitch_desc_get_dptr() for them.
 */
static dma_addr_t rswitch_desc_get_dptr(void *_desc)
{
        struct rswitch_desc *desc =3D _desc;

        return __le32_to_cpu(desc->dptrl) | (u64)(desc->dptrh) << 32;
}
---

Best regards,
Yoshihiro Shimoda

