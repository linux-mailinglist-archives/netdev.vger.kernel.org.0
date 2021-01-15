Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605532F72DE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 07:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbhAOG2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 01:28:13 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:42935 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbhAOG2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 01:28:12 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600135d10000>; Fri, 15 Jan 2021 14:27:29 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 06:27:29 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 15 Jan 2021 06:27:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgWwxBJnNX4mSq66gF1n58mZlmJb/jEqw5lCOZTvKU3OHxGtLiI1JykXIR/MaoFhkRsV0bnpXM6WhCu8ACrPmRj7ALugrr5Jq3qDTThrzEkoAMcQdiWSKCbGNPt4CjUPYHq9Y7Y7cClhah/lE63n9RIXeTZ6c/wakeGJtoA/Jf8jzLoyoOBNJacm46uIUGlV/Qut0QUZRS0042NS3zu5xVUZJzp6wcZCXHeQpQZignCkFZMf73/OaFdKyB3OTiwb7xPIA3rH0tu/5jbBYaAUcgQfLFUXUyQcYCtmegBC/XCKKS5N6M6tC3iQrxixsbxQHwgSof+38ew/TGUpZT7bZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xG7S9gwh1xgZxOKbRYWozddJdL893StehW1mcgsxTc=;
 b=Wbjkx/AJCC1GrkY43jfSg+bVeocBbWpQswNXZvumYfY5vp+30+2vUNu/Uh1d/qaxBQdw8Sp7a5GJkGFtkGKdFUYph7BpDRtnXLEYfZV2AY20BT/hfe7UbI42UI0053FKzd0RuCcROXmQkoxGtrJZE5DAdyC3Vd/G5ViYuDUhx9DsCZdUMw47mnzz7YHinWi8t8hP7rJuHwGg4+v8SnmJoYbMdqb/sMvSLVxPnDmhc/o2YEnhQ+QPEH0AWQJH/P/1mH4mJkdxTSX1VhxRiy07W8rXu4gesHKz9MqU8OW/SWLdtWJvbXJO6ehlDKCOKS89PSgWhPcOD+jw738zkxvo7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 06:27:27 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 06:27:27 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Topic: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Thread-Index: AQHW404ZeuD1Nrf6EkKQQnhYNrY/9qoY6uQAgAAB4oCAAAVhgIAAAsjwgAAQXACAAoNJoIALCUSAgAAyM0CAAXa1gIAADQPg
Date:   Fri, 15 Jan 2021 06:27:26 +0000
Message-ID: <BY5PR12MB4322309C33E4871C11535F3CDCA70@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105082243-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322EC8D0AD648063C607E17DCAF0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
 <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
 <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
In-Reply-To: <01213588-d4af-820a-bcf8-c28b8a80c346@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8026958b-71c5-4c89-e7f3-08d8b91ea0c6
x-ms-traffictypediagnostic: BY5PR12MB4322:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4322E7DB140F783D18C60284DCA70@BY5PR12MB4322.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5aJORqpzDGIakbfqz8CGMYIrQaAqXP+yLtYBahosdwLsTlMFQxXI5g3mH+AtDGYQa/+wAmDi0pN4Rr74upj1C6bDdbMxNZK9nQCWrfVCv8N2+JUIf+NRyB66OeKbpO/A8aeQE2HUfWkvGyWTMT49O9aHgr07PD64Msj7njiSLGvBSOHNJJIxYCXYn+qJv20t5ggn+aYl10HMrkmIcRpzkNXTtejRrRTu+9hpgJyFL2L44zLmrvpy+g+ei1cIrzd70iWdF4lzU4ivX8PvVCwlyrw/ed/xTF13FVfJILMUUpkeY1MHWcJYutA0IohglJVyNH9X4bfdFmaMPuQA2248diPBPiTpufm2QZ68CL0BRPTzeHewtOHkNtUUuYN8MZJGvITETFNKomXC6xKWWKVE2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(9686003)(86362001)(52536014)(66446008)(7696005)(26005)(66556008)(33656002)(316002)(4326008)(66946007)(8936002)(2906002)(66476007)(71200400001)(6506007)(55016002)(76116006)(64756008)(54906003)(83380400001)(110136005)(478600001)(5660300002)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bVM2Tmw1MVFGTnJHZEtKaDBaWWNHM2wxV0U4N2U0cndZRmlyNFNUMDVMTklH?=
 =?utf-8?B?YWZSRStBeVdwMGFnQWJxSW9YV3hHSzNYdUZqREx6dUVTSXNEcjVQZGJ0K21j?=
 =?utf-8?B?SFJYd2E2dXBhY2Fkek9UMjZ5cVdkaUU0Q0tGeTBrWnQvZjRMOEFzR3FFMmRL?=
 =?utf-8?B?VWxtMzNwL3A3YVRueENnWHJYUGdCOUJ2VzdxT3pkaGpYd0FMd25lV1dyaVc2?=
 =?utf-8?B?TUJBSmk0SHpDTVJlb2RreDd3S2lIbXZzU2J0ZHA0ZmErREkyNk9IaVQ2Qm9C?=
 =?utf-8?B?cVlQb053bm5nc2lqV3RIS0VHK1pNL1pBNmhVVUdSei95cXRqMmVUMzNmUmF2?=
 =?utf-8?B?SkViZlJqS0ZqQWo4UU4zVnh3SWdSUU5sYmFzR0Q3UWpsNGZoTjJDQlJCMU53?=
 =?utf-8?B?bTJrMmRxY2xFSFF0NEUrZ0JhSWNuTkNhVyt4Ni9haHlhM3l1MHJWWnVBZ1gx?=
 =?utf-8?B?QzhmR0xTRGlGZVNuSG56YWNYbFBVTm9WMzZkRWpFY3FYaFgvWlczbUovL0c0?=
 =?utf-8?B?RU5uSnJjZ2hHTzJ1U2V0QVFkdzgxREQyZXBYUHdwVlJRVHpzTWM2VFdSLzRp?=
 =?utf-8?B?S3F0M1JNUnZjU3ZhbytNeFNXWGV2QktOZDRUOGZORTg0a05SeWUwT2hSWlQ1?=
 =?utf-8?B?c3RRTVdFd0NHbDlBdlcveXJHSEh1REFyMEZYTzJzYXpXTUx2bnY2RStyL2Fy?=
 =?utf-8?B?TnRpWUJmU1J4WHRZc2JRUjdrcHRGSERUVUdUR1BQT3B5OFk4bjNHcFk3ZHlD?=
 =?utf-8?B?VEdkNGZpVWJpbGdLOE1maFlreEFNVkt5NDFPMEgrTXRXUDdmKzBRVWhEU3pI?=
 =?utf-8?B?czBpb0l1VnBxaXV6dmFqNW8xeEk1eUNWVXViUjhVNG1OZ1BrQkVnUW54bGpn?=
 =?utf-8?B?ZkpnT0lPcUgxaWlFdkU3aVo5dTM5WFBiOGxxV1ZCWk5DSE9uZ2swanA5ZXdy?=
 =?utf-8?B?UXIwRFpJbzFmL05wTHF1d0hCV3F0UFhFYyt5MFBjbi9WVXlyTmdCa3dYeWU0?=
 =?utf-8?B?bWkwSDZOVDUvWExBS0FFSHdqZGJ0TmU5ZFIyS1hPMnI0Z1c2ajdVWkxITVZy?=
 =?utf-8?B?TWplU1JyR2pTbmEwZEhxRmVGeW5WakpUMmtxc3ZZWG9CNzZXTDc2SmNFMWVH?=
 =?utf-8?B?aXYyeUk0YjBZZjJJN1M5WUo4K0ZwTElQVi9scUY5SXplWDAxNkIyTUVwTHRD?=
 =?utf-8?B?SjRXOU1VL0VvOUNKUGl0ejZOR0s4RUVxbDNsdGNzWEZ4ZmZ4cDcwZVFvcjZX?=
 =?utf-8?B?SEJ5a1krVmplVGg1aDRWQW5sMHZHZGNjeDkxdkhvcHI1RlZNVXNTTm54VnRR?=
 =?utf-8?Q?qjV84L6NyY9Bc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8026958b-71c5-4c89-e7f3-08d8b91ea0c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 06:27:26.9755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3huwCN7YG6ymtfc7X0Ls0Vz+WtJKkv4HxBhdsMTKyxEQBrO1tBNeZ9tUefSS3VlCAvQHpXWHTnr1E7/qwM8Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610692049; bh=3xG7S9gwh1xgZxOKbRYWozddJdL893StehW1mcgsxTc=;
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
        b=fZ/db/fTNmkN9uguCYeBsdlbx/RZt6hX/ynFyN1m5dMN/dy3wHPvWkfizJqOFuB6p
         +4ZmHLc922FbanRksfHz5tA6AkfZ5oWtO15Mg5xIYpbZfjPCNCP8N2y6Uf1UVLMfD1
         J8u0gCsUiVQN2tgvbMUssY1P/RZIjMvo0r73D5FpSclQ/s/0Tnv9bWyXtu+YVjUeNb
         jwZEaEtdDvWer/UbF5TS6bkB3BmRtBS8RKgxFBoYDkRLR1GnwSwYWvtcB1VJh5aiQT
         DvBtF5SzrZdj5rJtRxJvgWFjH7TkcI1wYGNBjVrpyQuOPWULQJTtfqQ5ubBgVDc3wH
         siDEEbErEuUFg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBKYW51YXJ5IDE1LCAyMDIxIDExOjA5IEFNDQo+IA0KPiANCj4gT24gMjAyMS8xLzE0IOS4
i+WNiDM6NTgsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBKYXNvbiBXYW5n
IDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgSmFudWFyeSAxNCwg
MjAyMSA5OjQ4IEFNDQo+ID4+DQo+ID4+IE9uIDIwMjEvMS83IOS4iuWNiDExOjQ4LCBQYXJhdiBQ
YW5kaXQgd3JvdGU6DQo+ID4+Pj4gRnJvbTogTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0
LmNvbT4NCj4gPj4+PiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDUsIDIwMjEgNjo1MyBQTQ0KPiA+
Pj4+DQo+ID4+Pj4gT24gVHVlLCBKYW4gMDUsIDIwMjEgYXQgMTI6MzA6MTVQTSArMDAwMCwgUGFy
YXYgUGFuZGl0IHdyb3RlOg0KPiA+Pj4+Pj4gRnJvbTogTWljaGFlbCBTLiBUc2lya2luIDxtc3RA
cmVkaGF0LmNvbT4NCj4gPj4+Pj4+IFNlbnQ6IFR1ZXNkYXksIEphbnVhcnkgNSwgMjAyMSA1OjQ1
IFBNDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gT24gVHVlLCBKYW4gMDUsIDIwMjEgYXQgMTI6MDI6MzNQ
TSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+Pj4+Pj4+PiBGcm9tOiBNaWNoYWVsIFMu
IFRzaXJraW4gPG1zdEByZWRoYXQuY29tPg0KPiA+Pj4+Pj4+PiBTZW50OiBUdWVzZGF5LCBKYW51
YXJ5IDUsIDIwMjEgNToxOSBQTQ0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBPbiBUdWUsIEphbiAw
NSwgMjAyMSBhdCAxMjozMjowM1BNICswMjAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+Pj4+
Pj4+PiBFbmFibGUgdXNlciB0byBjcmVhdGUgdmRwYXNpbSBuZXQgc2ltdWxhdGUgZGV2aWNlcy4N
Cj4gPj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gJCB2ZHBhIGRldiBhZGQgbWdt
dGRldiB2ZHBhc2ltX25ldCBuYW1lIGZvbzINCj4gPj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+PiBTaG93
IHRoZSBuZXdseSBjcmVhdGVkIHZkcGEgZGV2aWNlIGJ5IGl0cyBuYW1lOg0KPiA+Pj4+Pj4+Pj4g
JCB2ZHBhIGRldiBzaG93IGZvbzINCj4gPj4+Pj4+Pj4+IGZvbzI6IHR5cGUgbmV0d29yayBtZ210
ZGV2IHZkcGFzaW1fbmV0IHZlbmRvcl9pZCAwDQo+IG1heF92cXMgMg0KPiA+Pj4+Pj4+Pj4gbWF4
X3ZxX3NpemUgMjU2DQo+ID4+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+Pj4gJCB2ZHBhIGRldiBzaG93IGZv
bzIgLWpwDQo+ID4+Pj4+Pj4+PiB7DQo+ID4+Pj4+Pj4+PiAgICAgICAiZGV2Ijogew0KPiA+Pj4+
Pj4+Pj4gICAgICAgICAgICJmb28yIjogew0KPiA+Pj4+Pj4+Pj4gICAgICAgICAgICAgICAidHlw
ZSI6ICJuZXR3b3JrIiwNCj4gPj4+Pj4+Pj4+ICAgICAgICAgICAgICAgIm1nbXRkZXYiOiAidmRw
YXNpbV9uZXQiLA0KPiA+Pj4+Pj4+Pj4gICAgICAgICAgICAgICAidmVuZG9yX2lkIjogMCwNCj4g
Pj4+Pj4+Pj4+ICAgICAgICAgICAgICAgIm1heF92cXMiOiAyLA0KPiA+Pj4+Pj4+Pj4gICAgICAg
ICAgICAgICAibWF4X3ZxX3NpemUiOiAyNTYNCj4gPj4+Pj4+Pj4+ICAgICAgICAgICB9DQo+ID4+
Pj4+Pj4+PiAgICAgICB9DQo+ID4+Pj4+Pj4+PiB9DQo+ID4+Pj4+Pj4+IEknZCBsaWtlIGFuIGV4
YW1wbGUgb2YgaG93IGRvIGRldmljZSBzcGVjaWZpYyAoZS5nLiBuZXQNCj4gPj4+Pj4+Pj4gc3Bl
Y2lmaWMpIGludGVyZmFjZXMgdGllIGluIHRvIHRoaXMuDQo+ID4+Pj4+Pj4gTm90IHN1cmUgSSBm
b2xsb3cgeW91ciBxdWVzdGlvbi4NCj4gPj4+Pj4+PiBEbyB5b3UgbWVhbiBob3cgdG8gc2V0IG1h
YyBhZGRyZXNzIG9yIG10dSBvZiB0aGlzIHZkcGEgZGV2aWNlIG9mDQo+ID4+Pj4+Pj4gdHlwZQ0K
PiA+Pj4+Pj4gbmV0Pw0KPiA+Pj4+Pj4+IElmIHNvLCBkZXYgYWRkIGNvbW1hbmQgd2lsbCBiZSBl
eHRlbmRlZCBzaG9ydGx5IGluIHN1YnNlcXVlbnQNCj4gPj4+Pj4+PiBzZXJpZXMgdG8NCj4gPj4+
Pj4+IHNldCB0aGlzIG5ldCBzcGVjaWZpYyBhdHRyaWJ1dGVzLg0KPiA+Pj4+Pj4+IChJIGRpZCBt
ZW50aW9uIGluIHRoZSBuZXh0IHN0ZXBzIGluIGNvdmVyIGxldHRlcikuDQo+ID4+Pj4+Pj4NCj4g
Pj4+Pj4+Pj4+ICtzdGF0aWMgaW50IF9faW5pdCB2ZHBhc2ltX25ldF9pbml0KHZvaWQpIHsNCj4g
Pj4+Pj4+Pj4+ICsJaW50IHJldDsNCj4gPj4+Pj4+Pj4+ICsNCj4gPj4+Pj4+Pj4+ICsJaWYgKG1h
Y2FkZHIpIHsNCj4gPj4+Pj4+Pj4+ICsJCW1hY19wdG9uKG1hY2FkZHIsIG1hY2FkZHJfYnVmKTsN
Cj4gPj4+Pj4+Pj4+ICsJCWlmICghaXNfdmFsaWRfZXRoZXJfYWRkcihtYWNhZGRyX2J1ZikpDQo+
ID4+Pj4+Pj4+PiArCQkJcmV0dXJuIC1FQUREUk5PVEFWQUlMOw0KPiA+Pj4+Pj4+Pj4gKwl9IGVs
c2Ugew0KPiA+Pj4+Pj4+Pj4gKwkJZXRoX3JhbmRvbV9hZGRyKG1hY2FkZHJfYnVmKTsNCj4gPj4+
Pj4+Pj4+ICAgIAl9DQo+ID4+Pj4+Pj4+IEhtbSBzbyBhbGwgZGV2aWNlcyBzdGFydCBvdXQgd2l0
aCB0aGUgc2FtZSBNQUMgdW50aWwgY2hhbmdlZD8NCj4gPj4+Pj4+Pj4gQW5kIGhvdyBpcyB0aGUg
Y2hhbmdlIGVmZmVjdGVkPw0KPiA+Pj4+Pj4+IFBvc3QgdGhpcyBwYXRjaHNldCBhbmQgcG9zdCB3
ZSBoYXZlIGlwcm91dGUyIHZkcGEgaW4gdGhlIHRyZWUsDQo+ID4+Pj4+Pj4gd2lsbCBhZGQgdGhl
DQo+ID4+Pj4+PiBtYWMgYWRkcmVzcyBhcyB0aGUgaW5wdXQgYXR0cmlidXRlIGR1cmluZyAidmRw
YSBkZXYgYWRkIiBjb21tYW5kLg0KPiA+Pj4+Pj4+IFNvIHRoYXQgZWFjaCBkaWZmZXJlbnQgdmRw
YSBkZXZpY2UgY2FuIGhhdmUgdXNlciBzcGVjaWZpZWQNCj4gPj4+Pj4+PiAoZGlmZmVyZW50KSBt
YWMNCj4gPj4+Pj4+IGFkZHJlc3MuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gRm9yIG5vdyBtYXliZSBq
dXN0IGF2b2lkIFZJUlRJT19ORVRfRl9NQUMgdGhlbiBmb3IgbmV3IGRldmljZXMNCj4gPj4+PiB0
aGVuPw0KPiA+Pj4+PiBUaGF0IHdvdWxkIHJlcXVpcmUgYm9vayBrZWVwaW5nIGV4aXN0aW5nIG5l
dCB2ZHBhX3NpbSBkZXZpY2VzDQo+ID4+Pj4+IGNyZWF0ZWQgdG8NCj4gPj4+PiBhdm9pZCBzZXR0
aW5nIFZJUlRJT19ORVRfRl9NQUMuDQo+ID4+Pj4+IFN1Y2ggYm9vayBrZWVwaW5nIGNvZGUgd2ls
bCBiZSBzaG9ydCBsaXZlZCBhbnl3YXkuDQo+ID4+Pj4+IE5vdCBzdXJlIGlmIGl0cyB3b3J0aCBp
dC4NCj4gPj4+Pj4gVW50aWwgbm93IG9ubHkgb25lIGRldmljZSB3YXMgY3JlYXRlZC4gU28gbm90
IHN1cmUgdHdvIHZkcGENCj4gPj4+Pj4gZGV2aWNlcyB3aXRoDQo+ID4+Pj4gc2FtZSBtYWMgYWRk
cmVzcyB3aWxsIGJlIGEgcmVhbCBpc3N1ZS4NCj4gPj4+Pj4gV2hlbiB3ZSBhZGQgbWFjIGFkZHJl
c3MgYXR0cmlidXRlIGluIGFkZCBjb21tYW5kLCBhdCB0aGF0IHBvaW50DQo+ID4+Pj4+IGFsc28N
Cj4gPj4+PiByZW1vdmUgdGhlIG1vZHVsZSBwYXJhbWV0ZXIgbWFjYWRkci4NCj4gPj4+Pg0KPiA+
Pj4+IFdpbGwgdGhhdCBiZSBtYW5kYXRvcnk/IEknbSBub3QgdG8gaGFwcHkgd2l0aCBhIFVBUEkg
d2UgaW50ZW5kIHRvDQo+ID4+Pj4gYnJlYWsgc3RyYWlnaHQgYXdheSAuLi4NCj4gPj4+IE5vLiBT
cGVjaWZ5aW5nIG1hYyBhZGRyZXNzIHNob3VsZG4ndCBiZSBtYW5kYXRvcnkuIFVBUEkgd29udCcg
YmUNCj4gPj4gYnJva2VuLg0KPiA+Pg0KPiA+Pg0KPiA+PiBJZiBpdCdzIG5vdCBtYW5kYXRvcnku
IERvZXMgaXQgbWVhbiB0aGUgdkRQQSBwYXJlbnQgbmVlZCB0byB1c2UgaXRzDQo+ID4+IG93biBs
b2dpYyB0byBnZW5lcmF0ZSBhIHZhbGlkYXRlIG1hYz8gSSdtIG5vdCBzdXJlIHRoaXMgaXMgd2hh
dA0KPiA+PiBtYW5hZ2VtZW50IChsaWJ2aXJ0IHdhbnQpLg0KPiA+Pg0KPiA+IFRoZXJlIGFyZSBm
ZXcgdXNlIGNhc2VzIHRoYXQgSSBzZWUgd2l0aCBQRnMsIFZGcyBhbmQgU0ZzIHN1cHBvcnRpbmcg
dmRwYQ0KPiBkZXZpY2VzLg0KPiA+DQo+ID4gMS4gVXNlciB3YW50cyB0byB1c2UgdGhlIFZGIG9u
bHkgZm9yIHZkcGEgcHVycG9zZS4gSGVyZSB1c2VyIGdvdCB0aGUgVkYNCj4gd2hpY2ggd2FzIHBy
ZS1zZXR1cCBieSB0aGUgc3lzYWRtaW4uDQo+ID4gSW4gdGhpcyBjYXNlIHdoYXRldmVyIE1BQyBh
c3NpZ25lZCB0byB0aGUgVkYgY2FuIGJlIHVzZWQgYnkgaXRzIHZkcGENCj4gZGV2aWNlLg0KPiA+
IEhlcmUsIHVzZXIgZG9lc24ndCBuZWVkIHRvIHBhc3MgdGhlIG1hYyBhZGRyZXNzIGR1cmluZyB2
ZHBhIGRldmljZQ0KPiBjcmVhdGlvbiB0aW1lLg0KPiA+IFRoaXMgaXMgZG9uZSBhcyB0aGUgc2Ft
ZSBNQUMgaGFzIGJlZW4gc2V0dXAgaW4gdGhlIEFDTCBydWxlcyBvbiB0aGUgc3dpdGNoDQo+IHNp
ZGUuDQo+ID4gTm9uIFZEUEEgdXNlcnMgb2YgYSBWRiB0eXBpY2FsbHkgdXNlIHRoZSBWRiB0aGlz
IHdheSBmb3IgTmV0ZGV2IGFuZCByZG1hDQo+IGZ1bmN0aW9uYWxpdHkuDQo+ID4gVGhleSBtaWdo
dCBjb250aW51ZSBzYW1lIHdheSBmb3IgdmRwYSBhcHBsaWNhdGlvbiBhcyB3ZWxsLg0KPiA+IEhl
cmUgVkYgbWFjIGlzIGVpdGhlciBzZXQgdXNpbmcNCj4gPiAoYSkgZGV2bGluayBwb3J0IGZ1bmN0
aW9uIHNldCBod19hZGRyIGNvbW1hbmQgb3IgdXNpbmcNCj4gPiAoYikgaXAgbGluayBzZXQgdmYg
bWFjDQo+ID4gU28gdmRwYSB0b29sIGRpZG4ndCBwYXNzIHRoZSBtYWMuIChvcHRpb25hbCkuDQo+
ID4gVGhvdWdoIFZJUlRJT19ORVRfRl9NQUMgaXMgc3RpbGwgdmFsaWQuDQo+ID4NCj4gPiAyLiBV
c2VyIG1heSB3YW50IHRvIGNyZWF0ZSBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZSBvdXQgb2YgdGhl
IG1nbXQuDQo+IGRldmljZS4NCj4gPiBIZXJlIHVzZXIgd2FudHMgdG8gbW9yZS9mdWxsIGNvbnRy
b2wgb2YgYWxsIGZlYXR1cmVzLCBvdmVycmlkaW5nIHdoYXQNCj4gc3lzYWRtaW4gaGFzIHNldHVw
IGFzIE1BQyBvZiB0aGUgVkYvU0YuDQo+ID4gSW4gdGhpcyBjYXNlIHVzZXIgd2lsbCBzcGVjaWZ5
IHRoZSBNQUMgdmlhIG1nbXQgdG9vbC4NCj4gPiAoYSkgVGhpcyBpcyBhbHNvIHVzZWQgYnkgdGhv
c2UgdmRwYSBkZXZpY2VzIHdoaWNoIGRvZXNuJ3QgaGF2ZSBlc3dpdGNoDQo+IG9mZmxvYWRzLg0K
PiA+IChiKSBUaGlzIHdpbGwgd29yayB3aXRoIGVzd2l0Y2ggb2ZmbG9hZHMgYXMgd2VsbCB3aG8g
ZG9lcyBzb3VyY2UgbGVhcm5pbmcuDQo+ID4gKGMpIFVzZXIgY2hvc2UgdG8gdXNlIHRoZSB2ZHBh
IGRldmljZSBvZiBhIFZGIHdoaWxlIFZGIE5ldGRldiBhbmQgcmRtYQ0KPiBkZXZpY2UgYXJlIHVz
ZWQgYnkgaHlwZXJ2aXNvciBmb3Igc29tZXRoaW5nIGVsc2UgYXMgd2VsbC4NCj4gPiBWSVJUSU9f
TkVUX0ZfTUFDIHJlbWFpbnMgdmFsaWQgaW4gYWxsIDIue2EsYixjfS4NCj4gPg0KPiA+IDMuIEEg
IHZlbmRvciBtZ210LiBkZXZpY2UgYWx3YXlzIGV4cGVjdHMgaXQgdXNlciB0byBwcm92aWRlIG1h
YyBmb3IgaXRzDQo+IHZkcGEgZGV2aWNlcy4NCj4gPiBTbyB3aGVuIGl0IGlzIG5vdCBwcm92aWRl
ZCwgaXQgY2FuIGZhaWwgd2l0aCBlcnJvciBtZXNzYWdlIHN0cmluZyBpbiBleHRhY2sgb3INCj4g
Y2xlYXIgdGhlIFZJUlRJT19ORVRfRl9NQUMgYW5kIGxldCBpdCB3b3JrIHVzaW5nIHZpcnRpbyBz
cGVjJ3MgNS4xLjUgcG9pbnQgNQ0KPiB0byBwcm9jZWVkLg0KPiA+DQo+ID4gQXMgY29tbW9uIGRl
bm9taW5hdG9yIG9mIGFsbCBhYm92ZSBjYXNlcywgaWYgUUVNVSBvciB1c2VyIHBhc3MgdGhlIE1B
Qw0KPiBkdXJpbmcgY3JlYXRpb24sIGl0IHdpbGwgYWxtb3N0IGFsd2F5cyB3b3JrLg0KPiA+IEFk
dmFuY2UgdXNlciBhbmQgUUVNVSB3aXRoIHN3aXRjaGRldiBtb2RlIHN1cHBvcnQgd2hvIGhhcyBk
b25lDQo+IDEuYS8xLmIsIHdpbGwgb21pdCBpdC4NCj4gPiBJIGRvIG5vdCBrbm93IGhvdyBkZWVw
IGludGVncmF0aW9uIG9mIFFFTVUgZXhpc3Qgd2l0aCB0aGUgc3dpdGNoZGV2DQo+IG1vZGUgc3Vw
cG9ydC4NCj4gPg0KPiA+IFdpdGggdGhhdCBtYWMsIG10dSBhcyBvcHRpb25hbCBpbnB1dCBmaWVs
ZHMgcHJvdmlkZSB0aGUgbmVjZXNzYXJ5IGZsZXhpYmlsaXR5DQo+IGZvciBkaWZmZXJlbnQgc3Rh
Y2tzIHRvIHRha2UgYXBwcm9wcmlhdGUgc2hhcGUgYXMgdGhleSBkZXNpcmUuDQo+IA0KPiANCj4g
VGhhbmtzIGZvciB0aGUgY2xhcmlmaWNhdGlvbi4gSSB0aGluayB3ZSdkIGJldHRlciBkb2N1bWVu
dCB0aGUgYWJvdmUgaW4gdGhlDQo+IHBhdGNoIHRoYXQgaW50cm9kdWNlcyB0aGUgbWFjIHNldHRp
bmcgZnJvbSBtYW5hZ2VtZW50IEFQSS4NCg0KWWVzLiBXaWxsIGRvLg0KVGhhbmtzLg0K
