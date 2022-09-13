Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F65B7AB5
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiIMTWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIMTWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:22:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB6172EC4
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663096941; x=1694632941;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zgnz2kBekXEBHGlpP0V6OmtNnwmzfJi15I538MtPE40=;
  b=EEkLmZq//w3Tcesf0O62Eqa2pDNUFopqrCi9ggKkkYK0ydSxrC1nRM7t
   qZoCvcfaOdpzzFLx1fHtchCSRkLV3ZOL9r9ss+yHHN+61xrV1ftH2fUQJ
   6OtXZJ8L0YYGjg9FiLz8FVT/eWRzsKUjDm18qQ6T/fMBTJqrtrv1qRv/V
   Uka9Pn7L8qt2OlLPXj+yuMR0jVU38WT5NSLdvdxl71Wbod56IbpesL1/Z
   R1b1SZS/4uVges8iY5sZ3hwBIcG0uP91acHSY5vCcZ79JB2/qAbkFz6Lh
   ovZ3yFo641esLn84GxGunJXR8pLkGgfQtcloQ9m0c5bdd7G3ZDwlxitbg
   A==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="113504686"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 12:22:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 12:22:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 13 Sep 2022 12:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD/rtr5Q96/2/jgSiKw/E6ryXeRxw3JcoYsbc5DUU8Wg7PO+wL1rW/+bUZjsO2UJBJePqu/MnXiVqJ8sYZNI0/cS5b9eexo4JVR5lBR1uYqZBmDUGBF5uhfeOfbaNOOmLqYiJXY7d6fE9Wv1zFdknzdno5x6zqj9akKkF8Oxr0NzZFJiaHD3B9QwQiyYZj7U5FO/HekSK2tyvSPQ6f3/HYi0H/3ww7Xh+ZgLI4B1Kzd17ZpG16RYjWL3du+hwd2iTsP1ZmWcBPX7MdBOeKT3DKbfoPTgW4sc4+7ndE/F6ki8SdY824YHAd3ZWOyAxEDbzbje1V5KXR30b90STaNAeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dKSk7/haaYdMshcPsh7iyiM1v0f+kc9de5s7hjIhMg=;
 b=SWLfnAeHVlsr156rvb3gxqS97Po8Q4osJvCg/+wLjO7vXtTEHM57PfJwfpFd4RyI4PhwG5YUqS6W40T7BYBFnBPqAk/4zZFyToqVpCsbbr+ljWRwZNkXFrXKnZh/kn/Aji9b6DYOOB6LcVA30SSYqKagyRoLq6ssKZ55mhAsv0QLrYoSJvhLZVLaeTonnf2E8Lnu9C+71aR+OPmDzE2+InTtFvRLhpgMijxiDxpekTr86GTUYGmqCH31CBbUlfcDZBVLGrAq8lEefGgrwws50ANlbMrQgdlbjutTxLOPOti3JU30U1YwTine229/Ns8mPcimXDjo2tYO0BCtb1UxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dKSk7/haaYdMshcPsh7iyiM1v0f+kc9de5s7hjIhMg=;
 b=NfPMrVrgF2DhFNfbOZDvivLo61tRWn6d/viMQ632Ks+QW+mzNAt8fX67pE1mMYjBw9j+SHR3iPcHNQeQ0bFpxEDGdQaZ47yRgWDiX8y81+PXQfTKsYR3J3cW+Sq0SpBxctnf04JQVGfQHzmVVCMFMZ5WG12vP3Whj9ubDYq3tXQ=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by BL3PR11MB5683.namprd11.prod.outlook.com (2603:10b6:208:33e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Tue, 13 Sep
 2022 19:22:11 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 19:22:11 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYw3oNia0DwoNaEEmN7eTvM5DvRa3b4cMAgAE4lgCAACWmgIAAh+AA
Date:   Tue, 13 Sep 2022 19:22:10 +0000
Message-ID: <YyDajuBHfAP/dIF6@DEN-LT-70577>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <87czc0efij.fsf@nvidia.com> <YyBI/tF5x+3OE2dB@DEN-LT-70577>
 <87sfkvcubi.fsf@nvidia.com>
In-Reply-To: <87sfkvcubi.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|BL3PR11MB5683:EE_
x-ms-office365-filtering-correlation-id: f75b8d6e-2342-47ae-f2ff-08da95bd41b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: asWc6rCTJ9TePK5WFGytD6eujgSLn0OzJomBRtQqY6uZuKqCVAh039UZCpfERgvKABnsBQccqX7LqiWdYl/4gmGjp38sBI41Q/8s7ZChFJGtUiJj5HSYyS0b2s0f0MrnGPL89jmLmhbpLZoOPC2mh2xPgkusW8nlBVDQqICMCGMPzyi67/T0Vdb+69lF/BOf8js9ZWefOF5aj/Xj7M+b+V2v3WrCEej4iGhGkQ9NeN5ZBQR4c7AB04eJyeXOxxDy06iJIqMZQQiEkJXP2z80Do83aey6eoevA6d37V6cW0dAD3r7r+7xZ0e/cCLUwInTfAydBUoYzGFwBWlC5yP4toZLWHsSqVhM8iYuw/G6eNvUv+ot6ecBnBXV27CTI1uXjx4PU7vbo9dyVOvTtPp0IGMWlX/37/qRro2rt/koK0IIYeh8ezVaxDn//85IWMacVEBHN6LEbAVbZWl0s1FrgSoIaD4T4LXRjwzbOXV5Qwk6uvXCqz9aNhIb3YqSGg4ox4ZwuEur287C2UZsBVdBxzIRjBoHhp3xLa1xv0GdxSJDbzkBU2orCHSiZ1zUwlYGu0zaRPyI+cSodsvFVVRNM+g3U7vdTXQgObvwDJLkfvb92NdNWkkj28NrPMIKASieDLM+rpo0UGjwr5dSArTtfaksFTTb0xVFLX4Hr8JQsZ6yFypy4xwEg5eTFqE8+7C3Nep/D5lOnOoPb4GNisTqeuNLFXn/9JWd6pENc1b+LIhKsDQ11ssccS3q2fd8hPEHo04d7TGZXJfg89ZO91eZsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(41300700001)(478600001)(33716001)(6916009)(91956017)(9686003)(38100700002)(6512007)(64756008)(66946007)(66446008)(6506007)(54906003)(26005)(316002)(38070700005)(6486002)(83380400001)(66556008)(71200400001)(186003)(8676002)(4326008)(122000001)(2906002)(8936002)(5660300002)(76116006)(86362001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1vVXolvQxrnlY1punYSplqFIwrole0HTRPr2cl4Z79Pqo0RY4mXS/YXoGV4D?=
 =?us-ascii?Q?kvltrfx+6n+bHQ1yRYfcCra2D0SUqNFii8HM9Gfj0MUwRHzRK3LHg1TeG7OI?=
 =?us-ascii?Q?u4UVGfsFGMW8kxAGZqP0x52afmoD3jQRoswhOoubZQgnKRfwgnunpXsZVG0A?=
 =?us-ascii?Q?54nLQB2F76KNJJxezU+e0vuXG1vhjW8zNiDO6kYslho3ucG7iaCj6DTFWirl?=
 =?us-ascii?Q?Vr08FGSKpDS7W44HNraT7yVAQP246tLKmafmjNUT9x3wI4xEAJtmW7OVbGnX?=
 =?us-ascii?Q?L4jB/E0UwhC6ZFbcbQGM6uNdWs7j86go9+TfailQrNt5XdW3AFODpzrjrdqN?=
 =?us-ascii?Q?LWnPmqlS7Af/AeHrGQDgxAA12C+KQJM1yNLqHnYiBQpjdAzS5H0osdo9WI4N?=
 =?us-ascii?Q?XFJelBe9cnrxpc3AgTFLDts/hCLL/MVnVhyL6S8Mt5o8J4ReOq3hadEB89IB?=
 =?us-ascii?Q?oLf4AgzyWg+00rqFOE6gZbz6TwQwo4nwNg5IhIZrGWnQqAiryy+qVF/jyzBt?=
 =?us-ascii?Q?FLXbz1Dv5aUs2oufFzjDYG3D2/jIjvejTGyJnbFn8jx9cTF+bOR9/U4fzyXo?=
 =?us-ascii?Q?he/ZmrVCQBHX8n0CeAiIrkA9COknkRaUo+HfWXqDg4VHtaqM2aqr8bCfQT3Z?=
 =?us-ascii?Q?VX8nHRg/93Hrc+KjgGoFMFiAoHfVZ47b5MTOY84OYTfm6g9Ko9z8uHBO3Ycl?=
 =?us-ascii?Q?RMImDVaYyZ+xQYT8U7zc0Og2EGh3/Lnq3vrh4TrdsY0z3UolMlMF3AcPZdHm?=
 =?us-ascii?Q?247sBIRbyK/5Py0JGrqNC9RibheRjeOWTEgA/WeFJY1zfKvQWe5lhqzVr1K9?=
 =?us-ascii?Q?eBlPBjzhOZgSGWvNsMc3/7kqFxmsRLKzZkZzZXJAcbsbZYshEPnkK9Sjq1qP?=
 =?us-ascii?Q?LZhMoVfKTOLokYqMThqGHlYJpWHP6mxgcUJ6XQ+4pAVygi6Q03HkQI/vNP8j?=
 =?us-ascii?Q?6TapvNAha4nFYHfY6T5CeByTcW75qnpi1te3LFCWys5LHT5N6H4gR9x3h0Uw?=
 =?us-ascii?Q?+2uNe2rwq3BtdElPSsjQeW4STzF3gtaSJdlqHZGRp/IaresLdfAbuCfegCNz?=
 =?us-ascii?Q?ckvAOCop0G47qvB4tcG4GDn8zg/YmKJSQoKdnjDlOcg0fRsQqXUXqtzPZpDa?=
 =?us-ascii?Q?mKvKCMeJZk4yAPZW2Gtn+MNR7ws7Aoan+cMTQ/BTR0KH65T0Cvc/Ytt/sCk5?=
 =?us-ascii?Q?JTx2jWgdwA4+wJ+4esxlMxpdNtcvGXVBVf9jOPDp3+0OSY64okJYmpQNXDIJ?=
 =?us-ascii?Q?E2RccyFdWpu9hZp51ZWyRMQcAcnzKH0fPOKejrlSqLmmEqca/qJdqHDp/Zya?=
 =?us-ascii?Q?wGL0oN+iaW6ba0kBL8jz2Zgj+brbIXnpI02zI+4HKuoNCZEaNnqt8edML/ou?=
 =?us-ascii?Q?HHl0xCYvSd+3zhinmx0XZN1QBzgKpOaC2bF9a9sCInHwI9kitXh2ei0L3EG2?=
 =?us-ascii?Q?B2HkAQ7TvnSuiZHJeQ88RioZxlKAy2oNasRRoW+EEXpq2aSlyZBHeN4/iuWi?=
 =?us-ascii?Q?U3XFXOFDcdM4GS3+TW7ZylwNUFevEDPwF25asOh9hmvomo5kEH+NGLWHJp2m?=
 =?us-ascii?Q?EHKbophMBD/pCMpzoHavj4K0N6nGby+DmDsF1/yIF+nBpnZG70I6emFy+v/r?=
 =?us-ascii?Q?MdqOBLCFMsHOoa8lCXK2yq8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F21B7771F332E04F889476BBFF6DD9C7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75b8d6e-2342-47ae-f2ff-08da95bd41b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 19:22:10.9493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2U5pTensTHcHhWj+cEHLxvtmSnn5ptTaMdOSyZv+XGfoBBNku1q/dOCLl44K6+AxmeDxlsaWZpdqUl6owGbEnohqBBuc2yYsS8QUn551aN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5683
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

> <Daniel.Machon@microchip.com> writes:
> >
> > Petr Machata <petrm@nvidia.com> writes:
> >>
> >> But of course this will never get anywhere close to that. We will end =
up
> >> passing maybe one, two entries. So the UAPI seems excessive in how it
> >> hands around this large array.
> >>
> >> I wonder if it would be better to make the DCB_ATTR_IEEE_APP_TABLE
> >> payload be an array of bytes, each byte a selector? Or something simil=
ar
> >> to DCB_ATTR_IEEE_APP_TABLE / DCB_ATTR_IEEE_APP, a nest and an array of
> >> payload attributes?
> >
> > Hmm. It might seem excessive, but a quick few thoughts on your proposed=
 solution:
> >   - We need more code to define and parse the new DCB_ATTR_IEEE_APP_TRU=
ST_TABLE /
> >     DCB_ATTR_IEEE_APP_TRUST attributes.
>=20
> Yes, a bit. But it's not too bad IMHO. Am I forgetting something here?
>=20
>         u8 selectors[256];
>         int nselectors;
>         int rem;
>=20
>         nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE], rem=
) {
>                 if (nla_type(attr) !=3D DCB_ATTR_DCB_APP_TRUST ||
>                     nla_len(attr) !=3D 1 ||
>                     nselectors >=3D sizeof(selectors)) {
>                         err =3D -EINVAL;
>                         goto err;
>                 }
>=20
>                 selectors[nselectors++] =3D nla_get_u8(attr);
>         }
>=20
> ... and you have reconstructed the array.

LGTM.

>=20
> >   - If the selectors are passed individually to the driver, we need a
> >     dcbnl_delapptrust(), because now, the driver have to add and del fr=
om the
> >     driver maintained array. You could of course accumulate selectors i=
n an array
> >     before passing them to the driver, but then why go away from the ar=
ray in the
> >     first place.
>=20
> I have no problem with using an array for the in-kernel API. There it's
> easy to change. UAPI can't ever change.
>=20
> >> > +             struct ieee_apptrust *trust =3D
> >> > +                     nla_data(ieee[DCB_ATTR_IEEE_APP_TRUST]);
> >>
> >> Besides invoking the OP, this should validate the payload. E.g. no
> >> driver is supposed to accept trust policies that contain invalid
> >> selectors. Pretty sure there's no value in repeated entries either.
> >
> > Validation (bogus input and unique selectors) is done in userspace (dcb=
-apptrust).
>=20
> Using iproute2 dcb is not mandatory, the UAPI is client-agnostic. The
> kernel needs to bounce bogons as well. Otherwise they will become part
> of the UAPI with the meaning "this doesn't do anything".
>=20
> And yeah, drivers will validate supported configurations. But still the
> requests that go to the driver should already be sanitized, so that the
> driver code doesn't need to worry about this.

Good point.

Will prepare a v2 with suggested changes.=
