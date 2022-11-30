Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A934D63CE6B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiK3EmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiK3EmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:42:06 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5D05A6CE;
        Tue, 29 Nov 2022 20:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669783325; x=1701319325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tXeIVxmyJoQX83tVIK+8HvhWcVxJ7HcJ/J3l6DqTbrM=;
  b=B3qF6FcdVVvxbQyR/HmeLq3V0Jng5scbqX8vqHwrxBVrFTujDsGetGWs
   dFdWinztUGBJuKB9M/ncJRg+U24DX2mMsS6l5hxU0FmdkSQmJ+rdTu7Dy
   zHU5XNA4h/ITSO6/U+ssodcPcXsXBQVdpauSxzn6HfehElNxFrDf4JIhH
   X3KJuGKqqr4ZObFugN2EStuF6wGItewFvT4wrzNihHCB+/YU4YjRy12YY
   oIQLBkyrgacJO6aaHKZ5TGYfwnwNl2aul7bRX9VHAcZPZ5gXz8V5TfhRp
   1HITI/HIkCKIAgGX7paG7nQmMETD/CNq/0eb928qgVuk5IbiH9kzkMutc
   A==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="125741519"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 21:41:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 21:41:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 29 Nov 2022 21:41:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD6IVvhHP+66Xbx8htcCdhVysPQrZof+yaH4+JcAXN/IQF/Y+EIOwquT4AzWWpGN9mMBONesLQllAxei33mS/urMjvxCAh1eyGWvOpZ0/Miz+kYNK6th6pAd++Spy+QNQdzpFMeuradJzRkqYYX+Vpcd3EkWQ81/2Lk/KaErskcawHf/VS3TVygP3MT27rSI0/Gl45Mh39G0R97xaWEKdouT3UdOsxlIurlFoVA2o9GHmKzZcWRCyleFaMDyMUMHAdIxHunDKdNNPD7101R2RN6XLxs1WnhsqzqDjgx3aRwme9cpkdLtgyo1UKEI5NSZm3NGFOoO1sRBKfaMipjIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXeIVxmyJoQX83tVIK+8HvhWcVxJ7HcJ/J3l6DqTbrM=;
 b=d1SPrnjL1VRZe+iUcdSxnOyxHggiAJ9QAIOzBhIpDgLkrap4KOG2mcco8OnK/Ask8vN7NjY2a41RI8r9ZAKhCsvLamOw/RIbEhSB0ewCZ5GPJZSQkxlrv1pNqXkYkHm9mI8OcbEmQizoUNs74sj44nT6+++cY4HN5hZW7GapUBEmAo+qc+82snOqpr8F/daAMy30AJXkJRuZ3HmwUCXjMEYdwFYxR89RV8mokEJiUl5j3RZGe46G5tZTpuIEMXQxhzS2BZAZHuWSNgplEEyKnxosDcMNmKyaa3DHn3l2k6CsdBIC83x3cUNG6nMKwy3ctz2jXMEfHvQ0uF3ZPVs/CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXeIVxmyJoQX83tVIK+8HvhWcVxJ7HcJ/J3l6DqTbrM=;
 b=GJe2+G63k2VB7s4LxXkHFYMAwrnuOjq96V3EyzIUBsg7GdYUqO9m616pfeB4KXBjg27nhYQ8V1hmcyLe0bNTEr2fJbEhW/tDOIDBsYgvrDvSMi15DY6wCzvJ4w/3YUidHyBJvIFfDBeMUIYtJUu1xLnaNcKt+BJ/yjXmYuDKM8s=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 04:41:38 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:41:38 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pavan.chebbi@broadcom.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 11/12] net: dsa: microchip: ptp: add periodic
 output signal
Thread-Topic: [Patch net-next v1 11/12] net: dsa: microchip: ptp: add periodic
 output signal
Thread-Index: AQHZAxUMvqen7Moqn0qCt6IBoETj6K5VmgCAgAFL5YA=
Date:   Wed, 30 Nov 2022 04:41:37 +0000
Message-ID: <dcd59923c73cfa5535f9d68754599ace01bbc030.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-12-arun.ramadoss@microchip.com>
         <CALs4sv1hZRRdLGCRMLZxi2GjJ2NHYu2o9j5oNf3+BpTZKpdS8g@mail.gmail.com>
In-Reply-To: <CALs4sv1hZRRdLGCRMLZxi2GjJ2NHYu2o9j5oNf3+BpTZKpdS8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA0PR11MB4734:EE_
x-ms-office365-filtering-correlation-id: b6e60da0-3edb-4f45-ca08-08dad28d2b14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TSI67pSKVpN9JA0C0klRhqmujaGxTmbsN06alNtok7awCaiTzjqA5cAwOh/bAM1+d0BkUljDiYjrH7AHZgWrnW+I6autsNW5NkuYWaWrZ81259OprejU9GOPQhplKO1fUminvZbHAb8rWcXVgwFUgeG1yUVhIR5YLhBmhXPa8KWnbmEPSkfSIssuz+aN0srLT2mdsKjed/pQRGWPfX3j2Cmpu7r6FuA/onlaHEQAz5Bb3y4tzEfOA9Bf8rOXWlPMnRjMiRVqalv6Dvck/fG5DlDbkIyN/Ajr1208cvM5Mv4CBO0UAUa6Dg0lUqugbsi8vXDHWfThWLLL9q9DSVSMiKodIy0saQIIN1dDannxmtfrvYU3KqHzAGj/Wzoqs5GoPFKwxG2BDHuJblRLh7Qwp1myTqGRe75nRiXnmRswQh/DxYyHAqfPfic4vGxtILigciMPcokXjPo3QPpnwzOA48rprVygpHTygD0vvF1TimQlstzcjlkCglnpOnjcW7YJAKsfUfTjbrrlK7wrem7X0BEvn+G/FAq4SuftZg/wO/ZJyPWTWiON6J887uvXPAd8LHHhNwMJVLAvfmzIp0A2G0fekJJn1UsCaUQxIZXzlohwBCQUPTN/yjHK6jG7lEG6AInX59z8zc8Tg1p9kdyrIql2QEQ4uTuSrkyrF7NEcfaJNOrHv9LM4s8IDwyjeQrwu6cC5rR7MoIJ5R/mMP3+ubOh0DEFVGCyZ4SZvYXRBc0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(8936002)(76116006)(5660300002)(71200400001)(8676002)(186003)(54906003)(36756003)(64756008)(4326008)(66476007)(6916009)(41300700001)(6506007)(66556008)(316002)(91956017)(38070700005)(38100700002)(83380400001)(6486002)(2616005)(26005)(6512007)(86362001)(478600001)(7416002)(66946007)(66446008)(53546011)(122000001)(2906002)(4001150100001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2hTZ0YxQ2hMdURSNHI4bkRCNzhhOEFIZzJqRHhGLzhnVE9oTzZVRnM0bFh4?=
 =?utf-8?B?b1dBM3BSM2xWRXdsN0ovVncxcUgzb3dwRVNFb2dKeHVFaFZSaUlTMTVmY2ZH?=
 =?utf-8?B?d0tpR3BrbWxEaE1CS1Q4YVQzV1ZjMzJGSC9GRUFFU2t5aTRSZmxJMm9YSGpk?=
 =?utf-8?B?K0ZFZzY3azJRbWg1eTEvZVZjTjdjRVNtRndYYmNMMnB6dTRxRk1memQvOFov?=
 =?utf-8?B?aEVFSWJCVXI3TzlNSGRJSFByU3U2elhjaXdJbC9UWjlNR1VMakZZamxDTzBZ?=
 =?utf-8?B?MDJsOTNoS2pVMkQ5Wm5XRkIyWFlIYldKZW1tU0M5UkltTXpPTFB0aHM4UDVD?=
 =?utf-8?B?TDBmanlkVjRHSzRQc0E4aXBEdkNQWW5oamVPODNFWndDVWxiTzFodUJkKzV5?=
 =?utf-8?B?blM5UklyY3FDaUN3Z0NSNW1HWDBlUkY0eVExdERzY01SaXkzeGJ4OUNONVB3?=
 =?utf-8?B?MURJMytmbkpKY1diMWlWK25xWHN6TGVPMkYxNFphVjFOWnZJQWVlVllpNmUz?=
 =?utf-8?B?THhzQmxKN3BSdnNNVHFOdXJRaUpwanN4ckRocERoSXRibEpuanZEeVAxT3BF?=
 =?utf-8?B?ZmRFR0RDcHZDT3l4RU8rZTJ0Smhid3pwSElOL3pqTUlWcDdaSVMvd01NQ0Y4?=
 =?utf-8?B?ek83L1dHT3RJczFERHR0dGJCMWdQUkk3VGE0NUhFdXIrbjNGcitmU0QxMzZp?=
 =?utf-8?B?OG56NFI0eGlMTEFkM1lKMzc3VkVleWZ5SjQ3U1M4R0U0RmpxdDYzU0ZmbDNu?=
 =?utf-8?B?YkVHMU9IZDV4VTZVTXE5YXhNbFNYbDlnYXNXNmhFaTMvcGRnUjhFTG14T2VI?=
 =?utf-8?B?YnN5c2tWSUJ1M0pVenpOdENwLzJ1dFhTZWVmcFVkaVNodUVUSElwcVlkRFAy?=
 =?utf-8?B?dFBZa0U1VTZIYUF0V3FLUnNyREpGekhMU1VqMk4yRlNUUEw0ckhrSTVwZU1V?=
 =?utf-8?B?R001cEJqaEpKTE5FaTlYek8rWGFCcm1PWUhEbjFndWt5SGI3MktsWEIzbjMw?=
 =?utf-8?B?aGwvcndITmxCd0xjekhFbXZ2TzNGWFI0UEx5T00xSlg5VnZXdzk2REpYMmdt?=
 =?utf-8?B?cU1uU01QZTBrRDRzeXkyTzI1cUZBK25FUkREd2RPK0NXT2lmTWp3VDBKT0lV?=
 =?utf-8?B?VWdzTTVRWkYybGt5di84anlHZ2doUU94NmNzbjkweXlPMUd6c2RZSjJFMjF6?=
 =?utf-8?B?OS9mMURlQ3RucStuNFZhQWhOUW1TM1FQZnVxM1UvVXZtZWwybVN6NmRCbU1i?=
 =?utf-8?B?T2RKSW9TWjMrdW1hRkNNYmwydnE1OEhaUzRiUnJBM2xrNHpVeGlKazUycmZF?=
 =?utf-8?B?TFU1VUM1bHppc3JBaWlTc2lEQ2lvN1FoaFhwdUh1RGpGVXpVT2VZK3MzUWVu?=
 =?utf-8?B?ZWlkZDRRZ0psN1lmODlaWG81cGZsM1o2a0xQeHprMFk0RUg2U1U5dDZhRk43?=
 =?utf-8?B?cWphZHVhY1pYNi9LdDdRdStyWnQwTjRRdkV6WkRnSUdRR3Bmd3VIMnE2eFdz?=
 =?utf-8?B?TTlpTnIwMU5ENHc1YytGQTBKNTRjYXZnNG9LL2U1TWZscy9tRGl5SStqUktk?=
 =?utf-8?B?djdrclEvRnh3TnFvejltSHNXUGlRWHZmQWxzN3lOMzlDdVI2elRTVjVMT0F3?=
 =?utf-8?B?UDA1RWFGb2xzNzNrbytuTVlCWm9CNjltbGNBNXlQMlNaU0oveE03Wk9sMkx2?=
 =?utf-8?B?ZkIzbUkzMmxnSnJpV0x3Rm54MDRkOXl5MHU3VDJSaWkrTmJNVFdha0pCTTdU?=
 =?utf-8?B?Si8zMk5scTZYb2Rrd1VUZzJ2VUV1cDRrMERTSlhlMU5nYlVGazA2OTJWMTdv?=
 =?utf-8?B?YU5yUHVUcTNjcmtzVHZiUmRsUVBaam5OUndDWmhRUWFqSzBvK2c0OXFwMzFy?=
 =?utf-8?B?MEpQWjRUOFFBYXlFVnRVeXluMk1xNmMvcXhZMnNlUmtMY2ZrMUZoMDBkZWRj?=
 =?utf-8?B?bWJlU3l3cURPUHc1cjBadHVvT3pmQm9LQzJxeDB5b2p6YitCV1JGRnl4MUs5?=
 =?utf-8?B?UitJRWlKVlNMUzdaQjlZd3BtTjFNdjJLYmpJYi9HVTZxK1VDRWpVMk8wV0hw?=
 =?utf-8?B?aVZ2YzV0NEU0UXFkQVlUcVNNT0NydmtDb1RTTkhpRjdNbmlNcUZWSlFzWHdH?=
 =?utf-8?B?ZnUrcmVHenE1YWdBaWgyQTFCekVjSG1wZGJUdXplaHNHYmlMOVpPNFoxKzZB?=
 =?utf-8?Q?tg0Tmc67VXhEmV14eVagZEE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5F43BA3D4C3814F88A2F669C44B7CF0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e60da0-3edb-4f45-ca08-08dad28d2b14
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 04:41:38.1038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nryyloddVFOCQ/7Vl4CVhM4hqZwrqc9M6UlkMT+HgT3AIk6Gr1IZFgawCQe6WpmPM6EyJFMPmMrLzS89HETprJ31IHMtwGTB/g+ASlYfcJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF2YW4sDQoNCk9uIFR1ZSwgMjAyMi0xMS0yOSBhdCAxNDoyMyArMDUzMCwgUGF2YW4gQ2hl
YmJpIHdyb3RlOg0KPiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCA0OjA1IFBNIEFydW4gUmFtYWRv
c3MNCj4gPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+IA0KPiA+ICtzdGF0
aWMgaW50IGtzel9wdHBfZW5hYmxlKHN0cnVjdCBwdHBfY2xvY2tfaW5mbyAqcHRwLA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHB0cF9jbG9ja19yZXF1ZXN0ICpyZXEsIGlu
dCBvbikNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IGtzel9wdHBfZGF0YSAqcHRwX2RhdGEg
PSBwdHBfY2Fwc190b19kYXRhKHB0cCk7DQo+ID4gKyAgICAgICBzdHJ1Y3Qga3N6X2RldmljZSAq
ZGV2ID0gcHRwX2RhdGFfdG9fa3N6X2RldihwdHBfZGF0YSk7DQo+ID4gKyAgICAgICBzdHJ1Y3Qg
cHRwX3Blcm91dF9yZXF1ZXN0ICpyZXF1ZXN0ID0gJnJlcS0+cGVyb3V0Ow0KPiA+ICsgICAgICAg
aW50IHJldDsNCj4gPiArDQo+ID4gKyAgICAgICBzd2l0Y2ggKHJlcS0+dHlwZSkgew0KPiA+ICsg
ICAgICAgY2FzZSBQVFBfQ0xLX1JFUV9QRVJPVVQ6DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChy
ZXF1ZXN0LT5pbmRleCA+IHB0cC0+bl9wZXJfb3V0KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiAtRUlOVkFMOw0KPiANCj4gU2hvdWxkIGJlIC1FT1BOT1RTVVBQID8gSSBzZWUg
c29tZSBvdGhlciBwbGFjZXMgd2hlcmUgLUVPUE5PVFNVUFAgaXMNCj4gbW9yZSBhcHByb3ByaWF0
ZS4NCg0KSSBnb3QgYSBvZmZsaW5lIGNvbW1lbnQgbGlrZSBUaGlzIGNoZWNrIGlzIHByb2JhYmx5
IHJlZHVuZGFudCAoYWxyZWFkeQ0KY2hlY2tlZCBpbiBwZXJpb2Rfc3RvcmUoKSBhbmQgcHRwX2lv
Y3RsKCkpLiBJIGFtIGxvb2tpbmcgaW50byB3aGV0aGVyDQp0aGlzIGNoZWNrIGlzIHJlcXVpcmVk
IG9yIGFscmVhZHkgaGFuZGxlZCBpbiB1cHBlciBsYXllcnMuDQpJZiB0aGUgY2hlY2sgaXMgcmVx
dWlyZWQsIHRoZW4gSSBmZWVsIC1FSU5WQUwvLUVSQU5HRSBzaG91bGQgYmUNCnJlYXNvbmFibGUu
IEJlY2F1c2Ugd2UgYXJlIHN1cHBvcnRpbmcgcGVyaW9kaWMgb3V0cHV0IG9ubHkgdGhpbmcgaXMN
CmluZGV4IGlzIG91dCBvZiBib3VuZC4gSWYgd2UgcmV0dXJuIC1FT1BOT1RTVVBQLCBpdCBpbmRp
Y2F0ZXMgd2UgYXJlDQpub3Qgc3VwcG9ydGluZyBwZXJpb2RpYyBvdXRwdXQuIA0KDQo+IA0KPiA+
ICsNCj4gPiArICAgICAgICAgICAgICAgbXV0ZXhfbG9jaygmcHRwX2RhdGEtPmxvY2spOw0KPiA+
ICsgICAgICAgICAgICAgICByZXQgPSBrc3pfcHRwX2VuYWJsZV9wZXJvdXQoZGV2LCByZXF1ZXN0
LCBvbik7DQo+ID4gKyAgICAgICAgICAgICAgIG11dGV4X3VubG9jaygmcHRwX2RhdGEtPmxvY2sp
Ow0KPiA+ICsgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgIGRlZmF1bHQ6DQo+ID4g
KyAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4g
PiArICAgICAgIHJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4gIC8qICBGdW5jdGlvbiBp
cyBwb2ludGVyIHRvIHRoZSBkb19hdXhfd29yayBpbiB0aGUgcHRwX2Nsb2NrDQo+ID4gY2FwYWJp
bGl0eSAqLw0KPiA+ICBzdGF0aWMgbG9uZyBrc3pfcHRwX2RvX2F1eF93b3JrKHN0cnVjdCBwdHBf
Y2xvY2tfaW5mbyAqcHRwKQ0KPiA+ICB7DQo+ID4gQEAgLTUwOCw2ICs4MjMsOCBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IHB0cF9jbG9ja19pbmZvIGtzel9wdHBfY2Fwcw0KPiA+ID0gew0KPiA+ICAg
ICAgICAgLmFkamZpbmUgICAgICAgID0ga3N6X3B0cF9hZGpmaW5lLA0KPiA+ICAgICAgICAgLmFk
anRpbWUgICAgICAgID0ga3N6X3B0cF9hZGp0aW1lLA0KPiA+ICAgICAgICAgLmRvX2F1eF93b3Jr
ICAgID0ga3N6X3B0cF9kb19hdXhfd29yaywNCj4gPiArICAgICAgIC5lbmFibGUgICAgICAgICA9
IGtzel9wdHBfZW5hYmxlLA0KPiA+ICsgICAgICAgLm5fcGVyX291dCAgICAgID0gMywNCj4gPiAg
fTsNCj4gPiANCg==
