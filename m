Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A086469227
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 10:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbhLFJTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 04:19:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:25892 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239396AbhLFJTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 04:19:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="261311951"
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="261311951"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 01:15:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="461735044"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 06 Dec 2021 01:15:30 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 01:15:30 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 01:15:29 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 6 Dec 2021 01:15:29 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 6 Dec 2021 01:15:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXrUraa4N3/UwjuxzenLEyLwcOHYcJm4yKE6W9n1bXCf2F3/fP9OTi9vN+wen1rejQY89hQARfdI4UGx/T5SQP6ZMO6pY3KW4FCmB7mqliO3eRbXLLGwfvPcNs94C8xpQZB+Sa5czwoVentkUNhC14d6wno91F/92THLLnuMKS+XOL71sZSlaATq0B/mGzXqo5NZ+OMLxHiLo+6kInNs3fngmVXuu5jIGFO5hEEMuV4MUDi9jggRUFXVYP+UgMILlBTy1Cwu4hxNqTOX4hfY6eLSDS5VMwdLzpuj30beEoO3LM2OhP+BhC1/KH65ygJJUDtIhf2SULk6wqXzvTwezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWhNyi1Syz73y9pmwuXTKo1RF7/4AW1zCC3A46K3tjE=;
 b=aIEa2iRu4pM/X+p33+ZDL9t8EgcInmw5LG7LNtGHjeqw9Pz3UECS0EzgopBcM5YBo/4+HrP7tMeantnGAOvxJItNA/D5QGrCqQmYZ8++tzR4d05yphnIabZBd4laCTjS9CqT30P7c6Sifc4QFIQ8lXIR5Zclp11SRF723Hfl4eOCguLTApwV+KBhJm4ApkaLoU1MXdBiJf+7cIQCyYQQv/giLvdvrAXBdD5pa+yCQ/Gbmm+pu70Wh1bqtmBDSqkrbJA4/j49rCa+sjsjuAJpQWzPEzsv4thBUYtpBa3ANW7fq5Kk82RJWpgOzY+PbOdERAOs5eav8S8SZtAuzAruug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWhNyi1Syz73y9pmwuXTKo1RF7/4AW1zCC3A46K3tjE=;
 b=nN5oVEvr449SdGD1GUA9JCJhy9NjaL3MnOztjaz8wKuBigdPRqnmK+tMojCL0P1YYxGftxdAjOEHKf618glWulf+9tnw+73v78BKLCIhg27kqctWyvUvn6LKbKWHQ+8jEaXYSjsldd1QhwcVCs7O98s830RTtu8Fc8+fvrZgUNI=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR11MB1341.namprd11.prod.outlook.com (2603:10b6:300:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 09:15:28 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%8]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 09:15:28 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Topic: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Index: AQHX5t+zHNhA4eAQzEyd+4hcIqumb6wfJraAgAAesICAACIlAIAACV/ggAF7CYCAAAFg8IAC6u0AgAFSJXA=
Date:   Mon, 6 Dec 2021 09:15:28 +0000
Message-ID: <MW5PR11MB581288D11A5FB7CEEE0D4E3CEA6D9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <Yao7r4DF7NmobEdp@shredder>
 <MW5PR11MB5812AB9B6E0CAEB6F9A84ABAEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <YayvaIFw8obrUHs4@shredder>
In-Reply-To: <YayvaIFw8obrUHs4@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e807e79-e1a2-4d4b-ba8b-08d9b898f1e1
x-ms-traffictypediagnostic: MWHPR11MB1341:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1341E39F2C13CDC065F14BE6EA6D9@MWHPR11MB1341.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7Gw0rmsmZA4+LKDssUtDRcGl77GlnUPcrXHrSNJUp0GomLShqgZNwXgV84Pad15MPhiL5osPnWNIQPlGGEKcxUxc1u/i80IWkFTplWLnuOp+6j8POJYaATw7uj6jD0wE6xi90sYzFFc+dmKnx0vu3/EWb3Suz3qnS2bsJWmnfL9samBEAY0JCI++nzderURWEWROW0WZSYAAH+WjPwlBxt8ow63v/qwhKWfEgXRn5zvcJAiG+lZ6ZcZPetpYfMCXMPZJ6qoJ86Fffjf7S1zzwSLHPnXXc1J7t4qtyf7NAxAcFjjBXOLbiv69UPgcBJF6nVxmzfvvJ7nv6ivSZlVxvr7IpyitJuEiQgO50cWFLV58UgULXe974GJgH9ufow5Qrvgf+qfk8OdpaOwDIvxtDRyEAax8u3W5UfeR7b/1tk97PD+uVQy90ich75uJo+MdukWYI5euKk1kztJIMgMqPvr9ZerW4qD83bj1fXmUYigrUpsVVe0dBM/75jawyURcK9vkrnoQKWxX4M6w5O9Ys53qC0QWBgPJzCFx7jPs7YcAiKY73sWqbFJkA1wD71k0P6V9PSe21ivH3o/UlJIqs+jQ8fIkHn9mQGRMeND8QfPfVRyh8xj/z6O8TWAIHP9PKJNpyQLZli4OZyofgCX849wX0+xwlvFEkMWkg3ecxnkX4G9mGnJJU1iIXEVGsDHdp93ZcbYE8gWmsCGlQVCU3LK6H7Um53754Dt39AmluuhFP0AGD4CW6NEvC2qeAlsFC7fr49mLPpT56RZ1f+toWA8roHxY70z42lj7vExNfyj2xWisqUk7LXn3m76dEZjojSrNAxZvueGz7uxtlZcZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(966005)(82960400001)(86362001)(5660300002)(508600001)(83380400001)(6916009)(26005)(38070700005)(2906002)(4326008)(53546011)(6506007)(33656002)(122000001)(38100700002)(9686003)(7416002)(7696005)(55016003)(52536014)(316002)(54906003)(66946007)(64756008)(66476007)(76116006)(66446008)(66556008)(8936002)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjVaV2kvbUI3MDdSV0E2R2JFTytZSy91OUQwbWtzVW1veU81emhFOU1DNnRq?=
 =?utf-8?B?YWsyNi9XZG9HbE1kdTdQTXlQQkZKYVJWSGt0ckVBYXFIVHJsZ0VFTzYxMy9l?=
 =?utf-8?B?SzhIZEVYQi9iQncwSzFoUU1DU3RvZDZFVlNMZ0loU0hQQzlwT0VYYmRQa2d3?=
 =?utf-8?B?Z1FlZVA4cHFVNHVaamdPUFVHbFlwYktDaHRhSVN0K0pTanlyOS95UW1DYk1F?=
 =?utf-8?B?V29YbkMyN3E0dG5xdTdTbW5rd0U3Q0loS3VDYXVLdm1sRlpYek5JYzVIOFFq?=
 =?utf-8?B?UHREODh4bVl1WGRrVWFrQ21nR1hSQ1ZEb2FTdHNrUXRWWlEwZTgxWVBLd0dy?=
 =?utf-8?B?cWduamZOT0srckJ4THhZR28zcHJuWTFMcnNlalgvTDlBUFdDUUVHWGRZeWI2?=
 =?utf-8?B?ZnFLUnEyMFdjMEhHTkZpd1lteXgxVWVWbURYK0xxREpRUUVkbk5nSHZ2c2lC?=
 =?utf-8?B?S0JQd2FjeG02V3FwMXQyNTQvbWs1diswY3JEcS81K1FleEhqS1hNUlNEeEhF?=
 =?utf-8?B?Q0JJa01EcHBJd3F3NURpTGwvaEg5NmYweVRvakt2VUdVOWVOQjhTK2kzZVNv?=
 =?utf-8?B?Y2dPZzJlbUErSHJQR3hXZ3NLQktZM0pCVXd4SmJ0eUtySXpWckxHNjNKZVB2?=
 =?utf-8?B?bHFhQnl5VXArT0NESTBwczdKczJ1Z0NhR1ozNVBQVC9GK0w2UHBaZ2JyNjV0?=
 =?utf-8?B?dEo5emRjSlZOSGVZR1ZnVS9sK29OQ2wyWDcraWoxTlUwR1BHcW55aWR0cGN0?=
 =?utf-8?B?bTljeE45eFRLRi93NmZEWkhRNUYyMzM2ZGEvWUhFTGZJTWF3NWNUTXBWNHNE?=
 =?utf-8?B?NDlONVZ6S014Zm85S3p3RXVCWnEwT3g5SVFPRXFob3g0ekU0RDdnMXlsNFFw?=
 =?utf-8?B?eFpLZTFDOTRFdnowaytHdDF2SURyYy9NL3EwaGR2ai9GT3o0ZTMvQ2VmdGNm?=
 =?utf-8?B?OUM5S2kvMEJnNEJSRXZabGJDL0pGZUlNcDJ1V2NuaTFhaE1zYWVhdVpuNmlN?=
 =?utf-8?B?cWxLNWtaL1VzWHA2bnBYejJqRCtyYWV0SVZndzdGSkVaMkw5Y2IxOWkxT3Mv?=
 =?utf-8?B?ZWlES0E3MG5HNmd4bTlJd25wY2ZpNmx0SlJSMjZoZHdUQ0I0UzBMU2FRQWsv?=
 =?utf-8?B?Szh1Y3dPTlRMc1ZvZGo2Vjg0SDkzRHp4M21DdVpQajRHL3BjeWVldy9PUmQ1?=
 =?utf-8?B?cGI2Q3FqK3lXb2JwalpYN0xkSjNrZVdNVTFSUm1ndkhLTjYxemRQTHF6S1Bm?=
 =?utf-8?B?Nm83RWlpWDYvTWlvQkR4Q0hIWHVuTFZ0SzNMSERTSVozZ0ZCUjR4Um1Zbk9F?=
 =?utf-8?B?TFNIWUFOdFFCTHp4RWFTYTVSTGVzMW9yVVRaeitJbTlxYU1OeGRzYVlqYUlx?=
 =?utf-8?B?YVVGbllTbUI4Yithc0dqeThINWZHMHJPQzlNTTdZT3pGZm9HRDVYbjFZVHNa?=
 =?utf-8?B?Z2p1bzRwdHd4a3ZybGlDMlhPU3lsOVg5cU1RUzIwaVJpaFo4NHN5MjdIRk9R?=
 =?utf-8?B?ZVlwVmowMmM1bmhrV3FZK09ER2VCYkw0VG83Z3VReCt4Q1Yzb2hNMDdpc3Ji?=
 =?utf-8?B?KytYbUxEL2Zla3N1MWdpNUNlZnZmOFpYTWZpV3Z6V3ppMDhFdTlUQzJOSDhw?=
 =?utf-8?B?blpTNTNzRFhZZ0s2Z0tNYjF1dlRON2gxREF6M1gySHpiKzI1L1hBYS9ORFRK?=
 =?utf-8?B?V0JCd1BPU3luelJnQ2NhZUVXL1RjdTh3ZkRPTlVzYnNjZ2RxZlhYN1NJejFL?=
 =?utf-8?B?ZzdrZGIxRzJJeVJFWlljOWx1ams4TkU2Yk1vMkVzU3ArTyszQzkzT29SUHBV?=
 =?utf-8?B?cUV0TVVKdlo0dExrdnhHQ1E5aVhqL1plcDFEWFRvYmx0UHFENTYzakZleTJa?=
 =?utf-8?B?dlhlRXVsZUtBTzNWRXZLNjFzVFlLWVNQakJEY0Z0cnlWUGFpTXlYaGgraWFL?=
 =?utf-8?B?ZXU3c2gyVTRWQ3RvQXlxVjJxSG91M0UrT1NuK293S0hZRXFhRWdCKzFoaVl2?=
 =?utf-8?B?ZXVHd21VMlpxUUxjak9RWUk2SDhhdHZSekNsUXhqSWZSN0VPb09ZSmdtdUNi?=
 =?utf-8?B?VWpEWTY3WkwxN3FXSzNLYXlmYy9yNHQvcy9hNzlzVE4zWWZ5N05FT2lldXhQ?=
 =?utf-8?B?VkE4S0p4UzU3b05Qd3J3bVp0eE1taTV3WGxyeXY0QVlYTjB4QndXYWNYOGNM?=
 =?utf-8?B?YVFmeW9UelJmazRBTzduSGw2ZExJSEZnZ2RRTVVoTzFRVmZ1RVBzdmdDMlBY?=
 =?utf-8?B?a3FVU0RHNDNGMTJsVDRjTG1rUWlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e807e79-e1a2-4d4b-ba8b-08d9b898f1e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2021 09:15:28.0904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Paw2MyFJ8FnZzrVfltfRprMWhCXNy/HI8IHEo2fsqvZOAwcTeMQnEQBI403j4c+ri7Zhj5zXrs8SCtiIUQkT/aCAY2Hh0q7ALWPEuE+lAt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1341
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJZG8gU2NoaW1tZWwgPGlkb3Nj
aEBpZG9zY2gub3JnPg0KPiBTZW50OiBTdW5kYXksIERlY2VtYmVyIDUsIDIwMjEgMToyNCBQTQ0K
PiBUbzogTWFjaG5pa293c2tpLCBNYWNpZWogPG1hY2llai5tYWNobmlrb3dza2lAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IG5ldC1uZXh0IDIvNF0gZXRodG9vbDogQWRkIGFi
aWxpdHkgdG8gY29uZmlndXJlDQo+IHJlY292ZXJlZCBjbG9jayBmb3IgU3luY0UgZmVhdHVyZQ0K
DQoNCk9LIEkgc2VlIHdoZXJlIHRoZSBtaXN1bmRlcnN0YW5kaW5nIGNvbWVzIGZyb20uIFRoZSBz
dWJzeXN0ZW0gd2UnbGwNCkRldmVsb3Agd2lsbCBOT1QgYmUgRUVDIHN1YnN5c3RlbSwgYnV0IHRo
ZSBEUExMIHN1YnN5c3RlbS4gVGhlIEVFQyBpcyBvbmx5IA0Kb25lIHBvdGVudGlhbCB1c2Ugb2Yg
dGhlIERQTEwsIGJ1dCB0aGVyZSBhcmUgbWFueSBtb3JlLg0KQnkgcHJpbmNpcGxlIGFsbCBEUExM
IGNoaXBzIGhhdmUgY29uZmlndXJhYmxlIGlucHV0cywgY29uZmlndXJhYmxlIFBMTCBibG9jaywN
CmFuZCBjb25maWd1cmFibGUgb3V0cHV0cyAtIHRoYXQncyB3aGF0IHRoZSBuZXcgc3Vic3lzdGVt
IHdpbGwgY29uZmlndXJlDQphbmQgZXhwb3NlLiBBbmQgdGhlIGlucHV0IGJsb2NrIGlzIHNoYXJl
ZCBiZXR3ZWVuIG11bHRpcGxlIERQTExzIGludGVybmFsbHkuDQoNClVuZm9ydHVuYXRlbHksIHdl
IGhhdmUgbm8gd2F5IG9mIHJlcHJlc2VudGluZyBhbGwgY29ubmVjdGlvbnMgdG8gYSBnaXZlbg0K
RFBMTCBhbmQgd2UgaGF2ZSB0byByZWx5IG9uIG1hbnVhbC9sYWJlbHMgYW55d2F5IC0ganVzdCBs
aWtlIHdlIGRvIHdpdGgNClBUUCBwaW5zLiBXZSBjb250cm9sIHRoZW0sIGJ1dCBoYXZlIG5vIGlk
ZWEgd2hlcmUgdGhleSBhcmUgY29ubmVjdGVkDQpwaHlzaWNhbGx5Lg0KDQpNeSBhc3N1bXB0aW9u
IGlzIHRoYXQgdGhlIERQTEwgYmxvY2sgd2lsbCBmb2xsb3cgdGhlIHNhbWUgcHJpbmNpcGxlIGFu
ZCANCndpbGwgZXhwb3NlIGEgc2V0IG9mIGlucHV0cyBhbmQgc2V0IG9mIG91dHB1dHMgdGhhdCB1
QVBJIHdpbGwgY29uZmlndXJlLg0KDQpOb3cgd2l0aCB0aGF0IGluIG1pbmQ6DQoNCg0KPiA+IE15
IGFyZ3VtZW50IHdhcyBuZXZlciAiaXQncyBoYXJkIiAtIHRoZSBhbnN3ZXIgaXMgd2UgbmVlZCBi
b3RoIEFQSXMuDQo+IA0KPiBXZSBhcmUgZGlzY3Vzc2luZyB3aGV0aGVyIHR3byBBUElzIGFyZSBh
Y3R1YWxseSBuZWNlc3Nhcnkgb3Igd2hldGhlciBFRUMNCj4gc291cmNlIGNvbmZpZ3VyYXRpb24g
Y2FuIGJlIGRvbmUgdmlhIHRoZSBFRUMuIFRoZSBhbnN3ZXIgY2Fubm90IGJlICJ0aGUNCj4gYW5z
d2VyIGlzIHdlIG5lZWQgYm90aCBBUElzIi4NCg0KV2UgbmVlZCBib3RoIEFQSXMgYmVjYXVzZSBh
IHNpbmdsZSByZWNvdmVyZWQgY2xvY2sgY2FuIGJlIGNvbm5lY3RlZCB0bzoNCi0gTXVsdGlwbGUg
RFBMTHMgLSBlaXRoZXIgaW50ZXJuYWwgdG8gdGhlIGNoaXAsIG9yIHZpYSBmYW5vdXRzIHRvIGRp
ZmZlcmVudCBjaGlwcw0KLSBhIEZQR0ENCi0gYSBSRiBIVyB0aGF0IG1heSBub3QgZXhwb3NlIGFu
eSBEUExMDQoNCkdpdmVuIHRoYXQgLSB3ZSBjYW5ub3QgaG9vayBjb250cm9sIG92ZXIgcmVjb3Zl
cmVkIGNsb2NrcyB0byBhIERQTEwgc3Vic3lzdGVtLA0KYXMgaXQncyBub3QgdGhlIG9ubHkgY29u
c3VtZXIgb2YgdGhhdCBvdXRwdXQuDQoNCj4gPg0KPiA+ID4gSW4gYWRkaXRpb24sIHdpdGhvdXQg
YSByZXByZXNlbnRhdGlvbiBvZiB0aGUgRUVDLCB0aGVzZSBwYXRjaGVzIGhhdmUgbm8NCj4gPiA+
IHZhbHVlIGZvciB1c2VyIHNwYWNlLiBUaGV5IGJhc2ljYWxseSBhbGxvdyB1c2VyIHNwYWNlIHRv
IHJlZGlyZWN0IHRoZQ0KPiA+ID4gcmVjb3ZlcmVkIGZyZXF1ZW5jeSBmcm9tIGEgbmV0ZGV2IHRv
IGFuIG9iamVjdCB0aGF0IGRvZXMgbm90IGV4aXN0Lg0KPiA+ID4gVXNlciBzcGFjZSBkb2Vzbid0
IGtub3cgaWYgdGhlIG9iamVjdCBpcyBzdWNjZXNzZnVsbHkgdHJhY2tpbmcgdGhlDQo+ID4gPiBm
cmVxdWVuY3kgKHRoZSBFRUMgc3RhdGUpIGFuZCBkb2VzIG5vdCBrbm93IHdoaWNoIG90aGVyIGNv
bXBvbmVudHMNCj4gYXJlDQo+ID4gPiB1dGlsaXppbmcgdGhpcyByZWNvdmVyZWQgZnJlcXVlbmN5
IGFzIGlucHV0IChlLmcuLCBvdGhlciBuZXRkZXZzLCBQSEMpLg0KPiA+DQo+ID4gVGhhdCdzIGFs
c28gbm90IHRydWUgLSB0aGUgcHJvcG9zZWQgdUFQSSBsZXRzIHlvdSBlbmFibGUgcmVjb3ZlcmVk
DQo+IGZyZXF1ZW5jeQ0KPiA+IG91dHB1dCBwaW5zIGFuZCByZWRpcmVjdCB0aGUgcmlnaHQgY2xv
Y2sgdG8gdGhlbS4gSW4gc29tZSBpbXBsZW1lbnRhdGlvbnMNCj4gPiB5b3UgbWF5IG5vdCBoYXZl
IGFueXRoaW5nIGVsc2UuDQo+IA0KPiBXaGF0IGlzbid0IHRydWU/IFRoYXQgdGhlc2UgcGF0Y2hl
cyBoYXZlIG5vIHZhbHVlIGZvciB1c2VyIHNwYWNlPyBUaGlzDQo+IGlzIDEwMCUgdHJ1ZS4gWW91
IGFkbWl0dGVkIHRoYXQgdGhpcyBpcyBpbmNvbXBsZXRlIHdvcmsuIFRoZXJlIGlzIG5vDQo+IHJl
YXNvbiB0byBtZXJnZSBvbmUgQVBJIHdpdGhvdXQgdGhlIG90aGVyLiBBdCB0aGUgdmVyeSBsZWFz
dCwgd2UgbmVlZCB0bw0KPiBzZWUgYW4gZXhwbGFuYXRpb24gb2YgaG93IHRoZSB0d28gQVBJcyB3
b3JrIHRvZ2V0aGVyLiBUaGlzIGlzIG1pc3NpbmcNCj4gZnJvbSB0aGUgcGF0Y2hzZXQsIHdoaWNo
IHByb21wdGVkIHRoZXNlIHF1ZXN0aW9uczoNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L25ldGRldi9ZYWklMkZlNWp6M05aQWcwcG1Ac2hyZWRkZXIvDQoNClRoYXQncyB3aGF0IEkgdHJ5
IHRvIGV4cGxhaW4uIEEgZ2l2ZW4gRFBMTCB3aWxsIGhhdmUgbXVsdGlwbGUgcmVmZXJlbmNlIGZy
ZXF1ZW5jaWVzDQp0byBjaG9vc2UgZnJvbSwgYnV0IHRoZSBzb3VyY2VzIG9mIHRoZW0gd2lsbCBi
ZSBjb25maWd1cmVkIGluZGVwZW5kZW50bHkuDQpXaXRoIHRoZSBzb3VyY2VzIGxpa2U6DQotIDFQ
UFMvMTBNSHogZnJvbSB0aGUgR05TUw0KLSAxUFBTLzEwTUh6ICBmcm9tIGV4dGVybmFsIHNvdXJj
ZQ0KLSAxUFBTIGZyb20gdGhlIFBUUCBibG9jaw0KLSBSZWNvdmVyZWQgY2xvY2sNCg0KQWRkaXRp
b25hbGx5LCBhIGdpdmVuIERQTEwgY2hpcCBtYXkgaGF2ZSBtYW55ICgyLCA0LCA2LCA4ICspIERQ
TExzIGluc2lkZSwNCmVhY2ggb25lIHVzaW5nIHRoZSBzYW1lIHJlZmVyZW5jZSBzaWduYWxzIGZv
ciBkaWZmZXJlbnQgcHVycG9zZXMuDQoNCkFsc28gdGhlcmUgaXMgYSByZWFzb24gdG8gbWVyZ2Ug
dGhpcyB3aXRob3V0IERQTEwgc3Vic3lzdGVtIGZvciBhbGwgZGV2aWNlcw0KdGhhdCB1c2UgcmVj
b3ZlcmVkIGNsb2NrcyBmb3IgYSBwdXJwb3NlIG90aGVyIHRoYW4gU3luY0UuDQoNClsuLi5dDQo+
ID4gPiA+DQo+ID4gPiA+IFRoZXkgYmVsb25nIHRvIGRpZmZlcmVudCBkZXZpY2VzLiBFRUMgcmVn
aXN0ZXJzIGFyZSBwaHlzaWNhbGx5IGluIHRoZSBEUExMDQo+ID4gPiA+IGhhbmdpbmcgb3ZlciBJ
MkMgYW5kIHJlY292ZXJlZCBjbG9ja3MgYXJlIGluIHRoZSBQSFkvaW50ZWdyYXRlZCBQSFkgaW4N
Cj4gPiA+ID4gdGhlIE1BQy4gRGVwZW5kaW5nIG9uIHN5c3RlbSBhcmNoaXRlY3R1cmUgeW91IG1h
eSBoYXZlIGNvbnRyb2wgb3Zlcg0KPiA+ID4gPiBvbmUgcGllY2Ugb25seQ0KPiA+ID4NCj4gPiA+
IFRoZXNlIGFyZSBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzIG9mIGEgc3BlY2lmaWMgZGVzaWduIGFu
ZCBzaG91bGQgbm90DQo+ID4gPiBpbmZsdWVuY2UgdGhlIGRlc2lnbiBvZiB0aGUgdUFQSS4gVGhl
IHVBUEkgc2hvdWxkIGJlIGluZmx1ZW5jZWQgYnkgdGhlDQo+ID4gPiBsb2dpY2FsIHRhc2sgdGhh
dCBpdCBpcyB0cnlpbmcgdG8gYWNoaWV2ZS4NCj4gPg0KPiA+IFRoZXJlIGFyZSAyIGxvZ2ljYWwg
dGFza3M6DQo+ID4gMS4gRW5hYmxlIGNsb2NrcyB0aGF0IGFyZSByZWNvdmVyZWQgZnJvbSBhIHNw
ZWNpZmljIG5ldGRldg0KPiANCj4gSSBhbHJlYWR5IHJlcGxpZWQgYWJvdXQgdGhpcyBoZXJlOg0K
PiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L1lhbytuSzQwRDArdThVS0xAc2hy
ZWRkZXIvDQo+IA0KPiBJZiB0aGUgcmVjb3ZlcmVkIGNsb2NrIG91dHB1dHMgYXJlIG9ubHkgbWVh
bmluZ2Z1bCBhcyBFRUMgaW5wdXRzLCB0aGVuDQo+IHRoZXJlIGlzIG5vIHJlYXNvbiBub3QgdG8g
Y29uZmlndXJlIHRoZW0gdGhyb3VnaCB0aGUgRUVDIG9iamVjdC4gVGhlDQo+IGZhY3QgdGhhdCB5
b3UgdGhpbmsgdGhhdCB0aGUgKmludGVybmFsKiBrZXJuZWwgcGx1bWJpbmcgKHRoYXQgY2FuIGJl
DQo+IGltcHJvdmVkIG92ZXIgdGltZSkgd2lsbCBiZSAiaGFyZCIgaXMgbm90IGEgcmVhc29uIHRv
IGVuZCB1cCB3aXRoIGENCj4gKnVzZXIqIEFQSSAodGhhdCBjYW5ub3QgYmUgY2hhbmdlZCkgd2hl
cmUgdGhlICpFdGhlcm5ldCogRXF1aXBtZW50IENsb2NrDQo+IGlzIGlnbm9yYW50IG9mIGl0cyAq
RXRoZXJuZXQqIHBvcnRzLg0KDQpMaWtlIEkgbWVudGlvbmVkIGFib3ZlIC0gaXQgd29u4oCZdCBi
ZSBFRUMgc3Vic3lzdGVtLiBBbHNvIHRoZSBzaWduYWwgaXMgcmVsZXZhbnQNCnRvIG90aGVyIGRl
dmljZXMgLSBub3Qgb25seSBFRUMgYW5kIG5vdCBldmVuIG9ubHkgdG8gRFBMTHMuDQoNCj4gV2l0
aCB5b3VyIHByb3Bvc2FsIHdoZXJlIHRoZSBFRUMgaXMgb25seSBhd2FyZSBvZiBwaW5zLCBob3cg
ZG9lcyB1c2VyDQo+IHNwYWNlIGFuc3dlciB0aGUgcXVlc3Rpb24gb2Ygd2hhdCBpcyB0aGUgc291
cmNlIG9mIHRoZSBFRUM/IEl0IG5lZWRzIHRvDQo+IGlzc3VlIFJDTEtfR0VUIGR1bXA/IEhvdyBk
b2VzIGl0IGV2ZW4ga25vdyB0aGF0IHRoZSBzb3VyY2UgaXMgYSBuZXRkZXYNCj4gYW5kIG5vdCBh
biBleHRlcm5hbCBvbmU/IEFuZCBpZiB0aGUgRUVDIG9iamVjdCBrbm93cyB0aGF0IHRoZSBzb3Vy
Y2UgaXMNCj4gYSBuZXRkZXYsIGhvdyBjb21lIGl0IGRvZXMgbm90IGtub3cgd2hpY2ggbmV0ZGV2
Pw0KDQpUaGlzIG5lZWRzIHRvIGJlIGFkZHJlc3NlZCBieSB0aGUgRFBMTCBzdWJzeXN0ZW0gLSBJ
J2Qgc2F5IHVzaW5nIGxhYmVscyB3b3VsZCBiZQ0KYSBnb29kIHdheSB0byBtYW5hZ2UgaXQgLSBp
biB0aGUgc2FtZSB3YXkgd2UgdXNlIHRoZW0gaW4gdGhlIFBUUCBzdWJzeXN0ZW0NCg0KPiA+IDIu
IENvbnRyb2wgdGhlIEVFQw0KPiA+DQo+ID4gVGhleSBhcmUgYm90aCBuZWVkZWQgdG8gZ2V0IHRv
IHRoZSBmdWxsIHNvbHV0aW9uLCBidXQgYXJlIGluZGVwZW5kZW50IGZyb20NCj4gPiBlYWNoIG90
aGVyLiBZb3UgY2FuJ3QgcHV0IFJDTEsgcmVkaXJlY3Rpb24gdG8gdGhlIEVFQyBhcyBpdCdzIG9u
ZSB0byBtYW55DQo+ID4gcmVsYXRpb24gYW5kIHlvdSB3aWxsIG5lZWQgdG8gY2FsbCB0aGUgbmV0
ZGV2IHRvIGVuYWJsZSBpdCBhbnl3YXkuDQo+IA0KPiBTbyB3aGF0IGlmIEkgbmVlZCB0byBjYWxs
IHRoZSBuZXRkZXY/IFRoZSBFRUMgY2Fubm90IGJlIHNvIGRpc2pvaW50IGZyb20NCj4gdGhlIGFz
c29jaWF0ZWQgbmV0ZGV2cy4gQWZ0ZXIgYWxsLCBFRUMgc3RhbmRzIGZvciAqRXRoZXJuZXQqIEVx
dWlwbWVudA0KPiBDbG9jay4gSW4gdGhlIGNvbW1vbiBjYXNlLCB0aGUgRUVDIHdpbGwgdHJhbnNm
ZXIgdGhlIGZyZXF1ZW5jeSBmcm9tIG9uZQ0KPiBuZXRkZXYgdG8gYW5vdGhlci4gSW4gdGhlIGxl
c3MgY29tbW9uIGNhc2UsIGl0IHdpbGwgdHJhbnNmZXIgdGhlDQo+IGZyZXF1ZW5jeSBmcm9tIGFu
IGV4dGVybmFsIHNvdXJjZSB0byBhIG5ldGRldi4NCg0KQWdhaW4gLSB0aGUgRFBMTHMgbGlua2Vk
IHRvIHRoZSBuZXRkZXYgaXMganVzdCBvbmUgb2YgbWFueSB1c2UgY2FzZXMuIE90aGVyDQpEUExM
cyBub3QgbGlua2VkIHRvIG5ldGRldnMgd2lsbCBhbHNvIGV4aXN0IGFuZCB1c2UgdGhlIFBIWSBy
ZWNvdmVyZWQgY2xvY2suDQoNCj4gPg0KPiA+IEFsc28sIHdoZW4gd2UgdHJpZWQgdG8gYWRkIEVF
QyBzdGF0ZSB0byBQVFAgc3Vic3lzdGVtIHRoZSBhbnN3ZXIgd2FzDQo+ID4gdGhhdCB3ZSBjYW4n
dCBtaXggc3Vic3lzdGVtcy4NCj4gDQo+IFN5bmNFIGRvZXNuJ3QgYmVsb25nIGluIFBUUCBiZWNh
dXNlIFBUUCBjYW4gd29yayB3aXRob3V0IFN5bmNFIGFuZCBTeW5jRQ0KPiBjYW4gd29yayB3aXRo
b3V0IFBUUC4gVGhlIGZhY3QgdGhhdCB0aGUgcHJpbWFyeSB1c2UgY2FzZSBmb3IgU3luY0UgbWln
aHQNCj4gYmUgUFRQIGRvZXNuJ3QgbWVhbiB0aGF0IFN5bmNFIGJlbG9uZ3MgaW4gUFRQIHN1YnN5
c3RlbS4NCj4gDQo+ID4gVGhlIHByb3Bvc2FsIHRvIGNvbmZpZ3VyZSByZWNvdmVyZWQgY2xvY2tz
ICB0aHJvdWdoIEVFQyB3b3VsZCBtaXgNCj4gPiBuZXRkZXYgd2l0aCBFRUMuDQo+IA0KPiBJIGRv
bid0IGJlbGlldmUgdGhhdCAqRXRoZXJuZXQqIEVxdWlwbWVudCBDbG9jayBhbmQgKkV0aGVybmV0
KiBwb3J0cw0KPiBzaG91bGQgYmUgc28gZGlzam9pbnQgc28gdGhhdCB0aGUgRUVDIGRvZXNuJ3Qg
a25vdyBhYm91dDoNCj4gDQo+IGEuIFRoZSBuZXRkZXYgZnJvbSB3aGljaCBpdCBpcyByZWNvdmVy
aW5nIGl0cyBmcmVxdWVuY3kNCj4gYi4gVGhlIG5ldGRldnMgdGhhdCBpdCBpcyBjb250cm9sbGlu
Zw0KPiANCj4gSWYgdGhlIG5ldGRldnMgYXJlIHNtYXJ0IGVub3VnaCB0byByZXBvcnQgdGhlIEVF
QyBpbnB1dCBwaW5zIGFuZCBFRUMNCj4gYXNzb2NpYXRpb24gdG8gdXNlciBzcGFjZSwgdGhlbiB0
aGV5IGFyZSBhbHNvIHNtYXJ0IGVub3VnaCB0byByZWdpc3Rlcg0KPiB0aGVtc2VsdmVzIGludGVy
bmFsbHkgaW4gdGhlIGtlcm5lbCB3aXRoIHRoZSBFRUMuIFRoZXkgY2FuIGFsbCBhcHBlYXIgYXMN
Cj4gdmlydHVhbCBpbnB1dC9vdXRwdXQgcGlucyBvZiB0aGUgRUVDIHRoYXQgY2FuIGJlIGVuYWJs
ZWQvZGlzYWJsZWQgYnkNCj4gdXNlciBzcGFjZS4gSW4gYWRkaXRpb24sIHlvdSBjYW4gaGF2ZSBw
aHlzaWNhbCAobmFtZWQpIHBpbnMgZm9yIGV4dGVybmFsDQo+IHNvdXJjZXMgLyBvdXRwdXRzIGFu
ZCBhbm90aGVyIHZpcnR1YWwgb3V0cHV0IHBpbiB0b3dhcmRzIHRoZSBQSEMuDQoNCk5ldGRldnMg
bmVlZHMgdG8ga25vdyB3aGljaCBEUExMIGlzIHVzZWQgYXMgaXRzIHNvdXJjZS4NCklmIHdlIHdh
bnQgdG8gbWFrZSBhIERQTEwgYXdhcmUgb2Ygd2hvJ3MgZHJpdmluZyB0aGUgc2lnbmFsIHdlIGNh
biBjcmVhdGUNCmludGVybmFsIHBsdW1iaW5nIGJldHdlZW4gUEhZIG91dHB1dCBwaW5zIGFuZCBz
b21lL2FsbCBEUExMIHJlZmVyZW5jZXMNCnRoYXQgYXJlIGxpbmtlZCB0byBpdCAtIGlmIHRoYXQg
Y29ubmVjdGlvbiBpcyBrbm93bi4NCg0KSWYgc3VjaCBwbHVtYmluZyBpcyBrbm93biB3ZSBjYW4g
YWRkIHJlZ2lzdHJhdGlvbiBvZiBhIG5ldGRldiB0aGF0J3MgdXNpbmcNCnRoZSByZWNvdmVyZWQg
Y2xvY2sgb3V0cHV0IHRvIHRoZSByZWZlcmVuY2UgaW5wdXRzLiBUaGF0IHdheSB0aGUgRFBMTCB3
b3VsZA0Kc2VlIHdoaWNoIG5ldGRldiAob3Igb3RoZXIgZGV2aWNlKSBpcyB0aGUgc291cmNlIGZy
b20gaXRzIHJlZmVyZW5jZSBpbnB1dCANCnN5c3RlbS4NCg0KSG9wZSB0aGlzIGNsYXJpZmllcyB3
aHkgd2UgbmVlZCBib3RoIHVBUElzLg0K
