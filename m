Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64236362D5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiKWPHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbiKWPHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:07:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96361286DE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669216030; x=1700752030;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OJlyJPwyoRqhmL1BTR3+8Ldlb/cazHdSEGlcH3oAcT8=;
  b=K3eeo/jlBxm1RvAaF4UpXX0teWrVxEgFTlSkdWOoEOzsQ00nLUhvss5s
   K2pMWXdPpjbzcBRit3m7QGGcH04sYv3hpvSVYzh7vh9r4hUBbpwICNWME
   CI+jgkbWYII0ZalVRvzPmcx+WxqKY0wxem1TbAlE55gKoivVPtoi0ETyR
   SdJUzvZEvOiQbpthErPE2GeKsrFIoZC6Qnx6wspTczi/sq3/+0tSbQysH
   H+Bn0+H6Zm00NTb103Sv3Fai/EpKXXtO36nIsOS/itqRhmm2T+ajsax59
   y3Y2U5jnGuYAKt056oa1Rh821St7RlqhYHswOq42Cnh1RdB4aeOQVksdw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297445606"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="297445606"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:07:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="641825771"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="641825771"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 23 Nov 2022 07:07:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 07:07:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 07:07:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 07:07:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akiMDQZ6mQB9ZIrO6wb9Ctx2rIXVdXbrKMHZUbf1cGzEfMa9CiKdJHjV2mbxVJOrIrDHiyObGR010NVNS7PrRtxWYg0OfntPaZm3b9SvjphN+UQo9WW7Xks3fZ/eEuKkkmSEj5u4POyH9HwLd98n/ip4a3mm0GJt00wjuxrRFBmio99jYszd1ZlLLnZNi4zCqqNrkBd//v6JlJ94lk8qy0LQGrBsJwEzuZQPBpHRlPYgfuMSPR1+CggnG3joHto8AB8PZb6nKkoHYa4H7YQ0JGFBc2aN+EhJl0wzMHobAT1FSfKMrJ3VG3f1ItOJ2m+FebojV7YHcggMIV3K5t5/Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcUDaJIWVXI3SzcOQJ1ESD6MctYZC5pq2C2gLsNEvwk=;
 b=WKd5M5674OIqO9Xx2L0Q9Wp/pIHoLhsCQrYb78NbvaQpCrK8P3Ih4aYM2sUuJ7ExZI0y0+AakhF6Fn2iP1xmzGx574mSy4ZWOERng9y670SF+vySai+7LAgNl79CY0C7mTXaRibT0UIsF806t6mAJUEZvPqadj+MrS217Qn8EVwbb+YS558n3VmZcwve3yrDTA9jvj8pNKUrJ8zfqBhDnRn87I5pfx+NLBrWnXmZWhonTNrW5pt0+c2SjKJLwejMmuVXLjrdb2UF+2H2aaVAh/ho8qVM7VV0Ai4rwpBUsGIkxFwvygv0Knq7vFnRl9Bn8X2AmgDACj/hQHPS+GLwzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB5229.namprd11.prod.outlook.com (2603:10b6:5:39f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.18; Wed, 23 Nov 2022 15:07:06 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 15:07:06 +0000
Date:   Wed, 23 Nov 2022 16:06:59 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [net 04/14] net/mlx5: cmdif, Print info on any firmware cmd
 failure to tracepoint
Message-ID: <Y343E18Hoy24Jolg@boxer>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-5-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122022559.89459-5-saeed@kernel.org>
X-ClientProxiedBy: FR0P281CA0114.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c4750f-1130-473e-8208-08dacd646275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqiBxa7obOqbZpK5RNUfTVe3mWb+NH5J/Pm8NrncK+4K83Uz+yx21j7DNk2B/S4bWjeX/bntAOEesiwCAjpSy5UMm3m7Hd0RkYhOZvNxtpHeWJkCVBE3WqlLcYsfUT12pYTiLHQD3LZwUKKMBTTz3wc/6g7KCF2sjiJCqeSy1MM8kBOd/AgjIndIxbnJ9pTKussqTOehXWX4DF9VGq/e4QswTX3ElCs+ij3jf47yNkVE+IqIlbl8XE+DtMM09uFjEc/kH1AfhKxeSAigNzsv1wtbgTPQ+4O6WEVHlExGUvWEKCE94Ud0U/gT2UNkp21Jmiv6IGIoX3kl0ARWfkrAY3Als/rC4Ai1OBtnmzmmm8Fxwlf6RuSLF5O3bZ5Ll01Nt7pTxdVJBx6+pFk1MM7qO7N0D67a/vRe86NU2g6ACq82dZgCkDYnqXy0dHWCHk3CIOu5YLWADsYbpVwaPaDnV34LGMefZOP1rjxCDZreFHtIJvF33RmjRD/PDhr4+W71ox6doPKRfDgEXA0UO66xN31zJbhBoozZrXitQO+877u9KDCw7gv+dW/EZ/UCV59DurxIe2pY4GXDG0M1Ekls4tMge/NiTxdwpzrhuMKCNuNTLqtfTTy+4V0+wSa8v+K7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(33716001)(83380400001)(86362001)(6506007)(6916009)(6666004)(54906003)(6486002)(82960400001)(38100700002)(9686003)(6512007)(186003)(44832011)(5660300002)(7416002)(478600001)(66946007)(66556008)(8676002)(4326008)(41300700001)(66476007)(2906002)(26005)(8936002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1YEdqLJqITrthMChQ46zmYqWZIzeFf7zbJPCkWLRAd8PDNigeIdm7hABQQ70?=
 =?us-ascii?Q?cCztamp8oZZWa8DIGxFWz+X/KiDzUT5ohydes1PeybqGrFAQol0wEJ1dCr3m?=
 =?us-ascii?Q?BR0T6t7VUyD/9D2peBp2zjMZvmJhbruHELfDHIEpv+cyUpAVFJcKorP+tqxp?=
 =?us-ascii?Q?YKGS3dkVtruIT7aE4TNoDIs3LVlfVhNc9mimYR85cmMbifiF6hbde38Ryzu0?=
 =?us-ascii?Q?xhjZ7c+FPr1BMmNMIFzyhKNV4o3ltqvArM50tDEGevXngpRQC+N/YjOigAgu?=
 =?us-ascii?Q?aH2dY9TkpQucyQ8GsYPQx6kLElv+Vgeolv3f2EmdQXjpvcLUyUA1RetcRaUj?=
 =?us-ascii?Q?w7RwCVp5A84Pd4bi79a6+gdqmqtTBw1dIctLG1ztBrLCy1/zFftDXa9qBYCe?=
 =?us-ascii?Q?x1fEBticjFC/yluQy5lvbZ2P2Gl7jEX6zk19kgGgJQ7BGRMx/HpkQWuAyGhR?=
 =?us-ascii?Q?kWrSbDPmT0nJ/IxewrtOeBl3TReMt2llG63aT23MY/ujuyw0FNVKFjLS5ZSI?=
 =?us-ascii?Q?GTZnpS6C1G5mXWgdB57u/r4WHgyH0hdl7yQihnxCoYB0d+fONhN9ghNU+T0E?=
 =?us-ascii?Q?LkpJ0TmetotnJMKJcKs6/hHSBxlIBA+3KHngRF7A/86zJZMLEdL4q2ljFLjf?=
 =?us-ascii?Q?9YCtAo6WCHT37IQZjyybffEJ58XrKd6Ojyn2fQDx8r7zPB+vJ7+s4zalVpXy?=
 =?us-ascii?Q?Ih74VzWT78r/d1lsJqWKXeJHdXi5aEVeHZ5lsJ4aEPd5YIyqv7WuIg6+E1Zz?=
 =?us-ascii?Q?f6z+4hRngqvzU/vj7UPuUf6Kh/x1L0OcJC0DO7237OKFhjEuSbqyoarVn1AS?=
 =?us-ascii?Q?1ng1kBN5X/I0Y8vdPbJcI/LZDSKv1s9ewr8RvWY/W5G3Dzo9tta6IQN8W+IK?=
 =?us-ascii?Q?hqaY3zyGVtUB/SXy1gkw2KRNbuk04uvz2laxjns8HjqWwl04UiQzw+Rf6rym?=
 =?us-ascii?Q?XJN7oZmANPJQ3Zrq9HesHT462zS+JzPiwC0AA0saHmZkuUGYR4TvDysEYLJ/?=
 =?us-ascii?Q?hxvaIqVFYoxop7Zrba/dXsbCRMYH0HcUMXy3Igx6xLeVdUcgCc7vZ2DIxZMd?=
 =?us-ascii?Q?XuQ3Bxx7254yKe4Gf83xJ46DAeV9dcIr2LGXk20uVAmuDqdEHfQJr+vh0vho?=
 =?us-ascii?Q?bNNsQRxy2fDFrLmcNrHFr8ccylJg41tefQULTlHG5H7z2LtqL+TtJElkYitQ?=
 =?us-ascii?Q?kjaLEkg4N1nPjYc8iRcDJNOoO4/p4zUF3S0vKHkAFUmoPo1yBOQaIvMXI3ve?=
 =?us-ascii?Q?oWgBbATiNFoECTT4KlWXc4D6hl197sTNSaJ1F3dsOsl3M2uksme/C6hpAiF5?=
 =?us-ascii?Q?p2sXmYbxqxNDbbGvBqLauuxzOkAjGD6bBvZFBcYFStJxeR4Qclm9cNeTVJus?=
 =?us-ascii?Q?ZKX8ttVXrsRb11eXzkxTEXpixMLLWZAllyNNIAtpEMOCarp83PnsK2q1CzuO?=
 =?us-ascii?Q?zfbq3TlLGJwPx8vxNi4VBnO/Ql3LHis8v+kVMN245UawLisZ4dgP+jOA3e77?=
 =?us-ascii?Q?a7p2zqlJjkqcHBcZyf5d1kEsK6ibVTpv38xi+VKNSjECMz8jtfsOw4foLRMv?=
 =?us-ascii?Q?lRg7TwcjvCSsmTDJAucQW3YgOr57rMjGrP18gejsIN+hj4H2V1cMo0T+znBD?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c4750f-1130-473e-8208-08dacd646275
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:07:05.9731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8O9UluB8nENSh30f17gEWGyGrBm1Wl15t+hKV0LS200DNTfrbkLIMUPgcWjABsqarKXhng/yrew5roKl6j6EUxWAKQPHNpgxH1vv9pH/u2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5229
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 06:25:49PM -0800, Saeed Mahameed wrote:
> From: Moshe Shemesh <moshe@nvidia.com>
> 
> While moving to new CMD API (quiet API), some pre-existing flows may call the new API
> function that in case of error, returns the error instead of printing it as previously done.
> For such flows we bring back the print but to tracepoint this time for sys admins to
> have the ability to check for errors especially for commands using the new quiet API.
> 

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars
per line)


> Tracepoint output example:
>          devlink-1333    [001] .....   822.746922: mlx5_cmd: ACCESS_REG(0x805) op_mod(0x0) failed, status bad resource(0x5), syndrome (0xb06e1f), err(-22)
> 
> Fixes: f23519e542e5 ("net/mlx5: cmdif, Add new api for command execution")
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 41 +++++++++--------
>  .../mellanox/mlx5/core/diag/cmd_tracepoint.h  | 45 +++++++++++++++++++
>  include/linux/mlx5/driver.h                   |  1 +
>  3 files changed, 68 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
