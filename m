Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236385B6A33
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiIMJCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiIMJCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:02:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685D45C9DF
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 02:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663059690; x=1694595690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LwwPQ+g9MjGbwcMT1PpUY3Cg6gQt6x01OWT8E+6Xl5k=;
  b=xEouVc2DvGzo6JZyvmvNurTtCu1AQfGxLPg5yPck/ok2uMnp977uCksg
   cnqzFnJJOhqBMRMI1JKm7RJrQuSRyzLtN9yrxJTUR/q5DnhYTZun3/eDD
   j9HO1LQmE04t1MKHyp3Pg9lKeamoUotE/Lc24eoI5TZGSKAupnSy82hhe
   8UIcaOlZU1fqucuNh47tYBIc6LRxkE6ytYamx1D2Kgp5Rruc1mKkFE0Jp
   fzL7AP8gEb9IGnoL7kYBkv1YlQ64+XH7RHtQ08XBp3DdYPwHcTOjKiNoG
   7yv15UX7emvlvBRNoYV46x1la4SDH4O3ewSCguDOTWS7wRlASS5Tpdm+F
   g==;
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="113393612"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 02:01:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 02:01:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 02:01:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAegupalUk4mY/5cGU6UVGMcDtHbFWzJMqVzDEaGNCqzvBiggEoPH9jpd/No7JkjXObfIyb6d18SEVZ4SaIWPtn4QlJSl1ipAlEg7XoQWhv0BSXyLW9plIcjg5cG+m3+mMk4h5+mgh2nW4uyNr3FAg6dNtXG4TI4pS+6tBxtoLcbMPmu0IC7WH/B1QEK/RYuLBBSwfnfW3vMDDbuXzpKbb/pnpdbjsFhNaDV0+6wkjrf3dfNASK0sFtcdFtHCI6ReEAezVigrnhPPjxkkKrQ6g0/pfeCTDQ7drkGPVwG3d6I+Tq+bJblAD7853KSzJvAR0zZ/q3WiaBVbtOPI6nbLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBGsMZ0ClQBEGmlQQLs5fXklVmjpqN9Uc2OBZZXnxSI=;
 b=CU/DWRm+MCqiXTObQKgXXny7VJ9ooYJgEizWyHMBSdrbwxHH8m4sdicOif7NuRhP7pU3ImHNgQW6f42c1oKWxty30h7wmOAcC0TVcpP6Wc3+A5gIZM8DgdGypsZvtqzjOHrvPLxNpDS+3jAsAw7s01qFkm8zR3elyByveFLW1nhES15bSw+hD6aPs6scwfKLr1+a6yyyg4RsSSXuM1gbRCtwczMjcPUjb7fXgYIhNOLb1PFcLqbf1IIP87SG0UbEA3Zu2tvs+kUy+8kU6CytMPxsDz4wNPEeSk2tp4sSWiVOv5qkKZAi+QKdNtHf6r3E+0C7BjGFgLadoyP8NyxuQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBGsMZ0ClQBEGmlQQLs5fXklVmjpqN9Uc2OBZZXnxSI=;
 b=fbI0hLhtoI4suQ9nfx0PPptYHB9JSuEOOpuBjPpn1JTf/hufscDNvj+//urKWVMJ8ifnUPkdPtjPIRYmhIBKT6O0N3n8kbhK0gn9M+As13ZfA89Mv2mk8+yrPsUHOaphn/njIuve0uSCI2Cp4Bjx9LH4A7Wc8CtAAh696/eayLo=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Tue, 13 Sep
 2022 09:01:07 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 09:01:07 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYw3oNia0DwoNaEEmN7eTvM5DvRa3b4cMAgAE4lgA=
Date:   Tue, 13 Sep 2022 09:01:07 +0000
Message-ID: <YyBI/tF5x+3OE2dB@DEN-LT-70577>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <87czc0efij.fsf@nvidia.com>
In-Reply-To: <87czc0efij.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MW4PR11MB7056:EE_
x-ms-office365-filtering-correlation-id: 93fa6a5e-f3f6-4b1a-3c3b-08da95667eb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4n8wncOqMRy1i8T9Q9ut4/BmKeOWiibyK2RmQd23M28mfydxwT8xnbW4rwqL4jNcuqaMgaZ2PO6jGOj9FxMGeDYsOtulpdMGcgjVzLukMsTJZIdAgBq0seWGWomu82CtyCoVYJvYkaX0Qs7385/7Toob0bjyxpv0xidu63UfkFh4oXdczX1puf+Yul6GSL6yzrNbiSgOb7G3cRKtiUZTa5pGT/zfojdcbIUrA9U5PO3CARHhIBu6iyPoZBfWQ+EbSCTwXhecJ9e8eibtS45NGb2viOBRj1EEYov7gYSgD0wZ/yRh7Kh5yDUh38SUWL5y7spMqQYDqcKXwP2NwXow7ZwFBUoZVh2NFHe4d4AFfFGTWG62U0n9vTFu4ENAu4LeJt81ZsZA9cTbAtoIHuGT5N4eOqQvZB2Y+8uvNd6U4O/VneNgu9zCqzqnU5kRMHhhLU8sKdQWmI6co3w/bkyWDwDGTT0M5R3m7quaiYeTHKmcB4xy4eMs7pyjfwm6e/lIRyA1uALwcw3wUEH50JCe9dcfyyAieVh1LUm4iDneQxomm8Iv/24CdOmfzQ4RAqY9hG1VHDPFw/RDb7cqam6KuQsGtGNRclrhKOPfvfla0xWnaz9DZre4jZLvDqP79zs8voQzipr+mrahFu+5HK2rbm+LHHfxU1d24FtRpo4cQIVajRzagE/5ANt4uFqVMOEsS+/CSL4lUgBXyyjYLdcdXHY/zp943cQKeAMX9UKDHlmWNrx6RtyGF0ItFhGEVqVocL3VUZmcqvLtlClrFYlopw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(41300700001)(6916009)(54906003)(478600001)(38070700005)(6486002)(6506007)(26005)(9686003)(6512007)(71200400001)(186003)(316002)(83380400001)(122000001)(86362001)(38100700002)(33716001)(64756008)(66556008)(66476007)(66946007)(66446008)(2906002)(76116006)(91956017)(4326008)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3WVKqOfhBTuUYEcDtPJoLxpjguhZrBMu12zh0HVXPAOFy44A6oPPt3WhMzcV?=
 =?us-ascii?Q?5LFLKI4w3CsP6kxVMOZ/o3mpfEFHmLF08gn7ty+be99ItKrhjXPCCocz+0Zl?=
 =?us-ascii?Q?Oyid0R8iEEXsw9J9IylBD2AZnlVaQzD9Qg77Of4ijMwEBa2ONKOHHtHbJ5d5?=
 =?us-ascii?Q?wauykTXhXH9klt7FzazpffE0pQ2cqMufBxo4T6g4Lqxy4MTlFwVCovibwuNZ?=
 =?us-ascii?Q?HweiPsBPSp3pvkNTKwl0UhxIL0IGmAOqMcdiyqtuWsGa7i6ILGMXjA/Dn1O+?=
 =?us-ascii?Q?KjeTbc3o+UYEmzVcELqnza3i5zzhrrMerF8Zj/C9WaYertFPTgYVvi21/Mwf?=
 =?us-ascii?Q?/Hc71QrRn7GgxSpx1Me0N+AoXDzzSkreOGy7a+a63dNxLntoDOG0aFcz3Q31?=
 =?us-ascii?Q?gEfb1n/GHptjvTmhVtJ2Z7uXM2tdM0Z5J/ZKm6cqur6MX+bkg/5bnez8VhKu?=
 =?us-ascii?Q?Z5nPOIpqC64tlmaevE6JKttOqXwRO/kbgHVHIUdiQt5kO8gJU4Xp9p60c78t?=
 =?us-ascii?Q?JYWQ1lzEbJsXkqoj7WIfHZZpX8CuCJHSyWPZZvD7ZDW92LzU9eyN7qriOk81?=
 =?us-ascii?Q?BDQzEW9XYdqO2BGtVSGjTwxtgtfCvAsz/Z5mzdvLA7trCsGzvpatCJnTyYJO?=
 =?us-ascii?Q?FICx1PmbNKBl/XJoG2IFBF7PSsQYw1fWZtiqyoj39vVtjsjJTYvOFIqeJOJN?=
 =?us-ascii?Q?yi2iWfwFiiG6JL9IIuU9N/MN/ivipP97QWLHM/k3cbzNcCFq4fP9duGi5d5H?=
 =?us-ascii?Q?8ab8qC1VM430DiNYhzoFQ34cLIkrw2V2lJnUsBQudrUUwKQ41cXQ0/wseSXw?=
 =?us-ascii?Q?evLUHu2BiaJc4k7UnI1rAnOhzmYK+m0bV1I9oEOnGpIQrf3FMHu0o+RZuoCK?=
 =?us-ascii?Q?wGEPlIxtIrTxYHd7raALHmw2HrlKynt/5O8K+05UGhGiZKSKDhEVtACAJ8Zd?=
 =?us-ascii?Q?opfgMKzJ3b00gNfBbjgJ3IPn1mEt8MgCLTc5KQKEnGBCN2910gnaiMCFxf5x?=
 =?us-ascii?Q?q6UAVsiiqjoi6hKM/wJYm+tIIYJVxeh1mWdBcQ7l47GgDYB3bBmjyau2f46n?=
 =?us-ascii?Q?YAeQtB4Xwv4+kr8tmVfywuIa98YIR8KtjGRBXbcIO5p39pMlCms8wqmiqE57?=
 =?us-ascii?Q?/jtOuVWlGRhe4SfEdzGSrMKim4aOpsLjkUNe32U7VU4lTDNKQSbuDo0PS42q?=
 =?us-ascii?Q?ckXFh/msJxOeoy0GA0rVtpzkl5P/6f7X4SHQO1N/GRzFEB6UjH3wiXWlJGtH?=
 =?us-ascii?Q?871WxP/zszgMl5cA6yeOpRaxEXUSee0q+CSKNr2NyqpqEcPeRq+MG5XUtKCY?=
 =?us-ascii?Q?bho4zOw3+a3TCtANw5zM5R2TppI52fPQrzFgvYOs8eRSkbvS6CJA5u/xBRJa?=
 =?us-ascii?Q?AaWE7l4ScYEIY6ARGd+WFj2y2iAZ/CRhVsDjw4avHDs61cGUluUkzdNVZN6+?=
 =?us-ascii?Q?H3VYu12ISRwk5jpvg88iCFlQV+6pRqIYllRtYA3z0VLuOFu62ff/f4aB5/5p?=
 =?us-ascii?Q?ccLHhAZe9LuaCce4YKGILJ54vX1ANaQE8noErlyExlnkoh0HP0sS8vafJR9N?=
 =?us-ascii?Q?6EpGa/q3+TGo+5GAA0V8fZwc4bpYxx/tPEHZPq8TGqxdBp5SiCb1bVEn+nND?=
 =?us-ascii?Q?Ia2bt85wlm2u4kWXwlRhpnI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5510B1B3875B843B169BECA9FC3E6B5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fa6a5e-f3f6-4b1a-3c3b-08da95667eb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 09:01:07.1461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/lQ7ZRVOTWGA3MMULj9HrYIOS8ak4iyDxBw6/NgcJOZySc4LqrjO2OHbrgjq/+O0eCj0QtH6Obg3iSd9nTc7hTyumIwgH+eINNhsVph60I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Petr,
Thank you for your feedback.

> Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > Add a new apptrust extension attribute to the 8021Qaz APP managed
> > object.
> >
> > The new attribute is meant to allow drivers, whose hw supports the
> > notion of trust, to be able to set whether a particular app selector is
> > to be trusted - and also the order of precedence of selectors.
> >
> > A new structure ieee_apptrust has been created, which contains an array
> > of selectors, where lower indexes has higher precedence.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  include/net/dcbnl.h        |  2 ++
> >  include/uapi/linux/dcbnl.h | 14 ++++++++++++++
> >  net/dcb/dcbnl.c            | 17 +++++++++++++++++
> >  3 files changed, 33 insertions(+)
> >
> > diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
> > index 2b2d86fb3131..0c4b0107981d 100644
> > --- a/include/net/dcbnl.h
> > +++ b/include/net/dcbnl.h
> > @@ -61,6 +61,8 @@ struct dcbnl_rtnl_ops {
> >       int (*ieee_getapp) (struct net_device *, struct dcb_app *);
> >       int (*ieee_setapp) (struct net_device *, struct dcb_app *);
> >       int (*ieee_delapp) (struct net_device *, struct dcb_app *);
> > +     int (*ieee_setapptrust)  (struct net_device *, struct ieee_apptru=
st *);
> > +     int (*ieee_getapptrust)  (struct net_device *, struct ieee_apptru=
st *);
> >       int (*ieee_peer_getets) (struct net_device *, struct ieee_ets *);
> >       int (*ieee_peer_getpfc) (struct net_device *, struct ieee_pfc *);
> >
> > diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> > index 8eab16e5bc13..833466dec096 100644
> > --- a/include/uapi/linux/dcbnl.h
> > +++ b/include/uapi/linux/dcbnl.h
> > @@ -248,6 +248,19 @@ struct dcb_app {
> >       __u16   protocol;
> >  };
> >
> > +#define IEEE_8021QAZ_APP_SEL_MAX 255
> > +
> > +/* This structure contains trust order extension to the IEEE 802.1Qaz =
APP
> > + * managed object.
> > + *
> > + * @order: contains trust ordering of selector values for the IEEE 802=
.1Qaz
> > + *               APP managed object. Lower indexes has higher trust.
> > + */
> > +struct ieee_apptrust {
>=20
> Trust level setting is not standard, so this should be something like
> dcbnl_apptrust.

Ack.
=20
> Ditto for DCB_ATTR_IEEE_APP_TRUST below. I believe DCB_ATTR_DCB_BUFFER
> is in the DCB namespace for that reason, and the trust level artifacts
> should be as well. Likewise with the DCB ops callbacks, which should
> IMHO be dcbnl_get/setapptrust.
>=20
> > +     __u8 num;
>=20
> Is this supposed to be a count of the "order" items?
> If yes, I'd call it "count", because then it's clear the value is not
> just a number, but actually a number of items.

Yes, this is the number of selector-occupied indexes. I dont have any stron=
gs
feelings on num vs count - we can go with count.

>=20
> > +     __u8 order[IEEE_8021QAZ_APP_SEL_MAX];
>=20
> Should be +1 IMHO, in case the whole u8 selector space is allocated. (In
> particular, there's no guarantee that IEEE won't ever allocate the
> selector 0.)

Ack.

>=20
> But of course this will never get anywhere close to that. We will end up
> passing maybe one, two entries. So the UAPI seems excessive in how it
> hands around this large array.
>=20
> I wonder if it would be better to make the DCB_ATTR_IEEE_APP_TABLE
> payload be an array of bytes, each byte a selector? Or something similar
> to DCB_ATTR_IEEE_APP_TABLE / DCB_ATTR_IEEE_APP, a nest and an array of
> payload attributes?

Hmm. It might seem excessive, but a quick few thoughts on your proposed sol=
ution:
  - We need more code to define and parse the new DCB_ATTR_IEEE_APP_TRUST_T=
ABLE /
    DCB_ATTR_IEEE_APP_TRUST attributes.
  - If the selectors are passed individually to the driver, we need a=20
    dcbnl_delapptrust(), because now, the driver have to add and del from t=
he
    driver maintained array. You could of course accumulate selectors in an=
 array
    before passing them to the driver, but then why go away from the array =
in the
    first place.

I kind of like the 'set' nature more than the 'add' 'del' nature. What do y=
ou think?

>=20
> > +};
> > +
> >  /**
> >   * struct dcb_peer_app_info - APP feature information sent by the peer
> >   *
> > @@ -419,6 +432,7 @@ enum ieee_attrs {
> >       DCB_ATTR_IEEE_QCN,
> >       DCB_ATTR_IEEE_QCN_STATS,
> >       DCB_ATTR_DCB_BUFFER,
> > +     DCB_ATTR_IEEE_APP_TRUST,
> >       __DCB_ATTR_IEEE_MAX
> >  };
> >  #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > index dc4fb699b56c..e87f0128c3bd 100644
> > --- a/net/dcb/dcbnl.c
> > +++ b/net/dcb/dcbnl.c
> > @@ -162,6 +162,7 @@ static const struct nla_policy dcbnl_ieee_policy[DC=
B_ATTR_IEEE_MAX + 1] =3D {
> >       [DCB_ATTR_IEEE_ETS]         =3D {.len =3D sizeof(struct ieee_ets)=
},
> >       [DCB_ATTR_IEEE_PFC]         =3D {.len =3D sizeof(struct ieee_pfc)=
},
> >       [DCB_ATTR_IEEE_APP_TABLE]   =3D {.type =3D NLA_NESTED},
> > +     [DCB_ATTR_IEEE_APP_TRUST]   =3D {.len =3D sizeof(struct ieee_appt=
rust)},
> >       [DCB_ATTR_IEEE_MAXRATE]   =3D {.len =3D sizeof(struct ieee_maxrat=
e)},
> >       [DCB_ATTR_IEEE_QCN]         =3D {.len =3D sizeof(struct ieee_qcn)=
},
> >       [DCB_ATTR_IEEE_QCN_STATS]   =3D {.len =3D sizeof(struct ieee_qcn_=
stats)},
> > @@ -1133,6 +1134,14 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, =
struct net_device *netdev)
> >       spin_unlock_bh(&dcb_lock);
> >       nla_nest_end(skb, app);
> >
> > +     if (ops->ieee_getapptrust) {
> > +             struct ieee_apptrust trust;
>=20
> I believe checkpatch warns if there's no empty line between the variable
> declaration block and the rest of the code.

It does give a warning. No empty lines on any of the other declarations tho=
ugh,
but lets indeed add one here.

>=20
> Maybe it's just because this is an RFC, but for the final submission
> please make sure you run checkpatch.pl --max-line-length=3D80. The
> 80-character limit is not really a hard requirement anymore, but it's
> still strongly preferred in net.
>=20
> > +             memset(&trust, 0, sizeof(trust));
> > +             err =3D ops->ieee_getapptrust(netdev, &trust);
> > +             if (!err && nla_put(skb, DCB_ATTR_IEEE_APP_TRUST, sizeof(=
trust), &trust))
> > +                     return -EMSGSIZE;
> > +     }
> > +
> >       /* get peer info if available */
> >       if (ops->ieee_peer_getets) {
> >               struct ieee_ets ets;
> > @@ -1513,6 +1522,14 @@ static int dcbnl_ieee_set(struct net_device *net=
dev, struct nlmsghdr *nlh,
> >               }
> >       }
> >
> > +     if (ieee[DCB_ATTR_IEEE_APP_TRUST] && ops->ieee_setapptrust) {
>=20
> Hmm, weird that none of the set requests are bounced if there's no set
> callback. That way the request appears to succeed but doesn't actually
> set anything. I find this very strange.
>=20
> Drivers that do not even have any DCB ops give -EOPNOTSUPP as expected.
> I think lack of a particular op should do this as well. We can't change
> this for the existing ones, but IMHO the new OPs should be like that.

Agree.

>=20
> > +             struct ieee_apptrust *trust =3D
> > +                     nla_data(ieee[DCB_ATTR_IEEE_APP_TRUST]);
>=20
> Besides invoking the OP, this should validate the payload. E.g. no
> driver is supposed to accept trust policies that contain invalid
> selectors. Pretty sure there's no value in repeated entries either.

Validation (bogus input and unique selectors) is done in userspace (dcb-app=
trust).

>=20
> > +             err =3D ops->ieee_setapptrust(netdev, trust);
> > +             if (err)
> > +                     goto err;
> > +     }
> > +
> >  err:
> >       err =3D nla_put_u8(skb, DCB_ATTR_IEEE, err);
> >       dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);
> =
