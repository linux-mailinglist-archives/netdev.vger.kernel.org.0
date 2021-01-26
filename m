Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E436D305596
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316951AbhAZXMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:27637 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbhAZVbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 16:31:46 -0500
IronPort-SDR: 8pOMVKemN4lY857ZIaHGQLj1vbbCzJo2FLCM13Q4+aebCpDfR6pVlJsZOroxVkqnUdpm/t0Ozr
 4oMcUhncKVhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180054872"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="180054872"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 13:31:13 -0800
IronPort-SDR: T5/BCkVopX0Dmj7z3LELbs/A8UZ/i3ti0lUU0AewBEJepjNSeqG2L1w1v916BAM3/2G1HnDe6n
 x6EtiIjfuLCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="362136597"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jan 2021 13:31:12 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 13:31:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 26 Jan 2021 13:31:12 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 26 Jan 2021 13:31:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYSKynjiXA2Oqaa2wIU8ru8+/H/2HwkzhNPqUN2fykgcVqQVNr4373aWAmw8N+s68jWnhlw+G1eK8Qht7XuIIw/jrJ1/BtIZuNdKiZ/kL4juwnqjtUBNa5JtlWFvGI3lB4ZTmk1ArA4Du367na2MfAC4pm1gqELM/wdN1ItPPAo3IhjGJ/bWVDA40ir+PbqUzywj5ImZgjj08TVNEW02F2lUjiPW2sF2GZ2gEGh6l736IMo/siOI/sjbwJdOSnoJR+VLAKbEYuEjhHCe9ZHL2Fb/XGcCpzTdjySOyHOPvloh39DAQaoVqV/yTr9JhPqwd4VCwbpjozrYcXSHRQ5KfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G4W8uE9x5c0182jTaZSb+KEylWJFVpimvn4S+fh4oU=;
 b=ogbi6Smgb9XHS71EMYM/W8AKCzHmPBIemSWVAk/ZaxMdinFL858OkDkRTwbxLIeV8Oa+Drs7k3gfxxxis4c4sv92FqS/e6tEbcwazFD3QTEuhBA6cWcdKhOjvsc8bHrao4N/KEBhkkwptp0SxJKqpyw83+z6TCDjIYY4FrT6zmLzQoR9adr9mrkJ/hw6oUx2J/BRQ0RZNZMxF0r7y6oNIDha6IPuepb1vkv1OEFszbXJeBtRzm5+yyjG7moVTfJKHKWUQOuANmGLiYsDLfKkTz/SSq80wjDeuijw9Mt5dc3F+ThbbBdQ7lMOszX8vuwGJFAwEXxSeYqhK9Y/mbujCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+G4W8uE9x5c0182jTaZSb+KEylWJFVpimvn4S+fh4oU=;
 b=iBxxzBl5x3cw9uuJpDiXqmdKmdpqpg1InES2t/Ti4pNZxLrtLyQpRdpSrNV6z7G+ER0rbzh09G7l1/Gm12cusQ5711hlit6yfLyYUgFDWf/VuVDx4CsJiOqM61+mVrllZZusxCROrAYBOrZsdaa5SM6jTvRuzV9Cw+yLFjIAfO8=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 21:31:07 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6%6]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 21:31:07 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "vinschen@redhat.com" <vinschen@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
Subject: Re: [Intel-wired-lan] igc: fix link speed advertising
Thread-Topic: [Intel-wired-lan] igc: fix link speed advertising
Thread-Index: AQHW885faILNjOENQEmLb8EySK2ntao6VEyAgAAZMgA=
Date:   Tue, 26 Jan 2021 21:31:07 +0000
Message-ID: <b05eb6d7ac2df2aa6db81ca2a51c519daed7ed52.camel@intel.com>
References: <20201117195040.178651-1-vinschen@redhat.com>
         <20210126103037.GH4393@calimero.vinschen.de>
         <20210126120055.001934db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126120055.001934db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7b5acba-6b31-4137-8136-08d8c241b147
x-ms-traffictypediagnostic: SA2PR11MB4811:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4811EB2BDD13DE50109571FAC6BC9@SA2PR11MB4811.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IjiO2Tho0Xkzb5uvYfL/aLYRyER1a2ernzxAwN+hiWr3Mt9/FX9rIuhsuni0WvHqSu++AB7pMuIyeFO12jdNSxCcF5HpetlXd7BHverQErBOSP4PYfJsy4i1b5LHvJwqPzE7JdpfieHbNsjmY6fyhBC/cdYk+F3JACWxaQSnvidXFgKq/MuUgfSmh/ZqiJmTbEgXS9l+QEvSRoI13eXEngtvQinh5pBBM6YPw6x9abdhB6xSMSFgXeNe/E8OJLezUrWGjXvqTVu6T1nyqwIEtQNzFrnlW7+idZHxxsgb/P1e8saxwZYNJmSYP7+sbMhcN4qxa8vs2Hsr5+eWuYMz9+cqxJy971AnI01khbmKwr1upOFoYhuHrBZoL/hlwxH+CCHaNk14mqSlR/tVfjZW5PxYY0WZ/MHJaHrejTGkOCk9fG2zOgX7AD417JIlaC01uyFrC+pfNxPQ1bx+2VoXipGXFmH7jriziEbBJyLNYsTOt3dLRczuWsjWp4HQo2y+4Ewro8kFROnHa2quedg6h7nOJUzzTyvC3hygKt9CuSRoRjstcROOvzFNv31ANAEe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(2906002)(478600001)(26005)(4744005)(6512007)(71200400001)(91956017)(110136005)(186003)(6506007)(66556008)(83380400001)(6486002)(2616005)(66946007)(4326008)(5660300002)(107886003)(8676002)(76116006)(54906003)(36756003)(8936002)(316002)(66446008)(66476007)(86362001)(64756008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RVEybEFWUzRzY3owQXpHdm5XOEMwMFNUTW1nUjVwcTdjbnJtSVBUSkRlc3JV?=
 =?utf-8?B?NXgwN0YrV2VoT1ZHVng1N08xWVZGbzExeUFQWTNaQ01lZXZOcStCZk4raHF4?=
 =?utf-8?B?YXpLa0xNeE1vcWUza3FGN3RJeW9TMUdrUndUdWMwdzlMSGo1blZLMzI0VkZq?=
 =?utf-8?B?V09jMHp0WUVrMUdwVVZhaGI5N1FvcGtkano1WHUwcUxzRUhWcWJXSFhrd3dM?=
 =?utf-8?B?Zk5JNDJWUjlJeXE3TzRyOWc4U01KV1prY25vdDZmNnQ0L2Q0VUNLTkttcEcr?=
 =?utf-8?B?akN6OU1MdHNtUkw3QzladzQ0MnAySGJCZE5XeXdFM3BoZEhTdFFWVzE1dXRU?=
 =?utf-8?B?ZEptdnp6UC81WE1oa1g0YnoxU2cxTDRLR2hOaDZpKzV0ZzVRMmEwOVVyeEV6?=
 =?utf-8?B?OXd4Zit0bjVlYlB5QVUrNy84dU15QU5vM0s4UlFXV0RDaFdiM0dCdEJNalpD?=
 =?utf-8?B?bExuY3hGMmJNN1VKejQzZUI3V0dyaW5YdURkZ2I5Yk13VUNqYUxsUkV2ZXQ5?=
 =?utf-8?B?bmRxckViUHVlNzZHblViMTlTVEkzM1krNE9LSSt5L1hBTjZxVjMzRjhRV0xa?=
 =?utf-8?B?Rms2NlZsNWQ5cmM4RTdubE5nd2NaOXRuWm9leGdFNmtJVkkvZDhoY2Q5bG9z?=
 =?utf-8?B?MmlLb05tMDl1Q3hmaHJzUEJkMEt6aFU4QUFoREIra3EzeHJ0eHVTNnFsM1lh?=
 =?utf-8?B?SThwWTdsSFBEMlZsOVlhUWRBdEgrUG80c0xMS0FYUllKcDRxSkVhc3hEOFpj?=
 =?utf-8?B?NXpIY0RZR3pUWmErMGpVVGhlK01ySEQ0RUF3NUd6SGVPL0hseGxMelJKS1Qw?=
 =?utf-8?B?cXl5eWRlK3VyenNtUGtTenlKc201eVR3VDVvUkVkSS9iSEI1WGZnY0YwQnVQ?=
 =?utf-8?B?SE9vdlVnRndnUHRBQ2RIOUdROXozaERuVmZjZGhhWWhUN3pGQkYrMTRkMXBQ?=
 =?utf-8?B?M1pxNGVTTzN2QXV6bW5ZeTA0V2hBRWR1c2JBV1piSUNTdDBaZkx4bXVMQ0d1?=
 =?utf-8?B?Y2plQWxiMU5PeCtCMEF4QWFqRGE3OU4yMjRRN3phaDhjUWIvNnBUekpMS3Jw?=
 =?utf-8?B?ejg2VXU0Y1dJYndqUXdZT3p2S2IwUzZIMXJzb0dzbklVb0h5QVpLWWd0UWZ5?=
 =?utf-8?B?bHZlV3kzd0haZi80R3cyWkVxTHdvU0EzUHZiSHdNZTB1a2tnL3N5SGhUVmNo?=
 =?utf-8?B?cU1QQnBMMkROQUgvNngvcUtjZ25rSFVXTnFTOGNjSG9ncEUwaWdCaFBmWjIy?=
 =?utf-8?B?ZFFRV09rK0ZQRXNmNVFjSjlRQzlrYzFXWHFhMTZyc0FHWjRtNnZ6a0xuSWpo?=
 =?utf-8?B?WjlGa0tiQk9NUVBXSEtnSXlkMHJaK0pxY3JBOTcxMWFCRFZhZkJtYXUvMVFZ?=
 =?utf-8?B?eWMzWTJMVmU3aEx2ZHBIWW9yQVZuK1d0ZnEySm9mUmoxem5ieFl4dFBQSnF5?=
 =?utf-8?B?WGhmNkNxYkZWejZZM3BQUmQxTTMyaGh0aFg1SnB3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE96EEF398317E4784546ECCCBDDD80B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b5acba-6b31-4137-8136-08d8c241b147
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 21:31:07.4352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +kTDnOFxJUqTy+BpJ46uFTO16GKY/PAs7mi54K+YY3C8RQeBM9wKzY6EjiIdIkMvSvXnQPxD/5SA8+6pdg7wVwQVKYa8CEIBIMjBTJzFc3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTI2IGF0IDEyOjAwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyNiBKYW4gMjAyMSAxMTozMDozNyArMDEwMCBDb3Jpbm5hIFZpbnNjaGVuIHdy
b3RlOg0KPiA+IFBpbmc/DQo+ID4gDQo+ID4gSXQgbG9va3MgbGlrZSB0aGlzIHBhdGNoIGdvdCBs
b3N0IHNvbWVob3cuICBXaXRob3V0IHRoaXMgcGF0Y2gsDQo+ID4gc2V0dGluZyBsaW5rIHNwZWVk
IGFkdmVydGlzaW5nIGlzIGJyb2tlbi4NCj4gDQo+IEFkZGluZyBJbnRlbCBtYWludGFpbmVycy4N
Cg0KSSB0YWxrZWQgdG8gdGhlIHRlYW0gYW5kIHRoZXkgd29uJ3QgYmUgYWJsZSB0byBnZXQgdG8g
dGVzdGluZyB0aGlzDQpwYXRjaCBzb29uLiBXZSBoYXZlIHJldmlld2VkIHRoZSBjb2RlIGFuZCBl
dmVyeXRoaW5nIGxvb2tzIGNvcnJlY3Qgc28NCkknbGwgc3VibWl0IGl0IGluIG15IHB1bGwgcmVx
dWVzdCB0b2RheS4NCg0KVGhhbmtzLA0KVG9ueQ0K
