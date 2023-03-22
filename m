Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787426C4F8F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCVPgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjCVPgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:36:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D16F559EE;
        Wed, 22 Mar 2023 08:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679499393; x=1711035393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZViBQTxDtJEBY1C/HDTe8AUluKJpm+iVJhEaMg8fx4o=;
  b=COnbYP8YNtFL0uIadkqVRzHMMvh5xuc4Mnvi8c6E+nK1b5eJZGwz2lwI
   L9evnPOoEA6Qo71KdW94BdMCOtj/7lv87yQFgzpI2YU/fTKPaC/OWAZcM
   cS4e2K71Da92SL7Ta+z6kpFwy3Dz/mjx4+2KYzXJ4j9T8Tf0IXGkKVuCd
   7oWdXHC2LlqJNzIUqfShmlQexvW/snVwWtHUeG5S/0P5XJERDN/PFRiN1
   goBiYWQDMgEJRriLMUPJjkFxVQt5htHb7ybmrGYGMdixopZGzqzqhktD2
   pRkk04SJvzmHgy/5uJXkzQn4zb8P71IGo7p/ntYupEmN1fhhnmXYon0bt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="401816618"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="401816618"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="927876560"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="927876560"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 22 Mar 2023 08:36:31 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 08:36:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 08:36:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 08:36:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTDo/lvSWzMKqDrKpavGp0xZ09yLIOfAetZ4EiF14VZi2aGPmvk7ImMKZiFao2kfFsBM/vaxjimKiUMBtRAXca8lUkb6BXIvQzAk8Co+XrY2Id7mbVPkLIz3/mea53Ftd3zk4ZuBZMG4xkIgIOUr0Agy+FZZaNkkQA8lYXXDAo/d+6BnK6p1VQC/PCEGciTE+W8KMv0xjmYOrlTuyrkHLY2QFbVQU0N4lIIg9sI9tXaMXjB2Td/FjI9f/XRgJfoUeLwSxfUfqk+eQBrUo8EiEcTgVGlfj81L90tmjWqIxROxHU507TcLsj3mG6J4BBtqoiRbh/2bp+9TwTeA0uz5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9k9GTFrxsA6YP9L7R8iawlpFldNEhaVdyLnbaOfc3CI=;
 b=ZSJ9EtIFPA3z4sSEaU9u2UOHRU480hn9bT7h7h1mCbsnp4vdRyLof7dszku+RP5tt4NHZFubjtNo7QO4dYxTz+ApfTyejfnfIXoYrWArRv5jddf1SbbVoTiMyYXOGpeLcHKOHPN7+nPhdcCijw5jz0PZpRiqIAXIGFv+NKMOzCp7686a6n09hUK+TCqYfx833KoaXiUlAmIYSNpo24OdXghqmZcLkSmAVtRNkSaQEKT5gqQW+w/nD8NPrS1P9bZhgd8GGDMR+RYCL56+Bd9VB6VlPt3P9qe0qHoAh9XJrafuLGOD9jVtGF1vqy99t6S5muMZIcwhf2gyOMX3dJNC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by CY8PR11MB7396.namprd11.prod.outlook.com (2603:10b6:930:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:36:26 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:36:25 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        Marco Pagani <marpagan@redhat.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZXMpv4Yo9zQ8HK06ZEDUXfqbNWq8G4UeAgAACPlCAAAHggIAABvNw
Date:   Wed, 22 Mar 2023 15:36:25 +0000
Message-ID: <BN9PR11MB5483F72F40A6DF5BC3000F44E3869@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
 <ZBsVWWe33FJgoj9A@smile.fi.intel.com>
 <BN9PR11MB54839A3B9CBE7BB679FBFE4CE3869@BN9PR11MB5483.namprd11.prod.outlook.com>
 <ZBsYzZgonva5f3fB@smile.fi.intel.com>
In-Reply-To: <ZBsYzZgonva5f3fB@smile.fi.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|CY8PR11MB7396:EE_
x-ms-office365-filtering-correlation-id: 099a8a8a-cbe1-4f6f-86c5-08db2aeb3294
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DKCh3Wn7xqgE7k66j/cEaMHIVJg6V0+raXHXMa9BddYcL4SpfAVU4Rt97Kx/58oRu9CJlKrXhgTdMdpvMlqpjF4olGrkXgShakaNeDVJAS/sWfyH50EYYGz3aBnAqHa/hnITpJb0uHjZY57DOynJ2y8NJqlH13HbDuS4gloLCZbJ8JpG4Ag9JLQb13SbKu6G+kHPwHZ3xHKhWNiyR6rac4aCcb8SQcsyRp0j+O7lu0h606PlrrLB0y4cknVbsSKXSpAJQzP3+Nv1fCLTALu8eiyUx1x+c8MGCG5zLiJByMcq2uRVWe+kM6du71A7Eae900zPw/p8cH1Q5pC6Xn0aZc2Tmu6SOmmVkjoQnaA0oFKlkoc3GFole7onbkKB93o0nEiNoSHqhUCJlXFZ1V2hfli6P8dwVp2mUdZPfsd/reuICoAWpS9PGqOX9OdN3aYwbvUi6+/1CM8h7qJlfyig8GWJehBPbk/HMIrrLuzA9cf2K4ObqXp1Os+LB8R858htY3grrArZI1xjYnt1qLJdwFQ/V86ONA4H32B5lmlx8TGGwzMzCQwH1PVIAwakFljhAbWyp8GmPu69Kye+SYUJ41N4wA2hP4wLsn3zNQ0mRxU7Dlux+rtbUXY56CnwhECiEyJ4W5RlPikv26aA+/7E5wKlhpafogrmd0I8oOgWAxITKWcRMpqInkMeSYuKuVp/p54qkFm3Ygb0tsBjotFjVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199018)(86362001)(122000001)(38100700002)(38070700005)(6916009)(41300700001)(66476007)(64756008)(76116006)(4326008)(66556008)(33656002)(82960400001)(5660300002)(52536014)(8936002)(8676002)(66946007)(66446008)(478600001)(2906002)(186003)(83380400001)(7696005)(71200400001)(316002)(54906003)(9686003)(53546011)(55016003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QuDej3fTOBQ79dbuIlrVcxismAoeVbem2pZQwQoKKCaAgnkQadSePjgkBrb9?=
 =?us-ascii?Q?NHdgFKKfbofQ6W9FvxZBShDu3LdVe7D4expefBygnTIPzAc/zXT0K1j8Mofu?=
 =?us-ascii?Q?Ysx60y/jpSG64KiNI7BsILGYuzuD1x49ROM3xR0aCE3ckvy8/+1l2OwRlzmE?=
 =?us-ascii?Q?MALfQYkMySyP6Y//OpYLcZI1kgWFSF9Bq1SM94WN+NPTOEHfkkcZe45Me5Y9?=
 =?us-ascii?Q?ozOTIf3W2b5J73xL94dnN/3hZeb2wjHwGM6QHTUOwoqoa7wqxdbwXrQjcfes?=
 =?us-ascii?Q?fZwVItHqrbEQhscpH4Cwm+1KFJ3EZwG7GfaRg74weIMxtu64gVHFChPNdpCP?=
 =?us-ascii?Q?U52nFqhq0jYKaj1ym5CEolJ4QwZLtKyu2qRUt+UqjutcmpVcZW53xb0iO43x?=
 =?us-ascii?Q?Af9jLyJvHkxl4cMXX+snKhjYt2dejWDbsOYfEgSbbFfyQbphXsuyTJ8HZzf/?=
 =?us-ascii?Q?w6K352QDctBgXXeubhAgBllpi6wf8rFJ8AtpK9mANz4natoMpyFwyZsOxqkJ?=
 =?us-ascii?Q?0JOW29gSarrbMWKHe6w3aqp3T1EAfSsq1gkmjqyilo+c7Zb+auRzghRUVPnX?=
 =?us-ascii?Q?B3/Mx3vR8ACI0CbUTqado3JY19+DWT72101M5zgMZLjD1dvlK5ayj5dal8Lw?=
 =?us-ascii?Q?tab7jW5EhKHfNx69uCo6sXiX5JhKfkCcWwWymxvzyaafztRg0Z1Lo2W7Tgac?=
 =?us-ascii?Q?iyREodmNFKK9dblVw/iUhVu/8j7lsPwWzkMCOX6KlHVBZ/ll2EcExoc2jShh?=
 =?us-ascii?Q?mOOBVz7iY6DIrQ2/V5Z9w/HcFx2PFSdOd4stu0ukU5K6UNPRddbhxIerEhLA?=
 =?us-ascii?Q?0WRVLk2XAZeRBtxfdVHG+lhYB6IbeKDa1ZqQsNqTeAn/M9t5LbMjqZATYhe0?=
 =?us-ascii?Q?l03DKZbhg+W9eaBUJEE1aZ+BVN6GPWHeY0AP25CoMShnyWt+V2CJTQhwKK2R?=
 =?us-ascii?Q?60aZwVo1sOTMw7Nm1t12ewOdpG5kyyVpKMO4LsQyFfJvGq0+lhcbZUCz6p9U?=
 =?us-ascii?Q?Q7+lECQvAarVstYw+Y0qY2frLf90Pdwcn/pytkmuraA2wYcJY1jG4gLLK2cH?=
 =?us-ascii?Q?+Ezxy/y24TdEGhY/L9Zt6klNTtJkFJFUKlQsjfPiz8mezLY2HMtxc9k+b32s?=
 =?us-ascii?Q?F2T1w1Z5zNaCoCEF++2GyD0xFoBmRsYabfDFhDojJRfoVeqVpame8vMswv+z?=
 =?us-ascii?Q?q9LiM4YkXK7xEMVctQ/M+KFS4rEGVW9a7kKrqWaVF80lae+skPmGFABvIQJW?=
 =?us-ascii?Q?jqGxSiQc7DxhWBw6bKt61ba14HeSbg7zQDC1Jw6valg/4CERMSHF+oSPKg2+?=
 =?us-ascii?Q?kCQbMjXy06eMvANKDZl2WYpd3rLotZ8s8TdtpDJUILPEPilfmk4QrZg6qQ1O?=
 =?us-ascii?Q?lmO7Zv85NculiU0F2SctJFt27h6qqLt3MWJbryihRSjswL2f/e3ehLPAWtOR?=
 =?us-ascii?Q?Af5/3wZf6VvBblO/Xtt3wYsy+8R+BbZcgKdyfRWOO1RJxqY94fWv0+1eMPoa?=
 =?us-ascii?Q?qPIwCOBLUbcMBRH5Toadl7GMqEJSS429EmQqVpA6Lkqyryugg+Sxk4rBeU+T?=
 =?us-ascii?Q?662yi0zYR+BsnWidxyeHEQ0THGZ79jdATUloxQJuI8MGQUY+ZICaxxmPmh75?=
 =?us-ascii?Q?f+cptiUcGGRpLtSwqqPr59Z7kQ45YVUl/f/+3/76wBBI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 099a8a8a-cbe1-4f6f-86c5-08db2aeb3294
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 15:36:25.7176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eLtFr13pDO+7yvGktb0UP2oEhLZJ/coNEqiT6x+0zZWoE4FTZlySd/jKOlR0IQvkRv8HTXsvVvJQmAX/sHAPVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Sent: Wednesday, March 22, 2023 11:04 PM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> fpga@vger.kernel.org; ilpo.jarvinen@linux.intel.com; Gomes, Vinicius
> <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.intel.com; Pagani,=
 Marco
> <marpagan@redhat.com>; Weight, Russell H <russell.h.weight@intel.com>;
> matthew.gerlach@linux.intel.com; nico@fluxnic.net; Khadatare, Raghavendra=
X
> Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Wed, Mar 22, 2023 at 02:59:21PM +0000, Zhang, Tianfei wrote:
> > > -----Original Message-----
> > > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Sent: Wednesday, March 22, 2023 10:49 PM
> > > To: Zhang, Tianfei <tianfei.zhang@intel.com>
> > > Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> > > fpga@vger.kernel.org; ilpo.jarvinen@linux.intel.com; Gomes, Vinicius
> > > <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.intel.com;
> > > Pagani, Marco <marpagan@redhat.com>; Weight, Russell H
> > > <russell.h.weight@intel.com>; matthew.gerlach@linux.intel.com;
> > > nico@fluxnic.net; Khadatare, RaghavendraX Anand
> > > <raghavendrax.anand.khadatare@intel.com>
> > > Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA
> > > cards
> > >
> > > On Wed, Mar 22, 2023 at 10:35:47AM -0400, Tianfei Zhang wrote:
> > > > Adding a DFL (Device Feature List) device driver of ToD device for
> > > > Intel FPGA cards.
> > > >
> > > > The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is
> > > > exposed as PTP Hardware clock(PHC) device to the Linux PTP stack
> > > > to synchronize the system clock to its ToD information using
> > > > phc2sys utility of the Linux PTP stack. The DFL is a hardware List
> > > > within FPGA, which defines a linked list of feature headers within
> > > > the device MMIO space to provide an extensible way of adding subdev=
ice
> features.
>=20
> ...
>=20
> > > > +	dt->ptp_clock =3D ptp_clock_register(&dt->ptp_clock_ops, dev);
> > > > +	if (IS_ERR_OR_NULL(dt->ptp_clock))
> > > > +		return dev_err_probe(dt->dev, PTR_ERR_OR_ZERO(dt->ptp_clock),
> > > > +				     "Unable to register PTP clock\n");
> > > > +
> > > > +	return 0;
> > >
> > > Can be as simple as:
> > >
> > > 	ret =3D PTR_ERR_OR_ZERO(dt->ptp_clock);
> > > 	return dev_err_probe(dt->dev, ret, "Unable to register PTP
> > > clock\n");
> >
> >             This should be :
> >            ret =3D PTR_ERR_OR_ZERO(dt->ptp_clock);
> >            if (ret)
> >                     return dev_err_probe(dt->dev, ret, "Unable to regis=
ter PTP clock\n");
> >            return 0;
>=20
> It depends how you treat the NULL from ptp_clock_register() and why drive=
r will be
> still bound to the device even if it doesn't provide PTP facility.

For this ToD DFL driver, it depends on CONFIG_PTP_1588_CLOCK, I will add th=
is dependency in Kconfig file later as Ilpo pointed out.
It will not occurred the NULL case for ptp_clock_register() in this driver,=
 so it only handle the error case is enough.=20

=20

