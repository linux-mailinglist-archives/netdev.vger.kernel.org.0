Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5426E3DAC
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 04:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDQCym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 22:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDQCyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 22:54:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACF12716;
        Sun, 16 Apr 2023 19:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681700052; x=1713236052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m5jA0fpX6W2lnZXAUiA2jpc4Pcc7FrwtAAPqau7AlUQ=;
  b=Yw65qLp0h1FOfly0PIIl+edlDVBJjkDHg0p8pOiPVCJTO134bHc8nFPP
   lrcAc6EZXZnj6K9IUbE6ZkioSHtH4GKOJwd4kRtj5u/HbCzUTcREqwiRn
   cUeWcKgp8G8astWdP6akFacypbtToRXGNSV4fvm1D+bk7gT1Y5peaQHPZ
   kR7JHon44UcA9nCNVbvauG6HWZnHWf7IS2VaEbP+gLmF7SBidjz+Xjj2W
   arhbo4Pr0SisMg7DFbVD8qbnh3hCQsKMbl0yLibl9hBtu/m18Qx/i/Fth
   zlXUHaWKrm10lE0Hfg3+63NM+orPhFWUYnKvLkxIlIEOysC4eruhuOszC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="342282037"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="342282037"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2023 19:53:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="667958089"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="667958089"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2023 19:53:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 19:53:17 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 16 Apr 2023 19:53:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 16 Apr 2023 19:53:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 16 Apr 2023 19:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrPorqFORrIosZPhIIY5Qi0Qn9f8UdA95vGWE49cwPyTb167IAvJPRYO8lshWGXRzJK3zB95jePNl4Sy55vgY+dZDFDzSYTYL91kFpha2eawYZVSw3oUVAtsJ+4TLwaQnR5iGW7i/0Jrocn8wlJf0CVdfoZPk6KGUDZX3gnVXCm3ZmEYCPeC9ltsWZAp0iHTiANSsZma/9d0xlwZ8YyVuSKJgs6RyOoH8mjCsiXE20rWw1d4d51rGpsUvGY4Gia7u/l1hfVe6YYnMQnjbj6eQZimhkpWaCKKbKEBCRsRskbbqJlADtrdIobyRyrMf3bdZdQZFNl8YB5nnXG9TXm96A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bthDm4/ucCkts9kb9iSTxRlgJ+kt8cHcI6GU6AztvSw=;
 b=l1NYLfx0sPbNcINUDSu2sjfcN1E1rcRQQEnKcuFdBVNLvj1Oz0PpZsfWUBnNeJwaPFW0ZbXeDUigm/993i0Mxt/RUGfAgreBrTcuesAm3Y/NNh0HEjWtNshXVTaNvuM9SsOkcoQeqrWD7WREWuzUctM4kV1gPw7mwjSBjVTCDmoipnGP/17fbFBMJIZ8vXhhYTYgJ576bwI1tO0I+iu/g3p7w70AJ/a8DWMLxSiA0BzeTA+/GLjAaSSgQAp5KvabkEIhi5G4kj3v5/bSELzuQazlO/PCcc4vakjm1gQGwiIAx8Rr40LXbE5t38O0YQU+Y7E+GyenxoE+m4Qu4G6jmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by MW3PR11MB4747.namprd11.prod.outlook.com (2603:10b6:303:2f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 02:53:14 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::1977:c45:c8b3:b5bc]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::1977:c45:c8b3:b5bc%3]) with mapi id 15.20.6298.030; Mon, 17 Apr 2023
 02:53:14 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "Stanislav Fomichev" <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
CC:     "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Thread-Topic: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Thread-Index: AQHZcHX/ivZcm3VPRkiLBsOfvIXTYa8uyaLQ
Date:   Mon, 17 Apr 2023 02:53:13 +0000
Message-ID: <SJ1PR11MB618095F79E53B077E922F900B89C9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
 <ffa2551d-ca04-3fe9-944a-0383e1d079e3@siemens.com>
 <PH0PR11MB58306BDB63286338EABAF61AD89F9@PH0PR11MB5830.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB58306BDB63286338EABAF61AD89F9@PH0PR11MB5830.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|MW3PR11MB4747:EE_
x-ms-office365-filtering-correlation-id: 7bfad336-8a47-42f5-564e-08db3eeee2f6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LDwjB5RBi5JweCxvDwTpXD3Ip1+l/Zy/jHOuk4dsLzv3YGmVz2xFt5CObIMLvQ+0xdeASKxxRYxkYy3cTzn4GE4otLewtVQp0jytqroKmI9Btmo1cQQOpoBwYHuRdjiW6LC1ZMGHS+wLIzt0zALbaEhG2Nn6m3ct5zgXRC2emBIt/UZHs4DZDXc5Byo2vrfObo4G72VapQ++IKciaReUu/c+Old2f30g3vpFCwRi0dGusHB0F+3fhh/P10AXQxy7RWTBTscPp0lVFJz/whsHnq0zIHkdtNUv3OPqsRj4FGxs/H0rSmu0NJiLDrwWzHwZCt0GVt4RyLrqCNEAyxVEkff6Je00FYeaPMk/7cOZLOtPKUchdSl7R77wgRINoaSjQUhK+SxEs5US72vUfdR82rlOcUbDcB7DsRqh26TT4wNJRKjh/6a30nnsJoyXgjkWFNRt6XJedg4o62BHxJLI6EXZfZ0alwdwAIeLsGoiFPzwBWVD/ULWzXXOGOuBKYkWPfHhqc/qWBdg/LVulxMbrqYbunqMR/ecfzEH67PHM4DO6ufQasaUxlYkg+DbU3tKf3ON7hsCIxODnyKOb9L++3LjQQrG8o0daREqiuykiP6u/WE9Yej2ZGZvpF5p/kTvKvNl+fx4zq3I+PfAfaemU+VGEiIKQyzuKjPQ6oaDt+Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199021)(54906003)(110136005)(55016003)(7696005)(71200400001)(478600001)(41300700001)(316002)(921005)(82960400001)(83380400001)(64756008)(4326008)(66556008)(966005)(186003)(9686003)(66446008)(53546011)(6506007)(26005)(76116006)(66946007)(66476007)(52536014)(5660300002)(7416002)(2906002)(8936002)(8676002)(38100700002)(38070700005)(122000001)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RzY7t32d0EXu8SXzGXZeKIGd0ZcCoKOJSeYSaC6fyhst07oO4VnOioGrzx+m?=
 =?us-ascii?Q?tKjyryzFPRPjGSBvTBV04KNWPoTy0SihrL1kNOpc5YpWHrFBy7L0G7PDkHjp?=
 =?us-ascii?Q?DhMaLeZoAXJV4u8OZIfQ1XhDX2BfA8bl8BQTNuDkUpyHJbcqRiGOi4L6YVxb?=
 =?us-ascii?Q?KGH4aNI4ZGloJHU5d3S5wZTEMzu/vXlwTU6xX4YoGCrxTiDztyT5mg5P/sKT?=
 =?us-ascii?Q?FjmwPK/dlp6o98GueLdbaeCj0Lztb3kP+FRIZD9w0+wvRFqgHAxwDwX7otqL?=
 =?us-ascii?Q?fzb0oM66YqBvWtT7bDZIaXZQNL1Eg+l0qWAP5xmBlUOhC23pWGRkyGGejlQp?=
 =?us-ascii?Q?fa2jjuvPo1E42huMEeIB/sSmmN3MRgWODgiwZdZ9kDgrNnHj/4/pvYzZl0wI?=
 =?us-ascii?Q?G9+kAsbOchiIrK21XVic1WEmiMZ36FnEqgjhvWKF8M62SvqTqBGlF063lDjI?=
 =?us-ascii?Q?efA8z1aeaoFR4hR27IzOx2gtzdu8bwK0gPvuH+JwYT2dZstU0MaQPm+TymQI?=
 =?us-ascii?Q?Gb/wOu/+fKJY6Lyg8+QmiBNorbXdkrtOLhc95gR4cVNrSPwiv+QUcr0cTgqF?=
 =?us-ascii?Q?AkXSxVJRCXgFCT2m1MDLShDgz2M8Bb8ODrc24ICTmNjX6Ggl/EyLJ1S58oQx?=
 =?us-ascii?Q?54DgcwH/DLt1iuykeH7xE26n+d++SQ7/d4lfE9BXOsSme9kNP3IeHZwgbMD0?=
 =?us-ascii?Q?4DKjCuEf+hc4ywoUwcLEFlxA2i1HnGEIdCmoV5jzxf67NQIPMwEb7Fu7F8GD?=
 =?us-ascii?Q?WD1THsE1dtpL05AVuizsZWsxCKqBt8D9yXgv9KsQ7RewknC0LIesHRRm8iG8?=
 =?us-ascii?Q?hiKAQqG+5clzQCEjrjpbp3xO3mZUpmNQ5bzqa+4bVHYQ9NnHLKbKDy3EmQVt?=
 =?us-ascii?Q?aPxiFKH99RbeSzqQtRN3UMbZ8LyR4dpmgoOSAiK2a4Pi/R5GUbsv0W+cMUbw?=
 =?us-ascii?Q?teGU8SiKFcs2iKUQ0e5Q3nkdputkdANApkYiRvlG9aOJM/i+1woLplHxd6+6?=
 =?us-ascii?Q?dD0E92NJolDjWGt5qOSlkbeViz8S61c9fZJKuabI37KDsuCX303IKHLXeHc5?=
 =?us-ascii?Q?SBq9UxDyLtmoPPEkZd3r2Lse23VclF8hk4KUcwfmZUm9VCQXvNe1FXFJtSEZ?=
 =?us-ascii?Q?m4AvDzPOFC62Q1aj+nl1KLgetRbYOG86Vf0XVMkGf5VFlSwKTUeMNq5Lro2Q?=
 =?us-ascii?Q?f6PJLDQrAHxkWq6qCeHeXwUD/4TumGq5VmhgTL+0nqMOQ2NxBq1CW2zIB99z?=
 =?us-ascii?Q?dGOedv+Nwe0Kx7DlzgJlqpEwKW5f0a684VAVSd4V33z1kXoN8egcXAAXtDRL?=
 =?us-ascii?Q?ZUiL9Ws3kQndiEEkRiwXUzXKuBl3OkPSTcVI/gXCYRMc3ejXtOOYlgrVySDJ?=
 =?us-ascii?Q?4+rsJfR6XM1PDOcpJeHMRPTZgeabzU73vmALNfUMPjhaRCWXDHCbEbXbDt9Q?=
 =?us-ascii?Q?XaphrEuEB76hZZkfEYsASLRlBW7Kkk+3U/72BY4ooJewAIl4gT88nEvAxrj2?=
 =?us-ascii?Q?Y9vbeCK/T6c2bknysKeV2nmOOJER98jpH+pcfSzglBVai7TJBtbJ59T5zuQV?=
 =?us-ascii?Q?ZKf3N+Oen9Lsv1pa+FNanTFmoIDfVUor3GeBIipt0gXps3Gluqi/cQxFDlSO?=
 =?us-ascii?Q?LuIcE+fzNUYICmk8/SQrdRs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfad336-8a47-42f5-564e-08db3eeee2f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2023 02:53:13.3402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rmwht2gETBVs4NiYiL7E4tKqp/wAvvP8VHqAc0aJ8I6XRCWFe+Fjz+pjVxMyFyueUHdmDBbzg+bY43jvCfVke4JS75x0uYAeVrK41mjv3n85/fOkZQNukzkPi7nnWU0i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4747
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Song, Yoong Siang
> Sent: Sunday, 16 April, 2023 10:19 AM
> To: Bezdeka, Florian <florian.bezdeka@siemens.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S . Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>;
> Daniel Borkmann <daniel@iogearbox.net>; Jesper Dangaard Brouer
> <hawk@kernel.org>; John Fastabend <john.fastabend@gmail.com>;
> Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; Vedang Patel
> <vedang.patel@intel.com>; Joseph, Jithu <jithu.joseph@intel.com>; Andre
> Guedes <andre.guedes@intel.com>; Brouer, Jesper <brouer@redhat.com>;
> Stanislav Fomichev <sdf@google.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>; David Laight <David.Laight@ACULAB.COM>
> Cc: xdp-hints@xdp-project.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org; bpf@vger.kernel.org
> Subject: Re: [Intel-wired-lan] [PATCH net v3 1/1] igc: read before write =
to
> SRRCTL register
>=20
> On Saturday, April 15, 2023 5:20 PM, Florian Bezdeka
> <florian.bezdeka@siemens.com> wrote:
> >On 14.04.23 17:49, Song Yoong Siang wrote:
> >> igc_configure_rx_ring() function will be called as part of XDP
> >> program setup. If Rx hardware timestamp is enabled prio to XDP
> >> program setup, this timestamp enablement will be overwritten when
> >> buffer size is written into SRRCTL register.
> >>
> >
> >Hi all,
> >
> >I'm actually searching for the root cause of a similar problem (RX
> >timestamp lost) that I can reproduce here, but the setup is slightly
> different. The setup:
> >
> >- igc driver
> >- i225/226 network card
> >- When starting to transmit frames using XDP with zero copy enabled
> >  another application (ptp4l) complains about missing RX timestamps
> >- Loading the XDP program has already been removed (not needed for
> >  TX only)
> >- ptp4l is using the traditional socket API
> >- The RX timestamps seem to come back once we stop sending frames
> >  using XDP
> >
> >The "zero copy support" enabled part is important. If ZC support is not
> >requested everything works fine.
> >
> >Any ideas?

Are you observing similar issue like below?
ptp4l: timed out while polling for tx timestamp
ptp4l: increasing tx_timestamp_timeout may correct this issue

If yes, only TXSTAMPO register is used for both PTP and non-PTP packets in=
=20
the current driver code. There is a possibility that the time stamp=20
for a PTP packet will be lost when there is a lot of traffic when multiple=
=20
applications request for hardware transmission timestamps.=20
Few months back, I submitted a patch series to enable the DMA=20
Timestamp for non-ptp packet which can resolve the above issue.
https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulki=
fli@intel.com/T/
Will continuing back the activity soon.

But you might want to try with series submitted by Vinicius as well.
This patch series add support for four sets of timestamping register.
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230228054534.1=
093483-2-vinicius.gomes@intel.com/
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230228054534.1=
093483-3-vinicius.gomes@intel.com/
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230228054534.1=
093483-4-vinicius.gomes@intel.com/

Would it be possible for you to try any of the above patch series
and see if that fixes your problem?

Thanks,
Husaini



> >
> >Best regards,
> >Florian
> >
>=20
> Hi Florian,
>=20
> You means this patch does not help on your issue?
> Need to understand more on the setup and behavior to tell.
> Are ptp4l and XDP ZC Tx apps running on same queue or separate queue?
> I suggest you to run " sudo hwstamp_ctl -i eth0 -r 1 " multiple times in =
the
> middle to check the behavior.
>=20
> Thanks & Regards
> Siang
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
