Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D864063CE5B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiK3Ect (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiK3Ecs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:32:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3585F15A31;
        Tue, 29 Nov 2022 20:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669782766; x=1701318766;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sSrNcEfTJ1IkXOkEpEJ6ZLikWAEieOfi8rmreFFA4yY=;
  b=hT0Vpo9K6E4K+hnALkkT7blDrAahUUyRCPQJbv6aVuqsh860PpK1rWBn
   SNtPuR3dltCkHZlH6+Ptr8o3fRGFjRae98EZGeMDSORMxYbH3D71sl7Xu
   D0cLvXhUy4v+ygVhaZ8aKLv82WzcYo5yoJPReVbZc8bpJUozimVSSN330
   y411CGxqSOuEcxS1Tef89Z+lnvlnv/gH3EW9GL3zBOhiVyRKbYGR/5Vqo
   Wrbr76DA8RRjSwWvNZMuWL/SSK9xPTsKVwx9dy6kzPYXDDKz+4POuYv6A
   XLoVF/pQXynAmAsX72zQCmRGFufTitD7Bj74vLeSP3M4RXUBEPnjIxKTj
   w==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="125740820"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 21:32:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 21:32:42 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 21:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIY45Ib7p1xfT2QjJyx6oBrrJKe5n5rsMsgwKbDmu6Pyj7Ffe8AbE0VXVpX5D5Z95CmO37ZZrFa9jPFmsH/PRV/tceuVb6Oioy3+f+d8mrpKPbohfNOoK8yrVVu4x2XCWIhspaMdgwctPB4Pd1mw/lGqzHRJvwiZFVCpUvXTIXgzCC0EADri02OJfWEzT15vt0VpZlZF9D60955N8SE/VadnDO+o/WkstY6vrb/Ks6ltdLGR0jqh400RZvbyUf3hEFMNHe4/tqXNHum3b78C05tuX1b9T+vvdSi02qO45DtV1PMKCPY5ryBAAr2enHB6wONhyMjd7JImmUsXZQuPFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSrNcEfTJ1IkXOkEpEJ6ZLikWAEieOfi8rmreFFA4yY=;
 b=Srd//QR7S2e9xwQy56clrX7CUu8LhZH4lYa8e1Uy+Nl+iJ/DlOZ0q+YK+dzGS7Z2k7ESWf6hRZD64suecqBpGmgKKGJW2ciJFJRkFe0T5Bdzse3E+WM4ibBtEJ+8QHqC9mZvPbca+1ONaPKNHa0sMXJe1dG1uYxQtiDAubPU3Q9AhHM+CN8Eqv6xE3nz6A4G2apM99tqfN8lobJSR2ny9YH2Eq15sfUsSWYzg/mVzxRFnlMIsHtPpnar8BPMz9PPl1vj28eOohavdNtqFcveZxoj9xJSgHw0zvAVjU3jipgo0Q7AEYGfww5OesIHP0PCibCv6ZbDak8InHBmJ7Y0hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSrNcEfTJ1IkXOkEpEJ6ZLikWAEieOfi8rmreFFA4yY=;
 b=XCvAPbin9pzkIEOSQyC5ZXKB2sVbuLC2vuUUGE5kBlGGHGxZIa7yylZ0GRUTxttrPBmEI0u98JeCBykCbA+XhHxaEyzPg8Qcqv/tWDIiTpUXQ7JN+Pm9Y1F0CABvuuEeBs4eKp6pq6OEQPTWeHPkNFJgr59dWjWpvDzeZaBMOq0=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CH3PR11MB7894.namprd11.prod.outlook.com (2603:10b6:610:12c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.6; Wed, 30 Nov
 2022 04:32:40 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:32:40 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pavan.chebbi@broadcom.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Thread-Topic: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Thread-Index: AQHZAxTePqOJ5uCMbEmr3ypDxG/mcK5VmMOAgAFKogA=
Date:   Wed, 30 Nov 2022 04:32:40 +0000
Message-ID: <b9f4fa71c1fd96fef32010e5bd0076ec4ecc56bb.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-3-arun.ramadoss@microchip.com>
         <CALs4sv3nqNxMXwtdOdXuoS7xTKwXCrba=+s2e=Gq6cdEFNmttg@mail.gmail.com>
In-Reply-To: <CALs4sv3nqNxMXwtdOdXuoS7xTKwXCrba=+s2e=Gq6cdEFNmttg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CH3PR11MB7894:EE_
x-ms-office365-filtering-correlation-id: 07b00f93-edfc-4e1d-45d5-08dad28beaab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g1iv2AamFsE3ooYdUazimUs0hCUb7r9D9FaSY2h8qlFHF6uEjH/11wIggxhkJJIXDsVpqMdTdzveBu1uzPgmbzYOYoZuUOVS+iJRp12hHW9DNL80fp7MRW2NggKAGFFpbtF9Lxvx4y2BuNlKOjq9JT5pTT7aVajRQ7k2rVgJOrmTytrzQH1Mfy2x4ayKgV9Z9bdzLGcYhn8wXaNeDYHszNcaEG+LJYsTjQBfYMYKPw8HoVsK6XyImYMpj1Qb5jII4/fbIO6v49KuEmgkrIc2AL3I3M299UZOpKOvi06BUwrBsd6OlY2WChdQdlUQTdEmvkUr3OZM4KqTJ8p8TCHEgWYhzHKVpl6fkIsutU/WkcLAhPxYXUxVs7GN4UzFGttGnFFLOVGguEZ322gZuyrWVzVcYfW8Wk0aAuIPaa+Njbc8q9czsFcxz5ji8Zyv++qEBDd+AYptiYAO0/MNoR4Q5QPNJ38X5UtNONYVljRFeD5y+Ww1BunWqrDmCiSLwQzJI43wxklVsCdkdkBCQx+iBPKdle7O1P8u63QZ836x7a0PIyKblfBOQFINo+EnYL7Mak5urRqinHAlo3epUbGdH5T3hZVbSFOw5jhyApotw9Vm4YECpsbY2alt9yp6pGZOIRIMx4EX2NSB5OJq9TAlGg4ScnVyLT14Oq5qdPsTO+TcyTDwWnhep0fK9T/lmKKJcyJaSUQTMHPJbZp6Ks0IO4WHspqemQEEXYGuC5shc2c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199015)(6512007)(186003)(26005)(71200400001)(6506007)(53546011)(36756003)(6486002)(2616005)(38070700005)(86362001)(122000001)(83380400001)(38100700002)(478600001)(2906002)(4001150100001)(66446008)(66556008)(4326008)(8676002)(66946007)(64756008)(66476007)(316002)(41300700001)(54906003)(8936002)(76116006)(7416002)(91956017)(5660300002)(6916009)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEhIQURIa1Z3K0NRKzNWQ0U4MDlIMTRTbDhoOVovY016MjMyTzlUYjBwRXMy?=
 =?utf-8?B?ZDBud1k2T2c5bG95c0svYkJyTG9RYVJBTlI5UGJQeGZWL01mcWFoUERjOXli?=
 =?utf-8?B?SGY1cUFKeDhKUjExUjFZVnVXTzF3TWFoVktad3ZDUkFwNEM0Vi9LdzhidmQ3?=
 =?utf-8?B?Y3hzQnczQXY4NVl6MkpzcytTbUI0SFpYZHFmS2l3bGJJL0trV1RzbUJnWXc3?=
 =?utf-8?B?cUQyWVBCQnBpT1VVQjJKck5aWGZDcS95aEdrUlZYcnBDandFQzdhanN0bG1K?=
 =?utf-8?B?MFl5ZzE2dzkreGJnV1JIMnFRNWdaTzZINkdxb2dtQjVKMWZMekdPRXlRNlIv?=
 =?utf-8?B?djV4dzZTbENKdnArdkdmbXdYNHFxOElxRVIxSjFyeDNGSE5vSm4xeUluSGE4?=
 =?utf-8?B?cGNOa2F5NmczREJSaDRrQ1VxWVZRTHoxZFBnNlJxNm9lU1VySENob3FSaDJa?=
 =?utf-8?B?TlRuZWloeTlSb09GSy9NM1R3OFl4dTJjMWlKL09JUU9iZWFEWWROKzlyNTBK?=
 =?utf-8?B?U2NXMDZIMXJVZjlmVXhuWXdHOERSNmt1elZqaElDZ3lIM3VQbGhEWHNIcUVo?=
 =?utf-8?B?YXZEcWU5eVZzZTVDT2VHUlg4UXo3ejhUY2dRK2R3NzlDYi95NnR6anpIUFR1?=
 =?utf-8?B?KzJObW0yVnZ1b2UydjZ2QWEzT3FTUFU1TVFKZnBqVWd3QUlPdm94Z3FkOHVW?=
 =?utf-8?B?QlBTZ1hSWkJucUVIbHkvSkl6UTFKVVNtK3U1SGtDRnFwbDFINjRlR1FYZCtE?=
 =?utf-8?B?QnZQOU41QnNoaG1DSUtjeHBYeXc5UHZJYU5abzRTL0xpZWpNdTRDZHFCMlBk?=
 =?utf-8?B?TFgzbVZNZHpoU245clVrYnphTlZxVnd3UC9YVWkyWXdkTlZseGhnbVR1RnN5?=
 =?utf-8?B?ZDVvYzA3UnZxUVpxcmNCMTlVWVNMME1jTXpzQ0NUOWQzUTdTZGxZTWsva0Yy?=
 =?utf-8?B?Y1JMOEpDQW9tbDhJRDl1ZEZkVENYOUJnZ0MzVEs3NG5iYjlWN1MrNHNaQm5C?=
 =?utf-8?B?NUZDWWRCaU9kNW5ZNWNJNE9kcURpTlpSNjFZWXBQMCs0UGgxSFMzTU5UK1Z4?=
 =?utf-8?B?MFBUYkg0eHpLb2MwVWZGZGhINkp4UnBNdXZFVjkvWGQ2emhLQUFNY2tCVXlv?=
 =?utf-8?B?L3gzUjVidDFmMkZzaktCWllnMlRScDErcXdlUFAwU0dzaGNmdUhDU0crd3B1?=
 =?utf-8?B?YU10QVBvK3IwandZWG1EWFI0UWZRTlZxbjNpd3F5Y0pZRHY0RU54UE9GbWZy?=
 =?utf-8?B?TnpRZDh4NXFkWDRkMHFOQlFVNGRrbDljUG5GclJBQ2tRQ09PcG1hclZzT0h4?=
 =?utf-8?B?ZU02eUQ2MkgvNlA4aVNiajdYR0NQR0VQUC9Xdkh4QW5Lb1pBUThlR3l2TzJ4?=
 =?utf-8?B?UklOSTY0NnNWUDZsd0ZUb1kydGgrMlZZMzlRTXJpQm12K0xOQWplZUVMSkNv?=
 =?utf-8?B?NXB4WkZweWpRdFNnWVpKQVdkRkVVV2l3VDlsYzdwL0p6cHNRRVJSYkllSEEx?=
 =?utf-8?B?dGJ2aGZPY0FnZ0VZMC9lTHdCL2tRbC9WaHl4VElKdWxPSGY5OWNkWHVBQmY4?=
 =?utf-8?B?SU02RUlBeTcvTDI5MEpnTXlIMk9DazVhdlo2TEVzSTlxL0VyQjQrbE05Yytl?=
 =?utf-8?B?bStDWDZhQ00rT0YzUWdLbVQvblA0SktrT0phaHMxNDIxc1BFWlljeFpqN0py?=
 =?utf-8?B?RVFOcUJBT2J3UndtL3NkbCtMcjBPYUQ3NFJiUHU4VHhWeWtoNWNuNEZhM0Ru?=
 =?utf-8?B?Sm82TnhjOS9IKzhBZjg3MkZXY1F3QkhHRmRRN1lVSTJtOEw4SXFMbU9DZFQ1?=
 =?utf-8?B?YXhreThUY0xJU3gvSTNWMDEzckdqMFdTMTlQL3phVlRkdEgwQWljSzNja0o3?=
 =?utf-8?B?YVYvSFZBNktHRnBMckh5Qk1VQThCUEJLQ01hcmo3b3lnVGNzUGVDVGtLSUdv?=
 =?utf-8?B?bWkzSi9XNVNhMHhYWTBId2hSSVo2TE9hdmZDYllweWsrV1ZraGZjWkhYQ0M2?=
 =?utf-8?B?NlpmZ05QbS82T1RycGpHb0xIeFdhWTBFdFhob095OVkvL3IvUlBVM2xVanNX?=
 =?utf-8?B?c2M5TVBxaS9RV29FZ2JjUTlsU04yYjZlc0h5TlByaXlnRitXUVVDRU96QzBG?=
 =?utf-8?B?RnRqVFI5NVlRWVUybGdKWFRVQ2NaaVBmY0xzOGdINWp4OWQ2SzV4TitkbGJH?=
 =?utf-8?Q?vDfKZFw0sQ2GVFQKgTs/LmA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90229D47F19FB74CB60A2F11D3B540C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b00f93-edfc-4e1d-45d5-08dad28beaab
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 04:32:40.5414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqNxsz8nAsUhqp9DoyayU7o3bOSLqu5ruLTFVeko/RektfHDp50QtJdaL3+3ZT4XHoBYHVxhJpIT+vnDhTAIV7xkp/0Lo3uzTTCZO+qL/NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7894
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF2YW4sDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQpPbiBUdWUsIDIwMjItMTEtMjkg
YXQgMTQ6MTkgKzA1MzAsIFBhdmFuIENoZWJiaSB3cm90ZToNCj4gT24gTW9uLCBOb3YgMjgsIDIw
MjIgYXQgNDowMyBQTSBBcnVuIFJhbWFkb3NzDQo+IDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5j
b20+IHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IENocmlzdGlhbiBFZ2dlcnMgPGNlZ2dlcnNAYXJy
aS5kZT4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIGFkZHMgdGhlIHJvdXRpbmUgZm9yIGdldF90c19p
bmZvLCBod3N0YW1wX2dldCwgc2V0LiBUaGlzDQo+ID4gZW5hYmxlcw0KPiA+IHRoZSBQVFAgc3Vw
cG9ydCB0b3dhcmRzIHVzZXJzcGFjZSBhcHBsaWNhdGlvbnMgc3VjaCBhcyBsaW51eHB0cC4NCj4g
PiBUeCB0aW1lc3RhbXBpbmcgY2FuIGJlIGVuYWJsZWQgcGVyIHBvcnQgYW5kIFJ4IHRpbWVzdGFt
cGluZyBlbmFibGVkDQo+ID4gZ2xvYmFsbHkuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ2hy
aXN0aWFuIEVnZ2VycyA8Y2VnZ2Vyc0BhcnJpLmRlPg0KPiA+IENvLWRldmVsb3BlZC1ieTogQXJ1
biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiANCj4g
PiAtLS0NCj4gPiBSRkMgdjIgLT4gUGF0Y2ggdjENCj4gPiAtIG1vdmVkIHRhZ2dlciBzZXQgYW5k
IGdldCBmdW5jdGlvbiB0byBzZXBhcmF0ZSBwYXRjaA0KPiA+IC0gUmVtb3ZlZCB1bm5lY2Vzc2Fy
eSBjb21tZW50cw0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uYyB8ICAyICsNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9u
LmggfCAgNCArKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9wdHAuYyAgICB8
IDc3DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKy0NCj4gPiAgZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3pfcHRwLmggICAgfCAxNCArKysrKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQs
IDk1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gYi9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGluZGV4IDJkMDljZDE0MWRiNi4uN2I4
NWIyNTgyNzBjIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6
X2NvbW1vbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9u
LmMNCj4gPiBAQCAtMjg3Myw2ICsyODczLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBkc2Ffc3dp
dGNoX29wcw0KPiA+IGtzel9zd2l0Y2hfb3BzID0gew0KPiA+ICAgICAgICAgLnBvcnRfY2hhbmdl
X210dSAgICAgICAgPSBrc3pfY2hhbmdlX210dSwNCj4gPiAgICAgICAgIC5wb3J0X21heF9tdHUg
ICAgICAgICAgID0ga3N6X21heF9tdHUsDQo+ID4gICAgICAgICAuZ2V0X3RzX2luZm8gICAgICAg
ICAgICA9IGtzel9nZXRfdHNfaW5mbywNCj4gPiArICAgICAgIC5wb3J0X2h3dHN0YW1wX2dldCAg
ICAgID0ga3N6X2h3dHN0YW1wX2dldCwNCj4gPiArICAgICAgIC5wb3J0X2h3dHN0YW1wX3NldCAg
ICAgID0ga3N6X2h3dHN0YW1wX3NldCwNCj4gPiAgfTsNCj4gPiANCj4gPiAgc3RydWN0IGtzel9k
ZXZpY2UgKmtzel9zd2l0Y2hfYWxsb2Moc3RydWN0IGRldmljZSAqYmFzZSwgdm9pZA0KPiA+ICpw
cml2KQ0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uaA0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiBp
bmRleCA1YTZiZmQ0MmM2ZjkuLmNkMjBmMzlhNTY1ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gQEAgLTEwMyw2ICsxMDMsMTAgQEAgc3RydWN0
IGtzel9wb3J0IHsNCj4gPiAgICAgICAgIHN0cnVjdCBrc3pfZGV2aWNlICprc3pfZGV2Ow0KPiA+
ICAgICAgICAgc3RydWN0IGtzel9pcnEgcGlycTsNCj4gPiAgICAgICAgIHU4IG51bTsNCj4gPiAr
I2lmIElTX0VOQUJMRUQoQ09ORklHX05FVF9EU0FfTUlDUk9DSElQX0tTWl9QVFApDQo+ID4gKyAg
ICAgICB1OCBod3RzX3R4X2VuOw0KPiA+ICsgICAgICAgYm9vbCBod3RzX3J4X2VuOw0KPiANCj4g
SSBzZWUgdGhhdCB0aGUgaHd0c19yeF9lbiBnZXRzIHJlbW92ZWQgaW4gdGhlIGxhdGVyIHBhdGNo
LiBJbnN0ZWFkDQo+IHlvdQ0KPiBjb3VsZCBhZGQgcnggZmlsdGVycyBzdXBwb3J0IG9ubHkgbGF0
ZXIgd2hlbiB5b3UgaGF2ZSB0aGUgZmluYWwgY29kZQ0KPiBpbiBwbGFjZS4NCg0KSW4gUkZDIHYy
LCB0aGlzIHBhdGNoIDIgYW5kIG5leHQgcGF0Y2ggMyBhcmUgaW4gc2luZ2xlIHBhdGNoLiBUaGVy
ZSBhcmUNCnR3byBzaW1wbGUgcmVhc29ucywgSSBoYWQgc3BsaXR0ZWQgdGhlbSB0d28uIE9uZSBp
cyB0byBoYXZlIGxvZ2ljYWwNCmNvbW1pdCBhbmQgZWFzZSBvZiBjb2RlIHJldmlldy4gUGF0Y2gg
MiB3aWxsIGFkZCB0aGUgaHd0c3RhbXBfc2V0IGFuZA0KZ2V0IGRzYSBob29rcyBhbmQgcGF0Y2gg
MyB0byBtZWNoYW5pc20gdG8gY29vcmRpbmF0ZSB3aXRoIHRoZSB0YWdfa3N6LmMNCnRvIGFkZCBh
ZGRpdGlvbmFsIDQgYnl0ZXMgaW4gdGFpbCB0YWcgd2hlbiBQVFAgaXMgZW5hYmxlZCBiYXNlZCBv
bg0KdGFnZ2VyX2RhdGEuDQpTZWNvbmQgcmVhc29uIHRvIHNwbGl0IGlzIHRvIGhhdmUgcGF0Y2gg
YXV0aG9yc2hpcC4gSSBoYWQgdXNlZCB0aGUNCkNocmlzdGlhbiBFZ2dlcnMgcGF0Y2ggYW5kIGV4
dGVuZGluZyBzdXBwb3J0IGZvciBMQU45Mzd4LiBJbiB0aGUNCmluaXRpYWwgc2VyaWVzLCBpdCBo
YXMgZHNhX3BvcnQtPnByaXYgdmFyaWFibGUgdG8gc3RvcmUgdGhlDQpwdHBfc2hhcmVkX2RhdGEu
IE5vdyBwcml2IHZhcmlhYmxlIGlzIHJlbW92ZWQgZnJvbSBkc2FfcG9ydCBzbyBJIHVzZWQNCnRh
Z2dlcl9kYXRhIGJhc2VkIG9uIHNqYTExMDUgaW1wbGVtZW50YXRpb24uIEFzIGl0IGlzIGRpZmZl
cmVudCBmcm9tDQppbnRpYWwgcGF0Y2ggc2VyaWVzLCBtb3ZlZCB0byBzZXBhcmF0ZSBwYXRjaC4g
DQoNCj4gDQo+ID4gKyNlbmRpZg0KPiA+ICB9Ow0KPiA+IA0KPiA+ICANCj4gPiANCj4gPiANCj4g
PiANCj4gPiAgI2VuZGlmDQo+ID4gLS0NCj4gPiAyLjM2LjENCj4gPiANCg==
