Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550DE6362A1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbiKWPBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiKWPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:01:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F289B23168
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215706; x=1700751706;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i5gq/xV/3iT9yl7BVz+QS0Imn7dVxqcU0eQoQZ0Ny84=;
  b=ZgkCuu0KrH2+IrMZPlovS//oWTtieOMxVp08fihUKSJbmw2YCzLKIXHZ
   JpxYBvx4i2gaSFDeDsN0TnDjZEuKgtigK0gtW/b5DjuKVrHE+JTzitaq4
   XiXctYd7jdKGs//snFVNc0aUCwmoxGM/JcCvPn4Cx7aM0AOO0smzZ2Ezv
   nz+ssitvgnUc2f6oYtGRdC4lZfkwXvZzKVMITU7E/0DZwZKSoNWujKThL
   be24ApoivkgYCuGnc5PahYEXm+6D5Jr9qfPyUwsyTefS0V9FqwIYzOaQl
   q42Y54nIJjK+/OGMyVIa6orT6qUZ6T5H8Q6y44w1zqOVd1VOj2VlHsVg9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301643002"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301643002"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="644142608"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="644142608"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2022 07:01:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:01:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 07:01:28 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 07:01:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdYksgMIWiCn5VJM4M5O0ZYO5cUazvqKAmlJbGOoVdOXGsLMho++3GPLwV8JM/HcZmEuVg0ka74n7v4OOuKMbMLVVMfyMccPQdthXGNPYZ1+3A1DwJwpGIKbu0IzpIAKs3E+D2OJw7N0pTGzRmXLOq5ynIwp2rYN04aHnJ9cP5l497pa0sywOIFZXColDOiwQ5pmf8bmFEybLwgj919wvof75rojDQUtdZbopsSg2I/PI1ABkMdffhqm2V3kN77fzQNuJcbsWV05AE3Df7KXjm1Q69rNMrPRAD6N2s+TaIUpgv99s/knlufa+8DFAbaHxNQU1h2lULeSrfQ2jjFIgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueGModDdW6dtHGz/7/oYFBfqrYq57Jigr28pVFyqDg4=;
 b=ZDUBluCkIZiO2x4vPzAjTBVsUaYCBxbnUMVbn8kLElwZfORtEG6SdqN5u3if+yis+ZYag5oeuPFwSSi0GE+47FArz7BGnIGztyPWzU96+VEn1PazPW4ikPszqKNQHZ0nRkT7FUXjDS9kvwRGFWdCpolhYm9AHDrIkPYsKNnKQzfV/f9CoEPV9uls9FjupOoU5NfDI5rJ9zojuyWve1T4sp+IzO3FXh7PBIEzbayMvauHjL+AdN/27uxxkuokPjECRzZkrpg0l5Lnm5qbaAQ0swm+kRrK4v5JNDt/vnEuKOx/Q7OUTUFEOPTyTBj9IHUKOPr01Sq24h7zTG39VRpFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL3PR11MB6506.namprd11.prod.outlook.com (2603:10b6:208:38d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.11; Wed, 23 Nov 2022 15:01:15 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 15:01:15 +0000
Date:   Wed, 23 Nov 2022 15:57:36 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver
 probe phase
Message-ID: <Y3404H9uBoVqCQgb@boxer>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-4-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122022559.89459-4-saeed@kernel.org>
X-ClientProxiedBy: FR2P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL3PR11MB6506:EE_
X-MS-Office365-Filtering-Correlation-Id: 7be070f8-0ddb-400f-09a6-08dacd639167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWzHKQmbXTHWP/ZOuDZAgZSt4EUJGlQZ16R4D8T/1af3MalFFyQVdWdSXlk+Inl0OMggjDI15oLetpebRN3+KuEPWPOUrQ9mmKRAoND3Sjr64ZFRQN7+3IwqZ90357LxZOgy+AEWyUv6mSg9XBlv/VSqBxV6J31VG8K1JrWXiUu7eEXG8sbFQJFhJMwIK5fZHzrLmnBoe+u1mLsltIpV2bCgenBlYYFBKGcUuUmPYxwKHFXE7bjRwX7LUy3eZ1947nZ2/ug8/Onc2/iu7fzTcX/5/z0NWljnU/nOuUePw+XYN2ilHo9KQ+W+984Q5Kxn4dxg+fP0wGQX+53jZCTc2EkylFgt4/KGo9o1dyVUIvFF7yZHHcwNrlVR+SuY61ud0jf0UCX4k+qcC5PcpiTLJd7aiGb0UZsPzHihWe/pvCzqIkASE9OIPetDIdNJZZgNr+8PXiJTsoEgbpo151HRZySGWABKgcxCWWGJYl6YQNd0T+6GQxyvw28dvco1FSbZsCKYqFYL2lEJCQAf9EcHUhHcFwGSbt0cJKfIETX+QX5l7A4+EobqFjA4wfDu4aCv4uoD8r0Gvep9V1kXc05DJ3CvRM1LfBzBLuSt9gUiOWVWnqiVAL/KRvXyVVm+PidlIk8jzbzLiHajYldlnSBzSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(86362001)(478600001)(6506007)(26005)(2906002)(83380400001)(6486002)(33716001)(38100700002)(6512007)(9686003)(66946007)(82960400001)(6666004)(66556008)(186003)(5660300002)(8676002)(4326008)(66476007)(8936002)(7416002)(6916009)(44832011)(41300700001)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cm2N0D5UgMI3VyJSs5byekZ4k/6onABOoq04eEZiVC1COX5u31dAdmS0STnD?=
 =?us-ascii?Q?qWAr46GMOIRl9voVKeG1amUriwgfSyHG5PNHgcaaWFTqxCEd4ikf/1C3imF2?=
 =?us-ascii?Q?GHdZkvQmOkjE+UEMWBympHX7eIe9Gppv7whNzXNTBfeUga3O+miRI0kvVIVC?=
 =?us-ascii?Q?9WSZPdxy30KGJXBaOwAYszA4MtHWMm/mm3aRHcnb20omtIXEZ7QuZPzQiMGA?=
 =?us-ascii?Q?Wdyo4pUBQdWGMqdEiwkQXguG8aNlZopJXKW9kmCrI+l2e4bz76TCMnxbmADt?=
 =?us-ascii?Q?1UYa1IShBAG5im/vsTmoAjvivXIU9/D+mNodsuTEv1BZ0mxppead6ZC39ifK?=
 =?us-ascii?Q?milbOqrEecqEAQreUg/1wj6c5nzl+nJC7f6Plq2hnUApr3nxSY9Es74AvyMX?=
 =?us-ascii?Q?EesPLfcmG83Pd4LuWRJJIQiCNew1XlZe5qp7waE9u74F2gyU1Yey0oQH7XFu?=
 =?us-ascii?Q?H7bxdavOMrXrwn265VGAoHSGH+bKPk4VKNFoLIZ08yWppzLVjIPHsWAOAjPa?=
 =?us-ascii?Q?2dSQiuK6AxGxgsD2/al81Ybe03jO5u9TQU0Fhir1dxL+y4ovW0ruvxgmSUt4?=
 =?us-ascii?Q?N/rQbze9GLMORWtLXb+TYBAwMvQPaVA6mf5WuYHQafkIUVBwl5KR3+JXI5WZ?=
 =?us-ascii?Q?D4h6RcuCBngWVgLpm/XXlpx2VKVkyChlJvnWiDztIVFTN9KPAYYnksZGZPJR?=
 =?us-ascii?Q?VnFA52zfl2MoecggxiLkoswkd63LGKfYsW1/xuX6EH2e8C8qr9kAAKeWbwHT?=
 =?us-ascii?Q?I0HgLnLMlXmEN8enpjpnviEGovpe+wESLQiP3z4g9nz7SIAcRH53Q0GH2i9d?=
 =?us-ascii?Q?BvPQ+BC8G6xjssS/lkeg1O7HxTgIVdbNdGqBfyEhe/fGvSkB4Vz9HXy1UGtO?=
 =?us-ascii?Q?I7ZSmUgOhubBfA/9JloccTEPa4W0C/6fDvMQc3ZTOnNchlxWgBHKh3obmm/D?=
 =?us-ascii?Q?CNJDzyk605XiBvToIaEav5CDlwLZaGuySTc7KFgYFfdOZSrB/qSQBNmSRTmV?=
 =?us-ascii?Q?ucfxrbEK3EABILMnfOmHKOrg5OQP+YQHdg3WejI9WCDAuwUG83wad+MMlxTy?=
 =?us-ascii?Q?wdpQERbIRNXgxZTjImUSNfCW5epJnQGSe7YOIbrtPNKd+dPXsnh545/3ESCv?=
 =?us-ascii?Q?nBRf+u1pYoXlznn2ehzB1xcK3UUx5afAlrS61aqMa9qGaasyxv1cz2M2WIyk?=
 =?us-ascii?Q?vo9S/t3ioQKP+kQwapWiFjCub0urdIevJ0z8CYWUJEbOdkm+JuoE2ZxY9X5K?=
 =?us-ascii?Q?1Ice7iNi3orcr3R4QwOT4NBGQZ+qBKWob7kiccDVqAM6esHTP6ypA4rP3V+o?=
 =?us-ascii?Q?sjena0j83gqlwoX3G0/Uj2Fgxi8HaEr8yCnyFk9xcokseAL3k+1IC8qlbqvK?=
 =?us-ascii?Q?LDQdrT2hntnv1/2pV/W4EAJpC64pMeUISMqm1Jnb/qKx99KZM0LUwrCdQ/6s?=
 =?us-ascii?Q?jbAxQ7YVeZP77iVPfMvcVDwGJoK8ZHjjGhCRP7eBr5+YMRxw6l3DYkFrLUr5?=
 =?us-ascii?Q?+dBS7Nn+2aDc+KdWz1BTg9Q95gUXG19LP6qctODS03yEnu76s3EKmZIhi2dS?=
 =?us-ascii?Q?u2eZv1GXTX93zASR7Fis29f2AbA5V3Ek+0HiKOtgbFYuRJbo266sV198HvJf?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be070f8-0ddb-400f-09a6-08dacd639167
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:01:15.2656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AkZ86t2Yla0v/H21dAm8pmEx9iiMByNx/fmCnhgTmf4NJ0NtX4ZgkBv2RVAgO6y2C1mCR8hof224DzWYPsg5nAhR0zDsex4K5vEaeUBAbBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6506
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 06:25:48PM -0800, Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> When SF devices and SF port representors are located on different
> functions, unloading and reloading of SF parent driver doesn't recreate
> the existing SF present in the device.
> Fix it by querying SFs and probe active SFs during driver probe phase.

Maybe shed some light on how it's actually being done? Have a few words
that you're adding a workqueue dedicated for that etc. There is also a
new mutex, I was always expecting that such mechanisms get a bit of
explanation/justification why there is a need for its introduction.

Not sure if including some example reproducer in here is mandatory or not
(and therefore splat, if any). General feeling is that commit message
could be beefed up.

> 
> Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 88 +++++++++++++++++++
>  1 file changed, 88 insertions(+)
> 
