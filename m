Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF82F5BE7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbhANH6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:58:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6186 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbhANH6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:58:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffff9920002>; Wed, 13 Jan 2021 23:58:10 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 07:58:10 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 14 Jan 2021 07:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGF+dodk+vcYPqgQzYKpERF2z/jNm0pHHRR4cmysNnZtkiy65dUOnG2RiEv0jOa2PM0afMpHn0VXzNNK5qqqP0BBlbRjyJ097ZAzzhTyn0QzbgWYsXCYqB6ID95AF8DK/Z7VQF0VVF8AHqiyFQqZGereeKuiDt6N5FCaeSllRmBZUnZyaLPJigrkTiNUcJmN1dACG902NPR06octfUMOCUjnYnV+/CEfK/hjC+0KnO6amTw0rJJ2rmKMRSXu54WfmC9T2/A4Ehm4WyZi1MqRI+iV8C9pcFveCt3+VxVD0Mefhg+5a532olPblbOF7zTSjTT3fYWYlT+eOTOtXtVDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6OibsPp9mfy4OTim9y0eVocbAhfXDjzJPf/lsTe7kw=;
 b=IiXWJWHBxdBh30xZFfrwiAD/FLVo8aeJdHZFtXYqMi1n9M52kKjVC8f5F1EDt/h+T1JcbE3Kt0l0N5CfV37qX0DlA6xH6YAjhjCEuAo3QI5m4tDTM9tVzLhghYtcUerf52UB4/dxi9XwkKKDnndoV9CzXTeH3A/e+Uw45dl23AZG6Lvqf4HjA9N2R116ZVLQHZogY8qj7hnlTTcgXroRECoFaEHdOae0L5EV+lkKcpkohVrtb7AUkupAVxWs1Grp55ACcrewWaJI/CkuoQVSZyof237EEjYoNhbuGVHzDeE6R2CGIp7EhAi3/3hlwa4dLh+uHA43rVDXljQi79utkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2871.namprd12.prod.outlook.com (2603:10b6:a03:13d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Thu, 14 Jan
 2021 07:58:08 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 07:58:08 +0000
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
Thread-Index: AQHW404ZeuD1Nrf6EkKQQnhYNrY/9qoY6uQAgAAB4oCAAAVhgIAAAsjwgAAQXACAAoNJoIALCUSAgAAyM0A=
Date:   Thu, 14 Jan 2021 07:58:08 +0000
Message-ID: <BY5PR12MB43225D83EA46004E3AF50D3ADCA80@BY5PR12MB4322.namprd12.prod.outlook.com>
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
In-Reply-To: <66dc44ac-52da-eaba-3f5e-69254e42d75b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a486b493-bb6a-4a32-4add-08d8b86221a9
x-ms-traffictypediagnostic: BYAPR12MB2871:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2871ABE384DB0E3CAC123FF6DCA80@BYAPR12MB2871.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LP5DtqWN9EgGbw6LESxl7SZ4bFH5iP5CeYtU6pTCZQ98FnKge1bgPNFaPoCSbfbpd+gZmDdCDZRSbp4rEWL6LTCNDF5ot0hX3fJ7/b5ck1F1055aWuAxHOvKTBqoCgcddvO1VLwJqHJkjFDbe3B3CV82tJLH5Xz5RIOscGI5qiFcp5HUl+SMMl7EEm32VL3f0alGHVOCd00HVmF8fVb7Uy3le2BxHVNhBv+SZW+Ew6Da4wK43A4zncle3vYm8D8hfafX4bEjBcE5iUAugyQG3jLm4HkvKYiZI4uTCeHvYtTmR+tI1wa+e+vRBpXBAHbjL1BuSDHjqP4Td4mR8OMWAzJ4d7c5VaD+Ar3+mn1JpRDqrbOo/rLUuYyUT9fBBVci54iK7jbr0UNaEXgrwDPRwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(33656002)(26005)(83380400001)(6506007)(8676002)(316002)(9686003)(71200400001)(4326008)(55016002)(2906002)(86362001)(66476007)(66556008)(8936002)(64756008)(76116006)(52536014)(110136005)(54906003)(5660300002)(7696005)(66446008)(66946007)(478600001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1NXUGE3SjdYMDNaV1hKY3cvMDRpcEZFUXlQWXZHVGpEN2pXTk5sS2dNVk5V?=
 =?utf-8?B?emRRdVBVV3U3MlZla0NXQjl3azRBaFVCSzZra01OR0IyUWZpQ0ZSOG5hRXdO?=
 =?utf-8?B?ZGF6Q0M3b2RMTlBXTGJwYmNqQTA4eXFzSnljYUpFY0F1eHovUXhxd3pBSE8r?=
 =?utf-8?B?MkN3TU0yMUxseVBSQldLZUtFMGJldk0xK0g0M1Ezc01LQ0ZwelhOZ1BQMmdw?=
 =?utf-8?B?QlhXa085WTNnV0w3NXVScU8rUitUaEZuT0gzSGVwaUM1Q1dBcGRmV2MxYUFm?=
 =?utf-8?B?RGNwdzE2SGxac2FKdUlSQi8xeDJZa0I3c0xpWVM1YnYrZEg1THVqVGZUbUI4?=
 =?utf-8?B?NXJvVjhsekV4NkpYOVkyWGdEL2FMbEkxYlBsZ0s4RTBLYXFTdUFDUUt4TVY5?=
 =?utf-8?B?aE1GSmpGZ0RGMXVRbC92dEJ4SE5yc0ppRHoxdnpwMzhKV1NaYUVpSjVsUTFZ?=
 =?utf-8?B?OVR4Z2hSeGFzNWlQTHVFNjdhNU1sYzQ1Yi8zdmx1RlREdXZvU1Y3Ryt5SGhq?=
 =?utf-8?B?UjdiZm90WitRVHFLT0tMTjRBVUljc1pzRHE4SFlOV1RJZzRNMGFEcDh4eFo2?=
 =?utf-8?B?dG5MVjcwNFdJSGZPQzRwT1lyNjlzeDVIdGpieGxKZkJWeU01N0x6R0NSWSt0?=
 =?utf-8?B?bS9Vb3pMZzcxUERNYitjWFpRV3lPbnM1Z2hlbjR0RGpPMUU4WWh5bGlIZExy?=
 =?utf-8?B?ekNQWFpZVmFvREYxVmFwYVpLTHBISUc4NGZueXlWVUVGeGd4QW5JMUpkZkg3?=
 =?utf-8?B?NjlORStUTFcxTXFyUUtpRUJsa1JwcjhMOWZMZmY2NytCMWtEV1pQK1g4bHlr?=
 =?utf-8?B?b25DWSsrTXJjV2I0TEQxYnR5bkhzdS8rRmx1YmVWOUM1ZTlnTG93Q3NSbW03?=
 =?utf-8?B?Zk1GcFlyT3Z6VlRWYVV6aTBEenMzbmtuRVFPUEg1emdtZ1ZQM2NnMkMxZUcr?=
 =?utf-8?B?TXRuZkJBUjMwdlAzNk1CZjF6QTVGandZdWM5MzhpUTkwRTl0MUx2a0RiR1dV?=
 =?utf-8?B?V3hFMlJONDhLODFUd1BzeS9aYWprcGxFa05xWnVMbGJsc2NOQzNsajJlMDI2?=
 =?utf-8?B?YUJZSE5JakZyUUwwaXY5UjVrRFgxenNGb3pRNFEzWlNvNHBFbWt6c0o4UjFZ?=
 =?utf-8?B?Sm9SMnZNTUZFM1V5REZENElxS2l0S1NsYzdHZW5IelQxQnRRSTcxK01OdXAr?=
 =?utf-8?B?M3N0YUtjM0lWWTFsNmt3d0lqQlZoR0xiaVVYWUk3dGE0d0VXUHpibmRhOUV6?=
 =?utf-8?B?NmFmQ1pjTGZKSGgxUEFITklSK1RROUZVeEVpT0NFRlR0ZlB4UzFqWnZHbTd0?=
 =?utf-8?Q?5Xghzdd3BUYCo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a486b493-bb6a-4a32-4add-08d8b86221a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 07:58:08.2599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vEvfS6WznEYQpF6Y2u4d5kMgMBjJ/ReUT3LXXz4/0pHiTYgXFUOwb75tu+ODl26Tz+aW7gXR3Gx+/h24ngeAFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2871
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610611090; bh=V6OibsPp9mfy4OTim9y0eVocbAhfXDjzJPf/lsTe7kw=;
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
        b=q9HSy57CyYvJTApfIue29Ylo4S5+i1MgxS7zUmOUpvgbsxa7GcE19u0nreDg2TJKI
         9c9Mn+MQsnJTsRj2Uvaren2nHAk/ulMm+iS3dOUprX5CldrMvgSr3ZEwXVX/opH2Rj
         D/9VQGKdUJNtFbOtiYAnUJC5pnC1rhXtSaz4Hl3ZxCpcCkjrE7gtq8BQ7xpHnnCAgf
         +u4wsmJZc1ilKUUFSrUKNHv6F7lE7VDL6rnWQXpBbVjt1Bhf2wxSXspQjYbY/YZVSK
         mh92e8+MDG6qp6xiGwXFnZBzShRGCNJFD5VSlbSAZH6X8nU32rbZU2PSlTYV0XzmWv
         DRN+SG1nQe75A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1
cnNkYXksIEphbnVhcnkgMTQsIDIwMjEgOTo0OCBBTQ0KPiANCj4gT24gMjAyMS8xLzcg5LiK5Y2I
MTE6NDgsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBNaWNoYWVsIFMuIFRz
aXJraW4gPG1zdEByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDUsIDIw
MjEgNjo1MyBQTQ0KPiA+Pg0KPiA+PiBPbiBUdWUsIEphbiAwNSwgMjAyMSBhdCAxMjozMDoxNVBN
ICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+Pg0KPiA+Pj4+IEZyb206IE1pY2hhZWwg
Uy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+ID4+Pj4gU2VudDogVHVlc2RheSwgSmFudWFy
eSA1LCAyMDIxIDU6NDUgUE0NCj4gPj4+Pg0KPiA+Pj4+IE9uIFR1ZSwgSmFuIDA1LCAyMDIxIGF0
IDEyOjAyOjMzUE0gKzAwMDAsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPj4+Pj4NCj4gPj4+Pj4+
IEZyb206IE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+DQo+ID4+Pj4+PiBTZW50
OiBUdWVzZGF5LCBKYW51YXJ5IDUsIDIwMjEgNToxOSBQTQ0KPiA+Pj4+Pj4NCj4gPj4+Pj4+IE9u
IFR1ZSwgSmFuIDA1LCAyMDIxIGF0IDEyOjMyOjAzUE0gKzAyMDAsIFBhcmF2IFBhbmRpdCB3cm90
ZToNCj4gPj4+Pj4+PiBFbmFibGUgdXNlciB0byBjcmVhdGUgdmRwYXNpbSBuZXQgc2ltdWxhdGUg
ZGV2aWNlcy4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gJCB2ZHBhIGRldiBhZGQg
bWdtdGRldiB2ZHBhc2ltX25ldCBuYW1lIGZvbzINCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IFNob3cg
dGhlIG5ld2x5IGNyZWF0ZWQgdmRwYSBkZXZpY2UgYnkgaXRzIG5hbWU6DQo+ID4+Pj4+Pj4gJCB2
ZHBhIGRldiBzaG93IGZvbzINCj4gPj4+Pj4+PiBmb28yOiB0eXBlIG5ldHdvcmsgbWdtdGRldiB2
ZHBhc2ltX25ldCB2ZW5kb3JfaWQgMCBtYXhfdnFzIDINCj4gPj4+Pj4+PiBtYXhfdnFfc2l6ZSAy
NTYNCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+ICQgdmRwYSBkZXYgc2hvdyBmb28yIC1qcA0KPiA+Pj4+
Pj4+IHsNCj4gPj4+Pj4+PiAgICAgICJkZXYiOiB7DQo+ID4+Pj4+Pj4gICAgICAgICAgImZvbzIi
OiB7DQo+ID4+Pj4+Pj4gICAgICAgICAgICAgICJ0eXBlIjogIm5ldHdvcmsiLA0KPiA+Pj4+Pj4+
ICAgICAgICAgICAgICAibWdtdGRldiI6ICJ2ZHBhc2ltX25ldCIsDQo+ID4+Pj4+Pj4gICAgICAg
ICAgICAgICJ2ZW5kb3JfaWQiOiAwLA0KPiA+Pj4+Pj4+ICAgICAgICAgICAgICAibWF4X3ZxcyI6
IDIsDQo+ID4+Pj4+Pj4gICAgICAgICAgICAgICJtYXhfdnFfc2l6ZSI6IDI1Ng0KPiA+Pj4+Pj4+
ICAgICAgICAgIH0NCj4gPj4+Pj4+PiAgICAgIH0NCj4gPj4+Pj4+PiB9DQo+ID4+Pj4+Pg0KPiA+
Pj4+Pj4gSSdkIGxpa2UgYW4gZXhhbXBsZSBvZiBob3cgZG8gZGV2aWNlIHNwZWNpZmljIChlLmcu
IG5ldA0KPiA+Pj4+Pj4gc3BlY2lmaWMpIGludGVyZmFjZXMgdGllIGluIHRvIHRoaXMuDQo+ID4+
Pj4+IE5vdCBzdXJlIEkgZm9sbG93IHlvdXIgcXVlc3Rpb24uDQo+ID4+Pj4+IERvIHlvdSBtZWFu
IGhvdyB0byBzZXQgbWFjIGFkZHJlc3Mgb3IgbXR1IG9mIHRoaXMgdmRwYSBkZXZpY2Ugb2YNCj4g
Pj4+Pj4gdHlwZQ0KPiA+Pj4+IG5ldD8NCj4gPj4+Pj4gSWYgc28sIGRldiBhZGQgY29tbWFuZCB3
aWxsIGJlIGV4dGVuZGVkIHNob3J0bHkgaW4gc3Vic2VxdWVudA0KPiA+Pj4+PiBzZXJpZXMgdG8N
Cj4gPj4+PiBzZXQgdGhpcyBuZXQgc3BlY2lmaWMgYXR0cmlidXRlcy4NCj4gPj4+Pj4gKEkgZGlk
IG1lbnRpb24gaW4gdGhlIG5leHQgc3RlcHMgaW4gY292ZXIgbGV0dGVyKS4NCj4gPj4+Pj4NCj4g
Pj4+Pj4+PiArc3RhdGljIGludCBfX2luaXQgdmRwYXNpbV9uZXRfaW5pdCh2b2lkKSB7DQo+ID4+
Pj4+Pj4gKwlpbnQgcmV0Ow0KPiA+Pj4+Pj4+ICsNCj4gPj4+Pj4+PiArCWlmIChtYWNhZGRyKSB7
DQo+ID4+Pj4+Pj4gKwkJbWFjX3B0b24obWFjYWRkciwgbWFjYWRkcl9idWYpOw0KPiA+Pj4+Pj4+
ICsJCWlmICghaXNfdmFsaWRfZXRoZXJfYWRkcihtYWNhZGRyX2J1ZikpDQo+ID4+Pj4+Pj4gKwkJ
CXJldHVybiAtRUFERFJOT1RBVkFJTDsNCj4gPj4+Pj4+PiArCX0gZWxzZSB7DQo+ID4+Pj4+Pj4g
KwkJZXRoX3JhbmRvbV9hZGRyKG1hY2FkZHJfYnVmKTsNCj4gPj4+Pj4+PiAgIAl9DQo+ID4+Pj4+
PiBIbW0gc28gYWxsIGRldmljZXMgc3RhcnQgb3V0IHdpdGggdGhlIHNhbWUgTUFDIHVudGlsIGNo
YW5nZWQ/DQo+ID4+Pj4+PiBBbmQgaG93IGlzIHRoZSBjaGFuZ2UgZWZmZWN0ZWQ/DQo+ID4+Pj4+
IFBvc3QgdGhpcyBwYXRjaHNldCBhbmQgcG9zdCB3ZSBoYXZlIGlwcm91dGUyIHZkcGEgaW4gdGhl
IHRyZWUsDQo+ID4+Pj4+IHdpbGwgYWRkIHRoZQ0KPiA+Pj4+IG1hYyBhZGRyZXNzIGFzIHRoZSBp
bnB1dCBhdHRyaWJ1dGUgZHVyaW5nICJ2ZHBhIGRldiBhZGQiIGNvbW1hbmQuDQo+ID4+Pj4+IFNv
IHRoYXQgZWFjaCBkaWZmZXJlbnQgdmRwYSBkZXZpY2UgY2FuIGhhdmUgdXNlciBzcGVjaWZpZWQN
Cj4gPj4+Pj4gKGRpZmZlcmVudCkgbWFjDQo+ID4+Pj4gYWRkcmVzcy4NCj4gPj4+Pg0KPiA+Pj4+
IEZvciBub3cgbWF5YmUganVzdCBhdm9pZCBWSVJUSU9fTkVUX0ZfTUFDIHRoZW4gZm9yIG5ldyBk
ZXZpY2VzDQo+ID4+IHRoZW4/DQo+ID4+PiBUaGF0IHdvdWxkIHJlcXVpcmUgYm9vayBrZWVwaW5n
IGV4aXN0aW5nIG5ldCB2ZHBhX3NpbSBkZXZpY2VzDQo+ID4+PiBjcmVhdGVkIHRvDQo+ID4+IGF2
b2lkIHNldHRpbmcgVklSVElPX05FVF9GX01BQy4NCj4gPj4+IFN1Y2ggYm9vayBrZWVwaW5nIGNv
ZGUgd2lsbCBiZSBzaG9ydCBsaXZlZCBhbnl3YXkuDQo+ID4+PiBOb3Qgc3VyZSBpZiBpdHMgd29y
dGggaXQuDQo+ID4+PiBVbnRpbCBub3cgb25seSBvbmUgZGV2aWNlIHdhcyBjcmVhdGVkLiBTbyBu
b3Qgc3VyZSB0d28gdmRwYSBkZXZpY2VzDQo+ID4+PiB3aXRoDQo+ID4+IHNhbWUgbWFjIGFkZHJl
c3Mgd2lsbCBiZSBhIHJlYWwgaXNzdWUuDQo+ID4+PiBXaGVuIHdlIGFkZCBtYWMgYWRkcmVzcyBh
dHRyaWJ1dGUgaW4gYWRkIGNvbW1hbmQsIGF0IHRoYXQgcG9pbnQgYWxzbw0KPiA+PiByZW1vdmUg
dGhlIG1vZHVsZSBwYXJhbWV0ZXIgbWFjYWRkci4NCj4gPj4NCj4gPj4gV2lsbCB0aGF0IGJlIG1h
bmRhdG9yeT8gSSdtIG5vdCB0byBoYXBweSB3aXRoIGEgVUFQSSB3ZSBpbnRlbmQgdG8NCj4gPj4g
YnJlYWsgc3RyYWlnaHQgYXdheSAuLi4NCj4gPiBOby4gU3BlY2lmeWluZyBtYWMgYWRkcmVzcyBz
aG91bGRuJ3QgYmUgbWFuZGF0b3J5LiBVQVBJIHdvbnQnIGJlDQo+IGJyb2tlbi4NCj4gDQo+IA0K
PiBJZiBpdCdzIG5vdCBtYW5kYXRvcnkuIERvZXMgaXQgbWVhbiB0aGUgdkRQQSBwYXJlbnQgbmVl
ZCB0byB1c2UgaXRzIG93biBsb2dpYw0KPiB0byBnZW5lcmF0ZSBhIHZhbGlkYXRlIG1hYz8gSSdt
IG5vdCBzdXJlIHRoaXMgaXMgd2hhdCBtYW5hZ2VtZW50IChsaWJ2aXJ0DQo+IHdhbnQpLg0KPiAN
ClRoZXJlIGFyZSBmZXcgdXNlIGNhc2VzIHRoYXQgSSBzZWUgd2l0aCBQRnMsIFZGcyBhbmQgU0Zz
IHN1cHBvcnRpbmcgdmRwYSBkZXZpY2VzLg0KDQoxLiBVc2VyIHdhbnRzIHRvIHVzZSB0aGUgVkYg
b25seSBmb3IgdmRwYSBwdXJwb3NlLiBIZXJlIHVzZXIgZ290IHRoZSBWRiB3aGljaCB3YXMgcHJl
LXNldHVwIGJ5IHRoZSBzeXNhZG1pbi4NCkluIHRoaXMgY2FzZSB3aGF0ZXZlciBNQUMgYXNzaWdu
ZWQgdG8gdGhlIFZGIGNhbiBiZSB1c2VkIGJ5IGl0cyB2ZHBhIGRldmljZS4NCkhlcmUsIHVzZXIg
ZG9lc24ndCBuZWVkIHRvIHBhc3MgdGhlIG1hYyBhZGRyZXNzIGR1cmluZyB2ZHBhIGRldmljZSBj
cmVhdGlvbiB0aW1lLg0KVGhpcyBpcyBkb25lIGFzIHRoZSBzYW1lIE1BQyBoYXMgYmVlbiBzZXR1
cCBpbiB0aGUgQUNMIHJ1bGVzIG9uIHRoZSBzd2l0Y2ggc2lkZS4NCk5vbiBWRFBBIHVzZXJzIG9m
IGEgVkYgdHlwaWNhbGx5IHVzZSB0aGUgVkYgdGhpcyB3YXkgZm9yIE5ldGRldiBhbmQgcmRtYSBm
dW5jdGlvbmFsaXR5Lg0KVGhleSBtaWdodCBjb250aW51ZSBzYW1lIHdheSBmb3IgdmRwYSBhcHBs
aWNhdGlvbiBhcyB3ZWxsLg0KSGVyZSBWRiBtYWMgaXMgZWl0aGVyIHNldCB1c2luZyANCihhKSBk
ZXZsaW5rIHBvcnQgZnVuY3Rpb24gc2V0IGh3X2FkZHIgY29tbWFuZCBvciB1c2luZyANCihiKSBp
cCBsaW5rIHNldCB2ZiBtYWMgDQpTbyB2ZHBhIHRvb2wgZGlkbid0IHBhc3MgdGhlIG1hYy4gKG9w
dGlvbmFsKS4NClRob3VnaCBWSVJUSU9fTkVUX0ZfTUFDIGlzIHN0aWxsIHZhbGlkLg0KDQoyLiBV
c2VyIG1heSB3YW50IHRvIGNyZWF0ZSBvbmUgb3IgbW9yZSB2ZHBhIGRldmljZSBvdXQgb2YgdGhl
IG1nbXQuIGRldmljZS4NCkhlcmUgdXNlciB3YW50cyB0byBtb3JlL2Z1bGwgY29udHJvbCBvZiBh
bGwgZmVhdHVyZXMsIG92ZXJyaWRpbmcgd2hhdCBzeXNhZG1pbiBoYXMgc2V0dXAgYXMgTUFDIG9m
IHRoZSBWRi9TRi4NCkluIHRoaXMgY2FzZSB1c2VyIHdpbGwgc3BlY2lmeSB0aGUgTUFDIHZpYSBt
Z210IHRvb2wuDQooYSkgVGhpcyBpcyBhbHNvIHVzZWQgYnkgdGhvc2UgdmRwYSBkZXZpY2VzIHdo
aWNoIGRvZXNuJ3QgaGF2ZSBlc3dpdGNoIG9mZmxvYWRzLg0KKGIpIFRoaXMgd2lsbCB3b3JrIHdp
dGggZXN3aXRjaCBvZmZsb2FkcyBhcyB3ZWxsIHdobyBkb2VzIHNvdXJjZSBsZWFybmluZy4NCihj
KSBVc2VyIGNob3NlIHRvIHVzZSB0aGUgdmRwYSBkZXZpY2Ugb2YgYSBWRiB3aGlsZSBWRiBOZXRk
ZXYgYW5kIHJkbWEgZGV2aWNlIGFyZSB1c2VkIGJ5IGh5cGVydmlzb3IgZm9yIHNvbWV0aGluZyBl
bHNlIGFzIHdlbGwuDQpWSVJUSU9fTkVUX0ZfTUFDIHJlbWFpbnMgdmFsaWQgaW4gYWxsIDIue2Es
YixjfS4NCg0KMy4gQSAgdmVuZG9yIG1nbXQuIGRldmljZSBhbHdheXMgZXhwZWN0cyBpdCB1c2Vy
IHRvIHByb3ZpZGUgbWFjIGZvciBpdHMgdmRwYSBkZXZpY2VzLg0KU28gd2hlbiBpdCBpcyBub3Qg
cHJvdmlkZWQsIGl0IGNhbiBmYWlsIHdpdGggZXJyb3IgbWVzc2FnZSBzdHJpbmcgaW4gZXh0YWNr
IG9yIGNsZWFyIHRoZSBWSVJUSU9fTkVUX0ZfTUFDIGFuZCBsZXQgaXQgd29yayB1c2luZyB2aXJ0
aW8gc3BlYydzIDUuMS41IHBvaW50IDUgdG8gcHJvY2VlZC4NCg0KQXMgY29tbW9uIGRlbm9taW5h
dG9yIG9mIGFsbCBhYm92ZSBjYXNlcywgaWYgUUVNVSBvciB1c2VyIHBhc3MgdGhlIE1BQyBkdXJp
bmcgY3JlYXRpb24sIGl0IHdpbGwgYWxtb3N0IGFsd2F5cyB3b3JrLg0KQWR2YW5jZSB1c2VyIGFu
ZCBRRU1VIHdpdGggc3dpdGNoZGV2IG1vZGUgc3VwcG9ydCB3aG8gaGFzIGRvbmUgMS5hLzEuYiwg
d2lsbCBvbWl0IGl0Lg0KSSBkbyBub3Qga25vdyBob3cgZGVlcCBpbnRlZ3JhdGlvbiBvZiBRRU1V
IGV4aXN0IHdpdGggdGhlIHN3aXRjaGRldiBtb2RlIHN1cHBvcnQuDQoNCldpdGggdGhhdCBtYWMs
IG10dSBhcyBvcHRpb25hbCBpbnB1dCBmaWVsZHMgcHJvdmlkZSB0aGUgbmVjZXNzYXJ5IGZsZXhp
YmlsaXR5IGZvciBkaWZmZXJlbnQgc3RhY2tzIHRvIHRha2UgYXBwcm9wcmlhdGUgc2hhcGUgYXMg
dGhleSBkZXNpcmUuDQoNCg==
