Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDC6661DCC
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 05:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbjAIEbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 23:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbjAIEax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 23:30:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AF012AAA;
        Sun,  8 Jan 2023 20:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673237548; x=1704773548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y1XTMjiHjbmVBArT3JYeBw9KUyfITILGDEnJVgaR6VU=;
  b=sRAZXPEPQ0OlIGSKZL9bsfSq7YEOH6BW5aqgm8viyTi/DmJT68CNB7RC
   rqGmqLnBV3bHuAR0g4EMrDi1CjpWLwslB/Ag2Cy8g2nPQIuYjlRPKEEEU
   rOv/Kj2WfochPb5OmIMHdtZ9NiVpjW49Hz8gdTT7PclHj9x5AyvqCc/5t
   +PBkHboYINiS9kpRq2SgS5MqVq0fJEYWHDeZA+VjvLQ9r+lBNMvMqehft
   1JziQYuj+rJarVdcqvNg31zRphadkIn4rB2dLJTftzNb4sb364tztizSs
   glEKlUoV3NOhV6m02bHdmX2Wn/nF+GaKgsMvYrJGDgD1yXRQdJsgUNHoF
   A==;
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="206897889"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2023 21:12:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 21:12:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 21:12:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1pEugJPHnOFksTR18LeuFgBnpPejbuMhNPNjEQzrrfRZIIzc7CzMY8y0Oa09eX9oda6TYgV+6unMVES4Vov05BEM4S2zje92VsB9v4zoQMaOpRFRgrvUMzyGF4lFGVaQaIGGrJljW+kIMj9DAGos8OHDcrP/hv5b+2DY2QvZtRXeAyFDKW3SVsrQMj/7wrsdfeMujLEf7rZO3RwJjGJQeadTAwRufSJMqr2X/loDGwomZwBqPmblk7ipr78La7YOFSxVEl6eAUOEI4Sz9XGso18+x+iWZToe/H7O6bix/IjnpDlCxJNmk2/6FExIU1xvxQQ5wPE6BpgAsBe0YYL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1XTMjiHjbmVBArT3JYeBw9KUyfITILGDEnJVgaR6VU=;
 b=Ks2buNXZhSPv9A9wqq8B8Gt72sTqfiNs0Ny3lM1fapeTNWZ5LyEv6XUQ9+7zQEYXmtve9uzYWFTEibSS2lfYZysg2O1GxPRsyqwCjmcWOmOAj25EaScBt4kRaoZl975zx9s7vyGhrjzjC92YpBTHTwN6X53uI3gCQX46feHpVEe3aQ+RtBTOk67S388PAT0I/Mu2grDAjdi9uGIqdaWpNp0mc1Wg4j+Qw4VDwo81rMKXHgyGrmJzQiPFcbiPQLUDzoL0JHkWZvEv9NFLt60TBAip1I+mc/S25YjF7NSAQkJDNG7PrpS/NLNlJiAMQgvgC+G+qOpeiKxznT9QBqHq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1XTMjiHjbmVBArT3JYeBw9KUyfITILGDEnJVgaR6VU=;
 b=cCT1z/qrQcLIiW2oS/iArvkpder/CRBV89P1uMFbedDCYY1UKJ00lafDbNiMa89rn/K2CAZjC7NsTw/f8uX5uGKnoaJ0VnjoU13dbFqNi5nFQFEGg6jlNWrGbKchfScqd2jyMfvVZUtKZjqMZ2YpYsxI4C6k8D9Ua9EoZFz8jS8=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB4934.namprd11.prod.outlook.com (2603:10b6:510:30::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 04:12:25 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 04:12:25 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pabeni@redhat.com>, <edumazet@google.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Topic: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
Thread-Index: AQHZIBj04D/wYVohdkulxgExYAbHM66Pm06AgAAWB4CABc+fgA==
Date:   Mon, 9 Jan 2023 04:12:25 +0000
Message-ID: <c4c160a824d53c52f55332b85d8941f9bdc78fd9.camel@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
         <20230104084316.4281-7-arun.ramadoss@microchip.com>
         <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
         <CANn89i+XJzpXycUE_iiyRYQ-f-EkkBCD5FtdvbYfBy8pvOZ5qw@mail.gmail.com>
In-Reply-To: <CANn89i+XJzpXycUE_iiyRYQ-f-EkkBCD5FtdvbYfBy8pvOZ5qw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB4934:EE_
x-ms-office365-filtering-correlation-id: 3b82f7dc-c68a-4038-1baf-08daf1f7b6c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byuZSfXtOx9FcXwS2+3dNYoa2biEKBmpH58tguDHjdssi/sSo70z1BkbzafjtLCzlxPUVqZXvOsRx13TjPJ1Q2R9okBe/7RI85volRDpNcfXLVyYy8k3GHZB8C8tPQ930CAUU1pGOYg7v9G19iMgtYoUj2RmwynrF+IzdEE9h0XjKVy1lfNipE+8KciPo2ZY5lP7PwjnHyoNaSsF63fsbesrsZh1JdTYEBOFZA5/USf95KcHKpZpZdLm94AAeWF5sk1+PCqLJbicB7qYgGmxNnijFrtyfI6zKkDy5vxltqMoFcckiYU5frOaezoE3RqK0/OaWpWcAYIkO8rKo2hKp8rNUaZJbEZ7Ihx/YwZEXNe58org2WB4d7fPckFiFi31kO/R884ZNw3x3ZtwSszCDS+5IAErZJnsi5r1k0rv/LBHity0vuSP0m6YBrY/h7d4UKYOHQKEhkNdI6k8hZD6PPczZtFB7TdeiwV8HzODKkTsNq1pY49affqTdO4dp2yUouFCVZ60p+ppl0f7R18ZO4Sh5WLlz3LmiUzGvpwSn9D620I/gFURE+aWqXbDwq1233reE8FLIWyFQInQV1dP8GUD+SGVEVvJTUrs8AIpSVkyycsjyDqce6K33li7Zv34xfhWEzFUVuwZDJq/g2cvBxC/ntYPkFKWrs8U+rB3iuwnhzZ0tNRqcbXPB8iKqpy+5EGfl9uM4NAvJQxpKMEQd7hPHav89164UMsr3xi/YNA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(39850400004)(136003)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(7416002)(71200400001)(66446008)(91956017)(66556008)(64756008)(66476007)(4326008)(76116006)(8676002)(316002)(66946007)(38070700005)(110136005)(54906003)(186003)(26005)(6512007)(122000001)(2616005)(38100700002)(83380400001)(86362001)(36756003)(6486002)(478600001)(6506007)(53546011)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2Qwd0dnZ1Jsc0dlRzdabUNGVWZvcWY3RG9NM0xCV1YybmtiZ1Nnb1VPcTI5?=
 =?utf-8?B?YnYzVTQyb2ZRM1kvbWQxUTZvTXhjRmVScXBrZzB0L29nMlJSMU1IRzNlT2Rx?=
 =?utf-8?B?YWl6US9jVllCcU1OVHZraUhtQTlvaFVGMWc1WlZHNEloK01HcVVjTGhNWkxO?=
 =?utf-8?B?bk9yRCtyblAyZGtHQjRoaUEvMTR3UHJKb3U4cGxOeFZzR2E0dzJsc21ZcW4r?=
 =?utf-8?B?RnlLZlkzaW9QUk9VelVUWEdTNEtwMTU4djdtTTlBL0FaWERpbGFYTnBUaTRH?=
 =?utf-8?B?eTE0WTZ5T3ZETXV4Nm8zTzdtclZrcUVBQU1NTkRhcFpTNytJdngzaFlQbHFY?=
 =?utf-8?B?T1JJVm1TOXZuSHcvS1RSTE5VSElXNmVSR1ZmQVRNV0kwMjBoa3hjUENlbXc3?=
 =?utf-8?B?bFhPMjFHc0Z2Mkhrczd4aCtkNVlpN2MrZmxheHJDVzcyN2dJUkpjZVpHVFZD?=
 =?utf-8?B?aDVKZTVjbVhmcDRKQklaZVh3dFZ6TDZsaWwzbW1QYlErZ1JXKzd3dUdIVG1S?=
 =?utf-8?B?MVBNUWNSK1A0emxlRFUzSGhMQ3lQZHViY0tydDIzK1ZpakNQU1BuQVc5TnNP?=
 =?utf-8?B?a1hVczFKOFNqL3I3QVR3M0tlajVUSXE5Mkp6Nkl2RGd0MTVvd1RLSmU2SERq?=
 =?utf-8?B?NkNZVmN1eEczcFpKeCtMTUtMRlhHTDZzL1J1b0E3dkhuQ0xRa1BNaU54eUIy?=
 =?utf-8?B?dk1FcjJKNy9Mc2lBUkFpQXh4WTM4dVMybUNEQWYyR1V3OE9xbEplc2NSaVht?=
 =?utf-8?B?L2tvVEw1V2hUOHo1YzNPcTlhVzJMVmFvajJ5cXdHamJjYk81b3pSWG1mZTVo?=
 =?utf-8?B?Z3R4MmozcVk2YVpYRzdhdFBXa0RMOFNjZlR2T3pBek5Td1dUb2V3MEs3aEFD?=
 =?utf-8?B?NUgrenlyVWJFcS9nMHlyY3poS25DNkFrRWQrUzY5Smw1WHgvMnlzcXVyMXh4?=
 =?utf-8?B?d0VlTkU3V25OcjFCNWtWeVc1NFNhcW9BU3pjUzhwWXJWS00wNmlPVWlaK2V3?=
 =?utf-8?B?VTlkaCtIYUgvenFFcE5CcXF6Z1l0bXdkdzBVNW1USWppN2xpdXNwNlBlK0t0?=
 =?utf-8?B?c0pMcGlnMXM4c3ZHY3hsUHlObU1Yem50SEpNcDZzMlRwRmhtV2VpYkllWWtV?=
 =?utf-8?B?bUFGL3F5SFIyT3owV3BiQWJZYVNBT0gwbnZjVjdId0pVQ2EwQ0c0MnFqY21v?=
 =?utf-8?B?aEowSVlHYUVIM1I2VVJDTysyQS8zREcyMnZkci9wUjVlVi9MWUZ6T1FsbU9o?=
 =?utf-8?B?aFVuS0h6UFBSd2VSbTd0UGlKcExkZTNuM25oaDR4VFlsNlA2dmVYUU4zcXNo?=
 =?utf-8?B?V1hwYlBtNlVvTzdmcjBBd0VOZWVCQkgzaWdRR3ZVbWE1L1hQcjB6MXZVYWZF?=
 =?utf-8?B?WDZnNVdqMkU1M1F1NTlWTk9SQ3lCeHBPVjNZSnpkWFFiMUp4WGVXYkVCRTVK?=
 =?utf-8?B?eTFLQ0hLMXdrVTNMZTFWK29OcEt0ZitGSUphU1N4VTV4OW1HMElLNG9IaVVO?=
 =?utf-8?B?dUJhVlVOV2dZNDh5ZEhCTUF3OE1lZ2JvWi9vQk81MWZhRk9FQ3NtdzdTMWRB?=
 =?utf-8?B?M1BaL3F2WWljRkJnc3FsZEZKbjUxVHhBZXVCcThYZGRJODI5dkJUUFFFRjlT?=
 =?utf-8?B?VExheW5rYUhreUc0SGVJNXBCbFh0L29tbnVrNTQ1TXFzdU9tWm9qWURpUGlL?=
 =?utf-8?B?ZFJBYnQwUTRGV2ppSThHZlJ2dzlkMmFBdnd5bGlEMGVXa2ZWbHFUTkwrT1ZE?=
 =?utf-8?B?TUJxQVNUcldhWDdmN2pJYmhxRFM3RDIrakxTY25wNWZiRDhkbTFEYmhvbG14?=
 =?utf-8?B?NVplV3JYbGw5QncrVGZOMkU5aGxUOUVVcktKZGR5dGgvZEplSHBMalNDR3ZD?=
 =?utf-8?B?NVg3UGdVRXluSzZxVDEyYk43RzdEaCsrLzNBSXJucDQ2S1c4bXVncW1OMit1?=
 =?utf-8?B?M1ovN1dUWWdweWdTNWtVbWkyTHZ2QUU5TnlURHl6WjY2MWlPUzlUQ2s1NjZx?=
 =?utf-8?B?RTBpaG9ZRnhXRGh2Smlkd0I2cWRybzlYVGNaVEczWEExaVNoN0ZXNERFVkNX?=
 =?utf-8?B?ME90YU5BWmI5b0dLSW1xSlJxc2RNVGNlRktwbmVCdjkwTzJMVG5DejJHVnh5?=
 =?utf-8?B?eHhIK1dZVnVHMlE5MzZWSGx4QUJXeGZhRm5UTFBGQjJNdjdidTBtcldrNzM2?=
 =?utf-8?Q?vtAtl2TsfQTwOKqgOHiHVXA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12FE3B4C2E0241439B0573052AE94A63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b82f7dc-c68a-4038-1baf-08daf1f7b6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 04:12:25.1777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RVseT1HAI1HPFbri+V1GVXoQOKBBQJ0J1InXq9SKcicfa5JaARibyCQSVBcQXBJezMSDbFg/jH7w7Kom9kF016nf+XB0enivPx8wyi3xKwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4934
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXJpYywNCk9uIFRodSwgMjAyMy0wMS0wNSBhdCAxMjoyNyArMDEwMCwgRXJpYyBEdW1hemV0
IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9u
IFRodSwgSmFuIDUsIDIwMjMgYXQgMTE6MDkgQU0gUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQu
Y29tPg0KPiB3cm90ZToNCj4gPiANCj4gPiANCj4gPiA+ICtzdGF0aWMgaW5saW5lDQo+ID4gPiAr
dm9pZCBwdHBfaGVhZGVyX3VwZGF0ZV9jb3JyZWN0aW9uKHN0cnVjdCBza19idWZmICpza2IsIHVu
c2lnbmVkDQo+ID4gPiBpbnQgdHlwZSwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgc3RydWN0IHB0cF9oZWFkZXIgKmhkciwgczY0DQo+ID4gPiBjb3JyZWN0aW9uKQ0KPiA+
ID4gK3sNCj4gPiA+ICsgICAgIF9fYmU2NCBjb3JyZWN0aW9uX29sZDsNCj4gPiA+ICsgICAgIHN0
cnVjdCB1ZHBoZHIgKnVoZHI7DQo+ID4gPiArDQo+ID4gPiArICAgICAvKiBwcmV2aW91cyBjb3Jy
ZWN0aW9uIHZhbHVlIGlzIHJlcXVpcmVkIGZvciBjaGVja3N1bQ0KPiA+ID4gdXBkYXRlLiAqLw0K
PiA+ID4gKyAgICAgbWVtY3B5KCZjb3JyZWN0aW9uX29sZCwgICZoZHItPmNvcnJlY3Rpb24sDQo+
ID4gPiBzaXplb2YoY29ycmVjdGlvbl9vbGQpKTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgIC8qIHdy
aXRlIG5ldyBjb3JyZWN0aW9uIHZhbHVlICovDQo+ID4gPiArICAgICBwdXRfdW5hbGlnbmVkX2Jl
NjQoKHU2NCljb3JyZWN0aW9uLCAmaGRyLT5jb3JyZWN0aW9uKTsNCj4gPiA+ICsNCj4gPiA+ICsg
ICAgIHN3aXRjaCAodHlwZSAmIFBUUF9DTEFTU19QTUFTSykgew0KPiA+ID4gKyAgICAgY2FzZSBQ
VFBfQ0xBU1NfSVBWNDoNCj4gPiA+ICsgICAgIGNhc2UgUFRQX0NMQVNTX0lQVjY6DQo+ID4gPiAr
ICAgICAgICAgICAgIC8qIGxvY2F0ZSB1ZHAgaGVhZGVyICovDQo+ID4gPiArICAgICAgICAgICAg
IHVoZHIgPSAoc3RydWN0IHVkcGhkciAqKSgoY2hhciAqKWhkciAtDQo+ID4gPiBzaXplb2Yoc3Ry
dWN0IHVkcGhkcikpOw0KPiA+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4gPiA+ICsgICAgIGRl
ZmF1bHQ6DQo+ID4gPiArICAgICAgICAgICAgIHJldHVybjsNCj4gPiA+ICsgICAgIH0NCj4gPiA+
ICsNCj4gPiA+ICsgICAgIC8qIHVwZGF0ZSBjaGVja3N1bSAqLw0KPiA+ID4gKyAgICAgdWhkci0+
Y2hlY2sgPSBjc3VtX2ZvbGQocHRwX2NoZWNrX2RpZmY4KGNvcnJlY3Rpb25fb2xkLA0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhkci0+Y29ycmVj
dGlvbiwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB+Y3N1bV91bmZvbGQodWhkci0NCj4gPiA+ID5jaGVjaykpKTsNCj4gPiA+ICsgICAgIGlmICgh
dWhkci0+Y2hlY2spDQo+ID4gPiArICAgICAgICAgICAgIHVoZHItPmNoZWNrID0gQ1NVTV9NQU5H
TEVEXzA7DQo+ID4gDQo+ID4gQUZBSUNTIHRoZSBhYm92ZSB3b3JrcyB1bmRlciB0aGUgYXNzdW1w
dGlvbiB0aGF0IHNrYi0+aXBfc3VtbWVkICE9DQo+ID4gQ0hFQ0tTVU1fQ09NUExFVEUsIGFuZCBz
dWNoIGFzc3VtcHRpb24gaXMgdHJ1ZSBmb3IgdGhlIGV4aXN0aW5nIERTQQ0KPiA+IGRldmljZXMu
DQo+IA0KPiBQcmVzdW1hYmx5IHNrYi0+aXBfc3VtbWVkIGNvdWxkIGJlIGZvcmNlZCB0byBDSEVD
S1NVTV9OT05FDQo+IA0KPiBOb3RlOiBpZiBJUFY0IFVEUCBjaGVja3N1bSBpcyB6ZXJvLCB3ZSBh
cmUgbm90IHN1cHBvc2VkIHRvIGNoYW5nZSBpdC4NCj4gDQo+IChOb3Qgc3VyZSBpZiB0aGlzIHBv
aW50IGlzIGFscmVhZHkgY2hlY2tlZCBpbiBjYWxsZXIpDQoNClRoaXMgZnVuY3Rpb24gaXMgY2Fs
bGVkIG9ubHkgZm9yIHRoZSBQZGVsYXlfUmVxL1Jlc3AgcGFja2V0IHByb2Nlc3NpbmcNCmZyb20g
dGhlIGhhcmR3YXJlIHdoZXJlIGNvcnJlY3Rpb24gZmllbGQgaXMgdXBkYXRlZCAmIGNoZWNrc3Vt
IGlzDQpyZWNvbXB1dGVkLiANCkFzIHBlciB0aGUgcmVjb21tZW5kYXRpb24sIENhbiBJIHNldCB0
aGUgc2tiLT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9OT05FDQppbiB0aGUgZnVuY3Rpb24gYWZ0ZXIg
cmVjb21wdXRpbmcgdGhlIGNoZWNrc3VtIGFuZCByZXN1Ym1pdCB0aGUgcGF0Y2guDQpLaW5kbHkg
c3VnZ2VzdC4gDQoNCj4gDQo+ID4gDQo+ID4gU3RpbGwgdGhlIG5ldyBoZWxwZXIgaXMgYSBnZW5l
cmljIG9uZSwgc28gcGVyaGFwcyBpdCBzaG91bGQgdGFrZQ0KPiA+IGNhcmUNCj4gPiBvZiBDSEVD
S1NVTV9DT01QTEVURSwgdG9vPyBPciBhdCBsZWFzdCBhZGQgYSBiaWcgZmF0IHdhcm5pbmcgaW4g
dGhlDQo+ID4gaGVscGVyIGRvY3VtZW50YXRpb24gYW5kL29yIGEgd2Fybl9vbl9vbmNlKENIRUNL
U1VNX0NPTVBMRVRFKS4NCj4gPiANCj4gPiBUaGFua3MhDQo+ID4gDQo+ID4gUGFvbG8NCj4gPiAN
Cg==
