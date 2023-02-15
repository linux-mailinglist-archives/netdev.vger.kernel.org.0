Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BB5698025
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBOQFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBOQFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:05:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E7127D51;
        Wed, 15 Feb 2023 08:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676477129; x=1708013129;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VyaFW8x5nVd+hNRKDXSixCBjw1sWadNMA60zaL2EYf4=;
  b=C/wk2d8I25gx7OiGqaJPf6yzABCS9PmvuASg9OaeCvDP8njMYViRXUAH
   ZTQBgGPnJWazUQhJG5u+djNsqNORV6Q/XXK6Sz2b13q+156NLyEit3qCu
   4colkdS7SPtFKKSXc0q9iycUyOEoGhbCiIywumNjihG+YDSPNaMof3TrV
   I4ll1KdXCbeii5Fk3E2xVZl8wYP4VHWm/slIb/Aifwq5QEjYBjP10dcaH
   +4x74x6E/dt/NuFLZ3WrUql84Het/QfxwctNEcbw/4AfkH6n6GKZVfN2K
   0UCpFRvjzNNSypWNZWxu7bAV7pvS3sL0SheGkZYKUkO7UENLxzmylXyVo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="393866764"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="393866764"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:03:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="915205019"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="915205019"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 15 Feb 2023 08:03:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:03:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:03:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:03:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqfJ535mdQ5u3fo1MBExpPDDndWK1WOSFbJBKn02twbcGlCG6T9r6NjAzwI6nGA1V6a1uIDIf36wKVzCK5xQBx1xUdpK+QjFldxCSXijWOTJ3FHX1d5pTfM6ZwCOATzZxUTqjZRyxzoytW3yzuvY6Y3caXeZEMi4W3Z14gprdJdiMh4G+yBBibXQb54dT46dmr1fRoqNgEZ/AgaH9vVE70lUbtFKMN6gzx3ODKCE9GgDhmYTuu6g92ZZ9FpWkSO0EwdbrBct+UUyBWsoehIcEbpzUyMCZLYFZxFv9C/peIRL2CAmnOHJ6bJidkLlrHGjcBtsQFDYxECNvO0oJCDMDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF7uAWXiO8GdBhcWTlPbcKU5Rgll75Q1/DVVGgLxSKA=;
 b=IW/plhKM4sbDcXV2TGgzNw1kAyxyP7QVpePWu+WpIenD/xwXaURRs4lVp0tJ5jEU5Q2ZiwDkfCUKQl4B5kxaC5RoUsoQEvm+Hd7gqdvykONOrmHhBwp+UuInRYPTilLZ7mv8N89GIwoisLKGoe1UZYIeQW3ISSWDW6vvWYFTodYAaJNRQ0xLEp5NpBkL66eNSDG1gy+9pJLXRoP1EapDZPKJPwu4/lRuGF8DM6W7Sk960M2brZRFA6TdhkIzw4Tqy8mzpsGp3vmNxV58ARykHsScNQ7K8OWWk5WMl+//HdGGJcyQTOjoAv97C3fGJrX/n9wvvsWmBr9Q2azKceZnLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by BL3PR11MB6434.namprd11.prod.outlook.com (2603:10b6:208:3ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 16:03:33 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%8]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:03:33 +0000
Date:   Wed, 15 Feb 2023 16:45:18 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>, <martin.lau@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>,
        <alexandr.lobakin@intel.com>, <xdp-hints@xdp-project.net>
Subject: Re: [xdp-hints] [PATCH bpf-next V1] xdp: bpf_xdp_metadata use NODEV
 for no device support
Message-ID: <Y+z9/Wg7RZ3wJ8LZ@lincoln>
References: <167645577609.1860229.12489295285473044895.stgit@firesoul>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <167645577609.1860229.12489295285473044895.stgit@firesoul>
X-ClientProxiedBy: FR3P281CA0066.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::17) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|BL3PR11MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: 45bd28ab-40e7-4157-26ad-08db0f6e301c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XckRpkw04xdogpwGvmjjWdUGQLy2hGwdOs72qQAcdoHMXMHlrjohqczBIwKYWgvFIbYDtW3yq+w/ao0HUBa5/5rYBUQm5xkkW4sXMBkWxnV5dNFMh4NDR0Eiyrll8/uEacIsnvI1xLVgYX2+DwFA3XToTBqlwwOtmEJvRTOwtXQCvsIT5bQNyr2QpkuEQfTcGiox/yRn5CkAIVobmybwQEh5EECsDClNysfLvrknh9QCsPS5m7DrnZSGrovLZkvli8eYxs5u/pMKQLamXO8CR//+El1AOng9R0+IGsrcHQUqWkikl6dC9S9QDl1iCzcOtNIILPlmYA4ZWca3UjG24Uvv4cxojum9UYyCCQp9kPk0RSbIsHulGur1cc53vrMYdNBm6eWZBZ7PG887AsNAF0V2Z259eUQ1NJjSVz1YnyTqw3ljcEBtPoD7YFRW1ztyYx4Nv1i0A2I0VdMHHkDTBgqyy3pTzGBxj86CJ8CNZ/snyMCt7hjyn2s5fbuU8Gbgyu0pnKOYWy5GcUOELSeYWTrg9D4mac4HA8r8QXVMmGtUcthBvCwrlT8b2p3SEHnfja+knfZp08oBoGkNhjG5EmXZafZgzUGuWlM7rHwPSJF8GJ8wTR5fN+pC/y9e7FQ/lMGwf16trE8URjcZDVQ1Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(83380400001)(478600001)(6486002)(6506007)(6666004)(9686003)(186003)(6512007)(26005)(44832011)(38100700002)(41300700001)(82960400001)(5660300002)(86362001)(8936002)(33716001)(316002)(66476007)(66556008)(2906002)(66946007)(4326008)(6916009)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UwHPa0x96p7ydAraLNQxHM9Uyr454S71GsD8cTDFaq7HLJCRr7iQnmBaPxDH?=
 =?us-ascii?Q?OmDl3GDMZ3BousMhhkhhrvjuTsyZliW8YGEkNurp0N4bZwK1ccxsnzBNFMWP?=
 =?us-ascii?Q?6wEwotCcvVZNBIQA7Y7uUdrT4RByVc8Qr1l9mq0F7Oz4VhMDKwLVp4caQYla?=
 =?us-ascii?Q?J406NbWnSTRkBeeIv6qep3/ZZu8bWQqB3apwFAdHPG1BLHH3IdiV5n56mc0m?=
 =?us-ascii?Q?ifwsb/kFOee+LSnt4bnmUD8ZwRhg0B3DaiLxHEUlXNpNWqGuUwzKNM8+QAf0?=
 =?us-ascii?Q?J2M1Wh/Y4EgQYLxCx99ccs3sqITsfJrvX4EzKi5kgH3vB53X5yjACJrbTAKE?=
 =?us-ascii?Q?lhe4fXkzOmStqn/jlJO5qdkYrQ+6GwHGTGGmci+jlbROPQk/klj0gIoNV/7u?=
 =?us-ascii?Q?MchZlbNqQpu2vmp8+/YyF9LXMbaibqrjjb50A1uvBL5j/DcfG0KuN7yTMnlE?=
 =?us-ascii?Q?fjqfxP4iz+wDFKGp6ZpDN3b0jyDb7044d3gnKoZkidpwg/6+vMeE/yqtLMn0?=
 =?us-ascii?Q?UdJF+gXXHzHHnC3Gy8Ryx/CHblZTj0q3EqQXhSoSiZxwGlZb1+fOlKheVu/S?=
 =?us-ascii?Q?DVUY8uBc8H+I7xUyNwpKzLTraspcYZnZt7Ev/zYcOEI5b6Jy8/uM4DOep5wi?=
 =?us-ascii?Q?eeTzM3EkOX95H9CLE5RJJYkIRI7MTHrAFqFJ7vh316gEhEbFasw8GPO30WvV?=
 =?us-ascii?Q?HD2KPpDdHzYAC/ncxyK+F/hE+mFelVuGrJI6izE/Nw7zG7I7n3RC0LmY9+jn?=
 =?us-ascii?Q?q5qX5F/CAvMG7NEc496/CiC0wbt9YFagE956Ob24EfRUQ5Ev+2tNdM1O0Sze?=
 =?us-ascii?Q?Q47A+vQtIy6IX8Fmu5ETujqcAqpjDIG/2uDl8T56df9Wid+49IlRI7hDaUWZ?=
 =?us-ascii?Q?aEtN6uJmMhW/Ib079MMrtl571GnmefxQtehGMiMOxBqpkr7t8EE0wrFdCtgI?=
 =?us-ascii?Q?fHFusL9TglzsgZOHZVWMcrOdmF/c7x4o94g9NQkDZO0FbBpix2EsF081Xrcs?=
 =?us-ascii?Q?pLhqerb8HX/5Sbi//dui1wNx2OHkZxksRnTHVYuEFSUAP3GYaRPekU0GwMG/?=
 =?us-ascii?Q?1MsMCnopj3PBJgimFs17eM7T72SsT06TZBT6QIBxahsga1Qy0PRnHlNj8SSt?=
 =?us-ascii?Q?xmlUy9Mgu3S4WO88MiUwXTjR/SwHZ1bUl9Hci2i6+z54sr2xDXUcbi0SgOgY?=
 =?us-ascii?Q?ZIBnYC+RX4OXEVHhWVA+Ctb0vwjpWRPs5I48jDQRvV9gHZ7bNd39lmJQbYdi?=
 =?us-ascii?Q?DmHGHwolCRQk9g7twFn8+mcPjQsx8Vvg2g2FLYuVpPCdKH5VjzudqbpolrRf?=
 =?us-ascii?Q?sXQ48eLa2IuiN9QrEmEaffPiIVT/WLEnAfW/7A5gyRUr2snyBT7IEdmcFAND?=
 =?us-ascii?Q?okn5qFGUqS+L5AGjpHWkqQoIGu2uQIFFeGkF8ac+nZrpGVDr7HOfHzEdyghi?=
 =?us-ascii?Q?NAvJ3d8yqbSBMYuRUOgLBk/kME5Qeaw6LzIhnqcXx7VfFAFU+ALJw9rfhXoe?=
 =?us-ascii?Q?t7XzNA1uX0c1yVNFFt8wf+bQ4FuvQAhopicDJTG1q43UoZPe/UYdyR2MZ16u?=
 =?us-ascii?Q?+oMBQ3EL50jX9jj9pi7LeXtKpc3H12blG8Mq7g6LK6EeWl9VjDqAZ3IaVmKN?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bd28ab-40e7-4157-26ad-08db0f6e301c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:03:33.3819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kuVJEcsHJCqRBkTk6oE5wLlVozj3WJtSV+mVzaDCD/o7GoaAnMRMPQOURtZsKbdz7hOPVbkBZPchVlLbOU7nRNe/BnS6+5v3Eag6Uavqy1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6434
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:09:36AM +0100, Jesper Dangaard Brouer wrote:
> With our XDP-hints kfunc approach, where individual drivers overload the
> default implementation, it can be hard for API users to determine
> whether or not the current device driver have this kfunc available.
> 
> Change the default implementations to use an errno (ENODEV), that
> drivers shouldn't return, to make it possible for BPF runtime to
> determine if bpf kfunc for xdp metadata isn't implemented by driver.

I think it diverts ENODEV usage from its original purpose too much. Maybe 
providing information in dmesg would be a better solution?

> 
> This is intended to ease supporting and troubleshooting setups. E.g.
> when users on mailing list report -19 (ENODEV) as an error, then we can
> immediately tell them their kernel is too old.

Do you mean driver being too old, not kernel?

> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/xdp.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 26483935b7a4..7bb5984ae4f7 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -722,10 +722,12 @@ __diag_ignore_all("-Wmissing-prototypes",
>   * @timestamp: Return value pointer.
>   *
>   * Returns 0 on success or ``-errno`` on error.
> + *
> + *  -ENODEV (19): means device driver doesn't implement kfunc
>   */
>  __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>  {
> -	return -EOPNOTSUPP;
> +	return -ENODEV;
>  }
>  
>  /**
> @@ -734,10 +736,12 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>   * @hash: Return value pointer.
>   *
>   * Returns 0 on success or ``-errno`` on error.
> + *
> + *  -ENODEV (19): means device driver doesn't implement kfunc
>   */
>  __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash)
>  {
> -	return -EOPNOTSUPP;
> +	return -ENODEV;
>  }
>  
>  __diag_pop();

Documentation contains the following lines:

  Not all kfuncs have to be implemented by the device driver; when not
  implemented, the default ones that return ``-EOPNOTSUPP`` will be used.

If you decide to proceed with current implementation, you'd need to update them 
in v2.

> 
> 
