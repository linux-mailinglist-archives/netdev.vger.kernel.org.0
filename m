Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD8C34A2E9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhCZIDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:03:22 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:24384
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229463AbhCZICz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 04:02:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWsAZNZ+wOKPBR/ueInWywXSlGhlqWHsTy3S8jlPFU/Y8zOKwKq461WI3eb5ohDB+kokbe7hL60ZognirPZjejY3fM7X4JibJ6ubqAirlywWPN7Io8bFhvO1/BXH7AADatOyPysb+1yMHQgkxfHaLqzHWUATyek4sOvhcGll9NcUZxxDLx9A6ytddXEOs//OG5l1Rv2bOQRg/jft6IBvvMOu+ciQqpIclht5By2DCJSO1Ovo2fY6DZ/aCN/rJdsoXSXhM9qkK2+0d2ID7zQTpPG/nfjQf4t/n4pSEs8E4Bp37Z8aZqwoNAqo/fq2inxK3iMmMbhVJ4Rfe3ydwOySpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzsYEWyNXVaKJp2aIzGWtexY0kPbgegfh8nP2IVbrNE=;
 b=mxzUTidyVUB32H2zgauSfY18iv8WyDiJsFBsG2OesIyuytikxzHqDjjILsdSUiZ69BSpF+sTWjuixzcIgQgoEL+glUVTgUi94yhRXm7hOfkTQ5CescDxYL92sAzRgZAUY4eyn/UNAQjn9Bkcy6AvQv1AqLV2rXJJm7s3yBXDfzHvqS7xFs1l2/xR7xBw8aZQWLDpisUjnULe4QzHJ+td/iskI1SQR9IJhSIUsXYrTorwNVcZvtrvS6bXdDsVAIMthqwElQPhvD3UN+uIC4qhTEgvflk1U6Xz/FWmUue3FtzFlSm+nhjhwxRuq318qPX4dJ9by550W6LjzaIUV2EROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzsYEWyNXVaKJp2aIzGWtexY0kPbgegfh8nP2IVbrNE=;
 b=EQEFcWlY7HObundSbwf9tXOwufU0ckpsnPzP3cijdpWci8Z1oGqAu9BtGvpGD8L0/PjZR0rtfKGuj286TlRHQ0+8wOxPa9t9NESwrM7My/a0Qdhr8HUPUGykOQimgz8EFMliSUkyjGGPnhAbXZ4StEEOcZKoEupmNj2UkXIfC6U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3096.eurprd04.prod.outlook.com (2603:10a6:6:c::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Fri, 26 Mar 2021 08:02:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 08:02:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: FEC unbind/bind feature
Thread-Topic: FEC unbind/bind feature
Thread-Index: AdchTA4mhHE+X6FhQBmQJxJLMagesAAKJ/aAACgNBSA=
Date:   Fri, 26 Mar 2021 08:02:52 +0000
Message-ID: <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
In-Reply-To: <YFyF0dEgjN562aT8@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79f2adf5-45e1-446d-5a13-08d8f02d8e45
x-ms-traffictypediagnostic: DB6PR04MB3096:
x-microsoft-antispam-prvs: <DB6PR04MB3096985A2913088CC2650290E6619@DB6PR04MB3096.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMTO5RRKFnOvDgRAXJdhb0fJfnUpGNkhmUg9MZ7bsa7ML+8z64pTIWYM1Ep0ecBkPwfi9+O1Gx0qGUxPAXbCTD6DrVEdF813zyzv8nGE6panfmc5SgPd4Ku45acFBXdWAbx9Tf8fCkslsrvtsDfYCyLR1emn6ZlparZs81UQHKhCbH+557Xlh8iaEtQPimRZVH2SCCftZ3ub8n6nAoxIhyTBV7BhgQOvkkvWaofna93+3qQypfaAFCBaVZWvnbOi9FXiRswJFNOIgmx1/Nt+NEmNzVSjkFM+su9ihrWYLpIBW26RCacBJY3xEZIPctsOYQ4iZKHFcL+zhZzMFYq9DFFh2CtNSrP+o50bpPcxa1zUl0CanbQdg1jDucBzjdrMWieO3ThG7nty+/U852BDnSkvAkAWDUK3QWuW0Ercy1B1+NqrJu0m64Sf4aTvujUqR4U4IaYlGnEf4HUnGa4/pByFE4If8IK7BOfNfSYAFAVDaZV9qnGvhS0W4gZdfvlXGuljmQYFM/uTewI0z+nI8E+UpNUvpb1bNzI5dlSevvJFdAzNC5urHOsOJCdcUJwqJxM6xIUIMZwdDD+SGgk1bEjPaGDMpeoe7gYm9scrk4cvjNPE2ZwIwtZZNm1QxaIWI1+EqKfZiMzcGyzY4M0Em9tCSHkfEclkybjDZ1thAf9EcSpPtPer26diBRyNWEgc8rd/pqnItImzssbSULBWOZhBZcBDHLm6TRQBipiJ3O0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(8676002)(316002)(66556008)(8936002)(4326008)(26005)(53546011)(7696005)(186003)(54906003)(55016002)(6916009)(84040400003)(71200400001)(52536014)(45080400002)(76116006)(66446008)(86362001)(66476007)(66946007)(3480700007)(38100700001)(478600001)(83380400001)(2906002)(6506007)(9686003)(33656002)(5660300002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?K1B3YUk2Mmw3MklCekdkNkJGbFVyUzVhL2RTL0NOSXNVZVBlbUZ4Tk1hZTZk?=
 =?gb2312?B?STg2U3piMkpZTVpHQkJ1MVQzRHFmSmJ3M2hnTGZvWFVjWDQyWklvaHJlVHEr?=
 =?gb2312?B?cTRkY010VHVnclVlRi9XV0RrcWt1OWdhUzRkMHRoQnFFdGxwdGtScXVOSVcr?=
 =?gb2312?B?bU01Y1BXUkllMmxuT3dTLzNWcjJmeU9aemNkMHFqS3h3NG53YlUrMnNkcXdy?=
 =?gb2312?B?SGNWMjJyaXRTaFdWOGorL3E2anM4TWNsby9XemhLbTA1ckJPL0wxZXFCVVZC?=
 =?gb2312?B?V0V1Sm9UWHNUaEJhRmQ4blNXTVl5R0JyR3VWYjVvd3hOOU5lZmRNVGhVSmZs?=
 =?gb2312?B?VGpXZURlQURDeVJSSWV5TnRaN2NyZnJBYTg1blBYMkw2eEl4TDljZWlxeVht?=
 =?gb2312?B?Z3p2Z3JEVzhocWh0MkdLOEJNVWdQbkxyZTJXa3ViaTFjenU4TlUveE9mN0Vq?=
 =?gb2312?B?ZmZQZTdhRVdTM0ZjejlFdDZNOGtxcnRkOE9TOWdsUTVadXc1Mzd0R0xzL1VU?=
 =?gb2312?B?S21Ec3hrbk5yc3NnZkMyaUVOVU92NWlKNm1WRVBOaTZsdWZBbXpURGVSSS8r?=
 =?gb2312?B?eUgvL1ZyS0Z3amk2TjhhKzN2ejZhN0JQQmNhY3VETXVwZU9LVUZleXEvc2R1?=
 =?gb2312?B?VTgybko1ZXZQQVVnTVRTYUUyZmtLK3ZrbGQ4Sk5qQ1Q5NjRPdXUxdXBzaHFT?=
 =?gb2312?B?aExXZ3ZYckZhT1JlZ0xIQjUrdHVMK0pQQ0J1YzQ0Yko4MEFRVWFZUGZTcWJ3?=
 =?gb2312?B?Q2FSemVBbjdLdmEveEZCQ3RmNWViMVBHWk1XbG1xZ1NYa1J1MFdDUFRhc0tj?=
 =?gb2312?B?aVJ2MUl1bHhOK25NTEQ2SVJwRHRSalQ4ZjJyWXl0bVJXMnNPS2FlbmNtZWNy?=
 =?gb2312?B?c2hFZCtacUdHL1FJR2pWYXFPYm91K1VWUitBYjl1TllUZ1p2aDZvcHhSTEtX?=
 =?gb2312?B?cWJEc25KSVlRODBrTURqTG9ucG9CaW4yOG0vTHNlcm82UFhoeDBPalorM1dJ?=
 =?gb2312?B?MVVoeUt2MXVhL3IxUHNMVW1vREV0b3luWENOeHVyM0xJeHN5blJwMDlOSzBp?=
 =?gb2312?B?Sjl2VmhaYVlwV2c2cTVFdWRGVzdzcC92M2tBRkg3S2pOQS9weVZKc3lOSDFj?=
 =?gb2312?B?TzV2bzgwK0ppcUJlOEJKODZIb3d1STJDVUZLekVZQjRsYTBJVXJoQzBEVlFG?=
 =?gb2312?B?b0dzdDYybHNyWGh0czh1Wk5VYStqWi9TbU5PelFhT29nVDlLR3RKTHFiQjgz?=
 =?gb2312?B?T3Z6SDZQbk5jZmRONjY1b05YSGdBc3F5UENiWksxeTdKd1VSVngrTVUvRm43?=
 =?gb2312?B?dDVBdjd0RkRIZTlnVEt4Rmg5cm5qeCtXL3UrQUlQbndUcXBOd3hLbDVwZHJQ?=
 =?gb2312?B?ODhPN04rcVJTTXBjZ2laR2FYOFRDZEhqdHMzcFhoeGI2RTBhZ3hKT3ArVXJy?=
 =?gb2312?B?TmEwUm1tRk8wSjRGdG5ScUVuYk5zOXRKTzFQZWVvN3B6SHpVWE5ueldvc0ZT?=
 =?gb2312?B?TE5sYVZFbVdqS3laMGhEOEZuVTBSd2d2OFA2NkhYa2NYTzAwUlhlb1oraDhZ?=
 =?gb2312?B?VGdpVm1EWXhkMHNlTVVkUUJJUmp5TDZFaXdQUlFGL0FoNlNUNzV3Wm1WZXJE?=
 =?gb2312?B?ZVZDTytueFdFZkR1UHViR29icm56RExmaStIMTNkYm1iZXRpa3hVUERTbWls?=
 =?gb2312?B?c3lRTnlVelpDT2UzczlCeEtHUnpVSFB1OVIrNExLQkNRcnVHamlTMHdaUGh2?=
 =?gb2312?Q?FdqKhD0hKRr+zsP8eEnHdYrocT8FczfWsRtOpeR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f2adf5-45e1-446d-5a13-08d8f02d8e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 08:02:52.2745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/oZFko/fAunuor6+i3jcSGZkeIpbX/vgljhFThubRna9SRagVU9+HdComMQJPmeHizsTw/nMP8Rw1H6h/IhjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNClRoYW5rcyBmb3IgeW91ciBraW5kbHkgcmVwbHkhDQoNCj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNo
Pg0KPiBTZW50OiAyMDIxxOoz1MIyNcjVIDIwOjQ1DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+OyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogRkVDIHVuYmluZC9iaW5kIGZlYXR1cmUNCj4gDQo+IE9uIFRodSwg
TWFyIDI1LCAyMDIxIGF0IDA4OjA0OjU4QU0gKzAwMDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4g
Pg0KPiA+IEhpIEFuZHJldywgRmxvcmlhbiwgSGVpbmVyDQo+ID4NCj4gPiBZb3UgYXJlIGFsbCBF
dGhlcm5ldCBNRElPIGJ1cyBhbmQgUEhZIGV4cGVydHMsIEkgaGF2ZSBzb21lIHF1ZXN0aW9ucyBt
YXkNCj4gbmVlZCB5b3VyIGhlbHAsIHRoYW5rcyBhIGxvdCBpbiBhZHZhbmNlLg0KPiA+DQo+ID4g
Rm9yIG1hbnkgYm9hcmQgZGVzaWducywgaWYgaXQgaGFzIGR1YWwgTUFDIGluc3RhbmNlcywgdGhl
eSBhbHdheXMgc2hhcmUgb25lDQo+IE1ESU8gYnVzIHRvIHNhdmUgUElOcy4gU3VjaCBhcywgaS5N
WDZVTCBFVksgYm9hcmQ6DQo+IA0KPiBQbGVhc2Ugd3JhcCB5b3VyIGxpbmVzIGF0IGFyb3VuZCA3
NSBjaGFyYWN0ZXJzLiBTdGFuZGFyZCBuZXRpcXVldHRlIHJ1bGVzIGZvcg0KPiBlbWFpbHMgYXBw
bHkgdG8gYWxsIExpbnV4IGxpc3RzLg0KDQpPaywgdGhhbmtzLg0KDQo+ID4NCj4gPiAmZmVjMSB7
DQo+ID4gCXBpbmN0cmwtbmFtZXMgPSAiZGVmYXVsdCI7DQo+ID4gCXBpbmN0cmwtMCA9IDwmcGlu
Y3RybF9lbmV0MT47DQo+ID4gCXBoeS1tb2RlID0gInJtaWkiOw0KPiA+IAlwaHktaGFuZGxlID0g
PCZldGhwaHkwPjsNCj4gPiAJcGh5LXN1cHBseSA9IDwmcmVnX3BlcmlfM3YzPjsNCj4gPiAJc3Rh
dHVzID0gIm9rYXkiOw0KPiA+IH07DQo+ID4NCj4gPiAmZmVjMiB7DQo+ID4gCXBpbmN0cmwtbmFt
ZXMgPSAiZGVmYXVsdCI7DQo+ID4gCXBpbmN0cmwtMCA9IDwmcGluY3RybF9lbmV0Mj47DQo+ID4g
CXBoeS1tb2RlID0gInJtaWkiOw0KPiA+IAlwaHktaGFuZGxlID0gPCZldGhwaHkxPjsNCj4gPiAJ
cGh5LXN1cHBseSA9IDwmcmVnX3BlcmlfM3YzPjsNCj4gPiAJc3RhdHVzID0gIm9rYXkiOw0KPiA+
DQo+ID4gCW1kaW8gew0KPiA+IAkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ID4gCQkjc2l6ZS1j
ZWxscyA9IDwwPjsNCj4gPg0KPiA+IAkJZXRocGh5MDogZXRoZXJuZXQtcGh5QDIgew0KPiA+IAkJ
CWNvbXBhdGlibGUgPSAiZXRoZXJuZXQtcGh5LWlkMDAyMi4xNTYwIjsNCj4gPiAJCQlyZWcgPSA8
Mj47DQo+ID4gCQkJbWljcmVsLGxlZC1tb2RlID0gPDE+Ow0KPiA+IAkJCWNsb2NrcyA9IDwmY2xr
cyBJTVg2VUxfQ0xLX0VORVRfUkVGPjsNCj4gPiAJCQljbG9jay1uYW1lcyA9ICJybWlpLXJlZiI7
DQo+ID4NCj4gPiAJCX07DQo+ID4NCj4gPiAJCWV0aHBoeTE6IGV0aGVybmV0LXBoeUAxIHsNCj4g
PiAJCQljb21wYXRpYmxlID0gImV0aGVybmV0LXBoeS1pZDAwMjIuMTU2MCI7DQo+ID4gCQkJcmVn
ID0gPDE+Ow0KPiA+IAkJCW1pY3JlbCxsZWQtbW9kZSA9IDwxPjsNCj4gPiAJCQljbG9ja3MgPSA8
JmNsa3MgSU1YNlVMX0NMS19FTkVUMl9SRUY+Ow0KPiA+IAkJCWNsb2NrLW5hbWVzID0gInJtaWkt
cmVmIjsNCj4gPiAJCX07DQo+ID4gCX07DQo+ID4gfTsNCj4gPg0KPiA+IEZvciBGRUMgZHJpdmVy
IG5vdywgdGhlcmUgaXMgYSBwYXRjaCBmcm9tIEZhYmlvIHRvIHByZXZlbnQgdW5iaW5kL2JpbmQN
Cj4gPiBmZWF0dXJlIHNpbmNlIGR1YWwgRkVDIGNvbnRyb2xsZXJzIHNoYXJlIG9uZSBNRElPIGJ1
cy4NCj4gPiAoaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/
dXJsPWh0dHBzJTNBJTJGJTJGZ2l0DQo+ID4gLmtlcm5lbC5vcmclMkZwdWIlMkZzY20lMkZsaW51
eCUyRmtlcm5lbCUyRmdpdCUyRm5leHQlMkZsaW51eC1uZXh0LmdpDQo+IHQNCj4gPiAlMkZjb21t
aXQlMkZkcml2ZXJzJTJGbmV0JTJGZXRoZXJuZXQlMkZmcmVlc2NhbGUlMkZmZWNfbWFpbi5jJTNG
aA0KPiAlM0RuZQ0KPiA+DQo+IHh0LTIwMjEwMzI0JTI2aWQlM0QyNzJiYjBlOWU4Y2RjNzZlMDRi
YWVlZmEwY2Q0MzAxOWRhYTA4NDFiJmFtcDsNCj4gZGF0YT0wDQo+ID4NCj4gNCU3QzAxJTdDcWlh
bmdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3QzRhYzI2NmYxZWY1MTRiZDA5ZTljMDhkOGVmOGINCj4g
ZWUzMyUNCj4gPg0KPiA3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAl
N0M2Mzc1MjI3MzE1NjE1MDUzMDgNCj4gJTdDVW5rbg0KPiA+DQo+IG93biU3Q1RXRnBiR1pzYjNk
OGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaA0KPiBhV3dp
DQo+ID4NCj4gTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1kc3RHQUlod0h0THQzWVc5
RDhwOEw1Y05weElXTA0KPiBoM3dLelFtTHANCj4gPiBvR0dnRSUzRCZhbXA7cmVzZXJ2ZWQ9MCkg
SWYgd2UgdW5iaW5kIGZlYzIgYW5kIHRoZW4gZmVjMSBjYW4ndCB3b3JrDQo+ID4gc2luY2UgTURJ
TyBidXMgaXMgY29udHJvbGxlZCBieSBGRUMxLCBGRUMyIGNhbid0IHVzZSBpdCBpbmRlcGVuZGVu
dGx5Lg0KPiA+DQo+ID4gTXkgcXVlc3Rpb24gaXMgdGhhdCBpZiB3ZSB3YW50IHRvIGltcGxlbWVu
dCB1bmJpbmQvYmluZCBmZWF0dXJlLCB3aGF0IG5lZWQNCj4gd2UgZG8/DQo+IA0KPiBPbmUgb3B0
aW9uIGlzIHlvdSB1bmJpbmQgRkVDMSBmaXJzdCwgYW5kIHRoZW4gRkVDMi4NCg0KWWVzLCB5b3Ug
YXJlIHJpZ2h0LiBJdCBzaG91bGQgYmUgYWx3YXlzIGZpbmUgZm9yIHNpbmdsZSBGRUMgY29udHJv
bGxlciwgYW5kIHVuYmluZC9iaW5kIG9uZSBieSBvbmUgc2hvdWxkIGFsc28gYmUgZmluZSBmb3Ig
ZHVhbCBGRUMgY29udHJvbGxlcnMgd2hpY2ggc2hhcmUgb25lIE1ESU8gYnVzLiBJIHRlc3Qgb24g
aS5NWDZVTCwgaS5NWDhNTS9NUC4NCg0KPiA+IEl0IHNlZW1zIHRvIGFic3RyYWN0IGFuIGluZGVw
ZW5kZW50IE1ESU8gYnVzIGZvciBkdWFsIEZFQyBpbnN0YW5jZXMuIEkNCj4gPiBsb29rIGF0IHRo
ZSBNRElPIGR0IGJpbmRpbmdzLCBpdCBzZWVtcyBzdXBwb3J0IHN1Y2ggY2FzZSBhcyBpdCBoYXMN
Cj4gPiAicmVnIg0KPiA+IHByb3BlcnR5LiAoRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC9tZGlvLnlhbWwpDQo+IA0KPiBZb3UgY2FuIGhhdmUgZnVsbHkgc3RhbmRhbG9uZSBN
RElPIGJ1cyBkcml2ZXJzLiBZb3UgZ2VuZXJhbGx5IGRvIHRoaXMgd2hlbiB0aGUNCj4gTURJTyBi
dXMgcmVnaXN0ZXJzIGFyZSBpbiB0aGVpciBvd24gYWRkcmVzcyBzcGFjZSwgd2hpY2ggeW91IGNh
biBpb3JlbWFwKCkNCj4gc2VwYXJhdGVseSBmcm9tIHRoZSBNQUMgcmVnaXN0ZXJzLiBUYWtlIGEg
bG9vayBpbiBkcml2ZXJzL25ldC9tZGlvLy4NCj4gDQo+ID4gRnJvbSB5b3VyIG9waW5pb25zLCBk
byB5b3UgdGhpbmsgaXQgaXMgbmVjZXNzYXJ5IHRvIGltcHJvdmUgaXQ/DQo+IA0KPiBXaGF0IGlz
IHlvdSB1c2UgY2FzZSBmb3IgdW5iaW5kaW5nL2JpbmRpbmcgdGhlIEZFQz8NCg0KVXNlcnMgbWF5
IHdhbnQgdG8gdW5iaW5kIEZFQyBkcml2ZXIsIGFuZCB0aGVuIGJpbmQgdG8gRkVDIFVJTyBkcml2
ZXIsIHN1Y2ggYXMgZm9yIERQREsgdXNlIGNhc2UgdG8gaW1wcm92ZSB0aGUgdGhyb3VnaHB1dC4N
Cg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ICAgICAgQW5kcmV3DQo=
