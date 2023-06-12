Return-Path: <netdev+bounces-9963-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E128172B75D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53EE3281097
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 05:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708B41FC1;
	Mon, 12 Jun 2023 05:34:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E3E1C06
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:34:20 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36EB9B
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 22:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686548058; x=1718084058;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CUHc+Q099AZqWMWSL4lH22Z2AIrTQeW58nynkfaAveo=;
  b=na3QbtjUh/RTBzvdPydDfK4fbj95H70UaPuOjvwZem3nt/Yn54SFLzDW
   kYtzDh4snRpg2HFGs5pmCXHJhxI2C4zXNRLJBL/hvKVeLoH/qHax1aFox
   YZpuD2XEmoxP4PmeTqhL0a5WrxZ/hEzjXz1f4aOj3KbNWsGT6H4v9ICBa
   UAcTmPY1uvq4k9Q9kDdANmMJVFqLmmQTACpwqtgHjNBQN6uyowO4Q4oG8
   qXYAkjKtsTcX+1gw7NgUR763QWfqIL+TXwVeORWgSnilxPxv7PJ0HxZ5C
   tVDq7Ht06PZYEjsJ70dfsCMnspZGqKAvc664JGLVZyRZue/4DEjMJzdkG
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="360433361"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="360433361"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 22:34:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="823837137"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="823837137"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jun 2023 22:34:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 22:34:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 22:34:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 22:34:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 22:34:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hma/mQyHdeLFw3uHyztmMwKdeb5R2fGww1sM4TRtJ4COlhEnGfouLnnq3mBm0tlMLJT+8qtPUn/rhoJbobHbRwX93s12Q5uXH4fzGFRANFD6jYAMtYbk0oKPS2+iaASZ+tItbO9Qiev7WGVRnx8ZKZgSdBZRHzJLs+rBfbB/3u9Hov1Ax51+xkX7pRJDTVUxn903+Ru2aOnh2rceOwpiuhni4Toph14WkKrhqenBJQfgS1T8OjwesWTM9+7mm9ZFcOiFwg8Blgs3wPRaNNoEkqClsAE+rsVYMAuAmS4Keon+pe5QQNR7p4gubtlcAQgPCsBOueGAKyVwTCIwbUevbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUHc+Q099AZqWMWSL4lH22Z2AIrTQeW58nynkfaAveo=;
 b=f5MAa/Q5ui1NJnIf+NLx421KLIHfVzB2SMTS3NXkYlKGCPuXoahgLpq93XdSuNqGO6PqMSOe2l5Nrj+ye19Eb/4/jw0leNWdre0TJ9Yt5wcNhCLhS+WIk/5BPoHpcpv1I21LjqdSKDgjKfZmRqbsJWE79CHXkpTNJfnuNtyqzEQPHALsrMPQvsA+nV3J3YTn1LbUsRn2wffETtwyga9HcJehqguCDVojXtAV2J4aOkmkk7rJ2X+eW87CL3jFTsfi4WHQOeGz5viY0aapj2GE5XDxy34CxDxfie1wRClDFxvcUz9QJvTjy7LITQXEz3FcsVxRiOyEMHk2AQTJNp7HZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB6424.namprd11.prod.outlook.com (2603:10b6:8:c4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Mon, 12 Jun 2023 05:34:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.039; Mon, 12 Jun 2023
 05:34:14 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Gal Pressman <gal@nvidia.com>, Stephen Hemminger
	<stephen@networkplumber.org>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@gmail.com>, Michal Kubecek <mkubecek@suse.cz>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Edwin Peer
	<edwin.peer@broadcom.com>, Edwin Peer <espeer@gmail.com>
Subject: RE: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
Thread-Topic: [PATCH net-next] rtnetlink: extend RTEXT_FILTER_SKIP_STATS to
 IFLA_VF_INFO
Thread-Index: AQHZnFLFyCwkhnsIik64F2MI+8/BhK+FtBKAgAAv8wCAAMAAgA==
Date: Mon, 12 Jun 2023 05:34:14 +0000
Message-ID: <CO1PR11MB50899E098BB3FFE0DE322222D654A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230611105108.122586-1-gal@nvidia.com>
 <20230611080655.35702d7a@hermes.local>
 <9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
In-Reply-To: <9b59a933-0457-b9f2-a0da-9b764223c250@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DS0PR11MB6424:EE_
x-ms-office365-filtering-correlation-id: c57426cb-435f-4618-2294-08db6b06a891
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 42QQfEuNgwOFGeZJsczD1V/4whPwjLAXHwN/rBpspIOPXAwcFJt4YRx8z+Ga+mYpjKGeKBEG6/F0dsLDPG7QwGROTXyP+QAkDOzp9vXn+/O13Z1OQ1aB7WqHcp1hXYuZS9Fc4n33x02rwqvPjGkFlWLHiry3ytUt12O3fxtINbmJAW/SCSyXbeYlYnl9fFVW6C8h+O99YjJrUlk5jvtqppXcU6WLtJy0y0byvQdTJzx3HjQvZ72KRrkwBxxoS+N++2DMm/Clt3Gm/kxYvU35HotZZLIprCnKk7BOjPCBK7yCpMmKaQ5nUTnn1bsLjKCQKceLGd7/Ktf5rQNP3CZIpX8ABe3a2MTroOS7xTT+EOGIx/HQGscaG0RoyWOr2C9nUSBg7TUUWc5esI9N0dl4I8yj6bNfJScSolDcIbD8I3SoVD7KoBwTlCxs/PABpgvgHgy3rhAlILsWBU+ON9hXcrEuTiMpvzMdnelZJ5QDCmHzROM0yges+oSMQeXY4geIZHJVDf/bNgrKCFRDu5KJI2EeTK1X2YAip6WDSeKvQwKvf2jJbJoS5V+98stmO9k0Iib3lOa3I6OKg1pDHIaVnIyPZXKchzrxyt9E6JGbzWA07AvGME0MGq48L1oj4jaZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(52536014)(64756008)(8676002)(76116006)(316002)(66476007)(66946007)(8936002)(4326008)(66446008)(2906002)(66556008)(41300700001)(5660300002)(110136005)(7696005)(71200400001)(54906003)(9686003)(26005)(53546011)(186003)(6506007)(83380400001)(38070700005)(478600001)(82960400001)(122000001)(55016003)(33656002)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0tpVEV5RUNWSmlyRGxEcUlzQ0tMdGJjL05iQ0k3WjB1M2FGbmQ1bXNwa2g3?=
 =?utf-8?B?cGtBeTZxeGtBc2NqZHFGZm84b2dHb0k4ZmlFNnlHaUNTNTg3SjVsVFlhRWhq?=
 =?utf-8?B?ZDdlTUh4MEFrUjVzOFlqSUtRL05aOHkyWGxhakRmWjVmRlBjc2IwTUc3d0lh?=
 =?utf-8?B?a1kzQXRVWGhXUlZYbHcxekQzdEx1L2toQy9KdXBmTW0vWXJ5WVF0cEF0aWdi?=
 =?utf-8?B?Rk9WQXZXR3RaSXdTTHAwYXZnOE56OG1yelI3UVVGbGRxQUJIbGNncUlFcEZM?=
 =?utf-8?B?Vnd0cXZIdE44QklKSU43eXYvNVd1aTVGRkN6ekFCYy9NWEluZE92a0xtdzgy?=
 =?utf-8?B?WkgrNUFKcVhsZUovZ25MMVZGVHZpZURYRGJURFg2K2JCaERsYUN4WER6WU9F?=
 =?utf-8?B?VWc1RjB4T1l4cndtdlFyeERxMyt2NjNWVDVHc0dSNzNGSTlOUFZ5ZXhZYm13?=
 =?utf-8?B?QS9KdWh0SmdnTlRhOEw0MnRVVXJpR3FWMVoyUzdHSEdrL0F0VGRUMTcrYmRK?=
 =?utf-8?B?ZGFkcDNxWTdCKzE4Q01hWUQ1YjNUVFlkSEhudXl6UkJiWHB0RXdhdGZpUFph?=
 =?utf-8?B?VDdBM3dTaTN0clMvNHYxRWoxaVBDZHY0bmV4Qk1SVHMwV1dtNDh2UFYyYXFa?=
 =?utf-8?B?OGtWSWdObEd6T0kxOHpFdnRkRlBKZE82bEl3dUhQUVV0cTBhRXNDcW04MjNo?=
 =?utf-8?B?c1hScVBRTE5DSlAvOXA1dDk0ZHVUQnZlUHdiR2ZnT1BpSmp0cFp6clExYjNB?=
 =?utf-8?B?N241RjBqYmZFcFQ5SXZWcjllQ3NUdjJpVTFhekxTSEU4QlFTc0RyV1VhSjRR?=
 =?utf-8?B?dzg1YkF0YmNsZjhqYlRwVm1ZTFF4RWxzZWZhYnRyQUhTdDhKVU9PbU1LZHRX?=
 =?utf-8?B?ajBaajRXVjd4WjVFTEJIMFRQKzFtVVA0bi80c3F1VEo3S29xZWRKL0tDZnNh?=
 =?utf-8?B?M2RIMU1RT3VjVTg3Unp6VzdCTDMyQThkcUQ2VWk1UkxuaVhneEF6L1Fyb0c2?=
 =?utf-8?B?SDdDS3ZuYTFUNnY2My9mQ0lyVFgyRGpXc0FoYmxrd25lbXlFcmFiQVk2VFVv?=
 =?utf-8?B?ajdkNzRzSVFleW5JOHZraHR2KzUzcmQ2MWtuZ0pubG1aOWp2RmxCOU4yTVI3?=
 =?utf-8?B?bFEyVDFldXlVQzNzcmF3aE53U0tSUkVsbUdHemh3bEZScHJmaGdDVmFjT2N2?=
 =?utf-8?B?YlVoYXR6ZXJNS0d0T3ZEdlFpdnhGQURGVWdzVXlPUDJYY2VwZlFTV0krUlA5?=
 =?utf-8?B?MXhYa2tuQ01yRXRsYllVb1lVNVpXaGRhRFk0WFp4YzBiZ2JGeTdLUHlGdnIr?=
 =?utf-8?B?VFhyREJKdDEwU3lQV21STUdLdWM0ZU9jMjloYU1RSExYQlNlS0w4czAydUNu?=
 =?utf-8?B?aWtJeWtnemxwRjE5blhEUFZhT1RuVVdvU3ZaWSs1dkVKYVcwN2VJT0JQelN2?=
 =?utf-8?B?bU1RdVZPRm9JaitpS2V0WjVhdW14YUdQVnJlM1JIcHh4SjhSOEkrS1VBTzNs?=
 =?utf-8?B?TzlQRnliczNYcHBhOGtId1R6N0Y2UHl1QWp3bFJXdU1SSUJxNjc5cEMvRmo3?=
 =?utf-8?B?L20yOEQ0VUJZRkhkNFNxRTBJdVJDUWF1QVZKL1ZOMnZ5WWFMMGR1T0pzc0Qy?=
 =?utf-8?B?RnFzMzJjWWJhRU1hWFJ2VS9oQWwvQld2Z2xYWmdJRzhZTEk2ZGk1LzluSkV0?=
 =?utf-8?B?M0tIaWU0Q05MY3ZISE5CWWpVenYvcU9DYzdjNjJscndJRHEzUHhUdXovTnJQ?=
 =?utf-8?B?OS93czVzdVVjL0hsdFkramtndjE2R2RuSHZkZHdwODBqQTZhQXl0eHQ1MnYv?=
 =?utf-8?B?cExXZjRWUHcwZ0dIc2pLWU90Ty9CRFpMdlBob2hxaWo1V242ampEYlhPNFJv?=
 =?utf-8?B?WkZQSklMSHJ6VzdvRC9LejVHV0NXQTEySmN4Yll0OVA3dURxQjhSVlN1dHVL?=
 =?utf-8?B?ZjRLVGZyVzRmMjZRNkY3K2ZEMzlkK1JleW1VdzNpblFLRmpVTHpCSGtndnBz?=
 =?utf-8?B?NjRjUmFoZnRnVGZhRVVoWnZNaXZpOVh6YVFOWXdTNlBlYWJQZVdKVmpLeENG?=
 =?utf-8?B?T0ZxeVRoc3dXaXBadUdlWUdOOStzTWVERVZKd2NPTUVEYTBLVUEwRzdGUmNR?=
 =?utf-8?Q?gUKZuqq4lyjoLw+n0jhk3P07s?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57426cb-435f-4618-2294-08db6b06a891
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 05:34:14.4988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpqbbBsXbV3rp5bI0fEJVldd+qPh/CceqY7B04sDglI9uTogDHlyixYFIqOolSYhMw5DHA6zlMLOaP/omdDBVOglvsCb/ZtHU8xYdbjPQAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogU3VuZGF5LCBKdW5lIDExLCAyMDIzIDEwOjU5IEFNDQo+
IFRvOiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+DQo+IENj
OiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8
a3ViYUBrZXJuZWwub3JnPjsNCj4gRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPjsgTWlj
aGFsIEt1YmVjZWsgPG1rdWJlY2VrQHN1c2UuY3o+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBFZHdpbiBQZWVyIDxlZHdpbi5wZWVyQGJyb2FkY29tLmNvbT47IEVkd2luIFBlZXINCj4gPGVz
cGVlckBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIHJ0bmV0bGlu
azogZXh0ZW5kIFJURVhUX0ZJTFRFUl9TS0lQX1NUQVRTIHRvDQo+IElGTEFfVkZfSU5GTw0KPiAN
Cj4gT24gMTEvMDYvMjAyMyAxODowNiwgU3RlcGhlbiBIZW1taW5nZXIgd3JvdGU6DQo+ID4gT24g
U3VuLCAxMSBKdW4gMjAyMyAxMzo1MTowOCArMDMwMA0KPiA+IEdhbCBQcmVzc21hbiA8Z2FsQG52
aWRpYS5jb20+IHdyb3RlOg0KPiA+DQo+ID4+IEZyb206IEVkd2luIFBlZXIgPGVkd2luLnBlZXJA
YnJvYWRjb20uY29tPg0KPiA+Pg0KPiA+PiBUaGlzIGZpbHRlciBhbHJlYWR5IGV4aXN0cyBmb3Ig
ZXhjbHVkaW5nIElQdjYgU05NUCBzdGF0cy4gRXh0ZW5kIGl0cw0KPiA+PiBkZWZpbml0aW9uIHRv
IGFsc28gZXhjbHVkZSBJRkxBX1ZGX0lORk8gc3RhdHMgaW4gUlRNX0dFVExJTksuDQo+ID4+DQo+
ID4+IFRoaXMgcGF0Y2ggY29uc3RpdHV0ZXMgYSBwYXJ0aWFsIGZpeCBmb3IgYSBuZXRsaW5rIGF0
dHJpYnV0ZSBuZXN0aW5nDQo+ID4+IG92ZXJmbG93IGJ1ZyBpbiBJRkxBX1ZGSU5GT19MSVNULiBC
eSBleGNsdWRpbmcgdGhlIHN0YXRzIHdoZW4gdGhlDQo+ID4+IHJlcXVlc3RlciBkb2Vzbid0IG5l
ZWQgdGhlbSwgdGhlIHRydW5jYXRpb24gb2YgdGhlIFZGIGxpc3QgaXMgYXZvaWRlZC4NCj4gPj4N
Cj4gPj4gV2hpbGUgaXQgd2FzIHRlY2huaWNhbGx5IG9ubHkgdGhlIHN0YXRzIGFkZGVkIGluIGNv
bW1pdCBjNWE5ZjZmMGFiNDANCj4gPj4gKCJuZXQvY29yZTogQWRkIGRyb3AgY291bnRlcnMgdG8g
VkYgc3RhdGlzdGljcyIpIGJyZWFraW5nIHRoZSBjYW1lbCdzDQo+ID4+IGJhY2ssIHRoZSBhcHBy
ZWNpYWJsZSBzaXplIG9mIHRoZSBzdGF0cyBkYXRhIHNob3VsZCBuZXZlciBoYXZlIGJlZW4NCj4g
Pj4gaW5jbHVkZWQgd2l0aG91dCBkdWUgY29uc2lkZXJhdGlvbiBmb3IgdGhlIG1heGltdW0gbnVt
YmVyIG9mIFZGcw0KPiA+PiBzdXBwb3J0ZWQgYnkgUENJLg0KPiA+Pg0KPiA+PiBGaXhlczogM2I3
NjZjZDgzMjMyICgibmV0L2NvcmU6IEFkZCByZWFkaW5nIFZGIHN0YXRpc3RpY3MgdGhyb3VnaCB0
aGUgUEYNCj4gbmV0ZGV2aWNlIikNCj4gPj4gRml4ZXM6IGM1YTlmNmYwYWI0MCAoIm5ldC9jb3Jl
OiBBZGQgZHJvcCBjb3VudGVycyB0byBWRiBzdGF0aXN0aWNzIikNCj4gPj4gU2lnbmVkLW9mZi1i
eTogRWR3aW4gUGVlciA8ZWR3aW4ucGVlckBicm9hZGNvbS5jb20+DQo+ID4+IENjOiBFZHdpbiBQ
ZWVyIDxlc3BlZXJAZ21haWwuY29tPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBHYWwgUHJlc3NtYW4g
PGdhbEBudmlkaWEuY29tPg0KPiA+PiAtLS0NCj4gPg0KPiA+IEJldHRlciBidXQgaXQgaXMgc3Rp
bGwgcG9zc2libGUgdG8gY3JlYXRlIHRvbyBtYW55IFZGJ3MgdGhhdCB0aGUgcmVzcG9uc2UNCj4g
PiB3b24ndCBmaXQuDQo+IA0KPiBDb3JyZWN0LCBubyBhcmd1ZXMgaGVyZS4NCj4gSXQgYWxsb3dl
ZCBtZSB0byBzZWUgYXJvdW5kIH4yMDAgVkZzIGluc3RlYWQgb2YgfjcwLCBhIHN0ZXAgaW4gdGhl
IHJpZ2h0DQo+IGRpcmVjdGlvbi4NCg0KSSByZW1lbWJlciBpbnZlc3RpZ2F0aW5nIHRoaXMgYSBm
ZXcgeWVhcnMgYWdvIGFuZCB3ZSBoaXQgbGltaXRzIG9mIH4yMDAgdGhhdCB3ZXJlIGVzc2VudGlh
bGx5IHVuZml4YWJsZSB3aXRob3V0IGNyZWF0aW5nIGEgbmV3IEFQSSB0aGF0IGNhbiBzZXBhcmF0
ZSB0aGUgcmVwbHkgb3ZlciBtb3JlIHRoYW4gb25lIG1lc3NhZ2UuIFRoZSBWRiBpbmZvIGRhdGEg
d2FzIG5vdCBkZXNpZ25lZCBpbiB0aGUgY3VycmVudCBvcCB0byBhbGxvdyBwcm9jZXNzaW5nIG92
ZXIgbXVsdGlwbGUgbWVzc2FnZXMuIEl0IGFsc28gKHVuZm9ydHVuYXRlbHkpIGRvZXNuJ3QgcmVw
b3J0IGVycm9ycyBzbyBpdCBlbmRzIHVwIGp1c3QgdHJ1bmNhdGluZyBpbnN0ZWFkIG9mIHByb2R1
Y2luZyBhbiBlcnJvci4NCg0KRml4aW5nIHRoaXMgY29tcGxldGVseSBpcyBub24tdHJpdmlhbC4N
Cg0KVGhhbmtzLA0KSmFrZQ0K

