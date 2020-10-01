Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4527FFE5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 15:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbgJANTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 09:19:23 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:39844
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732018AbgJANTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 09:19:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nG1SwFwi2iFHsTdsylftBssF9I+kOHY4A5kQ5UI3wOaxXy4AsiBSwpJwZZRsShqxIJritxjqeZz386WRrEDOXMDmY/SO3Gt/hACTEXGOcl3H6A4JYvres/Q3F3z26mvrPOKbo3Ryxu0mTfms6s5lxUV015wos9E1lU7euI3eI5QiBFh6V7u2boOgbRdSWwe3ysOtNca/l68CxcYrb7FAy4CN/1kWGsajK3MLykUFD7dAKSktHA6FOeziLeS90qiLduRgF8Wbt5DK3d49unf6Herjb6hUp896gbdZ2nnp5C5SZ0L6TXnN0Sv+yrGqQxYpj6BKqddTEI/9huyr3Ns/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8XL10DLbGfNLQoVGrgpDGEApeSnEFzXB0SuXpWGLj4=;
 b=cpc2hxP5f2BnyoZdPSMSurLI0fHdn3CWJluHnYVkEa0Ne+Y6/pakq/KLrRxwxHU6AWPEaAacuC501FSTxvnsiowxZ8YXygFgRRX2SCURxia856+y0aCYzzzXTHOtxmQQGNICsrNfJRRI+Joob3/Wh26FBHLnTnAMrgq/JFIL8Lj1Ku5VZRxfvRkjnE02QsHFRqqKkyvl9QK6EAnELREOCEaCc9lFPwRk47cArgTWQDiFWxETL6HRXCStqM5UPuri7GOQj9G7dehCeOq8idbZRVFWenXMPSW+AyzuzAVJiceBw+aGcjfHZZlNwATv3U59Llq5vifLmxKZe8SVw/89Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8XL10DLbGfNLQoVGrgpDGEApeSnEFzXB0SuXpWGLj4=;
 b=fjIk9lUkfy5nGG7dRgjNaSZlUiY1UO4kIDgEllPvIsj7N1HlpL0neYGpMxy0Dl2xw8tzYW15XWJ6GT5cbneQk7AYCf3aBfh0iqZBlwzuLW5olPR2saPMWyzJFAseGx80waBqIzMdMOR059TlMr/zqgI11kTit3Xf1UTG5+qUWFE=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5885.eurprd04.prod.outlook.com
 (2603:10a6:803:e1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Thu, 1 Oct
 2020 13:19:18 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 13:19:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 4/4] dpaa2-eth: add support for devlink parser
 error drop traps
Thread-Topic: [PATCH net-next v2 4/4] dpaa2-eth: add support for devlink
 parser error drop traps
Thread-Index: AQHWl15Lv6akIxktI0W0hlJpBlSFgKmBlWGAgAEm0IA=
Date:   Thu, 1 Oct 2020 13:19:18 +0000
Message-ID: <20201001131917.fi3ol7k4onody32t@skbuf>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
 <20200930191645.9520-5-ioana.ciornei@nxp.com>
 <20200930194407.GA1850258@shredder>
In-Reply-To: <20200930194407.GA1850258@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9595c71e-d0db-473c-5149-08d8660c9a34
x-ms-traffictypediagnostic: VI1PR04MB5885:
x-microsoft-antispam-prvs: <VI1PR04MB5885F0A98C63C094B5C21809E0300@VI1PR04MB5885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p44FG0brPZFh3PHyZrwO9By6X+Nauva2uLsGFyiCyXfC1u/qSD7oySWz6b3cfO8O4m5LAivImLQuIk4SKf/mE2j76kti0K832ryEO9clgVCoW3wgg5+2uoiHAs7yyeuDuv4gA9Z8tlCnlxaGw40BdSekLcdMNG7z3qM/ZqI5MPq6CrGFiH3fvR2xb+wJK+kMpEy//5wJLI3YI4pcSkLdN8dCYU0WC5rY6KenZxoemKgeFudCgfMl+RU430tJI5/MfdvWWqrBecmFJEpyDB5OcxfRr9caGdbQH9ruH0ED/3rzs5Lx+yxbrlcVWE4MS/Bbx/qeZ907me2S9kYA+FgWGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(9686003)(76116006)(2906002)(6512007)(83380400001)(71200400001)(1076003)(4326008)(33716001)(8676002)(5660300002)(8936002)(6916009)(54906003)(186003)(316002)(6506007)(66946007)(66556008)(66446008)(64756008)(6486002)(66476007)(478600001)(86362001)(44832011)(4744005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KK/BcVzZiLCmz2Qm67NurWz+wG9G/pWn94sdXhz2r3jBcL9AokJQ4Vy/Ize+9L17CRlz1yzuIXI4o4K5PqCP8xnJu5ZKDuGpLzkXBrx+qLmqchiwd7HT6uoVoYOM7ew8QhQrKiMTMHfWgZM7+sJPxrPBFxXiIgQ1Yvvtj2ydB45/vOvsytJQVilecCOEX1k3z8LzVainHcZeTJCrm88rQYIIWddXcHZSKmQIrF8gh5ah+fPypR5U3MpsIjg59i9uUCjHM8OuCE62yRZS5ypMP3OFT0O8+ws6gyO9VVYU5v+X4RNiGx93d/C5Nt7i9/KO54hZ+bKrNUCdc5Uey9CQXto+0SL4qcQpXZMoW1E3/kqbJYbKWADTci/fhAUjQ/t1w/KSfdPLlBCk7mQiB0wPOxWmsYsLF7/dwpoLj0XU+TVbjHZxvm9Cxk8o72NBmwLV4BUevuXQvh4wRsm5LiEK8iCnDDAC8lWFAOen6yNSpYOtywd9/QQ60co7k2WEzrJS4s0xRbREjyEuWwbwXuQO5ysS8Mm8LTFbliPkARbaInaa/IibEQXS73vsshO0RC/uIf/p3kTMd8r+bTz3I7DR3rYm+QV3f6u72KyyVSMd53QhwVI2jbhApyS9ATtHpYbIUtl/ZBkIjYHVqcTkQO7I+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FE1330F3471E8408A71A8EEB5062912@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9595c71e-d0db-473c-5149-08d8660c9a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 13:19:18.4686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GRwkiWy1kGdAdWGgIRlhplFARbHD6r7AQJEckzVsrY24is8vhsrtexrdnaX2yLA7PGRZk0tuQ5U5wbiwuMCWKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:44:07PM +0300, Ido Schimmel wrote:
> On Wed, Sep 30, 2020 at 10:16:45PM +0300, Ioana Ciornei wrote:
> > +static int dpaa2_eth_dl_trap_action_set(struct devlink *devlink,
> > +					const struct devlink_trap *trap,
> > +					enum devlink_trap_action action,
> > +					struct netlink_ext_ack *extack)
> > +{
> > +	/* No support for changing the action of an independent packet trap,
> > +	 * only per trap group - parser error drops
> > +	 */
> > +	return -EOPNOTSUPP;
>=20
> Please also add an error message via extack
>=20
Sure.=
