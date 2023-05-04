Return-Path: <netdev+bounces-321-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C545C6F7141
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73705280DCA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458B8BA43;
	Thu,  4 May 2023 17:40:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6DF7E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:40:35 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5446A42;
	Thu,  4 May 2023 10:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGquuqRJRMHi29fMo26Efk52KHMxX49VUJTPDXth11IybQouOcGVIeIQAwj7oIvOIxuROVR9nSeURQ8cajwi3fctqRc18RSTaybJMCQGojpoRokdz0ntsa0ftylbUHA30i2un5erqC4nWFnw5m6vBg9kvKlNDEEKxsfUjhLeVIbHJzWnmvqbglPiMu7DK4b7z04RB/471auz4gTHwwcU1ZmH5R728ty5c4+ZVIenmyv/q50T3sC38AFyVA9TOuupdU18QcV+xNcX0XmyUcOS4QwSD1ae00X46Vje9J56MzR+B0PAa8uV/jpkHYDPNvnlbaFNYNQZR4EqEBUVLi78Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnqLn848IXK9ft6RpCT/cDqVhX92BYo2EknnWfW1sXM=;
 b=cVrlRgP2LnJMw+87W36A2VQzQFhTu2577YGk/2BAQN1Byl0Jj0EivJG0sUZGBlBwO7hLEvTd/9d1cKnl96KcqLa52HqG0OvDwW9dC2WjErZmikZ0XNvNzBf+u7HmDMZWaXcBsIR8hUhkqoC0JzjidEEvt8u//hyAsPbdIN6F2U0UZkY2jp7LMIzWBuTi7559H0dd2I+DIrKlvRzSDCXa4lfAalUuVIb5hXQEO1gE0+BONAs9vPdnBNYz+yOXzX60QpD5fsCysnM2XsJ3NkGg3X7kMPVLO0QljjcCAK7URp31wUPvf/wtSrJrI9avskw5KPer42aBKOhbsLK1OojUAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnqLn848IXK9ft6RpCT/cDqVhX92BYo2EknnWfW1sXM=;
 b=XVv1h/cV+M8szOc/mHTHyKxYfn9yQTl6p14uhTAJmAFnefga3YwmzPuSpar+MBgw1naxXgzTyqGj0ao/BH+THKhq2B+AZOUGWXshFd4qd9FABobyZvG/R/B5SP7qdwmjI0Y4DKTI6JBZtfN1wsGnVCipmgMNrw2VDuK51bp/cM97e08t/+vhyjRgZnW1VT7cxleK+LBedF6LV/VT2rZwMVAMhJT2oLERYyhWaNXmaCqOR5ODHPI9DIMdi4FWFQoLM6CKhO8BQM1nx4RdB16IY5ieHbV2kJJ80inIf46SkH3BJPZaJnTQJrUs+tEvqsb0oLZG+nfK9g4jfv3LTg+f2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6675.namprd12.prod.outlook.com (2603:10b6:510:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Thu, 4 May
 2023 17:40:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 17:40:26 +0000
Date: Thu, 4 May 2023 14:40:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, alex.williamson@redhat.com,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Message-ID: <ZFPuB8+Kb0lvI/yx@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
 <20230422010642.60720-5-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422010642.60720-5-brett.creeley@amd.com>
X-ClientProxiedBy: BLAPR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:208:32a::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c112c4-9773-4ef0-65b3-08db4cc6a594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yUzOB815XOPCpM82NxJKKIvCg8jpdVsRpGNLpiGsBC1l0AVGC3QJuiRzFm8qdwZQsLIJDyIMjm6aRmUpLEPP+fMD1y8LFDalWLgPAs8ayf2NtAgT2t/iCjhHPmogbOVUs42+lBcQSXs9Pr+n1SeV5U50wfIzl1jHB7S0EO4oGBjaqF/WtN/LztartGuL+IeOv23dsBp6bugqt4vcC/0PPSzkN+E2i+N6MbOc6K4i2p1HOiBPggIYR7/LuEWQ9cqMFHQ6mwVOHtNDERmDvEbNRCZKotWAiVoOBD1/EyVexsGhjsV86qSQ6cLqj73JNYUbp0aQxcjesUr+VFjAhy//+jLfYu5Zu25fSkT+prS7McV0VHuWN+RajXMNLJl5BDj9dITYD86lLBaV9EuFtuXVDnuCV2HeFMFzdKFPl3lylwsWvqXafxqZJdon/dt1XCziQsWFNyw0ZZQbE869VnoTYkLnFMT2po+Jx4jeddaz6tjMyixR8IW/8DFvdTgMnyM3AjKhljb1czqL5QYvEcHdjonyHbHyjHSPmWSVow5VCzDkVJPDLlIW6BbMg1SqlIY3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199021)(6506007)(6512007)(8676002)(26005)(8936002)(5660300002)(186003)(2616005)(83380400001)(316002)(36756003)(86362001)(4326008)(478600001)(66946007)(66556008)(66476007)(6916009)(41300700001)(6486002)(6666004)(38100700002)(66899021)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4/Xi7weNhdoGSZ8JQE6glmS9vvKgcxF4C2vIetxgqCwweEIXkp+O51lOw103?=
 =?us-ascii?Q?KzZ2wwkrPmtgiTilTnCoL1FznPCwnjLqjk3nKuxnhWhK1Wt8kYiK02q0Kwyj?=
 =?us-ascii?Q?BpBxExRhp8BOGOIQR81fAGN2sOYWkuD2s+s14if7BdrjelM43lfuGI8/dWz8?=
 =?us-ascii?Q?ntKn+E9+U910Ic6dhXjB6P860t3hBp9S42H90grCwl3MsGV7uEkjvkOtcN/r?=
 =?us-ascii?Q?DZYwWzPNGqHgEHDa5XeJMVc6DQPAqoF25z01iFjHZ90WbaV9acnYbMVn1fVZ?=
 =?us-ascii?Q?0D18wgViyJWPdO3oSFseZcx82sSumuMmI2o/Pn65FDkF3n4KQy6fuLWxxixu?=
 =?us-ascii?Q?S5GlhlRew9LeF4UudkRWDV9k05eMBb+WT+k3quuEpZhzVrLx+j62Roj/KUYD?=
 =?us-ascii?Q?wzgi8CwkxOExoQIaXCQtuzy/MS5fvPrwIHL+FiJTRkDwpze/vDXjUF+GCQNh?=
 =?us-ascii?Q?efjK3ev2PUhwxWRcEufU+rAE1kgONSMG6A1D7p0zliVwBo49WvTd+k9bVZfJ?=
 =?us-ascii?Q?cwahFtrMcts0so2Zv+Lc4VoIM8Q1RBJcr3QIiuGhvAARXrRnJPr9ocgpG87Q?=
 =?us-ascii?Q?JqdD2ZFPd05btw1oE6lzmFUFEJ22ScPBEKsveVQJyI4VcQXiAUWn9lEAbYnK?=
 =?us-ascii?Q?pV6gpX9pc21PAOhzTXbwqk2oaD9z4vUFbYR3z6BnINlVuiaLftNxg8knc5+Z?=
 =?us-ascii?Q?JBJq0iWoEqCYDnuFqhAD7syg0vcdQH3Uz/WEt/LruW8d7qfIYEhL36Px5wc8?=
 =?us-ascii?Q?Vzd9BBRVVyQd7fi0kXhA5PSiEkH5Q9La7sI1C4HZsRPHrTe+oWNaT0L0JznY?=
 =?us-ascii?Q?Mw2NeUpWSALcKsW744lh2gZwJ4fr6RMScS8N0l7MNvM7vIWc+p3OHjp3iUyt?=
 =?us-ascii?Q?d9pP0uJReHS2XrVhHaqBYjiXbt1LrTyXBhlhG14HjOzTsGP1FHff7HNTMxpd?=
 =?us-ascii?Q?aOJvueJtzqVZPRNin3EcJnDQacY+7Z0hoEV5Bph/cU1oS9UiRHK5G3FeVWbL?=
 =?us-ascii?Q?CC6qhJaQAcgoL7Nu5OWXEZblhFXrNohTz4Rl5NDlow1xe2gN+/Oc5NVcaSDh?=
 =?us-ascii?Q?kgxnkfKVbMf8i3Dz+ClexwU938Pm+YOLvXdJsYm0945UUYirZV+j5SG5rqjz?=
 =?us-ascii?Q?BfCRIWLQMfQfE8qXas1rBtvrHbTdCQa9x+Fu5rPDYhllZZ96Rw2HB3Ikq52l?=
 =?us-ascii?Q?Tue1ru5k8mx0idrFwjihggL3s/KX2bfGeGQX2lmjYnEbhi8MLLWudA9QPPBx?=
 =?us-ascii?Q?kC/5E8YtSO6nUYkc08pE8nRblO420k6U0WBQuWXKQZqT19DiUn0Yzs0jUbgs?=
 =?us-ascii?Q?vLKCodWEvoLrO1CWvGrHtwC+aByocWaKlY3SvYDg7MDjRmekMIQzSE5hyUrC?=
 =?us-ascii?Q?E4paLrr3PfaYUhwb47HdxrTGvyGEFQYNHLM+iUnpj0flhLhJzs+/kQBTw1bx?=
 =?us-ascii?Q?NJwufhiZU6kR7SSz/5SgtpNG5Wez8IdWObpCsAmzvbDkYrUgPo13zIFCpY3y?=
 =?us-ascii?Q?iB3vBSYYW13ym4aCG2Cq9Xn0cqzyreI3SGCkdiqyOPBnLbvTaCRgel3XMfrG?=
 =?us-ascii?Q?i8ta9qwjtHAJkVz3zF20G5BZUuACBmc062ndxcn2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c112c4-9773-4ef0-65b3-08db4cc6a594
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 17:40:26.9471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1nv2mon/QDgUxynqWGsf1D3Ssx5xtKz5Cs3ZyScbWxaVkbl9w+4yrTLE3vflI130
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6675
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Apr 21, 2023 at 06:06:39PM -0700, Brett Creeley wrote:

> +static struct pds_vfio_lm_file *
> +pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
> +{

I see this function is called with a hardwired 64k size on restore -
so this means save is also limited to 64k?

This is really overcomplicated if that is the state size you are
working with - the mlx5 code this was copied from is dealing with much
larger values.

Just kvalloc() your 64k and be done with it. You need a bit of fussing
to DMA map the vmap, but it is much simpler than all of this
stuff. See fpga_mgr_buf_load()

Since the kvalloc is linear the read/write is just memcpy.

Jason

