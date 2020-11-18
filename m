Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8E2B74AC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 04:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgKRDYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 22:24:04 -0500
Received: from mail-eopbgr110139.outbound.protection.outlook.com ([40.107.11.139]:29232
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbgKRDYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 22:24:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYNsSDn1YD2+lldEgO6iimSyjMYqwgneF3m9W7MNgTTNMIhjZ0gVuS40QlBTyJ6TJFg0w8ZTDc1HAXyMcP2epGwP9F0K2QI9o6QYvDI6G9EXeLThjIfF3Ybbw7SSh5XDlMbhbiykBz+ezaYd9l1yPxc7BP4AvhOgvZtNC9+/boJ5Cjmt95cenVT6jo89NR+aMR+U7w5Iv/NJQnMkhc71kIW3LfwHytI7QiX+1j6uit7Vj2PLHZysIwiNrU9c59App+Bc9vsT52I/yqkNegN2ADz8QG7KlB1szCPQXOHKkfu/Pvb7wyyFkWqmtlzlSxKr91iZhEaPMCCegC3NG0ZhJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHtzx+wB5MMWLb8h0WiHkoAXvB4iwhv08yPvhxAEFhg=;
 b=B7rizKWoM3L7UYNuk3U53UgapyEV4s8ltThkP4UdrB6l7YH1vsUmsIJnVdoNRX8ybKRCh6w0DqMuFPSG50gwf/nYIyGw3S/KxF+3Sw7Drw+SrkTaJf7b4zYHiVV9ALRAjZT341QuP1jDB0IrI3aHimjQGuZmRufQn+4BhpJ1WUV+c4o31xk/XuzG8XjIyW2p3jlkD8I3+ixwrTFmxQhf2evI/7bissekSwCGJsI0kowWblO07XQ13/qnbJrrWH1/6xJno1Y45n5Bq/hQYISD0e1hj6IpVaal1+H5RsM+gHmx0F5leSljINJJT/Dteqo6xBYcnih9cGi3b/N3PluiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHtzx+wB5MMWLb8h0WiHkoAXvB4iwhv08yPvhxAEFhg=;
 b=d849topV7PrH5hUmfVmwx+FXJuhGIl/jXt5VCdBLIU85xGNE4x0IjOLG9Glam2JUYz8dFms+l7WTTAn+ayFR5LSoQiGH6q/Z4r8KmahWUNnJ80TsKio/g5qv53Cr1g/8vIiW99d48pqAxg4SCFGb3tWMRRp6Z6ywXh7/4IAESLY=
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:3a::14)
 by CWXP265MB2886.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 18 Nov
 2020 03:24:00 +0000
Received: from CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f8b6:b3c:d651:2dde]) by CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f8b6:b3c:d651:2dde%6]) with mapi id 15.20.3589.021; Wed, 18 Nov 2020
 03:24:00 +0000
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
Subject: Re: [PATCH] [v7] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v7] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWu/oh8T+esyecpUerAB1FdPgUnqnLOtQAgAIBPDI=
Date:   Wed, 18 Nov 2020 03:24:00 +0000
Message-ID: <CWXP265MB1799EB495B08F1B942C2833BE0E10@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20201016063444.29822-1-srini.raju@purelifi.com>
         <20201116092253.1302196-1-srini.raju@purelifi.com>,<e246d2d2feed162e2f8f7bf46481dec7b6ce729a.camel@perches.com>
In-Reply-To: <e246d2d2feed162e2f8f7bf46481dec7b6ce729a.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.104.125.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ceaaaae-ef83-431b-524d-08d88b716454
x-ms-traffictypediagnostic: CWXP265MB2886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB288643624C2FAB440111BF5CE0E10@CWXP265MB2886.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VjHVAHIdDkhDiUxdpZj0cQcUyGx+BBxnwQ3bQ7WB0QpGyLP5ujdTUsXciAqEZvtmeqqckts0TTH3x08r/61hHHCXpKcXsy57uMKFt0Dr+u1xRqSZwnRhtt9o2e7d1RNMLGlc0V2cmiKxUPS/byf9NIuWGyzZCegEf6yTwVFGbrs6wAnfvBGQ+317vkdwi1Ui3T2JRfrJdcuRW+ikoAnMWTa+1asMGW+SEucCtCHeVQMjPMFYzKC8/LzjORUt42PXIk3VugJY4WgsX5VjVyk1e+Ko44gnaJ1kgG8A263HtOtpXuILPmFvXDua6rlIN+H7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(346002)(366004)(376002)(396003)(39830400003)(136003)(5660300002)(86362001)(54906003)(7696005)(9686003)(52536014)(71200400001)(55016002)(8936002)(558084003)(8676002)(2906002)(4326008)(33656002)(6916009)(478600001)(316002)(6506007)(7416002)(66946007)(66446008)(66476007)(64756008)(66556008)(91956017)(76116006)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 7QyKLe1Pqfl2RECyuCuGge3ZAVqsmRCSnScLkHIY3OKEpmiTzXq1/uFSvE2MpTnNs9VosLl9razY5fMXG8LJtUfZm6T6Iq1Yp8tmx9qXWk61Y2y6mR4D3/iZPcN6Put6J9d4fVScjSYW9DZtByd4vMnyjDvxrPOseRwh5G3PVKbjOd0bBOXHUdG1vtU/k6xuDdNuLd8+vNTP+tEEsZ7Xe+gEH0gOc/h+tq99F1ienxBvi35CD/2b9Ad8OIetzQFi13a+o6a9M+fvQUCPYSatXjjKX2vUTyNXWMal1iwssbWnNk/LBt0LZ2JCDXHDtYqpBuv7k5gZNhuI3Cif2yI8nmVRZKtXePBPj+/CHrhrrBrgBeDmxtctJU9wmlCSRSoZruHQ6Q9bclrqdIjHK/HIRlpRdkgXmWHa8LUAwepP3pO4fT5Em6ukJITXS+Gks8Csfu0BWbJYMXkyu9Sdr4EsVgMypx+uJ++d3XsY6PUX0whcbLDfGA0SY+te0xC757gwgojub31WbblLAxbh+g5pulVo1iGg68TFy2QB7Vp/it2fiZopz3cXp6nUH6xuzv1NodmlgVADQ1sHuuc05dnO0Bcv9VHzBKEq/Rqj2MK6DR1jHg+foUHHSFfAy/7nsU0HfVE1zKf+Duq93tIjn1HT9A==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ceaaaae-ef83-431b-524d-08d88b716454
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 03:24:00.2662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NxM3TXHHa38gqXv61Pvtrkll2wuPzoji/rfNRz8IZtIq1lWpUqvEQGeZgTvYSHyZfgLLxCe8uuYAJX31biv7JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2886
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> trivial notes and some style and content defects:=0A=
> (I stopped reading after awhile)=0A=
=0A=
Thanks, I will address the comments.=0A=
=0A=
Regards=0A=
Srini=
