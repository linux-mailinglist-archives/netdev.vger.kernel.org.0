Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B43EDB40
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhHPQvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:51:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:63918 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhHPQvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:51:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="215929599"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="215929599"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 09:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="423602429"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2021 09:51:09 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 09:51:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 09:51:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 09:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGR7kIVur+rtTH3AqEiTS9pIDOP3UxxOFX1I08L5S+UaFqy2dl3khwGeykHOQusI5+rnQEbkiPQBrH5fWutUDaRg3bQcrOVtds9RuhwpKrzCkYJ4YFHCkXncEYA4E9h6mfiFfNosWlaCeWpeKlH2QXMnnYqYFPMLRXktS3CfrkJJ/rJTAkB4IF+EOqZ5Ea3IVGiEUQnNEypOE1n65n8txmfNh5FZ0fHFree0/8B9Zrdy7+JyQqkqpzaelRmIEcOHbHyzAL4bmlGYXfJ+/cm1ST3L2WYCJcfBUFwpjsvz3J09+HraGNIWbS5DrD0HKmcM4Cux5jR8f52yhXVzZGJevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFunNEddNvjf5/3QARDcqvJBuuk2htaoMcbgeGB6VF8=;
 b=de1DNxgxAH4evACPGX4tmBMOl/vb+s7+9s6SaH7NW8fWBqqF0UiVavD7nQ213itc9tWaXQem206le8NQUDC3mOwNk3GDRt6Nmd70uPsS1a8O8hnR/Ps4YYn0JjkzMQKkW/fszHeNVGckBZ/GbIq1lmFq6PnU6TZ0aSHt62s0sML1vGNdmUPKUCRrMyGNWTtn3wYE40GdJnbAbw9fLc6Y/ie07ooBsDdMEKI4XYI6GFUykAVtMsdTf3Q5C3nxfcME3OCwqfn47Pq3J3vCnmADb6Xj2pE3oDS0Qz8E+7qXomxDfJTTttVkIO8l6gSVkqiTNX6O6wgvNtMyf8z0Q046pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFunNEddNvjf5/3QARDcqvJBuuk2htaoMcbgeGB6VF8=;
 b=dQGd1CbINcoRjE3SmLWUWkyq9JcGac7y5QvDfw4qyt8Ouh8QFNCsIzEDHcJKf3kkxlIlLM1vvKmKMW0h/9duzq2hgX9DBMdmWAtBuWEYbgswlIOSUerJvOTfmyPEphFEfu65rPAjhriFMX70zkK+GxZtA0ol0zyjX7jHdSr8GzQ=
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by MWHPR1101MB2256.namprd11.prod.outlook.com (2603:10b6:301:57::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 16:51:06 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d3c:c53a:cb70:76d2]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d3c:c53a:cb70:76d2%5]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 16:51:06 +0000
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "joamaki@gmail.com" <joamaki@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>
Subject: RE: [PATCH v5 intel-next 2/9] ice: move ice_container_type onto
 ice_ring_container
Thread-Topic: [PATCH v5 intel-next 2/9] ice: move ice_container_type onto
 ice_ring_container
Thread-Index: AQHXkRfnnLcP/Y6ye0SH974DeescXat2Wr/Q
Date:   Mon, 16 Aug 2021 16:51:06 +0000
Message-ID: <CO1PR11MB4835F0FDF2ABA2578B722095F5FD9@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
 <20210814140812.46632-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20210814140812.46632-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62adff4b-137c-4ef2-318e-08d960d60a72
x-ms-traffictypediagnostic: MWHPR1101MB2256:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB22566D562CD2AD6AD2BCB170F5FD9@MWHPR1101MB2256.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yCreu1oooRC8HPEG/57HX0JqrcM6yu6g/YfoSpShalDrvIVRgDjatHug3kEh78jRwP5YAqiiNARqE37Z/ZPbKGgjUIdrFsgSG23ffe3ITJX17wJGw/xsncaYIXGqzcVW1efq/5sMYy0m6lA2n3PHxZALkgcOOegaPjnpqJUwdrnCsLWQ3IFw85VZh1IEnlGiD/b2hsPiOtU85bAmFglqEcifPB3rw4sH+KSLVewGKHGIR2j0a8eP7QZ4GNEaps0CyDGzPI6Itl0+Q9i24GCfpt8A1mIuCdrlqZHRojVKNvxf43lvMtDa5pT5u4R6Mj4BUiFuU+Ptz1NMzUjXoTkAA+pMiCjg8jqAj6BCKcxeuMaMdGFLPQrS0uZY6QrP5gRFoJYpfMciEUNARYVtuDRqPDJcYsoXgavMzf5OBYAIlGBVO3OjY9sVE08FNzifYugF1yt4AlZhapqGLKUiysk9AfS8HrYTc0Dt4/O0tHwO9s3QxAzhCLABGFyMqaWSnMFzFSbUN4qbc3zU6Z1ArtGlwKptaG0pO9uMcCVJSYZlrMcgrVxO+yGTpBrFxo838mnbG58zcHo9CffIOFcQJ2mmlJsW/K2VNUUWnUC9e2Bv0Ycx7ohInAb+jROm0WySSEdQlt/fpXioeC0J69u7oUNWRkKrAkGpzTRL2qtS7IyY7Wq4wZyqCR8d07NQw6RasVL3EW4hVLZtxdg6Q1F3PNmR6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(86362001)(33656002)(4326008)(8936002)(8676002)(71200400001)(38100700002)(2906002)(83380400001)(186003)(55016002)(7696005)(38070700005)(478600001)(5660300002)(53546011)(52536014)(26005)(6506007)(316002)(110136005)(54906003)(66446008)(64756008)(122000001)(76116006)(9686003)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hG2Yy/Hg3mtOdnySIBpHrW6FLY3zYb6UqvfS9ap0IoOmppyk1EUt3JIQIMh6?=
 =?us-ascii?Q?Z4iHolI1S/v/z1sgvzmvzgj6HG5NILIp1TTalxgT+EXLhG3faEM8P9ALxmwc?=
 =?us-ascii?Q?B67r7IcpW7vq2j5WnRDdpxGKwzV7NTzoFFSKg3VJVQrk8HhMIiliHeYUCUt9?=
 =?us-ascii?Q?7begzKyuu+HRy4ROrnDFkloHC+AwOViMtSR9RdDfrF5Xopqu6lHhZj9NBHbz?=
 =?us-ascii?Q?5KPsUZsdxqhAcjNj1r60HkW1Gs+QDQf73mVrQN7k70TQdsgrHzcxK3g/awys?=
 =?us-ascii?Q?bZ25qpZJEd0yojlI4biyZNuy2AgfDqFFmceyIo2LYUq2cZThTVQuD6OkqrFt?=
 =?us-ascii?Q?rxioiRodRka7QkFG1b1ZsAAufvwXlkq5jFzM11UjX5RLWlL2sxYZEHv32Ya5?=
 =?us-ascii?Q?LHUZPg4gNkT054Wt2jm+n+AhTmrgmjMKx1DyfjVMmNN1XClQGTMDmLbCyl89?=
 =?us-ascii?Q?YPhJv4d78cf+7NX0Q/4Bw+BXPLWujiNdXMXwqh4sBQYv7nuzQeqFLbYO6R/p?=
 =?us-ascii?Q?pdaN+vuNPE53u/XkrEC/b20mLpjgmXl7A12mU1wY2MigaJe/Y1OCIWCpaRZE?=
 =?us-ascii?Q?qwnkHjw/96UWid06kzFGdjt/2rwH+DsCtEMDukrlqpnCrMuNxVqki9FALm5o?=
 =?us-ascii?Q?9MukI5cecOR9VF7tgdbj9lEeVMkaNLcKqb8X/3/iFmvtQqQ5vpgyW5nPQwzJ?=
 =?us-ascii?Q?lDpxgX4z6CZhk69zN27jsqNZyViDhVDd8SATqxMrbbYpcQxUwAQUidDt6tYH?=
 =?us-ascii?Q?AGCkgSRkF3/dl47T8QzaJevXvSUrpTAaNRJ/p+ufsmE32cq2I1t9Bsgk1QpZ?=
 =?us-ascii?Q?4UfJq/BO1hQai6MhlHB9rO6AqFEHdEcb51KRPqvSih+KfYRusAIpTKtbX3Lu?=
 =?us-ascii?Q?lfvZQtPgA/HpwEOkPd/WRY+wp3Z+JrabgLSToavACSm7Gz2hQTFbbSPf8U1/?=
 =?us-ascii?Q?Oq4+w6qMvjXcS/bmHo2KBj61XFFml6r56NCIQ+f/3fPjcOsG19Epel/4CxoN?=
 =?us-ascii?Q?6Zma+TajKpNuannAlahfC1rwEVPHSHsmmZpDU3sIGhunqLGe7TAVIc2494+v?=
 =?us-ascii?Q?PO6tJpgZ/kUvzWCChoy9ZjLcwyE5e4UFazGUa5gjMB0E1JrQCAwSU60zD0DB?=
 =?us-ascii?Q?eB641uygdfLFjacjT71NeLufyR8fB5he/X4jsmjtvFlsDz0/t7JCVx1b4IN2?=
 =?us-ascii?Q?sQkCVDLhyQQbb+RoTWAQBAwbK2B/z8/JarxzGcNLCQRdpc2FAw/xURAQEYwK?=
 =?us-ascii?Q?OkxmtyJX5Qb2yuCEr1mMhdQyH/vc+bMycECqkVHkXf2jUV/qhe3SlbNshFJp?=
 =?us-ascii?Q?a8t3l03SsyZa/dDGHPTPXusi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62adff4b-137c-4ef2-318e-08d960d60a72
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 16:51:06.1919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yy0Pq7PsNBEhyytn8VZ17LPuTzx2qEh2QwTBoam4Yf+k8XZ3sTnN6mMvw1E2hLpWZJG1pnMNqWJHEM/Q4jynhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2256
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Saturday, August 14, 2021 7:08 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Ngu=
yen, Anthony L <anthony.l.nguyen@intel.com>;
> kuba@kernel.org; bjorn@kernel.org; Karlsson, Magnus <magnus.karlsson@inte=
l.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Lobakin, Alexandr <alexandr.lobakin@intel.c=
om>; joamaki@gmail.com; toke@redhat.com; Creeley,
> Brett <brett.creeley@intel.com>; Fijalkowski, Maciej <maciej.fijalkowski@=
intel.com>
> Subject: [PATCH v5 intel-next 2/9] ice: move ice_container_type onto ice_=
ring_container
>=20
> Currently ice_container_type is scoped only for ice_ethtool.c. Next
> commit that will split the ice_ring struct onto Rx/Tx specific ring
> structs is going to also modify the type of linked list of rings that is
> within ice_ring_container. Therefore, the functions that are taking the
> ice_ring_container as an input argument will need to be aware of a ring
> type that will be looked up.
>=20
> Embed ice_container_type within ice_ring_container and initialize it
> properly when allocating the q_vectors.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_base.c    |  2 ++
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 36 ++++++++------------
>  drivers/net/ethernet/intel/ice/ice_txrx.h    |  6 ++++
>  3 files changed, 23 insertions(+), 21 deletions(-)

<snip>

> +enum ice_container_type {
> +	ICE_RX_CONTAINER,
> +	ICE_TX_CONTAINER,
> +};
> +
>  struct ice_ring_container {
>  	/* head of linked-list of rings */
>  	struct ice_ring *ring;
> @@ -347,6 +352,7 @@ struct ice_ring_container {
>  	u16 itr_setting:13;
>  	u16 itr_reserved:2;
>  	u16 itr_mode:1;
> +	enum ice_container_type type;

It may not matter, but should you make sure
the size of "type" doesn't negativelly affect this
structure?

>  };
>=20
>  struct ice_coalesce_stored {
> --
> 2.20.1

