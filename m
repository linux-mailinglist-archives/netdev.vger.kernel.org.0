Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A4B5F2C2B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiJCImS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiJCIl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:41:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E41A5A837;
        Mon,  3 Oct 2022 01:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664785062; x=1696321062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=T3irsWsG1xPinSS4akIkIe6kFLTF4vTE588H2I4oiTY=;
  b=rzhMC+IVfKwlNdVfmYJk07zFHE7Z91F/dHuRaqV8HaOmo/yOuKxZQJ7H
   fXRBvCBrtOr2QidMPkLIjZGSeScAUCwrlJb2EWW3lDtkkK7q04IKJzboi
   RQLnQBJVLjCoqC3tLb3+sLWiSAMQIYRJ6OTD8mIL1JOMP7q9+FctMdXbP
   Mi+c3WrlVa1STrxEsdBFzQe0MTNwXIVURHsxcAG1Pfxoq6BRitawTzJR/
   /K+5uZK0iRxW4VMVgf9+XuTE9gUNx7Ujs8BOF2/SlRCMwmox/kbH6R3Jy
   AwM7+gLEpw5fYKWI0WfDc/qZmkiiJlmLQKYumNlxe82RCCtTmyA0NnYSw
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="182950182"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Oct 2022 01:17:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 3 Oct 2022 01:17:39 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 3 Oct 2022 01:17:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1mO6c8tvo2GuIi/rYRgPbST3fmwQrFk3EUokA1CkCXKsrUcqkIEDyrp110uYR65RHIuesUVqz+C6dgcRMMlLINATdYPbj5yMKhBTyeXiZRzjB0jX6n6fGgbocIxT8DRDS8Xs/HpwTzQ6lbppsFqUfxrB70ooNLpCH5xLlJ6SEgqHV7yJuR/qsogRJarDrIPdt8qes3dlSj0to30HwZhKFsZQn0D5bFumqd9y6/3Zz/wZyWDhuQwDDsN7/T2LdB9BRKCEBYLGqoz6ZKNYV/oY9vjW0+sUn1ypDC/qEKpv1EQ6g93DIp4FWAhQIWUJN0SuR3Rcm2RqUPFol6gomuPCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTC0zkmxGglhBPttzmq3u0eiFAIhrILlKhoZjCAR8R4=;
 b=kD7l4QxNX4SRWpd6g2AVCS+s4A8YWRS+m+IRuVtl78muRp/4bDKW2p9PcdlnLABteZWi/efR/Ih9T9UOn9EORnxet4YILw8IB/2lgqf8OvZsBw2iEAGIUzgyda6HNb7MojvMZNg4lJVglmfNxfNuYZ9Ms4N+T+h4J8m7jrJni/zCK6j+AUDx04NX4SU1DQ1rXWgtNOb72uvoB8sV1R/06YHX0A6v/MvjduI3RiGxtv6+VBAoULHp1Jyc0Hnq92JM4zy95WS9BihuOGhKUZjmQzTVzNgjDSUVz3fDekTFISWWvDVtgYyz/NeUkP0Ox9WKkLWbYATFHWycz0pmJdcuMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTC0zkmxGglhBPttzmq3u0eiFAIhrILlKhoZjCAR8R4=;
 b=YbIXO3mJcd9+WEr5ue9CnZSwIFA2HHa6ZD6f1i6RBXmT26lvCV2wWjWrVlUOxw4kNt7hD7Q6c6BUfVPMU57bBVGCEWJsVElfISvSyaGIazE8VKSpnh4+MvVqmrHUXT3hWMyrNk2mHpbe8tIKIPa2OolXa9R9rB7Sf2J0uQQh1MU=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by IA1PR11MB6393.namprd11.prod.outlook.com (2603:10b6:208:3ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 3 Oct
 2022 08:17:30 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 08:17:30 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Thread-Topic: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Thread-Index: AQHY1DNZUjZtLK0dzEirZyaNJNiZ+634H/uAgAQj3gCAABBpAIAAB0yA
Date:   Mon, 3 Oct 2022 08:17:30 +0000
Message-ID: <Yzqc85mqkuakokCE@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-5-daniel.machon@microchip.com>
 <87zgegu9kq.fsf@nvidia.com> <YzqJEESxhwkcayjs@DEN-LT-70577>
 <87lepxxrig.fsf@nvidia.com>
In-Reply-To: <87lepxxrig.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|IA1PR11MB6393:EE_
x-ms-office365-filtering-correlation-id: 0de1cbc0-2e9f-4dea-2568-08daa517b75a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8DegA46Id96CryFo2cSQ/ylOJaw0aS7JZq101SLjroXt6HcMH+neU6AYWrqY0shnOPLhlR/4b5uVelY+/tdzzZhEyWdrO9BNqI9ttKSEHp+SZrd0jTKmAeBZ1rMRgzdCcQC9WE+w4eIdR7hJjGUUxFppbnohx4BYwi3NRi3RGBocMsrJ84VaKMcq9A2rZj7azuxdaIrEC9BmFrZWuwtJ+VFtw0IPwiM4oBMNNbU3zb/Lp01dsy5mjm4xbTZWPdVFYm2mfCbhnA3C51MInGKirx2lM/IeetAUkP4YR48RQl1ibp/q/HV2VQmRQHxNHrBtSrSAgG4zEdkU0EESD5yH0GksfI1MWQakkFGfYA5pCtu/+yCuIrwRd09NbtfO4eAzHQm0IW7v470041mz0FXNmtKpyAskAp2RdeiJttc9fR16Sgg5JZkBiMlDjsuQ6ZGzAaVObruQ1d77PlXliVohLgN6eipwZbuIoe2yJcDmIZTu9fN6rYFgUhmqZhhyvLCrbih/DxJLorLqk7HHFtB+YM/4e5t9EWY03OxG/d7Ypc+UQLlRB/B814JG0OdN0Ljskpq7Q5cCtpFh1dXK698e5LuzAd/0jj6fGhOT93UGaPakdvVSOpnxD+UyK4vQHzQkWQel6jQyisedqu1EdP0BmVdFAqoxjzL54K0/62PDy59CpfPEqCAsdl+wWX5EB8cXF0+sEgP2i9et+enJEG+odEazJ9xYyjnPcXvQuBG1Cv8LotwnqmbCson1FanvzfJ22XPMNa/QT/EWC+PtBDXM0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199015)(478600001)(6486002)(91956017)(122000001)(83380400001)(38070700005)(38100700002)(6916009)(86362001)(186003)(5660300002)(6512007)(6506007)(26005)(71200400001)(41300700001)(66556008)(316002)(9686003)(66946007)(7416002)(33716001)(76116006)(66476007)(64756008)(2906002)(54906003)(66446008)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?++L/NxK/LO5EItgK0rIWaQGtJbOyMw7IM/ZtyNbt2ggBUWYqxvvoCC7vg7tT?=
 =?us-ascii?Q?hfRzk3ZUcGDRNC2bWZNymA10XHpGkz/7fMWY9E9BRv3XslQPb9UcM1/9bY0t?=
 =?us-ascii?Q?oIHUndcAtAETScvFu4M+Lbzgn18F2HKtUqCTNR0gC+L5jbDcjtdqoqouf5vM?=
 =?us-ascii?Q?Dlsr+28pllkomJG3wczdzOPJ1PG7XZl/VCubuKX2HCURI4mg3+8MT9pCheYb?=
 =?us-ascii?Q?9In1w1hX9VNAUfX3t/1lQJ/96OufpFskHymum3ePjdGJRCSgtEEI8yfOCY+W?=
 =?us-ascii?Q?rypKfoLbNDs/gfqtKvxy0QjvobowVu7VqfLUz2AaV2J2UflSnsWpdZkammVm?=
 =?us-ascii?Q?qgFkxN6c17uoi69kPB+Y8UvRaoUgbwef1TifjuvHW2LFyvaqsOfQ2FPkIBL3?=
 =?us-ascii?Q?kb2YSHjtqH8iP4cS7IL3KEdGwTWUQiNsqe9XEzQ6aEvUvvn54ZJrWb5cswHR?=
 =?us-ascii?Q?k5X2agApEUxLWDAiJEu4b0DFJS3CCVvuVhuwfUE+GOpe0bFN77ikSjDD1qH9?=
 =?us-ascii?Q?vS3tXAUMtmtuS8nXyulf8/NvbfPmaaGFv9GmxRcBZwO4TYs9fbjVP3S/77Hb?=
 =?us-ascii?Q?w7nx3vuZDSAMU8QGRbERio/kk7kmE74TrR2nUfi3PAgfv3B7+CL4tmraPnmc?=
 =?us-ascii?Q?2sS87MHH581H3Y7cTn9AN9kZed5rj4QqtNtE023REBhRbldq+1KIg2+JQd7G?=
 =?us-ascii?Q?nj6fMe6zWDI2qPOgpZy6Dt5nOfj5H/IZriGQEhXmzb6Ub4I8xpLBpdutKJm6?=
 =?us-ascii?Q?u5Ookb3Spw7YzVlrBdguxg50VkcXvNb/ZRZ2mY13P8iKVs/DEldtWWKScJEx?=
 =?us-ascii?Q?Qb4ep9Yphdyjq9sX7aPZ+NYqXcCMC1kcQHAJ2xZi9MVnpmKfU/cmjH3Ew489?=
 =?us-ascii?Q?G0sDqezRnel8zrQLOfMp933aBAAOrnPQtHC1cMAy2pE9kYhhJCPZECbIT9yi?=
 =?us-ascii?Q?17NLkskuI+tpXMPQEfQ7GO9Mls26PnO3BWxM5X6cgTyjJvhC/bDcbCWkCrhI?=
 =?us-ascii?Q?OSosn8sH+791Sin+1ylLJa32ZGmS+PzXBucAsHahafqNagqUY2HZdWwO00lR?=
 =?us-ascii?Q?BQrLmoctCKLwHt1x6KfBOdNweXM402eE7LR94oDe7kvsrDn+97fqD0wv81JJ?=
 =?us-ascii?Q?KQGqRnhqjsPGrRQLfVRsDtfAIQykaw/mK4HqfXajB53xFe/zdT92SwkdzR++?=
 =?us-ascii?Q?uZQAq7Eu/lrfAjAFACz5lDi/cq2CDHkpiEuniQOpfz6QmnAffp8xMDpeICCV?=
 =?us-ascii?Q?k7aSjPpVqs2vL1dGEw6+od75tTNyUP1KH4SAB6+3lAlzxBkXl6wou0qKsUg9?=
 =?us-ascii?Q?MLYjDjpafT4uv/0eVbRR52ibyjCr3t5b9t1HHmUvij1cgSQZtuwo91+tQsln?=
 =?us-ascii?Q?3S/PCT1b3zMFhRUJwArNdOVPj09Z+nmtRRGiqRS0mDE9EhBzJZdNvjgBKVuX?=
 =?us-ascii?Q?HWI9ymrypRLQw1haXMiRHbTfO4v01g0W9CJjEP97t3c6NAjBkz7MhHs83283?=
 =?us-ascii?Q?E32E99Tb/jM7fHPOXLReJnDVfLVgk8lRImtgAcWKvaa3jG5zdSMb2SxpP9N2?=
 =?us-ascii?Q?tS3uWxhuc3GdLN3F4eVv0PBMOAWZ43fiH8FspgQ323WzIP7ERQU+FOSIrXrW?=
 =?us-ascii?Q?5ItDFnc1bulMHrPLrZijks0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <851C4612D281AF4FBAA77DBF115A39CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de1cbc0-2e9f-4dea-2568-08daa517b75a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 08:17:30.5003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfHBfflbgL56ppc1NVEMG+2wQRUr+FF276Yd70Pj0hzAkjL7Bz4H61TzYhZqxzOMf2JziWk+vu/5MnaKxUsT1408gpzMJDKv+1C+iMcoaGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6393
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> > Make use of set/getapptrust() to implement per-selector trust and tr=
ust
> >> > order.
> >> >
> >> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> >> > ---
> >> >  .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 +++++++++++++++=
+++
> >> >  .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
> >> >  .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
> >> >  .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
> >> >  .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
> >> >  5 files changed, 127 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/dr=
ivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> >> > index db17c124dac8..10aeb422b1ae 100644
> >> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> >> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> >> > @@ -8,6 +8,22 @@
> >> >
> >> >  #include "sparx5_port.h"
> >> >
> >> > +static const struct sparx5_dcb_apptrust {
> >> > +     u8 selectors[256];
> >> > +     int nselectors;
> >> > +     char *names;
> >>
> >> I think this should be just "name".
> >
> > I dont think so. This is a str representation of all the selector value=
s.
> > "names" makes more sense to me.
>=20
> But it just points to one name, doesn't it? The name of this apptrust
> policy...

It points to a str of space-separated selector names.
I inteded it to be a str repr. of the selector values, and not a str
identifier of the apptrust policy. Maybe sel(ector)_names?

>=20
> BTW, I think it should also be a const char *.

Ack.

>=20
> >> > +} *apptrust[SPX5_PORTS];
> >> > +
> >> > +/* Sparx5 supported apptrust configurations */
> >> > +static const struct sparx5_dcb_apptrust apptrust_conf[4] =3D {
> >> > +     /* Empty *must* be first */
> >> > +     { { 0                         }, 0, "empty"    },
> >> > +     { { IEEE_8021QAZ_APP_SEL_DSCP }, 1, "dscp"     },
> >> > +     { { DCB_APP_SEL_PCP           }, 1, "pcp"      },
> >> > +     { { IEEE_8021QAZ_APP_SEL_DSCP,
> >> > +         DCB_APP_SEL_PCP           }, 2, "dscp pcp" },
> >> > +};
> >> > +=
