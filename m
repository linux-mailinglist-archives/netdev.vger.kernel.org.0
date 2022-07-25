Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38868580686
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiGYV1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbiGYV1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:27:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79629240BE;
        Mon, 25 Jul 2022 14:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658784423; x=1690320423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OQFxjgGBW24GbzEdtt82SMUyDFnQSzs6E/C4HHWRwlE=;
  b=Io7/g+VzCw4T9eTP4ClF4B7TLK3h9Hy12nRUV1lnj+b/zyXkpkynVB1u
   SAXqX51YF1cKHPETofobdQgqKoU5MkHOb1T+xQXyCCPqRMvBP104o4LqZ
   YnrgTZhOaGBIqBos9xveDCXXkka+5UWlyDB3k2MpjPoIpGGfEOafsQMeB
   /1Dmuq7ANGMTUdhP1KuyUJgJw958Ze3/t5h8mQEwXAK1TnlD3sCbad1Ul
   13VEiioFDMaerSA3f+nOCOygt1odmXHY3u7ETpDqTSxZwx7LKlFlFg5kV
   q+V4dthh40pfFAGoROCu/44ZKD1tvblDRT1ihCvhhZmDMorQRZZsr5cCD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="285347051"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="285347051"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 14:27:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="627621196"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 25 Jul 2022 14:27:02 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 14:27:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 14:27:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 25 Jul 2022 14:27:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXEgTSWPFbpgkhnH8F1VxyFnvkPXv/qTrCrfx7P/ZeuDzX4qf442/b+tpU2k2+4QhgG1dWnByoW3C/miCO1c6UHk/+e9CjHONjvnJEcFH7ngWdDt2SNl9jvWSChVJyZFznGscuypFhVQGDDf7LA7R9jQglDchTflNjHE/rljYa8TvW6h9JQPGOwnzKvB4DmIX1akWS2Fpquy68gulD/1HzFUuskpm/uAd6VQldqrw6qhxZ7uaUuqxtx7zXo6MH1UoUIwrGnbIx2fVeGgz77FPAlAGWR3EbOD8g3VrAnII5wDKtyp/bURiqdSZGqtMM6auM277hLW5ZtfbxVVJgtOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQFxjgGBW24GbzEdtt82SMUyDFnQSzs6E/C4HHWRwlE=;
 b=bq7clTsNSeTcy4PNueUFOKEBVcwV0sO3snihu72E5fuVY/3s3hB5z5F/1wmh4X3/vuc5opLJJFfnJf8fKgfJg/jEkS5Oj5kyHRsEhEHDJHN6wnatieRBUi3W1f6GWPH/PZfdttqxPDKxCA7XjmtfHgSjUDN5kiIlYpxl4Zbrqk6N0UBaquozsiDSxbW7UDA1tL/xi7px9RLIDcWiIclwfxMku66QR0zvyxxZAG2wDzPgWOzODmIcd75jjegwbw+TiqImU7/5rj4GxRvpNfQGrXYn7cHuP+9FQZAgIAKC3+BUilptUpSQo6KUySq8bHJoo5QazcgaVS3vagaNSgr3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by PH7PR11MB5886.namprd11.prod.outlook.com (2603:10b6:510:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 21:27:00 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::f97c:8114:1f0c:f811%6]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 21:27:00 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [iproute2-next v3 3/3] devlink: add dry run attribute support to
 devlink flash
Thread-Topic: [iproute2-next v3 3/3] devlink: add dry run attribute support to
 devlink flash
Thread-Index: AQHYoGkavhZOFZPEFUODGj22P6MV6q2PleEAgAADyeA=
Date:   Mon, 25 Jul 2022 21:27:00 +0000
Message-ID: <SA2PR11MB510070677CCCEEE8748CDDAAD6959@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20220725205650.4018731-1-jacob.e.keller@intel.com>
        <20220725205650.4018731-4-jacob.e.keller@intel.com>
 <20220725141314.01771885@hermes.local>
In-Reply-To: <20220725141314.01771885@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e88180d-547a-40f3-81a7-08da6e8468f8
x-ms-traffictypediagnostic: PH7PR11MB5886:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: py/UWhj0kyb8uAP+0m8hq6PK3OKIP3DMWZ4lfBf3l7zIO7G++IT8ksWLwtfOwB0r82+6PIFNaL1Jp6zEo8lkgm7nPSKy/yzAg6P1z1a3oA0NPmJYNAyGc+cwgeIXwUpI2dAvplAfVZSVhmDnUQjesPeT5CaXWl3Xv3Ze/ajaN2AtpYyxA8oU9EO6CPnpVz0VN94iU28GwOJUwIqBa2ATYnSQ15F4lDcvixlO1ttuWCmdKxxnen1YT4NyLRUQb/EBCs877fBfQBNopFMrx4hqhnhrxxnSZpMNt0wkDIUD5PGRArVYUmcAm3YAxVwLSy6h5oxR6003BbffkAwLfBa/k9yx5ObcM988HcRUfFc6wD7xYZyvUmdBb2jsz+dpDu1LM53VGT4380m59AcUiEtt4baEJ0Dgx5bH2XUU+cjLaKFl8oAWM/TZCUnJ2MYweKB6dLPFTP1Hi6nGP2AHTomr+JPMUEXG4OFeHmE2xWHGhltmyiO3IwKYt5rxnH760wuGnOt7yDzRVU/VB6NFG58rk9s+iJFVXpTcs6u1msD2iFZ3Od2BW4tMHq1oX+1XZPLnUpWN8/eYBFQFPdMl2Wdd+0rNS+GMP/IA4hdxQMI+0dx0XLbWT/Q7SDCvdLTKpmkWZUok40s/r3z9SWF9RGwRbCI201Ift0OwukAPIYm9DQsje+/tOafbR6CGpeG78ISUx9D4pXff4DuXaK+tmKEG8OS90qwFVQrJtLJIppTeXYubIUh33iSoJeEQEu7LczriZXNGtA2Pa287QcpI+KWawNGilggm93SBPorC8B3RNAne0bnp4haqPcR3DCIINPGUZPLDbyVWCtT4vc1TVHEIVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(366004)(39860400002)(396003)(4326008)(6916009)(66556008)(66946007)(8676002)(64756008)(54906003)(966005)(76116006)(66446008)(38070700005)(82960400001)(66476007)(122000001)(9686003)(478600001)(38100700002)(52536014)(53546011)(26005)(316002)(33656002)(86362001)(2906002)(7696005)(45080400002)(83380400001)(71200400001)(6506007)(41300700001)(8936002)(55016003)(5660300002)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8eNDhyaj3c/31R/Gpt9zBTFKT2p3wkn+03SZWivNBWCcRrHfrc28yI9Wv+Fo?=
 =?us-ascii?Q?z+z/JafrY3xilqNuzkJQwej9rFK24iHf/4rhMyEklVQUL1L4j/WBeJh2d7h1?=
 =?us-ascii?Q?agT07Y0WTVG/cwfPxrkGsqSzrn+D2uA0/rKhl6W9s3pXbG2n24EZAS6/58DH?=
 =?us-ascii?Q?hsfYcS48niIQh90yU32MA2THh9RboakTc94a+/l0u4yrPlhSG7gBraff6vtW?=
 =?us-ascii?Q?xeGJo6qFu1SU1Z8bdxf0WraVsfbtkccH95C9xL1B4tELRfUujFi00UpVQIhF?=
 =?us-ascii?Q?kvP41Xdx4ZbPUni/7WSNER7DcEdMFbfg8yy6Osy5uLUNUTMIHn1H/jWoWKGn?=
 =?us-ascii?Q?QQYSpMd9TceKGiDKmu5p+PKTslVrhfvcQEevGj2kiasEI8qPwh2QxjFODW5t?=
 =?us-ascii?Q?d7OIReVDpWWcffwsUSNufHOEsoG7ITqZfhGMeREVUK49GujodE+rgf+CTBng?=
 =?us-ascii?Q?CfOeNGLso3QLrs2dgZn4ytjdNiaU2OImX5dwEZc8PikUE8r7Rn0RY34Z95T+?=
 =?us-ascii?Q?TpOtX5Ojs4RXJmT/bK2jkNxBykiHBE97oEJmyd8WwyomGUJG+G1iKcXHPmTx?=
 =?us-ascii?Q?1FtWPXcNQm961eS7a+vsyPVihDuU5iJ6fF1OJaE0KHfy9T2SDk/+eS9mVnTi?=
 =?us-ascii?Q?etvmFAafXmlDNGbDJH2IvITJlrXXyjIVBg1Am9eQh/ieGr4o9KtoDqSyr/z5?=
 =?us-ascii?Q?Tmf+fAPO13BkOAIFDSZYpBxD4jWZc+IzmZZrQksFwS/fBvWWnUYnasiSEStA?=
 =?us-ascii?Q?cz3YMWNKAeo46HTCzHuUUaXKnzv7+J/PLv7h4oGlDHVZlTvGytvLV4HKKsGF?=
 =?us-ascii?Q?m0IYo71KjKw0BhjR3IcDVDk9TnLCTI/2QAMSsGYLZF4Y8nyo32JFFs0hStro?=
 =?us-ascii?Q?jju9bh9ASJPgver29XYoCuMG4eOau3Itw2fbi7fAhOLRpX/pHn1MfAjhxKVJ?=
 =?us-ascii?Q?gdrzYOk3X2EjrXgpHM80hUhN1wLQ2/bKq3mnQq5Ftkc4He2emtaGpdAbP5cX?=
 =?us-ascii?Q?OPpQv/jKV9t4NBiPePz2bm7KawkB5l1a7APyUwFQUnB2LU0M/Y0b4hp7611V?=
 =?us-ascii?Q?j5+RO40c5ZM3mwjKkjaSj2uEvYrYB1zDvj5gotLH8G3qGyXM2k9jbUFwYert?=
 =?us-ascii?Q?jB6lgHRsE6uLQk2KY46hXnxQYOq1LQPiufMCcTEIhNr/J2khdHU/bbSFuUyp?=
 =?us-ascii?Q?xNqQFAvxwh6lM1Xu3g5w2bz2S3EogZfgPCIs5auF1GvC9pCyl2rrfzEbl8EZ?=
 =?us-ascii?Q?LstmcwV3CtQOIPJiadMcSy7+dtuUprK3VjxC5KNwqV3SAZpo3uH8/mDsGH2W?=
 =?us-ascii?Q?ipWCND2Z0VHNwYSpEh3UwXKYJ4B6z81xh7aBemcTdaj6v3vW4jK2J8K8scfr?=
 =?us-ascii?Q?kQisxbF4vx/o9muCLRUcIArMd1qcMCkX5aqFCVa7TFhmHVvCZXpWXZg0E6H1?=
 =?us-ascii?Q?X1Hote+KexSByZcMnziwcUcC9jAqkadOHvQdxo9618ZXfEBx1Fdy30NguaDB?=
 =?us-ascii?Q?Pwcf8EQ+RjIKTQk8tObZLmCsU46s5Ugm0RfuhvGTxsYl5+liKs/ygFmiC9q0?=
 =?us-ascii?Q?vWWBZh5xyDoeklOikmaABqH2HK2pQKfbalOepWDm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e88180d-547a-40f3-81a7-08da6e8468f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 21:27:00.1889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hhrGKncV+rdQR+tPRJRTktnlhs/o7R4e8r/MmcpIvq2jpcztu1Hoq8kiygPYlYLQwqnNcK/vlFp8+yLvyUiOVURwW3zGgpgL8HcQqVMfifw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5886
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Monday, July 25, 2022 2:13 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Jiri Pirko
> <jiri@nvidia.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> David Ahern <dsahern@kernel.org>; linux-doc@vger.kernel.org
> Subject: Re: [iproute2-next v3 3/3] devlink: add dry run attribute suppor=
t to
> devlink flash
>=20
> On Mon, 25 Jul 2022 13:56:50 -0700
> Jacob Keller <jacob.e.keller@intel.com> wrote:
>=20
> > To avoid potential issues, only allow the attribute to be added to
> > commands when the kernel recognizes it. This is important because some
> > commands do not perform strict validation. If we were to add the
> > attribute without this check, an old kernel may silently accept the
> > command and perform an update even when dry_run was requested.
>=20
> Sigh. Looks like the old kernels are buggy. The workaround in userspace
> is also likely to be source of bugs.

There is also further discussion going on around this topic at https://lore=
.kernel.org/netdev/SA2PR11MB510047D98AFFDEE572B375E0D6959@SA2PR11MB5100.nam=
prd11.prod.outlook.com/
