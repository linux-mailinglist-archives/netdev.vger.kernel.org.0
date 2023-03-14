Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B16B8DA5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCNIlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjCNIlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:41:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE162D84;
        Tue, 14 Mar 2023 01:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678783242; x=1710319242;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=G9N5H68bTaU0qY10VlTQElhR+KUCUF80eifBSbWSaUY=;
  b=Ht3582PJjCkDvbFmXRJnj3vjEnOP1L2ebVek30pU5RVyszM3g6xfOqGj
   y9DPUD3eIK2AAq1TwjNBi37MvwqaMXb7Ov+9YwsRFig0vfjqzJj+yWSqG
   aoYtz68dLusbtP6IfqhjJ9lZCxBudu8q8Fxvt9Lyz5glUNUF6zh4LEZ9H
   xRiDbDkZ/hk64G0HXm50vUi4+oH7Kz57j1z4/0VZyNBbDVfasa/qMxFFz
   VlMb5+ErzOK6IcBvGZvVqXad8DBK6uQ+3DAGLq+jRpiXpk1+bdQWpHLdf
   GRJ3fKrHqw9scJ0F8zjbzxHAtopwT7qPyCo8e0E5MlCc+caYvv57IEcz9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="423634847"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="423634847"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:39:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="1008325895"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="1008325895"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 01:39:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:39:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:39:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 01:39:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 01:39:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCj8BBSANj01aRiSa0cpJNURaV/XrEMqq9mRl79ZjD1myD6gM04sm6am6LmaKv+hdrrjyKEumqprtt02xN4DBb+DDKXLTQ6jM/HDYSnKWtB1mbR6gP0ryzuKf/KEuNq+cK7U9RoRSTQZDfeso0gjKBF+5ZboU23oiIOs7TgDn3oLKXwNeu8iYTX2C4UcJmiuZWQ7t/nR1nzgN1wDDiQNU5GZbL46UZ/PkUBEzwRpCfCB1Xm83QRTzYrIefd8FRqHjqFb3H0nj8NuQvjk7m5QDFCyuNVITqWMqMZSee3R97XcuBZKQoF3KVU7cg9ZUc9x0coCyYan3PX+v6sEikNP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIAb3ZpVn5tYgFsGLPlmC+SvICehi4SVM0jdXvdyj/g=;
 b=i+yuaiJ9Bk7bTALbfa02rzKJJmA/nBnfSbBdotS10ixoxM4tDOr4ox+Tj59bUIW3NvI1nLqitM6/8su+KbtZavR9g7yD7AAqOEzSeExiDbDOfclDmNfdAwgcM1Q12h3kZYAwdHj1FjaqMkhs5LvmxwbJ7//afphqmVZZSJ/VtmGjWUfaJK4lTzOcY9FkYu7SkTmsai7ywBnz+nrh4wXalzXaRjSckODbMvazDX4wfZf09nH6+AobDuKvvVHf/WxyUlLdmkVqfm7Gc0h8HdrYQuDSqcc9uEWxQRXzUe4e4A00LBMNZEbftGara9RQ+KMcC8PERWtYiNJ/SAC0hKQFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by MW5PR11MB5905.namprd11.prod.outlook.com (2603:10b6:303:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 08:39:47 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:39:47 +0000
Date:   Tue, 14 Mar 2023 09:39:25 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Looi Hong Aun" <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net 1/2] net: stmmac: fix PHY handle parsing
Message-ID: <ZBAyvXhvXPsQ8WrT@nimitz>
References: <20230313080135.2952774-1-michael.wei.hong.sit@intel.com>
 <20230313080135.2952774-2-michael.wei.hong.sit@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313080135.2952774-2-michael.wei.hong.sit@intel.com>
X-ClientProxiedBy: LO2P123CA0043.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::31)
 To PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|MW5PR11MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b58584e-4fed-4bd9-ebef-08db2467aabb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6kYT3FFj2TTzB6kuqDI0bMFW4PWFtBHpnGNpoHJ/0dogd45xcmTFOXDuRwAmeLP2eifOE8aUywe4WSgad9xc+NXjv3DYfma/skwLD5Y4taE7ifsXsqqQi2KA6lJhTBj5RmeQ705W2fJ67HjgU/chTHpX+7zuE6p2SFTA9mP+M8hX9HqytAeD1gOeSOwqcjh3ZSokuW52uQopiqhw6oSBvnYrX+rlRZtWtVPp++EmTMLgAKMo5zf0+fdTLhj3uNTjacYYLhF6UJ02+mKp4T+7PepqbyYnpJSfNGbvAiTWMM31G18NR9Zrkrt/TNUJVGFcLJ78N0sgN3SiQm9vVVDiYgYyECTz4CrHtWFnSxeNdcRrTweu2lkd+b6YsNNp8Wdzt8GyvTNCo1m+esepSDxR6wh2xA08ATZDg9NQdOLV4jtL/tEy7XGwvYmK2Uxas9Kq08TSg79kKcRRxdfsQzw1ufGAZRmcG+oSXMB/pElGSMB4/xhKAwCxJbUz6UtPso3gGVaWGHxcK/hg7Ee4bsdoiGQb6d0sVB2srR0ovZArH3VbOxlpqltJeYyYn1T0ScaTcTYUbPPYS/dDOTD/Hv+GFoG/PIVpyhr5EGzzcY/+jTo0IW04dpzLF5ZWFwi6+tVQIILgKVJGdoDxdIc98e9QQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199018)(6666004)(316002)(54906003)(6636002)(38100700002)(86362001)(82960400001)(83380400001)(186003)(6512007)(6506007)(26005)(9686003)(33716001)(6862004)(5660300002)(7416002)(6486002)(478600001)(41300700001)(107886003)(8936002)(2906002)(44832011)(66946007)(66556008)(66476007)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zis8dv+pE5+Nfv7XxVxa1S3yFdqEcj6Wp21wKan+HLQXZFKcBYoT9yt4//3I?=
 =?us-ascii?Q?4SDGWi4RzbvAtog5SIDGyvGg/6e+A/onYg8Zm6mYqo7nLZzke5T7WxU8dfwe?=
 =?us-ascii?Q?T/XvnATNHxoSVV7eb2/T3E2phCIzqFZVo6RWI13BVPd+/x6bC1C/gjhWIK1H?=
 =?us-ascii?Q?foAK9zmHMOdLRLBaMXd+Uq8IBeh3nbohcINYT1FGCdjf+KH21Br4TcoQ1ThD?=
 =?us-ascii?Q?zB5fP6kwqlZBZTjhLOaVlwkHVUrcE8mgXuvHgYMKiqBDSHJUghiDM46ThxRi?=
 =?us-ascii?Q?4RFzB2c8jugr0IHzOKfR7cE70Rs9ymqZ9T2H4QXtsHBjxNkiOsjhUZNaz7EB?=
 =?us-ascii?Q?vKwmlEFgffqnUnZufclH2AYupuscMoGKu/O1sGkg6xA96kDtFc36DB/KShca?=
 =?us-ascii?Q?3AbNdjE5Z2PMxHmxv9u/VlJ6mA9RSjeMEAmV6zpP7aSGTFjk43sOo1ureNjL?=
 =?us-ascii?Q?msfVdAG22RbYLZsEF1qCpLdG7Vso+QmoCgg69XTPDiGJg5gPuFXWDWlqTdkd?=
 =?us-ascii?Q?V+k+B5NnsgL06Je2X2BDbqaJdJv8fGXnJwXRdrE05KloN1OBwKV/pO4mRQy6?=
 =?us-ascii?Q?gNyHN+UMmq7Gicnasfkarie0AeIn5KWnG9aGO01RyyZl/BaJnvGlytPVAXOc?=
 =?us-ascii?Q?Dke/lPs2BmTW5Nf//YMxY2em+OGVRw4pJIrESfYY1FvHrcphkW2gCQbQt3U6?=
 =?us-ascii?Q?ekKmIjPRsjUga5NHJ0IwfwnVmWaPkBtFU0mNh9qRglrv/5GFgSB1tbNm+zpN?=
 =?us-ascii?Q?U/Y3TDuWzl9B6VeLMcYvKeH7WxkrZdNTNneZKWbPZLQve8SQ/1dncRLSZBWR?=
 =?us-ascii?Q?877Cq2FxwgzxDf7MAjZtwOPYnE07QKoMuGkBvF+m3LCKiQu/3M/i9/fzpHCI?=
 =?us-ascii?Q?EbaHLt49cHmApqyyQqJEgiFUezr60hZ0SyGpCBkFkiUmHOOu6xRJ/s/hw0ud?=
 =?us-ascii?Q?mvRbz3is+rwsl5QJH9hid0tvfeada41Bacl56TDoCfeEFJGK7sgrEV3yaIPj?=
 =?us-ascii?Q?Z6Ot7uA6/3IAKEKqliwQFo5t8HRWCa7mryFA6QGYsOOxjvAAdtTRd38nsdaw?=
 =?us-ascii?Q?MMerZhSuXZrziKp8+j/uUK2nQoMh4RHvN3jr9qdGISTEXxWvkYWINDKHxBZs?=
 =?us-ascii?Q?sbcRa1I4dxERXO1adtYn+jO7ZcZIZMsf1Y2VP5Vg+ncF3gL2IkNCoQrpnLvf?=
 =?us-ascii?Q?blwZI5JbjKFu1EefMZ0k1EfO7Tix1liTDAJB3Liah+U6Q8FFoEMgPVdVttTD?=
 =?us-ascii?Q?P2teQ0cRwXg8W8q75xYtb2Ss5q7yAYyvICvWYvjtVRcpMOJQ2X41uPKpYhel?=
 =?us-ascii?Q?e+joJM2I24kqwuC4BMhDzUNXDSa/hLAIe8DvHKt33HYF7zUChIIyxmmYAX1r?=
 =?us-ascii?Q?RlNwdkWhytrWijLZOEi4fdPprBIJfwnb2mfG11V/l/U0DJrhH4SA9nAFv/ZG?=
 =?us-ascii?Q?Tf8Ix4RPcVqgDCqvZrskjlOqo+WWj1/KoYHIi89PAC4IKo2tkh6rRZz+6Wbf?=
 =?us-ascii?Q?S5C9q7lgppw+4SVwuVKc23G1JHeLlmEIeAMPjY3xbuWiWzY+ffNBql7zv7/Z?=
 =?us-ascii?Q?CvbPIClGiixLhJRa16dDM5fHGTpvyIEl8V/53RIcXNUOz3L5xwXfq+CyOEgp?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b58584e-4fed-4bd9-ebef-08db2467aabb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:39:47.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I77bC2I3y5ZqyuenIRURKoXFawb6FGruV4bLu0JV2c2e+PptBRHg+ztiQ/eefxSjKXgEuP6dzss06qhYlIEoKkpS7mN/VowB9WVCEO8zO3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:01:34PM +0800, Michael Sit Wei Hong wrote:
> phylink_fwnode_phy_connect returns 0 when set to MLO_AN_INBAND.
> This causes the PHY handle parsing to skip and the PHY will not be attached
> to the MAC.
> 
> Add additional check for PHY handle parsing when set to MLO_AN_INBAND.
> 
> Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8f543c3ab5c5..398adcd68ee8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1134,6 +1134,7 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
>  static int stmmac_init_phy(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
> +	struct fwnode_handle *fixed_node;
>  	struct fwnode_handle *fwnode;
>  	int ret;
>  
> @@ -1141,13 +1142,16 @@ static int stmmac_init_phy(struct net_device *dev)
>  	if (!fwnode)
>  		fwnode = dev_fwnode(priv->device);
>  
> -	if (fwnode)
> +	if (fwnode) {
> +		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> +		fwnode_handle_put(fixed_node);
>  		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
> +	}
>  

On the occasion, why not rewrite above to:
if (!fwnode)
...
else
...

or:
if(fwnode)
...
else
?

>  	/* Some DT bindings do not set-up the PHY handle. Let's try to
>  	 * manually parse it
>  	 */
> -	if (!fwnode || ret) {
> +	if (!fwnode || ret || !fixed_node) {
>  		int addr = priv->plat->phy_addr;
>  		struct phy_device *phydev;
>  
> -- 
> 2.34.1
> 
