Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5E05F28A8
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJCGsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJCGsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:48:21 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320183EA4A;
        Sun,  2 Oct 2022 23:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664779701; x=1696315701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=osUY6AAKL58r51zbzfKBSC2d8E3b9gRvlhKOzKqUQ5k=;
  b=1ks4amy+PQZzJVepPy4bj78cJzUKlf8lyAyxH0H2RS0/dH9EpC1XUv37
   3OyjOfuI2yaCN2SznnpsqUDrKwCJzOMfafTIORBp6+jJoV50TrbekAXwb
   syiDGXW4GyQ3L6l/uMCV3ujY7bZvu8v5byxo+qcd19H4b3vEmjmAdnRzf
   nRXkaX3cc3xg2fMPJDDG+xr3TaDc1BT84bv+3NWxBChCZdU5MKEmFkuVX
   RC4LiBaXKC7w4k/59rbDA659JOr2FcUQUQzu/zcHYcPyieem7wCYw0uQZ
   vLceAWVELQQ6x2CbSI3wfVBKrvvVPucMjk0XzNDQ/b4CzYeHdgQq9Ekv0
   A==;
X-IronPort-AV: E=Sophos;i="5.93,364,1654585200"; 
   d="scan'208";a="182937416"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Oct 2022 23:48:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 2 Oct 2022 23:48:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 2 Oct 2022 23:48:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqmLKeJItABV1YBOgPW4NIoNxAzvjxCV6ImCIhuy095HKsuDTgsKhU59MwEnAzRIMC02YmPG/T164H2+P/UnJl8mO/BEy6ogVW4FrLUJ4qj/RYCVpzZVSH1thMYmxtRI2Zkl8ZZwQwnwdgU9eixCrBJpenV9Fb0tyC2j0vjTWdeW3JDXgd3Se2jhYabTycfmumccPXMxKoNNAWd+NGIfaW3xn8oFv/WH1oiIE+rMZCSikgzB7mw+AjWiguolhy3ZbBOCf6Wbj9WCTLSlrk6om4uwzaoWfKiG33bPqkeE8Czc0rJtbTGHNE9BI+p1LXreGWXjYX6aLhNFq2yi56Ih9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVqWUZMAXIrlenSI8tuCadItvw0f/qv/OmhRF9wiMnk=;
 b=Vqz7HlMhEZmnS5NgVNxBEh8jre5PFEMVQTaA/mIj/ywjwWZRnHC+PJdEmFh2S8aiMdECjnaQ/I9zSqSmaaF2Wbthjx8btV54nwA7E4fkooHaPqY9GhxqdkqjiQK1onkYrOQySOrKldoGeFKECVOhI/DxjnwBtVPWyWFm58+tGtVB2IpQPHaFLFHNz0zdSnWqj3TY9cVwMZo5qwXtoQ9ThmsKQcHvrOzyTL+XZnJZSSjg2MP/5k2w6Lj6NR/R+hK9h1R3NNJhb+JPGO1n+pV4sfIgtvoaJfc0tP1eodC/fykNZ2Ce2c+wciWHCGT5A2ZGK5w3pindes/sLk7rgkkoUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVqWUZMAXIrlenSI8tuCadItvw0f/qv/OmhRF9wiMnk=;
 b=mmixPAUS/xt9rDL0jSsYu7qDymPBCLkHo2Up/uhnxJZTZQLGxZjLOz9vIAqW7l3msg87/f0yCrAUMn7UcMu+YZ1KUZzgk9oihzEvVly+PVKav1aIg179i5X8l3WzXrXBMKNBPZ+HGrXDd4kscslT9tOLG33VE4dbpwFIp5eew1Q=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by SJ0PR11MB5118.namprd11.prod.outlook.com (2603:10b6:a03:2dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 06:48:06 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::782e:76ed:b02d:c99a%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 06:48:06 +0000
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
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Topic: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Thread-Index: AQHY1DNRRCKA3W+lZk2MiTdViI2XRa335cAAgARc1IA=
Date:   Mon, 3 Oct 2022 06:48:06 +0000
Message-ID: <YzqH/zuzvh35PVvF@DEN-LT-70577>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com>
In-Reply-To: <87leq1uiyc.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|SJ0PR11MB5118:EE_
x-ms-office365-filtering-correlation-id: 0014b5c0-6c3d-4de7-f35c-08daa50b3a12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DEdeJnL9qoY0x5gIRVUtFT3rwBKNM1wTW6MDQGdGRwXYd/7Oz3ua/09rEB680o0LwXbgoe2e9jYOGf+QBDLYWSUdyiD0+ZnG9FGAO7+Q3vN30YeeT3ukr2XjPQ9iug5ij2pt4cVsn4MAqiaN8oGW+3fXmW0EnekvDeupSjhgs6z8UYQOxNp1TPHavqP+gJAwCJMOwWaq3ubiTyvq23KBGJdtiUME9Lo9SoYUZZmigGq76Nb6KZvB+97P31vPe7JWzx/OzbCtWnH9VkVvOER9vfPTPJBehChNbzsgd6sgZWIExKa9UimS19osYhAU3IQ8crxMIa6kjP4EYlVB1HN0FaKn8cOdh8/G+M2e1tZaJHHa9SfqFu/+QixMSb4qj0cGyxHM8GOOoAbkZui/mIJuJfb0U/meoh4To633xM5CqYPE2i73DQJqqsmtB0v+ZKn/Af8utd7FLzfQXtgFqGBeC/ywLgM1I+JmtVS3OgFYBvtfNHAEGUbdG/KkY5MKGLbabH4OhWtjIIm93JCTkRkE1KEnkvhHV1Tw2Xw1/RcDqe8pWq+LCAXlpX+f3PKZjKLrPVcanHF7+7SoufTgB121hOiLbxopFlowkt8/OQZ3g4wBSofAJ/QcHqlxWPJ6oXAXFa1eeLvhbt0Hq9gwOI0/EONn0q5Yuk1TRjYJsn+XUzAQTYrpBcwscDCQRdc9j/OLFTGJGHt5xtmmrDuxP5J5WbuKhTQrDZ2RpkyLNYI2Dy+qicNRgABxsP79j0SDo8e1wGLifZEm55ib5rixro/JSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199015)(86362001)(38070700005)(83380400001)(122000001)(38100700002)(186003)(5660300002)(41300700001)(66556008)(7416002)(8936002)(91956017)(76116006)(4326008)(66476007)(66946007)(64756008)(8676002)(33716001)(2906002)(26005)(6506007)(6512007)(9686003)(71200400001)(66446008)(54906003)(316002)(6916009)(478600001)(6486002)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+PAu7QPEkYZdcOuULnZYCwO++t3U/ugzL9rsq7FPnoyQ++667wl0PA1ya2kp?=
 =?us-ascii?Q?7A59JnrCp17W7GvetFKBKQf7OQX8pfoyrCcmMiG/gVC+Fx+UlmxI+tnuhj/g?=
 =?us-ascii?Q?RxJFTKFICvFOaEpu05H080NyqtCiwe/Xu0GyGAGXQTmi5nE0bhDnhhW9AZxv?=
 =?us-ascii?Q?2eUqt21wI8roWEDLivaxFUNpVoR4fmotYMPvAd9NvdYbZE1KmfJpykoy5wHO?=
 =?us-ascii?Q?+coNTMGvlCX6yqzrl4A11lM4AosufwJJqIZqA8ysFOC9YWGshKmIbap55ZwD?=
 =?us-ascii?Q?zslK3moxgX56y8quBgRa5AVoE9xcj1geGsBGmMJ/lOWKRxPQVPKYgH9FSr55?=
 =?us-ascii?Q?gxBxOYfTzxfVMRxC71upmitqEKc6YRxTRpEKPGZsujdAzEqGgd458Ez+kV2x?=
 =?us-ascii?Q?V4VC6FlyOjzaZKuDf0SXpPorVo65qknNlJUGEm9w+NpTvLoNDPGWFiKN0ECt?=
 =?us-ascii?Q?GLOy0j1gft+sb1VrVCaVhqp7lGvFCfI5Z/hbwdFBbANxFAdCJ5OdxDivgnZc?=
 =?us-ascii?Q?l70nOq0dJqYkNwu1+JUrBed1bjDB+ZQUtgS+IiOPbh3BSwvw44oeHShyWMb0?=
 =?us-ascii?Q?NSIsHroZjVpZnL+DCJQszAruo5fo6+HzgjCFe40EI/ESJiR1ts2s9K7SegTL?=
 =?us-ascii?Q?ctwM4JrgwkO4/uKoZBEiMVzeVjpDgqxl53L8cCvp/WDX1H0cE4LH03j6TOG8?=
 =?us-ascii?Q?ohZsGouxXOF9PnpQ4p7RWFpLPGnT3M+2qbwogoqRDesU6u0SLRKazjtl7Fji?=
 =?us-ascii?Q?UHJiEFMZiOoiIvgDBs9JhJ0EyHPT3Gx2we7INJz1KxBrYDqy4tS1wioqTkM0?=
 =?us-ascii?Q?m/HcJffuhDGbd2s97FcPmEhS8rf/Vt+GnJ17B7HO/nM031rGVOr0HPZCroJL?=
 =?us-ascii?Q?iBDfgv/LMRQMBoA3ZI7F2u7PI+E+Q7mfcRgPqI+dJ7s5bNtvmfO2p522bfMl?=
 =?us-ascii?Q?sT12D2X4oQ17aSgxgoegWpy+ZgzNvcRL9pYZBLvI3x5M2vrAowtd2K6Y8WVh?=
 =?us-ascii?Q?e47IjqFBQQnK9xGRFFfq9dDy9mUbAtL76GeNW1QLfP6LkQXpEY8lSh8XfAmx?=
 =?us-ascii?Q?Z2kP4UGal4OCU1DWSSd6xmNXytLDSwTLutji/ydE73hyn+o/ee0XL8b/FWiv?=
 =?us-ascii?Q?hzqoROrg3nBDczxP1n/YzWW/l78J4JnFAoTjj4bdnMrR+No2IWhir178d4kj?=
 =?us-ascii?Q?QiWs0OVbqHuxgkblGafmQUrhAWOOifs/SHu0f2VKaBm2I++fKGv49nl/6eNY?=
 =?us-ascii?Q?aXNT64jKM8lugT2/lNJG3Bd8TNgBXqx8ufBR6wy2HXJT4PLM4YEpF5/movd8?=
 =?us-ascii?Q?Qrs/F8Wb1kZ4isnKkoMmP+kq2dFbak+hOV02C1zB/7gn3rK5Igz6TI/g4+iK?=
 =?us-ascii?Q?Y+DSAtfuVnPm2JanTN9224i//2siUpgp1wGKA780iPLERKE8UbcUt4MrUQ0o?=
 =?us-ascii?Q?CGHVIPIV5+7c5qOZj4LyFY8kfHdlNcAhfBJks2N1FBMW028FzoyGhz23859E?=
 =?us-ascii?Q?Nf6ZZMiNR1TfC1YCvBbjuSzx6hSAt7VERrWVEjWt5j0bur8XSpAmTTRWHUd4?=
 =?us-ascii?Q?O3THDAMZM8KSxrjezUTdc7raz/Xdh0Zb0qpRx3Maja60SCHw81IwGGEsSb+F?=
 =?us-ascii?Q?Ab0tctuT+pgv1zT+xyTL8Pk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D8D508C558C4A48AE546AC05ADAAD22@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0014b5c0-6c3d-4de7-f35c-08daa50b3a12
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 06:48:06.3265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wNXov+Lfcu5j6ms/RUndQ4dYgFuRElG5khGdJkEf7mhofKNAUGnzGlzPy+PoSriRbMb2XvdYbUHABRE+MJjwii3Nuif0th45pxgTCuWahhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5118
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Add new PCP selector for the 8021Qaz APP managed object.
> >
> > As the PCP selector is not part of the 8021Qaz standard, a new non-std
> > extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
> > helper functions to translate between selector and app attribute type
> > has been added.
> >
> > The purpose of adding the PCP selector, is to be able to offload
> > PCP-based queue classification to the 8021Q Priority Code Point table,
> > see 6.9.3 of IEEE Std 802.1Q-2018.
>=20
> Just a note: the "dcb app" block deals with packet prioritization.
> Classification is handled through "dcb ets prio-tc", or offloaded egress
> qdiscs or whatever, regardless of how the priority was derived.
>=20
> > PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> > mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
>=20
> It would be good to shout out that the new selector value is 255.
> Also it would be good to be explicit about how the same struct dcb_app
> is used for both standard and non-standard attributes, because there
> currently is no overlap between the two namespaces.
>=20
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  include/uapi/linux/dcbnl.h |  6 +++++
> >  net/dcb/dcbnl.c            | 49 ++++++++++++++++++++++++++++++++++----
> >  2 files changed, 51 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> > index a791a94013a6..9f68dc501cc1 100644
> > --- a/include/uapi/linux/dcbnl.h
> > +++ b/include/uapi/linux/dcbnl.h
> > @@ -218,6 +218,9 @@ struct cee_pfc {
> >  #define IEEE_8021QAZ_APP_SEL_ANY     4
> >  #define IEEE_8021QAZ_APP_SEL_DSCP       5
> >
> > +/* Non-std selector values */
> > +#define DCB_APP_SEL_PCP              24
> > +
> >  /* This structure contains the IEEE 802.1Qaz APP managed object. This
> >   * object is also used for the CEE std as well.
> >   *
> > @@ -247,6 +250,8 @@ struct dcb_app {
> >       __u16   protocol;
> >  };
> >
> > +#define IEEE_8021QAZ_APP_SEL_MAX 255
>=20
> This is only necessary for the trust table code, so I would punt this
> into the next patch.

Will be fixed in next v.

>=20
> > +
> >  /**
> >   * struct dcb_peer_app_info - APP feature information sent by the peer
> >   *
> > @@ -425,6 +430,7 @@ enum ieee_attrs {
> >  enum ieee_attrs_app {
> >       DCB_ATTR_IEEE_APP_UNSPEC,
> >       DCB_ATTR_IEEE_APP,
> > +     DCB_ATTR_DCB_APP,
> >       __DCB_ATTR_IEEE_APP_MAX
> >  };
> >  #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > index dc4fb699b56c..580d26acfc84 100644
> > --- a/net/dcb/dcbnl.c
> > +++ b/net/dcb/dcbnl.c
> > @@ -179,6 +179,46 @@ static const struct nla_policy dcbnl_featcfg_nest[=
DCB_FEATCFG_ATTR_MAX + 1] =3D {
> >  static LIST_HEAD(dcb_app_list);
> >  static DEFINE_SPINLOCK(dcb_lock);
> >
> > +static int dcbnl_app_attr_type_get(u8 selector)
>=20
> The return value can be directly enum ieee_attrs_app;

Will be fixed in next v.

>=20
> > +{
> > +     enum ieee_attrs_app type;
> > +
> > +     switch (selector) {
> > +     case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> > +     case IEEE_8021QAZ_APP_SEL_STREAM:
> > +     case IEEE_8021QAZ_APP_SEL_DGRAM:
> > +     case IEEE_8021QAZ_APP_SEL_ANY:
> > +     case IEEE_8021QAZ_APP_SEL_DSCP:
> > +             type =3D DCB_ATTR_IEEE_APP;
> > +             break;
>=20
> Just return DCB_ATTR_IEEE_APP? Similarly below.

That's fine.

>=20
> > +     case DCB_APP_SEL_PCP:
> > +             type =3D DCB_ATTR_DCB_APP;
> > +             break;
> > +     default:
> > +             type =3D DCB_ATTR_IEEE_APP_UNSPEC;
> > +             break;
> > +     }
> > +
> > +     return type;
> > +}
> > +
> > +static int dcbnl_app_attr_type_validate(enum ieee_attrs_app type)
> > +{
> > +     bool ret;
> > +
> > +     switch (type) {
> > +     case DCB_ATTR_IEEE_APP:
> > +     case DCB_ATTR_DCB_APP:
> > +             ret =3D true;
> > +             break;
> > +     default:
> > +             ret =3D false;
> > +             break;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> >  static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 se=
q,
> >                                   u32 flags, struct nlmsghdr **nlhp)
> >  {
> > @@ -1116,8 +1156,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, s=
truct net_device *netdev)
> >       spin_lock_bh(&dcb_lock);
> >       list_for_each_entry(itr, &dcb_app_list, list) {
> >               if (itr->ifindex =3D=3D netdev->ifindex) {
> > -                     err =3D nla_put(skb, DCB_ATTR_IEEE_APP, sizeof(it=
r->app),
> > -                                      &itr->app);
> > +                     enum ieee_attrs_app type =3D
> > +                             dcbnl_app_attr_type_get(itr->app.selector=
);
> > +                     err =3D nla_put(skb, type, sizeof(itr->app), &itr=
->app);
> >                       if (err) {
> >                               spin_unlock_bh(&dcb_lock);
> >                               return -EMSGSIZE;
> > @@ -1495,7 +1536,7 @@ static int dcbnl_ieee_set(struct net_device *netd=
ev, struct nlmsghdr *nlh,
> >               nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], =
rem) {
> >                       struct dcb_app *app_data;
> >
> > -                     if (nla_type(attr) !=3D DCB_ATTR_IEEE_APP)
> > +                     if (!dcbnl_app_attr_type_validate(nla_type(attr))=
)
>=20
> Oh no! It wasn't validating the DCB_ATTR_IEEE_APP_TABLE nest against a
> policy! Instead it was just skipping whatever is not DCB_ATTR_IEEE_APP.
>=20
> So userspace was permitted to shove random crap down here, and it would
> just quietly be ignored. We can't start reinterpreting some of that crap
> as information. We also can't start bouncing it.
>=20
> This needs to be done differently.
>=20
> One API "hole" that I see is that payload with size < struct dcb_app
> gets bounced.
>=20
> We can pack the new stuff into a smaller payload. The inner attribute
> would not be DCB_ATTR_DCB_APP, but say DCB_ATTR_DCB_PCP, which would
> imply the selector. The payload can be struct { u8 prio; u16 proto; }.
> This would have been bounced by the old UAPI, so we know no userspace
> makes use of that.

Right, I see your point. But. First thought; this starts to look a little
hackish.

Looking through the 802.1Q-2018 std again, sel bits 0, 6 and 7 are=20
reserved (implicit for future standard implementation?). Do we know of
any cases, where a new standard version would introduce new values beyond
what was reserved in the first place for future use? I dont know myself.

I am just trying to raise a question of whether using the std APP attr
with a new high (255) selector, really could be preferred over this new
non-std APP attr with new packed payload.=
