Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489683C9296
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhGNUzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 16:55:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:19160 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhGNUzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 16:55:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10045"; a="197694872"
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="197694872"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 13:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,240,1620716400"; 
   d="scan'208";a="505461088"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jul 2021 13:52:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 13:52:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 13:52:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 13:52:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjdk14Lqma72GqU7hY5ajUM9CaOeRrPOsZKZ/RAB80syvqu1M3rsS378cJ+8/snr9quDyuBo/WGpB0jn+IATyLh74FGQpJREZogLZa4vn6CuZUug0uPz6KECtMF2Z7t9riig+pNfgJhktS1D/+gopcxgV2c5wcZl4xMSoY9BHYMFhS57QUwCMSysnJiDfiESyiYIDV1rb5HqYK5Q2nkDC/zJXZJ8BJWiFtUAdDW2R+dS0DWkZr+eTaOcWVRzvtlFsD3jXpsxtVr1D0bqEWSv+5UAPZSklUW0mYqwlS6vPdIAXjYYYJHqF3fuIbk9RDDHECyKJmWe6A8YSdk/dM1vUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEslGUVSA6XiCgR8bTI+eaeSQvcQoEp8RGWKXCpSyGU=;
 b=gv/CrpvT5pcGgJQe6OZhKUxFgAmG/CdJOXcUMgj2yHW9NWJdekn3BDZSTrWX33p7lhsssT4/iNEzTOTFCVHVLYYEYqXsdZ/VZb7KkHZs5g3vNJHGkBoTs8tOxZ1vJbdyl6DKWr7Cxy4OQNfHPZcLNeBAHXCTqsasdZ0D2p99hdUO3HcmpqvFhoOs68ZcsnfbJydYB8W7hcxXztWZ4ZMiI1+Pk9hyy0qaEDQ+YZd/BRetluJyS2DZhIaYIuVDwezUKbV/5K+/9alot21aHbDxXWN8G8FGE/Co7pMf0YFGGc+kqVjr7vSulF8wdlCPAs41r7ZVzGVvyxjEfxdr7hpxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEslGUVSA6XiCgR8bTI+eaeSQvcQoEp8RGWKXCpSyGU=;
 b=WasckFjukdwtHlwbR4hsc1J930SPfM7nM5GPPhbtkYGKynWFcz04NBgCgipS2zoONGvVCOPk1kmg3DSAO0vvtgmNQjddkqN5aVZKVMjq9/rHx82KvwUBDC6Dr112WWEJYjevhc5xgKb+BE1VN/tLozX0LcAtGlYFLGDbrjL2udo=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3518.namprd11.prod.outlook.com (2603:10b6:805:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Wed, 14 Jul
 2021 20:52:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4331.021; Wed, 14 Jul 2021
 20:52:32 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kerneljasonxing@gmail.com" <kerneljasonxing@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "hawk@kernel.org" <hawk@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "xingwanli@kuaishou.com" <xingwanli@kuaishou.com>,
        "lishujin@kuaishou.com" <lishujin@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] i40e: introduce pseudo number of cpus for
 compatibility
Thread-Topic: [PATCH net] i40e: introduce pseudo number of cpus for
 compatibility
Thread-Index: AQHXcxRXDa+iEt2Iok+2H8F0lm/YOKs6PZsAgAjBcQA=
Date:   Wed, 14 Jul 2021 20:52:32 +0000
Message-ID: <03b846e9906d27ef7a6e84196a0840fdd54ca13d.camel@intel.com>
References: <20210707094133.24597-1-kerneljasonxing@gmail.com>
         <CAL+tcoCc+r96Bv8aDXTwY5h_OYTz8sHxdpPW7OuNfdDz+ssYYg@mail.gmail.com>
In-Reply-To: <CAL+tcoCc+r96Bv8aDXTwY5h_OYTz8sHxdpPW7OuNfdDz+ssYYg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04217212-02eb-4795-cd2b-08d947094d07
x-ms-traffictypediagnostic: SN6PR11MB3518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB351888ED04CF63C80A59564DC6139@SN6PR11MB3518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ETh2ZtBTIVszVZRSTx5xezjfaPYtkUErb6Xe7lPM+6zDDSL8ta1dqX1ggmDD0+Ik3/N29bHZYZ10JDkgclohcuy3YHwteq+DJxkcO84xtJOZXLjZyIaw+2S7RiBIN1A7Ln43CygyI4h7xo5P9IgIfd9gpIrt9DNeHPHpO/SenxZqR/5LkxWaJtI6jtk94O0QL7Hr5QTPD5+TkYX2fngdz/m/PARqQYOis12PRSrmFHcaggY3Rrhv+QE+0dVi5iYhvc/gY0h4M9260R1mflUlwlVKcNm1rjNHpQCAojiIyDmA/+0Xb+XUbROzEXBfXAq4oX9RyWVqOLmtCRzqtTzAbLfDZ/Z0VtD6vi7uFh45SAQ7auLyhr7nSemQVBcYMyjcXCpHJkv1nC5VgNDGjXl/tFlDuPvhp90zwvf/JVhxBK8i7m71zWCaCWP9SkUeQKDsZZ0Zgwv7P/m9FXQGEnMy5leeWK14tOCIYAIYwNCRok6lQQhhUcxvlNLwIBmCVz+9Wnl77qT1FFs5iai2QIWhY8NLu7DWQgPH2zDWUmg5TeQz4XbyL5lK3icgrno/F2ef4eZRuVsxELUGX47sfDF56QJEYK95rrKw9VELFfyPcO42ddixSdd4hREk1Iddd3CgJAUyKWDN7WPjdIQm1RFyWp+Ixpm44ASLMUf0b7WPTt0aDbKgAmhd0FD0lpgQu0MQki4TtyS3orhmUU2M9N8ou2PvlG6/jexniqq74zPETA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(6506007)(4326008)(5660300002)(71200400001)(2616005)(8676002)(86362001)(83380400001)(122000001)(6512007)(66946007)(66556008)(2906002)(921005)(7416002)(478600001)(26005)(76116006)(91956017)(66476007)(36756003)(186003)(66446008)(6486002)(54906003)(64756008)(110136005)(316002)(38100700002)(8936002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q095amxBREl2SWJiVTR2b1psQkRKQWtxRjhrNmlqempYUVNvSlAzQjBlSDh2?=
 =?utf-8?B?UUEwMmwxZFlIQ0pLVEs4aEswUmNKWXlYMSt0eFNxd2xPZXpVN3dyK2JwMDJC?=
 =?utf-8?B?ODN5NXcyR2VCaElieEV2RFc5YWJTc3pwTXFNK05ZNVlsZ0Y4a2UzMHJCODlC?=
 =?utf-8?B?b0pIODRZUkRzcTVRbWNlTGdjRHRoc1kxcFY2SDZ5R3NObUNHS0t3OFpHSHdu?=
 =?utf-8?B?SmJ6T042c1lxVHJOU0VLMHlQK3NVbHNTRTQwWnBFeDJZU3J0L290TWVZbW01?=
 =?utf-8?B?d0NwbjVZdGVIU2JwSCtNQUdMMXVNVXhiNFpCZFVLSFNGWlVPOENPdWJ6WVpm?=
 =?utf-8?B?ZTFSZlBQVzF5Qzc1RzZ3VzlXMlhITXJjNzVuR25RMTA1dFRTNTllcWFpZ2Jz?=
 =?utf-8?B?K20xM21mTFVuQWlhcTM2YzZWQ1BzUUNwSWZLYk1nTEdFYnllNWk4eUhyRytD?=
 =?utf-8?B?TlpkTHIrR0xHZmpxL2IzdlUxNWtoM3BtQjRvVmRMNXFPeUdrcTFPN3RrdWRP?=
 =?utf-8?B?K2loQ3g5eHNvZnlab2tiRXZ6WmtSYUU3Tmo3NURhTEUyNlBxWHYrTFZYV3ZS?=
 =?utf-8?B?UXFGZkZKSFNLL3ZjRVI3MTNaUEo3eVVIZndmUHp2SnZTNU1CRHVNcFBobm9m?=
 =?utf-8?B?ajJxdEgvd0xlWGdvSWNDaklhQjAyWFdFUGNCZXlKckNEaW1LQ1loQ0taYkx1?=
 =?utf-8?B?eGRUS0srMzYwNWdQU0tKRG5CbUlkdHFIU0habGladkVpMmRaRTVuaHlzcHoy?=
 =?utf-8?B?TXZSYWtiS0E5VE5UVFJydDlKTkM1dWRkL2Exai84VkRzYjY5U2NyYW1oa3p2?=
 =?utf-8?B?REJydVZraDA3NkNCU1pVRytsbm9lc3VyOVlvWlgzZDdFd3NLb2VZSkJTSmRm?=
 =?utf-8?B?UzljU0M5T1EybmJ5Si9NU1RJaGhNTUlOUHVoc3hLV29ERVk5N2l5MDF5R3Jz?=
 =?utf-8?B?VU9FT1A2aVRHanlzUzJOQXQxTEllY1dFdHBVYjArcnY3eE1NNnozUlZBVDUv?=
 =?utf-8?B?a2w3dWtzYVZrOStpeTFERzZ2a2t3Vm1UVUF5a2U0NVdzNjd6Q2lqRnA5OVVY?=
 =?utf-8?B?S0pYM1lxUExkVUdtZlRXbGcrWG12Q2JxdnB6WmNjS0orSmtvS0NVb25tTjBL?=
 =?utf-8?B?VCtHVTBEZ0EvbXhjU0lVRnFVYi96Zzd2RWJzanpGRmVYTVQwQUg5T2R3bkNp?=
 =?utf-8?B?SGI4TlJxUTAxZXZxYzkxRVI3VDNmNUhSRStERjc4aGtkRW9YN2R3ZXZCSnQz?=
 =?utf-8?B?YmtHaUhkeUhWNzFRWVQ3NTU2VzFCM3MyT1dWQlRNTFBsTmZpSGJoZHpiMHBi?=
 =?utf-8?B?cWNSYWtObk5oQ0pyeVUvVUt3K2R5QkhoSVhrcUZUVkk5ZmFFRGhJOVVCUXVo?=
 =?utf-8?B?elh3R0NnNlZQeDV6d2M1Z3dVSEhoeFJRMjBjSTdORXJDU2N1MmhjeklXajMw?=
 =?utf-8?B?b0E0Q2swMlNiaHRDSHVWWkxNcXFYWE53SCt0eWNNOVhJRHBvcjVQNmtYZUoy?=
 =?utf-8?B?VDJkbjVPaVQ2dWR4a1VPcm5CQ25KZFhtdHdQN3ZIMVhhVmxxd3JwYU1Xb3NO?=
 =?utf-8?B?TWRJYmYwdDhUM2k2NHJWTE1tbzFwQm41d2xjbXA0c2ZwSDRrVmJtL2RBOFZ3?=
 =?utf-8?B?VVpraU1ycXExZyswcnRxNnNRSnlmQUtFUXVHMWljNzlNZVZCVE02RGpBS1BJ?=
 =?utf-8?B?bHVwRndtMHgzUXQ2alVhUW1GQjJEY3J2MFE2bkREZHpsVFpPUWhUNkRNNjhC?=
 =?utf-8?Q?IVqp7OKaU1F3Y+jyblK9hgGRPfOMPncdqAbx3Qs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A915B6BE7717A146BBD06846EC504E8E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04217212-02eb-4795-cd2b-08d947094d07
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2021 20:52:32.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+p9QRQo9Ydp1MeVtnDg2sVPzRLfmccgxzd9YSl/S9IS+HEmh7YRw7ex3ds5H2mPl/8aZ2mHZXQnjHMQHHqZOTCKkgYsQTE9eCNdmj+/fww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3518
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA3LTA5IGF0IDE1OjEzICswODAwLCBKYXNvbiBYaW5nIHdyb3RlOg0KPiBP
aCwgb25lIG1vcmUgdGhpbmcgSSBtaXNzZWQgaW4gdGhlIGxhc3QgZW1haWwgaXMgdGhhdCBhbGwg
dGhlDQo+IGZhaWx1cmVzDQo+IGFyZSBoYXBwZW5pbmcgb24gdGhlIGNvbWJpbmF0aW9uIG9mIFg3
MjIgMTBHYkUgYW5kIDFHYkUuIFNvIHRoZSB2YWx1ZQ0KPiBvZiBAbnVtX3R4X3FwICB0aGUgZHJp
dmVyIGZldGNoZXMgaXMgMzg0IHdoaWxlIHRoZSB2YWx1ZSBpcyA3NjgNCj4gd2l0aG91dCB4NzIy
IDFHYkUuDQo+IA0KPiBJIGdldCB0aGF0IGluZm9ybWF0aW9uIGJhY2sgaGVyZToNCj4gJCBsc3Bj
aSB8IGdyZXAgLWkgZXRoZXINCj4gNWE6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBD
b3Jwb3JhdGlvbiBFdGhlcm5ldCBDb25uZWN0aW9uDQo+IFg3MjIgZm9yIDEwR2JFIFNGUCsgKHJl
diAwOSkNCj4gNWE6MDAuMSBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBF
dGhlcm5ldCBDb25uZWN0aW9uDQo+IFg3MjIgZm9yIDEwR2JFIFNGUCsgKHJldiAwOSkNCj4gNWE6
MDAuMiBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBFdGhlcm5ldCBDb25u
ZWN0aW9uDQo+IFg3MjIgZm9yIDFHYkUgKHJldiAwOSkNCj4gNWE6MDAuMyBFdGhlcm5ldCBjb250
cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBFdGhlcm5ldCBDb25uZWN0aW9uDQo+IFg3MjIgZm9y
IDFHYkUgKHJldiAwOSkNCj4gDQo+IEkga25vdyBpdCdzIHJlYWxseSBzdHVwaWQgdG8gY29udHJv
bCB0aGUgbnVtYmVyIG9mIG9ubGluZSBjcHVzLCBidXQNCj4gZmluZGluZyBhIGdvb2Qgd2F5IG9u
bHkgdG8gbGltaXQgdGhlIEBhbGxvY19xdWV1ZV9wYWlycyBpcyBub3QgZWFzeQ0KPiB0bw0KPiBn
by4gU28gY291bGQgc29tZW9uZSBwb2ludCBvdXQgYSBiZXR0ZXIgd2F5IHRvIGZpeCB0aGlzIGlz
c3VlIGFuZA0KPiB0YWtlDQo+IGNhcmUgb2Ygc29tZSByZWxhdGl2ZWx5IG9sZCBuaWNzIHdpdGgg
dGhlIG51bWJlciBvZiBjcHVzIGluY3JlYXNpbmc/DQoNCkhpIEphc29uLA0KDQpTb3JyeSBmb3Ig
dGhlIHNsb3cgcmVzcG9uc2U7IEkgd2FzIHRyeWluZyB0byB0YWxrIHRvIHRoZSBpNDBlIHRlYW0N
CmFib3V0IHRoaXMuDQoNCkkgYWdyZWUsIHRoZSBsaW1pdGluZyBvZiBudW1iZXIgb2Ygb25saW5l
IENQVXMgZG9lc24ndCBzZWVtIGxpa2UgYQ0Kc29sdXRpb24gd2Ugd2FudCB0byBwdXJzdWUuIFRo
ZSB0ZWFtIGlzIHdvcmtpbmcgb24gYSBwYXRjaCB0aGF0IGRlYWxzDQp3aXRoIHRoZSBzYW1lLCBv
ciBzaW1pbGlhciwgaXNzdWU7IGl0IGlzIHJld29ya2luZyB0aGUgYWxsb2NhdGlvbnMgb2YNCnRo
ZSBxdWV1ZSBwaWxlLiBJJ2xsIG1ha2Ugc3VyZSB0aGF0IHRoZXkgYWRkIHlvdSBvbiB0aGUgcGF0
Y2ggd2hlbiBpdA0KaXMgc2VudCBzbyB0aGF0IHlvdSBjYW4gdHJ5IHRoaXMgYW5kIHNlZSBpZiBp
dCByZXNvbHZlcyB5b3VyIGlzc3VlLg0KDQpUaGFua3MsDQpUb255DQoNCg==
