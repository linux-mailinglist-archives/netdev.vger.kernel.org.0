Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3735644FE1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiLFX6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLFX6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:58:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC8418396;
        Tue,  6 Dec 2022 15:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670371089; x=1701907089;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IGsLJytAEDKFXZZzrYkZdpJpoYYHjwoS1EwndoE1ap8=;
  b=iWdtRtAVsRBH3P3fUsWSkXbTkWcTTc0KkfWy8+WTtVR7XSxO/GHdRAcu
   ErNr1AuSH/OmacAhoz9Ka8fbCApmc/Zv/RUfS+GDw91fqtXo23sv3A1Me
   AEFyo6WLpYCFLar9VC+uxGhaxCKS2dR+MO1W7+fWpHMsVDzjPqWTH+pC4
   ko/K6zy4AaA0Ub1tByN+uGFn9lYGWu8TUgNcDJG2nW0eDMku3XdZprv+7
   k8WnrGotQdT4NUFOmDhDF5Zm3GRSCJbVKqB846/A04ZYHsnwUGqUp4Plx
   BfiO0llLm7auIZb3Edf+e6kKHt96yTVMbkDRWAon7w4lhWWgAIrdyrHZQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="190374303"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 16:58:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 16:58:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 16:58:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1KJOIq336Caz1ztqLsfasBKMl4EUR7lCQLgvbrZ76NJeoLkPd8PJSYee2um/7ySVfOax5HyulISDaAvGSxDYQG6a2Bze78R22pSpPM+HzG5OMB7dEUw52tOlfX5NMF8xVS0kwen5TG269d5A6AmUPPwcTdt0uC6SAkKxpwT1KB7kXDOW/9OCIkw03FYXPOVEk6z5N8Lm+Z36w5oLgI1XBnNwfs+HPxNk0v624DDQlIXBng63vk29F6dA8LAt4I9GSsA/JyY7I9tJm5HBQ/MD6hVSGc/qUVwmOHrHXi9pMmNAedncjD8BU+bQ0VQDBC6aoihLvOz2toje/KIp2zTGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XCbG341gF1sAXxHOvCOL+i9N7gPb6MT/QXGcbCNA/Q=;
 b=BfLGmdsvACtOIxo6HANS0cQpCoL1yeXtz9qsihib/4wrvvAfWfyXRcSb8iXAQKJrMlWVspgGk002slc0OqEQyevJUwCxHYetIJteGpYotCetA+mC7jL9ciizbgYPTGP1UWGqW5AtcqVBSMX6xQF70ahC8w4ypwJ/YxDCCgc5eXHWigzhAdOox7g7iRco1mZAwnBi9yorh4WPhAgIwh2RaWbxPqEvNoSYKZilWyAn/3fSk3C1qC6cmaQ/If8XcpknoVWgTaDNij0fGt5AH+yEU69Q5aG4EWvO3Hb3lYjx+yDQLw+0sx4Q9GVdYRTyTft6K07lfEfniDUG2Ka4cbu6/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XCbG341gF1sAXxHOvCOL+i9N7gPb6MT/QXGcbCNA/Q=;
 b=JLUQY6i9KzHrARqJZsS1IoF0GufdJ0TlXNubZDvHTC+4a6fSC+Z5k0ip4WLmCCkLJu0kbchxSkXDCer5TSpFCWj4ULNILBN403Hlhk+ktMvZIN7HW+NLlOEWiX4q83r3b1xtoie4MQ4xXQgBdyUl7xw9FLaYAX1NX8KBaDiswkI=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by MN2PR11MB4725.namprd11.prod.outlook.com (2603:10b6:208:263::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 23:58:05 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 23:58:03 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v3 0/2] dsa: lan9303: Move to PHYLINK
Thread-Topic: [PATCH net-next v3 0/2] dsa: lan9303: Move to PHYLINK
Thread-Index: AQHZCaGEKziA51mOckuLLq6J9mjqHq5hNgoAgABQ8oA=
Date:   Tue, 6 Dec 2022 23:58:03 +0000
Message-ID: <MWHPR11MB169321FC086EAD9BDFECD40AEF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206185756.hfecpkcy2lqahng7@skbuf>
In-Reply-To: <20221206185756.hfecpkcy2lqahng7@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|MN2PR11MB4725:EE_
x-ms-office365-filtering-correlation-id: 0c0a6635-ae90-4408-ef09-08dad7e5b69e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcMdRJPqYZSfAT7zY+dyN1ItKb9C+DkIu0VEzOPXx1dNsSWoKFePLpyUjrWM0uSk3O/rRGbcT6kaGZH7oPgbVUIcTGlUALZvBcBRQtmheV4GW8VGyVLb89yN8m/zz0nAq0Qx/ecelkUAWQtu3p5/5JOWlECn6ZLyD5UGdf5uCuqYkyhXJqRsoXfdHAYbCMDxDQ6KS6fO4Q/U7yfeNBgLZOY06cXd4xYd/JxV0AP8IwjsOFZEHpBB0J6GHFATpM7yZ7wkv9pBTQ3SOHgfkY51Kb99WLm3YXlBp3FtBbe7m6wABBN5QQcQU7rTvxFAE5511yiWsrl2Z5BaZlmDGZlu88var5h4FGIqGLtuVYP/WQtGFy3cxsIQYvrx0Bed0LzdM0K8W3OyMLcoJNrHuE5V89mK8mlDA3wqj+SOWJLLfSynbWjOMMUXf0mCjljoZDAcXMBvCFYpn9FVH8LzdRHNdYkQ4u/d1VVUO2gcn4CSaUgohm0n8ryMjVZVNTR6twizRWQntSduAPHaTGqpYjhx9s/Z+E2M5Pj1v8V+Q2ZeBRXSxXawtJg3zpMuNw6BnPmpYzc0ehCQ0cwZ06E+g8XvGxLj2bCVQ3q+t/FKHPAVAZC3AAPstcskmhZH+kPxunxZc3h8Qmz48EBikmwbfTltlnHllmIafTw1mz9LsL5hDFwfce+NJii384cHSt6n7we4KE7LUbXxF8qXAv4My9Sskg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199015)(66946007)(478600001)(71200400001)(76116006)(7696005)(6506007)(9686003)(4326008)(55016003)(316002)(6916009)(33656002)(54906003)(66446008)(86362001)(64756008)(66476007)(8676002)(66556008)(26005)(2906002)(186003)(41300700001)(38070700005)(38100700002)(52536014)(8936002)(4744005)(83380400001)(7416002)(122000001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XqnOm5sNBtoGG73pJCBWp4YBkMa+crqPjzG7RndFSymFsuZyJ5bF3HPQFNOg?=
 =?us-ascii?Q?9V8JjQg0rYkwutOsNm2VId9O6DsEGZ9cmLn6+NEZqrXb71D8uaYN7e3SWmmZ?=
 =?us-ascii?Q?0HV09gFiT0s/2+KV0jti1cfRyAyPFvq1ZH1Zn+yV65SaOe8EnwQZLgajNaTc?=
 =?us-ascii?Q?SV0Kq4BzfoppMvZ6BqZfKnab4e8gAdBTPzCUWbS0C0xwFgD9omYHT5Yt3b3+?=
 =?us-ascii?Q?zY53xsPMMCVWxKUegdU3DUPJog5iqUkONTKWcuzee4bNbohGXOxZYgFedIG6?=
 =?us-ascii?Q?EACbE69r8lR+ZF7aMhBGNhW3lnw0crzuL1Gk+qKi96x9PAgDKhEet+nUjXHK?=
 =?us-ascii?Q?gLzxuh+DMAb/JfltAJZL20TYKtlqjntC1dokUIbElrh8sGYSilNUCNjKXVoK?=
 =?us-ascii?Q?oScczuF11uZVaFjtamYB4oFx+4qFUz5wJn3ccHi0c0iEqBRteBkUGydUEIW6?=
 =?us-ascii?Q?cee5vFvGD4Fs3ZYnyoARq/8+2nu5YZXhucnhddzddPx2NUPzZP666/vEaK8q?=
 =?us-ascii?Q?KCKCFcxWslSrh605oQdrZzIV2Ls5/TIeWLJyGhO4zn4F8KeKXhERIaO0dAuz?=
 =?us-ascii?Q?dwumDI3N4pUxvgMUGbi109Ira9HqYIR8EvU6XFt6mZ0ogRt4ij6QqmSzBNwR?=
 =?us-ascii?Q?xoDmV74q6QOsx2adQnPtXwkFZNOC+tFtQrk6XDNl0p60wiVSt8WoRQ7rrgpl?=
 =?us-ascii?Q?lSWJOeTKh05fRK9IfbmWV3ZK1T1lEP7IGxkcFHIq6iKBZJOdRuO7iZ8RXmUf?=
 =?us-ascii?Q?XGcqbKKEb1yohZ0MYR0m5H36EysaAFbs67CrbiON4UpL9zJHk9AbmznW4F3s?=
 =?us-ascii?Q?Ilk2tjBqv5rUAcby6TuA3xT+iMBtWFf2k2bKiMJdKavSSYH3KHp3jU5td2e+?=
 =?us-ascii?Q?+1uq+6IFMfoEG7RP1C3OM+5iwapXLjF0EX2oLQeRY3j1SBeJzmtQ734ztGo2?=
 =?us-ascii?Q?fObOPTnlUJxLr+g+ATwqq8pUPNpPOCQH0J3U8FMsAcDONmHKSCqclFfF1BaQ?=
 =?us-ascii?Q?+RMW90Hc4fIgBCZ2eDnAp62r7HfaNcFYlqVo5k4kWWF3hP55BCH/i315xCEV?=
 =?us-ascii?Q?t5FM9smaj2rWV366XMewAogB0wPe4kjMfp3vI/mlrmbHOxRuNb4JYqcAyIDn?=
 =?us-ascii?Q?sAt/sX6IB701rDOLuQmWnWVSkOjL48sqI1BzksqTzPHfn5JbaESChSqYO0Ib?=
 =?us-ascii?Q?qC0r2n+XgZaS4j6J/7Vpts5x7UXg8wd0biI3U/PlnG3qk4E9P55dZpCcoBkK?=
 =?us-ascii?Q?EdcOQtosfX6hK1wAFLDEjhM2+LOJG9PRhLmOHUOpKUaqbRXmsYbVttLAHEVa?=
 =?us-ascii?Q?LOSoBdqa0kDUg1Xqzo6RpIgoUYA3cq+A3Ou8qBM1lxFALYr+SHFcuWvWbpen?=
 =?us-ascii?Q?uZVQX3oecQIYX3YB49zCaE3uyedxZAevtg0jvveVbsgyGPfRRtB6J5yhlY3I?=
 =?us-ascii?Q?RBaSKDAnnRQrM6ciIBDF6i34ehM4DljLrXdQF4gtbSgKSZKw/kgq5RXizn/a?=
 =?us-ascii?Q?GEZ8nojVKbNLSSpdkLkje/9QxtjT9GEzrsX5dPfZwcMWYZhdKAmztUeYZtK+?=
 =?us-ascii?Q?o5pV/Qo35cPyrrx0KpISv9CPNYQdJcog5wwq2Ogm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0a6635-ae90-4408-ef09-08dad7e5b69e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 23:58:03.7385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JuaDfPwkaEuOpgK9stVdp8WMYwmgj9bdFe8MtbjCqCEhKf4GX/8A8Rq/S5jjZpJCu1FKAbxahwtbOema/VbXlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4725
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This patch series moves the lan9303 driver to use the phylink
> > api away from phylib.
> >
> > 1) adds port_max_mtu api support.
> > 2) Replace .adjust_link with .phylink_get_caps dsa api
>=20
> What does the max MTU have to do with phylink? What is it that makes
> these two patches related?
>=20

I'm touching the same file, so I created this series of patches to avoid
piecewise patching conflicts that might have resulted if they were
independent patches.

> >
> > Clearing the Turbo Mode bit previously done in the adjust_link
> > API is moved to the driver initialization immediately following
> > the successful detection of a LAN93xx device.  It is forced to a
> > disabled state and never enabled.
> >
> > At this point, I do not see anything this driver needs from the other
> > phylink APIs.
> >
> > Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
>=20
> You don't need to put your sign off on the cover letter.
>=20

Understood.  Thx,
J.
