Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE946363CE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiKWPeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbiKWPeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:34:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A71378D47;
        Wed, 23 Nov 2022 07:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669217652; x=1700753652;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qbB138/7iikZ/+lcxHuaGkmIonFTEQvG7617Y5VtLhA=;
  b=BQabapPs3l6ZsPO85XAZY3Zxa8AkQc5OpAWBJ8p/UMjlYFXS7AVEewIm
   XeO40lB+y6xRzsiucZgG1qaTpi2v/tCh5TcOm46h8kKTCaGaKdlcX7Mlb
   vPCYQDP8L3zq8epU89oEuqcqxzJPzB8siJ4iOQbUde7XItARMlxxSQFfM
   GviJlFFdwq5CM0oKun41kDWdqxfmw8t+db8SV77CTeTmYthzpnlxUeKbL
   VI6oICUGJaS6yRLMTbUj97vAtnnH0WSPjSkXrlm7zwLkR/nnwzvX7jsL1
   IZHW4D6VYa3ICkcR+u66+NhFUsMcIZe3p3W3deGpScH2vE7P45Uns7c3t
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="340971042"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="340971042"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:34:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="766758482"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="766758482"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2022 07:34:11 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 07:34:11 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 07:34:11 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 07:34:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZCx8ojNtWtn2TIqfJMPsMlPcgLvvbgCbnDTGHFeCFURXpPqZr7hp+19NvgystnmYcCv5zizHggGH7hNED1NE/3HO9Da+0B2kToqECN0rS++UzgY3kgt3fIpZeAAU6+F8E8aC+8U3aO+xzW17K4zINKBxiqDd58IBwUr892urGKrpOYFU3G3vSQKVmwWOU4h2y5Zf/kg00o/uqQYv8Yk5HmL4Z807Lcu3sRbQiiSWNh8zhkVVblYqPTEVbl592/MKt7jlB68PpAtPFa8w7brgI5Q2S4RZKHuhrLFfjvuAL5b5UrXq4FfqNsRPmGUzqalqrmxlsb5a8t5qTAuzNlm/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a58KXowAJwbrABBAN8+oWlhtO6qlBR0uD43TdJw0D8s=;
 b=Bx5Nr3/3zQgT2q2q9hfS1DRPsIy7/WAdP1pzWNsxAkl9q07gPLcCvH/hLEg19SlAZg70EvTuQIGzYpBG1bRU0WoSv4q8gBdXF6ocTi/BFI1gahkkaGQ21H/CQNAou7emimuVnlxiuyXdVSfcEBqn7GnDAiFIbnGv3xftSoUB+orXZSKiaf5/gyE5O0wo7W94jKDDMM/FNQswyBPGxhFgKnyxuFaxj0RUGgN0xVdLrrmWhef7mDmXJtXalMcRbowOfqdBgBXP8t64HObmrhFhEUvi5Etmnqy+GVwlHlHJtCGPkkHGQTGbB9YYNILvP32ihN+h4mX29JfKt9fLuGD46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7685.namprd11.prod.outlook.com (2603:10b6:930:73::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.18; Wed, 23 Nov 2022 15:34:10 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 15:34:09 +0000
Date:   Wed, 23 Nov 2022 16:33:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Yan Vugenfirer" <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Subject: Re: [PATCH v2] igb: Allocate MSI-X vector when testing
Message-ID: <Y349YhHLzG7FwomD@boxer>
References: <20221122131145.68107-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221122131145.68107-1-akihiko.odaki@daynix.com>
X-ClientProxiedBy: FR0P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::22) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7685:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a4c9579-07d5-4647-80d6-08dacd682a5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxqfijckLE1dj/Rkcp10SxWOkmD1jWyQrD2x8KPXc3hFiYuDHCVvWXmAlMm9pcbMOn+l7DJ+rA4eSvRmNfNDAY7EBiVR1TTnmvphOhcCKLWKn+2begXjb+7E5U7lH2ScvpKssj1tBdrnpJi2RZMdUF+rRk3LoqAOFfWRXYxKL4Lzxp/Gn3uVeDGmkiRqW4VUIk2xSgoIR68Ub79sQXQo4pH3ppNv6y81IijpDG2ZHSjNjLi5uuzQzzAxq/HlF9MO7YmcVh8ghUaGgOvCjj0aJt2qinvgyGmfVzDoewXTBFCWnO2CfTs49x43sS4qopKdSO8UhMPLq86nRGROdhnlnCGSZHVg/tqjieNdsOSrWiBI4LB04GMN5WLguyHDy3sAzr6wOQ/VQ4HCqcWiENRsklTZK26VrQCPOUH4M6qym48nRk62AXhJK39LoIeDC8qEh6rVj2rZGVYq++Oh7RXLIrPSFD5Cm+xAISfV/y0Mf+VtpKqrmLutkms3ZwhephtaF4tn8TSXvL0vdNf8qh46171wszvTnQIgXKjAUP/l3saDFay8euYNwbn3q1UgBT7PQNKBi+iilNH7t+gA1hz2S3AVAAubN5UJRf3/pQUlkKuvNzENJSlHfrk5PDCYByKdtXETfr33FTo+PyCKsh5ulQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(82960400001)(38100700002)(44832011)(41300700001)(86362001)(5660300002)(83380400001)(186003)(26005)(9686003)(6506007)(6666004)(6512007)(478600001)(6486002)(316002)(6916009)(54906003)(66946007)(8676002)(4326008)(7416002)(8936002)(66556008)(66476007)(2906002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gztX+GSaEFO9QCBvftgNi632pBp2T9msFzWKVq3NmL+U5IXZPuOaoA6f8qzU?=
 =?us-ascii?Q?WUBpCs2heGONpYiuyqPugErNMP0wsbylyGgv/Fr/vA92q3rsFMqKmv9Lkc3o?=
 =?us-ascii?Q?thES085kiUP0sJOpY0V5D1z/ekQsVKly3x6Lzxi9/CJOgAeY0EgLXVZTcaCV?=
 =?us-ascii?Q?3iV7CpL5yJWw3+k9ov7YKPh1/fK3H4KbXRYQneQOd7oFZg9ld2eLUyPN0E3I?=
 =?us-ascii?Q?UlQMT+4kJiLGUhn2MsDaLhY+cAgvrQYJx2M4st8QVrcH/Vb6LrF5ex9yX54r?=
 =?us-ascii?Q?PHAcM7jqZwJgovaMVeQ7cTyfHCTVi0sPtS86zl9JhWttTgK77XYU3ia76Z/K?=
 =?us-ascii?Q?9GbxtvfJKS7ioJo6hpSho5it8/mYGc86hlTF63AOD8wsD6vjZFlf5/e4tr+T?=
 =?us-ascii?Q?nPQ03IOQK+noIr3OV0HD/tlYpEpG204k14NlL/Cs6axVUVcVf+/yDsAcC65S?=
 =?us-ascii?Q?mM4rAyHSCwvZvghGy/xCtpIwhi/KlHtnPEPKK4SJR3zvjA88P4bm+sBc1aIQ?=
 =?us-ascii?Q?y6R/MjPPn2Kksf2wi4MJRkEJ2clRg9vhvlR4jdfiUe8KsXdc+tMmMuOGYf9y?=
 =?us-ascii?Q?UVwiO+sJ3OifDbXzfTBw4zPO99UT+xqHbscDYqgS1jLppv8Ksw75zJ5rnwfR?=
 =?us-ascii?Q?XW4VR6VpJRQKE1SL6lZUk6e5nW6eY+n20bqVgPvsj54TOsIbAlQChWQKHXKo?=
 =?us-ascii?Q?XbWdn/d212qMY6ibpw+09AObXHQPyKLieFbi96f4OejNZ2OQffs+OIaH/d8Q?=
 =?us-ascii?Q?Q8djvBLOLDPpmiff/tLOcQG2Tt3ip34vHkOe7jSSP8CT4gHnRIZEiTbzUgqP?=
 =?us-ascii?Q?ysQks+Jy3dihAqbGPkiY1nc7zKilWlDyun3bx/9aJgNEJVrcFbZvksLfblqc?=
 =?us-ascii?Q?r7+iB4Uu7rMSU5fP3cVfVqt3wpz0h+TgtMEPbIzfkRBTBcO67aiBWgCaeeeC?=
 =?us-ascii?Q?9g3qPcoVpGjxM2YTCKW7P6o6+OIz3g4wCi+TakfCDWgOCL4XPoQ6WIHFyAeE?=
 =?us-ascii?Q?oOTefXC8+LooqfcbxVXH8yE9VqgzV/BujMVK4Quw7RA80wzyIhK7gNPzqHyo?=
 =?us-ascii?Q?Fsyyu+seD/mqUV+77loUGg11noiZwRGM/FRdIPIKAE0sUP22SeOe1S1cq/Ey?=
 =?us-ascii?Q?6Ap728QLw7AEPKboN+RYuBkEF3m/c3XtyBWH+XYFCb0bHCgLsuew4S7lrO0K?=
 =?us-ascii?Q?s8TaY1hR29Xrid+oTftWOklOXTjzuHe/whmBqsGkmA2yk0Ds2Wh0tofgBN3l?=
 =?us-ascii?Q?4Yo+ZzEbiTvP+99wNBw4zUq2vpmj0CVt14fhP4I71qpeU9Vg0rlVfNu8UjwD?=
 =?us-ascii?Q?GVM4zVAinDzM+++GA6RSMLnyQY+73T9ocdVGeFdt8J1ffl2JLEUeJ7mNMqkM?=
 =?us-ascii?Q?6j5QjfAOhNJ2PB6zkhK/VcExQY98b31/b0vuREXOWdZlCgtvk8MEM59LDtmx?=
 =?us-ascii?Q?FwiCARIHhjcqA8BQi80GXkjXx7uP+yfKM6CxMsyTxLK/hjHGRIuUCVmiXyrO?=
 =?us-ascii?Q?hoeGIto5aZqvdLd3jHFOy9xA4RUrVojVrlUXntoWQpGeZszy8MUNCp7E2nwB?=
 =?us-ascii?Q?Y2OloRLoJ2f3j7kMdFl6cuNJ1fTpCXPAIR/6UPiu0LJLeO+1BEpGx0+CUBnd?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4c9579-07d5-4647-80d6-08dacd682a5d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:34:09.8816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/2MRq+QIeu14kJQu5+k9KNSuWOMmB6o9yC4Qu9NOCrt9QY025hqWuN1F0rXdJCqW9XKJH54KWvy7V5fW2lFgoHIfPddY1fPNFNdO7QlrJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7685
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 10:11:45PM +0900, Akihiko Odaki wrote:
> Without this change, the interrupt test fail with MSI-X environment:
> 
> $ sudo ethtool -t enp0s2 offline
> [   43.921783] igb 0000:00:02.0: offline testing starting
> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> [   51.272202] igb 0000:00:02.0: testing shared interrupt
> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is FAIL
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 4
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 
> Here, "4" means an expected interrupt was not delivered.
> 
> This change routes interrupts correctly to the first MSI-X vector, and
> fixes the test:

Imperative mood, please - "To fix this, route interrupts correctly..."

> 
> $ sudo ethtool -t enp0s2 offline
> [   42.762985] igb 0000:00:02.0: offline testing starting
> [   50.141967] igb 0000:00:02.0: testing shared interrupt
> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> The test result is PASS
> The test extra info:
> Register test  (offline)	 0
> Eeprom test    (offline)	 0
> Interrupt test (offline)	 0
> Loopback test  (offline)	 0
> Link test   (on/offline)	 0
> 

You still didn't specify the tree. If it's 'net' and you're not sure about
fixes tag, then please provide some explanation to maintainers why you're
not adding this.

> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index e5f3e7680dc6..ff911af16a4b 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
>  			*data = 1;
>  			return -1;
>  		}
> +		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
> +		wr32(E1000_EIMS, BIT(0));
>  	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
>  		shared_int = false;
>  		if (request_irq(irq,
> -- 
> 2.38.1
> 
