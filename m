Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88963BF81B
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhGHKNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 06:13:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:61751 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231421AbhGHKNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 06:13:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="207655864"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="207655864"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 03:10:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="410857916"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 08 Jul 2021 03:10:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 03:10:27 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 03:10:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 8 Jul 2021 03:10:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 8 Jul 2021 03:10:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNFHCHrwFSgOxkbLwaeyvzrVR/7QVr5bZdnFsqRsel05nTWxC9yVHCWXwBtjKOa75Wpub3LYxuwC54iHJUUfReeFmPJP6035K56JzDwUt/r1kZuRPUBAxP/SjR78EvpXHp+++38UTSRgbzhJYmM3VqN/BLoPwCdoEzWQvJrGdnzUMrGIC/j5P/mcEqlcNPHderGCi3wrL6gV68pKLo/+4wY9a75SjKhpc4FAhMfMzpUZzWXcbAjtzgu4AU1gBJzSr42Kp+DYEiEbfQvGkL1ZchkUKYXBXQD/btIE+0n1ZvfeV4hckPtPFopXri+UEWR46MSJPFrEmP0rrLMlVzJwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndiCLDRNGxMUFANTIeXF8zg15wc2eWhd9YwfbOGPFlQ=;
 b=Z6E7xbbqe0PPKJ+6d+YhVoqMInu0oqB9SFCBN/KX0N9yAA5ipwrSm1Sob5Rc+XZVd6dIt2xubNeGQPo+mBp8Kofz/AP+Mq595ViKMtUADP8//rs8K+hAvtzHrn9rMZhsv7cLg6nNzieivzlICG50Wfzk0tvoyAv+Iy5kPPTnSzF43qUEOxx7GObx0DPxbjcPN5tBX2NijhzgYf5QNjYuolbbDM+4hC6dyEXy5ghpiNDlsnb6MHhqeHm2Uh1/B3r8apak6ghpMiGrEg0hSp+TRMPXVS+dorcE4+7PktPyyoC8s83L99A+BH5ScJ9C2ekmvynA3uCZVCmm0989bxZXIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndiCLDRNGxMUFANTIeXF8zg15wc2eWhd9YwfbOGPFlQ=;
 b=S4M+dtj9GsKHVSz5LsT3DDbn5ZwOo/kiHnmyAzx1lhpmXkzeGQGUBcO0dXKOa9lFgX4zDRDNHshdDqBQfco6jG+OKaMne9iBcBEmMg8NrL3/fCoVH0zIdMmjLcOdMmxgmYTklJWAN1xlGTkchIWAWxhrK6zgZqELcEasDjUrNI0=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MW3PR11MB4586.namprd11.prod.outlook.com (2603:10b6:303:5e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Thu, 8 Jul
 2021 10:10:26 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290%5]) with mapi id 15.20.4308.021; Thu, 8 Jul 2021
 10:10:26 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
Thread-Topic: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Thread-Index: AQHXc5JVSuHoO6yBxk2FsVeJf8muoas4SJuAgAAXwoCAAHlYsA==
Date:   Thu, 8 Jul 2021 10:10:26 +0000
Message-ID: <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch> <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
In-Reply-To: <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac0a5f1d-171d-420f-f09b-08d941f89bad
x-ms-traffictypediagnostic: MW3PR11MB4586:
x-microsoft-antispam-prvs: <MW3PR11MB458656358734BA54EB6B3751D5199@MW3PR11MB4586.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U8vyBNxvfWGJgc9AB/v90Kut6dfe1Li8Ajm/Ji4YFc9Su2+PwuspRg/MXu6egFrEz1KmF6uVv9D35fPASycqVd1fe/rQG6OeMwKqPpw7Lrlm+snLXP1raiLf4wx4tVqbYOxKoeEHRcnXJEaGUgea691hlpE9gCpQ68wGl0TR6ucXUgXHfQ6GN37Pxju3rWbc3mQqTZ+QFkbOCHpjzIsTpKTKVUysgwTz2obhPQnCARd2PRCx8iKOgteJ9nT01ocx3zzzQQR+Jclmb46Sf4tiWI+PPBxXdjpnWXHmBM747oliK5UWQcD5XdJOlnLKhDXplgb2dzgZFmw1PxkSExTp81f9E2nHEu9Y6WTk3cSrlp1QnbPHofjlzkqqHmLQrApWMTJTKB9RRp39cMEprWL6DqJSRYxeAJXu/ckQC5XPAkkYiJzobCcaaFmjOxFdDKTNgptK0F8keMChnMz0WRitQxtsc/F+coygWofmQteVNex+AFQua99Vu+0iU+6BDRdKefAs6QHAQeTTYVfGcZyA55/wlLWWA9pD6qL9LYBUhUevy3VaXPzWYdFHL5F6aKuQ5E09u9xlzcHKhNkVMzEEz0i+sxS8uRnr7rRTAVNTIMdKcWKDlXF0xjRCGfPmNQewbAjHyXcd0KFtoDwqCH9UNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(7696005)(122000001)(66446008)(55016002)(52536014)(66946007)(9686003)(76116006)(4326008)(478600001)(66476007)(71200400001)(38100700002)(64756008)(316002)(8936002)(8676002)(110136005)(54906003)(186003)(5660300002)(6506007)(66556008)(55236004)(2906002)(33656002)(26005)(53546011)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFFxaWgza1JvMG04TS9MMS9XUlRBSmgzWmpjRXJoVXkwSm1qN1dEL3hFVHdj?=
 =?utf-8?B?alRjdHFNZmtnRzVpVHhLbW9ISjlyb0V0dXdERlIxb3Y1VVNxSDhqZENmRkR4?=
 =?utf-8?B?cmw5VGRBYjNQdWJZZnpWazkremt5SEMyVUxkbS84cFFKS08zQ2tSZWVTWnkr?=
 =?utf-8?B?dEgvN0JBNUNPS3llbW1qN3JqRjNiNEJFaVdCcVJxRlBQMG1BdXF0eHNQNjhz?=
 =?utf-8?B?cEpROWYzRjY1WTk5dGViM0VHcVJtc1BBSUdYZElXNjB5ejlYdVVzOFNmcHNX?=
 =?utf-8?B?b3NjcDlZZExFT2JTSWlMQTQrNDR3Rm1mVFlYTEo2Vzd3VGdHNjhvVzNhQVZo?=
 =?utf-8?B?MVZaTlJmQW9QOU1vUWZxTjhBcE5TeS9pVVJ6dU5BOU9KWFNDMkFNQzBLc3NN?=
 =?utf-8?B?M2hEMFNuUGtLejJkMitQcVpsT0x1dmE0YXpLV2lreU5KOE1ZNEViQlgxSEZJ?=
 =?utf-8?B?TkcxTlhlQzlTQmFzZC9TU2F2Skx5RXlKY3BFdnUxMVN1V29pRlpqVzFNUDIv?=
 =?utf-8?B?aExxN1pEbDkvTlRFMHNWRUJyUERNQnJwSHNRRzFmQmJ2cWxBSHhmQm55WS9a?=
 =?utf-8?B?KzM3TGRvV2pvWjRUVEpyc29EMk9kNjREazNGdW1aM1FrNjU3ZnpkVkJQdlJ3?=
 =?utf-8?B?YnphNnIwbWs4eFhpZy84YWtoZW14Wk9KOVlvZzV4M00vVmRja3ZwYWF0QVdC?=
 =?utf-8?B?UFAzRnpNZXpFbmpWSjdDMUlJbVhRR0IrMHR6MGFqQzRUdXMzK2xMcTFBM0RQ?=
 =?utf-8?B?MnpKVWRQWUh4Mk1oU0pMa3RpNFNIMEZjVmtWNXhqdG4zaGVpdTIzYnptV25W?=
 =?utf-8?B?eEo3Unluc2c2YzZjR0ZGamRRbm54Ni9ZemVHQkMydXBmbFFwRjdiUm9xQUhH?=
 =?utf-8?B?bWovSDFCT1I2VnB4NG1JTk15azBpd3JlSWx5V0ozamlrdGdqdm1WdFpKM1cz?=
 =?utf-8?B?T2VzRllzNXdIcitpVThsaysrWWJlbEJEY2QzV0QrWVNFbXdNU1dGa3MvczdL?=
 =?utf-8?B?RE1VOVc5aDkvc0lzU3NXOXlIU2oyTjdYUDd5M3lueUlmVUtONVR4cStzaFNQ?=
 =?utf-8?B?UEtHYVdTRTVaZGpXelVSZWd1cUdrWWpuenZrUmJxanArejZDTkg1NUhlWlBt?=
 =?utf-8?B?VlBsS2NNcHVXbTBoUStZbExEdE5sYzZUb2R6d1VydjIvamw3QTc3L2NoaVZl?=
 =?utf-8?B?MFd1VVg5cWhsdS91ektMQkdGUkVMMFYyaFhTaDNvR2hFZVUxNlVWL1RzVXZy?=
 =?utf-8?B?K0MwbCtwcVhBSkV4THdaTkdKMzkwZ2xGalRyaE1NKzM1cVhBQjZBenBORU4x?=
 =?utf-8?B?MEh6SjVnWE1WOXluVFhIQ0pCclVSV3JwTnFSSU5VMEk2cnZzeEJ2My9UY2JI?=
 =?utf-8?B?cHQweWhpT3RQNmRZUXdpVU1hY1JPYmhSS1ZXekUrdGUrbkhnalhaV083L1g5?=
 =?utf-8?B?bkpSb1ovVGpZYTZYNTNhT1lZQ2pEM0tQSGVtZVBWY0VNcmozUzJaWVhYYnNN?=
 =?utf-8?B?elJpaDhwVlkrV1JJK1J2REd0UFF0RTMxSCtnS0ExRm9FK0prQW5jUU8zYUlq?=
 =?utf-8?B?STBYelZ6Q255eWtwOEMwbmhwcThlendHL3BXcXdjdGYwd05HWlZJOGUwMHhl?=
 =?utf-8?B?OVdLK2lNNWw1MTB1RTA4K0lRbS9PWDFnZTUvUjVOZ2pDRmE5RTdFdmJtOGZD?=
 =?utf-8?B?aDRRTldDZ0wyL3AwU1I2aVpDQk8wckgvbUEzTXplcmNPYkRzTXJxcHVwcE1M?=
 =?utf-8?Q?5aH8/SvwRU2+HnFmmLSfJsaybvqxo4PR/dIkPZe?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0a5f1d-171d-420f-f09b-08d941f89bad
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 10:10:26.8581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Le2I08+RxqenHOgtf0K+AKqV5kpmPDyFYNW8QHZnpJlvAUoGdo3t1T+2rkElCGZklypztANYD6JWECBb+wmn73Cj2GlViLftTFz4vhyVs9IPJCIBCqD9pkABtAoVhijk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4586
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDgsIDIwMjEg
MTA6NDkgQU0NCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IElzbWFpbCwgTW9o
YW1tYWQgQXRoYXJpDQo+IDxtb2hhbW1hZC5hdGhhcmkuaXNtYWlsQGludGVsLmNvbT4NCj4gQ2M6
IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBEYXZpZCBTIC4gTWlsbGVy
DQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5v
cmcudWs+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwub3JnPjsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldF0gbmV0OiBwaHk6IHJlY29uZmlndXJlIFBIWSBXT0wgaW4gcmVzdW1lIGlmIFdP
TA0KPiBvcHRpb24gc3RpbGwgZW5hYmxlZA0KPiANCj4gDQo+IA0KPiBPbiA3LzcvMjAyMSA2OjIz
IFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPiBPbiBUaHUsIEp1bCAwOCwgMjAyMSBhdCAwODo0
Mjo1M0FNICswODAwLA0KPiBtb2hhbW1hZC5hdGhhcmkuaXNtYWlsQGludGVsLmNvbSB3cm90ZToN
Cj4gPj4gRnJvbTogTW9oYW1tYWQgQXRoYXJpIEJpbiBJc21haWwgPG1vaGFtbWFkLmF0aGFyaS5p
c21haWxAaW50ZWwuY29tPg0KPiA+Pg0KPiA+PiBXaGVuIHRoZSBQSFkgd2FrZXMgdXAgZnJvbSBz
dXNwZW5kIHRocm91Z2ggV09MIGV2ZW50LCB0aGVyZSBpcyBhIG5lZWQNCj4gPj4gdG8gcmVjb25m
aWd1cmUgdGhlIFdPTCBpZiB0aGUgV09MIG9wdGlvbiBzdGlsbCBlbmFibGVkLiBUaGUgbWFpbg0K
PiA+PiBvcGVyYXRpb24gaXMgdG8gY2xlYXIgdGhlIFdPTCBldmVudCBzdGF0dXMuIFNvIHRoYXQs
IHN1YnNlcXVlbnQgV09MDQo+ID4+IGV2ZW50IGNhbiBiZSB0cmlnZ2VyZWQgcHJvcGVybHkuDQo+
ID4+DQo+ID4+IFRoaXMgZml4IGlzIG5lZWRlZCBlc3BlY2lhbGx5IGZvciB0aGUgUEhZIHRoYXQg
b3BlcmF0ZXMgaW4gUEhZX1BPTEwNCj4gPj4gbW9kZSB3aGVyZSB0aGVyZSBpcyBubyBoYW5kbGVy
IChzdWNoIGFzIGludGVycnVwdCBoYW5kbGVyKSBhdmFpbGFibGUNCj4gPj4gdG8gY2xlYXIgdGhl
IFdPTCBldmVudCBzdGF0dXMuDQo+ID4NCj4gPiBJIHN0aWxsIHRoaW5rIHRoaXMgYXJjaGl0ZWN0
dXJlIGlzIHdyb25nLg0KPiA+DQo+ID4gVGhlIGludGVycnVwdCBwaW4gaXMgd2lyZWQgdG8gdGhl
IFBNSUMuIENhbiB0aGUgUE1JQyBiZSBtb2RlbGxlZCBhcyBhbg0KPiA+IGludGVycnVwdCBjb250
cm9sbGVyPyBUaGF0IHdvdWxkIGFsbG93IHRoZSBpbnRlcnJ1cHQgdG8gYmUgaGFuZGxlZCBhcw0K
PiA+IG5vcm1hbCwgYW5kIHdvdWxkIG1lYW4geW91IGRvbid0IG5lZWQgcG9sbGluZywgYW5kIHlv
dSBkb24ndCBuZWVkIHRoaXMNCj4gPiBoYWNrLg0KPiANCj4gSSBoYXZlIHRvIGFncmVlIHdpdGgg
QW5kcmV3IGhlcmUsIGFuZCBpZiB0aGUgYW5zd2VyIGlzIHRoYXQgeW91IGNhbm5vdCBtb2RlbA0K
PiB0aGlzIFBNSUMgYXMgYW4gaW50ZXJydXB0IGNvbnRyb2xsZXIsIGNhbm5vdCB0aGUgY29uZmln
X2luaXQoKSBjYWxsYmFjayBvZiB0aGUNCj4gZHJpdmVyIGFja25vd2xlZGdlIHRoZW4gZGlzYWJs
ZSB0aGUgaW50ZXJydXB0cyBhcyBpdCBub3JtYWxseSB3b3VsZCBpZiB5b3Ugd2VyZQ0KPiBjb2xk
IGJvb3RpbmcgdGhlIHN5c3RlbT8gVGhpcyB3b3VsZCBhbHNvIGFsbG93IHlvdSB0byBwcm9wZXJs
eSBhY2NvdW50IGZvciB0aGUNCj4gUEhZIGhhdmluZyB3b2tlbi11cCB0aGUgc3lzdGVtLg0KDQpI
aSBGbG9yaWFuLA0KDQpUaGFuayB5b3UgZm9yIHRoZSBzdWdnZXN0aW9uLiANCklmIEkgdW5kZXJz
dGFuZCBjb3JyZWN0bHksIHlvdSBhcmUgc3VnZ2VzdGluZyB0byBhY2tub3dsZWRnZSBhbmQgY2xl
YXIgdGhlIFdPTCBzdGF0dXMgaW4gY29uZmlnX2luaXQoKSBjYWxsYmFjayBmdW5jdGlvbi4gQW0g
SSBjb3JyZWN0Pw0KSWYgeWVzLCBJIGRpZCB0cnkgdG8gYWRkIGEgY29kZSB0byBjbGVhciBXT0wg
c3RhdHVzIGluIG1hcnZlbGxfY29uZmlnX2luaXQoKSBmdW5jdGlvbiAod2UgYXJlIHVzaW5nIE1h
cnZlbGwgQWxhc2thIDg4RTE1MTIpLiBCdXQsIEkgZm91bmQgdGhhdCwgaWYgdGhlIHBsYXRmb3Jt
IHdha2UgdXAgZnJvbSBTMyhtZW0pIG9yIFM0KGRpc2spLCB0aGUgY29uZmlnX2luaXQoKSBjYWxs
YmFjayBmdW5jdGlvbiBpcyBub3QgY2FsbGVkLiBBcyB0aGUgcmVzdWx0LCBXT0wgc3RhdHVzIG5v
dCBhYmxlIHRvIGJlIGNsZWFyZWQgaW4gY29uZmlnX2luaXQoKS4NCg0KUGxlYXNlIGFkdmljZSBp
ZiB5b3UgYW55IHN1Z2dlc3Rpb24uDQoNCi1BdGhhcmktIA0KDQo+IC0tDQo+IEZsb3JpYW4NCg==
