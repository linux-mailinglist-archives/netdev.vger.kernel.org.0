Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C86369DB02
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjBUHOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjBUHOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:14:14 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E048A67;
        Mon, 20 Feb 2023 23:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676963645; x=1708499645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2E+5H5UQAjT58R67+x1FQq7G7i1b54+5yw9c9XuD1Ug=;
  b=usVwGIiMjfgou2GRgyCjujKuC9UQ+LZWT9iFJtUVZ9YC4SkMsNYXR/1s
   U0rcE1erE16AWHLB0kUBT47x3Qb/l9kC6+KePg83n7D23cfLSLyzXME+u
   h92/US8nrTDO6vT0pprcZ7Nq840ZgUj47n8LgcwL4n5DiLoNXn/Jm+pZU
   zWJ0+Yuj9djJ/YYf7/DAruA+cQgMhaIwj0cd1Kzqmf6ms4eKxhm/G+a5G
   yxYvOXRy8ypEyPgjzbVAEo5qOgsyDiV9LQVrT3X8TcPITQUD4DDz6bmNx
   ztuJpPoA73vOFD/YzqWd4ItgZ1Lq5l7layhSOTShqxkDUxdANR6iJeUAz
   w==;
X-IronPort-AV: E=Sophos;i="5.97,314,1669100400"; 
   d="scan'208";a="201577027"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 00:14:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 00:14:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 00:14:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGzksVZ2qbBbtfAU844Nz7wCXTMBV/s+Bw3TENPadaYi9QX6BTNoXe4NhL3PVIeuZ7limP5cohFDuXsFw3Xo3zOm4Ah9bBJlxaVz6a1yI/DyisKHAduuF1ZYubi1IA0k/k4BPywl/lxg/3057l9smm1DvGkk9sE/m3qsU8kmAzed0JwLWQghVPPN3JYKv0RP4eMenAe5jcb2EqnCUq4C5tIAuvBqeXSyiSaYQR93esZkKgyQ8Nw5p8F2eA1P9ehxFidQu5ZedNX6l2u9ZdFCrSVttlLj3Hbi8UQwUX8y6rG/VFpr27+JrHJ5lP6Ww+BuIAcq+3kfNhHNDv2/q/FddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2E+5H5UQAjT58R67+x1FQq7G7i1b54+5yw9c9XuD1Ug=;
 b=WmDki0CZXU/5aQ1Jn/OlFJZgbtSzEIvNJ2JBcqYSE1GRZW/h7R4Bapfd3MJmq0mcgyxlxI/R/SCAjBUCcKprUHIUiGYqyFg2f/DbTl0xRxhCsV/X4hu8ZUsrrvsKpgkf890QGmVQRVI7I9rIeV4wmzxpb/IraUz0VXK8k9rRWwNAwH+FWvHF2htabGhgNLIOvQ4qY51k3KCEGFsjjQCMxJvrq+OgWd6tAlZBfd0OzboR+xYtstAu2bLVvpw1TfGLgrY1enAIvywdpsKo6WiW97ZE/ppzT9lSkhZnSW9O353EiCo2/CuKQXUPyqEEC4/ioDonTcKrP7ocJTpvkgbMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2E+5H5UQAjT58R67+x1FQq7G7i1b54+5yw9c9XuD1Ug=;
 b=QlOakBk3y9xg9Cn4+9qkRAm570xzel2GibBUo6w/Nhn79aUJAjMUD/jxDcCgdcNk4B/3Si7xSbSCgBI85M+pEdK+2oogfFTTA2fohyP+z89/DzqaNg03Sl+gJfeS2XyCyu4/jGrrH5ohrp8UhGvSNBUA8SJWa7puKFb/Zhz4yWE=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Tue, 21 Feb
 2023 07:14:02 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e%8]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 07:14:01 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 2/5] net: dsa: microchip: add eth ctrl
 grouping for ethtool statistics
Thread-Topic: [PATCH v2 net-next 2/5] net: dsa: microchip: add eth ctrl
 grouping for ethtool statistics
Thread-Index: AQHZQr9Ndv2ewSrRn0OEgNzS+6trda7TX2IAgAWjl4A=
Date:   Tue, 21 Feb 2023 07:14:01 +0000
Message-ID: <e22ad18ecc0e6289b783971fe38f1f7a4df9f012.camel@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
         <20230217110211.433505-3-rakesh.sankaranarayanan@microchip.com>
         <20230217170822.w65c72hsbbnoqcab@skbuf>
In-Reply-To: <20230217170822.w65c72hsbbnoqcab@skbuf>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|MW4PR11MB5824:EE_
x-ms-office365-filtering-correlation-id: 859db52d-6447-4d38-e40e-08db13db3504
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ycVr8YlL72Yw8qZUuLHfnui1ZpFoRDQm3+OwM1tlykqXZ4Mz8C+I/Rj85J0jHtj0B6RC1RyLevhUISyzFneH5MSydS4hzG2J+tq5h0W1zzDTFQGAIEmO4YPIgxhTjNGBK6A9E+RnFfIcKRZOsL0kDPk9MmHLXhhnmWFf/cfEBsNRnyvTf/M3klSRUovdYwGKcL7coLQEXxcYGGsnm69ApKtUB9Kw9sSkYlM+CtMswAcUXBIUU5XoIM9dnQMUU1/NVI/NhrJ55nB7W32FUJBF3ix4JjN1uQwoHsNYq1Pg8KhVCdUGpGsK2SzZcPMFUmddY1KWD/hiKMd/vlqzqyeq8Gw6Tr0vzWSY9qT6el6rFFVRGFaOWuOATkfZ0mYnjQWzTv37lRz4BVUrXXKNPQzeF3FuzLcsp7j933LsrTUPgEcVs5Z/rkVlnrLGRA5BYCRtnuOQrSHqzYKcen+3oTjKQ8+ekyzur2q/yn2O9eJcLNM/Wth9b9w1ZhNGqpwLVJv+mJTTVA4GWS96gd1FE2wjo6+r2/EVgs7oErYw+i6umFNl+H8CGMNJO/czqox//SWljmjZrxccIv2DDSVijTD+ImfK7f03Ul6aeJ5of3JbR/cv4G635fkV4rFZzyRF2fIVBCy6PsBqxADdtzb+JcDL3Yp6SJtFo2sdUs3j0I/sd4e1fEFr+CiIa8BzvRWSoF/hV1QjLun5VBh4YnBL8froiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199018)(2906002)(5660300002)(38100700002)(8936002)(26005)(6512007)(186003)(4326008)(41300700001)(6916009)(8676002)(38070700005)(66556008)(66476007)(66446008)(66946007)(64756008)(316002)(86362001)(83380400001)(122000001)(91956017)(6506007)(76116006)(478600001)(54906003)(71200400001)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHJwSjA5aDRMM05ROXp6a0RGU2NuUk5LL29vaTlLbmNBUXJnZTRxeDlucFV1?=
 =?utf-8?B?SUNVckpMenJNRVdyUVZtRkx1YWRFMkVSZCtYdmY3dGRkVW5reUpRRmFPSG1s?=
 =?utf-8?B?RHBOaEhTeU9nUW9DU25ST2hWTkZ2RDVRMDd6QmNoS25PU0pUaE0yb3NPYWVE?=
 =?utf-8?B?WFpCTng1Y01ibDE3d1lmbis3RWNiaEdvMHVucEpteXZ3TCt5b3NBZTBIc2JZ?=
 =?utf-8?B?WmNCVVdVVkQ4dWRSZmNlQnhWNytFVGpWd0FXdWlseDc0SWZ5NUVXWnJ1clJP?=
 =?utf-8?B?elFmZ1FycklhK25MUTZnUnpnd1orUTBnVHhlOW9FbVpBQ1h1OURYdmVWMmg4?=
 =?utf-8?B?Um12dW8vMFNhMzhaWWYzZzF1QzdXNHZnWWFsblN4Vjdjb0tDQ2d3ei9obXkv?=
 =?utf-8?B?WlplY29Eb1l1QkhwTW8rWlpmMEhaNUFlV0VTVkJaUjJDY25oUzNZV3hCNGUy?=
 =?utf-8?B?Wlp1bjNFTGJleENBVnNSeGNkdmo3RTB5ZEg3RU5Ea3YzTXhtbFhpek03Mkx5?=
 =?utf-8?B?aWlSQmhNZUpqTGpjNWI0WXZ3eE5mSDZGSHBYMnhZMXlQclVuQzRKRnBBRFl3?=
 =?utf-8?B?ZmQxQnNsQjREM0czWUxjOWlMSnFrT1pwU3VVVDhFUjltTElaTUVTdjVQejE5?=
 =?utf-8?B?QkdVb0Y5VmQ3eFZUN3ZtL3BYcmt0Wnl3VkMrWlBiK2tXNEJVby91UHpNTUZ5?=
 =?utf-8?B?WTZCOEhuYjU2RjEyWE1YeGVQa2tsRW9iMVVLVk0vaU5GdHc4Yzh1VmJTcWM3?=
 =?utf-8?B?bHdZaGZXUjBjdUFPaXNvUVhQU3NNc250RUxtcWF3QVhlRjZKRitGWEtaQnI0?=
 =?utf-8?B?aEVZRno4aFROeDdxS1Ewb0tYTFJoUUQrUUl6UWwzMFBvSVNrdVR4ZDNpRkpq?=
 =?utf-8?B?QllZQ3oyZ29VbHpDQ2kyR1FoRW0wL3pVOHljc2dZenFXZDVaTFJtTGE5clI1?=
 =?utf-8?B?KzNObThOa084Q3hVZ0pxK3IxQk5SOENZWmFQa1YvYWhPMGRlQmJJa1RVL2hj?=
 =?utf-8?B?bm9JNVpmSU9ackZrcURqYTNmalduVWlYSlYzeG5VdHVNakVMT290QVN3UzYr?=
 =?utf-8?B?TFIvNjV5L2F2SEFFanFuU1dTcnp1SXhtNTRBOVFaR24wTU9Wa3d4dzNqcUJX?=
 =?utf-8?B?NEdjUU55VE1OaG1IUTZodVR1bjBWZE4vcVFhTXVkbVVkTmNXYUpuZm40R3Mv?=
 =?utf-8?B?K25sYVo0Y3RYVFhadURYRkZWSWQ0MDE2alN3dnUwNTJlVVZSKzdMMGtKa051?=
 =?utf-8?B?YnI0M09teGJhWTFZVG9hWFp5WU5HREs4d1pxN3ZSaE1Uc0NFMmV6bkhNVE4y?=
 =?utf-8?B?eC9lYlUyaDJlQUcvWFZQMWJ6QVJZVnRoWm0rdTZMR05hbCt0WVo0bExDUXRO?=
 =?utf-8?B?TStWQzR0SlRQaXdkUnNTaHV5cnRTRlRXWWFyQzkrbnh2TG5JYTJlTEU0L1Nr?=
 =?utf-8?B?YkZ2bHRzNjlGTHpTNCtyTmxSd2JWUWxIWHFFaThTM2hzK2dxZVEzc2xObmdj?=
 =?utf-8?B?aDIvbXFicXA0NmRqWDRhcGhGZXZOakc0N2dlOXVHREx0Z3RWRjJEVUU0dHRi?=
 =?utf-8?B?TDlna1ltbkRGUEdhallSZVhCUm1oUTZ2Z2xtQzlsdWx6QnFveXhiTWN2ZHlW?=
 =?utf-8?B?UHg5c2tYeHB3bFZQQkk1OUxEZm1OMmNHQ2l1YnJobC9GNXFGdWllSHEzMmF0?=
 =?utf-8?B?QnhLYVZBNkE1bzJrZE9menhDT0ZVNG53S1N0VFh2M0gwMVV4aDB1bHd4UEtK?=
 =?utf-8?B?cWxVWlBzUERNYlVJdElqUkpDR1Ntd0kyU0svbTdySkc4NWJwUTBYbWZ2S2lB?=
 =?utf-8?B?Q0hRZklzNVZGT29DWlNPYW5uamNJNm1kOHFya2U0ZmkrVGFJUWxjZ0VkbGNv?=
 =?utf-8?B?VlVVS0tKeCttdlVhK1h2MjAxb2RXQ2VKNzV0ckdPWTFPU3UzNU9mRFlCOHc2?=
 =?utf-8?B?K2FXczdLdkxWUkZxekE0TUxUbTZTY25vMUZqa2ZTQzBXcC9sa1Mva0F4R29U?=
 =?utf-8?B?c3NTZGFyNTVHeWhrRk5hSEU3T1dkUHlkSXNpNkkwdXJnUnIxNVY1aXROQlpO?=
 =?utf-8?B?SnJRT1NEMG9Bd3lmZzc0Z1NhamFHRWpUKzhhUkVaYlYxbisyRkVlOFFFTDhj?=
 =?utf-8?B?Vk1oVkt0UFc1MkNwMHE5K2JNZDdabS9NaG4zc1hHM01lM1YrQi9IMjVRZS9x?=
 =?utf-8?Q?bbJMFi/Zg53vM+UjvDoWZEVkoICu4Y8w/7Z0ccRqHLyO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6012D6E95504214EAEE2176CB0FEB441@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 859db52d-6447-4d38-e40e-08db13db3504
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 07:14:01.1179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6P3VoBQhU8amUVMGEAkhGUPaSiS/tYaMk0JJbUgEQUYqAudLpHMe4W85MqkABvVJD4JJL+GJ0hqLiJn1f6gA/K9qhOnfGvoTNDjEjU3cHL66a2WeAvWNs7PDSFPLwUbD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5824
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZCwNCk9uIEZyaSwgMjAyMy0wMi0xNyBhdCAxOTowOCArMDIwMCwgVmxhZGltaXIgT2x0
ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
IE9uIEZyaSwgRmViIDE3LCAyMDIzIGF0IDA0OjMyOjA4UE0gKzA1MzAsIFJha2VzaCBTYW5rYXJh
bmFyYXlhbmFuDQo+IHdyb3RlOg0KPiA+ICt2b2lkIGtzejhfZ2V0X2V0aF9jdHJsX3N0YXRzKHN0
cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZXRodG9vbF9ldGhfY3RybF9z
dGF0cw0KPiA+ICpjdHJsX3N0YXRzKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgIHN0cnVjdCBrc3pf
cG9ydF9taWIgKm1pYjsNCj4gPiArwqDCoMKgwqAgdTY0ICpjbnQ7DQo+ID4gKw0KPiA+ICvCoMKg
wqDCoCBtaWIgPSAmZGV2LT5wb3J0c1twb3J0XS5taWI7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoCBt
dXRleF9sb2NrKCZtaWItPmNudF9tdXRleCk7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoCBjbnQgPSAm
bWliLT5jb3VudGVyc1tLU1o4X1RYX1BBVVNFXTsNCj4gPiArwqDCoMKgwqAgZGV2LT5kZXZfb3Bz
LT5yX21pYl9wa3QoZGV2LCBwb3J0LCBLU1o4X1RYX1BBVVNFLCBOVUxMLCBjbnQpOw0KPiA+ICvC
oMKgwqDCoCBjdHJsX3N0YXRzLT5NQUNDb250cm9sRnJhbWVzVHJhbnNtaXR0ZWQgPSAqY250Ow0K
PiA+ICsNCj4gPiArwqDCoMKgwqAgY250ID0gJm1pYi0+Y291bnRlcnNbS1NaOF9SWF9QQVVTRV07
DQo+ID4gK8KgwqDCoMKgIGRldi0+ZGV2X29wcy0+cl9taWJfcGt0KGRldiwgcG9ydCwgS1NaOF9S
WF9QQVVTRSwgTlVMTCwgY250KTsNCj4gPiArwqDCoMKgwqAgY3RybF9zdGF0cy0+TUFDQ29udHJv
bEZyYW1lc1JlY2VpdmVkID0gKmNudDsNCj4gPiArDQo+ID4gK8KgwqDCoMKgIG11dGV4X3VubG9j
aygmbWliLT5jbnRfbXV0ZXgpOw0KPiA+ICt9DQo+IA0KPiBUaGVzZSBzaG91bGQgYmUgcmVwb3J0
ZWQgYXMgc3RhbmRhcmQgcGF1c2Ugc3RhdHMgYXMgd2VsbCAoZXRodG9vbCAtSQ0KPiAtLXNob3ct
cGF1c2Ugc3dwTikuDQpZZXMsIHRoZXNlIGFyZSByZXBvcnRlZCBhcyBzdGFuZGFyZHMgc3RhdHMg
dGhyb3VnaCBnZXRfcGF1c2Vfc3RhdHMgY2FsbA0KYmFjay4NCnN0YXRpYyB2b2lkIGtzel9nZXRf
cGF1c2Vfc3RhdHMoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGV0aHRvb2xfcGF1c2Vfc3RhdHMNCipwYXVzZV9z
dGF0cykNCnsNCiAgICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KICAg
ICAgICBzdHJ1Y3Qga3N6X3BvcnRfbWliICptaWI7DQoNCiAgICAgICAgbWliID0gJmRldi0+cG9y
dHNbcG9ydF0ubWliOw0KDQogICAgICAgIHNwaW5fbG9jaygmbWliLT5zdGF0czY0X2xvY2spOw0K
ICAgICAgICBtZW1jcHkocGF1c2Vfc3RhdHMsICZtaWItPnBhdXNlX3N0YXRzLCBzaXplb2YoKnBh
dXNlX3N0YXRzKSk7DQogICAgICAgIHNwaW5fdW5sb2NrKCZtaWItPnN0YXRzNjRfbG9jayk7DQp9
DQoNCg0K
