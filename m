Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9204F8233
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344317AbiDGOzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiDGOzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:55:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211FE205E2;
        Thu,  7 Apr 2022 07:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H98o54iydr1dDiGVWOhYen8z6O7vjCkgxBpy+3apEts/MIy7rR79zN4Wa+k4Idb8HcKHVUccG/9PggpYphSoj964j/qzvi9bYoBQyfEQCRvXqvKtMEkQ1H73dD498t+IruqKfpPvjHAGNZt1l7n/fMB1xLFc5O2s8PZr66Ms+abxrLbV6lIk/0qfr5cRvAXNV7N1yOsZ7mrtQ1Mq4MIKTjtM8XJH0aEC8MjRaB/GC073j2TcYaGvhXDF05FhucyU5c+yAVtRHcmpHYD1YQZFdr3sP0YBD4Zvk6Vuwtnu7zvIed9kz7o2AdEy9Jq/Gak2Yt6v2ru2U6x4AFsDcjvS4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vezn6pghw+/ojLfERDtLmCF1oV0Fa3dAA0amYTZe8Pw=;
 b=AMfXRkN9lqBC74Y0su8lV38xNZuJtrifoWi10bxko10b/kdNgtMwvb1v3P+11QPSZwAyPcB443onXfnpAiRlaiJTIBmrzpSXqzIB0SQL3uBJnp+MCDH7dphv1DPZCqh8eO3P+J/CWGwvRJj6xPTEEi3VMdZW6R9w7Vp6lIgednvyKtFoCqoYlLG1wjFrvpq8ycVQ1fhrWgZvcl4uUNl21q29XJDrIRsCo5O7Yvygf/LnQsgY96U39zl0vSlmdnmlLl0vyb64Zh2G358aAp/4R7LT14x81Fm1WTY5Aulo7gZFCkNL6SQPtkLfMZht1skqFMptGegyRGXZZCOTXfM1ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vezn6pghw+/ojLfERDtLmCF1oV0Fa3dAA0amYTZe8Pw=;
 b=E3hJQWiNqbeGRxyYd23yghNIid0lBlergOrflUL/l6QUo/Ajwccj56RRda+d0ThsxehZRGfBYj8obih7YqYNiS7yllS80PmCEV2Zc4O4r+XvJRQc65vtiy4XFqL9sbO9na2UT2OmlTbyXXgBRkdmTZDrh6TVD9FbNdelRkWn3DgA9VE8JP6856jYfOlt49dKIfyO8p8w31rsB4Nqy8kr0VajRT9IktKxNM6rmORz8q5yPnOcq5glWCv0X6i7cguqkgEeICPMqpyzloE7fJMHOHneKhcMtCCu1zdsFuAQHodv1SccAJXORnHjeK0qOJngF6NAOKxGrHCNpfGpkKOFbQ==
Received: from DM6PR12MB4500.namprd12.prod.outlook.com (2603:10b6:5:28f::13)
 by CH0PR12MB5369.namprd12.prod.outlook.com (2603:10b6:610:d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 14:53:34 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4500.namprd12.prod.outlook.com (2603:10b6:5:28f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 14:53:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 14:53:33 +0000
Date:   Thu, 7 Apr 2022 11:53:32 -0300
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
Subject: Re: [PATCH 2/5] vfio: Require that devices support DMA cache
 coherence
Message-ID: <20220407145332.GA3397825@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <2-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220405131044.23910b77.alex.williamson@redhat.com>
 <20220405192916.GT2120790@nvidia.com>
 <BN9PR11MB52766319F89353256863D41E8CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766319F89353256863D41E8CE79@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH2PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:610:54::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43ec1380-6fe2-43ec-9d94-08da18a66326
X-MS-TrafficTypeDiagnostic: DM6PR12MB4500:EE_|CH0PR12MB5369:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4500E77208EFE0E1B3D7ED23C2E69@DM6PR12MB4500.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yxj4MhC4rfK1c6dZxPMOBA7eSsFhY6Sir1BSAHEXOflRtq0tVX1J+ye62SCOut4+ycSCNKuS7wCRKldNJaXgue9osNFps1X0ILQ6XmAgMSIXS7SDWAhp4uywmS5EwgSwt6+juNA9i0JhgzbgUw7Vuf4TsJ2Xw95/LtX9zqNiPrzUYix8+ma/M8TbY6L03LeoJUkdqHow/0UZgDSI5I02VLQ5BrejysfCqLP1gSsfEB6svyuM4xmW9POZBMWg0eIbu9lK8BbwCQbF/VFKN8x7LoALPRTfTcqTEoP1SzCgLXcse18QCWJ4gSsN3BQ1BAxblWOITMx3Y+dsb12Cn5F/WrP03eQAsAsH3bDfHP9lGCr9li+ICGjHacAwNbLhgkUEhbT/Bq5x9cukMAyVCWFa55qyTW/ELN/Y+4sXLj01NXx0W2bUSr6JbUpw1ime7MDFrU9NGU3TPipTZPtMySr7XO2XT+bU3u/HSL0fmmZutz/o+t4maR+pjxyXRZdMBTK768WjL5oHa1XDNnSqGtPEI0VTP9cf6oMlkpvCZ50CEXx2p7/T5WZo3aKJoCWXRRypypxxBbXiRaT9IL0H4wNqWMg8FHxDQk7I39crN5dQw0bytxOwIwL7p7EVABz0b3mNgbFEmO+qZNi3uFXM2el0Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(86362001)(6916009)(316002)(26005)(54906003)(6506007)(4744005)(508600001)(6512007)(8676002)(4326008)(36756003)(66946007)(66476007)(66556008)(38100700002)(6486002)(8936002)(5660300002)(33656002)(1076003)(2616005)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NpfG20A9hiuLjO4yJb/Gw4Dz10yJdicx7jOXipBdqm8fki8JeapB1kRM380l?=
 =?us-ascii?Q?BEkY6ETmljGAhFtCFTc9eIsY9pDJoH19KIAwLNjoYAAh+CtPNKrxN5lOKj+g?=
 =?us-ascii?Q?A1wSCac0OCA8YXI2XA0XXIeQRYmD4IqJr3HPNGdlfNPSGY6ECBFZ2RKVG3BE?=
 =?us-ascii?Q?aX/s47P8nfdehEX1jx2IoxCk9toCNWv9Y+F2F11IvCA0/DJ+GvDbKDEtpUyT?=
 =?us-ascii?Q?5WS61Vz5wUZopiziFls7KSHE0U5mrVOsmBXLRUqX5foZ61+w4toZxJyUQG0d?=
 =?us-ascii?Q?CEyTvzmmG+hkxNtmSQDeoROGAy2dSlaJEHAkDrE92FD+smP+I39MCs0pDRMb?=
 =?us-ascii?Q?8bA3N8hytx0l/Fp47oCpmWhkxZCkkGSwueDyVVTD83XXwJLOcKs6pTQFWXl+?=
 =?us-ascii?Q?HMTdkZxdbw1C4Vl2GR0WmUnJrRSYQ6dnpv9UHKjJV2CKPEFy+pBiAURh9FAp?=
 =?us-ascii?Q?cCFQj1Ljlh+aAa+bB+LH7bYdt6QVa7bLhcv3lIZsVwpagCa1l8I3jucZdc6v?=
 =?us-ascii?Q?OarTk45ell/1j0ws78uh4laNID6O1LBecBtH27JOx9AAbIUnLlmna/312SUD?=
 =?us-ascii?Q?/VR3l1sLQ0egMvH+T398Uo43jf6x8O7TYbYZe46zwktveBGofADj/vW5qt8/?=
 =?us-ascii?Q?1Wi4mJ37V7igjz6o8XbhsOPneslZQx2RG/kAxsmc76nUeCH4K65bxWLspG0x?=
 =?us-ascii?Q?XpZ5aPUjQCm2sWVVpn4wv9RGdRVshCtfci9jGiKkAgA13fH9sX/oyJbpyZ4j?=
 =?us-ascii?Q?+mB3OpbRlw7vPVhV3xFXTpG8LxKq0UqLU6a+G4L5fN2ZtM8tSUDDwbN4eXMp?=
 =?us-ascii?Q?ettmT5HZfJ9QhNMnaubbH/SYgFTvkj2ZEihx2/BdQ/Y8n8wPtV6XAjIyZ944?=
 =?us-ascii?Q?oyHCcHn+FS11ANWFQBvpdkkJjmU2l/rk7tz8QrbXXxiizyDon2CnYzBZCXOe?=
 =?us-ascii?Q?L6dlW5mbCtxzlzoa5pgm9m3jX98140UeyaQlLWA5fn8zAa6IJI5+j+c9aL1m?=
 =?us-ascii?Q?lqHC5gu2np7PuzzwgCaKc8LFI/A0bIxBQN9maiMusjXIaVc3VZb0bH8+oKza?=
 =?us-ascii?Q?zAtQOMI/3PWVojncXOWnCd5ab7o4HEJcgzYcULYXKdH0+pHtC5nAmWtohjkx?=
 =?us-ascii?Q?+g0DddoOP1RYnCSsHdaNIiWlFbnUnHpw/ZHWiMLj9HVZPu5IgpV8V5ecIry8?=
 =?us-ascii?Q?Qz999Me8DFMeMOuDEc//dC5dYDIQHVJBnKnpotJvhsvWlC3UJ9XeZHedllVk?=
 =?us-ascii?Q?QP+5dlGPJFxJgv6erhjfXp1aPQ4p1VLN2NLCk/TOF6ZbZw5yUluRCaULuapZ?=
 =?us-ascii?Q?tZHTZfQL9EMhqsKbsqs22TZKp2PJNzG6H8lVkTUiEjyOMQ+Bh0tbIEnFfeh+?=
 =?us-ascii?Q?y8uvHoBBQVL6AXHl3M8/pN8/1qOyz1B+NxlfDfBzzqSvAmbozcDr85lzVnAX?=
 =?us-ascii?Q?4rrrCAYtCNkeAHhFwD3vg5ql7+UyPWifNqLDUHRzpvdPNGz0BMImIdG9FM8q?=
 =?us-ascii?Q?GmyItF+BrZnUSNCq/+M29pEXF2Jp7ZdGYJYYVZ6QYWQLCycZcmmawYFe2t9j?=
 =?us-ascii?Q?PlEwfjU4IDjoEI3Bjv3kyijcVG4lRc4tg4QIW/K/PdE1G0Ix9VqkzNBc74bA?=
 =?us-ascii?Q?3fSWyCPBpKotDZlxki0hQVD3byggEB0bLhioUocfFSHXyXQl9gUIZFGZPPej?=
 =?us-ascii?Q?o0Q68qSBx/NIzWu1+sd3mJujI0XqhzK9UVepu1IxLH3w2r4G+zAQDsF3SMY0?=
 =?us-ascii?Q?XB9xDHVysw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ec1380-6fe2-43ec-9d94-08da18a66326
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 14:53:33.5010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: de7R+721boXukfBThpCDiUmZtv10iq1C8vldnhy7DHB1yaKUtxgp2xLA6Jm6bUaZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5369
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 07:02:36AM +0000, Tian, Kevin wrote:

> > So like this:
> > 
> >  int vfio_register_group_dev(struct vfio_device *device)
> >  {
> > +       if (!dev_is_dma_coherent(device->dev))
> > +               return -EINVAL;
> > +
> >         return __vfio_register_dev(device,
> >                 vfio_group_find_or_alloc(device->dev));
> >  }
> > 
> > I fixed it up.
> > 
> 
> if that is the case should it also apply to usnic and vdpa in the first
> patch (i.e. fail the probe)?

Ideally, but I don't want to mess with existing logic in these
drivers..

Thanks,
Jason
