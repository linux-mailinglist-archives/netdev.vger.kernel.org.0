Return-Path: <netdev+bounces-1339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 803F36FD779
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AD5B2813A2
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D175686;
	Wed, 10 May 2023 06:54:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85E7F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:54:34 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BC51BE4;
	Tue,  9 May 2023 23:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683701673; x=1715237673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UqTC0IrX1fsiWtY7tkZ0TSpLaaxOidh/2SwfbTrQEf8=;
  b=VjVTPk2wwUykefQsuZZFR0xG5FM5OuG3QSBv6ulyxlw1y2MjUSRc/m0N
   7CCHPEWpkSmi4NLb6hnauhcNNyAe/mXV7j0W/GrTN0P8S7C6dXcNc7SQa
   5LbH5wDP/OLGjEyESxFn6Ydx06roaBFp28bcvKz8IluqvD+58UJIk/GS4
   dbvEjnDlprXSo9SwYhSH7764G9L8Zs+SHp+LH0kFm1osVcxmJH9Sek1xP
   4CnMLK+vCrTIR3vWH3Gq7zHW63Th0BYs/Ppqgl0CaZakHZ/JjhyWQCxxP
   y4Po8Pgf9lqo72RhkccBUsKk+RikoIHvkqtnHsGpfYNehgN/PeKQhLcuk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="378237498"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="378237498"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:54:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788817700"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="788817700"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2023 23:54:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 23:54:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 23:54:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 23:54:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMhnuczJ192yK526QDWd/Wu6Tzb1Kcn4MaBi2d5+nrwNgx2pEuzfqnVxdfmA5OoF+qBNn8CvGmGxSm78iDFeGLYscPNTWEulzEeuQi3eEsPtzI8xtfNndCjtRmK3unPmGctOLQEs0KJfmUlqw2Ivl7hbcXG3swTLHc/trafKbmmi/nOMVylu88gkpXZ/K6FoCG9hHxKi08anECsb7vakinwXWB5BWqZmVcVHNkmx+XXTbxbdadCsoAq+gMrGmFNBiufvNAR4cM91vSGfhv0PAEQfovBt1u2WkGDsIYaWe6pFzruM/qVlI6P+mvpc3T/NLB4P6vw1Lu7f5k+Pp1DARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UqTC0IrX1fsiWtY7tkZ0TSpLaaxOidh/2SwfbTrQEf8=;
 b=A39koXOMw/d08IPfnUKPiH9Eqaa+PMNmPVAuaWpMFz35gTez3VCH2IMh3kVSUkdXwYppjr39d7xPTyeNfxEKOCkl4Ugms43vRoKgpqGp6HRWkCa/GWgylJd9XAdGgXJIJvG56/aZLwQbLzOgM4wFC9CMumCqio6exlEfVxQqWOal/sdUbCpVSG48sQGRLsXk+XrKCaz49HxuIv60CN9hAtsQEOao39wB0g/c98MWkeUsGsCBbhNwzR1hlr53U9FFk3smwdPT46lNnAXBsa6qZy3GFpSxTcxO2Lr1HE3/345aAC6f3/dR8XSTc76nZaDx4ScbxwKVPh64jqPHw2OuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MN2PR11MB4678.namprd11.prod.outlook.com (2603:10b6:208:264::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 06:54:28 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 06:54:28 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>,
	Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>
CC: Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAD2w6A=
Date: Wed, 10 May 2023 06:54:28 +0000
Message-ID: <CH3PR11MB73456988A38EB575F99699CCFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
In-Reply-To: <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MN2PR11MB4678:EE_
x-ms-office365-filtering-correlation-id: 93fa0e0c-382f-4f91-3987-08db51236653
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mHr91CQvoNI3Ia+pJ+weManwzuG98rS7EA23x+spRFBXFK/gqffP8X2Ckb46WFdXULa9l0S+QcjZMZuAsYP73pCpHvR8DgbuXwIV/y6C+w/ESK9bS39ojV51c5tFOnnFQ5FI+onD1Q6vvbjB6YrLXPzignn7FzB5uF1TNDqlfw2j8yiWb67ilWXBqBZvTZvD0kv4EwfmoMqGWgkO/Y2Ei2ijMPja3DMEwepmsUk/ckTHQ1PN+4oqc/kBAn5lizTYMA980ie9N75UdUP5AMzD1k77uh4aC1bsKrhZ0g1Q92O5arSRBVLSGv2QyuXjkndLMUPOWTcnihmlHPhYb4yX/oFmIdvflksrJjRjM1A6VSfQxbbJzVySzsCB++F11nel6NLPr9Vd1cVycR56KeZ6gsTKhT+OUXwWBdQF4B8xsl4q3p3UZIRFTPBUXBBuBkNWDf5bEYAaUDb1A+nAHqf2GkVosYYL0hXQUAZ1TrOZnimPZL9yayIPsZhz2utANBQ/k+LvXcNkOaUm2MGBAVfWxKghaQsvZZNSvsk5Ff7bvCDhyV70eKHvMZmCkUlZ05HMyOOcffHxrbWSIwAlDI88i+i0ivC3DGvj5wCL4KuePEo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(122000001)(83380400001)(110136005)(66946007)(66446008)(64756008)(66476007)(66556008)(76116006)(55016003)(4326008)(54906003)(5660300002)(478600001)(86362001)(52536014)(38070700005)(71200400001)(316002)(82960400001)(966005)(9686003)(38100700002)(53546011)(6506007)(8936002)(26005)(8676002)(33656002)(41300700001)(7696005)(2906002)(4744005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjJOY3A4dTNOM2ZKalpTOVRzV0xGdnZQTlk3RzA5VkRSZmhDbi9TOVg1bXVS?=
 =?utf-8?B?Ly9ZMGNha0p1L09QNjZxdlZ5aVNybVRPQ0hyYXVGMWI0S0U1TEphSlVWSTdZ?=
 =?utf-8?B?K2FiQXNVdGhZRkMrVFlpZzRrSmpQSTlwR1VGMk5VVWp2S25LQXErd29aYWxR?=
 =?utf-8?B?MzdnYnZIUEViYXdQSWo1dGVqY1AyUlpsLzZRbXlJMTRzWFd4VU5SSXJIODJp?=
 =?utf-8?B?U2QzUmhWVFRUM0RrclViZmZBT0FZc2ZUS2E0RGJMMkhpMERlQStjS2ZvZ05x?=
 =?utf-8?B?LzRUbDZRc2Jmb1pjUk1LYy9zd1RacFREamxLbEhROWRDUmVTbWoxOVpveEFC?=
 =?utf-8?B?dC8zWVBJNThOWVRqb0xReC9PL210QlpxaStubFVVM0FZMmtCTjg3QW8wMTBu?=
 =?utf-8?B?cVFpZ2luUmZRRkx1R21ZMVNwZE1WTG9qdHdhdTFWVmk5ZWRlOUJRdzZoNjFh?=
 =?utf-8?B?WnFCbUladXlDK1NXYkwydkZmUFdTNjJJMWdzV0JoTE4vRmxFclVEOGRFNEE2?=
 =?utf-8?B?QitVcUtFNUlsaVhWL0dHc2x4MTY5bTFPWWJZZlI1QnU2TFg1NGltcExVWVp5?=
 =?utf-8?B?RmpVMHdJdkFLSE0wa2hCWUZrTzNaZWNkVDJ0YnNsZHI2SkRObzNJV0FSSkRM?=
 =?utf-8?B?WFp1RmRYNklyU1h6T2NSTWpjS1hiSTBQeUk3L3lBQ0Y5U3g4OFAxWkhtUU4r?=
 =?utf-8?B?QXcxUFJVMTdtTEtYckVPYnlSK0l3QWhHazBDVlN1RkJLMFlFTXJEdnZxZXhz?=
 =?utf-8?B?c0Rnb0xSZHVFWXArWWpJUkdZSGEvUU9mYzdPaHFETytXZlE4QkVnUzFDQXJk?=
 =?utf-8?B?TWlSUlpyRUVEY281YlVVNmVDNzdRYXozalZOSVhxckFFV0crcXZCQWp2VFJC?=
 =?utf-8?B?OVNnWXNzZVRxZXVWMk5tUS9hc1g5alIzMDR2eTIyWUNJQ0ZNSlJjYXhMM0lk?=
 =?utf-8?B?OWJGVldzSS9zWHFaL3hTWlZVRTgyZnRpdS9CRzI4SnNXbWJvZVFvM1EwbWhs?=
 =?utf-8?B?ODF1dnU4MTBzMGZZUEdSdXN3WUFzdHVtTTZrRkg0SGdVOUVhZDlUaEY0TG9l?=
 =?utf-8?B?SUVoRUN6OTNuakFxSW9vd1preWE2dFNFNjVXb2lzZWVnZWxrZWVqaVBiWkRT?=
 =?utf-8?B?aG1EWG5OTFdFbEVzZU1xNDFDQjROeTk2bTZFNmxlM0tyNVBJc3pnQkxkMUlj?=
 =?utf-8?B?Y0FWSzRQQVh0Y0ZYQ3JGRVpDbzVrRm5RYSsvanM2K3RhRkFBMXFaelRMRmkx?=
 =?utf-8?B?MExmV1VRRVhWVURxSk02eUI0QUQ3MWx5STNPSm1UdzlXZG5WbUszNHNpVEpI?=
 =?utf-8?B?cjNWSERnOHQ5TFFqOWZZYUozaFNaVWlsdHZCK2NRUGpFK29CR2Ntdmo1WDJI?=
 =?utf-8?B?cjB1QW4xVlpuRjR0ZnNLUXJkZW1oZzZXMU1XazY0L3ZrVkptL1dwdlArSDVJ?=
 =?utf-8?B?TlI2dXhlZDlNeVNTcVZZL1oyZlF0NGtZWVIwL2gvMG5ZTDBFVXQ5TFJYUDJS?=
 =?utf-8?B?TUpZR29lME4wRTRTbE9lbDRSTFIrVDg2Uk1yL1plNFJZNCsxNUdHQzhWWWV6?=
 =?utf-8?B?SXdTRWxCLzhEamhGZEtlMnk0bzhiZk9QZ3VMWUlFa2xNMVFjazFWZzVNQ0pG?=
 =?utf-8?B?SjNtejdjRGljQU5JeHhEZC9ualZqN0Evc1F5djdTdTZjZXhEQjFJMlB4QndO?=
 =?utf-8?B?WTV3ak9KMUNibVpCYmtVS04zS0JMaUxUMHdWZ3AxS1hDVlFqOUZJcXJDb0lj?=
 =?utf-8?B?bDVqY1o0WHRZTXdQcFdrczVTYTlRQy9GTUNSV1p6eitPbmQ1UDF5aXRURHRL?=
 =?utf-8?B?SER5blRrQTFoL0RLaXordXliejNtcmJQakFOb2R1RmhMNEJRRkdlblhPbzc4?=
 =?utf-8?B?cytOZnFGZElqdlVnZ1VEdGFVS3AyRTZGeXFnSmdIVC9hU2RuT0NkdVdjd01n?=
 =?utf-8?B?UlVvdDRnc3JXdEFEdHZjVGU5Q1ltNk5rbnNrTzF3RGJLNThWVTE5RlhqMzFG?=
 =?utf-8?B?bXlHdlNXWHJVNDJCc3FOaFJWSkRVN3hveUMyREo2QUlpaktqUURpOWl3U3k3?=
 =?utf-8?B?ZW5XUnhFVU5HK0RhUDc0TTFYYUxONy9idWV1TlpYNU5icTZlQ29yTnY5bmx3?=
 =?utf-8?Q?LpcM+FEdP5x0P6klw99ZGiQ+I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fa0e0c-382f-4f91-3987-08db51236653
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 06:54:28.5394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfddoBgBne/+ViD3uW+/sPS0Nt9SndswLUUEAsIKAPjQw3gbPjeT1PfWgeIPPuskCROW4TWUHhN51KQqwrSHJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgU2hha2VlbCwNCg0KVGhhbmtzIGZvciB0YWtpbmcgeW91ciB0aW1lIHRvIGhlbHAgcmV2aWV3
IQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNoYWtlZWwgQnV0dCA8
c2hha2VlbGJAZ29vZ2xlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTAsIDIwMjMgMTI6
MTAgQU0NCj4gVG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IExpbnV4IE1N
IDxsaW51eC0NCj4gbW1Aa3ZhY2sub3JnPjsgQ2dyb3VwcyA8Y2dyb3Vwc0B2Z2VyLmtlcm5lbC5v
cmc+DQo+IENjOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IFBhb2xvIEFi
ZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZzsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29t
PjsgU3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4s
IFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91
QGludGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+
c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiArbGludXgtbW0gJiBj
Z3JvdXANCj4gDQo+IFRocmVhZDogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwNTA4
MDIwODAxLjEwNzAyLTEtDQo+IGNhdGh5LnpoYW5nQGludGVsLmNvbS8NCj4gDQo+IE9uIFR1ZSwg
TWF5IDksIDIwMjMgYXQgODo0M+KAr0FNIEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNv
bT4NCj4gd3JvdGU6DQo+ID4NCj4gWy4uLl0NCj4gPiBTb21lIG1tIGV4cGVydHMgc2hvdWxkIGNo
aW1lIGluLCB0aGlzIGlzIG5vdCBhIG5ldHdvcmtpbmcgaXNzdWUuDQo+IA0KPiBNb3N0IG9mIHRo
ZSBNTSBmb2xrcyBhcmUgYnVzeSBpbiBMU0ZNTSB0aGlzIHdlZWsuIEkgd2lsbCB0YWtlIGEgbG9v
ayBhdCB0aGlzDQo+IHNvb24uDQo=

