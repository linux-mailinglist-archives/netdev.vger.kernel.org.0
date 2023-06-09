Return-Path: <netdev+bounces-9570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C39729D3E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0E5B1C20E81
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB5B182AB;
	Fri,  9 Jun 2023 14:48:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6BC15AA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:48:25 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B0EE4A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686322104; x=1717858104;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=s5Ew7dvYaKJfo6rpWZAQRF0uBWWu1jc439kydeUcv/0=;
  b=KrLb3VFV/Ys/es0+exD/gaFw8BCW0UcBz2QrT6HPK9vOnJFJtlKt8Uv+
   zTJcE37YoIC8n/wuIbRiNhu6qOoW4MAvBHVn1cslSbhoKmlGaXd5hOWKH
   RoPFTYGBBtIHHUnLNolSf76FREjMYFhvy9VMg/xAHoadk9vjKCiPmDtSf
   gXpodhu0Q7+kIxCcGVIuUfCxeMIRbVY2ORepara2b1+lLJB9LSVgvbegO
   es3d/C30Dwt4OW2Zu2YKkrmoR4PWGKLR0QYncZMaqqqXmHnUMVgVoWFns
   Ozh9ySsk+fPDdUVgh5kIla2IRKY+SWptgjx2i0YMJDd1honEun1jfuHd9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="443982380"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="443982380"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 07:48:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="780340718"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="780340718"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2023 07:48:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 07:48:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 07:48:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 07:48:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jcjh74D3cNGpNfO8A+8SoJezXrt9VE6Xvr0MQWmNKy+Grqr+s7mzf0sgXX63c34MCT2P1nTZoP1Q4JbkroPgc3bzXt16ij+9T193N/1CacFbF+lm7JeCPrJTdqiUZbpOzcbhq+gz6cxxzztMnToBaIywUsCMTEF+CClaw2v5D/YrCQubULgCYsaqxf37fBGt5vkqtWUwlXIJ7mHMQoo7iDEVuFay35SnDtOMzSh+Ll7YQmV2MmWCH3CBKYuad+K81hnyl1rHyg2hiN5mMPKuchZvRCZdxXrREwoJG/kiWj4zG0U6efRDVBgKOc6XUbUaiENL1SqkW9Z+RPpGqtkzzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqRPApTPkbUVCXowYnPcepp2bXDuC5kW4AL8KcJzXKI=;
 b=Nh5TX6yeqU7EkYnDXd1Uyo2qj2Cpyd5yLQfJVJ+CGaOjnhWQEVCCOaNskfd9aCgEj21xsdH3vkJ0r+HkLDqszmZaX4Tavqdr2We9TA6G3gK9uqUay6MLUx+TSTabyFZURT6FT/1YkijFZKXEzW93ZkumLcyiCjtbwAMasxri5BUyRV8wGujuYSYjVGC6rWt/Hspc2r1JTWkv5/dUpzJVkCVWLC2gyN8jA7SA82oPyeWHWV9HjXFg4AookiDI8eixNiJSodQJQpGI4st2znTsU2DJyn0DWR1doFQZSX6HbfAeM+TGeyMG/TY9BiKLN7qztTBzUyHXFLXG/1Q4IQFDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH8PR11MB6732.namprd11.prod.outlook.com (2603:10b6:510:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 14:48:16 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 14:48:16 +0000
Date: Fri, 9 Jun 2023 16:45:06 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Shannon Nelson <shannon.nelson@amd.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
	<brett.creeley@amd.com>, <drivers@pensando.io>, Nitya Sunkad
	<nitya.sunkad@amd.com>
Subject: Re: [PATCH v2 net-next] ionic: add support for ethtool extended stat
 link_down_count
Message-ID: <ZIM68vWe0nRSTkBv@lincoln>
References: <20230609055016.44008-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230609055016.44008-1-shannon.nelson@amd.com>
X-ClientProxiedBy: FR3P281CA0161.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::20) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH8PR11MB6732:EE_
X-MS-Office365-Filtering-Correlation-Id: 8486c53a-cca2-4207-67db-08db68f88d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0iY4LgIF7IeG4g8dhEpVKtelg0fDYLR7MGakaCUCiqHSF0L5UPGeIqZPTrjVYd8tj9IqmxbaPaCmnFN1Pn6shAE1sRivufgjkG+ussu9kvjSAegXq+e8FOvzcFn2mAjQodx5M5tCVwoM7qK5bXbDMHO9osP2qZ24LPAZSCoCSQ5nWvcdkCQgt0i9V2IHT77HJf33pLFldH57COVLvtEv+H+W11SekCL0ZTLxuhBldd8EQAWpOTypgff5aA684Hb8tF7qcZ/dmbB4kwaI0t9AGA7+P19CLDLGzc0Yu93gXidnYKr2WrRdjQOF8WEPo7xFXWSZhma79WV1UYy0RiNCpI2CiLkUAW4SrgSxgvIOm1Wh0WzUahioGfgC2mKi4Qojo8OB0bXKpC1V31zJUvhfltWG8RcbfbaK3bxKZbvKOj0EsEqwNDodsuoPSpKKImkwSuVdNkHQNM5dGex+cIPvtNOAt2xDC7E6rqNr5BWMVxFKf3AQGA9PLZIG9ZLk4FuM8p2o3kA/4OWbCPoSLIzOyJ880k95AtUxVOdUgd8yt2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199021)(83380400001)(186003)(478600001)(6666004)(6506007)(6512007)(9686003)(26005)(86362001)(66899021)(4326008)(66556008)(44832011)(5660300002)(82960400001)(6916009)(6486002)(2906002)(66476007)(66946007)(41300700001)(8936002)(38100700002)(33716001)(966005)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SvrKRXInU03yTilEHs1Y7xw7Agf8BjXekZQIe/dhL0y/QOkRmyiiL+ycr+oz?=
 =?us-ascii?Q?JDj1kAT1ivWikd+3lF2hHYlvZifZwnA29Xqmtq1ZATLRVJ5e4qo19i8Ix79z?=
 =?us-ascii?Q?7cTDy3bGxPK34rNoQi+P7ObesZx2fYKhYs1uGlpJsaXc3/RFxO0O4Y6cJRwq?=
 =?us-ascii?Q?Ht3WQmfIqjf6Nxv6yqi5hgyNChacHpA5qVYpmxqOz+eBzcQcDuXGpEhxRh5A?=
 =?us-ascii?Q?Si0y7w/rVwpWjpnXgNryMBhHasS/w5nPHN3qXq/oG4nZv6PPiEdRKYtqqeRx?=
 =?us-ascii?Q?uY4yyNi0uCiX0S086xPHxN9Qy+IeRsegtqZ2J4Cc/eDbGzsTtP3eaP7TjiTx?=
 =?us-ascii?Q?E90BGwiE3JPEYL9kSGVmb8JwkQio/QXuRivc779NtG7C6K1PRsTccGpQ8l7y?=
 =?us-ascii?Q?i8vH7ENvYWbfW663lIxRoDwgw5trkPCMXRIYr4oSlDSEowUwx8GpEYO6wQld?=
 =?us-ascii?Q?3+vE9/6aaGsGWRcM6PeE1FSVFeyJznawEgizgu9aGfWR17/JsBEzPkHNxEVz?=
 =?us-ascii?Q?q3Urfqood3/EYIRcVO/Xfz9pE5YVDg1EEvdwWii4x3L3fESrJa3A+UKwzTNK?=
 =?us-ascii?Q?fXQPliheWmTqnKeexHoPfQimNZPKlD1U4+1lNG9UHeDaBhRFMKqh4KMfNCTA?=
 =?us-ascii?Q?05hX1Zsnrah+XUFbXIN+DbmF63xMzozuxbfArL5vXmnPZa8YBH97AwXhxjdH?=
 =?us-ascii?Q?KeNRbK7WiBulNRhRB8exlYQ+5Zij25L1/AU15bpTs6BDU4yChfVq1YJz3zUg?=
 =?us-ascii?Q?KUHNUjY2D8v7Wpa1vDQ8r44/Z0oHq5e/KSsMnJNaG+fSHDS7iJru98MCKI7t?=
 =?us-ascii?Q?79NDFLzdxvwWqo+6Jz6JDcbhocwcI7R/BQDax3Q5dIpZXdVpnhn0uUqGlgAO?=
 =?us-ascii?Q?LFFY+nc/4rVzjJ82an08LzpIndoJYu5Z1Mr2roNPBqBksflXxxiN0yC70Mq4?=
 =?us-ascii?Q?SQhvxxEcbVauUXnS78dVJKtrnzSgoLwlQLC0K8017xJf+XmVLspV1aJd/G9j?=
 =?us-ascii?Q?C/ngRiuXB9AvfnWLccRDd2Y2IVwIQn/fEsWfpPeoVt1ddl/T+3kOEWjHtokW?=
 =?us-ascii?Q?4UxZvcxQQTdXPGjSJQ3sveEk/C0v9gS3Oj11EvHiTEKaelXs5vwH6yLKkzdu?=
 =?us-ascii?Q?5eQYhCm7fHoP5ChkdECpI1MaJtNbM18gNnDauEFezYV2dVlMoA8MFx/Eb1kb?=
 =?us-ascii?Q?yRJxm2RUl4264VDiCJMcPEjNWspDB5U3SayN+xV4UDDgiWnZkUD9Y0+ZZRjs?=
 =?us-ascii?Q?gfcZan+/5AlmLcAwKaV4NCRknabA8w0pDDRgoLnXK3u/gbFN8s261OJLdFCz?=
 =?us-ascii?Q?5DHNLKh3cy86uTO7BRrmUd22MvNgArgov53ykQwGyWUV/d2w+poFhpidXGYE?=
 =?us-ascii?Q?xO5pbygbRednb3eWpcKybOdrKTPVyNQcMLi30cbxEitvAd9V/XYBAVu6z2W/?=
 =?us-ascii?Q?4vEV3L2LX0K6HBpGjvYELthN7Zy08/XHyRqSgQTK/APWirXQauwdDV3tZSYB?=
 =?us-ascii?Q?hGZOuzTgxW5bbgJZbF6qEUu6LpK68e2vA9FrWCXy/d5bqCBRuWq1qWb9iJgp?=
 =?us-ascii?Q?LtQ5mgJXa7aDLipHKlwdOUbEXtQ2TLSKDWDqwy0QI0jMwcKw4H95zJD+LDKR?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8486c53a-cca2-4207-67db-08db68f88d4c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 14:48:15.4744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eC51t+QjJ8y8hEZIDgZZYu1j6FUB8m3p/k5Ubvdasb7UitA1PZCtCY7vdXDoOZZYx3taKKWLdO1IT0Ym9Sj6TdPwP2wZfYn7MJlAFLDEfwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6732
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 10:50:16PM -0700, Shannon Nelson wrote:
> From: Nitya Sunkad <nitya.sunkad@amd.com>
> 
> Following the example of 'commit 9a0f830f8026 ("ethtool: linkstate:
> add a statistic for PHY down events")', added support for link down
> events.
> 
> Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
> link_down_count, a property of netdev that gets reported exclusively
> on physical link down events.

Commit message hasn't changed since v1, despite the comment about usage of 
"added" vs "add".

> 
> Run ethtool -I <devname> to display the device link down count.
> 
> Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
> v2: Report link_down_count only on PF, not on VF
> 
>  drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 10 ++++++++++
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  1 +
>  drivers/net/ethernet/pensando/ionic/ionic_lif.h     |  1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 9b2b96fa36af..3a6b0a9bc241 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -104,6 +104,15 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
>  	memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
>  }
>  
> +static void ionic_get_link_ext_stats(struct net_device *netdev,
> +				     struct ethtool_link_ext_stats *stats)
> +{
> +	struct ionic_lif *lif = netdev_priv(netdev);
> +
> +	if (lif->ionic->pdev->is_physfn)

Maybe

ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF

from [0] would be a more reliable way to determine, whether we are dealing with 
a PF?

[0] https://lore.kernel.org/netdev/20191212003344.5571-3-snelson@pensando.io/

> +		stats->link_down_events = lif->link_down_count;
> +}
> +
>  static int ionic_get_link_ksettings(struct net_device *netdev,
>  				    struct ethtool_link_ksettings *ks)
>  {
> @@ -1074,6 +1083,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
>  	.get_regs_len		= ionic_get_regs_len,
>  	.get_regs		= ionic_get_regs,
>  	.get_link		= ethtool_op_get_link,
> +	.get_link_ext_stats	= ionic_get_link_ext_stats,
>  	.get_link_ksettings	= ionic_get_link_ksettings,
>  	.set_link_ksettings	= ionic_set_link_ksettings,
>  	.get_coalesce		= ionic_get_coalesce,
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 957027e546b3..6ccc1ea91992 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -168,6 +168,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
>  		}
>  	} else {
>  		if (netif_carrier_ok(netdev)) {
> +			lif->link_down_count++;
>  			netdev_info(netdev, "Link down\n");
>  			netif_carrier_off(netdev);
>  		}
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> index c9c4c46d5a16..fd2ea670e7d8 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> @@ -201,6 +201,7 @@ struct ionic_lif {
>  	u64 hw_features;
>  	bool registered;
>  	u16 lif_type;
> +	unsigned int link_down_count;
>  	unsigned int nmcast;
>  	unsigned int nucast;
>  	unsigned int nvlans;
> -- 
> 2.17.1
> 
> 

