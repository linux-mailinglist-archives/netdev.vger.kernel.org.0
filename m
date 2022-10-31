Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9797761384E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbiJaNpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiJaNpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:45:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC33F101CA
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 06:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667223913; x=1698759913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yF85cjEiFQk3m07+Mwo1XfPhSuEakYWjL0AOYNnikjs=;
  b=ioEB4tzGadlExlUVuAkT9JH47+ZncTKSeFcUjqma0EUxocoqfxfZa74i
   rTtOI39lQwfXYJmCqIH8h5fKLbRKwjncPCO8kyQXjs+0M9y75fK3h4ev4
   0XGrQV7kIiFPXQdZyqjSZGSFgsIOTUTZYd25NpQ9JYr2hgj4D5pLcvJrZ
   1pTDk7+NvPJWkAo53cIEAcBYtRBZTuSkeHqlxaCKjpBeimgrls7ExrzTY
   ytMepOcqIHTyauqxj58jcMqg7s90nV/261xOQsMI+vQq4kSRuE7VcRwBH
   ov4TYWzcJQtrZ3JKiArGQpkcljW9vAkLQSV4wlHE3wrEk2i1BznOhXmHC
   A==;
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="121088921"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 06:45:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 06:45:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 06:45:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmPFM4VZCA7toy8uXKmRy5OC6HlaDUTrgTqWT3YFpDW4WsLC+1b4xMKXv+MypaQWHF0+IlBFgzd7J/BjyUoEK7GET1/Zcrk+SoUMCpeSN6I/fnw+Xgh+Hr6RsLl2WoNHbAmuiGSsKLSzl0njZgXZ+h6rNbihfazikHKC0u0ni4SzBONTlVErNGlEYnaqHZLjHVt5Nm1RkFopz4RH8afESx31tmFtQc314jLqhC8r5lgdEIMbFYMQuBI0Dy3BUeKcvu6YUBXd/5wcMLhEMiWKu46AB1HOscxUuz2u+H5VPuJb5JkkGpPLMKUzvOSnZmSPs+ECNrJVK5vopUtVCwlexA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yF85cjEiFQk3m07+Mwo1XfPhSuEakYWjL0AOYNnikjs=;
 b=JRo5xoqnA5EHSElm0ykBEeuLJ1eG3c5jDbfCtHcS5nIZPM/2/Oh7ModA9uPATsD2odmlpBeZ/DJDFT/pefc9LHIDqAVZRz6qLwsJjMF+LkJL9L0kkDC6Idj/neO91JVecPPUFiT61VeoRDilx4aRi7Ud6L4qKPG+vpb26P/QeUJka/Zf0tHrb1hzS8Sgw7W96Tk8LbkdlYUg/ggHpk6l6yiw1YaP0zN5HQsGur7HaLgexTG9dFVtIVQaXu+PWN8MBPC6ABHPfvsSAYZAkZ5tcsTOsaDpaZyxLdIC2MOVysDRJ31q+q+0GcYhF2R9gQxSpUCoXjRjXZI1e0kif3905Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yF85cjEiFQk3m07+Mwo1XfPhSuEakYWjL0AOYNnikjs=;
 b=RAq3X6y7JYujOoFn5fYFp0rhjXG7BOaXKTm2j5ZNYsd/GSkZxWCHZhufYXWAE6h/QDYt1U8cy2W59jh4d6cNtvomJbkI8IqaxGROj50I18yrepIxihFYZWwpRbR/eyjZ8mqTb8aplJyjLxbNpmpz2hxrFiqGNbO/IgdTfyeO70g=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by PH7PR11MB6556.namprd11.prod.outlook.com (2603:10b6:510:1aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 13:45:06 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 13:45:06 +0000
From:   <Daniel.Machon@microchip.com>
To:     <Steen.Hegelund@microchip.com>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v5 2/6] net: dcb: add new apptrust attribute
Thread-Topic: [PATCH net-next v5 2/6] net: dcb: add new apptrust attribute
Thread-Index: AQHY6s3kyuIfPHjYUUenXsXS/82DDq4oVNYAgAA2XQA=
Date:   Mon, 31 Oct 2022 13:45:06 +0000
Message-ID: <Y1/TxJL60qsMod3N@DEN-LT-70577>
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
 <20221028131403.1055694-3-daniel.machon@microchip.com>
 <b6a2a8c9331d12dc6f7148be210acfea17f16479.camel@microchip.com>
In-Reply-To: <b6a2a8c9331d12dc6f7148be210acfea17f16479.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|PH7PR11MB6556:EE_
x-ms-office365-filtering-correlation-id: 24158112-586b-4dfb-4836-08dabb461ec0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYH8bF8zk86RKM9FfzmzPSvE1SvXOh2mAQ2HrTZt5n03Dzl8BaGUMWC3DiVPON7e16obS70tdSr94xhfViKgkhu7dvVqI+QyrH1ASML+Auv46UNZATIWor3LfHXbWlVR/wAUzVRX/lItmVi+cvudoBjYYsnm952EWODGDJi1qH1YbLXXzJt7qRZnXUMdunjECmTWbuA9K8DW8XlKlNLPv9FBf7PGFSYWgc4IQouHI8uFJph7KWXxw8oF/WljMF+uVTKP73tKn0FWugIEIF0APgrm4o4nNPXZUQRq8udKg3FbdRx6KLmZtCLPWETz1zL3uA3AxLHEVZjTC6M3SqENfvOO1KErxb+TiuOvov7oTNUvmgLc5tAmU8o4JBYoPlKX+f408k7RDXpVKQa7W0Fu2VU10gRGHYKgFt3exlTXqktTlhGsxLmMWWsCF5oXNGTsopENV6OYCDTgckUIMw5gr3R+SnqCMQ16UvC/vw9KZ4KZGo159kCkNNcxBj8AGaTCQjnlLgV9TYe5Faca/4pNl53XFXM2semEMVHXNnOFtEC5okPINYgm4pMhenFrPELBLd+AaovtyCFIKASSs8ppoLi+Tnfe3ZN8Hll4gOjR7bMOBj8LLV2jyiDPA9DfQrR45ilsW7Gi8moV+A64ayA/d6RDZvt/j+JzaPjObtCFMY3EkRdW9swjsCWflX6SO37sHX0vymjEfqu3Po0wwQpKsel4RqsBSLsWiLIXwO3CKE8olnlrm9OWWYDR0zX96+t1ZzyVFpXI430a4wK9E/BayQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199015)(66476007)(6862004)(8936002)(2906002)(5660300002)(4326008)(83380400001)(186003)(122000001)(38070700005)(26005)(86362001)(9686003)(54906003)(91956017)(6512007)(71200400001)(478600001)(6486002)(316002)(6636002)(66946007)(64756008)(66556008)(41300700001)(76116006)(38100700002)(6506007)(8676002)(107886003)(66446008)(33716001)(4001150100001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?pUnTjuuftIlbyFcw+fXJmytl2VaZQWrwG4cUFZLjUITVFD5uP5zDKeaDhM?=
 =?iso-8859-1?Q?fMc2DGoslCRjne6S8z4OPcHMQmEQHdtu5YORdGHWK06g8REay3M6laMSfi?=
 =?iso-8859-1?Q?7foDuqcM3cSiSaSYIXxADf/+/lDguNIG7mt7snH9Egx0g0JlvMn3e5NDUN?=
 =?iso-8859-1?Q?QfvnUwzMxhLKKiGdwwZ1SpAvzcnOMmSsfuqFM+nHg7zILU7vfngrCzFAM1?=
 =?iso-8859-1?Q?DiH92YPohtFmgIQK3cHdAa1ewbCz8u/VKvE7X3B5iBBDxiSU4OtwhKEZJz?=
 =?iso-8859-1?Q?EvrWqwQHnm8bBSiZZNCROZa1ftFl+AzFcBG5ur0/SFmG4b4Niaq3EeNKkU?=
 =?iso-8859-1?Q?BpnJZ/pC2Sk35RKZph1dQp6sWs06qE0KSPSCx7kjXCZTb6Zxtd+Tvaa7gz?=
 =?iso-8859-1?Q?UfLRItt69yhTDfi57QOSoERRYxT43K3ipjjiBme2HOo67L5R36iTnzqlmP?=
 =?iso-8859-1?Q?z+bBuVfkWNF5wvyo4Z9uhUN19IvJACn6jOUxZaef5+L+wIqrLbvM4A4GyJ?=
 =?iso-8859-1?Q?0Ee5fstCZAJbnn6GMI5domrnkMUOSZcj2gA9lC+P4M1+VUY4ESOx8SBE7f?=
 =?iso-8859-1?Q?YkSzzavP+ii7pnY8xquWDoBUL3uRME3Av4F9MVsH7j5IOAWMwxzwghByzW?=
 =?iso-8859-1?Q?EA7rN//QaBWNPJnRJO8IQUbfaFWd6HrNjK7EJMIbg/OqNHWou0pBS4nje2?=
 =?iso-8859-1?Q?WgnukJzrltqmZSwlWvXvJ8i8UkL/WieawGaTcxiRy417HebiilbZi1nQtW?=
 =?iso-8859-1?Q?nGX2f0vSCbl180aM/JkpMCOtjwewQNFbLcn5UwKtnFkxTlGuJ4Fvg1KhZq?=
 =?iso-8859-1?Q?kPLMJKT6DNv8t+x/afdqQS/I2av2APmBrwj7oMEIHJsb9ZkzpDHkMjGvjA?=
 =?iso-8859-1?Q?yXDpRNgeRjakMMjaOH8bTRMhSe0OaN+SrXt/4HH0XNacqMloOo5BJpdGyT?=
 =?iso-8859-1?Q?DFzSM1yMqi5dMkoFyV8ndC/wLS+hVgCjZZHUCpaLiaZ1xuV2kMvGAp/N0I?=
 =?iso-8859-1?Q?lNDohSoVJJ3ystdLK/PZ9IH0DhDt85SbIQ1e66BySKYQl0Ddm7N6sNFqFX?=
 =?iso-8859-1?Q?S9N9GBbN32cLNhlAJSyVpyGyADnzvd4BCCBjOWhB+z08DDhTKwg2z9ij8M?=
 =?iso-8859-1?Q?8GfV+E8+SUO0omKdDEPs51DyKCZzZExXLqF//DWaGZnRq8Kb57o1ohvrZi?=
 =?iso-8859-1?Q?j5HvNia8uoIKEmCMy3mtrwbPvC7GgBCrW/5YebPyMxE3VVfCAfwVGF/rW8?=
 =?iso-8859-1?Q?uwceKs4s1xsWS+7O9TXoGSDoCVF1uXkOfBZdH9J7evFZkuBRvQ4aqpblgE?=
 =?iso-8859-1?Q?FxKCsNdE4XEnRGCGrM1eacj4VUXb3Uth4LQ1wwK5GL6uvvJV47h9jW8N/Z?=
 =?iso-8859-1?Q?qr3MSDA48tEhTp7fCIXIRo6nu4LoH893Z7SJAQ1zsLreIrS9t7embV+Dcp?=
 =?iso-8859-1?Q?TEKlaFQ7axjh9Wa8e4JeRS+rnCoQaR1f156xKR+jtToMfYa5GIpWPMgFV2?=
 =?iso-8859-1?Q?RczEEazF6HfcTyBDxQRk+XFKJRaS6DQMG5B8ejRjhebWkyuvFrpZc8D3ij?=
 =?iso-8859-1?Q?hHya5x+VGazRRhWDty1ArBGACfyntNMEnLhoXetgbAS/NdzGzFex1MrYdc?=
 =?iso-8859-1?Q?GcyCwZi/2JuvnJpgSsNrhKz4xuX5NEuEJCgOVDkfWaNE0jCTshZQf7qRf3?=
 =?iso-8859-1?Q?OgWEs006IyAqsKtUSK0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F833CB0376A1474EB43D8DB5650FF86E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24158112-586b-4dfb-4836-08dabb461ec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 13:45:06.3744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mcqY90KFsgapAkJYU3ZhBYVFnl00Lv8yvwX3MtI7Zvg+x1+uiBe3G2I0s+1M+FoqArK77s4A2aha2F6+GgTdv08cZMyiB0eHOQn/5DuQXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6556
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Mon, Oct 31, 2022 at 11:40:42AM +0100 skrev Steen Hegelund:
> Hi Daniel,
>=20
> On Fri, 2022-10-28 at 15:13 +0200, Daniel Machon wrote:
> > Add new apptrust extension attributes to the 8021Qaz APP managed object=
.
> >=20
> > Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
> > DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
> > the nested attribute DCB_ATTR_DCB_APP_TRUST, in order of precedence.
> >=20
> > The new attributes are meant to allow drivers, whose hw supports the
> > notion of trust, to be able to set whether a particular app selector is
> > trusted - and in which order.
> >=20
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
>=20
> ...snip...
>=20
> > @ -1185,6 +1186,29 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, s=
truct net_device *netdev)
> > =A0=A0=A0=A0=A0=A0=A0=A0spin_unlock_bh(&dcb_lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0nla_nest_end(skb, app);
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (ops->dcbnl_getapptrust) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u8 selectors[IEEE_8021QAZ=
_APP_SEL_MAX + 1] =3D {0};
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int nselectors, i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0apptrust =3D nla_nest_sta=
rt(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!app)
>=20
> apptrust?

Wow, can't believe I missed this. Good catch. Will be fixed in next version=
, thanks :-)

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -EMSGSIZE;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0err =3D ops->dcbnl_getapp=
trust(netdev, selectors, &nselectors);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!err) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
or (i =3D 0; i < nselectors; i++) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0err =3D nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 se=
lectors[i]);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (err) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0nla_nest_cancel(skb, apptru=
st);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return err;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0nla_nest_end(skb, apptrus=
t);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> >=20
>=20
> ...snip...
>=20
> > =A0err:
> > =A0=A0=A0=A0=A0=A0=A0=A0err =3D nla_put_u8(skb, DCB_ATTR_IEEE, err);
> > =A0=A0=A0=A0=A0=A0=A0=A0dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_I=
EEE_SET, seq, 0);
>=20
> BR
> Steen=
