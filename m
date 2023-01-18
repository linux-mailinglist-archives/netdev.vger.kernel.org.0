Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A8671F31
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjAROPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjAROPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:15:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A3F44BDC;
        Wed, 18 Jan 2023 05:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674050170; x=1705586170;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dqgrCRmeHzQF29M6PcQRpGvYtYWHGY1aocV8Imilqxs=;
  b=fOOX4lvHO/1oDHYH2ZhSUFlk7UjSZbXpiO9LcwDaHSZ6vBtlT+Bb1C6N
   GIRQpg8tPvkqww/tUXDcKxP7Nz+NOF97PpepvWK9Wt4sHBctZQJcBYMsN
   vm/sXfdJIjHxr5XmhUMHoUubjLGhvei2zvWTwPS+JORQNEkwkwQNqfl/J
   YyTx7B2PEb56fHcQ2gbF9pDmGFpdngaWBp+VxEAyOhB6m7KeJcjJFh4L7
   Bp2IeSpzIb/UXUwTvWZqF3FM3YSHF4kF+YxV2c5FIqJ+rT76JdnekxqOD
   irpE1RGRdDzXwls9ZTz3NKsaj5DUhs8fH0zKUUMzMPq06KCsTMTht+2nz
   A==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197156705"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 06:56:10 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 06:56:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 18 Jan 2023 06:56:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dG8x/v6HNQDWWptIxND2sN6WsZ/teeNuqsB56c58Nhu/ekry5B/pmez0jDJQUhEFIpr991NeiyWIpdCl00vR0kUD7V4e4k+llR5JXVbImE3FSzJgGbn4znXshBSd6uzxpWc6IjslA7XdyZQqHTa157+YhAr7UYe5QaeHkRjl3TnpXm+geHjMgfHOTUrV0sw1Mtf6rNeZG2+1/bPw2+8ifC9wELsbj9IXF71Umip+5AJmVcletXREnkaHSnPR5sm94Lks6Zx6pW6MHnEqvvvYHJFEyffDMy4cynSraU8JlT3fJ2jfGRVrgIOjX1zIN284hK6/mFM445oIRtpsd/Ou1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUPLKTr4Fu5Foo2s+u1mn3EIctUgwa0eaUfesOXMIt8=;
 b=argLP3KChGCqiofMFXcHZZSYxKPn5OM9dNiE2fs3nDS62qm1S0sO4UyR1haJnU2OnOAvvh9n8n6ZBNOKQLsayho9hCWGkqidVbIum8yEWmKAA9U6sWNGY5y2cqJ6CUKkI6EgkcPeCxGwM30K+BPoVq9UJr2fhPvg0n9lR/ZlYmvarDR3+5GgOOmJiM92Rxyzu+nJVL60jUy0bMofdDQKGtwhzwSh5wyX91Mq9t2nitmJxo0KwZpMm2s55BSt++d1aPmKlbJqmGegJ++jsvW2OtDNA7BCu83wOQTyDW+jV/ZC6SWbT2GQpQO5bYpvdK0b8P8inQSNdsWLIriFigX6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUPLKTr4Fu5Foo2s+u1mn3EIctUgwa0eaUfesOXMIt8=;
 b=IdsN8eGnEI9XVvikNZYvCJyCeAGA8MTDNThnJmFm80uXo3RpNfIkuWPHCaOHfHwZw+1r4FdirLs+9rfD7CsooynohX4sGDGg8sPKgzS66oMXLzF9edMlI1d3RO/MiMwQNkHXV9M7dJ2OOQx5YQ2toHrVERYSGZu1IdkbAVe0tvM=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by IA1PR11MB7812.namprd11.prod.outlook.com (2603:10b6:208:3f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 13:56:07 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::8155:464d:11a2:a626]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::8155:464d:11a2:a626%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 13:56:07 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Thread-Topic: [PATCH net-next v2 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Thread-Index: AQHZKbnEKv6IsE6w70C8Q9TlPGBnVK6j+1CAgAAKK4CAADBJAA==
Date:   Wed, 18 Jan 2023 13:56:07 +0000
Message-ID: <Y8f6dqXGo8ikcQsx@DEN-LT-70577>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-3-daniel.machon@microchip.com>
 <87cz7cw1g5.fsf@nvidia.com> <874jsow1b6.fsf@nvidia.com>
In-Reply-To: <874jsow1b6.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|IA1PR11MB7812:EE_
x-ms-office365-filtering-correlation-id: 00f915c3-4d32-4378-8290-08daf95bbf65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /KfJaegDhPjR9zvjQZT6USOOzl9SAVqeF/poVoJ7M1GNt+dXzh1kVriiwD9SX7bgGDKmDJqgoEtC15ZK95lRkqVnWT4NfTDFRpLfWZXx4f62J3Yl0MKwcB0KvI6z3CNuly276s0vyryFhD84EbinWANW8d0f12RdyJyyewao7a6Msq3N3VyJgciWAEaIiBezOrdI2erxLvEH889O3vcyeg6Tl1SG5M5e1PdRuMBWaToaDp5wni1/fiNcN0O+12sFAmNqbr0bg4glBfCoR2+Evbt/AndY1a8LeI2GBPqH26RbdYn4eUUhaIk7I+SvsjcUdtpeGNzHvTfrMamRnmdV4sx0VxyVkPWc63PKDp76v2OFdFSwwOcn3d3LlM8JkGhSSag1EBW166TGLsXRJTFpL6iD1dtV55x/MwnSfD86DlR7RhRigRrds342vSOxHuIo9VYXy5Xq5XIixoQTbBaZ+NbIie2cthENeWisSQrit47zuKwUX+WEWryJ8MnMPLj4L46n6laU5yBUQeywAvFpXrRgOOOEa8/5qtgcc3Iy4wouQ08yM35vASLzmQX9NFlhZMpOPlVPefCrChm2QXMParA49csbPfAydsLubE1PJPo1tXpc/U3rAPunxf93PN7VWH/BWe4jBidFr2IdC68GIJRyn/MkoMvFQl8THmbTPaPQHrFoib5DGFa5Zo+0uBJmBrK/PGDOtGktMZobO3pVwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(122000001)(6916009)(54906003)(71200400001)(66556008)(91956017)(6506007)(6486002)(86362001)(4326008)(8676002)(6512007)(9686003)(66946007)(66446008)(76116006)(186003)(26005)(66476007)(64756008)(38100700002)(33716001)(7416002)(2906002)(38070700005)(5660300002)(316002)(478600001)(83380400001)(41300700001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ikSHJ7JUpOE3xyhR8MIRRums6PTlcQm5ZIqr5IdZIN6xpzsP7N1SqBoNJ+5d?=
 =?us-ascii?Q?Sd3qB2JKT7mmr3UB2E05HOFKeBx1zciS4iyNUB5ln8V1YbBgWtrP1/2+vJFw?=
 =?us-ascii?Q?M6ktxBAfUu5/yaiECVAXOSuyyJsJ2vN4A2WtL2YM73gP1/KLXsbvOK4N+bdp?=
 =?us-ascii?Q?lcLiuM/iBxIWeGkkGElkwTbe2rR/ILKk/9025Hg2AsHLfa0PwVPc2MXroj1+?=
 =?us-ascii?Q?eXBnc0YnHuRu2jV5V6AX8aEa2NPKk8r8kBxyzlhkuD27F6BNgmeLndSSVm39?=
 =?us-ascii?Q?nn0lNHeI3JA3yg3jbRAxe/HaHXnKtiWes/GZFLuAK3Stq1Nkf1qCn9hQ+pkF?=
 =?us-ascii?Q?TrROum7oeUpbRQsd5OkTW/eZvYMPEE9KzmBHYWDsm2NxZvk82sQ4AHJrJVjI?=
 =?us-ascii?Q?B5nQBO+lfYd0VnL7xzVt4+c2qlIn0H1sSeoRFJq/R7PildgSPyJD306xLpaL?=
 =?us-ascii?Q?lmJ8jvCbUGgb72WKskhTVVMZBASEHoORmHDdHIaPi0btY1s1keI880KCqVK9?=
 =?us-ascii?Q?ZahsBVlctLX59+gEzjzr/wkNJsziFzauWpfh422UnET9wP9bHmf9iOr/VR1k?=
 =?us-ascii?Q?RGREH3kggwxrlfKG369fokYDcHiKvzpNwkih5h8YO3V5c3iv94y+OZVB/G1H?=
 =?us-ascii?Q?yk+J0Kv9nXSm0MasocbfgTyiM5MDjpo1JO42Jnky5RH7wORzuz7IozPP8NgV?=
 =?us-ascii?Q?RHX4hql91WE9aDjPDdtvtH6EHoU5ZRYarO7FQAWgomiguLM4Fp/amxd7JZO/?=
 =?us-ascii?Q?Zlu+IZvU9gkevKgd6SAZMpNrVBvRJIqyVCAfwqWdQwinfCRGQ5PudqtHBJEc?=
 =?us-ascii?Q?azLnQK0VW3Ii7ySFr/W0wTQaQ0gNg3Zo++IAwJ8xFn8GhORseXtLGNTzgC3j?=
 =?us-ascii?Q?jnCqYNbHXSWH8/fsR8C66v7g3Fy7YvHqnH4NGdoY0bwIHaTyWuD+WtkX9akL?=
 =?us-ascii?Q?72tRS2YDAOrw1jD+N8XWnlvjdP8S4l2SoY7rmogjT9s2F3uV8Cmi2m7/508J?=
 =?us-ascii?Q?pFkCCNpymR6wPxComm/5Lw3BK1j2kTdvGdEz5J9wRcqSKoptZhQfnvJY2OBn?=
 =?us-ascii?Q?KW3mcdlWZP1TkQpcU+mh2/vleQpKYYtcCJlD+huElz8xNP3cQCZIAq9P91kv?=
 =?us-ascii?Q?ZQYWSZPtArvAC9AUoxs935sgqagiH23R8OwaKYlI84pOvBsl5O2RODn3oGP0?=
 =?us-ascii?Q?b5xnhAYQJmQrRPbMo3NAtXN8wWxTndcSG7tkmsuScInAOXrTz8Ugm0TufUAv?=
 =?us-ascii?Q?6gAIxJYkcZjatR3HyURj9QvjB0/DXES7D+Dyw3Iy2qiHbEq0wByjLEoJKK//?=
 =?us-ascii?Q?8b3eSEnzxzQR5rR97QqgSknZi5JkDlL3M/kLC2KHIxIUC+5XEvTZOitP/5b4?=
 =?us-ascii?Q?/ewM7/BvFFwzPEPVIbyrP3Ckcqie6a02bmYHTP4qUfywd6tv0nR3lXqVkw0F?=
 =?us-ascii?Q?woDqw1tKsOHeo7sd5TojwRJcRNH7C0tdSa/wNlPpEdpKz6EDtM20bCT3v4XL?=
 =?us-ascii?Q?hHxz7VJZozROSXLLsDHdP4PJDndChnFiajaxubKH96F0lwPzWmksbv1PzeYz?=
 =?us-ascii?Q?PbRPJ8OvOKGjrs4jiS9X0acAg1p0H/mlzu9a2lR1iKEXWHf7UOgn6t6dBRCJ?=
 =?us-ascii?Q?8KL7MF5jywgjDpQLVxbGlRM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <883D2D71D6146740ADD2A74A28764E16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f915c3-4d32-4378-8290-08daf95bbf65
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 13:56:07.4162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rkWcsjhBw5yglkwhwnOjPZPKB23Wmcw5xk5q5xxmsjnjnfAM/d+HANImFfH5Te6FrI/vLiVjY2YR4af9j+D/yUUjP2gB6GzUcy8huU7ufqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7812
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > Petr Machata <petrm@nvidia.com> writes:
>=20
> > Daniel Machon <daniel.machon@microchip.com> writes:
> >
> >> In preparation for DCB rewrite. Add a new function for setting and
> >> deleting both app and rewrite entries. Moving this into a separate
> >> function reduces duplicate code, as both type of entries requires the
> >> same set of checks. The function will now iterate through a configurab=
le
> >> nested attribute (app or rewrite attr), validate each attribute and ca=
ll
> >> the appropriate set- or delete function.
> >>
> >> Note that this function always checks for nla_len(attr_itr) <
> >> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not =
in
> >> dcbnl_ieee_del prior to this patch. This means, that any userspace too=
l
> >> that used to shove in data < sizeof(struct dcb_app) would now receive
> >> -ERANGE.
> >>
> >> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> >
> > Reviewed-by: Petr Machata <petrm@nvidia.com>
>=20
> ... though, now that I found some issues in 3/6, if you would somehow
> reformat the ?: expression that's now awkwardly split to two unaligned
> lines, that would placate my OCD:
>=20
> +               err =3D dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TAB=
LE],
> +                                            netdev, ops->ieee_setapp ?:
> +                                            dcb_ieee_setapp);

Putting the expression on the same line will violate the 80 char limit.
Does splitting it like that hurt anything - other than your OCD :-P At
least checkpatch didn't complain.

/Daniel

>=20
> (and the one other).=
