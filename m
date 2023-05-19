Return-Path: <netdev+bounces-3906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0AA70981E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB96F1C21220
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40ACCC2EB;
	Fri, 19 May 2023 13:21:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64F7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:21:04 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2100.outbound.protection.outlook.com [40.107.95.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E249D8;
	Fri, 19 May 2023 06:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cu8NOqsB2YlBV2qIL3yxnBXuMGukO+OKWMklGAJhMARDbb2Up9fcRY0BMII7zCUDbrPGMG8D+XRkDEzhlYMjI9kdJTFzo77cSfbUyfnVKGmnp/NML6iyzxz4PgFRoPckFpr3VdjGYV7NJ8On7601YeC5JHbZkH2L0wHVGzDJsmVbuU/C2tSlFmYwOioeVaSNqx5llC0Lo7UX33e/NAX++Q95ADcPkl6Fox3fWq6HhS4JFntnmqqZRWtJzB5ELxjABTmCMb4wK3I5hsxkLVXd4m+X8km2ZSWC4GtYGl75UFZnZ8P60Z8PE6M7TqRSNzAgop02RboWB8Rgt1j+I5plPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3J4uvkJubDd6mP4kF6UbC9SOrKcmxX9rDkLrtZiFkRA=;
 b=ehRXTu5i5bM19QbKlyibE80DIB4TVynfv3f3Sm0eoh9YHqUgfq9wEm3RHnlEiemS4cKwSsbCU/OHuAAXghKWz0Cl/CBLewVdJOuaeqMWWBDhERMSTGPjEWPjSJBJXKdhmAPBW+UanZaWZkfIF802y6fqClbJcjdN4JyF4nXxNeZXn9qa4/dxEIhFqZuKyr2UQt/rVrnnWHPF8j/b+XAXwoysCL53I6Xi5e2dqbY3mgXlbCqRs4p0T5lAKEEm5310eyMRuHHT0fIZMyYbrfc6CVkWiU5FjL2mn+2Wq5UQ1lMktFuYkotNnAhFwKB9bGnR7d4pKeSTiHH1RMc8b5zc+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3J4uvkJubDd6mP4kF6UbC9SOrKcmxX9rDkLrtZiFkRA=;
 b=dfEAPehRZ+QYBHsrXsTGCeroVtkoXGXNSx8TrFZ+3TRXC15XB2bkT+UkCFGpp6dPUUp9D2zinP+CdYOtESWIjMj5ccLki4ldPaB7VmRZ612sTaeKHtOOwHOphoMDS5Ml1Xj+SMmA9BOFac2d17KjTLYpWt/tnxIVZeQZZZLBeW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5978.namprd13.prod.outlook.com (2603:10b6:8:47::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:20:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:20:59 +0000
Date: Fri, 19 May 2023 15:20:52 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"linyunsheng@huawei.com" <linyunsheng@huawei.com>,
	Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
	Geethasowjanya Akula <gakula@marvell.com>,
	Srujana Challa <schalla@marvell.com>,
	Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: Re: [PATCH net-next v3] octeontx2-pf: Add support for page pool
Message-ID: <ZGd3tNs4F2OSehFa@corigine.com>
References: <20230519071352.3967986-1-rkannoth@marvell.com>
 <ZGdJRMfuXHnvVQy9@corigine.com>
 <MWHPR1801MB1918D77C6C6A87F09BC5EDA1D37C9@MWHPR1801MB1918.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR1801MB1918D77C6C6A87F09BC5EDA1D37C9@MWHPR1801MB1918.namprd18.prod.outlook.com>
X-ClientProxiedBy: AS4P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d907ec-f343-4fa3-5c8a-08db586be287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OOpuDG0gwNwjEC0ytqq3/Amxq0MflvmAuKe8j+QvUvbEDmbYdpU0KJxymHVdguOBkFWJp1YJQ3AeKk5CbgPuR0GmH4mcLTGtw5qhmScw3E3XnW3aknvYRNo8ZqR1W1Kn01H/pL8HRHp3S1cyDhQSX4TVCcYG+XfZB1tivTTKbO1cZyuD/8rb90yvUXCQdaz3XFWaGh5V1hv5vybktUg+F15pX/ZvArWfXKDNrWLbqniaAnW8beb7SG48NuMCHAs9OSgUyybt7ckUq41TFNZxxuosDqPrsoK9PcGmUSN9AChWMEwsXsHFL3gOz1nFZVhbabvCPL6DlPgxhVJ20lfqmzD6CvNMZkAPdxRbxnz0eb/PYUaJTOLn8VZ1PKiLG4mAOZc8UztRfDjDIhQ35XSigV1p9X74pUL8cmzvYRBSThPOLVQ6yQco+JAZSOv+pjZbrzlMuBxm7g5UC0FaIvxT9pkNGluKCJcJ0FXADolHulTxDtof8B9rXiWgiD1DZu5LiqmVakhJhtS8iEVJ8TlPxJjS3b8i+Y9zbrc7CJzt6InjytHLpehvEIkt7WwLlZYixGa6Cbcs0rjb+te4gRVdGtzvmB+OYfvkKBl9aqcxReQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39840400004)(376002)(346002)(451199021)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001)(54906003)(316002)(86362001)(36756003)(83380400001)(6506007)(2616005)(186003)(6512007)(53546011)(5660300002)(7416002)(8676002)(8936002)(44832011)(6666004)(2906002)(6486002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NZtYkBE72nVl2WQIjYop8Sg/Bpc9ifgfcu/Jo3yNXgkAjMvLtSLC17NLpeJn?=
 =?us-ascii?Q?8LKkn5SN5j2EwIyUJo8TbTdm8UJkfW701rnym6EsoHXW7MunEBTAS3d8ouWV?=
 =?us-ascii?Q?aZGgOM/9T3gPOQo4RSpraKm6nK1KNFwMB9GCMdYCIlh7+Qal7g8QqAvv31/M?=
 =?us-ascii?Q?YMML/ljMsX7rmDEuWo/mJGjxhtg+tsKfiMmaYSYYDbdtBhIHhVJpVuKnofok?=
 =?us-ascii?Q?vzVwf9VV4cfgmzlybjMRTZlMOlR4zB9LIZvb2ySEO2eUVFCHUgU/EqcK+ZX/?=
 =?us-ascii?Q?j8ajAI0WKh+C4gt6XdsLjb9DkuvNgVj98g8H4gri17LZHyK+Uqv/LbQxbBsy?=
 =?us-ascii?Q?63z33NeA1JUR/hLDepeDQO3b2iz8AiRUedJpIHS9pDJGS0TW6P8Hfy6fkp56?=
 =?us-ascii?Q?O63UQDGqnN63LXaXRUfQpa68pbnfpm5bH+uEO9+be8N+3X5zDzuc1f1Itk26?=
 =?us-ascii?Q?icgAeO/iewvxf4MF9IWDhPyC1rK80UH/Y+TKZ9PRxeMBhxOhKY+t01qWPmGn?=
 =?us-ascii?Q?Ob/bp5juImm4cq9TfY8KczBSpTVAF1uQ/oZ/UmUYBNiBVrwznzwlOY1Bs32a?=
 =?us-ascii?Q?xkFxCk34My214oCDKVU7+EO/binjVgCNSwuEldme3fXwHVfJfmQKteL0xFTy?=
 =?us-ascii?Q?bCspDnU73YzOeQDHndp1Nruc19BTUK9d4/mOifx13PXrNDGdGVZUC7saEin6?=
 =?us-ascii?Q?/ZnuBYW+yMVEmz3vt8fXnpoPa2sEb/rdBFm4u3Wse2kxVMDWuQ2FeAm0EAoH?=
 =?us-ascii?Q?7VrdyiBbFL5WZGXQQ7sCJTv/c727VSQflapmHcpg1hjSlozLGbI3V+YeRBSf?=
 =?us-ascii?Q?Eu1/zuOKJLHWqytTd2ql0GIEaEAhkYK4SiCkcnbydwxIBXN54mNRCbKG2PRg?=
 =?us-ascii?Q?6OWpdcDQkj9hBEVfChmB+cyStjS+IQ5YedROI1+nbqIqCwzrIONuxa+pgf3c?=
 =?us-ascii?Q?G05jpm6I5oUiNF8G98lu57CoCNtqPOzAwCUy4nejSo0Rb7PTVpTXg6zPIi7v?=
 =?us-ascii?Q?fjVHxwo257YB3CP1qft0OZDeE4vTmaG12+IJO+vlCVi7M0EfGCiK0I8snrPG?=
 =?us-ascii?Q?ZdxaJAXsHU/mIfx44x0R/Zli/UOUYGGz1POoGuF9NxrDvZKJvVw6r7i5S+ou?=
 =?us-ascii?Q?UmCA5NOsi7hPWqG2x2KOurnPqaQdgtd6C/DQNOBnQCqs4MJad86L2zDgbrDj?=
 =?us-ascii?Q?R8FVBpHV6k5wsTW5gWJ12/dfAN4fv2635FQEJjz4CvgJ+F6J65kbVDQicIV5?=
 =?us-ascii?Q?HiHmVrvIKYAmGEfXAwlAPm7BW+7RbP4LbKFV6COMU9QaQSBEHu7zQHg0l87/?=
 =?us-ascii?Q?66S8P1I/Bftz9q+J+KI78BDIhla+3HIJvCjf48C9mgs+CfdM0ZFcZol9A5g7?=
 =?us-ascii?Q?OCbPGodGwaZDk3HwnwRYRZhZ81x/P7jaTzNJ7BwuXfrHzjG//wys4f0nii9i?=
 =?us-ascii?Q?RHMSsQNUKjTiQvP5aeaL477fvfDrBDcqcgAB0kv7t+M3PmipQAxe7mJudKg7?=
 =?us-ascii?Q?HE5GhLKcd8ga+Zc0GxH0sJUSwP4zWnskBO9eezlyGtNAKzao2K4p9cGs5gEm?=
 =?us-ascii?Q?Ei7SZIwss+wMtq3Lb/7dKlNxCc5mpiQwHu8F8/5qWqNpk64vpaeDD/EpWZCp?=
 =?us-ascii?Q?8o1EdXBnJhwx4lJXZ+aQrLyXW9Vx/FWSNKKVfn4soR7p7sf4HiDI7/fDd4om?=
 =?us-ascii?Q?eUUu3Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d907ec-f343-4fa3-5c8a-08db586be287
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:20:58.9516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5g8m3+P9sU1Npvr8sMVB35903xBGcKkuDc9z1ZWI8p5awbhCp3ISFDXSwPzlvydaXgeFo3ze5Ng64OySrtCFh5mMh8SleWFJFC7KmwWKmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5978
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:21:44AM +0000, Ratheesh Kannoth wrote:
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Friday, May 19, 2023 3:33 PM
> > To: Ratheesh Kannoth <rkannoth@marvell.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri
> > Goutham <sgoutham@marvell.com>; davem@davemloft.net;
> > edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> > linyunsheng@huawei.com; Subbaraya Sundeep Bhatta
> > <sbhatta@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> > Srujana Challa <schalla@marvell.com>; Hariprasad Kelam
> > <hkelam@marvell.com>
> > Subject: [EXT] Re: [PATCH net-next v3] octeontx2-pf: Add support for page
> > pool
> > 
> > External Email
> > 
> > ----------------------------------------------------------------------
> > On Fri, May 19, 2023 at 12:43:52PM +0530, Ratheesh Kannoth wrote:
> > > Page pool for each rx queue enhance rx side performance by reclaiming
> > > buffers back to each queue specific pool. DMA mapping is done only for
> > > first allocation of buffers.
> > > As subsequent buffers allocation avoid DMA mapping, it results in
> > > performance improvement.
> > >
> > > Image        |  Performance
> > > ------------ | ------------
> > > Vannila      |   3Mpps
> > >              |
> > > with this    |   42Mpps
> > > change	     |
> > > ---------------------------
> > >
> > > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > 
> > ...
> > 
> > > @@ -1205,10 +1226,28 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
> > >  	}
> > >  }
> > >
> > > +void otx2_free_bufs(struct otx2_nic *pfvf, struct otx2_pool *pool,
> > > +		    u64 iova, int size)
> > > +{
> > > +	u64 pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
> > > +	struct page *page = virt_to_head_page(phys_to_virt(pa));
> > 
> > nit: please arrange local variables in networking code in reverse xmas tree
> >      order - longest line to shortest.
> Variable "pa" is used in second line.  Are you suggesting to defer assignment later; and only declare variables here in reverse xmas tree style ? 

Yes, that is my suggestion.

