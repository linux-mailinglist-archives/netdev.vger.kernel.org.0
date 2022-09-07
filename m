Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AA05B021F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIGKw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGKwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:52:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C352286B5C;
        Wed,  7 Sep 2022 03:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662547973; x=1694083973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cbIHZk40y3AGTrrtHTNG8SKbtkvVkrYl7A8H00EwQVw=;
  b=sAAaYqPuTy8LWgAWBc+aRB9QxFNJfgh968hAKIdDLbyazQ3gs9Tcbm/q
   GW7mdLlu1/O2D0oS1ue/rh42jYAwPfsX532l+7PZz1xf6Whyd1hu8el9k
   92eJAM7ggxyKnM4kDBSkaAEUcvH7zpkQLfAqjubwXQlqu7SBlBN3nB6VJ
   bdOCbeCP1/tuIxvn66/Fja/iOo3K85EH5Ns5WG6Puyn2WSYozxRsqPDlC
   BlbOsW2osNFzM7yEHhMwJ1tCbJ5Mi0FrKYqfOrxlAzHwsSxeN28GsUs+C
   9quk5K0JqPl0rBpl2ukavS5JhLAmZoM6QydXtdpK+UfPSf/Jb6om5k0nd
   g==;
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="112529508"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 03:52:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 03:52:51 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Sep 2022 03:52:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L301i2DpJGPVF/u9YBshHbMRFmN8MZCZZ681uWdTN415o9hb78ADjzOXnG+cioG8+gZXM97H/8F/6OnZ26HV0ARvYdF3x+OBNCAYwKScmtPFLZyRNJleYvY495wRKGcbvb/GXK42mFT7nFinMBpILZpKzwMqzGUELXPKmt7vFNEahwpx7BkCCSUCguVALGVyFnTTvemXQ/Orhp5OO5fSLC4WxB6yGNAq2LCdEAvD5HHww2RxjbgKTR2S+miIAJGkI6asuf942JnBIxlnpz4Nw8AvnWlTXGzdOE3LoC+OCqoR82vjTCbd9IW15oBaa1wNtpGPyjy00Krbd0IPUSo8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbIHZk40y3AGTrrtHTNG8SKbtkvVkrYl7A8H00EwQVw=;
 b=RnHUm/wcpsU4jg4dg7hGAdpcOvaxPaRhmIdkER0tC5sq3IRyGFSP5IVuINysXBTE4mEeUzn2ZH4TWhnIkQM8aNvSYK9MC9Egx1AnChd3qRyZ0/T1SjK2SrpQVg3C7imSmF7ew7oJAySJB0auJOBYwYw0KIm5Mvza6ilOCf0b36GyaMnGEVbtSYoT6dZvsPPPKICS4F0ENYbuG8SmBnk84n7jiC8x6ZQnqAgoBW+7dg+MKopEHCxPb+L0OQEFmMw6MYbhILrvveumS05v6bbdmsQdWHCiHNx4KGFCbC6sP6sI2IvEGHO6TigwM8sDZuCdpWUiqfbkoao3Pjj2hWxigw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbIHZk40y3AGTrrtHTNG8SKbtkvVkrYl7A8H00EwQVw=;
 b=a4tUP6R1qw8AnucbXgWDjWR+mK/SVZa+xmK/EFPPB8xlEP7Ea0YD4hnjOQbVNVYH5mUdPFknZmq/zan9NhTATAFBfCknUqxhOiXzyN8q/XaIaEel4WCZVz5fpbImEzeZqaSVdZ4duAzCwXoI1oHlXVM6N3Igo4Wi1mAJAXJRrq8=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 10:52:41 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::955:c58c:4696:6814%3]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 10:52:40 +0000
From:   <Divya.Koppera@microchip.com>
To:     <o.rempel@pengutronix.de>, <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <michael@walle.cc>
Subject: RE: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Topic: [PATCH v2 net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Thread-Index: AQHYwRDJNV3vhZ/TwE6+oYymZqWFva3Qz3OAgAFkqpCAADxPgIABRksAgAAWSbA=
Date:   Wed, 7 Sep 2022 10:52:40 +0000
Message-ID: <CO1PR11MB4771D73663D8754CF7E62827E2419@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220905101730.29951-1-Divya.Koppera@microchip.com>
 <YxX1I6wBFjzID2Ls@lunn.ch>
 <CO1PR11MB47712E1FAE109EEF5E502C5FE27E9@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YxdS6ygF7EdS/fy/@lunn.ch> <20220907093010.GA16112@pengutronix.de>
In-Reply-To: <20220907093010.GA16112@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|BL1PR11MB5333:EE_
x-ms-office365-filtering-correlation-id: f36149ef-4ac2-4e0f-26ba-08da90bf1607
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MOWduPaU1gEEN7LOIT80gmt328t6t/HSkPj1jgJuN30OKC8CaEW7q2igVhlQUpNd3/KUYs8/0t9NOguYcPF2lAWUpN2TKhhSk5hq/iPj9RYd3ttkLNRIEsu0YYWvRcIL36rqH0WyxIzZqs5CMdlilGfr9S3HoXYEQoO3GlX+GWCjAHaMp4sWvfXUhW+wb/M0r/cJPCUT+VNoZ8+KFlDIdoANhDZJWEaoMPyZXiFOHNgBJmzKW4UMOi6pfuqezJ85fAm6oW/KZnzRjch4X6F91kq3QT3knO4fzYZBUWGB0Vw9g2GV8ZD4wWVnEWHG7LEhFY7dxt2NYl6K0oh6j1qLv8nDpuse6VZhPA3+gfNne923lBA4H14y3LEALfKKOy8ZJ18Mq8GIi4HzXipz1XvNi7rUbY0+OJH0QC6iMvsNjm/c6PBHyDEsitM5bcHnPEL7H7XCu03dFY1VixlKzyJVDDxwbIqY1EoRkbgmeiBvamEByTDAJbDVk8PBDfotjYrCU+Q+SvO6JNLtW3nt2VANDrVtRu88omCuVr+UYyWsMRnHkQJHe3JCor2ovih1p211rt8DGKSQcqIWXt4ku1VLrFhEngkEAxLB1GqLKYXh0l9DvdmJlIO4AO619dU22HJV9DuND1Ajiva8z0/UiqTSSecdKVdepzYo2ZvYVhhhUac1lZOkqcDkqyS5m5Nyw6kH8DF4DJhnnXDJ682hjcu6SrKzt5sozPvqaKuOzWTAlqxOls7z5TSi2JSN6zPqxpy+Evw9S9V08t21bWRwU+wKMc4ODk3RMWWTUE4/nZeeZe4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(346002)(136003)(376002)(396003)(71200400001)(186003)(33656002)(83380400001)(8936002)(4326008)(8676002)(7416002)(2906002)(5660300002)(52536014)(9686003)(66446008)(122000001)(6506007)(26005)(66556008)(7696005)(53546011)(38100700002)(76116006)(64756008)(86362001)(55016003)(316002)(66476007)(41300700001)(110136005)(66946007)(54906003)(966005)(478600001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXFqY2NSVTVHUEd0czN1V251YzFPM1pLa2w2VVh6WGVubldnUlRPRnZKTHlF?=
 =?utf-8?B?eVpPOU9XZit1dW1wODN3NHAzemVpcU0rRjhCOFlEM0tmTkNEbnRLNlQ2M1RT?=
 =?utf-8?B?bmx3WnV3UituNFptRlNIN2o4WURUT1ppOWVZY2FrRUxEenBOb3RUbWVFRlNV?=
 =?utf-8?B?OFlsZHltaWxJc1BhM3pEUmZtTFVKLzN5aHRja3o4RzJTNWkvS1pLallWa1Fz?=
 =?utf-8?B?OTUwWGZ3NDRDSkNvT2VGYU1rYnJ2MXoycGJQN2l4UTdNUHplOE9KWHE0eEdO?=
 =?utf-8?B?ZThEdWs3cmZkMXRkOXBPUTlVUWRLQVFTbGdKMkpXTUJCMGxHMk9Wa1BMN3Mw?=
 =?utf-8?B?NDlKbG1YMkd1bjBCeXY2TXQ2T0UrS3JOdkVrdlY0NXMwTURBcm9lQzlXMHFx?=
 =?utf-8?B?S1IrRitBZXdZV3pnZjVFeEhTY2g0Tklqbi9mTkEvRm5zdmtqUnYzczNRR1FQ?=
 =?utf-8?B?M3hEbzdzRnpYZy9FT1R5K2prYlptNTBUZWlCNm9vNkt4Mmc4dDQ2UlBYcEUr?=
 =?utf-8?B?U0hNSWpORzRBWm1yZjNMME1VSjNzSC8xTHNCRGNFT1Y3Q0dqbHNvUllVNGM2?=
 =?utf-8?B?c2JJQkdNL01jc3k5ZzZxT2xQdGQ3dFFpdU56d3hmM0ZzQjBjc0NWVkZsUlpS?=
 =?utf-8?B?UGpOTEtkWFl2eVMwM1V0RkRLN3lyZmFUNEJpMHRsaS8vSyttNXMwTnpmMGxy?=
 =?utf-8?B?M1ZlL1lPSXhDZ0xWWW9wN2kvZ2hVelB5RjZJVGdKemNycDdidnhBNDNCa0Zu?=
 =?utf-8?B?djJOZzh6V0ZjbmFXNDVTczREZTg4UUo5VFRvc3pGT1p0elVyV1loenQyWjc3?=
 =?utf-8?B?T0ZXQkNGQkFTdUprVGlDRWlGSG5hUnZUSmcxTnh5VGx2cElxTTFZbU4rWXRu?=
 =?utf-8?B?YmpTb21weldSUHc3T1R6TWtPWVZrRU1wdnVvTjNjWUNiSHh5S1lYMTRSaWtx?=
 =?utf-8?B?Z1hmN3loU1FaZVdSM0J5YldqZ2czdWx2ZVJ2L216LzZBc204Sys4V0Vxb0Z5?=
 =?utf-8?B?dlp4TWVKQlNsZVF1d1B6T2tXcXdzSm1WelZCeGFrcW1ua1NTNm9pZXNneTlX?=
 =?utf-8?B?blRHUytiOHFxQ1FNV1I2enVtK0FSY3YvZW1sUW9JV0VtOXlSeTVwYlc2ckV6?=
 =?utf-8?B?WnFHajBZaXVheWtNcE54NmNFY25BL3c5dlhSNU9jNklxTmFqRGtzUm15VmVn?=
 =?utf-8?B?WUxGenlqM3BkaDdhYU94QURaS2phMkY5R1NJNVVLMEt2YmVsV0pFRTV0NXpz?=
 =?utf-8?B?RU1NZ1RjOWlRdUZyMVowMDUzZ2sralUwam0yZm5VTnNzVFk4UUk1bEVtNmdZ?=
 =?utf-8?B?NkMzL3VaZGpTQ05ld1p1NUduanRXUmgwUnp1MXF0Z1dZUVZ3am5zbHBQdndL?=
 =?utf-8?B?K0lOclUwcThCQW02aDVBMTBUS1RBQnV2TEp6TVFrVFZyODBoOHJZbHZJckRr?=
 =?utf-8?B?NFdaZVc0UFBkQ3FVb2s2VlpFSy9jNjMvNmdCWlAyenFHMzBDMkE4OGJZV2gv?=
 =?utf-8?B?N1BPblcvekVPUlNzTTNJOUE0cE1JMDJlZnlGMDUvR3dJM3ZiRTdOUStvaEw2?=
 =?utf-8?B?cVlzcGtFTTRyZklOdkVtK3NMKzdQaHllZGZXT01yZVB5SlkzN3o3TzU5bTdy?=
 =?utf-8?B?Rm5sY0s4dXo0RnkxZENQenl0SjZtRmpGK3Y2clZsSW1kMitkbUtwRUNaUGxu?=
 =?utf-8?B?d2hpei9SS0R2RnBEVXhVQlJ5Y2NXeUVQY05lMjh3U2o1eGx5dU4zMldrMFNP?=
 =?utf-8?B?RTRvcDd1blNHM01qdDh4ZXFuZVR0Rk1KSVlDc1JKQTU5MG8wenpsUVdBT1B4?=
 =?utf-8?B?cklyODRXRndqWEQ3R1NaQldTVk1xL3JxcUl4eGVZWkgwb0o5OFV3N242Tlc0?=
 =?utf-8?B?djNCcFowS2laOUFDbDNMZFR5YkpCRHZkeUIxaW9zR2puWW81Z0JiOTBYMkRp?=
 =?utf-8?B?Z1lSQTB0RHVhRDRYcXZIbVlCby94NDBucVhERTl0dnlsSStEZVIzYitRQ3l3?=
 =?utf-8?B?K21lS2tyay80cmRCZzV1L3loczV0Skw0aDJSdVRNRXdscm9jaHpHT3d4VGxW?=
 =?utf-8?B?M1BHOEVlNGZwUWxEUjNuVlMvMUsybXFESERpYmhyZTRmMDkzY2U0VGJkYUwr?=
 =?utf-8?B?Q1hFamJLZytQSW5zWGxUSDhaWENkT29UTC9JdlFnYlViaHFXWHRpSXZEaWU0?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36149ef-4ac2-4e0f-26ba-08da90bf1607
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 10:52:40.8754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSEzmsUvg2esPH5oHpaUWvY4RrIVyZ5BFTr2ntt6nbpv/eWbpss8PuXIC0xY7lHEWvveQa8S451Kk7Cl1D1xt5mf6uoffa29/qXDaSs811Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5333
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xla3NpaiBSZW1w
ZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJl
ciA3LCAyMDIyIDM6MDAgUE0NCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4g
Q2M6IERpdnlhIEtvcHBlcmEgLSBJMzA0ODEgPERpdnlhLktvcHBlcmFAbWljcm9jaGlwLmNvbT47
DQo+IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBhcm1saW51eC5vcmcudWs7IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFi
ZW5pQHJlZGhhdC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IFVOR0xpbnV4RHJpdmVyDQo+IDxVTkdMaW51eERyaXZlckBtaWNyb2No
aXAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIG5ldC1uZXh0XSBuZXQ6IHBoeTogbWlj
cmVsOiBBZGRpbmcgU1FJIHN1cHBvcnQgZm9yDQo+IGxhbjg4MTQgcGh5DQo+IA0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZQ0KPiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFR1ZSwgU2VwIDA2LCAyMDIy
IGF0IDA0OjAyOjE5UE0gKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+ID4gV2UgZG8gaGF2
ZSBTUUkgc3VwcG9ydCBmb3IgMTAwTWJwcyB0byBwYWlyIDAgb25seS4gRm9yIG90aGVyIHBhaXJz
DQo+ID4gPiBTUUkgdmFsdWVzIGFyZSBpbnZhbGlkIHZhbHVlcy4NCj4gPg0KPiA+IEFuZCB5b3Ug
aGF2ZSB0ZXN0ZWQgdGhpcyB3aXRoIGF1dG8tY3Jvc3Mgb3Zlciwgc28gdGhhdCB0aGUgcGFpcnMg
Z2V0DQo+ID4gc3dhcHBlZD8NCj4gDQo+IGF1dG8tY3Jvc3MgaXMgcHJvYmFibHkgdGhlIGRlZmF1
bHQgb3B0aW9uLiBZb3UnbGwgbmVlZCB0byBmb3JjZSBNREkgb3IgTURJLVgNCj4gbW9kZS4NCj4g
DQoNClllcywgaXRzIGRlZmF1bHQgb3B0aW9uLiBTdXJlIHdpbGwgdGVzdCBpbiB0aGlzIHdheS4g
QWxzbyBJJ2xsIGRpc2N1c3Mgd2l0aCBpbnRlcm5hbCB0ZWFtIHJlZ2FyZGluZyAxIHBhaXIgYWNj
ZXNzIGZvciAxMDBCYXNlLXR4LiBNYXkgYmUgaXRzIHdyb25nIGFuZCBpdCBuZWVkcyB0byBiZSAy
IHBhaXJzLg0KDQpUaGFua3MNCkRpdnlhDQoNCj4gUmVnYXJkcywNCj4gT2xla3Npag0KPiAtLQ0K
PiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfA0KPiBTdGV1ZXJ3YWxkZXIgU3RyLiAyMSAgICAgICAgICAgICAg
ICAgICAgICAgfCBodHRwOi8vd3d3LnBlbmd1dHJvbml4LmRlLyAgfA0KPiAzMTEzNyBIaWxkZXNo
ZWltLCBHZXJtYW55ICAgICAgICAgICAgICAgICAgfCBQaG9uZTogKzQ5LTUxMjEtMjA2OTE3LTAg
ICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgICAgICAgICAgfCBGYXg6
ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
