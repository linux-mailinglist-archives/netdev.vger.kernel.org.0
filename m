Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5788B575956
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiGOB7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 21:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiGOB7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 21:59:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BC672EF4
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 18:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657850373; x=1689386373;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=kvcGpKfKMcvxEtYl96gmTU3Nloqs7ie09+TMcKHFWXc=;
  b=BdO5h6YVZe1PUq2J9cEkcDbT5PyQaWvUf6dNGx6F2IUgqTsqRBRrp6KR
   fz+6d3qE6xVoFSg+K0oXeMwuxPzhCnVsMMEShU3jvIBjhgOhdMM1jZ2Ct
   8kNUVb+PsPWCr0AEfzdIZ/39XV3CvkPxgExFUNQ77yU1qanQxAE6+lkrR
   lrgCNAYpUUvs3jlwdWDvcGEUXr2tEOyss24wdQrFhXh0Djs9rwIm9U35i
   5R/et8N/WCuyVOP1soGbUPyEguKWfmBZExJpjtkoiaV/FQup0gBTr83VV
   RiegpZn2zkUa7a3c8Wii7mMFierpgJOF4DYvZmCuZ1yZfKm7eZkiFw+UE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286817921"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286817921"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 18:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="571333343"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2022 18:59:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 18:59:32 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 18:59:31 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 18:59:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 18:59:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIfOp7NES3LTxWYz/XNv/wxCZMXXZhy54LJslyHK3gyhIdZK3YblIJw1xrjxJ/1+MpvzEefUFOuuE7XYW7krDvR/LoHgvrsEIsNQFnl/9FkRbNuyVmif6f414k7BEp93QADHntPDzy+XJoPRhFreNrFORhmJ9wn76laoAaCMO5abfqiZexGrkoc72ctXcyCGCAFIcv4a/vnFp7ftYHK4qNuG3P8wdL76T6T7qvD2rjkLwp6QREz3x1FhE1UJSxN/xY4pynI483BgDrd+D66b7a7vz6+yvPV53eBui7L41krHmwpQGNqhmOyxwfEmCkRDu4n491YjDDh9votF9oKqNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvcGpKfKMcvxEtYl96gmTU3Nloqs7ie09+TMcKHFWXc=;
 b=ipcHsnJ03kYwSxYJG5bjQK1Jrp3MPygCNnMC3f5Qf9AfBG9knz+g1aYQNAu6rilyTi4SyvH5JM4rRG+ZJEnwUJND5c2TLsTjrrGPJ7oawy5JULVLtJyidP7huMzyyfBt4EsS/nPzN8v4ZhOZcH4I0fbRVfbMlS1spaLyUuVhYZmSr1Hsfc4fy/BeSoH26+/Gm/PHV4OKjj4hi4+cCzyl5D8L6UPjXew1oSQQWXb2hlrxY5lkxbTJOOsvOlan9T7jUYeePvg5OZuFco41sUEOTDnkpsrE0lyHVSQP1luZPzODBLtiXOdy0KzzxfGgccsApkwYQUsp6S9zkC5ntg3lMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8)
 by DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 15 Jul
 2022 01:59:29 +0000
Received: from BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::bc2f:626b:4d64:616b]) by BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::bc2f:626b:4d64:616b%5]) with mapi id 15.20.5438.013; Fri, 15 Jul 2022
 01:59:29 +0000
From:   "Chang, Junxiao" <junxiao.chang@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cedric Wassenaar <cedric@bytespeed.nl>
Subject: RE: [PATCH 1/2] net: stmmac: fix dma queue left shift overflow issue
Thread-Topic: [PATCH 1/2] net: stmmac: fix dma queue left shift overflow issue
Thread-Index: AQHYlpaH1CMZHTGub0K1UaYtujCHdK1+q4KAgAABgzA=
Date:   Fri, 15 Jul 2022 01:59:29 +0000
Message-ID: <BN9PR11MB5370EB8C8654FE18A3F142AFEC8B9@BN9PR11MB5370.namprd11.prod.outlook.com>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
 <5751e5c6-c7c0-70be-912f-46acb8c687cf@gmail.com>
In-Reply-To: <5751e5c6-c7c0-70be-912f-46acb8c687cf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 715872c1-e06a-4bd8-e39e-08da6605a790
x-ms-traffictypediagnostic: DM6PR11MB3625:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hvweFnXhmYUm2qStVb+6tReAl/24H3hHOTnyopu6I/bVwapctLJi2mfAMOVp33qbQ2euTDNR0YCD4mX7hFXA1lapuxqX9LAz4IQxj/yZbr4rY7MaNMgJ4jsxvGHHJnubZXqn4Dzekr4tlVbz8ovAgZJ1io/avn7mrKK64rAamzYkAKxYJ+r1mtUTDYFshUKdKJa+OSTivsl+ir13AOGZhocoD0s1E7CCmi4vxbVvg3MlMYtYTRjCi8yKwLPU7F8gXgWCNj3nUXqRoMRTT6BO3eglLtJq52nAHF+OtU3utdcU8FNPnAs23FvD8IMgWbeAypdQSA+qYyMgm/qysZoyMaHGfzWIjsWrmrpV1Eu6gbar7oFv/4w9plgOFL1WeQdFRjmW+6afQ3L+Mm5Xw+kAFWg+umIIC9NCJBL2Ei9fUnQ6vO5AOqbZqYs4UrvprUm4kKHdiaz1zc8uUEpMFvU6JaTn0p2ZU+GpgmgmzgHWY93TMUeoVCsGGQiTm8PVUZ0ddHJ7w4q+Mz2huUDpdR/pdgqcETk3nfPubzX9N3SHq71Rn6/YgofonkL+xP3KPbUfyObausLLP4mVN9GrHOH6XalItrHZt/V+CQVw6SLcFGJxe2hiPCwBsacyv5Lx9xkplUiKhrzfO7OG7N+0hH2/DMOhLsJAzPMwQKvBVQT8S1hQUzYQKRWbAE+2MW2zmk91kyNndOLoApdeSc80jWIkYjrvIEgNrQb90dPVBi+uoX67KxPik7DS9Xay5HHjwSyV5p6zBiRYfTDHUhIdvdK/bVeVEPhSySdbb5G/3QOObN6QqrMaznj9K2YlTi+aII5WuUvdtteCUlIyofX6U9QF/UBNscDQCinDUAutrEoTeLk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(376002)(39860400002)(346002)(66476007)(8676002)(66446008)(966005)(66556008)(316002)(33656002)(71200400001)(64756008)(41300700001)(38100700002)(2906002)(5660300002)(52536014)(186003)(53546011)(86362001)(7696005)(83380400001)(6506007)(478600001)(66946007)(55016003)(38070700005)(26005)(9686003)(122000001)(76116006)(8936002)(82960400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDluQTVOTnFDYkI0NWEzeUZGTXdCZTErOE9oUDRCUkNtVGhuT2tLdXhid24z?=
 =?utf-8?B?NndHK2dVcHA2UHZMc1BScUdpa2x1ekhJdi9IdURTK1R6RWJVWkIvUmxYM2VN?=
 =?utf-8?B?S2VXam1GYmJxSzA3NlpuVTFOTkFtR3hQUlFrRUlDNlNkWHhEM01TRXFEeDRI?=
 =?utf-8?B?UDI5WGtrMHhycjAxRlg0b2JTeUdmSlpiSytGbEs5YkxZNjFWMktseDhKNGUv?=
 =?utf-8?B?UzBZeDFYdkc0djZGOGZVdktaNUpwVSt1aU52dHl3cnNremN0aWJCdXRJZlBp?=
 =?utf-8?B?NkdiT2ZSMjF2KytJeGpvaHZrVXFaVk4ycGN0OXdjTWVPUWVOcGJobUZTUkYz?=
 =?utf-8?B?d3hVdjJHVnBOaG42VmUvUGl3aGxyTE90bjBnQVZFTTIyTmQyd3NsR1BMemY3?=
 =?utf-8?B?R1VNSDdPZlZ4ZldLN2NFbys4WjRKdTRFSXUwOERsY1A3dG1veHQ0VFh0cEFM?=
 =?utf-8?B?YTNSeDh3d3VvdWVHM3E4cDJMNjlnVGhrVUVOZUM4RzU1dWQyQS8xeUJkS05H?=
 =?utf-8?B?OTFFUUZ6SzNwQURqV0NvdWt0c1Q5Q1RpQmtmVENnSDAxbzNLeHJmcjBJeENx?=
 =?utf-8?B?cnRYcFVLbEo1QjRVU3oveUx0ekY0VS95aDE2Yndnd0RLdEZTb2RyZHl6OG5s?=
 =?utf-8?B?Wmw0NUkwckl2T2JiWVI5OVp4ek1CQnRoRGNJVFJ0aVpya1VTdENnNURhdFZm?=
 =?utf-8?B?N29vVjBFeTdNeDBYZXVZL1p6ODljT0ZIekJVMFJNRXB3UUxuTDZCZ2l3Y1Rn?=
 =?utf-8?B?YmxKT3BYS2t0RVdHZmNKUW9pNG81ekplMGlaZHlHb0tsaW0xdkpTaWR3RGNh?=
 =?utf-8?B?YnBNeEVmZ0YwcDhuR0lHZnlEZk9EeS83aFNQZFVCQlpueVNObWg3VWQ2QUk2?=
 =?utf-8?B?NE9lVjdXMkVUU1J5NUVuQ3lVQm9TT0t4TFRRTjJuTG5VeUwzWUZkWWg3Wjlv?=
 =?utf-8?B?Nm10dnFVaGZUN3dpRUVIekNRTEtydk82TFV4TWRZUVJTTUZmYlIvVDNJZXJ0?=
 =?utf-8?B?OEhIb0FSVFdPYVVOa2NTYkl3NGZZS0tZS2lDOUFyUGI3bTRaOVB1VVFSYmhG?=
 =?utf-8?B?NEVtRmIwb0hIU0g4c2Rna2w5clBJNjd5RVh5dVE4M0l3WW53RlI5YmxWSkVF?=
 =?utf-8?B?WHB3dzF2U1hnTkNIaEhqSktVREthSSt3VW0xMFVObWRFWlljMnBJeW1YTk55?=
 =?utf-8?B?WVRlN2VqcXVSY1BERUd3SlNUOFVKTlVnaFZwTzRDK1FLZzJRcnptZnE1eW5S?=
 =?utf-8?B?TkprcWs5S1k5aVBndDhQaEFoc2FuRVYyd1hDQlZTeUYzbTFCbU13YlpPR1pP?=
 =?utf-8?B?bEs4Z2lPQSsxdlowTUxlOERXS25oWkptazBaeTR2YmczZzZFYis4NlFiRGJx?=
 =?utf-8?B?UGtJaU14OEwvVVlVblFkTW50YU5jcXIyT3dnSnpvNW0vL01Zb0FxVzlPTjM1?=
 =?utf-8?B?S3oyWVEyak9xZnhXK3JYSXY4MkNzQTdDWExkR3pEenhhRlo2dG1WS3JIbVRX?=
 =?utf-8?B?N1poUDZiRXlVUFNoTDVHQlpUU3kwdVVPM1FIaDYrSjl1ZGtzMmZzNVRxeUEr?=
 =?utf-8?B?M05laDFOUTFaZ0xpV2VXMWZXWGw5WTk0Z1l5bkUzOUx5aWhCYjZsekRybTdK?=
 =?utf-8?B?dkxRMXVLWk55MUJzanEyOXY3THZQc1RwL0dRN3YxdXRKUUdROTJQekVqMXRi?=
 =?utf-8?B?aHZNczVFVld6bm80dlJ4QXovL0IvbmxPZUMrdzBNWEF1U1FqUEh5Wk5ZMkxR?=
 =?utf-8?B?bUZRV2dUN1d0Yy9mc3JnaG1VVitvek1MdkF3OXZtRkV1dTAybC9NUnA0enFj?=
 =?utf-8?B?aTc1aGNMT2xRQVE2M0t4d0lwSkZ4M1FQV2JldzYrYmxsS0JIUmVMQmFXcXJm?=
 =?utf-8?B?MDdQdXBJWXhRSGdZSUU0N2RodEFoTVJTZGV4UDZDb0REMzc0V0RwSjJzcmMr?=
 =?utf-8?B?WHU3TVVkNFJEZnpNYTJNRUFSSERpWlpKNGFiTTIxcnJzQXQ1WWxuTDNmTUs0?=
 =?utf-8?B?UHhHSWFGeGZPUktNcExkT2tVcjN2NGtrWnB5Z2ZrUFZ6eDF0VnVkWXJya01v?=
 =?utf-8?B?TjVBdzBiZ2VtcjNoLy8yOS91d1Z5RlZraGdxSEUxdTQ1QUc2REJwRnFQQ1Vw?=
 =?utf-8?Q?fj1T82+XzdyLDwxqNzjjwhSTu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715872c1-e06a-4bd8-e39e-08da6605a790
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 01:59:29.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lU6YqOIn8IsdfA7kDs+kw8Sxf+JyFUKKFPMAL4cCkXpjMeX2N/mVtqDTvol8ZpSGAZv4IvWZMVjd35ww/JJpQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3625
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlcmUgYXJlIHR3byBwcm9ibGVtcyBpbiBDZWRyaWMncyBidWdsaW5rKGh0dHBzOi8vYnVnemls
bGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE2MTk1KToNCjEuIFRoZXJlIGlzIFVCU0FO
IHNoaWZ0IG91dCBvdWYgYm91bmRzIHdhcm5pbmcuDQoyLiBFdGhlcm5ldCBQSFkgR1BZMTE1QiBl
cnJvciBhbmQgbm8gSVAgYWRkci4NCg0KSSBzdXBwb3NlIG15IHBhdGNoIGNvdWxkIGZpeCAxc3Qg
aXNzdWUsIG5vdCBzdXJlIGl0IGNvdWxkIGZpeCBpc3N1ZSAyIG9yIG5vdC4NCkkgd2lsbCB1cGRh
dGUgcGF0Y2ggYW5kIGFwcGVuZA0KQnVnTGluazogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3Jn
L3Nob3dfYnVnLmNnaT9pZD0yMTYxOTUNClJlcG9ydGVkLWJ5OiBDZWRyaWMgV2Fzc2VuYWFyIDxj
ZWRyaWNAYnl0ZXNwZWVkLm5sPg0KDQpUaGFua3MsDQpKdW54aWFvDQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNv
bT4gDQpTZW50OiBGcmlkYXksIEp1bHkgMTUsIDIwMjIgOTo0NCBBTQ0KVG86IENoYW5nLCBKdW54
aWFvIDxqdW54aWFvLmNoYW5nQGludGVsLmNvbT47IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFs
ZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207IGpvYWJyZXVAc3lub3BzeXMuY29tOyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBDZWRyaWMgV2Fzc2VuYWFyIDxjZWRyaWNAYnl0ZXNwZWVkLm5sPg0K
U3ViamVjdDogUmU6IFtQQVRDSCAxLzJdIG5ldDogc3RtbWFjOiBmaXggZG1hIHF1ZXVlIGxlZnQg
c2hpZnQgb3ZlcmZsb3cgaXNzdWUNCg0KDQoNCk9uIDcvMTMvMjAyMiAxOjQ3IEFNLCBKdW54aWFv
IENoYW5nIHdyb3RlOg0KPiBXaGVuIHF1ZXVlIG51bWJlciBpcyA+IDQsIGxlZnQgc2hpZnQgb3Zl
cmZsb3dzIGR1ZSB0byAzMiBiaXRzIGludGVnZXIgDQo+IHZhcmlhYmxlLiBNYXNrIGNhbGN1bGF0
aW9uIGlzIHdyb25nIGZvciBNVExfUlhRX0RNQV9NQVAxLg0KPiANCj4gSWYgQ09ORklHX1VCU0FO
IGlzIGVuYWJsZWQsIGtlcm5lbCBkdW1wcyBiZWxvdyB3YXJuaW5nOg0KPiBbICAgMTAuMzYzODQy
XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gWyAgIDEwLjM2Mzg4Ml0gVUJTQU46IHNoaWZ0LW91dC1vZi1ib3VuZHMg
aW4gL2J1aWxkL2xpbnV4LWludGVsLWlvdGctNS4xNS04ZTZUZjQvDQo+IGxpbnV4LWludGVsLWlv
dGctNS4xNS01LjE1LjAvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0
X2NvcmUuYzoyMjQ6MTINCj4gWyAgIDEwLjM2MzkyOV0gc2hpZnQgZXhwb25lbnQgNDAgaXMgdG9v
IGxhcmdlIGZvciAzMi1iaXQgdHlwZSAndW5zaWduZWQgaW50Jw0KPiBbICAgMTAuMzYzOTUzXSBD
UFU6IDEgUElEOiA1OTkgQ29tbTogTmV0d29ya01hbmFnZXIgTm90IHRhaW50ZWQgNS4xNS4wLTEw
MDMtaW50ZWwtaW90Zw0KPiBbICAgMTAuMzYzOTU2XSBIYXJkd2FyZSBuYW1lOiBBRExJTksgVGVj
aG5vbG9neSBJbmMuIExFQy1FTC9MRUMtRUwsIEJJT1MgMC4xNS4xMSAxMi8yMi8yMDIxDQo+IFsg
ICAxMC4zNjM5NThdIENhbGwgVHJhY2U6DQo+IFsgICAxMC4zNjM5NjBdICA8VEFTSz4NCj4gWyAg
IDEwLjM2Mzk2M10gIGR1bXBfc3RhY2tfbHZsKzB4NGEvMHg1Zg0KPiBbICAgMTAuMzYzOTcxXSAg
ZHVtcF9zdGFjaysweDEwLzB4MTINCj4gWyAgIDEwLjM2Mzk3NF0gIHVic2FuX2VwaWxvZ3VlKzB4
OS8weDQ1DQo+IFsgICAxMC4zNjM5NzZdICBfX3Vic2FuX2hhbmRsZV9zaGlmdF9vdXRfb2ZfYm91
bmRzLmNvbGQrMHg2MS8weDEwZQ0KPiBbICAgMTAuMzYzOTc5XSAgPyB3YWtlX3VwX2tsb2dkKzB4
NGEvMHg1MA0KPiBbICAgMTAuMzYzOTgzXSAgPyB2cHJpbnRrX2VtaXQrMHg4Zi8weDI0MA0KPiBb
ICAgMTAuMzYzOTg2XSAgZHdtYWM0X21hcF9tdGxfZG1hLmNvbGQrMHg0Mi8weDkxIFtzdG1tYWNd
DQo+IFsgICAxMC4zNjQwMDFdICBzdG1tYWNfbXRsX2NvbmZpZ3VyYXRpb24rMHgxY2UvMHg3YTAg
W3N0bW1hY10NCj4gWyAgIDEwLjM2NDAwOV0gID8gZHdtYWM0MTBfZG1hX2luaXRfY2hhbm5lbCsw
eDcwLzB4NzAgW3N0bW1hY10NCj4gWyAgIDEwLjM2NDAyMF0gIHN0bW1hY19od19zZXR1cC5jb2xk
KzB4Zi8weGIxNCBbc3RtbWFjXQ0KPiBbICAgMTAuMzY0MDMwXSAgPyBwYWdlX3Bvb2xfYWxsb2Nf
cGFnZXMrMHg0ZC8weDcwDQo+IFsgICAxMC4zNjQwMzRdICA/IHN0bW1hY19jbGVhcl90eF9kZXNj
cmlwdG9ycysweDZlLzB4ZTAgW3N0bW1hY10NCj4gWyAgIDEwLjM2NDA0Ml0gIHN0bW1hY19vcGVu
KzB4MzllLzB4OTIwIFtzdG1tYWNdDQo+IFsgICAxMC4zNjQwNTBdICBfX2Rldl9vcGVuKzB4ZjAv
MHgxYTANCj4gWyAgIDEwLjM2NDA1NF0gIF9fZGV2X2NoYW5nZV9mbGFncysweDE4OC8weDFmMA0K
PiBbICAgMTAuMzY0MDU3XSAgZGV2X2NoYW5nZV9mbGFncysweDI2LzB4NjANCj4gWyAgIDEwLjM2
NDA1OV0gIGRvX3NldGxpbmsrMHg5MDgvMHhjNDANCj4gWyAgIDEwLjM2NDA2Ml0gID8gZG9fc2V0
bGluaysweGIxMC8weGM0MA0KPiBbICAgMTAuMzY0MDY0XSAgPyBfX25sYV92YWxpZGF0ZV9wYXJz
ZSsweDRjLzB4MWEwDQo+IFsgICAxMC4zNjQwNjhdICBfX3J0bmxfbmV3bGluaysweDU5Ny8weGEx
MA0KPiBbICAgMTAuMzY0MDcyXSAgPyBfX25sYV9yZXNlcnZlKzB4NDEvMHg1MA0KPiBbICAgMTAu
MzY0MDc0XSAgPyBfX2ttYWxsb2Nfbm9kZV90cmFja19jYWxsZXIrMHgxZDAvMHg0ZDANCj4gWyAg
IDEwLjM2NDA3OV0gID8gcHNrYl9leHBhbmRfaGVhZCsweDc1LzB4MzEwDQo+IFsgICAxMC4zNjQw
ODJdICA/IG5sYV9yZXNlcnZlXzY0Yml0KzB4MjEvMHg0MA0KPiBbICAgMTAuMzY0MDg2XSAgPyBz
a2JfZnJlZV9oZWFkKzB4NjUvMHg4MA0KPiBbICAgMTAuMzY0MDg5XSAgPyBzZWN1cml0eV9zb2Nr
X3Jjdl9za2IrMHgyYy8weDUwDQo+IFsgICAxMC4zNjQwOTRdICA/IF9fY29uZF9yZXNjaGVkKzB4
MTkvMHgzMA0KPiBbICAgMTAuMzY0MDk3XSAgPyBrbWVtX2NhY2hlX2FsbG9jX3RyYWNlKzB4MTVh
LzB4NDIwDQo+IFsgICAxMC4zNjQxMDBdICBydG5sX25ld2xpbmsrMHg0OS8weDcwDQo+IA0KPiBU
aGlzIGNoYW5nZSBmaXhlcyBNVExfUlhRX0RNQV9NQVAxIG1hc2sgaXNzdWUgYW5kIGNoYW5uZWwv
cXVldWUgDQo+IG1hcHBpbmcgd2FybmluZy4NCj4gDQo+IEZpeGVzOiBkNDMwNDJmNGRhM2UgKCJu
ZXQ6IHN0bW1hYzogbWFwcGluZyBtdGwgcnggdG8gZG1hIGNoYW5uZWwiKQ0KPiBTaWduZWQtb2Zm
LWJ5OiBKdW54aWFvIENoYW5nIDxqdW54aWFvLmNoYW5nQGludGVsLmNvbT4NCg0KVGhhbmtzIGZv
ciBhZGRyZXNzaW5nIGl0LCBtYXliZSBhOg0KDQpCdWdMaW5rOiBodHRwczovL2J1Z3ppbGxhLmtl
cm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjE5NQ0KUmVwb3J0ZWQtYnk6IENlZHJpYyBXYXNz
ZW5hYXIgPGNlZHJpY0BieXRlc3BlZWQubmw+DQoNCndvdWxkIGJlIGNvdXJ0ZW91cy4NCi0tDQpG
bG9yaWFuDQo=
