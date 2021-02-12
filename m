Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4068731A5FE
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBLUYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:24:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59921 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhBLUYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613161460; x=1644697460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7LLDTyPowIHn1YBkOpWfrp6wylm0Bdm1XHC4nLFvAGc=;
  b=gM84WdMEWqIbI5Fu833vtdkmycGDmU4TlYjJVpoxBnLA54USc38E1tUk
   1CygLkOfPLHm9lRFk4c0LmGYJjuZVJTRCemyJfZJ3bDSc0kEh0JExozer
   5RaPlf2CrfHfagHizgHA1FF2uyn9FmkLgaUA1hm3gn0msxwBSPwuwMkAT
   PIad3QBCSouatY+N0hJ7bhPP6Fx3rnUzasZgzhDF5l5yarIXYz3AJei13
   OfNP5BnzxmDDhjYEe4oJh5REefmh1sPjwZbpCR3yycnykAdql4OnWHeoR
   pMwW0v3HUWJlmyrdGtg8YoU3pCnr8E7no79sCs3ks8TfKJAu7Ui+5KBbH
   Q==;
IronPort-SDR: JaZz2O4co5yORHOicgbiapcmNTLFHfU8E+aWmfxeSPH0w1tthjpzdLMWU63FB00Z4/Sjc9E/sQ
 yxx/EdUOYx+kE4OwwQ9DHqhWeYab9NYs7xj8ZLDsyRBI7WJ4UtWkn6lNsJ0+9etkNBFfTsMI1G
 hCWvjwQPMwQteUByppeK0Y8x4dKjW6TNwtSrA7tzoPCpKIn6Hd/onmxWt13sYtLnwgv9DJEfI+
 +lBBDZ5j77RdQ8LzeEIBJikAns2CfZ2yB4v1wCrwYqeyVGTdOOuAMD0IYSAWXIxoWpn0X6PLKf
 1ds=
X-IronPort-AV: E=Sophos;i="5.81,174,1610434800"; 
   d="scan'208";a="103600593"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 13:23:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 13:23:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 12 Feb 2021 13:23:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF00bAZJ+I05mje7Aok9uP16DCeWw7p72gODLn4oOjfgXaD7GwZ1nXPznz+P66pEBNkx7J5mvFzVyP/vgXqpyVxHLAniL/vHhT/DqzgEcuT+bdcWThwdITHSbAiyVVYAZDQipOW7ObtaUygMaZAAxgHZmqD7AkTcnnJIpOHe+sJttCMa8JV7LlP2fXlAbYKf/jueEp/HaR4TlIxeW54Yd8gVz22xSGYkcekER4SIihcBg3orRWv5dFdEna2vJygd03vBcIew+diHw1ideDVYUlAtOUIZxWz0vDnTT+BAA8wtWdqifPtBehJ67bX1hel52wDa7Z+XAxymCmDZGGXYdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LLDTyPowIHn1YBkOpWfrp6wylm0Bdm1XHC4nLFvAGc=;
 b=BIKwwAii0ghRHBUN8sWF3rE5iiKxs9tNvxtXkT4qS9SFWFgmQRmbP4mfwZ38/9sUP4XN/uTHRw/VuStehS16HNYI6uVSmjTKOPzvdYsViMIXpMoG0p81Hry1B4Bsjn/onqFL5t6q/wYx5pfWDsF8k2xMmjG6y/0ByQMt1jUza34G/9FNtyzJogdqO9IjtO+d72KlOy/ouNX8dlCG/CzegqqnY2255oMTKa7ANQGYfbEPY07490frnSBASuo7JsxuPDLPMnIHlHdyogvCNM3iKmZlU0QC8U9CMs4j2InLcbNE4zkS8pFVYeuTssyOMxScTDT8z5wFZJStm0rdIZa2jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LLDTyPowIHn1YBkOpWfrp6wylm0Bdm1XHC4nLFvAGc=;
 b=mNZsZIRHfGlMYBZWRetr4QHnHcHBeIiDobqoWOnBscwPDAOdpI+MvMsFi68gA9y0o5Gl/FqDoDzrp1kw3kmnla5WSlbWykSr4qwxhb+pMILd0S+8vZe/QPXeV7fiNcKZlhP/cX+dGLoSxWfT9Z1NXSg7/U+Lrqd0jtsRyM/CrOo=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3551.namprd11.prod.outlook.com (2603:10b6:208:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Fri, 12 Feb
 2021 20:22:59 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3825.031; Fri, 12 Feb 2021
 20:22:59 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <hdanton@sina.com>, <hch@lst.de>,
        <willemdebruijn.kernel@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/5] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Thread-Topic: [PATCH net-next v2 1/5] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Thread-Index: AQHXAJGgFt1Wq7/gnUCkgDNF19oYrKpU+I+g
Date:   Fri, 12 Feb 2021 20:22:59 +0000
Message-ID: <MN2PR11MB3662BCAD7CAA6F33D91F5725FA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
 <20210211161830.17366-2-TheSven73@gmail.com>
In-Reply-To: <20210211161830.17366-2-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5db5e63d-755d-4f03-0529-08d8cf93fdda
x-ms-traffictypediagnostic: MN2PR11MB3551:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3551798CF5E68A5E9744999FFA8B9@MN2PR11MB3551.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zY3RWHUQrIHEdBP72PsLa09FmBr3rOFCKjmkfu6XjPhDHjyM2SNLXdXm90Z+/W2F/H1aDII+DZff6aSPTbnQ5odfcIomF2R8fuINwkdnDWwQSVHZr+IIK5FgcUlCGyN5D5uSAP3+Eg+a5DwTRTdgcRvuWU0g3gma3lQzPrgxnU5ROXYHEMo4gX033g+Ta1qiG2lokeVp2TxS0wZ6+tw8DYt1oSaEFjd6nXt2sBSyYlwWuGADTDTvQhnkWaaITM/F7JIeG6CvnPg4QvJj8lFsj9YTABEKezIVgRg5gNmHUYu7XDQRiIzQZD5KZlY85HCrt24nL/HM7+lOeB/kfTb4IMEMwbhEZsl2r3uGBdn1m+7ujmODaHAfi6roBGp20GfhD8R3jpWuIBxZiqCtrq+u7oZSUJjXWB5goIIexNKxyR/OTjvfUBDam5so8b0C6pUimEkwkceOwBOqMioNdc4e4DogJ1WsacKIBQTouh7o9hJOPaN9e37CEeVbWHihGZiQdA9dn5LD2vKxMVku+bYxxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(76116006)(9686003)(7416002)(66946007)(2906002)(71200400001)(64756008)(55016002)(8676002)(33656002)(52536014)(8936002)(83380400001)(7696005)(66446008)(6506007)(186003)(478600001)(26005)(4326008)(316002)(54906003)(66476007)(5660300002)(110136005)(86362001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V1M1b3RiTW10TDkrdCt6VkpjbXkvUW1odnp2RnRBeEtSQk4vODh3djZveGZ2?=
 =?utf-8?B?Z2xOeWdZazFCNHQxYS85ZSs3dWEwdGd2MXM1Q2FXNjMvUmhQSTJjTDZlclNZ?=
 =?utf-8?B?TUpCSlN1MUR3N2x4NnVBWk43UkJvVlRNdWIzd0VpMmpnR3RiaXVGY1VyYTlu?=
 =?utf-8?B?UCtYbnZwK3hmQlFPV0NuSW4rQnFwTXN1UDFxd2dJZ2FXOVZiVG1DdExxTU1j?=
 =?utf-8?B?dUhCSThrckNDTGtVMkhvZmhTdkZKSnlWTUlOSDlGVzN5VkpFRFh4ak95OTZh?=
 =?utf-8?B?ME02WHFxbVRsOUtQNW1xS3RUSFJ1aUM4RzduSVFKYzRYaWR1UmFPWU9FTHdZ?=
 =?utf-8?B?MVpRRGpIbGJHOTFkMEFaOTdnZktFMFl0MFRaNUJLV3F6SWhLVkhIV0F5MDNy?=
 =?utf-8?B?aXBSUDRtdmxwbmtPbzNCVHYycXJFcTh3N0ExN3BmaW45TC9IK1Nrb256MHJj?=
 =?utf-8?B?c3c0MlRDaktuekhENWlJYkJrclpEN3dhL0IxZ0lGbzBzNzE0dmRleEx6TnFy?=
 =?utf-8?B?N0kvbmdlRW85TGE1Z0NNVDg2OHZRNjUrRWFJRlVLeFJsLzNzQkR1bTB2TVRI?=
 =?utf-8?B?S1dMNXR1WTZuL0VzRVowd1l4Mk8zazdBZ2tWMG5wS2F5Z0JHU1d5eEtaTXJy?=
 =?utf-8?B?ZllTMDFVaVdIRXlIRmR5aE81K1pTWHhWOTBlVGZjU2lSeEpQMlVWQmFhSjRi?=
 =?utf-8?B?R2JuTTUyZVY1Z1U3RHFWbGFvaUU0SzI0NWZPbVVPZE9JN05HaTJSTmdETGtD?=
 =?utf-8?B?bmZuVzNvOW5UczBVQVkyU0NPeFNGa3pwYStTV2NRZE8wRk1nOFlHTk5ENGFt?=
 =?utf-8?B?Vi9XTzR1TW5wZkdjTDdYaHhKTUlCVEJ5U3lUYkFwL2VMS0lNdXBoNFB3aUl1?=
 =?utf-8?B?SDF4Nm13MnJLYnNxSE1hRDk1Zlc1MVkxT0Npb3BsNGdvQkp4Y0J2dVdORVo1?=
 =?utf-8?B?Y2g5MkVRamY4MS82VzVjenFwYlNjZ0hNWkNrY1AxRlUvWUF2Ym5PUllrbXJH?=
 =?utf-8?B?R2VCZFdhOURJWElGVk1wWE9NVHQrVzlpUE91WlBCRlFWTTlMV3ptY2pzNzJO?=
 =?utf-8?B?YlhmQmZMeGQ2ajBpbkRqWGhHZzMyOWpyNEtCejliTkpxUFJaRDA1MDBoMnNy?=
 =?utf-8?B?Nk01WjFHNW9ocTI2ZEI1UkRJd2x2Nmo0SFBBKzBiMWdsQkQ3VllXejd6K2hO?=
 =?utf-8?B?Z0dmRWhHVnFjWlhmUlI0MjlxbDdCMFZTVUNlbXhLbGp1UUh3alRRVEVGUzE2?=
 =?utf-8?B?anlDRVE4emRlL1loTEZ3dnU3YXFTcWE4cWlWVkRxaGVmdHZCRnV4RXBIWUpN?=
 =?utf-8?B?a3ZmMUZEV1BEb0UrYUh3NklsSUFEZGFRZnFwbGJ0R28yMGdMam5sK0pjMnl6?=
 =?utf-8?B?aUQwL0VQdjJ2cys4QjFTZ0pQaER2eXFodXVrQzRNQzZWUW41NGtDYmw0aTdv?=
 =?utf-8?B?YmdIcnNncDR4cEtVZjh3ZzdVR05GVGx0RzZ5RU9ncEJpVnUxVFFNM3ZrQUhn?=
 =?utf-8?B?SzZ4alRTWWtFVEhmSFV0dXNUSjdyNjUxUHhyMk1zQmdYaC8yUFh6RXhsZ3oy?=
 =?utf-8?B?WW55RWZMRlJ1LzFWODFlRXdLYlJzSnk2eWYxeE4vdDlxeHNZb1orL3dMRzNH?=
 =?utf-8?B?SWM5TDNxK1czMjZHUGdLelAwTkl0bk1yd0FDa2prdENGU3daZ1l3VkJLZStj?=
 =?utf-8?B?VW0wYUx2TmtNRDJuS3Jja1JYVXlYdmRjSkJrVndQdFRPRFJXT0tiZXB5YVpv?=
 =?utf-8?Q?524XEyPLPFpSJS4DhBwWbhdqr1zwrBqjisUrcxH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db5e63d-755d-4f03-0529-08d8cf93fdda
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 20:22:59.8251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QjJJwr+aG3eDsErMny5n4ztBtq6uuHhaYFjOkQNS/tpStS8Fb7a7OO/CIpqvCi3QunmW7ydLxiE3+qlj90p67XBmtmN1sKMoeWeeIRwe49g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3ZlbiwNCg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgdjIgMS81XSBsYW43NDN4OiBi
b29zdCBwZXJmb3JtYW5jZSBvbiBjcHUgYXJjaHMNCj4gdy9vIGRtYSBjYWNoZSBzbm9vcGluZw0K
PiANCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3Uga25vdyB0aGUNCj4gY29udGVudCBpcyBzYWZlDQo+IA0KPiBGcm9tOiBT
dmVuIFZhbiBBc2Jyb2VjayA8dGhlc3ZlbjczQGdtYWlsLmNvbT4NCj4gDQo+IFRoZSBidWZmZXJz
IGluIHRoZSBsYW43NDN4IGRyaXZlcidzIHJlY2VpdmUgcmluZyBhcmUgYWx3YXlzIDlLLCBldmVu
IHdoZW4gdGhlDQo+IGxhcmdlc3QgcGFja2V0IHRoYXQgY2FuIGJlIHJlY2VpdmVkICh0aGUgbXR1
KSBpcyBtdWNoIHNtYWxsZXIuIFRoaXMgcGVyZm9ybXMNCj4gcGFydGljdWxhcmx5IGJhZGx5IG9u
IGNwdSBhcmNocyB3aXRob3V0IGRtYSBjYWNoZSBzbm9vcGluZyAoc3VjaCBhcyBBUk0pOg0KPiBl
YWNoIHJlY2VpdmVkIHBhY2tldCByZXN1bHRzIGluIGEgOUsgZG1hX3ttYXB8dW5tYXB9IG9wZXJh
dGlvbiwgd2hpY2ggaXMNCj4gdmVyeSBleHBlbnNpdmUgYmVjYXVzZSBjcHUgY2FjaGVzIG5lZWQg
dG8gYmUgaW52YWxpZGF0ZWQuDQo+IA0KPiBDYXJlZnVsIG1lYXN1cmVtZW50IG9mIHRoZSBkcml2
ZXIgcnggcGF0aCBvbiBhcm12NyByZXZlYWxzIHRoYXQgdGhlIGNwdQ0KPiBzcGVuZHMgdGhlIG1h
am9yaXR5IG9mIGl0cyB0aW1lIHdhaXRpbmcgZm9yIGNhY2hlIGludmFsaWRhdGlvbi4NCj4gDQo+
IE9wdGltaXplIGJ5IGtlZXBpbmcgdGhlIHJ4IHJpbmcgYnVmZmVyIHNpemUgYXMgY2xvc2UgYXMg
cG9zc2libGUgdG8gdGhlIG10dS4NCj4gVGhpcyBsaW1pdHMgdGhlIGFtb3VudCBvZiBjYWNoZSB0
aGF0IHJlcXVpcmVzIGludmFsaWRhdGlvbi4NCj4gDQo+IFRoaXMgb3B0aW1pemF0aW9uIHdvdWxk
IG5vcm1hbGx5IGZvcmNlIHVzIHRvIHJlLWFsbG9jYXRlIGFsbCByaW5nIGJ1ZmZlcnMgd2hlbg0K
PiB0aGUgbXR1IGlzIGNoYW5nZWQgLSBhIGRpc3J1cHRpdmUgZXZlbnQsIGJlY2F1c2UgaXQgY2Fu
IG9ubHkgaGFwcGVuIHdoZW4NCj4gdGhlIG5ldHdvcmsgaW50ZXJmYWNlIGlzIGRvd24uDQo+IA0K
PiBSZW1vdmUgdGhlIG5lZWQgdG8gcmUtYWxsb2NhdGUgYWxsIHJpbmcgYnVmZmVycyBieSBhZGRp
bmcgc3VwcG9ydCBmb3IgbXVsdGktDQo+IGJ1ZmZlciBmcmFtZXMuIE5vdyBhbnkgY29tYmluYXRp
b24gb2YgbXR1IGFuZCByaW5nIGJ1ZmZlciBzaXplIHdpbGwgd29yay4NCj4gV2hlbiB0aGUgbXR1
IGNoYW5nZXMgZnJvbSBtdHUxIHRvIG10dTIsIGNvbnN1bWVkIGJ1ZmZlcnMgb2Ygc2l6ZSBtdHUx
DQo+IGFyZSBsYXppbHkgcmVwbGFjZWQgYnkgbmV3bHkgYWxsb2NhdGVkIGJ1ZmZlcnMgb2Ygc2l6
ZSBtdHUyLg0KPiANCj4gVGhlc2Ugb3B0aW1pemF0aW9ucyBkb3VibGUgdGhlIHJ4IHBlcmZvcm1h
bmNlIG9uIGFybXY3Lg0KPiBUaGlyZCBwYXJ0aWVzIHJlcG9ydCAzeCByeCBzcGVlZHVwIG9uIGFy
bXY4Lg0KPiANCj4gVGVzdGVkIHdpdGggaXBlcmYzIG9uIGEgZnJlZXNjYWxlIGlteDZxcCArIGxh
bjc0MzAsIGJvdGggc2lkZXMgc2V0IHRvIG10dQ0KPiAxNTAwIGJ5dGVzLCBtZWFzdXJlIHJ4IHBl
cmZvcm1hbmNlOg0KPiANCj4gQmVmb3JlOg0KPiBbIElEXSBJbnRlcnZhbCAgICAgICAgICAgVHJh
bnNmZXIgICAgIEJhbmR3aWR0aCAgICAgICBSZXRyDQo+IFsgIDRdICAgMC4wMC0yMC4wMCAgc2Vj
ICAgNTUwIE1CeXRlcyAgIDIzMSBNYml0cy9zZWMgICAgMA0KPiBBZnRlcjoNCj4gWyBJRF0gSW50
ZXJ2YWwgICAgICAgICAgIFRyYW5zZmVyICAgICBCYW5kd2lkdGggICAgICAgUmV0cg0KPiBbICA0
XSAgIDAuMDAtMjAuMDAgIHNlYyAgMS4zMyBHQnl0ZXMgICA1NzAgTWJpdHMvc2VjICAgIDANCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFN2ZW4gVmFuIEFzYnJvZWNrIDx0aGVzdmVuNzNAZ21haWwuY29t
Pg0KDQpMb29rcyBnb29kDQoNClJldmlld2VkLWJ5OiBCcnlhbiBXaGl0ZWhlYWQgPEJyeWFuLldo
aXRlaGVhZEBtaWNyb2NoaXAuY29tPg0KDQo=
