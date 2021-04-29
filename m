Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3560C36EDF3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhD2QQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:16:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:18877 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232004AbhD2QQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 12:16:08 -0400
IronPort-SDR: tnNzsKQ7fOWtQMlBL/HGtIIpU8Pg0PIr454sLWE2oPvnze5X6qWNqGsqmsOCwwpp8X/ENvol7S
 WyEXvQcVQW0A==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="184516107"
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="184516107"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 09:15:20 -0700
IronPort-SDR: 3M81UBbIGJ+SvlQVobSS8tOm/Q9mQkNRmTEHKAZGxvwF64jx1LXHLrbIqMZBEuky0zqA38Ubww
 m6R8fqDPPRpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="527013415"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 29 Apr 2021 09:15:19 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 29 Apr 2021 09:15:18 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 29 Apr 2021 09:15:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 29 Apr 2021 09:15:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 29 Apr 2021 09:15:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVN8w5sr/3tiZLZ+XKdKpF0bZi1Ht7YWESKWgm09HpSve0O8wvFjRbKLWDZobx59mJJPRGQY790uqz6j1OF0GeOLYvbGGMBWo+B6A8wUQ9BkI3IxQZTNbBXXmv/bmY89Kq/PrK/XNNO3y9Ebr0m6t4al6TaC3oYhWckF/5rlaSFdODdxYlj5bR2prgMj4M0z7P6TUbvkrc9fz4uGLX47IsSaihe6tAkUoG3A52u2R8Ghkyf63q673oCmiSaHn97+HI5yoGEcgGO843RzZKyvvFCh/MejxKZ8F46pLnModO62RLGnUMnyFikEMgimnc9HE3eYh3S5iiVngmx/efi5aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJwpDbD80SRM3rjqrDYEh/l6S/89s84gKkPxRZS03fM=;
 b=H6ulpg5KUFVVm9K58JSXiGITI6H6dUG6mWXQKMOMSXbuR8FDbnS4Si4Wvt3Ow7Q9miPHNLiw1OrAcshHQCRffSAm0pnZE1s3KF+0QIkdlO+mPwApQAtsNbbH829GmbWR258EKvlM5bZbfQJLQo8NRKklblLBYa48ZsEOng9dEwJn7/q9WNpNtP+siw4uB6DYm6kCzjVSM75Uwka7Gk1BUTKa5lljNytlq2abS43FdwyS7M1/3tHI3zFiceyMKxyQHn5uMSt/+dRUrnQjV/tGi7DRBnjwZsEljPRmZcsvYrdQnvEhldB4bGY36lA6IF/gS/EBhj/pPkxv8w3qGONKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AJwpDbD80SRM3rjqrDYEh/l6S/89s84gKkPxRZS03fM=;
 b=E+z7kB/Wb2eYl06bV6kgSPnDgd0QZeZbunpnIXyreJKn5LuQR/aeW+gLT501WNrn0J5qj6IRfbSXccBcjZYzTrzV6ERUr2IVha3iICygsHbuk2OEi5+/qRFT7hCeujEw4vEULKSFB4gA+G05LklVNcbkKHS14GJDBp7dzzYCBn0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 29 Apr
 2021 16:15:16 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4065.033; Thu, 29 Apr 2021
 16:15:16 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "haliu@redhat.com" <haliu@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH intel-net] i40e: fix broken XDP support
Thread-Topic: [PATCH intel-net] i40e: fix broken XDP support
Thread-Index: AQHXOo1QOcdFIw10YkWxQQA5rzpJXqrLOgUAgAB2jYA=
Date:   Thu, 29 Apr 2021 16:15:15 +0000
Message-ID: <e1d4c3da623201bbbe9395477d7cd077638b4bf6.camel@intel.com>
References: <20210426111401.28369-1-magnus.karlsson@gmail.com>
         <20210429111056.2174ee76@carbon>
In-Reply-To: <20210429111056.2174ee76@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94e8deb9-a0fb-4077-2c70-08d90b29f9c0
x-ms-traffictypediagnostic: SA0PR11MB4557:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB45576026590DFB7FBD7CD6FBC65F9@SA0PR11MB4557.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dz3938pU+Rs/RVkMHK3SoQbR9Vv0+UPMRoQr92JFmMN62HmT5VaWOxqV+6yL0XZgdhfmDNN9gSYH2rD7fd/rbDJNF0OLdKpQxb3rlYbfzPNbC4n5uOHGhXfn4w6N5U4z1YwM5IhlLL7oAq1NyYqfLP1WaVFHnfk/ydk1m5/HqLd5fUNA0zytOIDHEzambL5sCC8YjmE1wkwzN22/QEe7D6Cco9LCRymzaNt7udumeFzE0q3X7XeQARA6f5j56PprtCd7FQz2Jpf/914hM4wOzHczZMDraJQ/uuwJcQEpxX+7IABbTbTEzPhoX2/aXviH+WajT+zj1i9WJp0FiSf+NUu8W+qvsY8d0sg53H/eveDDDf/KxbDEwJ/G1JqM/Dtrt/0J0k47l9t1w8zshPQGA+T3F648FO0sRQtsESGXHyhztzdfJUQIAVheAnwTUMdj3/WRY2uYfMp4iikYgvnCIYNddediKocFv9Xppm9dzPdrnbi1uH6OtnBpO7uIGOlZpB2fjxD2fzgbVWmresK1v2iHksbwBRm76q/jc/7LEB1hTgD3L1QnV94Pwr1d5yDwGahyovpVeg79tiLmP3/xS1a6SSh5Y/PwKUwxyexRO+UifZntIyKvoE1MjUTYV21NfwrIls234N22T3Q91JNUsnrOSf5p6q2I56i3c1x5NcTvn5EEilQsX3tnVIZBas9qow1+XczpTAyknFDXinQo7dUIUuuJtBxWVKXTeg0QA1o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4326008)(2906002)(64756008)(76116006)(6512007)(8936002)(8676002)(26005)(122000001)(66946007)(83380400001)(6486002)(54906003)(110136005)(6506007)(36756003)(186003)(71200400001)(2616005)(86362001)(66556008)(38100700002)(66446008)(316002)(66476007)(91956017)(478600001)(5660300002)(966005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N0FyeTBTU08yUTJ5THRaeHg5aENOOFUwV3FRd0R1ckdJN1R5Mjk1czJPR0tx?=
 =?utf-8?B?Q2VGMStzQ3VEeURFU0szcXQwVWRtMDJGa1k5Uk5VZGUySTVrT1pON280Qk92?=
 =?utf-8?B?Z2tkem9jaW9xNksrNkdFZjl3OEo4V2hhcm44c3JJajVxZjlVVFJRajcySXk3?=
 =?utf-8?B?RjlUaDI1R3NYNG50NVFSb0NOQXhkQXRyeStHY3ZUYVBFV0dtR2dPRnpDVDJT?=
 =?utf-8?B?MGR5Z0JzU2Y3Z0ppcGdmOE0ybnBZeVg4eldRbnd2NGxyMkJ2UEVGV290TkFD?=
 =?utf-8?B?dmRYV3orSThsTm9XUDZUU05xL3JVdjBxQUFBZitFOEZZeGpTUHVHdnBSVzVw?=
 =?utf-8?B?T3NPVDh3N1N4eHRJbjdWUXB0MDJYeE1VeTBpbnI1Ti9qaEsyR1E0MWt5T05D?=
 =?utf-8?B?Q2h0alFsT0NjY0l0WE5RdVordk9KWFpidVYwQmhHa3Z1YnhFQStSdzgzUzFi?=
 =?utf-8?B?TmtBWlMwbVFrZWVOOFloLzdGSGIrMDVpQitINGJsdGRVMXliclVxVXJzbjA0?=
 =?utf-8?B?bG9udGdGZjR3R2l4d0hKZkFSRG5ZTnJiK3ZxblkxeGp2UDJ6M3dUYTJnU1Jn?=
 =?utf-8?B?eW5XZXM4cURYM0ZUVXlaQzM1anBpbmR6c0xiOVpRV215WlhBVC9QODNackFT?=
 =?utf-8?B?bHFsbnFsbGlxTnA1ZEJVWVJhT1FaVDJxb0hOSUxkb09hU1FWL3drZFcrbUFX?=
 =?utf-8?B?M1FQNlNjRFNXbW9NOHE1ZGpYeHFSMXR2WHhUbEs4MUZzWVY5TlFVZDl3eEZS?=
 =?utf-8?B?cUhDczNaTENHYmFoejY4RG03Qm9la0lVZnA2am9kLzdWQ3dJMlRsbFhHY2Ur?=
 =?utf-8?B?YUEyY1BJelZLOS9SbmdYeGtqS0wzSUg5T0tnQmsrUmdFMkFRR3VVcHhvWm03?=
 =?utf-8?B?Z0p3cmxkMjZPQXg1RW9zczB2WXRsZlNQS1ZkMi9RR0hMYnFYTHlIOGtNVjJx?=
 =?utf-8?B?cUpXMnU4OTljZVZSbTV0VzFRcFkrU0M1N004SFJzd0ZXMXd4YXVWL0Z0VGVK?=
 =?utf-8?B?N0NhQ09ZOElobEZMQzV5YjlxMXAwa1JRUUF4dElXNzhvRUlySXdlZ1FrMXdj?=
 =?utf-8?B?eFhkdno2UXpERjVYYk5HZmN6OTFBYWxpeUh5YlBmQTZ4R2ttaEEzZXlTN2k3?=
 =?utf-8?B?UHY2Y3QxYlhGVFFKTVVNWEVKa2Y0QXV5cDBKZURmQXBrUVVoUml6THJyN1E5?=
 =?utf-8?B?MkFHOXc3QWJIOGJ5UzFlUSszaCs3TzdZMUtCK3dDZXZYUGF6eHRxUXFMbkRk?=
 =?utf-8?B?L0FxZW5CUW5mQWI3bWZZL0N0Z1hJUEFYYWpIQUxXUVY4QUlIM0lSK0VuYUJt?=
 =?utf-8?B?T3pGbkI2ZWcvK2F0WFNGaFdRSGVZenNrVmJpMHRyMlNxY24wRk9qeUd0SDNk?=
 =?utf-8?B?U2l2eGp0Y1JZRk4rUGxnQzNibWQ5NzBNeFVVdTdmdTFjdkhPOEZlanFEeEZu?=
 =?utf-8?B?MkxuNUVqQ1orTzZHaFhvUk1FS2dIRmtqRmkvTHJsenFVMDJpaitwcFpGNndw?=
 =?utf-8?B?dDhESkpySDltSXFSeExLVCtUNGZBcGd0OE13bDBnVmN2R1BUZXUwQllaUXpF?=
 =?utf-8?B?OG14VnJtbmoxbEs3NTBTVm5qVzEvVnBlVmdIdzloR0dwemFzV3BoejJ1MFZG?=
 =?utf-8?B?SW9ZRno0emRzY0lOSEhib0piaWRGZjlYZ29saUZPb2dWZERseTFteXBrcWpR?=
 =?utf-8?B?d0ZIYW1mYlFwUzErcXloRmVvbk5zZThNN1RPSDFuR1BBM2lkSkVOaW44NzJM?=
 =?utf-8?B?MkVQWUtaeWZRZmxCaHRtZC80U3Zxb1NuZmU1Z2tHY1JaU3BlY0hIUmJVQnUw?=
 =?utf-8?B?NGttK3QvUExMYjZYV3hWQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C32E0C25D3746468A03E5F2DE784533@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e8deb9-a0fb-4077-2c70-08d90b29f9c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 16:15:16.0128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D0t2vPUXbeEYdliJUGe7XJEdAE/0NztxRUy5DT7h0e1k6rUeIBP3HSih2XtbgyR6rBTLo3OqBO+YEY/pwr78UBoT7FU8a8edOlKlELfiyBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA0LTI5IGF0IDExOjEwICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBIaSBUb255LCAoKyBLdWJhIGFuZCBEYXZlTSksDQo+IA0KPiBXaGF0IGlzIHRo
ZSBzdGF0dXMgb24gdGhpcyBwYXRjaFsyXSB0aGF0IGZpeGVzIGEgY3Jhc2hbMV0gZm9yIGk0MGUN
Cj4gZHJpdmVyPw0KDQpUaGV5IGFyZSBjdXJyZW50bHkgYXBwbGllZCB0byB0aGUgSW50ZWwtd2ly
ZWQtbGFuIHRyZWVbMV0gYXdhaXRpbmcNCnZhbGlkYXRpb24uDQoNCj4gSSdtIGdldHRpbmcgb2Zm
bGlzdCBhbmQgaW50ZXJuYWwgSVJDIHF1ZXN0aW9ucyB0byB3aHkgaTQwZSBkb2Vzbid0DQo+IHdv
cmssIGFuZCBJIG5vdGljZWQgdGhhdCBpdCBzZWVtcyB0aGlzIGhhdmUgbm90IGJlZW4gYXBwbGll
ZC4NCj4gDQo+IEkgZG9uJ3Qgc2VlIGl0IGluIG5ldC1uZXh0IG9yIG5ldCB0cmVlLi4uIHdvdWxk
IGl0IG1ha2Ugc2Vuc2UgdG8NCj4gcm91dGUNCj4gdGhpcyB2aWEgRGF2ZU0sIG9yIGRvZXMgaXQg
ZGVwZW5kIG9uIHRoZSBvdGhlciBmaXhlcyBmb3IgaTQwZS4NCg0KVGhlcmUgYXJlIG5vIG90aGVy
IGRlcGVuZGVudCBjaGFuZ2VzIEknbSBhd2FyZSBvZi4gQXMgdGhpcyByZXNvbHZlcyB0aGUNCmlz
c3VlIGZvciB5b3UsIEknbGwgZ28gYWhlYWQgYW5kIHNlbmQgdGhpcyBwYXRjaCB0byBEYXZlTS4N
Cg0KVGhhbmtzLA0KVG9ueQ0KDQoNClsxXSBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3By
b2plY3QvaW50ZWwtd2lyZWQtDQpsYW4vcGF0Y2gvMjAyMTA0MjYxMTE0MDEuMjgzNjktMS1tYWdu
dXMua2FybHNzb25AZ21haWwuY29tLw0KDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9u
ZXRkZXYvMjAyMTA0MjIxNzA1MDguMjJjNTgyMjZAY2FyYm9uLw0KPiBbMl0gDQo+IGh0dHBzOi8v
cGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAyMTA0MjYxMTE0
MDEuMjgzNjktMS1tYWdudXMua2FybHNzb25AZ21haWwuY29tLw0KPiANCj4gKHRvcC1wb3N0KQ0K
PiANCj4gT24gTW9uLCAyNiBBcHIgMjAyMSAxMzoxNDowMSArMDIwMA0KPiBNYWdudXMgS2FybHNz
b24gPG1hZ251cy5rYXJsc3NvbkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gPiBGcm9tOiBNYWdu
dXMgS2FybHNzb24gPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+DQo+ID4gDQo+ID4gQ29tbWl0
IDEyNzM4YWM0NzU0ZSAoImk0MGU6IEZpeCBzcGFyc2UgZXJyb3JzIGluIGk0MGVfdHhyeC5jIikN
Cj4gPiBicm9rZQ0KPiA+IFhEUCBzdXBwb3J0IGluIHRoZSBpNDBlIGRyaXZlci4gVGhhdCBjb21t
aXQgd2FzIGZpeGluZyBhIHNwYXJzZQ0KPiA+IGVycm9yDQo+ID4gaW4gdGhlIGNvZGUgYnkgaW50
cm9kdWNpbmcgYSBuZXcgdmFyaWFibGUgeGRwX3JlcyBpbnN0ZWFkIG9mDQo+ID4gb3ZlcmxvYWRp
bmcgdGhpcyBpbnRvIHRoZSBza2IgcG9pbnRlci4gVGhlIHByb2JsZW0gaXMgdGhhdCB0aGUgY29k
ZQ0KPiA+IGxhdGVyIHVzZXMgdGhlIHNrYiBwb2ludGVyIGluIGlmIHN0YXRlbWVudHMgYW5kIHRo
ZXNlIHdoZXJlIG5vdA0KPiA+IGV4dGVuZGVkIHRvIGFsc28gdGVzdCBmb3IgdGhlIG5ldyB4ZHBf
cmVzIHZhcmlhYmxlLiBGaXggdGhpcyBieQ0KPiA+IGFkZGluZw0KPiA+IHRoZSBjb3JyZWN0IHRl
c3RzIGZvciB4ZHBfcmVzIGluIHRoZXNlIHBsYWNlcy4NCj4gPiANCj4gPiBUaGUgc2tiIHBvaW50
ZXIgd2FzIHVzZWQgdG8gc3RvcmUgdGhlIHJlc3VsdCBvZiB0aGUgWERQIHByb2dyYW0gYnkNCj4g
PiBvdmVybG9hZGluZyB0aGUgcmVzdWx0cyBpbiB0aGUgZXJycm9yIHBvaW50ZXINCj4gPiBFUlJf
UFRSKC1yZXN1bHQpLiBUaGVyZWZvcmUsIHRoZSBhbGxvY2F0aW9uIGZhaWx1cmUgdGVzdCB0aGF0
IHVzZWQNCj4gPiB0bw0KPiA+IG9ubHkgdGVzdCBmb3IgIXNrYiBub3cgbmVlZCB0byBiZSBleHRl
bmRlZCB0byBhbHNvIGNvbnNpZGVyDQo+ID4gIXhkcF9yZXMuDQo+ID4gDQo+ID4gaTQwZV9jbGVh
bnVwX2hlYWRlcnMoKSBoYWQgYSBjaGVjayB0aGF0IGJhc2VkIG9uIHRoZSBza2IgdmFsdWUNCj4g
PiBiZWluZw0KPiA+IGFuIGVycm9yIHBvaW50ZXIsIGkuZS4gYSByZXN1bHQgZnJvbSB0aGUgWERQ
IHByb2dyYW0gIT0gWERQX1BBU1MsDQo+ID4gYW5kDQo+ID4gaWYgc28gc3RhcnQgdG8gcHJvY2Vz
cyBhIG5ldyBwYWNrZXQgaW1tZWRpYXRlbHksIGluc3RlYWQgb2YNCj4gPiBwb3B1bGF0aW5nDQo+
ID4gc2tiIGZpZWxkcyBhbmQgc2VuZGluZyB0aGUgc2tiIHRvIHRoZSBzdGFjay4gVGhpcyBjaGVj
ayBpcyBub3QNCj4gPiBuZWVkZWQNCj4gPiBhbnltb3JlLCBzaW5jZSB3ZSBoYXZlIGFkZGVkIGFu
IGV4cGxpY2l0IHRlc3QgZm9yIHhkcF9yZXMgYmVpbmcgc2V0DQo+ID4gYW5kIGlmIHNvIGp1c3Qg
ZG8gY29udGludWUgdG8gcGljayB0aGUgbmV4dCBwYWNrZXQgZnJvbSB0aGUgTklDLg0KPiA+IA0K
PiA+IHYxIC0+IHYyOg0KPiA+IA0KPiA+ICogSW1wcm92ZWQgY29tbWl0IG1lc3NhZ2UuDQo+ID4g
DQo+ID4gKiBSZXN0b3JlZCB0aGUgeGRwX3JlcyA9IDAgaW5pdGlhbGl6YXRpb24gdG8gaXRzIG9y
aWdpbmFsIHBsYWNlDQo+ID4gICBvdXRzaWRlIHRoZSBwZXItcGFja2V0IGxvb3AuIFRoZSBvcmln
aW5hbCByZWFzb24gdG8gbW92ZSBpdA0KPiA+IGluc2lkZQ0KPiA+ICAgdGhlIGxvb3Agd2FzIHRo
YXQgaXQgd2FzIG9ubHkgaW5pdGlhbGl6ZWQgaW5zaWRlIHRoZSBsb29wIGNvZGUgaWYNCj4gPiAg
IHNrYiB3YXMgbm90IHNldC4gQnV0IGFzIHNrYiBjYW4gb25seSBiZSBub24tbnVsbCBpZiB3ZSBo
YXZlDQo+ID4gcGFja2V0cw0KPiA+ICAgY29uc2lzdGluZyBvZiBtdWx0aXBsZSBmcmFtZXMgKHNr
YiBpcyBzZXQgZm9yIGFsbCBmcmFtZXMgZXhjZXB0DQo+ID4gdGhlDQo+ID4gICBsYXN0IG9uZSBp
biBhIHBhY2tldCkgYW5kIHdoZW4gdGhpcyBpcyB0cnVlIFhEUCBjYW5ub3QgYmUgYWN0aXZlLA0K
PiA+IHNvDQo+ID4gICB0aGlzIGRvZXMgbm90IG1hdHRlci4geGRwX3JlcyA9PSAwIGlzIHRoZSBz
YW1lIGFzIEk0MEVfWERQX1BBU1MNCj4gPiAgIHdoaWNoIGlzIHRoZSBkZWZhdWx0IGFjdGlvbiBp
ZiBYRFAgaXMgbm90IGFjdGl2ZSBhbmQgaXQgaXMgdGhlbg0KPiA+IHRydWUNCj4gPiAgIGZvciBl
dmVyeSBzaW5nbGUgcGFja2V0IGluIHRoaXMgY2FzZS4NCj4gPiANCj4gPiBGaXhlczogMTI3Mzhh
YzQ3NTRlICgiaTQwZTogRml4IHNwYXJzZSBlcnJvcnMgaW4gaTQwZV90eHJ4LmMiKQ0KPiA+IEFj
a2VkLWJ5OiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4gPiBU
ZXN0ZWQtYnk6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQuY29tPg0KPiA+
IFJlcG9ydGVkLWJ5OiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4N
Cj4gPiBSZXZpZXdlZC1ieTogTWFjaWVqIEZpamFsa293c2tpIDxtYWNpZWouZmlqYWxrb3dza2lA
aW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hZ251cyBLYXJsc3NvbiA8bWFnbnVzLmth
cmxzc29uQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaTQwZS9pNDBlX3R4cnguYyB8IDggKystLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IA0K
