Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983CB286DD4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 06:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgJHE4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 00:56:14 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:55001 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgJHE4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 00:56:14 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7e9be80000>; Thu, 08 Oct 2020 12:56:08 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 8 Oct
 2020 04:56:03 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 8 Oct 2020 04:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqMlAXjAXE7/uvvQEFnBX7vvX+uBscnCmM0sGNfmZDQP0fhwvk4PQUp8emxT2+jXHKX8H9N61F2ODXHwqvv6QVOX7jyyIbtQDGVoncaASbO3jzBaZ+bFOXa+rxkVUbdmr8xHTGAIjqDB9MgMta0JrO3/+e6UoGNKlzR1ltSdvHeNq/qQkiQGaTiVOFz5UOxeJ0gk+HDWxjYG8Lcx8X6BQClCWdjIi5l6ggQIYSb4iLSDLghhSizh0SLmQM+rU8P3TLdmITqvnyYNbOA3zEoUzPw5/X/lCbfNHu2d4ccgiuypr2/x14v2rEysLp7ZHQRpy9gnHNgPRuLbMZHw65wOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjQlbYbrE9m3ZcuUWC4sdTr/WUY1WMbN9DbhplofSE4=;
 b=DEUtILoFguVqFVfpcndDtstG2bzRg7KN4N/xorNx83yvvvm0AMVI4q/ND1VMc1V6mvxmsUePkrYIgGKJRahd1dQvlrP22jBaqU/+cPJcRvWrIrWDTdFC8ACH1pOgRNX6Bh10cjR8pmGPmuCBYjAY/s0/0JA3fypTfy4t7Y9xyRKHXUOqzmBhYNQsmOdtWS8OFn28shYEunUGTTeOg3j0y3pmKWInaMWECChTp0BbM8JdkBkkfVZx4xcmCyXtYvOwkwiTEre5Tp3omgXhG5UA8PYaRLrZ8Chl/QLdYGT4BZmwOas2FoNF0QJtLkX/HB8SpkGuNZzx6w121VMUM/ab0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Thu, 8 Oct
 2020 04:56:01 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3455.023; Thu, 8 Oct 2020
 04:56:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm05cPW7H51WMukmCocLPE63Nf6mKKyGAgACGC4CAAB03gIABpCoAgAAWQgCAAAuCMIAACwKAgAADjQCAAAZvgIAAB6yAgABvlmA=
Date:   Thu, 8 Oct 2020 04:56:01 +0000
Message-ID: <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
In-Reply-To: <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51de899e-0d58-431c-4a31-08d86b46747c
x-ms-traffictypediagnostic: BY5PR12MB4180:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB41803C3FD30D00C6C1705A27DC0B0@BY5PR12MB4180.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rKGgHaUusek2zUEYRK0OG5ssxvp3BBHSXHrE1xRL845gKpqx9GR0Y3diIVRMQk6pfy1tBMPsgv5JwZ4Huhl6jJDYXDbstsP1Qp2Ir1Dil1EPYb2XLb9CajhmmG5j5w3xme2LxzktJ2GhjxhEWB1eMxe8DyvvQ133iC0CdBegXgcrTjziJSCS2AVfl3YAzNJAVDU6paH/SrYgTFjF6RwKTwI3VSqOFgSah2kT1qWiGbzOfGom/Z/XcRS1jULR+UNrGkWTGiVNMx9gGJSBJBE9HJ1jb/THj3d260SuCN13ycTpuskR+R2ip7FlXfWPIUL9ehW9JIiVHI2ca1gD4816Jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(83380400001)(2906002)(478600001)(110136005)(52536014)(76116006)(54906003)(316002)(66946007)(4326008)(186003)(26005)(7696005)(55236004)(53546011)(6506007)(86362001)(64756008)(66446008)(66556008)(9686003)(66476007)(33656002)(71200400001)(55016002)(8676002)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 14d+srQYIJc8eXMgUfV36KX7O4PvF9Av4udk4+g7A3D4M8pBN3qbkzASE3uG+sCOLeZ1Dq2X5XQvbY1n6UO+5ntGXSBY6Hj3NKuaPldkLUoKp017pXC/+BdXGmQwomoPdCHMfalmA16UVs7Usp6DMeeN4xSroqVyXkK5kIwz42ZJuX5HVMwFILstuDD8uQtHAn6NcI9WuuWYO162Yb8MJm2HshYA49aq2YCMUcwXyQANot3pKfn1u2v+X9EhyvJ7mhwfV5AsELL0ssW1Pg8SgcD35KlXk3WMeDuZZ4awBhbOHQww8NEst7UdA49On3JQ8vwv8jgQTOfNvkenrEVzXCXeZlPi27PetTL/XrDmirnwZB8rj/ozXFfrT9IX5s3H8nBOXUFDbm+ayQju0GqZZFZLG3nh+c/pKI0Kp4veOqnytteGt6EjFLukDz3ZYVVT1uP3PL3Ot9iAivAAIz09lCDWvs1d2qBOFtPz46lrCwRM502aF42Iw8yqmzpYK/R7p5pUnt5YHrGLyFc4V+vwLIKA4pgbkdGWmwe8g0cylq3LMg071AyiIV0KieqDvGYf8MxlwKjJ9iAY3+z1PsQMOQCoXueHxm3TBIcnf4bAY3rTLaaskvlCX1t9Va2n95DryVPpL1do8oRGh37Q2lhOVw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51de899e-0d58-431c-4a31-08d86b46747c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 04:56:01.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7OlUecuo4IoM83J/hxD+rJCDq2HjOKYyDsa1Ytgo0SJ3bqqd1hzr9atiq4DAOqfmYQ9OKJuE9OQoqYDvaM/HwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602132968; bh=ZjQlbYbrE9m3ZcuUWC4sdTr/WUY1WMbN9DbhplofSE4=;
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
        b=CPo5dF7AJcIIvst1ibrkZt16GPMo78+Nu60iBuUROvoWNmoRcEu+J10fl/IB0HT2c
         IRTaEG3rHInkb9T8nGFmznDbhYy282fwtt4uxzxeL7vUt7i3qCluNkHkLPykydDpz4
         39D5NiKxt3TjB/cgmzKcBVHDwj0fvapnPc9axKps5G7jMHIt4BneO8NL7AGJGD4XZO
         /Y5Yq8na8znPVwAE8Gj6Nvoeom9QqGZtq65jwUwWC6GY5m7ozUpYla8rUbZfsQkSiQ
         l7ulLKhTav/GZNSt0UDeuYdzkl53SKSpN4l6xE6rsM1o+r8U7Xgyg/liiX7Fk1oAQL
         lt201aoKNwZng==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogUGllcnJlLUxvdWlzIEJvc3NhcnQgPHBpZXJyZS1sb3Vpcy5ib3NzYXJ0QGxp
bnV4LmludGVsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIE9jdG9iZXIgOCwgMjAyMCAzOjIwIEFN
DQo+IA0KPiANCj4gT24gMTAvNy8yMCA0OjIyIFBNLCBFcnRtYW4sIERhdmlkIE0gd3JvdGU6DQo+
ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFBpZXJyZS1Mb3VpcyBC
b3NzYXJ0IDxwaWVycmUtbG91aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb20+DQo+ID4+IFNlbnQ6
IFdlZG5lc2RheSwgT2N0b2JlciA3LCAyMDIwIDE6NTkgUE0NCj4gPj4gVG86IEVydG1hbiwgRGF2
aWQgTSA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsgUGFyYXYgUGFuZGl0DQo+ID4+IDxwYXJh
dkBudmlkaWEuY29tPjsgTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+DQo+ID4+IENj
OiBhbHNhLWRldmVsQGFsc2EtcHJvamVjdC5vcmc7IHBhcmF2QG1lbGxhbm94LmNvbTsgdGl3YWlA
c3VzZS5kZTsNCj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgcmFuamFuaS5zcmlkaGFyYW5A
bGludXguaW50ZWwuY29tOw0KPiA+PiBmcmVkLm9oQGxpbnV4LmludGVsLmNvbTsgbGludXgtcmRt
YUB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4+IGRsZWRmb3JkQHJlZGhhdC5jb207IGJyb29uaWVAa2Vy
bmVsLm9yZzsgSmFzb24gR3VudGhvcnBlDQo+ID4+IDxqZ2dAbnZpZGlhLmNvbT47IGdyZWdraEBs
aW51eGZvdW5kYXRpb24ub3JnOyBrdWJhQGtlcm5lbC5vcmc7DQo+ID4+IFdpbGxpYW1zLCBEYW4g
SiA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPjsgU2FsZWVtLCBTaGlyYXoNCj4gPj4gPHNoaXJh
ei5zYWxlZW1AaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgUGF0aWwsIEtpcmFuDQo+
ID4+IDxraXJhbi5wYXRpbEBpbnRlbC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIg
MS82XSBBZGQgYW5jaWxsYXJ5IGJ1cyBzdXBwb3J0DQo+ID4+DQo+ID4+DQo+ID4+DQo+ID4+Pj4g
QmVsb3cgaXMgbW9zdCBzaW1wbGUsIGludHVpdGl2ZSBhbmQgbWF0Y2hpbmcgd2l0aCBjb3JlIEFQ
SXMgZm9yDQo+ID4+Pj4gbmFtZSBhbmQgZGVzaWduIHBhdHRlcm4gd2lzZS4NCj4gPj4+PiBpbml0
KCkNCj4gPj4+PiB7DQo+ID4+Pj4gCWVyciA9IGFuY2lsbGFyeV9kZXZpY2VfaW5pdGlhbGl6ZSgp
Ow0KPiA+Pj4+IAlpZiAoZXJyKQ0KPiA+Pj4+IAkJcmV0dXJuIHJldDsNCj4gPj4+Pg0KPiA+Pj4+
IAllcnIgPSBhbmNpbGxhcnlfZGV2aWNlX2FkZCgpOw0KPiA+Pj4+IAlpZiAocmV0KQ0KPiA+Pj4+
IAkJZ290byBlcnJfdW53aW5kOw0KPiA+Pj4+DQo+ID4+Pj4gCWVyciA9IHNvbWVfZm9vKCk7DQo+
ID4+Pj4gCWlmIChlcnIpDQo+ID4+Pj4gCQlnb3RvIGVycl9mb287DQo+ID4+Pj4gCXJldHVybiAw
Ow0KPiA+Pj4+DQo+ID4+Pj4gZXJyX2ZvbzoNCj4gPj4+PiAJYW5jaWxsYXJ5X2RldmljZV9kZWwo
YWRldik7DQo+ID4+Pj4gZXJyX3Vud2luZDoNCj4gPj4+PiAJYW5jaWxsYXJ5X2RldmljZV9wdXQo
YWRldi0+ZGV2KTsNCj4gPj4+PiAJcmV0dXJuIGVycjsNCj4gPj4+PiB9DQo+ID4+Pj4NCj4gPj4+
PiBjbGVhbnVwKCkNCj4gPj4+PiB7DQo+ID4+Pj4gCWFuY2lsbGFyeV9kZXZpY2VfZGUoYWRldik7
DQo+ID4+Pj4gCWFuY2lsbGFyeV9kZXZpY2VfcHV0KGFkZXYpOw0KPiA+Pj4+IAkvKiBJdCBpcyBj
b21tb24gdG8gaGF2ZSBhIG9uZSB3cmFwcGVyIGZvciB0aGlzIGFzDQo+ID4+Pj4gYW5jaWxsYXJ5
X2RldmljZV91bnJlZ2lzdGVyKCkuDQo+ID4+Pj4gCSAqIFRoaXMgd2lsbCBtYXRjaCB3aXRoIGNv
cmUgZGV2aWNlX3VucmVnaXN0ZXIoKSB0aGF0IGhhcyBwcmVjaXNlDQo+ID4+Pj4gZG9jdW1lbnRh
dGlvbi4NCj4gPj4+PiAJICogYnV0IGdpdmVuIGZhY3QgdGhhdCBpbml0KCkgY29kZSBuZWVkIHBy
b3BlciBlcnJvciB1bndpbmRpbmcsDQo+ID4+Pj4gbGlrZSBhYm92ZSwNCj4gPj4+PiAJICogaXQg
bWFrZSBzZW5zZSB0byBoYXZlIHR3byBBUElzLCBhbmQgbm8gbmVlZCB0byBleHBvcnQgYW5vdGhl
cg0KPiA+Pj4+IHN5bWJvbCBmb3IgdW5yZWdpc3RlcigpLg0KPiA+Pj4+IAkgKiBUaGlzIHBhdHRl
cm4gaXMgdmVyeSBlYXN5IHRvIGF1ZGl0IGFuZCBjb2RlLg0KPiA+Pj4+IAkgKi8NCj4gPj4+PiB9
DQo+ID4+Pg0KPiA+Pj4gSSBsaWtlIHRoaXMgZmxvdyArMQ0KPiA+Pj4NCj4gPj4+IEJ1dCAuLi4g
c2luY2UgdGhlIGluaXQoKSBmdW5jdGlvbiBpcyBwZXJmb3JtaW5nIGJvdGggZGV2aWNlX2luaXQg
YW5kDQo+ID4+PiBkZXZpY2VfYWRkIC0gaXQgc2hvdWxkIHByb2JhYmx5IGJlIGNhbGxlZCBhbmNp
bGxhcnlfZGV2aWNlX3JlZ2lzdGVyLA0KPiA+Pj4gYW5kIHdlIGFyZSBiYWNrIHRvIGEgc2luZ2xl
IGV4cG9ydGVkIEFQSSBmb3IgYm90aCByZWdpc3RlciBhbmQNCj4gPj4+IHVucmVnaXN0ZXIuDQo+
ID4+DQo+ID4+IEtpbmQgcmVtaW5kZXIgdGhhdCB3ZSBpbnRyb2R1Y2VkIHRoZSB0d28gZnVuY3Rp
b25zIHRvIGFsbG93IHRoZQ0KPiA+PiBjYWxsZXIgdG8ga25vdyBpZiBpdCBuZWVkZWQgdG8gZnJl
ZSBtZW1vcnkgd2hlbiBpbml0aWFsaXplKCkgZmFpbHMsDQo+ID4+IGFuZCBpdCBkaWRuJ3QgbmVl
ZCB0byBmcmVlIG1lbW9yeSB3aGVuIGFkZCgpIGZhaWxlZCBzaW5jZQ0KPiA+PiBwdXRfZGV2aWNl
KCkgdGFrZXMgY2FyZSBvZiBpdC4gSWYgeW91IGhhdmUgYSBzaW5nbGUgaW5pdCgpIGZ1bmN0aW9u
DQo+ID4+IGl0J3MgaW1wb3NzaWJsZSB0byBrbm93IHdoaWNoIGJlaGF2aW9yIHRvIHNlbGVjdCBv
biBlcnJvci4NCj4gPj4NCj4gPj4gSSBhbHNvIGhhdmUgYSBjYXNlIHdpdGggU291bmRXaXJlIHdo
ZXJlIGl0J3MgbmljZSB0byBmaXJzdA0KPiA+PiBpbml0aWFsaXplLCB0aGVuIHNldCBzb21lIGRh
dGEgYW5kIHRoZW4gYWRkLg0KPiA+Pg0KPiA+DQo+ID4gVGhlIGZsb3cgYXMgb3V0bGluZWQgYnkg
UGFyYXYgYWJvdmUgZG9lcyBhbiBpbml0aWFsaXplIGFzIHRoZSBmaXJzdA0KPiA+IHN0ZXAsIHNv
IGV2ZXJ5IGVycm9yIHBhdGggb3V0IG9mIHRoZSBmdW5jdGlvbiBoYXMgdG8gZG8gYQ0KPiA+IHB1
dF9kZXZpY2UoKSwgc28geW91IHdvdWxkIG5ldmVyIG5lZWQgdG8gbWFudWFsbHkgZnJlZSB0aGUg
bWVtb3J5IGluDQo+IHRoZSBzZXR1cCBmdW5jdGlvbi4NCj4gPiBJdCB3b3VsZCBiZSBmcmVlZCBp
biB0aGUgcmVsZWFzZSBjYWxsLg0KPiANCj4gZXJyID0gYW5jaWxsYXJ5X2RldmljZV9pbml0aWFs
aXplKCk7DQo+IGlmIChlcnIpDQo+IAlyZXR1cm4gcmV0Ow0KPiANCj4gd2hlcmUgaXMgdGhlIHB1
dF9kZXZpY2UoKSBoZXJlPyBpZiB0aGUgcmVsZWFzZSBmdW5jdGlvbiBkb2VzIGFueSBzb3J0IG9m
DQo+IGtmcmVlLCB0aGVuIHlvdSdkIG5lZWQgdG8gZG8gaXQgbWFudWFsbHkgaW4gdGhpcyBjYXNl
Lg0KU2luY2UgZGV2aWNlX2luaXRpYWxpemUoKSBmYWlsZWQsIHB1dF9kZXZpY2UoKSBjYW5ub3Qg
YmUgZG9uZSBoZXJlLg0KU28geWVzLCBwc2V1ZG8gY29kZSBzaG91bGQgaGF2ZSBzaG93biwNCmlm
IChlcnIpIHsNCglrZnJlZShhZGV2KTsNCglyZXR1cm4gZXJyOw0KfQ0KDQpJZiB3ZSBqdXN0IHdh
bnQgdG8gZm9sbG93IHJlZ2lzdGVyKCksIHVucmVnaXN0ZXIoKSBwYXR0ZXJuLA0KDQpUaGFuLA0K
DQphbmNpbGxhcl9kZXZpY2VfcmVnaXN0ZXIoKSBzaG91bGQgYmUsDQoNCi8qKg0KICogYW5jaWxs
YXJfZGV2aWNlX3JlZ2lzdGVyKCkgLSByZWdpc3RlciBhbiBhbmNpbGxhcnkgZGV2aWNlDQogKiBO
T1RFOiBfX25ldmVyIGRpcmVjdGx5IGZyZWUgQGFkZXYgYWZ0ZXIgY2FsbGluZyB0aGlzIGZ1bmN0
aW9uLCBldmVuIGlmIGl0IHJldHVybmVkDQogKiBhbiBlcnJvci4gQWx3YXlzIHVzZSBhbmNpbGxh
cnlfZGV2aWNlX3B1dCgpIHRvIGdpdmUgdXAgdGhlIHJlZmVyZW5jZSBpbml0aWFsaXplZCBieSB0
aGlzIGZ1bmN0aW9uLg0KICogVGhpcyBub3RlIG1hdGNoZXMgd2l0aCB0aGUgY29yZSBhbmQgY2Fs
bGVyIGtub3dzIGV4YWN0bHkgd2hhdCB0byBiZSBkb25lLg0KICovDQphbmNpbGxhcnlfZGV2aWNl
X3JlZ2lzdGVyKCkNCnsNCglkZXZpY2VfaW5pdGlhbGl6ZSgmYWRldi0+ZGV2KTsNCglpZiAoIWRl
di0+cGFyZW50IHx8ICFhZGV2LT5uYW1lKQ0KCQlyZXR1cm4gLUVJTlZBTDsNCglpZiAoIWRldi0+
cmVsZWFzZSAmJiAhKGRldi0+dHlwZSAmJiBkZXYtPnR5cGUtPnJlbGVhc2UpKSB7DQoJCS8qIGNv
cmUgaXMgYWxyZWFkeSBjYXBhYmxlIGFuZCB0aHJvd3MgdGhlIHdhcm5pbmcgd2hlbiByZWxlYXNl
IGNhbGxiYWNrIGlzIG5vdCBzZXQuDQoJCSAqIEl0IGlzIGRvbmUgYXQgZHJpdmVycy9iYXNlL2Nv
cmUuYzoxNzk4Lg0KCQkgKiBGb3IgTlVMTCByZWxlYXNlIGl0IHNheXMsICJkb2VzIG5vdCBoYXZl
IGEgcmVsZWFzZSgpIGZ1bmN0aW9uLCBpdCBpcyBicm9rZW4gYW5kIG11c3QgYmUgZml4ZWQiDQoJ
CSAqLw0KCQlyZXR1cm4gLUVJTlZBTDsNCgl9DQoJZXJyID0gZGV2X3NldF9uYW1lKGFkZXYuLi4p
Ow0KCWlmIChlcnIpIHsNCgkJLyoga29iamVjdF9yZWxlYXNlKCkgLT4ga29iamVjdF9jbGVhbnVw
KCkgYXJlIGNhcGFibGUgdG8gZGV0ZWN0IGlmIG5hbWUgaXMgc2V0LyBub3Qgc2V0DQoJCSAgKiBh
bmQgZnJlZSB0aGUgY29uc3QgaWYgaXQgd2FzIHNldC4NCgkJICAqLw0KCQlyZXR1cm4gZXJyOw0K
CX0NCgllcnIgPSBkZXZpY2VfYWRkKCZhZGV2LT5kZXYpOw0KCUlmIChlcnIpDQoJCXJldHVybiBl
cnI7DQp9DQoNCkNhbGxlciBjb2RlOg0KaW5pdCgpDQp7DQoJYWRldiA9IGt6YWxsb2Moc2l6ZW9m
KCpmb29fYWRldikuLik7DQoJaWYgKCFhZGV2KQ0KCQlyZXR1cm4gLUVOT01FTTsNCgllcnIgPSBh
bmNpbGxhcnlfZGV2aWNlX3JlZ2lzdGVyKCZhZGV2KTsNCglpZiAoZXJyKQ0KCQlnb3RvIGVycjsN
Cg0KZXJyOg0KCWFuY2lsbGFyeV9kZXZpY2VfcHV0KCZhZGV2KTsNCglyZXR1cm4gZXJyOw0KfQ0K
DQpjbGVhbnVwKCkNCnsNCglhbmNpbGxhcnlfZGV2aWNlX3VucmVnaXN0ZXIoJmFkZXYpOw0KfQ0K
DQpBYm92ZSBwYXR0ZXJuIGlzIGZpbmUgdG9vIG1hdGNoaW5nIHRoZSBjb3JlLg0KDQpJZiBJIHVu
ZGVyc3RhbmQgTGVvbiBjb3JyZWN0bHksIGhlIHByZWZlcnMgc2ltcGxlIHJlZ2lzdGVyKCksIHVu
cmVnaXN0ZXIoKSBwYXR0ZXJuLg0KSWYsIHNvIGl0IHNob3VsZCBiZSBleHBsaWNpdCByZWdpc3Rl
cigpLCB1bnJlZ2lzdGVyKCkgQVBJLg0KDQpIb3dldmVyIEkgcmVhZCB0aGF0IFBpZXJyZSBtZW50
aW9uZWQgdGhhdCBTb3VuZFdpcmUgcHJlZmVycyBpbml0aWFsaXplKCksIHNvbWVfZGF0YV9pbml0
KCksIGFkZCgpIHBhdHRlcm4uDQpJZiBTb3VuZFdpcmUgY2Fubm90IGRvIHJlZ2lzdGVyKCkgcGF0
dGVybiwNClNvLCB3aGljaGV2ZXIgZmlyc3QgdXNlciBidW5kbGVkIHdpdGggdGhlIHBhdGNoc2V0
LCB0aG9zZSBBUElzIHNob3VsZCBiZSBleHBvcnRlZCwgYmVjYXVzZSB3ZSBkb27igJl0IGFkZCBh
biBBUEkgd2l0aG91dCBhIHVzZXIuDQoNClBpZXJyZSwgDQpDYW4geW91IHBsZWFzZSBjaGVjayBp
ZiBTb3VuZFdpcmUgY2FuIGZvbGxvdyByZWdpc3RlcigpIHBhdHRlcm4/DQoNCkFzc3VtaW5nIExl
b24gcGF0Y2hlcyBhbmQgbXkgcGF0Y2hlcyBmb3Igc3ViZnVuY3Rpb24gYXJyaXZlIGFmdGVyIFNv
dW5kd2lyZSBzZXJpZXMgKyBhbmNpbGxhcnkgYnVzLA0Kd2UgY2FuIGFkZCB0aGUgcmVnaXN0ZXIo
KSBhbmQgdW5yZWdpc3RlcigpIHZlcnNpb24gaW4gb3VyIHBhdGNoc2V0IGxhdGVyLg0KDQpHcmVn
IGFscmVhZHkgc2FpZCB0aGF0ICJpdCdzIG5vdCBjYXJ2ZWQgb24gc3RvbmUsIHdlIGNhbiBkbyBp
bmNyZW1lbnRhbCBhZGRpdGlvbnMgYXMgdGhlIG5lZWQgYXJpc2UiLg0KU28gSSB0aGluayB3ZSBz
aG91bGQgcHJvY2VlZCB3aXRoIHRoZSB3cmFwcGVycyB3aGljaCBmb2xsb3cgdGhlIGNvcmUgY29u
dmVudGlvbiBvZiANCmVpdGhlciANCihhKSBpbml0aWFsaXplKSgpLCBhZGQoKSBvciANCihiKSBy
ZWdpc3RlcigpLCB1bnJlZ2lzdGVyKCkuDQo=
