Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7715EF3A9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiI2KoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiI2KoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:44:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BC4F8FB1;
        Thu, 29 Sep 2022 03:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664448249; x=1695984249;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WWBjJ0rMGy+UJVwfCA2/etuUFlowKE0toFNQUiMrwv0=;
  b=DQsCreE2428LJzTg/kkFxCfFRIteft2+3aTFXMExeMuajiV8ApljABFD
   zTqyMwoKXkxwLYw0K48B+ziDug5hoTy0PnkRJ0zxViExCCDVNATgrmrzO
   CgrbnRngM6Qo8K7eFc4kz7lEm9cr9tSlyAdlFe4Av7TC3tpHE7yQ3+w3H
   3YiUsEye3MtSaTNkvDxfg2VuY0voQs+OLBVpnX43vXWQ8Pc9piRCNJKHa
   f7YI+v4tt4mB2eTwd1voSXgKTycp8oxZffqkRlVA/FtljO93rmY5QfC8O
   yQMHUPDP7ApzQl493O0Rq99bHbWlCCpP8AsYtPLXzHIAL1n7Ghiy6Yv25
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="365904850"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="365904850"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 03:44:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="747788416"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="747788416"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 29 Sep 2022 03:44:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 03:44:08 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 03:44:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 03:44:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 03:44:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTuBi7I6sWGJFV46CXmGsuo/yk2AOVCiHW/wF5AUbjS8CrgjeT1CPKwB1ES7EnJgJy8Sew7Uk2iVyKuIUutNR5piAglSQ61RCEXNzvJL7I5zas1+mdhnWpQLKoaosBHeZ3/7emzhgujzzYXpAU5/AK/lI9zDlawvDGvHKBoFmj195+B7jVtHDHTQhfOQUCw/iKXgSYLtxCU+snZloqWtsPTJvA9hkQBVWOPFm8xF4jwk2vJkK+zEP4n2Na1lnalwFiCY7J/pvatG9JoaVZDy9EZmw85GJayUVuwrcMEBC31wlAjd2nE+BVbUztnoNHZzef47NW6NEV0b1nf3OZP/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZARna1Kwy/VSSKSAUPlfMvTUoMIN3s7uPVD4SclO+I=;
 b=he28o1xu57WhLh1H5s7Lc0h7bWc7wZiUPTxalnikG8WU5anR1Y1iyCzJuqLdKuIWh/MROdWjJcXi5z00NQW5tNFOO+hD9qmMLm126RtdbeRblTqo2EDMz7n5hgy3JcCGzl1Nm0w/8j/mSkwDZQSPt1pKI0LSEd0LdEIUrvqvFngnnPze0ZdE1Ffc+SLAtaCeqMR5oeK5bXhGa7y1w/WTRSx/eW5jAFKL6JtvdJVKrcsJs9DIQ155mlx+Dqr2y2PfVEW3wbwRkwICSMvCcnFq1SpYCpsEB0hMQli81aqZ3IqY/OEksgmYj1WfheJbaNxbVLkvh55OmQIDUOsob9LfJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB5439.namprd11.prod.outlook.com (2603:10b6:5:39b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Thu, 29 Sep 2022 10:44:06 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::60e2:11d4:5b77:2e67]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::60e2:11d4:5b77:2e67%7]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 10:44:06 +0000
Date:   Thu, 29 Sep 2022 12:44:00 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests/xsk: fix double free
Message-ID: <YzV28OlK+pwlm/B/@boxer>
References: <20220929090133.7869-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220929090133.7869-1-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR0P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB5439:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ed59f0-822f-4754-99dd-08daa207884c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H27O+fzixQE3SK/MTSHVIkp64xCVkRcln1xxH72mzNrV87aDjgOU6XW2QDt5yEl/ZXmWn3TGNeBD2W3RRURA+0hkItDv7xEKnfq0RrqYNiDywkpsSqX4jA+y9pfzTiCvq/lhg8FeIqq2qU3ECzrnMffs1zJjTCSrrBIsn3RZRAJ0/IjjbwgOQ2nB+vwlOTgUNe9t7ryw7L/kgbWY3DiSW63r/DkPKajB5lBWVf1ULCvg/PIxLcMnupCDN2LUMAA6Uu18HdP7SBux2gN8NsI8vWahNmjZcQG0RkLnj5YliIi6+5N61bwvPiZO4gGEEFPC/hJwTeR5kszzYTeQtdEEOwcg1V1rZrF2M9NhzwNDH80FDHxmcOSzsL8ldp23Ek8xCTQ3KIuDixhuVKp+YzodtUrQeTnjKfPwQ7f/niVb64Qo7pGowJ/mfk09cdt9qN4ldkX03hsrTpTMYip0WiJSSd5/l5XqBNieHAiBjKq2JsQ0Jn/nqMNklZ+1y/A2VTpMXgFXlT9FA4Bw9R3obt2IHU33dwLTUDQIKVUasUsUjKgoGkQitUbsoeUPQKYuzymPiLMivsvs35zXSuSy0/gASYjciZ7oE9HlaiE8opfVN+Had1GR/XnmbJn3QyutKDKEYX7pNpXM7fUnfsSC1V2LF8T2nqojigG596Fi9PXWDqGa9hE3HqnjYjrj2nzSHfYNmqbt8dDjPnS7+l8liNMYcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(44832011)(5660300002)(8936002)(41300700001)(82960400001)(38100700002)(316002)(6506007)(6486002)(83380400001)(2906002)(33716001)(6666004)(66556008)(66946007)(86362001)(6916009)(4326008)(8676002)(66476007)(9686003)(6512007)(26005)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nx0MMjXG6+R/sA2hU7bJtz9rTBqht+41pM5pOx5B9Sdadc7Vg8ndA6iqAbvE?=
 =?us-ascii?Q?RbQYC0J7ipV/CtQiMSyCA3RcPW7tVAWrTDfE/WQ2t63qvagyZPltX4jQKC8J?=
 =?us-ascii?Q?YynYK0n81wTaElSH5PhQ+bw61FpwqDPWowbO/n+xgY1YrsO2sQpAUhCDCrxG?=
 =?us-ascii?Q?X24T003J+Oc9lYDn9pa4t3KIMdJWuIjuHkCeAFfnCXJCrXXuzBVo8+woNmHP?=
 =?us-ascii?Q?9yVL9ZsJ50ft3gMVq3+G3vE3RTCIwQb2zCVNsvFIgDIYsehFJPEOTHnjr38Y?=
 =?us-ascii?Q?h47xj9L2OEFLe7ZLpT5I3ARw9vyyCE9B8dKBI8gda3QdgoYiK0eOmWLbTnwz?=
 =?us-ascii?Q?p36D7pdWeJ7FT/Ct2LmbmJhuLefQKR7YAQ7YFeEWooEDUQQa7oAdEQlhCk/c?=
 =?us-ascii?Q?QrGhF+Jqaxsv4iMMyLm86PrV6xpra6S52dsVf6dInvmmHddirdYWaRVBOoBN?=
 =?us-ascii?Q?P5SHYU+thdGsmW6CkLdGkQrHu74lhtnVsMwOSIZeGjI8Y2iOWyta+ybsqT6W?=
 =?us-ascii?Q?Ic+5lgf7ElRQfJ0Oo+qJCsej0olcXyVUk2MH+qYZN39N15L74k1KVfV0VPrO?=
 =?us-ascii?Q?mj2eCEuuxbWBW9drDR2iJU8vsrJatwd/V8s1deMeDSsXdqXVHplDTZ/KD4qZ?=
 =?us-ascii?Q?hx9BnEDKSc/o4g7kRmjzcBnvS2xJAWKtBemwNKi7fKh2cvhFqVEPR+AiQIZd?=
 =?us-ascii?Q?yfBR584eVHigHY62MmVJO9BR3J/SNqJ6cPdbtukV0FFiSepkpnqfC7oIsIzo?=
 =?us-ascii?Q?j0czZVh7knZixqJCdVnymN2swPvx2wtnfKb+VFwCjkZm5GygZNimifkLkAWV?=
 =?us-ascii?Q?wUjvtJArPSoGlNlvx1THMqbXC1R6r3Vu/JshWDt03eWwWWQ45um/AmROYv6t?=
 =?us-ascii?Q?XCKOsY9chyAp27ZFIzVp1Rp8Fb+LWMuacAMfurfjCdabEA/jzCR8kwA1vizp?=
 =?us-ascii?Q?YRX/kRZIptLAYX1pwdebg2h0eULgL9z/Q2GUrX17jrUFfGcC/Oi24+B8+N3B?=
 =?us-ascii?Q?0ofNINtwqCDJuE7JbxOVniO9pASLAUMJlYP/UEYwSug15U+8qlusXxg3bLLN?=
 =?us-ascii?Q?inCwQufq+a6kOqYQFZMVFqmXqgf+GZF1eLeMCwtoR6xOg0sj3zsEhQbtXfQ1?=
 =?us-ascii?Q?Shg89HfmBsDCmOlMzpol+dU8uIBA7WqlhNymDK/Kty8SlOBPz5N0wbO2t657?=
 =?us-ascii?Q?dbPkh5sDWtjZEmCdnA1WLn6hTXr0IX5Wj/4YrJ1RHJ8bDw/KyyNpJaFdZvx5?=
 =?us-ascii?Q?+yDel5XmFdW8db3mM1vg8AWgQhr6/dT6M8p+pRWMI8XYD1+2RID5TpRFxk7O?=
 =?us-ascii?Q?o5FAnf7z6jCtaTCcIK7kyYkSYB/pwSHAflJozJZFGCofrPhT0/gOV5uBT07m?=
 =?us-ascii?Q?OGgwLeUQRzH8/DI48QH23l2coZ48kSwQHND7v3aki7mTRkCHFcdzHQeEIc+P?=
 =?us-ascii?Q?9NT1Ok32GIMlpLIxclZglxE/Lf2MTYm5YWJx3oKauMPLQdS7kK75gXmHown1?=
 =?us-ascii?Q?+9cQnQNbL94fa4Ku6QWTVrQfh/ajI3lmxAZz9ljVZpoEDfXtWH3y3NzBwZT/?=
 =?us-ascii?Q?5Lxmr75vwBxkE2fIVco7l06qHICqdtUcRgD52LGN25y6+4X0hMlx9dUl98TZ?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ed59f0-822f-4754-99dd-08daa207884c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 10:44:06.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huggyZpRwrCaJSUc63aZfcbEIYzOFeM0pznMSEIx+Zxq6y8R53g8SYewkqmeyt2kRctNOI/RUqnOltkOk7AYiAS7F5Q9hwvGcIsN48GZeEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:01:33AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a double free at exit of the test suite.
> 
> Fixes: a693ff3ed561 ("selftests/xsk: Add support for executing tests on physical device")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index ef33309bbe49..d1a5f3218c34 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1953,9 +1953,6 @@ int main(int argc, char **argv)
>  
>  	pkt_stream_delete(tx_pkt_stream_default);
>  	pkt_stream_delete(rx_pkt_stream_default);
> -	free(ifobj_rx->umem);
> -	if (!ifobj_tx->shared_umem)
> -		free(ifobj_tx->umem);
>  	ifobject_delete(ifobj_tx);
>  	ifobject_delete(ifobj_rx);

So basically we free this inside ifobject_delete().

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

>  
> 
> base-commit: 8526f0d6135f77451566463ace6f0fb8b72cedaa
> -- 
> 2.34.1
> 
