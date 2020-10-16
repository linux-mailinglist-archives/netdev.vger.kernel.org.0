Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC229029D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406584AbgJPKNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:13:04 -0400
Received: from mail-eopbgr100133.outbound.protection.outlook.com ([40.107.10.133]:5280
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406542AbgJPKND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:13:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZS2Bvu6eNgMDRbp6LL4WQCiKxVgR+OlSrMhXepHfluvk/jNjQCq9mfWZ1lny4P5fdwZPkLbhGxZ6/Iyh8BGG7OhImvd+MiyVk0I3fBkdrxWUwss5eozEv4DhFkK16vfgo1s6m+VV6T+MBGDsWgh5y+8RbwnRiX3ACy7vJm7xIAG6e660dqxA6nJ3IlLmTIFOuU57fjF90jEPbVFNKOzsKOVWXmB3K0V3OX8AJPtEQo0L77+Os9moPu2GaJEGlU73AjhZ1pg4qNT9msOFYpnWwO6WASgg9O+vBOSakULTUTRV86jTUFQecSQGtesddGe1UKeQNWUOBVEPuJr4PaAhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6j3RsXTttqLD/78CZICOj114qwyiu+I8owpXr6o9KE=;
 b=k8x77Muat37273Z954/e3XEowISo69yvuRliQJnPYWRQQ38lpt6IS+wsjdYdCan3HNiKOH+X8GJcPJOS4x357z/PgqDEaJMzpQX2XOj+Plu1t31StRw5ZBxK8yUYkSEzDwogjl8uYl66bVt4g+sYubG94f402TlSpUcN8zif+HGcnUrrNjOUQRFev+eKzeFaSjGwsE5w20q5QKjkTesglt4603PaOqSFMsEOF8zvCVErCeRE618osQ2YMT37cYYPZaiSa6vzw1w2ISXID8u2d+/7PDyK6zJyJXD+pPE67zKgPp+Dmt8d4CsuUhI/YgCVupryHlGMGiG81NpY8mTuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6j3RsXTttqLD/78CZICOj114qwyiu+I8owpXr6o9KE=;
 b=MhF1J+r4oHzv2O0814e5jyoRzPFbNPUgxIzFtXBVaHSQiFApvtac8KtvMO8UEe6pHXKQFbh0zez2gujRRPaMQRhFLEIlL35KIlUnzlqlmHpsvLD25FSP1yUtbDxNGtMRehTNaMYk/23yb42ZuqE/RkMdiKLRixQ+Hgb5T9SpctA=
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:ef::9) by
 LNXP265MB2506.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:134::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21; Fri, 16 Oct 2020 10:13:00 +0000
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b]) by LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b%7]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 10:13:00 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Joe Perches <joe@perches.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [v4] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v4] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWo4aJ7nAHIWDR/0q1ocTOM/gpR6mZ7e0AgAAT2uA=
Date:   Fri, 16 Oct 2020 10:13:00 +0000
Message-ID: <LOYP265MB19182BFEA8D6F353BC25C061E0030@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20201016063444.29822-1-srini.raju@purelifi.com>
 <4676eb63d9aa5b9e532b580bd491527d9ed08535.camel@perches.com>
In-Reply-To: <4676eb63d9aa5b9e532b580bd491527d9ed08535.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.104.125.104]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be3b8ac3-b407-4e17-c8b7-08d871bc0fae
x-ms-traffictypediagnostic: LNXP265MB2506:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <LNXP265MB2506648F10031E70BA89CAF8E0030@LNXP265MB2506.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RARim+wM14jzLN0jeDPo/bEE/8c/8DNcMQdp+GitwgnIYrZnyhZk0AKLy2YF2d9rIGdGirgdCjQC1WHEI2yabVhfLTdLAdfC4nQsHK/vvLBVBFAvubAKH4GKuvZvIOQ5E62VhJf7hyQkmTVDemxS7BLeQNI0cmMIkET7o6jl4xAFA5j7dF8+qgJ1GdP5WWHJxcErsS2p2/3RdQJmNfMaDMCQgOhEkxhWfwgPUon3tWTDSLGpU42cjC/3l56xVxnaL+rBJnT0qA8FArX6DnLHw+69MeUXpHDTmtLCOQTkisulwQcy9NrSQVKfwbTyzX5A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(136003)(39830400003)(396003)(376002)(346002)(66556008)(8936002)(5660300002)(7416002)(558084003)(52536014)(8676002)(6916009)(71200400001)(9686003)(2906002)(66476007)(66446008)(86362001)(66946007)(76116006)(64756008)(478600001)(33656002)(4326008)(55016002)(186003)(26005)(6506007)(316002)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TsgUhBFe5qU+kQKaide0iEsw3QNbWpHUM1WmrCbU3yIRozJt/tgOYT6jtQTtTA35IKGG3/OKoux2KieYq80pmR9FaDwCG/Omt4TeXDdUuA3nrSwD/47fBBcD8qZ+KYL7rIrZ8yJITmarIWnswYB/N2C8yxaOly/jDc4yFRJMl6hkkzOEvTjjNG5e/avVGShhKS0HEGlSpBLhzPZf7CnOh8eJm6iZ3N0f7n4CLgfA8+lL9JtoHu805jKL/lNrWxf9PPJPlSWgz96rI01WhMI3ol6nJcb9L+AJZsD7D21L9WiYHMJClU5SPN0gfxVTKFsT+U1WTYO3dKP13wKpUizE6QSo2PX/UjrHnMVLWWQMGROdMXWT0dGJln7cBQcUAw1R2yf9MNxKUCPckOaACS1fVNbvkC9XdROJWHCiOo7gJdmzuRQCi1+RWxU5JzPcfBHsEpRIsTfrWj44LQ/+s0BGBWMEagRN9R58EpXbd4kG036d+nQpwf3bvDqnN1Wl3JMoCaM1me2ZwK1/tCtYfVVefaTWKslfDDiZephO4Ws9d2jmcFw14osCJ2TSo90xPR0EauMHyxj9kEdBb28QKT1Vd8a/IJkkXQ3UfrQp4heaRovLWqsS2Rf+7pSqDbGClGNHbJWCs8IBsR8xww5jN3q6gg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: be3b8ac3-b407-4e17-c8b7-08d871bc0fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 10:13:00.2817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j8jbo+g9Wcibu+iDzghdhjM4dcnjrOMyTi49waVCeXoCUjuR/iDOytjt/o5cFzhsosoWEOTxjIKSPidbXiUfwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP265MB2506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Suggested neatening patch on top of this:

Thanks for the neatening patch Joe, I will resubmit patch.

Thanks
Srini
