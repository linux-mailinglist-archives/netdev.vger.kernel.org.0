Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745036EDEFC
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjDYJS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjDYJSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:18:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75B335A1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682414298; x=1713950298;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=twESg/6lSVr2O3Wd23uEXU1c6VHSDZd6GAeENZctRH8=;
  b=KnK2ODUiPmccKwnk5iQ4/BxxL/5I5cOdIsbL2V7tNmfQRYdI+j2QJQRM
   ynTyTwKGxGqjRnKf85GY4eVAaUXSPI2qrVIRb2cEjjTQBIAu3il7e+NgU
   SKt3I0MJsIdDbKBN1gCgan8UXaVY513fK4xvQXXwdQWLdnF46vmZf/8Nc
   PQ51X/lPY1fCJkYd9D1WN8byK/K6HAoIchnx3teCHfIM6A7rlTq9oJ2Ig
   5QNoPy5jtlpJRvTtv+xwC1xz76v/Tr+WXRqf7X83b3dTIyoEzqUZ+RTY1
   1x3E3FUErUaUqp2RZ4CHxvomWV/fon0UYOWSBU9eqR7T+GZuZ4t20KYWo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335608579"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="335608579"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 02:18:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="693421227"
X-IronPort-AV: E=Sophos;i="5.99,225,1677571200"; 
   d="scan'208";a="693421227"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 25 Apr 2023 02:18:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 25 Apr 2023 02:18:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 25 Apr 2023 02:18:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 25 Apr 2023 02:17:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2NC0n6lXB9783+RPO05HYNCJZDw7cisbLIwQx9MlkStNA/ykXX6y8HTMxlmkFtZxK37Pv1LzC8iNF9E6by+OyzaF+HazmfYNJcfAZj7HblFn4jxUqm20KDH0s5UwZwkvpNnEHZT9OmVyQ4xmM5AbG4V2HMxsKFs6z4EaLLzlZl7qLrwA/RYwfYykd+MJHYHFEeSBm4ZOCMxOhprB3dBMuUjIRmcpkQ+NOnViw6fD05CfcZpt7dKP83pmGBli7yAPZaTT18Jbmox5tJWyd8OIciyuBDVUJmWgEcPqOXBkiLvLihbIWL3I1vbknp/aVv2jLN5NIVam8Vm/iJgJc+gJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twESg/6lSVr2O3Wd23uEXU1c6VHSDZd6GAeENZctRH8=;
 b=SPbT2AY/sqNcLPfGpX0XaU9USJ6nwG/LurVC2lgBgMXPeckMklGxq+5qkHupigdVLCcusr23rdzqbawmBwYiupJuZLagrKpxUjoC8rSLCmkUmDT0i/JNUIHhqqEZj9+GrnquEtw2SaF7NeGQ/uhZIwDAmrewIhU0G7o4LnAaNAa67OQ9xBbQ7a+4L0k9WlDTiPnxabY2VPqZgD0ViHBwq+qlmEzsgNhyTWEOCD+GG7kHepaJQnNM1HpOJ0gohuU3no3QxtWSyGVUKs/uTNt7PS8wQ+5bHM5HSpex0z68uDhXes/xwh5SlUv2MBVljCA7Z5CpfhRmU4mtRI7n0iMN9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SJ1PR11MB6108.namprd11.prod.outlook.com (2603:10b6:a03:489::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 09:17:37 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 09:17:36 +0000
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
Subject: RE: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Topic: [PATCH net-next 06/12] ice: Add guard rule when creating FDB in
 switchdev
Thread-Index: AQHZdFz0yKQvf74srUeucgetCSVNH687uWig
Date:   Tue, 25 Apr 2023 09:17:36 +0000
Message-ID: <MW4PR11MB5776FC269FE6CFAA5B0E73DDFD649@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-7-wojciech.drewek@intel.com>
 <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
In-Reply-To: <ab08efd8-3123-7560-0ef0-036dc156db9f@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|SJ1PR11MB6108:EE_
x-ms-office365-filtering-correlation-id: af6c949e-df8b-4ea0-e8c3-08db456de92c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PdSboxlLeybm8Rek4wurVO9gDGO7kYBgyW0nNgS9zNlhp9gCL+OqV3bZV5h64P96T0KcNS/vg2OzpI1zv3xW7eWSOxDXvHaqJkptJANrkZOnDwfnsSa3D6lyZljqLRN/6wwjz7CzVKhn4DIaDBA1UZ2ocZ9AwKHz1eGdeYY3ExRICaleA6VZbUgfuDhaPaWT0E3/FVEGoF1JrMxFM/9tUX4w+dMEairN2HbDEFIFeIKpb7YYifvZI7u4c3GSjkHStkhGtRwlcg8lkExRtyrr0qNz7ScjZEc/JqgMbj94ogGQWPddHcmE0/W/AU/1PIE7ZmlqSu+yEQ28WnFdvTM9MMo4wmOHHDq/IIgfB+VEHlKRvs5BxBhErMBpzy9o/+2IOIZ/gyKPTz4ADPoiAOh5mUJc0XPgL8QI38ehrEwA6e0M6UIEncq56Df+/BFAWYgQSPgCFEEVhZFvmla2N4CryddfhpfEqNdnBWsahyddAnIFG1ULUk+d9UbhHli9OtHXLTIdCZxRq90yCYoqJrUdjMt5jhMt71pogD/dw+jcqo6KPxND1JM3r/btoSFvd9WoQ51nKotpMqVj5e/u3qw5yhUYMNjJPBlxGE7ErqofyiNrJd26A5KEpIza7jiKyNsr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(54906003)(6636002)(86362001)(186003)(53546011)(26005)(9686003)(6506007)(55016003)(33656002)(71200400001)(4326008)(66446008)(66476007)(66556008)(64756008)(316002)(82960400001)(66946007)(83380400001)(76116006)(2906002)(38100700002)(8676002)(122000001)(41300700001)(6862004)(38070700005)(7696005)(5660300002)(8936002)(66574015)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dksxcEVOd29nTlFvd0NmUTVxN1Q2RVdoZmJ5VmNTdThVRFUrcTZ5d3BXSU5N?=
 =?utf-8?B?NFI2YnZNWkNUQVNaV05PeWtHRk5Fd0RGM0dWL3QxcEk4QkdXeStoU3dvek04?=
 =?utf-8?B?OUxLTG9XZmdXUHl5VWJtMkR0d3ZuNmNCL1B1NlRkM2RTeElBOU91aERtd1NW?=
 =?utf-8?B?QXlKbDFyNWJlTldrRStvYjN5ZDhJRSsvbkUxYWo0S0VGVVVKRUs5U0owZjEx?=
 =?utf-8?B?djk0ZVU1ZVF2V1l0NVBJazhuVno5MXNwWWpqbFJIUlNhSDNsR2JleXNlcFFP?=
 =?utf-8?B?blViNWoxaEhJTks2cWZVVFVxN1NSaEVBT3p6S0x4S3BTd3JpY3k0VUVlUXpV?=
 =?utf-8?B?NDN6Z2MwS3cxVk5xMUFnMEZOUXRnQy8zVHNGSlU2SzdOVStEbk41OXI0UGEz?=
 =?utf-8?B?b3RkTXZMc3Y2QnUyQUxUMjRnMXM0ZldPVmQwR0dtUS9NYjNTWGhleG9sNTlO?=
 =?utf-8?B?WEFDSXF3SGcyTXdITFc5M0VFSlNGbW1Ja2dFK0ZML0xiMXZIYmxPNXU5N2pT?=
 =?utf-8?B?cHFGQzZJdnhlL0hieHNxVmJsYlhGWis5cHM2Wi95aEthOG5vNVlFcXdyUktx?=
 =?utf-8?B?UFpCRHkyTlNDcVB1Z2EzLzBsUGZjN0x3am43bi8rK2lnQzNrcFZEU05PSWVK?=
 =?utf-8?B?VndPanV1RGNNcFRhdlZGckhWYjRHS003ZGN5VXh4dWh2QndCK1VDclVUVDRz?=
 =?utf-8?B?dmZlcVhPZzhuOU9QMklsREFIMm0veUF0eUdwam0xRVFuNmNseDFmaU5mVExT?=
 =?utf-8?B?OFZXOEE4T0NlTkN6QnM2UDBtUHRyTDA1VFh6b2tsSFRxTUoxdUc5OU1UMCtx?=
 =?utf-8?B?TjQwY2I2LzJ0Q1NJdGt6RlhIWUFBdERzN2ZjdE0zdDNLaEU0V0ZEZEc1dUxU?=
 =?utf-8?B?cFBJTDlUV1NZSFlMb1pqV3NIZi8yVXhYTTFRZUtGMnlGSUxPYkFKYTc3Z01E?=
 =?utf-8?B?eEZhWm5HY3F6QjJjOTJRaFN0UitZNmJkdVRacDdReWEzVm1VRmFoNlNjby8r?=
 =?utf-8?B?UVNwcHlXVC9rNTVxUWRSclFqWUdFa0xTdGlMK3lsTEtDRmx1dGVPVVdiOUdC?=
 =?utf-8?B?UmxIemNQSTRsMHhiL0ZHUEkvV2psQTlXUGFxZmtWUkxmdmozSXVPRWxhREtY?=
 =?utf-8?B?ZlRiT3FXQ0NuMUJmWm0ySVVjREt5WkEvQ1RvcG54YkRhRXZWdXVFdjdOc05Z?=
 =?utf-8?B?RnJ4N3ovaDBGb29DbjNGWmJxR0tmMnAwNzNMZVp2WDVXVXlwTVlSdXhlekRU?=
 =?utf-8?B?YU9GVzVjS29SQWIwZjgrUGRjTU9tZFU0MENLeGl2cFNPdmo0eDRHanMwUVZx?=
 =?utf-8?B?UVA3TlQwZ2ZYd1RmZ2lPYWoxb2luQVcyVFJ6NzdIbjlwTnFISlJTTzV6a0tk?=
 =?utf-8?B?Nk42NGQ5RzB4NCtjYXNadHM5aVZ3dnhhYXpHRTZJY1VWbGgvd3IvaElyV3hY?=
 =?utf-8?B?dmRLYWtJZFlEeTdweU56RE9LTkNVaGN5SlJ6ZjFEb05wR2dOTW1TemQ1eGpH?=
 =?utf-8?B?eFphbEhjaVYvWGJqeVpURlh4Q2tRclFpN1BWZTU3L25pQjBtSFZja3JOK1Mx?=
 =?utf-8?B?MmZybWZscTgzejZoWjVZZ1RUbWc0MUJOU2cxMkZPUyswdTJhSHBlWXhoL3Zo?=
 =?utf-8?B?QVdNSm90WDJtK2NBdlduWHoyU1laU3MvVUZqMlN3NG1iTkdYQ0tZNS9vWnBx?=
 =?utf-8?B?cWhjbW9abW51MUlTV01meVhhOEYzNmJEekRZZUtCR1hDb0ZhL1JjL21qU0hi?=
 =?utf-8?B?R3dYRnkvdlQ2bGwwR3pDZzE2a2dNeGxZNnErWXFVczRGTzI5SVdsMWZiVWFU?=
 =?utf-8?B?NC9KWTVJeG54QzM4RWs1YWgwemtNVXpFRVRSTTlqVWpZVEZiaWFGM1JXNUxz?=
 =?utf-8?B?cnZWcUpFVTFJRS9Nb25ISEhiT3NPVjBadDIwc3dxUnZMV3VoVU03YUc4L1Bi?=
 =?utf-8?B?aHgyNU1qano4ZDZTK1hkZ2M3dlM5b2hDZ0xwMzJXU2RsUTFRMS9uTDJ4WENy?=
 =?utf-8?B?YnhaZUhNMzdDUzlsWmd5MVMyRlNrUi9UcFBXZER6VmhFSHQySi9kc2hRTHZx?=
 =?utf-8?B?dHozVi94RW1sL29xNXZOVzlLTEVCZEQyNGFHMVMzUERreHdEQ0xVRHRYSHRK?=
 =?utf-8?Q?ARRbgaBL/pDU56wb9/kps05/M?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6c949e-df8b-4ea0-e8c3-08db456de92c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2023 09:17:36.8486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yixkS/CIx54jxmXflSaV+RBi9537WwLH5uPoU4V31hrR1lJs6caoRX76HKFWpS7f9eqd0co4KbzBJ89qONfGQLTdER57bBopXtt4UlRZNOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogcGnEhXRlaywgMjEg
a3dpZXRuaWEgMjAyMyAxNjoyMw0KPiBUbzogRHJld2VrLCBXb2pjaWVjaCA8d29qY2llY2guZHJl
d2VrQGludGVsLmNvbT4NCj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMb2Jha2luLCBBbGVrc2FuZGVyIDxhbGVrc2FuZGVyLmxv
YmFraW5AaW50ZWwuY29tPjsgRXJ0bWFuLCBEYXZpZCBNDQo+IDxkYXZpZC5tLmVydG1hbkBpbnRl
bC5jb20+OyBtaWNoYWwuc3dpYXRrb3dza2lAbGludXguaW50ZWwuY29tOyBtYXJjaW4uc3p5Y2lr
QGxpbnV4LmludGVsLmNvbTsgQ2htaWVsZXdza2ksIFBhd2VsDQo+IDxwYXdlbC5jaG1pZWxld3Nr
aUBpbnRlbC5jb20+OyBTYW11ZHJhbGEsIFNyaWRoYXIgPHNyaWRoYXIuc2FtdWRyYWxhQGludGVs
LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAwNi8xMl0gaWNlOiBBZGQgZ3Vh
cmQgcnVsZSB3aGVuIGNyZWF0aW5nIEZEQiBpbiBzd2l0Y2hkZXYNCj4gDQo+IEZyb206IFdvamNp
ZWNoIERyZXdlayA8d29qY2llY2guZHJld2VrQGludGVsLmNvbT4NCj4gRGF0ZTogTW9uLCAxNyBB
cHIgMjAyMyAxMTozNDowNiArMDIwMA0KPiANCj4gPiBGcm9tOiBNYXJjaW4gU3p5Y2lrIDxtYXJj
aW4uc3p5Y2lrQGludGVsLmNvbT4NCj4gPg0KPiA+IEludHJvZHVjZSBuZXcgImd1YXJkIiBydWxl
IHVwb24gRkRCIGVudHJ5IGNyZWF0aW9uLg0KPiA+DQo+ID4gSXQgbWF0Y2hlcyBvbiBzcmNfbWFj
LCBoYXMgdmFsaWQgYml0IHVuc2V0LCBhbGxvd19wYXNzX2wyIHNldA0KPiA+IGFuZCBoYXMgYSBu
b3AgYWN0aW9uLg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgaWNlX3J1bGVf
cXVlcnlfZGF0YSAqDQo+ID4gK2ljZV9lc3dpdGNoX2JyX2d1YXJkX3J1bGVfY3JlYXRlKHN0cnVj
dCBpY2VfaHcgKmh3LCB1MTYgdnNpX2lkeCwNCj4gPiArCQkJCSBjb25zdCB1bnNpZ25lZCBjaGFy
ICptYWMpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBpY2VfYWR2X3J1bGVfaW5mbyBydWxlX2luZm8g
PSB7IDAgfTsNCj4gPiArCXN0cnVjdCBpY2VfcnVsZV9xdWVyeV9kYXRhICpydWxlOw0KPiA+ICsJ
c3RydWN0IGljZV9hZHZfbGt1cF9lbGVtICpsaXN0Ow0KPiA+ICsJY29uc3QgdTE2IGxrdXBzX2Nu
dCA9IDE7DQo+ID4gKwlpbnQgZXJyOw0KPiANCj4gWW91IGNhbiBpbml0aWFsaXplIGl0IHdpdGgg
LSVFTk9NRU0gcmlnaHQgaGVyZSBpbiBvcmRlciB0by4uLg0KPiANCj4gPiArDQo+ID4gKwlydWxl
ID0ga3phbGxvYyhzaXplb2YoKnJ1bGUpLCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghcnVsZSkg
ew0KPiA+ICsJCWVyciA9IC1FTk9NRU07DQo+ID4gKwkJZ290byBlcnJfZXhpdDsNCj4gPiArCX0N
Cj4gPiArDQo+ID4gKwlsaXN0ID0ga2NhbGxvYyhsa3Vwc19jbnQsIHNpemVvZigqbGlzdCksIEdG
UF9BVE9NSUMpOw0KPiA+ICsJaWYgKCFsaXN0KSB7DQo+ID4gKwkJZXJyID0gLUVOT01FTTsNCj4g
PiArCQlnb3RvIGVycl9saXN0X2FsbG9jOw0KPiA+ICsJfQ0KPiANCj4gLi4ubWFrZSB0aG9zZSAy
IGlmcyBnb3RvLW9uZWxpbmVycyA6MyBBcy4uLg0KPiANCj4gPiArDQo+ID4gKwlsaXN0WzBdLnR5
cGUgPSBJQ0VfTUFDX09GT1M7DQo+ID4gKwlldGhlcl9hZGRyX2NvcHkobGlzdFswXS5oX3UuZXRo
X2hkci5zcmNfYWRkciwgbWFjKTsNCj4gPiArCWV0aF9icm9hZGNhc3RfYWRkcihsaXN0WzBdLm1f
dS5ldGhfaGRyLnNyY19hZGRyKTsNCj4gPiArDQo+ID4gKwlydWxlX2luZm8uYWxsb3dfcGFzc19s
MiA9IHRydWU7DQo+ID4gKwlydWxlX2luZm8uc3dfYWN0LnZzaV9oYW5kbGUgPSB2c2lfaWR4Ow0K
PiA+ICsJcnVsZV9pbmZvLnN3X2FjdC5mbHRyX2FjdCA9IElDRV9OT1A7DQo+ID4gKwlydWxlX2lu
Zm8ucHJpb3JpdHkgPSA1Ow0KPiA+ICsNCj4gPiArCWVyciA9IGljZV9hZGRfYWR2X3J1bGUoaHcs
IGxpc3QsIGxrdXBzX2NudCwgJnJ1bGVfaW5mbywgcnVsZSk7DQo+IA0KPiAuLi5pdCdzIG92ZXJ3
cml0dGVuIGhlcmUgYW55d2F5LCBzbyBpdCBpcyBzYWZlIHRvIGluaXQgaXQgd2l0aCBhbiBlcnJv
cg0KPiB2YWx1ZS4NCg0KTWFrZXMgc2Vuc2UsIHRoYW5rcy4NCg0KPiANCj4gPiArCWlmIChlcnIp
DQo+ID4gKwkJZ290byBlcnJfYWRkX3J1bGU7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHJ1bGU7DQo+
ID4gKw0KPiA+ICtlcnJfYWRkX3J1bGU6DQo+ID4gKwlrZnJlZShsaXN0KTsNCj4gPiArZXJyX2xp
c3RfYWxsb2M6DQo+ID4gKwlrZnJlZShydWxlKTsNCj4gPiArZXJyX2V4aXQ6DQo+ID4gKwlyZXR1
cm4gRVJSX1BUUihlcnIpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgc3RydWN0IGljZV9l
c3dfYnJfZmxvdyAqDQo+ID4gIGljZV9lc3dpdGNoX2JyX2Zsb3dfY3JlYXRlKHN0cnVjdCBkZXZp
Y2UgKmRldiwgc3RydWN0IGljZV9odyAqaHcsIHUxNiB2c2lfaWR4LA0KPiA+ICAJCQkgICBpbnQg
cG9ydF90eXBlLCBjb25zdCB1bnNpZ25lZCBjaGFyICptYWMpDQo+ID4gIHsNCj4gPiAtCXN0cnVj
dCBpY2VfcnVsZV9xdWVyeV9kYXRhICpmd2RfcnVsZTsNCj4gPiArCXN0cnVjdCBpY2VfcnVsZV9x
dWVyeV9kYXRhICpmd2RfcnVsZSwgKmd1YXJkX3J1bGU7DQo+ID4gIAlzdHJ1Y3QgaWNlX2Vzd19i
cl9mbG93ICpmbG93Ow0KPiA+ICAJaW50IGVycjsNCj4gPg0KPiA+IEBAIC0xNTUsMTAgKzIwMiwy
MiBAQCBpY2VfZXN3aXRjaF9icl9mbG93X2NyZWF0ZShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVj
dCBpY2VfaHcgKmh3LCB1MTYgdnNpX2lkeCwNCj4gPiAgCQlnb3RvIGVycl9md2RfcnVsZTsNCj4g
PiAgCX0NCj4gPg0KPiA+ICsJZ3VhcmRfcnVsZSA9IGljZV9lc3dpdGNoX2JyX2d1YXJkX3J1bGVf
Y3JlYXRlKGh3LCB2c2lfaWR4LCBtYWMpOw0KPiA+ICsJaWYgKElTX0VSUihndWFyZF9ydWxlKSkg
ew0KPiA+ICsJCWVyciA9IFBUUl9FUlIoZ3VhcmRfcnVsZSk7DQo+IA0KPiBBYWFoIG9rLCB0aGF0
J3Mgd2hhdCB5b3UgbWVhbnQgaW4gdGhlIHByZXZpb3VzIG1haWxzLiBJIHNlZSBub3cuDQo+IFlv
dSBjYW4gZWl0aGVyIGxlYXZlIGl0IGxpa2UgdGhhdCBvciB0aGVyZSdzIGFuIGFsdGVybmF0aXZl
IC0tIHBpY2sgdGhlDQo+IG9uZSB0aGF0IHlvdSBsaWtlIHRoZSBtb3N0Og0KPiANCj4gCWd1YXJk
X3J1bGUgPSBpY2VfZXN3aXRjaF8uLi4NCj4gCWVyciA9IFBUUl9FUlIoZ3VhcmRfcnVsZSk7DQo+
IAlpZiAoZXJyKSB7DQo+IAkJLi4uDQo+IA0KDQpJIGxpa2UgaXQsIGxlc3MgcHRyIDwtPiBtYWNy
b3MNCg0KPiA+ICsJCWRldl9lcnIoZGV2LCAiRmFpbGVkIHRvIGNyZWF0ZSBlc3dpdGNoIGJyaWRn
ZSAlc2dyZXNzIGd1YXJkIHJ1bGUsIGVycjogJWRcbiIsDQo+ID4gKwkJCXBvcnRfdHlwZSA9PSBJ
Q0VfRVNXSVRDSF9CUl9VUExJTktfUE9SVCA/ICJlIiA6ICJpbiIsDQo+ID4gKwkJCWVycik7DQo+
IA0KPiBZb3Ugc3RpbGwgY2FuIHByaW50IGl0IHZpYSAiJXBlIiArIEBndWFyZF9ydWxlIGluc3Rl
YWQgb2YgQGVyciA6cCAoc2FtZQ0KPiB3aXRoIEBmd2RfcnVsZSBhYm92ZSkNCj4gDQo+ID4gKwkJ
Z290byBlcnJfZ3VhcmRfcnVsZTsNCj4gPiArCX0NCj4gPiArDQo+ID4gIAlmbG93LT5md2RfcnVs
ZSA9IGZ3ZF9ydWxlOw0KPiA+ICsJZmxvdy0+Z3VhcmRfcnVsZSA9IGd1YXJkX3J1bGU7DQo+ID4N
Cj4gPiAgCXJldHVybiBmbG93Ow0KPiANCj4gWy4uLl0NCj4gDQo+ID4gQEAgLTQ2MjQsNyArNDYy
OCw3IEBAIHN0YXRpYyBzdHJ1Y3QgaWNlX3Byb3RvY29sX2VudHJ5IGljZV9wcm90X2lkX3RibFtJ
Q0VfUFJPVE9DT0xfTEFTVF0gPSB7DQo+ID4gICAqLw0KPiA+ICBzdGF0aWMgdTE2DQo+ID4gIGlj
ZV9maW5kX3JlY3Aoc3RydWN0IGljZV9odyAqaHcsIHN0cnVjdCBpY2VfcHJvdF9sa3VwX2V4dCAq
bGt1cF9leHRzLA0KPiA+IC0JICAgICAgZW51bSBpY2Vfc3dfdHVubmVsX3R5cGUgdHVuX3R5cGUp
DQo+ID4gKwkgICAgICBzdHJ1Y3QgaWNlX2Fkdl9ydWxlX2luZm8gKnJpbmZvKQ0KPiANCj4gQ2Fu
IGJlIGNvbnN0IEkgdGhpbms/DQoNCkFncmVlDQoNCj4gDQo+ID4gIHsNCj4gPiAgCWJvb2wgcmVm
cmVzaF9yZXF1aXJlZCA9IHRydWU7DQo+ID4gIAlzdHJ1Y3QgaWNlX3N3X3JlY2lwZSAqcmVjcDsN
Cj4gDQo+IFsuLi5dDQo+IA0KPiA+IEBAIC01MDc1LDYgKzUwODIsMTQgQEAgaWNlX2FkZF9zd19y
ZWNpcGUoc3RydWN0IGljZV9odyAqaHcsIHN0cnVjdCBpY2Vfc3dfcmVjaXBlICpybSwNCj4gPiAg
CQlzZXRfYml0KGJ1ZltyZWNwc10ucmVjaXBlX2luZHgsDQo+ID4gIAkJCSh1bnNpZ25lZCBsb25n
ICopYnVmW3JlY3BzXS5yZWNpcGVfYml0bWFwKTsNCj4gPiAgCQlidWZbcmVjcHNdLmNvbnRlbnQu
YWN0X2N0cmxfZndkX3ByaW9yaXR5ID0gcm0tPnByaW9yaXR5Ow0KPiA+ICsNCj4gPiArCQlpZiAo
cm0tPm5lZWRfcGFzc19sMikNCj4gPiArCQkJYnVmW3JlY3BzXS5jb250ZW50LmFjdF9jdHJsIHw9
DQo+ID4gKwkJCQlJQ0VfQVFfUkVDSVBFX0FDVF9ORUVEX1BBU1NfTDI7DQo+ID4gKw0KPiA+ICsJ
CWlmIChybS0+YWxsb3dfcGFzc19sMikNCj4gPiArCQkJYnVmW3JlY3BzXS5jb250ZW50LmFjdF9j
dHJsIHw9DQo+ID4gKwkJCQlJQ0VfQVFfUkVDSVBFX0FDVF9BTExPV19QQVNTX0wyOw0KPiANCj4g
SSBkb24ndCBsaWtlIHRoZXNlIGxpbmUgYnJlYWtzIDpzDQo+IA0KPiAJCXR5cGVfb2ZfY29udGVu
dCAqY29udDsNCj4gCQkuLi4NCj4gDQo+IAkJLyogQXMgZmFyIGFzIEkgY2FuIHNlZSwgaXQgY2Fu
IGJlIHVzZWQgYWJvdmUgYXMgd2VsbCAqLw0KPiAJCWNvbnQgPSAmYnVmW3JlY3BzXS5jb250ZW50
Ow0KPiANCj4gCQlpZiAocm0tPm5lZWRfcGFzc19sMikNCj4gCQkJY29udC0+YWN0X2N0cmwgfD0g
SUNFX0FRX1JFQ0lQRV9BQ1RfTkVFRF9QQVNTX0wyOw0KPiAJCWlmIChybS0+YWxsb3dfcGFzc19s
MikNCj4gCQkJY29udC0+YWN0X2N0cmwgfD0gSUNFX0FRX1JFQ0lQRV9BQ1RfQUxMT1dfUEFTU19M
MjsNCj4gDQo+ID4gIAkJcmVjcHMrKzsNCj4gPiAgCX0NCj4gPg0KPiANCj4gWy4uLl0NCj4gDQo+
ID4gQEAgLTYxNjYsNiArNjE5MCwxMSBAQCBpY2VfYWRkX2Fkdl9ydWxlKHN0cnVjdCBpY2VfaHcg
Kmh3LCBzdHJ1Y3QgaWNlX2Fkdl9sa3VwX2VsZW0gKmxrdXBzLA0KPiA+ICAJCWFjdCB8PSBJQ0Vf
U0lOR0xFX0FDVF9WU0lfRk9SV0FSRElORyB8IElDRV9TSU5HTEVfQUNUX0RST1AgfA0KPiA+ICAJ
CSAgICAgICBJQ0VfU0lOR0xFX0FDVF9WQUxJRF9CSVQ7DQo+ID4gIAkJYnJlYWs7DQo+ID4gKwlj
YXNlIElDRV9OT1A6DQo+ID4gKwkJYWN0IHw9IChyaW5mby0+c3dfYWN0LmZ3ZF9pZC5od192c2lf
aWQgPDwNCj4gPiArCQkJSUNFX1NJTkdMRV9BQ1RfVlNJX0lEX1MpICYgSUNFX1NJTkdMRV9BQ1Rf
VlNJX0lEX007DQo+IA0KPiBgRklFTERfUFJFUChJQ0VfU0lOR0xFX0FDVF9WU0lfSURfTSwgcmlu
Zm8tPnN3X2FjdC5md2RfaWQuaHdfdnNpX2lkKWA/DQo+IA0KPiA+ICsJCWFjdCAmPSB+SUNFX1NJ
TkdMRV9BQ1RfVkFMSURfQklUOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICAJZGVmYXVsdDoNCj4gPiAg
CQlzdGF0dXMgPSAtRUlPOw0KPiA+ICAJCWdvdG8gZXJyX2ljZV9hZGRfYWR2X3J1bGU7DQo+ID4g
QEAgLTY0NDYsNyArNjQ3NSw3IEBAIGljZV9yZW1fYWR2X3J1bGUoc3RydWN0IGljZV9odyAqaHcs
IHN0cnVjdCBpY2VfYWR2X2xrdXBfZWxlbSAqbGt1cHMsDQo+ID4gIAkJCXJldHVybiAtRUlPOw0K
PiA+ICAJfQ0KPiA+DQo+ID4gLQlyaWQgPSBpY2VfZmluZF9yZWNwKGh3LCAmbGt1cF9leHRzLCBy
aW5mby0+dHVuX3R5cGUpOw0KPiA+ICsJcmlkID0gaWNlX2ZpbmRfcmVjcChodywgJmxrdXBfZXh0
cywgcmluZm8pOw0KPiA+ICAJLyogSWYgZGlkIG5vdCBmaW5kIGEgcmVjaXBlIHRoYXQgbWF0Y2gg
dGhlIGV4aXN0aW5nIGNyaXRlcmlhICovDQo+ID4gIAlpZiAocmlkID09IElDRV9NQVhfTlVNX1JF
Q0lQRVMpDQo+ID4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vfc3dpdGNoLmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX3N3aXRjaC5oDQo+ID4gaW5kZXggYzg0YjU2ZmU4NGE1Li41ZWNjZTM5
Y2YxZjUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9zd2l0Y2guaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
c3dpdGNoLmgNCj4gPiBAQCAtMTkxLDYgKzE5MSw4IEBAIHN0cnVjdCBpY2VfYWR2X3J1bGVfaW5m
byB7DQo+ID4gIAl1MTYgdmxhbl90eXBlOw0KPiA+ICAJdTE2IGZsdHJfcnVsZV9pZDsNCj4gPiAg
CXUzMiBwcmlvcml0eTsNCj4gPiArCXU4IG5lZWRfcGFzc19sMjsNCj4gPiArCXU4IGFsbG93X3Bh
c3NfbDI7DQo+IA0KPiBUaGV5IGNhbiBiZSBlaXRoZXIgdHJ1ZSBvciBmYWxzZSwgbm90aGluZyBl
bHNlLCByaWdodD8gSSdkIG1ha2UgdGhlbQ0KPiBvY2N1cHkgMSBiaXQgcGVyIHZhciB0aGVuOg0K
DQpDb3JyZWN0DQoNCj4gDQo+IAl1MTYgbmVlZF9wYXNzX2wyOjE7DQo+IAl1MTYgYWxsb3dfcGFz
c19sMjoxOw0KPiAJdTE2IHNyY192c2k7DQo+IA0KPiArMTQgZnJlZSBiaXRzIGZvciBtb3JlIGZs
YWdzLCBubyBob2xlcyAoc3RhY2tlZCB3aXRoIDo6c3JjX3ZzaSkuDQo+IA0KPiA+ICAJdTE2IHNy
Y192c2k7DQo+ID4gIAlzdHJ1Y3QgaWNlX3N3X2FjdF9jdHJsIHN3X2FjdDsNCj4gPiAgCXN0cnVj
dCBpY2VfYWR2X3J1bGVfZmxhZ3NfaW5mbyBmbGFnc19pbmZvOw0KPiA+IEBAIC0yNTQsNiArMjU2
LDkgQEAgc3RydWN0IGljZV9zd19yZWNpcGUgew0KPiA+ICAJICovDQo+ID4gIAl1OCBwcmlvcml0
eTsNCj4gPg0KPiA+ICsJdTggbmVlZF9wYXNzX2wyOw0KPiA+ICsJdTggYWxsb3dfcGFzc19sMjsN
Cj4gDQo+IChzYW1lIHdpdGggYml0ZmllbGRzIGhlcmUsIGp1c3QgdXNlIHU4IDoxIGluc3RlYWQg
b2YgdTE2IGhlcmUgdG8gc3RhY2sNCj4gIHdpdGggOjpwcmlvcml0eSkNCj4gDQo+ID4gKw0KPiA+
ICAJc3RydWN0IGxpc3RfaGVhZCByZ19saXN0Ow0KPiANCj4gWy4uLl0NCj4gDQo+IFRoYW5rcywN
Cj4gT2xlaw0KDQo=
