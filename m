Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED323532B6A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237782AbiEXNke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbiEXNkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:40:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0E75221;
        Tue, 24 May 2022 06:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653399633; x=1684935633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=++vjas+PX+wlqfV344tFRyjKF322+YsDWlLQtLrpfxA=;
  b=nac8nzMZe4txupb5zY20v5whw29f1e0K8K2l8ITByPBc6LyVzS/cFEkk
   d+5tbnRbI4jI1GoE7HLkBYdFHKghSl8zS501/AaJUOPPmS98xrl9tA4NI
   meGCvynpyPKzvdUxcHXlesenC7xwXRy2QHKpVROGTKQFpGNVW76ypQjjc
   tpp4kvUNzBhmJa8zQ60uxl8nzzszqECnS50GZkIhS22dsFZ0fpOHnBqLM
   aO7yWaUtwvYrMyapyLqVZFY8yQYvxBUu9Ju/CWiA5pjxbAeHtFYxstGPt
   FDhrjvVaX2/9MfUtbEhvE2G2kz726c9dJGPMyT+fvqnGyl1CLeEsXRd1q
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="273645326"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="273645326"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:40:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="526406089"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 24 May 2022 06:40:29 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 06:40:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 06:40:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 24 May 2022 06:40:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 24 May 2022 06:40:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeAXRtd1KiIvH6xWi29bmD0LcaercpbKvyIjfC7s+BgEk0Ex3ZUIH+2lP+n43L3VP0vVhQIGRGX0qyDGwUleCMnI7ggTcSl9yQCd9RaEVDNqkqPs+jTBaYlk+Yyu1ViX1w0JCHZketc1e3mpFvyZ5dc/O/4kbPuuoO4eZCJrvCVqbjvtezUfv49Ss1Mg/tlq2xuj4DkCoS67vuR61UeY409E+GycDKbZlvHS5wUk8LuDzvbQ59abX1sSkB0k7t+2ZtrW9OJw9xr16ML/6GZ/C154omjYZ0HDBuL2PNSoSgMWktMOi+cqMEUF2TUPeXMOmz26qFfsx+JxQEgQR+8KIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAfxoN75yPrvYNfcgpTDZNM0Nz8aEtz6xVVTu8aQ2CY=;
 b=oBCucRrPvczJ81SAxciw/mnKSA/y/2+Q9tf49q7+1EBSzcmCXlOEywlclnzROQW5lqLiEw+1ZGOJV68nc7cXnI8ITFsnzRgtErpvi5dEQpy9+9IPkfWC199bfZsemVJt47ofbZPSVTynSwd/kdfBFZ5Cz4SBOi8aXbqwVQVnex2Gd2/Crlb8WW3HGXa2cc0xWsfk2NXcGhs9M3zntnY+yNVjofExO2FwSNOTQuVulHpA8csYype7ukaSRCPe5WRf3L9fxXtLtec5+CQV/OgubHSrKwtoI1H6j6Ilmgh8OVeiKCqrkiohHEsV0Mvw1omp37rnlW8+iwFs/05E3clEww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CH0PR11MB5475.namprd11.prod.outlook.com (2603:10b6:610:d6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 24 May
 2022 13:40:27 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5293.013; Tue, 24 May 2022
 13:40:27 +0000
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
Thread-Index: AQHYZTzOQMmO4kPqPEi5xAu279lZRq0uHQYQ
Date:   Tue, 24 May 2022 13:40:27 +0000
Message-ID: <BYAPR11MB33672B20A0116900DAFCB8AFFCD79@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220511065451.655335-1-zhaojunkui2008@126.com>
In-Reply-To: <20220511065451.655335-1-zhaojunkui2008@126.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2b30c96-7456-480d-f326-08da3d8af641
x-ms-traffictypediagnostic: CH0PR11MB5475:EE_
x-microsoft-antispam-prvs: <CH0PR11MB547500552777604C798FF11FFCD79@CH0PR11MB5475.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTSW2sUM3RfDCKrld0mkbepgf4ZiH/QZcQkh1zNDGtXjxd1Nogy1QAM/95WaCamb0ZcRUvDxZixN+ZuEDj2X/XcOrmoK4F/uoAFMLEyYDXUhFy8//dh8Ni2IFmkwtDdvmbuywDC7mWrC5k8x3XqHgW5V3NdbNL/3YwAhgwvyWWR5q7LgI5RFyrUzJeOQGmlDS8MXA0uj5KQTzDdz9RMpXuo6he0WOAZY33Quj/JTjubzD7ZoM8i+X3Z2EVQQTHouz0PVm9WC68RNHc0IKsbUhAoLdjEGHp1/Bgqu5x2+9H8cN6ZB1kDkflRYHk58mIunfXIDSSfLZMnBg3jutFHmE7b1GyKVkOADbtMIe50cbjXJQsG1TrYmfPgJ5fRVxuqI9krUc5OmWPb2enUQk3dTQe1gG+djf1tQf3a4FwaVIWLH8c5+9sNEKEtLMKMmJoCg8nBTAn7bjILKoxvt6H/N2wUuIwcxYC9QFXX+tCb1sc/mxrqNFdRbmMUQzzVqAznebcNUHo2G0OdxnA0pInj4VgP5+oLttUTcZ1G10s02C1Nc8fNJXG6AunD6vCrfNIkNjYsZm5l68EzTVNlXLnsI82JlSMTQBkbYBbvBL0x+TXsdjRa/s8ecbeHi/HeDVFpq/gpMUJwaCd2KKkIctAOtRRSU+jQpkmN0hOeyJ8cJm4IJAjHMjbVFH1mzS/NkWqEm0ISepdKQsPamFrkT9CfrJgfdLPCu6g6+bH/IdJXaeYg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(316002)(83380400001)(8936002)(122000001)(2906002)(110136005)(186003)(53546011)(38070700005)(66446008)(66476007)(66946007)(64756008)(66556008)(4326008)(8676002)(4744005)(55016003)(6506007)(7696005)(26005)(9686003)(921005)(82960400001)(86362001)(33656002)(508600001)(5660300002)(71200400001)(76116006)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V/vJQKJlfrOqKGNTesh2zDX8QH4i1d6j2kvDD4paLEokVAf7yokrUq3/tp3K?=
 =?us-ascii?Q?N3u8ITFAtZ2dUP79+YtJiHpxfhrstYtDqoKFXapqNCWo3G6LxbzHX0Y4l7Yj?=
 =?us-ascii?Q?GPvVOcXIGl18YhRB4f6Qyecq32Am6iwZRwwXpvsnxz8BNLORGG0ThG9jWIvp?=
 =?us-ascii?Q?z/ive7fgpAkAUa+KZfi9T/+kHbbH3uHTolHBiRbtUpjmSdZhuj5mjLRw1XMQ?=
 =?us-ascii?Q?CRBoHVw97azoxaJaUNDOoGlO2KqW5YucTVybxdNBtub8F+kNilswSg80nZ2D?=
 =?us-ascii?Q?ya/RkMZVFLjby4IyMe8fSU7feK7No5AyYXEY+FV5nyJCAiI5vUUH8ZAmoVrf?=
 =?us-ascii?Q?50GC2Mrg2PBWcFi0XrhkGm6mAsn9qgHDPHFpcm+LiVAj/RhRGduCtg+jmzMG?=
 =?us-ascii?Q?Hug6nwxbw8PBljkVKRwccy4QdSpLtIGTBmdRiBsx8IWywruMmNbh9LppA8QN?=
 =?us-ascii?Q?5WQrBqo3Yf5XGshOLq9DmIPZCidJml2cPdBJ3UmicURVj/qJtwgyl6yW1prA?=
 =?us-ascii?Q?q8adJvDlotZmjm0+RGsaLVJ2bq/ReX9a5QtXZO4M2CGVH0+sx5fqIkNK7eyA?=
 =?us-ascii?Q?se+dez30l9bLYM309256N3tZdWUTlotiM6VWKSGKbLafX33jrSJQq+O7b1O0?=
 =?us-ascii?Q?FmQFkerH+wvvrVgJSiBcs8lwsMNowg9KUQbEYSFSlNZy6dtWCezpY+/hYoZ1?=
 =?us-ascii?Q?GVxhGay/QC8JqL4GT8kV+3PxxfH0q67ix5moCkA8q0l/gPcFYZXoZpuKZ659?=
 =?us-ascii?Q?D8mXaLsrr+43hwLM8ysD5gy28NKflln42slAlvsSThbtAGVJRJVdVWvE6nVh?=
 =?us-ascii?Q?F1oVUg5cOh+oFfW6STrzD/GeU3GDrHoAL3EHLFlJQyUzoVD0VGI9sRs8O9co?=
 =?us-ascii?Q?gMbGXwJMyinCK4b5jAcMOMG8Bo2xAqp72APhD0lZg0KiHM0BzSSUAqqpzX1P?=
 =?us-ascii?Q?9tHF3RbXbzX08G6R5xeV7ueh+AClthQUODhIDg+RhSaayQdpj10WT8C25+xw?=
 =?us-ascii?Q?p+DpzNKJRyQE9oHelXOBe4ZahTNGfZrGRCsLlV7g8F6iX/oInZawkBiCii3g?=
 =?us-ascii?Q?S5SyQH1o/6VAZ33KhngL+KfxNdbxCqhPDHmSgke4CeI48h1M+S2CAzerUe9S?=
 =?us-ascii?Q?7lQZc6egzaOKPDJe65f0H82WItROFXy5gBP3aq2bbs+j9QwRsXyYpEnjgNbo?=
 =?us-ascii?Q?oCe11MY0ZIQeVNnXr+pcMTydOLZ9bkcRNwDzN/a9bE2pERkO7Eul1cpdXf2F?=
 =?us-ascii?Q?5w0nVl1Hvm+8z52wCXkn8mnLK8EnPkfw65GsiZTykJ3Pg4oHmY7+f4NmxMWC?=
 =?us-ascii?Q?v+Ry4uOWY7fn03nZsEl/74RTIMDcAv6HK9QfUP9LJWeaRxtiA2NA8CUpI+p2?=
 =?us-ascii?Q?g/FIxSGH9lqyIsi7hyufbBQSRZ6UABQ5DP3HnjMcZEbQlNfZOkZct5FB+k4R?=
 =?us-ascii?Q?HqqbEy/OZNvdylxyWXUFnzNN9+YKPYbSdUz9dgnjMDkSIiazmoqh6Q2JxUQ6?=
 =?us-ascii?Q?8B67qtCmqXlwDh1El4Ez+HLNO2k71wrul0pL4oT+8JvvyS9RPvHcw7FHfHrD?=
 =?us-ascii?Q?OEBv69rw6P+KS+Q/Pw4vqBTfq6g/gfFiYlN3EqALyMcUKabjER5ocwGfLKcr?=
 =?us-ascii?Q?O8e4xDK6jTo6nY7N3I/s8gO5wZu636ApdSdeqWBEREIea1LlUnI1tGu46xMK?=
 =?us-ascii?Q?cO6P9TEH7pxQGIC6xqJE0pZv94RofOA3ZZA6V9C82GlS7zrLfNkKnr6pE+U1?=
 =?us-ascii?Q?vguEqwEDkg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b30c96-7456-480d-f326-08da3d8af641
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 13:40:27.2019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2HeNLakLPECsdlblTeVN8rIGSBfMp6TEetODNapJpuNCBjx0/gpHDmpoB/0UkO4woBa2hrXfisj8P4DKP2x9JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5475
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
> dev_kfree_skb check if the input parameter NULL and do the right thing,
> there is no need to check again.
> This change is to cleanup the code a bit.
>=20
> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
