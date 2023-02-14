Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB62696BFD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjBNRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBNRtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:49:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1801C58F;
        Tue, 14 Feb 2023 09:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396961; x=1707932961;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U7TPgtgONgqr0LU2ZG1/EH9uIeiSmpkQz8a1iA6H89U=;
  b=Kq8VbDzAmh6XL0wwnGJT6RJwjQE7gHzG5cHHNXet4M8qWc0Lqm5/ZMYZ
   10Ng8tF6hDed/D+wMm9i9WytBIaECADD41JUVZk7xAOrHNDIqpn9HN+Uw
   jlrXrUVVwM4exRREy+Ts6QEWPUVuC9vedSMr1YpNfzVDPu7p77wRUofj9
   trBGFl24K+I78VYnXGbmz1pBplvs1CvbVkygrW9U2b5n7Cjd4WJn5FGvP
   d6dXygorjrgUPjeB/YRnbBenl1c3iFkXSdIm+66Kem6QMQf6AJtVyBZbT
   ri9bn09k0OQERe1kyV8Zm4QcvSU6uXBXH7eWEK9wTFRvkzCc1Buee/edL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="395835493"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="395835493"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:49:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="732958748"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="732958748"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 09:49:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:49:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:49:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:49:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2ITt5pdSn49yb4DJ1FGk43ZqeqlBlfP6BiA1j56zOjZJwlbK+GcECukYOmaDXmvxOCf1IIesBR/iZfhaoBuR+8XzDIcdgZmWIV9KY46FXJmwTl//RMCUCtDZzzrHpi9aIdlYhF1lVvXL0X1HJxvYiEY/YASOFzDRFa5KYfAY6hzFBdch6ts10xc2syuFqujpkCAiLZUotfyA7YpWxOVYyG1O/C0ryGrCAnCFympGb+CxHvL3C3z0XgWOCsMBsutuDkRyuqSTbN3u7SNuSVYg/VDzDB13qewuFsgxCmesKo4Bfu/2+epez5hsjarnXL19HiCBjKSxeUBSDY8Vd+TLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCpZ5eEivELW+33rqIhbGSm5yTDwfpvwnKwDDp7UeNE=;
 b=od8zaLeHaUMXUSol6R9T99Lga3pa+xLdjrfMZGLDzLo64NjNdle0+Yj/bcawb3VVSKsGcOY8LxBJOD9I8qOPKrfeGznpZ566gCg8qXsuF7XVJlzzTBZ8VCaiur3MN6gcOe5uPd/cmPVWwvg+PZEE2yn3bq1JR2leiuiLa8kec2bi/fFlOWMtYQKxo88dOGbK5B9mfoot+1H1cKQ43Bp0lupBulTrV7sIK2eI6h918VTA+ffnYUELVQgurGHiC1p/S+LuZy5adnMSIO34qtDZpW3SmQsIyFQYpD5bJJjEKXVjxAbX7S0MyGXot2uCUCbIwtjJ3xH0w4FMDH1Pouon3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 17:49:12 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 17:49:12 +0000
Date:   Tue, 14 Feb 2023 18:49:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>,
        <sburla@marvell.com>, <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 3/7] octeon_ep: control mailbox for multiple
 PFs
Message-ID: <Y+vJkPO1UZPDSFT2@boxer>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-4-vburru@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214051422.13705-4-vburru@marvell.com>
X-ClientProxiedBy: FR2P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW3PR11MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: b23bbad7-6ea1-4589-59ee-08db0eb3c7fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ahV7Uu5zxqTQsmwCa2h7B6uTojacsAfztRRSazRkHQz5FYI40m8onDjatSQOWp1o84W4I/nL1fFL03VcATBJl/slzjBx+wofEMh5LavBZFdyI2cQ1Ptb0+r7FcmCJjaBge8+MU4ht5G73U9Ms8KSRoogkDSImH3zPiI+XW8A33UxUoaK0oiuRGM0e2cQQfR8YalUQcN6hAbcWo2g+R5K/bw3YaUu1KAmFN8cdP5PvIp1k3mQmf1Mze1b4t3ysZKFLNDndj6GqeBBggQ5/5p5C77Vo1KKE/PbWGwL18Tv5g/I6+iqHL2m3jtprb5tzixtTgpXJYfbEVR00ob022MMMRM0IF8GQOj8WXBgwyLXoCcyf7a1h9AC2p6UAyxp4HTkHtZEbA96bp507O8Eu7Z75LkGHveUeffpOslW/RBXMJ05PcOAuXWuh0aKgXT+y/BEbsQMfzmlPciHDcswjzXBEXyQF5fkQwRGMvFLF3ekCTuHnDxv/fKHBVT04BcW8roA3c/0KzBZCmH2Xz4JUa8UqU+Jlj7DtewHjYv31YY6BbLt8y4ZVTM9Wk+Xq9Y6VsPk0IQuS+1kVay80p7n7m/OccwiAnIF6mLc7Frc4+KCeavkZ3NhlG03GdzGz/7HxU5vG2sQzKyoGUmASi4bxMJ3aTZx0IU22ujtZ6u6aQHTXyoxsulmvizWLUbLq/WSeyM6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199018)(6666004)(33716001)(6512007)(6506007)(9686003)(66946007)(66476007)(66556008)(186003)(8676002)(26005)(4326008)(6916009)(83380400001)(478600001)(86362001)(54906003)(6486002)(316002)(2906002)(5660300002)(41300700001)(8936002)(7416002)(38100700002)(44832011)(82960400001)(15650500001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5/s07lHGRaKYv32V/rKj/UI7YDyRT8gHeytwEyMQ62CGB+/1WvjDM1jw0Zo6?=
 =?us-ascii?Q?HksZAoUGxEIkjCl2OHNvKuLwkPSxPSPfhUuWiflZZKYlaOvlk7XxBGtgncMf?=
 =?us-ascii?Q?G1SKhC2zdaA7ILKG18+KcblgZKT0OdyQ/N4AibO/fkPVJA+xTw0PQ+csPb/l?=
 =?us-ascii?Q?bxlvxUxlezutRPY2nmvrI74s779FHRKWK2pAjxIZnKlbLpPgiXf08wo40pj4?=
 =?us-ascii?Q?K1DlDZCeARRoBl+eukvdW0gcc2EX/fRFjxZ1Bqx/o2j95A/TmAzbLdPFHPuL?=
 =?us-ascii?Q?4/90A7kc3y99xwL9IqsZJIFqYnGrqokegsQzV0ARtom6R/ncvAhKfAULGRNi?=
 =?us-ascii?Q?oVbW8nnHiFoQSV3dUbhxBBVkfEoFJZiNMI1rOUgq+dqwy3rjUWY6ZnezDD7O?=
 =?us-ascii?Q?HJeLWR/E+RWBUR4LvWexFfxPxH/mIS4LgUrAe+TT81sjItfUHc1eaKp2icH9?=
 =?us-ascii?Q?N/r4kVPbBltwj0DyVRDWnTz3oxBtYo8v+iEXqFrSjEQxkmlaGZBjZbH9LjvQ?=
 =?us-ascii?Q?nPtYEdcOCqUa1kVdyq1a2qQC63iLYIPL1jyNYH7JHuHBnIQ9xLnkE6NmNzea?=
 =?us-ascii?Q?mRrNNT45qdwKZCcfOvby3BxLUzJj9JYnLOB37SEeScy7htgOWkVJ8e+VnYAy?=
 =?us-ascii?Q?eYcpSK0pXsipNqZlI++0K/SEkqeSDWS1j0nIBX4jQ1hM37P32KNTWtdM10Hj?=
 =?us-ascii?Q?9tOifuKGfkM3pBJ5gaOuskgYxII2fHfYeU/SAtNq39Ag5ZGYe02IgB5fUhew?=
 =?us-ascii?Q?CqWqUvk3onwb5xZ0tIsvy4IqGeLd7r0KzAxwmYvYoIEZM8bZwvxwBNn2u8E+?=
 =?us-ascii?Q?A3HmvnlZFgHHfPZwkGtSmYDkXzpgN0xm5DnbtiJVDMngqydckFSAMpd6aIcA?=
 =?us-ascii?Q?yxi1/O5f4CnNkf6L7A1MFPdQjKYV5+Ch9D/dIG6HdX3jaQXTE508b8F+wf5R?=
 =?us-ascii?Q?vYDNqV6jbuoLyBqA2DKzE//QDV1fPCjdt2X3kPlHqjP3HfjBayx8wR76YRAg?=
 =?us-ascii?Q?T+fl2ifA6aZu+t3zHvuh8nYyS7KZi54IfToCIXT9v+DInuVb8GS+nMtBKrQ5?=
 =?us-ascii?Q?nM2FaNXhed7K6qZPiYbOfg9cfcREuG92nJgMBdAAJwshcK47kUMZ2/NnWJlm?=
 =?us-ascii?Q?WKkzwm3EMuKXrHSkuIDgVevirJGtVKncL9as+tImnJMxzJK4Cbi1AZScy4X9?=
 =?us-ascii?Q?hy+a73LVpeypkrzGUzgxYWXg0+r5VfozqtYwo+60zjlBvLwOF4hAAw3P5iUc?=
 =?us-ascii?Q?Ir34aWJRZRuQWWhxruJm3bnyOjELQEa+fmWiWPkJPOzeWJloP1aDGxeFcmSJ?=
 =?us-ascii?Q?uNrRF053J/YD3s2w7Xn+IlZitY5fWeaTyMU6qO4rIjw/8HQKUUZhATCPNZwk?=
 =?us-ascii?Q?4SAhxBJUJ4wfJWB47CjkuTuVnvzhTNaddiRu4UmUvfNWJNce9yOhu/ZdfIJs?=
 =?us-ascii?Q?EBfZPB6/frwY+27P2KfO12J6qxWzbkOMtM5AB3zZfCFvu9kQHA8mbgK+pMiF?=
 =?us-ascii?Q?0tXlFlSbTNJ4kvsvCQkUOM3NHGcRgBpoxSYVopZlZVgr77xPXOYtxmQ1Qybu?=
 =?us-ascii?Q?UnWs4au/2uPus78T+xladSApzRYWOorOeaOFoH2T49tAFw+ZB/ZG/Hs/dxQ5?=
 =?us-ascii?Q?4kx4uZQnjJUJDXwfFgpArGQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b23bbad7-6ea1-4589-59ee-08db0eb3c7fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:49:12.2136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ib3rHKHdpIv+ELvAdAfAPxIHvEa5qIVn3B3uhMvWLT6w8kLdh4rNCILXAGI6+y0HnzFbGZVxwwHyMZ76xxAxViWWKd1yPXjGDKAwEGRhP5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:14:18PM -0800, Veerasenareddy Burru wrote:
> Add control mailbox support for multiple PFs.
> Update control mbox base address calculation based on PF function link.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> ---
> v2 -> v3:
>  * no change
> 
> v1 -> v2:
>  * no change
> 
>  .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c   | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> index f40ebac15a79..c82a1347eed8 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> @@ -13,6 +13,9 @@
>  #include "octep_main.h"
>  #include "octep_regs_cn9k_pf.h"
>  
> +#define CTRL_MBOX_MAX_PF	128
> +#define CTRL_MBOX_SZ		((size_t)(0x400000 / CTRL_MBOX_MAX_PF))
> +
>  /* Names of Hardware non-queue generic interrupts */
>  static char *cn93_non_ioq_msix_names[] = {
>  	"epf_ire_rint",
> @@ -199,6 +202,8 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
>  	struct octep_config *conf = oct->conf;
>  	struct pci_dev *pdev = oct->pdev;
>  	u64 val;
> +	int pos;
> +	u8 link = 0;

RCT again

>  
>  	/* Read ring configuration:
>  	 * PF ring count, number of VFs and rings per VF supported
> @@ -234,7 +239,16 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
>  	conf->msix_cfg.ioq_msix = conf->pf_ring_cfg.active_io_rings;
>  	conf->msix_cfg.non_ioq_msix_names = cn93_non_ioq_msix_names;
>  
> -	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr + (0x400000ull * 7);
> +	pos = pci_find_ext_capability(oct->pdev, PCI_EXT_CAP_ID_SRIOV);
> +	if (pos) {
> +		pci_read_config_byte(oct->pdev,
> +				     pos + PCI_SRIOV_FUNC_LINK,
> +				     &link);
> +		link = PCI_DEVFN(PCI_SLOT(oct->pdev->devfn), link);
> +	}
> +	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr +
> +					   (0x400000ull * 8) +

can you explain why s/7/8 and was it broken previously?

> +					   (link * CTRL_MBOX_SZ);
>  }
>  
>  /* Setup registers for a hardware Tx Queue  */
> -- 
> 2.36.0
> 
