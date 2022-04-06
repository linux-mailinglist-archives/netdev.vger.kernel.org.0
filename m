Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154104F6D8D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbiDFV6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbiDFV5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:57:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C090FDF0A;
        Wed,  6 Apr 2022 14:54:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzw47JhLify1Oq1COpZa7qJgGsLP1pQEa9/Mb41ZoN383xLUiTHs9gKoEG+5A77ZaEy6U69TJ+jEFE6LdwWElBseZIFoCoVHKow2u66Ud0hoOnwbvVk8DbUDMwLH9OogOLtZM+FZ52qiPgRvzCiCixov9siJj7YhV957j0DCLHEmmi74dTNQdT7SCGBM5EpDo0yELmEm+ByJ8D23Q3GRmwD8o167fvV5tNQlPTx/jq5tmh+++Hd7WJdkYqQBrwjtkMY+zJLDHd1wRjnas3tr42qb3Lw34wfwDEVNNgCnNq6m5YewEBw785tdQPoRdF6UfbJa4GyfgRckBnsHWgLBGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/sMtznfKOR3Eqh1AG+Cl6lVqamH1zMzMBGGVUSNJHM=;
 b=HJKagU6zX7c7+Jj1Aasln+4dWInxtB35nvxwDeZGSWD08UVsEF60gX14gRCylIhqY88V5Hd5kCwFIsMAcEbp5EaHhSpCUN9qoTUnsUe96ZoozXXD8ri0nMVb3Hy+XSmrJ888p5tFXOGPa6X8RDeMb2ruQ8Oqc7+7ddD8c7GBy/MCvl6KOE95GbsUtXgNdp/rLB5e1kZV8R+bp4KM/Ah/yCKo2aVITjG+P71r6+/iiBR9XDd4qt5jzI7+Iyg41z3kcH8gwfo0Eozu0nD1mHYxzI3i0G12f8VlVWbGht1gu5lpo4rjQBu/DNkmoygun2c3HkNpyMrQoMO77Zz3CAyaew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/sMtznfKOR3Eqh1AG+Cl6lVqamH1zMzMBGGVUSNJHM=;
 b=jZkc1MrrxDb5yMsJR6/IMiQVyhzky5eDBzlxKrHT37zz2hujv2XkIrQsP2PCKpAJ5mO1jlYYgygI4GsHmLs6yNWdHgeGI+tnj1jogULJFcvItL0Hws5dEb7jUGp0IDCxpawsV3eq/SOfG1LRXssK4WA3B/gHGrY4pxfAvny+Un4oaCEikwFeY+KqZ1iEjgiRXNf3GDWFqJSosn0drXhqjLK+zP32dxxTijBWqqcTmYyamTHaeuVgMD8Q5AKSyE+oVidGhI4qjuHIO8Ble5/7HEiG19e4JristOlVO9AGy4rjNvgfdLZmfBXMglwLMeulXQk5knRPpmTA8yLP8ylNsg==
Received: from DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) by
 DM6PR12MB3786.namprd12.prod.outlook.com (2603:10b6:5:14a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.21; Wed, 6 Apr 2022 21:54:34 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 21:54:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 21:54:34 +0000
Date:   Wed, 6 Apr 2022 18:54:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Ariel Elior <aelior@marvell.com>, Anna Schumaker <anna@kernel.org>,
        Jens Axboe <axboe@fb.com>,
        Christian Benvenuti <benve@cisco.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        target-devel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH v2] RDMA: Split kernel-only global device caps from
 uverbs device caps
Message-ID: <20220406215431.GK2120790@nvidia.com>
References: <0-v2-22c19e565eef+139a-kern_caps_jgg@nvidia.com>
 <810e22f7-a48c-dd65-5665-8db757f3ae29@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810e22f7-a48c-dd65-5665-8db757f3ae29@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:332::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3c05a4f-44af-4533-5c05-08da18180924
X-MS-TrafficTypeDiagnostic: DM4PR12MB5745:EE_|DM6PR12MB3786:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5745534158BDFF56F27946EFC2E79@DM4PR12MB5745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaOaXjXH8v9O0m9nY7ZAmNnitGfHV4QKHVrcuzVH2sbLFNmVzpm+y+ZfQHwS9mIJh+gqR0uyyKofDDbRXiHtaEaekB0Uto6csersxeRElcaJY9OtDN1+wlofUUKYxuZpoRnuYLYXPbiQGjB4wF2dsmLIyJfBbdH64Q8A1zVEyvN23es0JCsB/vOBVPLWTGcZ5v3bPr47iEsiL109esCw7OFsYYTscBXV93ApAibV10d9VCgXjdyl9fg14X3SVAOWDzmFZHXOQTfxv9Ms3aOSTCDsH/9vcJdk11Kv57pN8FaFXhWyX+0eqFQ94AVHK9eAE7q3QMy4hIeAZWwUssLA1txl+IaUbLijUfLqUW6B+41Pq/JeGwzpbFOpWzwS1o+EsQfwmOMwRqhcqA1pdVfs3k6XXwiaDUOgjQOlcD66ZgWEotaNbsjmImuSrm6mMYyAyHkeThy+Ko5jH8vWu04niEc6ucrH00ZRJtNR1YJml0QBJzYIGkG8EaaASl1R4DVuGhMHXLfpUvRGTVcc6Kqvs6KyuTVK/lwJOoeurUc8Nyn/JGURb1Vr/iLwIFMBy39++LXsmF4Y47K5hv+weqHt7QMwgNvfKeIb6NmEYJ2taHapkG0vYQWiTVqmtEkkiehTUgWnWMLyPtDZTjJHZ92mgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5745.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2906002)(86362001)(4744005)(66476007)(4326008)(508600001)(6506007)(6512007)(6666004)(6486002)(6862004)(8676002)(66556008)(66946007)(8936002)(6636002)(54906003)(37006003)(2616005)(5660300002)(7406005)(7416002)(1076003)(186003)(26005)(33656002)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vV8fzBq0ZFGMrQwhoiMFb8jBy+mrhBrMiYEdzGIU//RNFp4NESV0gF+P/Yvl?=
 =?us-ascii?Q?R9fyTTv8hjWAgnhqnQ34Ae/UHfVlOrq2rp7mXbXGkqsJp6NH25+RVNuHe7GE?=
 =?us-ascii?Q?FqBd9nt3hFchCBQLQyGBn0Oo4gz1LiQqQkH9zj6zLvyji7KIe3kBp+Fdgesc?=
 =?us-ascii?Q?Prkdnd2TJ5RLGoOBt96WOpaJfWd8F3SXVtsc2IfNfW5ZVuCV351kMfjtoOQA?=
 =?us-ascii?Q?mk61xjv6olXUMl6SpCswOEniprZGGY5C1yUkAGuNOdKmeM/JY7Ho9yGa5xaE?=
 =?us-ascii?Q?7mUPz8/lvFwV0CFBqwVWWIJmsiXZTJw0evxADP863SWG94H/WIbJ9IiNQFOg?=
 =?us-ascii?Q?iWWbRxemtxg7TeL9r2NGNy+9gMGMa0wCtP7L/5mws0eeGmRoUyinOP8dscn6?=
 =?us-ascii?Q?/Pr8FDBDj+tySYnGZdRVOPWZCwwobxKYRKw254aBRRaSe35EjikdWUkTBS/R?=
 =?us-ascii?Q?o2NYKWpRr+xQ2cd5a7CzUD6ppdIuipMc2wAARkHSlsQ1hGJj7wqjm76uOQ+k?=
 =?us-ascii?Q?TBncgtgBkMK6sXO0pOD4Gng98/5v/3kKxlOkiUTOKBpfnz4FWD+RnwcVj7Td?=
 =?us-ascii?Q?mU2xRj5YF0thA7T6GyOT3mOjc8F9G9gd9M5zzud8ttrAImM2XbPRc8vHv7oJ?=
 =?us-ascii?Q?MBMZP6B8sAinOr5JRfFJAAmV5aG6a6+UGq+MjE25dIyyI2rdtoik0E94S9/P?=
 =?us-ascii?Q?o6aIpoz5aqNvK+dImbs2N9T6buJDG5y4LhP0FlE/WpcoVUfUF0K114eBIIbX?=
 =?us-ascii?Q?086i5Pb/f1JifI9G23qm0pOhg6qXowU/HDgS/Ww2iTyfXwirh2QS05mXUmVy?=
 =?us-ascii?Q?slbPTNQI/Pu8ODYV3UAiO/hRYi77P3rJ0hqCkIT2RBWLDfqrfHY+Kv+b8xRd?=
 =?us-ascii?Q?pmEer5fJ1gMhJNMOxggzXL+LVNMKBvWn+unDX8qZM4aSC0ZRzETIS9KXNOor?=
 =?us-ascii?Q?pzBjqVfYF5fqjL5jJ0Kvjdk2w6bhlZPJPSkIKoH/MnOZeu+V+9q/9fKh2hxI?=
 =?us-ascii?Q?tB3/wEm6XVAH+DIu4NIZaWqAB6motMn/ju5YER0TCZhe+MNbYqHeHlhMvL5z?=
 =?us-ascii?Q?FDkh+htk0l2A7pWquhAo9ZPaTuRdU6x7at8sysTPZ2lb1BFWIZ/x3fpIOCJ4?=
 =?us-ascii?Q?jLg4c9KFgpJQmWKb8qPXIhdAy+xKBVpWbrv9cwT8jh18BQknjJyqslZ4oohx?=
 =?us-ascii?Q?IGiZqYv/VZeT41aBG84a+Cap18R6lTn1zlexjSodyj/Q49ZwhBm9c4AoKQW2?=
 =?us-ascii?Q?VTRYcOE40ndALhgMgiZFazKOSUkOcxfy78DP6ipgHuBbB81fNzlr+jI126QW?=
 =?us-ascii?Q?OpjS833pg9OE8aprak/QjQrNWm61MR/KM1JbR8OEhM4/jM6TcfU6W5NtSyNH?=
 =?us-ascii?Q?GLLbxLFzh9Gh4tWgWerw/U+/GF/ab1YivZGQb0OtlSTCEcqY8xWrZmNx4xdb?=
 =?us-ascii?Q?bTNO72Gct+4SBJqeviw/vswWFahpNru9V2sNECZAhmuuFm2Ab/1A4xh+wpnf?=
 =?us-ascii?Q?ka1k0ZpwNRLwhLMBCdCXeiYxVOGiJ58Vu4RLJorhqtL90biz02JUgoSW5W3o?=
 =?us-ascii?Q?yPRtJ8idAYzc7zH8/t1XlOPxaS4s7rceUhApAWrqsSUmWg4jAHZsXBsXu9Ic?=
 =?us-ascii?Q?Mst8U1VL3+L190vIKsKfXhF+USSs46I0Ibr0sHBBzz7DodDp7ArIsf/KzlPJ?=
 =?us-ascii?Q?p3AW9fAea/olXmfosjPh4jUgUs2KwRGQ3Q7G3J2mFQBlnuw4WtsP6v7LWiHC?=
 =?us-ascii?Q?whxBl4e5NQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c05a4f-44af-4533-5c05-08da18180924
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 21:54:33.9568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXGyAWSEJQFFJfujDiFGWWf5CTiErh6g8O2+9F1BDFY6CGpVEtY3UCQJEMPWY5wy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3786
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 12:01:44AM +0300, Max Gurtovoy wrote:

> > @@ -267,59 +258,53 @@ enum ib_device_cap_flags {
> >   	 * stag.
> >   	 */
> >   	IB_DEVICE_MEM_MGT_EXTENSIONS = IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,
> 
> MEM_MGT_EXTENSIONS is used also in the kernel ULPs (storage)

It is not about where it is used, it is about if it is part of the
uapi or not. Cleanly separating uapi from not uapi

Jason
