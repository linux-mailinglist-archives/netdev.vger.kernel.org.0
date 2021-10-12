Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5A42A8DF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbhJLPzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:55:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:26841 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236864AbhJLPzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:55:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="214339883"
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="214339883"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 08:53:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="562727662"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Oct 2021 08:53:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 08:53:49 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 08:53:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 08:53:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 08:53:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJ3lQSkWBl5zmlw5lFRTPetMUeLzYZhIlAv6GgcToChySWwD0KgxDSjGjap+ZafYdGJ10OpJmTpjKu/ZBU6c+0Dc+6fk+kl6NJgLLwzU+fWB1PdAEzZjsVQ87HpKJGfjRipt9hj42EZCets3ZyAnKJKfUlTqL7IK1BpeEcWZCGeKJE7YKby+EE12qMzM30EmEFks6zKTDrK3fQsdTz+HQgOy4ao2Itz8XVfL4e0qxqYc4wWls47L3D3OfynheUdTupQ80Ns1qAiVHaJ2skKlwDVbrLHNKzS/dvTAxk5yj7vsPnLaeCrLxhCENH5yenMyW+eRx+oIi7ARkh0NpckczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=revrV2fWtOAM2jjsfSXYC2FwxDE0HN6tgaGeK2LLBe0=;
 b=CeCj5j8f89xLL1gztNd7XDmG/69uZJMp4kaZFNfFKitG1L5TDSat63Btw4oCf3cvEu4hCS7y6KG8iNaVILHCRhYmmuZIquAIzWqIhnuZHj4/7W8mQsDt1wFF8SqjzTecwpDlbtfmjCDXvOhPQ94Gy0b/Eh3SPmq8xsKDkLym+19eKp1zwz4xTL+hyq5xHpefy8wxRGITxTYiKonjJAPWFYWRVasm/l9t6AESKoDdi+AAp7cHwjQw9kMH2vii8CgAmVvNvRTMCgqsSkPLZsiMBSDRRUkH1Nd6sRcKkaIaRwudVQL8FVAFIW04dCpwEK4xzm+nIIh6ZdLrWgRGbJYzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=revrV2fWtOAM2jjsfSXYC2FwxDE0HN6tgaGeK2LLBe0=;
 b=T/scI5QX+31k7hvpuVukb9khtirGSm+PAM1vWqJdvTjE3d7EUwJQDYFSjPTzxX++TFmn0um2dE3RcsRk778h0y3iOe8z/3aMPwiYDy5KE+I0CB+S+bHwEyLYHbcwZ56lBy435pJGCTCkucUAu+ZKJPYaFjSRr4LH+qPbBp8/jSw=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4656.namprd11.prod.outlook.com (2603:10b6:806:96::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Tue, 12 Oct
 2021 15:53:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 15:53:45 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel.hbk@gmail.com" <kernel.hbk@gmail.com>
Subject: Re: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Thread-Topic: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Thread-Index: AQHXurJDllAcgwigi0aH336iMitVMqvF8UMAgAmZQgCAAAF0AIAAAMoA
Date:   Tue, 12 Oct 2021 15:53:45 +0000
Message-ID: <1228c09032a2cabc4b11b3a1e78f1b5da3eb1f49.camel@intel.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
         <YV2f7F/WmuJq/A79@bullseye>
         <CAA0z7By8Rz+3dqMF8_WXRZuvG7K_Mrgm209Zpsk6C0urG1cOnA@mail.gmail.com>
         <20211012084904.73c8453a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012084904.73c8453a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 157212cc-bce0-457d-3bed-08d98d9878e2
x-ms-traffictypediagnostic: SA0PR11MB4656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4656BF3A7BFCF34C87270340C6B69@SA0PR11MB4656.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TXQDfXhB/MhGbrstuVL7e1KdhSn6kHQ6zHLdaW7zaNX6n6O59ENrCPRY5Ks+ejjRox/TMVr8QPjyE1tSQP/4JUsaIu/f5/xObqN8s8ku1pyPGYfI4OPgXW/LVFi+qyybNmL4d5DwkwdBGKjiQFwfHlCyKGqATJeyPRUZzoZ//PfGoP0Jf+RvNfHxFxb0p5ixqdzg7qa7LCqnwViTT+rzZadQfkKT4tt6Vtoml3TRqmihAA2o7nX6o9lBV86f+anM5Q4v6LRWLBAg+LQbvCHR8sKtoOu89DxfzGDeNuhQ0y/xY4Ou13Ghxp5QcRHHP5C1cZNAlfyir5rqNCRc8czFJW/PNJIp/8TEg9Sb9MjV0cdgWVuq6uf9P7V0TkkrNt8s+xAIdaWQUSTL5+haEPhlsqY/jKJ3N22kr6oniAtTPtIVk/pCWZKzs1Bwx74l1Y4OuDftkWtdmkiWx7cDAyYTKEaY991XmGqUeXWVyVqCbHxTx7c3xuFUmSaKorrqUUKRQHsIRhj/arhKCluPjytpTW9Fk1pkWCVlrA17iQO8YH6BD0kDccUroTlcqGZLhQdutYVrs3/ShX2/XgvlFiauCLU/jE8Q+ADQWwiztUFJCWaWyaU4RUhblvq8fquvVifN7eeNf6ftSIdCr6se+iUp5AkWuR0qtZ4AGyhYsGWeaXcs4081VRez2cvaS9ATlVjNokslcZD8dpvz+iyq9EzgYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66476007)(66946007)(66446008)(53546011)(64756008)(186003)(38070700005)(26005)(6636002)(36756003)(91956017)(71200400001)(76116006)(66556008)(2616005)(6512007)(4744005)(8936002)(54906003)(316002)(38100700002)(110136005)(122000001)(6486002)(6506007)(508600001)(86362001)(8676002)(5660300002)(4326008)(4001150100001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVZwT3kySllnbVF6b2N2QVVDMFlKbkNUUTNhc05BWmV1aFdRUCtYdExxUS8v?=
 =?utf-8?B?d25yRXRGZ1dCeGRVbFZjNEMwRy82WFp6bWNxWVBMbzZyZHFMcjdaWHlGb05a?=
 =?utf-8?B?V3BHTGVpNGdqT3M3S09iWTJmZFNHZFIrTHlzNUJFZnlmK0NnbzZnOExkV1V0?=
 =?utf-8?B?cHllVE9Xa1lKUmpYL1NOOE5ZbHNFaFNScWo5RWI5Wmw3ZWFHczc3dFVpbmdL?=
 =?utf-8?B?dk9nZ0pZRWk3YmQ2NWZaS3BUNEdkTCs5WnlJdWtHWUFzSENUR0pFV3Q2U0FI?=
 =?utf-8?B?WXpwaHNubGNiRUhRdzZLZTdKSEVpL3J1eW1pcXovcTV4V3c3RGoyUE9VN1Vu?=
 =?utf-8?B?bWpaMDB1L2pJNzF0eWtKNkpsQ1l4RmtFWnRCcTRJQ0VOTDI1SFdwSmVvZDdl?=
 =?utf-8?B?SGl4ZWMrMFBESUh3RytyQlpSaWNWbW5HME1DeWVpUnVlbG95ZXVGakZpN0E0?=
 =?utf-8?B?Qnl2OTBDcGc0SXhPY1NBYzE5eFNKVFFXVloxV1JFaXdWVnpuOGFHU0dkdzhy?=
 =?utf-8?B?eDFxc0p1THNHY1EyMTFna1FMbXhKNGc5bTNxSGFRTlZkRnZNYWJJd010WW5N?=
 =?utf-8?B?UFVUbHBjSmthMGdKK3hzdEtXUlFvanpUNXhnYWJnOVpIM3AramJJSzlkSjFN?=
 =?utf-8?B?S05oTVo3aXhFZzB0aGhJNXA1eDJTOUovNkF0S3NoOXcrVERSWTBZYmplbnZ6?=
 =?utf-8?B?WDV6YWFTSWNJZXBDTEpCN1hmcFdCRGZSSkhEWFZzSUcxZlIramlhbkwzWnkw?=
 =?utf-8?B?YnByb0ZvZCtTK2ZqRUJzdWdLSFVyU2Evdy8xWU05dThKUU1QdDlpVG9LNWtn?=
 =?utf-8?B?bWMxcGFiZjFkdGxEUG9xSVFZWXV6a1dNN2luRjlMaVR4QmpmMDNXQ0F0UlB6?=
 =?utf-8?B?eEpWRUhaZStMTzJBTGdPR3RQRjljazd1elNmQzY0bm5OZ3NyNVJqckRGUWdG?=
 =?utf-8?B?dW9hcHRzU2ZiMTZOSlRtcW5GWkFER2tBVkNmcVhqMy9sd0cvaTVMUEpMVkty?=
 =?utf-8?B?aXFJNTlmNUs4MWlUdXBnd2FTMFFwZkpMWDFmL3ZiNERiVURueDlzbWdraWJ2?=
 =?utf-8?B?MGcwTFFPRDJ2MjlJZE13WXhyU3ZkMlMwMkxvL0x3QjRnWE5OYWtHNk1NYjd5?=
 =?utf-8?B?Q0pTOWFZWFYxd3pQZlcySFhsYkE1dHgvZDU3MTZnU05EWlN6dTBRc20rbU1B?=
 =?utf-8?B?a3QrYnlPZjh1YXN6TXJ1R2d6cEdoWHB4eGdPc2o0QnNKVXNLbVNyRnE4QzVa?=
 =?utf-8?B?anVuN0V4dTMxcUtmSnY1bWRHdDh0SEF6bVZtV0s4MUU5MUE5UUJESzFQcnk0?=
 =?utf-8?B?MzF1U3Z2K3lwRmpIWVkveVc2dWV4dStuQzNFOXM4SmlmL0Z5OGxnS3VPV1pY?=
 =?utf-8?B?MUNaQmFkM3pIL0FNUnJpR1hQbW1VVy9GTVhUM1IzQ0JjY21SczIxcjhSZmN6?=
 =?utf-8?B?QWhsQ3hMN05LNmtuam1TeTRlNFlNOXovcUNyeWtMSC9uemF4V1lsRDkweE9M?=
 =?utf-8?B?SWUyNFpheFQ5UGVJQnpMOTBLUDk1RXVFR0JoczZTNWxtRjhzYXAzdm1tYklU?=
 =?utf-8?B?VFVlNW5Pa2pqQTVhYzYwWnZ0OVRqRzlReDB3V1k1WUpjYjgwZ0lnMng1V28z?=
 =?utf-8?B?THlZYXl0RExrU214VXJiZGVmU1NjVGlDcmNMZUxTM0NOMWJNVHp4bXFkN2Fr?=
 =?utf-8?B?UEY5dWVYY0tuaHhDMnM3VU9QVnd4YW1GK2E4SEtNUXFHaUpjanp4UUFLeHJo?=
 =?utf-8?Q?iiuzkUd94VwL5Bw7FwqA0aqHhIi19VUWfDkZWmj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E88CEBF4A552D7478C76AE5E36D8CEA9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157212cc-bce0-457d-3bed-08d98d9878e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 15:53:45.1164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NuuAZYe7dcWkpctlHvzjmh60rZ3sJAXh09ioxzFsbSYh2OJj6kRYJS7jCrzAJAb9TLvOTXFXaxl2d9M85Ks0xM4KVuya32U0w+jr0LygfKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4656
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEwLTEyIGF0IDA4OjQ5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMiBPY3QgMjAyMSAxNzo0Mzo1MiArMDIwMCBSdXVkIEJvcyB3cm90ZToNCj4g
PiBPbiBXZWQsIE9jdCA2LCAyMDIxIGF0IDM6MDkgUE0gUnV1ZCBCb3MgPGtlcm5lbC5oYmtAZ21h
aWwuY29tPg0KPiA+IHdyb3RlOg0KPiA+ID4gTXkgYXBvbG9naWVzIGZvciB0aGUgaHVnZSBkZWxh
eSBpbiByZXNlbmRpbmcgdGhpcyBwYXRjaCBzZXQuDQo+ID4gPiANCj4gPiA+IEkgdHJpZWTCoCBz
ZXR0aW5nIHVwIG15IGNvcnBvcmF0ZSBlLW1haWwgdG8gd29yayBvbiBMaW51eCB0byBiZQ0KPiA+
ID4gYWJsZSB0byB1c2UNCj4gPiA+IGdpdCBzZW5kLWVtYWlsIGFuZCBnZXR0aW5nIHJpZCBvZiB0
aGUgYXV0b21hdGljYWxseSBhcHBlbmRlZA0KPiA+ID4gY29uZmlkZW50aWFsaXR5IGNsYWltLiBF
dmVudHVhbGx5IEkgZ2F2ZSB1cCBvbiBnZXR0aW5nIHRoaXMNCj4gPiA+IHNvcnRlZCwgaGVuY2UN
Cj4gPiA+IHRoZSBkaWZmZXJlbnQgZS1tYWlsIGFkZHJlc3MuDQo+ID4gPiANCj4gPiA+IEFueXdh
eSwgSSBoYXZlIHJlLXNwdW4gdGhlIHBhdGNoIHNlcmllcyBhdG9wIG5ldC1uZXh0Lg0KPiA+ID4g
RmVlZGJhY2sgaXMgd2VsY29tZS4NCj4gPiANCj4gPiBQaW5nPw0KPiA+IEkgZGlkIG5vdCByZWNl
aXZlIGFueSByZXNwb25zZSB0byBteSBwYXRjaGVzIHlldC4NCj4gPiBEb2VzIHRoYXQgbWVhbiBJ
IGRpZCBzb21ldGhpbmcgd3Jvbmc/DQo+IA0KPiBUaGVzZSBhcmUgc3VwcG9zZWQgdG8gZ28gdmlh
IEludGVsJ3MgdHJlZXMuIA0KPiBMZXQncyBwb2ludCBUbzogYXQgSW50ZWwncyBtYWludGFpbmVy
cy4NCg0KU29ycnksIEkgbXVzdCBoYXZlIG1pc3NlZCB0aGlzLiBDb3VsZCB5b3UgcmVzZW5kIGFu
ZCBhZGQNCmludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnIHNvIHRoYXQgaXQgY2FuIGJl
IHJldmlld2VkIHRoZXJlIGFuZA0KcGlja2VkIHVwIGJ5IHRoZSBJbnRlbCB0cmVlJ3MgcGF0Y2h3
b3Jrcz8NCg0KVGhhbmtzLA0KVG9ueQ0K
