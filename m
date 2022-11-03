Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA56178FF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiKCIpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiKCIpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:45:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF44D104;
        Thu,  3 Nov 2022 01:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667465099; x=1699001099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pdvOHDNdCBNJhtoQNqXueebwPl3UDtG/c7hkASw59fc=;
  b=gbMw7tNhy6ftQkT8b6sbQ/g4YRdfqg1oCcVCWF6bgeXG1z/8xEOiwxvU
   1G1dqiBYhKSRG4BOoSYt9sEGaTmV2v222on1IOp18XtQnqFHK5r2h3MUN
   enJt+jMePDiWc8fJ3hovl2ZgaYlwPlFmNw+gbV0+zM3spTlZdzGAkJtg0
   Xdl9y491pIxi8XD1V5Q2gXb/jbLH4MUDUBpgCCEOzM/wwTAo3+w1wnzCJ
   TMqGBJCuA0Mk2U0PV8TMH4SspUf5Bl/etTU75Fp2XGu5Z93e2kpX0sNpW
   2DB8Bzdd3KZSMeQk/vb42o3KcF/0DBeDcUE2In5nfMbHjY2c5buaA1yqj
   g==;
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="198212019"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2022 01:44:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 3 Nov 2022 01:44:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 3 Nov 2022 01:44:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcNlSlrBaS77gnlukrzH2z3vCSNbI3icv/Zgx/zuDeC4nRDHnNEKXICur7kYdUhfaCpg0e7JJ53uS5U+ivnCP3RmwZknyc2ikA3ee+Q7IMgT9oTp+ifSQMal2WFtDsWQeanFoKwtWxrkulVwNwDJoXYOva0RfivxGD9zIHWaG7wOURuBNP7ojequqBo12w1w6DM3oDATAharss4kPXtq8FItCumuFF1XIcqk5QmVPwhLyUtptirvRv0YkSmIdzUrPE3P0WhEZH3vnepqXPFEilWTKlnQjAkZkS95umEf4biZZnnhDEvNFem8M+/uFR2zYymbxxSMOfX1XjFPjnIbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdvOHDNdCBNJhtoQNqXueebwPl3UDtG/c7hkASw59fc=;
 b=LoWJRZ+4rdD8g0iZ3T8+JQVkWw2aX6dsaGXG1HVbH9BmFKyShTAfQRE+uiuEbU3XIbGSzhQK0q/kDj6hdDGvv/cOrUTpoR8BAx7qgFQSGQGY+ShP5Wxt5LkP0hKrjbEDaCh1YqNFTGCvDT73pGW7+dhCTc3nn6aN8Xxcqd8dgBur6mVgYiGWkXXgf8kcTRzge3Dzjjz4jJUAG1bPnA3/C7d9ba4zH4YLNy0ejh5XxYArGQsxY4my9rUz0xH5nbWxQpogCn9MR+nklGcKFbg1a0uGQ0YCiCnhCtfEHZnJJgyPvUOEQNzi951MnmsdHACn/zRDojsbxJzf1p/idJbVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdvOHDNdCBNJhtoQNqXueebwPl3UDtG/c7hkASw59fc=;
 b=UaGbpj0zP/Y7XvWckZyRVpV1mSkk/mC4JjVRTQbPrGA4vERn2Zu0mkUFtKJo/0mXdahIYpLSEdhkprS3S9hLH4ajvS+FA2DrARCdE7Knj6rKwElMkoCYSh+num1jn8zglS1lXxISBZMHu9WLD6Lr5LvqyzHKbeTONVaGTCehF+4=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by PH7PR11MB6353.namprd11.prod.outlook.com (2603:10b6:510:1ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 08:44:51 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::4340:6f79:9fb5:ca2a]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::4340:6f79:9fb5:ca2a%9]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 08:44:51 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <vivien.didelot@gmail.com>, <Woojung.Huh@microchip.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 1/6] net: dsa: microchip: lan937x: add regmap
 range validation
Thread-Topic: [PATCH net-next 1/6] net: dsa: microchip: lan937x: add regmap
 range validation
Thread-Index: AQHY7nGvyceDxKXtMUWQhFj2cSV9XK4r4KMAgAEC/YA=
Date:   Thu, 3 Nov 2022 08:44:51 +0000
Message-ID: <fcb582a7d4a396e19b9f6b62e743ce9666f3d371.camel@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
         <20221102041058.128779-2-rakesh.sankaranarayanan@microchip.com>
         <cc5dd02f-7285-dfcf-76b1-bb258c8029fb@gmail.com>
In-Reply-To: <cc5dd02f-7285-dfcf-76b1-bb258c8029fb@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|PH7PR11MB6353:EE_
x-ms-office365-filtering-correlation-id: ebb9520a-eac8-4502-84a8-08dabd77ac3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FuJ3xrPA/QHXgnDCyBnz7larb4/dIyD0Y/77rwcxah9TeM0DpDzIdldUfpxtzFAVf8qXtmCBMZQiL8hF+RlvD18oeheKf6cKZju35D/1549TWypNZz7bAvFHi+bpLRGn0PUxHjAxhqu4ecddVbq6LvZE/DdjF5ystDuykQ4iqFRnvfaYF+k3IlhgKZe86FIWrlAkqLrTaCOGSttD+OzweHThzbEvQMOxevz+c5+rEo/XSxuZof5DqiW9W4S1wWk8RH9aDcteuqv63ZrAlNQjizISyXk01TFpWokjmcR+C5lFNz3qnJ3FrPPnZriMsUnszewWGAmK6k5ctHtWhGbBFxG/sAo9D86X4JSCgNJKhxO506yeDNmTi6f/cE7YdjBhirLXdXyS7mibHiUzwB1efisvqYWCg76+Aa1A7YpQKRxHNVEtxSr4IdcJhMSf3fyZbCpNlXa0McAHSZ+GDMzIps+BVTG9+vZpd0o8ywASIBPqyxl48nG/vCH0b/EvbpUzhs6J156YSUoMSyTagClGvWfimOPaJoZkJLSrkJdILYhfXof/9zIv+DhxQy5nuEsBBYj9YIfJiXkFfzIxdz9I/Hcg7vUcu5VTcin0jgdNoGVJffP9OaQkN7/en/ybTnkVMMqxhVTOlWuP3Q1b308hdqTc19+VuK4x4uDkJucZCaWWdiDQxPtm7DQzak58z3n3cp/qi7Gkl5ASpr3bCbcR8vPwGKKrloxqZBKLTUxLLoDwJuz6gQJQOGWTnROY8O67AWS/TKDWDNTW+F2b8x9pag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(8676002)(91956017)(4326008)(86362001)(38070700005)(76116006)(7416002)(66946007)(110136005)(66556008)(64756008)(5660300002)(66446008)(66476007)(8936002)(316002)(478600001)(38100700002)(54906003)(122000001)(41300700001)(36756003)(6486002)(6506007)(107886003)(26005)(83380400001)(53546011)(71200400001)(2906002)(2616005)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2Y5M2lCR01rbnFjOUpZbHNncW44VUc0M2dBSnZtakJGNWlEU2pGMWxmTk40?=
 =?utf-8?B?RElLYU82RzFLZGE3bTBpUXkyTE9yVFJXbGlwaGlBYm5hZlVxRVNqV0hFZzlL?=
 =?utf-8?B?aWFoWHVSbTc3YzNLUHd0Z1FrcnRCY1UyeVVFWDlHV1VWVW5wNnp0a0ZyNHha?=
 =?utf-8?B?ZVMyVDJNaWxuU3ZTdUlUSUVoZVF5YTZXYmIxRU0vWXdWdWVWZThKT2NHLzZu?=
 =?utf-8?B?ZzZucGo5bXlnR1VodFFsTklzaE5FVWVCYm0yeE1JZ2hjdElCTFVHLzIxM3ls?=
 =?utf-8?B?RjBPQTZYUUpMcWJIWUdiVUNKNEpXRnNXdkZUakZvWXY0U0Q5STVGMnJ6ZEZP?=
 =?utf-8?B?VXZoL3hoOEZyTlJybFlQRmN5L1Uyclo0UkpnYWN1YmJpTUozdW9TcnVpUjN5?=
 =?utf-8?B?VHBuYVhIdHZGVTNGRGlKNnNWaGhvaFQ2cXR5Qmd0ckkyaGhyakxxNVpxT0FX?=
 =?utf-8?B?RUZTbmJvSkNCTFBKQUxWN1J4NVo4N1BqRkRwdWIrNllUcHdwdnV3em1vUjNt?=
 =?utf-8?B?L0RBQ1ZKcnIrWkJSMHdiQVJIRCsrclNaRXRlRDROak04RnpSN2kyeWUzN2E2?=
 =?utf-8?B?eTN0ekVVUWlYVys5TWt6L0FxSGtSdFM2RVUzYlJYZXJBK2F6d25IVWFTQkZv?=
 =?utf-8?B?Mm1SMXIwUjNNbTR2SE4wQ1pseXRHR0dVV2JaQkdJRXFKV0pFYVpJU3lWaFRR?=
 =?utf-8?B?M3R0Rkc3RmFjczdFck94cFNEUDhiTDk5YUZSU28xUkRTYm1xR3VycFNQZmhC?=
 =?utf-8?B?VUkvd1JsaUVKYXdRMkFFREpSdlNPeGpDUnFycnl0SDBVQ05NdkpXdS9semd1?=
 =?utf-8?B?UTJiRVhCQXBGVWZvblhOSmtMZUJuRlc1bGJmRXN1Z0ZrcmV2cjUrYytCeGFP?=
 =?utf-8?B?cHJNK2ljMWgwTEZZdlJHM3ZHVGdMeHd6d2VWR3pFczlQMW1Ec2R3TGJZcnZK?=
 =?utf-8?B?bmFGalc0ekI0WEQyVGFiNU5aOXdsL0MzYTJGS2lad2VKVHJvVkFMcWd5NjN5?=
 =?utf-8?B?cENQZ1ovRDRXaDhwQk1aTmFsaXNDeXg2bTAvQm1TWlFjVmp0MVE2LzlnQnBx?=
 =?utf-8?B?cFN2dENFNjJhVTZ2MkJoOEtMdjZkZ21UK0tmTDlFN2Z6Nm1ZQ0MweTdhNHF0?=
 =?utf-8?B?ak43NGs1RFpGYnkra0NoQzdKUmx4a2FmR1B0RGlIbGlTR1AxYUNaQlZUeHIw?=
 =?utf-8?B?dXRESC82SDh3MXQ2bUdCREh5U0cxVFFyY0JPSXEzQm5VS0h5MHUyaVBmcVdP?=
 =?utf-8?B?T3h1OHVHN3d2RDZBZG9sUldyOHRGRkFzVjBDbnhJbk0rRFptUmVjUWlJdlc3?=
 =?utf-8?B?Znk5YzBmSXZPUlpvSmJnMHlKdFBpbExEdWZkaGdHb252cGRvTnBZeStxdGlR?=
 =?utf-8?B?OHh2OFRPV0tKQ29KN1BKdncxbm9IUEZzN2JYejJtSkg0OWZvSElkNnlRaHEw?=
 =?utf-8?B?Qkg5ODZrRWxrL0pHZzBURi9IY0x5V2hLZGVJaWpkNlFBb1I3VmtFVmQrWVlQ?=
 =?utf-8?B?NDVwZXhhZnYzN215aTQxQ2dseXR2YmV6ZUwwQXVkb1FEMytIaGdTSlNqWWpT?=
 =?utf-8?B?ajNJZWtLNm1LRkdGS3k5di9seFh3bGt6UUh6T3c4TFZ5UnJzdjNUS2hMTjd4?=
 =?utf-8?B?RUZJZTM1L1gxazFYbkFkVVZOSy8yVU1vR0FrTnhTeGZUQ0F1ZVE2dzFHc2JQ?=
 =?utf-8?B?NXlYeDZqRjUybjJ2MDhydURYRDlVbGtQWHQ1QmJOamVuYUpWM3RjWlc3WGlw?=
 =?utf-8?B?SjN4ZTNmdHpxblBRMlo0djdINGpDb0k3OXZXcmxkRFFIZitvalEvRGtRSGhD?=
 =?utf-8?B?R294c3VGcXZUTkxhYXIxMXZHaS9OMkYvUGFCYmlpT2g4RGMyaFR6NFl0MEJ0?=
 =?utf-8?B?RDVNcVdwRm1HZDBPQVFJaTkwd1A1clJXY2crWkJIcmRRaXUwdENUVG1MOUo3?=
 =?utf-8?B?K080cmp0dHJTMkIvSFVWN091R0NNQTIzQUFhVjlTNlFFbmwwWWtKQzdpcUR2?=
 =?utf-8?B?ZlI0ZE9VL1V5VktYckFnMzcyQjFYYnhqWmpVd2tqZEY0NUhTZTV3VFlwUTJZ?=
 =?utf-8?B?WnZyTnZyWktiZGtJTWRwRWl6RW1jd1MyZ1ZRcWVsZ1BzOHE0SzBiaHV5STZs?=
 =?utf-8?B?OHgycG5GZUJkZEtwdnNYdHJCanRJTlNjM01MengwZXd1aGVxT2R1cVk1cFFO?=
 =?utf-8?Q?hg7AiC3SSxlb192KqqAa3bektxX7I5kwsOAs8qmpjWO5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FEBD4FB9AE6B2478A1B2AAC23F37847@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb9520a-eac8-4502-84a8-08dabd77ac3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 08:44:51.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G8O5Geh6kLjKmf496HlDvi2cHYGAjcaqDKmGWZkAUtmWLerzOqD6EfNK7NsqQx+bWUKz+ftou+za1zziwTYyh5H0z2/+FyJtiIEqUD2ms1SNjY19ljiL+3dPdzQbSwH2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6353
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTAyIGF0IDEwOjE1IC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVu
dHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIDExLzEv
MjIgMjE6MTAsIFJha2VzaCBTYW5rYXJhbmFyYXlhbmFuIHdyb3RlOg0KPiA+IEFkZCByZWdtYXBf
cmFuZ2UgYW5kIHJlZ21hcF9hY2Nlc3NfdGFibGUgdG8gZGVmaW5lIHZhbGlkDQo+ID4gcmVnaXN0
ZXIgcmFuZ2UgZm9yIExBTjkzN3ggc3dpdGNoIGZhbWlseS4gTEFOOTM3eCBmYW1pbHkNCj4gPiBo
YXZlIHNrdSBpZCdzIExBTjkzNzAsIExBTjkzNzEsIExBTjkzNzIsIExBTjkzNzMgYW5kDQo+ID4g
TEFOOTM3NC4gcmVnbWFwX3JhbmdlIHN0cnVjdHVyZSBpcyBhcnJhbmdlZCBhcyBHbG9iYWwNCj4g
PiBSZWdpc3RlcnMgZm9sbG93ZWQgYnkgUG9ydCBSZWdpc3RlcnMgYnV0IHRoZXkgYXJlIGRpc3Ry
aWJ1dGVkDQo+ID4gYXMgR2xvYmFsIFJlZ2lzdGVycywgVDEgUEhZIFBvcnQgUmVnaXN0ZXJzLCBU
eCBQSFkgUG9ydCBSZWdpc3RlcnMsDQo+ID4gUkdNSUkgUG9ydCBSZWdpc3RlcnMsIFNHTUlJIFBv
cnQgUmVnaXN0ZXJzLiBPbiAxNiBiaXQgYWRkcmVzc2luZywNCj4gPiBtb3N0IHNpZ25pZmljYW50
IDQgYml0cyBhcmUgdXNlZCBmb3IgcmVwcmVzZW50aW5nIHBvcnQgbnVtYmVyLg0KPiA+IFNvIHZh
bGlkIHJhbmdlIG9mIHR3byBkaWZmZXJlbnQgVDEgUEhZIHBvcnRzIHdpdGhpbiBhIHNrdQ0KPiA+
IHdpbGwgZGlmZmVyIG9uIHVwcGVyIG5pYmJsZSBvbmx5Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IFJha2VzaCBTYW5rYXJhbmFyYXlhbmFuDQo+ID4gPHJha2VzaC5zYW5rYXJhbmFyYXlhbmFu
QG1pY3JvY2hpcC5jb20+DQo+ID4gLS0tDQo+ID4gwqAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3pfY29tbW9uLmMgfCAxNzYwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
wqAgMSBmaWxlIGNoYW5nZWQsIDE3NjAgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBpbmRleCBkNjEyMTgxYjMyMjYu
LmIwOTA1YzViNzAxZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzel9jb21tb24uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2Nv
bW1vbi5jDQo+ID4gQEAgLTEwMzAsNiArMTAzMCwxNzU2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
cmVnbWFwX2FjY2Vzc190YWJsZQ0KPiA+IGtzejk4OTZfcmVnaXN0ZXJfc2V0ID0gew0KPiA+IMKg
wqDCoMKgwqAgLm5feWVzX3JhbmdlcyA9IEFSUkFZX1NJWkUoa3N6OTg5Nl92YWxpZF9yZWdzKSwN
Cj4gPiDCoCB9Ow0KPiA+IA0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IHJlZ21hcF9yYW5nZSBs
YW45MzcwX3ZhbGlkX3JlZ3NbXSA9IHsNCj4gDQo+IFN1Z2dlc3QgeW91IGVtcGxveSBzb21lIG1h
Y3JvcyBmb3IgZ2VuZXJhdGluZyB0aGUgdmFsaWQgcmVnaXN0ZXINCj4gcmFuZ2VzDQo+IGZvciBw
b3J0cyBzaW5jZSB0aGVyZSBpcyBhIGxvdCBvZiByZXBldGl0aW9uLCBhbmQgY2hhbmNlcyBhcmUg
dGhhdA0KPiBuZXcNCj4gcmVnaXN0ZXJzIG1heSBoYXZlIHRvIGJlIGFkZGVkIGluIHRoZSBmdXR1
cmUsIG9yIGNvcnJlY3RlZC4NCj4gDQo+IEJldHdlZW4gdGhlIGZhY3QgdGhhdCByZWdtYXAgbWFr
ZXMgeW91IHB1bGwgYW4gZW50aXJlIHN1YnN5c3RlbSBpbnRvDQo+IHRoZQ0KPiBrZXJuZWwgaW1h
Z2UgdGh1cyBhZGRpbmcgdG8gY29kZSBzZWN0aW9ucywgcGx1cyB0aGVzZSBiaWcgdGFibGVzIG9m
DQo+IHJlZ2lzdGVyIHJhbmdlcyBhZGRpbmcgdG8gcmVhZC1vbmx5IGRhdGEgc2VjdGlvbnMsIHRo
aXMgcmVhbGx5IG1ha2VzDQo+IG1lDQo+IHdvbmRlciB3aGF0IGJlbmVmaXQgdGhlcmUgaXMganVz
dCB0byBleHBvc2UgYSBkZWJ1Z2ZzIGludGVyZmFjZSBmb3INCj4gZHVtcGluZyByZWdpc3RlcnMu
Li4gdmFsdWUgcHJvcG9zaXRpb24gZG9lcyBub3Qgc2VlbSBzbyBncmVhdCB0byBtZS4NCj4gLS0N
Cj4gRmxvcmlhbg0KPiANCg0KVGhhbmtzIGZvciB0aGUgY29tbWVudCwgRmxvcmlhbi4NCg0KQ2hh
bmdlcyBhZGRlZCB0byBoYXZlIHJlZ2lzdGVyIHJhbmdlIHZhbGlkYXRpb24gZm9yIGxhbjkzN3gg
c2VyaWVzLCBJDQp0cmllZCBhZGRpbmcgY29tbW9uIE1BQ1JPJ3MgaW5zdGVhZCBvZiBpbmRpdmlk
dWFsIHRhYmxlcy4gSXQgd2lsbA0KcmVkdWNlIGxpbmVzIG9mIGNvZGUgYW5kIG1ha2UgaXQgZWFz
aWVyIGZvciBhbnkgZnV0dXJlIG1vZGlmaWNhdGlvbnMuDQpCdXQgYW55d2F5LCBmaW5hbGx5IGl0
IGlzIGdvaW5nIHRvIGV4cGFuZCBhcyBpbmRpdmlkdWFsIHRhYmxlcy4NCkNvbnNpZGVyaW5nIHRo
aXMsIEkgd2lsbCByZW1vdmUgdGhpcyBwYXRjaCBmcm9tIHNlcmllcyBmcm9tIG5leHQNCnJldmlz
aW9uLg0KDQpCdXQgb3V0IG9mIGN1cmlvc2l0eSwgSSBoYXZlIHNlZW4gdXNhZ2Ugb2YgcmVnbWFw
X3JhbmdlIHRhYmxlcyBpbg0Ka2VybmVsIGZvciB0aGUgcmVnaXN0ZXIgcmFuZ2UgdmFsaWRhdGlv
bi4gRG8geW91IHRoaW5rIHRoYXQsIGlzIGl0DQpyZWFsbHkgcmVxdWlyZWQgdG8gaGF2ZSB0aGlz
IGNoZWNrPyBvciBhbnkgb3RoZXIgYmV0dGVyIGFwcHJvYWNoPw0KDQpUaGFua3MsDQpSYWtlc2gg
Uw0KDQo=
