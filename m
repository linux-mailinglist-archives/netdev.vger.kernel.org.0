Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD43F312D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhHTQK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:10:27 -0400
Received: from mail-oln040093003011.outbound.protection.outlook.com ([40.93.3.11]:14763
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237712AbhHTQJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:09:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY6igOUyzdF0rVBZ2UcB6Ev9ueZEF7QpwENfv6Per5IcgZDPKYTiFXkbxOJEJMnAGLgt+8uo6McgHzrhQ/AdJlaieu1jNYEGjKCAYaz2BLhZ1qYiqRaS93n256s9xVMg2VTEi4L4s98d9JKTwVu+eVIU38Eh7SbbcXtmVM8nEa66A0oaAKmUjOsPYCUTmiQp3mw8OmT4q3r5Y0L3eK0KfwZyKcnMjJYo1CQItX89eY4jkOjosKmTJ9q/zz3woENsE5/JEYjC/Xt+awy44Aoh57BqWALUd5C9zid/yZS4h02OV6qv/E8yq3si9vcrjInA0FlIpzptwQOv79YTh1An8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H0tDeTmwPsXkAmbo0pX2aftdDFEj/VcfEvMEKiOGi4=;
 b=L4lTkr9uiEeQ+H/6GXxv8YnQk83P4J69DIT7GuJaPeXadhWVILDfo430dpH6t2TIk14F8MDFVXaTq6uZjCxiN/RgdKpxYrd1l5gS5O5Jo1Tr3IxXUByqjFEQnpFnINk4HQEpgXPgUQFHx2dA/FjuSRZMpDC7VJSP3Qwqld5q0YY9DZQaWNBC7aiRgfaU+95M/eUAxsfiuWivHEd4w/Ft0HaY/kJ7ljS/WbWyX/C1ODpnpbfG7G5D1QATS9JxWa5JTumM7c4kdNi2gtViFGoPsCrFG1AvH4S20hhEQo9kwqTO/k4NSKmbziDwzdwXyz2MfjEk4sDgCOVUnzdIfpxbWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H0tDeTmwPsXkAmbo0pX2aftdDFEj/VcfEvMEKiOGi4=;
 b=Qo4QhWF7WhFLlT6/ElfXBMMRDGgJzhTnJ0579en7N1NDXqfeCvmbvSXnZ7ginKUHwagg218BMnRMsM1Cl4Htj/W4s79orbnnvZ8MvB9kNeqyx4eTOAn7wPcCo6mP8mOz2d6DAStkuGnWyLeNW/prDhngSaM9P3GriTnfV4Yrxrs=
Received: from CY4PR21MB1586.namprd21.prod.outlook.com (2603:10b6:910:90::10)
 by CY4PR21MB0630.namprd21.prod.outlook.com (2603:10b6:903:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1; Fri, 20 Aug
 2021 16:08:32 +0000
Received: from CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6]) by CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6%8]) with mapi id 15.20.4457.007; Fri, 20 Aug 2021
 16:08:32 +0000
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
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
Thread-Topic: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for
 storvsc driver
Thread-Index: AQHXjUf4MnryDC/QY0a+heAsfHsxAqt3v7VggATTgoCAAAfhIA==
Date:   Fri, 20 Aug 2021 16:08:32 +0000
Message-ID: <CY4PR21MB158664748760672446BFA075D7C19@CY4PR21MB1586.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
 <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <a96626db-4ac9-3ce4-64e9-92568e4f827a@gmail.com>
In-Reply-To: <a96626db-4ac9-3ce4-64e9-92568e4f827a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=17b8e382-57d0-4c83-8b70-e6b9188dc733;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T15:48:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee0201dd-fdff-4203-0104-08d963f4c1f9
x-ms-traffictypediagnostic: CY4PR21MB0630:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB063069C91821DB2B19844FC4D7C19@CY4PR21MB0630.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zhmVJrKlueJP0U4GmOu0PtiGsKg+aF6JDSCxkBOYRH2XVjbEtuYDPVU8ZTR/Y/mwm13CYY/wo/KvDWzLy0bgK+LbADZMaf6V+PscVEOh1J6HFtkXyu2kob7RmgMCFMrzEel5VnPoCNoxLsGIbAYZ1qu3EsPgzKUEC0vOau0z8M61wwRolh3x8tsk/10gwKv71MqOpaXPgAz87nh1TrnVI8HxeVpxg8/osbq7S0cWojFHNH2UNhSIHS5+cYRW3dBkema4u3Rb7755PYw1RzU2VRDgWmAQO7tYRmySgNtMnIeXJD9CkqLjlEAZSTIYCtNuHgRL0RE5XkyivpAsasOevZhOEqEC7k9FwydF15rDNGUIugyoJ75b3PhCDDW3lifGnGPn4Ghq1Vs/eQwVFr2rg9CS+a1RqC30qXip77D248sm16HyO+agl5bZQGQtT0j0w+YrtplCrvX1M+5X2+A4B+tXzA7ZKn4nDOSWx7DG52wNgn+z4OjCE3ZDbsxNVwBw0TuhTkfQlvP28H9FgPMGrDr2T5f3Ql+iGb/LzBoGHJW/Fr1y5jyRcIKPtYsBLwTohp21TfleJbRcRYvVWi1bpko4AEeM4UHQGrrlMJUeVjVNzNl/hWr5/f0AKpVZwLCiB4QDUR/5I3j9HfHka/5cunzjCbck9N80A0x5Cu4hnJZD7Lekimt7PLr+N/7ggVZjb49cidDNQwZrAPkATwU7W9520lbu/NB+wzzWkay/9uE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR21MB1586.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(316002)(8936002)(4326008)(8990500004)(86362001)(83380400001)(71200400001)(10290500003)(66476007)(66556008)(64756008)(110136005)(8676002)(921005)(54906003)(76116006)(186003)(66946007)(66446008)(7416002)(55016002)(2906002)(38100700002)(6506007)(7406005)(9686003)(52536014)(82950400001)(82960400001)(33656002)(7696005)(38070700005)(122000001)(5660300002)(26005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnhQNlFId0pVQkMya0hsdXpYVnJLU3U0blY3RDhORnlhcGt0Vmw0QTN1UGRw?=
 =?utf-8?B?M1Zub0JXcU16TkxCTmMyWXZZV1lOTnExZENEWGU1K3ppMjJSMG1jZ2phU1hv?=
 =?utf-8?B?eGI2dEg5NjNBY1BmSXJ2K3F0dEQxdWVLZnhWcWFKdHo2V3BZU1pVSmlzcUsx?=
 =?utf-8?B?eTB3QkJYYTRYMHBDNjFpSWRJcFFBVHRrMG1QZWxOQldveUp4aGtsSit5OGEw?=
 =?utf-8?B?ZURoM2ZKV0J2N3d4a2xwaEpnTlJaMGNhQnI1SzBpeHljRW15NlBDemU0Qi9q?=
 =?utf-8?B?RTNudG5nNTkyd0gwcmtQOXdDWkM5dFBaL0oxTlp5dkU5SE9SdVVNNER4Mm1s?=
 =?utf-8?B?UG11cFN2dmtMN0xGdHdvd3NYUGU3MDlvcXdDZDl2RE1neEgwL1YxaVZDQi9w?=
 =?utf-8?B?Nk0rMmRtKzZXUnZaUGh1UWtKUjhqcnJTdEorcVMwZ1h5Q1ZNbWNVMFprVWJx?=
 =?utf-8?B?Nnp3ZE5HdEJ1NExKMXcrbnJIRkNML2xvTC9NTWd4cEFLZW54NXp3ckJKYmxJ?=
 =?utf-8?B?NFg5N3UweXIvWk8wV3FUSUJPaXpNaGZ2b0F4cFZZdDFGR2ZRekNKTVpqV041?=
 =?utf-8?B?Z080TVNmb3ozVk1zZUJjTHh5WE1UTHJBdEVwNmhBTGg2K2htZ3NiczEvQUxH?=
 =?utf-8?B?U3cycDRaVXUvVTNXbkVvZXdRS2QwNVZXNEdMT3hOM3FoemlGaElOOEZNQkNm?=
 =?utf-8?B?QlhxdWVGbXdqVnFuMjQ2a1FkTlVlUHdJMlFwdCtUR1l2RDZtNkdyNGYybVdH?=
 =?utf-8?B?aGt5SWNnWDVBZjRlQW81dFpJQjVhd1pFQ1ArTVhIczY2UjYxblJjZlhITkhE?=
 =?utf-8?B?RjlDWmM1NldIM0o0SzdISHhJQ01RaXdmVmZJZkEvRS9UWEJVUFRGZ29FbHNi?=
 =?utf-8?B?anFaUk5nWFB4NnJUelFRcGc2bTZGWmZNNnJ0c2g2Z2wyUE5JMTdtUHFhaEZG?=
 =?utf-8?B?aFdlajRmMk1kNXdMV1c1Z3BwR1hoaFAwMktaVWRIWExWcWlvTjNGNFBTVS9J?=
 =?utf-8?B?RHlpUndsdXZXRkVid2ovRFBxUEhOYkluOGJIREgzbjBCMExUMWw3NW5WWjRl?=
 =?utf-8?B?SDlxaDl0a1hybUxoeEZnOUVrWmpOSlVPVFBNRXoxNS82emU0ZUhUZEVBSmpV?=
 =?utf-8?B?MzVNRW02Q0xwRVh4VjNJSXhlZGVLdTNTZVg5Z1BTUVFoUTVnZkE2cE01UVBk?=
 =?utf-8?B?eFE1dXFaaHVvMFArSERsVkQ0U3drVDZnY1ZSbEVwb1dGcHlNTEVodFJib3Vv?=
 =?utf-8?B?YTZJZHlUVzNkUzYvMDIxaC9PNklxMS9QR1lmU3hGdDVRUk05dFV2b2tHTkhz?=
 =?utf-8?B?V2tGTElLQ0J5L3EzWkZuQVBqR3lNNVJpYzd4VWIrVDlnQ0ZFVVlWQy9tNERx?=
 =?utf-8?B?ZmgvNnFrVklaUnFhTllNdi80emFPWkFBWEV6K3lFSlhocjBCZGpoYjdIcGlD?=
 =?utf-8?B?Q3h3TjE0aXlYaHhSWnBodk5kQ3Q2dkF1RTBFQnM5RzBZbDNTNkp5VnZNQnhR?=
 =?utf-8?B?am95QVVzY09jOVhFclNIbXJhd1RQemFPclZjNjFZNUpmRUNwU3haVXp4Vk0w?=
 =?utf-8?B?TDRjblRoRFJUYzNzVjREdzlCanR6KzdZWEpGdXdJWExlZEc0S2pnNFdZUG1n?=
 =?utf-8?B?cUtmM0pjZWl5MmdSRDI3dmNwTFIvbmtOc05QV3BRaTEyRllDV1lLbFQ4S3M2?=
 =?utf-8?B?N0dyaTZLRFduWWhiWW0zR095UE41N3A5cm1vVDg4Q3BENmwwMnVWQzNGQlVt?=
 =?utf-8?Q?XAeZ88WyfJTO9t5543mrW3/uHlcr6mWfCWtlwgu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR21MB1586.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0201dd-fdff-4203-0104-08d963f4c1f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 16:08:32.4059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xO8fyyaAz65eHLOQzdArWlu4p62qqD+BCCyq5FTn0Dg3XmvvJMiiCKkoljDBB0qwmMkM9akoOwJJiiUDD3YgRw/wF7vTOJc47XNlt5y0Eqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0630
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGlhbnl1IExhbiA8bHR5a2VybmVsQGdtYWlsLmNvbT4gU2VudDogRnJpZGF5LCBBdWd1
c3QgMjAsIDIwMjEgODoyMCBBTQ0KPiANCj4gT24gOC8yMC8yMDIxIDI6MTcgQU0sIE1pY2hhZWwg
S2VsbGV5IHdyb3RlOg0KPiA+IEZyb206IFRpYW55dSBMYW4gPGx0eWtlcm5lbEBnbWFpbC5jb20+
IFNlbnQ6IE1vbmRheSwgQXVndXN0IDksIDIwMjEgMTA6NTYgQU0NCj4gPg0KPiA+IEknbSBub3Qg
Y2xlYXIgb24gd2h5IHBheWxvYWQtPnJhbmdlLm9mZnNldCBuZWVkcyB0byBiZSBzZXQgYWdhaW4u
DQo+ID4gRXZlbiBhZnRlciB0aGUgZG1hIG1hcHBpbmcgaXMgZG9uZSwgZG9lc24ndCB0aGUgb2Zm
c2V0IGluIHRoZSBmaXJzdA0KPiA+IHBhZ2UgaGF2ZSB0byBiZSB0aGUgc2FtZT8gIElmIGl0IHdh
c24ndCB0aGUgc2FtZSwgSHlwZXItViB3b3VsZG4ndA0KPiA+IGJlIGFibGUgdG8gcHJvY2VzcyB0
aGUgUEZOIGxpc3QgY29ycmVjdGx5LiAgSW4gZmFjdCwgY291bGRuJ3QgdGhlIGFib3ZlDQo+ID4g
Y29kZSBqdXN0IGFsd2F5cyBzZXQgb2Zmc2V0X2luX2h2cGcgPSAwPw0KPiANCj4gVGhlIG9mZnNl
dCB3aWxsIGJlIGNoYW5nZWQuIFRoZSBzd2lvdGxiIGJvdW5jZSBidWZmZXIgaXMgYWxsb2NhdGVk
IHdpdGgNCj4gSU9fVExCX1NJWkUoMkspIGFzIHVuaXQuIFNvIHRoZSBvZmZzZXQgaGVyZSBtYXkg
YmUgY2hhbmdlZC4NCj4gDQoNCldlIG5lZWQgdG8gcHJldmVudCB0aGUgb2Zmc2V0IGZyb20gY2hh
bmdpbmcuICBUaGUgc3RvcnZzYyBkcml2ZXIgcGFzc2VzDQpqdXN0IGEgUEZOIGxpc3QgdG8gSHlw
ZXItViwgcGx1cyBhbiBvdmVyYWxsIHN0YXJ0aW5nIG9mZnNldCBhbmQgbGVuZ3RoLiAgVW5saWtl
DQp0aGUgbmV0dnNjIGRyaXZlciwgZWFjaCBlbnRyeSBpbiB0aGUgUEZOIGxpc3QgZG9lcyAqbm90
KiBoYXZlIGl0cyBvd24gb2Zmc2V0DQphbmQgbGVuZ3RoLiAgSHlwZXItViBhc3N1bWVzIHRoYXQg
dGhlIGxpc3QgaXMgImRlbnNlIiBhbmQgdGhhdCB0aGVyZSBhcmUNCm5vIGhvbGVzIChpLmUuLCB1
bnVzZWQgbWVtb3J5IGFyZWFzKS4NCg0KRm9yIGV4YW1wbGUsIGNvbnNpZGVyIGFuIG9yaWdpbmFs
IGJ1ZmZlciBwYXNzZWQgaW50byBzdG9ydnNjX3F1ZXVlY29tbWFuZCgpDQpvZiA4IEtieXRlcywg
YnV0IGFsaWduZWQgd2l0aCAxIEtieXRlcyBhdCB0aGUgZW5kIG9mIHRoZSBmaXJzdCBwYWdlLCB0
aGVuDQo0IEtieXRlcyBpbiB0aGUgc2Vjb25kIHBhZ2UsIGFuZCAzIEtieXRlcyBpbiB0aGUgYmVn
aW5uaW5nIG9mIHRoZSB0aGlyZCBwYWdlLg0KVGhlIG9mZnNldCBvZiB0aGF0IGZpcnN0IDEgS2J5
dGVzIGhhcyB0byByZW1haW4gYXMgMyBLYnl0ZXMuICBJZiBib3VuY2UgYnVmZmVyaW5nDQptb3Zl
cyBpdCB0byBhIGRpZmZlcmVudCBvZmZzZXQsIHRoZXJlJ3Mgbm8gd2F5IHRvIHRlbGwgSHlwZXIt
ViB0byBpZ25vcmUgdGhlDQpyZW1haW5pbmcgYnl0ZXMgaW4gdGhlIGZpcnN0IHBhZ2UgKGF0IGxl
YXN0IG5vdCB3aXRob3V0IHVzaW5nIGEgZGlmZmVyZW50DQptZXRob2QgdG8gY29tbXVuaWNhdGUg
d2l0aCBIeXBlci1WKS4gICBJbiBzdWNoIGEgY2FzZSwgdGhlIHdyb25nDQpkYXRhIHdpbGwgZ2V0
IHRyYW5zZmVycmVkLiAgUHJlc3VtYWJseSB0aGUgZWFzaWVyIHNvbHV0aW9uIGlzIHRvIHNldCB0
aGUNCm1pbl9hbGlnbl9tYXNrIGZpZWxkIGFzIENocmlzdG9wIHN1Z2dlc3RlZC4NCg0KPiANCj4g
Pg0KPiA+PiAgIAl9DQo+ID4NCj4gPiBUaGUgd2hvbGUgYXBwcm9hY2ggaGVyZSBpcyB0byBkbyBk
bWEgcmVtYXBwaW5nIG9uIGVhY2ggaW5kaXZpZHVhbCBwYWdlDQo+ID4gb2YgdGhlIEkvTyBidWZm
ZXIuICBCdXQgd291bGRuJ3QgaXQgYmUgcG9zc2libGUgdG8gdXNlIGRtYV9tYXBfc2coKSB0byBt
YXANCj4gPiBlYWNoIHNjYXR0ZXJsaXN0IGVudHJ5IGFzIGEgdW5pdD8gIEVhY2ggc2NhdHRlcmxp
c3QgZW50cnkgZGVzY3JpYmVzIGEgcmFuZ2Ugb2YNCj4gPiBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMg
bWVtb3J5LiAgQWZ0ZXIgZG1hX21hcF9zZygpLCB0aGUgcmVzdWx0aW5nIGRtYQ0KPiA+IGFkZHJl
c3MgbXVzdCBhbHNvIHJlZmVyIHRvIGEgcGh5c2ljYWxseSBjb250aWd1b3VzIHJhbmdlIGluIHRo
ZSBzd2lvdGxiDQo+ID4gYm91bmNlIGJ1ZmZlciBtZW1vcnkuICAgU28gYXQgdGhlIHRvcCBvZiB0
aGUgImZvciIgbG9vcCBvdmVyIHRoZSBzY2F0dGVybGlzdA0KPiA+IGVudHJpZXMsIGRvIGRtYV9t
YXBfc2coKSBpZiB3ZSdyZSBpbiBhbiBpc29sYXRlZCBWTS4gIFRoZW4gY29tcHV0ZSB0aGUNCj4g
PiBodnBmbiB2YWx1ZSBiYXNlZCBvbiB0aGUgZG1hIGFkZHJlc3MgaW5zdGVhZCBvZiBzZ19wYWdl
KCkuICBCdXQgZXZlcnl0aGluZw0KPiA+IGVsc2UgaXMgdGhlIHNhbWUsIGFuZCB0aGUgaW5uZXIg
bG9vcCBmb3IgcG9wdWxhdGluZyB0aGUgcGZuX2FycnkgaXMgdW5tb2RpZmllZC4NCj4gPiBGdXJ0
aGVybW9yZSwgdGhlIGRtYV9yYW5nZSBhcnJheSB0aGF0IHlvdSd2ZSBhZGRlZCBpcyBub3QgbmVl
ZGVkLCBzaW5jZQ0KPiA+IHNjYXR0ZXJsaXN0IGVudHJpZXMgYWxyZWFkeSBoYXZlIGEgZG1hX2Fk
ZHJlc3MgZmllbGQgZm9yIHNhdmluZyB0aGUgbWFwcGVkDQo+ID4gYWRkcmVzcywgYW5kIGRtYV91
bm1hcF9zZygpIHVzZXMgdGhhdCBmaWVsZC4NCj4gDQo+IEkgZG9uJ3QgdXNlIGRtYV9tYXBfc2co
KSBoZXJlIGluIG9yZGVyIHRvIGF2b2lkIGludHJvZHVjaW5nIG9uZSBtb3JlDQo+IGxvb3AoZSxn
IGRtYV9tYXBfc2coKSkuIFdlIGFscmVhZHkgaGF2ZSBhIGxvb3AgdG8gcG9wdWxhdGUNCj4gY21k
X3JlcXVlc3QtPmRtYV9yYW5nZVtdIGFuZCBzbyBkbyB0aGUgZG1hIG1hcCBpbiB0aGUgc2FtZSBs
b29wLg0KPiANCg0KSSdtIG5vdCBzZWVpbmcgd2hlcmUgdGhlIGFkZGl0aW9uYWwgbG9vcCBjb21l
cyBmcm9tLiAgU3RvcnZzYw0KYWxyZWFkeSBoYXMgYSBsb29wIHRocm91Z2ggdGhlIHNnbCBlbnRy
aWVzLiAgUmV0YWluIHRoYXQgbG9vcCBhbmQgY2FsbA0KZG1hX21hcF9zZygpIHdpdGggbmVudHMg
c2V0IHRvIDEuICBUaGVuIHRoZSBzZXF1ZW5jZSBpcw0KZG1hX21hcF9zZygpIC0tPiBkbWFfbWFw
X3NnX2F0dHJzKCkgLS0+IGRtYV9kaXJlY3RfbWFwX3NnKCkgLT4NCmRtYV9kaXJlY3RfbWFwX3Bh
Z2UoKS4gIFRoZSBsYXR0ZXIgZnVuY3Rpb24gd2lsbCBjYWxsIHN3aW90bGJfbWFwKCkNCnRvIG1h
cCBhbGwgcGFnZXMgb2YgdGhlIHNnbCBlbnRyeSBhcyBhIHNpbmdsZSBvcGVyYXRpb24uDQoNCk1p
Y2hhZWwNCg0KDQo=
