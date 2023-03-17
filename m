Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED1C6BE949
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjCQMcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbjCQMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:32:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB82376049;
        Fri, 17 Mar 2023 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679056353; x=1710592353;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W+EQejgyLUFdC+YUCbCiowaCU3YeONi8stt5wXBjPxc=;
  b=U3QIC7UzgrwTKbPfOZ2a7jImcQfvHmtiTLzq1oWdSchDusheCEsVcyVh
   bEpFggeR1tivRKmHjMfIB+P5Zyu+tp2ArArg6uyDSWMimfeWZzNS46jmV
   mTPeSWsEpKhpem1wEdyj8snsEhZWPJpNKVrpkS4nZCd8BGIQsUftAJxLK
   pyVfGCC/2rG8B2LecpKOypWJTVUgpmXvUJFNOqgzoCBwNoC0wwEL9XxsA
   cIVM0KRN809jFe1kZcd4y4zQOp3cjWSAlCeg3OmkfmMWaEus3SVAANYz8
   tsC0Umw+t43cQJNT8hZDzrQlhkaD9IHHUnbe07WGDzx55Yq7Nm6HpJFWa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="365949868"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="365949868"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:32:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="682664776"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="682664776"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 17 Mar 2023 05:32:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 05:32:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 05:32:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 05:32:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 05:32:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzMoVsg9YvspT/7++ZbiSqbMKKmWCv40oZ9iVuDUHy2g1LDGJT8JNDmuafHOSwchczgGohw8HgkE5V44WBF4s8SjMAhsup7/fbsdst6m8AIrsplfNbgE7N4oCxxNYzc21wPnLsbu723Y/C7cgdkTxjrsHVpwywbosVjpclykvkk18LqS3gQ7KwV4wj7nqOX5XHiBnK5dq2SmRhzwwHofLUP0pEFokCQEkWjYorYWPHm2vgSYNpcmssGCKlSaj2qQcQnfnIM69yZKTO+zGxiAhjtmwubt77Mu3Ib/qUC6PJO6CUTg7sOCpTPpKwrmCbwEE4iWE+JbdCfceVaO0wl/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qazdd4QMDJ9skl4wHDowdwnm4weCOgk8bmXdwgycoUY=;
 b=bcB3/bNUgjjaCt3L5OkvPeapXw5BOuUMQUVsjOgIpCB+dkH2B7NJSCQOrPNVdAJB31UJxoHjx+Sh+FJq7fFDvLqwIAycLoRU7A191OMkjntc6fL5uiSp03otjKLAwkF8sa7zmBXFZwoyswdohmRBzYCPHeeUiXjZrgT/Tsecrz9jQtzraoHrUxIwA/rpQcLn6fpYoDO5H2F9MEWA6KBnCYDPE83e3+0F3mI7svI4NMn4n71oaSk4k4coZ+1L2qMTkNZq1YBXw+0QctI6eZphtCzxeHEbfgeWOR5/L+EdiiBRXiT48KyZk0mm48H2AXP71AxZkPpY7LY+tEWptFP2Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA1PR11MB7086.namprd11.prod.outlook.com (2603:10b6:806:2b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 12:32:26 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 12:32:26 +0000
Date:   Fri, 17 Mar 2023 13:32:24 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
CC:     <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong Boon Leong" <boon.leong.ong@intel.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net V2 2/2] net: stmmac: Premature loop termination check
 was ignored on ZC rx
Message-ID: <ZBRd2HyZdz52eXyz@nimitz>
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-3-jh@henneberg-systemdesign.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316075940.695583-3-jh@henneberg-systemdesign.com>
X-ClientProxiedBy: FR0P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::20) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA1PR11MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 99c27aa3-c61f-402b-5187-08db26e3aa35
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W3LnoUuUxgMSpHzApAgT5so2FqHxDA92H8KBx2RzR01GznKJYfQiDRTu+tpoHLk+xIhnzjOOjK1RcQ2unG56NKFl3NYxhghwOjuW6ppH1DAgo3bYGw5eZYuLlBOOtFPSHhmnzdzy9OiqIWPdzBhPathH8YfKe6yzqcUnDC/xVYM1kGniJs5eIyit+WgdNOQfhYc0dUhbok+a2xJ/MIhh0UERdNNxht+1Gso53YH+7iIwzwe8VpbvupZylNezySkhq/D0ghtLaTfRTOrqTtpXIE6QQ6DFQw7xifbPOUHiQ4FMqsaUrxJTnQfU/trW2igOmKj01LfTCP1rGI/bIVvOPp4GNyMhc3uH1MR/J9MKimm4f+RsxgUpoS27rmSj1wrnVyVcE6BQO1ez8X6ogqhaIQy3DKLHFjBRfBl8v0pIanZ1EyGw1FEkanTOZqPfT/rLtILT0aP84WVo9h7YEteT9SoWWpp3pJVbrIBWw1SXjW9cfzPx8mYdwWQVJpIjXJZ6NFm72WTsKY+UKAtBmTHTc07X528vzgoqwUDbkzTXYXyiv1J7IQqOf6EPVj/3zYYQ6rxb2oMhJddXX5VHU5M1b5oIg0p7WfQDLCNJRvJ3tP+xeDEeCo9a28J2lR5ux1g9s1QqdTgRebzJAuHgNfWhk8XlqziKefLuRuemezD3VYrWLX9RtYYmEX9Qnsabk8Av
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(478600001)(6486002)(33716001)(54906003)(38100700002)(4326008)(2906002)(66556008)(6916009)(8676002)(66946007)(66476007)(316002)(6506007)(186003)(83380400001)(26005)(82960400001)(9686003)(6512007)(41300700001)(8936002)(7416002)(44832011)(5660300002)(86362001)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1QMJaS5s47i5ALIbVML4cu1JmNYyXNMpt8F/SACCGWUTrnpEBmI10NFif8bW?=
 =?us-ascii?Q?bjaJWL5XGKcfWC4mdf1uae604gPOTw+D+WOko6ZBSy1zV+/owJq+tQqFZ4xg?=
 =?us-ascii?Q?PLSzkL4/zH5cBH8g7BSF0e7kQykgRJ0VNeNFgutBRjmsoqaBmtFDWajAkrzC?=
 =?us-ascii?Q?X/GNnTd9QUMLX/1qbj5Xn80Kcec9avq04CNJAlxrAl4mLjj/RoNS+GRwz0PB?=
 =?us-ascii?Q?t5nWCMrx5S6BKoWgBPdajq0Z4Ic7i7XghFOl85VM/B1Kq79r4BD5vxr/2/wp?=
 =?us-ascii?Q?t5VmtIA8zDfnZM1TlGjZWxILzfiIOG8/uD1hjmdmkAUT5O3cBw7cOsWtJJES?=
 =?us-ascii?Q?ZABfVjDioCVpao98+ONh62+TVaES2vHQytiPPLXR4VN0/Ugs5phs8aY0hidN?=
 =?us-ascii?Q?p+GsTtxSG8TCTSIlI6YssoUhTD2/ye1slOBCrGFuDBL4BZcXD4gP+dyX4nxZ?=
 =?us-ascii?Q?FcKhpaX6poKOcSjVYVxVuBIDV/THyWaLc2RxqlYN0ACxsyVzrj94mKF6H5sQ?=
 =?us-ascii?Q?h/GXhTxLlcRKorv+2rWwcXS01zXad1kuvLFJfWH5MJl4upEeMeuc/MNkj7jk?=
 =?us-ascii?Q?4IB2dl6r579jfbGAmdsfNgrmxLl1xFcAOAtG3IblPZRaCt3/vYAmyAtbubsa?=
 =?us-ascii?Q?UYS2aSPlDC6Bo3e+kgjVMOjzjyQHcc16eCtaSHO2nRAEUM6LqJttFEsvF4Ot?=
 =?us-ascii?Q?lwGIv9NbqGaF8S+ldyXhh8fnmvdwWD5/p2F8Zj87a/zj0+MkmmmCD9Zk3jIm?=
 =?us-ascii?Q?frGXLRtFi+cBc0TJasPZQqBGsFCEK30uVip3fQZA9k8c7sQ9G8el6V+TTWVH?=
 =?us-ascii?Q?5BGwtkf07VoXCoGkK0LDWo6nru5KhWIQeNPngCfP2j056HYDJUa8r8kbvZW7?=
 =?us-ascii?Q?bJW2OQTWlKKKqrHpYDdVU+HXLiS0Dm/T2WGlBp1osd9o6H+QlAbdSMbFVZs6?=
 =?us-ascii?Q?rrcVxMm8/7PY42MQbc/2sf/6wAZ7qIDmD42P0T12vTWYa0Pnfj8IFGMsz/cJ?=
 =?us-ascii?Q?RGPq/KMkgt0Fm1cQE7zgZlriD1sNlwn1S0jgNYRc+R+y8nmOCuRcLv9DV34z?=
 =?us-ascii?Q?diRWJ30ED/lHyO/IcHkNjBr910EUQw0fXsEf/Q9D7qgNfHeJLcVehIHZPJGE?=
 =?us-ascii?Q?CXvzaWeqioyv9pgjqg2zYil5kZO7Gj6efGvobEV4OMIShNrGJDPkPCRrxPIg?=
 =?us-ascii?Q?ACT1KqHtRQ3rHDsd4HfJ5PZLueRtcoliKfRfs/bPViTneag99hk7+1ZsaGPc?=
 =?us-ascii?Q?Q75F/n2fG7L0tf+G0U2VRA1lJ+wRQ7F7Dif9vxvr/C/SJBP+l1NieeHRTovv?=
 =?us-ascii?Q?rZv8cftING06saQ4WVsgee8RDWq6S25+LLCEsPVmUaZvEv+ojHg9lX3MKf1R?=
 =?us-ascii?Q?CFPIqD/DYjGTwSKH58YS44PbJTgdp5NQGxVU3kPkDM0+b2+bEw9U7MybwJFP?=
 =?us-ascii?Q?d/TlO0JVZWw2mWQfNukPlu/cpjj6ysGjdzaG8gDKuY5ljI9y3KVDeBRp7T2Q?=
 =?us-ascii?Q?0fgxAu4aMA6ewznexO59HoJ46hNoECo2prV/GYQ2zQCd/g2OZrH5pEOn8g9r?=
 =?us-ascii?Q?Uty1U9lxQE4O2ZWRC/Jp0KPe1UUCSXp5RxVy5NEk01A8jln9QGxFiYynB/QM?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c27aa3-c61f-402b-5187-08db26e3aa35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 12:32:25.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R5xsYPjZEsXVDlvFJGivhjUVIjl5yr+ykjcABpC2bs4TYmr1C6YybMbHezvurWRl4dumNYBbIFTPK+L1RPYaB9No7kD51NSoobXYdDPskAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 08:59:40AM +0100, Jochen Henneberg wrote:
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.
> 
> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index ea51c7c93101..4886668a54c5 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		entry = next_entry;
>  		buf = &rx_q->buf_pool[entry];
> -- 
> 2.39.2
> 
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

