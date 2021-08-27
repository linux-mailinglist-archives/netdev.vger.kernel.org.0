Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0743FA1E6
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 01:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhH0Xk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 19:40:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:60050 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232524AbhH0Xkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 19:40:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10089"; a="303620893"
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="303620893"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 16:40:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,357,1620716400"; 
   d="scan'208";a="599436034"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 27 Aug 2021 16:40:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 27 Aug 2021 16:40:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Fri, 27 Aug 2021 16:40:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Fri, 27 Aug 2021 16:40:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5yr/YbgcuQULEh9NnSaq9cE6MDq5Ae7Ya2VYqThGdg4psUKXSsPib74damm4si/VunrOFTSpDa+/4Q9yviypcM8Uz337EI1dhsfmSk2DA/2XH/bw/1rYI6+UJL/UdAs+SGkkKynWbc4qVzp80Lxc4kW4KZkHzi9sfJa2EUz941mv74bfO1P6NpKmyXshxpP+40ySuNbqKuhYF2HasBnxL7d08rLDnucHD2vQNOK2F807pWimt7333Ftpf1s198+lAjajkBzNfWqx7dHNnaYi+aFb1HBMiJyU5UGxnwC/8EjzUYW2bYbeSXOMbA5RNPS5Rhs4ea3tlA90mHtn0hAmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXnenENzKf9ItZnCAN4PJrFSzItdtDcPQWCH59q3nA0=;
 b=igRNPAqKTkxZ42H4DDVlcgIukdPYYxlTDK9lwLgTT6EufPJKlOY/yZK9L/ZP+vOR07k34EH/u93dPVmGYdIxQurHoGOjOVkq2ne0oodyBkHhDceL9LheKiJ9RTBHkbt5xZun8igt8VGmV0vqBBQPv0l+h5UwTdsPHk5ArUvFiPiZIA8CPf/tu3JP9M7ttRxv+8aJ2NZGS4B/Vskp8Jp1Qe9zcL/lRu6htqPG9iTjqRzoLbnbSq2gQMht/ivugpgcdjgFU0LZWq24aFS4Gc9HQJR49ndnfKPwLqcR1Qz8S70eXErp44Mx1SA7WH8B1LOBwISMgJ4YkHZ0+5PkHNBh9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXnenENzKf9ItZnCAN4PJrFSzItdtDcPQWCH59q3nA0=;
 b=WF3IuoW7H8EbVCUCQ0x5+Eu2hgRmQLIFSTJClwNd4v7VN0mAIt8UTuVKzT8XHo7CBoSbyKT9P+MznCMFN36rsBB7+vz1PvjlCm4bvHKmNmxHdW4UTuH942yNF+who/FDey9hohi72Y1GwTTkCcNggFtuAbOJaTIDbW2edckyUWA=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Fri, 27 Aug
 2021 23:40:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4457.023; Fri, 27 Aug 2021
 23:40:02 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] igc: optimize igc_ptp_systim_to_hwtstamp()
Thread-Topic: [PATCH] igc: optimize igc_ptp_systim_to_hwtstamp()
Thread-Index: AQHXm2cxSBuJgNWlv0ClU8o5SUI9xauIA/OA
Date:   Fri, 27 Aug 2021 23:40:02 +0000
Message-ID: <73b1637111236bebeeff08d3275ddd5d1da9637d.camel@intel.com>
References: <20210827171515.2518713-1-trix@redhat.com>
In-Reply-To: <20210827171515.2518713-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00dca93c-6c1a-4aaa-6ebb-08d969b3fddc
x-ms-traffictypediagnostic: SA2PR11MB5195:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB51958DAF900669747E26455BC6C89@SA2PR11MB5195.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:230;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ilmHkpeGfvBlGLdZr23bxSNka6l245WP9SDWbxl3zeFhjU3GHEJ/uRLAO03nMM2K24WQuaCtC5lmwTE38rEUMYGp0z53Xzr2nOZoKBthpN5090EvUWyCGwG/y8BHPaiChQCusuviccE8SqEdNSBv3FlkaO7umNWmmxB2YAFszEDCgERqoovlvdGhrUNy8OlPeWnZjJeSpMVt2DIIooW+Bc8YrDAa9R3Dwk3X2KySCehPBm7YtZH3ns/jfdOgMzIb2FrUkVg/Ac0N8qmMnV135uzli1eN998JdTe+T2g1rzBrc8U+Gr/rU5vlRNRu6vyDMqOkvH5TmE7rWykdY/ZHmx1MOpUqpsEr9flPt1C3f1n221WUUwpCZjCFxmTZAT0gH6/Lc0iZWjOWEckKj846uYLqhfOc4lybaEGRjJdVMbqoOlcMnHU0UwDMUSK9IMO+fgOhiGL1nhIT0SyLB9L4rSCCcBLwDK/XVFRvLbqBjfVpkQ74vMkRgyUZ29qMm6GCzoNf9R79CGnmkcdgMszGAjdbT0ZoopClP/ft/kkM3Y0NWXpNG9DSCyF9VvMiT7Sg+2ZToG+1R193QheGRCLWuZ9ew55Ja/L9MJ4ga4vioa+dMRB7ZKw4toRstXe2o52kCLLckT6r4WVpCMX1U5RO3u/JB/XEO4ryvxdi4GZYrdo7WWfDMuQLeXr0G7/d76lFjEOLKUuqmXQYadMSuJOgsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66446008)(6486002)(66556008)(5660300002)(66476007)(6506007)(26005)(38100700002)(38070700005)(2906002)(8676002)(122000001)(91956017)(8936002)(66946007)(76116006)(71200400001)(6512007)(4326008)(2616005)(54906003)(110136005)(186003)(508600001)(316002)(86362001)(83380400001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEx4UDd1czZpZ2YvcFJERG9jcG1EQ3JpMFhlM1pEYUJ4TFhWdWZDRTNSa3Fh?=
 =?utf-8?B?WmZ0bkJQdTZoaHhmT3lDWHMzcW8zNUVseVB0a3ZNZFVYRis3SUFzc2t5OHRs?=
 =?utf-8?B?N2c2UFY2TmpzWGNnSlFzS1BVeDROUjJWeUdEcjVJNnlvbTBwaFdZdGtDYmdN?=
 =?utf-8?B?alJwdDd0ellPeUlDUUNDdmF0R1IzYjQ3ZE5RcGN4VGYzU2x3dVJSN0MyKzJC?=
 =?utf-8?B?dEFudjMvR1ZYNFhUN1BYR2JGQ1JmWGFkSDBHM1IrN0FsOXNOaXYvQUNrbWFY?=
 =?utf-8?B?YjQzYUwxaDl4N01udTVVeXRWQTJMNGI3cndONGd5U3lCUkpvcUhkTFh6cmZR?=
 =?utf-8?B?S1Z5OHBzUVZ2UDRXQkljUTF5MGQ1TzFhYjNXOWVtYUdjU0ZUOVUvZ0R5aDhR?=
 =?utf-8?B?TisyZVZ1V0R2QWxZS0VML1ZFZ1oyTXBCOE5GVGlMSWYreVBsMG5UdTB1WDVp?=
 =?utf-8?B?dHZPeUdJQVdveS9hR3ROclhLUU1RTWduMk03bENIQVJ1L1VocWdQN1ZCVWJT?=
 =?utf-8?B?M1JWcUFkbkpnY21oM2V6NFprbTJFSUM0Ukp5c1VtcmRaLzNuWmoxU0dMbVo3?=
 =?utf-8?B?Tm5GQmJOUEZsYmJvNzdzaGZBN05FdDBBQmVtWVdmblVoTU1wOXhoQUxrNWJZ?=
 =?utf-8?B?OWFabEJFOWk1b0dLTUFHaGtsOGRZNU9EUHBQMHdURGpFZ1NWeUJGNEdQV2hD?=
 =?utf-8?B?anpmUzczTmZwdWRFb3E0Nmttek54ZjhtZGhubWRhOTVYRGVGTENZUVZiZDhH?=
 =?utf-8?B?QmdjS0s1K2poODhET0NoRWd3YTR1YjhrdHphU0hiQlRjaGNpL1VFU0pvbVJj?=
 =?utf-8?B?eTQ4S0J6NkVoNEpXa1h2N1RTWENwdkVBZmZ6OWYwMDR4WjMzMExQS0ZBaTVs?=
 =?utf-8?B?TnQwOFRQYTZSSHorOHRtUzRENFlVWmNUMFJETkw1MlRXZDZORHlaQzVXVGlO?=
 =?utf-8?B?d2JyYXNtK0VjcEdOSk1xdUgxVEc1MHRyZTdseWFLMWlaTmhzM2NEZU9LbVRJ?=
 =?utf-8?B?Vjd4Z0pTY054ZW9DbE5pakZlVkxrYmZiKzMyN0RkWDc1SW1WRndaYmFQMHlm?=
 =?utf-8?B?cnNpTjZUQ3hkQ3Mra25zUVFEVnNmNmNYbmhIRjZ0RFZGUkx6WkJwVzhKUjhF?=
 =?utf-8?B?aThGbzhITFdzUnhEWEFheXA2SS9vYjNDK21vbWc3c2tvZUYzcURKOHUzSVdl?=
 =?utf-8?B?TGtqUTRqd1JBeTlCYkpZUjRiNVB6L3RMaGw1aVlleWEreHMzdVA5ODZxeXVX?=
 =?utf-8?B?VnZld2hUeHRteG9HQnJkYTVGU0NhcnVqOWtSL2VTOFptcDM2WUsxbGxoN0w5?=
 =?utf-8?B?WFNmTUdqYjFWcTBxNnY0WnVVME5lS1RNRXRaT3dYN2Y1QlFhVUF5UFNkaURX?=
 =?utf-8?B?Z2dkRDFlTjJLd0xjUnhaVS9ST3hzci9mYUttb1l5aEtqVC9KSVh6cFZqUktQ?=
 =?utf-8?B?T2cxNFNNU3drbTQ0SW9mNWQySWtjNHN6cXgwVGVhaFVuWlo2cGlUV1o3cEsx?=
 =?utf-8?B?WGk4OTFqaDBtS1QzcUJPVFNJTm90bjVJSGdwK0pib1dCTHlHcndqT3FKZnNh?=
 =?utf-8?B?K0tGNUJMWUVDYWYwSkxDYnpzQnBYb3hMc0thWSt2YjlwL3BSRGdnZ285TEpa?=
 =?utf-8?B?cUI4TXZWYnZueGlTWTdwUzdkc09HZnRYSFVTUm9PV25GbGFEWGJldHU4WWRT?=
 =?utf-8?B?bmJ5c2QxVm1YZm90bnExQkFuZ3RYaXhYWlJZZVFBdC9qYWNNY0ZMS3VqU2hR?=
 =?utf-8?B?ckt4d0l3OVNXQ2FVZlhKM1VoS0Q5ZkVjRXJvLzVHL2NiU25pcS9lSGRxNXN5?=
 =?utf-8?B?eStqOUc4c2tNVGRiRGwwUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B13713A3175AFA4DA2D459E6B9D3A747@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00dca93c-6c1a-4aaa-6ebb-08d969b3fddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 23:40:02.7371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u6P5eYZbrhsSurT3q2oVubHEWyVmvUa6XkT4TgeRkLale1NvifY+gCsfMawPh/LDaGGbdH7O0GxiEItFeFfblcnek6y0tmyo98SxL+wIjyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA4LTI3IGF0IDEwOjE1IC0wNzAwLCB0cml4QHJlZGhhdC5jb20gd3JvdGU6
DQo+IEZyb206IFRvbSBSaXggPHRyaXhAcmVkaGF0LmNvbT4NCj4gDQo+IFN0YXRpYyBhbmFseXNp
cyByZXBvcnRzIHRoaXMgcmVwcmVzZW50YXRpdmUgcHJvYmxlbQ0KPiBpZ2NfcHRwLmM6Njc2OjM6
IHdhcm5pbmc6IFRoZSBsZWZ0IG9wZXJhbmQgb2YgJysnIGlzIGEgZ2FyYmFnZSB2YWx1ZQ0KPiAg
ICAgICAgICAgICAgICAga3RpbWVfYWRkX25zKHNoaHd0c3RhbXBzLmh3dHN0YW1wLCBhZGp1c3Qp
Ow0KPiAgICAgICAgICAgICAgICAgXiAgICAgICAgICAgIH5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+
IA0KPiBUaGUgaXNzdWUgaXMgZmxhZ2dlZCBiZWNhdXNlIHRoZSBzZXR0aW5nIG9mIHNoaHd0c3Rh
bXBzIGlzDQo+IGluIGlnY19wdHBfc3lzdGltX3RvX2h3dHN0YW1wKCkgaXQgaXMgc2V0IG9ubHkg
aW4gb25lIHBhdGggdGhyb3VnaA0KPiB0aGlzIHN3aXRjaC4NCj4gDQo+IAlzd2l0Y2ggKGFkYXB0
ZXItPmh3Lm1hYy50eXBlKSB7DQo+IAljYXNlIGlnY19pMjI1Og0KPiAJCW1lbXNldChod3RzdGFt
cHMsIDAsIHNpemVvZigqaHd0c3RhbXBzKSk7DQo+IAkJLyogVXBwZXIgMzIgYml0cyBjb250YWlu
IHMsIGxvd2VyIDMyIGJpdHMgY29udGFpbiBucy4NCj4gKi8NCj4gCQlod3RzdGFtcHMtPmh3dHN0
YW1wID0ga3RpbWVfc2V0KHN5c3RpbSA+PiAzMiwNCj4gCQkJCQkJc3lzdGltICYgMHhGRkZGRkZG
Rik7DQo+IAkJYnJlYWs7DQo+IAlkZWZhdWx0Og0KPiAJCWJyZWFrOw0KPiAJfQ0KPiANCj4gQ2hh
bmdpbmcgdGhlIG1lbXNldCB0aGUgYSBjYWxsZXIgaW5pdGlhbGl6YXRpb24gaXMgYSBzbWFsbA0K
PiBvcHRpbWl6YXRpb24NCj4gYW5kIHdpbGwgcmVzb2x2ZSB1bmluaXRpYWxpemVkIHVzZSBpc3N1
ZS4NCj4gDQo+IEEgc3dpdGNoIHN0YXRlbWVudCB3aXRoIG9uZSBjYXNlIGlzIG92ZXJraWxsLCBj
b252ZXJ0IHRvIGFuIGlmDQo+IHN0YXRlbWVudC4NCj4gDQo+IFRoaXMgZnVuY3Rpb24gaXMgc21h
bGwgYW5kIG9ubHkgY2FsbGVkIG9uY2UsIGNoYW5nZSB0byBpbmxpbmUgZm9yIGFuDQo+IGV4cGVj
dGVkIHNtYWxsIHJ1bnRpbWUgYW5kIHNpemUgaW1wcm92ZW1lbnQuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBUb20gUml4IDx0cml4QHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaWdjL2lnY19wdHAuYyB8IDE4ICsrKysrKy0tLS0tLS0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdjL2lnY19wdHAuYw0KPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfcHRwLmMNCj4gaW5kZXggMGYwMjE5MDli
NDMwYTAuLjE0NDNhMmRhMjQ2ZTIyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pZ2MvaWdjX3B0cC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2lnYy9pZ2NfcHRwLmMNCj4gQEAgLTQxNywyMCArNDE3LDE0IEBAIHN0YXRpYyBpbnQgaWdjX3B0
cF92ZXJpZnlfcGluKHN0cnVjdA0KPiBwdHBfY2xvY2tfaW5mbyAqcHRwLCB1bnNpZ25lZCBpbnQg
cGluLA0KPiAgICogV2UgbmVlZCB0byBjb252ZXJ0IHRoZSBzeXN0ZW0gdGltZSB2YWx1ZSBzdG9y
ZWQgaW4gdGhlIFJYL1RYU1RNUA0KPiByZWdpc3RlcnMNCj4gICAqIGludG8gYSBod3RzdGFtcCB3
aGljaCBjYW4gYmUgdXNlZCBieSB0aGUgdXBwZXIgbGV2ZWwgdGltZXN0YW1waW5nDQo+IGZ1bmN0
aW9ucy4NCj4gICAqKi8NCj4gLXN0YXRpYyB2b2lkIGlnY19wdHBfc3lzdGltX3RvX2h3dHN0YW1w
KHN0cnVjdCBpZ2NfYWRhcHRlciAqYWRhcHRlciwNCj4gLQkJCQkgICAgICAgc3RydWN0IHNrYl9z
aGFyZWRfaHd0c3RhbXBzDQo+ICpod3RzdGFtcHMsDQo+IC0JCQkJICAgICAgIHU2NCBzeXN0aW0p
DQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgaWdjX3B0cF9zeXN0aW1fdG9faHd0c3RhbXAoc3RydWN0
IGlnY19hZGFwdGVyDQo+ICphZGFwdGVyLA0KDQpQbGVhc2UgZG9uJ3QgdXNlIGlubGluZSBpbiBD
IGZpbGVzLCBsZXQgdGhlIGNvbXBpbGVyIGRlY2lkZS4NCg0KPiArCQkJCQkgICAgICBzdHJ1Y3QN
Cj4gc2tiX3NoYXJlZF9od3RzdGFtcHMgKmh3dHN0YW1wcywNCj4gKwkJCQkJICAgICAgdTY0IHN5
c3RpbSkNCj4gIHsNCj4gLQlzd2l0Y2ggKGFkYXB0ZXItPmh3Lm1hYy50eXBlKSB7DQo+IC0JY2Fz
ZSBpZ2NfaTIyNToNCj4gLQkJbWVtc2V0KGh3dHN0YW1wcywgMCwgc2l6ZW9mKCpod3RzdGFtcHMp
KTsNCj4gLQkJLyogVXBwZXIgMzIgYml0cyBjb250YWluIHMsIGxvd2VyIDMyIGJpdHMgY29udGFp
biBucy4NCj4gKi8NCj4gKwkvKiBVcHBlciAzMiBiaXRzIGNvbnRhaW4gcywgbG93ZXIgMzIgYml0
cyBjb250YWluIG5zLiAqLw0KPiArCWlmIChhZGFwdGVyLT5ody5tYWMudHlwZSA9PSBpZ2NfaTIy
NSkNCj4gIAkJaHd0c3RhbXBzLT5od3RzdGFtcCA9IGt0aW1lX3NldChzeXN0aW0gPj4gMzIsDQo+
ICAJCQkJCQlzeXN0aW0gJiAweEZGRkZGRkZGKTsNCj4gLQkJYnJlYWs7DQo+IC0JZGVmYXVsdDoN
Cj4gLQkJYnJlYWs7DQo+IC0JfQ0KPiAgfQ0KPiAgDQo+ICAvKioNCj4gQEAgLTY0NSw3ICs2Mzks
NyBAQCB2b2lkIGlnY19wdHBfdHhfaGFuZyhzdHJ1Y3QgaWdjX2FkYXB0ZXIgKmFkYXB0ZXIpDQo+
ICBzdGF0aWMgdm9pZCBpZ2NfcHRwX3R4X2h3dHN0YW1wKHN0cnVjdCBpZ2NfYWRhcHRlciAqYWRh
cHRlcikNCj4gIHsNCj4gIAlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gYWRhcHRlci0+cHRwX3R4X3Nr
YjsNCj4gLQlzdHJ1Y3Qgc2tiX3NoYXJlZF9od3RzdGFtcHMgc2hod3RzdGFtcHM7DQo+ICsJc3Ry
dWN0IHNrYl9zaGFyZWRfaHd0c3RhbXBzIHNoaHd0c3RhbXBzID0geyAwIH07DQoNCk5lZWQgdG8g
cmUtb3JkZXIgZm9yIFJDVC4NCg0KVGhhbmtzLA0KVG9ueQ0KDQo+ICAJc3RydWN0IGlnY19odyAq
aHcgPSAmYWRhcHRlci0+aHc7DQo+ICAJaW50IGFkanVzdCA9IDA7DQo+ICAJdTY0IHJlZ3ZhbDsN
Cg==
