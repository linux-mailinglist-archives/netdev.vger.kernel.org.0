Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C2D6F2A21
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjD3SAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjD3SAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:00:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD90719A2;
        Sun, 30 Apr 2023 11:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682877650; x=1714413650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yQd4+wgIIYwzscFXYZqXVajyT8VvYumjAZt0GCzwiEE=;
  b=DidW3B8A6OZkyP71Qdpc65EJr78P2sPv3jDiHQXcNO/Q7sORs0kJaWRk
   JABG55L7QgkSzoaUtcHP17/6tdMBeJXNllGAw7Agb5c4ZhSVNZ1w8keA4
   vycVUAG1roWh3KdPB46Lsw0yx5GaCXW93InExijEJrWfJgDwpbiGwiNBW
   sWkLsLvB2WKIIi0Cx3YyicqTcq1LcbggAK8WzavZWHdR6WFXa+ypJX/+R
   Kn39cl8G+4VqXiC20xvAl6l2xJByWQECr1aUcIIKcSh95+a5Q425MOB3x
   89J7GzcDIEHPT0S2QUnOTnwcbusn2eHvJ4QXeRFNjQB6d97gjq+Fr59Ci
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="434357318"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="434357318"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2023 11:00:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="689659416"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="689659416"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 30 Apr 2023 11:00:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 30 Apr 2023 11:00:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 30 Apr 2023 11:00:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 30 Apr 2023 11:00:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjrcI21UhdqCruLQdM5vY3878XP67vylTxWg1lzfR+ih7pTFB4StXXu9fePjyg8+T2KEvg0De4eF7R/7wF+iqQFKPe1agN0Cc9YvLCN+6CyMDn9akbWSePVeKoP0Y+Fk9LNYcV7wnF8qK09fTQzmCqoZnC2oPLpLJqn7J92TM8roIDnvAV1T119qtr8B/S7K9xBKp1mZ48kQK6a2CNF7gL4OoZgM8+zZbK11HkHGAaIcpbn5LhkysVtZcHUu+slbD8mjZUuJA7uRuUbmNHH7ngnBmw944sWVE1TQzfOwHAZxXMPLZXtycTwr+6lM4K9IYhWqzAr+/zkHMWKkl3vlUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQd4+wgIIYwzscFXYZqXVajyT8VvYumjAZt0GCzwiEE=;
 b=jKqhwN6qXEYtzZKxAatnQHfMurhNE7tnlORFs3ymWJdcwY0XeAec558FNXm4TiQ5rwC2RsK6jtbeU55y/xCyaI/2v372cK0DdHOq6dwnmZUYHWbtEY8Muj3KpOYJIe/KD1PVColxzuOTB0H8kWJLgtM3kt1eyB9VkX+cZu+rvDMYU3Xe0zaq8718LjBh3E/z07iOE8kCmeL7JmR6i/h0KjXyBzKgZXgORAk/tCknvAdBMDHjEj+Zdb+uusArkDcevRpUuHBW4nrbDtSQeNr7y8VKBcU3lKkHVu8fWpn5cqpSEkuF9bm24V+dgOLxIuFJYSiNkpiN10nTxdoYfWPZqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by DS0PR11MB6350.namprd11.prod.outlook.com (2603:10b6:8:cd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Sun, 30 Apr 2023 18:00:45 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::590:168a:7eda:e545%6]) with mapi id 15.20.6340.028; Sun, 30 Apr 2023
 18:00:44 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "jeff.chua.linux@gmail.com" <jeff.chua.linux@gmail.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: iwlwifi broken in post-linux-6.3.0 after April 26
Thread-Topic: iwlwifi broken in post-linux-6.3.0 after April 26
Thread-Index: AQHZeqQFhB2hgrahf0ygm4jpYqO+b69CmIUAgAEXqQCAAGaxgIAADzOA
Date:   Sun, 30 Apr 2023 18:00:44 +0000
Message-ID: <0785e432f1776b3531e8e033cb5b48eeb58b12b6.camel@intel.com>
References: <20230429020951.082353595@lindbergh.monkeyblade.net>
         <CAAJw_ZueYAHQtM++4259TXcxQ_btcRQKiX93u85WEs2b2p19wA@mail.gmail.com>
         <ZE0kndhsXNBIb1g7@debian.me>
         <CAAJw_Zvxtf-Ny2iymoZdBGF577aeNomWP7u7-5rWyn6A7rzKRg@mail.gmail.com>
         <CAAJw_ZvZdFpw9W2Hisc9c2BAFbYAnQuaFFaFG6N7qPUP2fOL_w@mail.gmail.com>
         <e9c289bea2c36c496c3425b7dc42c6324d2a43e3.camel@intel.com>
In-Reply-To: <e9c289bea2c36c496c3425b7dc42c6324d2a43e3.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|DS0PR11MB6350:EE_
x-ms-office365-filtering-correlation-id: 6056114d-e95a-425c-bc7d-08db49a4d185
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nj/U0RssdIPayySoCs4hEOI+74AcSAj6qniiIlmqw3+KI7oE3wFuuSEa23nUYRBq361mQun17EqcoRvb9Rpxi+j7pr9yCHt1RtP3hOB1a3gtki2N4R+zTsCgQ/ttpWFCK/h4PYf3gvu3yRsHshXh1HjvcMiWHrexjkoxibPk1vVlv6gBsC9D6r7TgUWzhCwwXwkQqhR7pccAwrV70cB/4HdSFqtTOGufz1xhzuJXPeyNJyRbWbsvlgEeI4KESGxgUXzaiSHnQqM1DwVVWPeooHsr4c051PCWrwHJKvvtltr6CcVfSSr6fNzIeWgKzjuD2V3g4KGDaRbCcS8Eekoz24TZPfhy+SaLWMFx3MEBsdAnzV+3c9F74YbuzoiWskZPTx/P/2ckKKcBBsEnnxk4gDOcCbne8fn8ZB9wQ21W5XtGLPWL75a5wGSMcBI9KlnIxgFMZJqFSM0inYltU6vT4BWjP+rYlUNDaHzVGPSAyWTS2DZjiIaXImFH+/+Trdv+27hp6pxviicwAc1NJQYdDeEhCWIrL3S11m298WAkOTh9xKuwNf1V+lOFUs8IT4GQ0hRoPqWhl37NPc8eHHxG3EzenL5eoRHCXyTAOcMHwbmIszZa/cNyJ4lwPc0DgoiKLwzPiFJ+OpSltb/kdRNroQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199021)(66446008)(66556008)(76116006)(316002)(66476007)(4326008)(110136005)(66946007)(54906003)(91956017)(7416002)(38070700005)(5660300002)(82960400001)(64756008)(8936002)(41300700001)(8676002)(2906002)(122000001)(38100700002)(186003)(53546011)(26005)(966005)(6512007)(6506007)(83380400001)(86362001)(36756003)(2616005)(71200400001)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUZHTlF2NFlFWWRyYzhuUWVZaWxDbmY5UXA0VTc5OGgzc3BOOVdaUm9DcXNv?=
 =?utf-8?B?R0lKYmkxd0VaZi9ndGd2cDZuakZHcmtoUUlTcVZINWRJNWFoM1ZJRU11N1g5?=
 =?utf-8?B?NkN6YUIzSWw1QUR5MUVnb2xJbVlTbEt2b1ZSdk1DOWRHN0J3bHo3ZnM2Z2dz?=
 =?utf-8?B?ZmpYNnd1cDdKRjZvUUNjZUNuWERTRndhUXZZR3lXMndsSnNaSDJmNVBDNHYz?=
 =?utf-8?B?RncvcWFTdlF5N2VsaXY0ZHUvbVVYWmVWc3BsblM2Mkc2ZkFFSmRWZTZhdkpU?=
 =?utf-8?B?WkcvK2Fub1RqamhhcjVIU0hoaXZqN2NPRm4yVGhndG55N3B2OGxoeitYZ0gw?=
 =?utf-8?B?UVVLdlBVN0cvOHFwV3RFMzZuRDhnZS9weTdNSngzL0V5WXp4aHFoL3lWQ3dC?=
 =?utf-8?B?dG56UU1DUWVtKy8xYmhqakRxU0ZmWFZZQktZb0cxTHJjYVdlMlJJZmo4UlZQ?=
 =?utf-8?B?QW1iM1lLNDZqY2RyL2ltTk1zSFVlaEpvZXduU0tQSjhOa2RtZUtCWFIvQU1w?=
 =?utf-8?B?S3dzNzNiL1ZNcnlyTGdqZDI3Q3lRMW05eVVDcjlHUWt6QzhNMW03QU5jVENF?=
 =?utf-8?B?cEs0dmR3ZDFPZU5YTzc3eGx6dmM0QnpSUzhCaUtQSmUreW85bGhNYnFOaUNk?=
 =?utf-8?B?VXE5NXFDYkJqRjY0cWxSbjBWRlBjdmhibDVJRVFkYVhkTnZmUm9WWWRPVFd5?=
 =?utf-8?B?ZXUwRmE5WDNEcUkwY2R4WktYamVrVGlnc1BvZFFka2ZvaDlVbDREb1BWS2Vx?=
 =?utf-8?B?RDZCeEo2V2V2dHhVaW1lclpiTWdWaVdXKzQvUWFNVmV4NGRSTUpCM25ra2J4?=
 =?utf-8?B?anlWYzgxaytlRGtIMkVPZUhRK0dxOCsyZlVXRnZ3d0plTkVFVzJ0Y0RJbDE4?=
 =?utf-8?B?YkNLTDc2ZUNGYnBvYXUxV0lSc2hOTGFVT1BrbHVJbHRjU3AxY2ZtcWdrV3VW?=
 =?utf-8?B?dUxZV0dUWUNBRnYxWE9taGRVelFvT284NmhpdGJxZ2FXTThFNkU5di9TUEJl?=
 =?utf-8?B?cTVrd0o3ZlZiUmZuU3IzZC9ZYzRGRUgrczJuTjJadE1LK2ZwaGtBUHpzQWpY?=
 =?utf-8?B?TkFDVXdkK3pHbHhZNjNEbUtVblBJelc5c0hSRUdGWHFiM1VZcm4xOG4rUW5D?=
 =?utf-8?B?eEZQck9SSFFhQ0l5ZTdGenJKTC94UFM5TUlBZ21DR3BuQVc3U2ZFVkNxQnVv?=
 =?utf-8?B?dmJWNVc5Sjl3dHJnM0grUFhSbGUvd24rOERkMGpUN3dha0xRTnRBdHlscVNR?=
 =?utf-8?B?TFJaNStHNGRoeS9jM2Z2d1hRMVJSVmRkY20xVUdjTEhNUnFsUVJxcnBxVXVL?=
 =?utf-8?B?S2RGWFhDY3N0Y1N0TS9kdlRZeGg1MHRPMkJMVHpzM1gvbDluaTUrY3crN3pv?=
 =?utf-8?B?cDk1NHBkQlhrVWZKOWxwUUhQK2xFb3NldTJiZmk2aE91SzkxdUIwVmpNcWlz?=
 =?utf-8?B?dVJQblY5RDVPUEN1V1J2Z05yTnFEcmpJYkw5dTdrTkhUUjZqNW0wOXBmVUwr?=
 =?utf-8?B?VTI4VDB6czhlRHNPUEtva21GWnBWcTEvcTRCZGRaZytEYXpOQWh3WDJNU00r?=
 =?utf-8?B?QTlveGRkUUhCYkZja1FWSjdyTy9sck83QVJ3K3NaKytObS9UK1lqbis4ZUxR?=
 =?utf-8?B?eHdsUHRDbnE0ZExGT3BFaVU0UjVqNTZVQ3REQ282Z21hUnRMVFpEVS9IVkx5?=
 =?utf-8?B?bUdVekU3VE1Bd1I1aWtJQk8rcVE1UUVKNVhoWUIyb3l1cjh0cWRjZUhDOTdi?=
 =?utf-8?B?dEYwaGdmcElQV3N4YUJOcklFL2xtTWY4RU82SFFMQUVnSDM1OGRoTlNrVE53?=
 =?utf-8?B?RFlNcWtXTDQwYjhyTHMxYk1WZ3hsaFdjdGVZUElPMklwbFlhRkJRRUs5eGQ5?=
 =?utf-8?B?YWJkdTFHVVdaaWZKdFAvVms4WTRTRnUzQ3V0R09kQUc5MUhXZjRlM3A0L1Ey?=
 =?utf-8?B?K3hYTzFSV3o5N3hMVW9FNktwMmVhcUhYSGJJbDQ2Qm96eWxlWWkvZHhzU25Z?=
 =?utf-8?B?ZVdPdW5BWEtEaHV3SWlhbmFrREpiTnpXOXZsdC9YL0RPUnBJMlFYby9EVnI3?=
 =?utf-8?B?dlhOYVZxU1lCK0xwOHgvdlZtRVBjUVBCZGloMzZibVFndi9sKytDM3gzeUs2?=
 =?utf-8?B?RGcyUHRqQ2Z0TjIwNjg3cW5qT2oxVkk4U3drVUt3aWRwWDF3bUZyRFNtMnBL?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6132F3838DFDA9418400C0EA746610AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6056114d-e95a-425c-bc7d-08db49a4d185
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2023 18:00:44.1149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oYkU00jXHMHUTX6OiDjUKhEctCPc0Vz1u/zQ0cv1LF5wyqltdwnZ7fLWWJzowslLNEfR4JVci1z3QQ1qY69h83tOHkfGnmPLAgUHc6HMwNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6350
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

T24gU3VuLCAyMDIzLTA0LTMwIGF0IDE3OjA2ICswMDAwLCBHcmVlbm1hbiwgR3JlZ29yeSB3cm90
ZToNCj4gT24gU3VuLCAyMDIzLTA0LTMwIGF0IDE4OjU4ICswODAwLCBKZWZmIENodWEgd3JvdGU6
DQo+ID4gT24gU3VuLCBBcHIgMzAsIDIwMjMgYXQgMjoxN+KAr0FNIEplZmYgQ2h1YSA8amVmZi5j
aHVhLmxpbnV4QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9uIFNhdCwgQXByIDI5
LCAyMDIzIGF0IDEwOjA34oCvUE0gQmFnYXMgU2FuamF5YSA8YmFnYXNkb3RtZUBnbWFpbC5jb20+
IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gT24gU2F0LCBBcHIgMjksIDIwMjMgYXQgMDE6MjI6
MDNQTSArMDgwMCwgSmVmZiBDaHVhIHdyb3RlOg0KPiA+ID4gPiA+IENhbid0IHN0YXJ0IHdpZmkg
b24gbGF0ZXN0IGxpbnV4IGdpdCBwdWxsIC4uLiBzdGFydGVkIGhhcHBlbmluZyAzIGRheXMgYWdv
IC4uLg0KPiA+ID4gPiANCj4gPiA+ID4gQXJlIHlvdSB0ZXN0aW5nIG1haW5saW5lPw0KPiA+ID4g
DQo+ID4gPiBJJ20gcHVsbGluZyBmcm9tIGh0dHBzOi8vZ2l0aHViLmNvbS90b3J2YWxkcy9saW51
eC5naXQsIGN1cnJlbnRseSBhdCAuLi4NCj4gPiA+IA0KPiA+ID4gY29tbWl0IDFhZTc4YTE0NTE2
YjkzNzJlNGM5MGE4OWFjMjFiMjU5MzM5YTNhM2EgKEhFQUQgLT4gbWFzdGVyLA0KPiA+ID4gb3Jp
Z2luL21hc3Rlciwgb3JpZ2luL0hFQUQpDQo+ID4gPiBNZXJnZTogNGUxYzgwYWU1Y2Y0IDc0ZDc5
NzBmZWJmNw0KPiA+ID4gQXV0aG9yOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91
bmRhdGlvbi5vcmc+DQo+ID4gPiBEYXRlOsKgwqAgU2F0IEFwciAyOSAxMToxMDozOSAyMDIzIC0w
NzAwDQo+ID4gPiANCj4gPiA+ID4gQ2VydGFpbmx5IHlvdSBzaG91bGQgZG8gYmlzZWN0aW9uLg0K
PiA+ID4gDQo+ID4gPiBvaywgd2lsbCBkby4NCj4gPiANCj4gPiBCaXNlY3RlZCENCj4gPiANCj4g
PiBlZjNlZDMzZGZjOGYwZjFjODFjYTEwM2U2YjY4YjRmNzdlZTBhYjY1IGlzIHRoZSBmaXJzdCBi
YWQgY29tbWl0DQo+ID4gY29tbWl0IGVmM2VkMzNkZmM4ZjBmMWM4MWNhMTAzZTZiNjhiNGY3N2Vl
MGFiNjUNCj4gPiBBdXRob3I6IEdyZWdvcnkgR3JlZW5tYW4gPGdyZWdvcnkuZ3JlZW5tYW5AaW50
ZWwuY29tPg0KPiA+IERhdGU6wqDCoCBTdW4gQXByIDE2IDE1OjQ3OjMzIDIwMjMgKzAzMDANCj4g
PiANCj4gPiDCoMKgwqAgd2lmaTogaXdsd2lmaTogYnVtcCBGVyBBUEkgdG8gNzcgZm9yIEFYIGRl
dmljZXMNCj4gPiANCj4gPiDCoMKgwqAgU3RhcnQgc3VwcG9ydGluZyBBUEkgdmVyc2lvbiA3NyBm
b3IgQVggZGV2aWNlcy4NCj4gPiANCj4gPiDCoMKgwqAgU2lnbmVkLW9mZi1ieTogR3JlZ29yeSBH
cmVlbm1hbiA8Z3JlZ29yeS5ncmVlbm1hbkBpbnRlbC5jb20+DQo+ID4gwqDCoMKgIExpbms6IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzA0MTYxNTQzMDEuZTUyMmNjZWZlMzU0LklmNzYy
ODM2M2ZhZmViNzY4NzE2MzEwM2U3MzQyMDY5MTVjNDQ1MTk3QGNoYW5nZWlkDQo+ID4gwqDCoMKg
IFNpZ25lZC1vZmYtYnk6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPg0K
PiA+IA0KPiA+IMKgZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9jZmcvMjIwMDAu
YyB8IDIgKy0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlv
bigtKQ0KPiA+IA0KPiA+IA0KPiA+IEkgaGFkIHRvIGRvd25ncmFkZSBGVyBBUEkgdG8gNzUgdG8g
bWFrZSBpdCB3b3JrIGFnYWluIQ0KPiA+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2ludGVsL2l3bHdpZmkvY2ZnLzIyMDAwLmPCoMKgwqAgMjAyMy0wNC0zMA0KPiA+IDE4OjI3OjIx
LjcxOTk4MzUwNSArMDgwMA0KPiA+ICsrKyBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3
bHdpZmkvY2ZnLzIyMDAwLmPCoMKgwqAgMjAyMy0wNC0zMA0KPiA+IDE4OjI3OjI1Ljc0OTk4MzQ0
NiArMDgwMA0KPiA+IEBAIC0xMCw3ICsxMCw3IEBADQo+ID4gwqAjaW5jbHVkZSAiZncvYXBpL3R4
cS5oIg0KPiA+IA0KPiA+IMKgLyogSGlnaGVzdCBmaXJtd2FyZSBBUEkgdmVyc2lvbiBzdXBwb3J0
ZWQgKi8NCj4gPiAtI2RlZmluZSBJV0xfMjIwMDBfVUNPREVfQVBJX01BWMKgwqDCoMKgwqDCoMKg
IDc4DQo+ID4gKyNkZWZpbmUgSVdMXzIyMDAwX1VDT0RFX0FQSV9NQVjCoMKgwqDCoMKgwqDCoCA3
NQ0KPiA+IA0KPiA+IMKgLyogTG93ZXN0IGZpcm13YXJlIEFQSSB2ZXJzaW9uIHN1cHBvcnRlZCAq
Lw0KPiA+IMKgI2RlZmluZSBJV0xfMjIwMDBfVUNPREVfQVBJX01JTsKgwqDCoMKgwqDCoMKgIDM5
DQo+ID4gDQo+ID4gDQo+ID4gTXkgaC93IGlzIExlbm92byBYMSB3aXRoIC4uLg0KPiA+IA0KPiA+
IDAwOjE0LjMgTmV0d29yayBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiBBbGRlciBMYWtl
LVAgUENIIENOVmkNCj4gPiBXaUZpIChyZXYgMDEpDQo+ID4gDQo+ID4gDQo+ID4gSSd2ZSB0aGUg
Zm9sbG93aW5nIGZpcm13YXJlIC4uIEkndmUgdHJpZWQgNzcsIDc4LCA3OSwgODEgLi4gLmFsbCBu
b3Qgd29ya2luZw0KPiA+IA0KPiA+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgMTU2MDUzMiBNYXIg
MTQgMDg6MDUgaXdsd2lmaS1zby1hMC1nZi1hMC03Mi51Y29kZQ0KPiA+IC1ydy1yLS1yLS0gMSBy
b290IHJvb3QgMTU2MzY5MiBNYXLCoCA2IDE0OjA3IGl3bHdpZmktc28tYTAtZ2YtYTAtNzMudWNv
ZGUNCj4gPiAtcnctci0tci0tIDEgcm9vdCByb290IDE1Nzc0NjAgTWFyIDE0IDA4OjA1IGl3bHdp
Zmktc28tYTAtZ2YtYTAtNzQudWNvZGUNCj4gPiAtcnctci0tci0tIDEgcm9vdCByb290IDE2NDEy
NjAgTWFywqAgNiAxNDowNyBpd2x3aWZpLXNvLWEwLWdmLWEwLTc3LnVjb2RlDQo+ID4gLXJ3LXIt
LXItLSAxIHJvb3Qgcm9vdCAxNjY3MjM2IE1hcsKgIDYgMTQ6MDcgaXdsd2lmaS1zby1hMC1nZi1h
MC03OC51Y29kZQ0KPiA+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgMTY3Mjk4OCBNYXLCoCA2IDE0
OjA3IGl3bHdpZmktc28tYTAtZ2YtYTAtNzkudWNvZGUNCj4gPiAtcnctci0tci0tIDEgcm9vdCBy
b290IDE2ODI4NTIgQXBywqAgNSAwODoyMiBpd2x3aWZpLXNvLWEwLWdmLWEwLTgxLnVjb2RlDQo+
ID4gDQo+ID4gDQo+ID4gIyB3b3JraW5nIGRtZXNnIGF0dGFjaGVkIC4uLg0KPiA+IGNmZzgwMjEx
OiBMb2FkaW5nIGNvbXBpbGVkLWluIFguNTA5IGNlcnRpZmljYXRlcyBmb3IgcmVndWxhdG9yeSBk
YXRhYmFzZQ0KPiA+IExvYWRlZCBYLjUwOSBjZXJ0ICdzZm9yc2hlZTogMDBiMjhkZGY0N2FlZjlj
ZWE3Jw0KPiA+IGl3bHdpZmkgMDAwMDowMDoxNC4zOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4g
MDAwMikNCj4gPiBpd2x3aWZpIDAwMDA6MDA6MTQuMzogRGlyZWN0IGZpcm13YXJlIGxvYWQgZm9y
DQo+ID4gaXdsd2lmaS1zby1hMC1nZi1hMC03NS51Y29kZSBmYWlsZWQgd2l0aCBlcnJvciAtMg0K
PiA+IGl3bHdpZmkgMDAwMDowMDoxNC4zOiBhcGkgZmxhZ3MgaW5kZXggMiBsYXJnZXIgdGhhbiBz
dXBwb3J0ZWQgYnkgZHJpdmVyDQo+ID4gdGhlcm1hbCB0aGVybWFsX3pvbmUxOiBmYWlsZWQgdG8g
cmVhZCBvdXQgdGhlcm1hbCB6b25lICgtNjEpDQo+ID4gaXdsd2lmaSAwMDAwOjAwOjE0LjM6IFNv
cnJ5IC0gZGVidWcgYnVmZmVyIGlzIG9ubHkgNDA5Nksgd2hpbGUgeW91DQo+ID4gcmVxdWVzdGVk
IDY1NTM2Sw0KPiANCj4gU3RyYW5nZWx5LCBJIGNvdWxkbid0IHJlcHJvZHVjZSBpdCBvbiBteSBz
eXN0ZW0uIEJ1dCwgYW55d2F5IHRoaXMgZmVhdHVyZQ0KPiBiZXR0ZXIgYmUgZGlzYWJsZWQgZm9y
IGEgd2hpbGUuIEknbGwgc2VuZCBhIHBhdGNoIHdpdGggYSBmaXggc2hvcnRseS4NCk1heSBJIGFz
ayB5b3UgdG8gdHJ5IHRoaXMgZml4IGluIFsxXSAoYWxzbyBjYy1lZCB5b3Ugb24gdGhlIHBhdGNo
IGl0c2VsZik/DQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC13aXJlbGVzcy8y
MDIzMDQzMDIwMTgzMC4yZjhmODhmZTQ5ZjYuSTJmMDA3NmVmMWQxY2JlNWQxMDAxMDU0OWM4NzVi
NzAzOGVjNGMzNjVAY2hhbmdlaWQvDQo=
