Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7404F7714
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbiDGHQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241530AbiDGHQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:16:38 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AD8F3FAC;
        Thu,  7 Apr 2022 00:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649315679; x=1680851679;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ahIgW+Y32NhgJ95fwQbNAKauXkOqVkUlgK3uHWQqBMg=;
  b=UscoazR8alwkikxSlmnRgXB/OfOYH3SG0wdncdArtRmmMIl050rtJ+yB
   FH97zVe8cCuU+nRUgM6b1USzchtOrJ2BgwvgylubaBHsFHUvhMiONG8Xj
   X/enTe5c5mGffKYmy8+BNoc3YwPRC4OATdBc0/8EU5TyCs32UdPdXVcau
   zNhqWs/3C4rK2TzBukcQIRx2vEyr084hSYQpgqVESQhxnFHH6Sg6RJE0e
   ESXIrWx5uRBfX8s7iggqQpdQdm6V04ZREHalQ/fHbRzwpJZr6XC5vXgj6
   44/kqwXjwVBF0YzVsomeiBsEGM6vy2ElvvQFMnm5eOdA7J7gpGs2kcTL/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="261426585"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="261426585"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 00:14:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="609216299"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 07 Apr 2022 00:14:38 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 7 Apr 2022 00:14:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 7 Apr 2022 00:14:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 7 Apr 2022 00:14:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pm7Echs7xowV4qGCHhFHAcROKdoQ5RFyaLu0qU+VzfVexzFiDDh8TjSMkxbdHXi6b5ZQ2KZ6nRepmS2ahYTniusFoQ7Gt8/x8dNtVgl2W0gOtzMPgrFB5JQfz1s8U1VCwYdRmnro7fEkMcxkpL0Sp/YJY5FUlcST6fI3Yu/MZLiZABP+gbPHQJLE4vc7t73hDSy8yYUNFw/0HfXV0bgsbsXO7FJDJGB7QAjCnOg4G6GU5/Kml4sLqiFNfEBhMlNSC2dZgJfGiAOnnBP07WBgCdbj8lPNbL2YEVJPa8sZtDEddryiG/nd451PUkqNQdmSUAUatau7x2LcHUv2kDfSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTLw++HBOzjJ4eWcipUgK8mjJTWs017gqT7mm+p6Qzk=;
 b=brumRkKy2MS0ewifdzSUeVAhieDdg45dkJ3QuirvG1y7s07njJ/lVwjmu3zMTJdn7ngrOUfSc+kQUaeqkjHhb2dJ2TdAuxs8iM5/irktgqxuN3cyci5ZwqNK1LDb1J1mFRQTKKxlsWG3ZiTCkeA0xUivqacrpxUOTWrZjN4wYeD0cUhC96YZbWumrCOd7ScttVy1/1jNGUdIzBGTvSmKoNbM3BY/y/VrVz6zxXo26T2cpm/fOtfooJ4aV37114pKyL13su7cZR5euMncfNWpafIQlrVx96QyPP+EGD25qSUOH/Qsvrao8EyLM+DnzeeC661bhVmFjA5Eb0HMUBIXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SN6PR11MB3392.namprd11.prod.outlook.com (2603:10b6:805:c5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:14:28 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::c8d9:8c9:f41:8106%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:14:28 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: i40e_main: fix a missing check on
 list iterator
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: i40e_main: fix a missing check
 on list iterator
Thread-Index: AQHYQqtWg9RkTjKkJ0Srnw1g2FXWpazkGL8Q
Date:   Thu, 7 Apr 2022 07:14:28 +0000
Message-ID: <BYAPR11MB33679D2463F0E8B3833CC64BFCE69@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220327063606.7315-1-xiam0nd.tong@gmail.com>
In-Reply-To: <20220327063606.7315-1-xiam0nd.tong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0714761-c22e-44f0-5d73-08da1866412e
x-ms-traffictypediagnostic: SN6PR11MB3392:EE_
x-microsoft-antispam-prvs: <SN6PR11MB3392B2E2396D9085E3C4C1A5FCE69@SN6PR11MB3392.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qzCvsvFMqG6gweZmF3rlsq1ONF9m+RHNm6ngqYZBwus7c2bW6ym6GiKkTDf4uJa9aQnReZ3qA+0sdgkTJOzj0vQx1IR7clR+POEeGbAsyDsmbK6skkf2brDGuEoHHES1UNJaamWn+l65kFK5InJgnhyrdkTKvpf3kgVaT6N2RQEN8LNUNKIrCy1w3XPRFmyhVWUs7ABOVYoZEDb3m5FUoj0PhlGmywXba4bIe4oYNjQzB+sYeduA3/7a77wf6qOiyBR2ANKIMX8/nhzsDir1dR2iHVbdhV3QCCrpN3HuNwvlHZTvIyuKQBe63ucGolX4aPdo0iB64/9xu3a7W3HCfTHTQ0/4FhFxbnZraj28SLokIS3YbEMpXzH8GYuDthiW6IdiHWp9mABf9iqS1od4l+v3xc8pIeNhOGIlOWl8Xq1q1HylJa53kqtJf3TQd4tyfkujNT9r7VswcpIfbcTonAQ6r0uh5Djn8VXJc6OMH5rFfIhpj9QPZOX5Im86bDczxZ3sRre1JZp5wjdvZh8VYvO+ba5kVRTXgoIwSFKPClQ0E19w17q3/HvmGhE6X/7ba4sWi8a3OK08dvKqLJVEcbZX1/rDVzRPqu4KxzFvV2RGPEkDMEPOm68+YxXut8kz541YZ69G51U8JChPAuq5HRQBep/vJjY3eYbaS8WZVLhXOOcXazWyM8gttqXfNzASPwllNo86zv1pIA4+RaEpww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(8936002)(54906003)(83380400001)(33656002)(6636002)(71200400001)(5660300002)(86362001)(8676002)(4326008)(110136005)(316002)(38100700002)(66476007)(66556008)(66446008)(26005)(186003)(55016003)(7696005)(508600001)(38070700005)(9686003)(55236004)(6506007)(64756008)(76116006)(82960400001)(2906002)(53546011)(66946007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kwYoqt4py8PKSIGrtjiUy/wfCBxcqkzQgGkiHI7UpbSg4PJw6yOcnaRYt8K4?=
 =?us-ascii?Q?CEDwiecqBW2kvabjPnHEgknm9jCbf0yXacmLk+CJtcZGxC640IbEHJF8f+Qt?=
 =?us-ascii?Q?h+Oldv67xRFJKP0KSoY8iWgmFbzOJop54UQdWCEQJmFaYjY9Xgl1E1d48e6d?=
 =?us-ascii?Q?aFkU6G2kdUZPd76rS8lT7RFpnrMCmt7oi1aF5cu8SFLK+chwEhr2Z3s3shgG?=
 =?us-ascii?Q?K69uHL1Hr6kmKnmltuQAzX2XHkAC9dxB4nhBfMI/XBmzGpjeQ+n1ffZoU1jM?=
 =?us-ascii?Q?v0tjKW39v2mnK+YcLMgmSlboPWLz1KS24Kfk5lPCP+lwtCbMSoao89mMMffq?=
 =?us-ascii?Q?gnsqrkILxP+yRkm9Ss4esV+3pEz37pR3FkJAoAcSQ9OIV/bAN+QOvCxg9tGM?=
 =?us-ascii?Q?Hz0QuPVg3PQFt8Xo78xXS2hpDYGIEfYvhbeDBbte/QDEHQmm0Ci+y5FzUd7/?=
 =?us-ascii?Q?+hBQz+/86FBM3je9Y8iPGZu/cRort5r9EAGr1z7X3q1q985AbvyP4y9Wi5Jo?=
 =?us-ascii?Q?mB1MzZsIBBg78GmxV2qeBoZCfa5ET53sBHVOZx2E8CTkFxL18KQHe/l1Mqll?=
 =?us-ascii?Q?bGDSzHVU8+Dbsvxdh30LfhFx4D1NLKdVWeSMIZYDdM+Ke/upwckaCTLiGKqo?=
 =?us-ascii?Q?f5Bo7f5ji4vcf0SFuTNngNlzdux4gIgE9YIVNQCYeeDc9qul2bPwWl3G4eio?=
 =?us-ascii?Q?2o+d6PnKiLOSBQpypiPi7mB+bmaYiKb1LuLrbkZsgIYfCfEiwzgazzZQmAOJ?=
 =?us-ascii?Q?By0rBCJPZy9hxZCWOQwI65fB2aGNvwvyg7EZqBuuZRpQE1Pomgf/OE/1Ez2U?=
 =?us-ascii?Q?jmrXoUqMOX6maDBoz99dIhNQG7dpMAsOCMVvXA77byCH7sjXNoU2F1wL21kw?=
 =?us-ascii?Q?SbZJlyouSr90JXv2rO8ly+uEwCTWClSaa/v/KQrNsls+jCMnKjIJlbDCLWJ0?=
 =?us-ascii?Q?DgcArKhPwh9o47Dx4VuLOTCa9kEOGbYuGsGhvPon3dNc0sVDc0lIEM850IBi?=
 =?us-ascii?Q?26KlClgNCDXenPXTLDMCibJFO3UYJlEWwgi71eMuatzpMgFXai/gPqJ7bPdV?=
 =?us-ascii?Q?9ARef4ePvjYtcz5EqlbVIXH8oQeybFNgCw+xcR19pA5isx29uLP6JOSaxTPH?=
 =?us-ascii?Q?8GILyszoFsXp7Bm03/GslJUeMb+v+CFHsGmy7hzfcHi4fvMcr1m/tnP1J7jv?=
 =?us-ascii?Q?5wB0LI6FtqCLPpYggLONzD9hPLV6ezqMdTFt6C000yxcBXY1Efc7+WiY5W7l?=
 =?us-ascii?Q?EIgommWBfq8IyhG43dXKygThuP6FhhXyUCgJG5yqJhJV6ivuERWUcoHEqYLR?=
 =?us-ascii?Q?uolrV2Gnr8F14LA6XnBNYtvX1xC1qZXagIocn8Po4OCuMXELgNpsjoJQZeYi?=
 =?us-ascii?Q?eqI9vR3vPH/2VBVRbXMMaihVqYRe0rXlLMAiYbrIHypTRUn9TXfctO3nYZ0T?=
 =?us-ascii?Q?DBfaseP6urbEbX6C45ekzeoQIq6gCRKONAiboV+ZfrlWTU0+iQ9mi5ou4ru0?=
 =?us-ascii?Q?PXT69917r4cE2gMv5Xwzqa3HaC/c151+BIBzdVwyaZ/ljksu7C4Sr2iFU9QA?=
 =?us-ascii?Q?OwehGUlfo6R2uqktapQiELf063WRHwaUe1JvIO+TQr02wV4Egjh8/FIiR3Ld?=
 =?us-ascii?Q?oFXlcz5gdC9PP3yDzHVSlib1IZ2jUN+3Et2VpXJ2c10VD4IZxFG7Dge2KA2X?=
 =?us-ascii?Q?61+qHPMDwVM8UdqXfZygNbPiz7k/p2RsKvB9J2pgIQOol1LcnrHIYVp9qSOD?=
 =?us-ascii?Q?NvM0Y/2U3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0714761-c22e-44f0-5d73-08da1866412e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 07:14:28.4385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHNAt1+XolI0OVht6YCTPZaa0I+HzxtoC2TrAgrKfhAzz2C8bVPZ0mFtj6+nM5A9TewsVVBEltePCjbecr2vIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3392
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Xiaomeng Tong
> Sent: Sunday, March 27, 2022 12:06 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: pabeni@redhat.com; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Xiaomeng Tong
> <xiam0nd.tong@gmail.com>; jeffrey.t.kirsher@intel.com;
> netdev@vger.kernel.org; kuba@kernel.org; davem@davemloft.net
> Subject: [Intel-wired-lan] [PATCH] i40e: i40e_main: fix a missing check o=
n list
> iterator
>=20
> The bug is here:
> 	ret =3D i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr,
> &aq_err);
>=20
> The list iterator 'ch' will point to a bogus position containing HEAD if =
the list is
> empty or no element is found. This case must be checked before any use of
> the iterator, otherwise it will lead to a invalid memory access.
>=20
> To fix this bug, use a new variable 'iter' as the list iterator, while us=
e the origin
> variable 'ch' as a dedicated pointer to point to the found element.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 1d8d80b4e4ff6 ("i40e: Add macvlan support on i40e")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 27 +++++++++++----------
>  1 file changed, 14 insertions(+), 13 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
