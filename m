Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092A39BE9B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 19:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhFDR0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 13:26:51 -0400
Received: from mail-co1nam11on2094.outbound.protection.outlook.com ([40.107.220.94]:7392
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230185AbhFDR0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 13:26:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMTpaCdVywW0TRbMvPSjn1E4WAajftX3lfilCHAoct7YPCNjtJsV4Wj3K9ZWKz4zHgAnISudTlOaWQ5cKaooXIxvhrjnVRKwPTHyGGwDSDGlLPHomvUJ6cP3TCZvPlndjrHeqq24FOYG5xoB4KvnwGThDxsDZ+BTwQizWy4eL0IolR6YeLr9W6hxkmUun9e1X33RESR6bkjwVhrlLwNUy/5WEKN71tcXhhMxhNaApBh1XoiCfbdgg7HBWmWtTYZGh7+qAnNXFVXfhmDxmDrGaAhFo+D7Bi9s8uyfnuhWwT8A2Ijnkfte1lj62dG6rMx8wJvCH5YlMRX1zXQ0ZoHmSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIKhgZluge1l1sgHWG7Svk4kYVFs0nLRlwd7mY1e7og=;
 b=DydL2tr335CusvBObgFDWgcmMLO4c0xGJzh6T+Y36ri2ESQFhjTnE8WC7OVaFHuBHBiljY1tn6kkMfpSo6T8dABxaTWiq0cytYvkdvsg0oxKcIfVray6Utv12IHlUPrNyyHwi0uq2Rqejt8mgCBWM38Xyy53pDWjkeSOocXAdhoGARQqmxDoERFbi8BqIxc9hiAJH9w40fOEZ4/Mi2j2gRnw+fotXUjIu8Z5TxW/Uvu5s9qj0reMMy5NvAUHWmxUW3CtdWp9McHD4sVeYkeU/TuPx3B4AKS2MSM6ov9Kowt2eR0+ArZAiN0jFP4P8Q3NanDDiRYybCH2iWQPgfUARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIKhgZluge1l1sgHWG7Svk4kYVFs0nLRlwd7mY1e7og=;
 b=IG3gkjnj4QWkGbNTFQCFBQAHo0Kxrpz1qYRpoEHf6C0NLkSAPQ6+V9+H+cW/quYbvGlecjhwzNJ4dER0/M+/GP7dZvwpG51/Kou8iP4FCROo6dZWsX0jcsvJllUGlabKczS2Woy/beU5GzW+6+O3E90uCd9wChSzP83Bat4J9kg=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW2PR2101MB0970.namprd21.prod.outlook.com
 (2603:10b6:302:4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.4; Fri, 4 Jun
 2021 17:25:02 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::7d51:65ac:f054:59c4]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::7d51:65ac:f054:59c4%7]) with mapi id 15.20.4219.014; Fri, 4 Jun 2021
 17:25:02 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Leonid Bloch <leonidb@asocscloud.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Long Li <longli@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
Thread-Topic: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
Thread-Index: AQHXWHTXyjSAvRmnA0a6WpgCISs5dqsCkHcggADx1wCAAJebQA==
Date:   Fri, 4 Jun 2021 17:25:02 +0000
Message-ID: <MW2PR2101MB0892CA70C86DC73A30751404BF3B9@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <54fb17e8-6a0c-ab56-8570-93cc8d11b160@asocscloud.com>
 <SN6PR2101MB089485D8C070855CD43C1961BF3C9@SN6PR2101MB0894.namprd21.prod.outlook.com>
 <d13d685a-ae48-b747-7ecf-357b91c275b2@asocscloud.com>
In-Reply-To: <d13d685a-ae48-b747-7ecf-357b91c275b2@asocscloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=390ee957-323d-43fc-b634-729195822c15;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-04T17:16:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: asocscloud.com; dkim=none (message not signed)
 header.d=none;asocscloud.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:7151:7539:d190:d1d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8953040f-388f-448a-faa0-08d9277db013
x-ms-traffictypediagnostic: MW2PR2101MB0970:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB0970FD4186F4EF9B3CCF9808BF3B9@MW2PR2101MB0970.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPc0vv4JgoOgi19Y9kelgiovJ66uTVtk7w7ve1GitvnAUDJRUPtMVZnGrGjBRmKO5jy5BwtLcPcewYJPzuPqoyWwoDMboC4G86yhMTifog0qGycqPJgSoE8K0S26Ebjn8tSqZ/yjlwiBgcLHr8GTZTxddJUxBw+B0qJld+I8rVEl/ddEzwE2b19/CqTziFHlPszZfaIL4ciPE6JxqgC5LAUZY/bXVQzFMP3/NZtJ2zIrcagw+s2Z7mx9/8j6jqdaOCkjlzTvuJ/hIe3rGOMDl6CdkEJECvxxHGEHt6lSKxR0XfkU5pZmZaFVyfexUPqfhLb5GN1+u8Qqr5Jlw0oEE9vfLTHk2Upc+OXhhGFGA8TzQD2TmrLh3obMivVdaEV86UQfA8N2XhDvhYvU5zdqyTAOOJdm0xv9FcLjzTOEa7XSdkibUByH584dNs4sfxjnczTl04ehYKRJ2Kx0oc71u5f1Ktk302URRzDWKDmHTrj66hyHT3FYm6cixj9ljAzBQE/tZBcf1W3SAbePGbl5XwYF3ZlduJ5noW90gZ7uP4mLJAAKmVUSMMRs+RVio8TpJdgDoye0hx8GUSgU/BjcNdxJiOBYcs8jayLCC3W8IQUVi5zGP7ZzdCytM2JPMv594wT/swkH+oQvesY3z+zDew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(86362001)(71200400001)(316002)(10290500003)(110136005)(4326008)(54906003)(8936002)(55016002)(478600001)(5660300002)(6506007)(82960400001)(76116006)(6636002)(33656002)(8676002)(9686003)(82950400001)(52536014)(2906002)(8990500004)(66946007)(64756008)(66446008)(186003)(38100700002)(53546011)(122000001)(66476007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUlNQXFLZUJKc2o3SW1JMW1QdE9DMXVFS2dnSmdkbFI0dnpaZno1TFJ5RXkz?=
 =?utf-8?B?RkdNd0dqU2lUUG8rd3d1ZTlOeFFjMWtyRU1GWnZ1VlBROTE4di9vWjRIS3Vt?=
 =?utf-8?B?OGxRaVhNcEZGcG9QSFYxdUMyTjBTSGlZRzFnaXB2ZzVPZjkvZ1lLQ1dPaDdZ?=
 =?utf-8?B?OXhHNjJBS21CZTFjSXJNZFdBYy9NUEhuSG5GZ05tTkQvRUlSdWJ3S2g3Qmhv?=
 =?utf-8?B?eDhLditoa3ZHWVlJWmtyalBLTG12aGErZWRVZlRBTFpGTmMvYUpwR2Voenps?=
 =?utf-8?B?WWVTNnl5dW92cnFZZWRlaWFPLzB5UlIwWDZPdlEzWHBLN1dEY2hIY1pYVXF3?=
 =?utf-8?B?ZEtZS29YN05TNUZXREJ5dDZvK1VzaW55K0lYUEN6blhPMlI5dUd2SExlRlBv?=
 =?utf-8?B?bTdRRjBIVzFNa0ZXTVA2azM5bmRMMmFrVkdYa1VIajNuTDJMT21ReGNUU0E2?=
 =?utf-8?B?QUZDS1M0Z3g3cEdYL1AvTElSQnNwNlhGa1EyY2RWUkFpeVJwK3E5dWFCeXRP?=
 =?utf-8?B?TjkxNi9kY2U2OXdTMnBabXJKNkpmREhVdC9peG9sSmxUdmpmZVIwRW5PUHY1?=
 =?utf-8?B?UFJTNmJ2OXgzOG5ZQU5tS01YazNiRFd2dUU0R1o0UEE2VmlxWWVjT216cDhW?=
 =?utf-8?B?SVcya1g4dUdITnlkRlJOOG13Vm1KRnZhd3NDeU9WMFJaNXptNGlaMWJwZmNs?=
 =?utf-8?B?Y3N6cGhmZXBlVE9yTk1PT1EyRzRBOC8xWStGVXJnYVp2Y2FXZ3NDbDk0dWN4?=
 =?utf-8?B?Y04yY3BnSnFHcGJDNzBJNHlqQ0pVV0xEaHZ6ZnB0eDJXMnNzZG44c3c0aGky?=
 =?utf-8?B?T2VkU0k4aEcvaWthdTFTaXdxRVZkd3R4SC9HMUNQREdEcDZCR29xTFFxSER2?=
 =?utf-8?B?WFM2dWg1WVFnaUhqVHorQWFNTjkxN3BRemZSYjB6UlhkNWdIM2h5cWpLeFRy?=
 =?utf-8?B?cmRwMTI4ZWgvREtOTG9Zb0RLb3A3ZkFWejdNZDY0L3d5ekR1OGRTTm1iSEJr?=
 =?utf-8?B?dnNrU2RWdnVhY2lvcVdXNzFxQkZMQUZCVU1FZVJqOXBDZDIzTXJTc2ZJZ0Jj?=
 =?utf-8?B?WUVVdXJTdWZuSDNsRU54K2JrL1pSSUE2S0ZFekJYSnNGOGw2N0x3SXh6RDkr?=
 =?utf-8?B?dHRnK2tVK0xPLzYyNjgzTWxEendiZ1RCZVU0a05UY0NhaTVNVEtKMU9TMGh2?=
 =?utf-8?B?ZkM3NHhvbjA3TnJFaTRlYm9rWFV0Ry9vRGs3VnZZVnF3WDNheVB1OGV2YkxK?=
 =?utf-8?B?TE1TV01WcC9vbzc3N0ZKUFVqeVk4RXkxNmIwZlB1MlRjd0RMUnkrcWZza3Ax?=
 =?utf-8?B?elhiYmtyRHF4OGoveFhZekxmWXo1Ylh1RmYyMjBJS25RZVJjU2htcm1WVE1F?=
 =?utf-8?B?dXQvcElDOTRGeS9nUXZ1UzZpL1FvUW82MTVYL2F0Zjl6RklJYmpMdHRqL2tk?=
 =?utf-8?B?bW1FY1N0eDNuNVZMVFc3VkRmSTJzcUhJRmwyT2hHVG5MeXU3YTFWWGJVM1Z2?=
 =?utf-8?B?L0hISG9HTlZkYUl1WWM2SlRXZnE2QUlDYVpMTG8zU2UyWVM2eGJ0YVZScE10?=
 =?utf-8?B?czJRa0pvYkUrTXo2ZW9GdEFSQzZ4a01vSjNYQnZuOGRuMGxYZFh0ZURPQ2JY?=
 =?utf-8?B?T09mbWNlNkJ3N0U0QW9JdUl4Vm5jbXJ3TlhnU2ppR055KzZPRkRqa2xpVG1I?=
 =?utf-8?B?NlFzV3o3aXI4cUpudmlIN1cxeW9OalNHWk1SelIwZTVaNUNOck1rWG5rcGtR?=
 =?utf-8?B?cnJWcFp3Um9LNkttSFRzTDc3STdESnkycnMwZHF1ZDU4eHNBbUxiNkFYb1RK?=
 =?utf-8?B?eXo2SHlZTS82TkZ5dE1oamhkM2FhenI5OXVZTkRaZTlMWlVmeGwxdVloSDFN?=
 =?utf-8?Q?16xm/FgJ+2lLS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8953040f-388f-448a-faa0-08d9277db013
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 17:25:02.6941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nWzBbk79AQJo25/ALuYDKhTB/w8ua6xKKy/5vtYEkHUrLmpYXPuIrfIb4osqg95kYHEZdBNmKJSMsEw89WBo2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0970
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBMZW9uaWQgQmxvY2ggPGxlb25pZGJAYXNvY3NjbG91ZC5jb20+DQo+IFNlbnQ6IEZy
aWRheSwgSnVuZSA0LCAyMDIxIDE6MTQgQU0NCj4gVG86IERleHVhbiBDdWkgPGRlY3VpQG1pY3Jv
c29mdC5jb20+OyBLWSBTcmluaXZhc2FuIDxreXNAbWljcm9zb2Z0LmNvbT47DQo+IEhhaXlhbmcg
WmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBTdGVwaGVuIEhlbW1pbmdlcg0KPiA8c3Ro
ZW1taW5AbWljcm9zb2Z0LmNvbT47IFdlaSBMaXUgPHdlaS5saXVAa2VybmVsLm9yZz47IExvbmcg
TGkNCj4gPGxvbmdsaUBtaWNyb3NvZnQuY29tPg0KPiBDYzogbGludXgtaHlwZXJ2QHZnZXIua2Vy
bmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW0JVR10gaHZf
bmV0dnNjOiBVbmJpbmQgZXhpdHMgYmVmb3JlIHRoZSBWRnMgYm91bmQgdG8gaXQgYXJlDQo+IHVu
cmVnaXN0ZXJlZA0KPiANCj4gT24gNi8zLzIxIDk6MDQgUE0sIERleHVhbiBDdWkgd3JvdGU6DQo+
ID4+IEZyb206IExlb25pZCBCbG9jaCA8bGVvbmlkYkBhc29jc2Nsb3VkLmNvbT4NCj4gPj4gU2Vu
dDogVGh1cnNkYXksIEp1bmUgMywgMjAyMSA1OjM1IEFNDQo+ID4+IFRvOiBLWSBTcmluaXZhc2Fu
IDxreXNAbWljcm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcNCj4gPj4gPGhhaXlhbmd6QG1pY3Jv
c29mdC5jb20+OyBTdGVwaGVuIEhlbW1pbmdlcg0KPiA+PiA8c3RoZW1taW5AbWljcm9zb2Z0LmNv
bT47IFdlaSBMaXUgPHdlaS5saXVAa2VybmVsLm9yZz47IERleHVhbiBDdWkNCj4gPj4gPGRlY3Vp
QG1pY3Jvc29mdC5jb20+DQo+ID4+IENjOiBsaW51eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFtCVUddIGh2X25ldHZzYzogVW5i
aW5kIGV4aXRzIGJlZm9yZSB0aGUgVkZzIGJvdW5kIHRvIGl0IGFyZQ0KPiA+PiB1bnJlZ2lzdGVy
ZWQNCj4gPj4NCj4gPj4gSGksDQo+ID4+DQo+ID4+IFdoZW4gSSB0cnkgdG8gdW5iaW5kIGEgbmV0
d29yayBpbnRlcmZhY2UgZnJvbSBodl9uZXR2c2MgYW5kIGJpbmQgaXQgdG8NCj4gPj4gdWlvX2h2
X2dlbmVyaWMsIG9uY2UgaW4gYSB3aGlsZSBJIGdldCB0aGUgZm9sbG93aW5nIGtlcm5lbCBwYW5p
YyAocGxlYXNlDQo+ID4+IG5vdGUgdGhlIGZpcnN0IHR3byBsaW5lczogaXQgc2VlbXMgYXMgdWlv
X2h2X2dlbmVyaWMgaXMgcmVnaXN0ZXJlZA0KPiA+PiBiZWZvcmUgdGhlIFZGIGJvdW5kIHRvIGh2
X25ldHZzYyBpcyB1bnJlZ2lzdGVyZWQpOg0KPiA+Pg0KPiA+PiBbSnVuIDMgMDk6MDRdIGh2X3Zt
YnVzOiByZWdpc3RlcmluZyBkcml2ZXIgdWlvX2h2X2dlbmVyaWMNCj4gPj4gWyAgKzAuMDAyMjE1
XSBodl9uZXR2c2MgNWUwODkzNDItOGE3OC00Yjc2LTk3MjktMjVjODFiZDMzOGZjIGV0aDI6DQo+
IFZGDQo+ID4+IHVucmVnaXN0ZXJpbmc6IGV0aDUNCj4gPj4gWyAgKzEuMDg4MDc4XSBCVUc6IHNj
aGVkdWxpbmcgd2hpbGUgYXRvbWljOiBzd2FwcGVyLzgvMC8weDAwMDEwMDAzDQo+ID4+IFsgICsw
LjAwMDAwMV0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogc3dhcHBlci8zLzAvMHgwMDAx
MDAwMw0KPiA+PiBbICArMC4wMDAwMDFdIEJVRzogc2NoZWR1bGluZyB3aGlsZSBhdG9taWM6IHN3
YXBwZXIvNi8wLzB4MDAwMTAwMDMNCj4gPj4gWyAgKzAuMDAwMDAwXSBCVUc6IHNjaGVkdWxpbmcg
d2hpbGUgYXRvbWljOiBzd2FwcGVyLzcvMC8weDAwMDEwMDAzDQo+ID4+IFsgICswLjAwMDAwNV0g
TW9kdWxlcyBsaW5rZWQgaW46DQo+ID4+IFsgICswLjAwMDAwMV0gTW9kdWxlcyBsaW5rZWQgaW46
DQo+ID4+IFsgICswLjAwMDAwMV0gIHVpb19odl9nZW5lcmljDQo+ID4+IFsgICswLjAwMDAwMF0g
TW9kdWxlcyBsaW5rZWQgaW46DQo+ID4+IFsgICswLjAwMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46
DQo+ID4+IFsgICswLjAwMDAwMV0gIHVpb19odl9nZW5lcmljIHVpbw0KPiA+PiBbICArMC4wMDAw
MDFdICB1aW8NCj4gPj4gWyAgKzAuMDAwMDAwXSAgdWlvX2h2X2dlbmVyaWMNCj4gPj4gWyAgKzAu
MDAwMDAwXSAgdWlvX2h2X2dlbmVyaWMNCj4gPj4gLi4uDQo+ID4+DQo+ID4+IEkgcnVuIGtlcm5l
bCA1LjEwLjI3LCB1bm1vZGlmaWVkLCBiZXNpZGVzIFJUIHBhdGNoIHYzNiwgb24gQXp1cmUgU3Rh
Y2sNCj4gPj4gRWRnZSBwbGF0Zm9ybSwgc29mdHdhcmUgdmVyc2lvbiAyMTA1ICgyLjIuMTYwNi4z
MzIwKS4NCj4gPj4NCj4gPj4gSSBwZXJmb3JtIHRoZSBiaW5kLXVuYmluZCB1c2luZyB0aGUgZm9s
bG93aW5nIHNjcmlwdCAocGxlYXNlIG5vdGUgdGhlDQo+ID4+IGNvbW1lbnQgaW5saW5lKToNCj4g
Pj4NCj4gPj4gbmV0X3V1aWQ9ImY4NjE1MTYzLWRmM2UtNDZjNS05MTNmLWYyZDJmOTY1ZWQwZSIN
Cj4gPj4gZGV2X3V1aWQ9IiQoYmFzZW5hbWUgIiQocmVhZGxpbmsgIi9zeXMvY2xhc3MvbmV0L2V0
aDEvZGV2aWNlIikiKSINCj4gPj4gbW9kcHJvYmUgdWlvX2h2X2dlbmVyaWMNCj4gPj4gZWNobyAi
JHtuZXRfdXVpZH0iID4gL3N5cy9idXMvdm1idXMvZHJpdmVycy91aW9faHZfZ2VuZXJpYy9uZXdf
aWQNCj4gPj4gcHJpbnRmICIlcyIgIiR7ZGV2X3V1aWR9IiA+IC9zeXMvYnVzL3ZtYnVzL2RyaXZl
cnMvaHZfbmV0dnNjL3VuYmluZA0KPiA+PiAjIyMgSWYgSSBpbnNlcnQgJ3NsZWVwIDEnIGhlcmUg
LSBhbGwgd29ya3MgY29ycmVjdGx5DQo+ID4+IHByaW50ZiAiJXMiICIke2Rldl91dWlkfSIgPiAv
c3lzL2J1cy92bWJ1cy9kcml2ZXJzL3Vpb19odl9nZW5lcmljL2JpbmQNCj4gPj4NCj4gPj4NCj4g
Pj4gVGhhbmtzLA0KPiA+PiBMZW9uaWQuDQo+ID4NCj4gPiBJdCB3b3VsZCBiZSBncmVhdCBpZiB5
b3UgY2FuIHRlc3QgdGhlIG1haW5saW5lIGtlcm5lbCwgd2hpY2ggSSBzdXNwZWN0IGFsc28NCj4g
PiBoYXMgdGhlIGJ1Zy4NCj4gPg0KPiA+IEl0IGxvb2tzIGxpa2UgbmV0dnNjX3JlbW92ZSgpIC0+
IG5ldHZzY191bnJlZ2lzdGVyX3ZmKCkgZG9lcyB0aGUgdW5iaW5kaW5nDQo+IHdvcmsNCj4gPiBp
biBhIHN5bmNocm9ub3VzIG1hbm50ZXIuIEkgZG9uJ3Qga25vdyB3aHkgdGhlIGJ1ZyBoYXBwZW5z
Lg0KPiA+DQo+ID4gUmlnaHQgbm93IEkgZG9uJ3QgaGF2ZSBhIERQREsgc2V0dXAgdG8gdGVzdCB0
aGlzLCBidXQgSSB0aGluayB0aGUgYnVnIGNhbg0KPiA+IGJlIHdvcmtlZCBhcm91bmQgYnkgdW5i
aW5kaW5nIHRoZSBQQ0kgVkYgZGV2aWNlIGZyb20gdGhlIHBjaS1oeXBlcnYgZHJpdmVyDQo+ID4g
YmVmb3JlIHVuYmluZGluZyB0aGUgbmV0dnNjIGRldmljZSwgYW5kIHJlLWJpbmRpbmcgdGhlIFZG
IGRldmljZSBhZnRlcg0KPiBiaW5kaW5nDQo+ID4gdGhlIG5ldHZzYyBkZXZpY2UgdG8gdWlvX2h2
X2dlbmVyaWMuDQo+ID4NCj4gPiBUaGFua3MsDQo+ID4gLS0gRGV4dWFuDQo+ID4NCj4gDQo+IEhp
IERleHVhbiwNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciByZXBseS4gSSBjYW4gY2hlY2sgZm9yIG15
c2VsZiBvbmx5IG5leHQgd2VlaywgYXMgSSBhbQ0KPiBvdXQgb2Ygb2ZmaWNlIG5vdywgYnV0IGRv
IHlvdSB0aGluayB0aGF0IHRoZSByZWFzb24gbWlnaHQgYmUgdXNpbmcNCj4gY2FuY2VsX2RlbGF5
ZWRfd29ya19zeW5jKCksIGluc3RlYWQgb2YgY2FuY2VsX2RlbGF5ZWRfd29yaygpIGluDQo+IG5l
dHZzY191bnJlZ2lzdGVyX3ZmKCk/DQoNCkknbSBub3Qgc3VyZS4gSSBkb24ndCB1bmRlcnN0YW5k
IGhvdyB0aGUgZXJyb3IgaGFwcGVuczoNClsgICsxLjA4ODA3OF0gQlVHOiBzY2hlZHVsaW5nIHdo
aWxlIGF0b21pYzogc3dhcHBlci84LzAvMHgwMDAxMDAwMw0KIA0KPiBBbmQgaWYgdGhlIGFib3Zl
IGlzIG5vdCBjb3JyZWN0LCBjYW4geW91IHBsZWFzZSBhZHZpc2Ugb24gYSB3YXkgb2YNCj4gZmlu
ZGluZyB0aGUgY29ycmVzcG9uZGluZyBWRiBkZXZpY2UgZnJvbSB1c2Vyc3BhY2UsIGdpdmVuIHRo
ZSBrZXJuZWwNCj4gbmFtZSBvZiB0aGUgcGFyZW50IGRldmljZT8gSSBkaWQgbm90IGZpbmQgaXQg
aW4gc3lzZnMgc28gZmFyLg0KPiANCj4gVGhhbmtzLA0KPiBMZW9uaWQuDQoNClRoZSBWRiBOSUMg
aW50ZXJmYWNlJ3MgTUFDIGFkZHJlc3MgaXMgdGhlIHNhbWUgYXMgdGhlIHRoYXQgb2YgdGhlIG1h
dGNoaW5nIA0KbmV0dnNjIE5JQy4gV2Ugc2hvdWxkIGJlIGFibGUgdG8gZmluZCB0aGUgPG5ldHZz
YyBOSUMsIFZGIE5JQz4gcGFpciBieQ0KY2hlY2tpbmcgL3N5cy9jbGFzcy9uZXQvKi9hZGRyZXNz
Lg0KDQo=
