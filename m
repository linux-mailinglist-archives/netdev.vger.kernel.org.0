Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5F5663DA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiGEHUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGEHUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:20:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56F4A1A8;
        Tue,  5 Jul 2022 00:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657005600; x=1688541600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EESTty5lfxesod253zoBi71Y0BXZUKcZehHCcHWlJwc=;
  b=updvlOwtwajDyowOD5FHpJo7uGmGqJNo6bbiaYQR36a2gGbaQfhtHPAJ
   IUDaT2B5XtED5Ct380ctAe7OU+vOU9uGhWxL2vUXHiS994svfCyUKVmWT
   cr3dbG/gxljkCLmPiV4HJc+1g43GsN9oHmOcMe3PI5bJl86xEPVp7JfBl
   WKr1odV1ZtdkCivCn9DVqFExT5ccipC6UE+pyIOhPCx6kw4GPQbSCyDOR
   DbDr2PrU0TSNalm6F2fjTSZlikuU348lSLs5l5ZeZ0luzNoP/X7apjwPL
   VxC/XUQesbwENpt5jW+hQujIwsb0NCamwDILIWgCjutwCyNqQju3S4KgM
   g==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="171042917"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2022 00:20:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Jul 2022 00:19:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 5 Jul 2022 00:19:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvKqVGYGU3eouvgNgS6FKe6tStPTKlCK88z1CJI3cTcTnYNC3xnTdGZSfq6Wm9cuJN4yi6LLLfTSAgXrBPdKCiEL/eylHS8sl16HUySM/wYnZGp3A2qPa80zqSJwLEmM3f9KxHKjQT1243iFSxjjOCntuzl2jygGB0VzqPcWVBMu2uuOFhzvdhG9yuz82LqZY6cgHPvPzzluGTg92ADV3/4ryZHSO5Oy3lXyGGkNsdsAx9n8FG602PfdSSJMxotfatKtDP870svGbFM6yhbYJvLHQoqyrEoLwFpnbuajJJk+cZPM4V4A1j5YV6DTb5TF/TWfioBED46Sh7ihh+pHMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EESTty5lfxesod253zoBi71Y0BXZUKcZehHCcHWlJwc=;
 b=FbbCxLDCcF2zH6HIj0uS+IcLp1dtZG9D54RphwZCccl5FFGMgyvajea2wWe1jSzZCe7A905XolsmBCMNST5AvJvIzJaGn0KxPxzflHvDmZytTPiuFDjZLI6eUe0R1JmmqFOfLZs3G+k/rDFkcT1M4LzgmtDgBYOhIEIBALj+fAgpDVT+6a4ZzZdzaR3a1XSWNKcj4alycyDB8sa2j245ymCiSsy4JLvzWAUuGQ1X7DVEOTCpUu+zmk0F2FuJ53nN10HY4NmSqzi5GvEsWATqotRy+/Lued43PPGykoNEkGMqIrkMe62Yy1isC9Y5OIPI4g9S3G3GAwa969YGXx5jkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EESTty5lfxesod253zoBi71Y0BXZUKcZehHCcHWlJwc=;
 b=YZUd+C/8YhM9O3J/OkfbICBpuntZup1RqAYtoxjHh/hExcrfSa6VO/UB4bCIcFjzJnt4egRZrSrXP1kxUy2SkaisH/+8aG9oSV1NEYtvwJXJk4tCSbU6Wq3FYbVwzcQds1dFkivWZrFskfgtaSvcIVo0w487/ROOUNBVTlmEpLQ=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CH0PR11MB5739.namprd11.prod.outlook.com (2603:10b6:610:100::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 07:19:55 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 07:19:54 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Conor.Dooley@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v2 3/5] net: macb: unify macb_config alignment
 style
Thread-Topic: [net-next PATCH v2 3/5] net: macb: unify macb_config alignment
 style
Thread-Index: AQHYkD+fxScyJXAhvky7g4JpHN4i5A==
Date:   Tue, 5 Jul 2022 07:19:54 +0000
Message-ID: <8747ac2c-4363-4fc2-8139-08d21a778677@microchip.com>
References: <20220704114511.1892332-1-conor.dooley@microchip.com>
 <20220704114511.1892332-4-conor.dooley@microchip.com>
In-Reply-To: <20220704114511.1892332-4-conor.dooley@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3711fe4-865f-47f1-47e9-08da5e56c263
x-ms-traffictypediagnostic: CH0PR11MB5739:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oQ0tbSm61XXUx+v5bOjJEft/sZTBufXhy36lDNpb8GmDOCPds0CxWMotsTBbx+pUAIPgqIpbbAoniA/5aRJwmBdhillaRXwuZ9WssK/19MOBT86De+8tjIj7YEMTcDCtoVnTSc0ldEr8YBiogNQJ2pkNmdAtuqTtthaMtsJN174aJVohhLJ4mPuzQV+Go/+vtVDVuAyptMcmJexhrijK/ykz/LW0amUPiXRgnlmNn2LrBVGSEuwYI5VAIOBDAFhuZTmaxmbYtGd0zUwiBN7heJ1xjeYF0WbmuJ0CQ7L9RI+R6J+EZYk1QXRitx360F9GRmBr33j2xwJKR7r8fqWHm4+sPBN8zAq3jH/8kXTkbftWITkjRPFj9UPMpA5mUi8c+tj6OGYXK+RgNseSlURvsEiqcvgMXTLjSpVy6y97KhaJXL0BZnOiaiXKhrQoJHzdSJT9K0zxaClXhUXPWMIZVo1cNk3uWuMTziWsis6a50n8CG4laexvdOM7kHQZ+HGB02O83+iW+iM4f0q0sjQRWw1ujuQqdqakXttVA5346osYfyeRk0GNvDqtCFeNUakBy114/hFK2S0INEPBHZujqhXyH8zoAQfppWL07Hg9POCr0xpXhMfyChDstkhreBOhOxJjmw0kg75VLO78FTQff3sX8mQYKKpKeHAxLrfBsHy6wDOCRiuUernCqPrzxc6POEYmtyHerRBBiAO3xDFcs1P5x+X7sL04IJMVgZgfqhQZ4TDvzaQOeTq/8ZwmQZPV1Ua/75IATvU7HAaclticTt6GRKBap8cpaI9ZyCR1vEmUyKSvfW07yDk4E3tFVe48aF/WfU08EigJgMYe7DiyKah6uBqas2tcJVgsBXY5nynt7ryfkG+3xPM9tpgD49WA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(39860400002)(136003)(366004)(38100700002)(6506007)(31696002)(8676002)(76116006)(186003)(2616005)(86362001)(41300700001)(83380400001)(91956017)(6636002)(2906002)(53546011)(66476007)(66946007)(36756003)(66556008)(31686004)(110136005)(4326008)(316002)(122000001)(66446008)(64756008)(54906003)(71200400001)(26005)(8936002)(38070700005)(6512007)(478600001)(7416002)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlVSQ0NDMEZWYjViOS9XenIvTk5ZVkE2SXFITmVscE9FWHNTUEpDQTVIaXVM?=
 =?utf-8?B?blJHUGNadStrTnY5Y3Q2RFY4NklUY3JtWHB2OGNOby9pSzkrSW5XYXJoODRO?=
 =?utf-8?B?ZnM1WkNpUWlwTEdTcE9UVjFYTXBlRThsbndlamtZUmNrMy9ZUDVveWVnTyt1?=
 =?utf-8?B?eVJOQ2VkdFRqRERJMjV2NDMxczBTb3ZHZlhsQktndVFsNFoyaU1JL3plUGtR?=
 =?utf-8?B?VHhXaDNpS0hqZzBoQWJSeVQwTDlsN1hENHhvYVhycVdrVk0zbUxyeG1BanYw?=
 =?utf-8?B?b3Y5cHhMVVBZV0N6MGltWXl5bExQNGpwUmxNbjN1T1Z3VnpNRU1kL1JES0N3?=
 =?utf-8?B?Rlc1MElEcnlZU2F0Q3FEWWZCMlhCTzFvV1NNeGRId2lCMnAvUWN6VmgwUlEx?=
 =?utf-8?B?ZFFTSkdaZUV0RmphMWFxRnFnaTlkc0FhTGNTd1NvY0RRUHI0SDZEQzNRZWpy?=
 =?utf-8?B?MURhVEtvem5lVVZ5RFl4aHlVa2grNDdwTVE0MXM1Vnl6d0RyNCtTVU9SRnVZ?=
 =?utf-8?B?R1FqeGxMalROTTk3M2ZIZUMybWMzanhyS3V2VE5DUXdaNHhRYzRtVVYzWkRw?=
 =?utf-8?B?V3NWd040Sjl1ZXQ4dTFEYkYxWXhXcGNqWW5HaXZwUWdUOXNuWjJ3a2JETzVw?=
 =?utf-8?B?eWxQYkY2Q0l3djJ0RG1XM0JrWDRERjNOdzd4YU1QRXFFZ3MzWVo2Wk5UVzY5?=
 =?utf-8?B?VTV3djIySHlmQmhqekRnZmlaTjl2RzRNNFNBdGorazY4OVI3Qnk5bEpOTks0?=
 =?utf-8?B?Nmw1NEJQK0ZxVHBMY0Vnck00enNWdU9FckJac0hnaEYveVBCZFRGdkp5LzJW?=
 =?utf-8?B?bTFmK3RmNTZ0V1ZDS1dtQjYvamRuZnBpOUFhZmNSOU1kZ29oSDN6M2JvSjln?=
 =?utf-8?B?cDVQbmJEYWd1TFdIYS83dmdPZWY5ZVBnU3dPVVRUaTlzSXpuVnhHak9NSUF4?=
 =?utf-8?B?ZzRDTkQ1aDM0TURjWGVXZHFLUnJOcWZCMU9BbTUrRnpBR1VnbW1uVzRWWi85?=
 =?utf-8?B?eDRoN20yUVVZc0F3Tk0vWEJINVBCMUJlSTVGTzhPMGtXZTY5Um9xYTJGU0Y3?=
 =?utf-8?B?VzROS0lyd2pXOERnUU9vbjNuLzNzTTdNQW1qcmRMV1FuN2FGZUFGYzZCaHB5?=
 =?utf-8?B?Zks1MzMrYXVJdzZkNlVxOURRcGhiWlFZaUZHc3FmNEZzRitxZjYyaDM4MHZz?=
 =?utf-8?B?SDAydmF3cDczTzhGWU4vY1JoWWF0cGNGU1lqdWY1SlpUV0hPSmxXRHpTU0kx?=
 =?utf-8?B?eUJ4cmVjZ2pueHlSa3hGbnZ2Tm9Wd3JmNm5ITXlPWWJsQlUyZ2YrUnM0cmVL?=
 =?utf-8?B?VGQ1L2FYeG5vRDBEZ3RVRjRiU1I5RXZHZ1llaHhSTmpDVEYwUGdxNGF3QXBp?=
 =?utf-8?B?emxza2xVbFliZ1ZsWTdVM25CaTNoZlRreFpWa0JTUTBReHFPcWJNV01aRE5o?=
 =?utf-8?B?enpnOTFCK1ZNaDVkZUdKQnJKQ3RoRGYvcEhGZjFxeElGaktZaW5uV3RTWDcz?=
 =?utf-8?B?N1NrVXFsVnNBck5WaGN0Y0pzZ2tmQ1dKZExOdDJRaHFNSXB6Nktwa2lGUklx?=
 =?utf-8?B?aGV2U2dHZVVaR3RjZThhSnRyZGJlSldoTFRqczNrY251ZGN2U0o3QVNibjAv?=
 =?utf-8?B?cnVGaUJXY1JXS1dyNEQvNzhsL1VkWHNVSTBrUlhpamt1OWFaV0tPeDlZaFVx?=
 =?utf-8?B?SzB4T0ZHV1MwWUwzOVdyL2J0T053bEFYSjlFYTJ3K2VGaWRuNW84eTUxK25L?=
 =?utf-8?B?cGRKa3lKMmdlcW9aaThqdE9GVjgwWGtqcFNoT0VVMTEwWGxHZnRpdnA5SXZn?=
 =?utf-8?B?VnkyUkNRVUhYbHlnR2RVUHFRbnJVOFlnUWhSZGhSSlJsWDdlVWZwWGdVbVU5?=
 =?utf-8?B?K1B0dGYvNTJzWlJZWCtRM3dQRkJFbmZ2STVaUlFNYTZwb1h4ZklmV3dzRjZF?=
 =?utf-8?B?OTR4SjdVTUJqblltdjFqRldyT09xZmxGYW0zMEYxTmtSeXRkTXh1M1BuemY1?=
 =?utf-8?B?TWdJMFVOK1hQVXBHbmVYTUpkYUtyVE9seFcyWVdDbDMxSndaa3lhU0tBNDkz?=
 =?utf-8?B?QStJY1h2NDQzS2xIbWwzMUhyL1RKczN1R2w2ZU8xM01Xdjg4MzhsV0E1Q1B2?=
 =?utf-8?B?dXREZjMvd3JlTmtsU0U5Nm5PUVVFMWRDZWFVb01CcXZXUzBmOVpxUXlUMXZr?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAA0F1BA029A304AA85EC4B843FD1EB9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3711fe4-865f-47f1-47e9-08da5e56c263
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 07:19:54.7206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W0Og39OrXQSPhED/ShsVHzKCn0Qk1tnOuLIwtpedrD8nVq/nlXctCVTZiDnxzeCuF23nshPaL4DECnKOv3Tfb7g2whTx3a7N07RqMgxJ1Vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5739
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQuMDcuMjAyMiAxNDo0NSwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBUaGUgdmFyaW91cyBt
YWNiX2NvbmZpZyBzdHJ1Y3RzIGhhdmUgdGFrZW4gZGlmZmVyZW50IGFwcHJhY2hlcyB0bw0KDQpz
L2FwcHJhY2hlcy9hcHByb2FjaGVzDQoNCj4gYWxpZ25tZW50IHdoZW4gYnJva2VuIG92ZXIgbmV3
bGluZXMuIFBpY2sgb25lIHN0eWxlIGFuZCBtYWtlIHRoZW0NCj4gbWF0Y2guDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAxNiArKysr
KysrKy0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+
IGluZGV4IGQ0M2JjZjI1NmIwMi4uODVhMmUxZWE3ODI2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTQ2MjYsOCArNDYyNiw4IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgYXQ5MXNhbTkyNjBfY29uZmlnID0gew0KPiAgfTsN
Cj4gIA0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyBzYW1hNWQzbWFjYl9jb25m
aWcgPSB7DQo+IC0JLmNhcHMgPSBNQUNCX0NBUFNfU0dfRElTQUJMRUQNCj4gLQkgICAgICB8IE1B
Q0JfQ0FQU19VU1JJT19IQVNfQ0xLRU4gfCBNQUNCX0NBUFNfVVNSSU9fREVGQVVMVF9JU19NSUlf
R01JSSwNCj4gKwkuY2FwcyA9IE1BQ0JfQ0FQU19TR19ESVNBQkxFRCB8DQo+ICsJCU1BQ0JfQ0FQ
U19VU1JJT19IQVNfQ0xLRU4gfCBNQUNCX0NBUFNfVVNSSU9fREVGQVVMVF9JU19NSUlfR01JSSwN
Cj4gIAkuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPiAgCS5pbml0ID0gbWFjYl9pbml0LA0K
PiAgCS51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+IEBAIC00NjU4LDggKzQ2NTgsOCBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHNhbWE1ZDI5X2NvbmZpZyA9IHsNCj4g
IH07DQo+ICANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgc2FtYTVkM19jb25m
aWcgPSB7DQo+IC0JLmNhcHMgPSBNQUNCX0NBUFNfU0dfRElTQUJMRUQgfCBNQUNCX0NBUFNfR0lH
QUJJVF9NT0RFX0FWQUlMQUJMRQ0KPiAtCSAgICAgIHwgTUFDQl9DQVBTX1VTUklPX0RFRkFVTFRf
SVNfTUlJX0dNSUkgfCBNQUNCX0NBUFNfSlVNQk8sDQo+ICsJLmNhcHMgPSBNQUNCX0NBUFNfU0df
RElTQUJMRUQgfCBNQUNCX0NBUFNfR0lHQUJJVF9NT0RFX0FWQUlMQUJMRSB8DQo+ICsJCU1BQ0Jf
Q0FQU19VU1JJT19ERUZBVUxUX0lTX01JSV9HTUlJIHwgTUFDQl9DQVBTX0pVTUJPLA0KPiAgCS5k
bWFfYnVyc3RfbGVuZ3RoID0gMTYsDQo+ICAJLmNsa19pbml0ID0gbWFjYl9jbGtfaW5pdCwNCj4g
IAkuaW5pdCA9IG1hY2JfaW5pdCwNCj4gQEAgLTQ3MzEsOCArNDczMSw4IEBAIHN0YXRpYyBpbnQg
aW5pdF9yZXNldF9vcHRpb25hbChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgDQo+
ICBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFtcF9jb25maWcgPSB7DQo+ICAJ
LmNhcHMgPSBNQUNCX0NBUFNfR0lHQUJJVF9NT0RFX0FWQUlMQUJMRSB8DQo+IC0JCQlNQUNCX0NB
UFNfSlVNQk8gfA0KPiAtCQkJTUFDQl9DQVBTX0dFTV9IQVNfUFRQIHwgTUFDQl9DQVBTX0JEX1JE
X1BSRUZFVENILA0KPiArCQlNQUNCX0NBUFNfSlVNQk8gfA0KPiArCQlNQUNCX0NBUFNfR0VNX0hB
U19QVFAgfCBNQUNCX0NBUFNfQkRfUkRfUFJFRkVUQ0gsDQo+ICAJLmRtYV9idXJzdF9sZW5ndGgg
PSAxNiwNCj4gIAkuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPiAgCS5pbml0ID0gaW5pdF9y
ZXNldF9vcHRpb25hbCwNCj4gQEAgLTQ4MDYsOCArNDgwNiw4IEBAIE1PRFVMRV9ERVZJQ0VfVEFC
TEUob2YsIG1hY2JfZHRfaWRzKTsNCj4gIA0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2Nv
bmZpZyBkZWZhdWx0X2dlbV9jb25maWcgPSB7DQo+ICAJLmNhcHMgPSBNQUNCX0NBUFNfR0lHQUJJ
VF9NT0RFX0FWQUlMQUJMRSB8DQo+IC0JCQlNQUNCX0NBUFNfSlVNQk8gfA0KPiAtCQkJTUFDQl9D
QVBTX0dFTV9IQVNfUFRQLA0KPiArCQlNQUNCX0NBUFNfSlVNQk8gfA0KPiArCQlNQUNCX0NBUFNf
R0VNX0hBU19QVFAsDQo+ICAJLmRtYV9idXJzdF9sZW5ndGggPSAxNiwNCj4gIAkuY2xrX2luaXQg
PSBtYWNiX2Nsa19pbml0LA0KPiAgCS5pbml0ID0gbWFjYl9pbml0LA0KDQo=
