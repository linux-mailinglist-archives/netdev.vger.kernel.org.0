Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9403F4F631F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiDFP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiDFP2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:28:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA13A577F3E;
        Wed,  6 Apr 2022 05:27:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaXPFvfU7SBCNPzLhpKst60+zlk/spsbdwVxMVOK/YsVBmpzvJ7QeAH+lhL1MvQN5HkkzsNfkaq0sqtK4ADzE0I3EAxpem4zyGpIQu3jtPc3sNiirvQQCuZD1EhzYVPn1lf9GRdYJUKFvvGQjfvnZtD69RCji8vSHo5dSUsTsVAtp48fZ+WBtrH6SjNdDct5AYWS1oX43FutmFE3XJSYe6fdx6L0/Ej4yYYpxCFUud7Om60BhdJ/ZWmzaKMSjE3OIL8Ofbs2CRiIK4ZYgVuqXOZGcHOXBFLhaAlqHZ1W1puB61O09Lup/IocjFaGnsIxfEFZkHE1DufkoHWQFqHGFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXAQpREFgfdnC7+UbVkwfhToUStahafDSVg0xlfxXdI=;
 b=HaDmcirnvvUByYCScNstwPBTgK6RmcfNikIaf/7PjQsHZRrxztp+XSvg41BBSEX5diKU80lOTY76GuRfKX0rMeVEnh3OF1RLsih9ro3dCuEzIV3yCa+go2JAGtuzPryo9dC+DpCWKPvKjM4VEySg0E9KQmbT+fnh46WrIDDIW95+HuCuM4HxF2PYA8S/woM7yHsSm+G8vDBo1Rm8SvXtxUUHsJcAiubtlIzXPrvlY6urfAK/j14j0JI5nm4u4R0mtNIcRvOdAJVXQZJVgdr+6xJxJ40h5Bq73bmIrQvZbaDlIWhU3mvbebEbkZBmtZClAyyeNbXDNquGMpFDhdo0aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXAQpREFgfdnC7+UbVkwfhToUStahafDSVg0xlfxXdI=;
 b=oDzi3F9wREQ0pOd4g6ZjBXPz8EJGyRa70qpqbNy6Pd+hcUcaRIuDIyA9G+BdOB3KxEa3tsSmGJcRxu0pLK38LCQtwGWoQNYVkhtA6QwzTz7/Z7CagT1o28Bw8dWriPF0sxKN5w1QimPcBnEHrahaU/EiXCgwglCEODqV+nyX5TgMgn2N96haXD5+5uQmzKi6iLM/C7mpain9A58uCHhZw+SW44KW5Y8gqVfisRUi7TtrGJkZ3Jd8okQPFg8O5upWMY4JUU64T7pBwtr9fvhHh3mtr0oB6nnKV3q/M4qGcmD7KhUHiq06DNUm0wvtuytN3Q4wR21UEXeYME8bWwzfhQ==
Received: from BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17)
 by BN6PR12MB1282.namprd12.prod.outlook.com (2603:10b6:404:1d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 12:27:41 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 12:27:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 12:27:40 +0000
Date:   Wed, 6 Apr 2022 09:27:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] iommu: Introduce the domain op
 enforce_cache_coherency()
Message-ID: <20220406122738.GB2120790@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <3-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB527691474154C32D5D1678918CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527691474154C32D5D1678918CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0076.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f67b13fe-fdee-4958-f767-08da17c8d77c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5320:EE_|BN6PR12MB1282:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5320A1A24A413C64E534E0A8C2E79@BL1PR12MB5320.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BOKxCUV1dgCKvovzVNPrrBF1p41vRVvJuvgIsA41zeoElC66KHGvuAY3e/pihxNrSJ+eyDdFL3eTDuwJc1lEXLKWMH1cgsdczZrVGVnOi1q+vdS7GnmW+2jm9o0npU3tjtPe/ASjHANJCjcqmYcVczWX4hveiB/PP03cUyf5BfJOP0F2BQ6Sa4F3GIETdR26fjBRqdCWMZ7V4b3yLWWVaZL1J/nlIN7kjK6RnkHfVjxeZw1qPpDQ3FLhza/z2EiIX9UASw8Ic69fy/UspCGn6WJAga2PF5Rd8r2vyNUVI4u+8NZCq6IWVTkAnjgARp+hf4PL1gpRtGM4wfC6d0QOv0WhdUHeZ44EJk+/6LTXQbxfXiqaTeBo7TKofeUqwDHKMfA/erIKUC4z0fqg3Khe0Zc8sAO+guzi9UH+wKfZW8XGNHSbH0w4xzpYGkKQzcNQ82dUUng8w+7tN0Pu6tgHUr0t1sM5cDqxBbYTx6TpULsn9vQZSDlyr9FX4DdEgibkXo3fuKMLN7cQ6AJ0qm25avNAg43OJ5FTpVriWOieBH7e1ixs2mWHM6zEuXDVBIav2iPv4up8YJ3HabtKnJlVqlTeq+Heh5up+Mo71N67RfcoYIYN63onSTkxjGezk7AYBK8zFYZmAWqMGAKUUHtTcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5320.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(5660300002)(2906002)(6506007)(8936002)(6486002)(7416002)(86362001)(508600001)(186003)(26005)(83380400001)(6512007)(2616005)(1076003)(36756003)(38100700002)(6916009)(54906003)(316002)(66946007)(4326008)(8676002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q2VVonRfm1pAMzXl8GqxbdW5a8tcfvAR9cSXKeMReT/TyTPhteTFRYGQ8eQW?=
 =?us-ascii?Q?t0xv43vYzdi+lstQCFcUoZJMkomQ2lURNePJkmtcctrVpy/Lh8vcI5HHvFYt?=
 =?us-ascii?Q?uSUY/sS9cwC+xC6eVUv7FA/eqrYHzT0bUy/+jKH+5k7ffZZMUoSWNa5Zxqci?=
 =?us-ascii?Q?EyHCrVRJfK6YSTDoR4sf7VXGtVbJ3cKs7xKCNcrwHxiUAr/P8ujp2cN751uF?=
 =?us-ascii?Q?tLRwLo51M4de2octoiQypv0us0M4Om8gho83I9wGlbYWpUujfg0dMRrM+n+W?=
 =?us-ascii?Q?7h6waJJzNZBRjargJZ0lBDZpeBIfa8gVBv15xsptCWZwQG6fPyMtq2fe4r8t?=
 =?us-ascii?Q?yB+vMpTzaAIxhpnYrBhw3ARt4+DA1N8IMsoErmIBPheuGviCa5ds6rYqTFys?=
 =?us-ascii?Q?vBCxvD/0eObANtnpn2j3EgOJP3iS40zPbvxBl+2CfJOS9cfv6rOi7HU8lbbt?=
 =?us-ascii?Q?Xh1uIJS8sxxxNxUgP2yFXzgmW4IA0itQT7meDsstzZm34C4ryj8DXt8jrjQ6?=
 =?us-ascii?Q?gNQfxO2R10EQxfPfVb1usmiVlm9ccy1bhkxDFuwjqp52f/MusLyrgRroOCvZ?=
 =?us-ascii?Q?KMy2cxfgauzRUr/QS+py8bd3KwHJTfoZb0Iy/Wq3vVajV4Nx3lbRAqvvAo+Y?=
 =?us-ascii?Q?TuvVPCXONgIRWaf+75SO1mxovuWdG3GaefElU5k9bmJ2kYm1zT+qPb8Q2pec?=
 =?us-ascii?Q?955D0AoEa+RJldSgrK+iNgxNtq2LVVu/23SvN6YBCkFVRAya3xCPMsbYyorY?=
 =?us-ascii?Q?1T1ghdNEJLOE96Ywa+PJ5prEaVpY6kfJhjU70WYz5/f3Ho0+y5MVM7zxR/Mr?=
 =?us-ascii?Q?apOB3ptKN/5mgQ+9OivZ31tT20ZsD7cCPIXdRBQKVenvVUhrkZ8csSqB7TJX?=
 =?us-ascii?Q?pjbf1cpSsQQ4ouQchQWIilBsOQvEci7jBjM59dr8OP4cKD8nv3FXNRCiar8o?=
 =?us-ascii?Q?PwD3WSlfQj4iLnj/K/+oQvRv0CS/RUsyoJVJe9RN7bxUuhUbhUSgTBJaUrI9?=
 =?us-ascii?Q?Tn3szC9xPfWpS5LVh4vfdEY/56Pewm73dDA6w1Vp9ElAF7illbQ5UM8nfK7N?=
 =?us-ascii?Q?hRE1sD9kDAoqdM1EYmZj8BDnhf6TchasmCbDj64bGU2UiJ28V14HxOTyf9Eq?=
 =?us-ascii?Q?B1poAoonhQLpMLL/q8LjlXAx9zEBruDaW0yKSBBDfJ0UBvQ6Z5mMqRnpsDIB?=
 =?us-ascii?Q?WhniciaCXkorS7yubVUJvgxaudQOjMpotFrzS2QD5GkKlI4TTTKIUMx+mjuO?=
 =?us-ascii?Q?jv7JcFrn9PncrDZ6IflDhP7tlc0t0PZsHHO9kdEVsztR0HOxbmUUrglGomwv?=
 =?us-ascii?Q?AIvR8tZJ7Tlmn/jOyrqtd5Gn2wkoR0zDs7G8KJXUsvBFiDAonR5EtBa6UXsA?=
 =?us-ascii?Q?Et0+x2E3aXF8Xw9Gr3FfbqXVagUioC19O4SljLRN2M+ZMM0V0rvDJ0Bgm3cV?=
 =?us-ascii?Q?Yefpf6OF888OmyQNIgF6FrutiPr4mCT6tnaSFaNG67ynxhkKsCW0CW63Sks9?=
 =?us-ascii?Q?IhIP2qdV+9QV3VvglExg35/qQejnvruPx1X65Y9Iv/uAClHwqO+DGgfQSPGY?=
 =?us-ascii?Q?yraEu2mCxxuL31iVyWxLWWiwL1O0Vclm+OV6MYJhvffZ4E2f74Ji/5+Os3yh?=
 =?us-ascii?Q?jmElyUbME1p17ql3rR9bz2WI5nqXNQMw8ZPtoI9uNN1DmbvQjhEqu02jlPk0?=
 =?us-ascii?Q?31JTBJK8DyMyZs3GRqsjM+C2T7Wz4eVM6ijMcg27jjpArPPRYeHEDbIdBpUI?=
 =?us-ascii?Q?4Dby2QQLug=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67b13fe-fdee-4958-f767-08da17c8d77c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:27:40.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpzlyGq0IZUJW+DDPpP6quY3UUqx+yEMrQW/SIRWEqNUnW0mg8Nhdpf+FazTx5Uc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1282
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 07:09:49AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 6, 2022 12:16 AM
> > 
> > This new mechanism will replace using IOMMU_CAP_CACHE_COHERENCY
> > and
> > IOMMU_CACHE to control the no-snoop blocking behavior of the IOMMU.
> > 
> > Currently only Intel and AMD IOMMUs are known to support this
> > feature. They both implement it as an IOPTE bit, that when set, will cause
> > PCIe TLPs to that IOVA with the no-snoop bit set to be treated as though
> > the no-snoop bit was clear.
> > 
> > The new API is triggered by calling enforce_cache_coherency() before
> > mapping any IOVA to the domain which globally switches on no-snoop
> > blocking. This allows other implementations that might block no-snoop
> > globally and outside the IOPTE - AMD also documents such an HW capability.
> > 
> > Leave AMD out of sync with Intel and have it block no-snoop even for
> > in-kernel users. This can be trivially resolved in a follow up patch.
> > 
> > Only VFIO will call this new API.
> 
> Is it too restrictive? In theory vdpa may also implement a contract with
> KVM and then wants to call this new API too?

I expect iommufd to handle this for all kernel users eventually.

Certainly vdpa should not be calling kvm functions.

Jason
