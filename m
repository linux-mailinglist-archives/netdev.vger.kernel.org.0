Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188164C0789
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiBWCCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiBWCCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:02:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C526764B;
        Tue, 22 Feb 2022 18:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645581731; x=1677117731;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1UB+DROUaJ6I2nQzmZoH5x5C6fokFo9tJId2bqlBBdQ=;
  b=dtnGfoGw0W2I8MvZtpM+3Lj1xqadqObnGFOjuU4y/tECYBfiOgoUhe62
   x0L9tjwUtVcpmQMoldh891H2ymMlFs2HSrZiHgCU40SaRzUVcLknNTZL0
   bbcSgL5AGkabdM2MbwXFe4b0wpPOk2HNUC8MBdiSqYZEDFFpdb0ocgAZV
   ZaISPP6I4TZsibqAPknKTSu0H9umTmwutW/NRAmBx6rAZTOEBvHq19qi+
   zuQsrNcfkvt+aUdS3gxGDsyNi0dmuOF4qGco2FQSgxVBBMjYtYU4oRdH8
   bSX1pQa0RzrPyfVIiM0sBfgGYGCEMUYdi8vz1gzevC43Bhojkz2zeZx4K
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="239251512"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="239251512"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 18:02:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="505749916"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 22 Feb 2022 18:02:10 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 18:02:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 18:02:09 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 18:02:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic+8JESIWCbkk3ejoRRWY40AlqKPo+rL8/u8DxWWhw4bwlJ2jDyKs3z/nkOYflIPmsOq6YBT7Y3gC2GLAWQ+tuE29/79Us2Mm3oDv3dgOhOG4WJawvtFr00DHKSbYWe052Yz2B3gHYi09GmOqfpTuY9KJO1w8t82hHANYRSOmFzk6MUgxVaOfZ0N1VmL30wyVI1BsnWhWtdlof02EYNtYCS8qIcdLGOS8GLI0EeTS8AmSc+vCoquasZQiJBw//ShawIqZon+sUk2HLrrlZglY86KYu2fj/EwXUM7wYP7o1/pd3tlt99sN7aO8cT2ZmpAKNmxJMGr0fST+/7ngW4YnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jAU2fR5hrwXYeYbH16XFRXaSiZYiipiBHCp5WeayVQ8=;
 b=S554Vwg0qm1laNNrGi59hFtYC+8MPE2LSBZBpWZdcEZYJnh1OM/ijlewjS5WqXWAe4V0a542CRyphqDhnK1P/bNmVgk9RZhQzvEabUyL8mVz+lX+z/DSo1ZqJgneNbZBPmABZ09Wb8rwxxZdzDW7e7MemYlbFMPIxvULpnNayRGivyriVn8AfW4oby16yOgjpbUXRYtjxWPOIPPk13Zookh3inx1M9KF25rzMKz3gHFsrHvACZYStP4VG2j2OYX157+caQRRTYpP7lrI4pOy0Eo2SUoCaQJoR1nIpKiISzhDsZ4fr0hTyMb87o8L2mX4g2jl61D0YPURO0UQOeHrAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 23 Feb
 2022 02:02:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 02:02:07 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
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
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V8 mlx5-next 09/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYJkCH07CQB0sr10KjEWYxyXMEIaygQiQAgAAH/QCAAA1nAIAADVSg
Date:   Wed, 23 Feb 2022 02:02:07 +0000
Message-ID: <BN9PR11MB527618B02E6BAF6EF03D2E0C8C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
        <20220220095716.153757-10-yishaih@nvidia.com>
        <20220222165300.4a8dd044.alex.williamson@redhat.com>
        <20220223002136.GG10061@nvidia.com>
 <20220222180934.72400d6a.alex.williamson@redhat.com>
In-Reply-To: <20220222180934.72400d6a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5668bdfb-e9d4-4072-94ee-08d9f6707efe
x-ms-traffictypediagnostic: PH7PR11MB5943:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH7PR11MB5943DB57BC29E715823C034A8C3C9@PH7PR11MB5943.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sFXpuoExVngB2txRcH7xhdc8vm9OfzcyP+pzuPzqIz/sxOoAM3yMt/bJ39r+PKJZMCGW5U8NX7bN4UB3Jopfm+qV5TQNRojqj75h5CWSdAPvDCnaQdQrjaAbWJ0ZaK3gy70pZT4UFTaKUwjM7bdBxd/yBrwo8c6qNw2OxSQPGOJ/IEKnCIjEKaY5JPyMS85fKrZI8Z27YnS86ypQao44jyNOMJbjS0L0OBbyW+6Y68uUYN4WfCUA0XBF9zzxGFppVI64j0ZBQ0QfCguuAYRZ9ZuOY8L21EqECP6X+XOGs0dQSOTByf/KU8gnVxtTcQgSzwzkoYzNLlEWvKfV9adJzYstPw98YOCEzpcl16N2VoayY7GltAuRgqFUMFQQ3RASO67+KWWleEcekbCE7+WZHu5NmXyfq3bCM42wBezMkrE6nnzCzGiaj6NTGm4pdbgx4ZIUSGSUjaQcqBrDfOsL2m0KR3FJJIDLR1aBVs4ZNx2zKYBAFW1J0iUmgg28gFxnreUr6CZTSjpoP0hR1n/JNd6HiNzxU3I9A+icZL/HpnhD1/dePb23jQgFkfNgEMS0VxLQqTd7wKkW8GHDwS6mj1O9+0u/8KUhSupYMBSSXG4R0v9mAqyA7OFU0K9uLLkK/7ew6GdN65tlhOT4k/4/939IxgUGgLQaWS8mijpawSlchNiA4i6TJiUfySr38tF5FRHE5Sz/MnK/Ey0TwkfmIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(82960400001)(52536014)(38100700002)(110136005)(66446008)(38070700005)(508600001)(71200400001)(316002)(6506007)(5660300002)(54906003)(8936002)(4326008)(8676002)(9686003)(66556008)(86362001)(64756008)(76116006)(66946007)(122000001)(66476007)(55016003)(2906002)(7696005)(83380400001)(33656002)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2pAf5iHBhfXgq7TOFQ+u66ZY2MyQwjzXStyn8mleVQMjK1K5OGus3aYkUOTW?=
 =?us-ascii?Q?dTS+c/TfNxWlMJKC/6OmyXjvujW96vayk8m5PW5B3pcKoUPpe8QgKZL/4x8E?=
 =?us-ascii?Q?EYj+ijBS3wrAemddC1KJbLqScojfRGLLm+W0sNrDBAu8SyuJfkd5GgMc5cH7?=
 =?us-ascii?Q?Q1Zr85S1R1WNpynxb8bTF5u7383TG7jjVPaBD7Qn2JzmGEsdaAhsmj+f9u3K?=
 =?us-ascii?Q?nEjr1NJt7nPJks4AkVnRhsZqeUEf5wRrXTORcrMvAXtC8+dn3rk7j6kx+UFC?=
 =?us-ascii?Q?ixkBkdGGl5muFldH77in010z6UYFFCF+dtjj1TXvL8wiIVwUxjD1Y97FTcX9?=
 =?us-ascii?Q?vIAjzWCBP1zkZEniX1hX23/6/b8nBTs7GnJv8XHyooxRQFkB9JCIeHAwU0dF?=
 =?us-ascii?Q?jxH0MAn5HizYsgrGs/gCmMwvFVE9R+/13OpC4acvuUcx6pKMC5S/AD1Wb5dT?=
 =?us-ascii?Q?cOTgeYSQeDY/YuYxfrZvz+u9smRUgeZKAPUWCdjNIfIU7QEr0V2BJIdPEo9Z?=
 =?us-ascii?Q?3b68sJRn0Qz3zqqFf/iAV/CAUNGqsbitHeUs+E3oiE4aDzvDZaqbJbLhF6G6?=
 =?us-ascii?Q?Z60/WsdeOQrpZryvZ+PdK/FZ2kRY2KbzHq2MsIgzllsvHFhg9jDbqxc+HKAv?=
 =?us-ascii?Q?YsH4iE+GUpGGb7HutpKpEVhY1QC27j6BsgyIu9YlbssLslF8ed2zAVNf/y1g?=
 =?us-ascii?Q?X5tF3zMyP8JEPOJ/5AY7tnyXtFGEig7VZLUC5YN5allEGQmy626KA2YC84HA?=
 =?us-ascii?Q?QpJVbY+VyfLOTffmKIVjHzDsXPI21xJRRD0Y2LU+gCYIUhkBG0nhcfvMdCru?=
 =?us-ascii?Q?hl/IZcwEpk9RFPSITMM6ozEfrx7rGe8OaTggoyZ5Vg789EFOTalFeXAndytl?=
 =?us-ascii?Q?9OH3f7H38A6v2X/DwA0Ky1iqJgkAent/hfSlwvvDlP4itsNWuUR9j7yYHpu+?=
 =?us-ascii?Q?GtMKCKJwZRTOzb2wN2odYh4/j2jiNPefGEn5m6FS6v8ZWo9E823s3nixU17C?=
 =?us-ascii?Q?wVFbYPD9rn5HMLJaDtnTY+kqxLZaL+21CIhqSFaZO9YGFSz+Q6Rd2d+4XeZa?=
 =?us-ascii?Q?6If34j5g9peoEwRhXk581syLZ/S7ylUR/r9MjOGw4mcHLd/tUk+E8V2r13+g?=
 =?us-ascii?Q?hHzLyg0F8zuJgIF5igMCYHyoeevuEbKphyV3TxYCZ51MHi6DaNBnuDzTyowL?=
 =?us-ascii?Q?RTTfWHuq1psdYYp8J4DI5ponGqe6TtwIz2yVY4k6KMXhHIuHr/K1y9fjaytx?=
 =?us-ascii?Q?U2rlFmbzmrm+y2u9LsacaBkylkG7YCp8KpI+iUG/1Km0TFCY6PQtU1H5Rpt0?=
 =?us-ascii?Q?aMaXG81e20XzoiqpxoXbDYAqe7jXDg23Oh8qpos7GMXNO0wFLIxp0MBoAid2?=
 =?us-ascii?Q?lMYRQTpTrGN9CJLs1l5ikRXAYJknJZGZVkHVymDOZriJR5C8CT36pX46PFGh?=
 =?us-ascii?Q?d/51NslI1R9ZgpVIlp8eHpu1fkW7Pd6GKAw8wkB4UVY8E5xZMWODhvDxipF6?=
 =?us-ascii?Q?Y6OATXLmu8w2PgmDPs05UMqef/lrME9ZNABrpAyWzp3Iaej7WjZVJoh+RfZu?=
 =?us-ascii?Q?0CZFoXFF2Ky8wzC/5O87TWiClfeG6f1sg4EV0dFlA1a/H5vpf2R8YosU769R?=
 =?us-ascii?Q?FjIZC9EkOWfvPmJfbsziQ24=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5668bdfb-e9d4-4072-94ee-08d9f6707efe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 02:02:07.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pZMZCIiABZ8WJyuIys7wTsF1ZSWNDgByTWSIMA0Krq9W8obyNqGEThz1jIHC2hO/aR/6XVXx3MxEG/oZY/TszQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, February 23, 2022 9:10 AM
> > > > + * The kernel migration driver must fully transition the device to=
 the
> new state
> > > > + * value before the operation returns to the user.
> > >
> > > The above statement certainly doesn't preclude asynchronous
> > > availability of data on the stream FD, but it does demand that the
> > > device state transition itself is synchronous and can cannot be
> > > shortcut.  If the state transition itself exceeds migration SLAs, we'=
re
> > > in a pickle.  Thanks,
> >
> > Even if the commands were async, it is not easy to believe a device
> > can instantaneously abort an arc when a timer hits and return to full
> > operation. For instance, mlx5 can't do this.
> >
> > The vCPU cannot be restarted to try to meet the SLA until a command
> > going back to RUNNING returns.
> >
> > If we want to have a SLA feature it feels better to pass in the
> > deadline time as part of the set state ioctl and the driver can then
> > internally do something appropriate and not have to figure out how to
> > juggle an external abort. The driver would be expected to return fully
> > completed from STOP or return back to RUNNING before the deadline.
> >
> > For instance mlx5 could possibly implement this by checking the
> > migration size and doing some maths before deciding if it should
> > commit to its unabortable device command.
> >
> > I have a feeling supporting SLA means devices are going to have to
> > report latencies for various arcs and work in a more classical
> > realtime deadline oriented way overall. Estimating the transfer
> > latency and size is another factor too.
> >
> > Overall, this SLA topic looks quite big to me, and I think a full
> > solution will come with many facets. We are also quite interested in
> > dirty rate limiting, for instance.
>=20
> So if/when we were to support this, we might use a different SET_STATE
> feature ioctl that allows the user to specify a deadline and we'd use
> feature probing or a flag on the migration feature for userspace to
> discover this?  I'd be ok with that, I just want to make sure we have
> agreeable options to support it.  Thanks,
>=20

Or use a different device_feature ioctl to allow setting deadline=20
for different arcs before changing device state and then reuse
existing SET_STATE semantics with the migration driver doing
estimation underlyingly based on pre-configured constraints...

Thanks
Kevin
