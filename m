Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF02A6D0AF0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjC3QXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjC3QXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:23:48 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7159BBB3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680193425; x=1711729425;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y8+t+0z3bf4AW0fG9FLYmWrrZ4BseGiRCKe6dGgKs2U=;
  b=BynucY+qe66Gp7tzdmR1nzHDKyPwNCyE2gI26sCKXmzvq76PS9GOTr0x
   22TNpMTUGyODx8fkFXId9QoyY6HlQR7oMNvLy7CPsJPhNvTjPi5lUpwrs
   49OAPuUCe3E1NvWGy+FRaxz63EvSYnRl8OhLPfyCXn8i+VKHN+TcbW2uk
   PjiKbPSnCNjKCfjflOO3fk5oa+61+3yC7miZmreN9Kw7mjtN2H5VAGOi2
   KXEdBk23OHnuaAO0TVUWC55tW5JaQOy3jvSPmOM+Zi3Him3fuTybIPGjj
   Rl8PJaM/6obZWeQnGYVdY7TLP8PcDEQbcvmYNSJDfgmbPE1pWVIdbIKZZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="427494779"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="427494779"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 09:23:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="858970760"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="858970760"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 30 Mar 2023 09:23:45 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 09:23:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 09:23:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 09:23:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 09:23:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He9pTLcqnYVvHUmlj91BxvMTlztsTJkoiOXw5gErZDztdhV0On1YdEJKoDDqNt3OlrPo52EDBwRrVsxGQHnKQOjO0yH0Lf2gLgbkLiEu95X97nXTN8i0RnISuRem9n/vMW3cz/Ohs8PoxMKfEqTQJZsnmXOMZTJq0wCbyBPCXux82eRTXk/AzLbuZ6RxmBt+5IwZoKWQ4YND0Uguoow3/hYCfa2nhJauCq+bpRj9J86ssgcshRgu9O4xK6jEoBF7mXyvbO5f5wd49kz8cRoGR6CE6WEu4oRS7yrvbTdtmp4+y52A8dyqFgp5yqHVs+SO9Wh5Cw1zWAYc4NOLKWI3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCnH7lbCrqI1gAFpSYJdWrnP340X9BtqpFkLUVaEINY=;
 b=BzprHjBYjvaybcpc8L/BsHWKH1DT+IpMdkmus+LafXSET5Q0+zIhFPVimubSKmyB2gSc6uOAYhDYlAinywHW22OxxyUWaFRM9uC5c0CUE/0jXgVvc6Nrp8C/KyTo3NEsWU9DoYBFWzA+hNI5EwxZtDNMH6mBwvNTiImhECdxPu3X9tJyJkxQa02L3HmTa3kKj/YU81wOcuvo6AxNyWvhh7/xv1bmm2vWbGzrdNPxsB3Xu5pt70gBKqbPlZoYisHSXIG9Fs6KWw9BCFAz/CfX9uxabij6/v7ES5w4RVvZf3cpJ9UKCwVLF8dtBm8V37KnfkKCS/jsx34z8mjmLOWlSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL3PR11MB6338.namprd11.prod.outlook.com (2603:10b6:208:3b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 30 Mar
 2023 16:23:41 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6222.028; Thu, 30 Mar 2023
 16:23:41 +0000
Date:   Thu, 30 Mar 2023 18:23:28 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <shiraz.saleem@intel.com>, <emil.s.tantilov@intel.com>,
        <willemb@google.com>, <decot@google.com>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 12/15] idpf: add RX splitq
 napi poll support
Message-ID: <ZCW3gFQStgYJRTBn@boxer>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-13-pavan.kumar.linga@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-13-pavan.kumar.linga@intel.com>
X-ClientProxiedBy: FR3P281CA0198.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL3PR11MB6338:EE_
X-MS-Office365-Filtering-Correlation-Id: 98b4a769-adf6-4e8c-9f27-08db313b1ff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtiWoESmY9j7jsIHKZ68wKDNyoZwR+F+V7ZX8vILhDlBBXfQ4DXncqMHxwxwdAeRsXxFORwmWtvlaGPzvx4lluqJAjBaF9gczucBxtwQ9tNuTywvek+lRrThUj0GrHM6uk9bbWiKAle54baTcVbKbtbCfUgDsyZJmAJQuVZIjHu4///KXqMJNmdweMuX+nmytAHTBuLTuLlrrRTEn+THyd8gQo1lNQLjGgzF1OkeA8wASMCrVg2WKuwq9PdR8mRqfeMuW8SGEDGphDxk4Pynx/7vOxjICEwcdqhXXAXRpdztcTYeF4l//AHmtOLkzQNgIOYNIfd2c8DJm/mkf1+6GU8gaELy3w9K6gKaOIj0BKLN3CwyZKGVbTVZDxhEHxeYz55OIbS7vPAMO+D33wL8XpVrpYNYivFOQth9HltsRj4FxcnKNVT8pdRI6B0C5Iq7J8vd6+32za2998y80rX2W3nonecge6hLbzHn4ftRTiVn+PmoZSvarIAGF7Q0Y7lZ+WJVmfNhvLeREqTT5JrviVHJkuaXb9RwYWMwTPizT0Pblu16HbKlwJ8SvfPzzwqXhkW1AorxcqK2ypp7IFsXPcdUtEEf3p/JQ/KYZza2Il55cLqS53NG9diJ4BokSPnR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199021)(2906002)(83380400001)(6862004)(5660300002)(8936002)(44832011)(30864003)(86362001)(82960400001)(38100700002)(33716001)(316002)(54906003)(66946007)(6506007)(8676002)(4326008)(66476007)(6512007)(26005)(186003)(6486002)(41300700001)(107886003)(9686003)(6636002)(66556008)(478600001)(6666004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZBybzf0jWIC46Z9njrROf6wYgiMWe0A66bw0dux68s4PK8IHIrfMdY3wkhnL?=
 =?us-ascii?Q?4MmIvhhwpDVxGf7Z4+14hrtllIMQBkRit88uUOm3V5bCSckJ9WZMqoLdySLV?=
 =?us-ascii?Q?p5RToNJquanCuYxpKY0SqY2JMAAGPs1mdU4QH8cJsZVitGED2skRHczGcN+h?=
 =?us-ascii?Q?R1aKWF2/NVeRNMC2+gt137XRqe8WlDJ79ODFsXejDTMr2fn3pEDHmdY3ic1h?=
 =?us-ascii?Q?7Z8v6ppt+Esaf4JXJKJc3M6qhb3AodUCCW8gCTobjOUA868hLJ0w2cKxkg01?=
 =?us-ascii?Q?hO70cvkR3Cu2SfozB1uqn2vAjC6lD7JC1F3yWGXJ0kjGbVJOn0tpUuDszkC3?=
 =?us-ascii?Q?D5cNTQiWn2jks2Cra+TMDk207Mc1tJUJou1rUmSNdv5aoXkRirVyiuV2rftz?=
 =?us-ascii?Q?Fb7WiDrjMuhPJDpIb2OnVdp4bdN80TkNY0vpkOnwAHuwrGITVki91OH8HEYC?=
 =?us-ascii?Q?zRY895CteHTZebGUDOBGqgyHgt1S6BnnVnJc6CJVgioSARw9wCOlgxaWb9q7?=
 =?us-ascii?Q?4IBM1Zx4LEzwG6s3CVEDCOrIaQoJ3Uhn8hKmAlNT52WXTN0yOnWd1WhzW/RK?=
 =?us-ascii?Q?VsZ4hQ8Lu/6/EYo1iDrhIqAuoW9HDfn0ITd2boFDQ9ipwO0p5eqCjlbbC+W8?=
 =?us-ascii?Q?QUqyveAvrsuzp2hVZekK1c4NJi4fYqbEzVOZZqdzX9HNJBEQTzsRV9lYiR6B?=
 =?us-ascii?Q?x/PUA9W8VgWAMQTVXEjMz2zV7UVf0bDT2PMXVbWFlwl478qZ6RnGSdI4/iEA?=
 =?us-ascii?Q?/UbuoG5IV3YAhquFo/PnlxlVOljvM5pGzdK8FeuTzZs33m/q09bl4j1yYUnV?=
 =?us-ascii?Q?ckT2wjVQJac0c19tZusVunDvqj2Otzxv2tBLXIbuL34CXIu8VuSbvq4G5Nji?=
 =?us-ascii?Q?SXQolryUpffI61/evr+Nu8yuUEPB5Nkvl1BBLt29cRbqypr0l0gpdrsUR0mB?=
 =?us-ascii?Q?qACRDuvl/vevnjRhWHea1/ZoTystwhawwsSomMcVRHnSbK8IJzhiQQWlljRc?=
 =?us-ascii?Q?PO2L4KyXHDKFU+dy1/G/iSZvwHGcgUO9AvjWPM7SBhU2sz18OhDiF449oXOa?=
 =?us-ascii?Q?R5UAo0FyQJLz5GTo97CsRlbeTzhu5JlM/If8jMItwNsNO+Gecs/aETDeGq2d?=
 =?us-ascii?Q?1jDoNF/w0hKD8qUhc0eZP5qUbz0ynxqKJ7tpTYFfAjV/ld2Ox0BqOs7jXjrZ?=
 =?us-ascii?Q?OPHZSvM0YEl/xzlKgeO6rFz3huPoCBwYF57pwTx7jlN/+8Dpf6Z+QgUJSMsL?=
 =?us-ascii?Q?ubhXKeCya9INIqzv8PUWds4yROrKB/yHE1z5ToXTIDjbswzyoOHweNTc74R9?=
 =?us-ascii?Q?hw9dOnYPDOOYyPzzFz+4/TeNKfkEYFQaNnIr1C6MBegG8Fx3PI/NgFC8QGjG?=
 =?us-ascii?Q?0WeuE1gxNzn9rAgEEEeD5knQFDpgQphw5Oes11x6JQn1xhNfE1OtNFY/Fdbh?=
 =?us-ascii?Q?gm/k4KlL4Ug4o/NVvB/1lABMU1E+OA2qhPKWa8bQI9jepRClBKs5YOmfhcHi?=
 =?us-ascii?Q?cm6ddaAzp+UMEMEpgTl6cioDdz/B7VW7VfEv9A4y7uSIdxsVcO90gTzq8Alp?=
 =?us-ascii?Q?KOAPFH+qC4LWLCl9kb8Sjkqjg6b71VRfQo3W6KFv3/ACB5MvARxejYhlNqA/?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b4a769-adf6-4e8c-9f27-08db313b1ff7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 16:23:41.5490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7k1kb8xm774zTBqsWjtKSs28/waOs4CQE2GjrnZ15yxlLTB3Thaz+MNUswaADOIkjP/8fhbGwf5oL7IutxrZ4dInaWrolySl7IAJJLe6tk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6338
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:04:01AM -0700, Pavan Kumar Linga wrote:
> From: Alan Brady <alan.brady@intel.com>
> 
> Add support to handle interrupts for the RX completion queue and
> RX buffer queue. When the interrupt fires on RX completion queue,
> process the RX descriptors that are received. Allocate and prepare
> the SKB with the RX packet info, for both data and header buffer.
> 
> IDPF uses software maintained refill queues to manage buffers between
> RX queue producer and the buffer queue consumer. They are required in
> order to maintain a lockless buffer management system and are strictly
> software only constructs. Instead of updating the RX buffer queue tail
> with available buffers right after the clean routine, it posts the
> buffer ids to the refill queues, only to post them to the HW later.
> 
> If the generic receive offload (GRO) is enabled in the capabilities
> and turned on by default or via ethtool, then HW performs the
> packet coalescing if certain criteria are met by the incoming
> packets and updates the RX descriptor. Similar to GRO, if generic
> checksum is enabled, HW computes the checksum and updates the
> respective fields in the descriptor. Add support to update the
> SKB fields with the GRO and the generic checksum received.
> 
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>  drivers/net/ethernet/intel/idpf/idpf.h        |    2 +
>  drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 1000 ++++++++++++++++-
>  drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   56 +-
>  .../net/ethernet/intel/idpf/idpf_virtchnl.c   |    4 +-
>  4 files changed, 1053 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
> index 9c0404c0d796..5d6a791f10de 100644
> --- a/drivers/net/ethernet/intel/idpf/idpf.h
> +++ b/drivers/net/ethernet/intel/idpf/idpf.h
> @@ -14,6 +14,7 @@ struct idpf_vport_max_q;
>  #include <linux/etherdevice.h>
>  #include <linux/pci.h>
>  #include <linux/bitfield.h>
> +#include <net/gro.h>
>  #include <linux/dim.h>
>  
>  #include "virtchnl2.h"
> @@ -262,6 +263,7 @@ struct idpf_vport {
>  	u8 default_mac_addr[ETH_ALEN];
>  	/* ITR profiles for the DIM algorithm */
>  #define IDPF_DIM_PROFILE_SLOTS  5
> +	u16 rx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
>  	u16 tx_itr_profile[IDPF_DIM_PROFILE_SLOTS];
>  
>  	bool link_up;
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
> index 4518ea7b9a31..8a96e5f4ba30 100644
> --- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
> +++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
> @@ -339,6 +339,11 @@ static void idpf_rx_buf_rel(struct idpf_queue *rxq,
>  	idpf_rx_page_rel(rxq, &rx_buf->page_info[0]);
>  	if (PAGE_SIZE < 8192 && rx_buf->buf_size > IDPF_RX_BUF_2048)
>  		idpf_rx_page_rel(rxq, &rx_buf->page_info[1]);
> +
> +	if (rx_buf->skb) {
> +		dev_kfree_skb(rx_buf->skb);
> +		rx_buf->skb = NULL;
> +	}

can you elaborate why you're introducing skb ptr to rx_buf if you have
this ptr already on idpf_queue?

>  }
>  
>  /**
> @@ -641,6 +646,28 @@ static bool idpf_rx_buf_hw_alloc_all(struct idpf_queue *rxbufq, u16 alloc_count)
>  	return !!alloc_count;
>  }
>  
> +/**
> + * idpf_rx_post_buf_refill - Post buffer id to refill queue
> + * @refillq: refill queue to post to
> + * @buf_id: buffer id to post
> + */
> +static void idpf_rx_post_buf_refill(struct idpf_sw_queue *refillq, u16 buf_id)
> +{
> +	u16 nta = refillq->next_to_alloc;
> +
> +	/* store the buffer ID and the SW maintained GEN bit to the refillq */
> +	refillq->ring[nta] =
> +		((buf_id << IDPF_RX_BI_BUFID_S) & IDPF_RX_BI_BUFID_M) |
> +		(!!(test_bit(__IDPF_Q_GEN_CHK, refillq->flags)) <<
> +		 IDPF_RX_BI_GEN_S);

do you explain anywhere in this patchset GEN bit usage?

> +
> +	if (unlikely(++nta == refillq->desc_count)) {
> +		nta = 0;
> +		change_bit(__IDPF_Q_GEN_CHK, refillq->flags);
> +	}
> +	refillq->next_to_alloc = nta;
> +}
> +

[...]

> +/**
> + * idpf_rx_buf_adjust_pg - Prepare rx buffer for reuse
> + * @rx_buf: Rx buffer to adjust
> + * @size: Size of adjustment
> + *
> + * Update the offset within page so that rx buf will be ready to be reused.
> + * For systems with PAGE_SIZE < 8192 this function will flip the page offset
> + * so the second half of page assigned to rx buffer will be used, otherwise
> + * the offset is moved by the @size bytes
> + */
> +static void idpf_rx_buf_adjust_pg(struct idpf_rx_buf *rx_buf, unsigned int size)
> +{
> +	struct idpf_page_info *pinfo;
> +
> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
> +
> +	if (PAGE_SIZE < 8192)
> +		if (rx_buf->buf_size > IDPF_RX_BUF_2048)

when buf_size can be non-2k?

> +			/* flip to second page */
> +			rx_buf->page_indx = !rx_buf->page_indx;
> +		else
> +			/* flip page offset to other buffer */
> +			pinfo->page_offset ^= size;
> +	else
> +		pinfo->page_offset += size;
> +}
> +
> +/**
> + * idpf_rx_can_reuse_page - Determine if page can be reused for another rx
> + * @rx_buf: buffer containing the page
> + *
> + * If page is reusable, we have a green light for calling idpf_reuse_rx_page,
> + * which will assign the current buffer to the buffer that next_to_alloc is
> + * pointing to; otherwise, the dma mapping needs to be destroyed and
> + * page freed
> + */
> +static bool idpf_rx_can_reuse_page(struct idpf_rx_buf *rx_buf)
> +{
> +	unsigned int last_offset = PAGE_SIZE - rx_buf->buf_size;
> +	struct idpf_page_info *pinfo;
> +	unsigned int pagecnt_bias;
> +	struct page *page;
> +
> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
> +	pagecnt_bias = pinfo->pagecnt_bias;
> +	page = pinfo->page;
> +
> +	if (unlikely(!dev_page_is_reusable(page)))
> +		return false;
> +
> +	if (PAGE_SIZE < 8192) {
> +		/* For 2K buffers, we can reuse the page if we are the
> +		 * owner. For 4K buffers, we can reuse the page if there are
> +		 * no other others.
> +		 */
> +		int reuse_bias = rx_buf->buf_size > IDPF_RX_BUF_2048 ? 0 : 1;

couldn't this be just:

		bool reuse_bias = !(rx_buf->buf_size > IDPF_RX_BUF_2048);

this is a hot path so avoiding branches is worthy.

> +
> +		if (unlikely((page_count(page) - pagecnt_bias) > reuse_bias))
> +			return false;
> +	} else if (pinfo->page_offset > last_offset) {
> +		return false;
> +	}
> +
> +	/* If we have drained the page fragment pool we need to update
> +	 * the pagecnt_bias and page count so that we fully restock the
> +	 * number of references the driver holds.
> +	 */
> +	if (unlikely(pagecnt_bias == 1)) {
> +		page_ref_add(page, USHRT_MAX - 1);
> +		pinfo->pagecnt_bias = USHRT_MAX;
> +	}
> +
> +	return true;
> +}
> +

[...]

> +/**
> + * idpf_rx_construct_skb - Allocate skb and populate it
> + * @rxq: Rx descriptor queue
> + * @rx_buf: Rx buffer to pull data from
> + * @size: the length of the packet
> + *
> + * This function allocates an skb. It then populates it with the page
> + * data from the current receive descriptor, taking care to set up the
> + * skb correctly.
> + */
> +static struct sk_buff *idpf_rx_construct_skb(struct idpf_queue *rxq,
> +					     struct idpf_rx_buf *rx_buf,
> +					     unsigned int size)
> +{
> +	struct idpf_page_info *pinfo;
> +	unsigned int headlen, truesize;

RCT please

> +	struct sk_buff *skb;
> +	void *va;
> +
> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
> +	va = page_address(pinfo->page) + pinfo->page_offset;
> +
> +	/* prefetch first cache line of first page */
> +	net_prefetch(va);
> +	/* allocate a skb to store the frags */
> +	skb = __napi_alloc_skb(&rxq->q_vector->napi, IDPF_RX_HDR_SIZE,
> +			       GFP_ATOMIC | __GFP_NOWARN);

any reason why no build_skb() support right from the start?

> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_record_rx_queue(skb, rxq->idx);
> +
> +	/* Determine available headroom for copy */
> +	headlen = size;
> +	if (headlen > IDPF_RX_HDR_SIZE)
> +		headlen = eth_get_headlen(skb->dev, va, IDPF_RX_HDR_SIZE);
> +
> +	/* align pull length to size of long to optimize memcpy performance */
> +	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
> +
> +	/* if we exhaust the linear part then add what is left as a frag */
> +	size -= headlen;
> +	if (!size) {
> +		/* buffer is unused, reset bias back to rx_buf; data was copied
> +		 * onto skb's linear part so there's no need for adjusting
> +		 * page offset and we can reuse this buffer as-is
> +		 */
> +		pinfo->pagecnt_bias++;
> +
> +		return skb;
> +	}
> +
> +	truesize = idpf_rx_frame_truesize(rx_buf, size);
> +	skb_add_rx_frag(skb, 0, pinfo->page,
> +			pinfo->page_offset + headlen, size,
> +			truesize);
> +	/* buffer is used by skb, update page_offset */
> +	idpf_rx_buf_adjust_pg(rx_buf, truesize);
> +
> +	return skb;
> +}
> +
> +/**
> + * idpf_rx_hdr_construct_skb - Allocate skb and populate it from header buffer
> + * @rxq: Rx descriptor queue
> + * @hdr_buf: Rx buffer to pull data from
> + * @size: the length of the packet
> + *
> + * This function allocates an skb. It then populates it with the page data from
> + * the current receive descriptor, taking care to set up the skb correctly.
> + * This specifcally uses a header buffer to start building the skb.
> + */
> +static struct sk_buff *idpf_rx_hdr_construct_skb(struct idpf_queue *rxq,
> +						 struct idpf_dma_mem *hdr_buf,
> +						 unsigned int size)
> +{
> +	struct sk_buff *skb;
> +
> +	/* allocate a skb to store the frags */
> +	skb = __napi_alloc_skb(&rxq->q_vector->napi, size,
> +			       GFP_ATOMIC | __GFP_NOWARN);

ditto re: build_skb() comment

> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_record_rx_queue(skb, rxq->idx);
> +
> +	memcpy(__skb_put(skb, size), hdr_buf->va, ALIGN(size, sizeof(long)));
> +
> +	return skb;
> +}
> +
> +/**
> + * idpf_rx_splitq_test_staterr - tests bits in Rx descriptor
> + * status and error fields
> + * @stat_err_field: field from descriptor to test bits in
> + * @stat_err_bits: value to mask
> + *
> + */
> +static bool idpf_rx_splitq_test_staterr(const u8 stat_err_field,
> +					const u8 stat_err_bits)
> +{
> +	return !!(stat_err_field & stat_err_bits);
> +}
> +
> +/**
> + * idpf_rx_splitq_is_eop - process handling of EOP buffers
> + * @rx_desc: Rx descriptor for current buffer
> + *
> + * If the buffer is an EOP buffer, this function exits returning true,
> + * otherwise return false indicating that this is in fact a non-EOP buffer.
> + */
> +static bool idpf_rx_splitq_is_eop(struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc)
> +{
> +	/* if we are the last buffer then there is nothing else to do */
> +	return likely(idpf_rx_splitq_test_staterr(rx_desc->status_err0_qw1,
> +						  IDPF_RXD_EOF_SPLITQ));
> +}
> +
> +/**
> + * idpf_rx_splitq_recycle_buf - Attempt to recycle or realloc buffer
> + * @rxbufq: receive queue
> + * @rx_buf: Rx buffer to pull data from
> + *
> + * This function will clean up the contents of the rx_buf. It will either
> + * recycle the buffer or unmap it and free the associated resources. The buffer
> + * will then be placed on a refillq where it will later be reclaimed by the
> + * corresponding bufq.
> + *
> + * This works based on page flipping. If we assume e.g., a 4k page, it will be
> + * divided into two 2k buffers. We post the first half to hardware and, after
> + * using it, flip to second half of the page with idpf_adjust_pg_offset and
> + * post that to hardware. The third time through we'll flip back to first half
> + * of page and check if stack is still using it, if not we can reuse the buffer
> + * as is, otherwise we'll drain it and get a new page.
> + */
> +static void idpf_rx_splitq_recycle_buf(struct idpf_queue *rxbufq,
> +				       struct idpf_rx_buf *rx_buf)
> +{
> +	struct idpf_page_info *pinfo = &rx_buf->page_info[rx_buf->page_indx];
> +
> +	if (idpf_rx_can_reuse_page(rx_buf))
> +		return;
> +
> +	/* we are not reusing the buffer so unmap it */
> +	dma_unmap_page_attrs(rxbufq->dev, pinfo->dma, PAGE_SIZE,
> +			     DMA_FROM_DEVICE, IDPF_RX_DMA_ATTR);
> +	__page_frag_cache_drain(pinfo->page, pinfo->pagecnt_bias);
> +
> +	/* clear contents of buffer_info */
> +	pinfo->page = NULL;
> +	rx_buf->skb = NULL;

this skb NULLing is pointless to me. from the callsite of this function
you operate strictly on a skb from idpf_queue.

> +
> +	/* It's possible the alloc can fail here but there's not much
> +	 * we can do, bufq will have to try and realloc to fill the
> +	 * hole.
> +	 */
> +	idpf_alloc_page(rxbufq, pinfo);
> +}
> +
> +/**
> + * idpf_rx_splitq_clean - Clean completed descriptors from Rx queue
> + * @rxq: Rx descriptor queue to retrieve receive buffer queue
> + * @budget: Total limit on number of packets to process
> + *
> + * This function provides a "bounce buffer" approach to Rx interrupt
> + * processing. The advantage to this is that on systems that have
> + * expensive overhead for IOMMU access this provides a means of avoiding
> + * it by maintaining the mapping of the page to the system.
> + *
> + * Returns amount of work completed
> + */
> +static int idpf_rx_splitq_clean(struct idpf_queue *rxq, int budget)
> +{
> +	int total_rx_bytes = 0, total_rx_pkts = 0;
> +	struct idpf_queue *rx_bufq = NULL;
> +	struct sk_buff *skb = rxq->skb;
> +	u16 ntc = rxq->next_to_clean;
> +
> +	/* Process Rx packets bounded by budget */
> +	while (likely(total_rx_pkts < budget)) {
> +		struct virtchnl2_rx_flex_desc_adv_nic_3 *rx_desc;
> +		struct idpf_sw_queue *refillq = NULL;
> +		struct idpf_dma_mem *hdr_buf = NULL;
> +		struct idpf_rxq_set *rxq_set = NULL;
> +		struct idpf_rx_buf *rx_buf = NULL;
> +		union virtchnl2_rx_desc *desc;
> +		unsigned int pkt_len = 0;
> +		unsigned int hdr_len = 0;
> +		u16 gen_id, buf_id = 0;
> +		 /* Header buffer overflow only valid for header split */
> +		bool hbo = false;
> +		int bufq_id;
> +		u8 rxdid;
> +
> +		/* get the Rx desc from Rx queue based on 'next_to_clean' */
> +		desc = IDPF_RX_DESC(rxq, ntc);
> +		rx_desc = (struct virtchnl2_rx_flex_desc_adv_nic_3 *)desc;
> +
> +		/* This memory barrier is needed to keep us from reading
> +		 * any other fields out of the rx_desc
> +		 */
> +		dma_rmb();
> +
> +		/* if the descriptor isn't done, no work yet to do */
> +		gen_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
> +		gen_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_GEN_M, gen_id);
> +
> +		if (test_bit(__IDPF_Q_GEN_CHK, rxq->flags) != gen_id)
> +			break;
> +
> +		rxdid = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_RXDID_M,
> +				  rx_desc->rxdid_ucast);
> +		if (rxdid != VIRTCHNL2_RXDID_2_FLEX_SPLITQ) {
> +			IDPF_RX_BUMP_NTC(rxq, ntc);
> +			u64_stats_update_begin(&rxq->stats_sync);
> +			u64_stats_inc(&rxq->q_stats.rx.bad_descs);
> +			u64_stats_update_end(&rxq->stats_sync);
> +			continue;
> +		}
> +
> +		pkt_len = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
> +		pkt_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_PBUF_M,
> +				    pkt_len);
> +
> +		hbo = FIELD_GET(BIT(VIRTCHNL2_RX_FLEX_DESC_ADV_STATUS0_HBO_S),
> +				rx_desc->status_err0_qw1);
> +
> +		if (unlikely(hbo)) {
> +			/* If a header buffer overflow, occurs, i.e. header is
> +			 * too large to fit in the header split buffer, HW will
> +			 * put the entire packet, including headers, in the
> +			 * data/payload buffer.
> +			 */
> +			u64_stats_update_begin(&rxq->stats_sync);
> +			u64_stats_inc(&rxq->q_stats.rx.hsplit_buf_ovf);
> +			u64_stats_update_end(&rxq->stats_sync);
> +			goto bypass_hsplit;
> +		}
> +
> +		hdr_len = le16_to_cpu(rx_desc->hdrlen_flags);
> +		hdr_len = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_LEN_HDR_M,
> +				    hdr_len);
> +
> +bypass_hsplit:
> +		bufq_id = le16_to_cpu(rx_desc->pktlen_gen_bufq_id);
> +		bufq_id = FIELD_GET(VIRTCHNL2_RX_FLEX_DESC_ADV_BUFQ_ID_M,
> +				    bufq_id);
> +
> +		rxq_set = container_of(rxq, struct idpf_rxq_set, rxq);
> +		if (!bufq_id)
> +			refillq = rxq_set->refillq0;
> +		else
> +			refillq = rxq_set->refillq1;
> +
> +		/* retrieve buffer from the rxq */
> +		rx_bufq = &rxq->rxq_grp->splitq.bufq_sets[bufq_id].bufq;
> +
> +		buf_id = le16_to_cpu(rx_desc->buf_id);
> +
> +		if (pkt_len) {
> +			rx_buf = &rx_bufq->rx_buf.buf[buf_id];
> +			idpf_rx_get_buf_page(rx_bufq->dev, rx_buf, pkt_len);
> +		}
> +
> +		if (hdr_len) {
> +			hdr_buf = rx_bufq->rx_buf.hdr_buf[buf_id];
> +
> +			dma_sync_single_for_cpu(rxq->dev, hdr_buf->pa, hdr_buf->size,
> +						DMA_FROM_DEVICE);
> +
> +			skb = idpf_rx_hdr_construct_skb(rxq, hdr_buf, hdr_len);
> +			u64_stats_update_begin(&rxq->stats_sync);
> +			u64_stats_inc(&rxq->q_stats.rx.hsplit_pkts);
> +			u64_stats_update_end(&rxq->stats_sync);
> +		}
> +
> +		if (pkt_len) {
> +			if (skb)
> +				idpf_rx_add_frag(rx_buf, skb, pkt_len);
> +			else
> +				skb = idpf_rx_construct_skb(rxq, rx_buf,
> +							    pkt_len);
> +		}
> +
> +		/* exit if we failed to retrieve a buffer */
> +		if (!skb) {
> +			/* If we fetched a buffer, but didn't use it
> +			 * undo pagecnt_bias decrement
> +			 */
> +			if (rx_buf)
> +				rx_buf->page_info[rx_buf->page_indx].pagecnt_bias++;
> +			break;
> +		}
> +
> +		if (rx_buf)
> +			idpf_rx_splitq_recycle_buf(rx_bufq, rx_buf);
> +		idpf_rx_post_buf_refill(refillq, buf_id);
> +
> +		IDPF_RX_BUMP_NTC(rxq, ntc);
> +		/* skip if it is non EOP desc */
> +		if (!idpf_rx_splitq_is_eop(rx_desc))
> +			continue;
> +
> +		/* pad skb if needed (to make valid ethernet frame) */
> +		if (eth_skb_pad(skb)) {
> +			skb = NULL;
> +			continue;
> +		}
> +
> +		/* probably a little skewed due to removing CRC */
> +		total_rx_bytes += skb->len;
> +
> +		/* protocol */
> +		if (unlikely(idpf_rx_process_skb_fields(rxq, skb, rx_desc))) {
> +			dev_kfree_skb_any(skb);
> +			skb = NULL;
> +			continue;
> +		}
> +
> +		/* send completed skb up the stack */
> +		napi_gro_receive(&rxq->q_vector->napi, skb);
> +		skb = NULL;
> +
> +		/* update budget accounting */
> +		total_rx_pkts++;
> +	}
> +
> +	rxq->next_to_clean = ntc;
> +
> +	rxq->skb = skb;
> +	u64_stats_update_begin(&rxq->stats_sync);
> +	u64_stats_add(&rxq->q_stats.rx.packets, total_rx_pkts);
> +	u64_stats_add(&rxq->q_stats.rx.bytes, total_rx_bytes);
> +	u64_stats_update_end(&rxq->stats_sync);
> +
> +	/* guarantee a trip back through this routine if there was a failure */
> +	return total_rx_pkts;
> +}

keeping above func for a context

[...]

>  /**
>   * idpf_vport_intr_clean_queues - MSIX mode Interrupt Handler
>   * @irq: interrupt number
> @@ -3205,7 +4102,7 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
>  	u32 i;
>  
>  	if (!IDPF_ITR_IS_DYNAMIC(q_vector->tx_intr_mode))
> -		return;
> +		goto check_rx_itr;
>  
>  	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_txq; i++) {
>  		struct idpf_queue *txq = q_vector->tx[i];
> @@ -3221,6 +4118,25 @@ static void idpf_net_dim(struct idpf_q_vector *q_vector)
>  	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->tx_dim,
>  			       packets, bytes);
>  	net_dim(&q_vector->tx_dim, dim_sample);
> +
> +check_rx_itr:
> +	if (!IDPF_ITR_IS_DYNAMIC(q_vector->rx_intr_mode))
> +		return;
> +
> +	for (i = 0, packets = 0, bytes = 0; i < q_vector->num_rxq; i++) {
> +		struct idpf_queue *rxq = q_vector->rx[i];
> +		unsigned int start;
> +
> +		do {
> +			start = u64_stats_fetch_begin(&rxq->stats_sync);
> +			packets += u64_stats_read(&rxq->q_stats.rx.packets);
> +			bytes += u64_stats_read(&rxq->q_stats.rx.bytes);
> +		} while (u64_stats_fetch_retry(&rxq->stats_sync, start));
> +	}
> +
> +	idpf_update_dim_sample(q_vector, &dim_sample, &q_vector->rx_dim,
> +			       packets, bytes);
> +	net_dim(&q_vector->rx_dim, dim_sample);
>  }
>  
>  /**
> @@ -3338,7 +4254,15 @@ static void idpf_vport_intr_ena_irq_all(struct idpf_vport *vport)
>  						  true);
>  		}
>  
> -		if (qv->num_txq)
> +		if (qv->num_rxq) {
> +			dynamic = IDPF_ITR_IS_DYNAMIC(qv->rx_intr_mode);
> +			itr = vport->rx_itr_profile[qv->rx_dim.profile_ix];
> +			idpf_vport_intr_write_itr(qv, dynamic ?
> +						  itr : qv->rx_itr_value,
> +						  false);
> +		}
> +
> +		if (qv->num_txq || qv->num_rxq)
>  			idpf_vport_intr_update_itr_ena_irq(qv);
>  	}
>  }
> @@ -3381,6 +4305,32 @@ static void idpf_tx_dim_work(struct work_struct *work)
>  	dim->state = DIM_START_MEASURE;
>  }
>  
> +/**
> + * idpf_rx_dim_work - Call back from the stack
> + * @work: work queue structure
> + */
> +static void idpf_rx_dim_work(struct work_struct *work)
> +{
> +	struct idpf_q_vector *q_vector;
> +	struct idpf_vport *vport;
> +	struct dim *dim;
> +	u16 itr;
> +
> +	dim = container_of(work, struct dim, work);
> +	q_vector = container_of(dim, struct idpf_q_vector, rx_dim);
> +	vport = q_vector->vport;
> +
> +	if (dim->profile_ix >= ARRAY_SIZE(vport->rx_itr_profile))
> +		dim->profile_ix = ARRAY_SIZE(vport->rx_itr_profile) - 1;
> +
> +	/* look up the values in our local table */
> +	itr = vport->rx_itr_profile[dim->profile_ix];
> +
> +	idpf_vport_intr_write_itr(q_vector, itr, false);
> +
> +	dim->state = DIM_START_MEASURE;
> +}
> +
>  /**
>   * idpf_init_dim - Set up dynamic interrupt moderation
>   * @qv: q_vector structure
> @@ -3390,6 +4340,10 @@ static void idpf_init_dim(struct idpf_q_vector *qv)
>  	INIT_WORK(&qv->tx_dim.work, idpf_tx_dim_work);
>  	qv->tx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
>  	qv->tx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
> +
> +	INIT_WORK(&qv->rx_dim.work, idpf_rx_dim_work);
> +	qv->rx_dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
> +	qv->rx_dim.profile_ix = IDPF_DIM_DEFAULT_PROFILE_IX;
>  }
>  
>  /**
> @@ -3437,6 +4391,44 @@ static bool idpf_tx_splitq_clean_all(struct idpf_q_vector *q_vec,
>  	return clean_complete;
>  }
>  
> +/**
> + * idpf_rx_splitq_clean_all- Clean completetion queues
> + * @q_vec: queue vector
> + * @budget: Used to determine if we are in netpoll
> + * @cleaned: returns number of packets cleaned
> + *
> + * Returns false if clean is not complete else returns true
> + */
> +static bool idpf_rx_splitq_clean_all(struct idpf_q_vector *q_vec, int budget,
> +				     int *cleaned)
> +{
> +	int num_rxq = q_vec->num_rxq;
> +	bool clean_complete = true;
> +	int pkts_cleaned = 0;
> +	int i, budget_per_q;
> +
> +	/* We attempt to distribute budget to each Rx queue fairly, but don't
> +	 * allow the budget to go below 1 because that would exit polling early.
> +	 */
> +	budget_per_q = num_rxq ? max(budget / num_rxq, 1) : 0;
> +	for (i = 0; i < num_rxq; i++) {
> +		struct idpf_queue *rxq = q_vec->rx[i];
> +		int pkts_cleaned_per_q;
> +
> +		pkts_cleaned_per_q = idpf_rx_splitq_clean(rxq, budget_per_q);
> +		/* if we clean as many as budgeted, we must not be done */
> +		if (pkts_cleaned_per_q >= budget_per_q)
> +			clean_complete = false;
> +		pkts_cleaned += pkts_cleaned_per_q;
> +	}
> +	*cleaned = pkts_cleaned;
> +
> +	for (i = 0; i < q_vec->num_bufq; i++)
> +		idpf_rx_clean_refillq_all(q_vec->bufq[i]);
> +
> +	return clean_complete;
> +}
> +
>  /**
>   * idpf_vport_splitq_napi_poll - NAPI handler
>   * @napi: struct from which you get q_vector
> @@ -3456,7 +4448,8 @@ static int idpf_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
>  		return 0;
>  	}
>  
> -	clean_complete = idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
> +	clean_complete = idpf_rx_splitq_clean_all(q_vector, budget, &work_done);
> +	clean_complete &= idpf_tx_splitq_clean_all(q_vector, budget, &work_done);
>  
>  	/* If work not completed, return budget and polling will return */
>  	if (!clean_complete)
> @@ -3810,7 +4803,6 @@ int idpf_init_rss(struct idpf_vport *vport)
>  /**
>   * idpf_deinit_rss - Release RSS resources
>   * @vport: virtual port
> - *
>   */
>  void idpf_deinit_rss(struct idpf_vport *vport)
>  {
> diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
> index 27bac854e7dc..f89dff970727 100644
> --- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
> +++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
> @@ -61,10 +61,21 @@
>  
>  #define IDPF_RX_BUFQ_WORKING_SET(rxq)		((rxq)->desc_count - 1)
>  
> +#define IDPF_RX_BUMP_NTC(rxq, ntc)				\
> +do {								\
> +	if (unlikely(++(ntc) == (rxq)->desc_count)) {		\

desc_count won't change within single NAPI instance so i would rather
store this to aux variable on stack and use this in this macro.

> +		ntc = 0;					\
> +		change_bit(__IDPF_Q_GEN_CHK, (rxq)->flags);	\
> +	}							\
> +} while (0)
> +
> +#define IDPF_RX_HDR_SIZE			256
>  #define IDPF_RX_BUF_2048			2048
>  #define IDPF_RX_BUF_4096			4096
>  #define IDPF_RX_BUF_STRIDE			32
> +#define IDPF_RX_BUF_POST_STRIDE			16
>  #define IDPF_LOW_WATERMARK			64
> +/* Size of header buffer specifically for header split */
>  #define IDPF_HDR_BUF_SIZE			256
>  #define IDPF_PACKET_HDR_PAD	\
>  	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
> @@ -74,10 +85,18 @@
>   */
>  #define IDPF_TX_SPLITQ_RE_MIN_GAP	64
> 

[...]
