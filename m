Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E843E511
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhJ1P20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:28:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:37698 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJ1P20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:28:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="217610210"
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="217610210"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 08:25:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="538072466"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 28 Oct 2021 08:25:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 28 Oct 2021 08:25:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 28 Oct 2021 08:25:56 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 28 Oct 2021 08:25:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kONZgnKyG1f3+Kwg7eMsA54uoTTJmf8dvg74BbPYdgUOHDvj/AkzG6rSR8Iip2CfZPEgj52KGal4jwrzeH71V/qMnlWl72e+FqGcN+M/zhT+Ri8Y06yjXxso7TEy9el3xQcewVvhUjU+BZZdIVUYsO+dWbrCFDwn4FuwrxHxbLo6DOj4k5liJWExkhbjFd8jF++EcGFOWm7PizjpZFLtUwk6Lku2T6PdbmOwvpFPHGmeEZeLfuLWTbZmQPNcW/n2NXun4yadCL/5yt6KUryPyFRB9gP7v2jAd5IsTf0IG0gB7B96lGRXe2U2Tfw5E6qoDjEMM6RMnxKPNE55i195pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVdsEO/8x//8XsAvN+szEg9hSywDb8S51frfXHot5ig=;
 b=gh+ECyLjmd/dUZqtGnkZzYzhYAyYprMyLTxr+HC8n3dl1AUCoSvEiG5Zs3fcMh6otP3KD3s80LKXthEYAjQVDmclEr58bncURbjx32fguGgxypckgSx6Muup+5I1GMjjuTUrybSPjD9TFGJYJN0DyH7VFzF+/CRxLSk+TA7tYzF+JZUUKoSlsWYTmxh6cIXysgboPgo2PrJfXmy32rftb4lRuL5EnKQfkSbq5mKvUUkMktQ0eHARGDfFOm9e1PRlGvGP5TvWcACnLDgzvAJ7vm3hLNVt/YYj5KXuFC/qqS0OjtGjFn4VW3eTGQN4ahN/uwvDCOFaWCpsO2ip94Ahxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVdsEO/8x//8XsAvN+szEg9hSywDb8S51frfXHot5ig=;
 b=HMPfg/U3GKHlY0DkGRQS7rD++ozyI8qHLeNGjidKC86mcKFjLtOGoqBkPHjU4hhUDCXPSEDHuIP45V08ecGDcRwh941eou8dis/uCAN7dDPkQa+AIbskIITZCh2CMg0ttA+/NlE85aYSdoPsLojXaHFnmIBdhh/hT3lGhs64+1Y=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5082.namprd11.prod.outlook.com (2603:10b6:806:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 15:25:56 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4628.018; Thu, 28 Oct 2021
 15:25:55 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "jan.kundrat@cesnet.cz" <jan.kundrat@cesnet.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Brelinski, Tony" <tony.brelinski@intel.com>
Subject: Re: [PATCH net-next 3/4] igb: unbreak I2C bit-banging on i350
Thread-Topic: [PATCH net-next 3/4] igb: unbreak I2C bit-banging on i350
Thread-Index: AQHXycm5yfWVXhnuGkCyIIwsWruCXqvnDF0AgAF/0IA=
Date:   Thu, 28 Oct 2021 15:25:55 +0000
Message-ID: <bd6dc27167a3bb143772d2ef114de7bf4242aee9.camel@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
         <20211025175508.1461435-4-anthony.l.nguyen@intel.com>
         <20211027093036.3c60a207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211027093036.3c60a207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9534ab02-0d84-45cb-25c1-08d99a273c84
x-ms-traffictypediagnostic: SA2PR11MB5082:
x-microsoft-antispam-prvs: <SA2PR11MB50824CDA4C5AF73F90364ECFC6869@SA2PR11MB5082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFh+CeI88BUHHGglNoXiGYgn/sXif5OMSmM2Cq5K5V7KwxtUy/z2sKu5zm81R1r5IMr9wi92Ybtk6KuRxaaRcTF/cw1xouC6SAsdXYMMq9BenKxboMRR5BqUy1RH34IORC852jTEw6tMKFZlKzecXkx1IJMOXHR6zgjjzGsuVwGO9zJ25ZLHLhZzdBVhkK9Tgp9oCiPrnOAyd+R7OEU0vof862mRM9pIdI8wcE3CPFF5LcPMM8AkeszPAyZZlOQ9gLND5MILH4k8GKfqHNsF6VYj7/1Vu2EveXfKKgGHuIwUlCeSnZrT3cdHUxWNvKviUPfAQ92CqXi9JW2bjXBwRsFx9T6eDt2zNoxMXtMKYb37Liq7hklsIRN5LKaCjRe8rpsVLqM9eZ+RRTY5fUL5xnVQNmOY6EruJ20lY7ZKCff3dnLOB904F18m7uYD86nofHB0i52gSMCcVdvupuv6aSPkzEg1ZzVU+OXPdPFD4aCr/T0l6m0I1lCSWb5Vhyi/OzHXmR8GmYffUI5T6oQ9aomV6YROH7n3QomzUw2vC7ovGB59tCU9HPePrvrYa5ouLb8z91U3etuxdOtztTfTmIHQNWjdlx5Li1zRDjoAN4mveM0v62Yw84O6/Q/3UNf2tFGbNKb0/4zHWqhJqnteae1vvH/O3Lq30Vk2U6g3dziSGOHG8PbiiJN4Hu2aAGEfT40o7wRkRv4YldzTfDkyFNUZ3x+5U5OTLqCv1tKo0nc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66476007)(38100700002)(2906002)(107886003)(6486002)(64756008)(66946007)(82960400001)(122000001)(38070700005)(6506007)(86362001)(66556008)(4001150100001)(54906003)(4326008)(316002)(76116006)(66446008)(36756003)(4744005)(186003)(71200400001)(2616005)(6916009)(26005)(8676002)(5660300002)(508600001)(8936002)(6512007)(91956017)(187633001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STJMMUdjbmdVNkNHbHVLdFVidk5saDkvc2o4R0xXK21iUmNzYzR1MjIzMnNr?=
 =?utf-8?B?STRFK2xBeW1aNGdOYnZTR3Z1UjRmQnVqZmk2WHpmY090UFNGTFlhUnRySE5J?=
 =?utf-8?B?ZVpSYTBNMmpNeXc0U1pmUFZTdStSelE1Y2l1djVDNlNJQXBnNllSalNqMmNM?=
 =?utf-8?B?QTlBTUNjVkNVWXdsUEl1UlIyN2tUNlYyZFI2RnQ0ZjZaZ2RlODJKaE4xczJR?=
 =?utf-8?B?cHBiUC9PMVVua0lLRnBDU2dxOVlCcjJ2MFUyUDhxQ2tQV09JVmN0b2J2MG9z?=
 =?utf-8?B?a3FEVXhON1NXN3F6REl4SzArYlZyZG9lb3lOdEt0Uy9xclFTMm5Ta3hwMFgw?=
 =?utf-8?B?bUpkazhpajEvbThOWlBsbWY0TklmdXN5VWZQaUhoVWs2MDNBMml3L0ZFUkh1?=
 =?utf-8?B?bHZRRzdPL3AzMTlJc2lkdmxCOUgvWm5XL0srZWVMRmJQWG5FU2QwZFZxOTR3?=
 =?utf-8?B?QUVEdlMycW9sWlNCTFUwTisyV1ZQK1M3TkFDZnQxVE9XVmwxZzBQQTZMekI4?=
 =?utf-8?B?NTZaUlZ5cTdoYlJGOWJZMlZlVHpOWHhIcXVJZ2tGWTMxSnZIRUUzcVdaUDR4?=
 =?utf-8?B?em1xZVFiNUlhMG0rVWYxTm85bWNzK1pZQWFJekxvL3N5b2l6YzRoZG9JNlZS?=
 =?utf-8?B?czduNFZ0ek50TEZ3K01aQ24vSndnbFJsaGxGYmlybjNZdDZVblRBVXVrVFcv?=
 =?utf-8?B?Ny8rdDlYQzlETUdLTmpic3FTcW5KUjd4Z3hQckRBUkwza2pVWUEyQ3J5Tkxv?=
 =?utf-8?B?WXlTOFlDV0ZWbGcvWG5SMnhyQXZFYU9rMk8yQ3ZWSXlQeTR1ZVNLQkF0U0dk?=
 =?utf-8?B?cWJ6MmJLc1VKbUN2OEJpV1dJNXdqQkVuMVBYOFl0K0ZNRHFwTlpjOTJYLzhu?=
 =?utf-8?B?U2NMOWtIaGlyTXBrbW5UeHEyS2JDc0UxT2lBdWtxYlJxUUJMV1JkSlFZT0VX?=
 =?utf-8?B?OFlWZFEvcU92bWdMa3FackhMaDJTck5LekxjMzdreTlCZVFpVXFXanlEV1VZ?=
 =?utf-8?B?b21IU05IWVVTZy9vYWIwRWJ3ZE1MUG93MGFxaWI5enF4aXhucjVkeDB2eW1J?=
 =?utf-8?B?UEJSUWpldndyTGRzY21XSDR1R2xSRGo5cFFkYnFqK3lhV1VZUlEwRWNMbWd5?=
 =?utf-8?B?c3FMTGRPWjYvays2UURhUDhuK1FBNXBtbDUreTdmZW5WMEFtSDF6SkE3SUIx?=
 =?utf-8?B?cVlYbkpRV01KUmJuSTBNc3ZQVmNXeW5RMTlPeVJKMDVzZ01BOXRrajMvRlNp?=
 =?utf-8?B?N0NUZ3ZwdEJDZ1l4MTdTRUJjTFhJbE0ycG1RalkvVzNyOGNpQ1crUDJVcGZu?=
 =?utf-8?B?SXBjSUZzMnc2NUpKckZ3aDBkOG1veUZaR3dwVUNXTzZNWGdQdmxmRHZrQUli?=
 =?utf-8?B?eHByRUtPdy9mb25CQ0JpcGd2UU9kcWJwb1dVQW05N3lkTlJZM3hYMmo3KzZF?=
 =?utf-8?B?eExzdWQxQlFRempJUklqNTkxbXhIZ29CNHZwL3ZjV21JODZlaE1yMnZBYldS?=
 =?utf-8?B?NUlEcG1Bazk4ZU9ZcTdPNEZlSEcvZlRmT3puWFdydCtBMnljVU40cWVFYmNy?=
 =?utf-8?B?Mlg0UVB6c0lDZ0k0QkgxZ0FJY0NXRnlucGJyd2Y5NmFFa0YrQkVPbFdSWXgx?=
 =?utf-8?B?TkdrUVlGNjJEZzF4Q0NqQ25YRzhTb2wyZmYwMHJpdHpMdGdtWHhJZjUvVlhw?=
 =?utf-8?B?eUpDMkFveFFFQkdsQjJVRGNtZ1Y3aU5BcW5TNlBBTStGSG80bHQ1WmxJSHRK?=
 =?utf-8?B?SUdPS1B2Q0RLMzAzNnc3VHd6Q1g2dzRKYmxDYWtBSHdyMXVuMUJYMjR3Qkl3?=
 =?utf-8?B?V0pYL0VGME9WbWVDRldXS0VQc3dzQUVyZm1vSXovMjM1WktHWkpYRmlsN1M4?=
 =?utf-8?B?ZFVkUFRlT3NXVTJCVzg3THdHR0JpUEtzN0lSbk5qMEZuejJxRm9SZ1Jib1BL?=
 =?utf-8?B?dUFYbXBNWG9RUTFCaE8wV0Y3OVphNzlOY1htbU4zaFhTaWZnU0ZtbHVVMDhK?=
 =?utf-8?B?UFBDR05DczFKbmdab3J4V3dzTUVweWc0OENWODdLR3VJK2RPRlhlYStDNW82?=
 =?utf-8?B?NENBRHhMTzkzM0o1cjJIeUxoaUdDNkQxZkpOODkyajFNdklFR2pDRXN0VkNN?=
 =?utf-8?B?YXBhRlFYVWRub1RWVk94cmhVYWpnZXd2UUFZZ3RLUldWbWhRWmdqT0p2T1FI?=
 =?utf-8?B?ZGxPTk53UDR3Y2pFOU9GNXVFYkcreCtWWmtLYytIc3JQM1R2ODgzMnp2UmdX?=
 =?utf-8?Q?yI40lXhjczwa+sJjrkL218gb0JpXQILluLQXFYVKp8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBF557E35D0A0A4EA177A404C54FB360@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9534ab02-0d84-45cb-25c1-08d99a273c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 15:25:55.8531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kinwahm0CrfsHF9NlI8I9PHBF3xqwG6MYiVbDe5iNshjWdp/LXfoAamdZX2KWJiAMT2hVHRlgAtbAuj9TUIxhtvzQJPx/rHxoYycnYnrN00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEwLTI3IGF0IDA5OjMwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyNSBPY3QgMjAyMSAxMDo1NTowNyAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBKYW4gS3VuZHLDoXQgPGphbi5rdW5kcmF0QGNlc25ldC5jej4NCj4gPiANCj4g
PiBUaGUgZHJpdmVyIHRyaWVkIHRvIHVzZSBMaW51eCcgbmF0aXZlIHNvZnR3YXJlIEkyQyBidXMg
bWFzdGVyDQo+ID4gKGkyYy1hbGdvLWJpdHMpIGZvciBleHBvcnRpbmcgdGhlIEkyQyBpbnRlcmZh
Y2UgdGhhdCB0YWxrcyB0byB0aGUNCj4gPiBTRlANCj4gPiBjYWdlKHMpIHRvd2FyZHMgdXNlcnNw
YWNlLiBBcy1pcywgaG93ZXZlciwgdGhlIHBoeXNpY2FsIFNDTC9TREENCj4gPiBwaW5zDQo+ID4g
d2VyZSBub3QgbW92aW5nIGF0IGFsbCwgc3RheWluZyBhdCBsb2dpY2FsIDEgYWxsIHRoZSB0aW1l
Lg0KPiANCj4gU28gdGFyZ2V0aW5nIG5ldC1uZXh0IGJlY2F1c2UgdGhpcyBuZXZlciB3b3JrZWQ/
DQoNCkNvcnJlY3QuIFdvdWxkIHlvdSBwcmVmZXIgSSBzZW5kIHRoaXMgcGF0Y2ggdmlhIG5ldCBp
bnN0ZWFkPw0KDQpUaGFua3MsDQpUb255DQo=
