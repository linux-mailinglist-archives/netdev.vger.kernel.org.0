Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA6F6996CB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBPOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBPOMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:12:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F93B87C;
        Thu, 16 Feb 2023 06:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676556752; x=1708092752;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0AA/A7D9WKJmOBloeXurO/Aah3JFaQd6O9cOMLviUYA=;
  b=nzC2OU4OEcxPmXN0ROJJi+sifLprZxYd3J5TbcccnO7zH6fIvgfOvhh/
   QCSKGZCIhEU6coPRpxO+8FWilWabIXPkCB2zKmQqhvT8fd1xBg/t0ijIM
   aJIs9s3rvu5WqhIOxyNwVP/cayZsftgCs+jIUS5hBR1WYkOak1DhlJzAU
   ADNBRsxiRg5TJC03SWr2kkDaw/8KtOXnbE7gZwpAIEkLi2W+I0qWLyuBT
   hJbx44lP/eC1r7UwI3u4DED9+vb4OhMLYh+zeRT8i5CT6h9dm4cMY9lkf
   rzAvFbNTpKvN7zN1DZ/crQz2XpYUHHUE3NL/ExZOB1+/7RevW3jr8I0a8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333051474"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333051474"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:12:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="812979077"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="812979077"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2023 06:12:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:12:30 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:12:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:12:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkjtEFo+7UgqmYI1iEtFauxEQA0BFnsPNBfsMJtYq332O55oTTwUKU2r4HU3PD8VK7dPGCO9aR5yJH/JE57eoI9cW8Q0UyNEdAP0efVuhBpwfkGOieXPKUlXtkJHTPtMzPPYtcYs84RTyT62aYs1b6BKqyFSOPnunw1F9sKKyAPXkrtwNNxEt5sGMwy36K5BXNwLS7p4nJs1BK7fUwyy1u2nE/tMb2Kp1WhaqdlnJXO7JKE9EEJ7MjpnqA6dKcop4u/Hs99JAbeTg3dkOct+20FHvEEbMww0sohSmAvL9m9l57c0zlHAhZMstY6jPGu1gTG9Rw+8Blo3mn/0SeAtag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2vs9xfyy20GVj0e7ogBXx9uLVNRm5yiFhfjnXWbBtTE=;
 b=LEaYxgsXZdCPqlAUUH0EgRt630NeQM4zXKbSTRyHzCcvt9RwRXC1fhBpUtc7qmKQbz0PqzwwQZM3nQxryigfzNpDfdhPqoSZsIOHmZD6WKJ1yzyaKJEdrl4/FftR1e7Y2TxVG3StlVWptdkmQqGZiuzovli+aqlm2h81BnN7dVlLlXnog0F72rmfVfbPFV2Gh3VaKqjEg65LwMMX9juDs5qDFY9jcF04MaAmNzX8Ot6dNMlrJz9XmHwAYb414bEuJgMpVqoj5F0aJLCiqK2KhFFwOaXhaONaWW8nlZEbzcaRX/b0P+StGUBbIP0dQ4/mPINw1x9izcBQiYR3Pj+ISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by CH3PR11MB8210.namprd11.prod.outlook.com (2603:10b6:610:163::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 14:12:29 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 14:12:29 +0000
Date:   Thu, 16 Feb 2023 14:54:05 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v2] net: lan966x: Use automatic selection of
 VCAP rule actionset
Message-ID: <Y+41fTUfz8Kx6ujH@lincoln>
References: <20230216122907.2207291-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216122907.2207291-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: FR3P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::16) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|CH3PR11MB8210:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f5e75b-d5c3-46f5-589d-08db1027d650
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rwm7EJ3b8VzIpDogzwVHL+lZSQgmMeIJW/h1E3jsCYOrVv8PGiP5tfUqq507Ee7p6zos575vlqUw/JlEQBPnh0kYmleL92tSLKeXpYnGNamGbHSdBVBVo+k9DyLJPLih4/9UvdmFXAK1uOSI5Qldjv3SI+iZjk/c4A5xkjJRIXDwN2fU7qs4xdV461GiUSmA9j6OcX3knKBbCrOmDfZMyLSNfs9pNjGE53aOVyqDRTa7Gs3oDDEzBMsEDNaTW0j5IyRM5b/odrieCpyflSl5V6qZF6pwI5f6gAAVHxmwy2Gg/KpohZrHQssVhKyHoNM5a1AURm/sbODqJnQyR2VYA38OEQ+BZvxUyGAawkNbSYxoUzWdk548+bJgOcQVj/O/pH4+Ceh5q1N+gLWiOZvdByE2vZknanGSShAat0Bqwr6xRp58tnyJxN6h9xNBfQr0+b2Kx0YRlkC0McCnrf3XKEA+wYOnhhWD3HZMz7T60qpRhluXi4/oSOuLOv+fAD6k5Gqd+R7OwBeMtrr5zr8SK4v5PAdafik7pciZL6qHK7wRwaHUMKpzvMFdJ9AolDhXFTIuUZeZ96Uj+yua9LFXMdug3zqJGG5dPx/EU/FAJHHzbOFWF8q7w+G/n7k4zp/5OJE49oY6STJobPGcV6ptOVFvl4LiryneStKyTONlKUd8zlB+D+09uUhORgWzns3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199018)(316002)(66556008)(66476007)(8676002)(6916009)(4326008)(66946007)(478600001)(6486002)(2906002)(41300700001)(44832011)(5660300002)(33716001)(8936002)(38100700002)(83380400001)(86362001)(82960400001)(26005)(9686003)(6506007)(186003)(6512007)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ZeMh6w2/pLqPpxGYm7CBdWPqlg4BCERyRIDv+q7GAsOaBadla24x93HkjQt?=
 =?us-ascii?Q?q3b+Bq15/TnnY2F7p3K7AYEzU0uqsdJNfoENmuoHYZQCfIBSoXGJWq4EDi4W?=
 =?us-ascii?Q?widCtpqGAZq0A6npT6TL0hwPVkbAOnry/b4BY3Gp0ZSI4KQrOr/tr9YB37pn?=
 =?us-ascii?Q?OXumJqDZVlwBRQV5+Fo5LV7gT4+x8FC5rvkvolz5fJiws0Gj46FEktGx2Vy3?=
 =?us-ascii?Q?1JqUaLMx15TZEv61JFV3EIsqqwBEx28YWDV0RiAhFwp9DaxduYFzDPjjmihM?=
 =?us-ascii?Q?cHezUuQo30Wict2I7JQe5howKVaKcv4X1cYK7HGe+5F7QsjpVJuRZlBcQPv9?=
 =?us-ascii?Q?CzNK8vO1t+RTDwmu60ZJ/JAkATt23dylvF69Ex+W0P9vkd0KQlOUUpy4WspD?=
 =?us-ascii?Q?g9h8BPHMdoqsgH2kf/u67KiNG0+xcJLasjqYq0A1I9kU3q+V9SuybV0/+q1N?=
 =?us-ascii?Q?+PueMCjGkjERi5qWQr8+BXu/jkC837fbooNTTMHX6Ad0b6o5fG2cTkYtYVVv?=
 =?us-ascii?Q?1rJ4ryfIvORvJygtJjms/UwPnixhss274uoNR5jqy0YVHc9jSJS2Sa96cV1y?=
 =?us-ascii?Q?TQpoJkkrEt8eYEgTsXPON3eaj5ZIu9sec2wynMIumx37L9ccmuqgkrvkslz2?=
 =?us-ascii?Q?eJBHeU8pfp8+OQdEHjkgXm8Df6Fd+PhhoTFWDNn7Gxa9ZIDRcack8E/c9x+E?=
 =?us-ascii?Q?eOvyfa9GO8T8UHz4On7RE6w6K+sJkPiF8XAkEw+PdUIFBmmM5SEgXloVFwKw?=
 =?us-ascii?Q?VxXK9QXGo0LIORKuhZVkPqKJhrCUvexwG6oMv49VEoMO9ACI3lCtTb0IONCB?=
 =?us-ascii?Q?QilO1871x8pWk/ckcRZWed7vhlaIdlGQk8migsy0v97qnojGdkyfCFvMgesS?=
 =?us-ascii?Q?IP6atN0fihdLwcoteAxUpD2E3Gt51YqMljnelYKsTPh9TA7hjUzM7Z6qXjN0?=
 =?us-ascii?Q?itnDp/k8UhGOmFXTZlHMnuHTjZ20J8w2yyH+jCn6Y5eaTV9Q35Rt/I4GfHO3?=
 =?us-ascii?Q?fdMOx/4qjl7Cp5FuGJAaOeZaStLEQR+PnKg+mEW0vzQ90wvPdp2jMUQ6/j2S?=
 =?us-ascii?Q?JLm+wFOp89CBx/M+D8p7RQlARAKmi5hDzKp2eSO0Oxz9lmP0UBuL5jup+Y4N?=
 =?us-ascii?Q?SoEznrXGbgkcQv+5/Uu6+gPr0bZqMnioPqxQY9COc5x04tZb3+rgG5+oS/fc?=
 =?us-ascii?Q?9WMaDzXYUml4hgcabWfhw/grhqJSSkUk/oVc9wSXa1cdaJT6wrMk7quS2da+?=
 =?us-ascii?Q?tyPOix2b4j4OQtfVEoo2ufBNe5cejpT5JRkGtj1RALRxM2ElJaBj/Bm7rhvT?=
 =?us-ascii?Q?LP32DRTShPAitd7eLxp9/dpjWtm31JIhsfPtU3XCD3QjLtg5lCC+Ut9bGOqF?=
 =?us-ascii?Q?y09fTFBwsLfC66LpI2Hl4UvNQZ7yWRcVM+ZfkKPNAXNqFs1dmNOB4uNw36kn?=
 =?us-ascii?Q?FfLJEm+Fukr0KzmLH0F6V4xyF2UziUF/wTdNdnfIQmqTnLi75b01DY3H7pYH?=
 =?us-ascii?Q?4pjdjJCPyQnKm4Y0TmeRsIGN4YpzmtRLF/0rA7YAMp5DEI3tvQfodfiP3Lgg?=
 =?us-ascii?Q?meZMmjBqEf7cM8Q199rik7wdFMGtFglwkA+Yjr1/6G0hXLIwpWm256vxqn24?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f5e75b-d5c3-46f5-589d-08db1027d650
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:12:29.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5ngmOanKbxOg5btCuun7OeU0CBHG1vyBSjmRmzfUz5eBLGuagVld2McOvDNFny/hl4zPGzQN2RQ8FlogmqpUQ5BCsuBrYozsckah3g4usY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8210
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

On Thu, Feb 16, 2023 at 01:29:07PM +0100, Horatiu Vultur wrote:
> Since commit 81e164c4aec5 ("net: microchip: sparx5: Add automatic
> selection of VCAP rule actionset") the VCAP API has the capability to
> select automatically the actionset based on the actions that are attached
> to the rule. So it is not needed anymore to hardcore the actionset in the

I am sure, you've meant 'hardcode'

> driver, therefore it is OK to remove this.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v1->v2:
> - improve the commit message by mentioning the commit which allows
>   to make this change
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> index bd10a71897418..f960727ecaeec 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
> @@ -261,8 +261,6 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
>  							0);
>  			err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
>  							LAN966X_PMM_REPLACE);
> -			err |= vcap_set_rule_set_actionset(vrule,
> -							   VCAP_AFS_BASE_TYPE);

Is this the only location, where this can be done? I'm not very familiar with 
this driver, would it maybe make sense to check out lan966x_ptp_add_trap() too?

>  			if (err)
>  				goto out;
>  
> -- 
> 2.38.0
> 
