Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50486638CD0
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiKYO6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKYO6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:58:52 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA627B0C;
        Fri, 25 Nov 2022 06:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388331; x=1700924331;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c3vG5jmy+Mic/gAV3Mbz+3QcIzgEwBh8+ctL++unJVg=;
  b=ndBH1nYuraH+th/CUUOfQjH3kor3Oiv9bvOa4eVNVET2kdm+A+lq+ogo
   MEDNIWBFuWwtI+yfH0Rf6q5cuGLIxCKuP3VKVvXE8IvS0z1EOrGrMSNc2
   zNlox7SMG5ehFgqq/16ooQ2iQQJuf0UQz+/ZIYLDzJk9Hi9Sq9YhPefdE
   lxSPDLc0bFDBhCaUT7ofQpw229J7N/crq+Fc4YYZIFo0fb+fpkfdl+IlX
   +Xqo+JTV421dj/wGdkfccqj0acJmDfkb1WRTL7mdkzQKJ4OUGE2OJOh2d
   3xJxUHFT8E4w/g6qJDZp19hhVWqjtezu+vXKdOzanKyh+y1BN0otpXYdv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="376639698"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="376639698"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:58:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="642724094"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="642724094"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 25 Nov 2022 06:58:50 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 06:58:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 25 Nov 2022 06:58:50 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 06:58:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TphziK+EAxgBjEOlmjE7HzLkdoOnkjp0V7Np+Wsj7LB+1WIwbcDZWk3poGeeCWZDi3pdp0oF9sE1Ar/gAD3va5aK63UJaPeTTm+I7+/F+Ttv83XcOjT59539E8hEWv17ZIoa1Uy2iehy2LE2C1VTI0anoZMLQLY+ZSSWkhdAikd1sdhO7hhsakb01kU86IUOEITezcYW1LtZAk+9M0wNgqjMpYZ9L1H5fXu6v7ceO38RKidX/ojXMy8GJ42vAR/6rGx5Z01xgfitpvfl9Hpelyt6MC7i+iu90XmpeUVj+KaCb7ZBEN9tN4/zNnhI2V6VlD+h11zod8Hr9HGfxLvkzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9DbUE+3AglpNZ/pvDoFvC2SM+bp/+sKq20JDCPgGLA=;
 b=h38T2FGsqZ/sEgKoBlVAibI5TNIlB0oHNIfibK60pti41dBjIkQVasYA0vTfgfEP1iQWZ0F6R24qbHpUPC5Zm3RPu+GRvmCX/t3rgIFAlRJrJFPn2iXofskXuVqj+ad+UcwSgrPR8wuaoi2dVZL5NTh7PAdbTKQivpCNMHeL02+1NRxSf4hBFwKt6qj8kIr7UCxEE341Mq3pk+QUYrS9os8v2LaiVAL2G+h/otYVMnBTFkM7Cqb9qgSwYosR5Z2UjIUuIkKGKbvD2e8FoA7euH+/GJde7CHDqsWZDXWwDg6JA2jwJ5FH3CP9XLcNge+fjDLCLmMMcI8+bWRhpGoaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW3PR11MB4585.namprd11.prod.outlook.com (2603:10b6:303:52::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 14:58:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Fri, 25 Nov 2022
 14:58:47 +0000
Date:   Fri, 25 Nov 2022 15:58:34 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Suman Ghosh <sumang@marvell.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <jerinj@marvell.com>, <gakula@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net PATCH V2] octeontx2-pf: Fix pfc_alloc_status array overflow
Message-ID: <Y4DYGjdcOzRryTLn@boxer>
References: <20221123105938.2824933-1-sumang@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221123105938.2824933-1-sumang@marvell.com>
X-ClientProxiedBy: FR2P281CA0080.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW3PR11MB4585:EE_
X-MS-Office365-Filtering-Correlation-Id: 857da77c-d593-4e9c-642a-08dacef58e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAnVYXUASaT71fcUjEnDWFUMW74gzO+WicTTg4dBPMXeqLYtrhO/kYWYjHUu254hIHovDTbk8Y+s+ak4G0Rw3sDRmlwEHKHCCuH/j29LTxseYrJveWfJ3pp/gwpKi5lw6lmlSko2eIa20B8YzpqXO9pah3Rd124TThyEvPqUlTrLgEAjV9kHdX3J7HpVdxS2mC7NoLmDSskgPX+DwLU35gLE62w8CN5wDQLDUGnzL61hwX9jb1Nxhw2dqcMp3/54YtZuoA18AiHpAg1FJa/J+xwjFpk+sGm68xzE9F+8kxOAGQ12qXozhEXaOIKl+XGLaM666BUMQ1zZyYF6eUPubJ5qGnXqwTPjBbv5ii3zrpUuQl+cNTKh47C4aLzf1cqCcU4ajkszWjXsQ6ETGVDb30OOfkWwQta2x9/NWp9uGef8/a+7mmncGs6SCXt03FAA0pTh+QG7KxRD43lq1EmRc+4FbpxN60tCR05yDWRlHpjfrY9eiffWbJzilSYqMjp3SMvKFgMEVGU0JcoxNVnXamcClxqWSZ4ydeuam25sgHtQr5i0Qa4gVnc52pPl3uZVDiAO9idt9eseyvlRY2eN7TJho2qSZMUc6w0SI1ScAbaJSwMdFgM96UAhPTYXJeRl2vSBKOtSimWR76LHA8iStQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199015)(2906002)(6666004)(6506007)(6512007)(26005)(7416002)(8936002)(44832011)(83380400001)(5660300002)(186003)(41300700001)(86362001)(8676002)(66476007)(66556008)(4326008)(9686003)(33716001)(66946007)(478600001)(6916009)(316002)(6486002)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UxJsO4g2/6sVoYgngUc/cOy6Cw4MSQUyUcz/o3QQgeUoEcjHfPgu/U3I3n4p?=
 =?us-ascii?Q?d09sKomducFQRg+perYpSkdbmRD93NIUsS0NwNz5kS9636QLnhUPv15pGtQo?=
 =?us-ascii?Q?+wk/opJ4HX01qSROSTvL0dKx9Y+FDhqqLwfRcuSrR89ym2/+kMuNf0Bo44mD?=
 =?us-ascii?Q?ccyAU5oy+iRGj1ptH3NZ/M29BWka4U47TN/rsKNUSxJob6PkgAxdT3Hqj1nA?=
 =?us-ascii?Q?epSqMPslun19khcCIqCECEhnCMEPi24dasmHkSYrSqE3p6+dDnZw05tNo7i7?=
 =?us-ascii?Q?DXJRSllBbuhHqVQPwFdVuhDljdlLJcIYOpSzwM6T7qxCPxmtlrho1i7f6Eep?=
 =?us-ascii?Q?eSy1hCVHsA5b6LsxSj1ZQtK4OL/luq8dCzNfc8jGl1RYRkpNLGz8LOPb+8Ga?=
 =?us-ascii?Q?q2+755Ro/M5V33ILcwsY8ns1wgLsAy4q58CtLhuvZMGvHKJte99VkKEUf38G?=
 =?us-ascii?Q?j+BM2XpDgddK+Se7x1dgbixYgWZTUmoj2ZmVAWh6+aqSQW3Uiic5sl99+9Xe?=
 =?us-ascii?Q?EVS7QVps2Z0t+OF5BGLC9t9C6GBJAWQLZqRbDHjWAI5SxilBe+zLoJ1HgZaa?=
 =?us-ascii?Q?EYp5HcxSnLEgZKqkqQ5gLMepp56PZ0WzI7ylTGmgwCSQFkkWL+v47JsDgawm?=
 =?us-ascii?Q?co6KrJRo9oUPClld5kCRnnkGyrCX3gTvW0zJjx+rQEFECaSvU3cZ6UgYA5fr?=
 =?us-ascii?Q?mqUumuEIGorN23n1GEnM+mpS2oB5GXgDqy5lHYNV8/xjONMOxkyxYZjNM2zt?=
 =?us-ascii?Q?G6QWzdNcIYPVL3E8GAsLktdwftR89lQ5VAX/x4pVyC/dd4WgxFDHNGBpmXra?=
 =?us-ascii?Q?VlZa4SVmZYfwcyIVcoqSq+vqFlaFvczepwzF8LiLo3qfnmEEiAfA95WKBV/t?=
 =?us-ascii?Q?Eh8mBik5IbspuT86E9oIuZAafk0xMRHcs5ngPEIjEcDztkEvh8QG5Z+8eTpD?=
 =?us-ascii?Q?mPst/xp3QfU3vYJ1gZ49oJVo45zh7FGKHD9KohPRljl1s9RyjmRUMm/rESBG?=
 =?us-ascii?Q?17TRH0XTsDCmB2Xw7ba2/ZJ0FSp85VKFlu2zO4+zl3XIcIxbDgYAARhVv2pf?=
 =?us-ascii?Q?YAI5jn1VK6DRAhjg4BiQ52Uh7buC/+lDZ6m4mtdWLJAlcUDOhjVPnXQbS+MY?=
 =?us-ascii?Q?9F9mAJxay+7ZO3jjaA+t/SSsPpEIbtVSFF3MFL5HI2fc9l4JFVP129fdwEdb?=
 =?us-ascii?Q?dullkCepk4wx97So4hXNzb5crKQNIOhV3q1OiOCDIxn8+5qYfJ+/yEewhFvy?=
 =?us-ascii?Q?QY34mtkUM50LFkR0D4ys4S+AGeJzKdsF1d+xQ+Tas8J9IyLZcnO8SITg0t1x?=
 =?us-ascii?Q?lKRqz8N+ZJJR/4T7JpYDB9IECL/GLvvGRNicYnK75V0PxEFcRHpH6vruMkCZ?=
 =?us-ascii?Q?WQ1KYZxNsmMICVZ3I+rxtN70a5NQFU+lz9X4YjVQhkG7nKtVv/mbKfjPDti5?=
 =?us-ascii?Q?iZmo1s+5MmRFM+Svlz44l1507MWKLOIJDj1lZ44RsjHq4sYE0zl/8Wlrqd4i?=
 =?us-ascii?Q?XU8s2+vsbXVOnyhBcSC3zH67zpX+18bnVSmKbzhbrQLzNN/BgwKv0Bop4bsp?=
 =?us-ascii?Q?0APrNKdmgDaIobcg1YLcwlBmrwGck1Kd37m+74QQUWzf+RMbP5GJiLLJTLtI?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 857da77c-d593-4e9c-642a-08dacef58e06
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:58:47.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAzTkyT+DQ+tyd3uuxu7TTEJSW2GdcaLvYavHSk7mj8Wn6MwCvX+HSZKTkhvUfvNyf+OfldHd3cf5Mc1kNR/bDv6WwS91MbbNZFxqzD4E34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4585
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 04:29:38PM +0530, Suman Ghosh wrote:
> This patch addresses pfc_alloc_status array overflow occurring for

Nit: use imperative mood

> send queue index value greater than PFC priority. Queue index can be
> greater than supported PFC priority for multiple scenarios (e.g. QoS,
> during non zero SMQ allocation for a PF/VF).
> In those scenarios the API should return default tx scheduler '0'.
> This is causing mbox errors as otx2_get_smq_idx returing invalid smq value.
> 
> Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
> Changes since v1:
> - Updated commit message.
> 
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 282db6fe3b08..67aa02bb2b85 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -884,7 +884,7 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
>  static inline u16 otx2_get_smq_idx(struct otx2_nic *pfvf, u16 qidx)
>  {
>  #ifdef CONFIG_DCB
> -	if (pfvf->pfc_alloc_status[qidx])
> +	if (qidx < NIX_PF_PFC_PRIO_MAX && pfvf->pfc_alloc_status[qidx])
>  		return pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][qidx];
>  #endif
>  
> -- 
> 2.25.1
> 
