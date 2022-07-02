Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C56564113
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiGBPfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGBPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:35:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C91B10AA;
        Sat,  2 Jul 2022 08:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656776102; x=1688312102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VSvyDcTYAB3cAxGSsbPOPuMOS0yLbU3qqP/Zk0pweMY=;
  b=YbJ8jER9bzn+Ol2EgA+rnv149wIS9oHQfk5tsNWOK+Ldp967cG8mRtES
   nHUt+UJjJUtZ76/lQ7q0hY+KBmAfpvB3QN83RgKr/FRxwRWMXM3ngoAC6
   KJAEAHmULQ8aeCrvpruUHiKpMKRRcwnmHQIzRJ1C5JWA86REWVuz9Z7+8
   k2n0W4Tldf2LSjnucO7BCm+OSxQn9HtSN8+ceGcLn7RsUvFNhKD8tuWVO
   TxcH+yC6UaI8SE1YkBILi4yLiOH1Tf15mnPdy8cgKt5wUhYozT64R2PGU
   HnUXtL6xZYgSGGYVDLnUKe+dw134ywhCEkb7USqC8v2adCDrgsduv95J7
   w==;
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; 
   d="scan'208";a="170531407"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2022 08:35:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 2 Jul 2022 08:35:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sat, 2 Jul 2022 08:35:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfZ/h3M+qVHSstfoZ2XB9wx14P+UgWn+2n12Zcdtqz+Zf44AHuNWkrj39AkPDaOv1RBwAn7Z5AnlDujQfSv7lXpL+yXR3ulqGA55rWCmfZpErREUnlixMfVVpisY0L5fOZecdNZ1jaC+nWvoeT254MAfa8/XCDUYu2xezvhiBNioZHHHGc1ZDBnr6WylVK4WfXL8HBFk/ofasFdyhhCH0LDEwKWSkYBn6M7OBgWLBCyAE/xijb+VWW/WU3jdbALANZ1eyotkpsyLvGyZqMWH3yGABqRnDTKRIEFzBV/8X/QU/auQGudl80DiVd+qxyULFnFyvQerKXbf4dQowsvcjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSvyDcTYAB3cAxGSsbPOPuMOS0yLbU3qqP/Zk0pweMY=;
 b=kNLgaGhKrY4MRkxeh2ruAiLmKnY+17djc/Y3aAaPFqv9zLdbwj/LV15JP/pZLnzimDjMIoZMkI45oSeA3etCog8ft/xeJfv5BBYgZ3gjNP+ongXt1LbqlUGfusBizKaUb9bULy5/o6ze097wRWf9WUR8JDGX7dOaYDfH7Y2E09VD4ycTyA5Xe4fu1/yJZOEWlkJXgNpeW0CLR3a1BJZu98KCPvCrkAInuEc84o+8FAygoxqRyRXUYXYzyDJQ6fQpo9IZNSniH3mEcC2Alk7v4HXmv8hEiTJ7dOWnLrz3jqj7GnW98K6E9Mz04EjDox+MFEDfrp91RWWyqrPRYJBxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSvyDcTYAB3cAxGSsbPOPuMOS0yLbU3qqP/Zk0pweMY=;
 b=WEiGdoHoMImu7l7wZMwcQSc/vNq/5h8/HvwQjO9Ff9N0w0CH0d23tpujVspckH2OIZmVCg2Lv/SyUgFEDlHYrclHXpGFTFjIVhMu1BVvfwBV1ZonRe7eTX0nt6BAL8nKKVusCSQEwMg5N0qS1q/0TK+KHkamqphZ9E143Bg5J1k=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BN6PR1101MB2356.namprd11.prod.outlook.com (2603:10b6:404:9c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 15:34:55 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 15:34:55 +0000
From:   <Conor.Dooley@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Topic: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Index: AQHYjRgQ3x7EmTGw/U+0JO50iJROM61pI3YAgAACHICAAhLLAA==
Date:   Sat, 2 Jul 2022 15:34:55 +0000
Message-ID: <06936f06-88d5-e3e2-dc23-9d4a87c0bf5e@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
 <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
 <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
In-Reply-To: <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c941b89-2c96-4be9-5236-08da5c4069fe
x-ms-traffictypediagnostic: BN6PR1101MB2356:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7kMlbQeLiRbOgWFtEwTtLocK9Pqd47QntUR7a6izmN5N9805CMtJyIuM2od5Rl1Xw5re+TjeqOcck+5FRPGfqmtERKkE0AAh93KhhjpSJX83Op0gyUxCVjlEI8ZrgjXiAEkLAfQQLhMo08c2Sc5pTGr9eQTaFAdrqWiGge8AFAk3EKPkBpSdv/RUlUbqQYUvMH7ofnnfewZTqPmxGOQiQ/uH8F2cI20fnBA860kv/D/8AObgXcmrP2xP2vb+WMUtUzCocCgpbwZ3EUQhH5rLtvEL44qz7Gr94/LLHOm83ylGfG34wRNnEpfALYmf1nBqCiiK0zOnKkuVPupfzm1dvwFsSEW+CD4VX6y3trqk+LuHylYCv47+6D3vpIAJTzgsJ0L/LVsEkeGaMAzrjWy0DanzawcxddxIFphvsL4j733dnlHnwZYLD39VmE4rMgwqGc5jme9BRfl3h2U5DenU9Q4bcun9Al1EaceZDXkqBD0Ijg95NXuy4RPDupyrs6bn4J05zXaNoSiZiepyR4mSPmpyRyEMsJ1UPzLvNpUbNBeFXAJImveOCicVMGl/DGgEtOA0m1gQGJdXfplUT9ptHjceq78WzfbrVdvG+1DBkeL1RKnhUGntRIxv+hbSEAtE4XUAWFbR9EIZXOmxLORmyhBUJ3D5d4rihwpzSwDdWMH6HOyfXXbW8dYt3WK8FbdmixREuEeiVSJyceDfWjfWD9EywktR26+ivWN6/ryyBFLBLmhEPEN3JzlTPd7Gp7xFeIjCI0/CroBG1YDmaK/pNqh3z+NGiQ5dol29ZWQdHRKoeMVBuf3dD9zRJI/Lk6yDk5J6LODlI6jUAN38rkmPbi4vRO5cTLaIbEgggDvvWBD8g6YSC+Fq/x9/sTzPwFym
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(83380400001)(38070700005)(316002)(4326008)(122000001)(38100700002)(66446008)(66556008)(66946007)(8676002)(66476007)(64756008)(76116006)(91956017)(2906002)(6506007)(8936002)(110136005)(26005)(7416002)(2616005)(6512007)(41300700001)(186003)(53546011)(5660300002)(71200400001)(6636002)(54906003)(31696002)(86362001)(36756003)(478600001)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVk0bC9HZTczZjYrR1h5R0VibnpNQk1EM3Vqc0h4U0pRR2VTTjMzZlVWcFVw?=
 =?utf-8?B?a3N6eUV3SEhiKzM2QzBsMEdzTXpXRVV4MzgyWWlTYnc4MDZlbStRQVZtR0My?=
 =?utf-8?B?TzlBanI0T0Rvbnh1cjRGUDVrVFVha3JiS3dFTDFGSFZ0OVFUWGpzdDh2Mklx?=
 =?utf-8?B?aTFUcmRMN2EzVDJPN3BlcXhsTWJkbFowdTM5VXRsL2RIeUZkb0ZSbHpjQkRx?=
 =?utf-8?B?ZEcyTER4UU11NUFxOHNROEFUNnUycGhmNU01M01XSVJwQno5OGRyUFo1cEp4?=
 =?utf-8?B?dmJVNUw3eFc3dUdaODVTZE8wa0pJY0hKcmFBZDB5bU5wTnU2M3dnUVoyYVYz?=
 =?utf-8?B?MzF3ekYzK3dFZHVORDAxbFNYeGNuQTVyTHIxaE5vZWpEdTBZbkIrKzkyNUtX?=
 =?utf-8?B?R0xPenRsUE5hVUl6d3FNa1NocG4wSW55aWRYRHQveHIrMlR6OG1EWUVUYTdq?=
 =?utf-8?B?SjBUVHAySCtmaEdyMzlFZFhkd1BOb1o0UDJEaVZscmtVSzd5YlZLY2JYYlE5?=
 =?utf-8?B?MFVvNE1kd0M0SC9DSTh5eXlPSml0bUowZDEvbWw0UFJUM2NXYlMvVXBpQVlq?=
 =?utf-8?B?aU5qeEFaQUZuOHY3cHorM0NmdUh1T0RlTHhldjE0VUNXKyt5aDVyTnVqVFJl?=
 =?utf-8?B?MHpPTVRBZm1NcGwvS3loVGk4RDRVcTg2Sjd3c3k5VXN5TEZ6YThLZWZPNTlR?=
 =?utf-8?B?UmJ2aWs1czJiS1BQWDdoK0lKUHh3cTJwVGh0K1NDSlNTZ0RXSlJtc0cwbU9x?=
 =?utf-8?B?bmlwWXNqOEk2RTloRTRLQzNVdnoyZjY2a2tQeHU3cHJ1d1pSR3JHdTIrK3M4?=
 =?utf-8?B?dTZPZE0vNEVrdXZpQ2RwSTNrV3pmTXRrTWZEa09kZzNiVExKNFVvdkpFSTZK?=
 =?utf-8?B?TFlkNWlyd1NERldIV1RFblZiUnBJaTU1R0ZHZHErVTZxN0g1MHdBVUwxWmNV?=
 =?utf-8?B?dmRJY2EzRUNSaFoxWndrWVg2QmpNbERqY09HTzFhZFNSdlJCTTRKMGo3OHcz?=
 =?utf-8?B?ZlZLRnQzUytGaFVWZXNMbW9yS2c5UUVubVcwUUIyZXRmSE1DS3BjRGExWjVM?=
 =?utf-8?B?ZktmeVNEeUJXdkZCWlBDTzBuSWJ0dU4wSlJBZHEvaGlMYkhVTHBod1BrbE9C?=
 =?utf-8?B?bGgxM0IyaVlmakg3UURXRkMxR2ZGU3FMSG1uMWJNQVlqcGdUUktoMDljeGdY?=
 =?utf-8?B?Q2V5b0FwQ2swRGo4T1lTL3Fid2FXbTRVT29Uc1ppVFlIbW44MVVxMHJ3SDRC?=
 =?utf-8?B?ZlJGVElMZWNlZVVvdk8zMU92UTBQNElBSHRPVXlEbkQrd0hPODd3dGNiWjU1?=
 =?utf-8?B?YXRWY0p4RVMwK2R5M3V2SjF5R1YxSi9FRm51NElraDhqQStNMjIyKzVXd01L?=
 =?utf-8?B?Y3NPRUszN2hUSENBN09zZ2tMRHF3aittSnl5VzFUUFl0bjRVN2l4OG5xQjZV?=
 =?utf-8?B?RGszNjY0ZmtuRFkzaUtadjRsZzJDbkxEKzA3WWlZbDJQMjZEWGdOOGJ5OVBE?=
 =?utf-8?B?VEtuMmZ2QjFZK1BjTUE3SktsOTJ4K1BUOGZmV1NYckhzZTZiR0VHbzJOWWVr?=
 =?utf-8?B?YkE3QkFKbGk3dkZlekx6UTlqcU42RzV2d2NaM0tpV2pBQ1JWM29tMjhZWFR5?=
 =?utf-8?B?Y3BRRytFRytnUWdiV1J2OTRlNkVmdkhRMkcwUm5GdUZteHpObXY2QnZMcXZN?=
 =?utf-8?B?K0wzNTNZdDUxLzZIMWRHUmlPK0dRVUtVV0hWdk9ObE04ei9tTXBoZEpqZWMy?=
 =?utf-8?B?WEVXRWlkYjZMM3NqaFM1MmdJNjhZUUM3QUVRQmk5LzRZQUx2aU5BOUE2Qkc3?=
 =?utf-8?B?aVB4TnFhRkRlcUhXdE9iOUgvWDM1ODN6bStkUnc0UW5jRmlhaWFWNm0veEF3?=
 =?utf-8?B?eVFHYWQyTU02eEtDOGpyeUNFOElsRDRxcU5EcnFUdXN3bUY4NytEeXl1eVBi?=
 =?utf-8?B?RlRwYXVFN1E0U093UjM4c1hlRXhZbEZMZzAxRlU4T0xSQUcvTnZCTG50WFYv?=
 =?utf-8?B?RmxBQjZsSjVyNXk5NXZRUzFXL2grb2FWMDZEWHFINzJUaFlCSlZzeW9QbWEx?=
 =?utf-8?B?dTRQSS9JUkw5dVdmOGY5clV6UVBid01Yd3IwSzZ0UGlYL3dOSktwOGdMS3RM?=
 =?utf-8?Q?yWqAEpHSJczcSNQlH3SiNAgLz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF566D1E0ECD4B44A446184990F164F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c941b89-2c96-4be9-5236-08da5c4069fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 15:34:55.1971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F2b/gFqQuau0bSWrZSE9rvrkfi6YkNZu/9eDOpg/GFxtCpPcbHxQsCg7GmPiRoO7ycSkR4z/gB1zEKPG99ixwHS65fKC31tjodR4IfxoS+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2356
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEvMDcvMjAyMiAwODo1NSwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBPbiAwMS8wNy8yMDIy
IDA4OjQ3LCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90ZToNCj4+IE9uIDAxLjA3LjIwMjIg
MDk6NTgsIENvbm9yIERvb2xleSB3cm90ZToNCj4+PiBUbyBkYXRlLCB0aGUgTWljcm9jaGlwIFBv
bGFyRmlyZSBTb0MgKE1QRlMpIGhhcyBiZWVuIHVzaW5nIHRoZQ0KPj4+IGNkbnMsbWFjYiBjb21w
YXRpYmxlLCBob3dldmVyIHRoZSBnZW5lcmljIGRldmljZSBkb2VzIG5vdCBoYXZlIHJlc2V0DQo+
Pj4gc3VwcG9ydC4gQWRkIGEgbmV3IGNvbXBhdGlibGUgJiAuZGF0YSBmb3IgTVBGUyB0byBob29r
IGludG8gdGhlIHJlc2V0DQo+Pj4gZnVuY3Rpb25hbGl0eSBhZGRlZCBmb3IgenlucW1wIHN1cHBv
cnQgKGFuZCBtYWtlIHRoZSB6eW5xbXAgaW5pdA0KPj4+IGZ1bmN0aW9uIGdlbmVyaWMgaW4gdGhl
IHByb2Nlc3MpLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQ29ub3IgRG9vbGV5IDxjb25vci5k
b29sZXlAbWljcm9jaGlwLmNvbT4NCj4+PiAtLS0NCj4+PiDCoCBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMjUgKysrKysrKysrKysrKysrKystLS0tLS0tDQo+Pj4g
wqAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+Pj4N
Cj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+PiBpbmRleCBk
ODkwOThmNGVkZTguLjMyNWYwNDYzZmQ0MiAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4+IEBAIC00Njg5LDMzICs0Njg5LDMyIEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgbnA0X2NvbmZpZyA9IHsNCj4+PiDCoMKgwqDCoMKg
IC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+Pj4gwqAgfTsNCj4+PiDCoCAtc3RhdGlj
IGludCB6eW5xbXBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KDQpJIG5vdGlj
ZWQgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIG9kZGx5IHBsYWNlZCB3aXRoaW4gdGhlIG1hY2JfY29u
ZmlnDQpzdHJ1Y3RzIGRlZmluaXRpb25zLiBTaW5jZSBJIGFtIGFscmVhZHkgbW9kaWZ5aW5nIGl0
LCB3b3VsZCB5b3UgbGlrZQ0KbWUgdG8gbW92ZSBpdCBhYm92ZSB0aGVtIHRvIHdoZXJlIHRoZSBm
dTU0MCBpbml0IGZ1bmN0aW9ucyBhcmU/DQoNCj4+PiArc3RhdGljIGludCBpbml0X3Jlc2V0X29w
dGlvbmFsKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+Pg0KPj4gSXQgZG9lc24ndCBz
b3VuZCBsaWtlIGEgZ29vZCBuYW1lIGZvciB0aGlzIGZ1bmN0aW9uIGJ1dCBJIGRvbid0IGhhdmUN
Cj4+IHNvbWV0aGluZyBiZXR0ZXIgdG8gcHJvcG9zZS4NCj4gDQo+IEl0J3MgYmV0dGVyIHRoYW4g
enlucW1wX2luaXQsIGJ1dCB5ZWFoLi4uDQo+IA0KPj4NCj4+PiDCoCB7DQo+Pj4gwqDCoMKgwqDC
oCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7DQo+
Pj4gwqDCoMKgwqDCoCBzdHJ1Y3QgbWFjYiAqYnAgPSBuZXRkZXZfcHJpdihkZXYpOw0KPj4+IMKg
wqDCoMKgwqAgaW50IHJldDsNCj4+PiDCoCDCoMKgwqDCoMKgIGlmIChicC0+cGh5X2ludGVyZmFj
ZSA9PSBQSFlfSU5URVJGQUNFX01PREVfU0dNSUkpIHsNCj4+PiAtwqDCoMKgwqDCoMKgwqAgLyog
RW5zdXJlIFBTLUdUUiBQSFkgZGV2aWNlIHVzZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFkeSAqLw0K
Pj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBFbnN1cmUgUEhZIGRldmljZSB1c2VkIGluIFNHTUlJIG1v
ZGUgaXMgcmVhZHkgKi8NCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnAtPnNnbWlpX3BoeSA9IGRl
dm1fcGh5X29wdGlvbmFsX2dldCgmcGRldi0+ZGV2LCBOVUxMKTsNCj4+PiDCoCDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKElTX0VSUihicC0+c2dtaWlfcGh5KSkgew0KPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldCA9IFBUUl9FUlIoYnAtPnNnbWlpX3BoeSk7DQo+Pj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgZGV2X2Vycl9wcm9iZSgmcGRldi0+ZGV2LCByZXQsDQo+Pj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiZmFpbGVkIHRvIGdldCBQ
Uy1HVFIgUEhZXG4iKTsNCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgICJmYWlsZWQgdG8gZ2V0IFNHTUlJIFBIWVxuIik7DQo+Pj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4+IMKg
IMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBwaHlfaW5pdChicC0+c2dtaWlfcGh5KTsNCj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkgew0KPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGRldl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0byBpbml0IFBTLUdUUiBQSFk6ICVkXG4iLA0K
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0
byBpbml0IFNHTUlJIFBIWTogJWRcbiIsDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXQpOw0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7
DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIH0NCj4+PiDCoMKgwqDCoMKgIH0NCj4+PiDCoCAtwqDC
oMKgIC8qIEZ1bGx5IHJlc2V0IEdFTSBjb250cm9sbGVyIGF0IGhhcmR3YXJlIGxldmVsIHVzaW5n
IHp5bnFtcC1yZXNldCBkcml2ZXIsDQo+Pj4gLcKgwqDCoMKgICogaWYgbWFwcGVkIGluIGRldmlj
ZSB0cmVlLg0KPj4+ICvCoMKgwqAgLyogRnVsbHkgcmVzZXQgY29udHJvbGxlciBhdCBoYXJkd2Fy
ZSBsZXZlbCBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUNCj4+PiDCoMKgwqDCoMKgwqAgKi8NCj4+
DQo+PiBUaGUgbmV3IGNvbW1lbnQgY2FuIGZpdCBvbiBhIHNpbmdsZSBsaW5lLg0KPj4NCj4+PiDC
oMKgwqDCoMKgIHJldCA9IGRldmljZV9yZXNldF9vcHRpb25hbCgmcGRldi0+ZGV2KTsNCj4+PiDC
oMKgwqDCoMKgIGlmIChyZXQpIHsNCj4+PiBAQCAtNDczNyw3ICs0NzM2LDcgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBtYWNiX2NvbmZpZyB6eW5xbXBfY29uZmlnID0gew0KPj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIE1BQ0JfQ0FQU19HRU1fSEFTX1BUUCB8IE1BQ0JfQ0FQU19CRF9SRF9Q
UkVGRVRDSCwNCj4+PiDCoMKgwqDCoMKgIC5kbWFfYnVyc3RfbGVuZ3RoID0gMTYsDQo+Pj4gwqDC
oMKgwqDCoCAuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPj4+IC3CoMKgwqAgLmluaXQgPSB6
eW5xbXBfaW5pdCwNCj4+PiArwqDCoMKgIC5pbml0ID0gaW5pdF9yZXNldF9vcHRpb25hbCwNCj4+
PiDCoMKgwqDCoMKgIC5qdW1ib19tYXhfbGVuID0gMTAyNDAsDQo+Pj4gwqDCoMKgwqDCoCAudXNy
aW8gPSAmbWFjYl9kZWZhdWx0X3VzcmlvLA0KPj4+IMKgIH07DQo+Pj4gQEAgLTQ3NTEsNiArNDc1
MCwxNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFfY29uZmlnID0gew0K
Pj4+IMKgwqDCoMKgwqAgLnVzcmlvID0gJm1hY2JfZGVmYXVsdF91c3JpbywNCj4+PiDCoCB9Ow0K
Pj4+IMKgICtzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIG1wZnNfY29uZmlnID0gew0K
Pj4+ICvCoMKgwqAgLmNhcHMgPSBNQUNCX0NBUFNfR0lHQUJJVF9NT0RFX0FWQUlMQUJMRSB8DQo+
Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTUFDQl9DQVBTX0pVTUJPIHwNCj4+PiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQo+Pg0KPj4gRXhjZXB0IGZv
ciB6eW5xbXAgYW5kIGRlZmF1bHRfZ2VtX2NvbmZpZyB0aGUgcmVzdCBvZiB0aGUgY2FwYWJpbGl0
aWVzIGZvcg0KPj4gb3RoZXIgU29DcyBhcmUgYWxpZ25lZCBzb21ldGhpbmcgbGlrZSB0aGlzOg0K
Pj4NCj4+ICvCoMKgwqAgLmNhcHMgPSBNQUNCX0NBUFNfR0lHQUJJVF9NT0RFX0FWQUlMQUJMRSB8
DQo+PiArwqDCoMKgwqDCoMKgwqAgTUFDQl9DQVBTX0pVTUJPIHwNCj4+ICvCoMKgwqDCoMKgwqDC
oCBNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQo+Pg0KPj4gVG8gbWUgaXQgbG9va3MgYmV0dGVyIHRv
IGhhdmUgeW91IGNhcHMgYWxpZ25lZCB0aGlzIHdheS4NCj4gDQo+IFllYWgsIEkgcGlja2VkIHRo
YXQgYi9jIEkgY29waWVkIHN0cmFpZ2h0IGZyb20gdGhlIGRlZmF1bHQgY29uZmlnLg0KPiBJIGhh
dmUgbm8gcHJlZmVyZW5jZSwgYnV0IGlmIHlvdSdyZSBub3QgYSBmYW4gb2YgdGhlIGRlZmF1bHQu
Li4NCg0K
