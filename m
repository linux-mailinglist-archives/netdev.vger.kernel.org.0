Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A083F6C654D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjCWKjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCWKi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:38:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CB01F5CC;
        Thu, 23 Mar 2023 03:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679567798; x=1711103798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Sal+nfjEoNhowvJCJSVwYC8lzQuWzrcUa4pgAXshPdY=;
  b=lhXbDXLUsbFrNWOuJMfShyKWkHNvxKauuHM1vZoSi1cbm6sGoTTz2ldd
   uqRfVT3jGba59JB8kkqZWyJenDZuzCWWIydQ9zw9lZVAP8C+2tckxqXbJ
   WnLBI0mhBEdINIQL9NlPt7tlyt19ltLiZPdaHBJtkz9aVmNQoYKAM0xvq
   WvRWBAADDe7qWuSfX66qKOOGY/FakKffATy5gyrWNusYNA653DRIw1fb7
   u+4uxjYUVR+MlBcViaULOVkEMlat254h11Fx01MzE9Rnqw6KUoPYMVMCv
   5YzZonXJFYwobJ2V9ScPmsYk43tHmQe0FudUl/4qUr69g79L3UKO1+ZOo
   A==;
X-IronPort-AV: E=Sophos;i="5.98,283,1673938800"; 
   d="scan'208";a="203047807"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 03:36:35 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 03:36:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 03:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bK5aesXawGfDr3LGbJz9Zkn4lmkHK78FdbM3XQD5M+Jdd1wEG86s+sORrqaViwcQb7GIsOkxPssbL4xmWtxf16x9eF3R8W5zXOOUAOTyyuvo1noGVfYVUqNsucXH4nsKsXcA3q/NQLyZ4PSkkdWXpQGs6JYfONzSRGQIUWRtD3FUQkuhf38MDtSKdXTFMDrbcHAPUUBp7Hnby6IjFz3/WE/B0esJSh7/nd4w73liuPYKLSF34x6Hri5PrOB2mrTW/kBNc29XW2/B1Xiab6ReTfld37QVO/haCKQ1s7nmHEu56ltQWWvyz8lNPsWoiphNDb/9TsLi5yjbbvqtnrX7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sal+nfjEoNhowvJCJSVwYC8lzQuWzrcUa4pgAXshPdY=;
 b=biuBPkK1xwsrl4Jh39MLf8XiOyeitfiXrFWd9jtSYKU39mB0Hynv0lrkIfBQ2BryP+mKW8smmbg/A3atb2d5qVhPYRyhzVYz+vvtzXqBpKx2XMdybJ44Uy3TeilovjK9/ZVpFWJJYhRVHHOf8gqp0+P7/4w0CLfoC7+CQ8l/PVUzw3wegm1s2O9raWWuUZuS4axEeOPhgZMKsxosbOlJ8Uo5lYWLTzHNGR3m4dPb0JEx6KduD/FD7M096G4/Mz85bgT/YOMwtYt/RMq1c2kSKDdTIK7kuL3SZNlLSlloSZw3O5AV7J85IHxMq6cGsohKZxdGxLwwR0nE7706n3ggqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sal+nfjEoNhowvJCJSVwYC8lzQuWzrcUa4pgAXshPdY=;
 b=vFEkCTqFNuxjzlB7kJprL52NYgEPpSutexwKi8ZSWPKUsjd7uBf7OPtLjd4yzg67Fert1a1PPM9i9/Ky4RB/pED9rJvpbqyOYfdqJUnPgs9de54S2c8sdWkwQJ5Ryb/qI8u55b4tTftsiwLFzRztPpM+3m0moE8o39g1NIEjX3o=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 PH7PR11MB6882.namprd11.prod.outlook.com (2603:10b6:510:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 10:36:28 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9%5]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 10:36:27 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <lukas.bulwahn@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <tsbogend@alpha.franken.de>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethernet: broadcom/sb1250-mac: clean up after
 SIBYTE_BCM1x55 removal
Thread-Topic: [PATCH] ethernet: broadcom/sb1250-mac: clean up after
 SIBYTE_BCM1x55 removal
Thread-Index: AQHZXUdO2MyhBYS7q0O9X3/4Es0aQ68ILBaA
Date:   Thu, 23 Mar 2023 10:36:27 +0000
Message-ID: <CRDP39LYBBU3.285KM5A5AVCYE@den-dk-m31857>
References: <20230323052101.30111-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230323052101.30111-1-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|PH7PR11MB6882:EE_
x-ms-office365-filtering-correlation-id: fdf125ea-564d-4b71-08e3-08db2b8a754e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fodx6sp65NY3PKb3D3q7CTh1pkwrp3qnfGzLoYkBS1iKNLQYqdOkHBbL+lZVEojAaJj9Gy+zhs/2vUHl1JZVyWAexdpXqD98OB/9aAiqHcy1lLU8U/ZmHefGsvUrfbOToMda8famF6LnFLQGs8wUZ2Uu/A+9XSldgm0E5DaFKiULD5sULPVlDzaVerO+kz0qzaB9FVC0x0LuQLLQzCLjy/MbbRJJl1eLPQ9bW7GF9g9GoDMRmg/iElOlFg17J1FNiGR/F3CJKD98ZaMZNUlrGbL1auIe3KbqGYqjTpbakuV1/G0wA3Ihjx+pzMxF/xf1N56j+vuo+p9YvWAUUHhacW9sYU9bcvVCxYQm/XVrCswzS3RaJY+qgd5KockK44qwWP5hQjrOWXotKzbHnH1D+KKgDb7mpNdrCWgmH6GLYfCwuSOnf52rh3gBJBjWBJLfBRVABtgyyb21a0prtUZZ2SVWYx+bgADHjT1JGDha6Bh6tSiDnq6nnieDSI0Oop0C4lY3ecJZjqrxUCUQhsZjLbXDZc76Ecms6KKzgIhS20jIPKS5R15QP6NsX09clWdppWf4mzsIJlGLIBq9M5NOiB27O3xcWCDcSjvjCYDp7bH/DK8BpojnrGArHWzO8Yf9VJtG05gnjJKzu2y1EpnUAHkh2zn28UFcV2eQxbA/nhqGTMq6MEq38y4ZIiY55OI5MNO6KLthix2QjCwotaXK+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199018)(33656002)(4326008)(86362001)(8676002)(91956017)(66946007)(66556008)(66476007)(66446008)(64756008)(8936002)(76116006)(41300700001)(478600001)(71200400001)(6486002)(316002)(54906003)(110136005)(33716001)(2906002)(5660300002)(38070700005)(122000001)(38100700002)(9686003)(6512007)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czFhRnR6V3NGU2pPNmtvY09ic2d4WWRPaVpHVUdIMG5wQzFuMDhTNkE2QzJn?=
 =?utf-8?B?cHRmUXJ3dTRLLzlJclArYzJmaWh5TkVQcEN2ci9FbzVCdHlCMnhpMXlhVUFv?=
 =?utf-8?B?TC9QVmNwUHNlUmVHSzVhbG5NVjJEMjBWR0NUWHRvSk5ibDhUUzZWUkdRa2N0?=
 =?utf-8?B?ek1YdXNpbVJFZjMvdU9jTExIQTJqT3o4REN4cUVFTFBjYlZ0d1JoVWxYYkZs?=
 =?utf-8?B?ZXVMek9sc0d2TFJkRkVsNXYzNkgzTFBWUWw2VEFnY2hNY0pmZGc3b2xGeVpo?=
 =?utf-8?B?NVhkOXc5R1dXWHNVQWN1Q3cvWGUrVGpiZDRkbm5sMkdXcmdac2E1VldwL1hv?=
 =?utf-8?B?bFh1d1BxRVZkOWJwU3NOZSsySCtSSTZCS041UUlYWXA3TGI0ZjUrbGROWjBI?=
 =?utf-8?B?aUFNMEo5Mys3cGF4VHVCK3M0L3A2QmRud0MvbHZhL2hGOEp5WVQ1eU1ISDRs?=
 =?utf-8?B?c0lGcUhOc1Y0ZzByL1QyUDJPTVJyVGxteUVoUUppZ2h6ZnF6bXhHQjVqd2Y0?=
 =?utf-8?B?b25oSTEwcHN3a0NKMWY0NEExSkpxTGYydlhmUnI3RE5DVFc1RklrVFdtSjA3?=
 =?utf-8?B?ZS9VREdSVHc3dHRtREROVjh1ZmZSNTJtQ28wMzE0eGxjOE05YTVSelNVNE5J?=
 =?utf-8?B?TjMyazlZeHllaklGaGl2alNLMWl5TkR2bmFzektPWFlOcno0K0FXVlp0dytq?=
 =?utf-8?B?Q1VRYVJkYXpUTk1nZ2hUbmF4ZXlQOTRYc2QwSzRTRGFyV01nL05IcEVFOCtO?=
 =?utf-8?B?V1hYSTJnZ3IvejJBMEpYZmdaY2RQUkxlTnYxbkF1Mk9DeC9FU3FCd2YzYlNo?=
 =?utf-8?B?QzNqcE5hYmsvZEtobndMeFhVaUE2bEo2TGZJN3Y3Wjc3NTdZWCtzeEFMQlJP?=
 =?utf-8?B?K2RrendwYW9uSVhHWHltSlVWNW5EazY1NVEzRXl1bGpBbUkwbWJuWnVGRGt6?=
 =?utf-8?B?aGI2d2hFTWZNSTkrSXdQaWVoUUYzLzcvTldrYUlKNTF0eE5uYmdJZU1iejZt?=
 =?utf-8?B?bFZGZGZGRWVkb0lxNDVCNW5GVW40QkJqZ2JjSENrNFA3S0d3cXN1ZG9UVndt?=
 =?utf-8?B?WUFQN1c4MUlvZkFzam9yZk44M1QzeTlpMEx2TlFBcWtoM0hpblozRnVLQmxJ?=
 =?utf-8?B?ZEtmTnVJVHhvcGQrZC9ETDZicFJMTmMrcUVaSURzaWZpTzNIdTZVTm1zVDR0?=
 =?utf-8?B?azJnbldUOC81Ym1QYVJ4azFFQjMxb205b3BTQklLemF5SlFwSit3YkNBZmlm?=
 =?utf-8?B?TGxweEFqaHRGVWNjck9sOGFFcDF0Q2FWdjhVWllicm5iUlNuZ2pXT3gzeWxw?=
 =?utf-8?B?REVDVHNFV1JFVU1yQ3Ezb01BQ2owVTZUdUhIUFlsN0tjdHZWWnhxbEQvL0VC?=
 =?utf-8?B?akllSDBkd1o2NnNRMWlMamRFRm5qV1pMSTErQWpZOHlZLzBPUHZrWWVpbC9v?=
 =?utf-8?B?NElnUTR5bkFET2NDRStra25DTUV6UkQ5MmcrSkwzbUpRNXdpSk9EY0dRblFj?=
 =?utf-8?B?T1dKYlNaZXQva0RTS3RlOGJkUy9lNE9TYlYvWEdxS2NXK1hsa2l3WFlQdjRw?=
 =?utf-8?B?ZEZuS0hzZHJFKzVlMUF4VFdiZkViU2Q3d0NwRTQ2SFR2S3RrUVNLbGhuMFZC?=
 =?utf-8?B?S2hYZU91SFk1RVA3K3BGSVFVTFprSktnekpXYjd5VHlWam4rWEVGcGZDU1ky?=
 =?utf-8?B?ajlyeExwZWt0WVM2U3ZSWmM1QjhES01ub3dxdGxhQTRRQm5yaXk0aVNKMFow?=
 =?utf-8?B?bzVzTWVFejZiajAvK2dOWUJwUnJ1bktpdGU3L1RiUzA5NXdtNTB3Yzh5OElV?=
 =?utf-8?B?d0h5WE1jNWFFOUx1czBJWGZsd01lcnhZS0xWRzNxd3lmTEc2cG45NmxxUGpw?=
 =?utf-8?B?RDNIYkpRNjRZb2RvZ28zQnJCUU0rTDVKUmhvRjRrNVl0Y3NMZmdYNXpEK0ts?=
 =?utf-8?B?RlRlOHRtZHFiZmtqdllUYnBZKzlLaEtoNXhpUUpzQVF2Y3c2b01HN2tYbTVO?=
 =?utf-8?B?WFlqK2dLMXNEajllYnFKQlRJUXR1cm5MY0JqQ2s3RFNKR090VXBldkxjQlUv?=
 =?utf-8?B?RHZ2YzBvb2d2bHJnTXNvazl4RXplVnhwdGNqQjNXajAzL3Q5S2JFNlBhUkR1?=
 =?utf-8?B?bSthYXE4OEhNTnExWE9XU3Z2eVdJVUtNTStJZnlzUkpwYjNFTlFJMllEajhL?=
 =?utf-8?Q?KhNrk1TAVkvn308e2r3mr+o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B9C32414B6B37241879DF7348994A198@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf125ea-564d-4b71-08e3-08db2b8a754e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 10:36:27.6118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mhu9Vshv8dL3tN3sUTTJvmWzsolgptbFmyBGn8IvmjHsjNGNYm1Ye2wkQYvv1VdXbSZ/7QEib3b9+SSqrpcbRfJPc5itaUfWxeNvlieIM+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVrYXMsDQoNClRoaXMgbG9va3MgT0sgdG8gbWUuDQoNCk9uIFRodSBNYXIgMjMsIDIwMjMg
YXQgNjoyMSBBTSBDRVQsIEx1a2FzIEJ1bHdhaG4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPg0KPiBXaXRoIGNvbW1pdCBiOTg0ZDdiNTZkZmMgKCJNSVBTOiBz
aWJ5dGU6IFJlbW92ZSB1bnVzZWQgY29uZmlnIG9wdGlvbg0KPiBTSUJZVEVfQkNNMXg1NSIpLCBz
b21lICNpZidzIGluIHRoZSBCcm9hZGNvbSBTaUJ5dGUgU09DIGJ1aWx0LWluIEV0aGVybmV0DQo+
IGRyaXZlciBjYW4gYmUgc2ltcGxpZmllZC4NCj4NCj4gU2ltcGxpZnkgcHJlcHJlcHJvY2Vzc29y
IGNvbmRpdGlvbnMgYWZ0ZXIgY29uZmlnIFNJQllURV9CQ00xeDU1IHJlbW92YWwuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IEx1a2FzIEJ1bHdhaG4gPGx1a2FzLmJ1bHdhaG5AZ21haWwuY29tPg0KPiAt
LS0NCj4gSSBsb29rZWQgYXJvdW5kIG9uIGxvcmUua2VybmVsLm9yZyBhbmQgY291bGQgbm90IGZp
bmQgYSBwZW5kaW5nIHBhdGNoIGZyb20NCj4gVGhvbWFzIEJvZ2VuZG9lcmZlciByZWxhdGVkIHRv
IGNsZWFuaW5nIHVwIHRoaXMgbmV0d29yayBkcml2ZXIgYWZ0ZXIgaGUNCj4gcmVtb3ZlZCB0aGUg
Y29uZmlnLiBTbywgdG8gYmUgb24gdGhlIHNhZmUgc2lkZSwgSSBqdXN0IHNlbnQgdGhpcyBxdWlj
aw0KPiBjbGVhbi11cCBwYXRjaC4NCj4NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29t
L3NiMTI1MC1tYWMuYyB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYnJvYWRjb20vc2IxMjUwLW1hYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20v
c2IxMjUwLW1hYy5jDQo+IGluZGV4IGYwMmZhY2I2MGZkMS4uM2E2NzYzYzVlOGIzIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9zYjEyNTAtbWFjLmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vc2IxMjUwLW1hYy5jDQo+IEBAIC03Myw3
ICs3Myw3IEBAIE1PRFVMRV9QQVJNX0RFU0MoaW50X3RpbWVvdXRfcngsICJSWCB0aW1lb3V0IHZh
bHVlIik7DQo+DQo+ICAjaW5jbHVkZSA8YXNtL3NpYnl0ZS9ib2FyZC5oPg0KPiAgI2luY2x1ZGUg
PGFzbS9zaWJ5dGUvc2IxMjUwLmg+DQo+IC0jaWYgZGVmaW5lZChDT05GSUdfU0lCWVRFX0JDTTF4
NTUpIHx8IGRlZmluZWQoQ09ORklHX1NJQllURV9CQ00xeDgwKQ0KPiArI2lmIGRlZmluZWQoQ09O
RklHX1NJQllURV9CQ00xeDgwKQ0KPiAgI2luY2x1ZGUgPGFzbS9zaWJ5dGUvYmNtMTQ4MF9yZWdz
Lmg+DQo+ICAjaW5jbHVkZSA8YXNtL3NpYnl0ZS9iY20xNDgwX2ludC5oPg0KPiAgI2RlZmluZSBS
X01BQ19ETUFfT09EUEtUTE9TVF9SWCAgICAgICAgUl9NQUNfRE1BX09PRFBLVExPU1QNCj4gQEAg
LTg3LDcgKzg3LDcgQEAgTU9EVUxFX1BBUk1fREVTQyhpbnRfdGltZW91dF9yeCwgIlJYIHRpbWVv
dXQgdmFsdWUiKTsNCj4gICNpbmNsdWRlIDxhc20vc2lieXRlL3NiMTI1MF9tYWMuaD4NCj4gICNp
bmNsdWRlIDxhc20vc2lieXRlL3NiMTI1MF9kbWEuaD4NCj4NCj4gLSNpZiBkZWZpbmVkKENPTkZJ
R19TSUJZVEVfQkNNMXg1NSkgfHwgZGVmaW5lZChDT05GSUdfU0lCWVRFX0JDTTF4ODApDQo+ICsj
aWYgZGVmaW5lZChDT05GSUdfU0lCWVRFX0JDTTF4ODApDQo+ICAjZGVmaW5lIFVOSVRfSU5UKG4p
ICAgICAgICAgICAgKEtfQkNNMTQ4MF9JTlRfTUFDXzAgKyAoKG4pICogMikpDQo+ICAjZWxpZiBk
ZWZpbmVkKENPTkZJR19TSUJZVEVfU0IxMjUwKSB8fCBkZWZpbmVkKENPTkZJR19TSUJZVEVfQkNN
MTEyWCkNCj4gICNkZWZpbmUgVU5JVF9JTlQobikgICAgICAgICAgICAoS19JTlRfTUFDXzAgKyAo
bikpDQo+IEBAIC0xNTI3LDcgKzE1MjcsNyBAQCBzdGF0aWMgdm9pZCBzYm1hY19jaGFubmVsX3N0
YXJ0KHN0cnVjdCBzYm1hY19zb2Z0YyAqcykNCj4gICAgICAgICAgKiBUdXJuIG9uIHRoZSByZXN0
IG9mIHRoZSBiaXRzIGluIHRoZSBlbmFibGUgcmVnaXN0ZXINCj4gICAgICAgICAgKi8NCj4NCj4g
LSNpZiBkZWZpbmVkKENPTkZJR19TSUJZVEVfQkNNMXg1NSkgfHwgZGVmaW5lZChDT05GSUdfU0lC
WVRFX0JDTTF4ODApDQo+ICsjaWYgZGVmaW5lZChDT05GSUdfU0lCWVRFX0JDTTF4ODApDQo+ICAg
ICAgICAgX19yYXdfd3JpdGVxKE1fTUFDX1JYRE1BX0VOMCB8DQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgTV9NQUNfVFhETUFfRU4wLCBzLT5zYm1fbWFjZW5hYmxlKTsNCj4gICNlbGlmIGRlZmlu
ZWQoQ09ORklHX1NJQllURV9TQjEyNTApIHx8IGRlZmluZWQoQ09ORklHX1NJQllURV9CQ00xMTJY
KQ0KPiAtLQ0KPiAyLjE3LjENCg0KUmV2aWV3ZWQtYnk6IFN0ZWVuIEhlZ2VsdW5kIDxTdGVlbi5I
ZWdlbHVuZEBtaWNyb2NoaXAuY29tPg0KDQpCUg0KU3RlZW4=
