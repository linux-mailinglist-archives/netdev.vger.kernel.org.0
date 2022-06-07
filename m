Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBD53FE07
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiFGLxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbiFGLx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:53:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287E793A1;
        Tue,  7 Jun 2022 04:52:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUicBoGrGL7EG1ZuFanvwkoKBo5SwWUUWBhbI//CoIyBixnL6/4mvSOiFA6WrYRniCXEMMoUBUhPO1radP5Px+IrnZxKO/L9bvGxsMLEQAH1bwFzjtv9R3dVrO2XnF/d+SCmNfatFTsaFMAu662zjjMohT3V6c0QPJWjB75hI0LHi73ADSIGa4X5vAcAIeOxr98p8h7JCU+NNuoQbhLVDvo/c7GXZ+RLltw+dWHJRWreZIPWszpLfsvkvAa0j9a1kjzftd0iG+wWYUfHmp9siHsrH1dN52puJy1ZSrnIQCTz2ISN2R6ZU/mMtaKey3FAIXBVMr2tME7sXS/EXR8nzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soZRWFIlvqT6DfyaNPSZiPB9KTUPw/PFTDy4Hm+2yiY=;
 b=LXWUk/yBlwLh6tqITUFHGcBQEvZLPfZfdYh8pB2D83GDLranOLp/Hmb0hAIFwwKO7WUt68+hMXeInkBylMV0kFZ6le8Q2akmEJuHYI96tJ/6ME+VA6exjVcKBrM+k30H6SZcKb8P0DMCrDUiM8FurtcCK8R3uhKljUVzFENhRx0epkXlMDQRv5kwkd1Ia2eoTVBbli1uLUSMsnAcx3g3t3UWn0Hw0Yl/0BqpSMSa9F8T+rNjfq1bXLbverSP/eX/L8gIoeamJXw5fUFqii1sTYfXGHWzTp7v3P5/P24T+ymt8oNfCmqQW3uoZsGOIT+Erevl3+oXU8EiLenSPPRgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soZRWFIlvqT6DfyaNPSZiPB9KTUPw/PFTDy4Hm+2yiY=;
 b=jbkS1/1koVhvbEo/d50DPIpJMynFuRqLRAgSyPxKQtmCFOf6l2LOBffKDIFWl7e1iZmoC9Pdrb1FzK+LRqw3L7dV7JR/v1Qm8V5bSEM0BLd0qIvf4P0TmfwGWu+wPoM4nwunOdG+27AwCQR6eZarJA6Z8i3IT7efsQSAl9QaMmY=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by DS7PR10MB5072.namprd10.prod.outlook.com (2603:10b6:5:3b1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Tue, 7 Jun
 2022 11:52:48 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:52:48 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8AgAAI2QCAAATTAIAAClqAgAACeoCABMTKgIACr/WA
Date:   Tue, 7 Jun 2022 11:52:48 +0000
Message-ID: <a7a73ca7dd521d632ac9b55fa17e083493765174.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
         <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
         <20220602095756.764471e8@kernel.org>
         <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
         <20220602105215.12aff895@kernel.org>
         <2765ed7299a05d6740ce7040b6ebe724b5979620.camel@infinera.com>
         <Ypz69QV6n5mW6Wl4@lunn.ch>
In-Reply-To: <Ypz69QV6n5mW6Wl4@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0c699f8-e977-484e-219f-08da487c3e4e
x-ms-traffictypediagnostic: DS7PR10MB5072:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5072976D8EB6DECC20E514B1F4A59@DS7PR10MB5072.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QpwIJ6/UbBLzqKzrwGH9rDP8ohSM+WoH4/qDHcpvC+zaNgm5dapUaURIB887ulp1GaQbdmJs1GjKu6hUii5zH+0/YTtFhDLNwPvPt/xBzaVyXc51LT9VKNLGXDRcikkYemMjgjdB9XT80r7r7A+JbaPNr2YrhklCMNE8Rntd8Wp2t9rnnrmF7ywPCkuMDs79vxzP/o1yXnm/I9+bzo7JD/ZctqKIQpNMnxohY1yyxQJ1eZc0HWJtchIvBvEGMMVsI1wXKTeUUwEB9vfoxnYdmAkiR43WP6kAUjWTtIkFroveAJ6nQFw7MAr7pl6KIZ8L8OdXImZrU6ajCb+9VGdyah1X0/A3fy/wKzD3DxVF7UUMtYi64RmBGJR414bFYA7K5m9ULYGpcrckh9V/gsVVScOnBNNaFyDSoQFWUdeqmftrE6HQDSOOhf6PyQNbEwgNnhRrlHhpzHw7VGcJ0KbmBQ4SoErS2Tuh2KiBLrU7kz0Q64hs+cX9tXXpVhZwRWSSrb67X60gxFjPifM9cHp0XcmWiUfEL5PuE9kQ0Qp46JFeA3GmtPOsvhk2bEOiX1AtI1g0MyD3a6BBbRh+aM9vizzfnRXEGjYlKl++jZioUwY+VcL21dnkw4BaBpPii5gX8AwCVIoxaYIvvgUM2GR5bXHX7XVGgL9olyE7yvr3BZHKB8osKetTErha+fO3qW5ZeMZdIcvViiBOZ5mmf/FPmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(8676002)(83380400001)(38100700002)(4326008)(66476007)(66556008)(64756008)(66446008)(66946007)(5660300002)(2906002)(508600001)(38070700005)(91956017)(8936002)(71200400001)(6486002)(6916009)(54906003)(122000001)(36756003)(186003)(2616005)(6512007)(26005)(6506007)(86362001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVZNVG5yVm4wU3FoRWRTMndkN01lNEFLY3VjNE9TOGxtRng0UXJyVm5Td24z?=
 =?utf-8?B?alpBeDVvWXF1dmhkYmNyUTdDVlZVaW5xMjZLc3BMWkJyb0hkYVhOUXZZVGJN?=
 =?utf-8?B?ZnNHWElKR0tES0lxZUZrcGkwQnpoOTFFbEFYZ1lQa0FjbVQ4S3c3RWhubllW?=
 =?utf-8?B?UDVxelhNdjA2b3R3VlZreks1d3BHL1JQclhrTHoyRFV2c2JVRlhjVERteC94?=
 =?utf-8?B?UUx3c1pKbFNvRndIKzlYeCtvRTFYSUNRYWlhNkU0aEJhZVFrWFJkL2NUK1lX?=
 =?utf-8?B?UFhxam01dThFN0FPNjRyeVJaYTArbWZFS0N3M2JDSk1MZVlDZDVzNWtQNlZx?=
 =?utf-8?B?ajluQXpiOG9US1FINytVT3B5V2VVTEJhQ2JHdkZkVXFpM2dNQnpVbUh5MjRo?=
 =?utf-8?B?U0plUStGTm9mMGU4UHRueUFZdzgxVGg5VzZabS85TENTa2xXZWIwTEdJaHVh?=
 =?utf-8?B?ZVQ3UmQzSVE4OFlLWVRtenY3YjdaWGVmZVovbnd1RUY4aU44VllIVVlzekRT?=
 =?utf-8?B?bCtrTjZRV0RmQTRLVEZWMTAyT0J3K2Y5VHVBK1JJUlNmZDh6QUlhSldrT1N1?=
 =?utf-8?B?cDhvN0ZCc3lxdEhOZ28wSXJTdkVjbkVVQVIrTDJ0YUdzdmQ3ZGdCVEZoNFhF?=
 =?utf-8?B?UnhrOTV3RFNaNXh6YXFERlUxbHM5UkRaTFlManVkRTE1YVpjVmZNaTY3bkcr?=
 =?utf-8?B?aUxiV2hmVXYxeXJlcnE2YkhyV2M3QXRLdXMrVmMxaTI4dDRLNFlWdThraElT?=
 =?utf-8?B?aDE2SHlzWjhlbEcwOHo0MkFJY0dXUE1xOHRTVzRmSWdhdnRjdXFBOE9hMlRQ?=
 =?utf-8?B?ME8vakcrZi9BRjNObmNHOE1VL3hjNjhFTFBvQ3NiVTBwQnEyMXBha3QvdFRR?=
 =?utf-8?B?N0JKMVBsOXFhZXhPcDVxZ1NEaWk4N2pBU200TkQ1UVhxd2pLcGxxb05SNkpu?=
 =?utf-8?B?ZW9Sc041dDZjN2dkSEs2cUtRYk41d3YydCsrRWk4dHA1Zlk4cnVZcXRVNnRY?=
 =?utf-8?B?L0hHcDZ4aDJQQi9aSEtFRS83cW9SQ1lINTB4cW9CL3RHQlY0cnlKbnJ5dXIw?=
 =?utf-8?B?cG9zaEZTbXJ6cWRFTTc5c0ZtV1g2MVRhdzNreWFRRjZXZE5qRXYyYmQrOXlN?=
 =?utf-8?B?cE5pZ2toN3JCRDc0SW9yN0NPczFjclQva0ZLdDJNNFNhd0ZDTlBaUCs1YXh2?=
 =?utf-8?B?THYyVWxQc251eTBvTi94TGJRaUl4a3RHMFVodXZBSS9ITlBUMGNGNXBXZXNh?=
 =?utf-8?B?cWZHemM5MHJubDBDOGNYb3c3KzZsSnVWOWdPUmpGcU1tTnN2UExiT3VENEsw?=
 =?utf-8?B?ekRoSjVjTUQ1NytieUxmU1kreGJwc05GNXdYNC9idmI2RzUxeXVNUUQwS01t?=
 =?utf-8?B?WEtoeUlOL1V5VlJtamowNzg2VlFQcE5KdXgreEhlK2NsTnd1eElHRlpOdTlD?=
 =?utf-8?B?VjRIckRMMUNQb2hVV1gxVmhiUnFaVGFqaGFNdTE5M0lIcUFUTHJIcUthdnk5?=
 =?utf-8?B?NmhtTlJjRXB4NkNoSytVektKNjd5b3FIQlVCZFpGRDNzc2kwWkUrYklhaStD?=
 =?utf-8?B?dlF4OGdHQXo1TE9kWVlGeUR4ZUdCS0NTK3pHaVFIMUFGa24vdXNFOWs1ZUh2?=
 =?utf-8?B?SWYxcHEwMXp0SzBvZmNaUm5OZE1ja1FRRkhKQXNQNXEzOHpNekxXcUFmMVRj?=
 =?utf-8?B?ZUlNdzNqaGwrbFV1OTZuLzVCRnY5ZWtHSTNwdXYwdzVXV0NvT2hLbHY2d2pk?=
 =?utf-8?B?UDhHUm5TYW1Gbld1TDhlcExrWnlTcGFHc1ZrTzN2SC9Qc3VHZ0VUSEFMSHBT?=
 =?utf-8?B?RHFBT044T3oyZlBHNXk2aEs4SWFkL0tvOHBvbGQzZ1ZQNktaSjEwc3RKdkVj?=
 =?utf-8?B?N2hCeVRFcGNZY001aFkvR1R6V0RHcEFvVVNrL2dtUjFSd2dIMFBLclJBQWFl?=
 =?utf-8?B?Q092SUxNVVArU3FjSGFCYzBCSHZCZmRhZG9VRkdYVzVwVldFOGZZa2M3alJG?=
 =?utf-8?B?NVdrckdIWFFYWTRlY21UT2RqWHU1dTdSNDcxTmNWNHZFeDAwM0lmR2tYN3Fa?=
 =?utf-8?B?MTVOWXlqbmltelNtSmQ0NS9ZaTMrNU12T1FncjBQRUozL1R1aHZwcnZyUnBo?=
 =?utf-8?B?TGZKTDIyK0FLWUtXUjY4ZGNkbmM0US84RHhwdmNyZCszdlRHSzlDMnFEYnI2?=
 =?utf-8?B?cHNzTnVJc1A1UGhkdEE5SFNVcGxBaStkTTh1ZTR4bTZZU2pzVlNKUXBPT3RV?=
 =?utf-8?B?VEU5M2xKa3BmcFVMMmNPbXk0UW9DRFFKcS9BaTBmT3FGeVhvb0ZCU3JDYXlW?=
 =?utf-8?B?V1hPbEZyMUoxWXVXajV1WllnRU9zVjFDbFhKbmxxZGNHbkxER2NYRFZ2Wnln?=
 =?utf-8?Q?BK0wQLAA1IsYVb6s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F2B5BE015B34A4F90662D80512E8578@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c699f8-e977-484e-219f-08da487c3e4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 11:52:48.4486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4++v+Hz8rsh8j3+H+7BROSmY/vy1OvXmBAey7YGU+Fqghss5AMPW2//KxBwpEdsCWUUILSrjvmbsXQo9v8o3hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIyLTA2LTA1IGF0IDIwOjUwICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVGh1LCBKdW4gMDIsIDIwMjIgYXQgMDY6MDE6MDhQTSArMDAwMCwgSm9ha2ltIFRqZXJubHVu
ZCB3cm90ZToNCj4gPiBPbiBUaHUsIDIwMjItMDYtMDIgYXQgMTA6NTIgLTA3MDAsIEpha3ViIEtp
Y2luc2tpIHdyb3RlOg0KPiA+ID4gT24gVGh1LCAyIEp1biAyMDIyIDE3OjE1OjEzICswMDAwIEpv
YWtpbSBUamVybmx1bmQgd3JvdGU6DQo+ID4gPiA+ID4gV2hhdCBpcyAib3VyIEhXIiwgd2hhdCBr
ZXJuZWwgZHJpdmVyIGRvZXMgaXQgdXNlIGFuZCB3aHkgY2FuJ3QgdGhlDQo+ID4gPiA+ID4ga2Vy
bmVsIGRyaXZlciB0YWtlIGNhcmUgb2YgbWFraW5nIHN1cmUgdGhlIGRldmljZSBpcyBub3QgYWNj
ZXNzZWQNCj4gPiA+ID4gPiB3aGVuIGl0J2QgY3Jhc2ggdGhlIHN5c3RlbT8gIA0KPiA+ID4gPiAN
Cj4gPiA+ID4gSXQgaXMgYSBjdXN0b20gYXNpYyB3aXRoIHNvbWUgaG9tZWdyb3duIGNvbnRyb2xs
ZXIuIFRoZSBmdWxsIGNvbmZpZyBwYXRoIGlzIHRvbyBjb21wbGV4IGZvciBrZXJuZWwgdG9vDQo+
ID4gPiA+IGtub3cgYW5kIGRlcGVuZHMgb24gdXNlciBpbnB1dC4NCj4gPiA+IA0KPiA+ID4gV2Ug
aGF2ZSBhIGxvbmcgc3RhbmRpbmcgdHJhZGl0aW9uIG9mIG5vdCBjYXJpbmcgYWJvdXQgdXNlciBz
cGFjZQ0KPiA+ID4gZHJpdmVycyBpbiBuZXRkZXYgbGFuZC4gSSBzZWUgbm8gcmVhc29uIHRvIG1l
cmdlIHRoaXMgcGF0Y2ggdXBzdHJlYW0uDQo+ID4gDQo+ID4gVGhpcyBpcyBub3QgYSB1c2VyIHNw
YWNlIGRyaXZlci4gVmlldyBpdCBhcyBhIGV0aCBjb250cm9sbGVyIHdpdGggYSBkdW0gUEhZDQo+
ID4gd2hpY2ggY2Fubm90IGNvbnZleSBsaW5rIHN0YXR1cy4gVGhlIGtlcm5lbCBkcml2ZXIgdGhl
biBuZWVkcyBoZWxwIHdpdGggbWFuYWdpbmcgY2Fycmllci4NCj4gDQo+IFBsZWFzZSBwb3N0IHRo
ZSBNQUMgZHJpdmVyIHRoZW4uIFdlIGRvbid0IHJlYWxseSBsaWtlIGNoYW5nZXMgdG8gdGhlDQo+
IGtlcm5lbCB3aXRob3V0IGEgdXNlci4gWW91IE1BQyBkcml2ZXIgd291bGQgYmUgc3VjaCBhIHVz
ZXIuDQoNClRoYXQgZHJpdmVyIGlzIGZhciBmcm9tIGtlcm5lbCBwcm9wZXIvdXBzdHJlYW0gd29y
dGh5IC4uDQoNCj4gDQo+IENvdWxkIHlvdSBhbHNvIHRlbGwgdXMgbW9yZSBhYm91dCB0aGUgUEhZ
LiBXaGF0IGNhcGFiaWxpdGllcyBkb2VzIGl0DQo+IGhhdmU/IEkgYXNzdW1lIGl0IGlzIG5vdCBD
MjIgY29tcGF0aWJsZS4gRG9lcyBpdCBhdCBsZWFzdCBoYXZlIHNvbWUNCj4gc29ydCBvZiBpbmRp
Y2F0b3Igb2YgbGluaz8gV2hhdCBtaWdodCBtYWtlIHNlbnNlIGlzIHRvIHVzZSB0aGUNCg0KVGhl
cmUgaXMgbm8gUEhZIHJlYWxseSwgZnJvbSBrZXJuZWxzIFBPViBpdCBpcyBqdXN0IGEgRE1BIGVu
Z2luZSBhbmQgYWxsDQp0aGUgc2V0dXAgbmVlZGVkIHRvIHNldHVwIHRoZSBmdWxsIHBhdGggaXMg
aW4gVVMuDQoNCj4gZml4ZWQtbGluayBjb2RlLiBZb3UgY2FuIHByb3ZpZGUgYSBjYWxsYmFjayB3
aGljaCBnaXZlcyB0aGUgYWN0dWFsDQo+IGxpbmsgc3RhdHVzIHVwL2Rvd24uIEFuZCB0aGUgZml4
ZWQtbGluayBkcml2ZXIgbG9va3MgbGlrZSBhIHJlYWwgUEhZLA0KPiBzbyB0aGUgTUFDIGRyaXZl
ciBkb2VzIG5vdCBuZWVkIHRvIGRvIGFueXRoaW5nIHNwZWNpYWwuDQoNClRoZSBmaXhlZCBQSFkg
aGFzIHRoZSBzYW1lIHByb2JsZW0gYXMgaXQgdXNlcyB0aGUgc2FtZSBzeXNmcyBJL0YuIEkgYW0g
anVzdA0KYXNraW5nIHRoYXQgdGhlIHN5c2ZzIGNhcnJpZXIgSS9GIHNob3VsZCBiZSB3cml0ZWFi
bGUgYW5kIHJlYWRhYmxlIHdoZW4gSS9GIGlzDQpET1dOLiBOb3cgb25lIGNhbm5vdCBldmVuIHJl
YWQgY2FycmllciBzdGF0dXMgd2hlbiBJL0YgaXMgZG93bi4NCg0KPiANCj4gICAgQW5kcmV3DQoN
Cg==
