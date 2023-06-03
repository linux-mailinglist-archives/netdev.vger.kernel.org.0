Return-Path: <netdev+bounces-7610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A35720DCD
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:32:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3492B1C211A9
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFF915A6;
	Sat,  3 Jun 2023 04:32:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667AD10F2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:32:15 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F24BD;
	Fri,  2 Jun 2023 21:32:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEJmok6PcYsIbRugrsPoQrxN/ghLj3hRJqMd29IIdpWA+pHTdyGIIBxauF6KEpYJwU9d86R1NHHUMrnnUQ9KZ7wlf8/wChUcn0zHB7Vo3IpaqzdSZX41dTZhdIh+bfwiRlRHWtUBtV/m/N9pSi9fgAFpzfgHQH0jsRycMOqGZ1Rk5bTTJpd+c0mfW5daFigPQcJf2+klf+CD9QS5UY2g1A0kUtVddEkaN/6yLL7of+f2/M+luI5oR7Du0JoQ7UMehoTDGPEZm8JcHfl8Mwx6iXGCeFej6vpKUz5nGj19HyvLRJ1oCnM/IbHPsDD0++L7SeXPy46rGdi2za43z6myYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rv+jLePwL+yNwGIYU74MJrp8U/OQEKePZ/TnYNvrXSk=;
 b=HEKUDQh3yPgDxZphBOG86WduFQiSSz5RKZ4P4JA0+X4eLAEO7QYFZupFaybzY6bT6GBUL+CXCUWSN4scJEom4jcX0X0BbQqD5da6UhTSDkJ16ugnduP31bpc4KR/9oqSHwrqak+pxcaiIJPPVcQLuaFMhvV3udX6m+2dnZF9iGnsCECeC/ieAIjmRo+bvDHMgpyjbkPK2+X3GiS1EHehTGuF4mXmjcBv1k6hptBFb8vPnE6dg9BufGIbijaNzUbRIysfs2pUduq4BQxhYFfUP7HgHbSVnBQSCCjpdnDkRVWvfOj3fo1x5/YoQztR7wfj7fIva5He8f0ZaDXJ0fir6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rv+jLePwL+yNwGIYU74MJrp8U/OQEKePZ/TnYNvrXSk=;
 b=JLceayaQOo3MZCLFZJkNiabg4zzI/V6OoYmZ8lPg/qwmbU18Ns19o3P7JVs3W85btFo0EaRLXQ6ePH2rfkIjbdlmkWjFAmEifv/qcUOwjUIXTnBEDeULIDRiNwSrijBS7TAeSp2AOAT+tf7cNz45che6lF2b1spHjXexgFYWHQ8=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by PH7PR14MB5865.namprd14.prod.outlook.com (2603:10b6:510:1a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 04:32:10 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 04:32:09 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "linux@armlinux.org.uk"
	<linux@armlinux.org.uk>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"simon.horman@corigine.com" <simon.horman@corigine.com>
Subject: RE: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZlOeZhHXye15LEk+eN0zupHuzTK93JOuAgAFZuWA=
Date: Sat, 3 Jun 2023 04:32:09 +0000
Message-ID:
 <BYAPR14MB2918BDA8AAEC5413A0CD523EE34FA@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
	<20230602001705.2747-2-msmulski2@gmail.com> <20230602095349.2ab53919@dellmb>
In-Reply-To: <20230602095349.2ab53919@dellmb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|PH7PR14MB5865:EE_
x-ms-office365-filtering-correlation-id: 85c8aaaf-7a81-422a-f67b-08db63eb7e5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Yq3pxxs5UeecRjdj2PA9nXQkGWsEDZOoDbqcHY5WbbI1UrAUitJvcKCct6eF78HT2S3I0th0BKCLI4AaGXubCnpnk70zKvytikTEQO5va8kweHya8HKZM+3uwb0xjDNmOSDjB2vNGT+9Mift70/CDjLmQl9APiAtKJg79w4rFYj9V3OpHuPiJREqA1/i+LTIWTEk+2u7YaqoXYAYfvOXwHIHghMVsLpdRdQ4rhFOBXwuqaIax6E0ASCzCuHc0VfpzftJN7XcSp5c2vUzuqZ6kS29m4R4zYKpm5pDXSQcrtiw8mtWJvP5I+nj7lXmitoyUA3hpgoLoKfh7u8j3n3bqFk+N6K/D4jkTJiHp/FUVjUmzXm8RmZCWETaXahlwYoBgfCznNk2fnCFsZkECIVYZKizL02tXhiuAQ7r3HYcntlpyPesdtY4vzdG/WE7FZx0Cw4SSS6+skWlKxyzQnjhmieRohmuSOcA6dkGXV6m3tGpi98CJEp9CtDqEw3WnL7gdZKDWq1UEa/vr09OB5K1Et9npTmeiOCwRIMJSe7DvciV+xT43cp6TamkiHoQfV0Swdw/IkglJj7ycHKCAEKGraPNr4LyawhAs3gIwQYZpOCNB9obamoLwH4FM4gHn4F913LoKxboTt0I82+qkLisCA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(451199021)(44832011)(7416002)(52536014)(8676002)(8936002)(5660300002)(316002)(41300700001)(2906002)(66556008)(4326008)(76116006)(66476007)(66946007)(66446008)(6916009)(64756008)(54906003)(71200400001)(7696005)(53546011)(6506007)(9686003)(26005)(186003)(83380400001)(66574015)(122000001)(478600001)(55016003)(38100700002)(33656002)(38070700005)(86362001)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Ntq16Z8UPpXGexrqssy5ScyTVpZOgaDr1RhjddfGcPp42mW8Sui1vYWHIl?=
 =?iso-8859-1?Q?ko83uamME+IuuLAmA+bU8PfU+XvMoSkR/MZvfDzbmxAJ28CDlwbouwUwla?=
 =?iso-8859-1?Q?FBOOzCxojSxeCq8T8CQOK2ISjujzNXSdvgCfmZc6JGe6QvGLwLi5bfDWuN?=
 =?iso-8859-1?Q?0ZPeWrBENxTlIxnrIPacSFDSDUTZbjYYJCN2YLR1yYhJuEFg8n+PN7R/5/?=
 =?iso-8859-1?Q?MVrNm3C9D5FPVRvgvQZXQHKTYOsV9GGKIFyT3LMdvOfmQnKOQqsbt6+gSB?=
 =?iso-8859-1?Q?u0qYtXZJGDt0fyZdNw6mN9GPrx7g1EAXmS5LHcPbEU4RKTKoDlvk8d2+2s?=
 =?iso-8859-1?Q?XCES0pg7apT2ZtwLbeBakcNc47rl3iAHhGK5Gb8OHAMLnmxT4gM9l5ffSx?=
 =?iso-8859-1?Q?f0Nt/Ms6EyTeAeev0F/EbZdC4hW8aPuxo/8AlSVf0LfzSYuOFjCzHWuFem?=
 =?iso-8859-1?Q?c1cz2B++uf7DZpLVWTpKUU01D3smnZvNH1AZcFOZAHTUXM8NwrUiWTIMrU?=
 =?iso-8859-1?Q?KC693DDvkRvkFWFc8xyV2W/fEshmpJveLLZMTwl+qL3JD6EAzacOKCmGqI?=
 =?iso-8859-1?Q?x5nczEWygEFK49H2Q2RsGI/Y8WxLqBA8+gXa+YzSaCzeM13RKA5LzOnq3A?=
 =?iso-8859-1?Q?jWRoLEzxXI9fA94ulFD9bAuNdkvbgOknOpt6A4VDLY+RDOvjt4qL15PGWn?=
 =?iso-8859-1?Q?aNohdw2BYQEnBUleDLJZoPaRuVZUPRe3AL+XQPNKa1SY6NcAX8F6k5a8F9?=
 =?iso-8859-1?Q?RgNPtTO+BBfG0UjyvoJ7Gv0y1AimUbdEaSjFQUT+3dfvN3Uv5XC2WORTlF?=
 =?iso-8859-1?Q?j5cOZdmb4VHiWOHcOf/qavCqh3oay2K3wfh7kcxOUJgt3dUEM7OIYWdw1a?=
 =?iso-8859-1?Q?SHb5gcxaBR9R2FAWupfXrDuI3HDlfHvE5g97tnHMp96d2j2hZ37lpxWMVk?=
 =?iso-8859-1?Q?7QVpSmMLEXoI+OgwGYRrmEnSsN8uXrdkjtEyJQaWH0P6TUkDWExLxhyNsT?=
 =?iso-8859-1?Q?xmqOLuJkCIvnowGjKzIIIS3jhKr1N/P4ntv9YHWmOpqIhcptTSUA4M0KED?=
 =?iso-8859-1?Q?fyhRbH5hvdkPCOpGyW2crY3JEgmrw/CK6wKfpT77gQ65OOXcBtQx/O5bhL?=
 =?iso-8859-1?Q?fGKdD0d6gPPR0vGSpnKmqL7zR+5A8CMMNc/jKXMKUpKjGefss8pjHsV2/I?=
 =?iso-8859-1?Q?JpgMxAj67USHqhjGYutHgPmGJDOp+4NqapJ7mRhzG6cmt/ogQYUuZ+HvjG?=
 =?iso-8859-1?Q?6N9ZkSM/+OTtqJT//0hzPgEiXztpOKDk4vNwNoikkmUfRE3b9eKfp+l1zT?=
 =?iso-8859-1?Q?fbu0jfR1AQ0dZQltjE2ZlA6uu1f0WlasbX6+9wpilmGxFMtSozBWJJIHaS?=
 =?iso-8859-1?Q?0E8dekqzs06H5R9b34HpTcP/DCCj3BIukXk3aN3yKZ2WgNoJjRjjIgWQqI?=
 =?iso-8859-1?Q?wTprw6IaUyvJBsXR7vWp4O0eqCgSlBvO51GG9rROIJgSr30D85lLeOhV5n?=
 =?iso-8859-1?Q?7jABBnI28kcYlzxVwDgmmeMjTZVKjQnDj77ss0MPwswLUyJvenFlRKSPGC?=
 =?iso-8859-1?Q?iH4XZ/XO6QfSRBVKKbXkU9JkgoCDDZ0U4e2ynVNllftIYOmY4Ndsanpgez?=
 =?iso-8859-1?Q?6DFiEURx+qWtJiOD4AGifQGziDTcn6ky/0?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c8aaaf-7a81-422a-f67b-08db63eb7e5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 04:32:09.1075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TqRQiYcwmDtjoI9j6VYomyISRiUtNLwrkueOdCPENdIiVc9pytXAYCDFlWtXzRVHvOZyv3ds0ZE1wETtA/0+Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR14MB5865
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you for the review. I will make the change on the next version of thi=
s patch.
Michal

-----Original Message-----
From: Marek Beh=FAn <kabel@kernel.org>=20
Sent: Friday, June 2, 2023 12:54 AM
To: msmulski2@gmail.com
Cc: andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmail.com; davem@davemlof=
t.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; linux@armli=
nux.org.uk; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; simon.hor=
man@corigine.com; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Thu,  1 Jun 2023 17:17:04 -0700
msmulski2@gmail.com wrote:

>                               config->mac_capabilities |=3D MAC_5000FD |
>                                       MAC_10000FD;
>                       }
> -                     /* FIXME: USXGMII is not supported yet */
> -                     /* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported)=
; */
> +                     __set_bit(PHY_INTERFACE_MODE_USXGMII,=20
> + supported);
>               }
>       }

The set_bit() should go into the if statement above, since 6361 does not su=
pport usxgmii:

 /* 6361 only supports up to 2500BaseX */  if (!is_6361) {
        __set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
        __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+       __set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
        config->mac_capabilities |=3D MAC_5000FD |
                MAC_10000FD;
 }
-/* FIXME: USXGMII is not supported yet */
-/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */




Marek

