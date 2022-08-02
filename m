Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597C2587DD9
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbiHBODM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbiHBOC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:02:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB9927FC2;
        Tue,  2 Aug 2022 07:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659448975; x=1690984975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TJ0IaNhc5dfJ6LAZSwziDjY0ez+9hSHOJ8newgb2+D8=;
  b=CPaZSfrq1CKceyxOEg37hjkkIiIDbEA1FHt9m1S344D5lBysW4/aAa2Z
   S2eEakUGAzXtiANgg/8/Einabcmo8uc/54QauZbVFl7CpfsAWAPncN5dN
   FZnp5wu2x8F1TtjzL6yejmq7IgdEIn/KxyZeOmTOreHxrpOHuV5NZVh5j
   sqtZIPVG97ua6BV3W6cwc6mqqWM1hy8d0KdO2qR9I8GZogTtUCKIWuEfx
   AMsjDcoThXkX6V+c9Zeo4TyK2PzL/DYXUBB/cintOzXhxlgTyqoGWymjB
   ulPz5gsQVFdTWct/8x9rHyAAhlYA61KsMZccoy8SETVQMBAkpfn6Ca/Ki
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="269794160"
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="269794160"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 07:02:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,211,1654585200"; 
   d="scan'208";a="929980059"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 02 Aug 2022 07:02:37 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 07:02:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 2 Aug 2022 07:02:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 2 Aug 2022 07:02:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 2 Aug 2022 07:02:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwGyygvWCEUff8qJ46rYjyiklOKc2MnJRSTqVwnV8cYCHIB/txSWYQT2tpVjBjmGmX7EdhobsIrrnGzAMH1NNrRP0KCL9UiNQERkGZ9G1GJxCzsnLYuoPTbJrjQige0nlwwPV3FsaC06ssxm/+6kQ9yPsy+Pm+nSs9yYtQ5BlzTTBoacaWZXDu/IbT+tXKzb4KysAXN+fMK8dIFMs1dTN9Z/F2pjf0Ne/f9XL4aIBBAz+mEZOG/FsWMRNYtqeBQK869xll251nyqRI66lrC06zEiEVrtqyQ/RW3cKXmpNGQ6bKhQgcGgqCy0Ym9eW/7q1XT+eB/UuYN+eEhz0j1piQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ0IaNhc5dfJ6LAZSwziDjY0ez+9hSHOJ8newgb2+D8=;
 b=bR4JCZmplYNkCq7iZuWU7xxZ8IJIa+u2VV64gJ0d1zl5GXFj+oEy4rm/Ssq9A7KZpt3JW6pku4ahy3d7MggB7zQuBCeZ1Ue19RP/dj3Yy5PF8/UsOkXxBdNNqlW7/ag1Oqo+C8J6RTPwPuvH80PX+BHOwTqc+L3VueLLk52ZEp3GOgpnpcr351Q7SvBsS+d6qeAiUVZ0yKhY1bOUMaz9GnHMQ3S9ZYaMzMde2txn+VEOVlM9Y60p4mlpxkv9bCM0pogmY8pDfKDrEhZzh1RZzqODqJ9UQNNf2I3vpaoqLQJZ9sntfvyQNO5VGaezDfL2mKtQzPZW7xmqxtmza0+hFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.11; Tue, 2 Aug 2022 14:02:31 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::2ce4:94fa:eef0:b822%4]) with mapi id 15.20.5504.014; Tue, 2 Aug 2022
 14:02:31 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Topic: [RFC PATCH v2 2/3] dpll: add netlink events
Thread-Index: AQHYiZJ5zeS9OiYOPkW4rEeGr6WnDq149o2AgAWpYQCAAS3QwIAcDMQw
Date:   Tue, 2 Aug 2022 14:02:31 +0000
Message-ID: <DM6PR11MB4657FADDDA75A5F35CF8FE3F9B9D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20220626192444.29321-1-vfedorenko@novek.ru>
 <20220626192444.29321-3-vfedorenko@novek.ru>
 <DM6PR11MB46573FA8D51D40DAD2AC060B9B879@DM6PR11MB4657.namprd11.prod.outlook.com>
 <715d8f47-d246-6b4a-b22d-82672e8f11d8@novek.ru>
 <DM6PR11MB465732355816F30254FCFA9E9B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB465732355816F30254FCFA9E9B8B9@DM6PR11MB4657.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38bb6f7f-0622-4354-1522-08da748fa46b
x-ms-traffictypediagnostic: CO1PR11MB5044:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHoOL2HsfY1s0Vux0Mados7D2knbRTJFpdk+WtgSG7BPnd4+BohvWPvjslOiy16hA4XEqp8qJ4baJt8USxj/HeF+obBual2MTWPUAdkKNZB9dZRgNdvVwxdyiqZwVenVBJQYbuj0jnNhidengmfl3+HG/6D+VUpxZUXcPCx2G7SBOSqUBZz5rrT3Ctk1aYJeqgSt6jZGNYkGhGjVS1TIxzObsJKtFTDKyi0IMOkjaXnLWunKDjqhwojjWYtBg5jsgwvQP7c4J0gORqAVA7CiSghDk9EcEJ9tP0DqP2UxZFYfl3lz2OGA3/S1OjoJiN13HMdQ8TcEVxEDY4iCqm/Vd2VgcDVPHIMy4jt2XL+F8na9bgi9/EiAUg7hEOwIB24Dp9P0ikUbUuHrK4FUjpgc0uTlhTNjUsH++jwRWLzhOJwEy2tMPk5GIesV2YpbjBgCh7TZ2xlQEuUbVJcQrWT13kJKsEqSX7hGmLgsRCLqTIia6i2uf0MZh6A/rApRmtEWJ4GqlVTyKwouCUxohhlw8SXicboV6SiqkKJLbEm2OxogvLAkxVV2sZpcyUc5DxA8F3bNt1old4ozVvtbQighABMT/Evccc+VSYLgiWjUDQmiJUKE83ts5kjw/PQogC0JwokXPhhsHifqEzE1qoRsdirm+2v/myjVq/0BdkXk9uhDhFjIFGycWg8CQ8tMBmau+bBwM6TEU7qSph3l+Bn2HaDL3waROFz8yL6R0gSQz65cMDi/6OgQNKcPAQIxPs9D01dDVIdqkWBPfG7D2r68qClWnyD9FzdzuzwGXfv6Y55OmzCSGY+/dWvm3gEqhMvZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39860400002)(376002)(346002)(33656002)(83380400001)(55016003)(54906003)(6506007)(2906002)(7696005)(316002)(5660300002)(66946007)(52536014)(38070700005)(64756008)(66446008)(66476007)(66556008)(86362001)(82960400001)(8676002)(4326008)(110136005)(76116006)(122000001)(8936002)(41300700001)(71200400001)(38100700002)(478600001)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2RlZjZTbmtHWDhPcDl5bkFLbmJPOXg1UFJlYVVtL0pFUHhsUHY0djVwbGdl?=
 =?utf-8?B?cWs5NTc4VHdtUmhLbTJZeWRHSWlIZ2hUYlBabjVyS2d0N09LN0pRc0ZKdkZH?=
 =?utf-8?B?TVhlYnlwTFJvemUrZW5WemlkU0Z1bnB4U0N0Snpodi9GZlJ6RVZOd1FwRnB6?=
 =?utf-8?B?bFBaT2ZFUThzTHorbU8zUmQ4dEcxSytEaFE3Z29pV3o2OXdOUDFxeW9tOHBy?=
 =?utf-8?B?dG50VHpmUU0rbk0weHpGdW91UFJpck1Da1ZvVVhmYWRBdFd1WThkaThybkVI?=
 =?utf-8?B?R01RbnBuMVN5REhORnVHOVo5OUJKSU12UUcxNFAxajRqQnlOZU5sYSsrY1R2?=
 =?utf-8?B?QldoSE1ueTR5YzhyMzRkOHRtTVdqeXVMY0orQ2MzTnBjSGdjVkN2eGVobmtZ?=
 =?utf-8?B?RW0vWGZEcUNySGpyZTI0VU1uRTR1M1V0VDJqVzV3Q25BaG5JcDRYM2hKUUlE?=
 =?utf-8?B?Wmw2eXZqa1ZPVVJuT2NGSWlGK1V4UHpwNXBRS0lsa2QxSWhIVDVVVGtYM2pk?=
 =?utf-8?B?NVdoa0Jkd2hnVGpOUzFEOS8wQmNTZ2dubHlhQW1LL1JTYldHa1FZUjNPbEFS?=
 =?utf-8?B?VnFwSm5QblIyQ01FTm1Rc2ZOU1c0aEpJRFBTTXdtOXVCU3BLOXltWi9JaXN1?=
 =?utf-8?B?RHVXSFNDaVZZbnBQaFJTaG1MRDhZNnZjSGYreW1wV2c1S3lmK1pGM3BHSUVu?=
 =?utf-8?B?MWRhSFc4cWZBeWxmSC9Wc0JVRXY4THpINTlKMm9tbHN3QmZjRjdWNzRQQWxt?=
 =?utf-8?B?S1NzY2xhMWhPSWhRN044UUp2RU9uNlR6cWM3K2RsNUltdGV0a2x1Ymh5Nm93?=
 =?utf-8?B?aC9YRHRtZVBWL1ZnUjFPZ2NUZjdLTUtIblJObkFZM2pTeGhNUStkNzhSbVhU?=
 =?utf-8?B?ck04T2FsVjBJZmpiY2VJNW04NE91WUdTRzcvSnFNUkZWcGt4UWNZNU85WG9S?=
 =?utf-8?B?Tythdmg2NmdUTjJhbnVORWh3QUQ3eTJVaDhiRmpNb2lzYjdpQnFoNys5N1dO?=
 =?utf-8?B?NHF2UlpDdUtvcDhNd2gycUsrQWU4d0Q3TTd3NTBwK1ExTEQ5YnhBcGRjYlRW?=
 =?utf-8?B?SWVDc0s4aGgxSlpaSkNlR2FSRU9xeXJYelVpR2k2YmpOLzVXSG5uTHpMOG13?=
 =?utf-8?B?VUIydjV3aDNWYlFDdFNQZ1NmazNWNnJOUXVUMzNHWDh4NzNKc1ZXUC9HeGhB?=
 =?utf-8?B?TVdEM0d2RGswNTZ2VW9WWTNFcE1FQ1crWEdPQVZtUWNlNXRQQnFHcHV0b0o5?=
 =?utf-8?B?c3FCUURRR3ZNaVE5U2hRcXBYUXVDa2RwN3pRUzJxTUNSVmllWUhBYTVjVWRF?=
 =?utf-8?B?aWtabVRUK2FZR0N1YkJtSUNRSkh3VTRoL04remZtSGxZcVhWWlRrNFh5Sm1T?=
 =?utf-8?B?cDh5cWc0eXlkcWVEU0E1SHc2OWp1Um5kclU4SW1SSEpTdk1HL3JTZFR1RjNz?=
 =?utf-8?B?YmJSaGgwajRabmdjRjU2QzFLVU1yZVNqZzNiQWQyZmMrM20vazRjNWRyaE5E?=
 =?utf-8?B?OWJqVWV2cjl2VkNPZG5qYjhTMWpYM2lzQ2dreXpOYUJTTjhhdWxxamhrWnh0?=
 =?utf-8?B?T2VZU0NtL3BReFFxa010ZUVlSEh4SVV4ek9LVUF0SkxwZ3FJWFFqNVlPc2wr?=
 =?utf-8?B?dU5ERFZuRmlUUFk0Z2tUci9tNE4xQnlXYmFyUUE2cXpYSTdMQlhhcENmZWtM?=
 =?utf-8?B?eWxLRktwYzVMYkNPM0g0ak5kVVl0ODB0TzdYMTJDTzdHOUdSTnpiS1pSTkVL?=
 =?utf-8?B?ZE1uM0UrdjVNMThhcHBoRmt0b1VmMktsTGlGYnFROVh6QjVTNG5LTGhjc040?=
 =?utf-8?B?VmpZbUFXbVJtQzMxbldnTVpUUmYraWhYUnBVV3FjOGc3cHdsQVZKQ0Q5YWMw?=
 =?utf-8?B?V2dTNHVneXBoOHpDNDZCS2ZoTmIzU1E2YjkvRTNvWjRIcExiRjIzNGRsdWts?=
 =?utf-8?B?VmVJdTlMbEltc3lqZkNkcXZlY011blhGUjArcUJWUTNCZnY1enJuR2hQSUcz?=
 =?utf-8?B?Q3ZURFduSnRXZHdMTUJXUFdoMDBZQVBlNEJlM1p4YTBsNUs1Y1AwcmgwRC9G?=
 =?utf-8?B?NTlaRzA1N2V1RXB5K2pmSmpGTExyWEFWNHIrOWFWSndPN0piamh2dUordzFm?=
 =?utf-8?B?a3E3c2ZrWXZxKzV4NG81RHk5ZEliRCs2RTZkcERvdUNJbC9IcHhKM0dVSUZu?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bb6f7f-0622-4354-1522-08da748fa46b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 14:02:31.3660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IewgFeEWIws+kFsJ6Gwn/Xx9IXJOyHJbMb4Qi3TzWzsLjQ1nv692dtG2T9aGNSqkP/wcFz9+7EM3EBCnSwGAVkynojdOSQxrpaIqdvBxScc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogVmFkaW0gRmVkb3JlbmtvIDx2ZmVk
b3JlbmtvQG5vdmVrLnJ1PiANCj5TZW50OiBGcmlkYXksIEp1bHkgMTUsIDIwMjIgMToyOSBBTQ0K
Pj4NCj4+T24gMTEuMDcuMjAyMiAxMDowMiwgS3ViYWxld3NraSwgQXJrYWRpdXN6IHdyb3RlOg0K
Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+Pj4gRnJvbTogVmFkaW0gRmVkb3Jlbmtv
IDx2ZmVkb3JlbmtvQG5vdmVrLnJ1Pg0KPj4+IFNlbnQ6IFN1bmRheSwgSnVuZSAyNiwgMjAyMiA5
OjI1IFBNDQo+Pj4+DQo+Pj4+IEZyb206IFZhZGltIEZlZG9yZW5rbyA8dmFkZmVkQGZiLmNvbT4N
Cj4+Pj4NCj4+Pj4gQWRkIG5ldGxpbmsgaW50ZXJmYWNlIHRvIGVuYWJsZSBub3RpZmljYXRpb24g
b2YgdXNlcnMgYWJvdXQNCj4+Pj4gZXZlbnRzIGluIERQTEwgZnJhbWV3b3JrLiBQYXJ0IG9mIHRo
aXMgaW50ZXJmYWNlIHNob3VsZCBiZQ0KPj4+PiB1c2VkIGJ5IGRyaXZlcnMgZGlyZWN0bHksIGku
ZS4gbG9jayBzdGF0dXMgY2hhbmdlcy4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogVmFkaW0g
RmVkb3JlbmtvIDx2YWRmZWRAZmIuY29tPg0KPj4+PiAtLS0NCj4+Pj4gZHJpdmVycy9kcGxsL2Rw
bGxfY29yZS5jICAgIHwgICAyICsNCj4+Pj4gZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5jIHwg
MTQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+PiBkcml2ZXJzL2Rw
bGwvZHBsbF9uZXRsaW5rLmggfCAgIDcgKysNCj4+Pj4gMyBmaWxlcyBjaGFuZ2VkLCAxNTAgaW5z
ZXJ0aW9ucygrKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kcGxsL2RwbGxfY29y
ZS5jIGIvZHJpdmVycy9kcGxsL2RwbGxfY29yZS5jDQo+Pj4+IGluZGV4IGRjMDMzMGUzNjg3ZC4u
Mzg3NjQ0YWE5MTBlIDEwMDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJzL2RwbGwvZHBsbF9jb3JlLmMN
Cj4+Pj4gKysrIGIvZHJpdmVycy9kcGxsL2RwbGxfY29yZS5jDQo+Pj4+IEBAIC05Nyw2ICs5Nyw4
IEBAIHN0cnVjdCBkcGxsX2RldmljZSAqZHBsbF9kZXZpY2VfYWxsb2Moc3RydWN0IGRwbGxfZGV2
aWNlX29wcyAqb3BzLCBpbnQgc291cmNlc19jDQo+Pj4+IAltdXRleF91bmxvY2soJmRwbGxfZGV2
aWNlX3hhX2xvY2spOw0KPj4+PiAJZHBsbC0+cHJpdiA9IHByaXY7DQo+Pj4+DQo+Pj4+ICsJZHBs
bF9ub3RpZnlfZGV2aWNlX2NyZWF0ZShkcGxsLT5pZCwgZGV2X25hbWUoJmRwbGwtPmRldikpOw0K
Pj4+PiArDQo+Pj4+IAlyZXR1cm4gZHBsbDsNCj4+Pj4NCj4+Pj4gZXJyb3I6DQo+Pj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmMgYi9kcml2ZXJzL2RwbGwvZHBsbF9u
ZXRsaW5rLmMNCj4+Pj4gaW5kZXggZTE1MTA2ZjMwMzc3Li40YjE2ODRmY2Y0MWUgMTAwNjQ0DQo+
Pj4+IC0tLSBhL2RyaXZlcnMvZHBsbC9kcGxsX25ldGxpbmsuYw0KPj4+PiArKysgYi9kcml2ZXJz
L2RwbGwvZHBsbF9uZXRsaW5rLmMNCj4+Pj4gQEAgLTQ4LDYgKzQ4LDggQEAgc3RydWN0IHBhcmFt
IHsNCj4+Pj4gCWludCBkcGxsX3NvdXJjZV90eXBlOw0KPj4+PiAJaW50IGRwbGxfb3V0cHV0X2lk
Ow0KPj4+PiAJaW50IGRwbGxfb3V0cHV0X3R5cGU7DQo+Pj4+ICsJaW50IGRwbGxfc3RhdHVzOw0K
Pj4+PiArCWNvbnN0IGNoYXIgKmRwbGxfbmFtZTsNCj4+Pj4gfTsNCj4+Pj4NCj4+Pj4gc3RydWN0
IGRwbGxfZHVtcF9jdHggew0KPj4+PiBAQCAtMjM5LDYgKzI0MSw4IEBAIHN0YXRpYyBpbnQgZHBs
bF9nZW5sX2NtZF9zZXRfc291cmNlKHN0cnVjdCBwYXJhbSAqcCkNCj4+Pj4gCXJldCA9IGRwbGwt
Pm9wcy0+c2V0X3NvdXJjZV90eXBlKGRwbGwsIHNyY19pZCwgdHlwZSk7DQo+Pj4+IAltdXRleF91
bmxvY2soJmRwbGwtPmxvY2spOw0KPj4+Pg0KPj4+PiArCWRwbGxfbm90aWZ5X3NvdXJjZV9jaGFu
Z2UoZHBsbC0+aWQsIHNyY19pZCwgdHlwZSk7DQo+Pj4+ICsNCj4+Pj4gCXJldHVybiByZXQ7DQo+
Pj4+IH0NCj4+Pj4NCj4+Pj4gQEAgLTI2Miw2ICsyNjYsOCBAQCBzdGF0aWMgaW50IGRwbGxfZ2Vu
bF9jbWRfc2V0X291dHB1dChzdHJ1Y3QgcGFyYW0gKnApDQo+Pj4+IAlyZXQgPSBkcGxsLT5vcHMt
PnNldF9zb3VyY2VfdHlwZShkcGxsLCBvdXRfaWQsIHR5cGUpOw0KPj4+PiAJbXV0ZXhfdW5sb2Nr
KCZkcGxsLT5sb2NrKTsNCj4+Pj4NCj4+Pj4gKwlkcGxsX25vdGlmeV9zb3VyY2VfY2hhbmdlKGRw
bGwtPmlkLCBvdXRfaWQsIHR5cGUpOw0KPj4+PiArDQo+Pj4+IAlyZXR1cm4gcmV0Ow0KPj4+PiB9
DQo+Pj4+DQo+Pj4+IEBAIC00MzgsNiArNDQ0LDE0MSBAQCBzdGF0aWMgc3RydWN0IGdlbmxfZmFt
aWx5IGRwbGxfZ25sX2ZhbWlseSBfX3JvX2FmdGVyX2luaXQgPSB7DQo+Pj4+IAkucHJlX2RvaXQJ
PSBkcGxsX3ByZV9kb2l0LA0KPj4+PiB9Ow0KPj4+Pg0KPj4+PiArc3RhdGljIGludCBkcGxsX2V2
ZW50X2RldmljZV9jcmVhdGUoc3RydWN0IHBhcmFtICpwKQ0KPj4+PiArew0KPj4+PiArCWlmIChu
bGFfcHV0X3UzMihwLT5tc2csIERQTExBX0RFVklDRV9JRCwgcC0+ZHBsbF9pZCkgfHwNCj4+Pj4g
KwkgICAgbmxhX3B1dF9zdHJpbmcocC0+bXNnLCBEUExMQV9ERVZJQ0VfTkFNRSwgcC0+ZHBsbF9u
YW1lKSkNCj4+Pj4gKwkJcmV0dXJuIC1FTVNHU0laRTsNCj4+Pj4gKw0KPj4+PiArCXJldHVybiAw
Ow0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtzdGF0aWMgaW50IGRwbGxfZXZlbnRfZGV2aWNlX2Rl
bGV0ZShzdHJ1Y3QgcGFyYW0gKnApDQo+Pj4+ICt7DQo+Pj4+ICsJaWYgKG5sYV9wdXRfdTMyKHAt
Pm1zZywgRFBMTEFfREVWSUNFX0lELCBwLT5kcGxsX2lkKSkNCj4+Pj4gKwkJcmV0dXJuIC1FTVNH
U0laRTsNCj4+Pj4gKw0KPj4+PiArCXJldHVybiAwOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtz
dGF0aWMgaW50IGRwbGxfZXZlbnRfc3RhdHVzKHN0cnVjdCBwYXJhbSAqcCkNCj4+Pj4gK3sNCj4+
Pj4gKwlpZiAobmxhX3B1dF91MzIocC0+bXNnLCBEUExMQV9ERVZJQ0VfSUQsIHAtPmRwbGxfaWQp
IHx8DQo+Pj4+ICsJCW5sYV9wdXRfdTMyKHAtPm1zZywgRFBMTEFfTE9DS19TVEFUVVMsIHAtPmRw
bGxfc3RhdHVzKSkNCj4+Pj4gKwkJcmV0dXJuIC1FTVNHU0laRTsNCj4+Pj4gKw0KPj4+PiArCXJl
dHVybiAwOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtzdGF0aWMgaW50IGRwbGxfZXZlbnRfc291
cmNlX2NoYW5nZShzdHJ1Y3QgcGFyYW0gKnApDQo+Pj4+ICt7DQo+Pj4+ICsJaWYgKG5sYV9wdXRf
dTMyKHAtPm1zZywgRFBMTEFfREVWSUNFX0lELCBwLT5kcGxsX2lkKSB8fA0KPj4+PiArCSAgICBu
bGFfcHV0X3UzMihwLT5tc2csIERQTExBX1NPVVJDRV9JRCwgcC0+ZHBsbF9zb3VyY2VfaWQpIHx8
DQo+Pj4+ICsJCW5sYV9wdXRfdTMyKHAtPm1zZywgRFBMTEFfU09VUkNFX1RZUEUsIHAtPmRwbGxf
c291cmNlX3R5cGUpKQ0KPj4+PiArCQlyZXR1cm4gLUVNU0dTSVpFOw0KPj4+PiArDQo+Pj4+ICsJ
cmV0dXJuIDA7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pj4gK3N0YXRpYyBpbnQgZHBsbF9ldmVudF9v
dXRwdXRfY2hhbmdlKHN0cnVjdCBwYXJhbSAqcCkNCj4+Pj4gK3sNCj4+Pj4gKwlpZiAobmxhX3B1
dF91MzIocC0+bXNnLCBEUExMQV9ERVZJQ0VfSUQsIHAtPmRwbGxfaWQpIHx8DQo+Pj4+ICsJICAg
IG5sYV9wdXRfdTMyKHAtPm1zZywgRFBMTEFfT1VUUFVUX0lELCBwLT5kcGxsX291dHB1dF9pZCkg
fHwNCj4+Pj4gKwkJbmxhX3B1dF91MzIocC0+bXNnLCBEUExMQV9PVVRQVVRfVFlQRSwgcC0+ZHBs
bF9vdXRwdXRfdHlwZSkpDQo+Pj4+ICsJCXJldHVybiAtRU1TR1NJWkU7DQo+Pj4+ICsNCj4+Pj4g
KwlyZXR1cm4gMDsNCj4+Pj4gK30NCj4+Pj4gKw0KPj4+PiArc3RhdGljIGNiX3QgZXZlbnRfY2Jb
XSA9IHsNCj4+Pj4gKwlbRFBMTF9FVkVOVF9ERVZJQ0VfQ1JFQVRFXQk9IGRwbGxfZXZlbnRfZGV2
aWNlX2NyZWF0ZSwNCj4+Pj4gKwlbRFBMTF9FVkVOVF9ERVZJQ0VfREVMRVRFXQk9IGRwbGxfZXZl
bnRfZGV2aWNlX2RlbGV0ZSwNCj4+Pj4gKwlbRFBMTF9FVkVOVF9TVEFUVVNfTE9DS0VEXQk9IGRw
bGxfZXZlbnRfc3RhdHVzLA0KPj4+PiArCVtEUExMX0VWRU5UX1NUQVRVU19VTkxPQ0tFRF0JPSBk
cGxsX2V2ZW50X3N0YXR1cywNCj4+Pj4gKwlbRFBMTF9FVkVOVF9TT1VSQ0VfQ0hBTkdFXQk9IGRw
bGxfZXZlbnRfc291cmNlX2NoYW5nZSwNCj4+Pj4gKwlbRFBMTF9FVkVOVF9PVVRQVVRfQ0hBTkdF
XQk9IGRwbGxfZXZlbnRfb3V0cHV0X2NoYW5nZSwNCj4+Pj4gK307DQo+Pj4+ICsvKg0KPj4+PiAr
ICogR2VuZXJpYyBuZXRsaW5rIERQTEwgZXZlbnQgZW5jb2RpbmcNCj4+Pj4gKyAqLw0KPj4+PiAr
c3RhdGljIGludCBkcGxsX3NlbmRfZXZlbnQoZW51bSBkcGxsX2dlbmxfZXZlbnQgZXZlbnQsDQo+
Pj4+ICsJCQkJICAgc3RydWN0IHBhcmFtICpwKQ0KPj4+PiArew0KPj4+PiArCXN0cnVjdCBza19i
dWZmICptc2c7DQo+Pj4+ICsJaW50IHJldCA9IC1FTVNHU0laRTsNCj4+Pj4gKwl2b2lkICpoZHI7
DQo+Pj4+ICsNCj4+Pj4gKwltc2cgPSBnZW5sbXNnX25ldyhOTE1TR19HT09EU0laRSwgR0ZQX0tF
Uk5FTCk7DQo+Pj4+ICsJaWYgKCFtc2cpDQo+Pj4+ICsJCXJldHVybiAtRU5PTUVNOw0KPj4+PiAr
CXAtPm1zZyA9IG1zZzsNCj4+Pj4gKw0KPj4+PiArCWhkciA9IGdlbmxtc2dfcHV0KG1zZywgMCwg
MCwgJmRwbGxfZ25sX2ZhbWlseSwgMCwgZXZlbnQpOw0KPj4+PiArCWlmICghaGRyKQ0KPj4+PiAr
CQlnb3RvIG91dF9mcmVlX21zZzsNCj4+Pj4gKw0KPj4+PiArCXJldCA9IGV2ZW50X2NiW2V2ZW50
XShwKTsNCj4+Pj4gKwlpZiAocmV0KQ0KPj4+PiArCQlnb3RvIG91dF9jYW5jZWxfbXNnOw0KPj4+
PiArDQo+Pj4+ICsJZ2VubG1zZ19lbmQobXNnLCBoZHIpOw0KPj4+PiArDQo+Pj4+ICsJZ2VubG1z
Z19tdWx0aWNhc3QoJmRwbGxfZ25sX2ZhbWlseSwgbXNnLCAwLCAxLCBHRlBfS0VSTkVMKTsNCj4+
PiANCj4+PiBBbGwgbXVsdGljYXN0cyBhcmUgc2VuZCBvbmx5IGZvciBncm91cCAiMSIgKERQTExf
Q09ORklHX1NPVVJDRV9HUk9VUF9OQU1FKSwNCj4+PiBidXQgNCBncm91cHMgd2VyZSBkZWZpbmVk
Lg0KPj4+DQo+Pg0KPj5ZZXMsIHlvdSBhcmUgcmlnaHQhIFdpbGwgdXBkYXRlIGl0IGluIHRoZSBu
ZXh0IHJvdW5kLg0KPj4NCj4+Pj4gKw0KPj4+PiArCXJldHVybiAwOw0KPj4+PiArDQo+Pj4+ICtv
dXRfY2FuY2VsX21zZzoNCj4+Pj4gKwlnZW5sbXNnX2NhbmNlbChtc2csIGhkcik7DQo+Pj4+ICtv
dXRfZnJlZV9tc2c6DQo+Pj4+ICsJbmxtc2dfZnJlZShtc2cpOw0KPj4+PiArDQo+Pj4+ICsJcmV0
dXJuIHJldDsNCj4+Pj4gK30NCj4+Pj4gKw0KPj4+PiAraW50IGRwbGxfbm90aWZ5X2RldmljZV9j
cmVhdGUoaW50IGRwbGxfaWQsIGNvbnN0IGNoYXIgKm5hbWUpDQo+Pj4+ICt7DQo+Pj4+ICsJc3Ry
dWN0IHBhcmFtIHAgPSB7IC5kcGxsX2lkID0gZHBsbF9pZCwgLmRwbGxfbmFtZSA9IG5hbWUgfTsN
Cj4+Pj4gKw0KPj4+PiArCXJldHVybiBkcGxsX3NlbmRfZXZlbnQoRFBMTF9FVkVOVF9ERVZJQ0Vf
Q1JFQVRFLCAmcCk7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pj4gK2ludCBkcGxsX25vdGlmeV9kZXZp
Y2VfZGVsZXRlKGludCBkcGxsX2lkKQ0KPj4+PiArew0KPj4+PiArCXN0cnVjdCBwYXJhbSBwID0g
eyAuZHBsbF9pZCA9IGRwbGxfaWQgfTsNCj4+Pj4gKw0KPj4+PiArCXJldHVybiBkcGxsX3NlbmRf
ZXZlbnQoRFBMTF9FVkVOVF9ERVZJQ0VfREVMRVRFLCAmcCk7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+
Pj4gK2ludCBkcGxsX25vdGlmeV9zdGF0dXNfbG9ja2VkKGludCBkcGxsX2lkKQ0KPj4+PiArew0K
Pj4+PiArCXN0cnVjdCBwYXJhbSBwID0geyAuZHBsbF9pZCA9IGRwbGxfaWQsIC5kcGxsX3N0YXR1
cyA9IDEgfTsNCj4+Pj4gKw0KPj4+PiArCXJldHVybiBkcGxsX3NlbmRfZXZlbnQoRFBMTF9FVkVO
VF9TVEFUVVNfTE9DS0VELCAmcCk7DQo+Pj4+ICt9DQo+Pj4+ICsNCj4+Pj4gK2ludCBkcGxsX25v
dGlmeV9zdGF0dXNfdW5sb2NrZWQoaW50IGRwbGxfaWQpDQo+Pj4+ICt7DQo+Pj4+ICsJc3RydWN0
IHBhcmFtIHAgPSB7IC5kcGxsX2lkID0gZHBsbF9pZCwgLmRwbGxfc3RhdHVzID0gMCB9Ow0KPj4+
PiArDQo+Pj4+ICsJcmV0dXJuIGRwbGxfc2VuZF9ldmVudChEUExMX0VWRU5UX1NUQVRVU19VTkxP
Q0tFRCwgJnApOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtpbnQgZHBsbF9ub3RpZnlfc291cmNl
X2NoYW5nZShpbnQgZHBsbF9pZCwgaW50IHNvdXJjZV9pZCwgaW50IHNvdXJjZV90eXBlKQ0KPj4+
PiArew0KPj4+PiArCXN0cnVjdCBwYXJhbSBwID0gIHsgLmRwbGxfaWQgPSBkcGxsX2lkLCAuZHBs
bF9zb3VyY2VfaWQgPSBzb3VyY2VfaWQsDQo+Pj4+ICsJCQkJCQkuZHBsbF9zb3VyY2VfdHlwZSA9
IHNvdXJjZV90eXBlIH07DQo+Pj4+ICsNCj4+Pj4gKwlyZXR1cm4gZHBsbF9zZW5kX2V2ZW50KERQ
TExfRVZFTlRfU09VUkNFX0NIQU5HRSwgJnApOw0KPj4+PiArfQ0KPj4+PiArDQo+Pj4+ICtpbnQg
ZHBsbF9ub3RpZnlfb3V0cHV0X2NoYW5nZShpbnQgZHBsbF9pZCwgaW50IG91dHB1dF9pZCwgaW50
IG91dHB1dF90eXBlKQ0KPj4+PiArew0KPj4+PiArCXN0cnVjdCBwYXJhbSBwID0gIHsgLmRwbGxf
aWQgPSBkcGxsX2lkLCAuZHBsbF9vdXRwdXRfaWQgPSBvdXRwdXRfaWQsDQo+Pj4+ICsJCQkJCQku
ZHBsbF9vdXRwdXRfdHlwZSA9IG91dHB1dF90eXBlIH07DQo+Pj4+ICsNCj4+Pj4gKwlyZXR1cm4g
ZHBsbF9zZW5kX2V2ZW50KERQTExfRVZFTlRfT1VUUFVUX0NIQU5HRSwgJnApOw0KPj4+PiArfQ0K
Pj4+PiArDQo+Pj4+IGludCBfX2luaXQgZHBsbF9uZXRsaW5rX2luaXQodm9pZCkNCj4+Pj4gew0K
Pj4+PiAJcmV0dXJuIGdlbmxfcmVnaXN0ZXJfZmFtaWx5KCZkcGxsX2dubF9mYW1pbHkpOw0KPj4+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oIGIvZHJpdmVycy9kcGxs
L2RwbGxfbmV0bGluay5oDQo+Pj4+IGluZGV4IGUyZDEwMGY1OWRkNi4uMGRjODEzMjBmOTgyIDEw
MDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJzL2RwbGwvZHBsbF9uZXRsaW5rLmgNCj4+Pj4gKysrIGIv
ZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5oDQo+Pj4+IEBAIC0zLDUgKzMsMTIgQEANCj4+Pj4g
ICAqICBDb3B5cmlnaHQgKGMpIDIwMjEgTWV0YSBQbGF0Zm9ybXMsIEluYy4gYW5kIGFmZmlsaWF0
ZXMNCj4+Pj4gICAqLw0KPj4+Pg0KPj4+PiAraW50IGRwbGxfbm90aWZ5X2RldmljZV9jcmVhdGUo
aW50IGRwbGxfaWQsIGNvbnN0IGNoYXIgKm5hbWUpOw0KPj4+PiAraW50IGRwbGxfbm90aWZ5X2Rl
dmljZV9kZWxldGUoaW50IGRwbGxfaWQpOw0KPj4+PiAraW50IGRwbGxfbm90aWZ5X3N0YXR1c19s
b2NrZWQoaW50IGRwbGxfaWQpOw0KPj4+PiAraW50IGRwbGxfbm90aWZ5X3N0YXR1c191bmxvY2tl
ZChpbnQgZHBsbF9pZCk7DQo+Pj4+ICtpbnQgZHBsbF9ub3RpZnlfc291cmNlX2NoYW5nZShpbnQg
ZHBsbF9pZCwgaW50IHNvdXJjZV9pZCwgaW50IHNvdXJjZV90eXBlKTsNCj4+Pj4gK2ludCBkcGxs
X25vdGlmeV9vdXRwdXRfY2hhbmdlKGludCBkcGxsX2lkLCBpbnQgb3V0cHV0X2lkLCBpbnQgb3V0
cHV0X3R5cGUpOw0KPj4+IA0KPj4+IE9ubHkgZHBsbF9ub3RpZnlfZGV2aWNlX2NyZWF0ZSBpcyBh
Y3R1YWxseSB1c2VkLCByZXN0IGlzIG5vdC4NCj4+PiBJIGFtIGdldHRpbmcgY29uZnVzZWQgYSBi
aXQsIHdobyBzaG91bGQgY2FsbCB0aG9zZSAibm90aWZ5IiBmdW5jdGlvbnM/DQo+Pj4gSXQgaXMg
c3RyYWlnaHRmb3J3YXJkIGZvciBjcmVhdGUvZGVsZXRlLCBkcGxsIHN1YnN5c3RlbSBzaGFsbCBk
byBpdCwgYnV0IHdoYXQNCj4+PiBhYm91dCB0aGUgcmVzdD8NCj4+PiBJIHdvdWxkIHNheSBub3Rp
ZmljYXRpb25zIGFib3V0IHN0YXR1cyBvciBzb3VyY2Uvb3V0cHV0IGNoYW5nZSBzaGFsbCBvcmln
aW5hdGUNCj4+PiBpbiB0aGUgZHJpdmVyIGltcGxlbWVudGluZyBkcGxsIGludGVyZmFjZSwgdGh1
cyB0aGV5IHNoYWxsIGJlIGV4cG9ydGVkIGFuZA0KPj4+IGRlZmluZWQgaW4gdGhlIGhlYWRlciBp
bmNsdWRlZCBieSB0aGUgZHJpdmVyLg0KPj4+IA0KPj4NCj4+SSB3YXMgdGhpbmtpbmcgYWJvdXQg
ZHJpdmVyIHRvbywgYmVjYXVzZSBkZXZpY2UgY2FuIGhhdmUgZGlmZmVyZW50IGludGVyZmFjZXMg
dG8gDQo+PmNvbmZpZ3VyZSBzb3VyY2Uvb3V0cHV0LCBhbmQgZGlmZmVyZW50IG5vdGlmaWNhdGlv
bnMgdG8gdXBkYXRlIHN0YXR1cy4gSSB3aWxsIA0KPj51cGRhdGUgcHRwX29jcCBkcml2ZXIgdG8g
aW1wbGVtZW50IHRoaXMgbG9naWMuIEFuZCBpdCB3aWxsIGFsc28gY292ZXIgcXVlc3Rpb24gDQo+
Pm9mIGV4cG9ydGluZyB0aGVzZSBmdW5jdGlvbnMgYW5kIHRoZWlyIGRlZmluaXRpb25zLg0KPj4N
Cj4NCj5HcmVhdCENCj4NCj5UaGFuaywNCj5BcmthZGl1c3oNCj4+Pj4gKw0KPj4+PiBpbnQgX19p
bml0IGRwbGxfbmV0bGlua19pbml0KHZvaWQpOw0KPj4+PiB2b2lkIGRwbGxfbmV0bGlua19maW5p
c2godm9pZCk7DQo+Pj4+IC0tIA0KPj4+PiAyLjI3LjANCj4+Pj4NCj4+DQo+DQoNCkdvb2QgZGF5
IFZhZGltLA0KDQpJIGp1c3Qgd2FudGVkIHRvIG1ha2Ugc3VyZSBJIGRpZG4ndCBtaXNzIGFueXRo
aW5nIHRocm91Z2ggdGhlIHNwYW0gZmlsdGVycyBvcg0Kc29tZXRoaW5nPyBXZSBhcmUgc3RpbGwg
d2FpdGluZyBmb3IgdGhhdCBnaXRodWIgcmVwbywgb3IgeW91IHdlcmUgb24NCnZhY2F0aW9uL2J1
c3ksIHJpZ2h0Pw0KDQpUaGFua3MsDQpBcmthZGl1c3oNCg==
