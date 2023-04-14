Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2F16E1979
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 03:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDNBNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 21:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDNBNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 21:13:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A94530FE;
        Thu, 13 Apr 2023 18:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681434791; x=1712970791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VCI5DUGxh8ilz8LiajJPQ9HLoNgbFvIdHA3rnCglT/A=;
  b=Tru5UoRnXr0fJro6Zb7U42SPuRbOhuaqJbEi/YTPcvrwyGAPRbnDgDDF
   TkaXyAgBqbJCxLEN9jgdb9sy+40GSCUMcbSJ+9WiK2vXJO4vkWw39SN33
   9j4PhUSytPvBLT/qOdKBqMelkagRA6TA61g/fklN/BJasTWtnSGNKZdsY
   GL0pmhO2Jpqjncb/iwCKtNqgtnfJtYsyErvKdY6VllngWpQvEpGZPpMhZ
   LVRW0Xj9a7JbcF994h1oImfG8mAtoS6sEtL8w17DyS6mz0kpu7gfaRbbH
   rTmuDFUJz1C5sg0mOwUoNsvB2q4Odkknfkylgowe5zZ96RwTID3ElyJ9U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="407220618"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="407220618"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 18:10:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="800999413"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="800999413"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 13 Apr 2023 18:10:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 18:10:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 18:10:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 18:10:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 18:10:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+g+2svl6rIoJrJpIDJZivuskGoOnuMhKSrNOX2hT5fh3+z9/eiwnZnG+pMDpQOzJQIjAq+Z/e/pvy3PKRPwcZertPTmQePgtqXaOdhCJ5G+4LBwAW7aBxRz3wE66EdV0NcC0nYiGEXTTelkkz7zU+kb8IeMBwfbgUAvy/1aUtV6MViLfB4c6KVNTKBDfzyaxgBmuA6i6zr0zMTb+oLTVg3GDtIJOlMR/QW3Mv3jHsfgFl56YghlTh8zcVuZt1AIi46vLakx9kk0a2DfBdDDDE3n5fJkHm/W/ym95J4yjgaXbsY1FtGyTs7aFaijso+LqNvNNKBgnxLDcmzcSgpF2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCI5DUGxh8ilz8LiajJPQ9HLoNgbFvIdHA3rnCglT/A=;
 b=j7J7oiKpQTTfQ6enjHvvB6BVBZ6L0mjs2XHy4jqTaRS1cu+pvaZj4yZJ+gs6FoxzgZW+YgIwdx4iy0KeBHttlNeCQ2sZZJXgwf3Sx4yq5cLEZ+Ubz9ByoJBMaExFolOHUcFkPL0d6UmWcdQMUiYrtb6a91rHxuuwo+6aKKvOdolMvgKaI27bZjUW76FIZKXP0mF6g9tu5u90gO2QQdXVIa05UM8fwazEqwHSpydZ2hFU16BAwyhyG9e33uhI+gLX0JGSk1wsS8TY4B0gsXw76D/JkUmNhspCL2rRPhbAzmBnPmuf60KvZfL21dAQStGDcc+z1p1AWa2DgCfmhhLWLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by MN2PR11MB4614.namprd11.prod.outlook.com (2603:10b6:208:268::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 01:10:04 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::1c4e:86ae:810d:1fee%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 01:10:04 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Alexander Duyck" <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: RE: [PATCH net-next v4 1/3] net: stmmac: introduce wrapper for struct
 xdp_buff
Thread-Topic: [PATCH net-next v4 1/3] net: stmmac: introduce wrapper for
 struct xdp_buff
Thread-Index: AQHZbbfAhpk1/Yp8/E+PaSaWefAbMq8peg2AgACFhqA=
Date:   Fri, 14 Apr 2023 01:10:04 +0000
Message-ID: <PH0PR11MB58304F87C004D7B243131468D8999@PH0PR11MB5830.namprd11.prod.outlook.com>
References: <20230413032541.885238-1-yoong.siang.song@intel.com>
 <20230413032541.885238-2-yoong.siang.song@intel.com>
 <203ab7d9-3695-f734-92b5-503118444108@redhat.com>
In-Reply-To: <203ab7d9-3695-f734-92b5-503118444108@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5830:EE_|MN2PR11MB4614:EE_
x-ms-office365-filtering-correlation-id: 2adb0ead-15f2-4d0e-157f-08db3c84fab1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2YR+21GaqBGh7S+jIUp3NQvg7BiZ/Mri3wLCmKpJpnxd5SES1AsCrRD/wJwRJjd1WMVr17KQvXUKMHAINZZgpES0VxszD8evwl7lx5PSw7VLVIsQ1nCMSANi7y2Kg0RoCRLwHnKs2yiYO4BWJ6W1eM5PO46nMeeHFTHZ1Gbcde8eAOz+TZ8fcJYDL9nyIcR/8kiPHuhMCVdNI29JWHyjraclWEU1hZkSWu0KtuSG5gzyws18g4YyseS7gVPI/4cXTZZD/L/6Y6OIM+qtcdPFIxeqd7l4J1nU8zfLvj0c+AOwI/Cr5+uK/Db3ggFIfjhb/1Ye1f4JCJJy7SjmftUSSOR3ujF4XLQ7VzJ9zSoxMHULSCxGByVzDtPUIaCGWXmRCdqMIUlfGcVxxhT/UkkXvrhbx5jrNzzkGzYd/hQpzPxA/YiXarlRX5UOHDSASPU3ufPJVHwrn/586L7ekVbZkarqxI1v036o7W7CTKaRY7PWVighkH0x/SgHGkzdv5RYWAwzB2lX9Ao9P9sSDxUutoImCgFiQkKvCO+Zy9RtDPrvJ+/xqVfAJhxJpBlL4uShaF8vbJqkU6DSDUaFkVlC8TDcRV/6AvIAxLUtHsdRwuTc0DpB1IHZeb/riQPZiXoy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199021)(316002)(4326008)(38100700002)(64756008)(82960400001)(66446008)(66556008)(66946007)(66476007)(76116006)(5660300002)(41300700001)(52536014)(7696005)(71200400001)(966005)(86362001)(55236004)(54906003)(6636002)(26005)(186003)(9686003)(53546011)(6506007)(38070700005)(2906002)(83380400001)(7416002)(8676002)(8936002)(55016003)(33656002)(478600001)(921005)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTRwUUdaMXJla0RtaUxob2FnVXJCM1drRjhDc0tITUlnL1hiYlV1ZUVkeDZh?=
 =?utf-8?B?bGdONFJzcmNZNVBqTDA4V29iWnZtQVhkS1BodWNEMmZ0Rmxqcy9RdzhScUw5?=
 =?utf-8?B?QklHcFRhL1Nvam5SUG5qNkFRNFlHbTlSWkhMd3MxZHM1M1RhSHpvZUNHaC9j?=
 =?utf-8?B?TVVTU1ZiWndQVHZHd2xwVVFDMXBHNXYyM1dnT3M1QllJL1JDR2ltK05QdTJk?=
 =?utf-8?B?QU9YaGxOSjlCbWNWYytQOG9uK1dpd1QrOE14SlZTQll0ajRCTDFaUDZBcGpK?=
 =?utf-8?B?OEsrNDdZOFpDRm16cndqRGJ2Sy96UGU3ZVZlcEl4WVVSTW9sNTBSRFRkZU0v?=
 =?utf-8?B?cnk5eGY4RDRoTktoMkx4dStyalhqcDJiNmdMTG53S0s4azFnYkg1MS9SQkM2?=
 =?utf-8?B?SUJ0aWI0Wm5OQ1IvNmFWMFVEMmRLUVk3ZThpa0tJOHhEdEZIT3lpV0g1UVdS?=
 =?utf-8?B?WVY0MVJoWlNYT3Q1ZTlsNURuMllHLzliSHh0azJYYyszNHh1Nm5CWUNCcU8w?=
 =?utf-8?B?Vmo2bWpZMllQWGJxUlRsbXNpVTF3M05jYmpLajBGeFpacU1OQWRPa3JlZjdV?=
 =?utf-8?B?azVyaElzRzdXZWkxTmRKN1FObThjZFYwdlJvTnBxbkJTRHRYczM0QXhLZXA1?=
 =?utf-8?B?ellhVi91UmdYcGpCbTFseUpublEvTVVzT0FxVFV3TU5ZeEJ1ditRR3VVMFJC?=
 =?utf-8?B?TGZGYnZJSmZ1cUFvNnhtRUpvc3lDZU5Kci8zblBMWkJ5WmRPYU5ndnQyZDc2?=
 =?utf-8?B?dVdTZDQ0SzRNTXQxSkpYT2NxTXBtTXNUNUp0VWdSa1RaeENEc2JROERZMC9G?=
 =?utf-8?B?WTREWEU0UkdCNTZ2QmoyZktuR1lkQTlsWmFIUnUwZ1o0OEN0dEMxTGxKTVFh?=
 =?utf-8?B?NDlRR2RPd21HQ1hLUjR0ZkNJeHlYWTRYd3BHR1JrZHlsMWtmZDJla3dtWit0?=
 =?utf-8?B?M2tqNUFEM2R2SUZKYW5rQTNJazhaR0Z1dzVEdW1FNkFHdzR2QzByNjVia1lW?=
 =?utf-8?B?M3VpdjhOelFXNUV6U00yUXA1bm41UzRlL1RZVmNEMGdhbzgrWVFycU9GbnRI?=
 =?utf-8?B?cXlXNXBMb3JZVndnU0Z4aG5wcktib21zNEVwMU1ua3ovK3NGdXZ6Z24wNmNi?=
 =?utf-8?B?eitYTzNhQzFjUWdjS29KeXRkV2luSWU3aVZaWkROZjRpWWduR0tEaTZrckpl?=
 =?utf-8?B?ZzNsNCtjeXBBTnlIRDZVdnBGNSsyZWZqVCs5M3Uybmp2azBSWTJBY2pHQlcw?=
 =?utf-8?B?Mjdrd0RTeURWMUozMmVlUmg0bXJPbG5JMnREc0g4eCszenJyVXdocnhhbWlY?=
 =?utf-8?B?YnNUNzBDSm9PMThnT2lyYlFvWHIwbU1Wb0FaMXJKQ2NIeDZXUjVtcitRak5H?=
 =?utf-8?B?QmtUUkFQK3dTT0VmYmZOZmlkdEsrMGhVenR2YTVLTDJMV0RBL1FzSmJJMTZm?=
 =?utf-8?B?OGNTNGJWSWtUQ2JvU29jbnZxeStIVVZkZ3V2QmVnV25YVHZTL2xZZzg5Z2JO?=
 =?utf-8?B?L2xENEZrNElOcFNtRUJoTkFxS1paZ2RGVEdTdHBCSEZYcUhUTVRMblRwakNr?=
 =?utf-8?B?bW9PRkNQejhacHVTVzR6bEN6aU14enNTejUxNDcva0JCbS96UURpN1lVZFdZ?=
 =?utf-8?B?UTZ1WFBLRURQNmtOcDF6d2Nwd2NESS9venpLOVNXMktnZ0JKYTRlY2lacnBv?=
 =?utf-8?B?ajBJUHJTUzM2dEYwMkhualVCcndnUFNsUk5vNVhncVhrNVhLSForaFZodUJ5?=
 =?utf-8?B?UjFJbWowU1RpZUhSeDZZSjdUaUNzTjh4Sm5YZm4wbW1EYmY5eFRxUWtZRFVH?=
 =?utf-8?B?NktWUXh0UDh1eFFkRUNhSGdxR3dWMHh0dVI0ZTlNTTJwRXFqaXFzcDdmVlQ4?=
 =?utf-8?B?c3orZy9pVkh6M0FqbnZZTi9SVEpPQWRxdG1nald1ZFROUG9QNlFYYVo1NnNo?=
 =?utf-8?B?RHVjd1hSS3V2eFZuSE9zaUF5OGRMUGYrMm5MYmxiRDFyMXlidFh0K2EvKzRH?=
 =?utf-8?B?QTFEeC9Ec1VRY3lOaytBUS9rRnJabFFvU3VrQ1VGSHdSV0xXc0dyd0NPbE1u?=
 =?utf-8?B?K3VWVGRybXl1ME1CL1JxMnVVMkRYT0g2UlhZUnRWYkYwM0JPZDFDYkJhS2tX?=
 =?utf-8?Q?y4emsdVVSXwductsj0H4FeJ9N?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2adb0ead-15f2-4d0e-157f-08db3c84fab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 01:10:04.2096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lRqpDLZCDbC/yEsDacu1MDWDIS447ChNo1p5DzOzJR8HqoFuYFc5uU3r2HyG7uD8KAc1X7GUHMkvHeA827FZqyDR/BEpxCQE0PEuOEVitso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4614
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAxOjEwIEFNICwgSmVzcGVyIERhbmdhYXJkIEJyb3Vl
ciA8amJyb3VlckByZWRoYXQuY29tPiB3cm90ZToNCj5PbiAxMy8wNC8yMDIzIDA1LjI1LCBTb25n
IFlvb25nIFNpYW5nIHdyb3RlOg0KPj4gSW50cm9kdWNlIHN0cnVjdCBzdG1tYWNfeGRwX2J1ZmYg
YXMgYSBwcmVwYXJhdGlvbiB0byBzdXBwb3J0IFhEUCBSeA0KPj4gbWV0YWRhdGEgdmlhIGtmdW5j
cy4NCj4+DQo+PiBSZXZpZXdlZC1ieTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRl
bC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTb25nIFlvb25nIFNpYW5nIDx5b29uZy5zaWFuZy5z
b25nQGludGVsLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3Jv
L3N0bW1hYy9zdG1tYWMuaCAgIHwgIDQgKysrKw0KPj4gICAuLi4vbmV0L2V0aGVybmV0L3N0bWlj
cm8vc3RtbWFjL3N0bW1hY19tYWluLmMgIHwgMTggKysrKysrKysrLS0tLS0tLS0tDQo+PiAgIDIg
ZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4+DQo+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgN
Cj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgNCj4+IGlu
ZGV4IDNkMTVlMWU5MmUxOC4uYWM4Y2NmODUxNzA4IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmgNCj4+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hYy5oDQo+PiBAQCAtOTIsNiArOTIsMTAgQEAg
c3RydWN0IHN0bW1hY19yeF9idWZmZXIgew0KPj4gICAJZG1hX2FkZHJfdCBzZWNfYWRkcjsNCj4+
ICAgfTsNCj4+DQo+PiArc3RydWN0IHN0bW1hY194ZHBfYnVmZiB7DQo+PiArCXN0cnVjdCB4ZHBf
YnVmZiB4ZHA7DQo+PiArfTsNCj4+ICsNCj4+ICAgc3RydWN0IHN0bW1hY19yeF9xdWV1ZSB7DQo+
PiAgIAl1MzIgcnhfY291bnRfZnJhbWVzOw0KPj4gICAJdTMyIHF1ZXVlX2luZGV4Ow0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWlu
LmMNCj4+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4u
Yw0KPj4gaW5kZXggZDdmY2FiMDU3MDMyLi42ZmZjZTUyY2E4MzcgMTAwNjQ0DQo+PiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+PiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+PiBA
QCAtNTE4OCw5ICs1MTg4LDkgQEAgc3RhdGljIGludCBzdG1tYWNfcngoc3RydWN0IHN0bW1hY19w
cml2ICpwcml2LCBpbnQNCj5saW1pdCwgdTMyIHF1ZXVlKQ0KPj4gICAJaW50IHN0YXR1cyA9IDAs
IGNvZSA9IHByaXYtPmh3LT5yeF9jc3VtOw0KPj4gICAJdW5zaWduZWQgaW50IG5leHRfZW50cnkg
PSByeF9xLT5jdXJfcng7DQo+PiAgIAllbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBkbWFfZGlyOw0K
Pj4gKwlzdHJ1Y3Qgc3RtbWFjX3hkcF9idWZmIGN0eCA9IHt9Ow0KPg0KPlRoaXMgY29kZSB0cmlj
ayB7fSB3aWxsIHplcm8gb3V0IHRoZSBzdHJ1Y3QuDQo+DQo+SXMgdGhpcyBkb25lIHB1cnBvc2Ug
YW5kIHJlYWxseSBuZWVkZWQ/DQo+DQo+T24geDg2XzY0IHRoaXMgdW5mb3J0dW5hdGVseSBnZW5l
cmF0ZXMgYW4gYXNtIGluc3RydWN0aW9uOiByZXAgc3Rvcw0KPg0KPkEgcmVwZWF0ZWQgc3RvcmUg
c3RyaW5nIG9wZXJhdGlvbiwgZm9yIHplcm9pbmcgb3V0IG1lbW9yeSwgd2hpY2ggaXMgc2xvdy4N
Cj4oQmVjYXVzZVsxXSBpdCBzdXBwb3J0cyBiZSBzdXNwZW5kZWQgYnkgYW4gZXhjZXB0aW9uIG9y
IGludGVycnVwdCwgd2hpY2ggcmVxdWlyZXMNCj5pdCB0byBzdG9yZS9yZXN0b3JlIENQVSBmbGFn
cykuDQo+DQo+WzFdIGh0dHBzOi8vd3d3LmZlbGl4Y2xvdXRpZXIuY29tL3g4Ni9yZXA6cmVwZTpy
ZXB6OnJlcG5lOnJlcG56I3RibC00LTIyDQoNClRoYW5rcyBmb3IgdGhlIHVzZWZ1bCBpbmZvcm1h
dGlvbiBhbmQgbGluay4gSSB3aWxsIHN1Ym1pdCB2NSB0byByZW1vdmUge30uDQo+DQo+DQo+PiAg
IAl1bnNpZ25lZCBpbnQgZGVzY19zaXplOw0KPj4gICAJc3RydWN0IHNrX2J1ZmYgKnNrYiA9IE5V
TEw7DQo+PiAtCXN0cnVjdCB4ZHBfYnVmZiB4ZHA7DQo+PiAgIAlpbnQgeGRwX3N0YXR1cyA9IDA7
DQo+PiAgIAlpbnQgYnVmX3N6Ow0KPj4NCj4+IEBAIC01MzExLDE3ICs1MzExLDE3IEBAIHN0YXRp
YyBpbnQgc3RtbWFjX3J4KHN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiwgaW50DQo+bGltaXQsIHUz
MiBxdWV1ZSkNCj4+ICAgCQkJZG1hX3N5bmNfc2luZ2xlX2Zvcl9jcHUocHJpdi0+ZGV2aWNlLCBi
dWYtPmFkZHIsDQo+PiAgIAkJCQkJCWJ1ZjFfbGVuLCBkbWFfZGlyKTsNCj4+DQo+PiAtCQkJeGRw
X2luaXRfYnVmZigmeGRwLCBidWZfc3osICZyeF9xLT54ZHBfcnhxKTsNCj4+IC0JCQl4ZHBfcHJl
cGFyZV9idWZmKCZ4ZHAsIHBhZ2VfYWRkcmVzcyhidWYtPnBhZ2UpLA0KPj4gKwkJCXhkcF9pbml0
X2J1ZmYoJmN0eC54ZHAsIGJ1Zl9zeiwgJnJ4X3EtPnhkcF9yeHEpOw0KPj4gKwkJCXhkcF9wcmVw
YXJlX2J1ZmYoJmN0eC54ZHAsIHBhZ2VfYWRkcmVzcyhidWYtPnBhZ2UpLA0KPj4gICAJCQkJCSBi
dWYtPnBhZ2Vfb2Zmc2V0LCBidWYxX2xlbiwgZmFsc2UpOw0KPj4NCj4+IC0JCQlwcmVfbGVuID0g
eGRwLmRhdGFfZW5kIC0geGRwLmRhdGFfaGFyZF9zdGFydCAtDQo+PiArCQkJcHJlX2xlbiA9IGN0
eC54ZHAuZGF0YV9lbmQgLSBjdHgueGRwLmRhdGFfaGFyZF9zdGFydCAtDQo+PiAgIAkJCQkgIGJ1
Zi0+cGFnZV9vZmZzZXQ7DQo+PiAtCQkJc2tiID0gc3RtbWFjX3hkcF9ydW5fcHJvZyhwcml2LCAm
eGRwKTsNCj4+ICsJCQlza2IgPSBzdG1tYWNfeGRwX3J1bl9wcm9nKHByaXYsICZjdHgueGRwKTsN
Cj4+ICAgCQkJLyogRHVlIHhkcF9hZGp1c3RfdGFpbDogRE1BIHN5bmMgZm9yX2RldmljZQ0KPj4g
ICAJCQkgKiBjb3ZlciBtYXggbGVuIENQVSB0b3VjaA0KPj4gICAJCQkgKi8NCj4+IC0JCQlzeW5j
X2xlbiA9IHhkcC5kYXRhX2VuZCAtIHhkcC5kYXRhX2hhcmRfc3RhcnQgLQ0KPj4gKwkJCXN5bmNf
bGVuID0gY3R4LnhkcC5kYXRhX2VuZCAtIGN0eC54ZHAuZGF0YV9oYXJkX3N0YXJ0IC0NCj4+ICAg
CQkJCSAgIGJ1Zi0+cGFnZV9vZmZzZXQ7DQo+PiAgIAkJCXN5bmNfbGVuID0gbWF4KHN5bmNfbGVu
LCBwcmVfbGVuKTsNCj4+DQo+PiBAQCAtNTMzMSw3ICs1MzMxLDcgQEAgc3RhdGljIGludCBzdG1t
YWNfcngoc3RydWN0IHN0bW1hY19wcml2ICpwcml2LA0KPj4gaW50IGxpbWl0LCB1MzIgcXVldWUp
DQo+Pg0KPj4gICAJCQkJaWYgKHhkcF9yZXMgJiBTVE1NQUNfWERQX0NPTlNVTUVEKSB7DQo+PiAg
IAkJCQkJcGFnZV9wb29sX3B1dF9wYWdlKHJ4X3EtPnBhZ2VfcG9vbCwNCj4+IC0NCj52aXJ0X3Rv
X2hlYWRfcGFnZSh4ZHAuZGF0YSksDQo+PiArDQo+dmlydF90b19oZWFkX3BhZ2UoY3R4LnhkcC5k
YXRhKSwNCj4+ICAgCQkJCQkJCSAgIHN5bmNfbGVuLCB0cnVlKTsNCj4+ICAgCQkJCQlidWYtPnBh
Z2UgPSBOVUxMOw0KPj4gICAJCQkJCXByaXYtPmRldi0+c3RhdHMucnhfZHJvcHBlZCsrOw0KPj4g
QEAgLTUzNTksNyArNTM1OSw3IEBAIHN0YXRpYyBpbnQgc3RtbWFjX3J4KHN0cnVjdCBzdG1tYWNf
cHJpdiAqcHJpdiwNCj4+IGludCBsaW1pdCwgdTMyIHF1ZXVlKQ0KPj4NCj4+ICAgCQlpZiAoIXNr
Yikgew0KPj4gICAJCQkvKiBYRFAgcHJvZ3JhbSBtYXkgZXhwYW5kIG9yIHJlZHVjZSB0YWlsICov
DQo+PiAtCQkJYnVmMV9sZW4gPSB4ZHAuZGF0YV9lbmQgLSB4ZHAuZGF0YTsNCj4+ICsJCQlidWYx
X2xlbiA9IGN0eC54ZHAuZGF0YV9lbmQgLSBjdHgueGRwLmRhdGE7DQo+Pg0KPj4gICAJCQlza2Ig
PSBuYXBpX2FsbG9jX3NrYigmY2gtPnJ4X25hcGksIGJ1ZjFfbGVuKTsNCj4+ICAgCQkJaWYgKCFz
a2IpIHsNCj4+IEBAIC01MzY5LDcgKzUzNjksNyBAQCBzdGF0aWMgaW50IHN0bW1hY19yeChzdHJ1
Y3Qgc3RtbWFjX3ByaXYgKnByaXYsIGludA0KPmxpbWl0LCB1MzIgcXVldWUpDQo+PiAgIAkJCX0N
Cj4+DQo+PiAgIAkJCS8qIFhEUCBwcm9ncmFtIG1heSBhZGp1c3QgaGVhZGVyICovDQo+PiAtCQkJ
c2tiX2NvcHlfdG9fbGluZWFyX2RhdGEoc2tiLCB4ZHAuZGF0YSwgYnVmMV9sZW4pOw0KPj4gKwkJ
CXNrYl9jb3B5X3RvX2xpbmVhcl9kYXRhKHNrYiwgY3R4LnhkcC5kYXRhLCBidWYxX2xlbik7DQo+
PiAgIAkJCXNrYl9wdXQoc2tiLCBidWYxX2xlbik7DQo+Pg0KPj4gICAJCQkvKiBEYXRhIHBheWxv
YWQgY29waWVkIGludG8gU0tCLCBwYWdlIHJlYWR5IGZvciByZWN5Y2xlDQo+Ki8NCg0K
