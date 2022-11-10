Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABA8624737
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiKJQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiKJQlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:41:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4761841984;
        Thu, 10 Nov 2022 08:41:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCwcFpB6XXdfAsyBYkWJNjxhpJSFERPTiplDRJiTZKXoO88RFUcXBwMqjbWq2VsKtB7bphWZ61zTHhFh0PWeAEIQFhHENp+wMLPlxKP6OwrDCwYjT3nOkGgNyTn/aWewclUotElhb/WhHsNKFB934jWra/SDqNh1xDP1Lsr45CjcojPZegjAVvIEtWRqt2U8KFIG6Crp5tROVT7cltGjht+WpHy2uALqZu//VPY6IkHy+Xqz3FhsvdLalWS5jGyBXxXboVgJ+ZHOMwXrszuQyl9epRY2SNhh/otvm+Ph9516+zmguPfrigED16WI5asrOwld4R9nXe2nmNb30xYG5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZbmjPAe5xtmgRe1F3lZ7tD4z0l8c3uLNP3+msqrFP8=;
 b=cNYV8i5hP7pk1C+N745FqsoN05lu8XpS2rvPrZ1fn7+X63xZlwNICKhJFtRtN/QnwFvQ80B3CVjKJAsn2k0D2BOETbq51X6uZiLpwSl3TFOhqHNJEzXHlw+xFx7WEOd/CFEAOah85+ntBi8x4CLBgD35gugQcqOo8bbFISIRnehTvw5V9so5i9OkotMPRVWMxkYw8mo5foo105HzGJtsXuOBuXtiXSlnV7rG6UJraUVnw0hYTEZ8IYGAstz5pT1cARl1BJBfbOkAYvw4+YfJNuVzwXvgo68pDUa2x/Ua4a/b8VSoDGJBAW+YBlD9OO/7PmUk9XY/Uy3ks3IFMpqKiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZbmjPAe5xtmgRe1F3lZ7tD4z0l8c3uLNP3+msqrFP8=;
 b=Hz14cs3w/qh/Lul5jC8HipD4wQH/Q3cJZ0OIxiqft2N4nU+w6gYPk4GfJSAfr7LuUsFK4F65uqP8ZVihYo9jCz730gy3ufDUe0XQXHibkoI85nJFRS1ug44pgbPPG5rJapRCTTAiiMsY/BuF8OKVX+DZtUcUP3tv4wKBP2ex9zJ/EyAPEbtKBwBhnOiITA6nC6mcRD0Gibk9vTQK03SZ3nBwqst+zGs8LMzaWxRiJ19r9QK7UxKoA0+hC1rhe6aSInmrJSdgAAA4wZ2UkuWW0RZ4C0s6v/pmbcU8DEfVPp5l4LcCqKCD7pccBhCVxYq5ZfkCdkB6cpAJVYzmVP4m0A==
Received: from MW4PR03CA0232.namprd03.prod.outlook.com (2603:10b6:303:b9::27)
 by MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Thu, 10 Nov
 2022 16:41:21 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::5) by MW4PR03CA0232.outlook.office365.com
 (2603:10b6:303:b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13 via Frontend
 Transport; Thu, 10 Nov 2022 16:41:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Thu, 10 Nov 2022 16:41:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 10 Nov
 2022 08:41:09 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 10 Nov
 2022 08:41:06 -0800
References: <20221110094623.3395670-1-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <joe@perches.com>, <vladimir.oltean@nxp.com>, <petrm@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        "kernel test robot" <lkp@intel.com>
Subject: Re: [PATCH net-next] net: dcb: move getapptrust to separate function
Date:   Thu, 10 Nov 2022 17:30:43 +0100
In-Reply-To: <20221110094623.3395670-1-daniel.machon@microchip.com>
Message-ID: <87eduaoj8g.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT014:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 700e0b2f-76a6-4447-1d90-08dac33a6628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTs3p1f3QDlwGor6jEqwE2c0MdYOfPintMzmAtbh0v8dANO1N0DMAprPh58quQhQjhiOBcYdupZkAeIwQlq72s0FCWFG6rTFslss9i4iLRMfJmw+mTM+5GaNwRWaLy3hANgPc/8te8sDAud+A1M6wlaFPybRQSpR/SpLJQoy8EGvhKKNzLMj2ga43f1AYFR9AKGFonwKrgt1QQD2B+EZiJy5Ve5RVJJWFO0FpbIPye8USoLMIZ/ja8BHLb0x3fPEwqYeRSmaY4MzeNgcMjxoYuT4V2+aU542O2KXlEPWerjk1Eg4QEEqQkq9QngGRWl4OTs19PCQYF4v8siFuMaqcd4AZiOm7wzZOmgO7+Et+GLhJLupWMIOMVeTXGcomcwu3bnevDxY/6anTvxdqEwqdjt+vh95KyRpOsJGitFvKuviM21r1Vk1l9hHkjxMOXDU803Q8Zx00fL3+G0C1aQpH3rq7dzpHx3dtFzH/MVZvrcpNfzgf2jHzs6YxD/mxcE8jZw50PoBmiKRMx/hb5+qgvaTfE04m8QwnD0toLF0ulekfAohdCY6JX2N9K25W69PKDJikpygXyHsstD9NGZX4uAtWx1ZjDvJnm2qKeYLPKm/eipTWOS+cXEGnQiJOKviGZZzspFvLf84qXtoeaw4Eeez2wSKPURjseQemJPWTImCPm7cxwqhs5t4hu7U76EI27XOZ4UUa1zKQKZhDY+qyqr0B/u1Ah4FRs5oSX29DdPwhrk6Qq+8xSNsVWoyOj3c0Bmy4UqI15P2vbrIcBz7SA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(70586007)(82310400005)(36756003)(2906002)(54906003)(16526019)(186003)(2616005)(36860700001)(6916009)(40460700003)(26005)(316002)(7636003)(426003)(47076005)(336012)(40480700001)(356005)(82740400003)(86362001)(70206006)(41300700001)(8676002)(7416002)(478600001)(8936002)(6666004)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:41:21.4208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 700e0b2f-76a6-4447-1d90-08dac33a6628
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index cec0632f96db..3f4d88c1ec78 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -1060,11 +1060,52 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
>  	return err;
>  }
>  
> +static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
> +{
> +	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
> +	int nselectors, err;
> +	u8 *selectors;
> +
> +	selectors = kzalloc(IEEE_8021QAZ_APP_SEL_MAX + 1, GFP_KERNEL);
> +	if (!selectors)
> +		return -ENOMEM;
> +
> +	err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> +
> +	if (!err) {
> +		struct nlattr *apptrust;
> +		int i;

(Maybe consider moving these up to the function scope. This scope
business made sense in the generic function, IMHO is not as useful with
a focused function like this one.)

> +
> +		err = -EMSGSIZE;
> +
> +		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
> +		if (!apptrust)
> +			goto nla_put_failure;
> +
> +		for (i = 0; i < nselectors; i++) {
> +			enum ieee_attrs_app type =
> +				dcbnl_app_attr_type_get(selectors[i]);

Doesn't checkpatch warn about this? There should be a blank line after
the variable declaration block. (Even if there wasn't one there in the
original code either.)

> +			err = nla_put_u8(skb, type, selectors[i]);
> +			if (err) {
> +				nla_nest_cancel(skb, apptrust);
> +				goto nla_put_failure;
> +			}
> +		}
> +		nla_nest_end(skb, apptrust);
> +	}
> +
> +	err = 0;
> +
> +nla_put_failure:
> +	kfree(selectors);
> +	return err;
> +}
> +
