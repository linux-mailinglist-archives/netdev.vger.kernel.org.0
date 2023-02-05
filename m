Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22D668B17F
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBEULN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 15:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBEULL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 15:11:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01E1B57B;
        Sun,  5 Feb 2023 12:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675627867; x=1707163867;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p2Vq+Tam4sWU8skt+mc3bGPmU9PVoHl5tutShKCA7D8=;
  b=LmtCixUbm39h7x7ToLmtjWl80DlgtpaVGv+mFg7ii47qcsCyPgH7c43d
   hBJUuRl/dyseSbOBUxGURAclWqG3PR568st4+Qt5RHoPIv53XYMnlyZC5
   zHsR6ENJu88gHE3r4eq6UoyX/9LBXWAIEVWQVhSOk6K0TL8pf5TAPgv+l
   pe3YmKXMoRC2+6Wwuhfm8c6iqGMGTkupAgwlbSZaKIgwLA1Ww6FJvUDYg
   GnEqz58U4eaI8l8+aZxBjpoDDacMo4rsHKF7baksFrlc434pV1waL+Uvk
   RXuTN055PRxkqU4T9/IghW5018hp+Dyx4KRKgv6vDfj4GPX3cVkhN3EYI
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,275,1669100400"; 
   d="scan'208";a="199641025"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Feb 2023 13:11:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 13:11:05 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 5 Feb 2023 13:11:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2+Qz6O7wHSY4fthWm1ySOtKMOVGWpK0jgEIFTLX8snKJaMxH7dVaBbS5sCEzk6uX7+RNbR7GMwhXsU1QRkobtIT0XZA80QIQF57x52Uu00o2a0MXE6PDr/GxS4Q51+IVW/KI+a0QurW4bNKdavlyCGdD1kFdIEYWIjLbH3hTRg0vngmwanFzc85x3SqZAL0sbHOREOEmuoP9p82yvPh8mc/4YJwEDut6oza1HVamt0kCgo1qPHW2qf2/iyBV8LL0wAVs97KSb8aHCR07aur2mR3oKi9wcc582qDY/04mMeTbWv1qpS49EB2bNEWeOvj9oEotFY65qWhYyM9HLKSXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2N7a40f1kIdPAoMgPu+NQ6pqcnMdgRQyvWi4sivvIA=;
 b=Mbl0I+6379ET0w2V7TNfPdYSqNLr9vwuUvZZvNPmBQwwx5QS5XmwcZm5r4htosU4JJfVL8UXfHAjj8tdVMF1nBB82skYieIGheXLeDXrc8XQg9iobJKkCEb5GRKTREzQ5gCT/EPmb6uNbizUpdyzOotW0LF6i4mSW0hn+SVYLlxkppHGjKVQ0O34FHHB+pbPmsMI8BOSMRND+DwaE+edc6RHsZpCj0Mv2tVKzJsXEN+2Mjmx3uJ/ne7wmJnF5v4xBbrMlWxaH+BpdV4/Z2mUfdjhPIxi0jk6NTNm70G0zipROJTZDp6/JFhEFPx0at3S1vPqyGmt4iGh4bX55M6B9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2N7a40f1kIdPAoMgPu+NQ6pqcnMdgRQyvWi4sivvIA=;
 b=ErpxZwLenpkqrJYdpKOSQVNMxQR43H6ZFPv21SEPIFWUTLiRtnIsaVVTrcrjcvMOnJcnB3UhBf9A1eEpgtGw5ZtmzSgmoh7CBvX9qzEy6/0gqFGR0/SaPvP5VYH5mDnrnKGlmly55oxqR0N5HVIcvfEa2x53YT4fefCOuHuXdWE=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA1PR11MB7087.namprd11.prod.outlook.com (2603:10b6:806:2b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 20:11:02 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::1e47:7862:ee17:f6cc]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::1e47:7862:ee17:f6cc%5]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 20:11:02 +0000
From:   <Daniel.Machon@microchip.com>
To:     <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <Horatiu.Vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 03/10] net: microchip: sparx5: add support for
 Service Dual Leacky Buckets
Thread-Topic: [PATCH net-next 03/10] net: microchip: sparx5: add support for
 Service Dual Leacky Buckets
Thread-Index: AQHZNvNw/NXbR7cUWEuZ5T9YllIEGa6+wW4AgAIMmoA=
Date:   Sun, 5 Feb 2023 20:11:02 +0000
Message-ID: <Y+ANVTMT7jgV0i0l@DEN-LT-70577>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-4-daniel.machon@microchip.com>
 <Y95VRJWV4NfSDYUR@corigine.com>
In-Reply-To: <Y95VRJWV4NfSDYUR@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA1PR11MB7087:EE_
x-ms-office365-filtering-correlation-id: 34ce8725-3e75-4f80-8a7c-08db07b51abd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nyQeLppJRAWY8lArBoQ7LKPdP823/N/m1Gq3H9qnqzooEOYcPpNW4k8oKac5uA5JhxfdYgaO1MR+VhPR6gSrqyqAUADwjf6yj5Cl+pUq3OXTl5Kaij7vWDys+d9KXhWm9oZNjbmG5PRSSXgue/7g4iwJpIfylexNyorUZYcNwiJSpzcl3HTyDYejBCBKlGguYfQw60Iby6OkJ29/mvac8aYcofpJBPeBQJhGNqSzj3zvuzCr3ZjcXf6AVFSJbTzOZdfZAdvBbAVQTE/jwba3Kc/gm8r5T32uTwxxibQgelLiBQaL/JVY7T6iVX/IJyGXxG9svCs0tLA3YtcdUKcGnmPmduwP0Y2ap+Y2CpzA93bNSOhvhFakjSp8XY+xe1vbSjaaHu1FpekoUPgxgaGpnrRXRYzxaUh45lRiEsQk2OoEdDGAHfzeZCqrAlHQolGZVYgPLd2BdUF/x0/BFkaqw149K+D4/Gpkzu9WCkML1pkxmh1f37kTEQ2Jlh5Ekq499/rrwFKameRAPJwFf4Yh/5YEFgMExrW/KpsbHZsslYsdWJH1At4C1YE9MV5U4eftymsbcAPOqB8htkCbHbpobt3dSGZaQnG0fIbjCszzth9Y1XPCHIYAaq5QweaZ1NOk9+JQq1kggiRtcm0d9AQ99W7B0bzn3l7gtIK84X6JThjGqykbkfa1IGzpJ8b4HcfRPwi/c85BKH8MUaG8hLd/RxX4tayBfMCboQnH75R+v48=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39850400004)(346002)(366004)(396003)(376002)(136003)(451199018)(38070700005)(86362001)(122000001)(38100700002)(33716001)(316002)(71200400001)(54906003)(6486002)(478600001)(2906002)(41300700001)(8936002)(6506007)(5660300002)(7416002)(91956017)(66556008)(66476007)(64756008)(66446008)(8676002)(6916009)(66946007)(4326008)(76116006)(9686003)(6512007)(186003)(26005)(67856001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?texSofwS+vWX9slHWWPBfHf/EVujxFHNvtXMxmH4Wj4/j3T4rrd73fTS73nJ?=
 =?us-ascii?Q?9PL0zArdyeDmdCZthax30JAmBNGQTznP9f17WQn0ywqsckHQzGbFFzrjMmnP?=
 =?us-ascii?Q?GlFt6lb4WMAY5XvTCVTj8QsoXIT+7uLSls4gNxE6ToqU/UpJH/6f3AVSWkIM?=
 =?us-ascii?Q?+YaTixb6BNkYUnHkQjU23GTHQkN3duokU3zwAbzQVMqq80HSnCr2z9UTAQCx?=
 =?us-ascii?Q?e/2dup76H32l6JoMsPEVXgxkecDSU6h7yhzvOSUFJUrzPCyjnmL998VA+xop?=
 =?us-ascii?Q?KkaDsoeIbHRlR875a/t71LFliltlGNxM+gLlh+LCTMlru2t09yRGm9Q1qrCw?=
 =?us-ascii?Q?mGmmE8K5IC0Df3OAXw1Kd0bm78MxQ/4yelh2OvCyNTUn9F/OjHuRnYGubbEP?=
 =?us-ascii?Q?WBdUKRJtmj2UsSMSWnTyZahrC7cu527uknrpsNuHx6V8kiRCGGhS17jPEByz?=
 =?us-ascii?Q?M1KpYtMQft+xYLhVs5v8qaQgo6Yz6jmKKsWqgf2TjWTghjJUbnkQPBWo7Vln?=
 =?us-ascii?Q?OAnwN2u8ZWiLma6e8vkAm6mndfv55r4XrrkDL/fdTKgvD3LEXDoIQfTgD/rz?=
 =?us-ascii?Q?Auit8IWEwHd9Pv0OxrwPV14CiwMFJr9AV2T//3XFKId5e3eqGTraohcDjO4e?=
 =?us-ascii?Q?tBnfg0z/RlEVWK+VqdMETNXBNBsTnmxYeavTLDckfeEKs1uOJNpOB1x5jkun?=
 =?us-ascii?Q?bhlqW5jUfGGoekjzk37uxUkOhKMq7loslSsOFeoDU2PAW1cnZI+aAZynUMLx?=
 =?us-ascii?Q?O1vFheqNlOdKCGHGwGyLiSNJXQn9duekIReEMMlJ+Vh+5gh7m5nloj7MEfSx?=
 =?us-ascii?Q?xy5vgxTK2qsiMTzWDchPpnRbj2zksiRjOhOu8H2oO2RVkyuh72v0//RCUxF8?=
 =?us-ascii?Q?BINtgtAHOxnn1QlYiAc54Dp+cGWg+9bpHp/rS/l3U0kUeU9FnHHGt4fc+kxR?=
 =?us-ascii?Q?Jp8GVjjE9i6S4OHm0rigBDzy1mnlf1gdEMzyTm2wZw94cfffCWZNzTzJGTzM?=
 =?us-ascii?Q?F0NY3dip6W2bxRFX21wUbCqjKoPHY+Zs9PBJk6dIqbYHNjvCBDpDHEyrOdmC?=
 =?us-ascii?Q?K8ZPGAqaqhkpKtWdrvcVXdpx+EEaGDqqUKnjdc7k/Zd2Qwzk8skVd2bAnIiW?=
 =?us-ascii?Q?lz6jmu9xh+7lAYowhMJZszK6khnT0z+Q72yk1NFtOIMmYmSciUlO6cpKMZcc?=
 =?us-ascii?Q?go0wZbRsBimvXk1BbypWhJz84T+o4080Ttjw1YtNqU3YlL54FP451uR9hhiy?=
 =?us-ascii?Q?79GZS37F27DFlMSnFZDec4WVMsqeqWYZ4v92pDZGO+3iR70aBxicgeDqihpa?=
 =?us-ascii?Q?dUhpAI0h2NtrP5gL0/JG7l4x+XFt7Q0DtTswe46eS0Zm41nZ6Ro1xgFtcUu1?=
 =?us-ascii?Q?/+kMgXVnGfhIqVn3RuOS3VUgZVuznnz5efExNo9ovBsJyN9aoONmsWmuGtaW?=
 =?us-ascii?Q?6R4thODsw/H2Mkh+AsIDObUqkuSelv6eqSi4r+RNnzm586TsJQyITwID5hlB?=
 =?us-ascii?Q?pEqPHkr3N/QFtIZ+2naZ2I1LEo1zVJ18hmIrUCnBeJKOdBVMup1dMyD/gd0A?=
 =?us-ascii?Q?V+ZQeqXHL5A/cEnSH2BQAnFLt2rIH88MeNo/qCNm+fyVYLL8E313fkruitxU?=
 =?us-ascii?Q?cDTuXYbvWPE0jKSGZy8xGKA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E80A4D018B8964B9F698349CCF54D11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ce8725-3e75-4f80-8a7c-08db07b51abd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2023 20:11:02.1537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yN72ACxeQBu2m2I9gSAoO2WkVxQFuk8zs6iz/QoKlVfQbXDZmGE1PjAMTeTFBCBP7bVjNIog9CF9UexxTfHJrhzOWw1S+9UCyJ282Iwa3/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7087
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

Thanks for reviewing my patches, appreciate it!

> > +static u32 sparx5_sdlb_group_get_last(struct sparx5 *sparx5, u32 group=
)
> > +{
> > +     u32 itr, next;
> > +
> > +     itr =3D sparx5_sdlb_group_get_first(sparx5, group);
> > +
> > +     for (;;) {
>=20
> Unbounded loops like this give me some apprehension.
> Will they always terminate?

Yes, it will always terminate - unless the add() del() functions are
buggy to begin with.

The end of the leak chain is marked by an index pointing to itself, and
this is the exit condition I am looking for in the unbounded loop.

>=20
> > +             next =3D sparx5_sdlb_group_get_next(sparx5, group, itr);
> > +             if (itr =3D=3D next)
> > +                     return itr;
> > +
> > +             itr =3D next;
> > +     }
> > +}
>=20
> ...
>=20
> > +static int sparx5_sdlb_group_get_adjacent(struct sparx5 *sparx5, u32 g=
roup,
> > +                                       u32 idx, u32 *prev, u32 *next,
> > +                                       u32 *first)
> > +{
> > +     u32 itr;
> > +
> > +     *first =3D sparx5_sdlb_group_get_first(sparx5, group);
> > +     *prev =3D *first;
> > +     *next =3D *first;
> > +     itr =3D *first;
> > +
> > +     for (;;) {
> > +             *next =3D sparx5_sdlb_group_get_next(sparx5, group, itr);
> > +
> > +             if (itr =3D=3D idx)
> > +                     return 0; /* Found it */
> > +
> > +             if (itr =3D=3D *next)
> > +                     return -EINVAL; /* Was not found */
> > +
> > +             *prev =3D itr;
> > +             itr =3D *next;
> > +     }
> > +}
> > +
> > +static int sparx5_sdlb_group_get_count(struct sparx5 *sparx5, u32 grou=
p)
> > +{
> > +     u32 itr, next;
> > +     int count =3D 0;
> > +
> > +     itr =3D sparx5_sdlb_group_get_first(sparx5, group);
> > +
> > +     for (;;) {
> > +             next =3D sparx5_sdlb_group_get_next(sparx5, group, itr);
> > +             if (itr =3D=3D next)
> > +                     return count;
> > +
> > +             itr =3D next;
> > +             count++;
> > +     }
> > +}
>=20
> ...
>=20
> > +int sparx5_sdlb_group_get_by_index(struct sparx5 *sparx5, u32 idx, u32=
 *group)
> > +{
> > +     u32 itr, next;
> > +     int i;
> > +
> > +     for (i =3D 0; i < SPX5_SDLB_GROUP_CNT; i++) {
> > +             if (sparx5_sdlb_group_is_empty(sparx5, i))
> > +                     continue;
> > +
> > +             itr =3D sparx5_sdlb_group_get_first(sparx5, i);
> > +
> > +             for (;;) {
> > +                     next =3D sparx5_sdlb_group_get_next(sparx5, i, it=
r);
> > +
> > +                     if (itr =3D=3D idx) {
> > +                             *group =3D i;
> > +                             return 0; /* Found it */
> > +                     }
> > +                     if (itr =3D=3D next)
> > +                             break; /* Was not found */
> > +
> > +                     itr =3D next;
> > +             }
> > +     }
> > +
> > +     return -EINVAL;
> > +}
>=20
> ...=
