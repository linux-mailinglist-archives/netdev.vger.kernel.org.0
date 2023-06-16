Return-Path: <netdev+bounces-11488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F61733547
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 586F41C2100C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0688719E67;
	Fri, 16 Jun 2023 16:00:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C318B1D;
	Fri, 16 Jun 2023 16:00:32 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C62D5D;
	Fri, 16 Jun 2023 09:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686931231; x=1718467231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kGEhgTRN28m0EK1O5VMPcfIfbuK/PkTjN9+K3CXcQ+E=;
  b=NJWLoA8tJGebjzTB9TEPLQYSHe2o6Y7u/JrnxAOBlMRlGJnx/frj2k0D
   23rvzfeJCN1xZlvM6FR79SDWn0DvDf0TGsbWiWQbgLVYeBUcSL3aqUxiJ
   Sw/RN7vMmvbLEsppLXyEAgLOd981dFXbaMShrjQWE46/NOwu9ETTosITH
   idqaOvgQgvwdz+dAK0dSh6Wz9rXr/8W2at/F/7QOrybLjlInwYZHjlKGb
   dGL1/IYRPx8/fXrP27ui0c4VUMdJdZ19cN0RIZHQtJbMT7akHgUnL6ODg
   gfKCag5h3mAYtcY6u6uYnHaTpKyIpgUjKocjrK+FPmcdTrYrU+iiEl9FD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="422898477"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="422898477"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:00:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742717785"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="742717785"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2023 09:00:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:00:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 09:00:22 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 09:00:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOw+MwR/uPGeZKQUkQhhmallZEOXg7CbXhAHNCJB1bZxgEmt7bpNSBR0O0FlozW7+ipkOfXB7Bly60FaXKqT/ms6FeCJ2RMtH6l7fqmqWA+XRuUl8adPlyRFOcq1EOwV637JQFXTrdN6jSvMb9Fv30CtbgL2Iq0LHqQyhpW+DpS6N8OSNfyxWuTkRAe1twj72c/KtnvM0pXwjNPLeF+pAjouZtjJO5ZAgqbwukp1zQhn183JUa6V8Jn+jW9H+0lMB+ZEKf4hEDrTWB9G32KupCAJ/iDuKYYkFeJ59zo435yAzvDy3VDhJR7soJx9+L/0npY8eO0KAtFasV6jYVWmWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGEhgTRN28m0EK1O5VMPcfIfbuK/PkTjN9+K3CXcQ+E=;
 b=BgO1WVMAZWZCkWvDD8cmMMN3wg86fQ9PHpRRfLYAzZRGcVQ7RvaW6AwH69LirfwM0oV/FI3ggMvqL4FFoVf4HwcYk6mK+mIv92oc2SHu8o96aAa0lnrvy1e8GQm26aFC/USPyRmiYpaJ9pO/YU6jVCogtDC7LHGWC5Me0R4z5FRGYawsbzUdODrCqgwiBff3BvrUMYTqWby1tbwHaPVnMuMZd2GAY9fX09wQT/Bm8o+mOrmyyt3uB68Q1FKu/Fn4s93etaV7WA97ygJdJNqESOx2P8wZ3fYysrEktlpzFDWkw6uH2g821Kt2Ngt/jP8nK6dlXK7Ww/R577S81Gr+Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4930.namprd11.prod.outlook.com (2603:10b6:303:9b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 16:00:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 16:00:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mcgrof@kernel.org"
	<mcgrof@kernel.org>, "deller@gmx.de" <deller@gmx.de>, "davem@davemloft.net"
	<davem@davemloft.net>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"puranjay12@gmail.com" <puranjay12@gmail.com>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"will@kernel.org" <will@kernel.org>, "dinguyen@kernel.org"
	<dinguyen@kernel.org>, "naveen.n.rao@linux.ibm.com"
	<naveen.n.rao@linux.ibm.com>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "linux-modules@vger.kernel.org"
	<linux-modules@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "song@kernel.org" <song@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
Subject: Re: [PATCH v2 01/12] nios2: define virtual address space for modules
Thread-Topic: [PATCH v2 01/12] nios2: define virtual address space for modules
Thread-Index: AQHZoC/AtDqnmjljKUyti1SYZxHTgK+NluyA
Date: Fri, 16 Jun 2023 16:00:19 +0000
Message-ID: <6f9e9c385096bd965e53c49065848953398f5b8e.camel@intel.com>
References: <20230616085038.4121892-1-rppt@kernel.org>
	 <20230616085038.4121892-2-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-2-rppt@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4930:EE_
x-ms-office365-filtering-correlation-id: d6aad173-1d51-4717-51e1-08db6e82c8d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0d9JFxv9hosLiwtk71F42QPxQJUZw+1FtgfKmHbzDl6ab253MV3UCzK7OViBrQoLgOw5PRqlxNZTzwJrKi5mtjiRalPEcNofoSHKpmuhCdEHctTE8AWalKU+hQ+hzMgMY1M8UCZ7eLbJnUdNEmMVdd6Z8MdMYA/C+qZ7sj0SxD3oZAUXiyBX6G05TBslyCl6oo1o0ssGkKQaFyU/uWIefvIPfL64q9yXgIdQl/pTnQnUbBv8M35s+fYECF7n2rdbIBDsKPRNIs08ICbGJuDA1utnOPFZ0oEa/CiiKXVq5EDNK6C1lQTskizNcbY5eAoSccdzh1qRBJg3l5nwOzQmSKOlh15dLjqvu5k3mlSbCHux16giA1TA7R7CMlUgUek7OQXafC8mgFvvsrLgL9MIw0rB34AkFZzDqmyyfC5esxem95QsyIsPdn6Ed4yfH95YAtdFraeV1bEpXEs9+qiIS7HP3B1cICMY4wyDWdMnLwhoTDITv8gVzEkyRLJw0d0XzzT38jmUkSO9D4KcBklsEJfQT4q0qH8L+o4p/f4aPkPG4G5ihtZeoVVAqiz2pii+hWH23jpqW31Ii4AIJQLEoyJfXJZCoMXWkRgeMFVMcskj/as7XbvBx4I0TRBt2MK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(110136005)(54906003)(41300700001)(86362001)(66946007)(66446008)(64756008)(66556008)(66476007)(8676002)(6486002)(71200400001)(8936002)(316002)(91956017)(76116006)(36756003)(4326008)(38070700005)(478600001)(6512007)(7416002)(7406005)(26005)(5660300002)(6506007)(2906002)(4744005)(82960400001)(186003)(38100700002)(2616005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3hCK3Z0YmxPQm5DdkRyMG53NmNsVzdvaEJmbGUzWkYrVFoyVlJ4by8ySHlz?=
 =?utf-8?B?blhEMlc3RTBBMTFlQWxVUUVjVXNFamkyQ0V6b2RnMFkyaVgrWjJleHRWOHkr?=
 =?utf-8?B?UFVUdGFScHUvbTEyYnZDM05SeTg2OWlKdkZkRDQwUndMdDVCeXJrYjFrQTdZ?=
 =?utf-8?B?MVNybmZtWlVsV3BQMmt5akFNWFFQVDhrZ01NYnZ0RXUwSHJwckswZVE3KzdR?=
 =?utf-8?B?ZHNjelhDU3pTYVdFNkpLcER6ZzVPeVJIc1JoOENuTUJFMG9xTnNVRGR4bFNL?=
 =?utf-8?B?VmRMMUpCZmlEVzRpbVU5YnN6ekhTTDk0UlIzaVpZOERvZTBnL0ZRdWVPOFpz?=
 =?utf-8?B?RjdIeFNDVDNkekVtQXArcElkbGQybUpQb25GTnFpcWtSMzV0bjhocFR1eGxO?=
 =?utf-8?B?Z2RUZExOZHZHQVNTbWprREZpa0NVb3VPczJLdUYwY09kNDhsMGNtTUl1dngz?=
 =?utf-8?B?dnNjUFFROEdGNkxPSENBbkJlVnI4L0tFQWRWTWovalFXQ1RSanNQQnBHM3RB?=
 =?utf-8?B?MndyY3BQWml5akZLUG1qT1dxNUdMYmZvTmp4V0g0ajFlbWVoYUpQdzRSMEd1?=
 =?utf-8?B?SVBwN0x4L2orL3JyRzFOb2pGVlkvTS9vUEhhWjdCcmhoN3lvOVkvYTc1ZnNr?=
 =?utf-8?B?SU1ESnpDUTJWTUhZT3NJWC9qRlU2Q3k4SjBRRS9RMHQxM09vVkJsYm5jTDd3?=
 =?utf-8?B?TkxIN3RtbUNobTd6bUZtbU51MlQ0ZWhpYlR2MGY1cU9CcTFnVUg5b0tldEM3?=
 =?utf-8?B?N01GRjNUZ096ZXBlY1Q2VXJoZVpXUlZ3cGczVCtFR1JiTVVoU1FOSkE3Rk1V?=
 =?utf-8?B?LzBzcXFVUlMyNDQ5S1VWeUFYMnFtbDV4eEprYzhWY09PN0gzQlQyRUJROThG?=
 =?utf-8?B?UU5La1AyeUZzOEVKT00zdTJIVjR0Y3hJd1VSNFJTTWxQZXhNYWQzWnV6S2p5?=
 =?utf-8?B?UHltOC8xVDh4TjMyVklqblRjU1I2aUpMNzhkSFVqZnphNHNaUSs0bjNpaDk2?=
 =?utf-8?B?MGxBdWNQajdDbHZEbDlzRXdlbUxINCtnKzA4dXpDQmdoK003WG9vclY4bGYy?=
 =?utf-8?B?WnpGRENFMy9yaGVSbWUyK2JCVElaUDlKaFN5T0h3N2d2eW1Yb082Q2NYQTRB?=
 =?utf-8?B?dWYzOG1ZTldMQzVFRFI1WnpCbmtLeHQ0RjJ5QzFUWWQ1eGQ1VFZpTE5YUThS?=
 =?utf-8?B?d21aN0JRUXBPaHBlZUZvY3dEcUQwTkFzelhBTUFHV0JFcEh1b2t4MXAwbTQx?=
 =?utf-8?B?ZkdMLzZZQlM5T0FFZUI1TFQwMnpOVXNnaC9hZlBBd1Q3b0RhUDlCYWlFU0FH?=
 =?utf-8?B?WFZDQXlSa2NJb2ZaL3B4WDVVWFEvY0V5N3pZUlBYMzRtZUMreU9UUzFzYzd5?=
 =?utf-8?B?U2NLN2Vsd1V5RFNxMVBKd0tpS2puNFRHUkNSMDI2MlFJbjd3Q2Z1QWJ0NkYv?=
 =?utf-8?B?UG9FN2tXU3VBWnZTZHFJSFlGSGQ0aUNub2poSUhkQjZLY0RLZXV1OVB2L1pp?=
 =?utf-8?B?ZWI1M0xDaW5WWUtmSmkrckIraU5OSTVBd3B1V3BLdHlGci9yejJjN0pCZXFG?=
 =?utf-8?B?cExaVjhLeWVWYkY0RWR5eS9GRC9sMjhoT21VaVM5ekJmb1BvQVdNcnBaSjhE?=
 =?utf-8?B?ZHJRSEFrRDdRNzV6SlVxVGVYeEt4VGRWQ2JIMjhKV0Y1T2tMLzlwZ1RIWnlm?=
 =?utf-8?B?R2d4dzExc2tvWGNmOHN2OC9SRjJ6OWIwR016ellDNlh2YXhtQzQrZmpDMmdr?=
 =?utf-8?B?VTFlYW10My9vNmhmZm4wRHNodUVJMEFuWndhaTVaM0V5UjhkS2ZpY1hKdDJz?=
 =?utf-8?B?R25iajAzREtiSTI4czRzZ2ZRdFJwcEhBTTZvNVF5UjF0QWtNZ0l5U3Yra1VG?=
 =?utf-8?B?Ym5EQkgzSmVjQldVNFluc0ZkaEpRYk5OVjI1RFRaMHBqU3RkRnZvUElSOG42?=
 =?utf-8?B?Yk5KMC9uZHM3WXRlcWJoc1dLQ0oxYU53bzYvcHhIVWt4ejRQck5XellSNnBi?=
 =?utf-8?B?THQ1SWtOM3dpbDBNSDNhUFkyMkVCQkF3WHBHcGIvQ0VxWCtoTjlnZTdMV2dB?=
 =?utf-8?B?bUdsbGEvVWU0T1hZMjczMml6UnY5Y0JlV2h6VHJDUG5SZllVZ2NQdUpIOXl3?=
 =?utf-8?B?SFhjb3piamkraklBWHVSWW5PdDhMdjdPRWRaSjNER3NZY085SDEyUG9LSnN4?=
 =?utf-8?B?emc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51EC89E559359A42A3CFEFF5B8575430@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6aad173-1d51-4717-51e1-08db6e82c8d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 16:00:19.6983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7eJebylubOtMiPhgXFTAuv50fnd6CdnT2+4jN/Riy0Ni5nDFvnhJJjBAQ8aKFtYDVWrcAdOF18WXjFDglsQ2HzQUVKIAcpSArlvkoHWoAy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4930
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gRnJpLCAyMDIzLTA2LTE2IGF0IDExOjUwICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+
IMKgdm9pZCAqbW9kdWxlX2FsbG9jKHVuc2lnbmVkIGxvbmcgc2l6ZSkKPiDCoHsKPiAtwqDCoMKg
wqDCoMKgwqBpZiAoc2l6ZSA9PSAwKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
ZXR1cm4gTlVMTDsKPiAtwqDCoMKgwqDCoMKgwqByZXR1cm4ga21hbGxvYyhzaXplLCBHRlBfS0VS
TkVMKTsKPiAtfQo+IC0KPiAtLyogRnJlZSBtZW1vcnkgcmV0dXJuZWQgZnJvbSBtb2R1bGVfYWxs
b2MgKi8KPiAtdm9pZCBtb2R1bGVfbWVtZnJlZSh2b2lkICptb2R1bGVfcmVnaW9uKQo+IC17Cj4g
LcKgwqDCoMKgwqDCoMKga2ZyZWUobW9kdWxlX3JlZ2lvbik7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0
dXJuIF9fdm1hbGxvY19ub2RlX3JhbmdlKHNpemUsIDEsIE1PRFVMRVNfVkFERFIsCj4gTU9EVUxF
U19FTkQsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIEdGUF9LRVJORUwsIFBBR0VfS0VSTkVMX0VYRUMsCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIFZNX0ZMVVNIX1JFU0VUX1BFUk1TLAo+IE5VTUFfTk9fTk9ERSwKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgX19idWlsdGluX3JldHVybl9hZGRyZXNzKDApKTsKPiDCoH0KPiDCoAo+IMKgaW50IGFw
cGx5X3JlbG9jYXRlX2FkZChFbGYzMl9TaGRyICpzZWNoZHJzLCBjb25zdCBjaGFyICpzCgpJIHdv
bmRlciBpZiB0aGUgKHNpemUgPT0gMCkgY2hlY2sgaXMgcmVhbGx5IG5lZWRlZCwgYnV0Cl9fdm1h
bGxvY19ub2RlX3JhbmdlKCkgd2lsbCBXQVJOIG9uIHRoaXMgY2FzZSB3aGVyZSB0aGUgb2xkIGNv
ZGUgd29uJ3QuCg==

