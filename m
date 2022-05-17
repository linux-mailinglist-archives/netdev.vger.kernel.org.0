Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42F529A73
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbiEQHHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiEQHHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:07:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDDB46B37;
        Tue, 17 May 2022 00:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652771253; x=1684307253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XNPRoduK8u66OuSH/+gKHpuARySH4hD7poDFDsr7rSk=;
  b=cFGtmmmmie5521zKkg/hb9cbNI1m33RlPVNB6xrWJw25SCnWXBLSIfVq
   NUj35ds15noGQqIy0Jau68RzKap9HggjXfI0XYtzAhowiS5+9zusvRSL/
   JY4qufVUhnOFooMpdKoqTTjKsa5lAYWuxS2hqhNyQ2ScB9PMd4M51L0BR
   hmjRrVqpGxg5h5xS3FM983x9IxJ1m2KyYbqLMQ2zcPjncMg+LEuXaAtxO
   n4+umwZlMzquwF40lPJtGa4vTz9Esoph2IUsHa/C+nBXpkJSXQ7HxeGXE
   z2Tc43Bx4DCX37XHpDEMPYUlxsop9npo19sGn7GeDTnB1K+FJljcUA6Gb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="250984918"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="250984918"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 00:07:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="596980463"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 17 May 2022 00:07:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 00:07:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 00:07:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 17 May 2022 00:07:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 17 May 2022 00:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRApGva/4S5idOg8PcVrbZT33fnW7hAeDKFIzWqjZZPcZL2OO4lcTzQlh5J2tQl1uihW+65xQy0TJCcJGk4hfQmQ3f2mZCy7hoAVTN/eeMtOpcno2gSuP6fyMiSFtJwcIm5pCuPIZtbHxIbZtRO3AUD+YlZU21xfS2SJ2V+9Pdg5+MwZw/Qw+X+DOxG86hn+u2N4728XyhUywJgmRv93xgu/SPoPt93ItfU42Hbvd4GD9Na8dsiMUn26pwUS6vftxU2NZ54LuEhPDe36ypn8VHY7//NJWXeM4heZNTV39B0CozWUPpLjrcBdskIf+059mkk0UY8r6hbhwwLqT2mR/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mv9ToMEbZfgb81LRb7O7Nd+tKmxpDxFRo38cskiMt8=;
 b=UOp5nwwPRznn2e0Hx852K6UjHLxNeOMrWD8o4Uq9bNgS8ozb0t1YUVt4cJV4OYwWbx6i2HAyAIX//uzJemgVPJhwil7Y6Y5J3NcmAmYEI1eflB4tupP8O0O9gqV9Q7ZqvGiIwQqv2xed4W6iHwRfVcgE5iBg93U8D5W7PElF5nR/OQhi/sEpEEOE78XFakONS2Bvyex6KTKclSotGGIdJn0dme0XCTt6XcuCnmZ2lKgXZKEPKC57JuwIYFl3rtE5/y4wQpLd6ZD62gSZdvdK3PDq6rxtSKv0C3OfQvtaoOa8UBF07QBOpVqJyVopf4XI9DjVencM57QPvGHQ6owPAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MWHPR11MB1904.namprd11.prod.outlook.com (2603:10b6:300:111::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 07:07:30 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 07:07:30 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Bernard Zhao <zhaojunkui2008@126.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "bernard@vivo.com" <bernard@vivo.com>
Subject: RE: [Intel-wired-lan] [PATCH] intel/i40e: delete if NULL check before
 dev_kfree_skb
Thread-Topic: [Intel-wired-lan] [PATCH] intel/i40e: delete if NULL check
 before dev_kfree_skb
Thread-Index: AQHYZTzOQMmO4kPqPEi5xAu279lZRq0irvZQ
Date:   Tue, 17 May 2022 07:07:30 +0000
Message-ID: <BYAPR11MB3367D27F04977C53C9744AC1FCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220511065451.655335-1-zhaojunkui2008@126.com>
In-Reply-To: <20220511065451.655335-1-zhaojunkui2008@126.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1239056c-0d18-4d85-4e9f-08da37d3e858
x-ms-traffictypediagnostic: MWHPR11MB1904:EE_
x-microsoft-antispam-prvs: <MWHPR11MB190412D6049158239C937874FCCE9@MWHPR11MB1904.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nYzhwqfXAwEaC6b8u3pK2JK+UYcBnLPat1Fc6ET6x54GIhLxpjvDNpfJaJDFiUaepQcR7pYlG1JriCqyVv+hZgh14rLrvA5RhcKZ5kQBCMq6XtDJmRY/US/GeFVxY9dXCtjUp/WGRC41csDM5cv5HQgv1iTHgsvCWLKqPrD1spimWufr85Ybo7p4LzxiqweuTKILnEMgD8B0VGdtZoD5GYOTsdwJHhJx8tG6+U/la3tOnYE8vsuSuDRzyF3+riO8VPcAKMe6fb5LBwd0QCdAIVXwybF35kyIN9tWqilqutAuMDiZgyD+V6LgW1m8UEE0+G3iv0AFurg8+ogmBxw7r33LdwflUvJdaV12FkJGb1oKZyaNPJz1Li5g1d5ohpErNKLLvG2kIVaR6AksxUxa3GO+jF7dsBEEBfSj4buJ3siPKlz9LD8TllVMWMqfIZF3flvEk8gH8ijuya26ls++6MTUh3Tc975FoSYR9BoQhkDEvO7Fy4aMfVvbfEh/V4m7hVFfpxD7OmwALaNS6OJSeOTY2uwNuSEk9eDZhUz/pfWbzG55fw1cJ5HZfBoBm+xdjh2HLTkbuKn0B29YD2CDPz1poWu+2s70CsvrkYPg/s1ygQMAWt90nSsUmSz+sgFzqcblI3RzJy291wM3cwNPqqqq/UQJWfcjncSmOA+Vb794ipixCYcOKAHk/aChGKw6k9K2s2lLptkpptSCV/tSsuDCHQaOSemZ3Pze8aBX40U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(7696005)(38070700005)(921005)(38100700002)(71200400001)(86362001)(83380400001)(66946007)(66446008)(8676002)(4744005)(55016003)(316002)(8936002)(110136005)(2906002)(52536014)(55236004)(53546011)(6506007)(186003)(33656002)(9686003)(26005)(122000001)(66476007)(66556008)(5660300002)(64756008)(4326008)(76116006)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nRGmhE5umHrkGxvC2ViHkM44N5UHa3cxIhoUZuCXUUwDUUnUkgz/sYkLVcrt?=
 =?us-ascii?Q?sUvtCUuUFbTJHlSG8QMi0lxAGB7KWK6RCtb6CtpgVpTbMU8GG3V/3mpmThFy?=
 =?us-ascii?Q?ZE66aL78n0K3/0cPKQFXwX2sr1MovxLzTALq/VNuYpVeS9Y2FhozmtviaYHJ?=
 =?us-ascii?Q?ib6UKIFNpZZko7O+GNBVuUk+yZ1pSnWsqV9D3hF2XWfTx16BGd0Wmyh7i30p?=
 =?us-ascii?Q?LwoQxW5jcXHrgepOY2vKBylslYNx/RB2UK0U4Bn0Fh7hEhvIaLItOYlkNSGn?=
 =?us-ascii?Q?KWZMQfKnIEMoiFbKL7PiVK4aSe4GOzvwd1AF0nxFp8I0jYTtB3KtwG5qsfuf?=
 =?us-ascii?Q?BmUVadO5UxuSPuSP45e20/3thXNJRBCZiCf7PFCnbHJvWk1I/OVTJr2vMoLd?=
 =?us-ascii?Q?pE8YsYWJiyxbd9pBkuVta9Jpk9LU0WMhICddCLZqcreEGl2s3aT76ptLPcsc?=
 =?us-ascii?Q?seb8epjeE/ihxlwhlJZSDMiz72b8dSv0EyukFYi2sJAzRZv46OKWBctdmHU3?=
 =?us-ascii?Q?uNWdAwIlDMGT5o5RemJPDXBQiz4roOfuKc7SHQBmasDOeWtoygChA3wHtpTj?=
 =?us-ascii?Q?eXST6LiB52VYrfak9DrVddZLcWF31hRIOJ6tHM8hVKHMcsUyH+eQSqn4yjO3?=
 =?us-ascii?Q?slZ3r+QPKxPgsP0l2LaFad43OjduwXxjHGuUoKISuhD0/0V5FwgUlK7lRUsP?=
 =?us-ascii?Q?vO3VdyUYM3ucSXV8oNhNLPVvdibzyk3zS39GFkhlROnK6R/qcncGPuK/5goV?=
 =?us-ascii?Q?dEG7Glkzch7b2f1hjyKdfFBaBsd2nPhMTn/+rtEiDaDQMFeg8v1FvFCX3UAa?=
 =?us-ascii?Q?/TqXyZoBPZSfMzED4i5nI8pNZCWEcy8o3otp7YcPC7nSF9YX/Ne7jvkSxN2e?=
 =?us-ascii?Q?rik9sD79nNtVq650MSV4VBpnDzNDtSXfEuf1RZU9weVNC3Rh2j+h+MuGSTCX?=
 =?us-ascii?Q?uNiOurIB/Tt7C7c9FS92faIxOAwroAga86kJpWV44rlrxYfcFXxOJDcVK2pG?=
 =?us-ascii?Q?8/rU9iN+cAIlKbqv4OP+X2z+oZMZCUHdfeG9OvIRPMZylqLVoly5NNWtZeqP?=
 =?us-ascii?Q?8QZ85lnAq5PYvvRzXo7J6ri8zqk1UXvdmU4YFUCSWu5LCrTeUWGsV/ciBgBd?=
 =?us-ascii?Q?Z1J1B29xrORmPvGsHmAEBSJofQJuvi9PmOz0R/doVAIjGoSoWCl/j4sYRo62?=
 =?us-ascii?Q?zeS6VissYWIprjbudNU/aK+4CROwUP2OxGo15oAq1A4fNy3Ql1Nd2sr+ouEh?=
 =?us-ascii?Q?Jid0XEy3ll4XwQZMrTyM1hNQHVZ6qUeyzf0BDdlNDoXSGl/aC7bQ9ZcSGDy/?=
 =?us-ascii?Q?yuYJTinTth2XAqGIdveaQXG9+fwd1VbCBxG94VDyYBeMvlzsCuGCxKnFD+AC?=
 =?us-ascii?Q?jggEqiD347JmKdA9nIr9MGXKbvYa77w2PKmCraJK6qsTDh9Y9k/albjmnu4p?=
 =?us-ascii?Q?3XkYYNjUVFtSCi+VgTIiHm1bdX+ggKhNgzYLxatQlvi0Dh2IK5EZtGe/9SDJ?=
 =?us-ascii?Q?1Z+i8RsUiS+IJXWhPbpkOmD3t6R6Wl6i6OR4dpv32iQoSdOQ0MyFJTWGezuY?=
 =?us-ascii?Q?SgyjRKgE2tDtV2WK3R+o0y3CGF1LuhZQ/aeU2PGS6Hz+u8OVghWLsEfCZ89p?=
 =?us-ascii?Q?uL6h97sfrNgmsq8rohrJJ/LQo95zX14BOapmDuSvS+uAHoahzTLlH8fOq3h/?=
 =?us-ascii?Q?smOpe9DR8kA3smFdDV/A4ab+2+qDLFDoW/+oYFkQssFzi5slhB6PNZLiinc8?=
 =?us-ascii?Q?e+ulnmzV6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1239056c-0d18-4d85-4e9f-08da37d3e858
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 07:07:30.1606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jK9zMhVEi/3pGcDKLmgZWbhMYHB0Z2liXndLJCItl8izYEWGi518y0Q4FwssURAABCTFkiyexF5qaLv6lgNbyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Bernard Zhao
> Sent: Wednesday, May 11, 2022 12:25 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: bernard@vivo.com; Bernard Zhao <zhaojunkui2008@126.com>
> Subject: [Intel-wired-lan] [PATCH] intel/i40e: delete if NULL check befor=
e
> dev_kfree_skb
>=20
> dev_kfree_skb check if the input parameter NULL and do the right
> thing, there is no need to check again.
> This change is to cleanup the code a bit.
>=20
> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
