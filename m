Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3911580C22
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiGZHHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiGZHHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:07:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1256A27CFA;
        Tue, 26 Jul 2022 00:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658819264; x=1690355264;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=toACzTNmn+CddaESfJVa2QtXUfrXmPpwwXDFYKH7wQU=;
  b=nT2Xiqpvxz9VIy+YiOBkuNpUiYo3wY3dvOTqgFTaGjEdphFAVWCkLYEv
   FbZZDRx/38VixOzR1YaxVNgx736CIlVHTHwsufwukG3vxs7WECzgw5RQA
   zAVKV3xsAr/6UZIrBzu9G3sPOWNPpqC2Mm5w6mgtI5Wzxhmh5BVwf9vwd
   eG0bd10FpdSycV/sDtSD1NG19k8jM9RcC3RnnIobgdAOzkFoh0K3ZLZzu
   qPOKblFQP4xZQpr8sc21n7WHHADh/LJoLbLZD6Nr2+kEA7PkI5FMqd1or
   BOJvogFm1Kw7bmdybWGJ61llVlC3XbrzPkzWRiEV1Oj2kJ2hEyjW7N55H
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274748220"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274748220"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 00:07:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="627780372"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 26 Jul 2022 00:07:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 00:07:40 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 00:07:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 00:07:39 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 00:07:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5AMnBSMJVJ7f7j28Ytlcl3nNqcbxxdKo/QUvx2iq6r8WOL9f1vfeJSi9rh9XaoxiPEpWSysewsdVZjeTTEyZnuokhpP7U7tWpKgBYuZdOE6JDUAQtzkAiqDHaisIDn8KvAykGLjRWqwradlHYozpSQlT7KQgMTSvDofnH2XN+FTqON/Yd0+wCtWfXTxdyLbTm4Xs+gQFPM7qiJcIV49kPeyiRuv3Ege8BFn3MPM2a6ZZMJNBzn3AdyWwhcuPF5I5RBLiaMpVmfREsLjtlKz40RQcdHCG8IryFRjzX7SCGx11EoOx8Algljq7o4U2Yb9yUXlmjjcg9kKraLTfxOYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DU9uKovsCxcMVo3E2Z/52kQ0vDA5VBE5iYbbGbyXS0U=;
 b=TPYAFjFW9srVgs5LPOx8bwM3fROZnE7DZ+fgY5JqOY9L5Jeax3UfNVHrsyQQUGu+vpYgloSVp1dkYc62qo2w3sZtoNCzDZjzjbM03u5q3d58aPXphbp9Ufh4D1STSa0kkGjhwBVl1HhK7ta8M7kNhk/4WuAEVZ6JhR7YxrpKdhDgXkXk2JtF0ghmoth4fZUzN6UgRdNmFBEzBpf2rtAfYz2X57B8IT5TLbrt0ZScHEg5Fy3vlydM1W/76/NzveekGkzASi38AXyUvKszbZHM2l37jEYudJxfynZaqJgLZxJwnQzz2bq4qqPJj1Biv6QzaLwjjGDf3ibYa5RwBkyYhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB2745.namprd11.prod.outlook.com (2603:10b6:5:c7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 07:07:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 07:07:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Topic: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNggAA8ogCABfYnUIAAfHWAgAEVj1A=
Date:   Tue, 26 Jul 2022 07:07:37 +0000
Message-ID: <BN9PR11MB5276A9E38ED63B5EEB572B8D8C949@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721120518.GZ4609@nvidia.com>
 <BN9PR11MB52767FB07E8C4F3C3059A1658C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220725143303.GC3747@nvidia.com>
In-Reply-To: <20220725143303.GC3747@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9254938-882c-4ab7-75d5-08da6ed585b4
x-ms-traffictypediagnostic: DM6PR11MB2745:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W+hNLwvInZoO/lLXQ18a4u5Fx2pHdoTXj81qTkUb3HcxQGVqazeg85mHxVSw5JLNZA7jXe56iDt/FF+Eo2XbwLrC3cZSL+qHHkwcmnmWYUs/vW4hwyv0s2rf72GOSUS7K1+/7Yj/Zmz6TRJmMcwszY7evXiul4efcdhw7jse2LoLIkMjo8x6OvSo3xpp8pCQUEUjrJLcoHGSFZtfpWHDNOdnu9YgVsscoOeigV5PT9ltCAVgRby2Mabv9TT22GHJXz3QDup9JmVDk0tjCZKd4Yzt4Scx41vjujxPGSWW/gitCGHWxwNZrR9WFZCy9UydgLBCGPcTC02S1/K3XA9TdpfdnNMdmSKBkWoHBpnq9QRPFI0iuaz5bDfvJ5Hmfu6k8HMHbsN9buPW8zr3g62sgRFQKJJZLS2WWLxIautBal4hHXbEA5pS1MS4rZXL/H7ZKnvuiIccMo94hsmWiZsxlSw2oL/3OgZ0KamTqKYYs+afONX0GuUNoh3PTYpqR+Z/fvpUlgdA5z51SnrrJtxTv3JIkbqLORz0fIpu3xFSfPayjqFag/pzWmF9uWKGH5T+pgwLKn+hMCuH3K+BlkaVu5Uas1VrWC4px6KqEGq8zrFEQVKULOxHOnUNkfjKvasC2w9zbLlPiCLyCI0ZzG6y6Z8yVJOTWQndjRTQwiyXJqF8ka1QB/Mx2vtOkqSLJIOu+bd+KPCGKf5yLJF+Hpp56bqrdlc1Jy5vp3jdpW8AqDV+8RmF7cD9cxER6hbg1JOb82L3QPtBEM0H0TbTsUskSQr3ayu07J3lZetENS6oWuKSlIPhZzkejgAzNTuNPNP6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(136003)(366004)(39860400002)(82960400001)(33656002)(122000001)(38070700005)(8936002)(52536014)(38100700002)(83380400001)(86362001)(26005)(186003)(9686003)(6506007)(7696005)(71200400001)(478600001)(316002)(54906003)(6916009)(41300700001)(66446008)(66946007)(76116006)(66476007)(4326008)(66556008)(8676002)(7416002)(64756008)(5660300002)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8po3wplsdlHarCmSAv6EDb6/+uP55n2NRynFg1mqjs1fbkKzH2bl7mfKkOgn?=
 =?us-ascii?Q?uMBQGM79n2JSqBxQLxU8WFXmw4Pdxuzw88jh36JmXEb+Yt0uivUjt4ohgxky?=
 =?us-ascii?Q?3/x03HW3HRV7dzORGnX2wykk8oO0B5b7fjKmXeYFxZAWyNtaBauUkJHIcUaf?=
 =?us-ascii?Q?Cc/ZqGw0p+a+AssWHXTLxzDsCjwkrwR4JSMMEQ2lDUynw17YXHJbefE/ZikT?=
 =?us-ascii?Q?p6mDu18T1Vjp7IHiNnX6UNgmCy8Ck+MpZYi8axeCemmoA4Xwitwcc001Hxku?=
 =?us-ascii?Q?zU19vLwXr6ZCRouKRLxR/doEUVN0/26tBZkX6KQk+0L+Dojwa669vIEOLVqL?=
 =?us-ascii?Q?ShJDqCEcuord/+ZdKbXUTc+apFxjPpyMsMYdIaLWOdyFQMpH65j8KzopAokY?=
 =?us-ascii?Q?iQGAa6LeYcIxpQ8BH+EW0NtLqj2uHiWN6ETttjLXPBDVDio/NV+IWcA0wosI?=
 =?us-ascii?Q?Uygt1oSQe6ZqR63MLt4k3DdhEcgg9LmqS5p2ug9TjM2h29XCIKpmyqEQG11D?=
 =?us-ascii?Q?dOOiYSVkIGXgNtzxXeg6q7W5d4IrQuj1gq9FrPKT039hAe+a+z34V/XkguGY?=
 =?us-ascii?Q?KOlijJ4ANvmduFCNbvlfJvp30ScfHENrHks6POAa6i2zfyE54Yz3mZto88J9?=
 =?us-ascii?Q?MurLccJNPApT0VvdDDFt83YZ6J6P3HyjJ90crrt+ghHr921Z6S4XADikjSCW?=
 =?us-ascii?Q?uCwVw9rSuT+E61P/ze22vppS2zITKZG8jAunI3hoXZpa3FKH8ltz+sYSFgxp?=
 =?us-ascii?Q?0enalpqe/dSJi4Qcdl3yRmYxJ9yUuNaRazscoyN+8O8Y/8EmBdg22iQIQ1bv?=
 =?us-ascii?Q?MFizv4c/bJfu+Tj9f5yE96kvjIinu4Y0fmpqbfVj3jvIbZ+CdzRG6O/Z5AcR?=
 =?us-ascii?Q?GrGQ0Ei2qbi1VIYlFdd+Nk6fDqlL0oDXoLY8G3CdEPAKHMkdNVaOIYbCWNp3?=
 =?us-ascii?Q?Un2PnvDqfHatqukKPnBwnTjJsDlt/vKsPdggbaP0SZr41JK5sixG7cHKxs+/?=
 =?us-ascii?Q?oGADB+nwFqbQjSD9jItpoHYmrnExrz9B9C1dXPGRhxN5kbvxtw2Ri7MLQ/Jm?=
 =?us-ascii?Q?9t1Tq7M/LwKvfqV4Or25MlLedwEBIi5FGvoXRF7iYU6m1sFyHizNfAKc/kqZ?=
 =?us-ascii?Q?ovgy7vTdiBnx1YsKuoI/ZnXA67ODFaC7mIWqPUbfqraDew8milI+JswU9lei?=
 =?us-ascii?Q?d/LAgvGq8cIo4f2SYMt+EOW1nv7bkCKO3IVHhb6M4zeGAhToWioR4OS8bsM7?=
 =?us-ascii?Q?wl4FTVS4JvRHW6UfYEtqbT/l1NGWFBkaJ/Sxt/gOqnmNsDBU79b0+0noZ8p7?=
 =?us-ascii?Q?gY++cvhy6Ptc6SyDKMxuP+OIeXWoRuiSVqRISbgYQj+PsdeDLcEm1MD47BXl?=
 =?us-ascii?Q?paVmD4StKEWIecI26o4nPCbYiI0VFSaLPAAt36enyKLri6A118k8GU9fqpq5?=
 =?us-ascii?Q?xeow+PohC6zfALbiAV+rO2Dd8R1s/HImPOz77w5AafaFGt3dR4yV/QSjeeYJ?=
 =?us-ascii?Q?g7xENbMI1IMviaRDWqpunW5Scq50j2KYXIRPQIgGoZAmFat3ynvmc4P6piUE?=
 =?us-ascii?Q?zj/rv/Uvfqa8T/AnqtCkASLW9ayYPu5B+hDeYsSH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9254938-882c-4ab7-75d5-08da6ed585b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 07:07:37.6476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71qjah3YP+O9D82axZWkEtGWt3eaGgFNxXaKmUXuqBazOKvOTyFaylUELwsDHM8berNvPEFL47wi1BrnOM6/sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2745
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, July 25, 2022 10:33 PM
>=20
> On Mon, Jul 25, 2022 at 07:20:16AM +0000, Tian, Kevin wrote:
>=20
> > I got that point. But my question is slightly different.
> >
> > A practical flow would like below:
> >
> > 1) Qemu first requests to start dirty tracking in 4KB page size.
> >    Underlying trackers may start tracking in 4KB, 256KB, 2MB,
> >    etc. based on their own constraints.
> >
> > 2) Qemu then reads back dirty reports in a shared bitmap in
> >    4KB page size. All trackers must update dirty bitmap in 4KB
> >    granular regardless of the actual size each tracker selects.
> >
> > Is there a real usage where Qemu would want to attempt
> > different page sizes between above two steps?
>=20
> If you multi-thread the tracker reads it will be efficient to populate
> a single bitmap and then copy that single bitmapt to the dirty
> transfer. In this case you want the page size conversion.
>=20
> If qemu is just going to read sequentially then perhaps it doesn't.
>=20
> But forcing a fixed page size just denies userspace this choice, and
> it doesn't make the kernel any simpler because the kernel always must
> have this code to adapt different page sizes to support the real iommu
> with huge pages/etc.
>=20

OK, make sense.
