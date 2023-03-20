Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D186C0EA5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCTKWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCTKVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:21:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C0C126D1;
        Mon, 20 Mar 2023 03:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679307672; x=1710843672;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ptgEEDnEf7sjIU2+4VSiuwlR9WoohHPih28INcG26Ys=;
  b=IlSurYH3qGTCtaVU8zHFT5KV5yvGTNsN3WzHKXXF0bIb1BmCfhqG5hzq
   31JwfYXzsEzKkW+VT0M1V+q55WvjlW7cYc7M8sabhBFXDeiUwyJgm6E9A
   O/PGVO+XtDFDTzVNslfkvofedLDyKfWU87HRXG49s7WFGkJ444WKnBXVQ
   Ry8kbIFqv398rmeGBWynaUdEE3d3p6xL9DSm8+dEavJz9EjhB81p5GkZB
   cAw6XG2Kqf1758wlRXjeGSIDdq34UezgaeICJ/vDEdsJCpVGgGeYgnddf
   S3+gdNzmbsIJYcf2M7jr3aym3/HvV9b4VGDYqwrfyTQHTvGvP1CwI+oAN
   w==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="scan'208";a="217071513"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 03:21:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 03:21:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 03:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ee3fbfF6aF/gRdsyEDKKLciSNLoGAiiZ66FJzDyHG9Nw30WR9wzphFfnm+dpxpzDeNVKezuSYjb1EM7Fuvx+z0tqBJDJY5VqScEOVSBLgNOiW0J1ruYOdT/lQO8zelVXtucXdhoNdcYQkaA5lv3VaZvSPF3fUEKW+cVhKhuDdoSWVMUrnxL+QUXURiUDeRHhifH4wXxhiYHJ0sVTwq4T9hOtMlGSm6xJH7tzVnoumpcS2Wg7M4j58SdDMCHAciR5lM+6NegYGX4up1YjrM4zQ9M2WuK+UyFqy6dBH14KFhIsWzTPTNcEW5Spm2lUe4TxZ0oqTB6ghDLxsMoUfNiM9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptgEEDnEf7sjIU2+4VSiuwlR9WoohHPih28INcG26Ys=;
 b=FpqQKlytRM80qmMrY5f2WfcAdAQXSanMJ/g0RTSlcZsBCfJp6OU+mcxFTYo3YtjyMuBlAdBQD1eveBUuYj+eLZCLPRHaR41Pt4THnVaRHq2YWIeTn/oep3ymkp/HYF8VaMepBz+Tj07qvUNLokz/3/GvvIXIpLoSYSasNJiuTT37oNZVwWUr0Pc4amWCkneroonaUz5QXvuW1Px7oRgXmFcFBzAfogmD5JpIaYIf8sjNhDgPYkSOijaH5h/IEIzXqq9UjS4+bLCsY+FO4mWSAgtB649llm8cubmMoeZsPXlg52aQaeMvjxuZ3XQxc28oq9zt1/cQtiu7dCtY6cX/Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptgEEDnEf7sjIU2+4VSiuwlR9WoohHPih28INcG26Ys=;
 b=ZtaW5qwBvjXkZ4yqlE/iqkUG2XBdZs76tbk0XFMO/fBisut6vG9ajo5emIpbaULZVdVhS71M66ObAlFcmwEKwvIvqrEnKdqiREH2MxDD5b2reuBxoORqzaRwmc0gk6l3kDZ3ff/p8X7eXSVpqFjNpbXUFQ9UYuDjxetjPEsnVlw=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 PH8PR11MB8259.namprd11.prod.outlook.com (2603:10b6:510:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 10:21:08 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 10:21:07 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <peter_hong@fintek.com.tw>, <wg@grandegger.com>,
        <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mailhol.vincent@wanadoo.fr>,
        <frank.jungclaus@esd.eu>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH] can: usb: f81604: add Fintek F81604 support
Thread-Topic: [PATCH] can: usb: f81604: add Fintek F81604 support
Thread-Index: AQHZWL+KXCc33Xm+FUG9YEYYnE7ChK8Ded6A
Date:   Mon, 20 Mar 2023 10:21:07 +0000
Message-ID: <CRB4VW859JPC.253TLOWY0XT6S@den-dk-m31857>
References: <20230317093352.3979-1-peter_hong@fintek.com.tw>
In-Reply-To: <20230317093352.3979-1-peter_hong@fintek.com.tw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|PH8PR11MB8259:EE_
x-ms-office365-filtering-correlation-id: 756393fc-8077-42d4-1925-08db292cd1df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62Lg91s1opoXE/PpTrpfwB0ZmbcWurnDesuq8/6ucekeonU+Eg2+SB8KoiG1LeEZ8jP8MGm4+PFblJHhziWqQpu+kW1PI2mQYkiArmu7q42j5eKWIl462TsgLKt/n+kH4IM2PlOvjXZP2ZkQj0K9EYvHT0D2pgs4Of4L8QqOTm/pFyPcoO83dmXD4DJ/SGd0MOi105DOqJWYzZy/gq6jFYwvB3GtXSExcOKzXH311n7gwENMXfehenY9K2NKiLqf5hgR+KT/N57GpzNb/yLNPU9uhZ5JaUnE2YqWps3yjAoEgDc/SO/VH2s4WFZWMG/lWBP16QhInOqBcEqOLz02lu0psPSQw90SzsiZ0Ti3m5leKarfYNIoloD+p3ErsD++hH0cUyLHfcunmqQqweD/i3bz9eggD0jbmBqNDLiJamDoTRl2sYpVv/ZIGoHrYvXD9D3DqyyIVS31fG9tr9UBgDzdajYVEZk05KgafYSqFMtkzA8OOQs5iXru/bNO/6mf7kJs4uWIhd+gTvrY9u2lrk0SYHUe7Q9vyya19JkuS2hsxZaKtkaqwkv2t8fCNCDyPdoW/bGZH46Da7IL4nUxTOqV9jH9+SUhKGsYABTSJQF2flV7LiyO3Jshi+wXlCWYNrRDKB2zL442QlEQNG/jrcztmW+Qz6fsicBs+i7DP5B4f7ca66w3F7uwWZfkSnP+BPsDdFcYVRuvaQEc573T1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199018)(54906003)(110136005)(316002)(86362001)(33716001)(83380400001)(9686003)(38100700002)(122000001)(38070700005)(966005)(71200400001)(478600001)(6486002)(33656002)(26005)(186003)(6512007)(6506007)(2906002)(41300700001)(8936002)(7416002)(5660300002)(66446008)(66556008)(8676002)(66476007)(66946007)(64756008)(91956017)(76116006)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxQd3VrMnQ2b2c4VFplNjJnVmhLZnp5MU5sa0IxMVdmM1EwTi9UWjFSTUxn?=
 =?utf-8?B?Y2ZTRXYxSm5zVnhVNGhSS3NIOG9TVDIxN0FGYWc4OGlIaUQweU94TlFlNHFJ?=
 =?utf-8?B?QUpXamxvQ2NnVThESDhHY2dEdGlVZmdUbW1OcDlmb1hyd1lFMzVtaHBzYXpp?=
 =?utf-8?B?NE0yV1RGVUZPSUU4a2V2dXhDQUZrbk5NM01GODNLL2gwbW1ZV3JsNGtmaGlU?=
 =?utf-8?B?dlJJSnNzLzRwTkRjZktPeGlwZ0hWWTJKdHgxSU56ZzFLajNRVXNMNGQrVUda?=
 =?utf-8?B?NENhOFhJcEk4MURFOUJkVUlsRzRQTWsyWm1qVEpDdFRycktJRGw5bFZmb2VM?=
 =?utf-8?B?SjFQdFBRODBVbG51SnJrQkRKOUdPcXdHaXE4ZnFuaVF0YWx2QnI5UE1aZXhl?=
 =?utf-8?B?T3Fob1B1WWU1SmhMWGVEV0hlQmlMNXNiMis0SjBubVZtZkRpM3ExZHV2U3d0?=
 =?utf-8?B?elp6ZlhoaS9YTGNpQ3YxZVhDeEFJT1hPUnBDQ01Jd2p0OHYxbGdpOUM5Q1pw?=
 =?utf-8?B?SEUrNVpsNGNTR1BHWnRsRmkrZndpb0ZuUlJ6VTNtaUI1S0EreHltdUdPSWNv?=
 =?utf-8?B?SWY4VE5GMGRjS0t5ek1GM0E3WjJMTDlwMzAvMXl5VFl4em5qaEg0VDJaUjVm?=
 =?utf-8?B?Z1I2K2F2YUk1Q243aFY5ZFRqMGY0cUhSZmtHREFyMnNsVy90cjdOM1VyQzVB?=
 =?utf-8?B?QTVWNWxPRFpuVzdPQnU2OXhqeVk0VU9CajdaVndzY0cydkRmSFU4eHV1cEZH?=
 =?utf-8?B?ZWp5RkgxTncrNzlaZUg2VzdWV1MyMVNtSE43ZlpZNHg2Zm1yTWptUG9aQXh6?=
 =?utf-8?B?NEgvWFA4bDVId1ZzT1ZLYXdxS3B6a3VIcHFDMFMrSktpOElhOWFqSUJSdzRI?=
 =?utf-8?B?am44cWVlOU9nVEJKUUJ4eFhpS2xpU2hNbkxVL0FpM2hUMjFHM1E4blJjb0tQ?=
 =?utf-8?B?TzJ6TEZtRm8xeW5heEhMQnFhTlJXcENzbU1keHJha3pkQnFmMVY4eTFaUUt4?=
 =?utf-8?B?aWoxNThiOUVhazk2ek9jc1ExQ1NldVdzTEhYelRSMFBzTGsycmcrSkMrZVJD?=
 =?utf-8?B?WDE5UGJqSmY2b2RyOGRVb2szaFVjT3J1YVBXMVFZNFp4SjNSTEJuQmdWSnZz?=
 =?utf-8?B?elgyQ2RRR3NiSUNqVG5QM1F3Q3BiQWd6YWZ6d294STlMNUxUZ2RwZytvNllN?=
 =?utf-8?B?cGJnMUN4VUcyd09ibDBFaUFwcHZyeVgrUEhoa3FJYW5FY1d5dWVqRTBlODdE?=
 =?utf-8?B?R0xmZ1lTOGkwWEQyRlM2eld0ZVlZWkFjUk1jWkpwWG80V2IrNWlEOTgxWFV6?=
 =?utf-8?B?WkVpSWx4T3BvNXZGRFJSZHlMZjhqVFNaVDFGbC9MQlYycHhhY3FlODVsVkNU?=
 =?utf-8?B?OEhtQ3pEQjhxckY5UDFaaWpIdEFjZDE4Yk81NTY3aCtVSFFwaXE3N21QVjNV?=
 =?utf-8?B?empPN2YvN2l3ay8vMGJTdkNnVTRjNjE1OERYLzZ1dWF1SkpDUW5MNHQ4eWZO?=
 =?utf-8?B?b0liRjhUaVFhSm9xTjIybHBLNW1hZ3hGcHBteUxtTytmc0o3SXYzSnZVTTRl?=
 =?utf-8?B?U09YaTRueG41WmQxSWpCSlMvMnI3dDFhMEc1bEZFQzVzMTlqdllCeHNTQXdO?=
 =?utf-8?B?UkNZZFMrazBoUGpXWnBPZU0zWEhKYzlSMVRwUXVIenBVU0xqZ2VjZnZSRzYz?=
 =?utf-8?B?SUhhMGhid0k5b0FRSmVWSWdqZU9JSzVxR3c2NWxXU1p2R2RCVktDT1VPV0lW?=
 =?utf-8?B?QUpxS3o4UHU1d29RelQxL1dXOThhazJoYjUzSjFFUzZqM1huK0k2NStpV0M1?=
 =?utf-8?B?OS8xbE1IZHpBRW9jdDRGNUgyUnY0Ymh1Z08zNVpWODJYeXovZFljWDdJSU5x?=
 =?utf-8?B?aTBNdllFMTVUWkRTQXY4ZS9TNVYvRHpvcWoyWkk2M2lmc3RQeU5tMFBQNnJX?=
 =?utf-8?B?d3BJamxhYXd0NitTT0lVUWZXb1ZlQ050L05rSER5bjhZQU5sSmZOaFZnWk9H?=
 =?utf-8?B?NVRJN2liZ0ljcFRLT1dKeGdUU25Nb0NQRmk1dkM4VkhiY3JjSkpmSForVGc5?=
 =?utf-8?B?cVhmSDhoSU0yS3VuY1kzSk1hc3R4dDFzRmNLTlF6ek1mMVBMRW9Bc09yYmtQ?=
 =?utf-8?B?NjA5Yzd1Um1nbEVBYmNXNXZSOTZvYUxtQVI2dVVjb0JnNE9tUzJ6bS9MUTR5?=
 =?utf-8?Q?um+HB0oNNjPr8jpVlF70PpQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52AD49A200097A4FBD088A341A6694E7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756393fc-8077-42d4-1925-08db292cd1df
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 10:21:07.9103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WZOncXpkIskloQWSqefD8nrUp0b61zuvJy0f1kyguXXRx0geO+E6htMdrVWVGjGIzcpKfqK7PFB9WuZJTpZ6ltdeolj4cxk9zSqTgH5wo9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8259
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGV0ZXIsDQoNCkJlc2lkZXMgd2hhdCBNaWNoYWwgaGFzIG1lbnRpb25lZCwgSSBub3RlZCB0
aGlzOg0KDQpPbiBGcmkgTWFyIDE3LCAyMDIzIGF0IDEwOjMzIEFNIENFVCwgSmktWmUgSG9uZyAo
UGV0ZXIgSG9uZykgd3JvdGU6DQo+IFtTb21lIHBlb3BsZSB3aG8gcmVjZWl2ZWQgdGhpcyBtZXNz
YWdlIGRvbid0IG9mdGVuIGdldCBlbWFpbCBmcm9tIHBldGVyX2hvbmdAZmludGVrLmNvbS50dy4g
TGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0YW50IGF0IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRT
ZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sg
bGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMg
c2FmZQ0KPg0KPiBUaGlzIHBhdGNoIGFkZCBzdXBwb3J0IGZvciBGaW50ZWsgVVNCIHRvIDJDQU4g
Y29udHJvbGxlciBzdXBwb3J0Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBKaS1aZSBIb25nIChQZXRl
ciBIb25nKSA8cGV0ZXJfaG9uZ0BmaW50ZWsuY29tLnR3Pg0KPiAtLS0NCg0KLi5zbmlwLi4uDQoN
Cj4gK3N0YXRpYyBpbnQgZjgxNjA0X3ByZXBhcmVfdXJicyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
ZGV2KQ0KPiArew0KPiArICAgICAgIHN0YXRpYyB1OCBidWxrX2luX2FkZHJbRjgxNjA0X01BWF9E
RVZdID0geyAweDgyLCAweDg0IH07DQo+ICsgICAgICAgc3RhdGljIHU4IGJ1bGtfb3V0X2FkZHJb
RjgxNjA0X01BWF9ERVZdID0geyAweDAxLCAweDAzIH07DQo+ICsgICAgICAgc3RhdGljIHU4IGlu
dF9pbl9hZGRyW0Y4MTYwNF9NQVhfREVWXSA9IHsgMHg4MSwgMHg4MyB9Ow0KDQpUaGVzZSAzIHNo
b3VsZCBiZSBtYWRlIGNvbnN0DQoNCj4gKyAgICAgICBzdHJ1Y3QgZjgxNjA0X3BvcnRfcHJpdiAq
cHJpdjsNCj4gKyAgICAgICBpbnQgaWQ7DQoNCi4uc25pcC4uLg0KDQo+ICsgICAgICAgaW50IGk7
DQo+ICtNT0RVTEVfQVVUSE9SKCJKaS1aZSBIb25nIChQZXRlciBIb25nKSA8cGV0ZXJfaG9uZ0Bm
aW50ZWsuY29tLnR3PiIpOw0KPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJGaW50ZWsgRjgxNjA0IFVT
QiB0byAyeENBTkJVUyIpOw0KPiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiAtLQ0KPiAyLjE3
LjENCg0KDQpCUg0KU3RlZW4=
