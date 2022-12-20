Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B63B652992
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 00:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiLTXD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 18:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiLTXD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 18:03:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9691F2DC;
        Tue, 20 Dec 2022 15:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671577404; x=1703113404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xtMNlN8m5HRzbWpNm6/8qm99x/VmmPyQ0gBVw5+GhV0=;
  b=IvCECiC2xV5t2b0GAvf20VBJ5FqicJK6+f+2MkdpMQeJQdp6fxlgwXsL
   ijq4Z9Ajc/TKo13ff0/BLwGO6Lei8tbpVc2BIxwnkczZG8zEkk39702W8
   qY8sp8jE33PLo5XS7cjFb+sRhvufibOmJoTxf8veEbWK1arUcxb90Odsu
   6nTjNhpQ8lpKI5ZKUwJ4ctYo7V4+/DZBVJZqpnU6b7mm5/09tpZGWZ5F3
   cJ8MfhWdYe+7+dF0DPQYc8I3SnXYKjpcT5hg82tR0LhsvsUlvrBCtKsYd
   sUf14PgpXfyp1BUmq1y+Y7Vyq3PvlLt6cZkws7OQN1YvKtAu24YjsocdS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="318436165"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="318436165"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 15:03:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="758296330"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="758296330"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 20 Dec 2022 15:03:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 15:03:23 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 15:03:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 15:03:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 15:03:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDhyE6pXWayUipVat4kRWsXX16cPXgA75pSl49sAuP0spycaFyAEJ3W9oOTKJ4TraIBKpCiboRRgRbSjo+RQt+itY89NkUPbl9skjk9aY8C+mojjoiEyJBhqAw7XTGUL/fcoT+FS2CdLEwXva9m2soPX9LQkhzaYd+o1j4Y3HoAXFlIGHZ+O4UcO+LSqhsWkgAfTm8W+wcOC3XZxNpcu7HUUG0G2jDXWg3ECjiO4iIA+i843mIo69U5cWraKhRe3aD2zpWiRY5X+woa8/0yhUhBcZg9dni2Aa5Mks11yaFGHzVSGuqzkp3eiCVDVw0cw4CP8mqWArUgGaQltBkXNlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G62sz+pNzT/abh4xhFo+GMX2kwyxgRuko0Ljvd4TFBQ=;
 b=ANzKcg6Z8dhS/xXBtZnNVID+xvrbA64pwBK7hpXw/wo+Tztu/G72LE2Cs0yydSQL4Wf15WFeW28hydeWTCtDPgwTvNIsaxwMrlkISgIE3YFh2ZA7MPChBP9DcJtJVtGIhhvDvN2S3V1sl5XodcCyl7wL0dnFreoy+rO6WIPCll4BuEgQACNAF/t5TLJ6vicVJGALwGiq97ezx3PXKzxsmVSQ8b4jRSnUWXK5F5dHHPcb2mDswUEOUf/n7qNRtNXS/9w/I4uJs7h3hhEUQhAiMotzHJavZs47axF3GimXFirgYedo7+Cl447lWFSTtFvRbZKZDJP2i2oDHZBswkT6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB6994.namprd11.prod.outlook.com (2603:10b6:806:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 23:03:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 23:03:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: RE: [PATCH v4] epoll: use refcount to reduce ep_mutex contention
Thread-Topic: [PATCH v4] epoll: use refcount to reduce ep_mutex contention
Thread-Index: AQHZFLV2yFtCvZIAgE692oY1uirJ0q53ZPMg
Date:   Tue, 20 Dec 2022 23:03:20 +0000
Message-ID: <CO1PR11MB5089DD857AC999A9283F1306D6EA9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <9d8ad7995e51ad3aecdfe6f7f9e72231b8c9d3b5.1671569682.git.pabeni@redhat.com>
In-Reply-To: <9d8ad7995e51ad3aecdfe6f7f9e72231b8c9d3b5.1671569682.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SN7PR11MB6994:EE_
x-ms-office365-filtering-correlation-id: 1f0aa633-a718-47d0-87b9-08dae2de6379
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jq8oI1ujmEMJp/V/ZbL3PTXcWO9gJ8q0q3fZpoFutQNJNXX0ujfJRkrzuCbPRiA6Tzb7nf0UxpNH8TEOGF6djylISmgqh6B7bB1Vf5UuVuhbNGZWyQsmylVuG56V5HOaydXS/jx3vrCM3gJqGkNmaqR0uAvOK9IRCaIUh8jyQV9tUeC8rkKx2qXBjha+jyIojVC172tB4Ro4u3E7FFRLUoMgDxw740HgNSwOQybWWV85EQj91PJey4qEYeHLNMDG+bxac6OCyCkqkF4OnQyF18kGtGxOfVtpNVrZ7lIk/aMYZdwp5n+qkE+w/zn1FucFU4drPRbdejquPEw/dO6UmhIWLfTn+4miGj2Aa2HQ8uBR10YHXN6o/FZBcby0wL0vIYEXG98OSkAMkE9yGX089bDP49zh8Wg2pjecfz1FjFCKo/9iYRbHSb2JZFTEsnJu25xj01dCmeRoc21nwY4Fu6Ns2pKCz/2HjQB1wgvehHv+Hp3IJaYGdxb4EUJBEXRdifUTx/Ru9wdO0NtG4sf5Gi4qhC9TYNb2JeOI5J4yVm15Zvfv8gZw55J1b05iseQ25qwKmaDwer9bUiQzg0TCQ7kzFkBiX4XmBdSBPtVr87SqGbptkSsIzf+bkxvbXYMtnv8AlxG5tk5gLkZiOMsDSdDbT45PIZxZR87tD94OqLTe3TozAl20joC9QU0wO3gXov36DOziIC7N9PZMzpZILaaYsnU99eurLedZ6pF17UdP3oQ7FrMc0uSWI4nUE1ojjwbXVIVYJlx60jQGAatXSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199015)(2906002)(6506007)(7696005)(66899015)(53546011)(478600001)(86362001)(52536014)(82960400001)(30864003)(83380400001)(71200400001)(966005)(5660300002)(110136005)(122000001)(8936002)(9686003)(26005)(316002)(186003)(54906003)(55016003)(8676002)(66446008)(64756008)(38070700005)(38100700002)(33656002)(41300700001)(66946007)(66476007)(66556008)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A22iM5TPCH2GRI4oxPYP2/VpQu4yoTMgGRgLTQwXU62DCaODTtL8d07EYPwv?=
 =?us-ascii?Q?HLFcB8XZn7/SsYTFoTNsbP9sFLKJAiNX47eFr9IOhI9ofcR6aFn46GI3GYSV?=
 =?us-ascii?Q?DtmIuslh9obDBUkWdNFmmy87iTBUvWtBCWnoapo1NBXvtaDbR9nT3eHCkfPt?=
 =?us-ascii?Q?hwC/GnO4+WSProCYtessXSEfHEXerV6pnIJtxLhRqT0h0C77ckLq45x7HqFY?=
 =?us-ascii?Q?9E0Y+UxHimar+MceftOfBE6CxG/3LHQTMT7ibCQ2pSmjbwpEJBPQRxtLsv16?=
 =?us-ascii?Q?oL4KmAMWnzuFz4KyJRUMjRIDrEY+0p41CCrr5aQFk3WMPsr3utira+9qHlzf?=
 =?us-ascii?Q?Qq7sZsqFBRH+mU/YCYNMe3wapFhnhNKV1EF1FMapEBcS6YjHaTtK48A3hsOW?=
 =?us-ascii?Q?8ZMGgzUpHgeQ2LCu1msrj4dMCA76xqcoxXSNUz55mxbgSVgl2ohv1i6Nb8ye?=
 =?us-ascii?Q?1CESO4CYys//vh6CwYudkvSwOGoA+DPrTSldUWcvpBaUGbP4iKTEJFqZAHxP?=
 =?us-ascii?Q?SEwmufQNSaRm7hvO2DK9VIOG3r6ryFURMz+VdzqtTmglCIvTZfXDgj8w0TSc?=
 =?us-ascii?Q?qc0pcC2/iy7D4F+szCTLwYg+JSpz0vIVwLuE+hDUQjHfbtmrj0AQW3PDGlJC?=
 =?us-ascii?Q?JB2sBJLwT3z9ehehg0NogCr6Z0thU1Q/xuOrbmgxyKVFqEdKf2bcpVz6jwxJ?=
 =?us-ascii?Q?8B1l4xr4GuLSPk5liFrDh7MKpiQY4jqcZXoR3v6rbv1tTuv2wejo2ZkwoSwA?=
 =?us-ascii?Q?wNGM2pnZ0rTvWQfow27B/ewFqLBdUcxy6QPl7+WBe3ibArWNA8qzT0PNp9bs?=
 =?us-ascii?Q?Riyi5TJ1tDRjTIyRfHK2b+QQX08MsiNMhRHAFUfSoWbmbnTO4xCPRAz7p0fR?=
 =?us-ascii?Q?6TxFMlJcmLLVB2WzuCILe92o0WMo31+hN6bJ2hJ4z5j/FGUxTT1ps9Q36eb8?=
 =?us-ascii?Q?SpP1/iOucyBII87CZzIAChhbs96I6hL+1JLyAPIrsltbGr3bf7OxOHGLUN0h?=
 =?us-ascii?Q?WCk2vE7nHaKlw7LWmeVAbxHG/s2/eowRI0u9sWWl569k3rQFDr4LiscmGc+p?=
 =?us-ascii?Q?/uUv62ysQNK+8/vjVJTD+tYSanYVrhCrlePbnnc8JvOX7CTvJySpXuxSf2R7?=
 =?us-ascii?Q?uIpVCJ/KrcLtTIb6rK0jztPNuKU+EZwZrkI9EzDl1yR1WD6knKyeQyJyes5c?=
 =?us-ascii?Q?/kJH51i3J9Itp1xgfqWgJX5P8E8heliPIC5b4LiZYniPHwtaZpR8txcq2ypQ?=
 =?us-ascii?Q?4X1PBHynx4YKPj7G9tpPDWrW6Wkn91Z3CeOKyTmZt1clNVJcRhC0S3dRss/h?=
 =?us-ascii?Q?Ke4fu3ddR8zhLVRl1Z8CcFF5tWhk9Qc9eH9DWB603WUd2KPwjZ3a6ArADDmq?=
 =?us-ascii?Q?ixKDdfBm1byBqRNw8JxVNnWjGAV55eMp8duBNCglDNTFNNZYZLfBki2alUoF?=
 =?us-ascii?Q?ACWZGc/+wOVcO78MGvH70IC00XlX48HPg8GoMe15Cu6K/LnYJ5+cZhj9i/bB?=
 =?us-ascii?Q?Ai+cy4KFrE4lYwvH1wkHLw7yNjRl+8jXi0wZz0mFVxoiXkra6NM9DO1MCRoV?=
 =?us-ascii?Q?xQIJ0NHuKUMEO8MK6/BiLEgziuYA3bGbCZG+obCl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0aa633-a718-47d0-87b9-08dae2de6379
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 23:03:20.5404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gETzp73ldrEx449IBfiVcglY6z951wMqUKGJFBwJRtmaBVMQwPB4y9CskiYdx+BhOYc4BeXWdgPqAxGMHO4gAE1gvDhw+8lL/BF+8PMGXrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6994
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLACK autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Paolo Abeni <pabeni@redhat.com>
> Sent: Tuesday, December 20, 2022 12:56 PM
> To: linux-fsdevel@vger.kernel.org
> Cc: Soheil Hassas Yeganeh <soheil@google.com>; Al Viro
> <viro@zeniv.linux.org.uk>; Davidlohr Bueso <dave@stgolabs.net>; Jason Bar=
on
> <jbaron@akamai.com>; netdev@vger.kernel.org; Carlos Maiolino
> <cmaiolino@redhat.com>; Eric Biggers <ebiggers@kernel.org>; Keller, Jacob=
 E
> <jacob.e.keller@intel.com>
> Subject: [PATCH v4] epoll: use refcount to reduce ep_mutex contention
>=20
> We are observing huge contention on the epmutex during an http
> connection/rate test:
>=20
>  83.17% 0.25%  nginx            [kernel.kallsyms]         [k]
> entry_SYSCALL_64_after_hwframe
> [...]
>            |--66.96%--__fput
>                       |--60.04%--eventpoll_release_file
>                                  |--58.41%--__mutex_lock.isra.6
>                                            |--56.56%--osq_lock
>=20
> The application is multi-threaded, creates a new epoll entry for
> each incoming connection, and does not delete it before the
> connection shutdown - that is, before the connection's fd close().
>=20
> Many different threads compete frequently for the epmutex lock,
> affecting the overall performance.
>=20
> To reduce the contention this patch introduces explicit reference countin=
g
> for the eventpoll struct. Each registered event acquires a reference,
> and references are released at ep_remove() time.
>=20
> Additionally, this introduces a new 'dying' flag to prevent races between
> the EP file close() and the monitored file close().
> ep_eventpoll_release() marks, under f_lock spinlock, each epitem as befor=
e
> removing it, while EP file close() does not touch dying epitems.
>=20
> The eventpoll struct is released by whoever - among EP file close() and
> and the monitored file close() drops its last reference.
>=20
> With all the above in place, we can drop the epmutex usage at disposal ti=
me.
>=20
> Overall this produces a significant performance improvement in the
> mentioned connection/rate scenario: the mutex operations disappear from
> the topmost offenders in the perf report, and the measured connections/ra=
te
> grows by ~60%.
>=20
> To make the change more readable this additionally renames ep_free() to
> ep_clear_and_put(), and moves the actual memory cleanup in a separate
> ep_free() helper.
>=20

Thanks for switching to refcount! This version looks good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v4: (addresses comments from Eric Biggers and Jacob)
>  - replace a refcount_t
>  - rename the ep book-keeping helpers
>=20
> v3 at:
> https://lore.kernel.org/linux-
> fsdevel/1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni
> @redhat.com/
>=20
> v2 at:
> https://lore.kernel.org/linux-
> fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@re
> dhat.com/
>=20
> v1 at:
> https://lore.kernel.org/linux-
> fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@re
> dhat.com/
>=20
> Previous related effort at:
> https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-
> cj.chengjian@huawei.com/
> https://lkml.org/lkml/2017/10/28/81
> ---
>  fs/eventpoll.c | 185 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 116 insertions(+), 69 deletions(-)
>=20
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 64659b110973..a43ccb02133c 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -57,13 +57,7 @@
>   * we need a lock that will allow us to sleep. This lock is a
>   * mutex (ep->mtx). It is acquired during the event transfer loop,
>   * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
> - * Then we also need a global mutex to serialize eventpoll_release_file(=
)
> - * and ep_free().
> - * This mutex is acquired by ep_free() during the epoll file
> - * cleanup path and it is also acquired by eventpoll_release_file()
> - * if a file has been pushed inside an epoll set and it is then
> - * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
> - * It is also acquired when inserting an epoll fd onto another epoll
> + * The epmutex is acquired when inserting an epoll fd onto another epoll
>   * fd. We do this so that we walk the epoll tree and ensure that this
>   * insertion does not create a cycle of epoll file descriptors, which
>   * could lead to deadlock. We need a global mutex to prevent two
> @@ -153,6 +147,13 @@ struct epitem {
>  	/* The file descriptor information this item refers to */
>  	struct epoll_filefd ffd;
>=20
> +	/*
> +	 * Protected by file->f_lock, true for to-be-released epitem already
> +	 * removed from the "struct file" items list; together with
> +	 * eventpoll->refcount orchestrates "struct eventpoll" disposal
> +	 */
> +	bool dying;
> +
>  	/* List containing poll wait queues */
>  	struct eppoll_entry *pwqlist;
>=20
> @@ -217,6 +218,12 @@ struct eventpoll {
>  	u64 gen;
>  	struct hlist_head refs;
>=20
> +	/*
> +	 * usage count, used together with epitem->dying to
> +	 * orchestrate the disposal of this struct
> +	 */
> +	refcount_t refcount;
> +
>  #ifdef CONFIG_NET_RX_BUSY_POLL
>  	/* used to track busy poll napi_id */
>  	unsigned int napi_id;
> @@ -240,9 +247,7 @@ struct ep_pqueue {
>  /* Maximum number of epoll watched descriptors, per user */
>  static long max_user_watches __read_mostly;
>=20
> -/*
> - * This mutex is used to serialize ep_free() and eventpoll_release_file(=
).
> - */
> +/* Used for cycles detection */
>  static DEFINE_MUTEX(epmutex);
>=20
>  static u64 loop_check_gen =3D 0;
> @@ -557,8 +562,7 @@ static void ep_remove_wait_queue(struct eppoll_entry
> *pwq)
>=20
>  /*
>   * This function unregisters poll callbacks from the associated file
> - * descriptor.  Must be called with "mtx" held (or "epmutex" if called f=
rom
> - * ep_free).
> + * descriptor.  Must be called with "mtx" held.
>   */
>  static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *=
epi)
>  {
> @@ -681,11 +685,38 @@ static void epi_rcu_free(struct rcu_head *head)
>  	kmem_cache_free(epi_cache, epi);
>  }
>=20
> +static void ep_get(struct eventpoll *ep)
> +{
> +	refcount_inc(&ep->refcount);
> +}
> +
> +/*
> + * Returns true if the event poll can be disposed
> + */
> +static bool ep_refcount_dec_and_test(struct eventpoll *ep)
> +{
> +	if (!refcount_dec_and_test(&ep->refcount))
> +		return false;
> +
> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
> +	return true;
> +}
> +
> +static void ep_free(struct eventpoll *ep)
> +{
> +	mutex_destroy(&ep->mtx);
> +	free_uid(ep->user);
> +	wakeup_source_unregister(ep->ws);
> +	kfree(ep);
> +}
> +
>  /*
>   * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>   * all the associated resources. Must be called with "mtx" held.
> + * If the dying flag is set, do the removal only if force is true.
> + * Returns true if the eventpoll can be disposed.
>   */
> -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> +static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool f=
orce)
>  {
>  	struct file *file =3D epi->ffd.file;
>  	struct epitems_head *to_free;
> @@ -700,6 +731,11 @@ static int ep_remove(struct eventpoll *ep, struct ep=
item
> *epi)
>=20
>  	/* Remove the current item from the list of epoll hooks */
>  	spin_lock(&file->f_lock);
> +	if (epi->dying && !force) {
> +		spin_unlock(&file->f_lock);
> +		return false;
> +	}
> +
>  	to_free =3D NULL;
>  	head =3D file->f_ep;
>  	if (head->first =3D=3D &epi->fllink && !epi->fllink.next) {
> @@ -733,28 +769,28 @@ static int ep_remove(struct eventpoll *ep, struct
> epitem *epi)
>  	call_rcu(&epi->rcu, epi_rcu_free);
>=20
>  	percpu_counter_dec(&ep->user->epoll_watches);
> +	return ep_refcount_dec_and_test(ep);
> +}
>=20
> -	return 0;
> +/*
> + * ep_remove variant for callers owing an additional reference to the ep
> + */
> +static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
> +{
> +	WARN_ON_ONCE(__ep_remove(ep, epi, false));
>  }
>=20
> -static void ep_free(struct eventpoll *ep)
> +static void ep_clear_and_put(struct eventpoll *ep)
>  {
>  	struct rb_node *rbp;
>  	struct epitem *epi;
> +	bool dispose;
>=20
>  	/* We need to release all tasks waiting for these file */
>  	if (waitqueue_active(&ep->poll_wait))
>  		ep_poll_safewake(ep, NULL, 0);
>=20
> -	/*
> -	 * We need to lock this because we could be hit by
> -	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
> -	 * We do not need to hold "ep->mtx" here because the epoll file
> -	 * is on the way to be removed and no one has references to it
> -	 * anymore. The only hit might come from eventpoll_release_file() but
> -	 * holding "epmutex" is sufficient here.
> -	 */
> -	mutex_lock(&epmutex);
> +	mutex_lock(&ep->mtx);
>=20
>  	/*
>  	 * Walks through the whole tree by unregistering poll callbacks.
> @@ -768,25 +804,21 @@ static void ep_free(struct eventpoll *ep)
>=20
>  	/*
>  	 * Walks through the whole tree by freeing each "struct epitem". At thi=
s
> -	 * point we are sure no poll callbacks will be lingering around, and al=
so by
> -	 * holding "epmutex" we can be sure that no file cleanup code will hit
> -	 * us during this operation. So we can avoid the lock on "ep->lock".
> -	 * We do not need to lock ep->mtx, either, we only do it to prevent
> -	 * a lockdep warning.
> +	 * point we are sure no poll callbacks will be lingering around.
> +	 * Since we still own a reference to the eventpoll struct, the loop can=
't
> +	 * dispose it.
>  	 */
> -	mutex_lock(&ep->mtx);
>  	while ((rbp =3D rb_first_cached(&ep->rbr)) !=3D NULL) {
>  		epi =3D rb_entry(rbp, struct epitem, rbn);
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>  		cond_resched();
>  	}
> +
> +	dispose =3D ep_refcount_dec_and_test(ep);
>  	mutex_unlock(&ep->mtx);
>=20
> -	mutex_unlock(&epmutex);
> -	mutex_destroy(&ep->mtx);
> -	free_uid(ep->user);
> -	wakeup_source_unregister(ep->ws);
> -	kfree(ep);
> +	if (dispose)
> +		ep_free(ep);
>  }
>=20
>  static int ep_eventpoll_release(struct inode *inode, struct file *file)
> @@ -794,7 +826,7 @@ static int ep_eventpoll_release(struct inode *inode, =
struct
> file *file)
>  	struct eventpoll *ep =3D file->private_data;
>=20
>  	if (ep)
> -		ep_free(ep);
> +		ep_clear_and_put(ep);
>=20
>  	return 0;
>  }
> @@ -906,33 +938,35 @@ void eventpoll_release_file(struct file *file)
>  {
>  	struct eventpoll *ep;
>  	struct epitem *epi;
> -	struct hlist_node *next;
> +	bool dispose;
>=20
>  	/*
> -	 * We don't want to get "file->f_lock" because it is not
> -	 * necessary. It is not necessary because we're in the "struct file"
> -	 * cleanup path, and this means that no one is using this file anymore.
> -	 * So, for example, epoll_ctl() cannot hit here since if we reach this
> -	 * point, the file counter already went to zero and fget() would fail.
> -	 * The only hit might come from ep_free() but by holding the mutex
> -	 * will correctly serialize the operation. We do need to acquire
> -	 * "ep->mtx" after "epmutex" because ep_remove() requires it when
> called
> -	 * from anywhere but ep_free().
> -	 *
> -	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
> +	 * Use the 'dying' flag to prevent a concurrent ep_cleat_and_put() from
> +	 * touching the epitems list before eventpoll_release_file() can access
> +	 * the ep->mtx.
>  	 */
> -	mutex_lock(&epmutex);
> -	if (unlikely(!file->f_ep)) {
> -		mutex_unlock(&epmutex);
> -		return;
> -	}
> -	hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
> +again:
> +	spin_lock(&file->f_lock);
> +	if (file->f_ep && file->f_ep->first) {
> +		/* detach from ep tree */
> +		epi =3D hlist_entry(file->f_ep->first, struct epitem, fllink);
> +		epi->dying =3D true;
> +		spin_unlock(&file->f_lock);
> +
> +		/*
> +		 * ep access is safe as we still own a reference to the ep
> +		 * struct
> +		 */
>  		ep =3D epi->ep;
> -		mutex_lock_nested(&ep->mtx, 0);
> -		ep_remove(ep, epi);
> +		mutex_lock(&ep->mtx);
> +		dispose =3D __ep_remove(ep, epi, true);
>  		mutex_unlock(&ep->mtx);
> +
> +		if (dispose)
> +			ep_free(ep);
> +		goto again;
>  	}
> -	mutex_unlock(&epmutex);
> +	spin_unlock(&file->f_lock);
>  }
>=20
>  static int ep_alloc(struct eventpoll **pep)
> @@ -955,6 +989,7 @@ static int ep_alloc(struct eventpoll **pep)
>  	ep->rbr =3D RB_ROOT_CACHED;
>  	ep->ovflist =3D EP_UNACTIVE_PTR;
>  	ep->user =3D user;
> +	refcount_set(&ep->refcount, 1);
>=20
>  	*pep =3D ep;
>=20
> @@ -1223,10 +1258,10 @@ static int ep_poll_callback(wait_queue_entry_t
> *wait, unsigned mode, int sync, v
>  		 */
>  		list_del_init(&wait->entry);
>  		/*
> -		 * ->whead !=3D NULL protects us from the race with ep_free()
> -		 * or ep_remove(), ep_remove_wait_queue() takes whead->lock
> -		 * held by the caller. Once we nullify it, nothing protects
> -		 * ep/epi or even wait.
> +		 * ->whead !=3D NULL protects us from the race with
> +		 * ep_clear_and_put() or ep_remove(), ep_remove_wait_queue()
> +		 * takes whead->lock held by the caller. Once we nullify it,
> +		 * nothing protects ep/epi or even wait.
>  		 */
>  		smp_store_release(&ep_pwq_from_wait(wait)->whead, NULL);
>  	}
> @@ -1496,16 +1531,22 @@ static int ep_insert(struct eventpoll *ep, const =
struct
> epoll_event *event,
>  	if (tep)
>  		mutex_unlock(&tep->mtx);
>=20
> +	/*
> +	 * ep_remove_safe() calls in the later error paths can't lead to
> +	 * ep_free() as the ep file itself still holds an ep reference.
> +	 */
> +	ep_get(ep);
> +
>  	/* now check if we've created too many backpaths */
>  	if (unlikely(full_check && reverse_path_check())) {
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>  		return -EINVAL;
>  	}
>=20
>  	if (epi->event.events & EPOLLWAKEUP) {
>  		error =3D ep_create_wakeup_source(epi);
>  		if (error) {
> -			ep_remove(ep, epi);
> +			ep_remove_safe(ep, epi);
>  			return error;
>  		}
>  	}
> @@ -1529,7 +1570,7 @@ static int ep_insert(struct eventpoll *ep, const st=
ruct
> epoll_event *event,
>  	 * high memory pressure.
>  	 */
>  	if (unlikely(!epq.epi)) {
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>  		return -ENOMEM;
>  	}
>=20
> @@ -2025,7 +2066,7 @@ static int do_epoll_create(int flags)
>  out_free_fd:
>  	put_unused_fd(fd);
>  out_free_ep:
> -	ep_free(ep);
> +	ep_clear_and_put(ep);
>  	return error;
>  }
>=20
> @@ -2167,10 +2208,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct
> epoll_event *epds,
>  			error =3D -EEXIST;
>  		break;
>  	case EPOLL_CTL_DEL:
> -		if (epi)
> -			error =3D ep_remove(ep, epi);
> -		else
> +		if (epi) {
> +			/*
> +			 * The eventpoll itself is still alive: the refcount
> +			 * can't go to zero here.
> +			 */
> +			ep_remove_safe(ep, epi);
> +			error =3D 0;
> +		} else {
>  			error =3D -ENOENT;
> +		}
>  		break;
>  	case EPOLL_CTL_MOD:
>  		if (epi) {
> --
> 2.38.1

