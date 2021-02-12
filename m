Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3356E319D86
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhBLLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 06:44:45 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:14765 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBLLok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 06:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613130279; x=1644666279;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UErNGnwGIDrcYW7/bS4h2AaPs2jHebY3+fgAfYw2MaQ=;
  b=X8D7aCCpeLLVIAORAlX/d/VOhC3/0HmB31GUCEK17EqbmzIuYpCWXY5v
   LJDKW94IWXUAr3v9KIuvZod8bX/mKL/cXWITz+qUt2+k8RBhVRsIGkL9E
   vNn+7gBuCtajQCKfXl4IfePGFqM5+lGfIhY/iFINTLxRuM6Uqqu6UBlj/
   5MxDCNpvTckkgqWzsXo1pyJjcaUb3wkC8/vouhN3TA1HTIkrl2YwSjdqx
   9RIU+JK8vgS+IkxucOV01yI/hRbz0+6dKE7jxM+acNBjGbVQ19r0DViLd
   MoMUY8d3MVlltyUGm/L4uRNczBAeP6UwY2IZM2ORhQpfzBLA91mIQpKBX
   Q==;
IronPort-SDR: iZaxlKLkgewh9qnQ/OFIuav1kR++M1bk11SEcxCZ19QzKgQumWvKK+C8yicAeDVOowBbbH8X6n
 qBV3wNp0CAf4NOkrlqJSa1a/h+dHQeAkwBHbF8g8UWLAtwAXBKDYp0uyqEuNVb1HGC6Q8I7zJI
 FQkVhrZCaMMieg6Xhi9c/gwQdEj8aDl3pdLmmysB9FG4sRPPzPdlgk6aHljw28xBCvZ6IgTJ+C
 s+eUCcvkwN6352Wf7dEGUnk9oawSIovmrFsTgXXDcegJ+DW9ua/nLZv/JjkYAHfmV+jL5RoT+P
 gig=
X-IronPort-AV: E=Sophos;i="5.81,173,1610434800"; 
   d="scan'208";a="43881674"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 04:43:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 04:43:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 12 Feb 2021 04:43:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oC7EOChd3nL1wjN96A0Hc5Gil+bDkOfPEfIIV4l/PsHPgPTI9UNMfaopx5bN9g4KCiUAFsSU7tP1fELkyn337oGYlI1OBbt4SKuQR79EC+iVRjCk2oqX60miNW1VUX3Z21WlrfCWjhHKT5IZptiERrnRXztfosdcUpmy6oBr7uVTEsiykk/Ktipou2B2bSSZvrkd1aQoWzPtNrQFVWRYwfNjHdJBE1WTkwpWYye3K2RAW9BGOtfGDMmHnejNzY5YUSPdTQHNaw9/5WrpTJa4X4jz8AxDERieGmhi1s4hBcFMEa0hYntVLktL0op84+fIjq3lmSXmO2eooxg0l+tERg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UErNGnwGIDrcYW7/bS4h2AaPs2jHebY3+fgAfYw2MaQ=;
 b=ZUYvCo2oupk25hUvM3N2/wcD9pAVVJe2BNOx2hPoYlrqpA5ki2oYzVEJJBtFd3K2A8oe+gw4fx+B6RVg/uInFOy7VK+dbalDToVl7lcpb0yWy0kF/IMoUgy3KNimbTqY/B09BGtA/z4e8EejGUBjxXUYmMeECVvxgdiEV/uSJoTCyU9LgdDr+3+0iMKMjzVc9X71tt1y84swTLEjJNPZkIlVzD9WJpUWyrrJVvuYLx2j34NM5SqatZwqH7RsggQkgI3VRZ+sS58wvlLlaqmX6oLywPNlUl9TEcqdyrqjHy+XYnKRs902BgIlve0Xg6knL/TODa19VXi6HhzJzfUNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UErNGnwGIDrcYW7/bS4h2AaPs2jHebY3+fgAfYw2MaQ=;
 b=sq0X3ENPTWwM1tQJflWmWWm08ceAXQRELpgEDhsJ8TaopKAy3ONnu/+MIJRn2RGv0dQpSqsiZFP8qT/N3ECzG4tVuytrLwyQsCBORs9Adt3KA2Sz7Bq1NkdsTeEmXd9eqio8d/POLtvwPcH5sPTnWkD/qWEslKNbADbAqrb8dAU=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB1306.namprd11.prod.outlook.com (2603:10b6:3:b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.31; Fri, 12 Feb 2021 11:43:20 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3846.034; Fri, 12 Feb 2021
 11:43:20 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <hkallweit1@gmail.com>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: consider that suspend2ram may cut off PHY
 power
Thread-Topic: [PATCH net] net: phy: consider that suspend2ram may cut off PHY
 power
Thread-Index: AQHXATRBqQU/ztzC3U+rZ8RmMpEbrQ==
Date:   Fri, 12 Feb 2021 11:43:20 +0000
Message-ID: <aa2e700d-83f9-1105-ca3a-a060c5da734a@microchip.com>
References: <fcd4c005-22b0-809b-4474-0435313a5a47@gmail.com>
In-Reply-To: <fcd4c005-22b0-809b-4474-0435313a5a47@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [86.124.22.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e8abeac-80a5-4f70-1b2a-08d8cf4b65a2
x-ms-traffictypediagnostic: DM5PR11MB1306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1306A5187F8EAE010F2341BB878B9@DM5PR11MB1306.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j+EoVsABMWSBrRnJsbSYT/4loYIWK5CPDnpUZTzygF9dek3PcEAx9gl09Vk0JHkxMpC75yuY++60pINhO6ndT9J67xWFWcO7+NucHKxBXyswlpAWDidfQatez5EFzLpLm2wHcnJvweUezTIhencPw8+G34fk5evh4LoB4G+JOz1txaFPSfDKOc1rRjzMWM5Sbu8pklT/0aqyPyMbq8Gq8hCwZDN6hbVhdZlCXH5ClG78LsIr/wr/5NYqclzCcK8bJIuueyp0SuzFwdjWfXjJGzCFU1c7nvcfRiumKhkEDzgo9U3tT/Kh5HE+qT3Z8/pHQB/4tPxarC9N4rvGDlkMsood2JGfOPi5sbSOj1wH30yLU8KiFMWMdjosxZ7TMjzw+tSFfbB0hxNP60hWlXGUBv8cmZJ1cIQ4m/ZI4XnlGC4eya4qr2U17jehS5/LuIYP2eRLrvMkRPVfhmVM/FMWyZy1KEohNBmtKeFTw3KSgoQ/oleCt6C1qKb1QRTZzXr/1aCq7RRipkB8cKEUqE7qD7By1HCS5U8kHgXIHf2TJnnn9qH8vI21id28qwmi1ukl633NJBHROkSzUIb7LVYEeXf2I5tnVyxq03Nn7zWGZbSknmic4A0J8afs5E3V3qtr5NsbO/Y6Yhy3hKCcyBvnxQ3RW2OBz9awzxvhlDAXvUvLdG4YX0rHxUX+b4ssOW8x
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6512007)(8676002)(2906002)(83380400001)(8936002)(36756003)(6486002)(31686004)(66946007)(316002)(66476007)(2616005)(5660300002)(110136005)(91956017)(76116006)(966005)(478600001)(66556008)(64756008)(53546011)(6506007)(86362001)(4326008)(31696002)(66446008)(186003)(71200400001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bkNjLy9KNzFYUGlSVGoyUENWRU9ac2FsWnNnVFFJdUU3azFlR1BvN0RLRlZp?=
 =?utf-8?B?c2kyZGJvNzdxYlV4TTY2VUVVRkM3M1BNMzNtK0p3N2YzWEZXOTF2QUtxanRj?=
 =?utf-8?B?ekduNndTQ1FROHVjUVRRU1BvZHFVL0dsK25wSGhiSkt1dXRIcXMwV0RiNFA1?=
 =?utf-8?B?Wlo2dGFQRGJFL0RTU09pV3N0aVVETDN6OHErY3NXUWJHbzYxUmMyNmI4cjhH?=
 =?utf-8?B?SERWdXRDdXhXdmtVdkhDQlNTK0s3RmNubEE4MExNVVI0TlV0ZThyKzFrWE9a?=
 =?utf-8?B?eFhYcm5QczNMOHFXL0xiWlBRZEplM0JLNUJoZW8wdXNjWjZRc201WDdWNzla?=
 =?utf-8?B?SzgrQWkySzV3aCtKZC9WSFZ6Ui8wNUVvaUs5Z05QSXVCNlVveEFGZW5xaFlu?=
 =?utf-8?B?dmswYnBPdm9PUkhkOUtvVFlWUVF4ZkN3QkNzWUhRUGNyY0UwQkhOZ2FpeitY?=
 =?utf-8?B?Y0IrRnYyY01KSTBJSkx5aE1nSnhaSitwWGFPY2JLRy9DNVcxN1hiTGhQRE1p?=
 =?utf-8?B?bFZEbmM5V3ZOa0J5T1dQRmNDSm41WUJoTXo5R2ZnaXhDNUd1ZUZ4SlFkWEw5?=
 =?utf-8?B?Vldha3dKZDkzUERCUjY1V3Y3UUY0ZmJZWnk0SkhQK1dzb2FBSjNVQXZ2bDMv?=
 =?utf-8?B?cE1BbG5NemIrQ240NExiYnZxSWVLM1FYYTByeXhHRWo2L2NjWEQ2cUpNWnBv?=
 =?utf-8?B?T0F0dHU4cGxtdmMvNGF6SzZxNUFrMjRhYStNTU82UWF4d013c0JoZmNqV2pK?=
 =?utf-8?B?bWpGRmc4SjRVSytUVjhPcjkzSXpCT3psd08xM3VrNTlYUllEWWhHUXB3c0dG?=
 =?utf-8?B?cnVTQ3gvWVlmUVpiV3JVcWEwZG9CR1lCYnJsWnpXbFFtdnZZSStNcG5wWlNF?=
 =?utf-8?B?RWowa3JhMEdFQ1FwL1JEN2c1Sk0xMkVMOHJ4Y2RaL0V6OGxtSHdkYzdwUkha?=
 =?utf-8?B?RkZHUmdlZXU1bFIxdERDRFZPeDJvZ1lkODNOdnpqbUtiMFZsRlloQWg3UEFi?=
 =?utf-8?B?U2pNVUZBeFViTlUyUDV6ZG1XUDdkcWNkeVRpNUZOT0JwVzE4SnFtVFhzZzM4?=
 =?utf-8?B?QkZqWTJIL2xiMFJjdkNFU0V5R09VdmZzS2dHZFZGb24xMnVjNUEveXpnVU5z?=
 =?utf-8?B?LzZDVkdwNlJuTzBYN0RIZEZWQ0pDMk9qR2xRRWJyYXVpb3RwME9LbG82VG9O?=
 =?utf-8?B?Ni9CMzBSbFFPSDdFOTVHUFExQWx1YmJqWXlkd1RmbGsva2RvRVdEZ1F5eGFS?=
 =?utf-8?B?cVMrbFUwNi8zclAyNjRmREQwRmlDY3c5d2Q2ckZxM1k3ak5DTnRkaTZ5ZXI0?=
 =?utf-8?B?V01HWlFHY2tBbC96VlhUc1VJaE9oZndKcnRBWEZWS1FHNWlmNGFlaGJOVlZI?=
 =?utf-8?B?THMrSGViclZTNTdzMnlDZC9ZckFuWjM0ZVJQa20wcW9McE5qR3E4MlRicXVF?=
 =?utf-8?B?M284Ym5sU2ZpUXRzUTNNa0hta21ZZ1BYeXZlLzF6YllVQWNLMGFXT2xtWFox?=
 =?utf-8?B?VFN4TG5FaDBFUkZKdDVobi9UbTB2QXF1NUl3UTVmMm9OWWliazRCRTVmUGdu?=
 =?utf-8?B?MzhweDI5Q1V0U1A5SlZRcDFCbG1OV3ZrWXlia29MNERZenpTQXg3UlQ2L0dr?=
 =?utf-8?B?bEx4NHFGQ0tSSFMvVU5KTUM3ZXhXbVhzOFpoS3BvRVg5Rk8wbE10R21WblN5?=
 =?utf-8?B?RDNvVFpESGFHUTNKZzljU3ZLNUs5QmJ2NTRJOEpseFA4R1VLTkpsb0lQL2lk?=
 =?utf-8?Q?kAOrql8hQeljtro3GM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA01ED8FCB11C448B1B7F385F14538D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8abeac-80a5-4f70-1b2a-08d8cf4b65a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 11:43:20.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hEi7o7Dl1tQLkx2h00LlFAfFwI9UggcdMpawR4vXaNSsp4czERjEOrZdWehbF2cm8sggsA5ccyJGxJQeNvk0+I6XhAS0PZil3xjzm6MJjtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1306
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEuMDIuMjAyMSAyMzozMiwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0KPiBFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IENsYXVkaXUgcmVwb3J0ZWQgdGhhdCBvbiBo
aXMgc3lzdGVtIFMyUiBjdXRzIG9mZiBwb3dlciB0byB0aGUgUEhZIGFuZA0KPiBhZnRlciByZXN1
bWluZyBjZXJ0YWluIFBIWSBzZXR0aW5ncyBhcmUgbG9zdC4gVGhlIFBNIGZvbGtzIGNvbmZpcm1l
ZA0KPiB0aGF0IGN1dHRpbmcgb2ZmIHBvd2VyIHRvIHNlbGVjdGVkIGNvbXBvbmVudHMgaW4gUzJS
IGlzIGEgdmFsaWQgY2FzZS4NCj4gVGhlcmVmb3JlIHJlc3VtaW5nIGZyb20gUzJSLCBzYW1lIGFz
IGZyb20gaGliZXJuYXRpb24sIGhhcyB0byBhc3N1bWUNCj4gdGhhdCB0aGUgUEhZIGhhcyBwb3dl
ci1vbiBkZWZhdWx0cy4gQXMgYSBjb25zZXF1ZW5jZSB1c2UgdGhlIHJlc3RvcmUNCj4gY2FsbGJh
Y2sgYWxzbyBhcyByZXN1bWUgY2FsbGJhY2suDQo+IEluIGFkZGl0aW9uIG1ha2Ugc3VyZSB0aGF0
IHRoZSBpbnRlcnJ1cHQgY29uZmlndXJhdGlvbiBpcyByZXN0b3JlZC4NCj4gTGV0J3MgZG8gdGhp
cyBpbiBwaHlfaW5pdF9odygpIGFuZCBlbnN1cmUgdGhhdCBhZnRlciB0aGlzIGNhbGwNCj4gYWN0
dWFsIGludGVycnVwdCBjb25maWd1cmF0aW9uIGlzIGluIHN5bmMgd2l0aCBwaHlkZXYtPmludGVy
cnVwdHMuDQo+IEN1cnJlbnRseSwgaWYgaW50ZXJydXB0IHdhcyBlbmFibGVkIGJlZm9yZSBoaWJl
cm5hdGlvbiwgd2Ugd291bGQNCj4gcmVzdW1lIHdpdGggaW50ZXJydXB0IGRpc2FibGVkIGJlY2F1
c2UgdGhhdCdzIHRoZSBwb3dlci1vbiBkZWZhdWx0Lg0KPiANCj4gVGhpcyBmaXggYXBwbGllcyBj
bGVhbmx5IG9ubHkgYWZ0ZXIgdGhlIGNvbW1pdCBtYXJrZWQgYXMgZml4ZWQuDQo+IA0KPiBJIGRv
bid0IGhhdmUgYW4gYWZmZWN0ZWQgc3lzdGVtLCB0aGVyZWZvcmUgY2hhbmdlIGlzIGNvbXBpbGUt
dGVzdGVkDQo+IG9ubHkuDQo+IA0KPiBbMF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2
LzE2MTAxMjA3NTQtMTQzMzEtMS1naXQtc2VuZC1lbWFpbC1jbGF1ZGl1LmJlem5lYUBtaWNyb2No
aXAuY29tLw0KPiANCj4gRml4ZXM6IDYxMWQ3NzlhZjdjYSAoIm5ldDogcGh5OiBmaXggTURJTyBi
dXMgUE0gUEhZIHJlc3VtaW5nIikNCj4gUmVwb3J0ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1
ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdl
aXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KDQpIaSBIZWluZXIsDQoNCkkgdGVzdGVkIGl0IG9u
IGEgc3lzdGVtIHcvIFNBTUE3RzUgYW5kIEtTWjkxMzEgUEhZLCB3aXRoIGEgUzJSIG1vZGUgdGhh
dA0KY3V0cyB0aGUgUEhZJ3MgcG93ZXIgYW5kIGNvbm5lY3Rpdml0eSB3YXMgZ29vZCBhZnRlciBy
ZXN1bWUuIFRoYW5rIHlvdSBmb3INCnlvdXIgcGF0Y2ghDQoNClRlc3RlZC1ieTogQ2xhdWRpdSBC
ZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQo=
