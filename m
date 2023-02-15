Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D94A698102
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBOQiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBOQiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:38:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107044AB;
        Wed, 15 Feb 2023 08:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676479063; x=1708015063;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c7cJZB0ktELN6weAiqmPF3DXiTHlAb3Ip1jyECZYY8w=;
  b=lhpqT4obezJqkn4+5vex3/YJYI0JwS3H8M+Hs2Fo8zFIL8EWLEETsZDB
   WIwL6b+Lr6G5b4+vFQvbdhxX8qQouH0mOwn1Tw+3KSD0a9JBWQ4GaXF1G
   /tCzfj4L3rvuMFgU+5Lkhxe9JXZksm5EM+xGW5+VbYxTpZsjvAr37YORm
   yChHXrFkqKHkW79nRI5LV7hx6BFvBg4e4IecWE155EvaZBC3HnGQweLr3
   WYFSTf3iRMWhvKEL5sUgpEdfW/c+BFTsVsTecGvVjM5hz6D3TFEmHKRvo
   SpZxy1q9lY+hNEzTS4Geoe5k/ya2UZo5EFXt19EQvPlDL/+BgCidcUksa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="315128333"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="315128333"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:37:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793566349"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="793566349"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 15 Feb 2023 08:37:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:36:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:36:42 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:36:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnnS8bNODwr6K93W2oiQZVifpktrVb4Bh7kRthYQy3lk+7iZVJjXEDYHHU139LWP1szCx8idgZilmKJ0Q8/Pp0bJ5L2ip1waSg1JKxPJWysmyAdX1cCmaETQNDIFbPLkkyL6QE8G3HlEJSIsBe/iGKMMD9seZI4JKXkYNe0EUbdebqlpjSSTqecci5ZAWc7wuBXMJZQ3cCIx0nU0+MljkDBm4SGQWVUu2zvG1RcasrDzyRg3fMD9UkBhMAgWSSMk+FRaaQPQ7ACQkcYbTkvaQdjO/fJmmkWGoRmjEm+EP37KxVm4ET9/UymGu9wR6+Ye2D34jX34ezJA9aJ0+/V+Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJHNfyvH2LZ6K2iiyLrWGpMKlEOmsaW3/CDkjgjDveQ=;
 b=fkTPTA+cr4ipYa2c121GxYexMwzqZNQIi9fFCiRsanFakWKk33xxhNvxqU8v5wqUg/GYNIyt9gj/lP4fn43eEwZfXszAyH7CBu9bFpGC+htNlyf+sWXqew4XUnTxIWcvBA4ZsXP6a9Ad7uCtOLJaXXqtQTuQHklmZIs1/EksTZJfbro2jjjhZyUEMnIcmF8d5bx2TZNliqOO7KN/4syBbuB35ICPOF/cwXMs75B6bmJulM5iZDNx1xoGfvSsOdL4rayDj6Ax0OU5rglM7y6VwhD/F0gdct4gKLusz5sset18l3wrw216IvvJI4vRU2J1OQIzgDluOOhayiLjCmf5uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5459.namprd11.prod.outlook.com (2603:10b6:610:d2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Wed, 15 Feb 2023 16:36:27 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 15 Feb 2023
 16:36:27 +0000
Date:   Wed, 15 Feb 2023 17:36:07 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>,
        <sburla@marvell.com>, <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 5/7] octeon_ep: support asynchronous
 notifications
Message-ID: <Y+0J94sowllCe5Gs@boxer>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-6-vburru@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214051422.13705-6-vburru@marvell.com>
X-ClientProxiedBy: FR2P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5459:EE_
X-MS-Office365-Filtering-Correlation-Id: f17b406d-ef5b-4c72-eae0-08db0f72c8f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMV3C2aryZ5KXyZwXFWJvtgAF41+f+AdPA71obImJp/xWFLT0IpPQjqiYfIjK83GZCt7+5VOkBO4xQ6AnA+gHFBB6Xx/8JpNQ2IkU4LAbOLxUgkaBzLlA1uTjwwU7GAYjWSmCxnCnybVqk5MsvFxDXzwiqhClq/WgicD2osgwye+lU6XkFR6k7GhdDCGiMOuBvx+slJ3bM3V9tON+VmaxXubWo6EJSvpt5Z9mhVIATwV6buAz2P72BciBTCIrz0/CPsGCMdW+B57WuDV4FqYb9TuKVOiY7BjvGwhmRqIfZDusdNx6RkxQFvdfape6N1wzhXfnrXwN/9ldCR8DkyRvBgGrWFQw0THzVg5NebeOBIhxfjLSfxXC3zFH/KnDmDOxgAHnvtR5Xi5JCeCq28xLytk3NStYHETLlQ6z2VOCqfUZLdQ2bRVfenlkp8//+kVfnGEJq5Z9WZp51wxpHjzlKm2/0sT6x7WDoxViPhYNIKbmAzlhHWp7C2/sjYqf6vMKme0AtTWu3xOdq3k4K60ocOU0SVq5pKND4p4F6KGBD9tMupcsF5ylnfnHCTzTqIPCy8UVYKeo6CJ+274BwLbxzpZ2E1NFdnqfVshLpZM46oJLAc3XnypZ9F+6ifxZseteqcBDkb7L2fsah8nOQJl8YcudOCp2dIAQyPxM6ifFe6qVfb53FRNqL18sajDTVNo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199018)(38100700002)(6506007)(86362001)(82960400001)(186003)(33716001)(83380400001)(54906003)(6512007)(478600001)(6486002)(6666004)(9686003)(316002)(66946007)(26005)(66476007)(8676002)(66556008)(41300700001)(7416002)(4326008)(6916009)(5660300002)(2906002)(44832011)(15650500001)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/HZnGOocOB2wSOgTis5AbzTHsZF6pAH95EaJIs+dyFc4KMP5vNVIuVCl0frO?=
 =?us-ascii?Q?djiUSdsFaD9NB3QU892r23VfIlYn0UhKM/6rNe8fXlwcHglQ23lHuEN2Jka1?=
 =?us-ascii?Q?SYvGL7c5g3Ib5Ed9s9pAx9Q+hhVPOu1/ddcTpb+T+mT/EaIsOPj1C9VBef6K?=
 =?us-ascii?Q?Od4cBEtwlENQpXra9gKJhpTlud3vZOP8d3j+k8lzwK2+ryaFIj5HbH3J4rL1?=
 =?us-ascii?Q?CLWFXPJCNouIEqlUesvqE/YoqP4sS6CNAhlBI7gGcXdoOTtoDxzH+5Yikb8B?=
 =?us-ascii?Q?jGckfOStNp9lWrhuDrtGXrf1vCvISfOo+gqGhJE1prDofma18YqESHjsnbVl?=
 =?us-ascii?Q?AYPw9dkWw+NbkxUfBCu7057MyLRxAa7mHeCvFd/OWrQgBkFIFK9L+gC+buVD?=
 =?us-ascii?Q?FtfRahLXvAtN9f918azLObn5jgw6IbyVUJil9o/SmlgZuPNU1SJJwUVm3nXY?=
 =?us-ascii?Q?3AiC/xSF9smN7xcQ/n73TnIqDzzE0LpUbQDKemFWsVRhI3a2zo6M26KZLuNy?=
 =?us-ascii?Q?i7eGVRpTs7UGAM+OGO7Q0xRJv84cT0baQvk3kn5vH86eB/p+u6wHZqWe9kxW?=
 =?us-ascii?Q?q819Sb3ErwQ3D7sunOyvTntjuupJWly/n2O9uIC15qP4zz8LgXoSTsVtnxdA?=
 =?us-ascii?Q?eZHdxPM4d1IfqRzO0lS1xy7LgVUJzZF4Bp7a2YEyM83Sg/xsV4jpN4/3m+q7?=
 =?us-ascii?Q?/LWnXBp92kMcUyH5fEp2n6gfelo34pPah08VmyZueZaUHM+buD2i0yVxKWZv?=
 =?us-ascii?Q?uowB1G8tYCWJR6DZ5vFvXZ2IVSwHcetM6CyVFB+DGkWQPcr+viR1uHr1eBJW?=
 =?us-ascii?Q?KFqIM17yuYOpd5JKZB1N696NjWDV54pz/PbSWdObqUWYM8npClQ7o2vF9aRo?=
 =?us-ascii?Q?rebEYKM56VUoObE4gR1OADVpCODAsYedi93htDCa06UirXUl4yRSalS5iaDq?=
 =?us-ascii?Q?0re5IbQrErjB+mQxJh35So0eJsiWiGTNFAjVlyhe7urIjijP9h1Sf4koYfgK?=
 =?us-ascii?Q?Asawda1t6WzT4XoNRlsOoYGxfbv+JgF46ip9MKrofG1Fs8Z7uVeP4N3D9A1o?=
 =?us-ascii?Q?DZlW+f2MyjpD6kTxRdRaHKBgh/yw+VStYvfdbSWARhAA/x2ogHXxTYS0yV1J?=
 =?us-ascii?Q?rTFOiB1h3ShRxV0jGxa9xWOI50OsmvtQF0Vrv/CKd17I2q9iYzd9qK/As3o6?=
 =?us-ascii?Q?2S66iKSDh+hpMLqbhf0bPrhxd3mQNNBHDjlA95aW5h4FLTQBpTX3byef/5/S?=
 =?us-ascii?Q?mSsH7rtdJ9kpJc5PM1BUHmrb4MVBmS2LxAvA3Ev4G39CdfrsPgkixak/4XJ/?=
 =?us-ascii?Q?c6E+7C1KecmZr4OE/AXaDltUICIqzkWCv2ba09LSe96M5EpNgn1AOHnozmRL?=
 =?us-ascii?Q?PNueh/VcQmc6cSJiLKq7Dp/SNplm46XVtcHQD+X5SO3Dx4gyCYXrk/rh7YyP?=
 =?us-ascii?Q?g6E+Dz3DgYiANeDWyEyEyoUzkwdv5AFDkkjIucYKyOE9lKuycoPIeMCUH/LT?=
 =?us-ascii?Q?LcrlkELV6i97mUrX4yzngOPKHYWFZF3wVkU1xELxfHI4chb+qRPXDjM+N2UN?=
 =?us-ascii?Q?BPRPh3c+cORZ7KWhpUmJk03NHrHJ9nbvuMeKN/cLbIWNxzLHeOI1N3r5hjF+?=
 =?us-ascii?Q?BNL/QGtuekLkId7MkwsKX04=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f17b406d-ef5b-4c72-eae0-08db0f72c8f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:36:27.7064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lT56QruPjqo8GAY+wQpD5GdNcno+oRvwz2aW3ABlv9H0bmJzXGehGtuaoJ/5GzMc0hy92J6UrSzGC56JHe1lw65uLoPZkVLHCtTvvLjNAWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5459
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:14:20PM -0800, Veerasenareddy Burru wrote:
> Add asynchronous notification support to the control mailbox.
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
>  .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> index 715af1891d0d..80bcd6cd4732 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> @@ -279,6 +279,33 @@ static int process_mbox_resp(struct octep_device *oct,
>  	return 0;
>  }
>  
> +static int process_mbox_notify(struct octep_device *oct,

void

> +			       struct octep_ctrl_mbox_msg *msg)
> +{
> +	struct octep_ctrl_net_f2h_req *req;
> +	struct net_device *netdev = oct->netdev;

RCT

> +
> +	req = (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
> +	switch (req->hdr.s.cmd) {
> +	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
> +		if (netif_running(netdev)) {
> +			if (req->link.state) {
> +				dev_info(&oct->pdev->dev, "netif_carrier_on\n");
> +				netif_carrier_on(netdev);
> +			} else {
> +				dev_info(&oct->pdev->dev, "netif_carrier_off\n");
> +				netif_carrier_off(netdev);
> +			}
> +		}
> +		break;
> +	default:
> +		pr_info("Unknown mbox req : %u\n", req->hdr.s.cmd);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
>  {
>  	static u16 msg_sz = sizeof(union octep_ctrl_net_max_data);
> @@ -303,6 +330,8 @@ int octep_ctrl_net_recv_fw_messages(struct octep_device *oct)
>  			process_mbox_req(oct, &msg);
>  		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP)
>  			process_mbox_resp(oct, &msg);
> +		else if (msg.hdr.s.flags & OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY)
> +			process_mbox_notify(oct, &msg);
>  	}
>  
>  	return 0;
> -- 
> 2.36.0
> 
