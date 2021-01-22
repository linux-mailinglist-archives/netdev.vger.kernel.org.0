Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FE32FFB26
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbhAVDfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:35:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2152 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAVDfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:35:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600a47bc0001>; Thu, 21 Jan 2021 19:34:20 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 03:34:12 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 22 Jan 2021 03:34:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oG6PU5+ctWjdZ2dUXmvhV/OI+93Vi9T4w9dfGq05ONnDfpH4L1d+G/ZHhMKPngaH3bK8kQCUjbxN12gCVeGtTuARGcCq91e8Q3P3/laIo8BoQQmPxi9BzKrFgmKI0KFtAfDk9c/Q1tSpPhgIj7WyvW7s2F441GmrXDfncRrtLB8kRXW/5Rowp9RMRdmTqvQpNPyp7VYaTzHtV2xqa80T8MPoSkIqFpmhOEPX7mfQbw7I8l9aFXZRNXlxv/gFe/jZQnWbEm9CsbbpXhoHN/VIDze1Ic4B04Lz2GeZfwq+PvSIGK0cIHLH5qHmxyWf5odFvNwCV0OfQllgGR2GI87HdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NiaxLtWn3IWUd91RAROJI8o8evHLAWqZdopN2ZdXWJU=;
 b=AGbcCrAvtShCVkmlVagctqkcJ9VgG4giK/G24SB28iVeDWbhZO42D9R3jkRm8F1LURF33TaM7giyde57hW4bbDlOplRFK5xZkc7tIl4WeSzsggGWXMigcFgcEWYovCjXTlStwZ+nFsOjThLZDhDimt0ycofKkgTcETHCkMtRu1chuGUZlJnJhux68/DTBfw0UB05/h5SYDXNPdpLyEIF+Ls6FdEGrVUPOObYK1NFlK++fzXcJNbRoyndx4f/E319phWgIKRMjQ3upwjb2+JXt2UhPsu4LMqe4ljD76Zk8phL/XumBd3VSy/X0Czf8oIJfi++GBavvFXqW1qGCDuXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3109.namprd12.prod.outlook.com (2603:10b6:a03:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 03:34:11 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 03:34:11 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "edwin.peer@broadcom.com" <edwin.peer@broadcom.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next V9 04/14] devlink: Support get and set state of port
 function
Thread-Topic: [net-next V9 04/14] devlink: Support get and set state of port
 function
Thread-Index: AQHW79LmOc2AgL8+00S37CQe3gJx/aoyjxaAgABvX3A=
Date:   Fri, 22 Jan 2021 03:34:11 +0000
Message-ID: <BY5PR12MB4322DA258E1C86792FA67C8FDCA09@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-5-saeed@kernel.org>
 <338c82b7-bb73-a793-2fe2-7e48bf0e4178@intel.com>
In-Reply-To: <338c82b7-bb73-a793-2fe2-7e48bf0e4178@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ade0a4e-9c6c-4063-cabf-08d8be869595
x-ms-traffictypediagnostic: BYAPR12MB3109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB310915E3029268EAE6C368EDDCA09@BYAPR12MB3109.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: afbWV6UN6cnsyvlVupQPjYsK1JX2EJpuixk2sJ9vl84ocEdClIwg64chb4eIpFIoIndEo7P+rSWtRHgcuww29AkkUm7Wi3mCdsehGHP9HXUv7sK6U6i2w5MnRmQlrfISG3Bcc1kbgFfAr1UNklKwpF6mDM3NavJspy5fExZ0i2kCX1xdRntHq+wa7Jp1Ao/SllLIvzsxaOXL2efcQwuJ3j3Q6TCt+Z7BYT4BxXvuNNg6Ztas3hx8/V//bZWpdlleVxzAKby7bw56Ax2tWgFg3QojzsTDj8QTEgOS2iuwUD75Wq94TKy+NKf3z/MHPJ8Ow1J2XPWVZAEdusunv80PURM5MHkqC2ZaBRjJD8jP+qE8BOs2+meBmGzhM+5RD1toIN0zNxNS0t/Ca7nHQuIK7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(83380400001)(64756008)(76116006)(186003)(4326008)(86362001)(66946007)(6636002)(33656002)(55016002)(8936002)(7416002)(71200400001)(5660300002)(8676002)(7696005)(478600001)(2906002)(52536014)(66476007)(66556008)(54906003)(6506007)(66446008)(316002)(53546011)(110136005)(26005)(107886003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L25SQjZMRDViSmVkd3Zub1IrZHlFTHNIQXZ4ZnFDTjJjcDFoK0NmSkw0clJ0?=
 =?utf-8?B?Sm9FaUI5YS81a3pFREFOUmdNbmZPMzdxdEFoRTBWa0cvVitFSHFlWDZCQzB1?=
 =?utf-8?B?eEFkeWc1T0VqVGJTU3ZOU3RkQkhKR2k3eWdBSHhMK3duVEJneGV1ZlJNK3FE?=
 =?utf-8?B?bmFhUkxXNDJoalFOdnFDM25RcGUvOTNOdW9GZEY5dmh6QWNodno4NkYwZzE0?=
 =?utf-8?B?R0VWd082MUdEQXBHeWhGSmNHOUxXRHlaSXRtYjhwZFRBQWVkOGIxckRZWUNp?=
 =?utf-8?B?S281UVp6ZmFIQjBvS1hHQ1ptUzVIem44cHpLbVVQRDl5VkMwTDJlcHlQZ3BF?=
 =?utf-8?B?d3pFV3EyeGQrb2E3WkVSYzl0cDA0U1NmMjFXOXlKbDNrNktxd1NZSGV4Z1VC?=
 =?utf-8?B?Q3cza3VUVWQ1QmdVMjNRbGVMZXpDL05ySUJZalB6L2J6YVpBWXIxdWVVa1Za?=
 =?utf-8?B?NDRRc2x0UEJBNzlrMXNZRlZVT2t1YVp5WmpiVjJUZFMyYzVCRm5EeG9Lajg0?=
 =?utf-8?B?UGlzYkRDOVdGVlBQb3BKYnk2bUtha3ZERmVNN2dWWG1HMEVpM1JGRlorSEFp?=
 =?utf-8?B?SHZjNXRYUzVvT1dkelorQ055dTlVa2FLV2RFbzRROFVvNE5sanY1RnhQSDVJ?=
 =?utf-8?B?ekRVV2JHU2REeXpRdDlXcDcrV1NucTJ6VDE4TUI3eDN6UEFFMmM4NC9Ddzda?=
 =?utf-8?B?cWtaWHdTTXlYYXV6Z2x2ZkJJZGdhMFBEcnR1ajcvL09QZzJtS3lvZ2s3bjM5?=
 =?utf-8?B?dSs2UTE1alBWR0piRDN4dXNmYkJUM0RCbzhONkUreXIzUVgyNlR0WFlqaDc2?=
 =?utf-8?B?bkRGU2pjMDVUeTZIOE5PaUp5di9CQzU5RmYweGtWMjFybHIxVEN3YWxmMzlV?=
 =?utf-8?B?NDg4RndGdlprc1JuUVBKSnBXdkk5UnAyV0NZKy81RlFNdTh0VnJUWGxvT1R0?=
 =?utf-8?B?bWtvQXhKSlp6Ty81T2pVUVdwN1JUSEZ5UUlQalRwQ1BSMVk4Z2FXZnp6LzZY?=
 =?utf-8?B?Rk1XOUMzNXZKNzVuMUUzMkZZOE5iNXIxUHI1WDBKS00yR3hJalpLV05IVjdM?=
 =?utf-8?B?UXVFSW1lZzFBOTBueVgwUk12Q05YUjZCR0xWSUwxNXU5eTgxL0RxZEdJWjd0?=
 =?utf-8?B?VUFRdEsrUXVoY1NRU2k1cFlUY0VDNkNpOExWeXZleWdoTHA2Sk5vVWN5bkxh?=
 =?utf-8?B?QldhR2RLSklYOEphbXd5OFVIMm9LUUpWYWozQUdhb3N3SHFKYU9jQ2gwYWh5?=
 =?utf-8?B?ZHplcm5QdzJqenUvSWRNcWRrNGoxU1g0ZnBCWklDZ1pyQStOQzZyZFV5UWV1?=
 =?utf-8?Q?k2Au049+uNZAQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ade0a4e-9c6c-4063-cabf-08d8be869595
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 03:34:11.6147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fa4AygDrm1f7OtgnZpawzGvcTHmr+m6l9Q8iYTCWIesn6ICbrzey5TnSvpfGkgMxav/pYukQH7IewfOwR8OjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3109
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611286460; bh=NiaxLtWn3IWUd91RAROJI8o8evHLAWqZdopN2ZdXWJU=;
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
        b=W+c6FoWBVfeQmA/jmqJL2mIaOBFF4GScTtQlOnGrazn8UypEPhuX/lclFMnLgfcaH
         IfWhcHvfdTzlnWL/vYrE6Ve/yyuhYNYv50lB9WNX7vceMUJNFOtsqUeYHVLyP+mZLV
         QwK6VQsSlEtOkIetNjt9DSf7fTDIexNPph/ExZPdfq8q5He+dwxGTIimWwRVdew+Q9
         EPeHLunGX6n4N9+orYTcEx1TzDsrmSP4SS2NvCjGOu/MrtECkwCZTTllGtDElJh7Wg
         ErnaYPP3HXbBitA8pIufaK8mCORdBWId4BaVd2zez1CLNxL9wUJY4XQSRGo4g+INOE
         45QPUlkV77VSw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFNhbXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwuY29t
Pg0KPiBTZW50OiBGcmlkYXksIEphbnVhcnkgMjIsIDIwMjEgMjoyMyBBTQ0KPiANCj4gT24gMS8y
MS8yMDIxIDEyOjUyIEFNLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBGcm9tOiBQYXJhdiBQ
YW5kaXQgPHBhcmF2QG52aWRpYS5jb20+DQo+ID4NCj4gPiBkZXZsaW5rIHBvcnQgZnVuY3Rpb24g
Y2FuIGJlIGluIGFjdGl2ZSBvciBpbmFjdGl2ZSBzdGF0ZS4NCj4gPiBBbGxvdyB1c2VycyB0byBn
ZXQgYW5kIHNldCBwb3J0IGZ1bmN0aW9uJ3Mgc3RhdGUuDQo+ID4NCj4gPiBXaGVuIHRoZSBwb3J0
IGZ1bmN0aW9uIGl0IGFjdGl2YXRlZCwgaXRzIG9wZXJhdGlvbmFsIHN0YXRlIG1heSBjaGFuZ2UN
Cj4gPiBhZnRlciBhIHdoaWxlIHdoZW4gdGhlIGRldmljZSBpcyBjcmVhdGVkIGFuZCBkcml2ZXIg
YmluZHMgdG8gaXQuDQo+ID4gU2ltaWxhcmx5IG9uIGRlYWN0aXZhdGlvbiBmbG93Lg0KPiA+DQo+
ID4gVG8gY2xlYXJseSBkZXNjcmliZSB0aGUgc3RhdGUgb2YgdGhlIHBvcnQgZnVuY3Rpb24gYW5k
IGl0cyBkZXZpY2Uncw0KPiA+IG9wZXJhdGlvbmFsIHN0YXRlIGluIHRoZSBob3N0IHN5c3RlbSwg
ZGVmaW5lIHN0YXRlIGFuZCBvcHN0YXRlDQo+ID4gYXR0cmlidXRlcy4NCj4gPg0KPiA+IEV4YW1w
bGUgb2YgYSBQQ0kgU0YgcG9ydCB3aGljaCBzdXBwb3J0cyBhIHBvcnQgZnVuY3Rpb246DQo+ID4g
Q3JlYXRlIGEgZGV2aWNlIHdpdGggSUQ9MTAgYW5kIG9uZSBwaHlzaWNhbCBwb3J0Lg0KPiBOb3Qg
Y2xlYXIgd2hhdCBpdCBtZWFucyBieSBjcmVhdGluZyBhIGRldmljZSB3aXRoIElEPTEwIGFuZCBv
bmUgcGh5c2ljYWwNCj4gcG9ydD8NCj4gSSBvbmx5IHNlZSBhIFNGIHdpdGggc2ZudW0gODggaW4g
dGhlIGZvbGxvd2luZyBzdGVwcy4NCj4gPg0KVGhhdCBzdGF0ZW1lbnQgaXMgbm8gbG9uZ2VyIHZh
bGlkLg0KUmVzdCBvZiB0aGUgZXhhbXBsZSBjb3ZlcnMgdGhlIHNmbnVtIDg4IHJlbGF0ZWQgZGV0
YWlscyBhbmQgZXhhbXBsZS4NCg0KPiA+ICQgZGV2bGluayBkZXYgZXN3aXRjaCBzZXQgcGNpLzAw
MDA6MDY6MDAuMCBtb2RlIHN3aXRjaGRldg0KPiA+DQo+ID4gJCBkZXZsaW5rIHBvcnQgc2hvdw0K
PiA+IHBjaS8wMDAwOjA2OjAwLjAvNjU1MzU6IHR5cGUgZXRoIG5ldGRldiBlbnMyZjBucDAgZmxh
dm91ciBwaHlzaWNhbA0KPiA+IHBvcnQgMCBzcGxpdHRhYmxlIGZhbHNlDQo+ID4NCj4gPiAkIGRl
dmxpbmsgcG9ydCBhZGQgcGNpLzAwMDA6MDY6MDAuMCBmbGF2b3VyIHBjaXNmIHBmbnVtIDAgc2Zu
dW0gODgNCj4gPiBwY2kvMDAwMDowODowMC4wLzMyNzY4OiB0eXBlIGV0aCBuZXRkZXYgZXRoNiBm
bGF2b3VyIHBjaXNmIGNvbnRyb2xsZXIgMA0KPiBwZm51bSAwIHNmbnVtIDg4IGV4dGVybmFsIGZh
bHNlIHNwbGl0dGFibGUgZmFsc2UNCj4gPiAgICBmdW5jdGlvbjoNCj4gPiAgICAgIGh3X2FkZHIg
MDA6MDA6MDA6MDA6MDA6MDAgc3RhdGUgaW5hY3RpdmUgb3BzdGF0ZSBkZXRhY2hlZA0KPiA+DQo+
ID4gJCBkZXZsaW5rIHBvcnQgc2hvdyBwY2kvMDAwMDowNjowMC4wLzMyNzY4DQo+ID4gcGNpLzAw
MDA6MDY6MDAuMC8zMjc2ODogdHlwZSBldGggbmV0ZGV2IGVuczJmMG5wZjBzZjg4IGZsYXZvdXIg
cGNpc2YNCj4gY29udHJvbGxlciAwIHBmbnVtIDAgc2ZudW0gODggZXh0ZXJuYWwgZmFsc2Ugc3Bs
aXR0YWJsZSBmYWxzZQ0KPiA+ICAgIGZ1bmN0aW9uOg0KPiA+ICAgICAgaHdfYWRkciAwMDowMDow
MDowMDo4ODo4OCBzdGF0ZSBpbmFjdGl2ZSBvcHN0YXRlIGRldGFjaGVkDQo+ID4NCj4gPiAkIGRl
dmxpbmsgcG9ydCBmdW5jdGlvbiBzZXQgcGNpLzAwMDA6MDY6MDAuMC8zMjc2OCBod19hZGRyDQo+
ID4gMDA6MDA6MDA6MDA6ODg6ODggc3RhdGUgYWN0aXZlDQo+ID4NCj4gPiAkIGRldmxpbmsgcG9y
dCBzaG93IHBjaS8wMDAwOjA2OjAwLjAvMzI3NjggLWpwIHsNCj4gPiAgICAgICJwb3J0Ijogew0K
PiA+ICAgICAgICAgICJwY2kvMDAwMDowNjowMC4wLzMyNzY4Ijogew0KPiA+ICAgICAgICAgICAg
ICAidHlwZSI6ICJldGgiLA0KPiA+ICAgICAgICAgICAgICAibmV0ZGV2IjogImVuczJmMG5wZjBz
Zjg4IiwNCj4gPiAgICAgICAgICAgICAgImZsYXZvdXIiOiAicGNpc2YiLA0KPiA+ICAgICAgICAg
ICAgICAiY29udHJvbGxlciI6IDAsDQo+ID4gICAgICAgICAgICAgICJwZm51bSI6IDAsDQo+ID4g
ICAgICAgICAgICAgICJzZm51bSI6IDg4LA0KPiA+ICAgICAgICAgICAgICAiZXh0ZXJuYWwiOiBm
YWxzZSwNCj4gPiAgICAgICAgICAgICAgInNwbGl0dGFibGUiOiBmYWxzZSwNCj4gPiAgICAgICAg
ICAgICAgImZ1bmN0aW9uIjogew0KPiA+ICAgICAgICAgICAgICAgICAgImh3X2FkZHIiOiAiMDA6
MDA6MDA6MDA6ODg6ODgiLA0KPiA+ICAgICAgICAgICAgICAgICAgInN0YXRlIjogImFjdGl2ZSIs
DQo+ID4gICAgICAgICAgICAgICAgICAib3BzdGF0ZSI6ICJhdHRhY2hlZCINCj4gPiAgICAgICAg
ICAgICAgfQ0KPiA+ICAgICAgICAgIH0NCj4gPiAgICAgIH0NCj4gPiB9DQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+DQo+ID4gUmV2aWV3ZWQt
Ynk6IEppcmkgUGlya28gPGppcmlAbnZpZGlhLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogVnUgUGhh
bSA8dnVodW9uZ0BudmlkaWEuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVk
IDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPHNuaXA+DQoNCg==
