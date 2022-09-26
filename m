Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF7B5EAD41
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIZQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiIZQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:55:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2866838AC;
        Mon, 26 Sep 2022 08:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664207346; x=1695743346;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cVdSevvhDIWDYS8iV0bUsmnd4ZtdDXW1rzPl0O1tgDg=;
  b=SG+tzfqlHEpj/CGX4mgrSW3yPAMvqMmoWXR0UtY65zkorUtkA/kcAJEx
   d3o/qgu8MUXgSliKWWp91+PMBlnsnTGh8aAMTkt0/p0vbpOI91rWGRwm8
   XKPPD+QpPJqgKJbv+Bl22AIGJvOhgF8OraSK8TMpH9bN83/qVje2Wz3Fi
   nwpkbu+a3h6hobkA3hh2hxnniqdyd90Q0ENzX3ZyL4E/vSQuf3I7QMaem
   nNQeaabrxJDENU7rwXneiUF1zNmVErOR/DjbLHdLJ2LwhMgH4UXFQDhtk
   HV19duYh1tRmxMQ4JkcuAyjIOHigIIQETjd2nrtJnBD55Rt+im5fGxG5c
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="299785946"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="299785946"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 08:49:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="651872904"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="651872904"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 26 Sep 2022 08:49:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 08:49:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 08:49:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 08:49:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhtVrnV1hWrZFMrW6hu+L0FvMm3efW1jV51BgXpDWUPYs92/cWrcS/NaHyp1AkTateGEmJ0rWmbKLghV347RQUlusnKQqDRoBx1ofdB3B6+Gr/2FFlS2Hvigns85tH74mj8Pfp+M8UzVeB5tj9kefJ7RonQ+iidia75muDq0WZmd7W1HHNPyutpemM0mQ2ZMI/WUP5TiebfZXT/EuxLlX04pk1XuTPb5tCpL66td5BdCSWKk00qUe7mqdU6ZxCrMqXSVHR1+xVUUl17Q2fI7WlOdW48kkuAutWAvadPVLvo2RO5CT017btgVcpcnRauIEVC0QltEa8qRpQB1zyKV7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fofTDFGBoNvMPEw1Dpr0xEP1PSg2NB2o1FENz4SGW6I=;
 b=Gjy8JkG/wFQ6bItH6RmDqCdYDrgE73YEiTXqndxOrZB7iLKF4fjqQ8OzEca/83b8O/JETI2JlFZtvYXcd9zP162MyRwysVuN06/zgbZ9kl3x2AixZ/LV1s6UyvONWapsDmXH8LWCyNylv1VJgPU+KC/kkC7lcggq1YsGPIXOvAN9zXIu/NEFDjGrSo8ECnrdW+5Az7bUA02c3apZxRU8E8cbzlHIN4/ezhWYQpd63LnELgKQGpOe84Daq/xXxYcF8Xkt7Monz1Ju8FXwBq4U6bJT24XIL7pinutnheTde/q/rrh8tHW6hrQNPnMFHs9UmJZ0CtJRzUSdGDEfl/szvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1324.namprd11.prod.outlook.com (2603:10b6:3:15::14) by
 BL1PR11MB5221.namprd11.prod.outlook.com (2603:10b6:208:310::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 15:49:02 +0000
Received: from DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::7992:6033:ae1f:3e08]) by DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::7992:6033:ae1f:3e08%11]) with mapi id 15.20.5654.025; Mon, 26 Sep
 2022 15:49:02 +0000
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Kees Cook <keescook@chromium.org>, Vlastimil Babka <vbabka@suse.cz>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Christoph Lameter" <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Daniel Micay <danielmicay@gmail.com>,
        "Yonghong Song" <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v2 06/16] igb: Proactively round up to kmalloc bucket size
Thread-Topic: [PATCH v2 06/16] igb: Proactively round up to kmalloc bucket
 size
Thread-Index: AQHYz4sQnGagtDAy5Ey39TamNoTGUK3x3q/A
Date:   Mon, 26 Sep 2022 15:49:02 +0000
Message-ID: <DM5PR11MB13241141BB4C863F1A01D958C1529@DM5PR11MB1324.namprd11.prod.outlook.com>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-7-keescook@chromium.org>
In-Reply-To: <20220923202822.2667581-7-keescook@chromium.org>
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
x-ms-traffictypediagnostic: DM5PR11MB1324:EE_|BL1PR11MB5221:EE_
x-ms-office365-filtering-correlation-id: 3b13f607-4bfa-4e36-51e6-08da9fd6a282
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B30/mdLOatQAiRtXoSU9ThH7GMZqYobdTBoeUkupZqB8NQQzuiPufJRt+xUV9Mlphn9XaKTnwqkNVNJYRggptoA7kAxQvFhbc886EY3QlyT85/yj2C9zMjalS8Oy3TxjiS1jxCYsURNDSOcF0CAtyMDEjDeR16pObo4J4GfAgrrBAfednKnZ4/UR5BexfId7wivgzrr0QJFp43FV0FfBml2iSePSFbIFhd6VJ6VlpqDv+vydQazHYB7x5HY6d998BLlU1gRMVWXMJjeHv56alVS4Jr+IChnCXsJBE0rwxcmxcK6x1i9NbeiK5O8Yyj7n1nIMoeHuiLZy1hXX9TrOgJ/3TNWzRNuawYp9dMZ5YK2tQpO2GBObKlkt8acIM8Z9sUnzvKkvzAFUppLLMAaSpjo2do6OJLvjLsOC6WKCI7NAIbC2p57ErD8qmMPk0NegJkC5r7ormJKghC2TEuT/FqquQUqboirfhYhQ73+Vfm1CEr0gbtGpqkFDmDPMc4yBZNNdgDnCZTGIJpUOUw1WIcZf7YPVAjE6mniGb3R91hxwArP8PiKJZ73Z56uMBcKCTnmdreIlQxtlZ/wBWSghZVDMizzvlS1bLOEtNGocg2LMDaoBsabjFQ2AdUS1huJUSi7SJ6bbygE2+oP5q5BSvVmPV/JDMVxRjqv0KNo5btFhVfQo3lMG1e7/IZhZpStakQ+oisI/VOrD0OOGC4B/OYmvHx2LNU1uF+rSIkXZw+tPpmcJy5oB+JFibzQStJRlsmH5pGQEmYEKhkyBBkoCdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(54906003)(71200400001)(110136005)(316002)(478600001)(83380400001)(66556008)(76116006)(66946007)(8676002)(4326008)(66476007)(66446008)(41300700001)(7696005)(6506007)(52536014)(64756008)(5660300002)(9686003)(7416002)(26005)(7406005)(38070700005)(2906002)(8936002)(33656002)(186003)(66574015)(82960400001)(122000001)(38100700002)(55016003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?AIGrTDbDFItjn4Ryzw80Jp36y9fRnr/BqJ50poZHfHifbpx3TK4GxN3wLw?=
 =?iso-8859-1?Q?Wf/aeQeLRJCZ9P5nh/rDr4nnMOpahTfkkC+fUPq1MpEbJ46lY873by7FdU?=
 =?iso-8859-1?Q?J2cw3+PkOjZqr952qdBoDP4n8mZoRkqMrL3atK9pR8sqRNdtu8xwFT0Ry4?=
 =?iso-8859-1?Q?E3VFxUQN0aHmYndJtE6YUJtZ4cpUGhWpXPZD00EUFIAfWs08f8yaGjDJ9l?=
 =?iso-8859-1?Q?ncSm+xyxBD1R4/PxRVSYc0Nv1V9aOu4YjTqzAldndhWBHvVFrrUM0YBu3b?=
 =?iso-8859-1?Q?af2gbglzyB5yMA9V3vitzkoMMgO8yH5TSr3W3bosOAoIvAItjDFoqmuFVq?=
 =?iso-8859-1?Q?lLYN8jq4h95OEmiGeFteIAiZBIe6HUlX/nH7LDhl/blo8scMmaAOVsQrdf?=
 =?iso-8859-1?Q?olupVt356KLQ0Og0nB+ecMlN6EbqZPEcruA31MZSZ0lz76ubOChyHrIXXm?=
 =?iso-8859-1?Q?jHkYwR+Uhn03JA8wgBMLgoSpIL/+9dAQVGpMap0j3Rexm/8z40UtGBnVXj?=
 =?iso-8859-1?Q?CSovMeYyGmi4CHXoXfiXuo3glmED68t9C2lq9S75RTDhFTCK3auRcDWbyM?=
 =?iso-8859-1?Q?d/cMOsEr2vc8L7gNrbyI+W6m4b5QRggJ+22xh9hKaVesQMAlW4dMMG8A6T?=
 =?iso-8859-1?Q?79rzTmOGWj3/L5TcmkntS31AB9ZDukDEXFaNXQ8XYUfsbM/Rx1cGQMW3CN?=
 =?iso-8859-1?Q?H4GfFka+AdbGR54KnJFSl8qRL98dkmy1jtk7Z2cZauT0NIx0vppc4KiWN9?=
 =?iso-8859-1?Q?TC0XaITbgjREt+/EAfFGYS0bOszJ704Wv3Npd2AMTav6nAXhl2vVv74sAG?=
 =?iso-8859-1?Q?wFbhbVmou/FcES5nolt2Xb/FVQCwFfBxPv9MwJhdFu8RYUJQiAQaWVx+g2?=
 =?iso-8859-1?Q?7/4zjzaoUy/aYLnulenNzKyEL8bFpR/VOi76HPQP9x2Wl1tqUuvSKT4pWv?=
 =?iso-8859-1?Q?qW6AFEFivC3KSZVhkj58dSSpuDzp+sM/dnUHbL7BG5ppTcdEIxId1G+sD3?=
 =?iso-8859-1?Q?5ALS8UTSqkyW1SRqDYyMNlhsuBzKDRXOD1cKVLu6gO1YcfHYIhczsj5lde?=
 =?iso-8859-1?Q?jm5GeWXoMq2/sovZ2XCfk1kxMWV3r9O2lm7pc3YY6Ng5ImU9MDEmaHmFeP?=
 =?iso-8859-1?Q?kyLvTTPKI+oYCmZwHPWnpnkFDvdvqe0Kc7Qe3rBQXXgOhQdKP+eXbm+V0X?=
 =?iso-8859-1?Q?wxHazAY51hizH4umUdbO69bZRz1m5c/TJnY+lOYaQjLPWDJZwhk7QIydxY?=
 =?iso-8859-1?Q?rstGMoJHAM8AJzg6le3U0UXgLXoDSj8DzopjPGJTNbwzFHBAcNAPhp9Z/M?=
 =?iso-8859-1?Q?c2vlGWNZh56Z0wqfS3JdYCkq34Z4rSx6F/ABopOEmhytlzV18ZBGBsW4mL?=
 =?iso-8859-1?Q?bot2lCu7Fek8tSBGBVu1HOoveRb69bFXLcpJYo7fcCdEN42FqkLUXnSPL1?=
 =?iso-8859-1?Q?a0Khc3p2AVe1ETebA6FZH6M+4n0+tAgeeXDi7VWkVMqWd7NkvM/R7oDBkR?=
 =?iso-8859-1?Q?RP8WRKpGbcG09Tewj1uc4knl1D2rr/kKYIPNzWnPl1jPZ2Uq54QsXg87jf?=
 =?iso-8859-1?Q?P9kG9GzfXxaMwRKkPrnDxOfX5ElS5WaqBWzSNIT9TDPfiacjrff3Z9bYNW?=
 =?iso-8859-1?Q?EZE+iFekeX83uHYvQWK9qhM/5NwWK8ZZLM?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b13f607-4bfa-4e36-51e6-08da9fd6a282
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 15:49:02.4457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QQDp/xFXJV7+d1QXhc5KT5kx9GvtnmEuu3UiJvVwVZaI8oGr7EdbJa6J1WFxdP4+VJW3h7gYwvRDgb0M5HM3n6atR7KeFrBgeExOURDbMX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5221
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Kees Cook <keescook@chromium.org>
>Sent: Friday, September 23, 2022 4:28 PM
>To: Vlastimil Babka <vbabka@suse.cz>
>Cc: Kees Cook <keescook@chromium.org>; Brandeburg, Jesse
><jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Paolo Abeni <pabeni@redhat.com>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; Ruhl, Michael J <michael.j.ruhl@intel.com>;
>Hyeonggon Yoo <42.hyeyoo@gmail.com>; Christoph Lameter
><cl@linux.com>; Pekka Enberg <penberg@kernel.org>; David Rientjes
><rientjes@google.com>; Joonsoo Kim <iamjoonsoo.kim@lge.com>; Andrew
>Morton <akpm@linux-foundation.org>; Greg Kroah-Hartman
><gregkh@linuxfoundation.org>; Nick Desaulniers
><ndesaulniers@google.com>; Alex Elder <elder@kernel.org>; Josef Bacik
><josef@toxicpanda.com>; David Sterba <dsterba@suse.com>; Sumit Semwal
><sumit.semwal@linaro.org>; Christian K=F6nig <christian.koenig@amd.com>;
>Daniel Micay <danielmicay@gmail.com>; Yonghong Song <yhs@fb.com>;
>Marco Elver <elver@google.com>; Miguel Ojeda <ojeda@kernel.org>; linux-
>kernel@vger.kernel.org; linux-mm@kvack.org; linux-btrfs@vger.kernel.org;
>linux-media@vger.kernel.org; dri-devel@lists.freedesktop.org; linaro-mm-
>sig@lists.linaro.org; linux-fsdevel@vger.kernel.org; dev@openvswitch.org;
>x86@kernel.org; llvm@lists.linux.dev; linux-hardening@vger.kernel.org
>Subject: [PATCH v2 06/16] igb: Proactively round up to kmalloc bucket size
>
>In preparation for removing the "silently change allocation size"
>users of ksize(), explicitly round up all q_vector allocations so that
>allocations can be correctly compared to ksize().
>
>Additionally fix potential use-after-free in the case of new allocation
>failure: only free memory if the replacement allocation succeeds.
>
>Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
>Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Paolo Abeni <pabeni@redhat.com>
>Cc: intel-wired-lan@lists.osuosl.org
>Cc: netdev@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
> drivers/net/ethernet/intel/igb/igb_main.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
>b/drivers/net/ethernet/intel/igb/igb_main.c
>index 2796e81d2726..eb51e531c096 100644
>--- a/drivers/net/ethernet/intel/igb/igb_main.c
>+++ b/drivers/net/ethernet/intel/igb/igb_main.c
>@@ -1195,15 +1195,16 @@ static int igb_alloc_q_vector(struct igb_adapter
>*adapter,
> 		return -ENOMEM;
>
> 	ring_count =3D txr_count + rxr_count;
>-	size =3D struct_size(q_vector, ring, ring_count);
>+	size =3D kmalloc_size_roundup(struct_size(q_vector, ring, ring_count));

This looks good to me...

> 	/* allocate q_vector and rings */
> 	q_vector =3D adapter->q_vector[v_idx];
> 	if (!q_vector) {
> 		q_vector =3D kzalloc(size, GFP_KERNEL);
> 	} else if (size > ksize(q_vector)) {
>-		kfree_rcu(q_vector, rcu);
> 		q_vector =3D kzalloc(size, GFP_KERNEL);
>+		if (q_vector)
>+			kfree_rcu(q_vector, rcu);

Even though this is in the ksize part, this seems like an unrelated change?
 Should this be in a different patch?

Also, the kfree_rcu will free q_vector after the RCU grace period?

Is that what you want to do?

How does rcu distinguish between the original q_vector, and the newly kzall=
oced one?

Thanks,

Mike



> 	} else {
> 		memset(q_vector, 0, size);
> 	}
>--
>2.34.1

