Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42F7578589
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiGROfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiGROeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:34:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBD911172
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658154881; x=1689690881;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KPjm0zOvN8tQfOISvl1qZ33o/RJSD5krV+VGhAf6ksI=;
  b=vlApYTjysqFneYqEVM8OZzD1xvt6wGaz2DdZAhrdT5CAlXd31nSQypWC
   xQMznvk7WUxBSFV+Z37JHY90zJUvwDaTm6pebRLlp0yR9KpLk+0gCpM9E
   V3Tovuh/FePIix8EA0Aye31gxGsZnRWEn5fS1XnMxvwWT/nhUpbSnaYE8
   Ioiyxx1gkx19qbQt4h1lBEfaKHYS+dCjDqqnXmtpHeQ8C2NhhUTKjpzpB
   TH3xlOvW9dERiIL7QWHwF2Rrwc76XLm/Qq/dey7BULwnw1L8W0BNWw+io
   9yFsIGxfWtOKZlnX84FMOZVXxbKcNs6FoBINmCar/wjbFrxctnxEgKmbd
   g==;
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="104953925"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jul 2022 07:34:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 18 Jul 2022 07:34:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 18 Jul 2022 07:34:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJcirW8y8pTA2DzrKJEmJLhPDOKgOk+/yubsTvFar9Sa4Lp5sAuiQGRfjjF6WAKKEb+Kk5uWrTdlA+x0Kuzr2oS3LitzL+DdYT4v88gCAv4+KLoVxI5yk4RHWUBRjXrPGPtiG5LUmGcVEqOcaDLL9kQPdsHFMYHSE2oiI0YXffNVwYVzowMGDmvvsll64PYWi/1zbHhnZmgfdNayunr/reV0Leki6w9beEOr6bZsZ6FKwzaSa5Zyl51c58goje+lovXYskPGz/tCmfSrux7J6cxz1mjsGYmCWBLsFEWpDTDqTSt42UZ4znTzSnNBYFQboxj/lsGSL+ejuE+d//3VNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPjm0zOvN8tQfOISvl1qZ33o/RJSD5krV+VGhAf6ksI=;
 b=IOfKjJAm/Y1GhdkwPZmah0OqkdaYiLv0VpHTvQR5WHPA1EVWbk0yeuOhIucfXWIlN0FMOj1/QHIDR46k/aFrM4A/NI3plr+do9uqFjvpRgaiEKcmcc8DwDsSVyzDLrGtGIqT8GKtjaMtUzTmZfj3/0kKc04k01ijWh9Px+CbK0BjNxKpTVtZF5QiDqDjhkDMwyT9OxcLglI54xXO8iComitnoswjbhH2jtx3g4bz3G7htqfqXHAVpySNcc28pK37LnOdFZPpXTDlcseldEQ0i6VactgFY0/2JYrm1UO0QH2teodP/KEbTT3jNdh6KNQsg/WH2AGGWq27fWcF/AiCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPjm0zOvN8tQfOISvl1qZ33o/RJSD5krV+VGhAf6ksI=;
 b=tni8wEf+4CGy+I8Lo+MRb63Kj2sZ3RJQnuciqfCGRD9SYHxCTrqZE+7dTEAPorxtsWnRv+jD8/PtRz8JKvQTeXlsfQmamSn2NA9iWzrmarjNOOY2hOjw2TPlEe9uJCBTk7vnGw6ubm8zmq8EdUbanHgETGlRjlyPSrMnxCxyOno=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MWHPR1101MB2303.namprd11.prod.outlook.com (2603:10b6:301:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Mon, 18 Jul
 2022 14:34:33 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Mon, 18 Jul 2022
 14:34:33 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <claudiu.manoil@nxp.com>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <idosch@nvidia.com>, <linux@rempel-privat.de>,
        <petrm@nvidia.com>, <f.fainelli@gmail.com>, <hauke@hauke-m.de>,
        <martin.blumenstingl@googlemail.com>, <xiaoliang.yang_1@nxp.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJVA+iLppAy/uE2cW1NrBQONVa1xiwcAgAADhICAADWVAIABvUGAgADAlICAACQggIAArH6AgAiqEgCAAEpdAIABMNoAgABliACABKhtgA==
Date:   Mon, 18 Jul 2022 14:34:33 +0000
Message-ID: <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
References: <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
         <20220706164552.odxhoyupwbmgvtv3@skbuf>
         <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
         <20220707223116.xc2ua4sznjhe6yqz@skbuf>
         <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
         <20220708120950.54ga22nvy3ge5lio@skbuf>
         <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
         <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
         <20220714151210.himfkljfrho57v6e@skbuf>
         <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
         <20220715152640.srkhncx3cqfcn2vc@skbuf>
In-Reply-To: <20220715152640.srkhncx3cqfcn2vc@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0faeb120-a629-4dd9-876a-08da68caa1af
x-ms-traffictypediagnostic: MWHPR1101MB2303:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yQ2Xh5DFD56ZZGCyEZMHknHkiJSYuJbJmACblAjM9Qky3IlaCyYlo3sW/BXtCvALsM2luLiwCxWnccMgzVaBnY8FhbCZfNJvuUDC7PMPaVWBv+MWx6Uk23Q6SHvZ4ht5j+2geAAj8KsAeNcUY6M8luqnUKP41V6xCZYze4rFVzY6I8uUQBhgWzw93MAkZwzDkWQpTNk5KxKLA2zmMNPn7faE2T+pPnTuWV1TaI9L5Bq2vPjuvdA5zH5qYZ6w5D7KumscWD/eFeDOyi/NxT+SnbFl3zDNuTfkZXxLsXNIOcx2RdAUjqapeDhGMFTi1/puCBjgv3GM8niB8vnInPA6HZb12pkhyBYsw1Zdyb6PMe/5Nm61YTYjLvY57SCAJvSvdqZmjwWmXi7QZM24pfiImoLVOhd3FK2uz8ITOc5OYs7fBZg6P/Hl+85XOuRipRLGdBzCE/lxDpazF7tg0nw43ZAB4oLgpX0hs9ckC6735RaAIocTYe1eclAwzb/j7ZHPJ8jLQ7W4SK+Upi/o2oGKuPiaCmhUaPnwhgGdXlMhg7vzBSHdElttdBuOgAG20NIznPhhnFx/pXmwpJM140zrVZquMpgEmb3IwFBJ88VIM1QwOGhR/iiZvXPY8oNbEY4ndx8A10/u1XtJPntuccM7/a7glc7x9kFgpuK5WGRpTZ2aQHslvaVFvE3sECHiOQ1q8UtvNT5easXrzXNw8FOM2U4lzK+JeQTxls/MEmt4Te9Lq4na0mlfcAVjvJbYAyu+sGw/3RsDissc5cb5VQE/cfTndAH0721Ae4WlJMV8qYHTFifz2uo0CZVBWz0HdJEfHpx5a2GSJMUczpq4QJTBaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66556008)(76116006)(2616005)(64756008)(66446008)(6512007)(478600001)(66476007)(4326008)(8676002)(186003)(83380400001)(36756003)(6486002)(8936002)(6506007)(41300700001)(316002)(7416002)(38070700005)(71200400001)(122000001)(5660300002)(6916009)(2906002)(38100700002)(91956017)(54906003)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTBUYlhMS0JVTnJkSC8rbmNiZzluV1d2ejd3bUg5KzBQQWRiQjdNWHdoWlF2?=
 =?utf-8?B?WVl0bkZpWlQ0OTRVUXdkeVVIWnpRSWNpTHhkMWNwT1FMMFZNUFJ0QlJzWDdn?=
 =?utf-8?B?YVlsbVRhYUNsYkZkNDJ0cUpIMEJObWVkYmNpZW0rZkdXdFJ3cy9DaFZGZnFZ?=
 =?utf-8?B?MHNLWGhpVCtqd2h0QXFPbkhhQkN5RTFvU0pGQTNMWEllbE5vVlI4VWgvd0Zj?=
 =?utf-8?B?bGdOek9HbFAyVEtxSUVjM04zaWNXWmNWMlFWTFlUVE9Mc2lUWCsxZ3RvaXdH?=
 =?utf-8?B?QmNSQnE4OVhQdmRhazFoMWttb1JvQ2NUTFhqeERybzRtNGRoYVdxR1RHRVdj?=
 =?utf-8?B?cE52d0JTRlBFQ3pmREhCelBodkw2YVlqUytFbXJ0MUxNcllnOVRtOUVtaytN?=
 =?utf-8?B?dWdSYUFmeHdSVUNHZmtUSGNXRjNLNGdUUXd6ckFXdmtVcUZBVWdKbTZnemkr?=
 =?utf-8?B?MlpBZDJMQnpId1FlTkk4dkZ2WVRscDVabVlSQlpIK28veG9Ud3U3aE9oVzJ2?=
 =?utf-8?B?V3ppb1QvNVNaMlNhK1Y3UDJnMXpBTGoyc2lEQWxXbWpBYXgvd0JKQWxPNkZH?=
 =?utf-8?B?STMyWnp3WlExNXhCNHU3cHR6OFR3NnVncCsxemxpVHJFM2preW1jKzdWZzQv?=
 =?utf-8?B?M1F0c09hMGlQQjVNeCtmTEZzZjFqRDNRSzl4ZnowODRNQXZIS1d3OWtLbWRO?=
 =?utf-8?B?YlZ4V3F6dUMvNUpkSEtoYmM0ellHaWVOd3RzQmVjTU16TzNRTjM4RVV0QTFh?=
 =?utf-8?B?NloyaEdTTVE2SVAwOFNqbnVCeFpJbVNlZU5RenhjRGpZUVNSdWwwZnV1QjNU?=
 =?utf-8?B?MXJrcFhKaEJCMnVBZ2ZuaGM2azFxSEJsWUZucHZhR3Jzd0tHeHlpTVdTRUln?=
 =?utf-8?B?b1dvTHd3bEFoK2FnRmQrdmQrWkd0eEhZMzB6WnZMK2o5WTFQczBHeVpJUVRC?=
 =?utf-8?B?LzAwTGk3MVRDbUl0dVFIQmNDazh6RGMwRFM5QzFidVpVdHQxck55cVBIRWI5?=
 =?utf-8?B?ZTJmK3dtUFJYbnN1VnVLeVZWTk9pS05hTVRTbU8wSGo2MG9YK0lKVG5PRUt1?=
 =?utf-8?B?K3UrbVFkekd0MTRkRGdaSjJQeURkM2VacVJ3akh0YjdMdTl1dXNLOVhLb2hm?=
 =?utf-8?B?cUtEcGUzV1dlaTVXZWFyRHl4blV0MGtxNmNIL1phUFlpb3FMK2hkc3NVV1Vr?=
 =?utf-8?B?dk4zRVlLL0hRS2hxSjBVckVuWG9icEliTGFSSno2dnV3NXA4QWZ6R205WGJC?=
 =?utf-8?B?bFBZWWl5aFpRa1lmb1RyKzNSeXJMZHZjN0VUWC9WYUJuWGs2UnNGVEZ2ZzBi?=
 =?utf-8?B?NUVGMFZtdmZLVnU1bXZFSnlEOVR3UkowY1ZaY3NIUGdaOTZQeUZoM3hIV3hu?=
 =?utf-8?B?NDU3d2tMcENVelp0TXVudXNnV01xN2tMbnp6aFNhaHlrN29aVHltTE5vNXls?=
 =?utf-8?B?YW1xb0NzVGo5bHI3WU1IRzBmUlBEczQ1c014Z05DcDBnR3NZVEhLSWI2bFFG?=
 =?utf-8?B?Z0hxZm5tRTFaL3ErUW9LU1pwaDlqSmZWYUtJUlZXZzcxSk0xUklHZG1xeXlp?=
 =?utf-8?B?ZHRLdk5wSnErYjRlSjI5cnpsTFRpdm1qSmFvTEMyTXZ2TTIvNXRPMGR0SzRT?=
 =?utf-8?B?MUJZUW4zL1NoSEo5RUVnOWRGVjJ6Z3N3dDNjWjFNZnJtc0NEbHdKLy9MampI?=
 =?utf-8?B?cDVmWk5jRm1XMmltbjNRaCt1Y0E0cXZxVDVNMzhYajkveTZ4V1l6dTYzMmI2?=
 =?utf-8?B?STdjaUorOGFMV0YzZXBEOFo1azh4MU83ZFAvZXUxdnoydC9kZHVJSlRDTmJ6?=
 =?utf-8?B?WEI0RTBnQ0lHSmhvMHBsTG9vMDVOclg0TStKdktGNlM1eTBlYlVmUUpFNGJz?=
 =?utf-8?B?T2IvdlpaTm1xREpYczhsZzJaYXNTTzNweWNNdjR0azJUWVVtWTdVMmdWNGZD?=
 =?utf-8?B?ZjdFak5OUDlUbTM3bVE1aDJrblg5bzQxK2xpT3NURFBGSHh4ZG1KTEVqNTVQ?=
 =?utf-8?B?bWFZSi9yaVBpUkFJNHZLT0dtMTBpTFRscG96T3pnWndYTFMwOEVzanI1WURR?=
 =?utf-8?B?SWV1amROYWMxakV2bTVBNnREMXZpSXUzVnBEVmhCUjVjSGp6TU5lYjlQZWE5?=
 =?utf-8?B?RjZLUUJwYnNYL0ZqejQ1dTgzL2pvZkJ3cE5qZHlEZWI1bHVzRFE0VUZ2eGVU?=
 =?utf-8?B?cFFMdzVCNEh1eGNWRFgrZDZRYUhXbXEwNmRWdGwxT3YwMHllNDBoRy9KOVBh?=
 =?utf-8?Q?yEcGjZlpdYzRWC7WNSY1V7HH+1QwSbRApL8m06HqfQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72BFF8F383F6C947AE1D7C419D53FD5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0faeb120-a629-4dd9-876a-08da68caa1af
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 14:34:33.1195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b61U11N5Cfdxi+8W4IszDH4wcHIL7Y0UX7yjjUI2uVENos3FEngeuAEU9rPzMMp8iAOcEuCIHZHHCmSnQQ4hYgF8Yl3tITZRzZdw39vRzFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2303
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIEZyaSwgMjAyMi0wNy0xNSBhdCAxNToyNiArMDAwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IE9uIEZyaSwgSnVsIDE1LCAyMDIyIGF0IDA5OjIzOjE5QU0gKzAwMDAsIEFydW4uUmFt
YWRvc3NAbWljcm9jaGlwLmNvbQ0KPiAgd3JvdGU6DQo+ID4gSGkgVmxhZGltaXIsDQo+ID4gDQo+
ID4gV2UgdHJpZWQgdGhlIGZvbGxvd2luZyB0ZXN0DQo+ID4gDQo+ID4gaXAgbGluayBzZXQgZGV2
IGJyMCB0eXBlIGJyaWRnZSB2bGFuX2ZpbHRlcmluZyAwDQo+ID4gDQo+ID4gaXAgbGluayBzZXQg
bGFuMSBtYXN0ZXIgYnIwDQo+ID4gaXAgbGluayBzZXQgbGFuMiBtYXN0ZXIgYnIwDQo+ID4gDQo+
ID4gYnJpZGdlIHZsYW4gYWRkIHZpZCAxMCBkZXYgbGFuMSBwdmlkIHVudGFnZ2VkDQo+ID4gDQo+
ID4gPT0+DQo+ID4gUGFja2V0IHRyYW5zbWl0dGVkIGZyb20gSG9zdDEgd2l0aCB2aWQgNSBpcyBu
b3QgcmVjZWl2ZWQgYnkgdGhlDQo+ID4gSG9zdDINCj4gPiBQYWNrZXQgdHJhbnNtaXR0ZWQgZnJv
bSBIb3N0MSB3aXRoIHZpZCAxMCBpcyBub3QgcmVjZWl2ZWQgYnkgdGhlDQo+ID4gSG9zdDINCj4g
PiA9PT4NCj4gPiANCj4gPiBicmlkZ2UgdmxhbiBhZGQgdmlkIDEwIGRldiBsYW4yIHB2aWQgdW50
YWdnZWQNCj4gPiANCj4gPiA9PT4NCj4gPiBQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3
aXRoIHZpZCA1IGlzIHJlY2VpdmVkIGJ5IHRoZSBIb3N0Mg0KPiA+IFBhDQo+ID4gY2tldCB0cmFu
c21pdHRlZCBmcm9tIEhvc3QxIHdpdGggdmlkIDEwIGlzIHJlY2VpdmVkIGJ5IHRoZSBIb3N0Mg0K
PiA+ID09Pg0KPiA+IA0KPiA+IGJyaWRnZSB2bGFuIGRlbCB2aWQgMTAgZGV2IGxhbjINCj4gPiAN
Cj4gPiA9PT4NCj4gPiBQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCA1IGlz
IG5vdCByZWNlaXZlZCBieSB0aGUNCj4gPiBIb3N0Mg0KPiA+IFBhY2tldCB0cmFuc21pdHRlZCBm
cm9tIEhvc3QxIHdpdGggdmlkIDEwIGlzIG5vdCByZWNlaXZlZCBieSB0aGUNCj4gPiBIb3N0Mg0K
PiA+ID09Pg0KPiA+IA0KPiA+IFRyaWVkIHRoaXMgdGVzdCBiZWZvcmUgYW5kIGFmdGVyIGFwcGx5
aW5nIHRoaXMgcGF0Y2ggc2VyaWVzLiBBbmQNCj4gPiBnb3QNCj4gPiB0aGUgc2FtZSByZXN1bHQu
DQo+ID4gDQo+ID4gSW4gc3VtbWFyeSwgcGFja2V0cyBhcmUgZHJvcHBlZCB3aGVuIHB2aWQgaXMg
YWRkZWQgdG8gdmxhbiB1bmF3YXJlDQo+ID4gYnJpZGdlLiBMZXQgbWUga25vdyBpZiBhbnl0aGlu
ZyBuZWVkIHRvIHBlcmZvcm1lZCBvbiB0aGlzLg0KPiANCj4gSSdtIG5vdCBzdXJwcmlzZWQgdGhh
dCBmb3J3YXJkaW5nIGlzIGJyb2tlbiBhZnRlciByZW1vdmluZw0KPiAiZHMtPmNvbmZpZ3VyZV92
bGFuX3doaWxlX25vdF9maWx0ZXJpbmcgPSBmYWxzZSIsIGJ1dCBJJ20gc3VycHJpc2VkDQo+IHRo
YXQNCj4gaXQncyBicm9rZW4gZXZlbiB3aXRob3V0IHRoZSBjaGFuZ2UuIFRoYXQgc3VnZ2VzdHMg
dGhhdCBlaXRoZXIgdGhlDQo+IGZsYWcNCj4gd2Fzbid0IGVmZmVjdGl2ZSBpbiB0aGUgZmlyc3Qg
cGxhY2UsIG9yIHRoYXQgdGhlIGJyZWFrYWdlIGlzIGNhdXNlZA0KPiBieQ0KPiBvdGhlciBjb2Rl
IHBhdGhzIChub3Qgc3VyZSB3aGljaCkuDQo+IA0KPiBEbyB5b3UgZ2V0IHRoZSAic2tpcHBpbmcg
Y29uZmlndXJhdGlvbiBvZiBWTEFOIiB3YXJuaW5nIGV4dGFjayB3aGVuDQo+IHlvdQ0KPiBydW4g
dGhlICJicmlkZ2UgdmxhbiBhZGQiIGNvbW1hbmQgd2l0aG91dCB0aGUgcGF0Y2hlcyBoZXJlPyBE
b2VzDQo+IGtzel9wb3J0X3ZsYW5fYWRkKCkgZ2V0IGNhbGxlZCBhdCBhbGwgd2l0aCBWSUQgMTA/
DQoNClRoZXJlIHdhcyBhIG1pc3Rha2UgaW4gb3VyIHRlc3Rpbmcgb24gdGhlIGxhdGVzdCBjb2Rl
IGJhc2Ugb2YgbmV0LW5leHQuIA0KVG9kYXkgd2UgdHJpZWQgaW4gdGhlIGxhdGVzdCBuZXQtbmV4
dCBhbmQgZm9sbG93aW5nIGFyZSB0aGUNCm9ic2VydmF0aW9uLg0KDQpTY2VuYXJpbyAxOiBCZWZv
cmUgYXBwbHlpbmcgdGhlIHBhdGNoDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCmlw
IGxpbmsgc2V0IGRldiBicjAgdHlwZSBicmlkZ2Ugdmxhbl9maWx0ZXJpbmcgMA0KDQpicmlkZ2Ug
dmxhbiBhZGQgdmlkIDEwIGRldiBsYW4xIHB2aWQgdW50YWdnZWQNCmJyaWRnZSB2bGFuIGFkZCB2
aWQgMTAgZGV2IGxhbjIgcHZpZCB1bnRhZ2dlZA0KDQpXZSBnb3Qgd2FybmluZyBza2lwcGluZyBj
b25maWd1cmF0aW9uIG9mIFZMQU4gYW5kIGtzel9wb3J0X3ZsYW5fYWRkKCkNCmlzIG5vdCBjYWxs
ZWQuDQoNClBhY2tldCBpcyByZWNlaXZlZCBpbiBIb3N0MiB3aGVuIHRyYW5zbWl0dGVkIGZyb20g
SG9zdDEuIFNvIHRoZXJlIGlzIG5vDQpicmVha2FnZSBpbiB0aGUgZm9yd2FyZGluZy4NCg0KU2Nl
bmFyaW8gMjogQWZ0ZXIgYXBwbHlpbmcgdGhlIHBhdGNoDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQppcCBsaW5rIHNldCBkZXYgYnIwIHR5cGUgYnJpZGdlIHZsYW5fZmlsdGVyaW5nIDAN
Cg0KYnJpZGdlIHZsYW4gYWRkIHZpZCAxMCBkZXYgbGFuMSBwdmlkIHVudGFnZ2VkDQoNCi0tPiBQ
YWNrZXQgaXMgbm90IHJlY2VpdmVkIGluIHRoZSBIb3N0Mg0KDQpicmlkZ2UgdmxhbiBhZGQgdmlk
IDEwIGRldiBsYW4yIHB2aWQgdW50YWdnZWQNCg0KLS0+IHBhY2tldCBpcyByZWNlaXZlZCBpbiB0
aGUgSG9zdDINCg0KYnJpZGdlIHZsYW4gZGVsIHZpZCAxMCBkZXYgbGFuMQ0KDQotLT4gcGFja2V0
IGlzIHJlY2VpdmVkIGluIHRoZSBIb3N0Mg0KDQpicmlkZ2UgdmxhbiBkZWwgdmlkIDEwIGRldiBs
YW4yDQoNCi0tPiBwYWNrZXQgaXMgcmVjZWl2ZWQgaW4gdGhlIEhvc3QyDQoNCiAqIExldCB1cyBr
bm93LCBkbyB3ZSBuZWVkIHRvIHRlc3QgYW55dGhpbmcgZnVydGhlciBvbiB0aGlzLg0KDQpUaGFu
a3MNCkFydW4gDQoNCg0KDQo=
