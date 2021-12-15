Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3A476091
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343701AbhLOSTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:19:22 -0500
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:40427
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343674AbhLOSTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:19:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyYCM873CnIBpxpcQgFr2eywkeVMvKSY3OjGXMvbm+Z7tTOfQlNLpW9dCGIDLDnkHpu255quK3i3GUwJj/vPD4kyZq/z3LAZbahJr1sEkS0nuPHrpNjKSn+oRptwSiuhwAXLYyzgztIFRPyvcd94SzMRKtE/R2dFVNA5q3nd/Wab+GFdyktVIq2dryZCZNWEu2EEvsNcKEc0YYin6jUpewfnYKFC1limVfNhgtLjo8eubLJozvUFJ9d/3ITfHIYXU50xrIKavMpgaHF7nQwR3i7AlN1J1ZQY0U3loXvjd4kvohzRxJ6snqG/CkV2eM9Vky9mn/eTzHBChtDb62MZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VydK5N/HbGnX957+ajUY+PLdrRx6PBMATd/RCmOy3tM=;
 b=W6+NyaT3Iu4AMxtnHq4VxkhZzMAVfNiNGYtjNC9zIWCnDX42jy4kW2CeEWTQKHxi2vguo/7Hd9QyElOmYaWCMZGKNXT76S7lEkdCTJfjOyiSJp1mG+HkKR4jXgI/zFmaOdWh/3kf+GzlkEX1arZd6NWQJTF86hiqCr5EUVDeZrtfmQsN7QS40RQuFEYFvTKrdjM130Tryja+zxKelObbpHKCrn2TUdq7yXzp+5kvXv9dNROPMrmbMVpnKziX5PDXQZORa7B2aeg4xmOyPMMMiy1qaEttwq82A3PYyGsFZBaIny5qEw8kZGan3Zigx36ooB4xjgzeuqWuGvNcbg9I1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VydK5N/HbGnX957+ajUY+PLdrRx6PBMATd/RCmOy3tM=;
 b=bW82Sypyugncy8LKpeVsaVKmIl5ldpctb8aE3erc0+D1ZT6ByOVt1x7EW3tLQ9OmY8SOcE3pKAZkVEh2aFECjDWsIQJ14tCNsJhCDg1Et/Z8IdIBgcxKJC4tSzSQu0t3GO2dYLFntJ2GpktzCdAG/+9hx2hUQVS+l8Nbl9SMOFQc3VRZy/LAFfaydZMeB4Pp3APioDi5yY1YKIJqXHWVC7FByZHNAamiNiRVbkRnnmlKefEh4klj/D1lZaGeaL5vsT4YAehGzUKywH/FIswiptf3eukZuHcUUT+nYk9xARH1X/9ZQORZRrTDP//Hd8fSp2UWrrfTV6RMICJC/AD0Pw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4981.namprd12.prod.outlook.com (2603:10b6:a03:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 18:19:17 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 18:19:17 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369esocIlp2uqECAMRBwa0Q32qwQUeyAgAxe1YCAAFJzgIAAQYMAgAJAtACAFHu+gA==
Date:   Wed, 15 Dec 2021 18:19:16 +0000
Message-ID: <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
         <20211122144307.218021-2-sunrani@nvidia.com>
         <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
         <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
         <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8449f43-9d68-4db9-88cd-08d9bff767f1
x-ms-traffictypediagnostic: BYAPR12MB4981:EE_
x-microsoft-antispam-prvs: <BYAPR12MB49819F6765BFB436CFA0EDA7B3769@BYAPR12MB4981.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Db/3bYOQlyVT+ckD6CHJ549lhbJ6kjvyLAIMk0c17GKSLv6+ZH+y3pAsQH5pP7cdqS6llIls9xOB0GGC/hJk2Au3Bm02JJr8kR/RGSIoSxy1FlISlsfkYXgIP5ncyYl3tjX0ZEcYtb5h5DlCO4epjdtcaxMcLiSWtemTde0+PNrwkisSkPXY2mKsDanLi8Ws/yC1h9XIPfjmxBZE9Oz+7INkHSc4557QBFLj2qvXSqGJEvPtV264FDBNL+aPDmf6H7wAoiZpHnEqBoiiH7SCRwR014qn6MqbHUIGM5J86fKx7pTzd88N5LavGvGPPB62FRDilz/87pdhvFYCHrb6hpXzZr4Xu/nZHMA4omTJgR9kxzAaGuoTvFcfvQNDICw05guE/tlsumm3YmEdry6MIhUuT1+nk894kR60VFU/gzUP9jN4SMWGXLw0Wm37rE70+Yl2VLOzOJBHggvKDqW7TcXB7cJVRQeE951qC15/yc4xllWsM/Ayheb+a9JsPGLT/RTA76q0B6n2x1Uqx0ZV2VN1T/Ln2UpASsIpcJZkQ7rBnia+eCGoCI1O5OnPz2X9vdUUV7+DDvkVnYYTHFahNUaxRfVBct/8oDKf2z3znrGIDtAzTjFJdpjWeAC92oeDGco3dJ2xyQRyV7RVsQjBo9xHjN11PpvxSKboyPLl9B5z1hnPta97OnSgyXHqzb7mWb/fvZUOci2Wii36o8fwIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(26005)(4326008)(83380400001)(4001150100001)(76116006)(66556008)(6486002)(5660300002)(66476007)(316002)(66946007)(64756008)(6506007)(186003)(8676002)(86362001)(6916009)(508600001)(66446008)(36756003)(2616005)(71200400001)(2906002)(54906003)(107886003)(6512007)(8936002)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkwyQ01pQ2pSNFJnU1NXa3A5RS91MW16U0YzdTd5ODhFYnZoOWU0SnZzcExv?=
 =?utf-8?B?TjQ2c1gzV01obld6MW9iSTU0QTAya1c4M2FGbyt5NHRGTFp0ODdOdFYzVnVG?=
 =?utf-8?B?ajM4a2ltSU1XbTRCb1RzaDZMUFlSVzh1N1NUQ0E2b1hTSnVBTHpNY29UYUhU?=
 =?utf-8?B?TmFZWU5qamhjZjEwVEVndDJXVGhvdkpFMXMvb292VUorM21TTWt4NUw5Rm5N?=
 =?utf-8?B?V0l2V0VVU3VxaW5NZnQ5bkpKeXZLYjFRRTVaYnJaTnNaaUw4ZXVCZjZDSkZm?=
 =?utf-8?B?d2gzUXZLVHVEaUxxVVhCZzQzRHdiSHEyV3hsSXZpdG9iOFpkUjUwV2JCamdY?=
 =?utf-8?B?TEJmckJFalZUWHp0VmpjNkYxbVV6eWtVOWR2WElCVmI4OFhZZWdzL2ppTFow?=
 =?utf-8?B?RXl2bEh3QXVieW8zNU12VUQwSGp5Rmk3UnU3ME9FYlF2VDB6dzNCQXlIWXRC?=
 =?utf-8?B?eENiZ0szZzA0ZkJiN25ZaEVROU9UMjVIUEx2L2ZNYkprajVjVWwxUFZ6aVpF?=
 =?utf-8?B?S2J4bm1sRDNGNzcrM1NyckF1VXk0MXpNMjFFTHhsNGhOU0ZSOVh0YWdXb1hC?=
 =?utf-8?B?dlRrZGtPTVZxTUVYRFJsSk9OcGtWdG9kUndtYlBPWVZrVEdMM3ptdGc5ZXdR?=
 =?utf-8?B?aUduWkNIWERDbEd3dGRsZWNCaktzQU5qMlNqaFpUWUc0WkxLVTlLWGFYZnlN?=
 =?utf-8?B?d29rTDltN3lXYzArOFN5ZGdvN25DU3JBUzEveEVPZlI3b1N0dVRXaUJBV2VK?=
 =?utf-8?B?Y1lHT29TaWRQVWJUbDBlMWFyOWIwNCt1NXRlSWlnMXV1N3cvZUFENTlMQ1JG?=
 =?utf-8?B?cWp0bTVaSmIrRXNFNlBkdWYwbWw1bkZ1SE9uZ2FXd2Y4V2Fxa0llckFUb2Na?=
 =?utf-8?B?STNPTkxlTzRSM0ZGNmV4SmZmaXByS3ZLdjE1ZzBqVG8rMS9aR2YvYTdJSmxH?=
 =?utf-8?B?RlYydFJGbnhjZVNoUFo4a2RFTW9tSlJoYmF1LzYzQ3A1SUpPQTB0VjVRczg0?=
 =?utf-8?B?OWhGc3N1N2dWUERqdGJqNDVJcTRJbjM0Y3drNERlN3psTzlWcmsraFZnbXlN?=
 =?utf-8?B?YlNDNGExYlE2a29xNDd6aEEwdlU0TFBJOWx2VzFta1pVMXJpSUQwSlFxbStZ?=
 =?utf-8?B?TjQrb2lKcCtrUkJEQ1FkWmZJRFB0QjI5eUdBbXFtOE1PNERTeVZsRk5lZWxa?=
 =?utf-8?B?d09YOUsybjhHN2JpUUFRWTdLS3o3SkVqY2VhemJuQXBSRmpZbTBibXNzMVZ2?=
 =?utf-8?B?VDVaVktrMVlOSkkvU1ZneEFXYjBvS1UxMnhCb2tpM0FSZkwzQVlOajcrTmRM?=
 =?utf-8?B?U2U1SEdPSnpxbXM1Tmhadml3eFJsTzNYdDQrc2xseElqK2pwRXQvalVCWTJ1?=
 =?utf-8?B?ZjhCOXIvcVJRNWt2RUl4TXpFdmFGUnJKMHFtdmM0VXpISzRYK1gzN21FckRJ?=
 =?utf-8?B?WDRhbEdLNE9QdUp5ODZXNHgwcTlOMERBd0lQeXZCZ1FmYS9RM2NjcGpNTFBk?=
 =?utf-8?B?TjJ5NHd2SnpsVnJkODJzdU5nSjdhVENhcVN1N1RTeUtuTEgzYy8wbDI1T2ZU?=
 =?utf-8?B?eUh4MXhJd25ya0dPK0l6SE1qQWc3cU1VRjJvTXJVSjcvb1p6ZnNkZ0JXQ2pO?=
 =?utf-8?B?R1YvVEhuU1E4Sk0yRFoxa1l6WjkrTGo2Nlp1eCtJbk5ES282YnhNV2tZS0h1?=
 =?utf-8?B?UWRFdjFSbEs0TUdLVjZMdytwSVRyTjB0N2tZYVpNdm8rQW1zMFV2akJtMmNH?=
 =?utf-8?B?U0t0MVZBT01nTDhBaVRYYkwrNGFyS0IvaWY3YzgybjdLZjl5TWNEU2MreEFh?=
 =?utf-8?B?RFFHS2xpczFRT1paNEQ5QUtXRnBucmt0dXgvN0dJQ2lzQXlFQ1VmalFSeXZk?=
 =?utf-8?B?ejJMMHBheHlVeXJTZ3dTSEhtUldOWC9XQWdZODRVakMwYjBpSFFCUFdDdFRS?=
 =?utf-8?B?NHFET0FuWVI5N2NyajJZUXNISy9UTkFaU0t1eEtoRTNkQ2NEZGxlaTl4YWVY?=
 =?utf-8?B?Sm9xaXBNVXZsMnNnQm13NWpHWThTRWwwUWZERWJOM0U0QWoxK0k5UzFXWmNX?=
 =?utf-8?B?VWF2NU5GZEE1ZmRCRXo5MXl2dWlUSnBKc2V2THE4UFZwZUpiVWs4OWJ2U3dz?=
 =?utf-8?B?RDhFZXdCWDNVWC8rcTVNNGYyLzJzOElYdldzeE55UTFWazhOTHVJOW1nNTdO?=
 =?utf-8?Q?d5+qayW3OdVdOtDrk5+nFHAepr2CBQm7FjMI2xPKQMTL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6FD77813D4D7A44B077AC14C13A2C72@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8449f43-9d68-4db9-88cd-08d9bff767f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 18:19:16.9543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +sXOvXJBaBrMOUBySXjPhRtft8EJMwJHrQbrFKoGeT3tZlaxa5dzNdEeT/xtlbwviAnqJ9GlQv8McTj286wrng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4981
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTEyLTAyIGF0IDA5OjMxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxIERlYyAyMDIxIDA3OjA3OjA1ICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+IE9uIFR1ZSwgMjAyMS0xMS0zMCBhdCAxOToxMiAtMDgwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gPiBPbiBUdWUsIDMwIE5vdiAyMDIxIDIyOjE3OjI5ICswMDAwIFN1bmlsIFN1
ZGhha2FyIFJhbmkgd3JvdGU6wqAgDQo+ID4gPiA+IFNvcnJ5IGZvciB0aGUgbGF0ZSByZXNwb25z
ZS4gV2UgYWdyZWUgdGhhdCB0aGUgY3VycmVudA0KPiA+ID4gPiBkZWZpbml0aW9uDQo+ID4gPiA+
IGlzIHZhZ3VlLg0KPiA+ID4gPiANCj4gPiA+ID4gV2hhdCB3ZSBtZWFudCBpcyB0aGF0IHRoZSBl
bmZvcmNlbWVudCBpcyBkb25lIGJ5IGRldmljZS9GVy4NCj4gPiA+ID4gV2Ugc2ltcGx5IHdhbnQg
dG8gYWxsb3cgVkYvU0YgdG8gYWNjZXNzIHByaXZpbGVnZWQgb3INCj4gPiA+ID4gcmVzdHJpY3Rl
ZA0KPiA+ID4gPiByZXNvdXJjZSBzdWNoIGFzIHBoeXNpY2FsIHBvcnQgY291bnRlcnMuDQo+ID4g
PiA+IFNvIGhvdyBhYm91dCBkZWZpbmluZyB0aGUgYXBpIHN1Y2ggdGhhdDoNCj4gPiA+ID4gVGhp
cyBrbm9iIGFsbG93cyB0aGUgVkYvU0YgdG8gYWNjZXNzIHJlc3RyaWN0ZWQgcmVzb3VyY2Ugc3Vj
aA0KPiA+ID4gPiBhcw0KPiA+ID4gPiBwaHlzaWNhbCBwb3J0IGNvdW50ZXJzLsKgIA0KPiA+ID4g
DQo+ID4gPiBZb3UgbmVlZCB0byBzYXkgbW9yZSBhYm91dCB0aGUgdXNlIGNhc2UsIEkgZG9uJ3Qg
dW5kZXJzdGFuZCANCj4gPiA+IHdoYXQgeW91J3JlIGRvaW5nLsKgIA0KPiA+IA0KPiA+IFNvbWUg
ZGV2aWNlIGZlYXR1cmVzL3JlZ2lzdGVycy91bml0cyBhcmUgbm90IGF2YWlsYWJsZSBieSBkZWZh
dWx0DQo+ID4gdG8NCj4gPiBWRnMvU0ZzIChlLmcgcmVzdHJpY3RlZCksIGV4YW1wbGVzIGFyZTog
cGh5c2ljYWwgcG9ydA0KPiA+IHJlZ2lzdGVycy9jb3VudGVycyBhbmQgc2ltaWxhciBnbG9iYWwg
YXR0cmlidXRlcy4NCj4gPiANCj4gPiBTb21lIGN1c3RvbWVycyB3YW50IHRvIHVzZSBTRi9WRiBp
biBzcGVjaWFsaXplZCBWTS9jb250YWluZXIgZm9yDQo+ID4gbWFuYWdlbWVudCBhbmQgbW9uaXRv
cmluZywgdGh1cyB0aGV5IHdhbnQgU0YvVkYgdG8gaGF2ZSBzaW1pbGFyDQo+ID4gcHJpdmlsZWdl
cyB0byBQRiBpbiB0ZXJtcyBvZiBhY2Nlc3MgdG8gcmVzdHJpY3RlZCByZXNvdXJjZXMuDQo+ID4g
DQo+ID4gTm90ZTogdGhpcyBkb2Vzbid0IGJyZWFrIHRoZSBzcmlvdi9zZiBtb2RlbCwgdHJ1c3Rl
ZCBTRi9WRiB3aWxsIG5vdA0KPiA+IGJlDQo+ID4gYWxsb3dlZCB0byBhbHRlciBkZXZpY2UgYXR0
cmlidXRlcywgdGhleSB3aWxsIHNpbXBseSBlbmpveSBhY2Nlc3MNCj4gPiB0bw0KPiA+IG1vcmUg
cmVzb3VyY2VzL2ZlYXR1cmVzLg0KPiANCj4gTm9uZSBvZiB0aGlzIGV4cGxhaW5zIHRoZSB1c2Ug
Y2FzZS4gSXQncyBwcmV0dHkgbXVjaCB3aGF0IFN1bmlsDQo+IGFscmVhZHkNCj4gc3RhdGVkLiAN
Cj4gDQo+IA0KDQpBZnRlciBzb21lIGludGVybmFsIGRpc2N1c3Npb25zLCB0aGUgcGxhbiBpcyB0
byBub3QgcHVzaCBuZXcNCmludGVyZmFjZXMsIGJ1dCB0byB1dGlsaXplIHRoZSBleGlzdGluZyBk
ZXZsaW5rIHBhcmFtcyBpbnRlcmZhY2UgZm9yDQpkZXZsaW5rIHBvcnQgZnVuY3Rpb25zLg0KDQpX
ZSB3aWxsIHN1Z2dlc3QgYSBtb3JlIGZpbmUgZ3JhaW5lZCBwYXJhbWV0ZXJzIHRvIGNvbnRyb2wg
YSBwb3J0DQpmdW5jdGlvbiAoU0YvVkYpIHdlbGwtZGVmaW5lZCBjYXBhYmlsaXRpZXMuDQoNCmRl
dmxpbmsgcG9ydCBmdW5jdGlvbiBwYXJhbSBzZXQvZ2V0IERFVi9QT1JUX0lOREVYIG5hbWUgUEFS
QU1FVEVSIHZhbHVlDQpWQUxVRSBjbW9kZSB7IHJ1bnRpbWUgfCBkcml2ZXJpbml0IHwgcGVybWFu
ZW50IH0NCg0KSmlyaSBpcyBhbHJlYWR5IG9uLWJvYXJkLiBKYWt1YiBJIGhvcGUgeW91IGFyZSBv
ayB3aXRoIHRoaXMsIGxldCB1cw0Ka25vdyBpZiB5b3UgaGF2ZSBhbnkgY29uY2VybnMgYmVmb3Jl
IHdlIHN0YXJ0IGltcGxlbWVudGF0aW9uLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KDQoNCg==
