Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FD74EC9F1
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiC3QtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbiC3QtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:49:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2E227971B;
        Wed, 30 Mar 2022 09:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648658846; x=1680194846;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5cVxqD4ooUyG1Sv+EbX3dcvpbC9xR89Qnh+6edQIYZY=;
  b=ECQrOT58CXS6h6YVnY2j3ffRGH6E7Ub1mO6KYYGOT2Z/5ApeopyM7cl+
   izrR+W6RerDaEQn8oYIoZmgAGfetxUbJ7qY+/dT/KenETBLl55e+wQpdw
   Q2HDcWGvSXczINXNabse8eArefCuEacxNUknRrr6pahh6Yd76IfbwZggk
   wbCdZX1kumxPzSIrZ/CcGXZJjX2SIUWdM0RtpPigZ38cILpD9vzw7EnOq
   SCdRdQSBJK5WvNqauhsyXiNGMzefeUdfCNyqCg/BBJ//1vxWbqWjiiIfy
   5HkqnJbGL+9D4ZO9ZuqgPkS3zSKFMVJjFFOtmElze3P7+GNnftwuhESGG
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259774441"
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="259774441"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 09:47:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="546930927"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 30 Mar 2022 09:47:26 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 09:47:25 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 30 Mar 2022 09:47:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 30 Mar 2022 09:47:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 30 Mar 2022 09:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhRHOPlGeKKhuO9IwAMovjDUiiBZW1UMELyTd4FCgKyJHWlRAnRk0gZBQ1LKGSlRcfSsYEJ3dMz4qycsS7ys4y4eA8iwiTPEOtqWVHXzrPyykBfWKrHSNldb1aGhJI/kOSni5x/bPNMsYa2UshZ78Nf625/w2rUndh3g36L0UB1M2c4ZHJ5YRuaAVO8+rghsLgle+HIkbA+g3jLUGh9s0tVFmVWTdu2v/wi5E0MzEFLFbbFgr1xIiiFsrDnQ4JD33EREyziAa7QPpOxmnON1TTOpEIvf4THFbECkg04e7G77pp7pQ3oXkWeJPjiaCJoxpcnAdrCBAcrSvi9YWl9bqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMHCaOJBLHpqWDcNh01/QHABLA5+d4qi+FKCdsBpqxQ=;
 b=E0PXB45+HHFKEC7ZM0tLz16cfUMMEmS0uP0hBjARLFGgIHRFIiI2KWvw2W+/Vv/dEvNAxHqDrqZDanf26KeCbjDKbD07RYOcXu6lRISgJqcdqKY9PhDy6q67vEHXKRkN6gB/HSx9SvL1N7uDVFnB0WNCdu+KIqHn6jBOcj5Gzqaix7aD55GHJSwXJDwmOxgJL/UfJXenIx80Tj/8dI7kBgWNR5pUByps/Ba4cznwLF977VtSRH0t9w//fte9yhFq6bgtdYFeYW8AcV9PA8/piZz8kD2mPv9JSuJMv18Vbo1/eAK8neeuIFVSxH+aIahDvvt0C0oR0A/nxnxj07630Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0062.namprd11.prod.outlook.com (2603:10b6:301:67::34)
 by SA1PR11MB5801.namprd11.prod.outlook.com (2603:10b6:806:23d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 30 Mar
 2022 16:47:18 +0000
Received: from MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54]) by MWHPR11MB0062.namprd11.prod.outlook.com
 ([fe80::c3c:359:d9c4:3a54%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 16:47:18 +0000
From:   "Michael, Alice" <alice.michael@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: RE: [PATCH net] ice: Fix logic of getting XSK pool associated with Tx
 queue
Thread-Topic: [PATCH net] ice: Fix logic of getting XSK pool associated with
 Tx queue
Thread-Index: AQHYQ1fKeNKey7PBdUWcO1Lt83Ut1qzWQlmAgABjSQCAAX0xkA==
Date:   Wed, 30 Mar 2022 16:47:18 +0000
Message-ID: <MWHPR11MB0062B06CAE27C58EEE54F162E41F9@MWHPR11MB0062.namprd11.prod.outlook.com>
References: <20220329102752.1481125-1-ivecera@redhat.com>
        <YkL0wfgyCq5s8vdu@boxer> <20220329195522.63d332fb@ceranb>
In-Reply-To: <20220329195522.63d332fb@ceranb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6717ed2-2049-4d34-c858-08da126cf3e0
x-ms-traffictypediagnostic: SA1PR11MB5801:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SA1PR11MB5801E6E4C3390D9A3345B8CAE41F9@SA1PR11MB5801.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: okQF2r2TBMY8v7BK2r4VSBdxAvv5tZTtiqsxs7K0c/LRF/yh5OdklrjP7kQJ9AUT2eS6ak8t0pvQl2aUeJpWfRz90jGw8OvzOaVNGla+HZMhl+cZLfgTRvnuuLpTgIsM3EaaCDi7c5LhgV/v7GEKBCM86h/c868fKuZ9seoDTYJ/Nu34FcQJ8imWDHvYQQrBCQ/+Yy8M8R303lJ4nC4hC5DCKULIQ/4S85E9FluYxNruk2TwtGZoV4elzeb+wAQTE08CCMq8hYz+yn+cTQB3/AGi6MisNrl+BBQAWmaST60DLhqDUyeVGlCV+djU30dC0H0QpVg1cYwUCAr4IGW1Cuo0PUvd25g3b+y/zxiBfA/Z4sopzOzfo48X1QyocOVPgvezQZYP8+l21+rwcON+tjUQctWHu+JSjciywHpS7QejJRrhnqTZb5D1SZ5bPZuThX2C0JP08DC4KBSM49VnY4S9JRVdp5mnQ55oUchihojl9xhuC13vQTqJxB6qmZ8pGeuU6OJ/c1o1K5RtBgnGPi0zIK182ozFGoEKlLTnCdiVlFC0L/3X+VeTK1D4WL+URp5gl0TrH7cdVNLGBZ2KGJLZdeQDRYvOjWPN5vbD1dwfUgkXczOsTTSt5d/Tyxhb0lwrI3r2h/ogRi49uhSNV7k+7/YStrBXR/7myPmBe4p6znbMtf1K8EPgRG+6hf7OXzN/RL2T9yR8ra6nRszjMDLlezBhkQI8he0bbOZjU8Plr/siMPh6/dFbyfgUCHfOgjB89dxAT0ar2MtvtgvsZT7qYhkAOoc+roumzhIyoDE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0062.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(26005)(186003)(82960400001)(38100700002)(122000001)(38070700005)(83380400001)(54906003)(6636002)(66556008)(55016003)(4326008)(76116006)(316002)(5660300002)(2906002)(33656002)(8676002)(7696005)(64756008)(8936002)(66946007)(53546011)(52536014)(6506007)(86362001)(9686003)(66476007)(66446008)(7416002)(508600001)(71200400001)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iSc0O9Mlvq36a1InspykdMkTWfObimaXYW0r9cDYamNSrI7jMlwvPQjj+GRI?=
 =?us-ascii?Q?KbUO12b5P7+PUrhXBUOu+t2Ix6hHANPZg6toZLsglcEoX8GdGxbEDH180ttu?=
 =?us-ascii?Q?VcSWNM8PjKAuCl3wGMiJpw9Nnq3SZDnhEXZUA/j2F6bMo4ebo4H1QtZROVTe?=
 =?us-ascii?Q?IjmWkClKTGFSpuoyH6sTSsuaztiw+xYz5+GuevFZ5fBQZF30MiFL1iVATmhH?=
 =?us-ascii?Q?crCfZGXwakX31XQ7XrMsBlUYqAYwe/dzuBfrTXlFDQhCg/XfDVv87ARwVG1U?=
 =?us-ascii?Q?Qh9bu70eRgWEROMW/Y5PyRn12RA8GA52TUu0u4DNL0AyFBOYMIwnQvvDkpBO?=
 =?us-ascii?Q?kdDegsgXiFUPMFKzVb5+kLODj7FLlaDULq3kWLl2l23StL10p57DbQ2fr4vU?=
 =?us-ascii?Q?GB4TiysnBoxZI+Pp3idFAXVZEDsKZzkeTb5qeHAaOvmTOkvrA35tkkhgI9Ox?=
 =?us-ascii?Q?StaWUSXrBoa93kZcbrLIULYsO1rtC0gB7wpOmmBwM1k2b9Wy3jxdpHrid7bL?=
 =?us-ascii?Q?672jWa0CykLHjQNSO5RWiIdQdom5o4y0H8+BpW5Sgns+ftFuvcddKfleTkLU?=
 =?us-ascii?Q?FAU3AxciCaIRCgcRrTEmlDsF/L+vK3YdSuew/XePeEtytP31pTLQ1wpbtq/2?=
 =?us-ascii?Q?XYor6FJQ7JO59pAXOUu4XZVHYvbZjLEKGIDnJoa+L3tLR6+mUC5g/bOe79hd?=
 =?us-ascii?Q?cvS/5v4O2zWXWnq9TeZ/k0c2Nk40YmoxAj2Ywns/R9tF07voTM5ZENbN/rrA?=
 =?us-ascii?Q?vLNBWtd10w8C0ORFa8mSQhcwfjEg6jLsPisPcWjDyEK3JxwGcF4d7/f9xm3X?=
 =?us-ascii?Q?7izKGjzBTo+NnfpIP2C3xy5xvWJ1AspcJ0JC3SC6i3T6YQCdStF38JVHcw4q?=
 =?us-ascii?Q?P8PSQZ9DFY53QXi1I9q5yUbplLBEZwtHQZ3MiWQmZm6H7rd7MO02mlZwMtMd?=
 =?us-ascii?Q?0TLL7Y2mKmFVuPdV/SJMCDgHkQQQNc1IYF0F/WdoZSTs8k38o13obv4o7iUb?=
 =?us-ascii?Q?M5iTDXfPfYdAxcHBwD3OBBRbsaiuPg9lHJWFw6I01pSqkt8ZwfYrnKhkMb9P?=
 =?us-ascii?Q?GMbwG7W4nJ18aL3EzJSqSAfQjd1UnkhLxd+KzEf9c1yjarHZQ76PMNo8muzL?=
 =?us-ascii?Q?HN1PG8KyDjI9QhvzjSRBXIZweqsAk92PMOiLyCiFoUbUqAPl7jDyHvbipFmW?=
 =?us-ascii?Q?1NEzqge1FIyFNa+k0/I2S28PwVsgCKTIlZScwT58MxHeSqAVGcNEShkoT9Yv?=
 =?us-ascii?Q?O22fTRzUOy/TCelKoLrVkbvbLO7te2t1zH6Aq8nyzR+nxjK1KhTLnv33YQ0o?=
 =?us-ascii?Q?NmbxMK5dCACXFC33pghdQRKhDaqu3NIVsKi+uKjY/ZctXfuTeGEKzkh9e6hA?=
 =?us-ascii?Q?+MNoZeRArCaJpw5PpspnIHMwyEKRNGq55Dwr8OHtAV1g5eG3137G0qf9h86Y?=
 =?us-ascii?Q?CMEg3HzL+w5UY3AoUmI2bIWa9LBrj7DudPnH8Dto7TBteFCczE+i93a8UXZX?=
 =?us-ascii?Q?JEMdnlk7nK18gkYKBdTgIJ2l3490O2TyhEX2HJis1Xtmef5dnRGnYALlBn4+?=
 =?us-ascii?Q?Ljv3ZYipv+4ryedxNYoW5DjNEpVSHaB4TYE0uaEB9ihE+hkmcMUq0Sqh962Y?=
 =?us-ascii?Q?tsmd8vQLTtWuQfU/8RFRF/wrE+9qnzntQY/vVTvi6Pk6+OHIkVndj0V8MWZT?=
 =?us-ascii?Q?ZSdalSJHMBp494cT3aCz985CAlrQv601aQRvaJySKlvGvfMzz1swif0prdtl?=
 =?us-ascii?Q?ukFT9GIGuQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0062.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6717ed2-2049-4d34-c858-08da126cf3e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 16:47:18.3084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rsikfikX5otiNydBaoDKt+5FGORcXGyd7x2z8eQE7GtFAu/nMIdl9BMKBkUXup8uLnU3vvgta2b6aazhwsV9zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5801
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Tuesday, March 29, 2022 10:55 AM
> To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; poros <poros@redhat.com>; mschmidt
> <mschmidt@redhat.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; Andrii Nakryiko
> <andrii@kernel.org>; Martin KaFai Lau <kafai@fb.com>; Song Liu
> <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; KP Singh
> <kpsingh@kernel.org>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; Krzyszt=
of
> Kazimierczak <krzysztof.kazimierczak@intel.com>; Lobakin, Alexandr
> <alexandr.lobakin@intel.com>; moderated list:INTEL ETHERNET DRIVERS
> <intel-wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.o=
rg>;
> open list:XDP (eXpress Data Path) <bpf@vger.kernel.org>
> Subject: Re: [PATCH net] ice: Fix logic of getting XSK pool associated wi=
th Tx
> queue
>=20
> On Tue, 29 Mar 2022 14:00:01 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
>=20
> > Thanks for this fix! I did exactly the same patch yesterday and it's
> > already applied to bpf tree:
> >
> > https://lore.kernel.org/bpf/20220328142123.170157-5-maciej.fijalkowski
> > @intel.com/T/#u
> >
> > Maciej
>=20
> Thanks for info... Nice human race condition ;-)
>=20
> I.

I'm covering for Tony this week maintaining this tree.  He let me know ther=
e were a few patches you had to send Ivan and I was waiting on this one.  I=
f I'm following correctly, this one will be dropped and the other ones are =
ready to be sent now to net then?

Alice.
