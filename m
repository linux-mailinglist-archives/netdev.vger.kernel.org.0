Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB11613690
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJaMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJaMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:39:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975BF7673;
        Mon, 31 Oct 2022 05:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667219986; x=1698755986;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4o2U0wOaijGKlXWQLlHQnqZa0n+ajYEaxdFfI9yoT40=;
  b=Jko13+Rm4V3x3Sa1k3WctEJHy7wjLpquBEZUfjpsEJ0jm9TQO8yc95KP
   HJ5n+PSu/Iws+ARqhcYzL907hRaJyqupU/PBGgIwuVTHT0tNSPgUdoCyB
   ev9aJ8pmDAzJpsj8SvUwkPHnTgs78By0s6tHA+9nA8YMiwBhYoWtjI2Da
   OrPxXGBZNCro+DfjtXRNsL0iMChhxUwxJqaXZ6jDcQ5X0nx9ADsmIMAvc
   VgegizRp1gKykwaTkPUsIxQtg4ynL483f85oRIECHgwIi2TXbhKpsr+wW
   Aql3SUOo9hlYTt5oRjbIVumc3WqD6tgQikuE/3OPPsRbtV+8oigl+N+DM
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="181224084"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 05:39:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 05:39:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 31 Oct 2022 05:39:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubd0OK43P9mT44oyxT/mOmUbCnpQwwvU9DTvkLDHkdjC//FtjbCkKvu69+jr/x9zcsD7x3AC19YTODJXpVDYb8QhKeFii7cZmWSrxp3yJrHm9Xi3yIeTtKHG+Xm6gfBYkGPHqPYJxxX9435xH7ossTSI2ICyCESuYEOCsip6M8fMhOxQmB7KNoCHZ4RlkEBnBlWnHCJxuS7Jj4lskyqMR28CPMyht9bPwQCmJIj8naFHRp7Km7JrxOXU87beM9miTw7pwSsBHwUXOS3czmSdh2sp4n7O00loatDqQzKb3xZ26UPG2USDQP6zjDUGrTsSW3/sT08+FZMK661HMSPRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecu+S1oxEyhUG0vVet8ySTN8lI//sdsx8IWeNxAE5qs=;
 b=kNSQhgjZRFjI1esbjVh/W2tFS2o8uTDnjvgyE51gcHkUkxr1DH7skOrK6CcNQno0o1RGm31f75cttwmQJtzNlBi0wEYxk/5UiIOaM1LVvL+QbUbLcJ3A7xfMkF+uhFdr1wScYy63NC21SE3uhF/DqwTT2nZag/E8xJNcCOdTgp2h8gGUbqAPGUz+MBSQXVkDvR4fNKJ9Kf1Qp4c9lubrr5QH/iqMhnzy+jB7fnGG3UMtN0NWN+t+Rnlc0bOG1FqM5HiVtYmXFuLdKg9fVymY6Z8P26mIV3jGQA1d7BfA5/G08VvOTxns2lHMU6sbCWVBAuWwxYxjmRX8yZIrst+NJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecu+S1oxEyhUG0vVet8ySTN8lI//sdsx8IWeNxAE5qs=;
 b=XZiN7IfoCMaSO+0dLrH9arDquESdsP2ughfTRNuDqCwfs6mwi0dBo+vtDlAVi2+koUsl0gj2vJBgnRpNWErgmPmWg/F2di0KT+UopT9KhOT8dXmCcXMDfjDYLbaJUuJcaW7ZEC1WbREPeabQnhs78kNkT35pHFfwgCGd40Rr6kA=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SJ0PR11MB6623.namprd11.prod.outlook.com (2603:10b6:a03:479::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 12:39:39 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 12:39:39 +0000
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
Subject: Re: [PATCH net-next v4 1/6] net: dcb: add new pcp selector to app
 object
Thread-Topic: [PATCH net-next v4 1/6] net: dcb: add new pcp selector to app
 object
Thread-Index: AQHY6rM8OFrHDA25H0OhHnc4y1yB/a4oXkWAgAAa2oA=
Date:   Mon, 31 Oct 2022 12:39:39 +0000
Message-ID: <Y1/EbRMDM4ah2qd6@DEN-LT-70577>
References: <20221028100320.786984-1-daniel.machon@microchip.com>
 <20221028100320.786984-2-daniel.machon@microchip.com>
 <87o7tsw7ji.fsf@nvidia.com>
In-Reply-To: <87o7tsw7ji.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SJ0PR11MB6623:EE_
x-ms-office365-filtering-correlation-id: d2942d62-86a9-48d4-f366-08dabb3cf9f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hhqf/Y+NRV845QsUZ74cdSU6LOhVFDMX9pGWJbkistG9x1M5OpAh4+CBtrWqwQsmbW3iGsoQw/F29IacETsOOQwAMPyG7Yt1zyvQh2yfjEjKj9TS7RMpaacOil+vNkL261pvsOO/Kfc6zVM6NGb3D6eT/L4hLqZaBhEZ6SrfDQPqgTrggbaUk6C4jvcwwo5wKKi3OMtlhjHa/UPgBj21Cig//09uHLzXylnVJx2yDNG6/KKbvVQ4fzh1WAgQZR+fNEbeuTIAAX5ReIMZQ4K3bTEQNFur/kkPmc9y5fmfAmfGDg208dBZskXYWAQ57L0eLS02gfXDLzpZaRviQV2EQajPGXrapDvUM2N7DqIZiCIwtQ8TDRsytJxb1pZg4EW77KCstFYIrwg2mx1VrIeAs0VPdVNLYzGoWhI8/aPGoj/yTcXXbLVmel+X0WeDhrja29vsk+TPRnTYN5EXvY7bSQXMwG9e/v+3oUs04P5NncCHRgoxdiJlncZEdNeJWK9j2/tIY/w/QjhyerOliyezrlnXuNJs/nx880V5GVpVt2qGG/yrh1jbBKNhg+b9Gr+FlJeUPmXOysXNdNXO3Sg8CJlRCzyMIXQ3FlstJj/T8H2LLKS819qt3LYr0rwQyEALbuD+tQZ3VxfY8xAEuk35X/cNxNgt1GkqlfdbNLmUkcrQ3cs+abEpcwgYGxlOcJznQE/W730891/7up5AY2NKWzhcQOL4v2U+GSgNUHvKNt5qKUzPZCIZCoWy15gEKETVa5H5dQkCAEvWOXXHIos88Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(38070700005)(186003)(33716001)(8676002)(64756008)(4326008)(6506007)(66556008)(76116006)(66946007)(66476007)(66446008)(6916009)(316002)(54906003)(91956017)(8936002)(5660300002)(9686003)(86362001)(41300700001)(26005)(6512007)(7416002)(6486002)(83380400001)(71200400001)(38100700002)(2906002)(122000001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sXHqvr4RcEMU4/+Fz21A1J5ur0vbwMzG74cLekBf3YGAbYfPYI4FNl00V8BE?=
 =?us-ascii?Q?m5qb31e5gKoPTEAFj9c3YqxsjbTq40drW4We/KPPQn9qYO375acfrqlW0AJ8?=
 =?us-ascii?Q?rEiFbCXlt9caQUZHm9QsMHdClWXE2EHuwKV9WJkV0h/gfu8+qIW8aHdQCHpM?=
 =?us-ascii?Q?juGpsQ40S2j9LfzUkyfeEVq3tZEBTnI5IfLvV2PDaH+yP45f+CsYlsNR6Mof?=
 =?us-ascii?Q?9AzWQHVT9fYPUmYxI7tLdTYt76X+XE8og50D93kR0pLElAC94itZqgJi9FoT?=
 =?us-ascii?Q?NfLDkyKKPxJxaXukwsbAjuOTA6uXDXWGe6Sb78/zMrFT+8S9kY9a0XlLsVoe?=
 =?us-ascii?Q?k3QP82TGV72y+6Oh3F2O3K42W989UbXD8vQiWhcWSdgjLU0BO/nbBggEQTqV?=
 =?us-ascii?Q?J+hut5bKVfEC5YFZSm1nrwWeX4h7W0qOYIgG34crnAeL5kfVDnS4jhjtG54u?=
 =?us-ascii?Q?8V5VZTPiFlqflu5HEUb1yXJskX1sryoJqkytb+3hVgS5XqqPvZUQT/W9XPtG?=
 =?us-ascii?Q?1oNMjzs8E4L6IsGOt7lfDO28tIRzKjaAho9abfIfUdgrh7E5ogr37OeOKT/5?=
 =?us-ascii?Q?QBtrvEMmxJpJ4AeH1gUa5QTN1dcecu+tvBKQjtiCCsIqJUEw6dTLdY4SPfJ3?=
 =?us-ascii?Q?y0MA9yfRtnBnf0XgPeeZZkxfhtGG8UdUYJ5cAG3RxgTTpIO855yI+BsoKC//?=
 =?us-ascii?Q?d5BZxDdy4izoDc0RRqiiORV/iSn/HHDCwPWm3MQkkReTcUckPGyE9oAUzaqH?=
 =?us-ascii?Q?3i474bdRMrEJ8ExI7k2wYIDq1nZBkfw0GYP8HkCgYKH/7/11TLsxCmNV+0QT?=
 =?us-ascii?Q?t7qZFVL32nDW8i+6RETNPdxYxwr+aNMT3c67W95Nz7vx/B+1Tx2iaRp3lT0f?=
 =?us-ascii?Q?Xp/SNQlS95pHIg8iAVaeONZb89h45ZCnYcn/1pDmhGAJtUPaskWHqjTZ5xuE?=
 =?us-ascii?Q?nitw64Js/Kq3/W7FeGgy7uMv3yY1CgHXgViXAXtBR1XEgZ9l1f1ibtNFhgih?=
 =?us-ascii?Q?Zd0TEJaBjdfiTDJk8U3gqjJWPKk6hfgMRqdFqQKvluAXafCGXFcBC2I8hBlE?=
 =?us-ascii?Q?INKFTN/L7mmlF8Ytnb2XIur22nMfn6y12ukQRVQ9EVN6PjJalBr6tFz5BUce?=
 =?us-ascii?Q?1AF5W4i6RS93wBBpiTxiG1TV9zuVgC4UtG+lINA0dq2548oddvuOukyb2izk?=
 =?us-ascii?Q?9ipDRGhgkr8ZPoJI04KzKdqz5dyBS0tFA0fi9IisThNBvxAu9TRMhCmcM56S?=
 =?us-ascii?Q?DjECNt2iHmk518n54lHC0JtqNal+HGPCo5ocWgcjQUlL58XwG2Qp85LYyBgj?=
 =?us-ascii?Q?eSXBFDNvNfheRbZ+Tf4CWxvVVvSWD3M4x5eS3FDYW1Y+C0CwCWlgitRSN1th?=
 =?us-ascii?Q?OdGxaKxh8BFyJE/ToGllRgrjtF/OhStdZlc4hvkR8wDFztfUqGstyLT36xHM?=
 =?us-ascii?Q?TIddLkTgAxNdzosGQteIor2b+6zEBswcRlQx/XFTEPjV8KaueRKkRuBEKV9d?=
 =?us-ascii?Q?yN/WU6gQb8bc2oMMA7jcQK+aYTu6dfrBEEJGB0h1FxdqzLsKb4muy2YNVFVa?=
 =?us-ascii?Q?rJ7Mn/PxQPL/RKcRufRddm8fVzM5AcVNlgbHmmQ/Ly82Wl6ZBDS+ZHXVH65h?=
 =?us-ascii?Q?e4rf1Ese79EYRDghFbdYLP4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB5A76D4A485264888C88A7AE293B759@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2942d62-86a9-48d4-f366-08dabb3cf9f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 12:39:39.2111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJBGIVFQtTKUnGhs0jZVr2SPPzcl1tqyUe/kOP2uyMBcFer/7L0Y9wIlWfSg1Plh7QvtM3N1oRBPvRkdwIL0B+0szdc47OBwFIOYM/CM5RA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6623
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > index dc4fb699b56c..68e033a459af 100644
> > --- a/net/dcb/dcbnl.c
> > +++ b/net/dcb/dcbnl.c
> > @@ -179,6 +179,57 @@ static const struct nla_policy dcbnl_featcfg_nest[=
DCB_FEATCFG_ATTR_MAX + 1] =3D {
> >  static LIST_HEAD(dcb_app_list);
> >  static DEFINE_SPINLOCK(dcb_lock);
> >
> > +static enum ieee_attrs_app dcbnl_app_attr_type_get(u8 selector)
> > +{
> > +     switch (selector) {
> > +     case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> > +     case IEEE_8021QAZ_APP_SEL_STREAM:
> > +     case IEEE_8021QAZ_APP_SEL_DGRAM:
> > +     case IEEE_8021QAZ_APP_SEL_ANY:
> > +     case IEEE_8021QAZ_APP_SEL_DSCP:
> > +             return DCB_ATTR_IEEE_APP;
> > +     case DCB_APP_SEL_PCP:
> > +             return DCB_ATTR_DCB_APP;
> > +     default:
> > +             return DCB_ATTR_IEEE_APP_UNSPEC;
> > +     }
> > +}
> > +
> > +static bool dcbnl_app_attr_type_validate(enum ieee_attrs_app type)
> > +{
> > +     switch (type) {
> > +     case DCB_ATTR_IEEE_APP:
> > +     case DCB_ATTR_DCB_APP:
> > +             return true;
> > +     default:
> > +             return false;
> > +     }
> > +}
> > +
> > +static bool dcbnl_app_selector_validate(enum ieee_attrs_app type, u32 =
selector)
> > +{
> > +     switch (selector) {
> > +     case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> > +     case IEEE_8021QAZ_APP_SEL_STREAM:
> > +     case IEEE_8021QAZ_APP_SEL_DGRAM:
> > +     case IEEE_8021QAZ_APP_SEL_ANY:
> > +     case IEEE_8021QAZ_APP_SEL_DSCP:
> > +             /* IEEE std selectors in IEEE std attribute */
> > +             if (type =3D=3D DCB_ATTR_IEEE_APP)
> > +                     return true;
> > +             else
> > +                     return false;
>=20
> AKA return type =3D=3D DCB_ATTR_IEEE_APP;
>=20
> > +     case DCB_APP_SEL_PCP:
> > +             /* Non-std selectors in non-std attribute */
> > +             if (type =3D=3D DCB_ATTR_DCB_APP)
> > +                     return true;
> > +             else
> > +                     return false;
>=20
> Likewise here.
>=20
> > +     default:
> > +             return false;
> > +     }
>=20
> Also, it really looks like the following would be equivalent?
>=20
> static bool dcbnl_app_selector_validate(enum ieee_attrs_app type, u32 sel=
ector)
> {
>         return dcbnl_app_attr_type_get(selector) =3D=3D type;
> }

Ah, yes. Less code. Much better indeed, thanks :-)

>=20
> Also, shouldn't it be u8 selector?

Will be fixed in next version.=
