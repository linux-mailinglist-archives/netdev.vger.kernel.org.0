Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4278D461FDA
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345604AbhK2TIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:08:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:16347 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237628AbhK2TGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 14:06:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="233552372"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="233552372"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 11:03:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="600310166"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 29 Nov 2021 11:03:17 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 11:03:17 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 11:03:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 11:03:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 29 Nov 2021 11:03:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/UhQRMiz0uFzhEmv37YCmuWbG1rRmFEm+sfWOTcmZuu+O6fcBOLvfSykrEHnKGshKXIFDV810IqLvBMNgAt08H9RdtI7Ut2ucd8/dlIxIWV9ZXvrVzcKmKbLJ33nYkn5fmXfiRLzbqrvV3tQ7ndkAlVDP0SN7zvJ0vZXMma/PL5OyI69ezk9QZxFPx0y339i6i/uy4SJiYp+reM3StyWmhzDe2HFsSGwqFHJYW/riwyuXWv7YTj9nPgOsrjqnGV5Y5iBUHSs66APiuUjBGMfYGSoOg6HMKsjCkXO8lQ2iYzCAxgWHRYiwV3QpWNAmUAQDMzU1m/Q66k7xqzxIJ6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeCPkIJg6FDImUbht4sBu3Ug628JcUJDGqLYZmZS8wo=;
 b=KHeu5YOa0Eo1RxmhEMbgb9cTDoco8wxj0O/zv8nDKHNl2bESI8AiY9MOFD9qLt0B6j8ZFV+C8xVFVhfDtwteRUxb597Egsn0It6eyZ+cv25raKC4NiTg1/+l6HJvmGqdiNRJhSa4Sp4cCbW5xxnvu1l93CBhjZy5doBoiENTDFitSwv5rSGN2yK7X08DQJCf4tPR3SUCTx/gb4Xo3PX4oqv/A7hNB7s3KZSsU61VWJdshP+0CT+V1dNCyNvmQROnJx35b6BCl0tlGFqp7VzzN94M9H0Rn/qUye6ci6hPfpFAdyoyowXBkGV883/ZQQYxPl0z9RvpOh/RRuKRgMLhPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeCPkIJg6FDImUbht4sBu3Ug628JcUJDGqLYZmZS8wo=;
 b=SOyV+RDyDiBaMbLu3oWk8lBD6364J7zsNQ683ihhZpofoxbGGGEW4sg8tf1uVLfE19jXvpdLgB+o1CEYS/1sMPH8rax1beVCPy83yE0J44Z/970C8UAxJR6FYw5WHx9PY9srCczUcutPdyX/dk1MhNUnSH6BWL3W4kLJs6V3S0s=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4686.namprd11.prod.outlook.com (2603:10b6:806:97::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Mon, 29 Nov
 2021 19:03:15 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 19:03:15 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>
CC:     "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Thread-Topic: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Thread-Index: AQHX2mCW3qOYExLw3UOcMLuBafaes6wWDUaAgASbrwCAAAPogIAAN/UAgAANowA=
Date:   Mon, 29 Nov 2021 19:03:15 +0000
Message-ID: <9948428f33d013105108872d51f7e6ebec21203c.camel@intel.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
         <163700859087.565980.3578855072170209153.stgit@firesoul>
         <20211126161649.151100-1-alexandr.lobakin@intel.com>
         <6de05aea-9cf4-c938-eff2-9e3b138512a4@redhat.com>
         <20211129145303.10507-1-alexandr.lobakin@intel.com>
         <20211129181320.579477-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211129181320.579477-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fa8bd1a-74fa-4ca7-a9cb-08d9b36ae611
x-ms-traffictypediagnostic: SA0PR11MB4686:
x-microsoft-antispam-prvs: <SA0PR11MB46862FBEE60C85E5E2CBABC6C6669@SA0PR11MB4686.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZLfQMdVL5SUAwflq6vW73/3HEWIcy2pnrluzm5gItysBa0lXX1j8enTni/+qxW3FA26wSuWaZ45WEdw0GrP8yVVbtgrdjR6+tR8cgwPgjlr96K+7tkHaD6s90Q66b4wRyj+5Hvr1cM8n+xfyjvRz5DrDmkN+djC+kEoyTbP902aDCa6kG9ffih3Xu1c72s9CMa42wetd50pWv/TfD/jBjMg+sF4Eb+Fu5Q7B1PcjNEHCL3up+68AgsmFm8Q1lHB9AjgddU42gmELViC16TkfWt1N2yPWydPHmiI397NUyPy0wL1zK7peFRRI2Xrph3arwyezIO3dG5o1kpup1Iu7B/cQeOyUqkMmMoZa+o6ufS+ynAxXPxSGiCKNmqrFcGk/9G8XicIuQCrOI9f9YMzpb6ztBjGaip5sFiOXiAEdQz8WUzliLL5cZ/+Kdd40qi8nhQ5dbmgTWkQD8bLtCdbq5DSc7PtI7wlwrCjaATgJyNOYIWWXWmiU14UozvS9n72jQP46vvXchKeSPMHZllk4uKmae1mAvpktPzunxvm964DMWip/2aLmx3ylJh+voSStxp4dbod5CcboSaEGd49bey6ogi/lkDu40JymUyRghf9e1wGk0VmkmZ1NkLP1L0eHSKYwfXFhCMQWxSBA7hcCEZNpL6/3YTENPy8Y/ZoncFMNn1Ca8Vqi+5eJTwEtzOPTjR51dhXnh/EC7Xap8viSyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(66476007)(76116006)(66556008)(71200400001)(26005)(2906002)(122000001)(66446008)(64756008)(316002)(83380400001)(5660300002)(38070700005)(6506007)(6486002)(4326008)(82960400001)(86362001)(186003)(6512007)(54906003)(8936002)(2616005)(110136005)(36756003)(38100700002)(66946007)(4001150100001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGZDckFsd2NiWk5EMnc2THc4Rmt4MDRkVHMzZ1pnWUJjdmlDL0I5MzBEWkJG?=
 =?utf-8?B?NldsLzQ2TXNVczBsRE5Ed3lNdjVkWG9LKzdJUmFsczFURGNYNU12aVdjME5i?=
 =?utf-8?B?ZVdjdjdlZ2pHV2JLT3lDTTBBUnpPYkN0YldneE9rQlVwVk9MT3Rrb1dIYldu?=
 =?utf-8?B?VVFQVWtVanVYZTlWM25vMXp5NUJZZTVYMHpBdi95TkN2eEhiZG90cnA2NFZO?=
 =?utf-8?B?SEV5bndydE5yb3huVzBYcUR6MTE5cEdLWGtueEVpaGh0VHZsWm56MS9tV3Bp?=
 =?utf-8?B?YmxiaTdETmZsL2lvWXpZR3NYVmxyRG1HS01hVUpuUmJJeW1vZmpzRW5UM3FW?=
 =?utf-8?B?T3RWWklITUEzNUJMckFLcHdQN2x0MjEvN1pSR0ZLaytIY1VaRm9PeWdiMGtJ?=
 =?utf-8?B?RC9HVVVZODZYd2VvVitjREs3SzNlS1AzalhQUi9pUjlkRS9IMUZFd1N6TytH?=
 =?utf-8?B?K09aU0Z3V3p4MjdYN3pETXlwNTNqS0VyYk9iZ0hTQjdKQmFaRk9aazZQcS81?=
 =?utf-8?B?V0g4bkozSmtmRE44bjZERzI1eHB1eFBvdjJDQ1lCa2FlRUswUUpFblFMQWdj?=
 =?utf-8?B?TDliL01aTFMzdlVuOWJzUXg0Qy85M29uM3JUUVY5TkhjbVY3V1lMbWZMTUIy?=
 =?utf-8?B?K3hGcjNzMlhxeEh4dXVXSFQ4eUZJY0VhL0J1N2pNRGErYUlONU1XcnRqSzhS?=
 =?utf-8?B?dDVmT0hXZTRHQ3ZhaXM3OFBEazlUMEl6NlF1eCtpS0xjMDdHVGpxZlZjV2Yr?=
 =?utf-8?B?UnJOL2pPaXdKT0ErczlpYnZmb1ZaRVdrMlpuYVlhUGU2SFhOY0dDeW9VQ09r?=
 =?utf-8?B?QTFPa3MxdTlxelVQMUwvTDF4K3NBNFpUY2JlQ216UEU4Tk85ekpZTlo0TmlB?=
 =?utf-8?B?RElsSHdxYXJSL05FZ3dLa1dPQStCQVBrMHhuWU1iTysyTWNSbFNaVThneU1x?=
 =?utf-8?B?NGlFTjlxVU80QWs3VWY0N2FVcitFbTJMcVZTdTgzM0hKdFNsL1l1ZDV5MlNq?=
 =?utf-8?B?dHVBdForaHFHbTVnN0NvZ1JmeEozc2d6a0QyMmZPbVhNNE5xbWtMYUdLSXZk?=
 =?utf-8?B?Z2lpdVdhRVFIM2RTc0tDaUdZSnlKRkZDcWwyMEVFUTVhdTl5TnRDVmRKRVBz?=
 =?utf-8?B?RnZUY0sraUhidGhSbVJ4OXJuSVE2VWRsWVBtZXdHU243SXdiZ00wUVUvS1Rt?=
 =?utf-8?B?MGg2cnBOVlR6SnlUZUdlZHU2YW5MY2ltMUFOczhjeXBOUU5wK3lzZk4vWnpU?=
 =?utf-8?B?RS9JbENmTlVldEU2dEpoWTJoMENya1drQklJWjhBOU43a09SMktMbldramZL?=
 =?utf-8?B?YnFUSWVva0lrQ2YxQXcvMHpxK1JReXZ6eWZSY0EzRkNRT1BqcDNZUHFjekRn?=
 =?utf-8?B?UXpPRFFYeFplU2xjTDNXLzZqbjl2OUZwMTNiTjFESytCSDJVeGtKVWpQSUdq?=
 =?utf-8?B?NnNpTkRjQk44QkJEb2ZldDNvRDlnU1FlUHkySlBrZStURlVZQWNhdGJFbkZu?=
 =?utf-8?B?WlBHenJPdWp6Y1NxNTNhbEpaZXc3QWNBYWd2NzYvcnhxWjI2N0RWWFlBUS8z?=
 =?utf-8?B?OUhMTStCbVhrbVBVNkRmZDJMSkJNVGhXSURCQ3p3ZEVXSXdjeTBVMlRIaXps?=
 =?utf-8?B?a3plRWhZd2g3SjRvTWgxWkYraWhubVQ1RmRtU3lETVpySktSVk9zcmQwT3ZV?=
 =?utf-8?B?anNjbHlQQ09ldGRTay80R25NSzhFbGxBLzBCNWFRYnZHVjNFdVgzNUNuRDYz?=
 =?utf-8?B?Tm4zL3MvQlhHZnNqVHdVL3FCV3d6a25SM2Zzd2RGdEw1QmN0UGplRm90Y2N1?=
 =?utf-8?B?VGRQWXh6TFUyYm91ZnRzSFBmeStmV0dZQ1F4dUl2d0dwSDVzWm1obm13SUhY?=
 =?utf-8?B?Nm5ySnZFVmJmT2xFWDFHdlYrMkxZQnMxSU5RS0M4V3RoNEJWUVBxT253aHJ2?=
 =?utf-8?B?QmNYZi9TbXRiVmRmd1RJUXJTOG11Nk81UWJFcUJ0aEM0NXVNQVBwc0hnY0h5?=
 =?utf-8?B?QmpXVktiZ0xvM3g4Rm5yRzBrazdySDBVYXVtVGhWZDg4eDBqZDlOMjMvZDZT?=
 =?utf-8?B?Y3pZNHFCZ3dHTU9BbDlucnVTd29QTWU4MU9ZT1VBOHhja3lQZFhzQUdtTGZp?=
 =?utf-8?B?TlAvaS80aXN1M3JzM2JTSVF5dTdrZFBSOCt1d0tDK3VURFB0eXNDRFJ0NFN0?=
 =?utf-8?B?WXNPbGVNWmwyL3kzaUcrR0NDWnpFeTEvc2luNXJ5cU9UQzVYWWNMYXFmMkhy?=
 =?utf-8?Q?r7s+Q2H+L5g3jOjL70IPmePf5KGSyXCmCW4BfpSO+M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A62250879B2934469703AD6C5CF20DE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa8bd1a-74fa-4ca7-a9cb-08d9b36ae611
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 19:03:15.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTckxvm5pMYXbvW6EnSo8tbAg9EYZFQUDKpsRJuVKEMkKG23DW8Yip/uiRrcqZ/r7Dl9kRkqWvV09j29Wg7ZYbnHzv7b4I5m/Yp1eEZwEMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4686
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTExLTI5IGF0IDE5OjEzICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToKPiBGcm9tOiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxleGFuZHIubG9iYWtpbkBpbnRlbC5jb20+
Cj4gRGF0ZTogTW9uLCAyOSBOb3YgMjAyMSAxNTo1MzowMyArMDEwMAo+IAo+ID4gRnJvbTogSmVz
cGVyIERhbmdhYXJkIEJyb3VlciA8amJyb3VlckByZWRoYXQuY29tPgo+ID4gRGF0ZTogTW9uLCAy
OSBOb3YgMjAyMSAxNTozOTowNCArMDEwMAo+ID4gCj4gPiA+IE9uIDI2LzExLzIwMjEgMTcuMTYs
IEFsZXhhbmRlciBMb2Jha2luIHdyb3RlOgo+ID4gPiA+IEZyb206IEplc3BlciBEYW5nYWFyZCBC
cm91ZXIgPGJyb3VlckByZWRoYXQuY29tPgo+ID4gPiA+IERhdGU6IE1vbiwgMTUgTm92IDIwMjEg
MjE6MzY6MzAgKzAxMDAKPiA+ID4gPiAKPiA+ID4gPiA+IEVuYWJsaW5nIHRoZSBYRFAgYnBmX3By
b2cgYWNjZXNzIHRvIGRhdGFfbWV0YSBhcmVhIGlzIGEgdmVyeQo+ID4gPiA+ID4gc21hbGwKPiA+
ID4gPiA+IGNoYW5nZS4gSGludCBwYXNzaW5nICd0cnVlJyB0byB4ZHBfcHJlcGFyZV9idWZmKCku
Cj4gCj4gWyBzbmlwIF0KPiAKPiA+ID4gUHJlZmV0Y2ggd29ya3MgZm9yICJmdWxsIiBjYWNoZWxp
bmVzLiBJbnRlbCBDUFVzIG9mdGVuIHByZWZlY3QKPiA+ID4gdHdvIAo+ID4gPiBjYWNoZS1saW5l
cywgd2hlbiBkb2luZyB0aGlzLCB0aHVzIEkgZ3Vlc3Mgd2Ugc3RpbGwgZ2V0IHhkcC0KPiA+ID4g
PmRhdGEuCj4gPiAKPiA+IFN1cmUuIEkgbWVhbiwgbmV0X3ByZWZldGNoKCkgcHJlZmV0Y2hlcyAx
MjggYnl0ZXMgaW4gYSByb3cuCj4gPiB4ZHAtPmRhdGEgaXMgdXN1YWxseSBhbGlnbmVkIHRvIFhE
UF9QQUNLRVRfSEVBRFJPT00gKG9yIHR3byBieXRlcwo+ID4gdG8gdGhlIHJpZ2h0KS4gSWYgb3Vy
IENMIGlzIDY0IGFuZCB0aGUgbWV0YSBpcyBwcmVzZW50LCB0aGVuLi4uIGFoCj4gPiByaWdodCwg
NjQgdG8gdGhlIGxlZnQgYW5kIDY0IHN0YXJ0aW5nIGZyb20gZGF0YSB0byB0aGUgcmlnaHQuCj4g
PiAKPiA+ID4gSSBkb24ndCBtaW5kIHByZWZldGNoaW5nIHhkcC0+ZGF0YV9tZXRhLCBidXQgKDEp
IEkgdHJpZWQgdG8ga2VlcAo+ID4gPiB0aGUgCj4gPiA+IHhkcC0+ZGF0YSBzdGFydHMgb24gYSBj
YWNoZWxpbmUgYW5kIHdlIGtub3cgTklDIGhhcmR3YXJlIGhhdmUKPiA+ID4gdG91Y2hlZCAKPiA+
ID4gdGhhdCwgaXQgaXMgbm90IGEgZnVsbC1jYWNoZS1taXNzIGR1ZSB0byBERElPL0RDQSBpdCBp
cyBrbm93biB0bwo+ID4gPiBiZSBpbiAKPiA+ID4gTDMgY2FjaGUgKGdhaW4gaXMgYXJvdW5kIDIt
MyBucyBpbiBteSBtYWNoaW5lIGZvciBkYXRhIHByZWZldGNoKS4KPiA+ID4gR2l2ZW4gdGhpcyBp
cyBvbmx5IGEgMi41IEdiaXQvcyBkcml2ZXIvSFcgSSBkb3VidCB0aGlzIG1ha2UgYW55Cj4gPiA+
IGRpZmZlcmVuY2UuCj4gPiAKPiA+IENvZGUgY29uc3Rpc3RlbmN5IGF0IGxlYXN0LiBPbiAxMCsg
R2JwcyB3ZSBwcmVmZXRjaCBtZXRhLCBhbmQgSQo+ID4gcGxhbgo+ID4gdG8gY29udGludWUgZG9p
bmcgdGhpcyBpbiBteSBzZXJpZXMuCj4gPiAKPiA+ID4gVG9ueSBpcyBpdCB3b3J0aCByZXNlbmRp
bmcgYSBWMiBvZiB0aGlzIHBhdGNoPwo+ID4gCj4gPiBUb255LCB5b3UgY2FuIHRha2UgaXQgYXMg
aXQgaXMgaWYgeW91IHdhbnQsIEknbGwgY29ycmVjdCBpdCBsYXRlcgo+ID4gaW4KPiA+IG1pbmUu
IFVwIHRvIHlvdS4KPiAKPiBNeSAiZml4dXAiIGxvb2tzIGxpa2UgKGluIGNhc2Ugb2YgdjIgbmVl
ZGVkIG9yIHNvKToKClRoYW5rcyBBbC4gSWYgSmVzcGVyIGlzIG9rIHdpdGggdGhpcywgSSdsbCBp
bmNvcnBvcmF0ZSBpdCBpbiBiZWZvcmUKc2VuZGluZyB0aGUgcHVsbCByZXF1ZXN0IHRvIG5ldGRl
di4gT3RoZXJ3aXNlLCB5b3UgY2FuIGRvIGl0IGFzIGZvbGxvdwpvbiBpbiB0aGUgb3RoZXIgc2Vy
aWVzIHlvdSBwcmV2aW91c2x5IHJlZmVyZW5jZWQuCgpUaGFua3MsClRvbnkKCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jCj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYwo+IGluZGV4IGI1MTZmMWIzMDFiNC4u
MTQyYzU3YjdhNDUxIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ln
Yy9pZ2NfbWFpbi5jCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19t
YWluLmMKPiBAQCAtMTcyNiw3ICsxNzI2LDcgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICppZ2Nf
YnVpbGRfc2tiKHN0cnVjdAo+IGlnY19yaW5nICpyeF9yaW5nLAo+IMKgwqDCoMKgwqDCoMKgwqBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoC8qIHByZWZldGNoIGZp
cnN0IGNhY2hlIGxpbmUgb2YgZmlyc3QgcGFnZSAqLwo+IC3CoMKgwqDCoMKgwqDCoG5ldF9wcmVm
ZXRjaCh4ZHAtPmRhdGEpOwo+ICvCoMKgwqDCoMKgwqDCoG5ldF9wcmVmZXRjaCh4ZHAtPmRhdGFf
bWV0YSk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyogYnVpbGQgYW4gc2tiIGFyb3VuZCB0aGUg
cGFnZSBidWZmZXIgKi8KPiDCoMKgwqDCoMKgwqDCoMKgc2tiID0gYnVpbGRfc2tiKHhkcC0+ZGF0
YV9oYXJkX3N0YXJ0LCB0cnVlc2l6ZSk7Cj4gQEAgLTE3NTYsMTAgKzE3NTYsMTEgQEAgc3RhdGlj
IHN0cnVjdCBza19idWZmCj4gKmlnY19jb25zdHJ1Y3Rfc2tiKHN0cnVjdCBpZ2NfcmluZyAqcnhf
cmluZywKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHNrX2J1ZmYgKnNrYjsKPiDCoAo+IMKgwqDC
oMKgwqDCoMKgwqAvKiBwcmVmZXRjaCBmaXJzdCBjYWNoZSBsaW5lIG9mIGZpcnN0IHBhZ2UgKi8K
PiAtwqDCoMKgwqDCoMKgwqBuZXRfcHJlZmV0Y2godmEpOwo+ICvCoMKgwqDCoMKgwqDCoG5ldF9w
cmVmZXRjaCh4ZHAtPmRhdGFfbWV0YSk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyogYWxsb2Nh
dGUgYSBza2IgdG8gc3RvcmUgdGhlIGZyYWdzICovCj4gLcKgwqDCoMKgwqDCoMKgc2tiID0gbmFw
aV9hbGxvY19za2IoJnJ4X3JpbmctPnFfdmVjdG9yLT5uYXBpLCBJR0NfUlhfSERSX0xFTgo+ICsg
bWV0YXNpemUpOwo+ICvCoMKgwqDCoMKgwqDCoHNrYiA9IG5hcGlfYWxsb2Nfc2tiKCZyeF9yaW5n
LT5xX3ZlY3Rvci0+bmFwaSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIElHQ19SWF9IRFJfTEVOICsgbWV0YXNpemUpOwo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAodW5saWtlbHkoIXNrYikpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gTlVMTDsKPiDCoAo+IEBAIC0yMzYzLDcgKzIzNjQsOCBAQCBzdGF0aWMgaW50
IGlnY19jbGVhbl9yeF9pcnEoc3RydWN0IGlnY19xX3ZlY3Rvcgo+ICpxX3ZlY3RvciwgY29uc3Qg
aW50IGJ1ZGdldCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghc2tiKSB7
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGRwX2lu
aXRfYnVmZigmeGRwLCB0cnVlc2l6ZSwgJnJ4X3JpbmctCj4gPnhkcF9yeHEpOwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhkcF9wcmVwYXJlX2J1ZmYo
JnhkcCwgcGt0YnVmIC0KPiBpZ2Nfcnhfb2Zmc2V0KHJ4X3JpbmcpLAo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWdjX3J4X29mZnNldChyeF9yaW5nKSArCj4gcGt0X29mZnNldCwgc2l6ZSwgdHJ1
ZSk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZ2Nfcnhfb2Zmc2V0KHJ4X3JpbmcpICsKPiBw
a3Rfb2Zmc2V0LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSwgdHJ1ZSk7Cj4gwqAKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBza2IgPSBpZ2Nf
eGRwX3J1bl9wcm9nKGFkYXB0ZXIsICZ4ZHApOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgfQoK
