Return-Path: <netdev+bounces-7612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1C5720DE4
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D675C1C211CD
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD7F1C3F;
	Sat,  3 Jun 2023 04:59:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0DD10F2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:59:29 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2062.outbound.protection.outlook.com [40.107.96.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3E9E48;
	Fri,  2 Jun 2023 21:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am7c0t514Gx02HwI5roNcce+fS6JkioqwFq51kxF3RwQ9B96vHcSuRSmt+FQUaIXJoq8qYWIyphQ/liviNSBALfygjRWCYoB17sordNKhM1Q11maibdW1KGrHxtrP588ZADbDEK4UwGUhoBfR40YUJJMn/zxUYDdd1hnC/2jVvtHRfTcSbq8oDl3nzg8Eyf/GoiyM+dpkM9VrEMiaFJqc9zo34zytZX8bxRZiQ1dvgtYQep+gxbfv44NJViovNcaAz7erDFCsLE3Cty01iBROW8LXJw+9DoTo0h29O9jV1LPoPsKKmq1Jc85oQjD400AhurwJ9SlkR5Jga3R8RAZ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ycZSP7B5sXj99R0XMHRqAQuRXNDr19WLEsQPyXZOWQ=;
 b=mq0snK8fsOKAmDinHODEgagZ51jbhDJQPPGcPdWe46Bf3CnaX0LYQT36BNMsoWJu1Yf1imOy4r3SKBiSdf/nTSu8mHNGC0e27ZD3mNEk+fs9b/k/bfwD3gfZDR6V6mDCvFI9TVMGIYWMUC2N47R5gMyOnI6j9768SRtb5TUD4eOeSSuvyTwVGZ+AIOVcb5mzrb5REAItLmsaR9Glf7hTs9phiToLBJHFrfRkNxPWMyQyeLLWXAViTICX9H8qXRfqmogzMnupCGR2YgBfbmsWtbifAGwwqZHNzebR0vyAYggcQU4WqtJJ5ZJlN84xxGVBoPPXzyf2PBy8gyaO4V/0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ycZSP7B5sXj99R0XMHRqAQuRXNDr19WLEsQPyXZOWQ=;
 b=DKWBYTtB7kbh7+fAUiN2XCA7zlH6Z8ol5rMHnS+ZBGB0ZkNjcuUmQ7m6C4v0KLcdRq6goG8+lKq0YyqwffVVMiSmGqekXdmbM8aCcO34BMbh+lCF7OZOlfeQ4MEXACjc877zXb8IgePH99BtjXJg7PrwMdH1w4THRrSqP00gL5o=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by SJ0PR14MB4394.namprd14.prod.outlook.com (2603:10b6:a03:2c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Sat, 3 Jun
 2023 04:59:26 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::6e6d:b407:35b1:c64%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 04:59:26 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: Russell King <linux@armlinux.org.uk>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "kabel@kernel.org" <kabel@kernel.org>
Subject: RE: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Topic: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Thread-Index: AQHZlOeZhHXye15LEk+eN0zupHuzTK93WzEAgAEqjCA=
Date: Sat, 3 Jun 2023 04:59:26 +0000
Message-ID:
 <BYAPR14MB2918E4481E0EC7697AB1BAB3E34FA@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
 <20230602001705.2747-2-msmulski2@gmail.com>
 <ZHnNlGiHRbUYsxlC@shell.armlinux.org.uk>
In-Reply-To: <ZHnNlGiHRbUYsxlC@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|SJ0PR14MB4394:EE_
x-ms-office365-filtering-correlation-id: 9ee16862-68b8-41ec-0569-08db63ef4e38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 s5tEQ9eRsstNdQm7hj426w/nf7DIaNEv110HjbVhC5LE4q3I40+4Kgls1uqGEAllzszjh2Ii/57GypxMBUBkZYlwz2zyngdXw8RoDt9AQxRQAtmk5pDjrmkrHyxDt8uVAw2+1VbBvpu+wmoZtBTb9PyusaS8IPCz3CmDAusR+mSsnDgTneEfFnSSW19KLiht2uL4RDjGk3h5OD03cgZCsrg3A8G2VpbzHAjr3jjJ5qGN2v/8yeiF1wrChZ5Da0UEpfZV4yJHifn3HswkbrDgWgoWIShiMKQnwTCCdteb9ZFQBloHsMPwrqGwuydGOpwToNUg89VQ2othIALlrmfpjcWeG37CQOdkggvbiLJ5APDWYB56mCZl7yQD9K9vO2nL2833Z/+PKGp51wiU2D5nkXHov1yMNw9XREDown92nKas7GW0e43wzPJmv+7jgB3Kvo4diauXK1Y/pQ5BxZE5sKFsv0J3PombEgyTkEE46LGmiosZ0Jk5hegGLb/6Xf23iIvGAbzHF2jPXa0xEvTaYuN89n5e/i+IKdB3Et2S7OpZkG/7vmC5OhAgFwzgcRA3cGn6LsapKRvHfNpdsWEa+zQ1Z7JJo+uXacJq1QFMqoY5OlkGwTB6/i2JMCjr4PKMfja5j/d3ZvYVxEhzFNYfFA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39850400004)(346002)(396003)(451199021)(66946007)(55016003)(83380400001)(4326008)(122000001)(41300700001)(38100700002)(316002)(38070700005)(53546011)(7696005)(966005)(6506007)(26005)(6916009)(9686003)(71200400001)(33656002)(66476007)(66446008)(66556008)(76116006)(64756008)(8936002)(44832011)(8676002)(52536014)(2906002)(7416002)(5660300002)(54906003)(478600001)(86362001)(186003)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+xvDfcCMn88budiQRBmpRtjfOXCFj/G47K17kErKLKckGBX8U1bidKODUcG2?=
 =?us-ascii?Q?4n4a29Qdeu3OQuZeG0jAhDZOEIEyibmBsfxj/SARf7rTZ6derzZC7UEHVnPg?=
 =?us-ascii?Q?Kt7i4WiDI2VKPJKSYT+vJJrjjqChZPZyRmM7LxwEb/y2/K/DOsYGy/vlAE+G?=
 =?us-ascii?Q?LYASflvfwPrBmjgvLQVUXFCsihP+Wpp9T66/gAz5MwahSn68hpqVQrxL9jPL?=
 =?us-ascii?Q?AkIhJL56kMQGHB7SSCRWyls9md7e2PoPWlL6BIEtGPHMUzeLGfchJbyRAV/z?=
 =?us-ascii?Q?y0e+b/ohWAN4AOfC9V4l2qEALEjVptb5a78nJrYFN8FPCaIxVdd+rrhaa2lg?=
 =?us-ascii?Q?gZ0yq0Ub8R9dd3wusqk3PZLKia+WfqTeWNZMQ32TvBXt/6R7+/ZrYn541qn1?=
 =?us-ascii?Q?lCEBfpetLWr3feLShl2Dt31f+FYbSTuV3SCHvL66YFTEC6AALTjqPWJdY9Uj?=
 =?us-ascii?Q?ssbRA8gecI8Bb9Kf+N2mW3qze3bAZ7hfI0BWLKnK1r7EOy3iI0bX9baNuQj7?=
 =?us-ascii?Q?+gSO51a1u2L5WxYY6JUeDLBDE0Px+h3v/5WkE3R6sm7bpyOlLoFsu/9Zvv+f?=
 =?us-ascii?Q?ixcqvnRypUEPaMzgsM7j3v/rCMgoGWPHvBTSNMIwuHp773DdnP68KlaD/Wfg?=
 =?us-ascii?Q?G8oYQX5hLlIvn/BvyKY+Wb8GXRaCl1OWn6WTvzt7uVQqklcC+qx9kYgcJsHR?=
 =?us-ascii?Q?lu2k6070qK7DFgZevwuX/5PVMY6lvK1xzCphcGakB8C6MJztXPehPzkHxNri?=
 =?us-ascii?Q?rQ3c4TiYjEEHsLumrg8h1E7OV/XM6BfkDoAMMgG37jeC5s/9Zj7PLAk4QMuE?=
 =?us-ascii?Q?Pc27Ndooslj8Vsdjg1dvBumGmfn9KlLcz++zwt61GNgtVqtoPcqQyz+j8WQz?=
 =?us-ascii?Q?9iqEyUR3vdQ4XQtwBHlZgEx0gMtUDPJTiq4Iz0YBeAHsRJzIuSMPzmqiTz9B?=
 =?us-ascii?Q?t0nqq6rBqnhCeVtn2EV9bB0pdoYSB2Ibyjpri1TeEtINjtOMsordnCd2h9ka?=
 =?us-ascii?Q?X9lhOGM3SR9MIA/itfTa2GIAfnXFDgghSwdxKL39389dzw1WMwdLSDr3iRNp?=
 =?us-ascii?Q?Yday59jK4V7DwmsPCgfVmt2hz12eVVFrIPxHjhgKBekFI1yrblFArFMZhKIr?=
 =?us-ascii?Q?3jv22Ar9WGoumf+NGmK7vQVKvh8XwqJ8z1pJ5Tk6xVDFQQIG7okM8v1mDEfg?=
 =?us-ascii?Q?/8HAUgcxn0LX0vE4Xvwm4JgP1GIqfLcx0BreeOfFXpD6rPGnFw4ngEVTvXSt?=
 =?us-ascii?Q?TyDiybhv2N//NR4OnWKMVR8rzDRiKNW50ynSRsfd5kfE2WjihyciprqHEQ/W?=
 =?us-ascii?Q?GpWWI0To5wvgTSl43oIERU6w5L2bxuKAYmsJpmBb7sMSvQ+1wuu0XQImkMlu?=
 =?us-ascii?Q?qZpNEL9Ln2UMtV9GuiVt8ZfPJ9W4Hq6NMLZ+dnKwZLt9lcCvARYEamY7pvsy?=
 =?us-ascii?Q?c2Vjag138c/i5Qz9G9dPSvvPBUg8SVFFaeCC99XAxkLp5uFeeVhK/nl7RVBB?=
 =?us-ascii?Q?PLeFj/TZ8M8+c9h3WQjSPTNMUBpHaqAJctRISwZdKtWWiyGycssqsaYQPlVA?=
 =?us-ascii?Q?vN78YU7iWwbCD2H/oANG0nDPDFE5wrv81r7kh1Gy?=
Content-Type: text/plain; charset="us-ascii"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee16862-68b8-41ec-0569-08db63ef4e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 04:59:26.3182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UEoe5o+95WzwHmGxVdJRGOwz8sEd1E4HxFsiDzHOHIWXBStIwr8dd/EELOyb6gIZpdcxbU/LF7VJ/Ohnlh8QTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR14MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I do not know if there is a an_complete bit as per my previous email. I thi=
nk for now I will set state->an_complete =3D state->link.
Michal

-----Original Message-----
From: Russell King <linux@armlinux.org.uk>=20
Sent: Friday, June 2, 2023 4:08 AM
To: msmulski2@gmail.com
Cc: andrew@lunn.ch; f.fainelli@gmail.com; olteanv@gmail.com; davem@davemlof=
t.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger=
.kernel.org; linux-kernel@vger.kernel.org; simon.horman@corigine.com; kabel=
@kernel.org; Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII=
 mode for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Thu, Jun 01, 2023 at 05:17:04PM -0700, msmulski2@gmail.com wrote:
> +static int mv88e639x_serdes_pcs_get_state_usxgmii(struct mv88e6xxx_chip =
*chip,
> +                                               int port, int lane,
> +                                               struct=20
> +phylink_link_state *state) {
> +     u16 status, lp_status;
> +     int err;
> +
> +     err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
> +                                 MV88E6390_USXGMII_PHY_STATUS, &status);
> +     if (err) {
> +             dev_err(chip->dev, "can't read Serdes USXGMII PHY status: %=
d\n", err);
> +             return err;
> +     }
> +     dev_dbg(chip->dev, "USXGMII PHY status: 0x%x\n", status);
> +
> +     state->link =3D !!(status & MDIO_USXGMII_LINK);

Another thing which is missing is filling in state->an_complete. Does the P=
HY have a status bit for this when operating in USXGMII mode?
If not, please set it to state->link.

Thanks.

--
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

