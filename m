Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1105363CE55
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiK3EW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiK3EWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:22:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E461A18F;
        Tue, 29 Nov 2022 20:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669782171; x=1701318171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lcaczI02HsNe1Gv+DvlnKGFbDm0K3dbGH33Q25Bn9XQ=;
  b=zfSqc9wOiGYtCLgZe4VuCWurFRl7wQeujgz2eAlA4lW9+RfV3H4aTys9
   CK8UJY8xVRmjOi9rF0+8Hkd+gFYrFveou3F+gIe4ETBN7hkmDTQMrQiUf
   zevG/kZxEoMG5+z7PRzhxjc7mGbWkHmjApteGmH9UAyhVuRrUeDarxTjD
   51S26t3ePzqq69IpGzQjgnSBp2slUgEUOZyj61ibMrPyzvM554xpGDT+g
   BZ/SMgrLw8gHK0CfbASD1XrgYexuvFhi7wGIuLE5Br12CBEjFgHiS26Od
   lGeMq+NxQvYT7bcTo57LzF25qMHrbF9fVIAVm2NSLDS4O3vxl1Rsw3X13
   g==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="201959400"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 21:22:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 21:22:48 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 21:22:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL6zjmHfjkhRcBfdJLVPgYFFXiyyCKdLln9aOMFsi4j1GiaN4UKIl8SO3a6Tpa38wnOSUJofRh2rZbu0NCafCZ6MLZq3/nWC17Ms6eMBU+KWEV6fG7sqMDhf15ZtyiTz/rP0n1SDJnWVtNdzQp56WOvNoFONnQK3oRss/mUqBBm7Kymq4xBg3ags4+kPfndBYOeFw0/LJ2JR4YRKL2s7XLsUPw+xO9l+BeCXluC/Brh2w/mc3Lc76mQ32Pflrp9q8IPoDs4a+YaBFVvMGodChTDfH7fBYOUcRuLWCYGBVnCUCAgiZ2IJ5scH0gdYFujlCjzKhJUvDh/wOEWR5NBWmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lcaczI02HsNe1Gv+DvlnKGFbDm0K3dbGH33Q25Bn9XQ=;
 b=Izji5jBWmexDddHFhYoW5LqhmKoLIYODLjdYcIg6u5dT5lxjY2a7SbMpucm+7f7aruNhKjDN5npC7XMkpBFt2eTzrXKF+CexNAT+HdEV4aTCEH2Ijg/GjgLP8zVMtps2c/dBQEZbfIYhsnDVxi/2c8eGZS6Z3gTEZBd90gEd0K8F0CWEPbRB7ldgHbkWGu6qwX7quNfCdxvj7/+Yw/GBDBqugEpkpj8m66Tg8geK0yGJ0WhT+fKSW5Zg6E92TEQUz3UF/Bs6+ubK5YYDJm71afmBACnFupZQVwptJoBpI0djUD7zxK5GerNSpm0zRN60+iGikfHfBHtKuwVwRMntsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lcaczI02HsNe1Gv+DvlnKGFbDm0K3dbGH33Q25Bn9XQ=;
 b=csbQ+Bh0GF3st6twCY2cScTdTzfVRJ4tGr6ycpIIMR2dswMtYDRTD4eCulBLf6KTmdGB0YDzyWlCFu61tz7XF5ucInhyJ+isd3P/qAG97cMrR9vwRQ7MHdAQUYLnbrFVM5O4fbwT8nnZQC1KXs5nmWb/VuEfN3wyck8FuKjsIp4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MN2PR11MB4615.namprd11.prod.outlook.com (2603:10b6:208:263::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 04:22:45 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:22:45 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pavan.chebbi@broadcom.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
Thread-Topic: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
Thread-Index: AQHZAxTwqsoem8TmskSr7lmTVTJtba5VlyuAgAFJdAA=
Date:   Wed, 30 Nov 2022 04:22:45 +0000
Message-ID: <743a908be8dcb9a6492a2adeee5f2f9de3eff5a8.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-5-arun.ramadoss@microchip.com>
         <CALs4sv0x04ODvWv-av56-FtnnpsC_8Sudp8T0U0buNRt+hq9bA@mail.gmail.com>
In-Reply-To: <CALs4sv0x04ODvWv-av56-FtnnpsC_8Sudp8T0U0buNRt+hq9bA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MN2PR11MB4615:EE_
x-ms-office365-filtering-correlation-id: e1f0621f-2d8f-4e3f-9961-08dad28a87e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Y3jxMbTxUXQwN3MPO2ukU+Dk8DWuY4CcLnRLt3yPDBfDPZGpqlkeo0XxPGgReAL+tefdF13gaKUAF8eX/40BrshzcxkVxPbCTCmvZRWZu6+AhZd/XSaKWbPm9LfAeU+yjccglsH08jhUjv/1mF9vt16TLY/wYsioYppV/u7ccPnaL1imut0Okc3YvCfJrvHqOBrBL6aeToikprtLgBpNjKueizA4rdKgyszx5ChNA+we3QFKADfLXHID9K/ivfwlJQtPj6f966ejHRlobiFILTpm1+rj0kdOyhb2zEcHkNNHqHXQIsIq8MkUSKSVLKEXpiP0wL3gBG25WBMC254kednByxtsa1GTcuQjrn3V37OGqkIyDl5Yj8ZAwdOJU6jF+rzdQmqdxmBrXCmXXuejiFCDoqaZaxm/4ok3iO8ypgvlLu78h/PfmoELLkpgFq3DTxERm6b3w9BtWUaQIC6kDYqMLMUOCXkw5g+pE6jRXI+bMZ/PMsc6pmba8NF5IJ9VBltF/pVOft4A9qzplvDbR1jU9mHBlAWf4Y36SwJXSPDU9BqZ58BPKi7NRKcDkudOnNxACOsPBqhOMNV7jCPM2MYOuHjRjekig/5RGlyNyhv+ptYW6OK9mUQR6Av1XcQ46Y1O99xbT+3l2b9uLkIh/i614l5wwA+56IaiIy1WBxQOBwvJ/8d4SLe0bBqdWMRyfUkYgAuevSz/Tc65DpAQ9hSRto6q+q1C9YUgGxOLag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(86362001)(2616005)(71200400001)(122000001)(41300700001)(6916009)(6506007)(64756008)(54906003)(316002)(26005)(6512007)(38100700002)(4326008)(8676002)(66556008)(66446008)(66946007)(66476007)(53546011)(76116006)(91956017)(36756003)(4001150100001)(2906002)(186003)(83380400001)(38070700005)(5660300002)(6486002)(7416002)(8936002)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmtJZFdwd0ZNM3RaT0tFa2VDUmxiTDBrclVzWHU3cTdrYkNwQ1RmdFlhTHN4?=
 =?utf-8?B?SlFyaWpEUDRpNVRLK1d1YVRyUTYzRWs5eC9jaUJqSVFhVzFzcE01aXRPMUZC?=
 =?utf-8?B?Qlh4eTQ1WjJndW9TREsycnFOYnNhVWUxbkNoWDNaLzZtOW5iUlhwZG80WUtD?=
 =?utf-8?B?eUswNkFQUjdUUG1tdzJFZCtUa08vaC9NUWpRS09VSjVRcEllYndFMSsrSEJs?=
 =?utf-8?B?a3lkWmQybHQrZ2pQZjFKRm9OalBNOGdlbnRjWEtjN1FhV2RkQ3VKQ1JQY2tr?=
 =?utf-8?B?Z2VFcVg4YkdGOTJTbDVVdTh6RGJpV0ovQVdnWVplbVc3VS9XNUVhUVhmVUNK?=
 =?utf-8?B?ejZldEZKVzBzZEc2RXFicnZhZksxQ1pydlZmVDFIVzhVa1JscjRBSm9FcXdz?=
 =?utf-8?B?b1ptT0lXOWpCTUFYMmF4Q0VUTnNscjZvdFdwMmJSenpNZTJqTnJ1M0FTdGNB?=
 =?utf-8?B?S0t6NmhxcTVRMkVJQ1JUMWtmbm5pTGlzWjBTYmFJZWR2OGwybk5YeXY0T1l3?=
 =?utf-8?B?M0EzU05BYmJNMUpqT1ovaHhwRURuUi8vUCswNDB4V1p6bHBKQ0pqQkgvV2xF?=
 =?utf-8?B?Y2VxQkVHVjBEaE1oZ016WWNsWEJDaDJDTFUyN0RvRFNXT3hJMnNLSDc0WVlU?=
 =?utf-8?B?REEvQnd5cU9CYXVZUDJBSVNCZDFnL3YvdnJPeFFJY2RtRFVTNjh5UTl6alo2?=
 =?utf-8?B?MDM0SURSbTVRQVFpTzB5VFB6VnJrTkNtYUxPeTZhaGJkMlBvNlErbmZEanZG?=
 =?utf-8?B?akVWTUhIbEpsblFUVXh0OTlNOFNYcXVUZkNLaGpqUkVBUTE3bkJNMUd2Um8x?=
 =?utf-8?B?ejdwOXNLQUFGaVdlSS9SdmM3dEYrSk5UVzRyUUxLY2ppVFE1RHhYZnQvVWdn?=
 =?utf-8?B?bXBNUG5HQmV6TnBzR2N2VCs0YXlMS2hGRGZEcENaTmtmSE5vWlJ6ZjIrSlRz?=
 =?utf-8?B?YWs3UjVmZktuWmd4TDJCOEZLTk1DTlJpOXVlbUpDdVhXYVF3aEFVb3N5dW9u?=
 =?utf-8?B?enZBblFuVEZ1eFE4U0pvZi9DZVl0SXpIbW5zR3YrNU5oR25jSFhKeEUrZzd1?=
 =?utf-8?B?R1piSm0zZlRCNnJtNnBUMWNIenltSkhCNjdFQldabFNRVDZZRUdxbDk1UHg5?=
 =?utf-8?B?NDJmU3Y5dzVkdU1vZ3c0TWUxaTNyMU1aQSt6NVRvWDZIaTJCTXdFM1cxSlpO?=
 =?utf-8?B?aGtibU9ZbU5tUTNJSVBINTNDYjNuZE1VNHBwMDhOeWhudjhFSzJscXpyaW9O?=
 =?utf-8?B?VUlMWkRYWVJxRGVCSWQ5TW9KZHB5RWdDUXFEWmhuUkN3cEdOckpxdmFEbHNG?=
 =?utf-8?B?SENvNU9SNGVLZ05Ma2RkY2VsU2VabGtYd0NiVnBqbDk1SU85ZllOemdkNGRm?=
 =?utf-8?B?NjdMMXExSUV4V2J1MDgrSThLbGNmenRvMWc1eE90WTFNWHNxRkxJR2ZIa3Ny?=
 =?utf-8?B?NVVQRG1QNUNYbThxQTNaQ2dPMXlrMFNJdTVVT3RQWlNpbVZmajNOWTFBbUF2?=
 =?utf-8?B?TlVpZU9tc0QvdFVSakprOHEyd2NUUTAyb1lxR0xNK0lQS2RWZXZlYWZ5TUJQ?=
 =?utf-8?B?clFRdUpzUG5oRWVhOExGZ2tpLzE3dmJXekJnRnVpaHl1MWZGUitKRThTaGZK?=
 =?utf-8?B?VkZNZXp2UlJpSmtxQkxLZW5hR2VPc2JYN3JuWmJRZVk5cFN0cUtnVlVRY1ky?=
 =?utf-8?B?VkI1LzYySWVFQVNhL0FNK0hzRGJpcUYzM0MveFdsWUNkekxBdlFpNk5XTHNM?=
 =?utf-8?B?Y2dBSWRNcHV6cUhwR0NZWFBYaFltVTlQbWhQdERrV3Y4K0g1bWI1bXIvbk5O?=
 =?utf-8?B?UHhZVmp2aGwzS3ZlaFhuUGpzYVEvKzVqUGJEckdqaTFoMmVFRE1jWllTMmll?=
 =?utf-8?B?WWllQlo0V0xPNGN1SThSVUNJNmpaNDNuK1ozaE4rK3JKQWFuOUlacDAzbjl3?=
 =?utf-8?B?VjhVREM4b2ptcGtyVlBzWWFxelNPbE1ZeFZPSGZzL2JSUTE1MlZ4eFZkamli?=
 =?utf-8?B?Wkp0QUgyUjhNS2s1d05vZFZ4TW5DR3YwSUpPR3gzVVdhUmYvb0VaWGR5cWpD?=
 =?utf-8?B?dXdsWS91Vmg5Mjdrb1NXeGhRUndJZzR4VldwOU14QnZMV2xiNkVtQ2U4YXBz?=
 =?utf-8?B?c01FcGJJN0N3LythelFYeUNvRFRrZXByalFUS1pHYzJnMGRNYi9rVlFiWHZp?=
 =?utf-8?Q?sfxGWGvlsV7GGq2yfmDhCcg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67286DD0E5A9F242A7D47F9ED82243CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f0621f-2d8f-4e3f-9961-08dad28a87e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 04:22:45.3103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rcKtiIMPaS0gasVXsZJuvIEtN1oyJ+8hEk45yv0283kJH9ksXXnuFgROyNA6KcUQLB6NhObjNZcnnRNmciVZGNOL4xY1RH4RGylr2ZhOxYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4615
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF2YW4sDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgY29tbWVudC4NCg0KT24gVHVlLCAyMDIy
LTExLTI5IGF0IDE0OjEzICswNTMwLCBQYXZhbiBDaGViYmkgd3JvdGU6DQo+IE9uIE1vbiwgTm92
IDI4LCAyMDIyIGF0IDQ6MDQgUE0gQXJ1biBSYW1hZG9zcw0KPiA8YXJ1bi5yYW1hZG9zc0BtaWNy
b2NoaXAuY29tPiB3cm90ZToNCj4gPiArLyogIEZ1bmN0aW9uIGlzIHBvaW50ZXIgdG8gdGhlIGRv
X2F1eF93b3JrIGluIHRoZSBwdHBfY2xvY2sNCj4gPiBjYXBhYmlsaXR5ICovDQo+ID4gK3N0YXRp
YyBsb25nIGtzel9wdHBfZG9fYXV4X3dvcmsoc3RydWN0IHB0cF9jbG9ja19pbmZvICpwdHApDQo+
ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBrc3pfcHRwX2RhdGEgKnB0cF9kYXRhID0gcHRwX2Nh
cHNfdG9fZGF0YShwdHApOw0KPiA+ICsgICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IHB0
cF9kYXRhX3RvX2tzel9kZXYocHRwX2RhdGEpOw0KPiA+ICsgICAgICAgc3RydWN0IHRpbWVzcGVj
NjQgdHM7DQo+ID4gKw0KPiA+ICsgICAgICAgbXV0ZXhfbG9jaygmcHRwX2RhdGEtPmxvY2spOw0K
PiA+ICsgICAgICAgX2tzel9wdHBfZ2V0dGltZShkZXYsICZ0cyk7DQo+ID4gKyAgICAgICBtdXRl
eF91bmxvY2soJnB0cF9kYXRhLT5sb2NrKTsNCj4gPiArDQo+ID4gKyAgICAgICBzcGluX2xvY2tf
YmgoJnB0cF9kYXRhLT5jbG9ja19sb2NrKTsNCj4gPiArICAgICAgIHB0cF9kYXRhLT5jbG9ja190
aW1lID0gdHM7DQo+ID4gKyAgICAgICBzcGluX3VubG9ja19iaCgmcHRwX2RhdGEtPmNsb2NrX2xv
Y2spOw0KPiANCj4gSWYgSSB1bmRlcnN0YW5kIHRoaXMgY29ycmVjdGx5LCB0aGUgc29mdHdhcmUg
Y2xvY2sgaXMgdXBkYXRlZCB3aXRoDQo+IGZ1bGwgNjRiIGV2ZXJ5IDFzLiBIb3dldmVyIG9ubHkg
MzJiIHRpbWVzdGFtcCByZWdpc3RlcnMgYXJlIHJlYWQNCj4gd2hpbGUNCj4gcHJvY2Vzc2luZyBw
YWNrZXRzIGFuZCBoaWdoZXIgYml0cyBmcm9tIHRoaXMgY2xvY2sgYXJlIHVzZWQuDQo+IEhvdyBk
byB5b3UgZW5zdXJlIHRoZXNlIGhpZ2hlciBvcmRlciBiaXRzIGFyZSBpbiBzeW5jIHdpdGggdGhl
IGhpZ2hlcg0KPiBvcmRlciBiaXRzIGluIHRoZSBIVz8gSU9XLCB3aGF0IGlmIGxvd2VyIDMyYiBo
YXZlIHdyYXBwZWQgYXJvdW5kIGFuZA0KPiB5b3UgYXJlIHJlcXVpcmVkIHRvIHN0YW1wIGEgcGFj
a2V0IGJ1dCB5b3Ugc3RpbGwgZG9uJ3QgaGF2ZSBhdXgNCj4gd29ya2VyDQo+IHVwZGF0ZWQuDQoN
ClRoZSBQdHAgSGFyZHdhcmUgQ2xvY2sgKFBIQykgc2Vjb25kcyByZWdpc3RlciBpcyAzMiBiaXQg
d2lkZS4gVG8gaGF2ZQ0KcmVnaXN0ZXIgb3ZlcmZsb3cgaXQgdGFrZXMgNCwyOTQsOTY3LDI5NiBz
ZWNvbmRzIHdoaWNoIGlzIGFwcHJveGltYXRlbHkNCmFyb3VuZCAxMzYgWWVhcnMuIFNvLCBpdCBp
cyBiaWdnZXIgdmFsdWUgYW5kIGFzc3VtZSB0aGF0IHdlIGRvbid0IG5lZWQNCnRvIGNhcmUgb2Yg
UEhDIHNlY29uZCByZWdpc3RlciBvdmVyZmxvdy4NCkZvciB0aGUgcGFja2V0IHRpbWVzdGFtcGlu
ZywgdmFsdWUgaXMgcmVhZCBmcm9tIDMyIGJpdCByZWdpc3Rlci4gVGhpcw0KcmVnaXN0ZXIgaXMg
c3BsaXRlZCBpbnRvIDIgYml0cyBzZWNvbmRzICsgMzAgYml0cyBuYW5vc2Vjb25kcyByZWdpc3Rl
ci4NCkluIHRoZSBrc3pfdHN0YW1wX3JlY29uc3RydWN0IGZ1bmN0aW9uLCBsb3dlciAyIGJpdHMg
aW4gdGhlIHB0cF9kYXRhLQ0KPmNsb2NrX3RpbWUgaXMgY2xlYXJlZCBhbmQgMiBiaXRzIGZyb20g
dGhlIHRpbWVzdGFtcCByZWdpc3RlciBhcmUNCmFkZGVkLiANCg0KIHNwaW5fbG9ja19iaCgmcHRw
X2RhdGEtPmNsb2NrX2xvY2spOw0KIHB0cF9jbG9ja190aW1lID0gcHRwX2RhdGEtPmNsb2NrX3Rp
bWU7DQogc3Bpbl91bmxvY2tfYmgoJnB0cF9kYXRhLT5jbG9ja19sb2NrKTsNCg0KLyogY2FsY3Vs
YXRlIGZ1bGwgdGltZSBmcm9tIHBhcnRpYWwgdGltZSBzdGFtcCAqLw0KIHRzLnR2X3NlYyA9IChw
dHBfY2xvY2tfdGltZS50dl9zZWMgJiB+MykgfCB0cy50dl9zZWM7DQoNCj4gDQo+ID4gKw0KPiA+
ICsgICAgICAgcmV0dXJuIEhaOyAgLyogcmVzY2hlZHVsZSBpbiAxIHNlY29uZCAqLw0KPiA+ICt9
DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGtzel9wdHBfc3RhcnRfY2xvY2soc3RydWN0IGtzel9k
ZXZpY2UgKmRldikNCj4gPiAgew0KPiA+IC0gICAgICAgcmV0dXJuIGtzel9ybXcxNihkZXYsIFJF
R19QVFBfQ0xLX0NUUkwsIFBUUF9DTEtfRU5BQkxFLA0KPiA+IFBUUF9DTEtfRU5BQkxFKTsNCj4g
PiArICAgICAgIHN0cnVjdCBrc3pfcHRwX2RhdGEgKnB0cF9kYXRhID0gJmRldi0+cHRwX2RhdGE7
DQo+ID4gKyAgICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICAgIHJldCA9IGtzel9ybXcx
NihkZXYsIFJFR19QVFBfQ0xLX0NUUkwsIFBUUF9DTEtfRU5BQkxFLA0KPiA+IFBUUF9DTEtfRU5B
QkxFKTsNCj4gPiArICAgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBy
ZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgc3Bpbl9sb2NrX2JoKCZwdHBfZGF0YS0+Y2xvY2tfbG9j
ayk7DQo+ID4gKyAgICAgICBwdHBfZGF0YS0+Y2xvY2tfdGltZS50dl9zZWMgPSAwOw0KPiA+ICsg
ICAgICAgcHRwX2RhdGEtPmNsb2NrX3RpbWUudHZfbnNlYyA9IDA7DQo+ID4gKyAgICAgICBzcGlu
X3VubG9ja19iaCgmcHRwX2RhdGEtPmNsb2NrX2xvY2spOw0KPiA+ICsNCj4gPiArICAgICAgIHJl
dHVybiAwOw0KPiA+ICB9DQo+ID4gDQo+ID4gIA0KPiA+IC0tDQo+ID4gMi4zNi4xDQo+ID4gDQo=
