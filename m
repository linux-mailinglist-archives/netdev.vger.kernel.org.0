Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C7931B68A
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 10:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBOJhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 04:37:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25049 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhBOJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 04:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613381845; x=1644917845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hl0fGYvqiwuQmR4PKwzOXMPzivnSuAJdAdTHd+BQFIM=;
  b=qfj7bcEohJlzdsjR+CEgNOjTTA8zjZsiLuw8yRiY97bpYjGeCIr8QbF4
   lH50862PtURVaINrVld+PojtqJ/RLvWkegmHXcoGXv004tpOhpjGI9QWS
   vMBtyWCI+FZGyWNw6cCFTD8mdnH0euT6atiukAQLcupq6jAgbG/DclerM
   23qdHIv7S/cJmBEaJPxDUP2S46W3b5qpCcoYTEH5yenVc2FnDe/EqMmSh
   CtMdaoEHM8KmoB6pbCf0hvDMHrbXX108DJQJV9wlIvsyH1PxeLWN+2y2t
   Nmh2w2VQ88JBlpRs7VnRS/w3+Sfnb2C2K01g4nFsP0S8LV+ICgJ5v9JUV
   Q==;
IronPort-SDR: QSp9OHuNUP6cZtMd8w6ZuJkcopZmRkPEEybzTtduriBBC0/q24cFjOlt2J1SXEHUFKhYRpF+9F
 nGrGPYAL32A8/ZBO6ZlzazU0vHYQ2LFWsrZe4Qqx2wmiohOZDj2P4wR/eUSme/V+wVU3FV1C3c
 53g5WdSziDGizKXJD8WvISvemAsFimIf+jZ7j27JGYxlhKe8Uit+oRfBJ5/XpWa1kiGL5lYnwk
 2ieGev/1APITJdju7JUxNR5XyN/7RkQPiPaE+2UlK50Sz4kPF+zZ7jGobWSH7/JNrDoRFtKMhw
 5HU=
X-IronPort-AV: E=Sophos;i="5.81,180,1610434800"; 
   d="scan'208";a="115090807"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 02:36:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 02:36:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 15 Feb 2021 02:36:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYOoOjAV3noM2TST34DmF7GKHUiAgrnvyW4sY/6g9QFL6vqxWAtJcVfSWWE3YC7WS4mRR7aODteNS7hWsFYjXCTr4wes3f49DGtMGwQUzSu1Qq+FlY8gTKWuljfZHmW8sZHWqC6l2XcIfhIsxL7bvXrehbK3kEIM7YimcCbgTMkb/WoxWkTa2TB9NEYeY4sPd5aVgQhUnuOtxWNNiBmKCveom+CJkzA4K/drdAa34fHSJwmfyGAmVThsxs8Tm9gmjCaRTd4+kZ63PDPtUhLNXtQF1FrU4ZcKqds3wCripDdMFcmca1i6zYQ1rfFnHJ+YClvLWwpF1G2IJ31yrmA5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hl0fGYvqiwuQmR4PKwzOXMPzivnSuAJdAdTHd+BQFIM=;
 b=hQ1/p2s6zHuubJEruvX1hi/yxpUV7alpRgxxM4FRZRS2erpwmsRez8bXB2wyJReIVR8teZcWgZe9VG8JcyH0E0U4fDDRJxktRpg8vylg25hLw71m7UNlgNVELyOY82Si/Y7WKu/gm1+211+WS8Jo2vUdmPt4CDIypZheG1bm4qB4/hzbB+dmSiUUKFkm4KIH9VSxn3lgGvFhI8nCLvovuqWRDtMW4b9rg4Vfibcykn2/6lsP1Ns08d7M8Wx+arJiHeW26YylCA2H4vXmBJUF+c36LJ4uMsDTJ+BE9JfvnF0kKrDNx7+ksi4XOXqaqcAYAb6Tb2bAh7iokf6aHCeplQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hl0fGYvqiwuQmR4PKwzOXMPzivnSuAJdAdTHd+BQFIM=;
 b=YKqhvVti0JIdw+EiXCdiBW04ngNMnCeRv0nzpHGwiEutNtwbqsQLFGM5dcv2lLBfXQFNpaxfx6ROA16QMlx7knoYyz4qPc4we7wCoCL4gxhW07T5+BwY8sKD42hHQaNJtC+J7yG5dtPKn2Fa/1cXAi6eH85v3b/HcnhxyAvWlzw=
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com (2603:10b6:3:9e::23)
 by DM6PR11MB4364.namprd11.prod.outlook.com (2603:10b6:5:201::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Mon, 15 Feb
 2021 09:36:05 +0000
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9]) by DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9%11]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 09:36:05 +0000
From:   <Bjarni.Jonasson@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Steen.Hegelund@microchip.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>, <atenart@kernel.org>,
        <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net v1 3/3] net: phy: mscc: coma mode disabled for VSC8514
Thread-Topic: [PATCH net v1 3/3] net: phy: mscc: coma mode disabled for
 VSC8514
Thread-Index: AQHXAUitY8DplGiIOEOE3an50gQw8KpUts0AgARClgA=
Date:   Mon, 15 Feb 2021 09:36:05 +0000
Message-ID: <b2eef99237ae547f55391d0cb5db27972ca2fff8.camel@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
         <20210212140643.23436-3-bjarni.jonasson@microchip.com>
         <20210212163241.kbx5eqyaa32js7mp@skbuf>
In-Reply-To: <20210212163241.kbx5eqyaa32js7mp@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61989a35-efca-4cff-4ab6-08d8d1951dcf
x-ms-traffictypediagnostic: DM6PR11MB4364:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB436474AC33800CD2172132EDE4889@DM6PR11MB4364.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6J/rsj8xx5JBfMnAcnCD2ln2PIcrCPk70veUcSVkoBlJJUn+fPjV1rxNEH1CvNPrUB4pxDTJJN6KGM4KaQwYR06dqNW99oCh7chIaglW863JHZlsoRsXqZQDYR5yN03hvMCfo6a1IEpA2zAI67bHyUxlnutmfzdh2nZQnq99gXW6s4c4oPEj+qpDW/wCplwwKadg8V5AVNmCrUrYGAE2jyT6KUeFPZcd57P4rK84a9MvoU/Qz77SWCBTi8a4v4vcGuvmBLypcwnMtT6ssLu/055O/K4JEg+CSKaAIjCMOyuxVRY8siSbWK6j1N3Yo23/OzK8xZwU7phOoi1y2yZ98jVNFbv4CHoyTiECb3OwsywhxpQuyItYYtnw/MBlFmAgEGuD5shGhKXibPdWmqu0x5X398ixwjHqCYhbm9I8kHlUjQsjOnt+cSmacpuKz7QgNfXDO9rnb8BTbUAuG9l2Jd0cvCbAd3dx55fxpOmTA9iwvsJRDbQzYKaR8wi7KO/mNbDmahM9KFYDCjU0eg2bS8irF0eTEXHlA+ahTlNj+yaXPQ3Nj2hVWGrs5WpzsATe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2329.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(376002)(366004)(2616005)(2906002)(316002)(7416002)(5660300002)(54906003)(83380400001)(4326008)(6506007)(36756003)(8936002)(478600001)(8676002)(26005)(71200400001)(186003)(6486002)(66946007)(6916009)(76116006)(91956017)(6512007)(64756008)(66556008)(66476007)(66446008)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?d1JFbDZJT0lwQnEwUDFFdW1wUWNsOVF3dGpEZ0piSzg0c2FmYlN2b2FGTnJa?=
 =?utf-8?B?Mkk5SENNUnVLc0xQY3phRE5objFwUHhmUWJ6RlhFaXpMMEdva1F4dmJqajJi?=
 =?utf-8?B?UDYxR1YveUc3SEFLOFFHV0xxWGFjS0REeml1ODFYc2lHZzFMVEFaYjVMSzBa?=
 =?utf-8?B?ZCtrNElaQVAxYktuV3JoWTExRXZGeXpUSHdKOTkxeFVLNkIwNWhSRHNRZzF5?=
 =?utf-8?B?VXBjL01haTVBdjJraHlKMjN6NTBsNTJhb1pVOE9hdFNrUDVsZ3FIVlZlR093?=
 =?utf-8?B?RUV4OUhURVZnZTdvanhzcUQrMndZMDB0dEVOc1lTdGQ2R0gvN05UQmx5TG8w?=
 =?utf-8?B?YnFHM3NnOFVTUmtaMnA4SW1rdnBzN0Z6NksrTG1BYWtmMjdwK2UySzFSSHBY?=
 =?utf-8?B?aXF0MUdub0dWK3pJcEZKNmxkYnFTY1p0QjZrUVBOQ1I4a2JWTEY2NTJqMUhI?=
 =?utf-8?B?MEs3TTBudFpOVjdhOU5mTGJVQnhYYzlOYThEVFFNTXZ2NUlvSlFsU1VPOHVu?=
 =?utf-8?B?bmdGdFkwemc2a09zc2VQRFhUSUthY1VtVzgrTXJjVmhBamlodGlzenYxVWtl?=
 =?utf-8?B?b3A1VlJ0eDVDcytoUmxLM0JDQzhxMmVvTXVUa2hkYkMxQVhNVmQzVzkzTjNG?=
 =?utf-8?B?UFQ1dnBRTHFUWlBqd3pOR1ZuYnZwTHk5UmFsbzliZXRwbHJKTnc0VytyVnpQ?=
 =?utf-8?B?RHFGc25pVTlpOFlUNmpYV1ZyRmp3TmM4UHEvbjBvb1ExbFRQOEJKNTZaNXhF?=
 =?utf-8?B?RTJRSStjb2xxempkY0JlZzVtODNTRTFLZGJ4ZFlZL2YvMkk3bWIva0hVUnVI?=
 =?utf-8?B?Ung3aFVTMlRzM0x5VFJSSTVTYlpwRTBYanhqZ0Qwb2dnbEs5OW4vOVh3WnFQ?=
 =?utf-8?B?bzZzZzJ1Um8vdi9PNnBidjVyMExPVXdxL0UrTU9Ub0JpRVJvZW5HM3NHb1pJ?=
 =?utf-8?B?WGE4Mi9IeHJPQVliQUl3bk5yVFNIRDlONWk3dmwrbUVvaUNybTU1ZThtYzBY?=
 =?utf-8?B?dmxPRHRVbUhJNXF4QkFkakRVVUtmUVVBZmozM1dtN1BBTmNKVEdtYzZVMVZs?=
 =?utf-8?B?bkZCWFc1YjlsRWJBeVJFMVRQMWc5anUxUGdWTXVNOUF2Tmt6bktjMHlkdVQv?=
 =?utf-8?B?UnZydjZ1bDVxYzBhcHVMTWR0WHBCZnpDQW1VUUUvS0Vscm9nSzN0NkhQaERF?=
 =?utf-8?B?UTZ0UFpxa2JLaUV2UWFBR21NMGRkUk1mMHRUSFh0TzBrcUlmWTJlZWRWeUhL?=
 =?utf-8?B?V0JyYXlDTzcydllZaDBNVHl6ZmZJY0JiNm9INWlYbDRLUkNHWGx5UHQ1bitJ?=
 =?utf-8?B?RGNGRzJNK1VzUEo3SnJsTzY3UUNyMUlUSmp1M3Ivd214dXFSbXRCd00xSEFp?=
 =?utf-8?B?YXhXd2UrcUdFcmNTTWpUc0ZVMzhadFg4Wi8wTmE4a2hEY3VaZ3h4disvY3l5?=
 =?utf-8?B?b2wrZVRGUFBVb0pmTkhVTGM3aXdYR083S3lmN0owaFMrd2ZpUk53aW1yWHdr?=
 =?utf-8?B?RjNoZWIzV1pmT2xyK1hNTSt3MmMzYkgxc25XTnRDSGZNSXVSM1NEbGYrRDda?=
 =?utf-8?B?Mkh2a3JaR3lPUXgrMThhNFhsejFMbERZVlIrMXhqTDZwYnMrMlh6YUtiN0Qy?=
 =?utf-8?B?WmE4UFNsUHh5YW00STVTVFRWMmJGdHQ3TG5FQVB5a0wyV0d5WTBWVlB2ZDVW?=
 =?utf-8?B?TTFFRHBhT0hvVkhPZFJiOEMxSnhpTitOcjgyMnBOcVREN0VjN09yd3VOT1hO?=
 =?utf-8?Q?ufPe0s3qcV+W04C5+k0YZlYfYpgdIZ9wLA9K67k?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE41EB3656F5D04680B12F9A55941063@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2329.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61989a35-efca-4cff-4ab6-08d8d1951dcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 09:36:05.2072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s2zqUShWnIuqi8ktK9gPLQaciTDSkqnRGHlUh3Rvz5dvxdNiDD+s9D4XG3cXzCchcolb2L4B1MEWDGRiCh6MhWK4/m3hOzufjbrjdxTA/a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTEyIGF0IDE2OjMyICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gRnJpLCBG
ZWIgMTIsIDIwMjEgYXQgMDM6MDY6NDNQTSArMDEwMCwgQmphcm5pIEpvbmFzc29uIHdyb3RlOg0K
PiA+IFRoZSAnY29tYSBtb2RlJyAoY29uZmlndXJhYmxlIHRocm91Z2ggc3cgb3IgaHcpIHByb3Zp
ZGVzIGFuDQo+ID4gb3B0aW9uYWwgZmVhdHVyZSB0aGF0IG1heSBiZSB1c2VkIHRvIGNvbnRyb2wg
d2hlbiB0aGUgUEhZcyBiZWNvbWUNCj4gPiBhY3RpdmUuDQo+ID4gVGhlIHR5cGljYWwgdXNhZ2Ug
aXMgdG8gc3luY2hyb25pemUgdGhlIGxpbmstdXAgdGltZSBhY3Jvc3MNCj4gPiBhbGwgUEhZIGlu
c3RhbmNlcy4gVGhpcyBwYXRjaCByZWxlYXNlcyBjb21hIG1vZGUgaWYgbm90IGRvbmUgYnkNCj4g
PiBoYXJkd2FyZSwNCj4gPiBvdGhlcndpc2UgdGhlIHBoeXMgd2lsbCBub3QgbGluay11cC4NCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGVlbiBIZWdlbHVuZCA8c3RlZW4uaGVnZWx1bmRAbWlj
cm9jaGlwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCamFybmkgSm9uYXNzb24gPGJqYXJuaS5q
b25hc3NvbkBtaWNyb2NoaXAuY29tPg0KPiA+IEZpeGVzOiBlNGY5YmE2NDJmMGIgKCJuZXQ6IHBo
eTogbXNjYzogYWRkIHN1cHBvcnQgZm9yIFZTQzg1MTQNCj4gPiBQSFkuIikNCj4gPiAtLS0NCj4g
PiAgZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjY19tYWluLmMgfCAxMyArKysrKysrKysrKysrDQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L3BoeS9tc2NjL21zY2NfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9w
aHkvbXNjYy9tc2NjX21haW4uYw0KPiA+IGluZGV4IDc1NDZkOWNjM2FiZC4uMDYwMGI1OTI2MThi
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9tc2NjL21zY2NfbWFpbi5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjY19tYWluLmMNCj4gPiBAQCAtMTQxOCw2ICsx
NDE4LDE4IEBAIHN0YXRpYyB2b2lkIHZzYzg1ODRfZ2V0X2Jhc2VfYWRkcihzdHJ1Y3QNCj4gPiBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gICAgICAgdnNjODUzMS0+YWRkciA9IGFkZHI7DQo+ID4g
IH0NCj4gPiANCj4gPiArc3RhdGljIHZvaWQgdnNjODV4eF9jb21hX21vZGVfcmVsZWFzZShzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICt7DQo+ID4gKyAgICAgLyogVGhlIGNvbWEgbW9k
ZSAocGluIG9yIHJlZykgcHJvdmlkZXMgYW4gb3B0aW9uYWwgZmVhdHVyZQ0KPiA+IHRoYXQNCj4g
PiArICAgICAgKiBtYXkgYmUgdXNlZCB0byBjb250cm9sIHdoZW4gdGhlIFBIWXMgYmVjb21lIGFj
dGl2ZS4NCj4gPiArICAgICAgKiBBbHRlcm5hdGl2ZWx5IHRoZSBDT01BX01PREUgcGluIG1heSBi
ZSBjb25uZWN0ZWQgbG93DQo+ID4gKyAgICAgICogc28gdGhhdCB0aGUgUEhZcyBhcmUgZnVsbHkg
YWN0aXZlIG9uY2Ugb3V0IG9mIHJlc2V0Lg0KPiA+ICsgICAgICAqLw0KPiA+ICsgICAgIF9fcGh5
X3dyaXRlKHBoeWRldiwgTVNDQ19FWFRfUEFHRV9BQ0NFU1MsDQo+ID4gTVNDQ19QSFlfUEFHRV9F
WFRFTkRFRF9HUElPKTsNCj4gPiArICAgICBfX3BoeV93cml0ZShwaHlkZXYsIE1TQ0NfUEhZX0dQ
SU9fQ09OVFJPTF8yLCAweDA2MDApOw0KPiA+ICsgICAgIF9fcGh5X3dyaXRlKHBoeWRldiwgTVND
Q19FWFRfUEFHRV9BQ0NFU1MsDQo+ID4gTVNDQ19QSFlfUEFHRV9TVEFOREFSRCk7DQo+IA0KPiBD
YW4geW91IHBsZWFzZSBkbzoNCj4gICAgICAgICBwaHlfd3JpdGVfcGFnZWQocGh5ZGV2LCBNU0ND
X1BIWV9QQUdFX0VYVEVOREVEX0dQSU8sDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIE1TQ0Nf
UEhZX0dQSU9fQ09OVFJPTF8yLCAweDA2MDApOw0KPiANCj4gQW5kIGNhbiB5b3UgcGxlYXNlIHBy
b3ZpZGUgc29tZSBkZWZpbml0aW9ucyBmb3Igd2hhdCAweDA2MDAgaXM/DQo+IE15IHJlZmVyZW5j
ZSBtYW51YWwgc2F5cyB0aGF0Og0KPiANCj4gQml0IDEzOg0KPiBDT01BX01PREUgb3V0cHV0IGVu
YWJsZSAoYWN0aXZlIGxvdykNCj4gQml0IDEyOg0KPiBDT01BX01PREUgb3V0cHV0IGRhdGENCj4g
Qml0IDExOg0KPiBDT01BX01PREUgaW5wdXQgZGF0YQ0KPiBCaXQgMTA6DQo+IFJlc2VydmVkDQo+
IEJpdCA5Og0KPiBUcmktc3RhdGUgZW5hYmxlIGZvciBMRURzDQo+IA0KPiAweDYwMCBpcyBCSVQo
MTApIHwgQklUKDkpLiBCdXQgQklUKDEwKSBpcyByZXNlcnZlZC4gU3VyZSB0aGlzIGlzDQo+IGNv
cnJlY3Q/DQoNCkkgY2FuIHNlZSB0aGlzIGlzIHVuY2xlYXIuICBUaGUgY29kZSBpcyBhY3R1YWx5
IHdyaXRpbmcgemVybyB0byBiaXQgMTINCmFuZCAxMy4gIEJpdCA5IGFuZCAxMCBhcmUgbm90IGlu
dGVyZXN0aW5nIGluIHRoaXMgY29udGV4dC4gIEkgd2lsbA0KY2hhbmdlIGl0IHRvIHVzZSBwaHlf
bW9kaWZ5X3BhZ2VkKCkgYml0IDEyIGFuZCAxMy4NCg0KPiANCj4gPiArfQ0KPiA+ICsNCj4gPiAg
c3RhdGljIGludCB2c2M4NTg0X2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYp
DQo+ID4gIHsNCj4gPiAgICAgICBzdHJ1Y3QgdnNjODUzMV9wcml2YXRlICp2c2M4NTMxID0gcGh5
ZGV2LT5wcml2Ow0KPiA+IEBAIC0yNjEwLDYgKzI2MjIsNyBAQCBzdGF0aWMgaW50IHZzYzg1MTRf
Y29uZmlnX2luaXQoc3RydWN0DQo+ID4gcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICAgICAgICAg
ICAgICAgcmV0ID0gdnNjODUxNF9jb25maWdfaG9zdF9zZXJkZXMocGh5ZGV2KTsNCj4gPiAgICAg
ICAgICAgICAgIGlmIChyZXQpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyOw0K
PiA+ICsgICAgICAgICAgICAgdnNjODV4eF9jb21hX21vZGVfcmVsZWFzZShwaHlkZXYpOw0KPiA+
ICAgICAgIH0NCj4gPiANCj4gPiAgICAgICBwaHlfdW5sb2NrX21kaW9fYnVzKHBoeWRldik7DQo+
ID4gLS0NCj4gPiAyLjE3LjENCj4gPiANCg==
