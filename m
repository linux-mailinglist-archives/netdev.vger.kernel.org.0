Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE02649BCC
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiLLKOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLLKN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:13:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F22E6;
        Mon, 12 Dec 2022 02:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670840034; x=1702376034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hnKTiBLAYp4K6KoRKrMr1ql7gOQXpoHWLs22PTOd/NE=;
  b=U94xs5dVb1GBWW20eY1oXC0GHI9UBpCKBFexmTZ45JTZZzhJgyq6EtSK
   HP5ZMk1QwhUkO1ClGfAJFnjqIYqsxLjVvTzRMUV104nNnYrj2CbmLBugJ
   Qs6KQix4pgtdN4T9I+EELD5c3Bym+dwtdRlpjGm1mArc5ddtb7xXc0lo7
   eNFuWBSnX9onH+C3PuxIGIe7BzzqRE4aiXcOmAI/kC6W+s+IfeS25hZNp
   JRLNWocAasLVBZwt8qAHS45AXWGFcKFcQzEozapn1mUjWoOndzxKxjUEd
   0PaUiP+B3yE/XR76TLfrjl1JQaAUNl5rvM5u2mBfjzHEFiNYqN5pVa9ao
   g==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="192681918"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 03:13:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 03:13:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 03:13:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAnomOlXHvgUDHc6VmiK5q6SurY3nIGmPm+DrOA0RR7xQYNIQnE92y5eTpDFsgvQY2GdiKXG9RpgvA9CgI69n8Fs8eomjso4iIka2E9IZ6En0r69Qwjtbp6cCgQsEnVwt0uYlWZdMLA4gswJgPw55EVZyLWD6T7LQLSwenmk/wWwVkH+B1lQq19mSFgN/508x2rgsfI1Q+cHkd+blFSfF22EZOlfh/rZTyU7Vs2kN8wuRq/OEItgiP0KmYPfCL0nCil2CNq6DGq7PzqvVOwhGvHIK9OrqBWgsSWWXGeh+EaataaXilAcX6Lw62MxfJ883Q3k6KrXByZrfq/7MDuuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnKTiBLAYp4K6KoRKrMr1ql7gOQXpoHWLs22PTOd/NE=;
 b=JH5PvqfCqTTqZE9DqBNbvcnPtK+h6g+/35DWwi1295baXz8+oQeEkoSGEmc82/fuvYFuOmeImYZT4MRNz20qA63SluDBsSJNTc/RxRVUnNkKXr6rz1y3L1hAuTj7uhuIbOnK+2R79omOCTIVEZs37sWraoVFSpy5UJ3pdJg4W1z0KibSUy30oZseJbi/1sZrJycKOqcrSFg6/reuGQrA5RNclIZ6urCGjTLoLOVg4/gBnh+qgiyMDVg/3TT6Pr+PZJw/nM+LcBAX5cJhsjdGzhipuLz6pFy6MHRcYZkR5q0EzKHrya4Khi9dH85/9kvPBCLEmcKOEUj8x0jsopQZKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnKTiBLAYp4K6KoRKrMr1ql7gOQXpoHWLs22PTOd/NE=;
 b=fheZCeMUnXSjvIr0BF0SkvhL9WYLYFoXBKgzOTvNIzsmIvvtDVOMsWLpZ6Jz0p+C1zuXh1Lol9F6YM2LzRgY3JLBuVuOVxRDU0J2KjGZI3jFlhPAC5Tyvj3TxE31EVAZA2ahe6SK33biBelSb3XX3XqnK9QnaXg6rlfSk3F/MPo=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SJ2PR11MB7574.namprd11.prod.outlook.com (2603:10b6:a03:4ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 10:13:47 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 10:13:47 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ceggers@arri.de>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v3 05/13] net: dsa: microchip: ptp: enable
 interrupt for timestamping
Thread-Topic: [Patch net-next v3 05/13] net: dsa: microchip: ptp: enable
 interrupt for timestamping
Thread-Index: AQHZC5+HGzbT3vRDMEGHJOw5v+wZV65l9NqAgAQYvIA=
Date:   Mon, 12 Dec 2022 10:13:46 +0000
Message-ID: <1df64e8b88e7cef0d9ee34bfa6deafe4801e82c6.camel@microchip.com>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
         <20221209072437.18373-6-arun.ramadoss@microchip.com>
         <5904188.lOV4Wx5bFT@n95hx1g2>
In-Reply-To: <5904188.lOV4Wx5bFT@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SJ2PR11MB7574:EE_
x-ms-office365-filtering-correlation-id: fc4b5bb6-5962-44c2-3bf4-08dadc298e97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uvn27rCVfPBt/1v+iouhxHdt+9cWYuBDIBDaP/XF6wwW8MfKVWwIn9fUTMThEasQnztor3ctdAIqj8vcHMR3TyWXCpNdzy6ygRqaNnCqLpRrF11X39nFlid0JrlDH0OPB18HgkbzYdMZN5Hrj/WD0Y2xY61f7/Yd4wn2ZaPuCVqTd/cYABespdysUUFT1FwAUmuJYWPSi3ltLgR6V+BoGodRI1wdlwLtMqmkymjUGerdg7zoUNk8PhR/SwIpnkiQDQeq0Y6aXUbSA+f6lVSaKm0iI9Crd2YnAdi+EB90nu2w/Pjb8I3nFaZFNOdosMpgP+ZiFC+scdHAxVjuAPIDvYfQsei2UhXds6YFS0g1AV9wKQVWXuPAqbpj+1iW1gQwOk8/HF6fmq1Y2RnL5j0GZ/QvM6fqGnilnvIt3M+kbHfCxkP8AYwmCSwdDU688zvbTVbD3zIRlV/jhG73zBIUI85GGPaxf0sEZ3EgwW/u4WeoiEea36yeZPYfTfIWtG+DXqm6AaXaq/gqXXHOPoYqhWKTjGM+sJa6uoTaq9Hc6UzLXYVK0VymzPfNJN8SWJLQeBgQZVKQwz4Z3VPQrL1/ZthDnTadB7G7vZQ5c/qZr/WztEy4QCJNSnCd2xNYCWtWSJ3xJmf5ukkBlo+oHPloSbFikvy/Y8CGsWRCnzf4NYUpuuttXodAWnRCEtyfD0kVJ0SljuoookBn2thIPXz0QH/oj4aRvQgBelLTUak3iE7C7xo8X4LaX2DcQatzed0o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(83380400001)(6486002)(966005)(478600001)(71200400001)(38070700005)(86362001)(36756003)(26005)(122000001)(38100700002)(2616005)(186003)(5660300002)(4326008)(91956017)(7416002)(66476007)(64756008)(66556008)(66946007)(8676002)(6506007)(6512007)(54906003)(76116006)(316002)(110136005)(41300700001)(2906002)(8936002)(66446008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0lCVGUrRDAzZTI5Z1lsN2hyK0ozTURXT3ozbUVYOXBpc1liNmh0VEhmUVZF?=
 =?utf-8?B?T0NtaHl1UzQrR2JxRWhTS21FTHVKQ3UwRjE0K3gzVWNFZWd5Sk1Ic1VEZkNB?=
 =?utf-8?B?WVoyWFdmS1ZaWTFXT3pPNHF1ZFA1T0RiM3B6cFZIUGJmdDJOWW9malVsc3R3?=
 =?utf-8?B?OFNybXJMYkNzRk9FOFk3eE1mdk1ZczQ1VklKTmF6RGNDaUY1NFFORVdRSTU2?=
 =?utf-8?B?S3FzSTV4bUREbVlwR1pMaFNNV3pOeWxFZ2ZmZFg0cjZBQXBlaVpUTFNTd0tP?=
 =?utf-8?B?K3lLa2FhN3g3aGlGRlFUV3BqRDd4ekhkVHdnS2FLeEVKaGFmaE9BTzQreUQv?=
 =?utf-8?B?Z1VTZ0xSY1NSTEVjQ2tSd0tXUWhGcDkxbjNrTlhiMFh4REtCdEtXQi9ySlgy?=
 =?utf-8?B?eE1Wc0V2b1ZJdEVuNjlGWWhWZmM1cnExSmc3SUw5dkkzRFJTVk9lUnlISm82?=
 =?utf-8?B?WktiaWNObHdtRnlSaFcyMmphMzZtS2s5Uk12RERXWDZOTDdHejRBUEZJWDIv?=
 =?utf-8?B?TUpOVnVHaUxiRVFYYU4walZQVFg2R0ZYN1RicUFjZHZmQ0FNbFlVdmswNVdY?=
 =?utf-8?B?YWF6YWY1ZDRiSVZHTkVYWG4yc09POEZsTHpEWm0ySC92YzVzdjhZQTVsVldP?=
 =?utf-8?B?NS9zem83K0tkd3ZPZ2JXNzU4K0hTcFUzTGljaFZObytpeFVNU2Y3L1gwVTNM?=
 =?utf-8?B?UVhIMG9oT2Yybk5xTzFyZ1c0V0VlSXJmUkJCa3MyQjc3a01oOTNYRVVxSC9K?=
 =?utf-8?B?R3hZMVkyOE5ramZLaW51bjBOb2pFeFBTWUdhdEhGSS81M0hSL2hCemZ0Q3U2?=
 =?utf-8?B?QkFmeEtPSE8zaHM0SkdBNG1jNlM4UzlPeWdTbmJLWDl5bW44VGNTSUQrWm8r?=
 =?utf-8?B?TkR2RFhmSlRzNDZsMTZVdi9BMVJmT2RoRXRDdW1yVXg2WHdXakxRdmJ1TXQv?=
 =?utf-8?B?cWxUT3kwZ2QvTitHS3VGdzJiWlNFNkRTMnZVNUhERjRJNmN6NE5WOXM2Qmh1?=
 =?utf-8?B?amFQbzVsai9qa0dycHR2L1VWc2FueUxDWTRxRWZERStkY3I3MVRrVmdxaXh4?=
 =?utf-8?B?VmdXcjc2UUt4YVVUMkJjZW9nY0tmZUUvaXNidG9ZdWlsbHlWMFpkakRVZEdo?=
 =?utf-8?B?WkNTb3ExaTRwdThFK3YyV0VEUTJhcGVnU0c3YWRZT2UybEd6QmdWUXVFc0Q1?=
 =?utf-8?B?a0NlZkwwejJNeU5TQWI4eTFUMURoa3pWb04wVFROQ0N4WGJkT1BEVEljK0hO?=
 =?utf-8?B?QWdzcnAvM2dURmVzUFRiYWNSWVhIdGh2VUFWRnBUUG42OUpNSWdOcVlxeU1a?=
 =?utf-8?B?ajJxTFBUQmYvaEZyTS9kTFVXdFNmOUNzWXlFdkM0bGZ6QlBQdXVydmtnT2F1?=
 =?utf-8?B?R1ljaGpoTmxEQ0NsS3BUb0p2OFFwcnA1Vkd2L1pDakE3cCs3d3M4SUc5c0NT?=
 =?utf-8?B?bXdUMTEzb0R1cVpLR09Nb1JybmpnSVplcW5zWTlLUkFXSWtIMzdTYVluMHV0?=
 =?utf-8?B?aVJaTjA0ZnRhR1hNL3Y1WXVBRlk3M09TeHVUOVdMNzRKbS9xcWpsVWhFeUsy?=
 =?utf-8?B?V0F5OEhEYUpYTVhtdCt6YUpHdXBRdExXUHFzM3dEdUNJY2wycGdMREcxTG14?=
 =?utf-8?B?KzZreVNhSmpBMjJ4Z0oxWFpuenYvTTc2UE84VzlXQTU2ZXlwMmZkTkFrZkpH?=
 =?utf-8?B?NkQ5TFVkT0NWdHFWTVovb01NZy9LSEpyV3NqZnk1SDlka0cvZ0VScVFUYzIy?=
 =?utf-8?B?MWQ3cW1uS0dCVWtSOXlkVDBvZDgxWmN1RFZ6ZXVUWEZqMlpZNlZFdGhXMUFX?=
 =?utf-8?B?RkFvclI5Q0hGdU1iY3RrbjRCalJ1UU8yTm9mZ3hPR0tVakpaVW1VN1BQVG5I?=
 =?utf-8?B?Y1pUTkczTHdYNElxbThLUytXajRHVTRQTkpTWnF5R0l6elhjTzNPYlozOWgw?=
 =?utf-8?B?dXpVdHJaZDBYQ2xRZkM3cHZrYit0ZlYyTi9PZXlYOGkrWTVDblpFVTBVSVdr?=
 =?utf-8?B?dE80ZW1hejYzS2xkOTVZRTlFL3R4Qk1iajdIODhBVlVDemdiREl3L0Z1MDJD?=
 =?utf-8?B?M0pCcWppY01lWkhPV0JWTUVTZGdZekxOK1dBcjVHc3F3cUR6VUFkTlBuUkhI?=
 =?utf-8?B?enpOelFsNUdDNWZoclh4ZDROaXgxNU1RSEQ2VmxtN2lxdHNKdHBlQ1NXd05x?=
 =?utf-8?Q?4M1uLmIrRbG7p57Hx4o7OKk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EA3CD691C6CA043A555D2EB72789E34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4b5bb6-5962-44c2-3bf4-08dadc298e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 10:13:46.9923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zqvXYCn9KFyQJWWi7fWFsSyTptMMw3FrslMjS2Ugm2LNf8QyIz51Wttujv21ZwpyzTyAmuV/J09eJJ+evcnki4cydqOz+95KG8lmhE5uxqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7574
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2hyaXN0aWFuLA0KVGhhbmtzIGZvciB0aGUgY29tbWVudC4NCg0KT24gRnJpLCAyMDIyLTEy
LTA5IGF0IDIwOjQwICswMTAwLCBDaHJpc3RpYW4gRWdnZXJzIHdyb3RlOg0KPiBFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0K
PiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpIEFydW4sDQo+IA0KPiBPbiBGcmlk
YXksIDkgRGVjZW1iZXIgMjAyMiwgMDg6MjQ6MjkgQ0VULCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0K
PiA+IFBUUCBJbnRlcnJ1cHQgbWFzayBhbmQgc3RhdHVzIHJlZ2lzdGVyIGRpZmZlciBmcm9tIHRo
ZSBnbG9iYWwgYW5kDQo+ID4gcG9ydA0KPiA+IGludGVycnVwdCBtZWNoYW5pc20gYnkgdHdvIG1l
dGhvZHMuIE9uZSBpcyB0aGF0IGZvciBnbG9iYWwvcG9ydA0KPiA+IGludGVycnVwdCBlbmFibGlu
ZyB3ZSBoYXZlIHRvIGNsZWFyIHRoZSBiaXQgYnV0IGZvciBwdHAgaW50ZXJydXB0DQo+ID4gd2UN
Cj4gPiBoYXZlIHRvIHNldCB0aGUgYml0LiBBbmQgb3RoZXIgaXMgYml0MTI6MCBpcyByZXNlcnZl
ZCBpbiBwdHANCj4gPiBpbnRlcnJ1cHQNCj4gPiByZWdpc3RlcnMuIFRoaXMgZm9yY2VkIHRvIG5v
dCB1c2UgdGhlIGdlbmVyaWMgaW1wbGVtZW50YXRpb24gb2YNCj4gPiBnbG9iYWwvcG9ydCBpbnRl
cnJ1cHQgbWV0aG9kIHJvdXRpbmUuIFRoaXMgcGF0Y2ggaW1wbGVtZW50IHRoZSBwdHANCj4gPiBp
bnRlcnJ1cHQgbWVjaGFuaXNtIHRvIHJlYWQgdGhlIHRpbWVzdGFtcCByZWdpc3RlciBmb3Igc3lu
YywNCj4gPiBwZGVsYXlfcmVxDQo+ID4gYW5kIHBkZWxheV9yZXNwLg0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4g
PiANCj4gPiArDQo+ID4gKyAgICAgICAgICAgICByZXQgPSByZXF1ZXN0X3RocmVhZGVkX2lycShw
dHBtc2dfaXJxLT5pcnFfbnVtLCBOVUxMLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAga3N6X3B0cF9tc2dfdGhyZWFkX2ZuLA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgSVJRRl9PTkVTSE9UIHwNCj4gPiBJUlFGX1RSSUdH
RVJfRkFMTElORywNCj4gDQo+IEkgYXNzdW1lIHRoYXQgSVJRRl9UUklHR0VSX0ZBTExJTkcgaXMg
bm90IHJlcXVpcmVkIGhlcmUgYXMgbmVzdGVkDQo+IGludGVycnVwdHMgYXJlIGZpcmVkIGJ5DQo+
IHNvZnR3YXJlICh3aXRoaW5nIGhhdmluZyBhbiBlZGdlIC8gYSBsZXZlbCkuICBBZGRpdGlvbmFs
bHkgSSBoYWQgdG8NCj4gcmVtb3ZlIGFsbCBleGlzdGluZw0KPiBvY2N1cnJlbmNlcyBvZiB0aGlz
IGZsYWcgaW4ga3N6X2NvbW1vbi5jIGluIG9yZGVyIHRvIHJpZCBvZg0KPiBwZXJzaXN0ZW50ICJ0
aW1lZCBvdXQgd2hpbGUNCj4gcG9sbGluZyBmb3IgdHggdGltZXN0YW1wIiBtZXNzYWdlcyB3aGlj
aCBhcHBlYXJlZCByYW5kb21seSBhZnRlciBzb21lDQo+IHRpbWUgb2Ygb3BlcmF0aW9uLg0KPiBJ
IHRoaW5rIHRoYXQgb24gaS5NWDYgSSBuZWVkIHRvIHVzZSBsZXZlbCB0cmlnZ2VyZWQgaW50ZXJy
dXB0cw0KPiBpbnN0ZWFkIG9mIGVkZ2UgdHJpZ2dlcmVkDQo+IG9uZXMuICBBZGRpdGlvbmFsbHkg
SSB0aGluayB0aGF0IHN1Y2ggZmxhZ3Mgc2hvdWxkIGJlIHNldCBpbiB0aGUNCj4gZGV2aWNlIHRy
ZWUgaW5zdGVhZCBvZg0KPiB0aGUgZHJpdmVyOg0KPiANCj4gaHR0cHM6Ly9zdGFja292ZXJmbG93
LmNvbS9hLzQwMDUxMTkxDQoNCkkgd2lsbCByZW1vdmUgSVJRRl9UUklHR0VSX0ZBTExJTkcgZnJv
bSB0aGUga3N6X3B0cC5jIGluIG5leHQgcGF0Y2gNCnZlcnNpb24uIFRvIHJlbW92ZSB0aGUgZmxh
ZyBpbiBrc3pfY29tbW9uLmMsIEkgd2lsbCBzZW5kIGJ1ZyBmaXggcGF0Y2gNCnNlcGFyYXRlbHku
DQoNCj4gDQo+IA0KPiA+ICsgICAgICAgICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgZ290byBvdXQ7DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICByZXR1cm4g
MDsNCj4gPiArDQo+ID4gK291dDoNCj4gPiArICAgICB3aGlsZSAobi0tKQ0KPiA+ICsgICAgICAg
ICAgICAgaXJxX2Rpc3Bvc2VfbWFwcGluZyhwb3J0LT5wdHBtc2dfaXJxW25dLmlycV9udW0pOw0K
PiA+ICsNCj4gPiArICAgICByZXR1cm4gcmV0Ow0KPiA+ICt9DQo+ID4gDQo+ID4gDQo+IA0KPiAN
Cj4gDQo+IA0K
