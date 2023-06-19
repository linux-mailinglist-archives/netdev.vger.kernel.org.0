Return-Path: <netdev+bounces-11962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA30735728
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5747F280F74
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7257D2E6;
	Mon, 19 Jun 2023 12:46:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93C8BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:46:52 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7D93;
	Mon, 19 Jun 2023 05:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2OV78lhkN9mApnh3t5I1Gprc0Hh9g6JcJzkhYXyKlLvT+9WHdmR1Um7sG0MQRUMAOo1f0wtcZZqAefksg0FwLS856C8PlbhEQbZi8+yRrgn6aG84sLvTjQ95DQjyL1ul2TykVnEFAmYy3HtSV9mfw/P9o2DW9IVVb6O7iTfpdkda35g0nv7xJ8FfvdktoGy1WZK1l5JGf6hlMXjPIEsLpPOB2EBDxmI6nUEpolZYdqjTIezrFrvYhtCqc+7wYCrU6QgvNHsmR+yLjvI5Rn4rGiOvK17r3fmXAoeEe6tEaI9XsIxuADyOexQ4TLNDQC7FY9r3q2Y/4D3WtuP7BBk9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xpgnp6H0C5Lo7lG2Vx1wIkjgN1u/5iiOPeFj52yn0tw=;
 b=NWEhHoRKbDSh7GmN+bASzzZ4cwP15Gg+S/H0NYWj8dL7pqv6kaSIlMWY0iCmmTD+r8ogrb4zhhWRnjoX1bEHRb2VdJnsGr9ikDyjtqnM9syxfmVgjpwVXk2UP09fT+uYKHxdF4Q7Aq6CwYZmjSC9wXV/w7FqXGkJW0C+bMzZObuYU8Cfw5Y0xKcwXz95QALxuar4jbb/g6vMgak7u/3FcE5Va/PkfoSPN1AStN9cLawGYK1KczNO+rBZ6AlwViJDva+k+KmLvx+b/AcwzZNkek7md7dP5VGmJzueMYvStfYLhLeok68QEaDwoV7qpFByJYC6kwYWRm8LhVBzvjqhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xpgnp6H0C5Lo7lG2Vx1wIkjgN1u/5iiOPeFj52yn0tw=;
 b=lGlbOoIr9bv3WVhgMloL4d+wNDLc8yAUXUYwOoaDNI15UDYTJAsaHoyi7dTKBqPIv6yacK9jt2Ro6GskR9yyNXijCcRU6sot/C4T+2zmddsOkPHZvVDpDbUNLpbo6FRdzf5W7lr/BXkFtfRuFtrVlO7iwfn9k3HLAn4AGDAuPsxozfZ0YPL7x3PH6wIkueMciC4ORtzqUqsTjsV1Vtlct7n/XvcTtPUPpA3hNjOPqkQT2BpQMAaHBhRKClZqj66TXR12ZXu6J76qqTPoto5a/2SAJ2kBZqno0UU4Jgyrbw0+A1DL7X08quKMxXDneMIDCs1e0pBhlFMF/6ltBOlGDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4958.namprd12.prod.outlook.com (2603:10b6:5:20a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 12:46:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 12:46:47 +0000
Date: Mon, 19 Jun 2023 09:46:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Brett Creeley <brett.creeley@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZJBONrx5LOgpTr1U@nvidia.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0178.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: dd61aae7-93c6-4eba-8e19-08db70c33ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V0Wgm2nwefjGUTRRdy5/djovFm33xHi4GTFk57kMjX8cTa12f8DNvPHUWgzr7Hd2xeyO/n6YJ43IUNK4rrJv219dYybmV8//JsewFU4oMj5qdySCzPYyF2Gf135dda7QuGxLcjfSRZx1vBXJVfXyyGxrJRO3HhqrD7m0GGWEL+tIx2Q9oAVGBilBuo+N0S1nKiHpWaEGQYKFy1hSmVuP0jSN++w8b/4d7Vew2eVayXl4RD6/xhA2wFu5XTcDjdbiGhMKKDxVG7fLGp8pWjL71UJ9w5GDJ6XmGnozRnSOTGM56R728zcXcU4bx0Say5OgrzQYdTDeCKOEvZAWnJvhAFbna5Sks0fNEpujc9o1td1A1qC02YoJhYPLp5MBq74TGe7VgguT9OX08IgwlPF4UacYmVtYi6dKNx3IBER5pQksbKNJKTJ+vFONoopMgiO+uezhkMsIf/4y9cy0Ighviwd8wMQDDDLzdOkdfUzWRbuKVW4B+TNEkd8QicxlN6QI2m9NX5U11AApcgYfI2ur++X78/h7w2CEPqADLZt2tpWz6K8qxp7hSOTO/MGeyrIY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(2906002)(66899021)(41300700001)(5660300002)(8676002)(8936002)(36756003)(83380400001)(86362001)(478600001)(26005)(6506007)(6512007)(186003)(54906003)(6486002)(66946007)(66476007)(66556008)(6916009)(4326008)(316002)(38100700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ouQdCaeg/vC4WpXO3Q7m7Q+lzk4cVAkJ7GPtnprdm/jgDayEIBJzVsMmYRmg?=
 =?us-ascii?Q?ewLK4+g6gK1Hq8tBSxYo7XD+aNeVVPIurmq4j2AbjQO6ZjUXtEuzBm9MH5pp?=
 =?us-ascii?Q?bUEsTKsSsCezJ4yvgCnlHVgncBF0dC86wu8igDawoUfuXj245hHS9gMeBTXY?=
 =?us-ascii?Q?a3XafiQOMcfNiDXIao3D1KMMRlbpPUXpEic4n/XUt6tzEoPxFs5h6j3Oc5Jr?=
 =?us-ascii?Q?WROfP0v15vw3npRbxquxxNFTFy+TlBlOBC58d6AeFPtGk/Ysf27b6RdQqe/G?=
 =?us-ascii?Q?61RakKxrMDCqV8t2ewHn6my17nDEoSmG5QUXSJEaZ8XHvF+kn0HDSWNNd2dF?=
 =?us-ascii?Q?oktTSpbFNGZZVtWwv6hd+voaZx8IJuJzx5QumfcYaV0g+DDJ26lJDJ0WlYyx?=
 =?us-ascii?Q?bQEyz6HimP/ecZ3mvq5YnXCEo5a/EmR44rdxQ7OmfR66+mxTtDku1l6WbQtn?=
 =?us-ascii?Q?fO+aZfUGTSmwitlHMpizTAZcXtwksF5fVR++lGKmhlrRDKZeGoXZ4Ik2EEsr?=
 =?us-ascii?Q?H+sKrE5wNUSUCfNwBNS9A95Wa63q6f/OPp8yvcAba88xw9g+RC94CBTO1SFd?=
 =?us-ascii?Q?VPo8sX2Mh5qFiKItBcJIqpuUlqfG6EJEiRghcZxsmLbTpBquviBPUiRWvp8p?=
 =?us-ascii?Q?Gz4iNAfRZDZjXGk/17ORo+5mgs7fXKau49m5NlGDu0Ny3T8QGPMWl8fjUzm6?=
 =?us-ascii?Q?r63cI+6tiLHAieWt8yDAWsgPKrIf0fnTbZzlJ30BQAMW06+j03F6+GKsvGNy?=
 =?us-ascii?Q?AKpdAACQ72ZP/96rL6bzi0dq/p+2GbqIIhmCPJNrA/Y1M71LP1YO37IwyeZr?=
 =?us-ascii?Q?E8+isVxJT7h1zGlgSgkp5OvzOgRkH1d7/0rH3lynZRa9i+675Of7GzUztoDd?=
 =?us-ascii?Q?LKh0LNKtonjT2wVrtj/Nzcodl+z0gUwFYtrhBrbOE4rL5azLZkUoRiOGjhv2?=
 =?us-ascii?Q?TYUlr2l3VUGu7/5jyR9iVYo/h37r8MK2ZMYO4LCUwHOOXEprpD+pNLtQn+s9?=
 =?us-ascii?Q?a8MJcr1gZ9f9Vo+DGgRIfvCAwkcZgd6NL7Dq5FLvlhqPxEwfy0kxejAg3FwD?=
 =?us-ascii?Q?vJ+jbPsq55LqBpHXArqrscplRvP9Wkahi0qcyH8BEROE0x7RTLs8h1/UmfBM?=
 =?us-ascii?Q?WbRNqgaNfYr0+yhR803c0ezI8z6Zv25wSvGZ2LkYo4PRSpW52wEZKzCI0nlX?=
 =?us-ascii?Q?0nkOdJaFnA+9jNLZbLsGQSbPaqaERKjEPA9iQpPJ0I/xpcdMHjj4kblLXDSL?=
 =?us-ascii?Q?9gjmFSvHLJ27FaaHEU7JZwSXGhzowTlMtahrZ9WK0hBentGSnwHK6JVVXQpK?=
 =?us-ascii?Q?8Aobz8dR5WqxapL+77QPJ/sW7ElQk7H7a308kkAYVfi7Bx8jYLsfmT48BZh4?=
 =?us-ascii?Q?4W9JMmURQRXj0NTj9eKTr8K1PjLjkEdUFUUnVzafyP5IEMRFsL3meYtQSTQY?=
 =?us-ascii?Q?6OzLIhvjn1F9TvII3ARh4h7W/z5uO6hjTpn8XpbRio0Be9OKEpdb18c4LcxM?=
 =?us-ascii?Q?A0mCaYy+szzYVBoia7CXUCI7MlIYxrVWpHc/R/BUfXdoX8uNt6QW7g/d+7i6?=
 =?us-ascii?Q?K7G67g+sm10ifimGZiQ0PxjCS0cWXRm2DY5693p6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd61aae7-93c6-4eba-8e19-08db70c33ea2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:46:47.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdmIYU2/RWFpCHP4CxhXk2VG0fxP5v+FSOfosKVXBReDLcNx0NYi3Q8v/c8VLeMw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4958
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 08:06:21AM +0000, Tian, Kevin wrote:

> Ideally the VMM has an estimation how long a VM can be paused based on
> SLA, to-be-migrated state size, available network bandwidth, etc. and that
> hint should be passed to the kernel so any state transition which may violate
> that expectation can fail quickly to break the migration process and put the
> VM back to the running state.
> 
> Jason/Shameer, is there similar concern in mlx/hisilicon drivers? 

It is handled through the vfio_device_feature_mig_data_size mechanism..

> > +	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next ==
> > VFIO_DEVICE_STATE_STOP)
> > +		return NULL;
> 
> I'm not sure whether P2P is actually supported here. By definition
> P2P means the device is stopped but still responds to p2p request
> from other devices. If you look at mlx example it uses different
> cmds between RUNNING->RUNNING_P2P and RUNNING_P2P->STOP.
> 
> But in your case seems you simply move what is required in STOP
> into P2P. Probably you can just remove the support of P2P like
> hisilicon does.

We want new devices to get their architecture right, they need to
support P2P. Didn't we talk about this already and Brett was going to
fix it?

Jason

