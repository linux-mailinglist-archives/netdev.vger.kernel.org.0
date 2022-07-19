Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14EE557A3C2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiGSPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbiGSPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:55:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38E319012;
        Tue, 19 Jul 2022 08:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658246140; x=1689782140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=P5ijavxuAVTHQRk0uupd6CFXmnyw+qYrNM2lTVZkgco=;
  b=B4McnU/zrXibm4sng4z4RedUr+jDwA/8OWsULFlPTkDqZvxS3F16hIzN
   y7ZX9SXSpGFD24q1H1kjU6qdim8DJVuK2iv0YkUFtr8DgCyjU1EGc8iz2
   +MVwxHivGUMWG6c4z7eZ8fogeNDvzYkVSqZ9ref7VMWHAdyhr2t8HjAXJ
   STAfg5jTdRBSO1IRajMm1/5Qofwir+BBLpSJli3eFU4DTFDsuXViWKHqr
   ziUKRBZmiBSoE2VFD2sZtTLbcz8D5Lns5w7F/ZeeReRtOgv7OBgPND12r
   l8b4oh2Jq3VJlYs8wMdAutbEDUlwfJ/2GHoCWu0mYiqVE9v/atEG7kUI/
   g==;
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="168549765"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2022 08:55:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Jul 2022 08:55:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 19 Jul 2022 08:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRD3Ij5t+wbJZA8uaSlynFn4BIOjy+zD0NEtLdjyclKW2Ncefp9ll/aykPH1vk3uTS2/NFAhVpba/4tQNE6vUQH1VyaaR9+/k44tNlFGsfw8v5jK79NCRSt10uhg2EqqIEyEJmeIcysWJsRIbgLLnOjiv/fznHCHKGtwjKwEv1tAmBNHxaHrsJewU9Z1V4nXu50g5d/1Ylx3x5lxx0m53UpcI4WoR+VVO9e54uYB65XGclDUDCP+IdGFYB8IehkqtJFg8xhUWf0sXkVk1QxO7A9yD818H7EKmBlTzhq/SMRStPUXjg+ADzjdeQVi42TLdY3nacyWcDeHUYGcgVHF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5ijavxuAVTHQRk0uupd6CFXmnyw+qYrNM2lTVZkgco=;
 b=VeonfTp+SAUPwwhjgANnlp2EC+a0oqhro/DpIu7U+f2/Gusn2waaRQVQHmTUKRD8HG/fKeZ17bZWKMEBEVhkfw9NtMXHNnXAejyWwk+26pO+hhL89uD600fMiPXCHcKfsuGy9MtTXVZSkulWAuhM6khKPR9qlRLjfAvYvrc3ShqaBjrNu7cLelqBGEGzAJSU1FWn0o09jLgong8eQjbmahNrph+S5Ivpeo7vPxZXkz0DVgfFPmwc2288ANd7LZQh6FTBnbPCXLRxH6MW14Ia0IVJKkM6M4EBx8psLBU+FpyboL6wbAuRa4QdfYPt05vf0RGHIARf0K6WeqydRh4nNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5ijavxuAVTHQRk0uupd6CFXmnyw+qYrNM2lTVZkgco=;
 b=AemktshGYMikoRkS4FsdxoU2pOussq97d2KZOuU1bbcGgctxlu85L6YAeAI0Ftp/Wq3gDc3/yHVIlCV/fMsW+p8bVJQL31KJQ7K40thTkiYauFGEH2X3QyF5C0dz2lkyKqG6e1+4CtCfltB7qPz2Ia6fVdztNpck0b3KjnTGBaE=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH7PR11MB6745.namprd11.prod.outlook.com (2603:10b6:510:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 15:55:31 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Tue, 19 Jul 2022
 15:55:31 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next 06/10] net: dsa: microchip: lan937x: add
 support for configuing xMII register
Thread-Topic: [RFC Patch net-next 06/10] net: dsa: microchip: lan937x: add
 support for configuing xMII register
Thread-Index: AQHYlgkrlcrVbf+Htk6jXoYUpIdWlq2FksVWgABRGIA=
Date:   Tue, 19 Jul 2022 15:55:31 +0000
Message-ID: <bc2149a96e870004bb1c9e51184c64a88e8ececd.camel@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-7-arun.ramadoss@microchip.com>
         <20220712160308.13253-7-arun.ramadoss@microchip.com>
         <20220719110455.6aoldb6tokljdjia@skbuf>
In-Reply-To: <20220719110455.6aoldb6tokljdjia@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64cfa0d7-9fac-4614-98f5-08da699f1bdc
x-ms-traffictypediagnostic: PH7PR11MB6745:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hY9RGZrWwlPMco9+zyoeC+TaQFXufecAoogGNEYuRRnrUqN+Agx2TYFXxhYBSgPVjSi1P0Cb20sJnEwXlNNv8v/q6+jXIC7fPB/v2tCEd3/fNj9pKgqCT4oKjrMSybVfAauRtfGw9oq3/N5aNARTkitlqF3Ve2yCuYnkm+K8dfNQjdgRS2WGc4s/Iq8tIXObc+Y6l46eNacR+Oq7yXp6QedZP8L2RphOFUNOn/MNbmDfCbnb5dW939D7FE6s8nHGloX8bhlfz+EJw5InbkFN2bRELEsIRH92WKzs88MsDmrjI7sjaqTezIcU/z+3EV40iB2v81aynCpseMeQYDzAuGXM//Ef3RZVDM2ctx2c3lRPIcU/WAsvQJ+lCO31lhOI1ytK9YZMytB0WbgBFHTFH/bSzAHlc4AtP5GAyRumcySD41rk/RrvcAdX/zCd/nxRmJG+la5cdX4u2Ri9tC1GO4DUVOSwQdWfBmq49Dpb+PnIi0UhTTxqRhGEIDNZFqS5RbjIu+ierKdDyTIj2HRcTxx5iYksQpABnnZO+6PVk5FtI+O/ipZuseqmG9+uNXeG9B5/iCl000pqmGBKV7JyPxrpmOcF/lT748avK8LkXO7cVm/8NtOUsfNaZ68LMofmnF+WXlPgu9XUJPBYY8rWprLLaV70KNWMUWhZ2o0JT76BKGyRjD605AKBq2ybtsIsM3V4DCBaBEtap8Jbx90TK8+R29H5O+N7roc5Jq4IUthr8WKi9jfRWQEfRfWPbKPTh8fe0OL125TsYjclj2EJO5E2fbrP8Ku13PQuuefYO/+TH+yBY2Kmq8gzQDYuaXYIjt0iAT1qo9/QkxAGkwReoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(376002)(136003)(346002)(66556008)(66446008)(6506007)(478600001)(6512007)(316002)(6486002)(41300700001)(83380400001)(91956017)(76116006)(4326008)(64756008)(66946007)(66476007)(8676002)(36756003)(2616005)(71200400001)(38070700005)(54906003)(6916009)(86362001)(8936002)(2906002)(38100700002)(5660300002)(122000001)(186003)(7416002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2ZheUJjcXpkcjVwSkhWN09TS1JxYjlwbElhVmZHWWtaSmtwNWhhQng1U0lZ?=
 =?utf-8?B?UnBGUTdYNVRRRU1jTkx4REN6RCtyZUtXQm1FU0JFNThTRzBIV2FLazQ2Uytu?=
 =?utf-8?B?ZzQrOTlTNGpRbEpHTWNJc3BnZDRHV3ZScVpMbCthclpsd2w1N3UrTnZJTFdq?=
 =?utf-8?B?ams1bXpWNlBYSUNyZlJ3RXBOd2dPNU1NdzZHb013M0czSXV4c2ZDMVVpNXdH?=
 =?utf-8?B?SGNPalFkYmxqamNZclhTMC9HbG14K1VEd0IrVUljUE1Rb0hwNmV4WHJvSGVV?=
 =?utf-8?B?aWdMSFNldjBvRjFJalZQMXBYRTRwTjU1Y2ZUOVAvQmxUU1NjdFM3b1NLUUFY?=
 =?utf-8?B?eG1INzVOU2s0bVM1a2I4NGhiQkUvMTRiYVpLNGFCSWdHbGM2R2gzMStNMlZY?=
 =?utf-8?B?OWhuS3A4TUd2bjV4U0F3bysxcFRyOEJZTnE2dEFQTTRvNW56cTFjZlA5ZS8z?=
 =?utf-8?B?S2FUY1BkNmxhZkwwdHg2YkFpZGMvMjgvTHJvRFRZaTZMcVA4dUJDZnZsWXJo?=
 =?utf-8?B?a01sMEpQa2EvcHUyalJFSnplMWtvbDVXOXcwa2VsM203L2NoM1VlU3Flenky?=
 =?utf-8?B?NS9XUHdTV2Y2RzF3Smxncm1PVXdobDBYdXo3aDZJWk0yNkpwbTRqOERXL1lM?=
 =?utf-8?B?bkZqODYySXZwa1pVb2VTWGIxVUNYVllWcnp1UTIyMFpWUnNhbVNrY2dTWjZR?=
 =?utf-8?B?Z1E0MnowaDRuL0hRNmtkTmFDTVdyeU9YbjByNUR0c1ZqaGN4MWpWemp4Y0JI?=
 =?utf-8?B?Z0IydXgzUTAwd3dHQm0xV3Npb2dhTVg2dlFnaWVuUkl3UmNuenRld3Yvb0VS?=
 =?utf-8?B?VnVZNHZreGovTHFJeTlINitFU3Q0dG84UHV2eGQ2ekpOdklZQTg1RlNVeEU2?=
 =?utf-8?B?My9tZzVseW9pbEtERlNQTHh6bk94VTVicWdoUmMrSEdwWE9ESXlKZ0NyYkQv?=
 =?utf-8?B?d2Z3MTg2TDZiV2RKVEcrYzgrcW5BeDJLbyszaWRobkRSbG5ZSHU5S0licDla?=
 =?utf-8?B?d21kRVk2OWZoWUd5NWdpcVJLdGZzTzhCTzYwTUhoVUtLSDZmN0o1a0toai9Z?=
 =?utf-8?B?ZkdzK3NkNzROVk4zZlpWUzNjemxSbHJSRVZPRkN0dXdIWVJwbC9TWlN3dFV4?=
 =?utf-8?B?ZnpoNStWcWZpWmlmNDNwK2l6WEVRWGhTdE42dU1zWlZ1NXZ4Q3lTOVU5bHNH?=
 =?utf-8?B?TWw5YlQwcTZKUEdXZkdyRE1vUXFaMnJPSnM0SStMRG9WazhXMjZsRExEL1pK?=
 =?utf-8?B?RXpEMjNRZFBNR0VQMWtDaVZ1Qk4vUmtrVnAxUUxBQnVSWUUvSWxMa0dTOG1B?=
 =?utf-8?B?TTM3eXltMFViZ2dTQzVWQ2lhenF3SFQ0SmhDRnY5SUdLWHd6T210ais2Z0pJ?=
 =?utf-8?B?YmEwM0N3a1AzSE5nVU5XeUwvU3VaTWtudERuQnB0U085c2hFbkxUdnFJdWpt?=
 =?utf-8?B?ZHlIUlk1MDNMR3o3Ynd0UGQ2L3F0TU1zZzl3Nk1uVDRNRUVoeklhOUJpN2N4?=
 =?utf-8?B?ai9iYjBTYXlNcEFrOXVwQUNBVjBRM3U4VWtVZFprRW5PY0tVSmlkaFB2Y1RO?=
 =?utf-8?B?SXZNVkJXRkh1R2ZHaGU1R1VXbHNUSVd4QzRRL0Q3VC9tUUNuM1ZXL2M2b0lG?=
 =?utf-8?B?RU9vRmdMYkovZzVXMjl1cXhtWlJQWjRkMnBRL3pSc3RYQjMyU0RCTVUreklQ?=
 =?utf-8?B?ajBaN0dqK2dtQVllL1dRd2swYytmaFEvQjl1Z3BZc25SNUV0eCtBZFlKZjNu?=
 =?utf-8?B?VDhrSCtsMXMvZ0dsNTBZUldUYXR4N0xyMlhSMVdBNVVLeGNRc21mUlNnMUEr?=
 =?utf-8?B?RytaODNQTisxVnM4VGtkL1pPbTg2TjFXRTQ4dHp0Y3JWSnBJa0V0b2xCWlBE?=
 =?utf-8?B?ZkxlbWpKTFZ1NzNlMEhZZ1dWcURDMWFYOXdHam5razZ4TmxCWWZuNmdUSHJt?=
 =?utf-8?B?NTZHWlMrT0V6SVFxSGxNSWdRdFVSblVBRmlOUitMSWNsS09JQ0pUMWh2WkxF?=
 =?utf-8?B?MmpUT3k2SzIvbi96SGFHNWRZM3Q4UVpxN3dVQXN0aVhndjZ3VS9YTStlRjdQ?=
 =?utf-8?B?b0tKbUtSL2t6WnA4L1F4K1dtU25LVE52UXpQWmVHRHhuT2F5ZnRadzY0dUJQ?=
 =?utf-8?B?bm5RVHRwRlNZeWJsUDZlTnBFeHU3cWZDMHY5blFPV09VUVdEbkljTWk4TkpH?=
 =?utf-8?B?M2hLTGE5Z0dsajRJZko5d3FOSzNhTGg0NkorV1NLTFJkcXFsNytEZTRKbXk2?=
 =?utf-8?Q?+IcsUoFPxWGlhSIYKF/QGTBgxzdeW3geOnglU2KFJ8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B3E64E688CA99478A0BB999D369B327@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64cfa0d7-9fac-4614-98f5-08da699f1bdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 15:55:31.4036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f2XbE0yXcgamLS1FeMBZxvMOxmmtqR1zK8mYLQwX906AFwRRSA2hBRsRvqnmuzgs2SSwWX69VV90DKxkNO6VTtV7uqCdGzzSTmmXlKi3ChM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6745
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFR1ZSwgMjAyMi0wNy0xOSBhdCAxNDowNCArMDMwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IE9uIFR1ZSwgSnVsIDEyLCAyMDIyIGF0IDA5OjMzOjA0UE0gKzA1MzAsIEFydW4gUmFt
YWRvc3Mgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBhZGQgdGhlIGNvbW1vbiBrc3pfc2V0X3htaWkg
ZnVuY3Rpb24gZm9yIGtzeiBzZXJpZXMNCj4gPiBzd2l0Y2gNCj4gPiBhbmQgdXBkYXRlIHRoZSBs
YW45Mzd4IGNvZGUgcGh5bGluayBtYWMgY29uZmlnLiBUaGUgcmVnaXN0ZXINCj4gPiBhZGRyZXNz
IGZvcg0KPiA+IHRoZSBrc3o4Nzk1IGlzIFBvcnQgNSBJbnRlcmZhY2UgY29udHJvbCA2IGFuZCBm
b3IgYWxsIG90aGVyIHN3aXRjaA0KPiA+IGlzDQo+ID4geE1JSSBDb250cm9sIDEuDQo+ID4gVGhl
IGJpdCB2YWx1ZSBmb3Igc2VsZWN0aW5nIHRoZSBpbnRlcmZhY2UgaXMgc2FtZSBmb3INCj4gPiBL
U1o4Nzk1IGFuZCBLU1o5ODkzIGFyZSBzYW1lLiBUaGUgYml0IHZhbHVlcyBmb3IgS1NaOTQ3NyBh
bmQNCj4gPiBsYW45NzN4IGFyZQ0KPiA+IHNhbWUuIFNvLCB0aGlzIHBhdGNoIGFkZCB0aGUgYml0
IHZhbHVlIGZvciBlYWNoIHN3aXRjaGVzIGluDQo+ID4ga3N6X2NoaXBfZGF0YSBhbmQgY29uZmln
dXJlIHRoZSByZWdpc3RlcnMgYmFzZWQgb24gdGhlIGNoaXAgaWQuDQo+ID4gDQo+ID4gU2lnbmVk
LW9mZi1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyAgIHwgNTcN
Cj4gPiArKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmggICB8ICA4ICsrKysNCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9sYW45Mzd4X21haW4uYyB8IDMyICstLS0tLS0tLS0tLS0NCj4gPiAgZHJpdmVycy9uZXQv
ZHNhL21pY3JvY2hpcC9sYW45Mzd4X3JlZy5oICB8ICA5IC0tLS0NCj4gPiAgNCBmaWxlcyBjaGFu
Z2VkLCA2NiBpbnNlcnRpb25zKCspLCA0MCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gaW5kZXggMGNiNzExZmNmMDQ2
Li42NDlkYTRjMzYxYzEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3pfY29tbW9uLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uYw0KPiA+IEBAIC0yODQsNiArMjg0LDEwIEBAIHN0YXRpYyBjb25zdCB1MzIga3N6ODc5
NV9tYXNrc1tdID0gew0KPiA+ICB9Ow0KPiA+IA0KPiA+IA0KPiA+ICArdm9pZCBrc3pfc2V0X3ht
aWkoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsDQo+ID4gcGh5X2ludGVyZmFjZV90
IGludGVyZmFjZSkNCj4gPiArew0KPiA+ICsgICAgIGNvbnN0IHU4ICpiaXR2YWwgPSBkZXYtPmlu
Zm8tPmJpdHZhbDsNCj4gPiArICAgICBjb25zdCB1MTYgKnJlZ3MgPSBkZXYtPmluZm8tPnJlZ3M7
DQo+ID4gKyAgICAgdTggZGF0YTg7DQo+ID4gKw0KPiA+ICsgICAgIGtzel9wcmVhZDgoZGV2LCBw
b3J0LCByZWdzW1BfWE1JSV9DVFJMXzFdLCAmZGF0YTgpOw0KPiA+ICsNCj4gPiArICAgICBkYXRh
OCAmPSB+KFBfTUlJX1NFTF9NIHwgUF9SR01JSV9JRF9JR19FTkFCTEUgfA0KPiA+ICsgICAgICAg
ICAgICAgICAgUF9SR01JSV9JRF9FR19FTkFCTEUpOw0KPiA+ICsNCj4gPiArICAgICBzd2l0Y2gg
KGludGVyZmFjZSkgew0KPiA+ICsgICAgIGNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX01JSToNCj4g
PiArICAgICAgICAgICAgIGRhdGE4IHw9IGJpdHZhbFtQX01JSV9TRUxdOw0KPiA+ICsgICAgICAg
ICAgICAgYnJlYWs7DQo+ID4gKyAgICAgY2FzZSBQSFlfSU5URVJGQUNFX01PREVfUk1JSToNCj4g
PiArICAgICAgICAgICAgIGRhdGE4IHw9IGJpdHZhbFtQX1JNSUlfU0VMXTsNCj4gPiArICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+ICsgICAgIGNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX0dNSUk6DQo+
ID4gKyAgICAgICAgICAgICBkYXRhOCB8PSBiaXR2YWxbUF9HTUlJX1NFTF07DQo+ID4gKyAgICAg
ICAgICAgICBicmVhazsNCj4gPiArICAgICBjYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSToN
Cj4gPiArICAgICBjYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9JRDoNCj4gPiArICAgICBj
YXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9UWElEOg0KPiA+ICsgICAgIGNhc2UgUEhZX0lO
VEVSRkFDRV9NT0RFX1JHTUlJX1JYSUQ6DQo+ID4gKyAgICAgICAgICAgICBkYXRhOCB8PSBiaXR2
YWxbUF9SR01JSV9TRUxdOw0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgZGVm
YXVsdDoNCj4gPiArICAgICAgICAgICAgIGRldl9lcnIoZGV2LT5kZXYsICJVbnN1cHBvcnRlZCBp
bnRlcmZhY2UgJyVzJyBmb3INCj4gPiBwb3J0ICVkXG4iLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICBwaHlfbW9kZXMoaW50ZXJmYWNlKSwgcG9ydCk7DQo+ID4gKyAgICAgICAgICAgICByZXR1
cm47DQo+ID4gKyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICBpZiAoaW50ZXJmYWNlID09IFBIWV9J
TlRFUkZBQ0VfTU9ERV9SR01JSV9JRCB8fA0KPiA+ICsgICAgICAgICBpbnRlcmZhY2UgPT0gUEhZ
X0lOVEVSRkFDRV9NT0RFX1JHTUlJX1JYSUQpDQo+ID4gKyAgICAgICAgICAgICBkYXRhOCB8PSBQ
X1JHTUlJX0lEX0lHX0VOQUJMRTsNCj4gPiArDQo+ID4gKyAgICAgaWYgKGludGVyZmFjZSA9PSBQ
SFlfSU5URVJGQUNFX01PREVfUkdNSUlfSUQgfHwNCj4gPiArICAgICAgICAgaW50ZXJmYWNlID09
IFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9UWElEKQ0KPiA+ICsgICAgICAgICAgICAgZGF0YTgg
fD0gUF9SR01JSV9JRF9FR19FTkFCTEU7DQo+IA0KPiBJJ20gY29uZnVzZWQgdG8gc2VlIFJHTUlJ
IGRlbGF5IGhhbmRsaW5nIGJvdGggaW4ga3N6X3NldF94bWlpKCkgYW5kDQo+IGluDQo+IGxhbjkz
N3hfcGh5bGlua19tYWNfY29uZmlnKCksIGNhbGxlZCBpbW1lZGlhdGVseSBhZnRlcndhcmRzIHZp
YQ0KPiBkZXYtPmRldl9vcHMtPnBoeWxpbmtfbWFjX2NvbmZpZygpLiBDYW4geW91IGV4cGxhaW4g
dGhlIGRpZmZlcmVuY2VzDQo+IGJldHdlZW4gUF9SR01JSV9JRF9JR19FTkFCTEUgaW4gcmVnc1tQ
X1hNSUlfQ1RSTF8xXSBhbmQNCj4gUkdNSUlfMV9SWF9ERUxBWV8yTlMNCj4gaW4gUkVHX1BPUlRf
WE1JSV9DVFJMXzQ/DQoNCkluIGxhbjkzN3ggUkdNSUkgZGVsYXlzIGFyZSBtYW5hZ2VkIGJ5IGRs
bCByZWdpc3RlciB3aGljaCBpcyBub3QNCnN1cHBvcnRlZCBpbiBvdGhlciBrc3ogc3dpdGNoZXMu
IFJFR19QT1JUX1hNSUlfQ1RSTF80IGFuZCBDVFJMXzUgYXJlDQpjb250cm9sbGVkIGJ5IHRoZSBQ
X1JHTUlJX0lEX0lHX0VOQUJMRSAmIFBfUkdNSUlfSURfRUdfRU5BQkxFIGJpdC4gU28gSQ0KaGF2
ZSBtb3ZlZCB0aGUgZ2VuZXJpYyBwb3J0aW9uIG9mIGltcGxlbWVudGF0aW9uIGluIGtzel9zZXRf
eG1paSBhbmQNCnByb2R1Y3Qgc3BlY2lmaWMgaW1wbGVtZW50YXRpb24gdGhyb3VnaCBwaHlsaW5r
X21hY19jb25maWcgaG9va3MuDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgIC8qIFdyaXRlIHRoZSB1
cGRhdGVkIHZhbHVlICovDQo+ID4gKyAgICAga3N6X3B3cml0ZTgoZGV2LCBwb3J0LCByZWdzW1Bf
WE1JSV9DVFJMXzFdLCBkYXRhOCk7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyB2b2lkIGtz
el9waHlsaW5rX21hY19jb25maWcoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQNCj4gPiBwb3J0
LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBtb2Rl
LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBwaHls
aW5rX2xpbmtfc3RhdGUNCj4gPiAqc3RhdGUpDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uaA0KPiA+IGluZGV4IGRiODM2YjM3NjM0MS4uOTBmM2VjOWRkYWVjIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiBAQCAt
MjE2LDYgKzIxNiwxMCBAQCBlbnVtIGtzel9zaGlmdHMgew0KPiA+ICB9Ow0KPiA+IA0KPiA+IC0t
DQo+ID4gMi4zNi4xDQo+ID4gDQo+IA0KPiANCg==
