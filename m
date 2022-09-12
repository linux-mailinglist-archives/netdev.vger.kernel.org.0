Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257455B5A4D
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiILMlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiILMlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:41:19 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2090.outbound.protection.outlook.com [40.107.114.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8B633E0B;
        Mon, 12 Sep 2022 05:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiaSy75TBoGrMZOVsmDEcXBFuN8JAhADqK5qjRQw0xcpkqx8a02hx2uh24rSdSpxFKTWxGaMdguNthcsoFWbrPkevSfj18R1LUkJxQJ77Y7CfL/ENGUMde677iiron5W3pHTqp4fnfbQzuUGinznGOqUPubMvemm+Gmn9IpANXcPFgkoBdVKATH6j8qBU15Lj9IFSVCr+OV+nyqiIf37Ikh1hh9CWrEnHtr9RTixu1Ndv+BRSSgFk7YyzSrw7PRTc3uazKG24Vm5UACBnQNXGLCuL5N9fued3MvN4oZ6ESYJc38sdt8yDpnBT7/C6NRRhVao5itAjh5FdCdvP4QMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+Q4yHGwDg0xZr6VAN/KcaaH3tarALA7pe2l2APNBbU=;
 b=HCNTNVo/Esnn5E8ahj6RMOkrEgpgyY8tkhxPmdvqNwus/T7QqVY9JMP+ayZNmF4oVa9lQtnxc1tLB67lRqKEs91DP/HpXNk2dCqA0C5Io0IPttAmPZ+kb2JIcj4kuY5VcCCo5buG8Yi0aZ16HJ2q8qfaeoVT6lERp+YTsKunP6jfW3r2pXWW5fr4b1rtgUxBb28eofXGnaB20BQHNyRpQlU/kfdVhShSZ3hMMGlbRUeaHz7VmbwkWbYMZHsK+p+gibIkbqY1NSZQ3X4VSpASD7YdVmDCae+WlWoVunQDQFhJOWpTwdkEfXAQyVwQlOklbEvNW5znY4BOgJhsU5w6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+Q4yHGwDg0xZr6VAN/KcaaH3tarALA7pe2l2APNBbU=;
 b=P86wVNkbhv+vBtpYcrVdOdVJ5h/a2cLXXO89Gl5DmCVOHMsfUhx94eHlYfw94aX1NmtzGgj5hNBvYG+NMVvg7HPnbqN/CqoyKfzYHvpSz2m3AaDY08ubAX3Pc7FnmwcsnvCdmkG4iQ0atwp4N9hKG07770daA+jDDH8+iTaJo0U=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10081.jpnprd01.prod.outlook.com
 (2603:1096:400:1e2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 12:41:14 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::194:78eb:38cf:d6db%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 12:41:14 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Index: AQHYxE/FihGBdu/LPk6xtXUSKRtI763XWdaAgARm3IA=
Date:   Mon, 12 Sep 2022 12:41:14 +0000
Message-ID: <TYBPR01MB5341637E41D6570C96E16291D8449@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
 <202209100156.WIC248Uh-lkp@intel.com>
In-Reply-To: <202209100156.WIC248Uh-lkp@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10081:EE_
x-ms-office365-filtering-correlation-id: 984b63a0-769c-4fd7-8aa0-08da94bc1457
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C2OXx+hhZSjY3yIq9b6QGD2VgD7mDUGc7Mnaqj3yKOk2zvN/LNHxzW9V5QaFspzioGjBmj2L6llH3lyun2qyx8M+MeQE++jZdROiEDMgxTawqxg3Opp58TNGb0l11icKvolFnKT+8NjF85mMSEQdC891gZTvv+6JgE9+8h032aDZUbtJhk6rcDk0j8BI0pLkWHMt3qzxtvtfRAsYuXuBWnsSeXxYQYg/W1pxniX63YjmvUaDkFz5EOa09lStK0V/Bn+IRbRHTedDx1+RAoQn03GtF1Su1R76/S0dEglToR/dTvRcyucFiONun3sqwxEVhAwhLsjvL9K0vtAkr1j4vvmlN7tCdyNrmGBNnN33Vuljy/L6u7KItjZWYEwS285n8kKvhS9deBrFgdejatsmNYNe3xO/ap4p/lki5FKioyXL82LstE1ookGsFHB9eh3AbU15OwW4/9zDyv21+g88W7BCeHarm6D+Ev+pqyaLUB6DGczyVKK9Fg1MSyEo7KwZxGG6/YsZespg5onYqiU/zCSKXu9KvizH1/5mBkIwqrU6VOIjqa/jc//bY8Ey55M2fSv9ZxiA6wiHRjoewRes3DAp3Yc4wnhGGMKFWmI5MVHy67iFdo6a2prloDdepKvg4BCz0B8bFQkNNo5nST2QO3aZ+cqWhnKqfgY8n+qyZeQAUb74h6l8g/O+BFO0mvmVKYXF5J62jKEO61z22p++V7UWTOugeKhfruTrj7E6rNhJD2tPgif2OoJBwSrb5J92kQx+c0KJDiuYzlN2OdYWmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(52536014)(4326008)(316002)(55016003)(5660300002)(86362001)(76116006)(110136005)(54906003)(64756008)(66556008)(66476007)(66446008)(8676002)(38070700005)(66946007)(71200400001)(2906002)(7416002)(8936002)(478600001)(9686003)(122000001)(38100700002)(26005)(6506007)(186003)(7696005)(41300700001)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vt3pJNgzPCL77FZot8vmDZjEggA+iqH3z8+Hs6bes1kzkvHKDfrP+CE0fuPi?=
 =?us-ascii?Q?+u4rXwCKcma68ao9w4YOnAgdFfyF2QbpqxDiVpkChepKJfgm9p+KVhKclFAj?=
 =?us-ascii?Q?ErLi/OddqqSybY/Rs6GD8jpJppWyTApAWnj1GliQF4M1XabO9gFYO/JUvJY1?=
 =?us-ascii?Q?ct7+B+TtlqgxiLYjq8ij2jrXXsul7DXYc46ubEx5vS0bGC7l2kJqZoNdK1oQ?=
 =?us-ascii?Q?rzoEAcdXQfzEgAjB315hiKD4fYcxSeTgJGu26u5iPPFfFZ9j3GHK22fPfuIN?=
 =?us-ascii?Q?TQoqOZsRx1wk+fVGIRZ2jGMtEOiOQEFNgoTeGQgQXaD0NuEJLJ04CnAMsrSW?=
 =?us-ascii?Q?fSc1Ff5meEOVMLWVgsXWZljc/sFxCsNInPI9oLO6kU2Uu2rmjBWZwEJXPJD2?=
 =?us-ascii?Q?3B/+GOXQKSA7H02nmrKgYn9wRJKoDEanPo/Qwlxq4MtN4Eacr62p9RWQjulc?=
 =?us-ascii?Q?HL5ccJU/k57ExSUmJ9kjpWx3vGsKA74DI/6opv642WvOszeBX4hmk6yCe0cO?=
 =?us-ascii?Q?radZWEvwsshwxxyinJXzY9LDK74huN4BhFtiDajmdFLUkrf3mfncBhR+A215?=
 =?us-ascii?Q?xd7aMmeYpVTVgVdrimSfhAL4bsmXyZ9ra5k4IieNTZBelYOJAcwdTq0ZiU7Q?=
 =?us-ascii?Q?MJNrt5Y4Y/tE8xzHBspaBu51guWJny6Z3ar92rm2ODXEpWmT9dZAZcUI5SLo?=
 =?us-ascii?Q?E+t7WW8RrJYyJ98gJe3vVVRwKggeT3X96w2EaHOWRKhSNnA4nSssYg5pcKQO?=
 =?us-ascii?Q?bgFF5XyzYFYFC3d1cQNvPH3+mFgrPKhQjOA0/cLfmcA4n4/28JVApYHxXeve?=
 =?us-ascii?Q?j4aFCspNHu5Id1FShAEH/5p7jZRmNf3bSyhwT2IM1xhmm+R3rGhM8LtiI0/p?=
 =?us-ascii?Q?zXytAfzFXI0bhOGUBcOA7IMmHCTJ6p9VK+s0/i87CdQSugMP+TQubONBQlgT?=
 =?us-ascii?Q?eyXs43RvQCOs9Soz1oLac/1Y0biUQ40IC86G422Rf10RZo7a82tpD296luaq?=
 =?us-ascii?Q?5jp7aFEXo9+ramn4Sa4x9Q38IvusYyD0DEu1lA4ECd1ue83jtltIuCMWuS5V?=
 =?us-ascii?Q?U9q6nL20fD/GKOfwp/FzbB+mm+SqxaK/oXMDZ/nvU5BiQPNhrK0PWfFndPtL?=
 =?us-ascii?Q?RrzWp9y1bFDUCcwpj4P63/K/+h4EhXVPFtxLcT/bIWOoAgKSKTzhrxCbnbe+?=
 =?us-ascii?Q?JghvaQjksRjPsUtXs6BGw2xPJrKYPC4cXJlU/2ou+HlxsJ3Onff3wFHbDKoo?=
 =?us-ascii?Q?f+nZPIPgjBLC8hiRGuyOSPaV3TMcinjBxB5NTV4Y/PSSdUbfOZUZlWguhJ5p?=
 =?us-ascii?Q?xwJ9FhZjpOfiHVmo/4BGyllQFLXNQbC1yWzuSb09ilKVzkSyOhDE0CkXDZHN?=
 =?us-ascii?Q?KWRFecTyn2txgIj2IZ8YcwAog4MLouKAD0BoNaNP04q6bS65R3IxYEAxDyeR?=
 =?us-ascii?Q?wHXTjzOEmkQF8tZuTfpJPnPqY+rBcRZtAXVYWpXGKRj53qQx7Gh9UPoVMvoM?=
 =?us-ascii?Q?TF1vzCphX5RF2C0eILLNavBijPORh0d6Lfe1M95l8rWbVEwvUY3eI9MIwlpZ?=
 =?us-ascii?Q?SHKH47f+4estRaWBCGaqdM2MLc88fPIkoLz8GLf9QU9aOihnZZCYXijmdPda?=
 =?us-ascii?Q?Vw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 984b63a0-769c-4fd7-8aa0-08da94bc1457
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 12:41:14.2234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7aVZ+/ANsjRAk/QE3OTpe2Fc43H7FaOyCskOjIr7ikeYcKK6/T+WI8FzkqH42UQjufJrbLhKetzmWoJ4xlHgVtJEmBgK3EmlEd0M8J5m7l1QunprytRbz0NY0S1pe6Gk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi kernel test robot,

> From: kernel test robot, Sent: Saturday, September 10, 2022 2:26 AM
>=20
> Hi Yoshihiro,
>=20
> I love your patch! Perhaps something to improve:
>=20
> [auto build test WARNING on next-20220909]
> [also build test WARNING on v6.0-rc4]
> [cannot apply to geert-renesas-devel/next net-next/master net/master linu=
s/master v6.0-rc4 v6.0-rc3 v6.0-rc2]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
<snip>
>         git checkout 9c5c4dd0ca6beb269dd0a6ef12c386198e193c68
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss W=3D1 O=3Dbuild_dir ARCH=3Dsh SHELL=3D/bin/bash
> M=3Ddrivers/net/ethernet/renesas
>=20
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> drivers/net/ethernet/renesas/rswitch_serdes.c:16:6: warning: no previo=
us prototype for 'rswitch_serdes_write32'
> [-Wmissing-prototypes]
>       16 | void rswitch_serdes_write32(void __iomem *addr, u32 offs,  u32=
 bank, u32 data)
>          |      ^~~~~~~~~~~~~~~~~~~~~~
> >> drivers/net/ethernet/renesas/rswitch_serdes.c:22:5: warning: no previo=
us prototype for 'rswitch_serdes_read32'
> [-Wmissing-prototypes]
>       22 | u32 rswitch_serdes_read32(void __iomem *addr, u32 offs,  u32 b=
ank)
>          |     ^~~~~~~~~~~~~~~~~~~~~

I'll fix this issue on v2.
- Add "static" to rswitch_serdes_write32().
- Remove rswitch_serdes_read32() because no one calls it.

Best regards,
Yoshihiro Shimoda

