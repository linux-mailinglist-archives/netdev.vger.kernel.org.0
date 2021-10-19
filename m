Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E59433F38
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbhJSTZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:25:45 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:26913
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230432AbhJSTZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:25:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jITP9TEPH8bzEe0hqqDEXCwMXkdqyhplZMMaTHnNO+WOHh3Zhp9cqQ34g1TMGMagS5QH4PuJHB0sQp+hBGCs1Egyvc5N/8jZ3dN55uhgwUVFdguHq7mke3ITqkQ2TemzK8E2a/0cs8LKxxW6T80vxqyxTjja+JLmrIIVS5irRHsdmwD7rsZVQlfrbV16F6O55RN3E/B1ZCUJ6L+6aVQY+jx9kbYzFgwAsiKNM0oZ4QNs7kVPnCNb1Iy6JIf/Mlsltf4b7E9Zsl0XUX+8S6cUXva0Zo/DrHEaBY3gCkCGULUMLKKnGlw3WP/5KD2Tgn69m+ywgEwmlCR+/jQIaUc8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZiet93y2Ewa/PJvh+Wx/7C90B6eq0e4ydr6jOUOGdg=;
 b=L+LW0/h4sq5T62n3VDJhtHzG8TVysy3NbLLAe5L579Nul3RIaqls+k2qJWU4t8HsdLxhx/fpREf/UzNdG6ue4Vk5O9Adbf3dcnqGDz4T3Vxm7MTeoZ/Q0ANdiOUgd3W+PdNCgL8wDDDBXGlzcS1O3ZWQn0YPkNoQHnWJ93M4yWfqV+j3I8qv9KOsO03ulISylixnmaG9z43goLpzmFVKqVwb0bwhKd2tweV/xJq5xtXnOs3IQ3cZs/60WR9z0cgSorHlseYvw25TISQJfZxs18rTQZ5K7inWfLn1XLdJDiw1RPzgXhitzu1hVwPYw8fzI0cwh96yI7TnvUg93vLCxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZiet93y2Ewa/PJvh+Wx/7C90B6eq0e4ydr6jOUOGdg=;
 b=HgIz5sK9rdWW5VH9uwjvKDqaXpv/GR8Up1XHTXfvwgHpRE2lb9ScP8Wb88njlQK36LEZKWBF/arXEP55/WYQ5/Tp4Dhb97Oh9ttut23yvHdXs06HowhJoK+RBAUdRM4NsrD/uI56hCSpjI5osoHWhbENh646iriCRlmXjIG2ZupEYZPfgushxv2O9laiJqeXzpJAyQq7v40tyQOnknnYy/Xn4zEqtzSHCJov8LkYt3+5UmPWSKpXj+DzAIjWFArHYHFiB7Afyb+3PG/Yz3uHBVNmlyKw9OHSimBTeMKmfzo9Zv2nXL/iNph+yQp2Tyq6XOutzM3pTYuQ5A/ZcfIPVQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 19:23:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.015; Tue, 19 Oct 2021
 19:23:29 +0000
Date:   Tue, 19 Oct 2021 16:23:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211019192328.GZ2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019124352.74c3b6ba.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0064.prod.exchangelabs.com (2603:10b6:208:23f::33)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0064.prod.exchangelabs.com (2603:10b6:208:23f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 19:23:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcuhs-00H5hn-5J; Tue, 19 Oct 2021 16:23:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f827f130-aba6-493d-74f4-08d99335ee4a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB514292C084C89DE39FAB649AC2BD9@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxc5r8yHfsyzlGeCxLysQcQ0lIDIy3u/vKwlOsl8oCqvD7vuY+W8/ugUNztPQPDIpgiMw5FALVMFYSCgVu4kmkxD1iK5NsUYVmf96Mz7fNXfXfTC46t+XySv4Uk0j569z27QAGWYUZRVdh02b8XybOrYM2y523L9ei9bGR83XIrEcTqxI/y84Jw+h5LgzTN/EkPjYbVQxFowSut5PLv86rqAPdMHod2ZoLFEypmIjNAlP3D1pLkBGl348Rlzw3UoaFFDXTP1SVHQaTZcRhJuulbkdgfiiaavNMfTnUte3DYMnObCoQX6dJ6qFITeDgUlV/cxyhinOjtlOAJA0aDaRrGjpXuocR9XLck6nCmvEr1dmMOoiQ+CDTJ6wEqVE2O+XOI9/iim6cgaGY5DX30wxfOQz3cJFpGH567VbzNMqQBOh4MEeb/Gl9sx7jgOrj/4SaC55phlizg0ZaUAPaVvCPSuosU/m4EPjORW4QCEyRMt6nebXZGtFbT+osy1Dz3jXnycEg1TvGqlrcCFAW8Rl9yo7vqCUF2IAPGIYCwySPlNuvgy3WUy65o+H2MnRt7QfMHosC7BRBmWtn1ZEOjn2zLoge/EZey0VTdpf4cL+1U6uobIc6DHIghF6NWVEHUvtWG7GXyi7L+c0T33ZsWBOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9786002)(9746002)(8676002)(107886003)(2616005)(1076003)(36756003)(26005)(86362001)(2906002)(66556008)(8936002)(316002)(66946007)(508600001)(186003)(6916009)(66476007)(426003)(33656002)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jaBmu1/6GtTY6QTMSqQ4WQNYrt6sHzQJUGp21b83C9JFtMIRmBhCs/VaaKOu?=
 =?us-ascii?Q?XfBzyXrXJZFwtPAv1vmMyxw0dGKC+gvXdzYF4LHmbnd461ZVjbjENSVBCuax?=
 =?us-ascii?Q?X9BkZ7b5k9F4UHLOM8F34gWt2YZf8qPGJIWAikzPTi+M6bdANh9/z3hi0JbE?=
 =?us-ascii?Q?0QNoOHMraAm6N4jSNVHbv7OpUb+8p/f62KWCuqvuy01m8mChbg3Elo29zhOT?=
 =?us-ascii?Q?uh/PkgX6wgrWSelazzDZ0jmnMUOjq16DsK9vU3TKr0k6yuAdin65Q0uxCXBL?=
 =?us-ascii?Q?MSDiIUz8+0VUKIy/gfiU0FwqSd3EqEXzHCISa8Fp6w04VtBSAd+5twedFhwc?=
 =?us-ascii?Q?SlBOY+8PCTmbWnCFiF5Vzr7q1cGc+sG9EYr9XhxvCiBd+ZcctuzyBm7t6tNi?=
 =?us-ascii?Q?R9bdGrF+swMURz5A/vUxH38VuuOR2sN7gTqgp26GjKnbQBjIgsvvVXU7FL+t?=
 =?us-ascii?Q?VuUgGLMaPRZL7O5GPfT8AeWtvAGxw3KNn4uRFL+Xsl1n2DzehJCV0JDHDWpC?=
 =?us-ascii?Q?8afY85nh4S+wCXV6XQZIN+804yNHTgJE5RMHbWEwBBFWk4A3T6CssodTNM9d?=
 =?us-ascii?Q?1QRfWIhpo0eGzR1kkRjp+pWP+u45Z4aTuyO6Orv8AdpHZzVfp62YvJI508nZ?=
 =?us-ascii?Q?0lkPIeUHCxgtBM6xshqrBdXREBmMc2ozJtKWGWQizNao89uHh5GfnlNXxdxj?=
 =?us-ascii?Q?IykOsPJMRmT9hLrI/blbi0hIp/l+E98d+elRHmrU4CjA3dXJIpS0PSTqoLXa?=
 =?us-ascii?Q?azI/aJWh+DQDh+QF9pBL4KqlO94gEFwl+S5L0qYaYpgCRTWRMWeimBKbISES?=
 =?us-ascii?Q?i5j3Plhaoezrl7rbHXCeDe3U3eLZ6RP7kjfoQzVtcecG20ltAK+s7oX1bbt1?=
 =?us-ascii?Q?sn2I8+6Xei5FAuyTaFu3CJLMi5U+mQJxQ/oL+DJMvl1eALg3EG7TGj2z+txw?=
 =?us-ascii?Q?7yLy9fmsVJ57Vyub4n4I0PKTvPLDIjZ07i5zdeCpfPK4i2UhwS55Ffvk02wP?=
 =?us-ascii?Q?cpIResESbLx972xnX3v9ULPr69Sm4sXgfCuwfrnA3/lkLKBGSJT7bnhNQHOC?=
 =?us-ascii?Q?9UE+AyNDJOuT46lLdR1MpChtrta4yoNpNtcqnjAQtU1lt+esL6LCjCfKztGq?=
 =?us-ascii?Q?VLeqe+xAxwYfcHFwACtMzguprxZPiM2Qgh+sAWfvN0UG/2DFUciFTbisBF7q?=
 =?us-ascii?Q?Fh4jExRUKQDmzszzZhx+gDlOeiVJ2tt50KkWzft4tYCuhfxgx+deuhp201F8?=
 =?us-ascii?Q?ZddMwJAjPyf8Axtxndi4doqn6LlYKc+nPl5U7FLdc7coRvVTcQb+E0nyuhtq?=
 =?us-ascii?Q?p8afwv9nYlbFbBCwM5LbQY4LKL94QwiqCstnYOK1ZS2NRg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f827f130-aba6-493d-74f4-08d99335ee4a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 19:23:29.1028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 12:43:52PM -0600, Alex Williamson wrote:
> > +	/* Running switches on */
> > +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RUNNING) &&
> > +	    (state & VFIO_DEVICE_STATE_RUNNING)) {
> > +		ret = mlx5vf_pci_unfreeze_device(mvdev);
> > +		if (ret)
> > +			return ret;
> > +		ret = mlx5vf_pci_unquiesce_device(mvdev);
> > +		if (ret) {
> > +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> > +			return ret;
> > +		}
> > +	}
> 
> Per previous discussion, I understand that freeze and quiesce are
> loosely stop-responding-to-dma and stop-sending-dma, respectively.
> Once we're quiesced and frozen, device state doesn't change.  What are
> the implications to userspace that we don't expose a quiesce state
> (yet)?  I'm wondering if this needs to be resolved before we introduce
> our first in-tree user of the uAPI (and before QEMU support becomes
> non-experimental).  Thanks,

The prototype patch I saw added a 4th bit to the state which was
   1 == 'not dma initiating'
As you suggested I think a cap bit someplace should be defined if the
driver supports the 4th bit.

Otherwise, I think it is backwards compatible, the new logic would be
two ifs

 if ((flipped & STATE_NDMA) &&
      (flipped & (STATE_NDMA | STATE_RUNNING)) == STATE_NDMA | STATE_RUNNING)
      mlx5vf_pci _quiesce_device()

 [..]

 if ((flipped == (STATE_NDMA)) &&
      (flipped & (STATE_NDMA | STATE_RUNNING)) == STATE_RUNNING)
      mlx5vf_pci_unquiesce_device()

Sequenced before/after the other calls to quiesce_device

So if userspace doesn't use it then the same driver behavior is kept,
as it never sees STATE_NDMA flip

Asking for STATE_NDMA !STATE_RUNNING is just ignored because !RUNNING
already implies NDMA

.. and some optimization of the logic to avoid duplicated work

Jason
