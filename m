Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAE461FA7
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379652AbhK2S44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:56:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:20159 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230396AbhK2Syz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 13:54:55 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="259985489"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="259985489"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 10:43:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="676473665"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 29 Nov 2021 10:43:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 10:43:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 10:43:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 29 Nov 2021 10:43:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYuJJYqkYerducfqQTqEbC45mHYdVp+/1XD0hnIritzpprS0T5+Pmw5hXJdPaHDGrLUtvTFSbnTD2rNXobVMNU53uANXB8FaWgwf+atRPBiYkZ6/g+Pb518jwDuMl1D5bQgFjOgstYacMpRyLwcvo88mOCLGtT6+gyHUqPzwGhS7+MH6HjX6LM7TqSpqkXmGo7m+5rV9p+VSpMPQMZHALt4EwS+u5LcmEyuhdd94bCQw1JAR45VkiuSEaczaugTbvN8CKiJwza+VZYxQEo3xTRjgt6o5kziCRPbM59zAs9uUhkmIRr+IR2+7iXXZPdrZVPn16UiqXpf5k/QTa5TJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhXIiGdmXSWu9tqO4M6xyOk8N4AsjonnD95aFthHYcM=;
 b=YRdeak8rjIn9b3tMhHmY3ECtVHZRKEsc5ISP3m3vfLRzlidwYkNP4BaGeQ+jUByqJvfNfbOYQFsFuGlsBHjANCbhW2Gh0mi8uiTaUfjuIe7mjIvfM8JnlKHIsI1u75yi9tnldVQU4rSuNRnUnPyUBzUb4+4GYSm1kOhMPgbRBlFimgl+PnjEgSQPn+YUZuw+qT8gWM5ZOHFoQz11605Ci3/FUXK50l/Rlb8jnPwmKJEWm/ya+vNYLB8D3Lgyy+ZZwmttpjLx+ivqTxWv8ZQELuBgmgQQjmmLr85BOFTMB5aOENIZT7jOYCKgJFi6BBVUblnJFah1ubzh8upbKXzU0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhXIiGdmXSWu9tqO4M6xyOk8N4AsjonnD95aFthHYcM=;
 b=eZDoEWNA1ogDJ+MDazKFAhX6QOoD7wljLlxN0p/qSaNys9OPjkOACHXfQl95aIe9Nax1AFMImRfTxshTYPu5CKXIa6tkUpv/DMB8qsssJA92P3nkDZ7xj11HTrJko45ttVpciog3OwxgpKSndurnt9PuW+SwUuC/TWzWpiP4UxM=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4859.namprd11.prod.outlook.com (2603:10b6:806:f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 18:43:26 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:43:26 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "patryk.malek@intel.com" <patryk.malek@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 02/12] iavf: Add change MTU message
Thread-Topic: [PATCH net-next 02/12] iavf: Add change MTU message
Thread-Index: AQHX4VcMfnfbCWR0C0mdBHCxTcD9V6wTWDcAgAeGxgA=
Date:   Mon, 29 Nov 2021 18:43:26 +0000
Message-ID: <91d61a00c15af2ad177cc88fa532fb911fd8484d.camel@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
         <20211124171652.831184-3-anthony.l.nguyen@intel.com>
         <20211124154606.47936e48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124154606.47936e48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8757563e-3ee0-4978-3fe1-08d9b368211a
x-ms-traffictypediagnostic: SA2PR11MB4859:
x-microsoft-antispam-prvs: <SA2PR11MB485975BAC8DB6EB91EE33BE2C6669@SA2PR11MB4859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NNLXhxx7uRCmwLjsieFXLHL6BNuo09dCfbWX2bfwAxQlNqpdzqbf63dPr7BJkvj24OfDY+nj27S059mnvkNRXuoi3L8XitdElTmmzACjOucN/47qOC9+lAuCK6mAogf0sN6unHHh5ngXQBNxRhfMPih/H4ymRAlCY4X05OGH1o7ODlGiYlRuDjzvuGbZAcTwGHllD8/GwkdkKP/Ced7w2ab5CYZj/WzwxTK/IRR2oo1/9ntkmZGaj6vwyMzpKwL30lgKLjxRLPgMvUSeEa51bh7SNEGB2k8+26ZjCAjJBXMM/7VNFMNYynwLevgCA5NKKhkwwta+YUMqjAP/hBiAGAd+pHynAGrX3CgizwP0EjYTdMM/hhEvJExK9fhRiJn33i4EqXL9es9ezqskKNetQ0kVGlfVGfoStajkIuMmA5XEAb0e3Jzr9y8WJX8MIho63PPA0l9kCi2PcuWPJCP3/sF/c2JV0zY7UQU+vNGET/q9o20kCJOYU2/wpvoaVlC7T/nNQKZ7EUSCr4rTrbCWp50wopUJq2meTr1mrvDSH8smutDrM98IP5cKZl32JrUi1mLwiko7hljdvziY/KRXVbWe1kqH5FdlXsMxupJtNFDvKCkzgX1gMeIyfKIi9K1I8RDayJf/cxpmfSSoFKY0Bmk1tCTRTxcQfpeXcD6QQrPVdxDWU8NM9vIB0/Y2HmleZVKPhweYLx9jQigkzfEhRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(316002)(5660300002)(82960400001)(66476007)(64756008)(26005)(66946007)(66446008)(2616005)(66556008)(91956017)(76116006)(6512007)(6916009)(8676002)(54906003)(36756003)(6486002)(4326008)(8936002)(38070700005)(71200400001)(122000001)(107886003)(508600001)(86362001)(186003)(6506007)(4001150100001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVhqc0E4N2NOQVdwTnNreXY1SG93RE5XZk4xLy8vSDNkKy9FRWw0WXhnVStC?=
 =?utf-8?B?bnpDTkpHQ1VMWkFHQnozd0Uxd0tsYVpHNEhPRXVZbDZOYUxEY2ZHMlFQYkpB?=
 =?utf-8?B?VHFoZi82ZHJ0R1l1OTdqMzFiZGxxS2tGV2JKKzVBN2pQT0xROThDQkYvMlNr?=
 =?utf-8?B?Z0ppYm12b0Y2emk5RXFBZWU2Tk1WVldyU1Z0NVBxbXM5M1dQMUtaWm5VSVhj?=
 =?utf-8?B?M1ZrblY3OGpZQmd1S2dPaS9IWUtzVER1bDErc1UyS1BSVGF2UGhERmNxQkhR?=
 =?utf-8?B?bHgwYm54SGNubkNkak9sZXVHUm5OeTNHRURPL05lNXRBWXl5MGpvak01aFh6?=
 =?utf-8?B?T2Ewd1NKTEhCMFhmOXJEaGJnUEh5ZjBEWlUwZnJTUjY1UXpOeWlYYlJ4TmNP?=
 =?utf-8?B?Z0xFT0cxdkp4MjZxc1dYNEpxclIvMVlLZm1tNGZnVW84SEFzWks2VmJGOHJR?=
 =?utf-8?B?UnllSSsvYXoxZmJuYnhJMExGSGlsNDNJQlZFNUM2UkFkZTBxRUpTa1NVbEp0?=
 =?utf-8?B?RytIYXdiNkNjcmowbUhvejBReU12TzU1ejA5OXA3TUhyTGdyRUhBZ2hKMDk1?=
 =?utf-8?B?bFpjWUM4bExaUTdnMS9vRnNQY3l4NWZlNVpJZk5ZZUZGUUY0bTFzcm5mYXlj?=
 =?utf-8?B?QVdmUEM5WW5Wa2NJTHRLd3BOemJNNW5zNFBiOERiTjFZV2NSMFBNQWk4M2ph?=
 =?utf-8?B?V05tdE82YVpvN0F6YWc0Vk9VR0JHbG5UOHZIVTlzRHRacFRJKzV1eEdhUG04?=
 =?utf-8?B?UEdKTjJ3ZDlCVXE0ZGx0ZmhUc3BDNG5ZVzBkaXpXdHNxRnhWZXNTcXJoYmZp?=
 =?utf-8?B?WGdUZzVQbWlNNnBpQjFNM0VsWmsxYTBGdW4vSHpPM2FhMEcxMUluY3VQa1J2?=
 =?utf-8?B?Nkl5c1ZOeHNMUlJVTFZqdHRVL2lpRWg1TTVLVGR3TTRzbXVld2lNVEVmd0Jm?=
 =?utf-8?B?U09rZ3d6YWJKQW9xUVNjcUM4ZmxBVkhlYWNSalYyZXo1eS9wQ3F2QTZybHRO?=
 =?utf-8?B?L1JrSVkzRGVIK3ZhRXc4ZU9VSmtpczQxdVo4ejRwNjIwekZWcmpqUGk3UVQ4?=
 =?utf-8?B?T1hUWlgxZFNtZEQ1OTVwVkZaYm1wejRsZzBSTUNuN0JQZUxKVVFMQ2RGbUdY?=
 =?utf-8?B?UkYrR3cxL0V4bWlpUmFSa3ZtMlNCZGdrYTMxUHhNd2F4eEUreXh4MEIvcVlX?=
 =?utf-8?B?dVo0dUg1NCs0ajFCN0dUZ0o4M1Y5VGVNSy8yY2pLZ3RLdzRLVVh6UDJOUTNp?=
 =?utf-8?B?bDRQZC9OS2lNWlRRVFpreExBREc1d2lDMURPa25oQmdBQXRNZ20wcEdWS0Ju?=
 =?utf-8?B?dWFRWFkrZnRuQmUyK2IwMXFmYWlGM1BKRUtBQVlSclpzQ3QzVjNRNDhGUDBJ?=
 =?utf-8?B?Z1U4SEpXMDJ1NzZ4SU03NjdSSzdzRGFyOHdKMzdTQmRDV3Noc0J1RjYvT0JL?=
 =?utf-8?B?cU0xdG5URFZzTks0K3c2TU95VTFUUllCSm5YYjFDQkppV3NVeG15S05HZkdt?=
 =?utf-8?B?dFdFU2IxeEdpZmIzZnBJbTMvdmlBVWlqOVV5Z29QYXVqZytlZVEwcHlmV1RN?=
 =?utf-8?B?Q0Q2WGlwcE1oOGtSSXM0cDVWL0ZYZWxxUVloWjdPMEcyQzdvTW9Md09RN1Bs?=
 =?utf-8?B?b3Z3REFzL2RmRks3ZUJxSW5VUlRmK2gwUVV3Nk13NWEzVWl0TTFxaGkwci92?=
 =?utf-8?B?N1d3eWlQZmxENXRhR04wamhWVUM1ZVc1K3ViTmxVdXY2RnM5NU82Rll4L2tp?=
 =?utf-8?B?MTFoMFJYL05GRHNTcUJvWkRvdytRd1cxNGN6a1dWSjduRkhJdVVXQjNHTlI1?=
 =?utf-8?B?WE5BcFRSbHBZUFpHcHlPaXFSNzV2WDBWMnBpM01xT2t2blZQTlZkSUU2UWxU?=
 =?utf-8?B?WjlqbFU5TlQyRWlHajFrWktLTjUyTnJrTTdmVGgzVHVsb3VXRUtCRmY3dHlK?=
 =?utf-8?B?ZXpKMkdKa1YxS1Z2U1BoVE44QXlpWFlaMkVNMmszUG9BVmVjZXJ3YUd3TGQr?=
 =?utf-8?B?YmE4UXEyMDRxUEtiOUE4Q0JQd3RrSW54Ulh3Zy9hTWFLLzdDNVlaeXArbnhw?=
 =?utf-8?B?WjNCY01DZVE0bVRpdGJsREZqcVh3OHhUTDNseCtZcnJsVHVXQkt1QWR6Ny9a?=
 =?utf-8?B?N1dHQjRBd3BVVmxidnpDMVRUU1ByUXl2V3BVdWJWMENXRjVnQ3UwLzdhSTVQ?=
 =?utf-8?B?MDdCd1draHZERVJ2MXA0ZXljdThleXozZ3FvRjZkbTV0cm02V2tvb2t6TXRK?=
 =?utf-8?Q?m6FMbYxKKl9Pwlut/iDSaeFkMnal0cF/b3sFjB4WsA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D4F02657A22C94B802111B80C70664F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8757563e-3ee0-4978-3fe1-08d9b368211a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:43:26.2505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6krOAFSrEX8VASVtUe+218/DWPDutKUWzvMZP3Jv/GOnRi9ZrBKrDKbBRvaVxRPPDgLvWwVLN+Mau5KUqE+oBKOBQLXiJmR7BUm5bAEBXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTI0IGF0IDE1OjQ2IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNCBOb3YgMjAyMSAwOToxNjo0MiAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBBZGQgYSBuZXRkZXZfaW5mbyBsb2cgZW50cnkgaW4gY2FzZSBvZiBhIGNoYW5nZSBvZiBN
VFUgc28gdGhhdCB1c2VyDQo+ID4gaXMNCj4gPiBub3RpZmllZCBhYm91dCB0aGlzIGNoYW5nZSBp
biB0aGUgc2FtZSBtYW5uZXIgYXMgaW4gY2FzZSBvZiBwZg0KPiA+IGRyaXZlci4NCj4gDQo+IFdo
eSBpcyB0aGlzIGFuIGltcG9ydGFudCBwaWVjZSBvZiBpbmZvcm1hdGlvbiwgdGhvPyBPdGhlciBt
YWpvcg0KPiB2ZW5kb3JzDQo+IGRvbid0IHByaW50IHRoaXMuDQoNCkkgd2FzIGdvaW5nIHRvIHNh
eSB0aGlzIHdhcyB0byBtYXRjaCB0aGUgYmVoYXZpb3VyIG9mIG91ciBvdGhlcg0KZHJpdmVycywg
aG93ZXZlciwgYWZ0ZXIgbG9va2luZyBhdCB0aGUgb3RoZXJzLCB0aGV5IGFyZSBkZXZfZGJncy4g
V291bGQNCnRoYXQgY2hhbmdlIHdvcmsgZm9yIHlvdT8NCg0KVGhhbmtzLA0KVG9ueQ0KDQo=
