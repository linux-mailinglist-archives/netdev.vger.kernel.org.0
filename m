Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641886614AD
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 12:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjAHLLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 06:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbjAHLLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 06:11:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8729A3893;
        Sun,  8 Jan 2023 03:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673176272; x=1704712272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7rqgZMpQ6jkIftWSpVeoorFslU7orWXKQuY/mx293zc=;
  b=q72MJKN+4y8CZ1uBP8AzAtHbEnOdoLCB9OYCl3YYu0HI8eF+dx1rimU1
   H0LUCOwkdvVVl/DAFaehh3sXt5R4Q1mmlmai6NHKFL6MSRwlyYyngNaVz
   nb1Qi2cvjVutpAD5HTpXXIutTYqWvp41o3J9hHDqS+GZBYSBF0St7JIUB
   mCduYCRRwDnMGKhByh2cRN3JD2VIlIxCac3nakVGpUcDTsVjxHDVGKuTE
   Z9VdEEGf7i4D88Ya1hSo0mePNpHXgXjp5apzP/zmoo0xaLnd4Zwx+4QrX
   iqUsJlqI0sL1vAdHgpBy+Lqwgpti0/3GgtPtu1ltLP/80lo1DzBxi9rzh
   w==;
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="206832692"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2023 04:11:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 04:11:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Sun, 8 Jan 2023 04:11:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZReG3xWGOn51XadzrIeL1wJao3pNcby7lJnBd2d0tmUYQvtPJDwbEabcfYVmgOumKI7mBFD19Y9fH7mLfribDbPlsfvrxbkBtv9V9Yc5gwoRO7yvC2iHxqemottNXbuIukJBnzGB/UpsD+/vqcOmvNBLMMsayiOLLoAhly6/n2Q3y2Y27l4l55CbBcr5cj6X351z9yCUVqMpA349kV2OtlQOaYIMhtVgzcdmMB/rt4liu7sv6aZQKZF7ZjHrazyrBFWZ/5kQrmLRNkNnsSEA4DF442651m0ibgzT60dv08yHUNzDBOTNR51CnfgPKkrgEb0byu9gfhuDrDs5zV8lug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rqgZMpQ6jkIftWSpVeoorFslU7orWXKQuY/mx293zc=;
 b=MQ9ADq8kUzu9EWU2p6/T0Mx26EfLI15Dxq47AHD8OCYKommmOsssfx1KRBNDNkFcdLl7DLJHOZ6GP4Nb5Oobudk2Dwwe/nbjxsytI48N4lgf/Ufg3TNT6lidwqtepqB6Z1VjR0dkuZr3ufRTZIdCCoI1NtWW6WX9R3R4dnok8iOYgcbcKMW21swjJcxvzwngygoz8BoZLjWuHk97YtgTPR5Mu1Dm/Avf0Z1uMFuG8+WF4HvOTEZekxCM0JNU+nXzHfolRms2YQB6Xno1HKwDp0zAaSPghxSFIFc4rp0bQvfQOxmZwgITGC3Zc2r3/WUZXPeEW/QO2AHAX2+PwNNa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rqgZMpQ6jkIftWSpVeoorFslU7orWXKQuY/mx293zc=;
 b=p8w5rrggpCfrPrciWdP/uwJtHM/tNMDJ1OMcpT6mFn/31UbA9IyNhikepIRlPtT7CjpgI3MhqtDyn/9YrnsKodln495wM7viYExYxxQ1NrvC+Kj3ieOkkDmBNUQlPpe29B3JonUPKILnh4BR71ds3Ma8t/XFhewdRGRoRnVE/Gw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SJ0PR11MB5919.namprd11.prod.outlook.com (2603:10b6:a03:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Sun, 8 Jan
 2023 11:11:08 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5944.019; Sun, 8 Jan 2023
 11:11:01 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <yanhong.wang@starfivetech.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <andrew@lunn.ch>, <robh+dt@kernel.org>, <pgwipeout@gmail.com>,
        <kernel@esmil.dk>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <richardcochran@gmail.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 5/7] net: stmmac: Add glue layer for StarFive JH7110
 SoCs
Thread-Topic: [PATCH v3 5/7] net: stmmac: Add glue layer for StarFive JH7110
 SoCs
Thread-Index: AQHZI1EmAE6NG2kyd0WD9IW4crckga6UXSQA
Date:   Sun, 8 Jan 2023 11:11:01 +0000
Message-ID: <720bffcd0dde99d6a87aea6baa8b5ccefe65a178.camel@microchip.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
         <20230106030001.1952-6-yanhong.wang@starfivetech.com>
In-Reply-To: <20230106030001.1952-6-yanhong.wang@starfivetech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SJ0PR11MB5919:EE_
x-ms-office365-filtering-correlation-id: 1f3e7536-1aac-42d4-b79e-08daf1690708
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TB8VV9kh1ZVs5Fo8arRy584XNtovE1rttMa8OwTNIAIoOJeiQ3gu4hrQQbGuZn178tUKTN/+Lwcgpa3g4oQaxg4bHiNHW1zx1sWDbztGgY8VDJN3gdHFvj+EEEmTPIBBbTkke3zwtPEU0LsMSp4TxJQxdXZdJdmBFZBIwggguJp+QxvVbR7f3Mf+3D6dzAS6aitCqOUGOXFjDe68EtoipXFxVgzWhDGayC33nz69nFfYKNjV3UYLFdxw9/hMQQSFWXHoxzFvNPVqmEDCBEHkAvB1i8+xniqTjX0uQhVrIfP/E+Ool+tOIyiVAevl8qw+MBzdD/Mv7MX90aQa0SqQq6XJCJzrVea3yGWGiufL009rimyloa8x/HJOCgCLSOY3kb0JK+KDPap4RLtrW8hExzc6nkWOSVuP3GZldtKjt/Rr0JfwHgshIyZqR7RaE5KuswABOAmUAkXzi1MfkULX0YGMw/vw/owRwUakNfQWWK7MqeCDoW6CPY1YeWsnSIUo3g1HcbtsxMCAuI7WGjZcwgWP8VgQbp6cXOOYKfrWkAUbZ6eTbILYe+vJKPf6OBaa41pOArB7hpfitpM+hvo6tBFfvwsZITlEs3BVb338Glo0d+Q4kuuqNL4Kwfa3GfcV9KO9Vgj886Dg3L5mt3dlVKu6M8rF9LdD5XAcOSn0QLGLwwdypx4sNOIpPT5Ccawrsb7eFjafway9CPJh7wehfZYwWamHm4GpkZB0J/Py6CA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(6029001)(396003)(136003)(346002)(39850400004)(376002)(366004)(451199015)(478600001)(122000001)(36756003)(38070700005)(86362001)(91956017)(66446008)(316002)(54906003)(8936002)(6486002)(38100700002)(2906002)(71200400001)(2616005)(110136005)(41300700001)(5660300002)(64756008)(6506007)(186003)(4326008)(66476007)(8676002)(66556008)(76116006)(83380400001)(66946007)(6512007)(7416002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0FGcGk1bXJrdkVsdGZWTGxDNWY4SkRJY055dkY1dTdDNDBZTjhsSW9TeUhS?=
 =?utf-8?B?b3JQQjF6Vm42QWRRWHkvMFRUQTBaWDZ6bXZBZ2lvOG5TaVkyZldkQnVWQlJV?=
 =?utf-8?B?cDNJNnJvblV6S1NNVkw0Qm1SSDJ6OUYrQXJodUdNL21ubStpL28zMStLTGJQ?=
 =?utf-8?B?dlM0NHZ0cFBsdFdNSEtDOWJzVm82OVZTV0xVcmhqNzlXbzhuU0hCK0hwZkFk?=
 =?utf-8?B?M0hCU3RaaW01c0E5MUhWR0tRckpBTi9jSC9VOTloMUp2NFNpS01jUzF5akxJ?=
 =?utf-8?B?UDJYWTA5ZGl4SklpZ3FXdHIyaGFCNWU1bThpSzFKQzN4eUMrZzVweEhPNVIv?=
 =?utf-8?B?RGNHN0hMRXNWSXdNdWdtSWRwS1R0cjNyUEtLRG1aL3Q1bXFCYlVMek16RGdo?=
 =?utf-8?B?SFpLU2d6Z0RoTzRXN0pFWUlsQ3FkSUl1dUpCdHJZWmlCbEFFQlI1Q2owV1oz?=
 =?utf-8?B?M3hRc2tSeXlVaG9sci9oNG5xak13NEFHdEIxVjBXeVptUmZwQi9Fa29hSVQx?=
 =?utf-8?B?d3VET2RNeCtwbk03c1VSVmkzMzQ2dW5OdlpyYktzWTdiM1lmZXk0ZERqWDlm?=
 =?utf-8?B?ei8yWXNMRHN2eGxTeGVBOUtETTd1ODdYbjJyY0VERythZmNDZWhobHcrSnhP?=
 =?utf-8?B?S2p6NHBPYVBnRWkvTC9QMlptTUd3QmZVL01mclI0RHZXbks4d2JUR0tCQTh5?=
 =?utf-8?B?WjJuMHQ4d0lncXlSaEh6VTl5VlQ5ZWJ6WGRPTjFNNmRsYmVOLzZVTmtyZGFS?=
 =?utf-8?B?ZmpRNlBBYXh2YTEvcGFhUEVWM0tocDd0Ti9menFXODRuQkFHbUJvWmlMdE9P?=
 =?utf-8?B?anVYejBObEU4ZmtwMml3ODV1WlhlVVY0Zy83QkNMSExXVWt4MmppcWorTk9l?=
 =?utf-8?B?MnV5T3U3UUFBUkhKOVFYWVQ5NEw1M3gzM0t3SmI4NjB3YlVaSEV1dkRzV3JG?=
 =?utf-8?B?bGtnVHpoY3R4c2hRYi80VEN5b04wY1gzZitnYUFYR2tZdllVY3pCN1I1TXV2?=
 =?utf-8?B?Y0pHd3FhN0xqeDJkaCs0TW1HcDR6d1RBZlc0THNWS3UrV2dpYlJGRks4QWl4?=
 =?utf-8?B?OVFQSjhFaUFFNnc2SVdDY2hTUXpIN21JVGlxSWxlTnd4MCtWM2pML0FEK3Fy?=
 =?utf-8?B?MHdha01UOEJFRW8zTXU4RlJNbG9PazNCam55MnRtWFVaVFRRV3llY21uY2pm?=
 =?utf-8?B?eDF5amtaWGM5Y0cwZmd0Tk0wNWpGQ2lEQ3NrMytLdnU2ZVhJa0JHUVhLUXZ0?=
 =?utf-8?B?MjBtc05OYnpnamdkOHVoRFk4TGVQTVF4aUVLNXNnMVB6VkZHc2dRWVQ3MEp6?=
 =?utf-8?B?S3dxVXRtWmdubHlHcytYWklrUGtxWm9KeTJoQ25JL00weS9hYlVtWWFtaDJL?=
 =?utf-8?B?cWUrbklSNmNPS3ZLWDgzZk5pcTRvOG84dklwT05RNHkwaDlmYmZaSmQ2STI5?=
 =?utf-8?B?R1gwd2lZbEZvYjBCY3ZIYis4TDIrNXJlcXE5QldBdjZHTWVpOUpYZmZoT01r?=
 =?utf-8?B?TkFZcEVQU0JYbmh1elZ5WVg2NUtSOE9id1V1WE56cmppc1MxbmRzMDZoM1lC?=
 =?utf-8?B?dG8yaEVFaEVwckRwdlJjVmFwUE1rcXNtRi9acVp6VG9Od0VmeHNPSTVJV3Zn?=
 =?utf-8?B?QXVTMFN0bVJ5Q2ZvMUpQVDB3RWVacjJ2bTBTMWNVaE1FY0ZrSW5RVjE1bSti?=
 =?utf-8?B?Ykp0UjcwU2UzUzB2SHE0NU00V25LbXhUeXNqRGl1ZENQTjYrVmhiNDNSYVZG?=
 =?utf-8?B?K0l0ZWV1cTdiRm84bkZoaC9NOHN1dGlIVnBRL0FTSG1hL3pWdFFWNGp1N2NT?=
 =?utf-8?B?c213aDNKQ05Td0tLNzZHMkpmNmNxTysxQjRTWHR3RERKeHJ1WmsxSERibGxu?=
 =?utf-8?B?MEpuTjlXdm1VMWVDTUtmcml3WVAwWi9rZnhUWTJZemc2NnlJVkc4L1drTk9V?=
 =?utf-8?B?bkdIN044b0pkQlAxNldUT0JjZG03M3paZG9kKzNydkdqMVdPdnBTemt4VStP?=
 =?utf-8?B?V3lsV0NVM21KRVdxc3JjS2FrR01PZlhkdldqMmVZcGlCTW5MZUJpNnlhZW53?=
 =?utf-8?B?MXFDZEVIdFRXQkx3aWpvU1RqSWl3STFURTdFSzBmK1NIMWVFZzJRTFkvaFE5?=
 =?utf-8?B?dVNidkZqSjExcXdtQWdPOTVNUWVRQjdvQ0Mwdld0eVlNcDI0WVFBeWxoWThB?=
 =?utf-8?B?RXV1aWV1UE9COW8zR0RZS2pWRy9KdlpRSWpLQm0rMFBPUXNESEM3RnNyanha?=
 =?utf-8?Q?O2e9GvOc5YJuMGVdUknhE0prmSAJ/BuwO1PZfOReVQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CB4934DB5A6744C8C5E9C470AA4C671@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3e7536-1aac-42d4-b79e-08daf1690708
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2023 11:11:01.8061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4SJuKirN9Oc6HFHHd5H/EllRUrlBtG90lAmogzMA+quChDi8ZGDcs35eg7R9cvY7qzagmr1Bby19ewaOWtGYhKHjZt4eKyOg06abq9qZeTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5919
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWWFuaG9uZywNCg0KT24gRnJpLCAyMDIzLTAxLTA2IGF0IDEwOjU5ICswODAwLCBZYW5ob25n
IFdhbmcgd3JvdGU6DQo+IFRoaXMgYWRkcyBTdGFyRml2ZSBkd21hYyBkcml2ZXIgc3VwcG9ydCBv
biB0aGUgU3RhckZpdmUgSkg3MTEwIFNvQ3MuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5ob25n
IFdhbmcgPHlhbmhvbmcud2FuZ0BzdGFyZml2ZXRlY2guY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6
IEVtaWwgUmVubmVyIEJlcnRoaW5nIDxrZXJuZWxAZXNtaWwuZGs+DQo+IFNpZ25lZC1vZmYtYnk6
IEVtaWwgUmVubmVyIEJlcnRoaW5nIDxrZXJuZWxAZXNtaWwuZGs+DQo+IC0tLQ0KPiAgTUFJTlRB
SU5FUlMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL0tjb25maWcgICB8ICAxMiArKw0KPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvTWFrZWZpbGUgIHwgICAxICsNCj4gIC4u
Li9zdG1pY3JvL3N0bW1hYy9kd21hYy1zdGFyZml2ZS1wbGF0LmMgICAgICB8IDEyMw0KPiArKysr
KysrKysrKysrKysrKysNCj4gIDQgZmlsZXMgY2hhbmdlZCwgMTM3IGluc2VydGlvbnMoKykNCj4g
IGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9k
d21hYy0NCj4gc3RhcmZpdmUtcGxhdC5jDQo+IA0KPiANCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYy1zdGFyZml2ZS0NCj4gcGxhdC5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtc3RhcmZpdmUtcGxh
dC5jDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uOTEwMDk1
YjEwZmU0DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvZHdtYWMtc3RhcmZpdmUtcGxhdC5jDQo+IEBAIC0wLDAgKzEsMTIzIEBADQo+
ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCsNCj4gKy8qDQo+ICsgKiBTdGFy
Rml2ZSBEV01BQyBwbGF0Zm9ybSBkcml2ZXINCj4gKyAqDQo+ICsgKiBDb3B5cmlnaHQoQykgMjAy
MiBTdGFyRml2ZSBUZWNobm9sb2d5IENvLiwgTHRkLg0KPiArICoNCj4gKyAqLw0KPiArDQo+ICsj
aW5jbHVkZSA8bGludXgvb2ZfZGV2aWNlLmg+DQoNCkJsYW5rIGxpbmUgYmV0d2VlbiBoZWFkZXIg
d2l0aCA8ICA+IGFuZCAiICINCg0KPiArI2luY2x1ZGUgInN0bW1hY19wbGF0Zm9ybS5oIg0KPiAr
DQo+ICtzdHJ1Y3Qgc3RhcmZpdmVfZHdtYWMgew0KPiArCXN0cnVjdCBkZXZpY2UgKmRldjsNCj4g
KwlzdHJ1Y3QgY2xrICpjbGtfdHg7DQo+ICsJc3RydWN0IGNsayAqY2xrX2d0eDsNCj4gKwlzdHJ1
Y3QgY2xrICpjbGtfZ3R4YzsNCj4gK307DQo+ICsNCj4gK3N0YXRpYyB2b2lkIHN0YXJmaXZlX2V0
aF9wbGF0X2ZpeF9tYWNfc3BlZWQodm9pZCAqcHJpdiwgdW5zaWduZWQgaW50DQo+IHNwZWVkKQ0K
PiArew0KPiArCXN0cnVjdCBzdGFyZml2ZV9kd21hYyAqZHdtYWMgPSBwcml2Ow0KPiArCXVuc2ln
bmVkIGxvbmcgcmF0ZTsNCj4gKwlpbnQgZXJyOw0KPiArDQo+ICsJc3dpdGNoIChzcGVlZCkgew0K
PiArCWNhc2UgU1BFRURfMTAwMDoNCj4gKwkJcmF0ZSA9IDEyNTAwMDAwMDsNCj4gKwkJYnJlYWs7
DQo+ICsJY2FzZSBTUEVFRF8xMDA6DQo+ICsJCXJhdGUgPSAyNTAwMDAwMDsNCj4gKwkJYnJlYWs7
DQo+ICsJY2FzZSBTUEVFRF8xMDoNCj4gKwkJcmF0ZSA9IDI1MDAwMDA7DQo+ICsJCWJyZWFrOw0K
PiArCWRlZmF1bHQ6DQo+ICsJCWRldl9lcnIoZHdtYWMtPmRldiwgImludmFsaWQgc3BlZWQgJXVc
biIsIHNwZWVkKTsNCj4gKwkJcmV0dXJuOw0KDQpEbyB3ZSBuZWVkIHRvIHJldHVybiB2YWx1ZSwg
c2luY2UgaXQgaXMgaW52YWxpZCBzcGVlZC4gQnV0IHRoZSByZXR1cm4NCnZhbHVlIG9mIGZ1bmN0
aW9uIGlzIHZvaWQuDQoNCj4gKwl9DQo+ICsNCj4gKwllcnIgPSBjbGtfc2V0X3JhdGUoZHdtYWMt
PmNsa19ndHgsIHJhdGUpOw0KPiArCWlmIChlcnIpDQo+ICsJCWRldl9lcnIoZHdtYWMtPmRldiwg
ImZhaWxlZCB0byBzZXQgdHggcmF0ZSAlbHVcbiIsDQo+IHJhdGUpOw0KPiArfQ0KPiArDQo+ICtz
dGF0aWMgaW50IHN0YXJmaXZlX2V0aF9wbGF0X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYpDQo+ICt7DQo+ICsJc3RydWN0IHBsYXRfc3RtbWFjZW5ldF9kYXRhICpwbGF0X2RhdDsN
Cj4gKwlzdHJ1Y3Qgc3RtbWFjX3Jlc291cmNlcyBzdG1tYWNfcmVzOw0KPiArCXN0cnVjdCBzdGFy
Zml2ZV9kd21hYyAqZHdtYWM7DQo+ICsJaW50ICgqc3lzY29uX2luaXQpKHN0cnVjdCBkZXZpY2Ug
KmRldik7DQoNClJldmVyc2UgY2hyaXN0bWFzIHRyZWUuDQoNCj4gKwlpbnQgZXJyOw0KPiArDQo+
ICsJZXJyID0gc3RtbWFjX2dldF9wbGF0Zm9ybV9yZXNvdXJjZXMocGRldiwgJnN0bW1hY19yZXMp
Ow0KPiArCWlmIChlcnIpDQo+ICsJCXJldHVybiBlcnI7DQo+ICsNCj4gKwlwbGF0X2RhdCA9IHN0
bW1hY19wcm9iZV9jb25maWdfZHQocGRldiwgc3RtbWFjX3Jlcy5tYWMpOw0KPiArCWlmIChJU19F
UlIocGxhdF9kYXQpKSB7DQo+ICsJCWRldl9lcnIoJnBkZXYtPmRldiwgImR0IGNvbmZpZ3VyYXRp
b24gZmFpbGVkXG4iKTsNCj4gKwkJcmV0dXJuIFBUUl9FUlIocGxhdF9kYXQpOw0KPiArCX0NCj4g
Kw0KPiArCWR3bWFjID0gZGV2bV9remFsbG9jKCZwZGV2LT5kZXYsIHNpemVvZigqZHdtYWMpLCBH
RlBfS0VSTkVMKTsNCj4gKwlpZiAoIWR3bWFjKQ0KPiArCQlyZXR1cm4gLUVOT01FTTsNCj4gKw0K
PiArCXN5c2Nvbl9pbml0ID0gb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhKCZwZGV2LT5kZXYpOw0K
PiArCWlmIChzeXNjb25faW5pdCkgew0KPiArCQllcnIgPSBzeXNjb25faW5pdCgmcGRldi0+ZGV2
KTsNCj4gKwkJaWYgKGVycikNCj4gKwkJCXJldHVybiBlcnI7DQo+ICsJfQ0KPiArDQo+ICsJZHdt
YWMtPmNsa190eCA9IGRldm1fY2xrX2dldF9lbmFibGVkKCZwZGV2LT5kZXYsICJ0eCIpOw0KPiAr
CWlmIChJU19FUlIoZHdtYWMtPmNsa190eCkpDQo+ICsJCXJldHVybiBkZXZfZXJyX3Byb2JlKCZw
ZGV2LT5kZXYsIFBUUl9FUlIoZHdtYWMtDQo+ID5jbGtfdHgpLA0KPiArCQkJCQkJImVycm9yIGdl
dHRpbmcgdHgNCj4gY2xvY2tcbiIpOw0KPiArDQo+ICsJZHdtYWMtPmNsa19ndHggPSBkZXZtX2Ns
a19nZXRfZW5hYmxlZCgmcGRldi0+ZGV2LCAiZ3R4Iik7DQo+ICsJaWYgKElTX0VSUihkd21hYy0+
Y2xrX2d0eCkpDQo+ICsJCXJldHVybiBkZXZfZXJyX3Byb2JlKCZwZGV2LT5kZXYsIFBUUl9FUlIo
ZHdtYWMtDQo+ID5jbGtfZ3R4KSwNCj4gKwkJCQkJCSJlcnJvciBnZXR0aW5nIGd0eA0KPiBjbG9j
a1xuIik7DQo+ICsNCj4gKwlkd21hYy0+Y2xrX2d0eGMgPSBkZXZtX2Nsa19nZXRfZW5hYmxlZCgm
cGRldi0+ZGV2LCAiZ3R4YyIpOw0KPiArCWlmIChJU19FUlIoZHdtYWMtPmNsa19ndHhjKSkNCj4g
KwkJcmV0dXJuIGRldl9lcnJfcHJvYmUoJnBkZXYtPmRldiwgUFRSX0VSUihkd21hYy0NCj4gPmNs
a19ndHhjKSwNCj4gKwkJCQkJCSJlcnJvciBnZXR0aW5nIGd0eGMNCj4gY2xvY2tcbiIpOw0KPiAr
DQo+ICsJZHdtYWMtPmRldiA9ICZwZGV2LT5kZXY7DQo+ICsJcGxhdF9kYXQtPmZpeF9tYWNfc3Bl
ZWQgPSBzdGFyZml2ZV9ldGhfcGxhdF9maXhfbWFjX3NwZWVkOw0KPiArCXBsYXRfZGF0LT5pbml0
ID0gTlVMTDsNCj4gKwlwbGF0X2RhdC0+YnNwX3ByaXYgPSBkd21hYzsNCj4gKwlwbGF0X2RhdC0+
ZG1hX2NmZy0+ZGNoZSA9IHRydWU7DQo+ICsNCj4gKwllcnIgPSBzdG1tYWNfZHZyX3Byb2JlKCZw
ZGV2LT5kZXYsIHBsYXRfZGF0LCAmc3RtbWFjX3Jlcyk7DQo+ICsJaWYgKGVycikgew0KPiArCQlz
dG1tYWNfcmVtb3ZlX2NvbmZpZ19kdChwZGV2LCBwbGF0X2RhdCk7DQo+ICsJCXJldHVybiBlcnI7
DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCg==
