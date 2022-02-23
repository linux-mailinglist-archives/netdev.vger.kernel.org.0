Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3134C064C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiBWAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiBWAl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:41:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4885F8F7;
        Tue, 22 Feb 2022 16:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645576861; x=1677112861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c2sCwvplkAMYYEvIJujx0p83KUn6c7kPPcsdq3VVf7Y=;
  b=gJ1KEYyY16AjiksCpi+UrFJa24TNr4/HaI+Gh4Tsj92UGMinnflIiplu
   lNSXqVjnErfT9bcelIOwSdaWaOPnYd63OvxX9bJ0admXuhcOvDfFKDD/G
   ZrGz2Y8/j0yMtvSpOX7uSPPCgzoJGvQDtLe5ZlYGQnUfAt9rwJswtq+Be
   7iOeHB9W8Ey4VjwfmgBJ+NMEAnTdlZPm8C27NoEofkYWyBirt+NmgOusA
   u37alv4r5k9rSWl776lzRQcgLi8PViSWnaDLocBF5sHdXEWj4ToManU9T
   csaL1C5diPj7XZwGwMmwznGnG7U4/Jk9jKUntU9MnkKPazSjpMVKQIrgs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231824474"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231824474"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 16:41:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="591514014"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 22 Feb 2022 16:41:01 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 16:41:00 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 16:41:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 16:41:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUM81Js4Ng7Ltx483XfiuVVumomiHUPUNFS0YPcZHQgk9MZAd1+rgWI0L+dMMaVxf47fgmkizywwiTL4VmaqMaAkUVwvZeNdl9ACF+3zWbYdN2vcun6aCeTYMSbPX11pbrIvgaxjCcCRph337bGaL+WzWRdCzz8689jTd2UwP88F2bKHi7dSgewD2znYItF/NplyG4/1D/JrcQn3p5zMXCvFKyL+DewD3IKEAbqx6LjzldTHcfU3i+ptaHCe0a2uAaLeBhxbLJOD2VW1N1xoP3V0Vc5DkZ8wWJKU/zmEQ2oHc8M18ryFjxBFeEFL+7V66FXFyWAwvKzXuHKrrhVqQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2sCwvplkAMYYEvIJujx0p83KUn6c7kPPcsdq3VVf7Y=;
 b=IbYezLFKykL92QVR83V0E8Ug8KHDyQrOtIij7d9ggT9WWMVyLEJkq3QSZHa7APLqmCNE5dahu7dzB9fTYHrLkEjofuu34+mepeMEBsFrXH/3KxwpIdwjl9rNRY8Q0iGAAOBEHG8ZCE3jQhrR71YP2tXFsUrYZae9te7JCJ0eTRG0oCTaKT2xVupANks2OlKVEo56qKpiZ1YdxEE7JjPBT9mqpa49RKnrqs1un1SPLaJWTIpQYj9d/gyVNbWUiZ2nhOl+Y5tl8hnKyj/t/PeRYS7/IP5nnxAxEYHsBhKH4JDmTTYLsGztVinTy8vPww/sS9oC7uFfTNqTQusQApj5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR1101MB2168.namprd11.prod.outlook.com (2603:10b6:910:18::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 00:40:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 00:40:58 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Topic: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Index: AQHYHEeP9+yi67MoOESanaHY+teTS6yY7QGggAB71QCABXaE4IAA7/8AgACRoKA=
Date:   Wed, 23 Feb 2022 00:40:58 +0000
Message-ID: <BN9PR11MB5276DF4B49F7D57E81675C068C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220218140618.GO4160@nvidia.com>
 <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220222155046.GC10061@nvidia.com>
In-Reply-To: <20220222155046.GC10061@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c03f35e-84ef-4952-64d9-08d9f66528cc
x-ms-traffictypediagnostic: CY4PR1101MB2168:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY4PR1101MB2168B9236F9825B768A7BA918C3C9@CY4PR1101MB2168.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4efUnFf1O83831vxN+WoFVg1pIs+AzEr/3fxko5sxokX23O5Bk63nxg3Ospb+LwjVr046+t6hN1EAU1+ZzgKL5W7MUbk072n/43vqydyJQRrzS+69s4aJ6fIHxoLrNHvUmpGrpAu9WBJVVU7dSWfoSJeMSnq9w/fqWxIaSc4RX5tBXfitTYxZu7eJI2DnJaM87dbwUOP3vCI8Sa4YIK0QX7TCdb/CoxOpaQD1233lCc+4MqNmFy3Dg7r9dk+3IXt0YB2J6Oe6LFyncho/XyQ0Ed9I5WkH+3BwC8c1SXyOxSedVjhVjRVAgZHMPkdKTYyvxE0Bcujx8iSGSlFvMYG0PnS+PGRKpPhWx2gdkODRzvtzhuVH0NXM0EN2C1e2R+LO7Jxd3MuPkmOLj5PJbwXuvee32e5nSfynuWTi6SoedfnNh9168yM7svm6p/W/BXtbR+CQSmhicI4jpxhgfNadWcxcHmn1Su6HzWIrdlUyNcBPdUzwM8h800C3FQ6BreM2HenCqR0NnNpH9zhsFfxnaibhWUlw/ExNJe1IIrC1eed8of5F/RgYSIgGmns/4Ko3+V02L6c5AsM38h30tBhLRnm0FI2PkH4OKRCpSRPaZsAFk0yT202CU6XwB7bbnjIZHXsfuWIaGeIELjtvfcMT9/yORl9Z9r4G9z8jXx7TX6ITNEnWT41WNvYApk//rW5EZeypCI/vBBM925n1OxDew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(6506007)(8936002)(7696005)(52536014)(71200400001)(186003)(26005)(9686003)(38070700005)(82960400001)(38100700002)(316002)(508600001)(66556008)(8676002)(55016003)(66476007)(4326008)(6916009)(66946007)(54906003)(64756008)(66446008)(2906002)(7416002)(5660300002)(33656002)(86362001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E4mgoq8Mua9dE6J95Z+F7yETNf3mJdlD2xmH5Fl/FJzzfNu6LLz+AD9uJyPx?=
 =?us-ascii?Q?YmD6F+4J9WempFMuHSlyv1QuxAGYkgq24mpLq9pjkvacZNwFwn5ZC2CNo4aj?=
 =?us-ascii?Q?EDZks8AZxa4qO1JaekAaeJOYtKpFR4+0BnSG/F0UHkpuSKvVrNILx1+eqfyB?=
 =?us-ascii?Q?3mK7BUt2E4HOSu578vI+M56z9GKaRz/23CnXn2T0yzUn/Kw3t+TWAPlPEkOU?=
 =?us-ascii?Q?DKeNg51ub3foOIM+lqrd6ClvxASRvy7wOcPWBwm86RnZZ8FdxbNcawh1M0bc?=
 =?us-ascii?Q?A34uupql3B1qWx5dMMn1ewn/J66lCn809zUIkVOyiCg4FqkdzGCcMVc4LqYZ?=
 =?us-ascii?Q?7xH357JEStc/FwFzeXLE70dZn4L7dMykcPFQ4ulEGb0TDC5iGCH7qaBnqltv?=
 =?us-ascii?Q?W8oVKEh9TeRJCFbJeZ6kRdoUy9A8JzClkpxOzarFNMe0QW+YrbD2ffk9NWL9?=
 =?us-ascii?Q?sFvH2ttmCF5hSfhz9TLWKNbSnJngai1jSXG4IMPGJFDki2lLIAoFOy5CZOd5?=
 =?us-ascii?Q?5nYeAbDy9zRZdyzsA7dp8xhVI5yEthIMn9BuZSh8woDlZfaLq0oGmlgIh/Ag?=
 =?us-ascii?Q?5Ap0MgSCdT+qkd43VBpwIJeARWpYofy50wqv9PbeMMbxKQ24zwm1TCRugM3m?=
 =?us-ascii?Q?0WQu+1wM52EPyrLrisoP2Cj/oQT3Q1zTtGrlbpH6p/Hhptptr6bVWIM7+ROt?=
 =?us-ascii?Q?0McRetPROuhukE3OsHCECgnJcV1fsGZ/xccZxdQHjl7Gjb7iuifhWpMzwj+y?=
 =?us-ascii?Q?joZOsfCzBjKjV+JcKxMOzkEXVD9FN5bkloiCBlFSipdKybmd60IemxZBIyYw?=
 =?us-ascii?Q?iQ+uxMQjrgtHGWfBgjwCkoa0hDs+kJxM4x5s3Mr3vQVMMm2MB8Xlr/5oZrDZ?=
 =?us-ascii?Q?Ah5IXJ5PgkMmw1fhijk5PgNDSyb80QjbzoRhdhjrTNI0FEc0FByZReZokUht?=
 =?us-ascii?Q?BObc4dDtX6E8JR0y9KpX20apzmXFapqrsLR9xPIX2InDL6pAX7ZPwPCX19pP?=
 =?us-ascii?Q?G+R/ffVKLK4aF97pp3FquXICHTHYTqE6ws/7D5SUzExRuXowdCir495S6ld5?=
 =?us-ascii?Q?Fv94GBZfyaAGvrW8CCcpgQ2h3abK/Wo39nQdSX0r/H4IVPK421iLw1AZdclx?=
 =?us-ascii?Q?z1iJtk9LD/GItQszG7eIyMocm1buuIHFkiL2jGNBSCoZuNgwmoE+L1G9SihZ?=
 =?us-ascii?Q?GgIDZWAydQo0mQfWgE4VtCaQHhnCwk12AyOhN0LuLo6ry+IpkkL0VVcHagxs?=
 =?us-ascii?Q?sb06CWOjhbl3HyURdCkqMvoxRL1KYAeN1w8grUbRhoPGmGs3kTMvqersToh1?=
 =?us-ascii?Q?IGt1TwUgT5DPE/xf+07tXyPssGPNyOC2GwN4ahRcO9y2ycIGGKwjlFYV5WRr?=
 =?us-ascii?Q?TXRdNp4g6Y+9wxowih1gNazjTOXXTjK92F9futu8wiky2WKhEaQuqy1FZnbI?=
 =?us-ascii?Q?N3GRg3Qwuu3gxGNayxVSqVYVJdATbLd7sQZFwz+6ByXACf2GS+SZSfKXZak6?=
 =?us-ascii?Q?V97KB8T9oJhNOgnv6bm75ZiRsPyvaKxiuM53cmaBNyFLb0YlLAISZzdeLARb?=
 =?us-ascii?Q?7U3fNe5n25xPehB8ISlP7jLoi8mXH8TIq1xJyIgE35NJQLOYKBgDshUx13UP?=
 =?us-ascii?Q?DaPGXVZ/bLR2Pe4PMpIudHU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c03f35e-84ef-4952-64d9-08d9f66528cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 00:40:58.5312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5r6M8+uzl+00KKmF2TtrO+WCD8j2zTrEAxOc0qgf5KdWxGIT2rPZBV0qIMmFE+jOlIhS6MA8WvbRSS3Pip7Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2168
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 22, 2022 11:51 PM
>=20
> On Tue, Feb 22, 2022 at 01:43:13AM +0000, Tian, Kevin wrote:
>=20
> > > > > + * Drivers should attempt to return estimates so that initial_by=
tes +
> > > > > + * dirty_bytes matches the amount of data an immediate transitio=
n
> to
> > > > > STOP_COPY
> > > > > + * will require to be streamed.
> > > >
> > > > I didn't understand this requirement. In an immediate transition to
> > > > STOP_COPY I expect the amount of data covers the entire device
> > > > state, i.e. initial_bytes. dirty_bytes are dynamic and iteratively =
returned
> > > > then why we need set some expectation on the sum of
> > > > initial+round1_dity+round2_dirty+...
> > >
> > > "will require to be streamed" means additional data from this point
> > > forward, not including anything already sent.
> > >
> > > It turns into the estimate of how long STOP_COPY will take.
> >
> > I still didn't get the 'match' part. Why should the amount of data whic=
h
> > has already been sent match the additional data to be sent in STOP_COPY=
?
>=20
> None of it is 'already been sent' the return values are always 'still
> to be sent'
>=20

Reread the description:

+ * Drivers should attempt to return estimates so that initial_bytes +
+ * dirty_bytes matches the amount of data an immediate transition to STOP_=
COPY
+ * will require to be streamed.

I guess you intended to mean that when EITHER initial_bytes OR
dirty_bytes is read the returned value should match the amount=20
of data as described above. It is "+" which confused me to think=20
it as a sum of both numbers...

Thanks
Kevin
