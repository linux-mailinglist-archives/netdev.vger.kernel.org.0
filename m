Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB64436594E
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhDTMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:54:53 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57420 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhDTMyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618923260; x=1650459260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8/IHPWGBzfp3UDnmZF5gMkJBspYqdoZewV1YCV6xOSg=;
  b=0VueJrWVi/QiYgPUM7qBP9sBk5seAd9PQt070pZm6X7mqZv9d7zqH4DS
   0H/cxzTAiRm3GtE048Hyoqcqv2yci1+fKreLMxKlQAHOQVVQD7F7mBMUO
   70AzBbPerZ/Zw1tmmvqQ8lwxvg404Z0jFkgk/EjrK0faqNSKH5bu5mVvk
   BMCbYMtIuWmGMXEL3DOeoN+F88UAM+gUCFRfVIRiRnuqGaH5KuCpAwWWK
   dXNzFetJADYorhnBNZk5zfMn2iqTTlckKx2xLlWrKV8FIqBzROsNqN+ZI
   IBneilggX94teM67aE63wmN1Y4XDSKK4vretUvp023fbzzCfaX5t2fIyg
   A==;
IronPort-SDR: FjQ7yPNsHvlGhpCOpPk5yee3GMl1YtGZoEYkA6AETAxGo4ZBM8egjtlhjxW4M8NbTgn8pB/k/a
 jxDlXie9CWhqjVBnaA03W0XFvHkaIcPpCnSXwis8S2z323aL45ovI0SmBo29PW6G4hzJ6UsWdp
 jwslCCOwXR4QE0ej/0ltReg3EZ5943GOPIk+gv846sHmAfKutEtpfo/BvBoIF5xqMxPN5WF9cO
 rvVJjFnGMmtwy8TXQcpPuCvJppgpzUU8kmR1Zz67p3OAa5mZfAtTx+5REvbaOV2TlwIIjsewXI
 Lcc=
X-IronPort-AV: E=Sophos;i="5.82,236,1613458800"; 
   d="scan'208";a="51815093"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2021 05:54:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 05:54:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Tue, 20 Apr 2021 05:54:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUTYC1AilkskYnQKLP/OEgDnEFFn+S+W52Zi/ogQti9l1XsEz2+jkobqcSrpWelq5+71Hod6tl5bAB0+s3KPISQMTW2OhJYwOQEwpfP8u2OMDIhKgo3U6SAojO3vybNd21c1dflF//BYllckllPY14nqf7MpFxpdZPL93yUcSOotjfdgeRYsS1yCziVpKwU5M1S86uJjQ4BqzEmoyH5oSRgIFQTq7TKcQuWcC5AtSb7wLQNQqQBVqF7LOkVQB5SYxTxd5CyYBG2RH7Lrwk1E7X0HoyRbCe4b2x0HnEu9Z+Mwq/V6K9l4qLbbC86MidXc4XbsKXo5PkurYFkoZ+Ve8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/IHPWGBzfp3UDnmZF5gMkJBspYqdoZewV1YCV6xOSg=;
 b=ZyTvz90oZ70qBOV8ARtCtkjbRpIET8UB5gIORjIP6LglVbm44f6OM4xYTYhjKY+xu2VFwcq4CqWnRx/557JUUtDy8T3oC+VBIsXhJMU0eotHs+JGCkV8UU1CjFdQ9Q+PoOFiBBannd8aIalbWkd5u/Ra9Pi2eDworVNaT0rNruBu2hM2oOF1tUjOdCdWI5SODmy5OMrCIkMhT/BG6RyJi/HC7EAHD591kIQCxtrM1hj8GfJbqJLMTBjUjd6ydJX2KfKbUFlz1aKpkFlpJfC8OoxePSKr21Ip+dGAxIJMEfdtHrSqCTufTDwAhhoUvgfArd7X7Mk3Nt1DoF13/cuLHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/IHPWGBzfp3UDnmZF5gMkJBspYqdoZewV1YCV6xOSg=;
 b=svdoKkJqbtr3hgaOprUQd3wxJ+MqipQddD8j06lKiI9Fp6B5mLh8yL/MAauYd0q9sGeMfokUOqawWkyB2yCOCGNYoyrSvoQDmG6mD1+OQlFk1cmsXd/ODIo3UB9f4mWSiA/B7CZO7JnWFM6cbS9kjAp0cDh+mUfhxtEICOWyL9A=
Received: from DM6PR11MB3417.namprd11.prod.outlook.com (2603:10b6:5:68::33) by
 DM5PR11MB2010.namprd11.prod.outlook.com (2603:10b6:3:12::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.21; Tue, 20 Apr 2021 12:54:14 +0000
Received: from DM6PR11MB3417.namprd11.prod.outlook.com
 ([fe80::c994:babd:c007:eeb3]) by DM6PR11MB3417.namprd11.prod.outlook.com
 ([fe80::c994:babd:c007:eeb3%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 12:54:14 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <masahiroy@kernel.org>,
        <Bjarni.Jonasson@microchip.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <linux@armlinux.org.uk>,
        <Lars.Povlsen@microchip.com>, <arnd@arndb.de>,
        <p.zabel@pengutronix.de>, <simon.horman@netronome.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <mark.einon@gmail.com>, <madalin.bucur@oss.nxp.com>
Subject: Re: [PATCH net-next 03/10] net: sparx5: add hostmode with phylink
 support
Thread-Topic: [PATCH net-next 03/10] net: sparx5: add hostmode with phylink
 support
Thread-Index: AQHXMsLv1SdjNE1+n0yUe8etPNSsK6q3p8EAgAVuHwA=
Date:   Tue, 20 Apr 2021 12:54:14 +0000
Message-ID: <e443bf58c73cb382ea5f84eda9da1ea00ebf44c0.camel@microchip.com>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
         <20210416131657.3151464-4-steen.hegelund@microchip.com>
         <20210416142244.244656a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416142244.244656a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4-0ubuntu1 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2.104.141.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 290113cd-f827-4ee7-d785-08d903fb66d0
x-ms-traffictypediagnostic: DM5PR11MB2010:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB2010B0679CDA21173AAA766086489@DM5PR11MB2010.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFgncjmSlYl9yQNUdGQ683bcJnOIgV2UNZjGHDruHa+P+QheaFpv7M4nRU/7pAUjxS18h8s/lEC+aYSge16bWSYiO83hWnK6PxUZVNHYIZXOmQqXRj7ROoFaM3HymN2/CRljKTxfwG0NLwegnn8b0KPllg6aJ3cCnb2o70rAYO3bm8Qtzr/ER6n7poXBcmCGbTZxtgIgiNnUZr+22xy11JrWy0Ao8cDkg23DTVlUXs2NqspI73p0Z71EH5pME+TeXloQcROSYo06ILjYGDofbTWkbo4LXvQ71jJ+p0JhhQsHvJO8UcLsa+Y4OwW1ylmr5kHWuy7a81PMOp/h6F2MatxCMJXJwwV1MUq3OAEh59+3knIXh8DYckbDkfaN+gdPpHp7uBAHX2mtR0ewS04zRbxWsrY1021K78ZPEp8NM1PAhA/Z3Fzl2BID8B7Rnb4VOxXMW043dHZFRV+BHqsCZFUHu6lU8R4he5qLWgtifJBY3PpwLAbtFq9b6MyGVOQs9QpmaZ1fEI8GLHhL2zrVbcT8kUG/3atSJg0vGqaFJDWr3P2EDmbpQVvwnWdbG9RhnkBbWl4k9y3QpFm14Fm5bwRhCqunR4WM+CbsTNDlmlc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3417.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(136003)(376002)(366004)(396003)(6506007)(2616005)(122000001)(478600001)(36756003)(316002)(8936002)(6486002)(8676002)(186003)(5660300002)(4326008)(7416002)(86362001)(26005)(38100700002)(66556008)(66476007)(66946007)(91956017)(76116006)(54906003)(83380400001)(66446008)(6512007)(6916009)(2906002)(71200400001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YktPVVdJQWx3M3NSb0NzTDR2SnRYQTdvYmNzRGJ6TUU0eHRtV0xibElVb25C?=
 =?utf-8?B?dU02TFpPZVh6MWZ3Qk1Ca0tPNkRWWXZlY0o5ek9YeEN1SG5PbXFhNzhIT003?=
 =?utf-8?B?UGcwb0RTRStxMUxWa0xvM25ONlFwQ2x3TlFSYVlMU2xjYSsyRnRBcllRZFRH?=
 =?utf-8?B?VnQ0Z0NFVE1odHhUUHQ5ZmxIbmUyVjF4K0tnUVlOWlAwdFBMbmh4Ymo5NnAr?=
 =?utf-8?B?SHYxSzQ3L2tPT0FYR2xqUWhUY0JOVXd5OFE0RGFqKzhMckp2ejFFM0kzeVhi?=
 =?utf-8?B?a2ROTnM5M0syS1BWcVpaZS9ObGlvTGo3OTZ6clRpMUFUL3YrT0xWQ3VHZFJJ?=
 =?utf-8?B?VVRsamFPd0hYdzM2cytCU0tsNnpYT3BHNVpaQmlFeGZWZ2ljM2tocVZsV2lE?=
 =?utf-8?B?ZUxocWFORG81NWhrN2dGSFU2VjdBOCtjR08vM0gwTFRiNzZTYXRWOUVueVZh?=
 =?utf-8?B?aTZ2dnlMcUZ3WDFIWS8rL2JqeDRjejhUd2YzdXV1aDJpc2FtRXdHOElUZjJ4?=
 =?utf-8?B?VzNzRklJS0ZENFlBbi9Oc0hmQXdkU1NwdjVlMnQwWHBMOUtxaVlzaHZ4NGdj?=
 =?utf-8?B?by9VaUlvamFyYWJRRGdiSEVxblpjMHFiTzRzRExZZ0Vidk50dzhxNUxZVkZG?=
 =?utf-8?B?c1NBZnlkRzF4dE5PU1F4MS83RURLRVlVSHlFM1lFdVpRZTFKbVhnN1Z4K2Nm?=
 =?utf-8?B?UFVIdWRYcEttVTdIZzdtNUtMOWgyM3BYeWh5RWpzb1NKdlI2bytRSHZDY2Q1?=
 =?utf-8?B?QkxKaG10TS96UFhHMUl3NFBOVVdxRHlpRC84N0thTlZYWS9iVXpMdzlEK09O?=
 =?utf-8?B?NzMzZVF0WlVYL3ZrU2lWSFdGZS96M212Um9TQW82eUZ3ZTI2ellPRkVBem9E?=
 =?utf-8?B?TDN2VHZkTnFXR3lqdE5uUlVVU2dvWlVhdEEwQnVPVVdmRGN5RnBkSDNYVDlC?=
 =?utf-8?B?VTFKRktRN29RSkNHa1ozZFc3cE12ejhxTVhqOFhUUTJ6ZW04aHB6YzdGQzlX?=
 =?utf-8?B?NjM3WEVtMk4ySEFBeWwwUWJNNmJMei90dVdXWkdWWHV1QWVvU2hVV1JjZ2c5?=
 =?utf-8?B?eTZLMitCMFBpbVl3MVN4eDY2emh5NnZ2N2w2Y09UNG5DZGpCR2lJaHM4ZjJJ?=
 =?utf-8?B?aldiRHI1a3NqaVd3MEtOdndxREVyV016dDdQZit6Z1RJYmFlUlg1R2lqT2Iw?=
 =?utf-8?B?blhhbUtNa0dHekVsa1pweDBFTXUwOENBMWxLczByL1hLajF3eHdpS0g5R0ND?=
 =?utf-8?B?a2E0QkUyRk9TbjZyWDFRK0RNUnF5Rmppdyt6Ly92TVc3SmJlUk5LMzlSRlg4?=
 =?utf-8?B?NFkxVkNNVWxpa2MxcHR0WWRxd1c5cG5XN0lFWE9EZWVBbmZFWi8yc2NvL2p1?=
 =?utf-8?B?ZWJyUSsxay9xVGVwZkFQZ1VyZGRSRVUrbzBtWm9BTGVaZllaWXJXYUZqSFEx?=
 =?utf-8?B?bkliV0p0RFM4djd1UEFqelhSekpzNUpUbnRsckRUM3JkTUUwb1VjZXRoRzlB?=
 =?utf-8?B?T01ZT0thR1NHRkRjZVpEWExFVm9ZSUhkQW9YSzFlRk1oeDlJOFFWWjdwQjlK?=
 =?utf-8?B?SGRWT3lpZndwNllhVCt0VU9MMGV3SlNjRTZrL3cxOGRRUytHcFcvK1NJOTJJ?=
 =?utf-8?B?Vm1BVlcxak14blI1ajNaZndLaGZReWtTenJwMVpFVHVWYWswQzAxR2xSZ25O?=
 =?utf-8?B?QUFSTHQzVkkzdzhvT29jNnNnSDNCZmxZYmRCK3FiUkpwQ1UxR0U5M1JFUGZT?=
 =?utf-8?Q?ZJ8TFB4zA+B8h187xS1Cr51sZ21Lj5zUPrkM5BJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CC84AE2946D00498C1FF9D306DD3502@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3417.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290113cd-f827-4ee7-d785-08d903fb66d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 12:54:14.5653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DAoL26eFXc9qsfdQ/LYPFeGsNr40eAOJDAKe4zH13cCbVfl0h9mWmIQXCiBzRSITnG7c1TE8Hw7dr5TCReX4BymUybt3OnJEaeALdDiKqLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFjdWIsDQoNCg0KT24gRnJpLCAyMDIxLTA0LTE2IGF0IDE0OjIyIC0wNzAwLCBKYWt1YiBL
aWNpbnNraSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0K
PiBPbiBGcmksIDE2IEFwciAyMDIxIDE1OjE2OjUwICswMjAwIFN0ZWVuIEhlZ2VsdW5kIHdyb3Rl
Og0KPiA+ICtzdGF0aWMgaW50IHNwYXJ4NV9zZXRfbWFjX2FkZHJlc3Moc3RydWN0IG5ldF9kZXZp
Y2UgKmRldiwgdm9pZCAqcCkNCj4gPiArew0KPiA+ICsgICAgIGNvbnN0IHN0cnVjdCBzb2NrYWRk
ciAqYWRkciA9IHA7DQo+ID4gKw0KPiA+ICsgICAgIC8qIFJlY29yZCB0aGUgYWRkcmVzcyAqLw0K
PiA+ICsgICAgIGV0aGVyX2FkZHJfY29weShkZXYtPmRldl9hZGRyLCBhZGRyLT5zYV9kYXRhKTsN
Cj4gDQo+IEkgdGhpbmsgeW91IG5lZWQgdG8gdmFsaWRhdGUgdGhhdCBhZGQgaXMgYSB2YWxpZCBl
dGhlcm5ldCBhZGRyZXNzLg0KPiBpc192YWxpZF9ldGhlcl9hZGRyKCkNCg0KSSB3aWxsIGFkZCB2
YWxpZGF0aW9uLg0KDQo+IA0KPiA+ICtzdHJ1Y3QgbmV0X2RldmljZSAqc3Bhcng1X2NyZWF0ZV9u
ZXRkZXYoc3RydWN0IHNwYXJ4NSAqc3Bhcng1LCB1MzIgcG9ydG5vKQ0KPiA+ICt7DQo+ID4gKyAg
ICAgc3RydWN0IHNwYXJ4NV9wb3J0ICpzcHg1X3BvcnQ7DQo+ID4gKyAgICAgc3RydWN0IG5ldF9k
ZXZpY2UgKm5kZXY7DQo+ID4gKyAgICAgdTY0IHZhbDsNCj4gPiArDQo+ID4gKyAgICAgbmRldiA9
IGRldm1fYWxsb2NfZXRoZXJkZXYoc3Bhcng1LT5kZXYsIHNpemVvZihzdHJ1Y3Qgc3Bhcng1X3Bv
cnQpKTsNCj4gPiArICAgICBpZiAoIW5kZXYpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gRVJS
X1BUUigtRU5PTUVNKTsNCj4gPiArDQo+ID4gKyAgICAgU0VUX05FVERFVl9ERVYobmRldiwgc3Bh
cng1LT5kZXYpOw0KPiA+ICsgICAgIHNweDVfcG9ydCA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+
ICsgICAgIHNweDVfcG9ydC0+bmRldiA9IG5kZXY7DQo+ID4gKyAgICAgc3B4NV9wb3J0LT5zcGFy
eDUgPSBzcGFyeDU7DQo+ID4gKyAgICAgc3B4NV9wb3J0LT5wb3J0bm8gPSBwb3J0bm87DQo+ID4g
KyAgICAgc3Bhcng1X3NldF9wb3J0X2lmaChzcHg1X3BvcnQtPmlmaCwgcG9ydG5vKTsNCj4gPiAr
ICAgICBzbnByaW50ZihuZGV2LT5uYW1lLCBJRk5BTVNJWiwgImV0aCVkIiwgcG9ydG5vKTsNCj4g
DQo+IFBsZWFzZSBkb24ndCB0cnkgdG8gbmFtZSBpbnRlcmZhY2VzIGluIHRoZSBrZXJuZWwuDQoN
Ck9LLiAgSSB3aWxsIHJlbW92ZSB0aGF0Lg0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuDQoN
CkJSDQpTdGVlbg0KDQo=
