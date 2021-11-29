Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3479D461FAD
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348075AbhK2S6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:58:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:9765 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378948AbhK2S4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 13:56:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="235874565"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="235874565"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 10:46:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="459271450"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2021 10:46:02 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 10:46:02 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 10:46:02 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 29 Nov 2021 10:46:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0jkfVoUmTTdbeJsiN08lDlxIR6n9EcDP9lWp6rcFghp2922WmAGK6XwlI5vW2IJCQ+/vHNoYT8sI2mlO/3QeKegG8UXHeufifDiZ/lhjqn5wN32pCmFSaD/u0dnYj20p+rYW9cQ8aJovmlp7s4mZEiqv7YopSA+bzJF4x7myZR+gJ7xmTMc2d0LW0DpbgBvbLBPE1KgxVww4JrBeo8SwIiJOZNknxrmryIODm5pq6noJ6+iy7NWNMywPK8VtjDUBdiFWM0O1j8uqEq/qfwZgHb5nIRRuwFf1xGu8IyM+iojz0L5Lurf4Jo1PZqanc9XvC5ykcvPi2nCnLqpxycbHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWxacj2oui9943IstK41iTYVSKAw69JkJMnOjyWt1cE=;
 b=S6IzkrWE5shShRt2kPmyYH1aADhBnNg0Bu3f6+ehB1iNfeH4ZjYMdSYst98vrWcs8sBgd10c0ou06wcAH29S5Bgz5uO0Cff5J2I7vsqMO2sT6oCOWeWGc0AeCLFz3klQONLTFqWo/jjASmGqvYYsCOIiZyAqxJAV1BNUTbvyZ+XbMxSjirZcLcdszRXChwnGephHkAqBYLM4yurKGIvMFBB4r/LSyji44r9mc/cUy6XhmOwWyDkUjmQi/rnay1DGls306DwzHJz/S1c1ejesCxlp2nTF5iUqrzEY2+y1EvAK4PLB55mro6Xe5THhSp+FLPWOqdIWxeBg7iXxFvgSqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWxacj2oui9943IstK41iTYVSKAw69JkJMnOjyWt1cE=;
 b=fK9D/b/SeY32zdDazXKNc0g9Gum7JM03AxriJEwchl6h7EKM26ForjChIFArKVQxgn3PMHlEUA7ekkA68qoTA6HnjNgbjQO8McznVcr3xbumbwQ422ZQ85iTj1fV36tEYr61RHCfIX//fMSkSFKrgI/OEEGxnwj8Q1HwJh7V22U=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3005.namprd11.prod.outlook.com (2603:10b6:805:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Mon, 29 Nov
 2021 18:46:00 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:46:00 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/12][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-11-24
Thread-Topic: [PATCH net-next 00/12][pull request] 40GbE Intel Wired LAN
 Driver Updates 2021-11-24
Thread-Index: AQHX4VdNl1U5l60zvkSg+uLWtW7h/KwTVzkAgAeIfYA=
Date:   Mon, 29 Nov 2021 18:46:00 +0000
Message-ID: <fd3868f993d77872907ba54cf7b9bf80e3da760b.camel@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
         <20211124154234.4f78a4d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124154234.4f78a4d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61ce2e95-fbf6-4981-9862-08d9b3687d3e
x-ms-traffictypediagnostic: SN6PR11MB3005:
x-microsoft-antispam-prvs: <SN6PR11MB30056A5E99559A8FB822B8DBC6669@SN6PR11MB3005.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bHQ6ZSXv/9LgTRMOgFGA/zR4WczKAgSWj/FI0eheMpNr7moqNcnHoU0R4s/Zy46a7aphlp5CsE0tyhcDR4jXqM1ECG638D8h6NigF0l9/LkukpE7eAGLLrV9O321J9WgCB9QyCHjTVdBbHPiwxDXtDZiOEP3e+tBd/aLPbo204jH0I7fiCdc0WeCarqRGbr//QrRBPpK8j/7Lb/yJUYqqKLLOOkPELIThxbEzN85trZ0oAado7ZJv0/pktUs0Kzjljhw7v4uZafPXppev/KZF/IP8yO3NBedQXZkeWhfTNSoZm5HICn63FBiyjfcJSIwyRSftXHhLhz2EM9oFauPEsXiNGl2QHiE4YUKxNCF/O1M7AKLhuD14S3I9v4tNe2Q7ppVsgXPpjkgSeCstp5h5zFWvYOyZ5TOlqd5PF+FKz+g9LSCKwWgPf0Jnnsk0pzchVSiftjIfZxSjdFtPl5akifD/xRTYk+DRskh8qDvLIP79QO/2YFQxFlWtXV7R0/h1YC+LMgpnw7XARPohRFFVlXw1Dk5G2eZjuAHU91XGAEApDradzlXo+BpVtA6sbeunPs753Yg0w/6TeNagiAxfSE3XRiYq+12VtmTH6pOgCnamTvucH6D/40P4U5eWS6N723Ji/OgqTOgh0mO32JKJNs9jDeznPMDcLmCD4PXcT8l1tYQFGFjMdXwGEYCb9NTPnXePiItYAN3hE4TfXt48g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(122000001)(26005)(54906003)(64756008)(66556008)(316002)(76116006)(38100700002)(2906002)(5660300002)(186003)(6486002)(83380400001)(4326008)(4001150100001)(38070700005)(71200400001)(66446008)(508600001)(8936002)(8676002)(15650500001)(6916009)(36756003)(6512007)(82960400001)(86362001)(66476007)(66946007)(91956017)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWxiUDJHSmlROEs1cTdDUXdaM3RObGoyalU3Rlc4eVBGRytrclFSOThiNlk0?=
 =?utf-8?B?U2s0SldVTlZndDkxWG1UR1hERElhRjFuR1RuYzR0NUxSZ0xYUkRaR1FCTGU2?=
 =?utf-8?B?YWI4a0pSWFJsQkVUVXhmbDV6Q0xYaGI5Wnd4enNINnVKN2VqYnVxenBVVUto?=
 =?utf-8?B?UmphVWxTZXh5UVNYR05EemdpT1VHeHBpcTU1SG90ZiswTmdrdlk5T2h2VHE4?=
 =?utf-8?B?RGRtcjdOTVNxWTFlZlJxY09XdUI4NXJsNXZzZ1BNZmZmb0RKemhxOFAyU2Nx?=
 =?utf-8?B?N0hlZENGU2tGV0VPLzh6SWNuYWIzQW1FdFUwRGNxMTRTWGJNZXU2UHE1WmR1?=
 =?utf-8?B?bndDVndML2xQbi9lbFpnVVlGaUJ2citWNExxVUppcXkwanRIZXlZTVh1Tktp?=
 =?utf-8?B?WHJnU3RubVpUeXg0NmFjb1ArSXBVRksvdmpHU05qaEs3MHJMbnE2Mm45K1pI?=
 =?utf-8?B?MnVONkRBK0NMMHJLSXQrZGlIMkxSSlBZbkdPWVdBUk4ySWg0SmV3NC9mRTBW?=
 =?utf-8?B?Yk1DaUU4b2ZGek8zeEhpK0tPU1Ryd0lOYXNpSUtxVlFYZWRydkJQM1FNd0ZK?=
 =?utf-8?B?OVVzbk0waXVKUzdFQXVUN0Q3SVZ2NGh6c2V1M2xXOXlTQm5EbVJBd0ppRDVJ?=
 =?utf-8?B?aU8rLytLRFNmZ1J3NDRzRlFHcXVhaVFEaXNMUVdnelJEY3JrYTFhNXFuMnln?=
 =?utf-8?B?RVVFR0FWWUlpckplcGxyaUhJVzIrMDJ1TGZ2OUFQNHlQeVNFVnlXZ250alRp?=
 =?utf-8?B?NXNFZnJZUGRxV3o1aVpSMFhBL3NNWnFQTkpMSUxRaEgzVGxWK2hoalREVnd2?=
 =?utf-8?B?OGJCTXhrSlVBL0Z6VEdsUkR3U3hhNUJ1cHR2c0JONSt5OVlEZDVUZnpGYTdr?=
 =?utf-8?B?THZvbWN3a2YybTkzY2tZdmRFSnBwZzVraWhWaGNUVXd5cHU4ZzNlSGkweHB2?=
 =?utf-8?B?T1BvVjVYZGs3UVhKTGFqMUE5YWhuSjlpTEJXREJXQVpBdFAxOTJaNE9HQkVa?=
 =?utf-8?B?ZzY5cnJSS1FWVFdiQlFjajBZbmFaWGJmSkJkZzJOTmhsRXA2SWZsQlZHbE0w?=
 =?utf-8?B?cmhQdzFxM1BwYnd0S2FDcWV0MWVkWkJBNmxXRm5qZW9XSWhhRHpET1JpbHlq?=
 =?utf-8?B?azY3WjVHYVQ3aGpEVzVhbGFhT3NLT1RYd2JYWE9nRUhVeTNrbmVXdUwvVXJW?=
 =?utf-8?B?ZWlSUzVBMW5yQjFVVWdtTG9LYzYxMllIeXcwVVhnU0tRbWZ3ZjVLYitNK0JF?=
 =?utf-8?B?Mm9IRC85YkhhcWU4Tmg4N3p1Unk0QnEycUtrUi9EbVlLL2lyd2FNTUhyWTNS?=
 =?utf-8?B?NjBPZUNlREhDUlVzdVFtQWJzTmZRYjRhMzR2TTQ2eGlHcXNENDZaaVMrKzhW?=
 =?utf-8?B?d1JJYnVIQmZqTWlocXdSV0NBb2NHT3FwSGFpcVdzVXRsYzl2Kys3UGpQQzlk?=
 =?utf-8?B?WE1KMUx2ZnB1TmpIbDdkaURjQlhCYXBaTXpPYytzVkorYUpYVVpUdGlMZTJi?=
 =?utf-8?B?d2dwVUxyRFZ0UGVPN05PdUk5UTJUajd5SzhKT2ZnOXNuZTdpU0Y3ZFhUQmNi?=
 =?utf-8?B?RVdxbkVIT2ZpZ1E5Y2ZwOUpMc1BEUEhPTVp0UG9jOFRTenVQOUJwa0gzR0N2?=
 =?utf-8?B?aE10dFNLUnVNUm5aczR3dzA5RlpGQmV6bGdySys1ODBCK2lvQmZoOVRnb204?=
 =?utf-8?B?OEZUOUxOL2pQSzZ4NWtkamo4ek5LeTR3ZkFHMDIxZ0h0aWxOVUxtL0JOVmpp?=
 =?utf-8?B?RS9vaC9tbSttd01rcXlOME1nVlArQlFzSnVocmg1RTZGc3NSREJTUTdzM2Z4?=
 =?utf-8?B?eHUrYzViZVhNTXdNS1NHWHdzSUtNOHZ0dE1KYk1Tall0aERBYnArTjBlKzBG?=
 =?utf-8?B?Zm9DV1VRQ3BhQ3hiVWowaE1wMjdDT203QU92bjk5cHYrZmNWK1F2eUVYTjd4?=
 =?utf-8?B?eER0Q04vVUZSSS9MdXErQ05tRGM1TExLUEl1S0dKNnFLOFlQb1ErakpOUnM0?=
 =?utf-8?B?eHJsdnFuSERXNzRnRTdacTlpUER3aGhXS1I4YTdkYTJoTnQxVkhQay9zQ0lt?=
 =?utf-8?B?SHJ1RUNlNzBObXZqQ2dHNVpVb2RWK1RRVC93eVVaM2JBTVdhZFV0ZFJEeWcy?=
 =?utf-8?B?Q3g5dlZWMHIzaCtqWThjRVdXb0hmSHNnTHAwK2V0ZisrRUF1RmxXclMveVpY?=
 =?utf-8?B?M2RhMmRLUlpJRC9lVGNkbUM0L3haeGltVzNra0NtaHRjeVloVUwwb0o1d2Ny?=
 =?utf-8?Q?FczeFr0U+M21gtQYWznCw34HRd+rmq9hGHpjZZwgXQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B29E72451E0BD1429769651F5C6F6B93@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ce2e95-fbf6-4981-9862-08d9b3687d3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:46:00.8411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VF1C7JcyfCnbiQvQ2uqaayTk2LruyIOVNJrLuQK/jTJB6k85TqUSnZCI4c05p7C2LzTo8d41nbtSunC0xENEVPUVUOUiDrUwrPN47F+ST4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3005
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTI0IGF0IDE1OjQyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNCBOb3YgMjAyMSAwOToxNjo0MCAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBNaXRjaCBhZGRzIHJlc3RvcmF0aW9uIG9mIE1TSSBzdGF0ZSBkdXJpbmcgcmVzZXQgYW5k
IHJlZHVjZXMgdGhlDQo+ID4gbG9nDQo+ID4gbGV2ZWwgb24gYSBjb3VwbGUgbWVzc2FnZXMuDQo+
ID4gDQo+ID4gUGF0cnlrIGFkZHMgYW4gaW5mbyBtZXNzYWdlIHdoZW4gTVRVIGlzIGNoYW5nZWQu
DQo+ID4gDQo+ID4gR3J6ZWdvcnogYWRkcyBtZXNzYWdpbmcgd2hlbiB0cmFuc2l0aW9uaW5nIGlu
IGFuZCBvdXQgb2YgbXVsdGljYXN0DQo+ID4gcHJvbWlzY3VvdXMgbW9kZS4NCj4gPiANCj4gPiBK
YWtlIHJldHVybnMgY29ycmVjdCBlcnJvciBjb2RlcyBmb3IgaWF2Zl9wYXJzZV9jbHNfZmxvd2Vy
KCkuDQo+ID4gDQo+ID4gSmVkcnplaiBhZGRzIG1lc3NhZ2luZyBmb3Igd2hlbiB0aGUgZHJpdmVy
IGlzIHJlbW92ZWQgYW5kIHJlZmFjdG9ycw0KPiA+IHN0cnVjdCB1c2FnZSB0byB0YWtlIGxlc3Mg
bWVtb3J5LiBIZSBhbHNvIGFkanVzdHMgZXRodG9vbA0KPiA+IHN0YXRpc3RpY3MgdG8NCj4gPiBv
bmx5IGRpc3BsYXkgaW5mb3JtYXRpb24gb24gYWN0aXZlIHF1ZXVlcy4NCj4gPiANCj4gPiBUb255
IGFsbG93cyBmb3IgdXNlciB0byBzcGVjaWZ5IHRoZSBSU1MgaGFzaC4NCj4gPiANCj4gPiBLYXJl
biByZXNvbHZlcyBzb21lIHN0YXRpYyBhbmFseXNpcyB3YXJuaW5ncywgY29ycmVjdHMgZm9ybWF0
DQo+ID4gc3BlY2lmaWVycywNCj4gPiBhbmQgcmV3b3JkcyBhIG1lc3NhZ2UgdG8gY29tZSBhY3Jv
c3MgYXMgaW5mb3JtYXRpb25hbC4NCj4gDQo+IExvb2tzIGxpa2UgcGF0Y2ggMDMvMTIgc3RpbGwg
aGFzbid0IGdvdHRlbiB0byB0aGUgTUwgOlMNCg0KSSBsb29rZWQgYmFjayBvbiB0aGUgZW1haWwg
YW5kIHNvbWVob3cgcGF0Y2ggMyBkaWRuJ3QgZ2V0IG5ldGRldiBsaXN0DQphZGRlZC4gVGhlcmUg
d2lsbCBiZSBhIHYyLCBzbyBJJ2xsIG1ha2Ugc3VyZSB0aGUgbmV0ZGV2IGxpc3QgaW4gb24gYWxs
DQpvZiB0aGVtLg0KDQpUaGFua3MsDQpUb255DQo=
