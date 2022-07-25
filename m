Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D313257FA0F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiGYHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiGYHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:20:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937C63880;
        Mon, 25 Jul 2022 00:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658733620; x=1690269620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=COomx8LJ36kJEDEwMA6aW/uur56j6cNdJDCWQQB46GI=;
  b=S8zt2zsGktfnPGZ/wnhm7F4cuXUU/+cRtFYAcqXep+aoJwiMRsPdK5LE
   v1yhWDJrvkQ8xE/M8W/Y1uYUhjvy9GVqhISTUoUXque2KX1+q8/XgCfq5
   qq6y7nCdHAL/MmgygivkLYvJ64vhKUHExpSfxT7cD+40VlG7GURC2X4hz
   tjuy3wUQDCC9zZZ3P0cYjVbxYFaQwoJTjbBR/3wUU1mgEtHaHv/52Fcey
   onfHO6RSv1lDnpEgSyzboLSar0EHeugcFMGvej9jopVFvyjgBF2g2enU4
   gwkEXONEcMj1uV+9NyhD4kvm/31Gez+eWqW/N0XxiXlRT/ee6/7iZaH+E
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="288390639"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="288390639"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 00:20:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="574938084"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 25 Jul 2022 00:20:20 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:20:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:20:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 00:20:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 00:20:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Armrt8HFDeq927nMPt16rHhOZEQJ4Rx3ZeYNsnWZ2nnvG1D4pxuoHsP6qSu31wKZpfudsPGa+iYn7vjVakSJG0Rj0gZAvbLvhUnoIFBy32c0wa9ArAWr5dgtsWU2kEiIllp/cyQY/HJWUasxPmvSfU7XoI7W9VxWeKWcNRCxUCcMOE1v+Qgtbu8EtgxyKwpAj//uwr4vb3dx3tj0FmIOzmLIAQf9PUEVWYhatFh+zw4lbHkSBpnvZLmL5Mh5UtByoaZlRcqc0OfxnTxPTMykNUMTXa4FtGxoejGjr78YJJbkMjzlIU8BMuV+CvnDIU1cK62FgY6JDxUxzX61fRTm0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYYvfatZ0ETCgxc0FTbjXSDdQom2jsHBa2b2vxjKGdI=;
 b=dzZSvf/VgXRkD5omZdoNNYo6d9cwC69cBdu/6n3Mes6ph/1cvsKwxmHMU653qMBuH68iYL408cODhsVms+C58W6i+ivhqeXeWcZx/f2O6PjlxO8mYx8pltq0N3Q4HroyDnDpwcBizmgoareBaEVKRn+kbRmoiT9Go68lvdaTPhDqmJC4aoIa4+NKX5nZZIR/4qqNDmZUn7ikYH9IjU/G3WuLWFcyPIo8QOI543O0UwKJ94fap8QuXNJTEmK7WagzW611tqIb7GWxgXOpNq7Gz9XNMjgCwq6A91G5NSgDEvvCQTruwtN6Bxn8LzJtzMwqvO4HuKFvaUuvWJm0OYG4Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4489.namprd11.prod.outlook.com (2603:10b6:5:203::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Mon, 25 Jul
 2022 07:20:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 07:20:16 +0000
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
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNggAA8ogCABfYnUA==
Date:   Mon, 25 Jul 2022 07:20:16 +0000
Message-ID: <BN9PR11MB52767FB07E8C4F3C3059A1658C959@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721120518.GZ4609@nvidia.com>
In-Reply-To: <20220721120518.GZ4609@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eec2119d-dba1-43f1-9c09-08da6e0e1f6f
x-ms-traffictypediagnostic: DM6PR11MB4489:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +l5LvF6v0i7RiSAuHqZzLKX3LMJ//Ce/wGRhyOqyFozvEpp2MzPIvo/YvrHaC34nz8rnmIvR8HmJzMCRw49t8ZaR38JzgFvEU6Fm3T3pNWvyHX6hNcmtnoy+ot4/2m5pOMV+EybOp/OPkzMUHdzbIa+cfkk3lgMM6Fho7KJMFeAsWMWXRopXriKbvohNCXDT7yMnANl09yWTLKhKGoeQJvBiJDWtuST1eRnmv1kfePEsKhvC5z6sfgvNLsm5V7A3vJDGdH+zk8Khe1fwAqaLtYuElwQOnkr4S74747TS5NAfJ8TO6BQ2yeZG8rwhF4FpZcTpzoz+srrfVIFTclxuHExubjo78QrqIorae0YCLYm9bhyHdvB0orMEIjuJah7kM1IUUMJIvypymJN9kCFyAE0BjVq5un1NPoTWhHLEqa600WU8/gQ2wF2c01z6oVhzqtpPRKsjCwEWOPov5z7ml0C3PeT73X9BDurt3bFoceHJAvtEvdHi3qVRlhTHBqpx3GLriIA+F04oF91Y8l+4oulFtLzNEnM9kqLF40yqJnaIb7HtLDZXSahyyMuwSyXNpvmqfeVIm5Lj6YrXVoJYaXc/SCdrbkz8jWLBQM2PT70zFJctSF0qQgFhu669QkArcKjX9bo/1w1uMmddqZOu6jNxuLekhIN7x6H2T2WX9BApOpodwkNBuxT7Ec+90crENTEJn47BUuyIwirB+x72ZSDbmvrcnWeWlYyU/Q9rhvQ80KeJwjmQSwlxA4udWkB9V29aRwI0x56H6KdgDynauJvRgWnrOD8MrBSZonOx6dpCebrg2np6WIuoMLb9Bzi/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(346002)(136003)(376002)(83380400001)(82960400001)(38070700005)(122000001)(38100700002)(66946007)(33656002)(76116006)(6916009)(54906003)(316002)(66556008)(66476007)(66446008)(8936002)(5660300002)(8676002)(4326008)(64756008)(9686003)(26005)(7696005)(6506007)(186003)(71200400001)(41300700001)(2906002)(478600001)(86362001)(55016003)(52536014)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u808NqKFDXRU8NI8cuvKjAippMn/nneBhucqUJlBdWcECm3pqt2vCRsIRLky?=
 =?us-ascii?Q?iiajQrDMBMBDk6eLhazWn6fSWurBUxPgUKGOaOibP6owQcJmKCH1Cygm7FYA?=
 =?us-ascii?Q?skVUH8oH9kySM1zokmBTX+J8QME7Qov84AWl6p570OB85P1Yk6SYMefIA4gP?=
 =?us-ascii?Q?bMQqGfpPKvzJvDcnN7dPFvMJ588fXWsO/TSutjNJ8v5wunbvIKjFtbl5D0IO?=
 =?us-ascii?Q?kSjO0P/QbKb8+Dg18hjHrOKSW3+OCaDXNSLqGNt7RY8VB2fWrXJj07p1eZnj?=
 =?us-ascii?Q?ylDxCH6yyuYwDrs94gQ/aWBFjqAx9VaqScgtnR0tad1EChFct2VoJ8+a+NEp?=
 =?us-ascii?Q?6afT+vuQ3Oht5tHGS6Dq4idTov04HX2azLdtIVwwzxLa6BHMH24vTrTydY6h?=
 =?us-ascii?Q?v22Eukvm312HdXOnFhRdeHsg31ypqTzdAWbFJ94l0laZi0KOyyk6l4JiFflN?=
 =?us-ascii?Q?gJ4YCWz8UG/VSs7BVjPhyrQ3PusEVX3bqbge8NCRhfi/AS6jSXBIr2b7jmDh?=
 =?us-ascii?Q?ELvvOz9ER8FuvOnlIdJbIFvxj9HVbn6MXVKez26tGdSae1SqkNwhL6g/H4ga?=
 =?us-ascii?Q?9fLAyS3Px4LsgJcQyksEXFsAA48VQ2Zfy9aVRDSjrn0+ShRsY5x1Z+S8ZWes?=
 =?us-ascii?Q?3I1bQOYZNRkXuxLkuQd3Yruc+lhQn1D5QkqUBP1uogA+tR8wdBLBgzJmIS39?=
 =?us-ascii?Q?5GFO6O9fwMMdIty8yHMoUu98hUa4kddhJX4UKf51pu3gmMgw1tPJGIL854qI?=
 =?us-ascii?Q?6J6dY84wUMGGS0HhPX6gB3Q6qOnNMFxeb1bKwah9kqTcGkaZD7LXydV6Abld?=
 =?us-ascii?Q?IgNUFLNL3p9oh9AyXePgj0BudMRAUkA3ieDIdqMv/2IdmDXUShoSzLJdNtM+?=
 =?us-ascii?Q?EPuCNFcFw3BP0Xd6QXnf2jjs/0KvE8rsDSNIBQ+iAh9f2A/XIAAZXO9pesv6?=
 =?us-ascii?Q?YIbDbXwxJeoyrWuEg5cUbzaN3JgWOlJTiaOj2Z14BNx4V73OGrBgBk2EjCyx?=
 =?us-ascii?Q?kHMCagAtZKzjXamzb40iylY3ddTSMhSS3PMuXCezMINBffG73IbZrROWDaMC?=
 =?us-ascii?Q?OqF1a71hghMIM2FN+sK1pVHxrbYrNGv0QlseqsIe2MhfUce/7VDxIQwtWRCj?=
 =?us-ascii?Q?7GRHa5dtDwnn5i467LRShMSgmk6HKi+WAp357v1UDm/d5RKTCPdbi2I6UggN?=
 =?us-ascii?Q?vYiJOSRlp5EdjGwHYiHJYYhfiekC7SPxbXsJ66AcTwBlDIKCqKwhggSxP67j?=
 =?us-ascii?Q?J7CTaPxU72cajLIbLbfocNheUss/LwCEUSZfo8kR57z1ImwpmZizqBCRPr+f?=
 =?us-ascii?Q?1ry/yKQ5eAGZtoTmIjhxnBnnhm98P/P5dgvn6xjlx1isiIzOzNqYMo/Vt+yi?=
 =?us-ascii?Q?Zom61Eirnw1pbsPrY69Ckm5Ora2uiNfH9vA+UAvD2EkiDPHELRwubuRkbEr7?=
 =?us-ascii?Q?pWhdYYWUhI1NOADBVydE233qvjKQWkk1VQ9oZV/nTvEAEDUAusaTKPl/gyLW?=
 =?us-ascii?Q?1r7liPjuIReaTr+Ou4dX32oKfis3Y+CWaU/Qhk0uDui1GF+I8P4PkNlMEFgH?=
 =?us-ascii?Q?6zmx0pyF2xiKWphzdggNxRFtgtFcxsWxvKMQgjbC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec2119d-dba1-43f1-9c09-08da6e0e1f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 07:20:16.2195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LH5y6vLZnDJm2gR9QivPOetcErQduGfWkbtQyGYI09tO/Ueivl0Okzp7VDnMjACzPow2anhhlFnaxXg+69UyvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4489
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 21, 2022 8:05 PM
>=20
> On Thu, Jul 21, 2022 at 08:45:10AM +0000, Tian, Kevin wrote:
>=20
> > > + * will format its internal logging to match the reporting page size=
,
> possibly
> > > + * by replicating bits if the internal page size is lower than reque=
sted.
> >
> > what's the purpose of this? I didn't quite get why an user would want t=
o
> > start tracking in one page size and then read back the dirty bitmap in
> > another page size...
>=20
> There may be multiple kernel trackers that are working with different
> underlying block sizes, so the concept is userspace decides what block
> size it wants to work in and the kernel side transparently adapts. The
> math is simple so putting it in the kernel is convenient.
>=20
> Effectively the general vision is that qemu would allocate one
> reporting buffer and then invoke these IOCTLs in parallel on all the
> trackers then process the single bitmap. Forcing qemu to allocate
> bitmaps per tracker page size is just inefficient.
>=20

I got that point. But my question is slightly different.

A practical flow would like below:

1) Qemu first requests to start dirty tracking in 4KB page size.
   Underlying trackers may start tracking in 4KB, 256KB, 2MB,
   etc. based on their own constraints.

2) Qemu then reads back dirty reports in a shared bitmap in
   4KB page size. All trackers must update dirty bitmap in 4KB
   granular regardless of the actual size each tracker selects.

Is there a real usage where Qemu would want to attempt
different page sizes between above two steps?

If not then I wonder whether a simpler design is to just have=20
page size specified in the first step and then inherited by the=20
2nd step...

Thanks
Kevin
