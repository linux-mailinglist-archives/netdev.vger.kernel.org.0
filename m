Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8E675CD1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjATSf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjATSfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:35:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019929B122;
        Fri, 20 Jan 2023 10:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674239725; x=1705775725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wiDfW5r+8FYAOwgD67EO6scI8pjD4J6XntbSSM5271M=;
  b=kqUSqw5FocnN40U7ibUxVlhuf5j4rpXnSQ6yXaI/vGkWMiCuV+qlVwPF
   c8lozY8PRkdKgYkMD7ud4R3BH/2KZXEi3OS21L6Lw5YTcjQtAkGC0S+dn
   IjNrL0lKbFn1fnUq+HKdxzwdigoT0R9Kf/Fr/bUDCbWxZUVMM23B+0PdV
   jlHzJLYNmbhCQ60QJTgaeLHp4vTL6f00mcjD7VGcNSINKmyd4pZX+7Vdi
   Fe5aM7BJ8XE6iZqkK/44YjkLvcyG/BiYF+DPCYnwfm5C4NjPl33n6Rw2T
   X+/8bC0QFvb/+6jcz/dXT2ycNshSXMyhcFM97CFjYTECuVqO/ex6lzGoY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="352910646"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="352910646"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 10:35:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="749447707"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="749447707"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jan 2023 10:35:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 10:35:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 10:35:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 10:35:21 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 10:35:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YXOOmE4k3ddqxX9gyz0PcB7BYOKpGMLAziB9dBYbiKr+ggVYcg1i/TZv2N2zKS/VZfGg+wcLAns1ZKxUphrIPw8CeUEO7h4+g3rv70/ljPCONNeou6WaIFcVztvAGq6Ga7K0UzgeWUVy9oIIuaQ1eNTSZtUA6pnvnvS3GTJ4InoNdkHa3bv+6fAdrcV7VWNKXaL77/eabE+o0nvA/l220vfNUalrJxWPTHWiS8vRT79nlRy0QoFQGcjwLj2D+K/rYD/d1Yh08OY9DV2AOL5XtDL1BVSe16t1NET3LYnyF8ozhlnxus+02wapT0Hq9AOAW8Q5fyWOqKhLlQ6uWia+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wiDfW5r+8FYAOwgD67EO6scI8pjD4J6XntbSSM5271M=;
 b=X6Bgh9kBJ3mcYFyVUY2byPFhdpMMzxyhACGasQVwwjp7W4EFd5sCwR45aXpgU8w4mCYPzVV8cd/qC1tM7GnPfp0hTeSj1DJ7lJDZ6pu5VMKP/5kO2Hcx/ARuLY3OMuh9bVEK1wU+cDqOqnS0Qwf36qkkYuxSEpqhxQ670MB9r1N4Vz7xxRuocGUnX4UoUCrpOLXWAoi02dwmEnECQ+tjt4sh6uoyjZKSUCZdtCmgrsWusi+JcLc4FDf6+4pbGtLkTcIECrhzd4KDgn5LnETt+8hOmUFg5gz/8Ko9K8TNJRWig06diZdNBEt2rA7vlnu+mVP5KnelNgaxZg6euQXDCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5544.namprd11.prod.outlook.com (2603:10b6:208:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 18:35:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 18:35:19 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "sdf@google.com" <sdf@google.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: RE: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
Thread-Topic: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
Thread-Index: AQHZK54dORDYoTDGjUCv5MeJsxNljK6mMjEAgABBSQCAAJNmAIAAnPkQ
Date:   Fri, 20 Jan 2023 18:35:19 +0000
Message-ID: <CO1PR11MB5089E0F6516DAB7657792667D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-2-kuba@kernel.org>
         <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
         <5dd6c9bf-192d-44ab-7d93-22c01cb8d64b@intel.com>
 <7918760462738ceded5b67322fd5ad8035215fd8.camel@sipsolutions.net>
In-Reply-To: <7918760462738ceded5b67322fd5ad8035215fd8.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|BL1PR11MB5544:EE_
x-ms-office365-filtering-correlation-id: 1d530d92-e795-40be-408b-08dafb15150f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FwmErXP3upvtfsJnMIOHNHA9yL5sizjYWuT8Fny/+uN2Wxk9+d3XNdIPbywGrQPAXjrqIGoVK6ZWHLQG/GSxxzP6fBzuzVzP2oKHEr8Rv10k3TkRjQQ/5OaV3ZxG0PyFIggJGOoCOS6mUiByd/svCA7kVPN5GXDA+lIPhx/oJh88nrUl3kM1ppMq0e+zpG75/ZTlgitgdXjcDEqA8XJc+BU2Rhogoh2U88tBWranL54mft8InIbR+pmqGKm+uiMhRPD9lPufMSheHEOJ41skhncJ8yfdix+NaOg09ySzNx/1SoaAdajGpJmP6zeTd88Fl3eFS6uTQdRk7GvpSDOLcY0nk36fYrePaDYpUXLv7hW2NkgfFIhBGn8YrrUfTYXwat1h4gRU7xkj6euezvmSoORmVlMNHNUKShE71G7AKLqRqLMCsHAIlv3q2ylfIScbBCf48A05fD/XAM9Kb1+oqTcUmaM1jZfsMiUWl3LFEH6YSGBLUOvc71hSUbhVOrTajV1Jkp6QQnLKV1fFVexFPzv2ObIwf08Zl+j9duxCYDvfliBFAWlzeAFHvJKrk8xMfnb+UxPED2R/+folPQ1wXfCpFo6FPsPHQ5TxaBaTQVvEgzLYd9NY0vhTxOlKu0EBSW+E52cUIYIzxWjDPW9Lz3R6+l4Vvy107Bs5QzMvx892HF1PGEaAaDTv6WuSXfLRKSVlxRbSdlrvmz7odP4c6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(39860400002)(376002)(451199015)(5660300002)(82960400001)(8676002)(4326008)(66476007)(64756008)(66556008)(316002)(66446008)(53546011)(7696005)(71200400001)(52536014)(6506007)(33656002)(8936002)(41300700001)(38070700005)(122000001)(54906003)(110136005)(38100700002)(9686003)(478600001)(86362001)(2906002)(83380400001)(26005)(186003)(55016003)(76116006)(66946007)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzNicVBEUDlFVHZyMkxTMUZhSFFha28zaVkvSW5mbjlpdHMwUTN6ZXVtNW9I?=
 =?utf-8?B?dlg3WGp1eHBqUi9hQ25odVVYNjQwSjczOHBtTmZVUDZNTnkyT2dKLytnNEox?=
 =?utf-8?B?cXFFZ0pzQTlGNGR2eEJqdEo1ZTRmejdHbEdtOFRHOHM0SXIwTUpGTmNxUUEr?=
 =?utf-8?B?ZUFaUTdGUGxmV3U0cTErRUJmS1BqcTZyK1RJaGRqUGhUR0FFUlZuZm5DNkFk?=
 =?utf-8?B?d1RpMURxa1hhbnFVb2lpNEZFZ1RKbkszSS9HMDltVXhDY05jSXZSNjZQM3FS?=
 =?utf-8?B?Mk1ndGV0ZFIzVW9kTVVvV2o0R0hZNDhvckV3Y1pRNlFrYkwzZUNteU5xWC84?=
 =?utf-8?B?SExraDhVL1Zld1pJTHo2dlExeGtseTRaWTJETk8vT3M0SGNJVGhjcGcwMHVJ?=
 =?utf-8?B?eGpucUdkS1lVdTkzRTJjdHB3NVk0RlpvRW9VRWNuRWxxZjJhNzdTSDBsamlC?=
 =?utf-8?B?dVJjMlIydEJadlN5Y0pyd2xXaVZBbDBCREo3dmM3b0tDeVNBK2w0aTA2VUtM?=
 =?utf-8?B?K3YrY0sraXJjSlV2Qk9wajg5ajhJdS8weVFpVS8xb3BieVdIRFZvWnhZVnFn?=
 =?utf-8?B?ZkMrYktaR2xvSldsMmFlMURhVDE0UHRMVnlOcFdPeFdLbjcvcVhnanhaN2NE?=
 =?utf-8?B?c1gxdzJiQ2lMY21PWXRsTCtTakZ3UGNDVmszQkxSWHhuRmZSWjM3TFlNc1JC?=
 =?utf-8?B?dFU0TGo3R2p0cFdPY0w2NHF0aisxZDY0N0tWNEhhTTE1TEZZSXVRSGVsNkhy?=
 =?utf-8?B?NTV6UzZHWEhSZzIwUitsaVdkUmdMZDd2NG1jRkp2MWFwSkllcGVFb0dYN0hT?=
 =?utf-8?B?bTN5bUV0TklneUJnUXhPdkgrZzcvYmxlSVErc2k5TWx2eVVNYzQ5M3dnRkdK?=
 =?utf-8?B?YXV2MVRzaE1YV2MwZ1djSjR4TzcyT2xGdVM4SGJRQlUrVGM5N0ZaNlFBU1do?=
 =?utf-8?B?UUxyMFlDaTllTW9vZFVhMHVseVROVTdTYXRhbENnbjVidkhsTExMalJRbWMz?=
 =?utf-8?B?dXhYZzF4OE5MNkhVbUlPYlJtTmt1empGRitJUHd4SzJLcjNDdTRQQWx3OFhv?=
 =?utf-8?B?ZW5naFVTNHpnVGVLT2IxV05NNEU3TzJMSVBQamovNHJCbUlFQXNJU2hrRGVH?=
 =?utf-8?B?SUlOT3hrRno5eURRcnNXeVJ5MUtwZHFoZGhxdk9WTHB2cSt2MGt3Ym5Yc2l3?=
 =?utf-8?B?N1E5Nit5MXBrUVo2VDZvZS94RTZQc3JydGtucXV2UHhRN2VIZVhYYzBnRHF6?=
 =?utf-8?B?NXE5Uk9tMUNoMmNDUXEyZXJreGdOS204OEd0emQxQlRwb1BoYU5CbzJBK0ll?=
 =?utf-8?B?ejZPMVBjYVZIY0lMUXUvMlhwWmc3SVNaTHVUamxUaEVlUEZhbTBiU2RNZ0Ey?=
 =?utf-8?B?bWdSS2RBRU5hTE4vUEZMeU1mV2pmc2l3K0ZNTUZjekQ4dXdCdFNQaVlTL1NR?=
 =?utf-8?B?Y0JVVVEwcndWaFc5ZVFyTkg0ZzRoTzVaUHpPNkEzUjI1SkFubDhRMFJSbDdT?=
 =?utf-8?B?c1FldzRReSsvVUhwREFqaUlEVzUxUWdGL3NrSVNDNHNWbXdoNVRMSjlMRDlr?=
 =?utf-8?B?U09zR1ZGdU9OclhMb2h0d095TUNqOXJQa0ViTWFsZlVVbDNnTzBLUjNZQ3Jt?=
 =?utf-8?B?OU9XSXk4eWJ6d1VwUE9WaUR2bFJBbFRpaUhKbWhoVWRONmtrcmV3SlhuNGFL?=
 =?utf-8?B?SFRURVdlUzVhY2lOMUcvRE5jWklVajU1Y3N4SUV3UGpNVWx6RDVGeTZ0OVk5?=
 =?utf-8?B?akJXMkJqc0s2VWs0QUp3VzVhMmd1L3VYZC9jd05HVy9ibS9NSnBEbWdkWnVY?=
 =?utf-8?B?anJkUUtWU0h2UmFuLytpT0VCMzBISWtXY3QzWERWU01pUW9pUDJGNW10WXVw?=
 =?utf-8?B?NDlNZUJma29rTjQxMlc5MDVLaWFJV0tlS1B6ZFFEUGYrcE9wcGZUaXZnREJ2?=
 =?utf-8?B?cVNjNjJvVmxPNVFid0JxamZzY3lSTUcwZTFjbnQvRnpSY1hGYnp6L2R1SDZp?=
 =?utf-8?B?aWlWakgxbzBRaDl4OUxIZXp0VjNOSUc1M05tSkp1RWdyVXZ2TnNEY2UxRzlJ?=
 =?utf-8?B?RGtrQnAycFEzaGttSXMvWUYwTkpZNHBCUUZrZTRjbXFaTFlCVjNxcy9udlN6?=
 =?utf-8?Q?YJfOdUonrK7yex0wJJ0xMKrmR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d530d92-e795-40be-408b-08dafb15150f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 18:35:19.2240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZg7llulOmxFyDIPyFx/lJnT+T13iW7b5Twn2fNozdxCa1sqgZDzyelsp6WMnGiM2pStZxjS1BjE3jdJsTd4V4TTydpM6qE4aPnCmYQCU0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5544
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9oYW5uZXMgQmVyZyA8
am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD4NCj4gU2VudDogRnJpZGF5LCBKYW51YXJ5IDIwLCAy
MDIzIDE6MTEgQU0NCj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwu
Y29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IGRhdmVtQGRhdmVtbG9m
dC5uZXQNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGVkdW1hemV0QGdvb2dsZS5jb207
IHBhYmVuaUByZWRoYXQuY29tOw0KPiByb2JoQGtlcm5lbC5vcmc7IHN0ZXBoZW5AbmV0d29ya3Bs
dW1iZXIub3JnOyBlY3JlZS54aWxpbnhAZ21haWwuY29tOw0KPiBzZGZAZ29vZ2xlLmNvbTsgZi5m
YWluZWxsaUBnbWFpbC5jb207IGZ3QHN0cmxlbi5kZTsgbGludXgtDQo+IGRvY0B2Z2VyLmtlcm5l
bC5vcmc7IHJhem9yQGJsYWNrd2FsbC5vcmc7IG5pY29sYXMuZGljaHRlbEA2d2luZC5jb207IEJh
Z2FzDQo+IFNhbmpheWEgPGJhZ2FzZG90bWVAZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0IHYzIDEvOF0gZG9jczogYWRkIG1vcmUgbmV0bGluayBkb2NzIChpbmNsLiBz
cGVjIGRvY3MpDQo+IA0KPiBPbiBUaHUsIDIwMjMtMDEtMTkgYXQgMTY6MjMgLTA4MDAsIEphY29i
IEtlbGxlciB3cm90ZToNCj4gPg0KPiA+IFBlciBvcCBwb2xpY3kgaXMgaW1wb3J0YW50IGJlY2F1
c2Ugb3RoZXJ3aXNlIGl0IGNhbiBiZWNvbWUgaW1wb3NzaWJsZSB0bw0KPiA+IHNhZmVseSBleHRl
bmQgYSBuZXcgYXR0cmlidXRlIHRvIGNvbW1hbmRzIG92ZXIgbXVsdGlwbGUga2VybmVsIHJlbGVh
c2VzLg0KPiA+DQo+IA0KPiBZZWFoLiBJIHRoaW5rIEkganVzdCByZWFsaXNlZCB0aGF0IG15IGlz
c3VlcyBpcyBtb3JlIHdpdGggdGhlIGZhY3QgdGhhdA0KPiBwZXItb3AgcG9saWN5IGltcGxpZXMg
cGVyLW9wIGF0dHJpYnV0ZSAoaWRlbnRpZmllci9udW1iZXIvbmFtZSlzcGFjZSwNCj4gYW5kIGlm
IHlvdSBkb24ndCBoYXZlIHRoYXQgeW91IGhhdmUgYXR0cmlidXRlIGR1cGxpY2F0aW9uIGV0Yy4N
Cj4gDQo+IEFueXdheSwgaXQganVzdCBmZWVscyBzdXBlcmZsdW91cywgbm90IHJlYWxseSBkYW5n
ZXJvdXMgSSBndWVzcyA6KQ0KPiANCj4gSm9oYW5uZXMNCg0KSSB0aGluayB3ZSB3YW50IHBlci1m
YW1pbHkgYXR0cmlidXRlIGFuZCBvcCBJRHMsIGJ1dCBzdGlsbCBwZXItb3AgcG9saWN5IHRoYXQg
aW5kaWNhdGVzIHdoaWNoIGF0dHJpYnV0ZXMgYXJlIHN1cHBvcnRlZCBmb3IgYSBjb21tYW5kLg0K
DQpUaGlzIHdheSB5b3UgY2FuIHJlLXVzZSBhdHRyaWJ1dGVzIGZvciBtdWx0aXBsZSBjb21tYW5k
cywgYW5kIHRoZXkgc2hvdWxkIGJlaGF2ZSB0aGUgc2FtZSBzZW1hbnRpY3MgZm9yIHRob3NlIGNv
bW1hbmRzIHdoaWNoIHN1cHBvcnQgdGhlbSwgYnV0IHRoZSBrZXJuZWwgY2FuIHByb3Blcmx5IGV4
cHJlc3Mgd2hpY2ggYXR0cmlidXRlcyBhcmUgdmFsaWQgZm9yIGEgZ2l2ZW4gY29tbWFuZCB1c2lu
ZyB0aGUgcGVyLW9wIHBvbGljeS4NCg0KSSBrbm93IHNvbWUgY29tbWFuZHMgZG8gdXNlIHNlcGFy
YXRlIGF0dHJpYnV0ZXMgZm9yIGVhY2ggY29tbWFuZCwgb3Igc2VwYXJhdGUgYXR0cmlidXRlIHNw
YWNlIGZvciBzdWItYXR0cmlidXRlcyBpbiBuZXN0cywgYnV0IEkgYW0gbm90IHN1cmUgaG93IHdp
ZGVzcHJlYWQgdGhhdCBpcy4gRGV2bGluayB1c2VzIGEgc2luZ2xlIHNwYWNlIGZvciBhbGwgaXRz
IGF0dHJpYnV0ZXMuDQoNClRoYW5rcywNCkpha2UNCg==
