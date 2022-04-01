Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7E4EE985
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 10:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344199AbiDAIM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 04:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245069AbiDAIM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 04:12:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607DE4DF53;
        Fri,  1 Apr 2022 01:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648800635; x=1680336635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ao3LHon1J5Ck91nN9xaC08gMIBgN2rczPDTVGB2LXkw=;
  b=f4+7S9dxF9OmhCTPnQkIaxhyMn8VD1AH7Q0hg9oe6a9nQN47RPp8APDw
   vMx8FOWXBw+BuraRPTOekHkRJD/ZhpzrwiGYF2lke2ULZSm2ix0Xkaom/
   Twbcj9aNxZP9MTFMPO1qq8ZyNyVfXwwnJdDN6tmj/rq5OinXYurqsMsYD
   D0MucneTRcBLuer1ArSLfNkPmEi9kHaeAb+QxWUNdn1f2DX+K/AdLwj33
   r8RUu4jUQPg5UpgagI4JwlXj+maY83F+aTqkMEJ2d3BvixE6THFWe5bQB
   0P9HllTwP3YDQ2Je6gmVMnI4CaYoMxSkPXqx2HvF8gc9/DKMBsMEq9RZr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="247582466"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="247582466"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 01:10:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="655518236"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 01 Apr 2022 01:10:30 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 01:10:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Apr 2022 01:10:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Apr 2022 01:10:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Apr 2022 01:10:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4D3Lw+2+k4/a11HbdJkrIKw4W1FvjZCfTjKfwE+rRSi6K0TGxKhDiL02Mw9B8aAueC5hxdf7WyihKwU3QQ+8JziR0NYbzTACyFP8wY69UuUcrg6rSi4xFwOc7Nx+Us2k2DUV8TpaGIw5Jnn2HFGgG7gEstTYw1jANshcIWo5uoS4XVWvBFtLxH5eo7UUjvjydMploQhCcTSPzjNv4dPJB5VurTsSU/fTMHwgjG8Iq7ANYSSB2LlWkPllU61tN6mF+Pk4MM+JO5e+P/IzoPNP4bKUz31g81Nikyo5xRTTFGHqHadaFeRyO+Wqa8YlyFhdrVw8tKVkSb4j3zA/9WFJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ao3LHon1J5Ck91nN9xaC08gMIBgN2rczPDTVGB2LXkw=;
 b=LrRuNd6w63N+vhCxO6olqsSUa1r9CRBbl4lXWlIq2fhDUGgROUMtBd+8VuftIq0WSJfYrBVkdymw+xcuQg0bl7jirWt87vEZtoVpQ3m3/gV2IhmigIwC/GrlXjvije17X1t723+JVk6yab93puFIT01AEtPF2g6qzOEjBa8xqCKbwnZR8dvOhIz26VIjrulwaCtbM4reXiQlLfr45AScS83ZusheYfs4zpG9+mFt0TKpqirpGZFNbXjpzCOpRhnobdxM8kEvR4ya14qm1G2Vit4T4W1RhCWF5hizKFREySnyI24rW89H6Im/SZPu9OGfFiLDCT7wx7ny+2KzXGTL5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SA2PR11MB5113.namprd11.prod.outlook.com (2603:10b6:806:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Fri, 1 Apr
 2022 08:10:26 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167%7]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 08:10:26 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH][next] iwlwifi: mei: Replace zero-length array with
 flexible-array member
Thread-Topic: [PATCH][next] iwlwifi: mei: Replace zero-length array with
 flexible-array member
Thread-Index: AQHYI21p4QBTTxpzHk6RtOxEWNwTO6yWopUAgDprEICAA3p/IoAGcOEA
Date:   Fri, 1 Apr 2022 08:10:26 +0000
Message-ID: <2fff1c4d0efdcda670ddc3683e383f6472d91e85.camel@intel.com>
References: <20220216195030.GA904170@embeddedor>
         <202202161235.F3A134A9@keescook> <20220326004137.GB2602091@embeddedor>
         <87wngezkyf.fsf@kernel.org>
In-Reply-To: <87wngezkyf.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.43.3-1+b1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54e54319-5dba-45d6-3be5-08da13b71467
x-ms-traffictypediagnostic: SA2PR11MB5113:EE_
x-microsoft-antispam-prvs: <SA2PR11MB5113BF0EB1BF2408091D288190E09@SA2PR11MB5113.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xnv66PrFmzUGo0VFQzXAsecgmzyECEwyLAbdtJuJzVlau369br0XPDGB2FoYqvtVwSQwr5d64pvSI7DI7r12B1qlAbUDv8vxcapdvkGZt7Sth767feioVlRGWtvciNSwJCBGmGFcod1+79zacB/Daw1JC1HAgzri9lWT/wOFqEHwzeAcGoooJtgpoJXEyl8KxYJT3ji8dIHR63GFzNzw2Vq9w5kJWMXaf9u4TfOi50TcLFwkmAgcZaRZjZCrGmUqvhUu81jRdOFTUUnAY9BOTwR1Fc8I4oJ5rtfHu7OXM1TBbjZgPPFGpi8mJnQzOhjE/aWRnR9vqMnmm0u9r4ZPjsS5jgQ5aCH2WPAbG6m4wWBLj9y6tZs2zLhTGyg4qkKzLnG+mp9SSdKEyPBjIulqLdLctIKobBgaPkFcwg88/IpU7MeJegB5luRLb5T7FrEHCNUQswVtEXDnsKqshq1B7eNxsLKIdlC+uNIQrH6PE4Ujmorr6eR0eDkDRqb7WM6jtUqaKqnpBn5naY9nwrDq0Bg0aUreq4RKP3dIFGSuxkRSnmT2xXUP8s0cSx2SS63fLaqGxMjyGLtfGJpZA5zBx4SmkM4LD2c92M/I/QCVxIQhGH5/P7Vs7i96H3TiEiljqWHKuaZ0CaKzery3AM0FQ190ZYMX6iogYoyCS2RFTmWUD4mDz/Z3psIBoP5naGD7vrxk8WcjuNXeP13jYDLcecg6iGmICScU1y0zafbjrfmcpQ2iB4XOqE08LzfohTRQpZwbboH6EHF36/HN9SvrvYnhDWG/Um4YBDtpPBi00Fgy6eAS5ZtWEVcXHr+faFMB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(186003)(26005)(966005)(110136005)(316002)(6512007)(36756003)(71200400001)(54906003)(6506007)(86362001)(4326008)(66556008)(82960400001)(8936002)(38100700002)(66946007)(76116006)(91956017)(2616005)(38070700005)(8676002)(66476007)(122000001)(66446008)(5660300002)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjhXNGpoRmpnb0lXbmRYMmNyTW5kZENkUUpoZnd3eGJUSjlhczVabFRGSU5V?=
 =?utf-8?B?K001M0ZRSzNDRjVqdFdsb3JaMWRvNlVKVEU5d3dQRDNNKzRSK3RYVHRUbWxy?=
 =?utf-8?B?b2pqMFlXSmlWTUJKMUUwQW9NQVZ0SHBCejZMOVZMQnJQaTM4WDY1NUFIdnhY?=
 =?utf-8?B?VVBYZW9QdDRzYXVxZ2JTd0U2dStZanNidzMyQ2RMMHQxYTZNaVk0NlNnVjBi?=
 =?utf-8?B?b0tma01zM3psb3VZcEJNcE0xN0szUGlSZlAvY2VweWhpWW14TlZwbEpJaGZW?=
 =?utf-8?B?dHpVZCtORG1ZM3dGSXV6aENBQ1RlZkN5TTg2enFzYjgwMEpsdmFnUE1xWFk1?=
 =?utf-8?B?d0NGcFFxdm1hVTE2SGo1WjNvK0ZOUEJqcHNYT0p4VHpYUTNielpQM0N2dCs0?=
 =?utf-8?B?amJ1MzcvcGo5Tm5RR2NlMHBBZ2lTdjlxTTVGYWNySVUrYzNXMmVCUkpOZGdE?=
 =?utf-8?B?TFpoa2NkU2FGWlV6R2JmTllDQmN1MEhiQUJvWTdueURZSXVtRERTRWNLU0hC?=
 =?utf-8?B?U2lPR3FNZ0hJaTlQc1c0SG1kKzBKaU1OQkVUR1ZkRFJ1WGg5dmFpdmJheTNQ?=
 =?utf-8?B?SC8vZWlhWkVKS1V3KzdLNnJFSWk3dE9JNnFTbnR4TzcxajdFcEpobXF4d1FB?=
 =?utf-8?B?b1JSMURjSmlqbXdMMm13L29aQ2hSdXNIbkV6azdNUGIvZm5GMnZmVC83QWsr?=
 =?utf-8?B?NmtUTk5OMG1XWnZPaW9BeW8wUzNiek94OS9SeGprdTlRekdTaDY0cGhwRlhz?=
 =?utf-8?B?bVdkSmZaNCthdDRUSHFFVXdVenpVdURlREdHWW0weFNJVGFKNFRGNVJnRE5w?=
 =?utf-8?B?L0lJT0w4dXZOYUlIRVdxZnUwTkRWSmNhbmRIWWl0Skt0V0tTRkpkK3RPKzN4?=
 =?utf-8?B?bVRyaUo1NWhOM1l2MnVDcFNudFNWMVJKMFBGVEZVREY5cDdMWlBleHZqV3dO?=
 =?utf-8?B?ZDViajdiZGN4SW9GVHU0c0NHRGo1TCt0SDJoajFBK0JhM3FITGRCWjhtN0th?=
 =?utf-8?B?NnBBQTE3S2IvNVRydDlIUEFJemdwMkt1YUUzK2hZeTdTdVg4Sm5XYk9WcXpj?=
 =?utf-8?B?cExibU11SUpCQmxGUE00L1VKNFNOcHBiMWRnM3BYa1pzWldnTWRzeVhVdWh3?=
 =?utf-8?B?QmZPOE8xODVieFVsT0FEcmJhcXpQUWZjcjdYUUVXMy8zTlNnUG1TbCtYeEw2?=
 =?utf-8?B?THJ3amhXMUhrdVZaWWRlYWM5S0xIYThVS21OcXNDTzNVcTBnemMwNm45YkRq?=
 =?utf-8?B?MFVJME1OZmdwd2EwK0tKMXpzaGVNTW9GQjcwTGNlVk1ucXZHRkkzcWpKSjIv?=
 =?utf-8?B?QnUveTZKRGpsdGJHYlVnWVZianovdHpRVC8rM3NkbVlmMjdIU3piTGFHM05a?=
 =?utf-8?B?Y01NUUFmUW9iN0NENkZreEVwZlZQKzQ0aDYvL2dxbVU0RjhuYS9BMjRNbzBO?=
 =?utf-8?B?cXVhMTlPZmI0R2pvSElGRHZQd1cwdlJFRXppNmJCTUpYWkRCWE9pWEdBY00v?=
 =?utf-8?B?Y20wWWY3cEVWek1lTSs1anBjNk10NHVzVjRRNWVrblpmaGhwMEhwUWRjYkJ6?=
 =?utf-8?B?WXJCZXJ3YUgyME00UU0rK2lIQndYbi9qTzR0cU1XMTZnQlU0cEUvOCtjRlBz?=
 =?utf-8?B?T2tla0Q4NW9wdzhOUDhlVjJLR2U5U2w0UzkzTHl0bDg5Vy9hNkpuYStSWkV1?=
 =?utf-8?B?cVpMenZxSHFkWHpwNWNHazBpZFNRaE5HOWJwdXZGbUg2WEowU2cwc3I3bVRr?=
 =?utf-8?B?czR2ZERlR00rU1RDSENYajVmWGJEOWJDMEFRWHpNdzNjNVJSNE10endoSmxH?=
 =?utf-8?B?U2NxdEFYNGpCajJkRzVaMjQ3cHFXanJCMWJBMVF3UjRCUS9JeERBbkJQeG9O?=
 =?utf-8?B?Q0Q1N0FDVEZGR002dTlibUhLdGFrRitMUWl4dzI2YXFoUUphVlZHM1JiSWFt?=
 =?utf-8?B?QTRpSTEwQmdURmJxUmtZWU9WME56VS9ubWZNcWU1aFBKL0cxTUJHditueFlt?=
 =?utf-8?B?K2NieENJeFNHcVJhaFdLM2FONk1aTHdXK01LTUVaS0ovM1lETVpRTDY0RGNO?=
 =?utf-8?B?ZTNiNm1rUUZvSzQzS3ZzSmdNUkFDWFg5eFltYUFFazcwY3Vnb2pweHYxQko2?=
 =?utf-8?B?RVlyVy9lR0NVQnpGbXZxbDRpNk1qWGNTYVhmZlpqTHkyTU5xNWw0b1U3MDVw?=
 =?utf-8?B?Q3RYSDU4VFJNMDcreG9KMDd5a1B4NTUzMG9OT1JsSWl2QVFYZnlyMlNuNnlm?=
 =?utf-8?B?dHlFRG53SXZYUXZZS1F1bUJIUEdJc1hNVHdueGRFb1BNSHJMa3MwaUl6eXEw?=
 =?utf-8?B?MTBGeWl4ZXdFR0t6UThQRzYrUFErSS82anZKSUY2aGp0MklsbzJSSTZBbHBo?=
 =?utf-8?Q?+Adps3OQP+RV1gH/OVhM/KfXSCTbFUwgjQy8D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C1ECC4CC2D6874A9118204B88CD947D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e54319-5dba-45d6-3be5-08da13b71467
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 08:10:26.7974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBGCryUanVzh/gxQwK8NcYT6IBoYGnGrjS6/R8w6kXf1fXUkm0XyyFaahqs4HhqYR8teDMegSOlCFE9DkHy/5CJwSTKt9aWafCVvD8NkfyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5113
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTI4IGF0IDA4OjQ4ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiAi
R3VzdGF2byBBLiBSLiBTaWx2YSIgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4gd3JpdGVzOg0KPiAN
Cj4gPiBPbiBXZWQsIEZlYiAxNiwgMjAyMiBhdCAxMjozNToyMlBNIC0wODAwLCBLZWVzIENvb2sg
d3JvdGU6DQo+ID4gPiBPbiBXZWQsIEZlYiAxNiwgMjAyMiBhdCAwMTo1MDozMFBNIC0wNjAwLCBH
dXN0YXZvIEEuIFIuIFNpbHZhIHdyb3RlOg0KPiA+ID4gPiBUaGVyZSBpcyBhIHJlZ3VsYXIgbmVl
ZCBpbiB0aGUga2VybmVsIHRvIHByb3ZpZGUgYSB3YXkgdG8gZGVjbGFyZQ0KPiA+ID4gPiBoYXZp
bmcgYSBkeW5hbWljYWxseSBzaXplZCBzZXQgb2YgdHJhaWxpbmcgZWxlbWVudHMgaW4gYSBzdHJ1
Y3R1cmUuDQo+ID4gPiA+IEtlcm5lbCBjb2RlIHNob3VsZCBhbHdheXMgdXNlIOKAnGZsZXhpYmxl
IGFycmF5IG1lbWJlcnPigJ1bMV0gZm9yIHRoZXNlDQo+ID4gPiA+IGNhc2VzLiBUaGUgb2xkZXIg
c3R5bGUgb2Ygb25lLWVsZW1lbnQgb3IgemVyby1sZW5ndGggYXJyYXlzIHNob3VsZA0KPiA+ID4g
PiBubyBsb25nZXIgYmUgdXNlZFsyXS4NCj4gPiA+ID4gDQo+ID4gPiA+IFsxXSBodHRwczovL2Vu
Lndpa2lwZWRpYS5vcmcvd2lraS9GbGV4aWJsZV9hcnJheV9tZW1iZXINCj4gPiA+ID4gWzJdDQo+
ID4gPiA+IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvZG9jL2h0bWwvdjUuMTYvcHJvY2Vzcy9kZXBy
ZWNhdGVkLmh0bWwjemVyby1sZW5ndGgtYW5kLW9uZS1lbGVtZW50LWFycmF5cw0KPiA+ID4gPiAN
Cj4gPiA+ID4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL0tTUFAvbGludXgvaXNzdWVzLzc4DQo+
ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2Vy
bmVsLm9yZz4NCj4gPiA+IA0KPiA+ID4gUmV2aWV3ZWQtYnk6IEtlZXMgQ29vayA8a2Vlc2Nvb2tA
Y2hyb21pdW0ub3JnPg0KPiA+IA0KPiA+IEhpIGFsbCwNCj4gPiANCj4gPiBGcmllbmRseSBwaW5n
OiBjYW4gc29tZW9uZSB0YWtlIHRoaXMsIHBsZWFzZT8NCj4gPiANCj4gPiAuLi5JIGNhbiB0YWtl
IHRoaXMgaW4gbXkgLW5leHQgdHJlZSBpbiB0aGUgbWVhbnRpbWUuDQo+IA0KPiBJJ2xsIHRha2Ug
dGhpcy4gTHVjYSwgYWNrPw0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhv
QGludGVsLmNvbT4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
