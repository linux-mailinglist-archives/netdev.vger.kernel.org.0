Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E7D4204FB
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 04:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhJDClx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 22:41:53 -0400
Received: from mail-bn1nam07on2137.outbound.protection.outlook.com ([40.107.212.137]:38384
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230295AbhJDClw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 22:41:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbYkrmNI6K8Q+OuzrLQrAieBcIaOl7f8jegU3Lq1cVOWsAZMRVpAJq1tF8j8nujcwH/5iRqNLq4lq80mUMXe8ii7GYvaD74UDnPnsx+qVB48hRmANaHROhbBWBuO5ado0CkA3tAMvAK3rZkBcpB7YWaMPloXld5Zd+GBZG5KCAzTNTUMDY1erSrxbCKpDDPa6pAFyQosGSZI+D4C0xafCXxjn6FfokjN1/GgBEZmV7M7L7lPvJu51rLcYfoHO8BtcxOK84F3TWSooyvrJluS/SPT23cuq4BXYssqyUL7sAnn06lslWg1YQRQqBqpug0Eh/3KG2Mcmp1EOGEhYzLJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qifDXBMTC+dUrWywhHdHNhRndkwTVS0vdhohTgvFoFA=;
 b=kH5DirZMCAIGaxEtPed/WpBwbRRNqXmpjQaS1xpjkIJhOaMTBUPRvkNzVvpdN76Xm3AbnyYxdYSwtS5v0EfFe30F4md040EzzTfHbWR1U8fD36FOfXPOfyPdvvdsFegBqkyPBXRmXAaREfQ5ddi+j5Rnb+j5TvAl5OEyLmp50SsQdbPhxZIrk0rCUwxGn5hyhiW8aSoX3HdSsXM0QRq0mR02aD8pVZQ15Ds8S4li4fEvcufS1tNHQvlwSS896hod9ECkCWLl/G9xqCBM2K1WWc8QoNL7AqljZsMfBCRSkTxBs0oJ6p7Xk459taNX8bQ33yvxYk+oJTiVVXESXK8uyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qifDXBMTC+dUrWywhHdHNhRndkwTVS0vdhohTgvFoFA=;
 b=I48bFDKWNKDV/1fUdSsHTl2GOhWiuzFx9lX4d0fmruaeq0v50Og02UXoC/ZFGCDSZuWAafP31CywByKThCAkqEwBdy/4tUIzKyeK268Uc4MF1fhZWm3wRfZjQ4fnOiC5EBsjmALOt3IEmUMAMi42FrmhM1eKlOKyMPTNP/gR+bk=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0285.namprd21.prod.outlook.com (2603:10b6:300:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1; Mon, 4 Oct
 2021 02:39:58 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::6129:c6f7:3f56:c899%4]) with mapi id 15.20.4587.017; Mon, 4 Oct 2021
 02:39:52 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate message
Thread-Topic: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus
 channel initiate message
Thread-Index: AQHXt5tug0WMgbP5AE2oqpJIPfrMMavCIl5g
Date:   Mon, 4 Oct 2021 02:39:51 +0000
Message-ID: <MWHPR21MB159300A5BB5146AD54684954D7AE9@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-8-ltykernel@gmail.com>
 <MWHPR21MB15933BC87034940AB7170552D7AC9@MWHPR21MB1593.namprd21.prod.outlook.com>
 <1c31c18d-af76-c5af-84f1-0dafe48f8605@gmail.com>
In-Reply-To: <1c31c18d-af76-c5af-84f1-0dafe48f8605@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e527f072-604a-4e75-9684-2e4a8b2cacf9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-04T02:37:36Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a1676f6-d574-4628-33b1-08d986e03e8f
x-ms-traffictypediagnostic: MWHPR21MB0285:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB02853B7FC819A00D0ABD1BADD7AE9@MWHPR21MB0285.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ffWXCNPDv+PymDLevPlpUnLKEObwBvbpKDien1Kk8P6ZTUn6tr6ROfagHXUEyNVyJ4T+XLOxXbmjNVZiP3w/Qu6ZRv6/V8VrzXqsm2/mvCb1Rv7n5GTJ22+DkETAtfjFGL7DIHJlORYqYh8zsNkddxX46bcZKyjdvi9r+2nx7HxCK+S2MpUBkjYpadMF8GGdDMA6T3GwHTxGIp/o0r6rrzZPH2CQ1YZox+Ce1Jj58iQEzN9UyNtJW6DZrAfLrR1nCmt2L++sPYoYkIkfDfc9GGrn2zXRvjby4iuQ6TQUVwZkB2XL1YNCwWoDphkyNUZ/BPjsd0ZbmWYOiFqFLX8WQvTUpW7L5JS6pqbJdK+MaCOCexZfZOkCT7ZqMQY6SYR+RLU1ExvZNJbu0iB218eg96ZMte/19GykPMKfuYoz7OrZzLlDvphcphONerLx1IkXL3VOcxsSpBqR4zM2IfUvRur6n9+UlsY+JR5mLXFVeQMMd0/qaM8bjL45PrSGJQ+80FmydEaYg7eYBHqtAzLRLVsLzcs4kuIZF4nyeCg/J8AEhB8HGXa8zpffQeO9b6TbVYZuPVGgYTKnYxCZy146lGetXUvglJjbQ0j+Jb1sXc2s3NWR1XDttbnDGhvIzqAQuT5F6yoV+/Xmqe6ladE4CbSbgIALe3ijKW8q3nBh7ZvESP8fIn1PaADA58aqzJBuPEwDH0pvjwNP1ScQ0ZFjQYlENr9jcBG7MUWl3gNh+4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8676002)(4326008)(86362001)(66476007)(66556008)(66446008)(64756008)(38070700005)(76116006)(921005)(82960400001)(82950400001)(66946007)(186003)(5660300002)(7416002)(7406005)(2906002)(122000001)(38100700002)(8936002)(33656002)(55016002)(6506007)(7696005)(52536014)(53546011)(26005)(110136005)(508600001)(71200400001)(8990500004)(10290500003)(9686003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUJPV1RCVC83WHAxQU1NclZxMHQzdURjY2U5d1RxeVRpSDMyaWFWZnVVc2tt?=
 =?utf-8?B?SDJNclg0NG1oNmxnRmp3T1pkZEFkZlVURisrYWVmdHFXblNUL2Qrb2ptTEU5?=
 =?utf-8?B?czRLNjg3a2FiWnpXUTlQRjgzbEFSL0hTZUpUMGl0NTczUVZFbnlrNzRrczNH?=
 =?utf-8?B?MHRTSlRkWFpQVjFYTFEwTVhUNC93RXJUSXIwOWROUHdGa3pzWnZ4ZnFFTVpN?=
 =?utf-8?B?M3ZESlVpdlFGd2JYdnZhY2hkeUhmVWdmL3F4ZEJseEdGRE1uaDlhaS9xT3dj?=
 =?utf-8?B?YkpGdWtySnFnYzhKbHF1eFR0a1JENnlzZjVRc09IWWZ1MXo4MlRuYkNrVlRs?=
 =?utf-8?B?ZTMyeitpUUVkVXJGMlBNNlpQZS8rLzJySGwyVVczNWtDcWhya0VhTnJTbHYw?=
 =?utf-8?B?ZzhIbGh1N2JOZElZOUFPNHBXckFoeTlaVVIvdkxKK1VLTDhweEs2NUR6eHJF?=
 =?utf-8?B?YWdUbG5GTEIvM2g0WllYM0N1V3JPcU5rSERoQnZhSHVrK0pHQ010eHhSSTZ1?=
 =?utf-8?B?KzJKNlA2ZW9FTnBYOCtlWUM1RjBKb1ZuZittem9UbWFRNWM0UVlVQmRKV29Y?=
 =?utf-8?B?WDdVZzNZS0hVeTFoQWJIaUo5c0crdjN6VHRKQlJlRWZSaVVJeWF5aUI0R2dS?=
 =?utf-8?B?eTF2Q3dPRTZ5SlNwRTh1ZnVpeHppM0kxODViVG9sZFdydnQ3ckxYTjZxRVZk?=
 =?utf-8?B?Q1B1SkVId3d1OWZzdVFWSm1mZWQ2MjhtWXhjbys5dXZzUzJkU2NPSVdUQ1Yx?=
 =?utf-8?B?MWtiUk1ieUZHaEtUSjZEQTJIMXJWcW81TVp3NGJPc2gwd2VETkJEV29icVB3?=
 =?utf-8?B?bFJacUQzSzc3ckJIcENSdVlKMnY3R1hNc0N5amRHSnVDRkFDd29qQkw5WUZX?=
 =?utf-8?B?SjZPMDN4TWNFYjl3SVl3L01peExydjFPakp1N1I1TVBFVEhGMkIwV0dyRXdt?=
 =?utf-8?B?ZkFrbHc5WTY0OVJPdlZmZkNGK1V3M3hvQjlTSktINGNEaVRwMW56UUgrTXpG?=
 =?utf-8?B?OUQwNnFCQXZUN1BwQzVqWG5FY1FUNzVnNkhIVDJjbVBrV1NoNDdoNitpTmFk?=
 =?utf-8?B?R043RHdNS2lkU3hzT2pYM1JVcEI5Ym9wL0xCK0tmL1NGVFV4K3Q0STN4Tjl0?=
 =?utf-8?B?OWUzT2NmcVRyTHdPTFNvSGI4Y2dJN0s0Z29jcWNMYWo4RDlpSElBeVcvT2sy?=
 =?utf-8?B?THgyZGdjRkVmMkFtbXpSaDhhSll3N0RQSkVqVVZ0MmFyZTl5MWVxU1ZSTnZJ?=
 =?utf-8?B?VUpSZzNGc1cyTGZwblR1YlFuYXBjL3VhZ3VOcHVodExSd05tSUZkKzJsV3RN?=
 =?utf-8?B?ZFVCSy9CK3NXaUdXS1RmT3hFZFFNZU1qQnUvNUpoYm5jdmdYOGtWSGtTdURo?=
 =?utf-8?B?Z2xVMjlVWTgrMmJ1MXBLSGdLTzJ2c21MWC81R2dUeEduOTNRTmNxeWlCamZ4?=
 =?utf-8?B?K0FkTjlxbnpKR0lxMWxpSFgwL05ma3VuWWpLY2pBRjNUWTJxQVBwbDNnK2RQ?=
 =?utf-8?B?QTBDTElVTWtCd1lvRUR2aXpiVWUvQ3pZQ3R3Y2V2RHBRRjhXc3U0cWlvU0Jm?=
 =?utf-8?B?TE1iMm14YVgwa2RnUFYza3JxTlIwd2V6d2V3ancweEJXMGcrUDV0TFNvc1Bk?=
 =?utf-8?B?aUxWS2p5ZzJ2ZkREWnlWQVpwR1pqdXIrUEhZdm56TDdBblNHMGhNVzJRZUoz?=
 =?utf-8?B?U1NXYUJ3am9OUTlqQ012TlV4WXMvNkVFY21DRUNUR3BqMFJTSkZPUHFSb0lz?=
 =?utf-8?Q?SVA+euqmUmn6SytgXZQsYIL+fKmaNtFTNAL8ToU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1676f6-d574-4628-33b1-08d986e03e8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 02:39:51.5292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zDx/MFgpm1pF11WR5vZOtGKe1gS8UQp8UhXunl02IO+gH8tlk8wPysuYESPblmNJYtNA16PuRXPuhT0RAMIckZcJdT8kDd9PJ0vdk175LCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGlhbnl1IExhbiA8bHR5a2VybmVsQGdtYWlsLmNvbT4gU2VudDogU2F0dXJkYXksIE9j
dG9iZXIgMiwgMjAyMSA3OjQwIEFNDQo+IA0KPiANCj4gT24gMTAvMi8yMDIxIDk6MjYgUE0sIE1p
Y2hhZWwgS2VsbGV5IHdyb3RlOg0KPiA+PiBAQCAtMzAzLDEwICszNjUsMjYgQEAgdm9pZCB2bWJ1
c19kaXNjb25uZWN0KHZvaWQpDQo+ID4+ICAgCQl2bWJ1c19jb25uZWN0aW9uLmludF9wYWdlID0g
TlVMTDsNCj4gPj4gICAJfQ0KPiA+Pg0KPiA+PiAtCWh2X2ZyZWVfaHlwZXJ2X3BhZ2UoKHVuc2ln
bmVkIGxvbmcpdm1idXNfY29ubmVjdGlvbi5tb25pdG9yX3BhZ2VzWzBdKTsNCj4gPj4gLQlodl9m
cmVlX2h5cGVydl9wYWdlKCh1bnNpZ25lZCBsb25nKXZtYnVzX2Nvbm5lY3Rpb24ubW9uaXRvcl9w
YWdlc1sxXSk7DQo+ID4+IC0Jdm1idXNfY29ubmVjdGlvbi5tb25pdG9yX3BhZ2VzWzBdID0gTlVM
TDsNCj4gPj4gLQl2bWJ1c19jb25uZWN0aW9uLm1vbml0b3JfcGFnZXNbMV0gPSBOVUxMOw0KPiA+
PiArCWlmIChodl9pc19pc29sYXRpb25fc3VwcG9ydGVkKCkpIHsNCj4gPj4gKwkJbWVtdW5tYXAo
dm1idXNfY29ubmVjdGlvbi5tb25pdG9yX3BhZ2VzWzBdKTsNCj4gPj4gKwkJbWVtdW5tYXAodm1i
dXNfY29ubmVjdGlvbi5tb25pdG9yX3BhZ2VzWzFdKTsNCj4gPiBUaGUgbWF0Y2hpbmcgbWVtcmVt
YXAoKSBjYWxscyBhcmUgbWFkZSBpbiB2bWJ1c19jb25uZWN0KCkgb25seSBpbiB0aGUNCj4gPiBT
TlAgY2FzZS4gIEluIHRoZSBub24tU05QIGNhc2UsIG1vbml0b3JfcGFnZXMgYW5kIG1vbml0b3Jf
cGFnZXNfb3JpZ2luYWwNCj4gPiBhcmUgdGhlIHNhbWUsIHNvIHlvdSB3b3VsZCBiZSBkb2luZyBh
biB1bm1hcCwgYW5kIHRoZW4gZG9pbmcgdGhlDQo+ID4gc2V0X21lbW9yeV9lbmNyeXB0ZWQoKSBh
bmQgaHZfZnJlZV9oeXBlcnZfcGFnZSgpIHVzaW5nIGFuIGFkZHJlc3MNCj4gPiB0aGF0IGlzIG5v
IGxvbmdlciBtYXBwZWQsIHdoaWNoIHNlZW1zIHdyb25nLiAgIExvb2tpbmcgYXQgbWVtdW5tYXAo
KSwNCj4gPiBpdCBtaWdodCBiZSBhIG5vLW9wIGluIHRoaXMgY2FzZSwgYnV0IGV2ZW4gaWYgaXQg
aXMsIG1ha2luZyB0aGVtIGNvbmRpdGlvbmFsDQo+ID4gb24gdGhlIFNOUCBjYXNlIG1pZ2h0IGJl
IGEgc2FmZXIgdGhpbmcgdG8gZG8sIGFuZCBpdCB3b3VsZCBtYWtlIHRoZSBjb2RlDQo+ID4gbW9y
ZSBzeW1tZXRyaWNhbC4NCj4gPg0KPiANCj4gWWVzLCBtZW11bWFwKCkgZG9lcyBub3RoaW5nIGlz
IHRoZSBub24tU05QIENWTSBhbmQgc28gSSBkaWRuJ3QgY2hlY2sgQ1ZNDQo+IHR5cGUgaGVyZS4g
SSB3aWxsIGFkZCB0aGUgY2hlY2sgaW4gdGhlIG5leHQgdmVyc2lvbi4NCj4gDQo+IFRoYW5rcy4N
Cj4gDQoNCkkgd291bGQgYWxzbyBiZSBPSyB3aXRoIGp1c3QgYWRkaW5nIGEgY29tbWVudCB0byB0
aGF0IGVmZmVjdCwganVzdCBzbyBzb21lb25lDQpsb29raW5nIGF0IHRoZSBjb2RlIGluIHRoZSBm
dXR1cmUgdW5kZXJzdGFuZHMgdGhhdCB0aGVyZSdzIG5vdCBhIHByb2JsZW0uDQpZb3VyIGNhbGwu
DQoNCk1pY2hhZWwNCg0K
