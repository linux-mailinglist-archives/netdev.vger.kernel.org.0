Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F09E66DEE0
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjAQNai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjAQNad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:30:33 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2043.outbound.protection.outlook.com [40.107.212.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8135739B84;
        Tue, 17 Jan 2023 05:30:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCvEnLw5KG0qDzBl9xERUBBu7fCC7dpVHSWEMQcx8ACCW0kF0wrer7gfG7dBgr8WNiFJyW1XnX2DvAIpKERyCBgWJyGO8BX5k1fm5bJsehNwMBx9qd+yhsT8az3NNtHNKrvtyg43Wfw7yHIQZSLuU1AUUKnMrEWZJ38sGNNoj3KsGGP+smZKDAa0c1qBHFYv/5m+2DRwp5r9vX1DyfsXs4GioT5Wd4uZc5w9yPSeybRALNi1oOewZY1rAHDIkwKjnq3UkUM9pUsEb46loNSzZvm6sHIXMWdxaAVB7FtT9qlVsEwRu1sR4lehUyceMamow7FozK/vWo6mypW/EaHyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsytL9wJ1VxKzILKFyD+VW4nBBi6uFgymaKFp2fLMIY=;
 b=UAFYxHTcCYE65PkbZp1MuZkFw17MYwtMm0c6Ovjkv4+iAb67ejtp5pkE2rDu9xoti6xfIQeTE0unJ2pXUJ5jv/4zQBAi/y2N00un7tOi9/n/3vN79I2X8hf88elZa99E4+AmMeglJDH1HmqLCdTsupV3ZESmB60kDumn6+YVZamAH5oPfsRAANcZuaO7RPGIqlegPx4ldesW83hSIon/sXgE4+evkUelIrpRm4A8C0UVuBqYtXmupht1dad0wEvEidL3JoOLCtkU8neHBZ5jZ4GbaVK/5bD+W6Yf2QAINMM3lgdE8bso8V7YroX1yS4orz7sPNvSW0UUEmm5RHzqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsytL9wJ1VxKzILKFyD+VW4nBBi6uFgymaKFp2fLMIY=;
 b=RCtKIaIpQvvAq8yUs0er0TZJb7VFNDBPkjutc3/CaRv4syn/aRLJCdJ0tKBNDKpAM2BaJaazxor7f4P/AfCuW5DeS2f4xy4rf2fbRBiXGJHcHeyTfAE/lgyxr1VFEjhLvUUIepQBgOxOC8QA+qCI7f0raoseRFc5Oq51nMkwHX33gK/3cBSUsi1vufGdr9iUq0No58TdsbXH83aF/auAhV6EBZzBAu0r4OgR+4fk5s6vtkbrwGQKrQKLWvIz6m+h3DStncYE5sOcPq5rW+rlLoPNsHt3fpLkUSZw93P4tUtSRbgGNwdme8RrMKu7bkiGQyFz+zL8AnGf0srXDLa3yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7754.namprd12.prod.outlook.com (2603:10b6:930:86::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 13:30:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 13:30:27 +0000
Date:   Tue, 17 Jan 2023 09:30:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 6/8] iommu/intel: Add a gfp parameter to
 alloc_pgtable_page()
Message-ID: <Y8ai8i2FpW4CuAX6@nvidia.com>
References: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <6-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <BN9PR11MB5276A8193DE752CA8D8D89928CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A8193DE752CA8D8D89928CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:160::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 99078ce9-5e35-490b-7427-08daf88eff02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qypHGm+neClz/zCECh7tGdQmWpptWD+l4XdJqhvfOpSgMH12xabqMVBLI99fytEZzQQaftQKOFf1EK/U5AQJF5HrQ4mlxQNNnR25+1njD5gN2kyD1ZGoKunpm/OlmKAI9922VnMle0Ke0brer3GNTMoWY4YRjpghiw362Hb/Gs7xl9qvOWRt0g8r88xnMZso31AMBjfWO4+nN9ccIvW693ZWtB1ptXc/D6eoSL/kn4jP/OZgiQyehowKBaQ6XcmVIdXRWjmT4eVny7ta51BSTvKS/1mil7a0EBncuWBDb6mM/JFkEEsseUgdeh0zMvSGmmYk7MS5Yum6zfiBBFftkW5o509mbIDOKUyrNa1EsrlJZY5NIWvzyxWQiC7uIWetgNQf47ea6NntJ6IBoOkWfYI//6h626m14YFZVb5KcaUPKjRQdDLwC9BD00g6pS8plsPajjMYKuq6YQONg8A3exTK6q+p3R5VfWT5GZOq9Zmy2QiNUBA9KxJMIxmz10L8lxS6vbP+7Q+rABwmcC4peys0+TDY+KjB2iaqgbYVro89/FU5I5BYxV4DcpLLlX6rcf4ZV0u2+ubvAOiMJ5CGRMCi5y78Vnr1QPiGl/lKbwqH5cfNPutNlQGpdMT3ccfn/wfJaUWXyJRO+F1fPrexWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199015)(38100700002)(86362001)(7416002)(4744005)(5660300002)(2906002)(8936002)(8676002)(6916009)(4326008)(66476007)(66946007)(66556008)(41300700001)(6512007)(6506007)(186003)(26005)(2616005)(54906003)(316002)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Daxf/0fWTX+SCv/ujbQEaECMLH7OWG5pBEqH1XbO8LdCXrJ+9g1UxY4oVmDW?=
 =?us-ascii?Q?oDWFT606eG7IUvRqbT3TMYUs6w9qXnUyTdMLR5VgWyxIsNfDBof+aFeS0A82?=
 =?us-ascii?Q?/4FFu+QzAi5vRTCCcNk/VRbftPdPggBMV+sjbnc+8TTSyTOzWV2AT5K6fRyw?=
 =?us-ascii?Q?SOO96h7nwzpQceiUyl7DLA+thBhNURe4hvyWF8ayvH9h1kH6zJQeEqOPMod7?=
 =?us-ascii?Q?8SIEsIv3kbJGhHzi8IsrM8UFHVoC714axnHvWlMWnnVL+8dmg3nn/UCzfNpz?=
 =?us-ascii?Q?zXfXG6H+ssCBg6mPavWtqPWMNAoFKju7GwfWUGx9CRIGvTvzXiOqcPg0s5+8?=
 =?us-ascii?Q?SFc1hmHg73h+jVadfZpUIHGn+LmSmC5MEAFCe9w0eJnpTVX/03ixBM1evGbz?=
 =?us-ascii?Q?dm9K69SbcEntjGVUhCvJ8wtQYB93wpS/ffXEhA1OcdXGcQqR86GCQ9RchKsl?=
 =?us-ascii?Q?ZIUIHFGl7BhWW7Jg2pugkTffMn6UGLeX+WL6nmVI0Qwmtg13eXxW/P0mWzsA?=
 =?us-ascii?Q?wq6Xf4X532yRYs1B4GnlIug9qJbDQVMnmnLwpJroUg0FVhkzhYloCnm1tm1C?=
 =?us-ascii?Q?47DBmjmA6dVWbi7t1qCPf7L4umv6NpwV/xx0yZZd2Ssj4zP477wgfKNkvg6m?=
 =?us-ascii?Q?K+3jkHS6B++H1QlhWL0oXojbiDkRZiRjFPuba8v8j0xxbX05z/LBTPwgBaVJ?=
 =?us-ascii?Q?peENjQpfG77ohMVE+xkCpwrOsnk0UAriWpCpQrk07Lj+ZU/KjrvyBx7h8CWI?=
 =?us-ascii?Q?foNU+vkhGu9yMEFZaorpCJK+J4rhHPCgVLJoZv3/Eqqocyt1uUTX1S+7N24u?=
 =?us-ascii?Q?e7fMMyLULiuXXNcM6R7hggE4o2tKuuzJz5dwwlS/wQXs76cvbaPBiMSguMZz?=
 =?us-ascii?Q?rHZKy/75MlpnUCotc4KDjwNgQIpBgKp38wl27wT4gvWzCSpDfrlbUYUxwj4C?=
 =?us-ascii?Q?S6JdseE4F+/zdSakSfdO+00QDoMjpgabYV10+QOlnNWJJcFvB3gOOOwA3NVn?=
 =?us-ascii?Q?maZTXykTApbjrB6O+tjJw0qaY8ilR1EGsuJB+SuuzRzt8AHF6niTiUUYBb+v?=
 =?us-ascii?Q?UHEO+bW07RFZy7jwhbzN28PIX6JPFjkzQhKOPvjp4ViBy1O/ZwEu6nQPUtb7?=
 =?us-ascii?Q?2WrcN+r/lxuMp1oUKtDWS2VGm3WBHbvHbzP6iIqhPL+G/n56DVhKw1gMFCdU?=
 =?us-ascii?Q?qZVqWjCkcUoSxLuz2WhYTU7zRe1n/nQzE6Y1Pl5CVBnK5xrJUeHrtG0CZOxl?=
 =?us-ascii?Q?BOMeRgB6moKW/AsJto8GALrJKzwzOcu03FsRPU03RB1TG8hAJdSq76tmBquH?=
 =?us-ascii?Q?2CiK4ef+DQuK1TlxwHmmrv9354y3VZVAW4nzUHtj6yD6qSk4Ah22Y+rjZqY2?=
 =?us-ascii?Q?b5Nmh8nU2jguxJxwxirX5Ul5nZuafXuiRr3iFKk1cdtb/vR4+6/SgYYVnV0p?=
 =?us-ascii?Q?FFrmTjRBMo26xFpd8f7bX78Oa7Vf8yxkdG83TX0bIfQKBUvGQGq8ovTiJUd3?=
 =?us-ascii?Q?p+EBmo3Y4Ot9EaBIbNgSdrOQdgJuqZ57YVEmUpTPlu7a+uq3hREZ2nN4Vy0x?=
 =?us-ascii?Q?IIgRw7Vf+odqVqPLgwavm78fdh1VuiTw69u2ZCto?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99078ce9-5e35-490b-7427-08daf88eff02
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 13:30:27.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiYEfeCnCtHWcIwHNEH8MCNG3yP0JSRqsOQvJVIFStgJg91AStEssh6QsPw5SbgL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7754
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 03:35:08AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, January 7, 2023 12:43 AM
> > 
> > @@ -2676,7 +2676,7 @@ static int copy_context_table(struct intel_iommu
> > *iommu,
> >  			if (!old_ce)
> >  				goto out;
> > 
> > -			new_ce = alloc_pgtable_page(iommu->node);
> > +			new_ce = alloc_pgtable_page(iommu->node,
> > GFP_KERNEL);
> 
> GFP_ATOMIC

Can't be:

			old_ce = memremap(old_ce_phys, PAGE_SIZE,
					MEMREMAP_WB);
			if (!old_ce)
				goto out;

			new_ce = alloc_pgtable_page(iommu->node, GFP_KERNEL);
			if (!new_ce)

memremap() is sleeping.

And the only caller is:

	ctxt_tbls = kcalloc(ctxt_table_entries, sizeof(void *), GFP_KERNEL);
	if (!ctxt_tbls)
		goto out_unmap;

	for (bus = 0; bus < 256; bus++) {
		ret = copy_context_table(iommu, &old_rt[bus],
					 ctxt_tbls, bus, ext);

Jason
