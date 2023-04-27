Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603296F0435
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbjD0K21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243498AbjD0K20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:28:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5194C12
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682591304; x=1714127304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GgspYLzVMp3xS+YfirzifH0sr3YZOH1IvKkez9Rcho8=;
  b=cuPD0lBQyyLsrC3pR/BkEfyxVFfV3i5F463IHSDWTOb4VplsHcb8/mUm
   n5r6h+A43dbeN69bS665fiYV6Qh4vdpQJa15hmYBAdoDEVdqKC9pK4AJt
   F2ITNn3LXtdL+ijL+mshtPcuSrToKV/A1BC3g4n9q/9NKWM/4ByEvZ58X
   NIWASD+Cu66O518uD3mmWCLqiQpxE8BPgssU1rOmFRMra3gTQxiz4u5VF
   2lpyRxZS7psVhb+89kwYzbv/gFoAx9YVxmcVXQuF1pnU3M6BaP3EyfZDH
   bvi5gQV3cpdYoIeUTc2AktQGIzRZBGoAH3vrstHE129ejchPhHdZhOJEG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="433680232"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="433680232"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 03:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="783681969"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="783681969"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2023 03:28:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 03:28:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 03:28:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 03:28:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 03:28:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgNDNDLG/8gkaZ6glex+MJM17S1a0x8LWmbaC1rEZWdSJW48JaXEVbH3x0QL7+U6AjO1ayw/eWs7LOsZJabsox2y1l7fiO7fBceMy5GYlklFFeRwFywNa+BfGWvTCXFyU6D6mGGTb+c0vDXlwltRiqY0KZiqvSp9cZZhVCrQ8ea2VPdB5CmVEuNsGN2o3lGpXnt38nlhV6v5M8U5kHAjU4BmWCva6VX6HQcXNukw1X2tg0/QDgikmQNu8tjl1OuShhQaJ3KpHF3TRL8/6J6C/WI77UICHZvcIBlFS0Gc17gIVKax37ifNxo4XqtykqpMh51vLiWeY2FnhZu5qixgNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgspYLzVMp3xS+YfirzifH0sr3YZOH1IvKkez9Rcho8=;
 b=Z3axY1Htr7DanaUy0XwVg+Zy2o6zvARXQzbcXxWq9S5cUlOAFcXxMlBdmWeXII+JYB0SS3YK2oR4nAtDgdUiKTIi/CXaplzt9XXeh/OINhecJMzrpLuEMMGP15/I3ixrpI/Qj4/v7wwYvuhX8lcb15D9i9X5A/13TFW9ECnNg4bihUyAy7n4ykCxFVPW23r1WBDDhHiFNAwmjCHNKp+64F3vyj/cNi4M5i40XBNeJLBLjA1t38sl0N1Km3DbOHQWWeTLx/nPl9/8CDaCMCpuPRdtsJ7tQCennZ9MFg0Q3Ic9eIjdC8WJDvNpsmPVaAZSFcWLLd3uygHvmdciDnVPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN9PR11MB5418.namprd11.prod.outlook.com (2603:10b6:408:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 10:28:22 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6319.033; Thu, 27 Apr 2023
 10:28:22 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev
 mode
Thread-Topic: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev
 mode
Thread-Index: AQHZdGWvt2QOAGWUJ0e3sYXeO23uyq8+5rFQ
Date:   Thu, 27 Apr 2023 10:28:21 +0000
Message-ID: <MW4PR11MB5776844315E90B76E1DBCD64FD6A9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-9-wojciech.drewek@intel.com>
 <d3cc5703-bc8d-9e5e-c354-94dde3b1e91c@intel.com>
In-Reply-To: <d3cc5703-bc8d-9e5e-c354-94dde3b1e91c@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BN9PR11MB5418:EE_
x-ms-office365-filtering-correlation-id: 79941a2d-f3db-435e-68fc-08db470a203f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YDvbB9PJJbiOU+W39go3J1Qta4dT4NTz+JY1SMj+rkS18KBikPUFPm30ThuP/+AYw7oZ0T27VbaAgDh9PHIBLWcFzCFWkG+2QPD4ymiVgVkrLiNM4BniOj85Aet5UqMzlK7V0aJOjs8VPGf8HP3C4qCU5gS5pbVJbg6DKS1Soe1npQEEQn0c22rYFAH9TUsAtr9vOpV9l2IKl0mAbzjJ7TJinmo/q3JmyDM4jdaG12CjeUXPBRZl7d16BTPFBskyG/vvP43AQ3h99bhgdYfCPwZBsTED8mpXO3cRlATAmM0tJZGRJVk1d9zDPqDJcPCsUkR+qU8zUSJ2HZK4IlsrJHCusRP5bXMXOJVJkbd6eI/x08k2oHmyVokQlGQnQyIEXeAphHt0UhLBl/ECetrXjlP/rn/W7g2AWKgNTedko9NYGytTomAw5GIeOopY+/4rWhpM0fU+N5lw3x9la0q7jZaKsaSYGJ5jABDwjl8eKo5zNdlta3VqLwXlQeyTjgrc1ZzVi/b92NocKLqzIs1xFgtUA+nPEwQo78ZyzRt6DdUIB6d8dzXr2GoIWU6uOwtmDNXp91wXRXwD2g2VX8YcN8iw9458PX/n4rL7LYc7GyscD61iJSw4c/bzAyEEPJfDAlVh8ToOz5X0mvjydW5X5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199021)(6862004)(5660300002)(8936002)(52536014)(41300700001)(316002)(2906002)(4326008)(6636002)(64756008)(66446008)(66476007)(76116006)(66556008)(66946007)(54906003)(478600001)(7696005)(71200400001)(53546011)(186003)(6506007)(8676002)(26005)(9686003)(83380400001)(38070700005)(38100700002)(86362001)(33656002)(122000001)(55016003)(82960400001)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0QwTzJwZGxnVUxUTVduNm4xQzN6TnZ3dzNBRFhsSVpYaXp5MFpHaVRramh1?=
 =?utf-8?B?QmlIcVFIS3pWLyt4UjF1cjg2eDVrYzNtNUQ1cUtXRnpCbjc4OHdsczUzSFNU?=
 =?utf-8?B?bGVtSUVmS1dsNWFuRmNxY2dQUE9WU0N0d1pTUnRISFdaRGhrR29SYmlMaUhF?=
 =?utf-8?B?M3kwSzdHNmJxY1EvUThBZU5hV0xJdlFwWVdaaTgzOWRDSmF6VGJ1NnRCSFRz?=
 =?utf-8?B?N3JhWFZVUEtYMXhtL1dDSFVGZWpXeHNGSnQ4QVZRL3kyRXRKLzI2bGpDVzJI?=
 =?utf-8?B?eG9tMHlaL05RQWhrb3poZGpjVjFHVTV0MUV1VVhOa0RmajE5Q0ZxS29MTHo5?=
 =?utf-8?B?Y2IxY3QzYVpHc3QrVXhKbkxWRnAyblpsbDc3TkJUaElYcTdRaVlPOFZ3SHcz?=
 =?utf-8?B?Sm02SGs2ZjZ1eEdqWXNCOXFDTTA0Y3EvSGluNUFuZmoyN05EK002ZDhWZzhG?=
 =?utf-8?B?eVpKbVRFd0JYVGRCZDVoaEdnSTZnL0hpbEdha215NlpSS2s5cHI1NXJad0Fw?=
 =?utf-8?B?K010WWdQZkoyNW1JWVc2ZUF5dzlNWUsrUlluUGlsMkJGWnZBZ3cxNzU2MEJi?=
 =?utf-8?B?aVV1MGpibjVPNDdudVVQQk5XaWdEN09BVFVYRU5uYm9RZ3Bsamx4ekpnTHlw?=
 =?utf-8?B?NVhSMW9DdVBCcDl0RStKbVJqS28yTXQwTkRKc3dOeG42a3R2S212RW11aVlU?=
 =?utf-8?B?N3VvRE93MlljQ08reGJ1UFozQXZ2QXFheHlWTEdzM29qWDI0cTBWNHpmUlpV?=
 =?utf-8?B?Ykp2ZVI0VWpTRTNWNU5FRmh4aXlYTWc4U1pYcXlTUEJCUnI3Mk1TN0ZUY1pZ?=
 =?utf-8?B?YkE5M2FuYnRkUFBpVkYwRjVHTnRYK0phRFJhTEx1YVBtdVVFR1VJREZHRHdU?=
 =?utf-8?B?NFdZVjRyNWlrR21zQ3dLR1JxZk9CT0dzQmVJVUE1RG84OVd1OWtXN3lZb0JZ?=
 =?utf-8?B?U0E1aUErcGtzYSs0cHhUWVd3MC96MXJZT2tBV1B3OGROa1hDN2o2bW5LdGky?=
 =?utf-8?B?c0t2NVo1TjQ1emRrUzJDU0IrNnR6eWkvSlVmcjZTNE44a3ZTOVRqRW5TTmwy?=
 =?utf-8?B?ZWF0OEtYdTdkOHo2UUVMRzVpckJ3dlJhcUd4TkFhTGJnVGJTVkd6eUpoZ0Rp?=
 =?utf-8?B?U2g3K2Q5WThrakY3TlBtTWd6eHNNMTNXd3BqVTZEMmZmQXhPNHdKa0YvUUFG?=
 =?utf-8?B?a2tvTko4QnhVZUpQS1NjWGVveVNsdkhqTEhVR1lkVnd4eVJxQWkxb2M0NCtV?=
 =?utf-8?B?NkdPUWc0c3VMQ0hHaHZYR3Mrd1dWK3hTM2NlMlBqdnNOZW1IMWtzQUhvOG5B?=
 =?utf-8?B?WkNUb2tBT0dDMjN3QTBzMnY5V24xTnY2d1dNTCt6bjFVbkNXRjZHRHZvUm0v?=
 =?utf-8?B?eGd0V2pDamxpYko2Tnl4MVpDUUJWYjV4ZjVCa0g2ZmFPKzVQeUk2SFpBZnBz?=
 =?utf-8?B?MzU3bEpheEhVbDAydXA1TEhoQjBOWFRBZWFlMEk2eUpNVXFXTklWWVRkTEpO?=
 =?utf-8?B?LzU4aE1TeTg5VndJZm9nQ2NsTll6eW5BaGh5VFEyRlFvendGM1VwcGZzR01I?=
 =?utf-8?B?SWhxeTBvZFRpUTZabTFJZGhMZWhOVjk1eTNZbnJCUGZnOGFoZ1F6VnlXZFNF?=
 =?utf-8?B?ZXVsVnNBRDVtTnkxVGR0ZDhoZG9Veml2K0NEbmpNVkR1UHdJOVJYckFSTTg0?=
 =?utf-8?B?WGZmemZtN05qWW8zb3hGdm14QlhuaHUzUWdrRW85bkp3R20rV3JXNGdXblZn?=
 =?utf-8?B?Qk50a0hzSHdzSlR0RWRGaXNwQndKMkpSTVNUSjZkcDZiUWJzdXUzNjJ0Rm83?=
 =?utf-8?B?ZGFlVEN1N0dCT2ZkSEd0YXRJRTd4RndVZ0VEbDBzOW9tSU1mUTBpSmI4aWdM?=
 =?utf-8?B?Q2llODRaZXY5TnhVMjIrM2hrWlZhNm92bklVWFVWNEZmaXQxRjZLZHdRWmZW?=
 =?utf-8?B?VzhlSkJ0VEthcmRYejd2c3FuQnQxcGh5b05Sd2JxWmJGaDdLaEpKVzkvdnhp?=
 =?utf-8?B?aWk5SkVaaytzNmprOExsRXAxaDg4YkE0M1k4emY4RTZGemsvZyt5MHU0Nnp4?=
 =?utf-8?B?QUt0SzczdThYS2tBYWxXd1RSNlUxQUQ5K2ZOTDk4eFN1VmNZV3FrVUVWZzhm?=
 =?utf-8?Q?zajr5IF4ZF+jnqe5c9K0a4mCv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79941a2d-f3db-435e-68fc-08db470a203f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 10:28:21.8725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4ZMDn6cG68nD9m7jwBFL38nUVO7IiEb6+N6AHTrhUK7oOeFUmI9VZWU8Xlv0YYNJDMBxfIKdi+e5jWPM8XR6Sm3kqS1XjCER4HoHuzmaoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5418
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogcGnEhXRlaywgMjEg
a3dpZXRuaWEgMjAyMyAxNzoyNQ0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJl
d2VrQGludGVsLmNvbT4NCj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMb2Jha2luLCBBbGVrc2FuZGVyIDxhbGVrc2FuZGVyLmxv
YmFraW5AaW50ZWwuY29tPjsgRXJ0bWFuLCBEYXZpZCBNDQo+IDxkYXZpZC5tLmVydG1hbkBpbnRl
bC5jb20+OyBtaWNoYWwuc3dpYXRrb3dza2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4uc3p5Y2lr
QGxpbnV4LmludGVsLmNvbTsgQ2htaWVsZXdza2ksIFBhd2VsDQo+IDxwYXdlbC5jaG1pZWxld3Nr
aUBpbnRlbC5jb20+OyBTYW11ZHJhbGEsIFNyaWRoYXIgPHNyaWRoYXIuc2FtdWRyYWxhQGludGVs
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwOC8xMl0gaWNlOiBBZGQgVkxB
TiBGREIgc3VwcG9ydCBpbiBzd2l0Y2hkZXYgbW9kZQ0KPiANCj4gRnJvbTogV29qY2llY2ggRHJl
d2VrIDx3b2pjaWVjaC5kcmV3ZWtAaW50ZWwuY29tPg0KPiBEYXRlOiBNb24sIDE3IEFwciAyMDIz
IDExOjM0OjA4ICswMjAwDQo+IA0KPiA+IEZyb206IE1hcmNpbiBTenljaWsgPG1hcmNpbi5zenlj
aWtAaW50ZWwuY29tPg0KPiA+DQo+ID4gQWRkIHN1cHBvcnQgZm9yIG1hdGNoaW5nIG9uIFZMQU4g
dGFnIGluIGJyaWRnZSBvZmZsb2Fkcy4NCj4gPiBDdXJyZW50bHkgb25seSB0cnVuayBtb2RlIGlz
IHN1cHBvcnRlZC4NCj4gPg0KPiA+IFRvIGVuYWJsZSBWTEFOIGZpbHRlcmluZyAoZXhpc3Rpbmcg
RkRCIGVudHJpZXMgd2lsbCBiZSBkZWxldGVkKToNCj4gPiBpcCBsaW5rIHNldCAkQlIgdHlwZSBi
cmlkZ2Ugdmxhbl9maWx0ZXJpbmcgMQ0KPiA+DQo+ID4gVG8gYWRkIFZMQU5zIHRvIGJyaWRnZSBp
biB0cnVuayBtb2RlOg0KPiA+IGJyaWRnZSB2bGFuIGFkZCBkZXYgJFBGMSB2aWQgMTEwLTExMQ0K
PiA+IGJyaWRnZSB2bGFuIGFkZCBkZXYgJFZGMV9QUiB2aWQgMTEwLTExMQ0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogTWFyY2luIFN6eWNpayA8bWFyY2luLnN6eWNpa0BpbnRlbC5jb20+DQo+ID4g
LS0tDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dpdGNoX2JyLmMgICB8
IDMxOSArKysrKysrKysrKysrKysrKy0NCj4gPiAgLi4uL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX2Vzd2l0Y2hfYnIuaCAgIHwgIDEyICsNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzMTcgaW5z
ZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9lc3dpdGNoX2JyLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2hfYnIuYw0KPiA+IGluZGV4IDQ5MzgxZTRiZjYy
YS4uNTZkMzZlMzk3YjEyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfZXN3aXRjaF9ici5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9lc3dpdGNoX2JyLmMNCj4gPiBAQCAtNTksMTMgKzU5LDE5IEBAIGljZV9l
c3dpdGNoX2JyX25ldGRldl90b19wb3J0KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+ID4gIHN0
YXRpYyB2b2lkDQo+ID4gIGljZV9lc3dpdGNoX2JyX2luZ3Jlc3NfcnVsZV9zZXR1cChzdHJ1Y3Qg
aWNlX2Fkdl9sa3VwX2VsZW0gKmxpc3QsDQo+ID4gIAkJCQkgIHN0cnVjdCBpY2VfYWR2X3J1bGVf
aW5mbyAqcnVsZV9pbmZvLA0KPiA+IC0JCQkJICBjb25zdCB1bnNpZ25lZCBjaGFyICptYWMsDQo+
ID4gKwkJCQkgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKm1hYywgYm9vbCB2bGFuLCB1MTYgdmlkLA0K
PiANCj4gQ291bGQgd2UgdXNlIG9uZSBjb21iaW5lZCBhcmd1bWVudD8gRG9lc24ndCBgISF2aWQg
PT0gISF2bGFuYD8gVklEIDAgaXMNCj4gcmVzZXJ2ZWQgSUlSQy4uLg0KPiANCj4gKHNhbWUgaW4g
YWxsIHRoZSBwbGFjZXMgYmVsb3cpDQoNCk1ha2VzIHNlbnNlDQoNCj4gDQo+ID4gIAkJCQkgIHU4
IHBmX2lkLCB1MTYgdmZfdnNpX2lkeCkNCj4gPiAgew0KPiA+ICAJbGlzdFswXS50eXBlID0gSUNF
X01BQ19PRk9TOw0KPiA+ICAJZXRoZXJfYWRkcl9jb3B5KGxpc3RbMF0uaF91LmV0aF9oZHIuZHN0
X2FkZHIsIG1hYyk7DQo+ID4gIAlldGhfYnJvYWRjYXN0X2FkZHIobGlzdFswXS5tX3UuZXRoX2hk
ci5kc3RfYWRkcik7DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiBAQCAtMzQ0LDEwICszODksMzMgQEAg
aWNlX2Vzd2l0Y2hfYnJfZmRiX2VudHJ5X2NyZWF0ZShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2
LA0KPiA+ICAJc3RydWN0IGRldmljZSAqZGV2ID0gaWNlX3BmX3RvX2RldihwZik7DQo+ID4gIAlz
dHJ1Y3QgaWNlX2Vzd19icl9mZGJfZW50cnkgKmZkYl9lbnRyeTsNCj4gPiAgCXN0cnVjdCBpY2Vf
ZXN3X2JyX2Zsb3cgKmZsb3c7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl92bGFuICp2bGFuOw0K
PiA+ICAJc3RydWN0IGljZV9odyAqaHcgPSAmcGYtPmh3Ow0KPiA+ICsJYm9vbCBhZGRfdmxhbiA9
IGZhbHNlOw0KPiA+ICAJdW5zaWduZWQgbG9uZyBldmVudDsNCj4gPiAgCWludCBlcnI7DQo+ID4N
Cj4gPiArCS8qIEZJWE1FOiB1bnRhZ2dlZCBmaWx0ZXJpbmcgaXMgbm90IHlldCBzdXBwb3J0ZWQN
Cj4gPiArCSAqLw0KPiANCj4gU2hvdWxkbid0IGJlIHByZXNlbnQgaW4gcmVsZWFzZSBjb2RlIEkg
YmVsaWV2ZS4gSSBtZWFuLCB0aGUgc2VudGVuY2UgaXMNCj4gZmluZSAoanVzdCBkb24ndCBmb3Jn
ZXQgZG90IGF0IHRoZSBlbmQpLCBidXQgd2l0aG91dCAiRklYTUU6Ii4gQW5kIGl0DQo+IGNhbiBi
ZSBvbmUtbGluZXIuDQoNClN1cmUNCg0KPiANCj4gPiArCWlmICghKGJyaWRnZS0+ZmxhZ3MgJiBJ
Q0VfRVNXSVRDSF9CUl9WTEFOX0ZJTFRFUklORykgJiYgdmlkKQ0KPiA+ICsJCXJldHVybjsNCj4g
DQo+IFsuLi5dDQo+IA0KPiA+ICtzdGF0aWMgdm9pZA0KPiA+ICtpY2VfZXN3aXRjaF9icl92bGFu
X2ZpbHRlcmluZ19zZXQoc3RydWN0IGljZV9lc3dfYnIgKmJyaWRnZSwgYm9vbCBlbmFibGUpDQo+
ID4gK3sNCj4gPiArCWJvb2wgZmlsdGVyaW5nID0gYnJpZGdlLT5mbGFncyAmIElDRV9FU1dJVENI
X0JSX1ZMQU5fRklMVEVSSU5HOw0KPiA+ICsNCj4gPiArCWlmIChmaWx0ZXJpbmcgPT0gZW5hYmxl
KQ0KPiA+ICsJCXJldHVybjsNCj4gDQo+IAlpZiAoZW5hYmxlID09ICEhKGJyaWRnZS0+ZmxhZ3Mg
JiBJQ0VfRVNXSVRDSF9CUl9WTEFOX0ZJTFRFUklORykpDQo+IA0KPiA/DQoNCkkgbGlrZSBpdA0K
DQo+IA0KPiA+ICsNCj4gPiArCWljZV9lc3dpdGNoX2JyX2ZkYl9mbHVzaChicmlkZ2UpOw0KPiA+
ICsJaWYgKGVuYWJsZSkNCj4gPiArCQlicmlkZ2UtPmZsYWdzIHw9IElDRV9FU1dJVENIX0JSX1ZM
QU5fRklMVEVSSU5HOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCWJyaWRnZS0+ZmxhZ3MgJj0gfklDRV9F
U1dJVENIX0JSX1ZMQU5fRklMVEVSSU5HOw0KPiA+ICt9DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiAr
CXBvcnQgPSB4YV9sb2FkKCZicmlkZ2UtPnBvcnRzLCB2c2lfaWR4KTsNCj4gPiArCWlmICghcG9y
dCkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKwl2bGFuID0geGFfbG9hZCgm
cG9ydC0+dmxhbnMsIHZpZCk7DQo+ID4gKwlpZiAodmxhbikgew0KPiA+ICsJCWlmICh2bGFuLT5m
bGFncyA9PSBmbGFncykNCj4gPiArCQkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJCWljZV9lc3dp
dGNoX2JyX3ZsYW5fY2xlYW51cChwb3J0LCB2bGFuKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwl2
bGFuID0gaWNlX2Vzd2l0Y2hfYnJfdmxhbl9jcmVhdGUodmlkLCBmbGFncywgcG9ydCk7DQo+ID4g
KwlpZiAoSVNfRVJSKHZsYW4pKSB7DQo+ID4gKwkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywg
IkZhaWxlZCB0byBjcmVhdGUgVkxBTiBlbnRyeSIpOw0KPiANCj4gRllJLCB0aGVyZSdzIE5MX1NF
VF9FUlJfTVNHX0ZNVF9NT0QoKSBsYW5kZWQgcmVjZW50bHkgKGEgY291cGxlIHJlbGVhc2VzDQo+
IGJhY2spLCB3aGljaCBzdXBwb3J0cyBmb3JtYXQgc3RyaW5ncy4gRS5nLiB5b3UgY291bGQgcGFz
cyBWSUQsIFZTSSBJRCwNCj4gZmxhZ3MgZXRjLiB0aGVyZSB0byBoYXZlIG1vcmUgbWVhbmluZ2Z1
bCBvdXRwdXQgKHJpZ2h0IGluIHVzZXJzcGFjZSkuDQoNClN1cmUsIEkgZ3Vlc3MgSSBjYW4gaW1w
cm92ZSBsb2cgbXNncyBpbiBvdGhlciBwYXRjaGVzIG5vdy4NCg0KPiANCj4gPiArCQlyZXR1cm4g
UFRSX0VSUih2bGFuKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0K
PiANCj4gWy4uLl0NCj4gDQo+ID4gK3N0YXRpYyBpbnQNCj4gPiAraWNlX2Vzd2l0Y2hfYnJfcG9y
dF9vYmpfYWRkKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGNvbnN0IHZvaWQgKmN0eCwNCj4g
PiArCQkJICAgIGNvbnN0IHN0cnVjdCBzd2l0Y2hkZXZfb2JqICpvYmosDQo+ID4gKwkJCSAgICBz
dHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBpY2Vf
ZXN3X2JyX3BvcnQgKmJyX3BvcnQgPSBpY2VfZXN3aXRjaF9icl9uZXRkZXZfdG9fcG9ydChuZXRk
ZXYpOw0KPiA+ICsJc3RydWN0IHN3aXRjaGRldl9vYmpfcG9ydF92bGFuICp2bGFuOw0KPiA+ICsJ
aW50IGVycjsNCj4gPiArDQo+ID4gKwlpZiAoIWJyX3BvcnQpDQo+ID4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChvYmotPmlkKSB7DQo+ID4gKwljYXNlIFNXSVRDSERF
Vl9PQkpfSURfUE9SVF9WTEFOOg0KPiA+ICsJCXZsYW4gPSBTV0lUQ0hERVZfT0JKX1BPUlRfVkxB
TihvYmopOw0KPiA+ICsJCWVyciA9IGljZV9lc3dpdGNoX2JyX3BvcnRfdmxhbl9hZGQoYnJfcG9y
dC0+YnJpZGdlLA0KPiA+ICsJCQkJCQkgICBicl9wb3J0LT52c2lfaWR4LCB2bGFuLT52aWQsDQo+
ID4gKwkJCQkJCSAgIHZsYW4tPmZsYWdzLCBleHRhY2spOw0KPiANCj4gcmV0dXJuIHJpZ2h0IGhl
cmU/IFlvdSBoYXZlIGBkZWZhdWx0YCBpbiB0aGUgc3dpdGNoIGJsb2NrLCBzbyB0aGUNCj4gY29t
cGlsZXIgc2hvdWxkbid0IGNvbXBsYWluIGlmIHlvdSByZW1vdmUgaXQgZnJvbSB0aGUgZW5kIG9m
IHRoZSBmdW5jLg0KDQpTdXJlDQoNCj4gDQo+ID4gKwkJYnJlYWs7DQo+ID4gKwlkZWZhdWx0Og0K
PiA+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1cm4g
ZXJyOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50DQo+ID4gK2ljZV9lc3dpdGNoX2Jy
X3BvcnRfb2JqX2RlbChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBjb25zdCB2b2lkICpjdHgs
DQo+ID4gKwkJCSAgICBjb25zdCBzdHJ1Y3Qgc3dpdGNoZGV2X29iaiAqb2JqKQ0KPiA+ICt7DQo+
ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl9wb3J0ICpicl9wb3J0ID0gaWNlX2Vzd2l0Y2hfYnJfbmV0
ZGV2X3RvX3BvcnQobmV0ZGV2KTsNCj4gPiArCXN0cnVjdCBzd2l0Y2hkZXZfb2JqX3BvcnRfdmxh
biAqdmxhbjsNCj4gPiArDQo+ID4gKwlpZiAoIWJyX3BvcnQpDQo+ID4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChvYmotPmlkKSB7DQo+ID4gKwljYXNlIFNXSVRDSERF
Vl9PQkpfSURfUE9SVF9WTEFOOg0KPiA+ICsJCXZsYW4gPSBTV0lUQ0hERVZfT0JKX1BPUlRfVkxB
TihvYmopOw0KPiA+ICsJCWljZV9lc3dpdGNoX2JyX3BvcnRfdmxhbl9kZWwoYnJfcG9ydC0+YnJp
ZGdlLCBicl9wb3J0LT52c2lfaWR4LA0KPiA+ICsJCQkJCSAgICAgdmxhbi0+dmlkKTsNCj4gDQo+
IChzYW1lKQ0KPiANCj4gPiArCQlicmVhazsNCj4gPiArCWRlZmF1bHQ6DQo+ID4gKwkJcmV0dXJu
IC1FT1BOT1RTVVBQOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtzdGF0aWMgaW50DQo+ID4gK2ljZV9lc3dpdGNoX2JyX3BvcnRfb2JqX2F0dHJf
c2V0KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIGNvbnN0IHZvaWQgKmN0eCwNCj4gPiArCQkJ
CSBjb25zdCBzdHJ1Y3Qgc3dpdGNoZGV2X2F0dHIgKmF0dHIsDQo+ID4gKwkJCQkgc3RydWN0IG5l
dGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl9w
b3J0ICpicl9wb3J0ID0gaWNlX2Vzd2l0Y2hfYnJfbmV0ZGV2X3RvX3BvcnQobmV0ZGV2KTsNCj4g
PiArDQo+ID4gKwlpZiAoIWJyX3BvcnQpDQo+ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gKw0K
PiA+ICsJc3dpdGNoIChhdHRyLT5pZCkgew0KPiA+ICsJY2FzZSBTV0lUQ0hERVZfQVRUUl9JRF9C
UklER0VfVkxBTl9GSUxURVJJTkc6DQo+ID4gKwkJaWNlX2Vzd2l0Y2hfYnJfdmxhbl9maWx0ZXJp
bmdfc2V0KGJyX3BvcnQtPmJyaWRnZSwNCj4gPiArCQkJCQkJICBhdHRyLT51LnZsYW5fZmlsdGVy
aW5nKTsNCj4gDQo+IChhbmQgaGVyZSkNCj4gDQo+ID4gKwkJYnJlYWs7DQo+ID4gKwlkZWZhdWx0
Og0KPiA+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlyZXR1
cm4gMDsNCj4gPiArfQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4gKwlicl9vZmZsb2Fkcy0+c3dpdGNo
ZGV2X2Jsay5ub3RpZmllcl9jYWxsID0NCj4gPiArCQlpY2VfZXN3aXRjaF9icl9ldmVudF9ibG9j
a2luZzsNCj4gDQo+IE9oLCB5b3UgaGF2ZSB0d28gdXNhZ2VzIG9mIC0+c3dpdGNoZGV2X2JsayBo
ZXJlLCBzbyB5b3UgY2FuIGFkZCBhbg0KPiBpbnRlcm1lZGlhdGUgdmFyaWFibGUgdG8gYXZvaWQg
bGluZSBicmVha2luZywgd2hpY2ggd291bGQgYWxzbyBzaG9ydGVuDQo+IHRoZSBsaW5lIGJlbG93
IDpEDQo+IA0KPiAJbmIgPSAmYnJfb2ZmbG9hZHMtPnN3aXRjaGRldl9ibGs7DQo+IAluYi0+bm90
aWZpZXJfY2FsbCA9IGljZV9lc3dpdGNoX2JyX2V2ZW50X2Jsb2NraW5nOw0KPiAJLi4uDQoNCkht
bW0sIEkgZmVlbCBsaWtlIGl0IGlzIG1vcmUgcmVhZGFibGUgcmlnaHQgbm93LiBJdCdzIGNsZWFy
IHRoYXQgd2UncmUgcmVnaXN0ZXJpbmcNCnN3aXRjaGRldiBibG9ja2luZyBub3RpZmllciBibG9j
ayAoc3dpdGNoZGV2X2JsaykuIEludHJvZHVjaW5nIGdlbmVyaWMgdmFyaWFibGUgKG5iKQ0KbWln
aHQgYSBiaXQgYW1iaWd1b3VzIElNTy4gU28gaWYgeW91IGhhdmUgbm90aGluZyBhZ2FpbnN0IGl0
IEknZCBsZWF2ZSBpdCBhcyBpdCBpcy4NCg0KPiANCj4gPiArCWVyciA9IHJlZ2lzdGVyX3N3aXRj
aGRldl9ibG9ja2luZ19ub3RpZmllcigmYnJfb2ZmbG9hZHMtPnN3aXRjaGRldl9ibGspOw0KPiA+
ICsJaWYgKGVycikgew0KPiA+ICsJCWRldl9lcnIoZGV2LA0KPiA+ICsJCQkiRmFpbGVkIHRvIHJl
Z2lzdGVyIGJyaWRnZSBibG9ja2luZyBzd2l0Y2hkZXYgbm90aWZpZXJcbiIpOw0KPiA+ICsJCWdv
dG8gZXJyX3JlZ19zd2l0Y2hkZXZfYmxrOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiAgCWJyX29mZmxv
YWRzLT5uZXRkZXZfbmIubm90aWZpZXJfY2FsbCA9IGljZV9lc3dpdGNoX2JyX3BvcnRfZXZlbnQ7
DQo+ID4gIAllcnIgPSByZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXIoJmJyX29mZmxvYWRzLT5u
ZXRkZXZfbmIpOw0KPiANCj4gKGhlcmUgdGhlIHNhbWUsIGJ1dCBubyBsaW5lIGJyZWFrcywgc28g
dXAgdG8geW91LiBZb3UgY291bGQgcmV1c2UgdGhlDQo+ICBzYW1lIHZhcmlhYmxlIG9yIGxlYXZl
IGl0IGFzIGl0IGlzKQ0KDQooc2FtZSBoZXJlKQ0KDQo+IA0KPiA+ICAJaWYgKGVycikgew0KPiAN
Cj4gWy4uLl0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfZXN3aXRjaF9ici5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9lc3dpdGNoX2JyLmgNCj4gPiBpbmRleCA3M2FkODFiYWQ2NTUuLmNmM2UyNjE1YTYyYSAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Vzd2l0Y2hf
YnIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXN3aXRj
aF9ici5oDQo+ID4gQEAgLTQyLDEwICs0MiwxNiBAQCBzdHJ1Y3QgaWNlX2Vzd19icl9wb3J0IHsN
Cj4gPiAgCWVudW0gaWNlX2Vzd19icl9wb3J0X3R5cGUgdHlwZTsNCj4gPiAgCXN0cnVjdCBpY2Vf
dnNpICp2c2k7DQo+ID4gIAl1MTYgdnNpX2lkeDsNCj4gPiArCXN0cnVjdCB4YXJyYXkgdmxhbnM7
DQo+IA0KPiBIbW0sIEkgZmVlbCBsaWtlIHlvdSBjYW4gbWFrZSA6OnR5cGUgdTE2IGFuZCB0aGVu
IHN0YWNrIGl0IHdpdGgNCj4gOjp2c2lfaWR4LCBzbyB0aGF0IHlvdSBhdm9pZCBhIGhvbGUgaGVy
ZS4NCj4gDQo+ID4gK307DQo+ID4gKw0KPiA+ICtlbnVtIHsNCj4gPiArCUlDRV9FU1dJVENIX0JS
X1ZMQU5fRklMVEVSSU5HID0gQklUKDApLA0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0cnVjdCBpY2Vf
ZXN3X2JyIHsNCj4gPiAgCXN0cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkczsN
Cj4gPiArCWludCBmbGFnczsNCj4gDQo+IFVuc2lnbmVkIHR5cGVzIGZpdCBmbGFncyBiZXR0ZXIg
SSB0aGluaz8NCg0KWXVwDQoNCj4gDQo+ID4gIAlpbnQgaWZpbmRleDsNCj4gDQo+IChCVFcsIGlm
aW5kZXggaXMgYWxzbyB1c3VhbGx5IHVuc2lnbmVkIHVubGVzcyBpdCdzIG5vdCBhbiBlcnJvcikN
Cg0KSXQgaXMgZGVmaW5lZCBhcyBpbnQgaW4gbmV0X2RldmljZSwgc28gSSBkb27igJl0IGtub3cN
Cg0KPiANCj4gPg0KPiA+ICAJc3RydWN0IHhhcnJheSBwb3J0czsNCj4gWy4uLl0NCj4gDQo+IFRo
YW5rcywNCj4gT2xlaw0K
