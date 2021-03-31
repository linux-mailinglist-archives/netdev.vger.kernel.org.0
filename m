Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B443500C3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhCaM57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:57:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:61447 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhCaM5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 08:57:44 -0400
IronPort-SDR: Rln8IoCua006TdAyLzvl4MbBp4LJb60xTdm9LUw9OcL7E7X8VCNb1QyWkV5EUMpthNm2hQCklF
 dA8mpS7yWcOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="212237531"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="212237531"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 05:57:43 -0700
IronPort-SDR: bjlri3IXVFc3Y6dOZo0XPAGcWlcL34O9j6xyk7nDTWmMGHWuwZBx01/rJ8vOYYcfaAo2tCiXXk
 kFJF55vEfbSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="527769226"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2021 05:57:43 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 05:57:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 31 Mar 2021 05:57:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 31 Mar 2021 05:57:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lj1ds0oRgEDgGoP4iuF+cvFUMXwc9Ji8t3CDz/ouVbMJYIFZTcwTCR32wuFs3OMK7c8GCUi7hytTK8lIQBWxmDHiBgBIFThCtl1SVrE2qbmI1nt+AEV5xT5nL0CR3ZCgwQEXfHXnIaOC5rIVU7IkRRkuqxS8Tu9WC6zDQaaw2DsZGZ9vDIUSbYZtlEm5G+gGWoJnIOGi5TiSKOpkEo9yuL1TvbH2fpvycnmPX2ThJtN8g+U6e6jFIn4prRlFiC32tP5cruwOr9FpLx2S0fOfECR82gF70xkY5pnhAmIwwkXp7nQo3K0O2EwzKc6biJYRuvgCQdRCw0QrHr5OyDGq5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12f/hWPnBeIUAkFlDA4PjyHqskUcOC1NtRXiDM2V0ks=;
 b=VDKmHi7LYJC0BersKV6Eq/oSAKYB38GLC6JxFrqXdVmN4LImvZShNr10npKZVc7tpWiZDv1q6B23X656vlMRAjcKVcpZ7F7FCTFXSEFUmeA7vOjHOh48IyH/Rb5EmHL4BtQgQ3F5pnsSn/XCaJsoTyrbi0qAxRuPoudqvu5kFR9b6kCi39pa0Isq3Nb/VjmzSIyGq+kUnuEzrEsF5EMAMVf+f3uhZneLCu3vYTP416ZAYPjuVldxpc6EfGEEtRJdFlRCzSKCCYyEVnQ5PCUYUyO9anmkMuxXhXrbFwo+hsNUO0LmHJ7hEluAVgyIB/7ifrIO+QemjCk7g1HsasKkBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12f/hWPnBeIUAkFlDA4PjyHqskUcOC1NtRXiDM2V0ks=;
 b=nLwnTXKHnw04T+K+B223aIGlN4ibAdu8fwdudNIvNL1MDO1jJWLCXeyjWUJFA4zSWs+8olwGR0Oizkhr9Mo9mKBjDavbzug+skns7nxhPD+SvFWwHn5u/4bLW9TC75dBVXcoNzcPLtQDUFBvCLjZUVOI3XSvb8OQXHMJ53K5mcQ=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB3802.namprd11.prod.outlook.com (2603:10b6:5:143::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25; Wed, 31 Mar 2021 12:57:35 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::49d7:5128:e3cc:695a]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::49d7:5128:e3cc:695a%6]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 12:57:35 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Joshi, Sreedevi" <sreedevi.joshi@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net] i40e: fix receiving of single
 packets in xsk zero-copy mode
Thread-Topic: [Intel-wired-lan] [PATCH intel-net] i40e: fix receiving of
 single packets in xsk zero-copy mode
Thread-Index: AQHXHKSGNpFwotJmWUSG0GvPFk4OuaqeIQKg
Date:   Wed, 31 Mar 2021 12:57:35 +0000
Message-ID: <DM6PR11MB3292D119D24C4E9291856E02F17C9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210319094410.3633-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210319094410.3633-1-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [198.175.68.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b0123c1-6083-4d0a-055c-08d8f4448e5f
x-ms-traffictypediagnostic: DM6PR11MB3802:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB380263D6B0073D324518E646F17C9@DM6PR11MB3802.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PAG3jzbO57X26wEOSYlQBTiCQPu7GyUplYeDg5VXpaxJTOwCTzJNdGyNzLwHOjgEE+TL+oWBOnjrDniU+SbFrbLXFPaLuozrHUzyPacEgfyBgbbg16eDAhGNYQ42X0gvueSn+YQTQzfYzQD4b9MxwPEEhOP8B7a/QzerR9NY5rMHMJ97VZLNWYnM7QcMccw9DuRZGqbR16IoDzKvlXIBxQO3CRIyh08s4xwcqeJ9J45eZgdwKFhx4wHm0JVmGNDZOxDZZ/ky7nlrIKZzyfHe6KfMLkcWilz0lcgzWMflplVd/zyemx3Rv6KgzJnYGwQJV9STKI2ZRNnpBeKMhe6tygPJlfV47sSXzCHXStNaPtjMccX/DChuKV1WHlpWGwiD77V8QowAdqXQRMLNCm9pt9HfUgchBTwhHdxnc9U9hoEfoV4dVuDjYNL4/vRgZ3EOpbVzBwccPwFqhl0p3sGpC43TV/3xHf53A+9Uy2C3spninYPUv0nUkGkz2CulHCjsAJ391e8yD/szcs24obLto/LVGFQibIvts2Qb89MJZmKmAEpjZZ91bimOEZ/2RplICfv1jEDCRLjulH34y13KGklCFeh7uHM/31GcoTOdB8gRAfYeD2Z26sLLKBTlpgAp26LaiPdEQgwCblbrKzOVZv3dAVKmfxr0NPwRHaROMTA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(376002)(396003)(6636002)(8936002)(8676002)(478600001)(7696005)(64756008)(66556008)(316002)(52536014)(55016002)(38100700001)(66476007)(66446008)(66946007)(110136005)(5660300002)(71200400001)(54906003)(33656002)(26005)(53546011)(2906002)(6506007)(4326008)(186003)(9686003)(107886003)(76116006)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IIi277sWmKBvDowIL/b21klbhb8GvxhrywLD2Dy3zbkCcV8uh211XIePuRJC?=
 =?us-ascii?Q?6BxtSWAuYAeYDhtT8e1Y/VWRYz8VY/2XsdPsCeceml1cG3ciZkkAJKtof8Bj?=
 =?us-ascii?Q?Asfl/05ild17vj/UmJeA/3YebS1/SdOur/3Qcq/B8iIEfBrG3quJHQCTOVr+?=
 =?us-ascii?Q?lNuQg6CO+gn5RqPN7XpjBmL4XXzGkzsNlgBU9SiAXIJ2s++3457XjDd8Rrvl?=
 =?us-ascii?Q?PqaGFTZiYmC63xytD6E3Iiv2Dc8lkIBuhga4lOYYZ/YBN1CN7s9ri+6lkQM0?=
 =?us-ascii?Q?cmiyriA38ailIMUDbYBnygMJFoD7VD5a39EEeKcMUa9G/+pupE1DTtfI052w?=
 =?us-ascii?Q?za386S8EtblGLsPxlb2DLSn8CX/k/LZOkkF39mRhpyZ3Wmti35k6hclAOSde?=
 =?us-ascii?Q?Eli+bVYUnA9BbwUBaJjCcEjmfd1/07CB6g+wZFXKDxQ7mEKfMbcNHd1/Syhl?=
 =?us-ascii?Q?o+leOu60gvYcloQg1mZ95zXVtaK6MM0ZZ63LSQL6KoWenascIzc5il2CkO1E?=
 =?us-ascii?Q?N5ZEzgsqBhhith92pdJtlOdUD2VFX8sk1AnNsvAqIhgJse/1hPih6Cegruzk?=
 =?us-ascii?Q?pdsxh+5YXc+1N8SvYpwa+mOw1yFgzUxelUNxXNbkh+ywE7nrl9kPO/RyMDos?=
 =?us-ascii?Q?P9LzqCWCbhYXcF7jHY2nmVPdlA7Dl7quSRicjvRgj+7j5moCGKpqgou4/wqg?=
 =?us-ascii?Q?6tUVypB8CtwSn/CyQNMkumcsnPA0Nq6Z5ymZDhh3ir8LVTRAUyZHmTul8mR+?=
 =?us-ascii?Q?hP0iT/2P9po4QhFHCLwFNQETXqe4BOGnQqyMeu6dIs1Iy0hQ+x1T/uPYOc4j?=
 =?us-ascii?Q?UvLov5ygXFEGkZewuZFxVKqV8IoX+UL3qjGGXAxnxWUC9M50JSliytONGOoZ?=
 =?us-ascii?Q?eQZJWYSlaVo045vM0TLZvVVG66KTleg/R81GM+GS7YJi+tUHIYQTSsf+y4Lj?=
 =?us-ascii?Q?8oxt/+cjr4tfOj/N2LDYNDERSd/kBK1sPD+tuBFqLzsxTuI2lwM5Vdf5d1Jb?=
 =?us-ascii?Q?QIjwg56WGkHZU5FU1qnV7U11jsLWE4DME+atAKpg+732gV3vEEQVtTY1nJDs?=
 =?us-ascii?Q?eOfHeRq05fuS8rN4BvMk4gONs85aAtr0kvm1VrF2DvT4JyeFu6HY3IMrJQ7A?=
 =?us-ascii?Q?ExzGrzXhzGyT+Q0Jj0wieeFnPpeYCfCIPRcHNPJRf/Y5scQtYHl17rSlHXfP?=
 =?us-ascii?Q?rIWT56nlo3ubo/JFAeKvZ2SbQtOPMPGfl5++NDZ/ZiC431+pYKVQAjs+aPhP?=
 =?us-ascii?Q?q3TqHsaK9BvdBRju7vTG77zFI/z0IwFwM8Y/Y3rMSNRcvorqDvSCQx0bnZhg?=
 =?us-ascii?Q?g7akGtg2gaSXiVkMbIbN+6RL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0123c1-6083-4d0a-055c-08d8f4448e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 12:57:35.5121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwjXFX+E2SvKcshla+trvV/UVLI3iZEVVLRGh62I5MC1DV7A+UEmiE2DvvEFyrr6KdVLQ345IdOXHZ5+WIpUBvnjLaxvFwnD4B+b0jh37+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3802
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Magnus Karlsson
> Sent: Friday, March 19, 2021 3:14 PM
> To: Karlsson, Magnus <magnus.karlsson@intel.com>; intel-wired-
> lan@lists.osuosl.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; Joshi, Sreedevi <sreedevi.joshi@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net] i40e: fix receiving of singl=
e packets
> in xsk zero-copy mode
>=20
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>=20
> Fix so that single packets are received immediately instead of in batches=
 of 8.
> If you sent 1 pss to a system, you received 8 packets every 8 seconds ins=
tead
> of 1 packet every second. The problem behind this was that the work_done
> reporting from the Tx part of the driver was broken. The work_done
> reporting in i40e controls not only the reporting back to the napi logic =
but
> also the setting of the interrupt throttling logic. When Tx or Rx reports=
 that it
> has more to do, interrupts are throttled or coalesced and when they both
> report that they are done, interrupts are armed right away. If the wrong
> work_done value is returned, the logic will start to throttle interrupts =
in a
> situation where it should have just enabled them. This leads to the undes=
ired
> batching behavior seen in user-space.
>=20
> Fix this by returning the correct boolean value from the Tx xsk zero-copy
> path. Return true if there is nothing to do or if we got fewer packets to
> process than we asked for. Return false if we got as many packets as the
> budget since there might be more packets we can process.
>=20
> Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase
> performance")
> Reported-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
