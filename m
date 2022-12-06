Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16956444D4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiLFNpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiLFNpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:45:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662A429C9C;
        Tue,  6 Dec 2022 05:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670334318; x=1701870318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pwLz35mjqwC3RQUA7DaMJ3wvBEuAGa7Z4Ven2TVkh/4=;
  b=KV5Ib+0Ym5oP3ZfknEyrY0TMq3a+PZu49w80ElEXjkaoMQrW21RIlPnB
   ZBqKn5hJSoe+Gij9txL3DOyeiuFaWUcuft9BwBm6F9O/lYK9YmfeJnC2E
   xYBVwCsO2usrrXaModM9au6eRdfSQ8wJOPQtCm0g60vnC8eCgiT/tgWCM
   xDqX+OfEy8aZ2WkvPjznNHZeY3iR/GVdR/mAPX0yHkwVx2Q8rqja7I38V
   EfIR9jLbdlSmDvamHYnslmp/KuNnvnIEHZmCeSBxKIOmxoszdiwDZkELq
   v0oYP204cgyo2ApXziSMNtF7PAsrC0SxlVmA6n7j0gfY3gWdkfNlaQQJN
   w==;
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="186779409"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 06:45:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 06:45:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Dec 2022 06:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOhxq6TiSkKCaoKIxHIWp6CBt21LrF90mhM9/SzTp/DV7wff3sjalSeKl5OfZdHLVoeEaRmEPHsnjZKV5QZ6clp5T3hsY8o1fBbdaQa76npJ7aEakg/top+4ITtONLvIc6jy1pHvupn+cdFuKdO4QMT2HVNEFgIJa0sEbPT9Dnq6+2g9B98JXB56vY77tmsn1aK8hQN8oKDskBAL1YQr0CS/tODMUM3NWhBRhFO18hcJvU/Q/M7fywcLARvTkqMyCEPyqQGjlktYcCxyp+EY2IfKjju+hyTdvrLNe5X8np5VsqdQ+OECxptE/KbjF0INLdN5o1Q8qRTWqbjOE8gLPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=401klHf2vN1gBkPfUE2wTkgGpDoM5VjfUyG6ZJ76e3g=;
 b=iN+393BzItCa5v8XX/UA1krFuIHCXRc66Ngj5rOs6n9RjlRhLr5kMoBMw4tCBkH9Waf7LEe1WtaMKKxhfTdGgkJXYBAiCodmmj46Lo2anAy6ozBLZdnJBNM8cHnHGNL7hWbY+yHPTr35Lix+DMOuBdwuKD6IHuHY8C9fqq9CMSlpaXn72t/8SbeJWLL0kTGweV6s/37EYT93WzNFxKGecPyREJn4booOcWOM46CcJKsN5n8KE5uW2xmddkjoVM/dec2CTaPSZiKNla18JrcmZPjUsxgaGuB35js3N0bFXttY9ncWB2uR8gyITmrb+4NVjppm+pk1koKEi3gzgMCUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=401klHf2vN1gBkPfUE2wTkgGpDoM5VjfUyG6ZJ76e3g=;
 b=rBZCvK3d+QufC4hKu9qFeMTEnRjRsmdkNI1Xmu3bubQ+itUX8vv/URYLH8DktHk+Pei8r6cn3EiU3jEktWVM2Z/7y/CC9jW7vMMUxyXvM34ahjELiQfxWfBcd3loez/aPgEE8/n2im6zBk2N63UFV51hz++0dGzJowgBXbgO9KE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DS0PR11MB7531.namprd11.prod.outlook.com (2603:10b6:8:14a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 13:45:12 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 13:45:12 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Topic: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Thread-Index: AQHZCUVX+xhZw8rF5EesOiBOrBuDqa5g1PgAgAAJjpA=
Date:   Tue, 6 Dec 2022 13:45:12 +0000
Message-ID: <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
In-Reply-To: <Y48+rLpF7Gre/s1P@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|DS0PR11MB7531:EE_
x-ms-office365-filtering-correlation-id: 6fe4059a-470a-43ad-ccfd-08dad7901918
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pVZVU3pq6qnb9pUkRAnygwQSCgezM5gOjDlO2t8V7sYTnT3lq47CZaWSR3fzUd1fWMWUQorrbZRKun4ogl7TzYY9n+ORGB+tDbCiEJvUDt4w3Gt90XkUGeTgiUyjxc/HIwf1O3JbQz9VIJELi0hVp4si83zcy1vL+2SuQ0SoQamy2p7ACgb3MRmGryY5iwspaFYFITaqCrWR73vbnSY1fSgH64a4utWBAbjxeOX7uF9p2lqpnBt+qjujTrXmzC9a2CN2856b63gfH+5/AfJneIVEy0xKyEJTdqwkkQJNWR5DcWK90r2lFSPZJWNsf737Md0oXII2U/PL64sWlMOOtzvt1fOtk4cJUh+Rao14uoeUMCBEjh1CTy2RItRQeqS6YWDMmHos+CqE0HzNAkzYHzf/TrUASdEByvIyfwqcy2HZSOuSSLMvJtkueijwGTim+2XUV3sCKIg74eWnEWSk9OjTxKwRAbEEsHNIGaXWhNZWg//V9QcaEhYQJwWacv/tEKEQI0rBtAv29UI/o7f9Lr5RprcCfcGo6gN3pDERJrRsygY/6a2v/k5QBpSotvWjU0pKkuioOkN9xjKk6oeK8uA+InyCicDYF7Bd9lAMcayR0yhe84UYALqbRRzZO/LoGAb3h2vgGBhjZRa6O4RK+RNCWRQEFaN4UkzqvTAXJGItSzU4lZOZWcv5gUdXorBETt3OYdXzndZkBRZkk6t7iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(38070700005)(55016003)(86362001)(33656002)(71200400001)(53546011)(7696005)(6506007)(478600001)(26005)(107886003)(83380400001)(7416002)(5660300002)(41300700001)(4326008)(8936002)(316002)(66446008)(64756008)(54906003)(6916009)(2906002)(66476007)(66556008)(66946007)(76116006)(52536014)(8676002)(122000001)(9686003)(38100700002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jl+go87NskpPsWY5OWjuoIFwW4VGCm/mwLEYx5cJWiYkCuG1xMzxXDzW0Yl3?=
 =?us-ascii?Q?+FzeNAmd9GQqMM/a5CY7VBtWlgt0QLLeqBQ+9T1PixL/OCEdYsiZhxTzMKNv?=
 =?us-ascii?Q?t2Zp8Q4gf4nNZtAv5Lq2as5KXYL6kHXV6kUoEG31nQC7qAlcswRZKft2bthS?=
 =?us-ascii?Q?xo1O6nQYFok9pqkn03RIx8/nuKu2PJNckEHDvRrCakuVL2RxeBtqDi+bahNo?=
 =?us-ascii?Q?Erw8M/tC95pWqTJhk9W9GR0IiejPmy5VW7a4URZ84RYOwlEGaxyTAKQ2a3Lf?=
 =?us-ascii?Q?3z5KvnAJPFjt048WeIVN8wdXszxARLS+CsaduDABN4jPaPre31JWIJhKGm2r?=
 =?us-ascii?Q?LdcZlFFjugu7mZvKUE6YBMQ2s/O7YkDhmCrjcZqnLzpCK3y+co20AZGYRWRI?=
 =?us-ascii?Q?JBL2mfKOR0BHldR3BTdxdQsiQaIxIg39yroDbMohncQ7yyOPun5NkQW3jWR7?=
 =?us-ascii?Q?POR6lNip1LqUA9Ytzn7GMFXxtigRPcGrLIcIdnGcOyBrFp8LNuY11YbHbYbn?=
 =?us-ascii?Q?omYv0CYxMFUcSpLzgSKHeu2eanWGXDbyiqsd4WcRJ+6yp+tbHnnwG+wQ+vwv?=
 =?us-ascii?Q?fFh2iZvPsk14MPNrpDCBOtBtXYTuVy8JBoyIvng/WLqlSJkvisAPrZ3lG3g2?=
 =?us-ascii?Q?NHYHgpr/BHk/jJn3eq58FtZAdaHInODadUkrP5wHD/qnvLhf7y/FEQEXNlhw?=
 =?us-ascii?Q?u0i6TEndIhpOobLnvNlAb8t74kwGM7zvxk5QfIVQo88MNpOU5xOZUtJ3ETiM?=
 =?us-ascii?Q?yK+vTi4+a845Fm8MtTRMAavdNJlXYcJeI+1rYooXUzM3s+Orb8N1W1WfLv+H?=
 =?us-ascii?Q?OlhFLlFGRJGFUWalpWwiKWttTS4fLMZdiflwaANFkrL8A61y6KkjKs2jzzgS?=
 =?us-ascii?Q?oD64acOjtQvnJZG7etxDvnWH6OgpYtOrCua0RJCnbwRY3g1xaDWwj2We5vHG?=
 =?us-ascii?Q?4QFHppi7/4d8tk5zBJ14mCjCcKRa5DvfRlySE/QXUxfYuzgKk/xRY652bvaL?=
 =?us-ascii?Q?ZKH5DTl5sM04f+OvjZddmrr1y5FTcTd2MFvLTuDEOlSrkAakj7yxo/SVW5mY?=
 =?us-ascii?Q?9t93u3l1MuP8a5p5TR0N7MgQ/qleFSh2kq4QklcH8qNtWPlkoND214d5PdXO?=
 =?us-ascii?Q?658DRkoGAC7bHLQ+R0Ic7K7RrSjl2D2hOjBvaEkOwsaEx0NlXMXIJL2D9W3z?=
 =?us-ascii?Q?Hppt8aEo5+LlHBv2swRJqObbSu0MjnaWI2TavGCVMCLB+vYaIILW+Rv/A2w5?=
 =?us-ascii?Q?25iX9x2HdK2npN8x1ngZCkuwwMZYMLDwF7B7puB3PZnBW9b4nzfs9vEdhyl8?=
 =?us-ascii?Q?kmnkzlx5TlUvfTBWlhUYGvhTINPZrzu1uB/JMrASc7C6ZIrZxU+hQxZ7Y58y?=
 =?us-ascii?Q?6rVJuGF96G3DuVk45kc6rGs9nN49hHNqsqZjW2YXUh1I0JlGaTj52FDLwELT?=
 =?us-ascii?Q?EYFOC3hT+W4W4+aNDaeQYuN8FLbX8HsF+YExb9iZGQyfPxllisslJp+KbC5n?=
 =?us-ascii?Q?onrvOy7D8AMcMh9xcK2TsPLLYg3WmH5MLw4sxrwE7vFDG+6ZX2JFFCQ9JDM7?=
 =?us-ascii?Q?Yno7L+GeRxCIOUyFdcQ33Ps2bzccfgm7kwQXf/pOQwhS7m4JactYxBYShi9q?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe4059a-470a-43ad-ccfd-08dad7901918
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 13:45:12.2196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlPFHtbrKk6TWRBOg9Lo7qMzph1Mgb6yq/QRBlLxDsChOXgmSlLOf1IypUemlj99Ds6FL0EALaUwWUfO8dSSmy4CRF725B/CbN0wo5enY7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7531
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 6, 2022 6:38 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> richardcochran@gmail.com; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing =
zero
> to PTR_ERR
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c index
> > 1bcdb828db56..650ef53fcf20 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -3017,10 +3017,6 @@ static int lan8814_ptp_probe_once(struct
> > phy_device *phydev)  {
> >       struct lan8814_shared_priv *shared =3D phydev->shared->priv;
> >
> > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > -             return 0;
> > -
>=20
> Why are you removing this ?
>=20

I got review comment from Richard in v2 as below, making it as consistent b=
y checking ptp_clock. So removed it in next revision.

" > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> {
>         struct lan8814_shared_priv *shared =3D phydev->shared->priv;
>=20
>         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
>             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
>                 return 0;

It is weird to use macros here, but not before calling ptp_clock_register.
Make it consistent by checking shared->ptp_clock instead.
That is also better form."

>     Andrew
