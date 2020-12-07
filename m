Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1032D14F8
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgLGPmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:42:47 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:16396 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgLGPmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:42:46 -0500
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7FVc3C001264;
        Mon, 7 Dec 2020 10:41:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=Yl033VIlG1IECCjazmwRTE+HQDUuq8uOXglGVuShf2I=;
 b=G34dyOyGblFd2YcR9LX28R7DjWfM8vQ1x+qoQkBDw1DzUwZyQTszl3Pe5qnDYu/vyaJH
 ceE69OAr7tsl0HmFPFcQdDzpwj6/3EbdZuLdSXzg+ty5h55zi2Hxp83DAbXqAYxYwJxY
 /Q/fwhtjoAwJL9VOGvc+orE29DqDI7kriitKCW4VQ2wuaGll73F324oy8s05Yd36TVoF
 EzWYYhAbiMXofcvHLKgTgelGLKIkVeGo8WT6YqA7dEoGrqUk9KLCmbbqlOxpjZ3wAHW4
 HV6A5JQQXYWPitwxCj2E1Di/pvzJCl/LIuSKkiDpqIzbh/fq2EYrE7seHfv2xU//rN9v MQ== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0b-00154904.pphosted.com with ESMTP id 358b6ndm5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 10:41:51 -0500
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
        by mx0b-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7FUt7H013621;
        Mon, 7 Dec 2020 10:41:50 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0b-00154901.pphosted.com with ESMTP id 359kc64jq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 10:41:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZxAzuNNYDMyjEI3g+jFpJARmAkLl4hV7QEFEit/v8UW+9FR4ChJJzq1XMJuuf2r4/ecpNFSz3/ErkmeNaaFHAm5AxI5j6F7DivAqPXEBsWaFnRKakNjrid+glexKtsIIWtCCMgRTJBZ62XlWEFIfPILs8Sl+g6CWWDKWUXO6WuoHIc7iAFpLENEGLCMUI8pJ4U/xxFYWvsHfeZlANX6L1dR9umziS/oZZ4oCCJI52TiWqU1+Hp29CD8VCbBhs0nOjwcVkkaGYzKFYCueUc8OrJUmysaAeg1K5C1kFhV1j1AYPBDN0eCywHmD80IUpPwqMC1PrfdqSQ5EpJLu2XzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl033VIlG1IECCjazmwRTE+HQDUuq8uOXglGVuShf2I=;
 b=ZQHgihSr/lfwhJc5p88Fde5GC5TOIb/HvvOzs2dBtolQdFDvSDschyTJ50MDVM31ZQMOmd+WaXgs9dLVSWiKfxA32n0CbO/RdhdsY8ehrGdM63IBe8kbeuU//QiXj3vrh329fpNsK4Hj/hBwUoUpvSSVZxS1/mR4XzTM6vdQ9KijguIAU0XHw0d9VRTI9Z0WTDffLVZs6ryktzSvNix0AWdnawCrzr1eRz5DzPA1UAEXW5mg16wFRXZmCz0BZb2xwFtuyrnfBSEDTwtZwmQ2Ag5+mcqRzYmfxGFd5XzLe2PfHhdkTrDhMTzrxFKOmKYMKDC3bIg7EK6nKpCmk7halA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl033VIlG1IECCjazmwRTE+HQDUuq8uOXglGVuShf2I=;
 b=aJ+MiAAJp66j1k/yCwM4jslRnuo9rYS9+zTHciNduwLpXCSnQ+afzg1Kk3c2BY90lZ/p0R3ryVu7EOs00WDb7x1fJM1zCQzOKcNugaJs0QCRAcp7nsHfRmNxkdFG2B6ksOsofvJII/DER7qiEw5jlafx1DWju0PsLRhSNFYpCRU=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DM6PR19MB3993.namprd19.prod.outlook.com (2603:10b6:5:1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.18; Mon, 7 Dec 2020 15:41:48 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 15:41:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
Subject: RE: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Topic: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Thread-Index: AQHWynlfqP1K6e0vqUqfE6etAZ98TqnrpJ0AgAAfsNA=
Date:   Mon, 7 Dec 2020 15:41:48 +0000
Message-ID: <DM6PR19MB2636A4097B68DBB253C416D8FACE0@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
 <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
In-Reply-To: <d0f7e565-05e1-437e-4342-55eb73daa907@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-12-07T15:22:41.6229061Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=39b0ae18-a5d1-4afd-8c1d-13344afa4a46;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21866001-96b4-4978-8102-08d89ac69c2d
x-ms-traffictypediagnostic: DM6PR19MB3993:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR19MB399392EAF9AD5227637AAF74FACE0@DM6PR19MB3993.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t5N/SjnsarLrm07P+9RR5YC9ZgIm/2i4alDMwL7ovW+j3cxrp3B/LMjfNMnDRcnCkJNyX/xLhDGfwCmyqzmzICJio4aM2UijSdiFhztJO+pOpkcKuV++k1SymvAvEyW1/pUux1DE8tvqIaGWVNL0HIiuGfgF8TCAbsp+2sGBlcgthKzHA2+QWNB4frVS/8yQn5FVpu9+QcbbUM6Lnan9GYFd4xUI9F20XYcKYmfqqsvu6GYySvlZsZspV4farq7uG9IXcAQVkMOwMfq4akU4HbfZLkVnlXtWnB8k/t3fauV65vRUWOC7yLiGBSiPrXJd9UaqFFP99h2PYbNw0PzUZhcRqF+DOVSJfNv9Kem9YPDmTqw/fuk6y97DJ18PWEbqYkcIMqh17ExyeHREcNlWgPfvoerP3jVafJfKzjErKnktNKfBps6Z0HdyxrkoXQ8AcGEXDBnOYc7l099tkRESVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(66946007)(5660300002)(66556008)(110136005)(4326008)(86362001)(64756008)(71200400001)(83380400001)(966005)(2906002)(52536014)(76116006)(7416002)(8676002)(8936002)(54906003)(9686003)(478600001)(186003)(66446008)(66476007)(6506007)(55016002)(786003)(33656002)(26005)(7696005)(316002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OEk3N3d1dWZZSXp6RTB4SS9VYytQaFp0K25rL2ppWG9oTUYyWm9UYzB1aFRx?=
 =?utf-8?B?N2VIYXI5ZFplZmtpdXlnTTJJdGd0TUMzR1Rmak8xbERGSXpiZGZMdEUya3lT?=
 =?utf-8?B?RjVtRmFldlo3bzA1aHZPZ0RpakduUTNlYTQxMGxQZ0M5Y2wzR3l5RnovSTYz?=
 =?utf-8?B?cXJpeWM2V2o0UmlWcmtLbzdUUVcrcktTMjRjblQ2Vk5ISWdxemVKTWZHeTFz?=
 =?utf-8?B?RFBQeHBRMHB3QXF3QTVYdWpsQitDT1k2MEZXSnFyRDAzazVGMFpMRVlVNEVa?=
 =?utf-8?B?RU1pRjAzeTVOZnp0WFpWOVMrZzJsaUMyRE1hM3JTSWNNUk9UaTBhd1djaWwr?=
 =?utf-8?B?Wjh3ODQ2V2ZSamJYd21HY05UMnJKb1o2djNpMW5DYStOSFZ6TjgxM2RFb3pO?=
 =?utf-8?B?blJSd1hzenhML0grTVIrbTIxL0Y5bXN6Y3VZcDJrUkNjYnJFbDcya0RyUHFn?=
 =?utf-8?B?NEoxWnB6WmxNcno4NFY5MzlnbXBITHdqWVpWQkdKNTFrMm5LVXIwNUR6UEVj?=
 =?utf-8?B?UjN3dCtFMU9GOWwvOTl4aDJPUXVXTTlidEZYWDhMRGdicXR2OVJUWFhMcm16?=
 =?utf-8?B?NkNLbitweWJkQWtTTVdIMSthUGcwTFR5ZCsvT0l3dzJNUmY0SVlGakFPVTRx?=
 =?utf-8?B?QVhzSlZjNXdQcVhYVmdwSjJOQ1V3dkR2NFVXWFRZUnZsa1FUdm4xSndBMmo1?=
 =?utf-8?B?YzhiNW9nSkFNajhqK3A4aWFkUVVYeS9JZWdKOUZITnFtRVVYWjBBMDAySDk2?=
 =?utf-8?B?OFlpSEpEczhjamg3RU9SMEpMV3N1akVURXMzZ1UyRlNBanBsWHJPQlZFMDRG?=
 =?utf-8?B?OWx2N0VPVmhUN29YNzJ4VnZlYklkOUl3Q1VvbGdEdnVQejNWTG5HbWc0dzJS?=
 =?utf-8?B?dThoZVl5R29sV1AxYU94eUFldjFwaklMYzN2V3VOVnkrQXhZd2NWQXg0MWxi?=
 =?utf-8?B?dVdmRDFuM0pJQkp6bFFFbDgzU0YrUVMwQnl5YlU4TG9pY3pjT0FUVmxTbXVK?=
 =?utf-8?B?aExiR0Y3emVkcm4zb2FaVmhIZjkxOW1VWlZ1UE9iU1ZDcFplTDJIRmhxWXpS?=
 =?utf-8?B?WUdKdWtqM0Q2WjRpY3Y1UHI0ckF4QWs5Z1VobnN0QmNUUXZBa2p3VEVMTjJs?=
 =?utf-8?B?bWVIaVRNYVhiMmZIZWYxMm9oRk5SNjlSN285czRESFNIT055TVhuRnN1VFpr?=
 =?utf-8?B?QmE3eTNlUUxtS2VLVytYLzJ5RE9ZWWVqZWFKNjZ5b3kvR29oRkRrYk5VOGw2?=
 =?utf-8?B?WU1MbTNTM3FUdUFRZWhKTzM2ZDZmS0ZNbzROU0JQT0pZSFlRNVZ0UFR1cUxm?=
 =?utf-8?Q?9WvyqkDyproIc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21866001-96b4-4978-8102-08d89ac69c2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 15:41:48.6905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uoK6jRH8KdoNxqUar9rmd3QSy2kedsMLrEL9KYdfqdy0P10rlXn0bsOPgAXHbSQEUzhI5CKPL2YOB/Vu3zqx8mQwy4WQMrBAInHMrrZ4oi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3993
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070100
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGaXJzdCBvZiBhbGwgdGhhbmsgeW91IGZvciB3b3JraW5nIG9uIHRoaXMuDQo+IA0KPiBJIG11
c3Qgc2F5IHRob3VnaCB0aGF0IEkgZG9uJ3QgbGlrZSB0aGUgYXBwcm9hY2ggdGFrZW4gaGVyZSB2
ZXJ5DQo+IG11Y2guDQo+IA0KPiBUaGlzIGlzIG5vdCBzbyBtdWNoIGEgY3JpdGljaXNtIG9mIHRo
aXMgc2VyaWVzIGFzIGl0IGlzIGEgY3JpdGljaXNtDQo+IG9mIHRoZSBlYXJsaWVyIGRlY2lzaW9u
IHRvIHNpbXBseSBkaXNhYmxlIHMwaXggb24gYWxsIGRldmljZXMNCj4gd2l0aCB0aGUgaTIxOS1M
TSArIGFuZCBhY3RpdmUgTUUuDQoNCkkgd2FzIG5vdCBoYXBweSB3aXRoIHRoYXQgZGVjaXNpb24g
ZWl0aGVyIGFzIGl0IGRpZCBjYXVzZSByZWdyZXNzaW9ucw0Kb24gYWxsIG9mIHRoZSAibmFtZWQi
IENvbWV0IExha2UgbGFwdG9wcyB0aGF0IHdlcmUgaW4gdGhlIG1hcmtldCBhdA0KdGhlIHRpbWUu
ICBUaGUgInVubmFtZWQiIG9uZXMgYXJlIG5vdCB5ZXQgcmVsZWFzZWQsIGFuZCBJIGRvbid0IGZl
ZWwNCml0J3MgZmFpciB0byBjYWxsIGl0IGEgcmVncmVzc2lvbiBvbiAidW5yZWxlYXNlZCIgaGFy
ZHdhcmUuDQoNCj4gDQo+IEFGQUlLIHRoZXJlIHdhcyBhIHBlcmZlY3RseSBhY2NlcHRhYmxlIHBh
dGNoIHRvIHdvcmthcm91bmQgdGhvc2UNCj4gYnJva2VuIGRldmljZXMsIHdoaWNoIGluY3JlYXNl
ZCBhIHRpbWVvdXQ6DQo+IGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcHJvamVjdC9pbnRl
bC13aXJlZC0NCj4gbGFuL3BhdGNoLzIwMjAwMzIzMTkxNjM5LjQ4ODI2LTEtYWFyb24ubWFAY2Fu
b25pY2FsLmNvbS8NCj4gDQo+IFRoYXQgcGF0Y2ggd2FzIG5hY2tlZCBiZWNhdXNlIGl0IGluY3Jl
YXNlZCB0aGUgcmVzdW1lIHRpbWUNCj4gKm9uIGJyb2tlbiBkZXZpY2VzKi4NCj4gDQo+IFNvIGl0
IHNlZW1zIHRvIG1lIHRoYXQgd2UgaGF2ZSBhIHNpbXBsZSBjaG9pY2UgaGVyZToNCj4gDQo+IDEu
IExvbmdlciByZXN1bWUgdGltZSBvbiBkZXZpY2VzIHdpdGggYW4gaW1wcm9wZXJseSBjb25maWd1
cmVkIE1FDQo+IDIuIEhpZ2hlciBwb3dlci1jb25zdW1wdGlvbiBvbiBhbGwgbm9uLWJ1Z2d5IGRl
dmljZXMNCj4gDQo+IFlvdXIgcGF0Y2hlcyA0LTcgdHJ5IHRvIHdvcmthcm91bmQgMi4gYnV0IElN
SE8gdGhvc2UgYXJlIGp1c3QNCj4gYmFuZGFpZHMgZm9yIGdldHRpbmcgdGhlIGluaXRpYWwgcHJp
b3JpdGllcyAqdmVyeSogd3JvbmcuDQoNClRoZXkgd2VyZSBkb25lIGJhc2VkIHVwb24gdGhlIGRp
c2N1c3Npb24gaW4gdGhhdCB0aHJlYWQgeW91IGxpbmtlZCBhbmQgb3RoZXJzLg0KSWYgdGhlIG93
bmVycyBvZiB0aGlzIGRyaXZlciBmZWVsIGl0J3MgcG9zc2libGUvc2NhbGFibGUgdG8gZm9sbG93
IHlvdXIgcHJvcG9zYWwNCkknbSBoYXBweSB0byByZXN1Ym1pdCBhIG5ldyB2NCBzZXJpZXMgd2l0
aCB0aGVzZSBzZXRzIG9mIHBhdGNoZXM6DQoNCjEpIEZpeHVwIGZvciB0aGUgZXhjZXB0aW9uIGNv
cm5lciBjYXNlIHJlZmVyZW5jZWQgaW4gdGhpcyB0aHJlYWQNCjIpIFBhdGNoIDEgZnJvbSB0aGlz
IHNlcmllcyB0aGF0IGZpeGVzIGNhYmxlIGNvbm5lY3RlZCBjYXNlDQozKSBJbmNyZWFzZSB0aGUg
dGltZW91dCAoZnJvbSB5b3VyIHJlZmVyZW5jZWQgbGluaykNCjQpIFJldmVydCB0aGUgTUUgZGlz
YWxsb3cgbGlzdA0KDQo+IA0KPiBJbnN0ZWFkIG9mIHBlbmFsaXppbmcgbm9uLWJ1Z2d5IGRldmlj
ZXMgd2l0aCBhIGhpZ2hlciBwb3dlci1jb25zdW1wdGlvbiwNCj4gd2Ugc2hvdWxkIGRlZmF1bHQg
dG8gcGVuYWxpemluZyB0aGUgYnVnZ3kgZGV2aWNlcyB3aXRoIGEgaGlnaGVyDQo+IHJlc3VtZSB0
aW1lLiBBbmQgaWYgaXQgaXMgZGVjaWRlZCB0aGF0IHRoZSBoaWdoZXIgcmVzdW1lIHRpbWUgaXMN
Cj4gYSB3b3JzZSBwcm9ibGVtIHRoZW4gdGhlIGhpZ2hlciBwb3dlci1jb25zdW1wdGlvbiwgdGhl
biB0aGVyZQ0KPiBzaG91bGQgYmUgYSBsaXN0IG9mIGJyb2tlbiBkZXZpY2VzIGFuZCBzMGl4IGNh
biBiZSBkaXNhYmxlZCBvbiB0aG9zZS4NCg0KSSdtIHBlcmZlY3RseSBoYXBweSBlaXRoZXIgd2F5
LCBteSBwcmltYXJ5IGdvYWwgaXMgdGhhdCBEZWxsJ3Mgbm90ZWJvb2tzIGFuZA0KZGVza3RvcHMg
dGhhdCBtZWV0IHRoZSBhcmNoaXRlY3R1cmFsIGFuZCBmaXJtd2FyZSBndWlkZWxpbmVzIGZvciBh
cHByb3ByaWF0ZQ0KbG93IHBvd2VyIGNvbnN1bXB0aW9uIG92ZXIgczBpeCBhcmUgbm90IHBlbmFs
aXplZC4NCg0KPiANCj4gVGhlIGN1cnJlbnQgYWxsb3ctbGlzdCBhcHByb2FjaCBpcyBzaW1wbHkg
bmV2ZXIgZ29pbmcgdG8gd29yayB3ZWxsDQo+IGxlYWRpbmcgdG8gdG9vIGhpZ2ggcG93ZXItY29u
c3VtcHRpb24gb24gY291bnRsZXNzIGRldmljZXMuDQo+IFRoaXMgaXMgZ29pbmcgdG8gYmUgYW4g
ZW5kbGVzcyBnYW1lIG9mIHdoYWNrLWEtbW9sZSBhbmQgYXMNCj4gc3VjaCByZWFsbHkgaXMgYSBi
YWQgaWRlYS4NCg0KSSBlbnZpc2lvbmVkIHRoYXQgaXQgd291bGQgZXZvbHZlIG92ZXIgdGltZS4g
IEZvciBleGFtcGxlIGlmIGJ5IHRoZSB0aW1lIERlbGwNCmZpbmlzaGVkIHNoaXBwaW5nIG5ldyBD
TUwgbW9kZWxzIGl0IHdhcyBkZWVtZWQgdGhhdCBhbGwgdGhlIENNTCBoYXJkd2FyZSB3YXMgZG9u
ZQ0KcHJvcGVybHkgaXQgY291bGQgaW5zdGVhZCBieSBhbiBhbGxvdyBsaXN0IG9mIERlbGwgKyBD
b21ldCBQb2ludC4NCklmIGFsbCBvZiBUaWdlciBMYWtlIGFyZSBkb25lIHByb3Blcmx5ICdtYXli
ZScgYnkgdGhlIHRpbWUgdGhlIE1MIHNoaXBzIG1heWJlIGl0DQpjb3VsZCBiZSBhbiBhbGxvdyBs
aXN0IG9mIERlbGwgKyBDTUwgb3IgbmV3ZXIuDQoNCkJ1dCBldmVuIGlmIHRoZSBoZXVyaXN0aWMg
Y2hhbmdlZCAtIHRoaXMgcGFydGljdWxhciBjb25maWd1cmF0aW9uIG5lZWRzIHRvIGJlIHRlc3Rl
ZA0Kb24gZXZlcnkgc2luZ2xlIG5ldyBtb2RlbC4gIEFsbCBvZiB0aGUgbm90ZWJvb2tzIHRoYXQg
aGF2ZSBhIFRlc3RlZC1CeSBjbGF1c2Ugd2VyZQ0KY2hlY2tlZCBieSBEZWxsIGFuZCBEZWxsJ3Mg
cGFydG5lcnMuDQoNCj4gDQo+IEEgZGVueS1saXN0IGZvciBicm9rZW4gZGV2aWNlcyBpcyBhIG11
Y2ggYmV0dGVyIGFwcHJvYWNoLCBlc3AuDQo+IHNpbmNlIG1pc3NpbmcgZGV2aWNlcyBvbiB0aGF0
IGxpc3Qgd2lsbCBzdGlsbCB3b3JrIGZpbmUsIHRoZXkNCj4gd2lsbCBqdXN0IGhhdmUgYSBzb21l
d2hhdCBsYXJnZXIgcmVzdW1lIHRpbWUuDQoNCkkgZG9uJ3QgaGF2ZSBjb25maWd1cmF0aW9uIGRl
ZW1lZCBidWdneS4gIFNpbmNlIHlvdSB3ZXJlIGNvbW1lbnRpbmcgaW4gdGhhdCBvdGhlcg0KdGhy
ZWFkIHdpdGggdGhlIHBhdGNoIGZyb20gQWFhcm9uIEl0IHNvdW5kcyBsaWtlIHlvdSBkby4gQ2Fu
IHlvdSBwZXJoYXBzIGNoZWNrIGlmDQp0aGF0IHByb3Bvc2FsIGFjdHVhbGx5IHdvcmtzPw0KDQo+
IA0KPiBTbyB3aGF0IG5lZWRzIHRvIGhhcHBlbiBJTUhPIGlzOg0KPiANCj4gMS4gTWVyZ2UgeW91
ciBmaXggZnJvbSBwYXRjaCAxIG9mIHRoaXMgc2V0DQo+IDIuIE1lcmdlICJlMTAwMGU6IGJ1bXAg
dXAgdGltZW91dCB0byB3YWl0IHdoZW4gTUUgdW4tY29uZmlndXJlIFVMUCBtb2RlIg0KPiAzLiBE
cm9wIHRoZSBlMTAwMGVfY2hlY2tfbWUgY2hlY2suDQo+IA0KPiBUaGVuIHdlIGFsc28gZG8gbm90
IG5lZWQgdGhlIG5ldyAiczBpeC1lbmFibGVkIiBldGhlcnRvb2wgZmxhZw0KPiBiZWNhdXNlIHdl
IGRvIG5vdCBuZWVkIHVzZXJzcGFjZSB0byB3b3JrLWFyb3VuZCB1cyBkb2luZyB0aGUNCj4gd3Jv
bmcgdGhpbmcgYnkgZGVmYXVsdC4NCg0KSWYgd2UgY29sbGVjdGl2ZWx5IGFncmVlIHRvIGtlZXAg
ZWl0aGVyIGFuIGFsbG93IGxpc3QgIm9yIiBkaXNhbGxvdyBsaXN0IGF0DQphbGwgSSB0aGluayB5
b3UgbmVlZCBhIHdheSBjaGVjayB3aGV0aGVyIGVuYWJsaW5nIHRoaXMgZmVhdHVyZSB3b3Jrcy4N
Cg0KSWYgd2UgYXJlIG1ha2luZyBhbiBhc3NlcnRpb24gaXQgd2lsbCBhbHdheXMgd29yayBwcm9w
ZXJseSBhbGwgdGhlIHRpbWUsIEkgYWdyZWUNCnRoYXQgdGhlcmUgaXMgbm8gbmVlZCBmb3IgYW4g
ZXRodG9vbCBmbGFnLg0KDQo+IA0KPiBOb3RlIGEgd2hpbGUgYWdvIEkgaGFkIGFjY2VzcyB0byBv
bmUgb2YgdGhlIGRldmljZXMgaGF2aW5nIHN1c3BlbmQvcmVzdW1lDQo+IGlzc3VlcyBjYXVzZWQg
YnkgdGhlIFMwaXggc3VwcG9ydCAoYSBMZW5vdm8gVGhpbmtwYWQgWDEgQ2FyYm9uIGdlbiA3KQ0K
PiBhbmQgSSBjYW4gY29uZmlybSB0aGF0IHRoZSAiZTEwMDBlOiBidW1wIHVwIHRpbWVvdXQgdG8g
d2FpdCB3aGVuIE1FDQo+IHVuLWNvbmZpZ3VyZSBVTFAgbW9kZSIgcGF0Y2ggZml4ZXMgdGhlIHN1
c3BlbmQvcmVzdW1lIHByb2JsZW0gd2l0aG91dA0KPiBhbnkgbm90aWNlYWJsZSBuZWdhdGl2ZSBz
aWRlLWVmZmVjdHMuDQo+IA0KDQpDYW4geW91IG9yIHNvbWVvbmUgZWxzZSB3aXRoIHRoaXMgbW9k
ZWwgcGxlYXNlIGNoZWNrIHdpdGggYSBjdXJyZW50IGtlcm5lbA0Kdy8gcmV2ZXJ0aW5nIE1FIGNo
ZWNrIGFuZCBhZGRpbmcgdGhlIHBhdGNoIGZyb20gVml0YWx5IChpbmNsdWRlZCBhcyBwYXRjaCAx
DQppbiBteSBzZXJpZXMpPw0KDQo+IFJlZ2FyZHMsDQo+IA0KPiBIYW5zDQo+IA0KPiANCj4gDQo+
IA0KPiANCj4gDQo+IA0KPiANCj4gDQo+ID4NCj4gPiBDaGFuZ2VzIGZyb20gdjIgdG8gdjM6DQo+
ID4gIC0gQ29ycmVjdCBzb21lIGdyYW1tYXIgYW5kIHNwZWxsaW5nIGlzc3VlcyBjYXVnaHQgYnkg
Qmpvcm4gSC4NCj4gPiAgICAqIHMvczBpeC9TMGl4LyBpbiBhbGwgY29tbWl0IG1lc3NhZ2VzDQo+
ID4gICAgKiBGaXggYSB0eXBvIGluIGNvbW1pdCBtZXNzYWdlDQo+ID4gICAgKiBGaXggY2FwaXRh
bGl6YXRpb24gb2YgcHJvcGVyIG5vdW5zDQo+ID4gIC0gQWRkIG1vcmUgcHJlLXJlbGVhc2Ugc3lz
dGVtcyB0aGF0IHBhc3MNCj4gPiAgLSBSZS1vcmRlciB0aGUgc2VyaWVzIHRvIGFkZCBzeXN0ZW1z
IG9ubHkgYXQgdGhlIGVuZCBvZiB0aGUgc2VyaWVzDQo+ID4gIC0gQWRkIEZpeGVzIHRhZyB0byBh
IHBhdGNoIGluIHNlcmllcy4NCj4gPg0KPiA+IENoYW5nZXMgZnJvbSB2MSB0byB2MjoNCj4gPiAg
LSBEaXJlY3RseSBpbmNvcnBvcmF0ZSBWaXRhbHkncyBkZXBlbmRlbmN5IHBhdGNoIGluIHRoZSBz
ZXJpZXMNCj4gPiAgLSBTcGxpdCBvdXQgczBpeCBjb2RlIGludG8gaXQncyBvd24gZmlsZQ0KPiA+
ICAtIEFkanVzdCBmcm9tIERNSSBtYXRjaGluZyB0byBQQ0kgc3Vic3lzdGVtIHZlbmRvciBJRC9k
ZXZpY2UgbWF0Y2hpbmcNCj4gPiAgLSBSZW1vdmUgbW9kdWxlIHBhcmFtZXRlciBhbmQgc3lzZnMs
IHVzZSBldGh0b29sIGZsYWcgaW5zdGVhZC4NCj4gPiAgLSBFeHBvcnQgczBpeCBmbGFnIHRvIGV0
aHRvb2wgcHJpdmF0ZSBmbGFncw0KPiA+ICAtIEluY2x1ZGUgbW9yZSBwZW9wbGUgYW5kIGxpc3Rz
IGRpcmVjdGx5IGluIHRoaXMgc3VibWlzc2lvbiBjaGFpbi4NCj4gPg0KPiA+IE1hcmlvIExpbW9u
Y2llbGxvICg2KToNCj4gPiAgIGUxMDAwZTogTW92ZSBhbGwgUzBpeCByZWxhdGVkIGNvZGUgaW50
byBpdHMgb3duIHNvdXJjZSBmaWxlDQo+ID4gICBlMTAwMGU6IEV4cG9ydCBTMGl4IGZsYWdzIHRv
IGV0aHRvb2wNCj4gPiAgIGUxMDAwZTogQWRkIERlbGwncyBDb21ldCBMYWtlIHN5c3RlbXMgaW50
byBTMGl4IGhldXJpc3RpY3MNCj4gPiAgIGUxMDAwZTogQWRkIG1vcmUgRGVsbCBDTUwgc3lzdGVt
cyBpbnRvIFMwaXggaGV1cmlzdGljcw0KPiA+ICAgZTEwMDBlOiBBZGQgRGVsbCBUR0wgZGVza3Rv
cCBzeXN0ZW1zIGludG8gUzBpeCBoZXVyaXN0aWNzDQo+ID4gICBlMTAwMGU6IEFkZCBhbm90aGVy
IERlbGwgVEdMIG5vdGVib29rIHN5c3RlbSBpbnRvIFMwaXggaGV1cmlzdGljcw0KPiA+DQo+ID4g
Vml0YWx5IExpZnNoaXRzICgxKToNCj4gPiAgIGUxMDAwZTogZml4IFMwaXggZmxvdyB0byBhbGxv
dyBTMGkzLjIgc3Vic2V0IGVudHJ5DQo+ID4NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvZTEwMDBlL01ha2VmaWxlICB8ICAgMiArLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9lMTAwMGUvZTEwMDAuaCAgIHwgICA0ICsNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvZTEwMDBlL2V0aHRvb2wuYyB8ICA0MCArKysNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jICB8IDI3MiArLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvczBpeC5jICAgIHwgMzExICsrKysrKysr
KysrKysrKysrKysrDQo+ID4gIDUgZmlsZXMgY2hhbmdlZCwgMzYxIGluc2VydGlvbnMoKyksIDI2
OCBkZWxldGlvbnMoLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2UxMDAwZS9zMGl4LmMNCj4gPg0KPiA+IC0tDQo+ID4gMi4yNS4xDQo+ID4NCj4g
Pg0KDQo=
