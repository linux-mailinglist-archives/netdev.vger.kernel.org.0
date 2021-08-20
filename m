Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209123F349F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 21:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbhHTTXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 15:23:01 -0400
Received: from mail-oln040093008011.outbound.protection.outlook.com ([40.93.8.11]:6335
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230006AbhHTTW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 15:22:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzodoZrq5U0TGafkMgl8AUuSPyMClQn6jiRFX7PvtZEYAzfyFJAg91NRmvMCdHF9gjjKDrTKUqdaCVd/qsTweTKsOeQWO9WzzYGtb/PHrgTgxDB2iBROuop0APk41vINy0rMZLs01+P0t6T8+4742aBz0MQGENtR5EKY6pJkPqCJTm+pIz6NNffV6PfF564f7linR/Wo5gJKC6RvynVCxHaEsAYVirB4uOC2ZSnsoBT4L94MLXpC9lP5K1qCk5sxm3dJHlj9WS38ZokbqoLa8hGODq4iIR2DE633JzBQ719uhoxpkxPnaG2kh0uShkhZ/aaaIo2e/rKVAfdqZpYS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nijsuRvOJ23nsVmLpYc5DV21YnvuxPrMi13EC1b7neQ=;
 b=V66kKHFWWE3Nue0n2WcgCNCr4/ReSRzOCQSkcMhaO/qSJzCHq15XUN++aPn5lSdW3IhaVwjkB65Kkuk2gCPi3ZPrzRjzYw43VAfKvTW8cHfbe8HMXTcn8JRDysiBIkURfJwyN2yjpc4dU6HSxqdpEs/uzoT2BHlH3OnY6ML10jOo9QuqoCmMs7sgSzprNnIm8M8vbJlmUWlr+5m93K8PAxr6vomcZ/q2Jat0ZkaLydSEBaWA4jOU3vmsTj3W8CgkRBMnC5mQ+TM/ro5njjA/lkxG9od7xgBC8XwhOSeU2sHWLMuwrCTi/Uj2JT70k47rr+Dc+1ahoHyova7457mhxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nijsuRvOJ23nsVmLpYc5DV21YnvuxPrMi13EC1b7neQ=;
 b=GiJdV2HSWswR4HtjJgxNfECN3LcjsqPqHM96HfRNhWTrEDBBUV77LDnL0sgn5uqP7o88fDBa6/RsLsx8Bb99DthqPMpTHKyrjjYch6ZXsDrO/DtznNnrHq36lOC7Rn7+vvKQTf63YSNfDxRvFlq/DqBDNwPh7lLOLYoeNkpU6eA=
Received: from CY4PR21MB1586.namprd21.prod.outlook.com (2603:10b6:910:90::10)
 by CY4PR21MB0280.namprd21.prod.outlook.com (2603:10b6:903:bb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6; Fri, 20 Aug
 2021 19:22:14 +0000
Received: from CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6]) by CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6%8]) with mapi id 15.20.4457.007; Fri, 20 Aug 2021
 19:22:14 +0000
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
Thread-Index: AQHXjUf4MnryDC/QY0a+heAsfHsxAqt3v7VggATTgoCAAAfhIIAAJeaAgAAM0aA=
Date:   Fri, 20 Aug 2021 19:22:14 +0000
Message-ID: <CY4PR21MB158655D98947D66C1C8B80B3D7C19@CY4PR21MB1586.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
 <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <a96626db-4ac9-3ce4-64e9-92568e4f827a@gmail.com>
 <CY4PR21MB158664748760672446BFA075D7C19@CY4PR21MB1586.namprd21.prod.outlook.com>
 <939aa552-5c24-65ee-518d-1cf72867c15d@gmail.com>
In-Reply-To: <939aa552-5c24-65ee-518d-1cf72867c15d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0ba912b1-2bad-45cd-923b-a60bd443d8c3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T18:50:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24d7f675-86d5-41ad-9da2-08d9640fd10e
x-ms-traffictypediagnostic: CY4PR21MB0280:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB02800876B8C69885C5DFD7E5D7C19@CY4PR21MB0280.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLeThGL+2lxj/EfsBL3cZ4P03clXBgcRcqDYtOsesgeRHs5z0qnZdu5fole5HKbixBvEKKPUvHiPtC/V+hsyeQcITyyE4UAKpGMx/IL5XvZ2AvSfRj09DqG/iOaF+TWiZawfbn31pFDAyUC2bn0QczYqcT591GpGn2fx6hDQei1MubCIE626EvuwR6FuD9qZtZgq53j8QCPauBXerLlblsnJqNCR2S7DQcgPUZbIHvHIBHlQ3Tcmr8eA6hDspTX+bCYmEbPYNMl+23H3c/MxrpUpDF5y+VTknxqDQg7Zu+FVd4FbPCC3tMacmAEGMKwAEnjk0xkbT2y7dypMP0G+RzmhcN1TnnLEWeY/mbUYTWfzG3a5rezO7YsgA+K94oMctv1iDykKp6H4ryM8ssC7EbFEYCQqOepKzDYosfyKHLOScume2NhRtD+XFfEKeOAXukPw6giJsqm/M9yVc8eE3xPVl6Z+sNJrq2JtE2dDhAuQNiAP3BTWHVRjPN/HuytJEdKKO3ShioeIbiTWRwQAM/5kjdLZLVCB5aPwcbd+om7oCNlYlyQWL4KofvQlfCCPojpeBdgiY/ICVS8/uh59HPuGNPtGlUwbbT3xoZMuSHgPYrxA9j1Y0pW6ngCt+U5xTIYHjnoWuKom4T7CygQb//w1/um+WcbjQbPTcwct1/yp8xlD38m2vFJVkgzuDw7rsmaznkbvocmsEsqgUH3fADFAqRyO9eO9yLmrVSwa000=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR21MB1586.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(316002)(26005)(86362001)(55016002)(54906003)(33656002)(82950400001)(122000001)(8676002)(4326008)(53546011)(64756008)(110136005)(9686003)(38100700002)(8936002)(38070700005)(71200400001)(10290500003)(7406005)(8990500004)(66476007)(7416002)(76116006)(186003)(6506007)(52536014)(66446008)(5660300002)(921005)(7696005)(2906002)(82960400001)(508600001)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZC85ZUI4Yll0clhJWFBURFF2dzFZV3RvZnJqM1MzakFJMExVNUlaUXE2U3lK?=
 =?utf-8?B?VDN5Um5nWUZqUEE5L2ErbFlWV0Q2MjV6Slg0UE1aWi9SMk9Tc0dKUmFIZ3Bs?=
 =?utf-8?B?b2Iya3dyWEVJUVozdnRPQkZZeU9ZV2t3K0N6cjNiQ3MzM2RjUVhEUzVyRzgz?=
 =?utf-8?B?QjJjRE9BbmowNjA3WTFlQTdSeVZlVko0dlBUU3R3cTFaQjJKclVnaVJtV005?=
 =?utf-8?B?aHd2Q29pKzRsMTRYZTROc1VEcndaeDdyenFGKzBIU0NTRXEyQXM0R3ByWTQv?=
 =?utf-8?B?di83V1NScXU0UDdpUHd2SVVKdUN6VW1FOEdUd0JDV0ZBMFRlN2tZTkJEWEE2?=
 =?utf-8?B?a3pKM1J1eEkrMXNWUnFYeXc3aTIwTVhsTUgvR1BORjNTN2orS1luZVh0RGxv?=
 =?utf-8?B?VUMzSnk1UHhMRWpJdWdqbStGdU5KYTJzRUJVd0tlTy91SURDYml3bXVTYzFS?=
 =?utf-8?B?V1ZGSjAyNnpIR2ZMQW11RnEwMElWdTlxWDB5eDl2Tm9DcEtvdGVJdWFyUGVL?=
 =?utf-8?B?M0tYTjFUWTE5S3dVYnBJUHkrU0VzMHhPNG9iM3hUcXhYdzhpWjVVVzZxRFNJ?=
 =?utf-8?B?OGdLeklBVDBlbVNhY1NzMFZ6RVhIMnFQZ0xkNFZ4RkYyWHp0WkdROE9uWEhy?=
 =?utf-8?B?SjRDcEh2UC9YYzJYalBGRkxPZGVVMjhXVmtoc21rbWVNaWozZ3UraU1iNG1Y?=
 =?utf-8?B?blYyU2szcXF3SllPcHFSNk54dC9NbEhQRlBQRDA5d2RZUWI5SFhJcHEyMitZ?=
 =?utf-8?B?OFEzYm9Tc1pDL1VHeFBLQjVZZEJzTlkzSVk1aVBkZXNHaldKTkdLWVU1djNR?=
 =?utf-8?B?NU5oYy9FdEkyQmdrUFVzWkFzQnlYU2ZrMmRnUCtmTDhPMW44cVV5ckt1S3dX?=
 =?utf-8?B?YnBLQllqaEozeS9RTTEvM0pSV3kvcDh6bjZPdzNTeUZFcHZiL2Q1TFc1SlVU?=
 =?utf-8?B?aENkZkRxMWVHVEJRNlk3YmVYeEh0RXBJa0FIYmdCanBDc2pIMXhFQnhsWDFt?=
 =?utf-8?B?K1RNME1hOHFvV2xhWmFjYTZrdmFLTWJMaUhyMUZja0h1YWcxQks2SHJpR1hI?=
 =?utf-8?B?QlAzWXk2T1FIaUtsYzJKa21NQjFLWGc2MStNRGZGOGJZb1FxM0IxTFp1U29I?=
 =?utf-8?B?MCtJQVJBQkhhblovRkw5ZUVnOEY2U2NNemlrdnM1UisxQXZNUWs4M0ZRd216?=
 =?utf-8?B?Q05HN0tCTHk1cWNCbHZsY0xReXdrTk5yL1A2cnVQaUFyakdkTlhpV0pMTGVz?=
 =?utf-8?B?Vk8wa3ExTE5sWDdieXdBbDhPUllTQ1lHMG50NjdTVzFPU3pSSCtmbnk1UDhP?=
 =?utf-8?B?R1lPMUNhTll3S0ZhZlNNajVkZ1ozWlhxRjVGMHd1RFN3Qk9yMEJHQkZaVU5u?=
 =?utf-8?B?Q1pYNGpmbVRxYXRhRFFsekJFUEZpSXpWY2hNcGs4ZjBBN2o0VURPaURrSmtW?=
 =?utf-8?B?Uk5UZS9USWQ1S0N2MnFmQ2kzODZhNC9JUE1yODNsdmhQTnlUQXFXa1ZYeFdC?=
 =?utf-8?B?R2orRHF2M3Y3NklnS1hLQ2RyUXJ1MXp1S0U5L0V1Q3RqdFBrU1Qrc1owaThi?=
 =?utf-8?B?YkdoUWR4QWRNRDNoS0ZsN0pNbDlRVE84UGw3YVl2ZnlvRmdlY3Vmb0gvYnNR?=
 =?utf-8?B?WStCS2xPRUZKd1VnMXhrcHBXR3pFRjJMVHJGOEgrVUVwVEh3NlhkS1dVV0or?=
 =?utf-8?B?ejZncVNXV1U3UG90YTFNZ0hzeHM1S20zSkd3OVdvMVRkejJWUTE3ZFpUenVW?=
 =?utf-8?Q?F5mEVZ5P0anxObU2dpBW71v9BSvqYRNsTcNtsaA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR21MB1586.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d7f675-86d5-41ad-9da2-08d9640fd10e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 19:22:14.1800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SqILgPuiapj/MmCXfScJLA4Yxao5XWu94HGgwVOQddBGv82AAtJ/bdPhIpcF/8pyCvwycQ7Cx9YBLaMFf5240xBLw1rztk2dS0qJTi/QGYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0280
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGlhbnl1IExhbiA8bHR5a2VybmVsQGdtYWlsLmNvbT4gU2VudDogRnJpZGF5LCBBdWd1
c3QgMjAsIDIwMjEgMTE6MDQgQU0NCj4gDQo+IE9uIDgvMjEvMjAyMSAxMjowOCBBTSwgTWljaGFl
bCBLZWxsZXkgd3JvdGU6DQo+ID4+Pj4gICAgCX0NCj4gPj4+IFRoZSB3aG9sZSBhcHByb2FjaCBo
ZXJlIGlzIHRvIGRvIGRtYSByZW1hcHBpbmcgb24gZWFjaCBpbmRpdmlkdWFsIHBhZ2UNCj4gPj4+
IG9mIHRoZSBJL08gYnVmZmVyLiAgQnV0IHdvdWxkbid0IGl0IGJlIHBvc3NpYmxlIHRvIHVzZSBk
bWFfbWFwX3NnKCkgdG8gbWFwDQo+ID4+PiBlYWNoIHNjYXR0ZXJsaXN0IGVudHJ5IGFzIGEgdW5p
dD8gIEVhY2ggc2NhdHRlcmxpc3QgZW50cnkgZGVzY3JpYmVzIGEgcmFuZ2Ugb2YNCj4gPj4+IHBo
eXNpY2FsbHkgY29udGlndW91cyBtZW1vcnkuICBBZnRlciBkbWFfbWFwX3NnKCksIHRoZSByZXN1
bHRpbmcgZG1hDQo+ID4+PiBhZGRyZXNzIG11c3QgYWxzbyByZWZlciB0byBhIHBoeXNpY2FsbHkg
Y29udGlndW91cyByYW5nZSBpbiB0aGUgc3dpb3RsYg0KPiA+Pj4gYm91bmNlIGJ1ZmZlciBtZW1v
cnkuICAgU28gYXQgdGhlIHRvcCBvZiB0aGUgImZvciIgbG9vcCBvdmVyIHRoZSBzY2F0dGVybGlz
dA0KPiA+Pj4gZW50cmllcywgZG8gZG1hX21hcF9zZygpIGlmIHdlJ3JlIGluIGFuIGlzb2xhdGVk
IFZNLiAgVGhlbiBjb21wdXRlIHRoZQ0KPiA+Pj4gaHZwZm4gdmFsdWUgYmFzZWQgb24gdGhlIGRt
YSBhZGRyZXNzIGluc3RlYWQgb2Ygc2dfcGFnZSgpLiAgQnV0IGV2ZXJ5dGhpbmcNCj4gPj4+IGVs
c2UgaXMgdGhlIHNhbWUsIGFuZCB0aGUgaW5uZXIgbG9vcCBmb3IgcG9wdWxhdGluZyB0aGUgcGZu
X2FycnkgaXMgdW5tb2RpZmllZC4NCj4gPj4+IEZ1cnRoZXJtb3JlLCB0aGUgZG1hX3JhbmdlIGFy
cmF5IHRoYXQgeW91J3ZlIGFkZGVkIGlzIG5vdCBuZWVkZWQsIHNpbmNlDQo+ID4+PiBzY2F0dGVy
bGlzdCBlbnRyaWVzIGFscmVhZHkgaGF2ZSBhIGRtYV9hZGRyZXNzIGZpZWxkIGZvciBzYXZpbmcg
dGhlIG1hcHBlZA0KPiA+Pj4gYWRkcmVzcywgYW5kIGRtYV91bm1hcF9zZygpIHVzZXMgdGhhdCBm
aWVsZC4NCj4gPj4gSSBkb24ndCB1c2UgZG1hX21hcF9zZygpIGhlcmUgaW4gb3JkZXIgdG8gYXZv
aWQgaW50cm9kdWNpbmcgb25lIG1vcmUNCj4gPj4gbG9vcChlLGcgZG1hX21hcF9zZygpKS4gV2Ug
YWxyZWFkeSBoYXZlIGEgbG9vcCB0byBwb3B1bGF0ZQ0KPiA+PiBjbWRfcmVxdWVzdC0+ZG1hX3Jh
bmdlW10gYW5kIHNvIGRvIHRoZSBkbWEgbWFwIGluIHRoZSBzYW1lIGxvb3AuDQo+ID4+DQo+ID4g
SSdtIG5vdCBzZWVpbmcgd2hlcmUgdGhlIGFkZGl0aW9uYWwgbG9vcCBjb21lcyBmcm9tLiAgU3Rv
cnZzYw0KPiA+IGFscmVhZHkgaGFzIGEgbG9vcCB0aHJvdWdoIHRoZSBzZ2wgZW50cmllcy4gIFJl
dGFpbiB0aGF0IGxvb3AgYW5kIGNhbGwNCj4gPiBkbWFfbWFwX3NnKCkgd2l0aCBuZW50cyBzZXQg
dG8gMS4gIFRoZW4gdGhlIHNlcXVlbmNlIGlzDQo+ID4gZG1hX21hcF9zZygpIC0tPiBkbWFfbWFw
X3NnX2F0dHJzKCkgLS0+IGRtYV9kaXJlY3RfbWFwX3NnKCkgLT4NCj4gPiBkbWFfZGlyZWN0X21h
cF9wYWdlKCkuICBUaGUgbGF0dGVyIGZ1bmN0aW9uIHdpbGwgY2FsbCBzd2lvdGxiX21hcCgpDQo+
ID4gdG8gbWFwIGFsbCBwYWdlcyBvZiB0aGUgc2dsIGVudHJ5IGFzIGEgc2luZ2xlIG9wZXJhdGlv
bi4NCj4gDQo+IEFmdGVyIGRtYV9tYXBfc2coKSwgd2Ugc3RpbGwgbmVlZCB0byBnbyB0aHJvdWdo
IHNjYXR0ZXIgbGlzdCBhZ2FpbiB0bw0KPiBwb3B1bGF0ZSBwYXlsb2FkLT5ycmFuZ2UucGZuX2Fy
cmF5LiBXZSBtYXkganVzdCBnbyB0aHJvdWdoIHRoZSBzY2F0dGVyDQo+IGxpc3QganVzdCBvbmNl
IGlmIGRtYV9tYXBfc2coKSBhY2NlcHRzIGEgY2FsbGJhY2sgYW5kIHJ1biBpdCBkdXJpbmcgZ28N
Cj4gdGhyb3VnaCBzY2F0dGVyIGxpc3QuDQoNCkhlcmUncyBzb21lIGNvZGUgZm9yIHdoYXQgSSdt
IHN1Z2dlc3RpbmcgKG5vdCBldmVuIGNvbXBpbGUgdGVzdGVkKS4NClRoZSBvbmx5IGNoYW5nZSBp
cyB3aGF0J3MgaW4gdGhlICJpZiIgY2xhdXNlIG9mIHRoZSBTTlAgdGVzdC4gIGRtYV9tYXBfc2co
KQ0KaXMgY2FsbGVkIHdpdGggdGhlIG5lbnRzIHBhcmFtZXRlciBzZXQgdG8gb25lIHNvIHRoYXQg
aXQgb25seQ0KcHJvY2Vzc2VzIG9uZSBzZ2wgZW50cnkgZWFjaCB0aW1lIGl0IGlzIGNhbGxlZCwg
YW5kIGRvZXNuJ3Qgd2FsayB0aGUNCmVudGlyZSBzZ2wuICBBcmd1YWJseSwgd2UgZG9uJ3QgZXZl
biBuZWVkIHRoZSBTTlAgdGVzdCBhbmQgdGhlIGVsc2UNCmNsYXVzZSAtLSBqdXN0IGFsd2F5cyBk
byB3aGF0J3MgaW4gdGhlIGlmIGNsYXVzZS4NCg0KVGhlIGNvcnJlc3BvbmRpbmcgY29kZSBpbiBz
dG9ydnNjX29uX2NoYW5uZWxfY2FsbGJhY2sgd291bGQgYWxzbw0KaGF2ZSB0byBiZSBjaGFuZ2Vk
LiAgIEFuZCB3ZSBzdGlsbCBoYXZlIHRvIHNldCB0aGUgbWluX2FsaWduX21hc2sNCnNvIHN3aW90
bGIgd2lsbCBwcmVzZXJ2ZSBhbnkgb2Zmc2V0LiAgU3RvcnN2c2MgYWxyZWFkeSBoYXMgdGhpbmdz
IHNldCB1cA0Kc28gdGhhdCBoaWdoZXIgbGV2ZWxzIGVuc3VyZSB0aGVyZSBhcmUgbm8gaG9sZXMg
YmV0d2VlbiBzZ2wgZW50cmllcywNCmFuZCB0aGF0IG5lZWRzIHRvIHN0YXkgdHJ1ZS4NCg0KCWlm
IChzZ19jb3VudCkgew0KCQl1bnNpZ25lZCBpbnQgaHZwZ29mZiwgaHZwZm5zX3RvX2FkZDsNCgkJ
dW5zaWduZWQgbG9uZyBvZmZzZXRfaW5faHZwZyA9IG9mZnNldF9pbl9odnBhZ2Uoc2dsLT5vZmZz
ZXQpOw0KCQl1bnNpZ25lZCBpbnQgaHZwZ19jb3VudCA9IEhWUEZOX1VQKG9mZnNldF9pbl9odnBn
ICsgbGVuZ3RoKTsNCgkJdTY0IGh2cGZuOw0KCQlpbnQgbmVudHM7DQoNCgkJaWYgKGh2cGdfY291
bnQgPiBNQVhfUEFHRV9CVUZGRVJfQ09VTlQpIHsNCg0KCQkJcGF5bG9hZF9zeiA9IChodnBnX2Nv
dW50ICogc2l6ZW9mKHU2NCkgKw0KCQkJCSAgICAgIHNpemVvZihzdHJ1Y3Qgdm1idXNfcGFja2V0
X21wYl9hcnJheSkpOw0KCQkJcGF5bG9hZCA9IGt6YWxsb2MocGF5bG9hZF9zeiwgR0ZQX0FUT01J
Qyk7DQoJCQlpZiAoIXBheWxvYWQpDQoJCQkJcmV0dXJuIFNDU0lfTUxRVUVVRV9ERVZJQ0VfQlVT
WTsNCgkJfQ0KDQoJCXBheWxvYWQtPnJhbmdlLmxlbiA9IGxlbmd0aDsNCgkJcGF5bG9hZC0+cmFu
Z2Uub2Zmc2V0ID0gb2Zmc2V0X2luX2h2cGc7DQoNCg0KCQlmb3IgKGkgPSAwOyBzZ2wgIT0gTlVM
TDsgc2dsID0gc2dfbmV4dChzZ2wpKSB7DQoJCQkvKg0KCQkJICogSW5pdCB2YWx1ZXMgZm9yIHRo
ZSBjdXJyZW50IHNnbCBlbnRyeS4gaHZwZ29mZg0KCQkJICogYW5kIGh2cGZuc190b19hZGQgYXJl
IGluIHVuaXRzIG9mIEh5cGVyLVYgc2l6ZQ0KCQkJICogcGFnZXMuIEhhbmRsaW5nIHRoZSBQQUdF
X1NJWkUgIT0gSFZfSFlQX1BBR0VfU0laRQ0KCQkJICogY2FzZSBhbHNvIGhhbmRsZXMgdmFsdWVz
IG9mIHNnbC0+b2Zmc2V0IHRoYXQgYXJlDQoJCQkgKiBsYXJnZXIgdGhhbiBQQUdFX1NJWkUuIFN1
Y2ggb2Zmc2V0cyBhcmUgaGFuZGxlZA0KCQkJICogZXZlbiBvbiBvdGhlciB0aGFuIHRoZSBmaXJz
dCBzZ2wgZW50cnksIHByb3ZpZGVkDQoJCQkgKiB0aGV5IGFyZSBhIG11bHRpcGxlIG9mIFBBR0Vf
U0laRS4NCgkJCSAqLw0KCQkJaHZwZ29mZiA9IEhWUEZOX0RPV04oc2dsLT5vZmZzZXQpOw0KDQoJ
CQlpZiAoaHZfaXNvbGF0aW9uX3R5cGVfc25wKCkpIHsNCgkJCQluZW50cyA9IGRtYV9tYXBfc2co
ZGV2LT5kZXZpY2UsIHNnbCwgMSwgc2NtbmQtPnNjX2RhdGFfZGlyZWN0aW9uKTsNCgkJCQlpZiAo
bmVudHMgIT0gMSkNCgkJCQkJPHJldHVybiBlcnJvciBjb2RlIHNvIGhpZ2hlciBsZXZlbHMgd2ls
bCByZXRyeT4NCgkJCQlodnBmbiA9IEhWUEZOX0RPV04oc2dfZG1hX2FkZHJlc3Moc2dsKSkgKyBo
dnBnb2ZmOw0KCQkJfSBlbHNlIHsNCgkJCQlodnBmbiA9IHBhZ2VfdG9faHZwZm4oc2dfcGFnZShz
Z2wpKSArIGh2cGdvZmY7DQoJCQl9DQoNCgkJCWh2cGZuc190b19hZGQgPSBIVlBGTl9VUChzZ2wt
Pm9mZnNldCArIHNnbC0+bGVuZ3RoKSAtDQoJCQkJCQlodnBnb2ZmOw0KDQoJCQkvKg0KCQkJICog
RmlsbCB0aGUgbmV4dCBwb3J0aW9uIG9mIHRoZSBQRk4gYXJyYXkgd2l0aA0KCQkJICogc2VxdWVu
dGlhbCBIeXBlci1WIFBGTnMgZm9yIHRoZSBjb250aWd1b3VzIHBoeXNpY2FsDQoJCQkgKiBtZW1v
cnkgZGVzY3JpYmVkIGJ5IHRoZSBzZ2wgZW50cnkuIFRoZSBlbmQgb2YgdGhlDQoJCQkgKiBsYXN0
IHNnbCBzaG91bGQgYmUgcmVhY2hlZCBhdCB0aGUgc2FtZSB0aW1lIHRoYXQNCgkJCSAqIHRoZSBQ
Rk4gYXJyYXkgaXMgZmlsbGVkLg0KCQkJICovDQoJCQl3aGlsZSAoaHZwZm5zX3RvX2FkZC0tKQ0K
CQkJCXBheWxvYWQtPnJhbmdlLnBmbl9hcnJheVtpKytdID0gaHZwZm4rKzsNCgkJfQ0KCX0NCg==
