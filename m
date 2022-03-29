Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A09C4EB378
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 20:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiC2Slj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 14:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240150AbiC2Slh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 14:41:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE46B95A03;
        Tue, 29 Mar 2022 11:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648579193; x=1680115193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3331OhGVhQInwhgNK6UQ0GRBfVtE39JBWw4AP0nYtwI=;
  b=d1xStKpGxgVO0FEHlnuynnWhxxNYJ9XEbgV1NqeB8k78CUsb+jzw9bts
   Zd6cIzxGBav89DV4fCW2K6EYpmDJuYexFkNhJnMvJAtBea/HnUO3CRfyK
   bq349hkmUqjOuXd65kiGHQc5Os8iixeIi5vZuJtQ8ueOOR+I8sumGi7tF
   2B1V9Cpic8VbaL22RYKOr57LwAEsj9JzW7IHX3np9WXHuaKigl063OFKz
   ZKXVChh3bQaa535y2m5iVsmGLo4onZbpS+iT/TluDaDGTBHPOd9sG4YwF
   +axSeVYDmtMDENqHCie2oPsXepk+RfjfdP7f3jSJJuzhyi3o+clBg4FP/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="241489868"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="241489868"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 11:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="787706698"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 29 Mar 2022 11:39:52 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 29 Mar 2022 11:39:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 29 Mar 2022 11:39:51 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 29 Mar 2022 11:39:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=je9Phs16O2szW1NSphllG0vexOaWoZ9E8/ApIUifLz2o/7H98wepTbfjDhGcykzXbBnw76QvXhVZLc8NaOeeMGapNu4/QXJP4wjaC6E8988IKkMe6fNQYlUKvTCISjrtTguMVaPsGnbpFQfzZ/ekSpiq960lt/H5LrRLTg67ufZ7TpbyXt6rigWL+JNX1eVt0N+u0YH+0ihBd4uoFB0bhdcyTDeI22OoHr5lAIM2d6jtZILqqJrDIF9qGXkFHFLvIrQwjYCgoZVdJj4qqQbWjOOdiJBGchEh2WknMX5QeBwl95kiEAE3gvsIqng8jKP3zeDtpCM11TuotMnnsEmo5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3331OhGVhQInwhgNK6UQ0GRBfVtE39JBWw4AP0nYtwI=;
 b=VXe+5MtmrVa3Xlvf1E0+/IM8ZFm/QTVZX1qcI124P3pNwDY3+b6y0OsJvBpFHhw6tiPXY07KMgB6S5F8p7kOy49nJJb9v17yv+9kjjd6YEOXrcitXdITEDOHU95Kl+mcta5j2KLlPLyUTKeWybfpg7xFMPziUoqfBCVOV+LXCJXwdLRj8QyGXJEqxHwzir3VDSpURMKGnLcwC/WsceLWnPgaDg3QlgXM6+uJQzUECoGk0ivgTkKt7ZZ9l4Be1DUNHnAiO0pAH2G8j3RduleFWW9PUOy6A113EB5EYG3tnl6Oe+s9KGSC7ZcyOEdfvfC9bOjKXC+0zCTxNOFKQtojng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by BN7PR11MB2723.namprd11.prod.outlook.com (2603:10b6:406:b9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Tue, 29 Mar
 2022 18:39:49 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b%3]) with mapi id 15.20.5102.022; Tue, 29 Mar 2022
 18:39:49 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "songliubraving@fb.com" <songliubraving@fb.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>,
        "song@kernel.org" <song@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "urezki@gmail.com" <urezki@gmail.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>
Subject: Re: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Topic: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Index: AQHYQHSY+pR621m40EmnNhTft3vXEqzQydiAgASr5YCAAA5JgIAAh7uAgACsEQA=
Date:   Tue, 29 Mar 2022 18:39:49 +0000
Message-ID: <3ecfbf80feff3487cbb26b492375cef5a5fe8ac4.camel@intel.com>
References: <20220204185742.271030-1-song@kernel.org>
         <20220204185742.271030-2-song@kernel.org>
         <5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com>
         <F079AC10-2677-41B4-A4D5-F07BDE512BE1@fb.com>
         <ee754770889c7b6de13d8e4835c7bd8b15d5e538.camel@intel.com>
         <6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com>
In-Reply-To: <6080EC28-E3FE-4B00-B94A-ED7EBA1F55ED@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 085523db-fbe0-459a-2cf8-08da11b3816f
x-ms-traffictypediagnostic: BN7PR11MB2723:EE_
x-microsoft-antispam-prvs: <BN7PR11MB27239E99D31CD8CE5F3E681AC91E9@BN7PR11MB2723.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wAS1PwzQobRfBlCfQKKxNITtoi0/9IVVrUPYq4eABLOVojPTdRJ3qo7HH/SsJd4RNDwbVR528etIgmKeHn4cRBH1cywzMoFebcSyqQI8Dh67nyxarBGsu8S1Y718krUpE4ENOgMObhlxtKKAyfJ/j5dJXldyThwpWeE7toxzvzeuoJ6CwCxfRwNYzZB4zLKklqYNkrnaDYg+PII8plOKXKQJp2KPQI/EZmvY5NUbvTSP6zO/ajL2m0oQrUVUZfne/iV9TjWcosOGtzP3jpFYQE1RZVdjLBBozgzJV1od8Fg3+4N7GYY/RFTtglGrEYhAOzrrWjkzSdJ3YdGQkMgWvzvwDJFazTwCl236L1cIt0Dy0M8DhAFny0IteYGIkWy2mLuKza+yUwqWZemv54vAYXje9U3ZC3gpUlsS2z1N4seBEZldM7/Wj+pcWd6aIe7TC/jvUdsNErCQwqLmB3oenCqpoufGffugXx3nvYdnavIOZwHzX1KKIw4kZtwylccGgEEoscBvVjgGPzlzwAQZpnBF+RVCByuUyAcsjIyesLtFtEHoMUS+CesJbGQP+XaOn9h62wY00bTNC2LyYPZvTGgUdjSuyBtxTadFwMDesP/lAB7n26U1y2PVAXH4kaG4gLzRPmOW46Cdo9n8wAb2e++YNlvnHPNYIlCUJTZZ8ntqzYlZxlvLWcfpkwHqxLsdEqNcaeGKkjLlIIvkTll/qZtmxHWcUTeaQ9phTtnJ+5m/ZRM8ArTi3wIbSE1pLemNBg5LosBj6fZnP/oFjUV3HIZo6OJ54lYmCj3LuWbidJT+u+KIADt6AFzaJTIidQm6yzD+WLVqNxUzfhFquXHgXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(66476007)(86362001)(26005)(186003)(38100700002)(6486002)(38070700005)(508600001)(66446008)(66556008)(54906003)(6506007)(966005)(66946007)(82960400001)(8676002)(76116006)(122000001)(4326008)(64756008)(6512007)(6916009)(2616005)(316002)(7416002)(2906002)(36756003)(83380400001)(53546011)(8936002)(5660300002)(99106002)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akNER3ZIbHNFREZxT1VxTWo3VnZuVjBJZDZYZTRYekhVK1B3dXdza0VGbjEz?=
 =?utf-8?B?STh6cEp5RVRjVzVOb3dMWTNTeFhNOEhCVDl1S3NXaTVMZzlNS0xpbFJ5bitF?=
 =?utf-8?B?TTZnU3lRNmlZMkNlR2hubVZscC9hQlBNZ1VaV2o2czhhd21jZXE3QjR4NFA2?=
 =?utf-8?B?MzAvbGdWSDZSeDNKblI0UVBqbGNzWjdtRXBJRTFDZ05lU1MzQm1rUjBKeUph?=
 =?utf-8?B?MDNUSDNZR0ptRGt1VDd2aFJ3c0dtb3dxaUp3N3Z2dTU0NkM3Y2JHYlVJTWMz?=
 =?utf-8?B?YU41bW5sVHJjdXc4RmxndHhlRDZ1T21mdC9yWHJEdWtuQkVtRTJUZS9TT0NP?=
 =?utf-8?B?VEQ4QVFGSWFhS3RKNFNQYWlJTnJpbXFJemgwYkFRbDJuUWI5QWZleW5QMUM4?=
 =?utf-8?B?T2tPZStwUlVYVGtjMUZFOUNxb2kvalFMVU4vS1VFcHpIcUQ2WkFvUWJySXRa?=
 =?utf-8?B?T2djWU1qZ2ZTZFFDRWdDZW43K1p3ZVdhZkx6WVU4VTVlZVl2QzhRL0U4dFlt?=
 =?utf-8?B?dnVYVGgxdTVTQjQralFPT1hMSllVSGFYY2lpNCtjKzdQbEw5RkVXYW5EdSt6?=
 =?utf-8?B?YVJIZkI5TWQ2OGpEa0YrL2hDWGh5UzdKZldTZWdrdnhFUjZrRDNqNVRKcDgx?=
 =?utf-8?B?cEpGOENHVEdRckxrS2xLNHNHMmw5b2x4aTk1QW1RZm8xZzEwVmtpc01nblhk?=
 =?utf-8?B?OHpJem4wMktDREMyeEVHcHNxNGhNNlRNeDVJM28rUk5pMWZtcCtkenVyU0RD?=
 =?utf-8?B?dXJTOVZQZGc3T0s4UFZFMTh2Zm1SQXNtdmJ4M2xFYXFuSyt2ZWJsZG9KbTRC?=
 =?utf-8?B?MGtJNit2VXBTYmFBRlptaXU1SEpmMHZDTDBUd1hzSVBhelAvVWRxRkgzeVBL?=
 =?utf-8?B?K3N5UEw5UElFR2tzUFdQUU0xRlBFTk5NNkJXMXhnSzZNekdKakNVWHd0cFhk?=
 =?utf-8?B?NWxidHROa0FZSGg5VmJXek9qenMzSWhQaEZnVWw4a2hmL2hoemNvaGpOZzF5?=
 =?utf-8?B?TG93OXRmZEtQUDgzR05uSmozdjgrb0xISzBrRCtSOFp1LytYRWM5OTFxY3o0?=
 =?utf-8?B?MmZKMEJtdHdzUHlXQlBGd3VHUUw4YmM5ZXlWemF1ZkFwZmxEaU10TW5FM3ZS?=
 =?utf-8?B?cW1jMFNXSVlsZmRpcDdDSy93NThhV09sbW5OR0lva2VwZVFVSk1Jc1E5TXlP?=
 =?utf-8?B?VWRUb09la01GWWpCTU9zU01WZ1hraHcwbERMcVlRbGRwTkF6cVhsYi80ZjhQ?=
 =?utf-8?B?QUJHQllOYStuQTRmQSt1Q1gzVXFqcWR1cEVGS2tjZFBMZWptbjVSYnRuT1ZW?=
 =?utf-8?B?QVlvcTB6Z2Evcm5XcWU0VEVlbW5rQVNxQ3FvWERZcUZad1lQOWlvRk5WODZR?=
 =?utf-8?B?Q1FTZTB4L1RoT0RaTE1NempTelpzSllaUDhScXFRSVZSR2hvejIybVQySXIw?=
 =?utf-8?B?ampwWGZ1VEtTUlhiOUN5VGRXN0dubFJXc3hzNW16Y1oxZGtDVCtKUFo1VFUx?=
 =?utf-8?B?bkh3Yld3c21jclc0TnFTSVlOQ0o2U0lEWklFZGpOUkgram1zbkdJV1hTK0Ev?=
 =?utf-8?B?ejV4VkMyYXVVdzBYb0ErMWwxeCtONHhpRndUc0oydjJGWG5ycmowRUZrRXp6?=
 =?utf-8?B?RENrRk8rRzFXaGhLQVdpc0pvemc2MDF4Ukl2cStVbzdadWJvQTlrREptT0p6?=
 =?utf-8?B?aWR1VUpJRTJZWXYrbmxWOW9zUjI4UlhvSm5RWEg5V0R0VEtwUHpNc3lVcFM4?=
 =?utf-8?B?ZG5sZ3NGNDFEUENaS1FqVFhaSnpYdVJhSERwVlF3M21aM1BMRUR6YUh3M3c1?=
 =?utf-8?B?SDhBaGRFeFNiMFE3TlRiSjlGNlI1MTBWQzFTNWRpSG1hTDAvdVdhd3E3ZHR1?=
 =?utf-8?B?OTNTSUs5Vm1aNG1EZWorNkQzbDhMUERYdzAvbm5CczdmMDluUkM5S2o0dkgx?=
 =?utf-8?B?VFRvcUg3Smhvc3VBNmN6WTAwU29OVXdac2piNCs0d2xQOXQ3YytCVmx5cFBx?=
 =?utf-8?B?VCtuM2p5YUZpRmdCMzRJRlJUTDNHc3Ivbi9yNGxpcStTUG14cDE3RzJlM2xR?=
 =?utf-8?B?d3VOQnVsZnBnWGd5OEtKaTlhcGZvT2Q3Z0dFWERuRGpEQm5SeEpMSU1YUW5S?=
 =?utf-8?B?dXFLTysxN0IxckZKMkFlQXlyVjNxemtMczlMUU1kY01MOTBRaVBVQzh4RHk1?=
 =?utf-8?B?L0dJY0pOMnFQSk1Fb3Z6bnVRSVYvR1psRENiVjRIVWkyR2xKNDNOWS8vd2N3?=
 =?utf-8?B?S0ErTHJxQ25uMG9SbWVmVzhjam1JT0ZvQ1F5WGJWakxidmR3cEF6cGdXUGZs?=
 =?utf-8?B?MjVRZytCeVdUdE8rcmtyZHk4SGIvWENDUlpjVWlmVFcra2FUeWl3ZFArV0hB?=
 =?utf-8?Q?WixVQkUGKWauBvyvPtkX56EBjo9v/eRWBr+lD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <288F368081555543B2FFD161698540E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085523db-fbe0-459a-2cf8-08da11b3816f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 18:39:49.3774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBtytvoPojcmBrieF8GUNokRntjVKrPIbfG5LENAjqJhcsZLVURCP1F2FENeLLm0xGq4AcRjfN1eTZv3V/1TA9dTvqFq85f+oQI/ccsIRWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2723
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q0Mgc29tZSB2bWFsbG9jIGZvbGtzLiBXaGF0IGhhcHBlbmVkIHdhcyB2bWFsbG9jIGh1Z2UgcGFn
ZXMgd2FzIHR1cm5lZA0Kb24gZm9yIHg4NiB3aXRoIHRoZSByZXN0IG9mIHRoZSBrZXJuZWwgdW5w
cmVwYXJlZCBhbmQgcHJvYmxlbXMgaGF2ZQ0KcG9wcGVkIHVwLiBXZSBhcmUgZGlzY3Vzc2luZyBh
IHBvc3NpYmxlIG5ldyBjb25maWcgYW5kIHZtYXAgZmxhZyBzdWNoDQp0aGF0IGZvciBzb21lIGFy
Y2gncywgaHVnZSBwYWdlcyB3b3VsZCBvbmx5IGJlIHVzZWQgZm9yIGNlcnRhaW4NCmFsbG9jYXRp
b25zIHN1Y2ggYXMgQlBGJ3MuDQoNClRocmVhZDoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC82MDgwRUMyOC1FM0ZFLTRCMDAtQjk0QS1FRDdFQkExRjU1RURAZmIuY29tLw0KDQpPbiBU
dWUsIDIwMjItMDMtMjkgYXQgMDg6MjMgKzAwMDAsIFNvbmcgTGl1IHdyb3RlOg0KPiA+IE9uIE1h
ciAyOCwgMjAyMiwgYXQgNToxOCBQTSwgRWRnZWNvbWJlLCBSaWNrIFAgPA0KPiA+IHJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBNb24sIDIwMjItMDMtMjgg
YXQgMjM6MjcgKzAwMDAsIFNvbmcgTGl1IHdyb3RlOg0KPiA+ID4gSSBsaWtlIHRoaXMgZGlyZWN0
aW9uLiBCdXQgSSBhbSBhZnJhaWQgdGhpcyBpcyBub3QgZW5vdWdoLiBVc2luZw0KPiA+ID4gVk1f
Tk9fSFVHRV9WTUFQIGluIG1vZHVsZV9hbGxvYygpIHdpbGwgbWFrZSBzdXJlIHdlIGRvbid0DQo+
ID4gPiBhbGxvY2F0ZSANCj4gPiA+IGh1Z2UgcGFnZXMgZm9yIG1vZHVsZXMuIEJ1dCBvdGhlciB1
c2VycyBvZg0KPiA+ID4gX192bWFsbG9jX25vZGVfcmFuZ2UoKSwgDQo+ID4gPiBzdWNoIGFzIHZ6
YWxsb2MgaW4gUGF1bCdzIHJlcG9ydCwgbWF5IHN0aWxsIGhpdCB0aGUgaXNzdWUuIA0KPiA+ID4g
DQo+ID4gPiBNYXliZSB3ZSBuZWVkIGFub3RoZXIgZmxhZyBWTV9GT1JDRV9IVUdFX1ZNQVAgdGhh
dCBieXBhc3NlcyANCj4gPiA+IHZtYXBfYWxsb3dfaHVnZSBjaGVjay4gU29tZXRoaW5nIGxpa2Ug
dGhlIGRpZmYgYmVsb3cuDQo+ID4gPiANCj4gPiA+IFdvdWxkIHRoaXMgd29yaz8NCj4gPiANCj4g
PiBZZWEsIHRoYXQgbG9va3MgbGlrZSBhIHNhZmVyIGRpcmVjdGlvbi4gSXQncyB0b28gYmFkIHdl
IGNhbid0IGhhdmUNCj4gPiBhdXRvbWF0aWMgbGFyZ2UgcGFnZXMsIGJ1dCBpdCBkb2Vzbid0IHNl
ZW0gcmVhZHkgdG8ganVzdCB0dXJuIG9uDQo+ID4gZm9yDQo+ID4gdGhlIHdob2xlIHg4NiBrZXJu
ZWwuDQo+ID4gDQo+ID4gSSdtIG5vdCBzdXJlIGFib3V0IHRoaXMgaW1wbGVtZW50YXRpb24gdGhv
dWdoLiBJdCB3b3VsZCBsZXQgbGFyZ2UNCj4gPiBwYWdlcw0KPiA+IGdldCBlbmFibGVkIHdpdGhv
dXQgSEFWRV9BUkNIX0hVR0VfVk1BTExPQyBhbmQgYWxzbyBkZXNwaXRlIHRoZQ0KPiA+IGRpc2Fi
bGUNCj4gPiBrZXJuZWwgcGFyYW1ldGVyLg0KPiA+IA0KPiA+IEFwcGFyZW50bHkgc29tZSBhcmNo
aXRlY3R1cmVzIGNhbiBoYW5kbGUgbGFyZ2UgcGFnZXMgYXV0b21hdGljYWxseQ0KPiA+IGFuZA0K
PiA+IGl0IGhhcyBiZW5lZml0cyBmb3IgdGhlbSwgc28gbWF5YmUgdm1hbGxvYyBzaG91bGQgc3Vw
cG9ydCBib3RoDQo+ID4gYmVoYXZpb3JzIGJhc2VkIG9uIGNvbmZpZy4gTGlrZSB0aGVyZSBzaG91
bGQgYQ0KPiA+IEFSQ0hfSFVHRV9WTUFMTE9DX1JFUVVJUkVfRkxBRyBjb25maWcuIElmIGNvbmZp
Z3VyZWQgaXQgcmVxdWlyZXMNCj4gPiBWTV9IVUdFX1ZNQVAgKG9yIHNvbWUgbmFtZSkuIEkgZG9u
J3QgdGhpbmsgRk9SQ0UgZml0cywgYmVjYXVzZSB0aGUNCj4gPiBjdXJyZW50IGxvZ2ljIHdvdWxk
IG5vdCBhbHdheXMgZ2l2ZSBodWdlIHBhZ2VzLg0KPiA+IA0KPiA+IEJ1dCB5ZWEsIHNlZW1zIHJp
c2t5IHRvIGxlYXZlIGl0IG9uIGdlbmVyYWxseSwgZXZlbiBpZiB5b3UgY291bGQNCj4gPiBmaXgN
Cj4gPiBQYXVsJ3Mgc3BlY2lmaWMgaXNzdWUuDQo+ID4gDQo+IA0KPiANCj4gSG93IGFib3V0IHNv
bWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmc/IChJIHN0aWxsIG5lZWQgdG8gZml4DQo+IHNvbWV0
aGluZywgYnV0DQo+IHdvdWxkIGxpa2Ugc29tZSBmZWVkYmFja3Mgb24gdGhlIEFQSSkuDQo+IA0K
PiBUaGFua3MsDQo+IFNvbmcNCj4gDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9LY29uZmlnIGIv
YXJjaC9LY29uZmlnDQo+IGluZGV4IDg0YmMxZGUwMjcyMC4uZGVmZWY1MGZmNTI3IDEwMDY0NA0K
PiAtLS0gYS9hcmNoL0tjb25maWcNCj4gKysrIGIvYXJjaC9LY29uZmlnDQo+IEBAIC04NTgsNiAr
ODU4LDE1IEBAIGNvbmZpZyBIQVZFX0FSQ0hfSFVHRV9WTUFMTE9DDQo+ICAJZGVwZW5kcyBvbiBI
QVZFX0FSQ0hfSFVHRV9WTUFQDQo+ICAJYm9vbA0KPiAgDQo+ICsjDQo+ICsjIEhBVkVfQVJDSF9I
VUdFX1ZNQUxMT0NfRkxBRyBhbGxvd3MgdXNlcnMgb2YgX192bWFsbG9jX25vZGVfcmFuZ2UNCj4g
dG8gYWxsb2NhdGUNCj4gKyMgaHVnZSBwYWdlIHdpdGhvdXQgSEFWRV9BUkNIX0hVR0VfVk1BTExP
Qy4gVG8gYWxsb2NhdGUgaHVnZSBwYWdlcywsDQo+IHRoZSB1c2VyDQo+ICsjIG5lZWQgdG8gY2Fs
bCBfX3ZtYWxsb2Nfbm9kZV9yYW5nZSB3aXRoIFZNX1BSRUZFUl9IVUdFX1ZNQVAuDQo+ICsjDQo+
ICtjb25maWcgSEFWRV9BUkNIX0hVR0VfVk1BTExPQ19GTEFHDQo+ICsJZGVwZW5kcyBvbiBIQVZF
X0FSQ0hfSFVHRV9WTUFQDQo+ICsJYm9vbA0KPiArDQo+ICBjb25maWcgQVJDSF9XQU5UX0hVR0Vf
UE1EX1NIQVJFDQo+ICAJYm9vbA0KPiAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9LY29uZmln
IGIvYXJjaC94ODYvS2NvbmZpZw0KPiBpbmRleCA3MzQwZDlmMDFiNjIuLmU2NGYwMDQxNTU3NSAx
MDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvS2NvbmZpZw0KPiArKysgYi9hcmNoL3g4Ni9LY29uZmln
DQo+IEBAIC0xNjEsNyArMTYxLDcgQEAgY29uZmlnIFg4Ng0KPiAgCXNlbGVjdCBIQVZFX0FMSUdO
RURfU1RSVUNUX1BBR0UJCWlmIFNMVUINCj4gIAlzZWxlY3QgSEFWRV9BUkNIX0FVRElUU1lTQ0FM
TA0KPiAgCXNlbGVjdCBIQVZFX0FSQ0hfSFVHRV9WTUFQCQlpZiBYODZfNjQgfHwgWDg2X1BBRQ0K
PiAtCXNlbGVjdCBIQVZFX0FSQ0hfSFVHRV9WTUFMTE9DCQlpZiBYODZfNjQNCj4gKwlzZWxlY3Qg
SEFWRV9BUkNIX0hVR0VfVk1BTExPQ19GTEFHCWlmIFg4Nl82NA0KPiAgCXNlbGVjdCBIQVZFX0FS
Q0hfSlVNUF9MQUJFTA0KPiAgCXNlbGVjdCBIQVZFX0FSQ0hfSlVNUF9MQUJFTF9SRUxBVElWRQ0K
PiAgCXNlbGVjdCBIQVZFX0FSQ0hfS0FTQU4JCQlpZiBYODZfNjQNCj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvdm1hbGxvYy5oIGIvaW5jbHVkZS9saW51eC92bWFsbG9jLmgNCj4gaW5kZXgg
M2IxZGY3ZGE0MDJkLi45OGY4YTkzZmNmZDQgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgv
dm1hbGxvYy5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvdm1hbGxvYy5oDQo+IEBAIC0zNSw2ICsz
NSwxMSBAQCBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2s7CQkvKiBpbg0KPiBub3RpZmllci5oICovDQo+
ICAjZGVmaW5lIFZNX0RFRkVSX0tNRU1MRUFLCTANCj4gICNlbmRpZg0KPiAgDQo+ICsjaWZkZWYg
Q09ORklHX0hBVkVfQVJDSF9IVUdFX1ZNQUxMT0NfRkxBRw0KPiArI2RlZmluZSBWTV9QUkVGRVJf
SFVHRV9WTUFQCTB4MDAwMDEwMDAJLyogcHJlZmVyIFBNRF9TSVpFDQo+IG1hcHBpbmcgKGJ5cGFz
cyB2bWFwX2FsbG93X2h1Z2UgY2hlY2spICovDQoNCkkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIHRp
ZSB0aGlzIHRvIHZtYXBfYWxsb3dfaHVnZSBieSBkZWZpbml0aW9uLg0KQWxzbywgd2hhdCBpdCBk
b2VzIGlzIHRyeSAyTUIgcGFnZXMgZm9yIGFsbG9jYXRpb25zIGxhcmdlciB0aGFuIDJNQi4NCkZv
ciBzbWFsbGVyIGFsbG9jYXRpb25zIGl0IGRvZXNuJ3QgdHJ5IG9yICJwcmVmZXIiIHRoZW0uDQoN
Cj4gKyNlbHNlDQo+ICsjZGVmaW5lIFZNX1BSRUZFUl9IVUdFX1ZNQVAJMA0KPiArI2VuZGlmDQo+
ICAvKiBiaXRzIFsyMC4uMzJdIHJlc2VydmVkIGZvciBhcmNoIHNwZWNpZmljIGlvcmVtYXAgaW50
ZXJuYWxzICovDQo+ICANCj4gIC8qDQo+IEBAIC01MSw3ICs1Niw3IEBAIHN0cnVjdCB2bV9zdHJ1
Y3Qgew0KPiAgCXVuc2lnbmVkIGxvbmcJCXNpemU7DQo+ICAJdW5zaWduZWQgbG9uZwkJZmxhZ3M7
DQo+ICAJc3RydWN0IHBhZ2UJCSoqcGFnZXM7DQo+IC0jaWZkZWYgQ09ORklHX0hBVkVfQVJDSF9I
VUdFX1ZNQUxMT0MNCj4gKyNpZiAoZGVmaW5lZChDT05GSUdfSEFWRV9BUkNIX0hVR0VfVk1BTExP
QykgfHwNCj4gZGVmaW5lZChDT05GSUdfSEFWRV9BUkNIX0hVR0VfVk1BTExPQ19GTEFHKSkNCj4g
IAl1bnNpZ25lZCBpbnQJCXBhZ2Vfb3JkZXI7DQo+ICAjZW5kaWYNCj4gIAl1bnNpZ25lZCBpbnQJ
CW5yX3BhZ2VzOw0KPiBAQCAtMjI1LDcgKzIzMCw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpc192
bV9hcmVhX2h1Z2VwYWdlcyhjb25zdA0KPiB2b2lkICphZGRyKQ0KPiAgCSAqIHByZXZlbnRzIHRo
YXQuIFRoaXMgb25seSBpbmRpY2F0ZXMgdGhlIHNpemUgb2YgdGhlIHBoeXNpY2FsDQo+IHBhZ2UN
Cj4gIAkgKiBhbGxvY2F0ZWQgaW4gdGhlIHZtYWxsb2MgbGF5ZXIuDQo+ICAJICovDQo+IC0jaWZk
ZWYgQ09ORklHX0hBVkVfQVJDSF9IVUdFX1ZNQUxMT0MNCj4gKyNpZiAoZGVmaW5lZChDT05GSUdf
SEFWRV9BUkNIX0hVR0VfVk1BTExPQykgfHwNCj4gZGVmaW5lZChDT05GSUdfSEFWRV9BUkNIX0hV
R0VfVk1BTExPQ19GTEFHKSkNCj4gIAlyZXR1cm4gZmluZF92bV9hcmVhKGFkZHIpLT5wYWdlX29y
ZGVyID4gMDsNCj4gICNlbHNlDQo+ICAJcmV0dXJuIGZhbHNlOw0KPiBkaWZmIC0tZ2l0IGEva2Vy
bmVsL2JwZi9jb3JlLmMgYi9rZXJuZWwvYnBmL2NvcmUuYw0KPiBpbmRleCAxM2U5ZGJlZWVkZjMu
LmZjOWRhZTA5NTA3OSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9jb3JlLmMNCj4gKysrIGIv
a2VybmVsL2JwZi9jb3JlLmMNCj4gQEAgLTg1MSwxMyArODUxLDI4IEBAIHN0YXRpYyBMSVNUX0hF
QUQocGFja19saXN0KTsNCj4gICNkZWZpbmUgQlBGX0hQQUdFX01BU0sgUEFHRV9NQVNLDQo+ICAj
ZW5kaWYNCj4gIA0KPiArc3RhdGljIHZvaWQgKmJwZl9wcm9nX3BhY2tfdm1hbGxvYyh1bnNpZ25l
ZCBsb25nIHNpemUpDQo+ICt7DQo+ICsjaWYgZGVmaW5lZChNT0RVTEVTX1ZBRERSKQ0KPiArCXVu
c2lnbmVkIGxvbmcgc3RhcnQgPSBNT0RVTEVTX1ZBRERSOw0KPiArCXVuc2lnbmVkIGxvbmcgZW5k
ID0gTU9EVUxFU19FTkQ7DQo+ICsjZWxzZQ0KPiArCXVuc2lnbmVkIGxvbmcgc3RhcnQgPSBWTUFM
TE9DX1NUQVJUOw0KPiArCXVuc2lnbmVkIGxvbmcgZW5kID0gVk1BTExPQ19FTkQ7DQo+ICsjZW5k
aWYNCj4gKw0KPiArCXJldHVybiBfX3ZtYWxsb2Nfbm9kZV9yYW5nZShzaXplLCBQQUdFX1NJWkUs
IHN0YXJ0LCBlbmQsDQo+IEdGUF9LRVJORUwsIFBBR0VfS0VSTkVMLA0KPiArCQkJCSAgICBWTV9E
RUZFUl9LTUVNTEVBSyB8DQo+IFZNX1BSRUZFUl9IVUdFX1ZNQVAsDQo+ICsJCQkJICAgIE5VTUFf
Tk9fTk9ERSwNCj4gX19idWlsdGluX3JldHVybl9hZGRyZXNzKDApKTsNCj4gK30NCj4gKw0KPiAg
c3RhdGljIHNpemVfdCBzZWxlY3RfYnBmX3Byb2dfcGFja19zaXplKHZvaWQpDQo+ICB7DQo+ICAJ
c2l6ZV90IHNpemU7DQo+ICAJdm9pZCAqcHRyOw0KPiAgDQo+ICAJc2l6ZSA9IEJQRl9IUEFHRV9T
SVpFICogbnVtX29ubGluZV9ub2RlcygpOw0KPiAtCXB0ciA9IG1vZHVsZV9hbGxvYyhzaXplKTsN
Cj4gKwlwdHIgPSBicGZfcHJvZ19wYWNrX3ZtYWxsb2Moc2l6ZSk7DQo+ICANCj4gIAkvKiBUZXN0
IHdoZXRoZXIgd2UgY2FuIGdldCBodWdlIHBhZ2VzLiBJZiBub3QganVzdCB1c2UNCj4gUEFHRV9T
SVpFDQo+ICAJICogcGFja3MuDQo+IEBAIC04ODEsNyArODk2LDcgQEAgc3RhdGljIHN0cnVjdCBi
cGZfcHJvZ19wYWNrICphbGxvY19uZXdfcGFjayh2b2lkKQ0KPiAgCQkgICAgICAgR0ZQX0tFUk5F
TCk7DQo+ICAJaWYgKCFwYWNrKQ0KPiAgCQlyZXR1cm4gTlVMTDsNCj4gLQlwYWNrLT5wdHIgPSBt
b2R1bGVfYWxsb2MoYnBmX3Byb2dfcGFja19zaXplKTsNCj4gKwlwYWNrLT5wdHIgPSBicGZfcHJv
Z19wYWNrX3ZtYWxsb2MoYnBmX3Byb2dfcGFja19zaXplKTsNCj4gIAlpZiAoIXBhY2stPnB0cikg
ew0KPiAgCQlrZnJlZShwYWNrKTsNCj4gIAkJcmV0dXJuIE5VTEw7DQo+IGRpZmYgLS1naXQgYS9t
bS92bWFsbG9jLmMgYi9tbS92bWFsbG9jLmMNCj4gaW5kZXggZTE2MzM3MmQzOTY3Li45ZDNjMWFi
OGJkZjEgMTAwNjQ0DQo+IC0tLSBhL21tL3ZtYWxsb2MuYw0KPiArKysgYi9tbS92bWFsbG9jLmMN
Cj4gQEAgLTIyNjEsNyArMjI2MSw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50DQo+IHZt
X2FyZWFfcGFnZV9vcmRlcihzdHJ1Y3Qgdm1fc3RydWN0ICp2bSkNCj4gIA0KPiAgc3RhdGljIGlu
bGluZSB2b2lkIHNldF92bV9hcmVhX3BhZ2Vfb3JkZXIoc3RydWN0IHZtX3N0cnVjdCAqdm0sDQo+
IHVuc2lnbmVkIGludCBvcmRlcikNCj4gIHsNCj4gLSNpZmRlZiBDT05GSUdfSEFWRV9BUkNIX0hV
R0VfVk1BTExPQw0KPiArI2lmIChkZWZpbmVkKENPTkZJR19IQVZFX0FSQ0hfSFVHRV9WTUFMTE9D
KSB8fA0KPiBkZWZpbmVkKENPTkZJR19IQVZFX0FSQ0hfSFVHRV9WTUFMTE9DX0ZMQUcpKQ0KPiAg
CXZtLT5wYWdlX29yZGVyID0gb3JkZXI7DQo+ICAjZWxzZQ0KPiAgCUJVR19PTihvcmRlciAhPSAw
KTsNCj4gQEAgLTMxMDYsNyArMzEwNiw4IEBAIHZvaWQgKl9fdm1hbGxvY19ub2RlX3JhbmdlKHVu
c2lnbmVkIGxvbmcgc2l6ZSwNCj4gdW5zaWduZWQgbG9uZyBhbGlnbiwNCj4gIAkJcmV0dXJuIE5V
TEw7DQo+ICAJfQ0KPiAgDQo+IC0JaWYgKHZtYXBfYWxsb3dfaHVnZSAmJiAhKHZtX2ZsYWdzICYg
Vk1fTk9fSFVHRV9WTUFQKSkgew0KPiArCWlmICgodm1hcF9hbGxvd19odWdlICYmICEodm1fZmxh
Z3MgJiBWTV9OT19IVUdFX1ZNQVApKSB8fA0KPiArCSAgICAoSVNfRU5BQkxFRChDT05GSUdfSEFW
RV9BUkNIX0hVR0VfVk1BTExPQ19GTEFHKSAmJg0KPiAodm1fZmxhZ3MgJiBWTV9QUkVGRVJfSFVH
RV9WTUFQKSkpIHsNCg0Kdm1hcF9hbGxvd19odWdlIGlzIGhvdyB0aGUga2VybmVsIHBhcmFtZXRl
ciB0aGF0IGNhbiBkaXNhYmxlIHZtYWxsb2MNCmh1Z2UgcGFnZXMgd29ya3MuIEkgZG9uJ3QgdGhp
bmsgd2Ugc2hvdWxkIHNlcGFyYXRlIGl0LiBEaXNhYmxpbmcNCnZtYWxsb2MgaHVnZSBwYWdlcyBz
aG91bGQgc3RpbGwgZGlzYWJsZSB0aGlzIGFsdGVybmF0ZSBtb2RlLg0KDQo+ICAJCXVuc2lnbmVk
IGxvbmcgc2l6ZV9wZXJfbm9kZTsNCj4gIA0KPiAgCQkvKg0K
