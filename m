Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC06D54D5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjDCWi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbjDCWi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:38:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13414C3F;
        Mon,  3 Apr 2023 15:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680561505; x=1712097505;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SVV0BS0NCOPXJWNXy6IY0yyro0GWCU9cqqeSuGjv2hU=;
  b=cUDndrgYBB9HpxJVMSwAiLFWbQJ61vgJwQ80dqXur2fb1aSJk1HDMm0b
   9t2SxbQSWtpw7GmEqQfC4VI451N9V82l9Pm0IubHSeSREg9TwOwU0Hzhp
   glfmgUs9kuJP9g3efSYQEctZu1wWpYHBfHWIpX6gdqRbI3c6+VUII/3fO
   QSo1ZvTB9ou13D3SD/zu87GDm5/JTgLRQrK6H2KWduBo5vxqb+ezz0cCU
   nNzFpNd2Wu86ewzaapaLyfwyaz3pGqRtFRIecaXyAYeYk9D2TuZAzvEjD
   CQ0RymO2KuOR7YkmYUfR+qclFrnZNJzMbffqx6qcUy0RlprxBCj9JgGwv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="344590120"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="344590120"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 15:36:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="809997366"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="809997366"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2023 15:36:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 15:36:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 15:36:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 15:36:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPg0VbPOE53vN99TzD/QQy9xOq2A6zOfp0mfbb4pSavp5mRWUWcd4SMle3ZljjGNYYwfzMSh09TFrn9GIUOtAnbR6mhuU/1Ve16guIZf3oMv/FidkH7Kuj+4/bVhYvtuZ7uG3PtmR0Cqo6R/uv0fazFz5pGQu1aqGgccPbJpuUzOClhq5QdAveaPcjmli+FyOLNTKLY8TUSbDf/X05GXThQoj/E2XT4c4sRzoZcj2pOUL1hGVyOwOUZNsw+XWkHHdHnKqHTdDx+3vmdCH3x1eOWP3cci3ywBUSNkXu95SkdzHbrdod/cke72r57OS8NZsHvQwuewVVJ+QOC9M9kFig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCMottKjBTUDFBzwjR0FeyHOsbZI+FWHLgdklYz/brA=;
 b=IdZ55TagpBxl+gNgtjMirjJnjM+LS7xroioz5ozmY0f21lUbwpynxqJgc91s5agRHylo+56T4E+rqBIFik6MojTYr+7P1Zll1TEwFX1aNMPCidN9Rks2I9/JJGXeZSeH2h6D7ZoHBXe6Jb9OL7B+/PKQfRKGgC9oAAc99Lb1+nEYesAG97VqXsnwyObfuRJa3LaJzvLql9jl2OViKQDPyJvXstPMYYcpGwFAV8VqWrt1mndIG/QwNfbmItgPUQHUqSrt6sk2fyrlx7wmpqkdrGv3Pswk9UPnZwLuPElvvrFJjCWkWB74m4e+f7MjUyPKzh8MISXEu7I+dBzJJItnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.30; Mon, 3 Apr 2023 22:36:49 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 22:36:48 +0000
Date:   Tue, 4 Apr 2023 00:36:33 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bjorn@kernel.org>,
        <magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 5/5] tsnep: Add XDP socket zero-copy TX support
Message-ID: <ZCtU8WN+NpNXS+N8@boxer>
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-6-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230402193838.54474-6-gerhard@engleder-embedded.com>
X-ClientProxiedBy: LO4P123CA0055.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS0PR11MB7681:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff30e64-ade9-4e5a-eb5c-08db3493e93e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URkNbZ+HJem2KmK2Yi3tKJ8u84MTAFRf0YK6mCtou9jc+JFJmDUFIAx2eA3KYSDBt+ec0b9nV71d1b0l5H0C2kDfwVpPm0PXN/YMZwQQDiH77jYkyiL5IHf6DVDyiGc0ujK64lRGYzYLVQDRYbrDos94Oh6NSLk1oe3ERq2e/9W2SyUIMwmq4PMBq6Jgz5u1IDsOAfHiJp47DcZk6yFAtg8w/cFsdAeL3eykgCpd+qrLV6bbb+aiHduGdv+zwDZCeofGZRuBi/3TN7OZ+ecc1a3r5Oc+BrBJ0iI77yuNUA1Lo7nApHwmfMXW/OT90dJQwQhSAjGx0AB7rKX/g9gQ+GloAfJto8mRGq65BEyGRBN/3qCxsvu6Kbjiz7Y13XyHoGDnKnL7Ohf1F2eq8LnjGJqwvxUFjExuaAoN1IImIrkbCopQJq9XQp8tyXBvIOgjh1BQmeSvkBpK7+yRwTRGkWmOvyxOp5OHugSBn/3AScDimQISYk8pGrCH1IKC957peBIZYUkrVn+dJjMiOnhJRD+bGdQEEIuTtZ9eXh5nKEoYqY7swjt5Vd89bVcdLE+Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(44832011)(478600001)(6666004)(186003)(26005)(9686003)(6486002)(6512007)(6506007)(2906002)(83380400001)(86362001)(66476007)(66556008)(66946007)(8936002)(5660300002)(8676002)(33716001)(41300700001)(38100700002)(82960400001)(6916009)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8iRAjwUNZWhqu6KA3AeFbuhzQxDHMx0P3nGg4crnBBEiGWqghoAqhEb1EZFw?=
 =?us-ascii?Q?PM7TkaFAatz+pJSsJ7lh7JxD6upqkxVoGaLIIsWvE8nB8XAr3hPaDG5ng9Jy?=
 =?us-ascii?Q?k6rT2CenTPq5x74+0qh9J6co9c3OE+aC4rS8ytFVE0ELgFDYpMm1Hpa4QIc6?=
 =?us-ascii?Q?Hz+XHOcg92BLtR4P1RAq4ka/e4mDi8rvwqqgT2EgG9Zw238+fkemHjBCMZXo?=
 =?us-ascii?Q?PrbLNrSXsdwvxo2Ybw3c+QakyK1J2XL87vbQw4/5anZXkaCS4tn65RpSkdLK?=
 =?us-ascii?Q?3rB4LSRtb9G8qAo+NUQnb5WgKYtbZG4T54YSNM1QxvFCa8AsPw7eZNXDOaQ0?=
 =?us-ascii?Q?S6sgKgVaf/NPMmgjBPj0e9WRrymobu+lNBeQ9JPKxHd99FaV8co9LIAuAN0c?=
 =?us-ascii?Q?uRbenBKnmbKls0Gqls6Tse0Unjb99wPwo5ee9+80nH3VaTsM4lCylZM4nbrJ?=
 =?us-ascii?Q?Ix+ksgfQDPihCPR2jg2BofOs6/IgwFCnUqOzsrYYm2xzvlVnXXGZo0svwHfY?=
 =?us-ascii?Q?+jiDxtPkg74JnSByAZueTF3eK9OKGDwcEqDnDcwU4A00OseoUOKFZ/EAARI8?=
 =?us-ascii?Q?pSVmHn/Toh0Kg89vXPpIXE7hNceoDhvYo6pXgAe3hzGVa0XSf+8tvsfFYTfS?=
 =?us-ascii?Q?/5ZSBBWUyxLqO3PNokClV+PXbUln+4f/ikmF2cugwTRM2lRlvaf2bLuqqoCv?=
 =?us-ascii?Q?WIXvAPav3WC6KOkh0wqAe4h7lEJjbyQ1KWnzQ6sJovYDNcE3M6cE309oXzho?=
 =?us-ascii?Q?sb8dVEWd8u/cYSXE1ERKLyNU0SVxzPO3MVADwqgAXw03eVHePfhiULwvNtPE?=
 =?us-ascii?Q?IyTMXdX5JP9G+8vqhEQbX2y84+xlhMu/6bcPSt/TYPqKVu5Xi8aDaHDOrdnS?=
 =?us-ascii?Q?vzSPJ2Sfyl7ctTfaAPGj9ICbEzaQ3C4J3bQylHNcUT/igdXEBN9tKqHgSjrT?=
 =?us-ascii?Q?7cDFhSqubr44n/Fy/XzmfgWL47a974cPuJQ9uP9wQCcPyYy7MXGwxEKHEUsp?=
 =?us-ascii?Q?dqGRfm4+wWIim2LKtTFABtagWdG3lilDUJkWtpZAqfo0T0XDixhzySaGfAr9?=
 =?us-ascii?Q?ahY0tjVhFbk+dEkRMfd1JX4vp5tkwGFvY/+rFQsm/9vmCaGqPV0wNrcRZQTD?=
 =?us-ascii?Q?SOq2mQM8/N/BL2UMLrtk9gT1OVYSVOuNPuRTQtkSUDEeaPdTGHDIVenWSx/k?=
 =?us-ascii?Q?3jsEFuhChkMsTJD4RpMqRZ+1EZrjHnweYX132PqVfYzvuIZR4dIxyvH6eNV0?=
 =?us-ascii?Q?K8ldIxhh/yXjVcnXEtdrFHOrOe87zs34Khxmm6DDDqsdGKdbjp30KjhyBPsU?=
 =?us-ascii?Q?s2tEjD0ejyc23xdLl5aoXAkWbEeUKRQBXeGulQzQGHSLtMNhkPIlE1VEXYh2?=
 =?us-ascii?Q?ba4UydCIbr0t7UequcMDhrkfXr1koBeZ4dPoqDC9IkPNzvSuE1yUeeZ5OIj+?=
 =?us-ascii?Q?JVFUNx56IUosJGes12Hrx8fx6hgzdxaYeaA8RlI4u20USGdP7i2rlNBfC4FM?=
 =?us-ascii?Q?BEHstsFVtoNTzpNTZ7Lyr9pG/ekkggdouFnA+HRRdzs5GJHo1s9+LDQvxbeu?=
 =?us-ascii?Q?jfnNS+Pbttz2hdZscfaEVkVwK+QVThe7Oe+x5pHFJJPOZnVQmAmlFNTNTNLd?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff30e64-ade9-4e5a-eb5c-08db3493e93e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 22:36:48.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEhN1w7kqTholwoQtD+9msZ7bPQB8mmKfTtwvAfZufC7uBK4OWhiFsrn7PadUTWd4ISx1mKuvNrYUmeYW+cKsVNGzERkWu41O7Vhsldi7xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 09:38:38PM +0200, Gerhard Engleder wrote:
> Send and complete XSK pool frames within TX NAPI context. NAPI context
> is triggered by ndo_xsk_wakeup.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |   2 +
>  drivers/net/ethernet/engleder/tsnep_main.c | 131 +++++++++++++++++++--
>  2 files changed, 123 insertions(+), 10 deletions(-)
> 

(...)

> +static void tsnep_xdp_xmit_zc(struct tsnep_tx *tx)
> +{
> +	int desc_available = tsnep_tx_desc_available(tx);
> +	struct xdp_desc xdp_desc;
> +	bool xmit = false;
> +
> +	/* ensure that TX ring is not filled up by XDP, always MAX_SKB_FRAGS
> +	 * will be available for normal TX path and queue is stopped there if
> +	 * necessary
> +	 */
> +	if (desc_available <= (MAX_SKB_FRAGS + 1))
> +		return;
> +	desc_available -= MAX_SKB_FRAGS + 1;
> +
> +	while (xsk_tx_peek_desc(tx->xsk_pool, &xdp_desc) && desc_available--) {

Again, I am curious how batch API usage would improve your perf.

> +		tsnep_xdp_xmit_frame_ring_zc(&xdp_desc, tx);
> +		xmit = true;
> +	}
> +
> +	if (xmit) {
> +		tsnep_xdp_xmit_flush(tx);
> +		xsk_tx_release(tx->xsk_pool);
> +	}
> +}
> +
