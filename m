Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F603648A9
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhDSQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:58:43 -0400
Received: from mail-dm6nam12on2135.outbound.protection.outlook.com ([40.107.243.135]:21408
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230127AbhDSQ6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 12:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBK+WsEXoseDJ+mbMf8H29+S1ysPC1ba4VmyL/HWpRciup0GfQNhYCwK/6J1sqZwwF6LWhG6/AZV8wGPU3xKh/L+pEReBRdlQHduHzjkWcNyVrUwoxTIawuhVUJKweOSfmZ+uihFzoP1h97/lTbTsC3jx7btWzS3xhOKfXr49ojmbz2XqRJKOIhzGBTAj12DIabTRctuokcj5ZAHqx3Lijxn4PX5ry55/H5D2df+3E0Dos8ayb/ugt21Fqldqo+dNbPJPahQGuI/xMERhFZLcb/WEOi0MolWzdMKM+grVFdaQB/6lZojSePFBZdQC1Q+gaKcJDlKcyR6Y6sY5c7fJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3g5pyv/zx0VwlOZVX4Q+pAhGxYb+6xs3wOv3LAQ+xU=;
 b=MK8D0jN0FTfVKhJvUXDA+y14Dx6VwqSoBpWfSL5H2ZxiKS9Z35k659fuI9UN2dyO4nYq9w1HZU5kSeYvz2KlZFifWuKprLL1uLqcDAmZKd+8LxwN1eJq8wx48qP0d8YCVx3q0V3lpI0cDR/8OLQ4VcwfRz8x2CbkqvH89oUUyLCDYMRIQpPe0h/bAjjg/HKE4XpOOnT+w0Ie4WjNBDsbZqCP8fVPHA8YRwTW8y3HOwMrtdTSU0xTJhedfUTbf1wLFznfd3jHMEcs7srhVmIzrgA3bb9/z1HIggHxm0jewNVz68Jox0RMX8WbPw5VCbzAvYA6mZs3/MQwr5Ws00ePxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3g5pyv/zx0VwlOZVX4Q+pAhGxYb+6xs3wOv3LAQ+xU=;
 b=OeOX29PYXlQ8XfOQXyXjE4eWE3M3hx+Iimy6QAkvj6t6RkcumHzmePtVaP7y4ZtUtiT/2pjEHuJC0xVeEO1mDgYIE5qZhXfIJ1h2LdO1w+rKcxenEUMTxCd+Xx3D93JkC2W//3mczQKZE3DWdqOk+Z45yBlmNuhsrmpT1hQS/I8=
Received: from DS7PR13MB4733.namprd13.prod.outlook.com (2603:10b6:5:3b1::24)
 by DM6PR13MB3274.namprd13.prod.outlook.com (2603:10b6:5:193::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.8; Mon, 19 Apr
 2021 16:58:05 +0000
Received: from DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0]) by DS7PR13MB4733.namprd13.prod.outlook.com
 ([fe80::f414:a9a:6686:f7e0%4]) with mapi id 15.20.4065.019; Mon, 19 Apr 2021
 16:58:05 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "fuzzybritches0@gmail.com" <fuzzybritches0@gmail.com>,
        "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com" 
        <syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net: sunrpc: xprt.c: fix shift-out-of-bounds in
 xprt_calc_majortimeo
Thread-Topic: [PATCH] net: sunrpc: xprt.c: fix shift-out-of-bounds in
 xprt_calc_majortimeo
Thread-Index: AQHXNTo9jFavk/To2EeOoe/7QqIJfaq8D94A
Date:   Mon, 19 Apr 2021 16:58:05 +0000
Message-ID: <5850f8a65c59436b607c9d1ac088402d14873577.camel@hammerspace.com>
References: <20210419163603.7-1-fuzzybritches0@gmail.com>
In-Reply-To: <20210419163603.7-1-fuzzybritches0@gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c17fb2a-112b-45c4-698b-08d903544d2f
x-ms-traffictypediagnostic: DM6PR13MB3274:
x-microsoft-antispam-prvs: <DM6PR13MB3274440C3DB7EFB4E5D78F30B8499@DM6PR13MB3274.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fOwZ8Dtlrvqvzjopy1aLrQgbW5EOTlSNruLgVaI38ZIBGITqtt41J7A+7dTPGd2PYd2QPj+AU6NRFS/KyaGT6muPj01sgjbXf5br7YC+RADwsHcxupLm4KoXVqfaPbyZR3yk/IuhuF0H7PAozHwMmJWnQQ7mcAQqR/R+3lgch5XDvNrWnXOBYK5F+oL+yXoBXPoXxdYJvjds7CfY1xkTpSSLo4EYJio8AYONH1Hs628Uz+eVstX7/heBH+3UHjQFskOaxRUMoifBXIPYZoaDhNna/Mk2fpUNEbfbOVkv5XwPHRGj9KSI8iQbwWl4tbuv35m3iRjLTDFa7lHuFOqWXYyTfcn3OdeOmwy/+/pay6UCHSl8Rgy1uyfCxtk1f8eUhOFcJ3z6MEEG5mSyrHOly1vP8U04vA5/hEJUHSvBOUnPculkIxCFWCH9TT+CwR1VCCevF1JRJdW45g4G5UojSYGZNpi4U23GfztSULno0kW+1/reGUKOskbnTzU0AA7vZENI5iWsFb2d2+WamjyxfGFSoG/jFnbxd9+YYacJWfUtWwpjJKowFDwRvxAbfqxH6JxTACYi7R4Glp37pGrW6meOAIbutNprto9TFaqQki8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR13MB4733.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39840400004)(346002)(396003)(6512007)(86362001)(36756003)(186003)(478600001)(6506007)(7416002)(316002)(26005)(54906003)(110136005)(38100700002)(4326008)(122000001)(71200400001)(83380400001)(2616005)(2906002)(8936002)(5660300002)(8676002)(66476007)(6486002)(66946007)(91956017)(76116006)(64756008)(66556008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SWNoaFBDUHY4U09mTXk1cXZxZFdrV0V5RmtEUGRYOVFMb0pqOURpaTFRd1ho?=
 =?utf-8?B?bkFZWGNNdVc1dGI0N1NQOFRoamRwYXVxMkpCdTFHQ3NFTHp1SUx4RERsQVVh?=
 =?utf-8?B?SEY3cXhFd29GQTYwV3NBZzFJUEdXSlB6TFNIMW52dkQvUWgyM243VWV1NjZ4?=
 =?utf-8?B?anJYaG9FM2U2Q2VRUlhpVFR2TE9tUHBZQnJEK3B3UEI5TS9MR1pNS2pOYTZX?=
 =?utf-8?B?N0RpZm1BRDZLNnVvNXo0aTVkLys4bzYwTC9JVHNERnhwMEZyMlRZaGYvTDhB?=
 =?utf-8?B?dURwbCtJUDMranlWc0QvQVIxUmZHNFZzVGg0cktJMlArcWVKMm9NNTZ0eCt3?=
 =?utf-8?B?MGlBd2lXdXM2WWgrWThjU3NPUld1WVNEM3IxdEljMU5iWVI3Qnh0K1VtTlNV?=
 =?utf-8?B?Q1dack1PVXJjWTBaNUxlZlcyUGxicUNUeGVuV0c1K3BqN1hBZjAzdW10T3lH?=
 =?utf-8?B?YUE0aTRMd2Q4eVlEZzREYWY5djFvMDk5MEhpcnBldHhUemZaaXJuajFoNlZs?=
 =?utf-8?B?MUd1ZWRKb2lrck8zVVFKYnVFQk0wekxSMnlBL0FoT1orY1VZeXZxVWJFSVlt?=
 =?utf-8?B?MlIva05jV3RjTGlJV3NRSldHbVNtNE8zdWc5bm1NUjkwajB3ZDZUZkZrdlV0?=
 =?utf-8?B?TlFBOUt3aHhWMjhOYTNPR3NZQnI0bjZSY3UzU1M4WGx3aDQ1NURObm9WMUpw?=
 =?utf-8?B?V0EvbTNzT0RkbldxWGdDbnpYWGt4YVJBamdxU2MyQU5YeGRmam1Bdi9QUDNr?=
 =?utf-8?B?S3J3UE9xLzVZc1BEUzRxL202YWVjbzBWSlZzQ1IxQ2tLT2IrMVVXd2VRTGwz?=
 =?utf-8?B?NkxKVmN5eE8reHNob0U2VnQ2SGdTUUJWSGg5ZkR5OE8xbkVQQkN0bVE4Y2kr?=
 =?utf-8?B?OWNmUVcrUDRRNCs2d2pVZmlXTnBKejd2VHRFbVcxRk4ycXl6S212cDlweTh5?=
 =?utf-8?B?QTcvaHo0QjRteWNybTBiQWtXNkFpbGRZSDM3T2FqZ3N6eWdrZzZtK1dDK0d0?=
 =?utf-8?B?SkFMc2xJQWpIM3dWMjE5cmdHZGVlQ0lNUGhINmtzbGVvOVNCcmxLZ3NiSzJn?=
 =?utf-8?B?a1VyR0wwTXZ0MWRocnptd040TVVsSlVlN045WDJoVUU5SnZPU29EQUFvRmVU?=
 =?utf-8?B?TGFIWEkxS1h0YU4xNlN0ODJlSFlaQTlrTk1jVmdqbEQwVEdtRWJvUTBocDJo?=
 =?utf-8?B?aGRvSExuOHBDV00rYW9kbTQxeThzUmx6ZFNrTmR5Uy9IVndic2NEMDNNVU1L?=
 =?utf-8?B?Mmh3OVp1ZWRPZzRJTVVmek8xQmE5N09kcTRwQjlXTEk5c2QybDhVcm80d2Z5?=
 =?utf-8?B?ZENNRmU4aHgxb2FSVzlkT0w3U1FBTWNlK3BkRGFsU2x1K1lZdUdXMnpiZ1J3?=
 =?utf-8?B?dkx4dnZiaWN3ak9sN1Y3NFpIbC9QemZUUFk3OVZEek14RGpwcHpIeXpBaUJ1?=
 =?utf-8?B?Q1Q3Zkh2RzNBTDhsT09ZYVpMRk9TeEtRaFQxMDdESWlLblJyMzRwVGo0NlRr?=
 =?utf-8?B?Y1NMNUptTUREY1NHdnJiUTdXL1VLNW9PZ053d3ZrcWgwSnRXMGhSQUlFVVc0?=
 =?utf-8?B?QWh5MnBZVE5tSlM0TnEwbG9kOFZ6UitjSDZlUmZTcXo3YzhCbEZHbXdmYmlm?=
 =?utf-8?B?WWJpREQ0QXJKUzJGWm80MURPcG5mamtZSUh1MmhycUlTdUR2eVArN0tsdjdl?=
 =?utf-8?B?ZVk5b08xZjlETUxqVVpYUDMvM0tXVGVVUTJtUVdHZGNXUDZRMzZEU2E3NU9S?=
 =?utf-8?Q?MRwY++/Jv8XyOMny6wjW2mveK7V3RLk91U7Ju5e?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <299834F6FE2E2C43883C741694F2B88F@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR13MB4733.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c17fb2a-112b-45c4-698b-08d903544d2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 16:58:05.5311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LIqlumy+CYoZFlb1Ok1VQ0eOJU2gIK/eCxuZXmCw4p8NYihoe7wm96NqQT+2+iBWiAbqitmx0lm9n3ZQgvhopg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3274
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA0LTE5IGF0IDE2OjM2ICswMDAwLCBLdXJ0IE1hbnVjcmVkbyB3cm90ZToN
Cj4gRml4IHNoaWZ0LW91dC1vZi1ib3VuZHMgaW4geHBydF9jYWxjX21ham9ydGltZW8oKS4NCj4g
DQo+IFVCU0FOOiBzaGlmdC1vdXQtb2YtYm91bmRzIGluIG5ldC9zdW5ycGMveHBydC5jOjY1ODox
NA0KPiBzaGlmdCBleHBvbmVudCA1MzY4NzEyMzIgaXMgdG9vIGxhcmdlIGZvciA2NC1iaXQgdHlw
ZSAnbG9uZyB1DQo+IA0KPiBSZXBvcnRlZC1ieTogc3l6Ym90K2JhMmU5MWRmOGY3NDgwOTQxN2Zh
QHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4gU2lnbmVkLW9mZi1ieTogS3VydCBNYW51Y3Jl
ZG8gPGZ1enp5YnJpdGNoZXMwQGdtYWlsLmNvbT4NCj4gLS0tDQo+IMKgbmV0L3N1bnJwYy94cHJ0
LmMgfCA1ICsrKystDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9zdW5ycGMveHBydC5jIGIvbmV0L3N1bnJw
Yy94cHJ0LmMNCj4gaW5kZXggNjkxY2NmODA0OWE0Li4wNzEyOGFjM2Q1MWQgMTAwNjQ0DQo+IC0t
LSBhL25ldC9zdW5ycGMveHBydC5jDQo+ICsrKyBiL25ldC9zdW5ycGMveHBydC5jDQo+IEBAIC02
NTUsNyArNjU1LDEwIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIHhwcnRfY2FsY19tYWpvcnRpbWVv
KHN0cnVjdA0KPiBycGNfcnFzdCAqcmVxKQ0KPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9u
ZyBtYWpvcnRpbWVvID0gcmVxLT5ycV90aW1lb3V0Ow0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKg
aWYgKHRvLT50b19leHBvbmVudGlhbCkNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oG1ham9ydGltZW8gPDw9IHRvLT50b19yZXRyaWVzOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKHRvLT50b19yZXRyaWVzID49IHNpemVvZihtYWpvcnRpbWVvKSAqIDgpDQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWFqb3J0aW1l
byA9IHRvLT50b19tYXh2YWw7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlbHNl
DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWFqb3J0
aW1lbyA8PD0gdG8tPnRvX3JldHJpZXM7DQo+IMKgwqDCoMKgwqDCoMKgwqBlbHNlDQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWFqb3J0aW1lbyArPSB0by0+dG9faW5jcmVtZW50
ICogdG8tPnRvX3JldHJpZXM7DQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAobWFqb3J0aW1lbyA+IHRv
LT50b19tYXh2YWwgfHwgbWFqb3J0aW1lbyA9PSAwKQ0KDQpJJ3ZlIGFscmVhZHkgc3RhdGVkIG9u
IHRoZSBtYWlsaW5nIGxpc3QgdGhhdCBJJ20gbm90IGFjY2VwdGluZyBhbnkNCmNoYW5nZXMgdG8g
eHBydF9jYWxjX21ham9ydGltZW8oKSBmb3IgdGhpcyBwcm9ibGVtLiBUaGVyZSBpcyBhIGZpeCB0
bw0KdGhlIE5GUyBtb3VudCBjb2RlIHRoYXQgYWRkcmVzc2VzIHRoaXMgYm91bmRzIGlzc3VlLCBh
bmQgdGhhdCBjb21taXQgaXMNCmFscmVhZHkgYmVpbmcgdGVzdGVkIGluIGxpbnV4LW5leHQuDQoN
Ci0tIA0KVHJvbmQgTXlrbGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1l
cnNwYWNlDQp0cm9uZC5teWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
