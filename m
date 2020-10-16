Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251B628FE66
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404102AbgJPGgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:36:51 -0400
Received: from mail-eopbgr110102.outbound.protection.outlook.com ([40.107.11.102]:2336
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392207AbgJPGgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 02:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQYS5yGV41cFmp8NQD1RHaaYAbK59ldXltypxXpqnSTOFz+Hek314J7Q6AAHR6ahGi5mnxDKFdVK/1WP+r0aeP7dSM/gRitfZ494/AfdYZIaATCENINqEMiAEIwewLStoHTrJPb0h57JnQx9hubZBcWB9nJEQLsfWFo7795KxyLp6ifuWyIkhJRdzCWti5xBAifez6hjaMmcTh7lsKS/6bvbK3vfOBiBBuWJOvb60WjSHzFntgqbIpTFnMSW1+AVNgeU1L69HoS05iP5+UvP89AXY4QnSniKXsPz5FnXjRUq79rwe2qWRUv+1FAbSgRLbzCZ3xPp9PEBRkrMwJYJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATWx5aWeV2yYP8Hwg+ssOnHUhsZl0FdjmGg2xBjUnYk=;
 b=Y2Xq6iI4cKbahgLgsGSv8qWTNYw3tki/MZEy5ptJLibry7j5ZhXoed6Fvi165CjfczuxSpMdDCQ3nioZQLg7kGumYx4h32TSz018WadKGqvbDMC42AIb3ktbtUlGjAfBPx4xmIDjMo4uXS6gedEXdqxvgG6/nnlRRsWGa2PtqV3FX/ia16feitEYjwMGiVWA3cE2RzXBXwhMgffEZ7g+WU8RuzsScE7EPcUS3+tW5nqOVWUJ86jENB6eEnPg7J/wTbExgvOF44mQh3YMOJz0sphfDYHEV7So4zUfLIiDzdoxW+3YWBvQptJCCLKajNfbGLFUvARNxV8ItFfZfY7iUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATWx5aWeV2yYP8Hwg+ssOnHUhsZl0FdjmGg2xBjUnYk=;
 b=gnsX2K+uyukVrajVj4N9U3vSnYtCbeDNxUGGwpBp98ddwHfq9VZCiHwyxZXNkmOt8NAptP/WzI2sg0WQrca44yinEMkwhOuTBMF2h1EegtFvBfeyeJ9Q8Yss7yOMpW5bBiJ33ki6Yt/uqkPX4AJOgcSvyJFtKL34qcsuvn8ELDA=
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:ef::9) by
 LNXP265MB0618.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:12::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.28; Fri, 16 Oct 2020 06:36:47 +0000
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b]) by LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b%7]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 06:36:47 +0000
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
Subject: Re: [PATCH] [PATCH] [v3] wireless: Initial driver submission for
 pureLiFi STA devices
Thread-Topic: [PATCH] [PATCH] [v3] wireless: Initial driver submission for
 pureLiFi STA devices
Thread-Index: AQHWofIO6pqL25Wx2UmQlZy/whAuaqmZQxAAgACGOyE=
Date:   Fri, 16 Oct 2020 06:36:47 +0000
Message-ID: <LOYP265MB1918B3958A20761CAB5F0F58E0030@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20201014061934.22586-1-srini.raju@purelifi.com>,<cb5dce0a645418d1cbab93448a15d8c3109d9990.camel@perches.com>
In-Reply-To: <cb5dce0a645418d1cbab93448a15d8c3109d9990.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.104.125.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95ef8462-96a7-483c-3fd0-08d8719ddb2b
x-ms-traffictypediagnostic: LNXP265MB0618:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <LNXP265MB06185E5F5F31B74E2AFB3707E0030@LNXP265MB0618.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RC3X5HOk9tPcGb9vwcdLesB+pXbAbNXf3qKUWpDNqkrnzVzLi66RQM7euQw3DsUZPqhLC/OlpA17ZbWOzf9k/PR2wEFpDjQvm5LTiwzrO2ErlDDQO0BotSlUR1AFjdy3K5CA+s2/H4N4p5WrehYvejpYw1zjQShiDOlaGRKNEdPoz3BbfUaayIN/E+a7lgIk7EwC2zeVsI3QL5F06iyGMOqFKmnRMplQC7DeaAurhoB+BbBCgvERbMiYeyWtxIXrbBS+xtfezFZzSBxFbaU4btiATYVtj6oXJOE6fuUrC4YRHNwWkUmPNpMflTp2fyNa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(2906002)(86362001)(52536014)(7416002)(7696005)(66556008)(91956017)(8676002)(558084003)(4270600006)(76116006)(66946007)(66476007)(6916009)(478600001)(64756008)(54906003)(26005)(316002)(186003)(66446008)(8936002)(5660300002)(9686003)(6506007)(4326008)(55016002)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zLz1zNAyT7ji7hYN2slVwi+3voIF0PrXjwlzL/D2uklY1zRAwMzAtgwdJtn+lV3iYXx1KcI1Rc3+CROtkTkNw6lPyK7OkOqRQkHfb955+o2RlKVy2ok2IS76nZYshRfIfdEJ2pqeXnWJ34VccUrICuSX4bg5k5OPVoWUOlkBby0B+UBtDBXhk+kFsTumWn1TbPh3EoBFeGInykIfWauzBk8FedxuNQZAI/02AoRKld4pRw0A7/lM31pnM705j88iM+i9CiaUfh0BEfF5LG7UqBB4qXZQF6YiCs6Aem6cGgxmPPHK1XQd4up21r7DcXdg277LCZrLL5gNFRRy4wpOeO/VHiOor02AhB914616abNB2ZI0PiLtXTB2fzU+QLJ0yzn9bseCUd08gWDeVYGXvZUs/G509AYPucaASbDR6vbXRCGYA/TdDFkQL6Gc0NmOhQ/PaehhYnW7vuhv4aDfNwOaqvql9jBiRGmLaxcHL8cRBzfHscw4Lm11nMQW9alLOWJ8ToX76AM4A4/3hlKaIstF7AbjaMTe9Jcm3AzBfaSTg55z08cHCovH28to7jSd2rFM5FFiX98/YWHBu6bIhkFvdXDrCsxIHjk6pTlPxhezUcT6dDDYQTtvLmcCFS0d/IKAM98TnziWZTUc2UIONw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ef8462-96a7-483c-3fd0-08d8719ddb2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 06:36:47.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WMuubhpbzVxw5wuQsxe5A58LsvmiGeDo7DAifnlJ46Wma2dHm8Dz1O0XiFXjf0+v5hRCSC8akpRYxSqVBPjfrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP265MB0618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
Thanks for your comments Joe, I have resubmitted with the comments addresse=
d=0A=
=0A=
Regards,=0A=
Srini=0A=
=0A=
=0A=
