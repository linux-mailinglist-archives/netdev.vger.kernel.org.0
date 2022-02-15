Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD9B4B6914
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiBOKSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:18:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiBOKSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:18:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C2DBCB6;
        Tue, 15 Feb 2022 02:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644920301; x=1676456301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uIgUAvwFXFL53Da1lpBlxcaeImhmAPEUmNwlb/ZJS8w=;
  b=JO0qKOxMSspRpUCcYRaZgio1gaFtwosgjvEODQQxrxokrS/teLSqScKe
   hcgJRoFMYJbcOSJJAS3R4SOTrsrRA2aXPJeCN/rQfNvK7YxtXFxEk6uyP
   ElWJ9mADUZ6GQksXzzyutMbblekvHUmsJuhGHSWgiLtIvCdaAGHjJfR5x
   Q/ITmmfm0+NnK9TG3z9IgSSRIssqm1WjHBO1ZmtIk7+Ian0aUtqFEdZat
   0e2PSv5okFgi2NBtYow2vumD4h4kzS0siwfi9wi8xIcuX68FqQjWmD2xu
   hPkBy3WN86xJkxR2fGDuOYB33vphJxrRbVPtUSY4Y0wFJSQ6NzpQ1dvLm
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="233862386"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="233862386"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 02:18:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="680963667"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2022 02:18:20 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 02:18:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 02:18:20 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 02:18:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlIL/5sEiw0ukvOsHWrn3JFESF89DP4SJ7v17pBgs17xRgN09zg4ZUg+6Bvdr1swUP000Josh3x7rrPjuRH5AAZR6i+AkGSumi5RxmNfvL5h4vitmvqt/N6+mTSOH8XCvs7WIgG7i2ll4ppJW/ZbNLJMOWNftGwSWKj1wRBoI9KyNnMo4NorgoCVenzo8e6txqW9mJF8G3Z+vJ+zrVCJGh+SV7xEb8Zy/8rANfEf4NTu+SgyENBhrBIerLgvI/Uo3FkRoLPxkzTT97WhsGUBd02XCEwIjJvncZnlpK3HOp9ouU70zOsMHn7Dfj8a1m5GMEBpbk81n9yJwWxaWVopVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIgUAvwFXFL53Da1lpBlxcaeImhmAPEUmNwlb/ZJS8w=;
 b=YsoPWIdecaPrBOw2k+RZfAHj6MRRIwrwmLn5LU+Zf4p7yUVDE8dsddWulTdgi7v4Okx6ncjattXrmUl3qZczAnJ8sCaxCFUaO3mGFoBzwyw6q6bLPMlLVWiIOw/8zRxBipFbc6m1hfWyja1pLGyXoa1JR4FuamXGl8vsW1YY4uHQi/1aP1xL9KwUq3hU0ZgjeHomHN4A30BQuTMrVScF/r6G/oWTNWEjUu+oN248tYf2tWD7LNx0ANC1DTkBXSAZMrxeXMSl7EDskXRdYtuWNIx9VsB5HM+bReAWrWRyrwDxXo1Eo1AnEhHt377TZv75fVEa4dAau+6agp7jsutyrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB3837.namprd11.prod.outlook.com (2603:10b6:208:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 10:18:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 10:18:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Topic: [PATCH V7 mlx5-next 09/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Thread-Index: AQHYHEd+yjnoZ8pnEEOIRNVo6epEhKyUVd/w
Date:   Tue, 15 Feb 2022 10:18:11 +0000
Message-ID: <BN9PR11MB5276D169554630B8345DB7598C349@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-10-yishaih@nvidia.com>
In-Reply-To: <20220207172216.206415-10-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9171bc46-1ffd-43a4-0b9b-08d9f06c787a
x-ms-traffictypediagnostic: MN2PR11MB3837:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MN2PR11MB3837861A747722E0CE8D6A7D8C349@MN2PR11MB3837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: le7HAzB5Ly+Vu9jUClywhCMhJtqGGZ1OmytYAzS3WtQiF2LFilOcwP9jqlq83yA9JedZSyIuZ+P+OWka2GKqBtQXi/0nkX8bLpuZH4hVcXevnQHywcLSE1jqhOSpPAsbwXO8CbssUJwXIEndMkOV6+EW4O79vq8ULRvBNj89/JhEpF3AfocWw6bDCSadIDGpk7deQQNCzEG3dVPVR9A/+A3elWh8Qpn4Mp13tlsataq3xwzqXEYyJ0wdO6jwoJ7/lTCyRW1E0FfT6vHUHHnEcYpd+iITlhAjZ2EDznMjHK8WYf70tRrxEEsAWvLoz1SYuwhvg8ULXvjTKU6v9FPx/bZQnlbJ7TBX53nQKzzZAFSEj+THgyUBttZSQYlKjMq4qO0FoQsmrqBXLrOtTBO7Nfgo+poHtBgaU4YB9yiQL8x4zndxcdkp0eUbvEO6MFHXwQfIpHCKOdMxY8r+9olJVmPghendV929GDAaMkWSfx1D7tUjpr2Fyug3aA77chjhmgJgsqtwgC/gtlu7YIKekgj/dGO5BsYubrsJKpCxCuhwWloE5+/uucGkWfnFL+mXzkYSzWATXbhUYJCA2Gznu2YqIqDB+Lx4/8VuJM+TIBTLxOYCP6vOi0U4OnTRloR2ojEmxFVH67qfR1gJugCtFXWx3sVNJzXBXliUmSfqITJMWlPcCjE6kY1vne35rtKIt68sswGxKd3BR3io/NCHPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(86362001)(38100700002)(33656002)(122000001)(8936002)(7416002)(5660300002)(82960400001)(2906002)(110136005)(4326008)(8676002)(508600001)(71200400001)(9686003)(38070700005)(6506007)(7696005)(76116006)(54906003)(316002)(83380400001)(55016003)(66446008)(66556008)(186003)(66476007)(26005)(64756008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGxqMkNyem1kY01SYjBMTHA2Zi9RMmx0UHd2WWVncmttRGJ6c2NZeUJvNnMr?=
 =?utf-8?B?eEhRQTlVWHJtOCs3dmtzNFFUTWxEZ3hSWWs1aURlbm5XSHpybnpJYTRDampD?=
 =?utf-8?B?enZON1NOZElxTGhRYXFGM2kwNWVxZDRVdnhxMTlUSG1GVHJGblE4ZEgyZGh1?=
 =?utf-8?B?bVlvOVVHYmhGNVBpaGlRR0VlSVhOblhweXdFU3c3LzkxZUpQSnZndHYwUTVw?=
 =?utf-8?B?cGJYWXMwdG9BVUQxSEhsRTBxQlNUYU8vRW5uaWx4YUxmNDl2UG8rNm1hMm5X?=
 =?utf-8?B?V2d0a09wa0dwZ0NzaE9zb2cxZ2Mwc3pWcFlnS0h4UDc0TlE3K0dqYUMwTHdh?=
 =?utf-8?B?czJGTVdGa0s2c00wdXV6RXBqSmdqQlhiOWRLczJqY3Zrclo3RmYxeGE3d3hU?=
 =?utf-8?B?bEhKUTJ2U1FvemVJTGNOL2h6YldNWjRmYXA5amtWNWlVcUxPUGxGUjFhcXU3?=
 =?utf-8?B?REs4SjRZRlZEQjZjVXZCSTYyOXlMeTBabU1BV3ZvMjlFNTFPVXd2N0FrbjFo?=
 =?utf-8?B?SkR5SWVVV1RETHB1ZXRnS0xmTlJSU3A0Z1FRZnVYRmJPbHhFbGErcjJEUEFm?=
 =?utf-8?B?SDRSci9WZFUzbit5dmlrd0ZhRXRxdmlQVmpnTHk5azdSTVFMeXdzakpySFhY?=
 =?utf-8?B?MFdmR3ZtNHg3ZFpnZ2g0TmVkMEJKS1pMS1VZNnIrcVc1VEdvVk1oRElzSkFi?=
 =?utf-8?B?c0RzM01ZM1IydWVBZUhMUytaZkx1bEtnTW9ZU0wvTFBRUHFQb0loRFFBUUtp?=
 =?utf-8?B?VldCNGJoVnIrVzRCbHF3UVcrZk1YaVVJdnN3Z0tISnNURFlBOXFJZXV0KzF3?=
 =?utf-8?B?d01FM3ZHOXpIYzB4MEJ1NEdOaDM3cDdyZDNMUGJ1V1p1WWNWRktxQTBmMTZh?=
 =?utf-8?B?UC9yUXFscmMrTThwd29pZkxIK1gzdCt3Y2pIS1MvaVlRRGNvZmJNVjkvdUFG?=
 =?utf-8?B?Q0VXRk1lbXc1enY3QllRT2NkMzlQcWZBZDhBZEJLYWwxdkprMEpkRkY5T2Jt?=
 =?utf-8?B?aG5QaVRPVEhhY2F6ZUpqeHNIbW1mblI0dmh4VE5US0ZrcFJVTi9IVzczajAy?=
 =?utf-8?B?QTRPR3ZYQjBsVkdWMjl4RDdzTzE1TkkrMk53T25ZRXBHUWphYUlVcW4yTll2?=
 =?utf-8?B?c1Y1MkVjc0gzWVVoY2g4eVJWcno2U1NnZlNWQTY1MldJZ2VTTm10bWRMdFF4?=
 =?utf-8?B?UlNkZ1NaSkdxdC9SVkdYNWtVQm9JdXpTeGR5ZkNzRjRIaUxnQ3lDY3JpT3U4?=
 =?utf-8?B?amVqTWdZTVM5UE92RXNjM0lkWUkyWUJnVzJTN0J2OFFSblpsY3ZsVVVZTzRW?=
 =?utf-8?B?T21oSDFqdmdFWS9hRnJhOC9WT2ZzRHg5MjROUWNMUnV2amNJVGRhVkE4TE9M?=
 =?utf-8?B?UnN1L3hjRUhvamcwNGNLS0Fxc1hpci8raHpKdkIybFVKKzhhZnkwVjZvOCtx?=
 =?utf-8?B?OXdsam1TeDE0WTJIQ1JIdFIrR3Zjelp1Q3luYnFVamlId2dQQkJCdW56SDR0?=
 =?utf-8?B?WjFvVndCcUI5dVNtcmZMNmpRcnhMaWZadS9FOVRQN3ZzQkhYMk42VkViYkdX?=
 =?utf-8?B?NWErL2czSDFhN1lYYTI4dnhlWEFhT3dTOXJtTlJDMmhpbXVqY0RZSXJ2c04z?=
 =?utf-8?B?bWt6NFR3VU1PV2dFcDBsRVZzc2RlV1VzdlFwWkNwbkxBcWlDbjJwNTQ2UC9p?=
 =?utf-8?B?aTN5b2pHbHJZRW9XWmpoUkVrK2ZhQ2krR2RxT3lRcXpNaHRrKzJwR2lNVnVo?=
 =?utf-8?B?NzRYaEpmOWoyN1RQTGZGa2xad3oyODBKM0swVGtnd3dOYVFlOGs4WENIMzNp?=
 =?utf-8?B?S1AxbmpvRkw1YlJQK00vUUdvVzZrak5wZ0JvVEhWd0UrM29zYnFodHN0N3M2?=
 =?utf-8?B?MGpaeW1raHMzQjZ5bjBwZHc0Q204RnVzSTdPL2pReTY4Z0J6aWRHeTgveFg4?=
 =?utf-8?B?N2J0aGEzVXYwTFV4UkhnNERQdXp5dHlpUGQ2NWtwc29SblZwUkpqS3JBM1Rn?=
 =?utf-8?B?WnYvRzJtbDVmcW1UYXJoeXFTOFpxaVNNUThjMXVKVHFnUFF6Q3RJQzN6OGVo?=
 =?utf-8?B?MWlMblhqYVhVTnpRcG1KMTh0ZnErS3J3YUtaeVp3aFJEMmVuaTAwZ0YxWVYr?=
 =?utf-8?B?R1hRUEs0K3VscTdVS0VlUGlwR2xFeFhlaUtXZzVTbTdLYXlCRWo3SEhnSW5I?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9171bc46-1ffd-43a4-0b9b-08d9f06c787a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 10:18:11.7096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O7ajmRV0gjmgYOqeo5ZFMzcMzg4KCFvWF0hAYDu6RB9tOKH5wt9cIoJHO009aNYU+fUkHTlVU+tT1+lpWEpUiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3837
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT4NCj4gU2VudDogVHVlc2Rh
eSwgRmVicnVhcnkgOCwgMjAyMiAxOjIyIEFNDQo+IA0KPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUg
PGpnZ0BudmlkaWEuY29tPg0KPiANCj4gVGhlIFJVTk5JTkdfUDJQIHN0YXRlIGlzIGRlc2lnbmVk
IHRvIHN1cHBvcnQgbXVsdGlwbGUgZGV2aWNlcyBpbiB0aGUgc2FtZQ0KPiBWTSB0aGF0IGFyZSBk
b2luZyBQMlAgdHJhbnNhY3Rpb25zIGJldHdlZW4gdGhlbXNlbHZlcy4gV2hlbiBpbg0KPiBSVU5O
SU5HX1AyUA0KPiB0aGUgZGV2aWNlIG11c3QgYmUgYWJsZSB0byBhY2NlcHQgaW5jb21pbmcgUDJQ
IHRyYW5zYWN0aW9ucyBidXQgc2hvdWxkIG5vdA0KPiBnZW5lcmF0ZSBvdXRnb2luZyB0cmFuc2Fj
dGlvbnMuDQoNCm91dGdvaW5nICdQMlAnIHRyYW5zYWN0aW9ucy4NCg0KPiANCj4gQXMgYW4gb3B0
aW9uYWwgZXh0ZW5zaW9uIHRvIHRoZSBtYW5kYXRvcnkgc3RhdGVzIGl0IGlzIGRlZmluZWQgYXMN
Cj4gaW5iZXR3ZWVuIFNUT1AgYW5kIFJVTk5JTkc6DQo+ICAgIFNUT1AgLT4gUlVOTklOR19QMlAg
LT4gUlVOTklORyAtPiBSVU5OSU5HX1AyUCAtPiBTVE9QDQo+IA0KPiBGb3IgZHJpdmVycyB0aGF0
IGFyZSB1bmFibGUgdG8gc3VwcG9ydCBSVU5OSU5HX1AyUCB0aGUgY29yZSBjb2RlIHNpbGVudGx5
DQo+IG1lcmdlcyBSVU5OSU5HX1AyUCBhbmQgUlVOTklORyB0b2dldGhlci4gRHJpdmVycyB0aGF0
IHN1cHBvcnQgdGhpcyB3aWxsDQoNCkl0IHdvdWxkIGJlIGNsZWFyZXIgaWYgZm9sbG93aW5nIG1l
c3NhZ2UgY291bGQgYmUgYWxzbyByZWZsZWN0ZWQgaGVyZToNCg0KICArICogVGhlIG9wdGlvbmFs
IHN0YXRlcyBjYW5ub3QgYmUgdXNlZCB3aXRoIFNFVF9TVEFURSBpZiB0aGUgZGV2aWNlIGRvZXMg
bm90DQogICsgKiBzdXBwb3J0IHRoZW0uIFRoZSB1c2VyIGNhbiBkaXNjb3ZlciBpZiB0aGVzZSBz
dGF0ZXMgYXJlIHN1cHBvcnRlZCBieSB1c2luZw0KICArICogVkZJT19ERVZJQ0VfRkVBVFVSRV9N
SUdSQVRJT04uIA0KDQpPdGhlcndpc2UgdGhlIG9yaWdpbmFsIGNvbnRleHQgcmVhZHMgbGlrZSBS
VU5OSU5HX1AyUCBjYW4gYmUgdXNlZCBhcw0KZW5kIHN0YXRlIGV2ZW4gaWYgdGhlIHVuZGVybHlp
bmcgZHJpdmVyIGRvZXNuJ3Qgc3VwcG9ydCBpdCB0aGVuIG1ha2VzIG1lDQp3b25kZXIgd2hhdCBp
cyB0aGUgcG9pbnQgb2YgdGhlIG5ldyBjYXBhYmlsaXR5IGJpdC4NCg0KPiBiZQ0KPiByZXF1aXJl
ZCB0byBpbXBsZW1lbnQgNCBGU00gYXJjcyBiZXlvbmQgdGhlIGJhc2ljIEZTTS4gMiBvZiB0aGUg
YmFzaWMgRlNNDQo+IGFyY3MgYmVjb21lIGNvbWJpbmF0aW9uIHRyYW5zaXRpb25zLg0KPiANCj4g
Q29tcGFyZWQgdG8gdGhlIHYxIGNsYXJpZmljYXRpb24sIE5ETUEgaXMgcmVkZWZpbmVkIGludG8g
RlNNIHN0YXRlcyBhbmQgaXMNCj4gZGVzY3JpYmVkIGluIHRlcm1zIG9mIHRoZSBkZXNpcmVkIFAy
UCBxdWllc2NlbnQgYmVoYXZpb3IsIG5vdGluZyB0aGF0DQo+IGhhbHRpbmcgYWxsIERNQSBpcyBh
biBhY2NlcHRhYmxlIGltcGxlbWVudGF0aW9uLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmFzb24g
R3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWlzaGFpIEhhZGFz
IDx5aXNoYWloQG52aWRpYS5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy92ZmlvL3ZmaW8uYyAgICAg
ICB8IDc5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAgaW5jbHVk
ZS9saW51eC92ZmlvLmggICAgICB8ICAxICsNCj4gIGluY2x1ZGUvdWFwaS9saW51eC92ZmlvLmgg
fCAzNCArKysrKysrKysrKysrKysrLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA5NSBpbnNlcnRpb25z
KCspLCAxOSBkZWxldGlvbnMoLSkNCj4gDQo+IEBAIC0xNjMxLDE3ICsxNjU3LDM2IEBAIGludCB2
ZmlvX21pZ19nZXRfbmV4dF9zdGF0ZShzdHJ1Y3QgdmZpb19kZXZpY2UNCg0KWy4uLl0NCg0KPiAg
CSpuZXh0X2ZzbSA9IHZmaW9fZnJvbV9mc21fdGFibGVbY3VyX2ZzbV1bbmV3X2ZzbV07DQo+ICsJ
d2hpbGUgKChzdGF0ZV9mbGFnc190YWJsZVsqbmV4dF9mc21dICYgZGV2aWNlLT5taWdyYXRpb25f
ZmxhZ3MpICE9DQo+ICsJCQlzdGF0ZV9mbGFnc190YWJsZVsqbmV4dF9mc21dKQ0KPiArCQkqbmV4
dF9mc20gPSB2ZmlvX2Zyb21fZnNtX3RhYmxlWypuZXh0X2ZzbV1bbmV3X2ZzbV07DQo+ICsNCg0K
QSBjb21tZW50IGhpZ2hsaWdodGluZyB0aGUgc2lsZW50IG1lcmdpbmcgb2YgdW5zdXBwb3J0ZWQg
c3RhdGVzIHdvdWxkDQpiZSBpbmZvcm1hdGl2ZSBoZXJlLg0KDQphbmQgSSBoYXZlIGEgcHV6emxl
IG9uIGZvbGxvd2luZyBtZXNzYWdlczoNCg0KPiAgICoNCj4gKyAqIEFuZCAxIG9wdGlvbmFsIHN0
YXRlIHRvIHN1cHBvcnQgVkZJT19NSUdSQVRJT05fUDJQOg0KPiArICogIFJVTk5JTkdfUDJQIC0g
UlVOTklORywgZXhjZXB0IHRoZSBkZXZpY2UgY2Fubm90IGRvIHBlZXIgdG8gcGVlcg0KPiBETUEN
Cj4gICAqDQoNCmFuZA0KDQo+ICsgKiBSVU5OSU5HX1AyUCAtPiBSVU5OSU5HDQo+ICAgKiAgIFdo
aWxlIGluIFJVTk5JTkcgdGhlIGRldmljZSBpcyBmdWxseSBvcGVyYXRpb25hbCwgdGhlIGRldmlj
ZSBtYXkNCj4gZ2VuZXJhdGUNCj4gICAqICAgaW50ZXJydXB0cywgRE1BLCByZXNwb25kIHRvIE1N
SU8sIGFsbCB2ZmlvIGRldmljZSByZWdpb25zIGFyZSBmdW5jdGlvbmFsLA0KPiAgICogICBhbmQg
dGhlIGRldmljZSBtYXkgYWR2YW5jZSBpdHMgaW50ZXJuYWwgc3RhdGUuDQo+ICAgKg0KDQphbmQg
YmVsb3cNCg0KPiArICogVGhlIG9wdGlvbmFsIHBlZXIgdG8gcGVlciAoUDJQKSBxdWllc2NlbnQg
c3RhdGUgaXMgaW50ZW5kZWQgdG8gYmUgYQ0KPiBxdWllc2NlbnQNCj4gKyAqIHN0YXRlIGZvciB0
aGUgZGV2aWNlIGZvciB0aGUgcHVycG9zZXMgb2YgbWFuYWdpbmcgbXVsdGlwbGUgZGV2aWNlcyB3
aXRoaW4NCj4gYQ0KPiArICogdXNlciBjb250ZXh0IHdoZXJlIHBlZXItdG8tcGVlciBETUEgYmV0
d2VlbiBkZXZpY2VzIG1heSBiZSBhY3RpdmUuDQo+IFRoZQ0KPiArICogUlVOTklOR19QMlAgc3Rh
dGVzIG11c3QgcHJldmVudCB0aGUgZGV2aWNlIGZyb20gaW5pdGlhdGluZw0KPiArICogYW55IG5l
dyBQMlAgRE1BIHRyYW5zYWN0aW9ucy4gSWYgdGhlIGRldmljZSBjYW4gaWRlbnRpZnkgUDJQIHRy
YW5zYWN0aW9ucw0KPiArICogdGhlbiBpdCBjYW4gc3RvcCBvbmx5IFAyUCBETUEsIG90aGVyd2lz
ZSBpdCBtdXN0IHN0b3AgYWxsIERNQS4gVGhlDQo+IG1pZ3JhdGlvbg0KPiArICogZHJpdmVyIG11
c3QgY29tcGxldGUgYW55IHN1Y2ggb3V0c3RhbmRpbmcgb3BlcmF0aW9ucyBwcmlvciB0bw0KPiBj
b21wbGV0aW5nIHRoZQ0KPiArICogRlNNIGFyYyBpbnRvIGEgUDJQIHN0YXRlLiBGb3IgdGhlIHB1
cnBvc2Ugb2Ygc3BlY2lmaWNhdGlvbiB0aGUgc3RhdGVzDQo+ICsgKiBiZWhhdmUgYXMgdGhvdWdo
IHRoZSBkZXZpY2Ugd2FzIGZ1bGx5IHJ1bm5pbmcgaWYgbm90IHN1cHBvcnRlZC4NCg0KRGVmaW5p
bmcgUlVOTklOR19QMlAgaW4gYWJvdmUgd2F5IGltcGxpZXMgdGhhdCBSVU5OSU5HX1AyUCBpbmhl
cml0cyANCmFsbCBiZWhhdmlvcnMgaW4gUlVOTklORyBleGNlcHQgYmxvY2tpbmcgb3V0Ym91bmQg
UDJQOg0KCSogZ2VuZXJhdGUgaW50ZXJydXB0cyBhbmQgRE1Bcw0KCSogcmVzcG9uZCB0byBNTUlP
DQoJKiBhbGwgdmZpbyByZWdpb25zIGFyZSBmdW5jdGlvbmFsDQoJKiBkZXZpY2UgbWF5IGFkdmFu
Y2UgaXRzIGludGVybmFsIHN0YXRlDQoJKiBkcmFpbiBhbmQgYmxvY2sgb3V0c3RhbmRpbmcgUDJQ
IHJlcXVlc3RzDQoNCkkgdGhpbmsgdGhpcyBpcyBub3QgdGhlIGludGVuZGVkIGJlaGF2aW9yIHdo
ZW4gTkRNQSB3YXMgYmVpbmcgZGlzY3Vzc2VkDQppbiBwcmV2aW91cyB0aHJlYWRzLCBhcyBhYm92
ZSBkZWZpbml0aW9uIHN1Z2dlc3RzIHRoZSB1c2VyIGNvdWxkIGNvbnRpbnVlDQp0byBzdWJtaXQg
bmV3IHJlcXVlc3RzIGFmdGVyIG91dHN0YW5kaW5nIFAyUCByZXF1ZXN0cyBhcmUgY29tcGxldGVk
IGdpdmVuDQphbGwgdmZpbyByZWdpb25zIGFyZSBmdW5jdGlvbmFsIHdoZW4gdGhlIGRldmljZSBp
cyBpbiBSVU5OSU5HX1AyUC4NCg0KVGhvdWdoIGp1c3QgYSBuYW1pbmcgdGhpbmcsIHBvc3NpYmx5
IHdoYXQgd2UgcmVhbGx5IHJlcXVpcmUgaXMgYSBTVE9QUElOR19QMlANCnN0YXRlIHdoaWNoIGlu
ZGljYXRlcyB0aGUgZGV2aWNlIGlzIG1vdmluZyB0byB0aGUgU1RPUCAob3IgU1RPUFBFRCkgc3Rh
dGUuDQpJbiB0aGlzIHN0YXRlIHRoZSBkZXZpY2UgaXMgZnVuY3Rpb25hbCBidXQgdmZpbyByZWdp
b25zIGFyZSBub3Qgc28gdGhlIHVzZXIgc3RpbGwNCm5lZWRzIHRvIHJlc3RyaWN0IGRldmljZSBh
Y2Nlc3M6DQoJKiBnZW5lcmF0ZSBpbnRlcnJ1cHRzIGFuZCBETUFzDQoJKiByZXNwb25kIHRvIE1N
SU8NCgkqIGFsbCB2ZmlvIHJlZ2lvbnMgYXJlIE5PVCBmdW5jdGlvbmFsIChubyB1c2VyIGFjY2Vz
cykNCgkqIGRldmljZSBtYXkgYWR2YW5jZSBpdHMgaW50ZXJuYWwgc3RhdGUNCgkqIGRyYWluIGFu
ZCBibG9jayBvdXRzdGFuZGluZyBQMlAgcmVxdWVzdHMNCg0KSW4gdmlydHVhbGl6YXRpb24gdGhp
cyBtZWFucyBRZW11IG11c3Qgc3RvcCB2Q1BVIGZpcnN0IGJlZm9yZSBlbnRlcmluZw0KU1RPUFBJ
TkdfUDJQIGZvciBhIGRldmljZS4NCg0KQmFjayB0byB5b3VyIGVhcmxpZXIgc3VnZ2VzdGlvbiBv
biByZXVzaW5nIFJVTk5JTkdfUDJQIHRvIGNvdmVyIHZQUkkgDQp1c2FnZSB2aWEgYSBuZXcgY2Fw
YWJpbGl0eSBiaXQgWzFdOg0KDQogICAgIkEgY2FwIGxpa2UgInJ1bm5pbmdfcDJwIHJldHVybnMg
YW4gZXZlbnQgZmQsIGRvZXNuJ3QgZmluaXNoIHVudGlsIHRoZQ0KICAgIFZDUFUgZG9lcyBzdHVm
ZiwgYW5kIHN0b3BzIHByaSBhcyB3ZWxsIGFzIHAycCIgbWlnaHQgYmUgYWxsIHRoYXQgaXMNCiAg
ICByZXF1aXJlZCBoZXJlIChhbmQgbm90IGFuIGFjdHVhbCBuZXcgc3RhdGUpIg0KDQp2UFJJIHJl
cXVpcmVzIGEgUlVOTklORyBzZW1hbnRpY3MuIEEgbmV3IGNhcGFiaWxpdHkgYml0IGNhbiBjaGFu
Z2UgDQp0aGUgYmVoYXZpb3JzIGxpc3RlZCBhYm92ZSBmb3IgU1RPUFBJTkdfUDJQIHRvIGJlbG93
Og0KCSogYm90aCBQMlAgYW5kIHZQUkkgcmVxdWVzdHMgc2hvdWxkIGJlIGRyYWluZWQgYW5kIGJs
b2NrZWQ7DQoJKiBhbGwgdmZpbyByZWdpb25zIGFyZSBmdW5jdGlvbmFsICh3aXRoIGEgUlVOTklO
RyBiZWhhdmlvcikgc28NCgkgIHZDUFVzIGNhbiBjb250aW51ZSBydW5uaW5nIHRvIGhlbHAgZHJh
aW4gdlBSSSByZXF1ZXN0czsNCgkqIGFuIGV2ZW50ZmQgaXMgcmV0dXJuZWQgZm9yIHRoZSB1c2Vy
IHRvIHBvbGwtd2FpdCB0aGUgY29tcGxldGlvbg0KCSAgb2Ygc3RhdGUgdHJhbnNpdGlvbjsNCg0K
YW5kIGluIHRoaXMgcmVnYXJkIHBvc3NpYmx5IGl0IG1ha2VzIG1vcmUgc2Vuc2UgdG8gY2FsbCB0
aGlzIHN0YXRlIA0KYXMgU1RPUFBJTkcgdG8gZW5jYXBzdWxhdGUgYW55IG9wdGlvbmFsIHByZXBh
cmF0aW9uIHdvcmsgYmVmb3JlIA0KdGhlIGRldmljZSBjYW4gYmUgdHJhbnNpdGlvbmVkIHRvIFNU
T1AgKHdpdGggZGVmYXVsdCBhcyBkZWZpbmVkIGZvcg0KU1RPUFBJTkdfUDJQIGFib3ZlIGFuZCBh
Y3R1YWwgYmVoYXZpb3IgY2hhbmdlYWJsZSBieSBmdXR1cmUNCmNhcGFiaWxpdHkgYml0cyk/IA0K
DQpPbmUgYWRkaXRpb25hbCByZXF1aXJlbWVudCBpbiBkcml2ZXIgc2lkZSBpcyB0byBkeW5hbWlj
YWxseSBtZWRpYXRlIHRoZSANCmZhc3QgcGF0aCBhbmQgcXVldWUgYW55IG5ldyByZXF1ZXN0IHdo
aWNoIG1heSB0cmlnZ2VyIHZQUkkgb3IgUDJQDQpiZWZvcmUgbW92aW5nIG91dCBvZiBSVU5OSU5H
X1AyUC4gSWYgbW92aW5nIHRvIFNUT1BfQ09QWSwgdGhlbg0KcXVldWVkIHJlcXVlc3RzIHdpbGwg
YWxzbyBiZSBpbmNsdWRlZCBhcyBkZXZpY2Ugc3RhdGUgdG8gYmUgcmVwbGF5ZWQNCmluIHRoZSBy
ZXN1bWluZyBwYXRoLg0KDQpEb2VzIGFib3ZlIHNvdW5kIGEgcmVhc29uYWJsZSB1bmRlcnN0YW5k
aW5nIG9mIHRoaXMgRlNNIG1lY2hhbmlzbT8gDQoNCj4gKyAqDQo+ICsgKiBUaGUgb3B0aW9uYWwg
c3RhdGVzIGNhbm5vdCBiZSB1c2VkIHdpdGggU0VUX1NUQVRFIGlmIHRoZSBkZXZpY2UgZG9lcyBu
b3QNCj4gKyAqIHN1cHBvcnQgdGhlbS4gVGhlIHVzZXIgY2FuIGRpc29jdmVyIGlmIHRoZXNlIHN0
YXRlcyBhcmUgc3VwcG9ydGVkIGJ5DQoNCidkaXNvY3ZlcicgLT4gJ2Rpc2NvdmVyJw0KDQpUaGFu
a3MNCktldmluDQo=
