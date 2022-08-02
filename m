Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C458587DBA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiHBN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiHBN6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:58:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A8F1D6;
        Tue,  2 Aug 2022 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659448728; x=1690984728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BQ9X0rNtBKX9lUrROg+gGR1gnSbRahygrbrmEHVHAvc=;
  b=MabO0PJHLGspzVwv+qSaODfXu6f1d6hplY25WzG74VE5qcNihUsqHUUT
   sValE37d3xhiIquCXEOla6LVx+cfA7BwW+lwip7AkNK8lI8Q3t5WHNRnh
   GfFtk4Tg0zmj4o/xJXrtktCNvvveeKfohUR5Tkz8v72yKdBwLex+zIGKI
   MBjQ0ztIin82cPwULc03GJERX+Fw4KImMVVx5J5LqlwZ2h2sDnr7zAEwS
   OemKk/Ei+y8PuXDksISL22TD6xMA9aIikUAUdVy5W5Thx8BkVqNj6EDMs
   GEmlaGDkQMwdvBWU5rFr2ZO7z824wXcdD84iNj/f/2Ei9S1ZnrJsk9Hv1
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="174584957"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2022 06:58:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 06:58:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 2 Aug 2022 06:58:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQVrNEWzQJ8n0+76fZMSJbndhkyn3KBeZu+PN3euMX+TBBosqJ/doH65Uw+Ha01+i5m/otxEq/VggcaPDOehxW/6+KqkPBM9Rp6HWNnc1gwAeWF28o0jd5ufeSg1jMkhOo6HecWu86+SOHVaRDsZjxOR6UcoEwhllV7pQWCZe5w17BUpOFae1sbgDVdh/U+RKwVeo76BmEjR0i4WOngACc+zWPXg4zSki0OI8SWwGXL7CwARILTY3GPOliwrBL+ntk/lH4Rb5xVHrZpwkllldELkdbgcqcPllMvxXaYivcQeGpsqfcbsCzVi/Lg1cw8yU3LypzIZCT+pvvNtcBuNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQ9X0rNtBKX9lUrROg+gGR1gnSbRahygrbrmEHVHAvc=;
 b=d+ylu3gCKCucwwddMNIgxolUuK7RsLouFrnQv9IZjhdSFGC/i/Q/xFoQGEqI2ZgAx6xR7ptHIJRaMewdCE7KAyQkbQ6ZmGu27cCcEFrv5+KGWCGCPJ8jAkRjseVv9W/mF6sx2NAcyfp0Itf9Qt9B6iDJlhdSXsR+jDwqif0F+xSxKkrbuWhC2NDYmhuoIgYdPzBWj0+RvaaSI2B7Ok5qsKyEokskO6+p2oz4we88xP/L293XkzvO6kC8HurtZ6H919OCSqsNlXJE+5tL5E865x//qKoCRyxjowNkaCg98sYoCLIkMbweRITRdy6wrX87q80Mhlol30BmXGr4WqZpVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQ9X0rNtBKX9lUrROg+gGR1gnSbRahygrbrmEHVHAvc=;
 b=X4Ms3EbnA4rGPc7Hb76JUEBQOq2W8AAL+VHzk2N9FQSNedINjMiZTzMPvedNbVIIDNbRuLEH6eeOD46IA72XBisZLs6z2qU3W/LGanPIksS6MxfSF/b4GgjcikLRN5NnXtO5ryja8VK7jfHyJf8aKheDtp+cChgmBflRUTi8/h4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA1PR11MB5924.namprd11.prod.outlook.com (2603:10b6:806:23b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 13:58:37 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::945f:fc90:5ca3:d69a%6]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 13:58:37 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch RFC net-next 1/4] net: dsa: microchip: modify vlan_add
 function prototype
Thread-Topic: [Patch RFC net-next 1/4] net: dsa: microchip: modify vlan_add
 function prototype
Thread-Index: AQHYo15u9o+N7zyb80WrHCfPvO4YcK2bb7SAgAA5eYA=
Date:   Tue, 2 Aug 2022 13:58:37 +0000
Message-ID: <1993b9fa044df876b7f5b978a0c77a91b8e4e45b.camel@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
         <20220729151733.6032-2-arun.ramadoss@microchip.com>
         <20220802103253.z7jryvmnef5bzdww@skbuf>
In-Reply-To: <20220802103253.z7jryvmnef5bzdww@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4624a62-a5dc-4175-39cf-08da748f18eb
x-ms-traffictypediagnostic: SA1PR11MB5924:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVgi42e3F7TPFLMFoMafIfSsFvo9vdFV4Ii3xBIxne9H2l2hjSqzlFZbVASnTyB2dTI6HU/6Xy5kANdcWKt1Xqo5Yw+fB0ab+4Bw2qm87Bf2/oUYRHB7hWYttSKXTT0uZ8h2NtpcO6gEEUdH7M1EVK11F8BizbKRXlfYo9oMNlpWLk65G+ATxu9a797iEFDSnfJLz8ZYDftFNB6YO+n3Y2zMlBa1HOs2TPooMzVQmfbaV/7wMu+93bXrQXaF34SF55usqhOFCSwlOYrOI2EJKCBB/TwSKLKEuwLHsul/VpM/Nv74bZROdBogd+fQCsa6jx3k4yEt8QT5f+zsmyEbCnsYPTKN4cJeOtCIXWeitWBhawlaobUmJq7tFRAkqbVANvQyiNehvnFREbDSBgtf0vU6O3YIgd2Afsq7/N+x1nVKi8BbeNwkwerHrlYjES2Z3ZCbmcfCInD3qR5mOG5yxBP7mFvql2WOzoS9kUJ00ZiSGOMtoOtmCL902d3MNrYyCBP4aNBqXxJGeAKKRYiDGCRE3XvpzBDO9n9I8EHwqP2t1JF1xvN1qwN1XX00FzyEJxrv9pzAeJbFQO/i0rS9Amfa6+JOtE006gB4s35NDhtOP6nga+/2kaCPWHHUYJBqX73sHlGLyK4UFEkdIlRQw+id1+X5kJAVJAjRfJciIIi0hDbBz+gIHGXhChdo2QiJT6fiTPCRw2RTYmX353lgQRQL62vGAUJqdzJQqVykCHbiDgRf+5Q9dLDY7Dgni+EXFKg1oT6jiUy7PbZGWbmsqjdMqVgFd3XZMvEkcsPB558NDPq4xAVo66jPSNw7SL59OqVUKs8t/QUY85OzdFwlzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(366004)(376002)(396003)(316002)(71200400001)(6916009)(6506007)(6512007)(478600001)(38100700002)(41300700001)(6486002)(122000001)(38070700005)(54906003)(186003)(86362001)(2616005)(66556008)(66476007)(66946007)(64756008)(66446008)(76116006)(91956017)(2906002)(36756003)(8676002)(8936002)(7416002)(4326008)(5660300002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHYrQ3pxMFoxVUpaUFRPcE1lSldFakFuTnFBNytEdTRjS3FwdUJVeER4SnA5?=
 =?utf-8?B?N3VqOWZBWDY3WDM5U1A4Z1NwNEZISHdlSmtPU1JKMllLcGtBUXFqZCtjQlJZ?=
 =?utf-8?B?VXg1MCtLMkZyTFdZTGNMc0kwUTlickpHdlRPdjFzMVJLMmluSFZMekt2cm5N?=
 =?utf-8?B?SjF3d3Y4Qldza1hmb3hLaUUrSWZLc2pMa2xMYk5ob2JvenNvaDRrN2YreUIy?=
 =?utf-8?B?bVljZzhDTFE2WlNRTCt6b0R0K3plbGZPbWVTVTZldjNPN3lVQnpEblhEN0w4?=
 =?utf-8?B?Y2lrTXUxSmludzYxOFNYbXhhQi9XUlVrOHdCSlNoOHdoY1lSSGFXd2lkb1Bk?=
 =?utf-8?B?cGJnVlQ5bXR5Y0wrN3V4WW9MVXhGcTZFSEVvb0FmMHoxYjNBUlJscVdyZUJZ?=
 =?utf-8?B?QXFFa1VwSlE0MkJFZFN0bE0vWU1tVTFWWXNDTmpFOU1SdElQRktIeVFZR3hj?=
 =?utf-8?B?Y2NJVXdXUU8rNUM1SXFYV3E3UnJ4ZHJVUzRFM1lTQXlGUS96OWtHMWtad3Jq?=
 =?utf-8?B?dDQ1dXQ0cFlNMS9vVmVSNXIydXVGc1pxakpTUTN1Z3hiaDZlMzFaVVlSWWF1?=
 =?utf-8?B?NytpWkd6L0lPMzl4U1EvZGNvenZ1N2c4enNtWEdleUVFQzlPVGtFNkxHS3Ir?=
 =?utf-8?B?cEdNKytOU0VqMnJVU3NKZ3JheWRvdDBWbWNuSVdZenRJVThVVlkwQ1VoY2Vx?=
 =?utf-8?B?ODF2TU5CWXBnQ3FRRTJYRUVVVFpvZFpFd1NZR000bUl4dVNMazA5Nml3MUg4?=
 =?utf-8?B?WUZFTUgzVmcwbEJDeFVPQUZXcitXTXl1WTdkOWtsMmh3YnY5ZUJPc2xCNzVn?=
 =?utf-8?B?VGVvK1NablhWT0NJaDRWUk8wazd2MUM2R2xnbVJ0eWZsSkNoMGw4UzFublBF?=
 =?utf-8?B?cWltbjRzME1lTVRUSTJYbS9mcnZKVmRuOHFZWHVBblcyeFpGczV0U2Q0NldE?=
 =?utf-8?B?TFY3K3VzdW9UNStvMzg2YlVEV2xtRzdLcFJ3VTlCd2JEYVZiQk5ETjNlc2VG?=
 =?utf-8?B?eFJYUTVkd25EcVhXQmFPWmF0V1M1N2w0ZUNNSlVTYVV2WmpoVHByR0xFbTlO?=
 =?utf-8?B?aDJaelBMUHpFRU84UklZZVZrTHJxWENYZCs2Y2NRRTlyWEhTcGRFdUpxTXMr?=
 =?utf-8?B?aW9PclNtRGt3d0NjNkpjR284cE5ROXBUbGFIblNyTlJtVmhxam5uVDVNTGRy?=
 =?utf-8?B?TnVwWjNMKzVtTGhPN25vanBxMExFRUZUMlBSSTdubHFDLy8zRHVxRG5OZWVz?=
 =?utf-8?B?VzhVRkJPd3dwM1kwTk92dXFVbTZPY3dESjZEMG9zSnNjQk1QczRMKzF2cVp6?=
 =?utf-8?B?K2N5TGcxVEp1RlY4amtmYUg0M0J2RXlWdlZ5SlNsemFqQlFJL2xTMWVqMjEr?=
 =?utf-8?B?TmZUL0pMU1dDVTJMNjAwcG50cTJRVkJsQ2Fmak5YYkx4djJHTThHVzBWc01M?=
 =?utf-8?B?KzNkM1lmeFNTZCtOcUNGbVUwdk0vb0lTS3VrKzhhTkh6RHZGdUkwSG02WHl0?=
 =?utf-8?B?dHJTaFd1OUJ6T1Z0WmJ3RFMrcWNLL05PYlZ3RytvbUFmNklSNXdxdUpkUlFL?=
 =?utf-8?B?Slp3eE5ERnMzZ21aQ05YaXVxQlZrTkRabU1XVVU4cmlmQmFTVlM3Mk5ZZDJm?=
 =?utf-8?B?VjI0cC9EUWp2bFFLUUVidkpqSXdxRTd1TEFpWjJoeEpwek1Ca2ZvbEYwTXpR?=
 =?utf-8?B?WkVNcHVDU2tUNjBpZUdlK3hGcTNCa0dCM1Fpby9kNEdoOVJMZWVRU21BMVdD?=
 =?utf-8?B?NVY2R1hXWmhyNVFjTHVMaHVzM3JOK3o0NkgzbW5Ga1p0MnFJVVFpTW1Wa3Ns?=
 =?utf-8?B?cXFRU0s0VzNiNndscm9yTXFLNWM1ekxIcy94dGl1b2JQREVqY2JHZzBYSVlP?=
 =?utf-8?B?NEdMRUJyaTVETmRVS1dKdHhKOHdPWjE1NVJlR1JLdE90MzVmcHQ2K2ZHODh4?=
 =?utf-8?B?TU41Z1gzSjdKM21KaXFzREQzSEtpejFrR3FzVnUvRVpra3RLUFZydnA4QUg0?=
 =?utf-8?B?a0g3SmpmYU9hREVvRFFlNkJqQ01uR3ZEYXlmWUpyZDcyNGkwK00zK2V6OVdN?=
 =?utf-8?B?WUNzTElrRm9TOVc4UndrQlhZVm56NmJpRG5HS2tGekMvRkl4a1lUZytvbjFh?=
 =?utf-8?B?L0s0Ti9zYzhXVXVBaCtoQ2Z0allMOEJ3alZBNkt2KzhlcXBEMlAzQncwQjly?=
 =?utf-8?B?VUR0T1puSnhSRi9tdGlPK2JNaDZhdHl6ZVVPclNsaVpnbnc3d3Q5N3V2WTB2?=
 =?utf-8?Q?Qrg5QePa4DZLKIGhAHIEu9Pb7Uk5+CRs6sQtXWLRqU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <344F466757A5F8418569BEAF75DBCF14@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4624a62-a5dc-4175-39cf-08da748f18eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 13:58:37.3404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PrfC2rux9Qma5PBDkL/OY4NsZotPh3JBjIQgxYQ32dnUeyzETZJ/z9ZC9lChXv+4XkGXnhMoFZb7NaeDCHbgan6TX7K2/Rx06ROidEPpZDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5924
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50DQoNCk9uIFR1ZSwgMjAyMi0wOC0w
MiBhdCAxMzozMiArMDMwMCwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIEZyaSwgSnVsIDI5LCAyMDIyIGF0IDA4
OjQ3OjMwUE0gKzA1MzAsIEFydW4gUmFtYWRvc3Mgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OC5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzejguaA0KPiA+IGluZGV4IDQyYzUwY2M0ZDg1My4uNjUyOWYyZTI0MjZhIDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OC5oDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4LmgNCj4gPiBAQCAtMzgsOSArMzgsOCBAQCBp
bnQga3N6OF9tZGJfZGVsKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiA+IHBvcnQsDQo+
ID4gICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHN3aXRjaGRldl9vYmpfcG9ydF9tZGIgKm1k
Yiwgc3RydWN0DQo+ID4gZHNhX2RiIGRiKTsNCj4gPiAgaW50IGtzejhfcG9ydF92bGFuX2ZpbHRl
cmluZyhzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiBib29sIGZsYWcsDQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0
YWNrKTsNCj4gPiAtaW50IGtzejhfcG9ydF92bGFuX2FkZChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2
LCBpbnQgcG9ydCwNCj4gPiAtICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3Qgc3dpdGNo
ZGV2X29ial9wb3J0X3ZsYW4gKnZsYW4sDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgc3RydWN0
IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKTsNCj4gPiAraW50IGtzejhfcG9ydF92bGFuX2FkZChz
dHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgdTE2DQo+ID4gdmxhbl92aWQsDQo+IA0K
PiBJIGRvbid0IHNlZSBhbiBpbXBlZGltZW50IHRvIG5hbWluZyAidmxhbl92aWQiIGp1c3QgInZp
ZCIuDQoNCk9rLCBJIHdpbGwgbmFtZSBpdCBhcyB2aWQuDQoNCj4gDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgdTE2IGZsYWdzKTsNCj4gPiAgaW50IGtzejhfcG9ydF92bGFuX2RlbChzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiAgICAgICAgICAgICAgICAgICAgICBjb25z
dCBzdHJ1Y3Qgc3dpdGNoZGV2X29ial9wb3J0X3ZsYW4gKnZsYW4pOw0KPiANCj4gV29uJ3QgeW91
IGNvbnZlcnQgdmxhbl9kZWwgdG9vPw0KDQpJIHdpbGwgY2hhbmdlIGl0IHRvby4NCg0K
