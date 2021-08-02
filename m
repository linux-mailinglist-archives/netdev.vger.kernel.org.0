Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0297C3DE055
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhHBTyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:54:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:2137 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBTyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:54:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="274584260"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="274584260"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 12:54:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="440696415"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 02 Aug 2021 12:54:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 12:54:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 12:54:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 12:54:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 12:54:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rm1vgwZrO6fOuRRWiY3sx76Cpr+3gpY/9rAo3K5REUSpd395awS8F+hOKYCasC923JOYAA56YP7nL1VLuHeHjD4//UupWi4eCWFfJkg5xaIOdk9PVJWfRCRZEh5Zd5Omlbg1BxPLd3serDpXj8RpMC60o+IXMJuFAUUcIV6c5eztKACpB2C0UmA2+IFCsGeLBG1FdNkJwMCvwH4LeTJmYq3w+02ryDrEvZ3TdwTUCCoXQJLur/8qDx4qFs1JCPffC9fle7fZD7D5tL+fhnb4O+mhJ4f9qZpR1BX9VNmDloZxyZTk1+iOtT0J5WLOZl6o0nagqO48fJgauGKtVtOs0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nGl3zsZUJ1d557Xp2PskZUJXv2twVy3AEytRXZ5dfY=;
 b=WtbmbRVrpEDHwAPjTPXBaPoADA8EMvG3Ch/ZA+azPcwSgtEsnbbFy3TfBqmRm7SQDi+IWAF0QSv7tUhLuSnSspLXp+xcFckC1RZ9LGPn6zds2RCqGmC6CGPkV0KeMtRLLE+PzcKgeuN08xWiy918GQ+y4cVO//WDIxN0Wu2Pk8hQfE7o8mpIBfTCPr+OMK2yyFu2Wzby7Bfjm0jhcnhM9XrF8Zixln99jShHPBeSIfUgzBB8z8DfIkaCg7L3XulE1ZmUklVtehK6xBTdUZE9YP8KNhwVLvyO+r5DowF8sCkYfPYU/ifmCEiqp3M0gZ/Ze0tvYtiVPvQV0SWQuIyXOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nGl3zsZUJ1d557Xp2PskZUJXv2twVy3AEytRXZ5dfY=;
 b=dvqdSYUBRPOrsAbbapOlLoqoySfvKb3pp1kusLf+3dRW2z1SfCxPiQTTl42rduTJN0WRxZ3GDTD1hVprGmAANXtcVuHJlFXWwwXzV0OgeT1ciG8DWOczQfER9pLygGrWXUWajC/8Ls68mODEyOYd5Tw0dK3XIzhpfrnR5+ProFQ=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1933.namprd11.prod.outlook.com (2603:10b6:300:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Mon, 2 Aug
 2021 19:54:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 19:54:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuIA=
Date:   Mon, 2 Aug 2021 19:54:20 +0000
Message-ID: <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
In-Reply-To: <20210802164907.GA9832@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6edff095-9921-426d-db9c-08d955ef51a4
x-ms-traffictypediagnostic: MWHPR11MB1933:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1933832F1627AF58AE7DB584D6EF9@MWHPR11MB1933.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VH3T4XpU4y/yI/HSzTH296HSoeXBmzQF5A5kHLn/FDQyt4UF/J0vVd3+SoJ+aGII78/iLHdwrJNR/bmflnhceTJ/cBHZsfTpS3KrKbPOOgThGXs3AqLfzrI+ZAfrrEcCM/IPtiehvS9xLgMYkOC/0VlIlKybWp8+YU+Wn4wJZBztImRiGVAkKtCXEXAO73NoaByGFmVCKPw1nQ7gYGJjmLC4HHFYj+MySu223QYRQFm1WFegciUFL5J7z1BY0ZHbiPUc/GC3sMgnukWxQVCvvNbVZchFK6mse/FS5plF61+l1HJWzNbh8N4m0X9R8iDlqfPyr2kBDWq6ph5drLq2eH/IBIyNfWwB58cwqFGXFTuwfz7OBPj/INw6jkC95IsZlz0o1m6ExddyTjP5tuKwIEg1h4yfb8TAXbn4j3MFgJM4q3NcJ+5gYKQQCOQQ+AlfuKODlBreYnmEQszraMdUyK0vflgfKIkTHzWuB91DLF4HmUGw9+bE7apcXoGJ6iv4LDCHW3HFuqIyjMEYYTD5/EMl795tioDFAikBO8pS2ho0k1h1CO4XftstLsWL0QdYYBKe19E4E9JmALjiZZou4Bj36C7XzpjdWL1twfGG16qF9vHQovRQCYN8dy5Rg9Off0d1RZBfgq5h8rCiLFU5xkxWvTJgAeOs2n9lNq1NbhorMIjV3V6j389RaOma3zh6dm0ZxlqwhugH0RYWOMy83sH72SrXogZryZ4WcYRWxYelr+kpE1o6p23w0ATlTUBT3VktmUXnHOW7M0XINayNeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(186003)(76116006)(36756003)(2906002)(110136005)(6512007)(38070700005)(53546011)(6506007)(26005)(64756008)(122000001)(66446008)(86362001)(66946007)(66476007)(66556008)(38100700002)(54906003)(4326008)(8936002)(71200400001)(2616005)(31696002)(7416002)(316002)(5660300002)(83380400001)(31686004)(8676002)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkJzRUExUUhIbm5HR0wxdWxxZTJLWmtjUVRzNDNZM00zZW14UTJtS1ZFS3hZ?=
 =?utf-8?B?TzlrZ1JvTW9mazloaGFTcTV1bVFuMVp0UnVuOUplcDNjcUJUT0tmOTVhK05O?=
 =?utf-8?B?b1Z5REp5Q3ZLcVpGNUlzc0paT1VKUUxrTlZWRm4rbElURXg5U25OMVc5ZlR1?=
 =?utf-8?B?aWYxK0lmcjVCdS8xTXh6Y1FIdU12a3c1bXhOZ2pwTytNU3FqcG9aTlBiY2VQ?=
 =?utf-8?B?eFk3emE5d3V5T2xqdFVsb0sxbkg3RGJhWk91Z1A5SlBmZnNVYkRwdGpqMURO?=
 =?utf-8?B?YW9Ld01VMVdkbW5DK1VpaEVNQjNha3V6bjJmY0g1dERsVkRFWTJFNHAxbGJm?=
 =?utf-8?B?UFRDWGIwLzI2Q3AreExEQ1NlU2g3Qk1GSUpLTmlpcG1tUlNyd0tuSzMzYVpZ?=
 =?utf-8?B?WVN6SFNnampJd1J0MmxMdnN6VXdPMXBRbVZhb0kwVFFyQTdXaXRFejFOLzd3?=
 =?utf-8?B?S1JycFBrTCtKZjBzY3VIeFRrNmYvNFV4WkNjNElUdGJvOXBUamdIYXVPbkN4?=
 =?utf-8?B?SUpOTy8rQ0RpWHU3b0tYc2oxWHp2OTZEb0laTmlFODJET3YwdHhyTmNBNWhi?=
 =?utf-8?B?UFBZeDQxeHoxV2FmQW9oU1lhTGQ4aVhXeWNoeXhqbHF5UGp4NFUyYjA0V0tt?=
 =?utf-8?B?dEQzSnMrdTBycFZGcHZMVXJSY09KR0VvbG1QVnFZUGlGYS82SXl1VkJBcDdq?=
 =?utf-8?B?QTk2SmxwNlRKRkZwSzZKMzQ5Z3M0UWNGLzRDOGU0MGZkdWhNMHdCTnU4TmV5?=
 =?utf-8?B?cFFMajZIRnVEcFdoMFFJcUpLSU9Za2ZwRVFFa3dzKzR3OWpsZmwycHdFK0Uy?=
 =?utf-8?B?Q3ZYbGFMajNOWnNsY0U4ek5Bbi9zZitFYmJBUlZTSnpWeldKMzY0WEpJdmRt?=
 =?utf-8?B?YnY3enJzK1RWLzBBMEQ3S2RJUTYzSjNYOGhHcVlzcG1xbVI2R0RRc0lpY3Np?=
 =?utf-8?B?U1F4aVdseEd4bDdjUGQxK2VHNzJ2RVd3MkNwekJuQ01IT1JLcGhVY1hOWGpm?=
 =?utf-8?B?WFhvSmFKYWRNckc3QnZRdFNYN3hwYStnSDNlcVJxanFmUHVxd0VLV0IwSENH?=
 =?utf-8?B?cHRlR2RMWVp3Sis5S2RzOHJvZnBjc1RrbzY4U0V0b3c0V000SzJkY0t0TEJK?=
 =?utf-8?B?R3pQZU8zanNLeXQwaE5rcTFqbVAxTU9SajV4K1N3Y0xHV0lwR2ZKOHJpY1gz?=
 =?utf-8?B?cUVkNDdiS1NUVk5xanFlSzhrVVNBM0xieWx0cHZkTEdIQytpSERGc0Jsb0hE?=
 =?utf-8?B?bFpwS0FiRlRrWC95Qi9IVXNvb0VjS1gzbzA3cmtxZmxRMnRFajBOd0paT2xQ?=
 =?utf-8?B?dXFtOG11bjk2L3FidWtTait2eDFaS0FIWTNVYUpOdDEwQ0VLSlluQVZOaTFz?=
 =?utf-8?B?SnlZK2QrWmVUZSsvU2Vab3U5WGRobUx0bTVMZEJyQjloYnpzb2RERDNQS24v?=
 =?utf-8?B?MEtsUVJzSDRjb1RsUDZ3akJhdEorV3ZyWVdiK3RIR2RnTENHK3gydUlKbGhs?=
 =?utf-8?B?ajJoNzM2Mmkrb2NlL2V6akpyczFzaGNpTVAvZEl1cksrR2FtWmxIT2V6ME9P?=
 =?utf-8?B?V1RvVXdVblRMeVg4WHFualVCRVI4Ny9YbUIraDdScXhQWDNXUHhhemY2dnM5?=
 =?utf-8?B?ekxBRFZ3UG9mbmFsWC9uaE9YQ1RucGwzank5dnJQWHV4OW5vMTJpVU1KcGNr?=
 =?utf-8?B?UDQ4TE1TcDIyWmtvUE10U1FBOTJkaTlrN0dCSENFaG9YcHFMUVRKOGNKbFlw?=
 =?utf-8?Q?6Nzx+5YmcXj/wXyFhc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B83004C25AE6D45B65B0DAFB47905E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edff095-9921-426d-db9c-08d955ef51a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 19:54:20.3724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AG1BF32OMeoZOPKT9JM/XiH/HEDKF+8o2nJbMPdQvp2diOnBrRvNSMwjvWBIUqvg82DE/t3OJJykvTGwf4xsVEDr9sb6hx07kmrttN3ga7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1933
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yLzIwMjEgOTo0OSBBTSwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBNb24sIEF1
ZyAwMiwgMjAyMSBhdCAwNDo1OTozM1BNICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiAN
Cj4+IFRoaXMgaXMgYSByZWN1cnJpbmcgcHJvYmxlbSBpbiBtYW55IGRyaXZlcnMsIGFuZCB3ZSBo
YXZlIGRpc2N1c3NlZA0KPj4gaXQgc2V2ZXJhbCB0aW1lcyBiZWZvcmVzLCB3aXRob3V0IHJlYWNo
aW5nIGEgY29uc2Vuc3VzLiBJJ20gcHJvdmlkaW5nDQo+PiBhIGxpbmsgdG8gdGhlIHByZXZpb3Vz
IGVtYWlsIHRocmVhZCBmb3IgcmVmZXJlbmNlLCB3aGljaCBkaXNjdXNzZXMNCj4+IHNvbWUgcmVs
YXRlZCBwcm9ibGVtcywgdGhvdWdoIEkgY2FuJ3QgZmluZCB3aGF0IHJlYXNvbnMgdGhlcmUgd2Vy
ZQ0KPj4gYWdhaW5zdCB0aGUgYXBwcm9hY2ggd2l0aCB0aGUgZXh0cmEgS2NvbmZpZyBkZXBlbmRl
bmN5Lg0KPiANCj4gUXVvdGluZyBteXNlbGYgaW4gdGhlIHRocmVhZCBmcm9tIDEyIE5vdiAyMDIw
Og0KPiANCj4gICAgVGhpcyB3aG9sZSAiaW1wbGllcyIgdGhpbmcgdHVybmVkIG91dCB0byBiZSBh
IGNvbG9zc2FsIFBJVEEuDQo+IA0KPiAgICBJIHJlZ3JldCB0aGUgZmFjdCB0aGF0IGl0IGdvdCBt
ZXJnZWQuICBJdCB3YXNuJ3QgbXkgaWRlYS4NCj4gDQo+IFRoaXMgd2hvbGUgdGhpbmcgY2FtZSBh
Ym91dCBiZWNhdXNlIE5pY29sYXMgUGl0cmUgd2FudGVkIHRvIG1ha2UgUEhDDQo+IGNvcmUgc3Vw
cG9ydCBpbnRvIGEgbW9kdWxlIGFuZCBhbHNvIHRvIGJlIGFibGUgdG8gcmVtb3ZlIGR5bmFtaWMg
cG9zaXgNCj4gY2xvY2sgc3VwcG9ydCBmb3IgdGluaWZpY2F0aW9uLiAgSXQgaGFzIHByb3ZlZCB0
byBiZSBhIG5ldmVyIGVuZGluZw0KPiBzb3VyY2Ugb2YgY29uZnVzaW9uLg0KPiANCj4gTGV0J3Mg
cmVzdG9yZSB0aGUgY29yZSBmdW5jdGlvbmFsaXR5IGFuZCByZW1vdmUgImltcGxpZXMiIGZvciBn
b29kLg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJkDQo+IA0KDQpTbyBnbyBiYWNrIHRvICJzZWxl
Y3QiPw0KDQpJdCBsb29rcyBsaWtlIEFybmQgcHJvcG9zZWQgaW4gdGhlIHRocmVhZCBhIHNvbHV0
aW9uIHRoYXQgZGlkIGEgc29ydCBvZg0KInBsZWFzZSBlbmFibGUgdGhpcyIgYnV0IHN0aWxsIGxl
dCB5b3UgZGlzYWJsZSBpdC4NCg0KQW4gYWx0ZXJuYXRpdmUgKHVuZm9ydHVuYXRlbHkgcGVyLWRy
aXZlci4uLikgc29sdXRpb24gd2FzIHRvIHNldHVwIHRoZQ0KZHJpdmVycyBzbyB0aGF0IHRoZXkg
Z3JhY2VmdWxseSBmYWxsIGJhY2sgdG8gZGlzYWJsaW5nIFBUUCBpZiB0aGUgUFRQDQpjb3JlIHN1
cHBvcnQgaXMgbm90IHJlYWNoYWJsZS4uIGJ1dCB0aGF0IG9idmlvdXNseSByZXF1aXJlcyB0aGF0
IGRyaXZlcnMNCmRvIHRoZSByaWdodCB0aGluZywgYW5kIGF0IGxlYXN0IEludGVsIGRyaXZlcnMg
aGF2ZSBub3QgdGVzdGVkIHRoaXMNCnByb3Blcmx5Lg0KDQpJJ20gZGVmaW5pdGVseSBpbiBmYXZv
ciBvZiByZW1vdmluZyAiaW1wbGllcyIgZW50aXJlbHkuIFRoZSBzZW1hbnRpY3MNCmFyZSB1bmNs
ZWFyLCBhbmQgdGhlIGZhY3QgdGhhdCBpdCBkb2Vzbid0IGhhbmRsZSB0aGUgY2FzZSBvZiAiaSdt
DQpidWlsdGluLCBzbyBteSBpbXBsaWVzIGNhbid0IGJlIG1vZHVsZXMiLi4uDQoNCkkgZG9uJ3Qg
cmVhbGx5IGxpa2UgdGhlIHN5bnRheCBvZiB0aGUgZG91YmxlICJkZXBlbmRzIG9uIEEgfHwgIUEi
Li4gSSdkDQpwcmVmZXIgaWYgd2UgaGFkIHNvbWUga2V5d29yZCBmb3IgdGhpcywgc2luY2UgaXQg
d291bGQgYmUgbW9yZSBvYnZpb3VzDQphbmQgbm90IHJ1biBhZ2FpbnN0IHRoZSBzdGFuZGFyZCBs
b2dpYyAoQSB8fCAhQSBpcyBhIHRhdXRvbG9neSEpDQoNClRoYW5rcywNCkpha2UNCg0K
