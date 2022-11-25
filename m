Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E717963843B
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKYHGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYHGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:06:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B95CED;
        Thu, 24 Nov 2022 23:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669359972; x=1700895972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lab8dBA+m2TXraYpBPH3JB9+6QuiiAsHK4ljhyfffsw=;
  b=ODkT6IEfR0TZ90aQoHIIlj4ZXUZe2dIrTGTJNQ0TgLtemgL+bBL7BZS/
   UgUhdco9JE1ZjwA6gbW2hqQx4H1CYx2kbJ1IGlI0JtTeOB8Lz0kJeV5Kz
   qD2xBkeoGmF2Kf38MaM9k6S/NWGrhRngAGv25KcTx/JpG29QnahFRsUJw
   6MZJx5L+uM/Ts0ychoiU6rn3CYxb6LtUxjIFy2VynPYMV+6r1vWlVuaTE
   D9Q2Mp2wf35Gatq99pclgTpfwrg9IX7/SCxyUrw0dfm5mm0WMjXE/xVOp
   b4PKyxHdm26rt5EIM0cHs/xys9NUaeDZKhEkOOhO4i5IFMHqEutHeWUy3
   A==;
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="188612467"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 00:06:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 00:06:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 25 Nov 2022 00:06:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOsF5CFL/DqmqQYeofhz0Tfbcy2svJ//Tjkzf4RE/XqTQensAs+w/CcfLcfTE0d2Sl9UkNZLsE9Lgkd5JC+GddcxSjBWbN7jeHJKSKphdSUGfAQiA1SqqflqyjvSBRI20hSq9dZcsF8fC4kc06IHtNR2kLNjY5Sg9xrpnHtgoRByllYpdPfF0yFn/FtQdAFl/E3ZhlKDOVo+Wgn9Qda9ErSfsAQ1SA73P70kfGtn59Pj7e0CaXHxFly/sqX3YT+NmQM6l0Is63sIGRQ+CaTjvQhoVSYEO76fHnmg/wJsCpVnSOvCtGEcHhKPW9AcOujpQ2qjAn1+3q0Y0KsurGatWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lab8dBA+m2TXraYpBPH3JB9+6QuiiAsHK4ljhyfffsw=;
 b=lEDpnbWq1s0m2Ai6la79Uod/zF2u7HIY0eQZRefOMro5MlwKzzXAKRHldSiEFiXH3oQbx4qCvZBHPJIfDWhLf9IoQRB+NKzB38P4k/CGFKmWSV7Y3dCksmRZc3+den8C5eiFtJJR+N14o92JjWJjNjYS90aKKsimzGrWEFkU5sNsyjtKICaoEXczE79BiIpjkz7gmVDC4M93QYvvr9dFfeMaFuzEwcUqSBUToFCDY1K23oZNdVXLDb/oSPYVUMPF2CY++CQ9seBRprcfRLtC6or3z2Otcu87Pz2ZDsT00lPGCKh9DRY146BUKmQPtwnC0B+HMryRjaFEH4jgCvWqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lab8dBA+m2TXraYpBPH3JB9+6QuiiAsHK4ljhyfffsw=;
 b=cRw4xtdzZtcMnq8aL/LOeGjX175Gx21jKsCH7YcsmOoD6hmwSdCA8kAoWh6kJBoEhi+99B8utwpA6OULxc+44ewQej8zKACQzPmxQ5XFWtfAXbS4mBdyKyr2WMaKr+BKt34/U/VDpSbA5kEdfeP+tD5ywVJwQZSACax8idyJYsg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 07:06:07 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Fri, 25 Nov 2022
 07:06:07 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial hardware
 time stamping support
Thread-Topic: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Thread-Index: AQHY/b/imAgaAgzTi0Cq9JpLcCQfmK5KAikAgAKJeACAAVYlgIAACH0AgAA4fgCAARqFAA==
Date:   Fri, 25 Nov 2022 07:06:07 +0000
Message-ID: <4b2408602ce29c421250102c5165564d7dafda77.camel@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
         <20221121154150.9573-4-arun.ramadoss@microchip.com>
         <20221121231314.kabhej6ae6bl3qtj@skbuf>
         <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
         <20221124102221.2xldwevfmjbekx43@skbuf>
         <0d7df00d4c3a5228571fd408ea7ca3d71885bf6f.camel@microchip.com>
         <20221124141456.ruxxiu7bfmsihz35@skbuf>
In-Reply-To: <20221124141456.ruxxiu7bfmsihz35@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BN9PR11MB5483:EE_
x-ms-office365-filtering-correlation-id: 9925d1aa-fcb2-4d6a-df8e-08daceb38629
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pD8/fDcBparV5ZxiljRXzlgKGRuFj4q/smRAsyGV3LmbBGBVFuGR54JE6fP82CLDiimJcqW9YK9yXOjOHfYnUlu96LadazTg9Zj9GKOGEcOZYadM2Qgu41AzqS6PjRGDXSJthdLJoY/ZC/Ioe23JM8rtzTazADHpF/MLVo2S9M1vXeZMeuF+KuxIHv5qxP3wfucu+HSBdeJ9dhjbXIXRLyB/HLOoCKxNQwZkaApKja5IqWggLOz0PJAD+Z9TlbN4DkFzrhnTJc+Prw5zIKdmWqQM7fdQpv+nuU9PpamxydNFb347e49P8ESsuhwNFLtz0iEuNdV97Z4FDNJp5pbawmrniRu92KpOCXX+/NBbthKifbxpaaQXItTeexwHcJvFqAfpG8tBI0IgkuExaqZ+rvFCjR6FWebvUtWTifGsILNaZzrhtSbzuy7UDFPkNDvg5gjbRuaac+1LoFpnGuiqScOmdV2wOoZFquHF91MoBztw1vjj/OlekkcQ/N6MFnpZ0t4Ocuwe4x2mhJqmbpXdqSH6+fUu4R7d5BqZevmLKPmVCV5M+z/e36FioYuLyJURtDD55G/HxKmhHvwpk73o0w+e+uo4EGvSpVFYlMhCaPiFppyc8M6wc8CcfGtl1coW3vFwT3G9re4TMcMQ9DG7QBO3nKRjqmJdRYWrDzreTBIE4eoAo4T0HphoF2wutbK7739lBu6DVymHuvleWeWaShswfNOJBceMyb88L89ug9osupKSxiH7B0xVv+UifHbw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(66946007)(38100700002)(86362001)(64756008)(4326008)(8676002)(66476007)(76116006)(41300700001)(66446008)(66556008)(54906003)(966005)(91956017)(8936002)(6486002)(6916009)(316002)(7416002)(5660300002)(4001150100001)(83380400001)(2906002)(122000001)(38070700005)(71200400001)(6506007)(478600001)(2616005)(186003)(6512007)(26005)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?em9TT1ZiSWVSemtTUHd1Q01mVUxrMGJMQnlnczBpZlE2WTJnaXd4OHJzZVVm?=
 =?utf-8?B?RHNyYk9yN1Z5MXY1Y0hjc3JtMWFjYjArcG55WDhYRytDQ2RPWVpnbnlOenhn?=
 =?utf-8?B?NGF1ZGZjWkhLZjhjSTFIUE13RGhreGFQRUNFTXNvWDhKRURRUmVrU1JoaEc3?=
 =?utf-8?B?YTZsSDBCM251YWREZWZvN0JZVVRhRVJIekR5a2ZLVmRxN09YV3luclAxR3Zi?=
 =?utf-8?B?Y0kySWFqaHRHeFczZERhbG5aWjF5NjdYY0pXa2tsUlNjV3VGaGJJV1J6N2d5?=
 =?utf-8?B?ZzRDc2ZlSllZUHYrNStodzl2VzlZU210MlREd1pabjJxOUpINVBMeWJNZ0M1?=
 =?utf-8?B?aFhOeWN4b2xWSFNYRFpLOWM1OXM2aUwvUGhGQURVQ2ZwWEFuUWIzQ3dUYm1q?=
 =?utf-8?B?Mm96QmRacU1QVjdwWlRodVJZbWQxOFowMFJyRXdsekZuQ3FkVnVLZk1ZNmZ6?=
 =?utf-8?B?QTBqRU1kNG1uaTRycnU3emFnbHNPbVFrS1Vqdmo2YW9XcldvcTZIUHM4NHZB?=
 =?utf-8?B?WC8vemxrdnhXdk9uNm5zVW9oZWR1OW1zNTNxMzBsRXBvYXlhSXc4UksyUnlL?=
 =?utf-8?B?Lzc1c3RCWUlRbU1pODlvKzlTVzdNTVE2WjBJSVA1djNnb0JmR1g2clVyNDFP?=
 =?utf-8?B?SzB1NlBHMmF6QjU0L2IwVmsyVTAvUERVM3g4MTRTSkc0Uzl6V29YeDI2YkJp?=
 =?utf-8?B?WVFRRGZNQmtac05JaFNRZEFNdEs5V2tLdEFCL2EvY0NMZ0FBK2RSSlErVWdH?=
 =?utf-8?B?MTZoczF4aDkvQUhLQ0xJSTNhSlZ5ZHo1Mm1XbVl5V1RuR0l6bXlCS2pxZHU0?=
 =?utf-8?B?RjRzY0V3OFlGSmRsblcwazFldW5aTndwWTFxemk4QUdqS0U4RjRiWU94dTZo?=
 =?utf-8?B?UVNoaE0wTXZsZm9PRk9lOUtrZVhLaEY3Nk5jUU85Y0FQUSs5SXg5ZkpYNjJ1?=
 =?utf-8?B?K0NNNnB1QWlybEtjbTlyYjEyOGgwVDJyd0FIdENHK1V2ZHlWaXo2NW5BUnJ4?=
 =?utf-8?B?OGNpU3UvTG1iSnhpdTlVeHQzRkc3T1RKTjR2RW51NlhFM1JkdXNLSnJ4VzQ0?=
 =?utf-8?B?dDJYS0ZZZDZ4ZjJGOU1oZVlHSTRmUkplYThHQmdVa1lrdmYySUVNS0d4TlRE?=
 =?utf-8?B?QmtsMU9kSzhUelM3U1NCK0JYU0V6Q3RtVmtCd0kxck95OVRvZXMwWDVrMkdt?=
 =?utf-8?B?R2pTVDN2Zngra0NVbHQ5ZEZHVEdpVjU4Mit2ek1YYnJoUDNyUTIvRThpWUg2?=
 =?utf-8?B?KzhKQXg2dkV1QWlpVjhRVEtPZzd6YWV5VmgrdngzVjM3NEk4RWRtM2wrU29z?=
 =?utf-8?B?SzV1YnU5aUdGSDBEWjlOalRzR0RXd3BBM05KS3YxSG13SHBzWStHWWlrTjNN?=
 =?utf-8?B?U0NqcDhkTUV5d1BITkRtUW1nWHpQdFYzaDBxd1p2OG9Oc05FUm1tNDlHdHpU?=
 =?utf-8?B?MWR6VWFZQXBOVkhEaWxUYlR2NE56eStwMTNwQ0Y2UlJhZmFWdnVqWHVqYUNz?=
 =?utf-8?B?aitlbG12bzAzQnFHVzlrVG9wSnRMMDllWEdJZzhKeDliQVQ4VnI4Yyt2T29R?=
 =?utf-8?B?K2haaFRIeE1LTkVFNzFnemlwMW5iK2NrY1p4OHZGQTA5WUE0VDc5cTkzeUVG?=
 =?utf-8?B?MmJtdDAxUHQxeVg1SFZJSDUvRjkwODdxK2xxZFBLbFJHVnpzY2xrdFpJczlt?=
 =?utf-8?B?Zmx5bHU0MlI4dUk5WlliMGp0WlM5U0t6VWN1b0xZV3dxd2Vvd0dEd3J4TVcv?=
 =?utf-8?B?dzVFcHB6VlpGVmM0YURIYWg3eHhXby9kbkhrVTNTUkJQZmowbHhlNTQ4SHJ2?=
 =?utf-8?B?M09Ycis3NzB4NWNKN3VxZjQ2ZzNPMWdvc2JPMTQ4N3JlT3VualErWFc5MWJT?=
 =?utf-8?B?Wkl4NEdYcSs3bEh0aVRNUndSTisrTGZTZmhRdEVUN25WNHU0d3oxdlNreGRX?=
 =?utf-8?B?NEhzaHpoM2hHS1pSczh4ZzFOU0t0dFdSUnRCUTUzeU1yR0hLM3YvdDZiZERp?=
 =?utf-8?B?TitNdlRDSGlIQStRKzQvNkU5bzhydmZpc24zaEZsanZVSXRJME9aS0llUjZ1?=
 =?utf-8?B?VEx2QnVidGRHUWtYZDIrMjRPNTMxa1lVY3pwS0xyRElqNVlzNTIrZGN6d0hj?=
 =?utf-8?B?WGEzNjVYb2hqS3RyZ2VLM2tTbTlFNzhqTlhaZVhXYkVrWmhXSFdYdkNyamlM?=
 =?utf-8?Q?7lUr487X5yCK9KJjiAs6zFE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A470B0737C25774099410C6C0A33FBAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9925d1aa-fcb2-4d6a-df8e-08daceb38629
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 07:06:07.1236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQgDrrvABdDs0X/b0gaY6Yx0rJ1CY/AjTscPGG5wPXKNKN/2AOnM3Gc1ewiTYf1jrbqEO5K/aAGA1GuFFlSVVcZS4MQXpnOSRFe+XzVo1TY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5483
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFRodSwgMjAyMi0xMS0yNCBhdCAxNjoxNCArMDIwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IE9uIFRodSwgTm92IDI0LCAyMDIyIGF0IDEwOjUyOjQ2QU0gKzAwMDAsIEFydW4uUmFt
YWRvc3NAbWljcm9jaGlwLmNvbQ0KPiAgd3JvdGU6DQo+ID4gTWlzdGFrZSBoZXJlLiBJdCBpcyBj
YXJyaWVkIGZvcndhcmRlZCBmcm9tIENocmlzdGlhbiBFZ2dlcnMgcGF0Y2guDQo+IA0KPiBTdGls
bCB0YWtlbiBmcm9tIHNqYTExMDVfaHd0c3RhbXBfc2V0KCkuIEFueXdheSwgZG9lc24ndCBtYXR0
ZXIgd2hlcmUNCj4gaXQncyB0YWtlbiBmcm9tLCBhcyBsb25nIGFzIGl0IGhhcyBhIGp1c3RpZmlj
YXRpb24gZm9yIGJlaW5nIHRoZXJlLg0KPiANCj4gPiA+IFdoeSBkbyB5b3UgbmVlZCB0byBjYWxs
IGh3dHN0YW1wX3NldF9zdGF0ZSBhbnl3YXk/DQo+ID4gDQo+ID4gSW4gdGFnX2tzei5jLCB4bWl0
IGZ1bmN0aW9uIHF1ZXJ5IHRoaXMgc3RhdGUsIHRvIGRldGVybWluZSB3aGV0aGVyDQo+ID4gdG8N
Cj4gPiBhbGxvY2F0ZSB0aGUgNCBQVFAgdGltZXN0YW1wIGJ5dGVzIGluIHRoZSBza2JfYnVmZmVy
IG9yIG5vdC4gVXNpbmcNCj4gPiB0aGlzDQo+ID4gdGFnZ2VyX2RhdGEgc2V0IHN0YXRlLCBwdHAg
ZW5hYmxlIGFuZCBkaXNhYmxlIGlzIGNvbW11bmljYXRlZA0KPiA+IGJldHdlZW4NCj4gPiBrc3pf
cHRwLmMgYW5kIHRhZ19rc3ouYw0KPiANCj4gV2h5IGRvIHlvdSBuZWVkIHRvIHF1ZXJ5IHRoaXMg
c3RhdGUgaW4gcGFydGljdWxhciwgY29uc2lkZXJpbmcgdGhhdA0KPiB0aGUNCj4gc2tiIGdvZXMg
Zmlyc3QgdGhyb3VnaCB0aGUgcG9ydF90eHRzdGFtcCgpIGRzYV9zd2l0Y2hfb3BzIGZ1bmN0aW9u
Pw0KPiBDYW4ndCB5b3UganVzdCBjaGVjayB0aGVyZSBpZiBUWCB0aW1lc3RhbXBpbmcgaXMgZW5h
YmxlZCwgYW5kIGxlYXZlIGENCj4gbWFyayBpbiBLU1pfU0tCX0NCKCk/DQpLU1ogc3dpdGNoZXMg
bmVlZCBhIGFkZGl0aW9uYWwgNCBieXRlcyBpbiB0YWlsIHRhZyBpZiB0aGUgUFRQIGlzDQplbmFi
bGVkIGluIGhhcmR3YXJlLiBJZiB0aGUgUFRQIGlzIGVuYWJsZWQgYW5kIGlmIHdlIGRpZG4ndCBh
ZGQgNA0KYWRkaXRpb25hbCBieXRlcyBpbiB0aGUgdGFpbCB0YWcgdGhlbiBwYWNrZXRzIGFyZSBj
b3JydXB0ZWQuDQoNClRyaXN0cmFtIGV4cGxhaW5lZCB0aGlzIGluIHRoZSBwYXRjaCBjb252ZXJz
YXRpb24NCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjAxMTE4MjAzMDEzLjUw
NzctMS1jZWdnZXJzQGFycmkuZGUvVC8jbWIzZWJhNDkxOGJkYTM1MWE0MDUxNjhlN2EyMTQwZDI5
MjYyZjRjNjMNCg0KSSBkaWQgdGhlIGZvbGx3aW5nIGV4cGVyaW1lbnQgdG9kYXksIA0KKiBSZW1v
dmVkIHRoZSBwdHAgdGltZSBzdGFtcCBjaGVjayBpbiB0YWdfa3N6LmMuIEluIHRoZSBrc3pfeG1p
dA0KZnVuY3Rpb24sIDQgYWRkaXRpb25hbCBieXRlcyBhcmUgYWRkZWQgb25seSBpZiBLU1pfU0tC
X0NCLT50c19lbiBiaXQgaXMNCnNldC4NCiogU2V0dXAgdGhlIGJvYXJkLCBwaW5nIHR3byBib2Fy
ZHMuIFBpbmcgaXMgc3VjY2Vzc2Z1bC4NCiogUnVuIHRoZSBwdHBsIGluIHRoZSBiYWNrZ3JvdW5k
DQoqIE5vdyBpZiBJIHJ1biB0aGUgcGluZywgcGluZyBpcyBub3Qgc3VjY2Vzc2Z1bC4gQW5kIGFs
c28gaW4gdGhlIHB0cDRsDQpsb2cgbWVzc2FnZSBpdCBzaG93cyBhcyBiYWQgbWVzc2FnZSByZWNl
aXZlZC4NCg0KV2UgbmVlZCBhIG1lY2hhbmlzbSB0byBpbmZvcm0gdGFnX2tzei5jIHRvIGFkZCA0
IGFkZGl0aW9uYWwgYnl0ZXMgaW4NCnRhaWxfdGFnIGZvciBhbGwgdGhlIHBhY2tldHMgaWYgdGhl
IHB0cCBpcyBlbmFibGVkIGluIHRoZSBoYXJkd2FyZS4NCg==
