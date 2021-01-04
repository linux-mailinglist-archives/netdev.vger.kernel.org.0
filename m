Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971BC2E90EE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 08:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbhADHZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 02:25:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7872 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbhADHZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 02:25:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff2c2a90000>; Sun, 03 Jan 2021 23:24:25 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 07:24:25 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 4 Jan 2021 07:24:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDnkBs22mqiAMG3RKc6BCemjH4PZAamP7jkJ8Yc7rgruAMBkA85lSTDUpp5h9ypvEH2tAY76qoFy/GNPFChta74E45DyqYxq/ZGOpaaynPU6IdBygKgjpgtS5lEzRGcBPdZM7/q4Ai85TV6+Q2/O92DaDuqKi3vpO4PTxaNz3Fh1mjMgadBwI6yo3lz37EBqHFoAXmnRLG2PUA03Gf+z4oPr7MwlBbGT7789ShgODDeIxIPnrr15THjv8OSaoIQi8FWi1ezbeoNI3uNGn/NwE26VFUsFa2Q642Qni2Hi03DaxoADMrs/Jg/Ns/xPf/OH/SMpc7qaprV9n7ujDEYHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Io40VfempQ9GE9px41C5oCUiHOZkR4354vo5YDga4Hk=;
 b=Fq8baza6Wj9/yFAxEY/LOIKY+1PoMhVZOwc6oLXQh3uNr41bJlcBqlmeR576NXaAgZQMN2JLp4p0UhU2ekbAiK0UDkIkQQYPBnTesdk7SuGUfUn3YHlY+IpeZ1chuciyz+AwZCsrMnwonuj2Ly/xgk/GY9KR6WpUiyZCY8qbKD/gySkxJoG6jFZbX2IvK9j604JT4OP2BsE89fc1AKh/MxLMgPdjQIffGFzflMiE+FqfySNJjhY6AoTSchJpmF9zMzXLWwe59gc1WXqw5YgSoeqllFbyrHW+hAn//j/3Ng0MS8tWDUa4qeJNRmJ8qaN8GLt8BB/W183eH4kuUEXtJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3908.namprd12.prod.outlook.com (2603:10b6:a03:1ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 07:24:23 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 07:24:23 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
Thread-Topic: [PATCH linux-next v2 4/7] vdpa: Define vdpa mgmt device, ops and
 a netlink interface
Thread-Index: AQHW4ko6qlHRm93SwkGgKhE4ETo8PaoXCs2AgAAFMiA=
Date:   Mon, 4 Jan 2021 07:24:23 +0000
Message-ID: <BY5PR12MB432236DE09EBC2E584C07FCDDCD20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-5-parav@nvidia.com>
 <b08ede5d-e393-b4f8-d1d8-2aa29e409872@redhat.com>
In-Reply-To: <b08ede5d-e393-b4f8-d1d8-2aa29e409872@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.203.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df02a612-d694-44e4-a825-08d8b081c2db
x-ms-traffictypediagnostic: BY5PR12MB3908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3908431B7A5464B963FF24D7DCD20@BY5PR12MB3908.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qIp8eQ6BtO8PYKhh4JJ12kdhMtDeJ5FMrhWObKF9FIwLeYzqlxV8hhKyTigddgxvyGaCtei/cdRtRYT3XtMZrDinto2lg+6r2Acb6Acy6jI9VQr5mh/Wf1hhflcs+ORamPzKrH4rlaHEvQCwcOiWPKiJEfkGW6SXoCxDHjKrh7Lz4m02l0F92WudfZ9TRLyjgyhriggalOe3pcmGsGHdeQxi5kPoHNXttJgVZ7gafmuxiYA9mWhJrprTQGIB2gsw2d2MfQmCiZzjFxC4LXaLCRVpgPJlAm6oQDChCS1ZNQDVaBBKVIDgcjEQoY0aIi2tMrXbjbHU2TppUOVT+y9+qIfGTxC8YPlmCMIAiS8rgJ1x0FIzlHGO5XdR+GAowDwzpRpZE5Gw5tgqzjh40OG9oA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(8936002)(7696005)(4326008)(478600001)(33656002)(186003)(6506007)(55236004)(66446008)(64756008)(66476007)(66556008)(26005)(52536014)(8676002)(2906002)(83380400001)(76116006)(71200400001)(110136005)(66946007)(55016002)(9686003)(86362001)(316002)(5660300002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?clVpaXlXM0RySU5CdERmK1ByTVkzRVF0SFduczMxMWlnb2hXOG1OaTJWNGQw?=
 =?utf-8?B?UU8yOVJnQlY2VUtSU1hicmRVVnkxOUlzU1NaMHdMWXl5dHV2djB5cmtrd2ds?=
 =?utf-8?B?eEJvbDZpM1Z5dDFyanNPSmMvb21DQWJDWVdGdktMbEsxbHVUZ0psdXVjR0dQ?=
 =?utf-8?B?Rk84b0RKVGpINDBReHlHdTBvRFkvanZWTE1JbEwxZm9WU3F5aG9QSU5zL3Jx?=
 =?utf-8?B?NWhaeTBxeUpjZERkVkJXYjhUYUJMM2pWNFdlUUVwa1lCcGoyWVR0WFRvODM0?=
 =?utf-8?B?UnlRTTdzekwveUROZjNWdmFSdHlzVm9wMVNyRElwZjE5ZXREek9KNlorRUhs?=
 =?utf-8?B?dUFzMUI1RGhRRFZuY1lpM1FzQndJVjBWZjZkQ0FqczlBMHZZb25NNDdWNEtK?=
 =?utf-8?B?eEVTOGxTTktsSlovRTJDaVpzN3FFbnZKa2pEbnhxRmhsblhlWW1OQ1FSbi84?=
 =?utf-8?B?VlV5TFlaL0JIbktrTit3Y3ZlTGZDblk4RFptbENTU3BpQnE2enlEeHZnWUFN?=
 =?utf-8?B?UGFVazZuK2tyT2hudjRvTWVMblRvdlpFeWIvMEluUFMwd1VtWUhpOUpYQUJC?=
 =?utf-8?B?a2dwVCtlUEdWWjUyc044TG90OGhHbzdwMzZCd2VnMi93V1JIVFdhVDNiQ0J1?=
 =?utf-8?B?d0pCOFlyYmZoVXdocDQxVmlBcm1kaWpTUTRsT3FXVTFha2RTdjJyc25sdnhq?=
 =?utf-8?B?SHhKckU0bUtIZkt0djFsdDE2WDB1SjExVG56WG9FSXhTeE92N21PNjlGWjgw?=
 =?utf-8?B?RHdveEhxc0FSOGJsZ0JvS0MxN2p2LzQvNjY0L012NE5MVWVZaFFXNWFqYldO?=
 =?utf-8?B?T2E4d0loK3pMdEljQjY5R2pYcDBZNXp2NVBRS0dsVnpRY1lKdm5OQXkwbjNi?=
 =?utf-8?B?ZjdLZ3ZwMFBQOTU1U2JkMkh0T3c3dnNrdDh6bzNkakpMcGRvLytQYWNtMFhB?=
 =?utf-8?B?eVVJZlRzWlZnSU01NlBsQi96VXVhdTVFL1pjY0xEUTc2N3pWdG45My91YkMv?=
 =?utf-8?B?QjlTMW55TU9zRU9rSDVzMjQ2MEVNR3VHc3RFcjdQdnhDa1dibWdWWDNJZTVX?=
 =?utf-8?B?VTVsVW14UzVrRVNqMTFhaVFLRDNkMXZDM2c0NXNRSHR2cjVNM3gwL2NxVk9X?=
 =?utf-8?B?NHI5anNOWWtDMVR0em5FSjFGWW4zVHJkWVVwK1JHUWtPT0thTmdFRWxtL20x?=
 =?utf-8?B?alJ1MXpxV1V0TUFnVWJ5Q2svdjU3eGIzNEJINUZyV1ZLOVl0WUt5N3JLdExG?=
 =?utf-8?B?SWdueXVIMkpudDV1RWExc0NzRmlOUkNWSHc2M0JySkVEK1lqVFMyMXZxNzRI?=
 =?utf-8?Q?v49/GxUpNZ5VI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df02a612-d694-44e4-a825-08d8b081c2db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 07:24:23.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypB+vhl83lpZgVHnM7mN1E/88XPwM3vzqAVcegOfwWIRi3eN7X6WGvYhwY2ob51Vb/gQuTQthuxxf6o5s1SUmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3908
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609745065; bh=Io40VfempQ9GE9px41C5oCUiHOZkR4354vo5YDga4Hk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ETwSX6ESZnCQjdYNGBqQ7bUjvoYgnzZZrwjztBbRfkgnSeNbhhsbs9TEA79EZVghK
         msbIX/EefO0FBnWRCP647X9pFzSZ9HjTQixgM/Zz/z0CGQyL6Xf3PbXPThybXPf0Nx
         isEt7ntZLtLAxlDNXu8M+GbyqcvmhEJSozojwA9cpdv+Z2dVAIhtlgcmyzqK4bS+yt
         26WmmWQ32qF+yBHy3GVYjjsCcQrFe4mtwNucEPD8qDWn3LOXz8c09Fus1yys9RrkfR
         NumHD8tL4a2ZBije3oTXE3LULwS3KKTrw1KoujXir0IWOjaCU+jOWBtWGdk7Jzed4l
         +MT6BnzFehnvQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogTW9u
ZGF5LCBKYW51YXJ5IDQsIDIwMjEgMTI6MzMgUE0NCj4gDQo+IE9uIDIwMjEvMS80IOS4iuWNiDEx
OjMxLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gVG8gYWRkIG9uZSBvciBtb3JlIFZEUEEgZGV2
aWNlcywgZGVmaW5lIGEgbWFuYWdlbWVudCBkZXZpY2Ugd2hpY2gNCj4gPiBhbGxvd3MgYWRkaW5n
IG9yIHJlbW92aW5nIHZkcGEgZGV2aWNlLiBBIG1hbmFnZW1lbnQgZGV2aWNlIGRlZmluZXMgc2V0
DQo+ID4gb2YgY2FsbGJhY2tzIHRvIG1hbmFnZSB2ZHBhIGRldmljZXMuDQo+ID4NCj4gPiBUbyBi
ZWdpbiB3aXRoLCBpdCBkZWZpbmVzIGFkZCBhbmQgcmVtb3ZlIGNhbGxiYWNrcyB0aHJvdWdoIHdo
aWNoIGENCj4gPiB1c2VyIGRlZmluZWQgdmRwYSBkZXZpY2UgY2FuIGJlIGFkZGVkIG9yIHJlbW92
ZWQuDQo+ID4NCj4gPiBBIHVuaXF1ZSBtYW5hZ2VtZW50IGRldmljZSBpcyBpZGVudGlmaWVkIGJ5
IGl0cyB1bmlxdWUgaGFuZGxlDQo+ID4gaWRlbnRpZmllZCBieSBtYW5hZ2VtZW50IGRldmljZSBu
YW1lIGFuZCBvcHRpb25hbGx5IHRoZSBidXMgbmFtZS4NCj4gPg0KPiA+IEhlbmNlLCBpbnRyb2R1
Y2Ugcm91dGluZSB0aHJvdWdoIHdoaWNoIGRyaXZlciBjYW4gcmVnaXN0ZXIgYQ0KPiA+IG1hbmFn
ZW1lbnQgZGV2aWNlIGFuZCBpdHMgY2FsbGJhY2sgb3BlcmF0aW9ucyBmb3IgYWRkaW5nIGFuZCBy
ZW1vdmUgYQ0KPiA+IHZkcGEgZGV2aWNlLg0KPiA+DQo+ID4gSW50cm9kdWNlIHZkcGEgbmV0bGlu
ayBzb2NrZXQgZmFtaWx5IHNvIHRoYXQgdXNlciBjYW4gcXVlcnkgbWFuYWdlbWVudA0KPiA+IGRl
dmljZSBhbmQgaXRzIGF0dHJpYnV0ZXMuDQo+ID4NCj4gPiBFeGFtcGxlIG9mIHNob3cgdmRwYSBt
YW5hZ2VtZW50IGRldmljZSB3aGljaCBhbGxvd3MgY3JlYXRpbmcgdmRwYQ0KPiA+IGRldmljZSBv
ZiBuZXR3b3JraW5nIGNsYXNzIChkZXZpY2UgaWQgPSAweDEpIG9mIHZpcnRpbyBzcGVjaWZpY2F0
aW9uDQo+ID4gMS4xIHNlY3Rpb24gNS4xLjEuDQo+ID4NCj4gPiAkIHZkcGEgbWdtdGRldiBzaG93
DQo+ID4gdmRwYXNpbV9uZXQ6DQo+ID4gICAgc3VwcG9ydGVkX2NsYXNzZXM6DQo+ID4gICAgICBu
ZXQNCj4gPg0KPiA+IEV4YW1wbGUgb2Ygc2hvd2luZyB2ZHBhIG1hbmFnZW1lbnQgZGV2aWNlIGlu
IEpTT04gZm9ybWF0Lg0KPiA+DQo+ID4gJCB2ZHBhIG1nbXRkZXYgc2hvdyAtanANCj4gPiB7DQo+
ID4gICAgICAic2hvdyI6IHsNCj4gPiAgICAgICAgICAidmRwYXNpbV9uZXQiOiB7DQo+ID4gICAg
ICAgICAgICAgICJzdXBwb3J0ZWRfY2xhc3NlcyI6IFsgIm5ldCIgXQ0KPiA+ICAgICAgICAgIH0N
Cj4gPiAgICAgIH0NCj4gPiB9DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQ8
cGFyYXZAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogRWxpIENvaGVuPGVsaWNAbnZpZGlh
LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSmFzb24gV2FuZzxqYXNvd2FuZ0ByZWRoYXQuY29tPg0K
PiA+IC0tLQ0KPiA+IENoYW5nZWxvZzoNCj4gPiB2MS0+djI6DQo+ID4gICAtIHJlYmFzZWQNCj4g
PiAgIC0gdXBkYXRlZCBjb21taXQgbG9nIGV4YW1wbGUgZm9yIG1hbmFnZW1lbnQgZGV2aWNlIG5h
bWUgZnJvbQ0KPiA+ICAgICAidmRwYXNpbSIgdG8gInZkcGFzaW1fbmV0Ig0KPiA+ICAgLSByZW1v
dmVkIGRldmljZV9pZCBhcyBuZXQgYW5kIGJsb2NrIG1hbmFnZW1lbnQgZGV2aWNlcyBhcmUNCj4g
PiBzZXBhcmF0ZWQNCj4gDQo+IA0KPiBTbyBJIHdvbmRlciB3aGV0aGVyIHRoZXJlIGNvdWxkIGJl
IGEgdHlwZSBvZiBtYW5hZ2VtZW50IGRldmljZXMgdGhhdCBjYW4NCj4gZGVhbCB3aXRoIG11bHRp
cGxlIHR5cGVzIG9mIHZpcnRpbyBkZXZpY2VzLiBJZiB5ZXMsIHdlIHByb2JhYmx5IG5lZWQgdG8g
YWRkDQo+IGRldmljZSBpZCBiYWNrLg0KQXQgdGhpcyBwb2ludCBtbHg1IHBsYW4gdG8gc3VwcG9y
dCBvbmx5IG5ldC4NCkl0IGlzIHVzZWZ1bCB0byBzZWUgd2hhdCB0eXBlIG9mIHZkcGEgZGV2aWNl
IGlzIHN1cHBvcnRlZCBieSBhIG1hbmFnZW1lbnQgZGV2aWNlLg0KDQpJbiBmdXR1cmUgaWYgYSBt
Z210IGRldiBzdXBwb3J0cyBtdWx0aXBsZSB0eXBlcywgdXNlciBuZWVkcyB0byBjaG9vc2UgZGVz
aXJlZCB0eXBlLg0KSSBndWVzcyB3ZSBjYW4gZGlmZmVyIHRoaXMgb3B0aW9uYWwgdHlwZSB0byBm
dXR1cmUsIHdoZW4gc3VjaCBtZ210LiBkZXZpY2Ugd2lsbC9tYXkgYmUgYXZhaWxhYmxlLg0K
