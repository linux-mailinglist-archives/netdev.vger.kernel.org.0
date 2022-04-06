Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957404F6875
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiDFRnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiDFRj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:39:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7411FE24;
        Wed,  6 Apr 2022 08:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3qBdKfd3nrMh7ZqYQggyCRBokdQfm/gJtvN6/HQFYUjUxWV0jIo1ohjrMCH+m6f13TNaSvNONHDxMJ7EeTEqWprDdi+fahQizXbJ+bOSyGaajfEWqI4hqFjpt4+jD5n54vl85y73XbY7GOB3Hl5qTh21Snm0wdQ6F3yMSJTnfcx3qFGHUKILeuuZek6S+kvWAwcwjrTncQVPiT0ze25qEP3HiuBahFVYJrGqZ7PtWTBsq6RSud2l06MnYuAQXYZtV4uchMpcb0q7uSBlvUjW8YjBABF+ryT+8MLTPt7gtMrmpAXXXyw9w8Rmd0kzNL7UczjA0cxSPltgTPQxUvllQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAeixdgG2sm4ASXFPZPLt4CAPqXGuYqkQOSoPMbdDjw=;
 b=fFq//y3DiRH1cJeUfd2mo4g3yMPvdoLeOPS1x5AUWoBMwYKKuhLamA4ROEwJr2VzG1v9pTOaQPgrwLmrnZ7gNWx5gT53KjAuRPKJQec8bjltjTiNvlmuG+v/V9duj4AAg44m2Nxutr3Rcx9vKCtf//0UiBjFuID6YG7/Z06rI147SJ8HHxBsX1wr9Tl0DZjNbGbSODpJjlsfB3vv1iYPyQZlgM0S0uIZ3gXVHMSoDTgUUEmz4WgWaOxd8M6yaNH60qb2xTIo8C2SLQ1byHX98ghEZjAMYnjOlu62qq04fyCnh4gZGzN8Fzp1BZrKIcyRTIw3PZ3ZIpvCWO4f9z6mFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAeixdgG2sm4ASXFPZPLt4CAPqXGuYqkQOSoPMbdDjw=;
 b=sebjnQJ9t57qhpd7YFYxruratpenglUq4GMxiXQh867+bcFEX+QbfRAIZP4KuSDi0EkCTS4RxI76/AXsPDZPlYEM78VcKOQZahMLWy2b4dR+nmdhyYy9ByEXYsCEH/Og8bOzTEiiNSLj2T7TkNHehsES7kDai3hTilcOcxIxgcwDlucqIB7hTTcvk63sAgZJqwNDmWoIjpFaLM/8ziDh2TvYFOUpU/SxgvYka4lH5wHnTE7S3qU+jiDLY40aHyc8gvmB4SySefej/ZXhz6nnyW3n2p1jvsgNP5P4T2KzfV5XhMexqYxjVgGXxE3n2p5vhvr11l4Sxmx4DMyXhSpczQ==
Received: from DM5PR12MB2357.namprd12.prod.outlook.com (2603:10b6:4:b7::14) by
 BYAPR12MB2791.namprd12.prod.outlook.com (2603:10b6:a03:61::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.21; Wed, 6 Apr 2022 15:48:58 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2357.namprd12.prod.outlook.com (2603:10b6:4:b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 15:48:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 15:48:57 +0000
Date:   Wed, 6 Apr 2022 12:48:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406154856.GH2120790@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220406053039.GA10580@lst.de>
 <20220406120730.GA2120790@nvidia.com>
 <20220406135150.GA21532@lst.de>
 <20220406141446.GE2120790@nvidia.com>
 <20220406154723.GA30153@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406154723.GA30153@lst.de>
X-ClientProxiedBy: CH2PR14CA0060.namprd14.prod.outlook.com
 (2603:10b6:610:56::40) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fa4ff2d-7244-4baf-eba2-08da17e4f601
X-MS-TrafficTypeDiagnostic: DM5PR12MB2357:EE_|BYAPR12MB2791:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2357050267F89A6846CB966AC2E79@DM5PR12MB2357.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KO5s2xIpBNbHQ4foe41kCHe9Iajc7vCfw07Ieb8DqfJahoGHY7FZrp4wUYxREzUWYeYVW0E80X7vneHARco2kuuKpYH4vwOlUhQhxd2vlgZfqoszlyHR3rNcyKcaodpuQx5TVQknZcQ6CaqzsS6aN+NT0MGrycTEUAgh25IL6hgtOZXpGIzpoT5VqEQhpIljf7btbyerrM4OjDXpcpn/xg5p1thYdCAZg11hzLISddTRcUI6sIiMpCbxy678Wqops9HW/3Hwu/jfm+i5Nj3hdPu06hL6YcI1maI24GG6rnoPAShF6QtMWrID2IT/wCsPR/hoFNr/HMydjxIeCBd9dPhZN5XUHt/cSXH3BJdqt7JnKQtwNBwUPeuAhs4TbIoKWHRZsJQnIBby4AbFVLmilQ0SB+gSAxbfpdz8BULONettY04KWsuLBAWPq0xQxKGL/UUQulLa3XanWmkJFpXiOYMceXK3oCScV06ljhYnCl6cQ8RE1uP869ZFih54mrDKUg4SAYZQyqMuIvU+57LrlPiD3v4v0Qm0XphPwiqj3dxy+iq87qb5OJraLWcA/4sSWcQpY9oPZP/vd1TxNSyc+F9SRnND5Q4D5TeQIlov5AkJ5QGrmZIwLqa6iHZA8h716WIJWVHXFXboQZ99fKnyKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(66946007)(66476007)(8676002)(6916009)(54906003)(4326008)(66556008)(316002)(36756003)(6486002)(2906002)(6512007)(508600001)(33656002)(5660300002)(86362001)(7416002)(8936002)(2616005)(1076003)(38100700002)(6506007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2cMp96zzB5PdQEUbsrSXHt5tj0qQi3hREFyTYc+IXxb5jSh/eJAZP8qTQOu1?=
 =?us-ascii?Q?GKmBcOevcK0pQ5pC76888qQQMWeBO9NgDm6R8uczoDy2ssZkk31iRKSjIS7N?=
 =?us-ascii?Q?S5icr6YmkuGlJdEgf02XA2y2L/ALNyyIpKSr866RYARxeP+wQ/J33O9qfnxD?=
 =?us-ascii?Q?TNs37Gi2FIgR0cpolHcDyu/hVZ7rLXXSqKkSynlH6cv5+qFLtRBURdtCjmmL?=
 =?us-ascii?Q?YZxS8VgKsNaUOK1stqfNlhcr54SnOyNadrrWGAbzclX+1ubkmjvzmPwSwS7Y?=
 =?us-ascii?Q?aCUXbHV2hZUgAZIKcDwMtUAAQP/ROdSOm6H57sJ3O+JIjRpa4gsfvpaDcpkc?=
 =?us-ascii?Q?491LKijX6Rt2C00of4Q7QgeLtYY5isiDrpuyg4/I1rU31U2JGa+QIbaDESLJ?=
 =?us-ascii?Q?5c5djN2o7RYxN+4N5KT3VqZQqPiWQYqNr+FF31x+uTw8JGBi5/9hec5tv7W/?=
 =?us-ascii?Q?NW8C018bT54121bXztn3iQdbEBWMQG4NGURDqBzQe5j6ZveZdfdrLR9Jv0Gs?=
 =?us-ascii?Q?tYKW3YgltUtpbAtq4t4+2f4EDmbZP92dK6NQ8w8rUf5/gZd+dyA57GHtuGeG?=
 =?us-ascii?Q?Sy8CEVbEB1kXymUBcWxXh3GdOJ49dEVaZAttqOfD8BtEz3GFJ/v7/golp6b5?=
 =?us-ascii?Q?Cc6hyJvPW3gz5x099zHt5rvb+GrqbZszSeRqG1eQ1zSDoI8iOjYPu0b6WTlX?=
 =?us-ascii?Q?3cAbL5mT+PytRp5hFPJvSdMXKeWx9p+LD3O7EcXChMW1wdQtoozhUOlDPkwg?=
 =?us-ascii?Q?VTftluYUw2wMviDGRenfxj/6fib5diVJj9lUuLrgTYeyvxNJmkFXti/T6rty?=
 =?us-ascii?Q?FZLmR5NDdq4/t5CK0lGiEXllYUWBNgrgTW2YjJApBko0YVCql5HVKNmqj3LV?=
 =?us-ascii?Q?LcoYOMGbtXhB5FN8XaOwSVkJL39tHX+kJbtJ9swGGBho0M110Eb00DVv+fa8?=
 =?us-ascii?Q?e1X6oC/59aTyHbKO7NGWceI1QuUsJrgQiaMy3Ld4s/yHdBm7z1bwMnVUEXHH?=
 =?us-ascii?Q?FY5D8HFHGIey2VbY38B0bRFjfs3k8+QnVI82RyDWKURAtWnGuSb+XTg++d2H?=
 =?us-ascii?Q?dlCSSke6uySgWugHRpFa838GPy2mZ4cYhuk8S30n8G9guuRgii0gcu4KhKt+?=
 =?us-ascii?Q?8VHAxOdq7pZ8KahEXx5PinnY1/Ax8nf3nPQD4k1XbFSEjaNwkHi221kf58fx?=
 =?us-ascii?Q?SWoS+5CTofFE8EaZ2yVqDvWmvU3pJ2+1H9YiHXs5DdUIcFSdhvCENUrDIYva?=
 =?us-ascii?Q?umICuvTcogjuuhrcrBxsBfGJXv4srG0/uwvBD0BhPUtImDKgMaJTCk6dydGE?=
 =?us-ascii?Q?3Q/aN65tBs3CnrO+KPy4i+YixNNtfiVsGZZu96yVlFcY+yuBqrUGVOAEVgcF?=
 =?us-ascii?Q?cTgrEWkhbKSW1FYnEbMftXQR1W0Ks9M/SnY6ABbANnq/t0jCTPlJEOxMSiTc?=
 =?us-ascii?Q?nPj7bCOmHMDFkC0EosifAwdkBdvFhqLUEn3R5/lJChjweTCtkObg+CREKUoe?=
 =?us-ascii?Q?DTS1bCeNWY3iHOEjMvFC2J4LBPijIcRca1sANI1dW6BfCIsYULxswPQ4ZEjs?=
 =?us-ascii?Q?6mncjcrdaOa381bR3pinDYXXmD6Dx00ECeCbIKeBKVo28h7WvpvxA74ipVtb?=
 =?us-ascii?Q?81PqWfb17r/g3Kk3U8PNj4A2/CIoS4y/O7FOgwTeLX66IyBszu89W0+5s9VQ?=
 =?us-ascii?Q?qCzNj/zTo7NwFXOeWrndcT/Id/lNskUrs28iH3+0l7PRdDlju/zXdXtj8MF+?=
 =?us-ascii?Q?Rmqw2kkIxg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa4ff2d-7244-4baf-eba2-08da17e4f601
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 15:48:57.4587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6j+QppSN1FAFlLtwFC0LRq6d4eZKNg0b+sb9LpRpPEOlFnP7TFGsRi8NcdObAjG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2791
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 05:47:23PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 06, 2022 at 11:14:46AM -0300, Jason Gunthorpe wrote:
> > Really? It is the only condition that dma_info_to_prot() tests to
> > decide of IOMMU_CACHE is used or not, so you are saying that there is
> > a condition where a device can be attached to an iommu_domain and
> > dev_is_dma_coherent() returns the wrong information? How does
> > dma-iommu.c safely use it then?
> 
> arm does not use dma-iommu.c

Oh. I did not know that. Thanks

Jason
