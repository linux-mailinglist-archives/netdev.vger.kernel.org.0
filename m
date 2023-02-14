Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6FB696BCA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjBNReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjBNRef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:34:35 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EC82F7A3;
        Tue, 14 Feb 2023 09:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396047; x=1707932047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Scv+TFXTAu2mohxT42y+r+RgzujgWtjeBLTWIJ5Mq2o=;
  b=FOfsXlGhiU7C/e1Pbu8ZcggJtww/P+vjbniVtiCs7GiepYv6Tctp1y8P
   Fc4gArRVTxLMBJwcWY+9KhzdXdLusEOklw0jlMc5fbubc14eNneB5XbWd
   CjqYm9g6KBjvuxB5uSlJDimk1Is1IrGjyOKpQStsqrYdbMJcxyPan7wGW
   Ywz2BztIvVNhAUYlSwjBTUxKY8Vnk5dNADICCFp0vgx18k4BMOF22uyOm
   Gf4Buas+rrmd6beP+zG7coFmOZgl6xXqtVRlifVcMnHHx5Ff2Zc82Wy5V
   KTVSUT+l7Xqe7RyfhrzaRhiWuCv6PMxul7LYF2J0Z/8DGutSGkqoAtW2i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="332528651"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="332528651"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:33:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="812120617"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="812120617"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 09:33:07 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:33:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:33:05 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:33:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7yDiyzOh4F3asP4SaJvlCap2QryjDURFs96eTt3W3uDgI9/i67agBCvq3WXlUDEhfKp8/Wkux1sWzenSPpfsRtm/3bHecXs981B2ClU10kj0KPxQBHgiZY1yIlopA2s+VW3oXeYkEw2x7s63ABfkjpV6+eLqiJzjj7ow3fBadrB2fv+xkVODgA7PWfJJhG0tyySc3URplZh+T1aEhSPHBSMUjRaEOT7rhfeU4qRvqAmmX9ry5Adr6KaVb073yBtKtfn0EesEYtmPMVtZJLBNxgO/GeFzKz5gcK74LCDdRANLPwL7zWjLPx07e+wT6yk5MejWk86+Rh8WtPoS3jxxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+i/rXCo/y9j2fQjJatTmw6LikcKHOEyIkYNt/R6oWI=;
 b=HaXqv9Lx+uNKhgPmhvHqsvKNFHfq8SnjGEJCdAxWG2KBRT9V9iIoTfTepV+Seadzovp+46SvLEmvOfAy78fATpVrTFSej7pqyuFOiZ9rZfYh1CmWAS9Lrblp6WW7QXKMihkfuWUjz6HS3KnGlWCbbVem1y/7MgH9Rwnm1zV+64y7tm5JlKVvtUvgz53kAaHN6NHTqS64G2lWubNDsgGZv2bVHu+HVC/K9kVZ/WqDd0qpNxEYjObA+66F2cBsmS6zQKhfGZ36sg9SIFNeV9QKI8wNYSIR8XB1szqPNiWRhMmcBzlaEx0d3CoLw1v+kdAOYwKj0foRq/duNEer9Q52CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5584.namprd11.prod.outlook.com (2603:10b6:a03:3ba::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Tue, 14 Feb 2023 17:33:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 17:33:04 +0000
Date:   Tue, 14 Feb 2023 18:32:05 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>,
        <sburla@marvell.com>, <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 1/7] octeon_ep: defer probe if firmware not
 ready
Message-ID: <Y+vFlfakHj33DEkt@boxer>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-2-vburru@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214051422.13705-2-vburru@marvell.com>
X-ClientProxiedBy: FR3P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d29ff7-c4ac-432d-3413-08db0eb1870b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6B6I0X8GcKwMOMJaBIClk8B+P222MeS+4/1nM0//qJpxvtCK1o4V1peygXS2AyVQpMXD6mCN2Rn7V2ajwmP3Urah5XZVTMNV/YulgG9WUkz1OJzQpj2li13vFyq/N8EPTLaQ0HMvhDAp778zR2GJGU8zCtALmjdNabccnBpIJFSmchVOmE/MBFUU11r34DLZUKH+FfDsPT2BPgoQrCBbI+8siA8/4WdO7/1sLQ/M6oFi1KxHl9ToStUGg5+agpI7NPqrrTkFOMVh+3Vt3Mch/QNlea5RcLx0BjBNgtXVq0qOsDcRM4ZIPL76eFIlOV9+in3O23A7mMigd5Gh5bS94rPp8BuFRqfiLg+ScDIoI6hm0KLoIcasN0xOfa821VNWU8hDiBFy4rdZ1o73WO8SgnI7tAS0KviklVOiXs2a8FbqDr1ymy4BxIhz+QAy/NCs8P+CHWkjQZyS/pniknC68ew9snfnfypqVk/32u7silf7/DDfTazIleYk0Xie5X37KlJ1u5qjqz6C5fT2q49Ips4U0s+21FhMol84FJuhJeeVHDvb1IIcjaHSWxvBCDkTSFXsJWU3l0WY591kWhsiuzELaizcs4r+gkZFuTcPpS+y3cx7yxmHzqNYIPtT/vkJ4mIouETayM4i16Z56aADSIePbyI9ZWw9Lfh7QH4sGW5/hX9oNZf8n54TGVgXx/AGFUBzzHqGVlMSRqX6riddw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(8936002)(41300700001)(7416002)(5660300002)(44832011)(54906003)(316002)(8676002)(4326008)(6916009)(66946007)(83380400001)(66556008)(66476007)(186003)(26005)(6512007)(82960400001)(9686003)(33716001)(6506007)(2906002)(38100700002)(86362001)(966005)(6486002)(478600001)(67856001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iDDXEzqioIqixVtbJJeI01TMrnjdIlP6Cb22O2Tz66xJkiOg2dZOb89Lr2Gx?=
 =?us-ascii?Q?XqVP9ZatHTAoQLT0mMx64Ok+FDgePBpqyRCuJ9azN7/y7rD5LmcsG5+4vjVl?=
 =?us-ascii?Q?5fE46jB+jj2X1A3v7fmph/p6ZjQlmrSHzf7ZdWS4Qb+VCLGCUi8lNtZrJyLY?=
 =?us-ascii?Q?IGoj+xvYbMSLl5kw151niVvedvvS0wtvW3RlTvOooS1UyM0kpVVlfdBIvZsp?=
 =?us-ascii?Q?S44WcNSb1O6T4LBpbK3mqD1dezlq4837nnDq2VcHJCPmCPsjqums7Bk+I7Xv?=
 =?us-ascii?Q?7Uo0FnuII0d/mCvfyg879zTYKvPccn2PxqoxjuhuNbP1LKjDt5J4uXPTFCFq?=
 =?us-ascii?Q?oSuDvAGnZkK3pVcMt4EhPI2YXqeOHz40BefHfhOa4lhLvtqnW9Ql3dB02b3s?=
 =?us-ascii?Q?Z4/Bna9TQV9AJkaTHF8IgVMyysqHv7uq4EKg+lNc+A+EZInLY1y1upycCa8Z?=
 =?us-ascii?Q?pAZqfLaNjQFRjIPP/VRaCG1PkXm+aC4czUi7pBm+q6Dzlx7YipiGOjhGI31k?=
 =?us-ascii?Q?VUbQwVhwWmsFrzp3qV4Y0Yd2ps+tm23+3wIvydAESOVmYF4pTz/y3BdXwcgS?=
 =?us-ascii?Q?qPM5W3JkcUHcZCkViqxAUU6NwKlQpnEC5xM1oPHfywwOrCTg2CGaWqYzxhGl?=
 =?us-ascii?Q?iWKb6sw0JdCTDqYHFyRMvO6pTApIakAZh+xCuIGJtwn6ISp6BlEj5nT6szi8?=
 =?us-ascii?Q?uouEBIlypiCK2vu22TpkUVMx/AGtLnsmhhm1qfuIiY9+j5uYES+Rk6LaduvR?=
 =?us-ascii?Q?L/SXWfxTAIXeJide0LMEiDBSpLpZ/779RWK17ucWqD45liPOE3Ro2lbngoyO?=
 =?us-ascii?Q?Lg1q1E1Vjt5T6Y457xJOLN3rzKH+bTjl71N5W/5Aa+p3mOWXcWBAZzyvD1uM?=
 =?us-ascii?Q?PpW/3eBb9sftTfYoPhTcxRZrWQHF7bhGzBA1W31cwY74a8G4eEW0lQgataag?=
 =?us-ascii?Q?TUnuYL1Bgvw7T2ECm/g/1bkniiSg233s2PBhlYe0btUPK7aZv3h5T/d8x/wC?=
 =?us-ascii?Q?A/ZwYHvP3QoUHLilM0zUjmZ3FUfKE/zyfwAciUjZOL8VTfeERqax/R/qYiGH?=
 =?us-ascii?Q?7yfnddNVrsbZ4i2Wz32M9lk8bkd7gqTaWtfnsCCy7kkXykShlsSbPrBnFVMU?=
 =?us-ascii?Q?zUQWBs091TDmkspR+b/9QozJDMNH+DPra4KYTxWYCnwxQpTKHvnoZ92f9LVS?=
 =?us-ascii?Q?jCkIkNzeMNLlGC7pJf+z2Z5s/K2eGSPpbpinGwyEW29mgqklvth2yj/B+IfS?=
 =?us-ascii?Q?EdgSUdajcH2AlT4PoFJhB351tsiZylvaxjq6kaRFm8VSDO0YJxLD/cLPUjxT?=
 =?us-ascii?Q?8BmJJL+/c7Wri/oi4ayQAgrLpZiWs7zsLLTXV76PLmXRxtIfXYpYkLSl/DYu?=
 =?us-ascii?Q?AASyFLsZJi/PpZeo+T7RogKV+T+xqAlxWcdw8vwT7FxUvJvjWKqXxvuO5C6S?=
 =?us-ascii?Q?Xf89FiWYNJIEPVEhcqQ7wRX90qXhM7zH28j2Pbrx6YRMgTlMIRWgmwtjaTYy?=
 =?us-ascii?Q?YORxmJfzC2+wmPSmrVGzvrgF5GOaDaHXd3tKIrMJsbk4kc7DmTjJsn/X0Hkl?=
 =?us-ascii?Q?4jEqk7n/kezThtBqH1bUHlVpFlF68BwR6NTh7mt06Kwu4LRbKn1AIpvxRCoN?=
 =?us-ascii?Q?0WmSvTAqjhdTKYPsDP4WqRA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d29ff7-c4ac-432d-3413-08db0eb1870b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:33:04.2590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TQRASIGiW2jKhX9QjCMVP66TRNTwtXtNVPVLW5U42uYqkuPD7ioLp/ZiBpyadaWucYQl5vUG29u6yhxs1Gv7licZRfnNTSYxoEkv+kI6A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5584
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

On Mon, Feb 13, 2023 at 09:14:16PM -0800, Veerasenareddy Burru wrote:
> Defer probe if firmware is not ready for device usage.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>
> ---
> v2 -> v3:
>  * fix review comments
>    https://lore.kernel.org/all/Y4chWyR6qTlptkTE@unreal/
>    - change get_fw_ready_status() to return bool
>    - fix the success oriented flow while looking for
>      PCI extended capability
>  
> v1 -> v2:
>  * was scheduling workqueue task to wait for firmware ready,
>    to probe/initialize the device.
>  * now, removed the workqueue task; the probe returns EPROBE_DEFER,
>    if firmware is not ready.
>  * removed device status oct->status, as it is not required with the
>    modified implementation.
> 
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 5a898fb88e37..5620df4c6d55 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -1017,6 +1017,26 @@ static void octep_device_cleanup(struct octep_device *oct)
>  	oct->conf = NULL;
>  }
>  
> +static bool get_fw_ready_status(struct pci_dev *pdev)
> +{
> +	u32 pos = 0;
> +	u16 vsec_id;
> +	u8 status;
> +
> +	while ((pos = pci_find_next_ext_capability(pdev, pos,
> +						   PCI_EXT_CAP_ID_VNDR))) {
> +		pci_read_config_word(pdev, pos + 4, &vsec_id);
> +#define FW_STATUS_VSEC_ID  0xA3
> +		if (vsec_id != FW_STATUS_VSEC_ID)
> +			continue;
> +
> +		pci_read_config_byte(pdev, (pos + 8), &status);
> +		dev_info(&pdev->dev, "Firmware ready status = %u\n", status);
> +		return status ? true : false;

nit:

return !!status;

?

> +	}
> +	return false;
> +}
> +
>  /**
>   * octep_probe() - Octeon PCI device probe handler.
>   *
> @@ -1053,6 +1073,12 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	pci_enable_pcie_error_reporting(pdev);
>  	pci_set_master(pdev);
>  
> +	if (!get_fw_ready_status(pdev)) {
> +		dev_notice(&pdev->dev, "Firmware not ready; defer probe.\n");
> +		err = -EPROBE_DEFER;
> +		goto err_alloc_netdev;
> +	}
> +
>  	netdev = alloc_etherdev_mq(sizeof(struct octep_device),
>  				   OCTEP_MAX_QUEUES);
>  	if (!netdev) {
> -- 
> 2.36.0
> 
