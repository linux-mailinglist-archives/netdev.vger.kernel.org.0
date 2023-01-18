Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F782671AE7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjARLnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjARLm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:42:27 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437BFAA5E6;
        Wed, 18 Jan 2023 03:00:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3G8u5mGJ5wHB+muhiwseBgvEAOfNE+F86Etcs6crdlgx27FAF7Z27tAU0lKftotVhlTtEGhX1S/OLJAQ+xvH0zzcMWgA07EkYw2OwG7KR766nsaZ4b9ZaKspm8pY55TBlxhAmL2zbWzj+JAJzyUlDVjkQqke7m1ZR4YYVfiovymkuCCc1TR7dCpS9QEU6rWaqFdsZfSYGo6hvT2M+LUi3fvNJoP32VnQnifkVRa/fLzy0bdxyxzop9MCameTVB6IgHFBYnlFI4Jakt88ID8XiGPqPyWJ5r87wRTkxQ4wkZFHoc2MmffpGXGr54r6Lqa19eAfQ7OaR4EyfihtO9Emg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jZUb5VOHceB/ECOCY4cbxqfUuu91ZpC06M2g4cOQAM=;
 b=QC27vFOlGhS7Uw+TuNFvQxePgKsnUh97VwHY0GNFyBhWc/e137uvNZvzgRi+f8RnVufjmdl5ynSAJPtU5mCW5c0a+irUJ0oGvQp0s3W1wzFz5zwcMVx63A/C1E0SeFY9Ob0D7hJXGhI0qRgXW2/vVfvDNcNo0LhbucxC45PK+JOevB0ZpvmFWr0M9jbJySFXfQx+3aBYoO4zYE+v+y4hVq+aoAfx2KdiltVGLaT0Ez7keLzkBWpnxdUUPyWZb0rwcxJkxgdjxGoiK2DH6hxdern7NFXIINHNEEJfOmqY5o+CK+SzgOrmIo2G4mfSTGkrCJ2p1CHVvNI9HwpclxrH1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jZUb5VOHceB/ECOCY4cbxqfUuu91ZpC06M2g4cOQAM=;
 b=TAdkQRhRAwhY4pmc8LFKk/AFSIiVacRDkid+bHx1490VUvZt3pDxjnVI3/ZIvGp2Ydy1dCGggkDaX2F//9gXAuJhaavLhZH54bjZYrYhKSIAnQS3kKaL5Uuxuo8s3AghDCul4yfNZLVI+jNIPPVMFWcpjnTFO0l75raQ8Bb1i1AIv0iVHS3cBLu85Yd0EpKFBnatSSUjKxzEcXzsH6STB0tfZQbEBNsKVGwfV57eU+y2WLZU5tPMEde1GZJkGxhW9Dc+Amg0cx2wSwpJ2ueFKyByjoNpd/LeT+ml8kNRrFHPFO09suGolk1cfT+D2puFrWPcnsa/tJcBXSwx/E63SA==
Received: from BN9PR03CA0089.namprd03.prod.outlook.com (2603:10b6:408:fc::34)
 by CH2PR12MB4279.namprd12.prod.outlook.com (2603:10b6:610:af::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 11:00:00 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::a6) by BN9PR03CA0089.outlook.office365.com
 (2603:10b6:408:fc::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 11:00:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Wed, 18 Jan 2023 11:00:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 02:59:51 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 02:59:45 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Date:   Wed, 18 Jan 2023 11:54:23 +0100
In-Reply-To: <20230116144853.2446315-4-daniel.machon@microchip.com>
Message-ID: <87lem0w1k3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT046:EE_|CH2PR12MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e16b71-a003-4342-1ce7-08daf943250a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUxlGZ4NHnvetNitrLctKx/RBArJA/Y+iJvj69hLlIbJURVbLXielFS+9N4p/6FpbQeJSZMvUaehVlhdcMMbESpyJYIEimNiLNhnSVeF5azJU+kLgyItab+9qyLn9an/QkobnYWguVBHhxQwON78k6v4Lny3SnldaYT7W3AoeqfAbeFr4cYq3JfPV7eA3bYLgAlJxj2TOQ85GVYdKM0znbCKw4/iJsqnSeUDEpIK62vNrZOzz59H7lNkNdgk73omKvRLAbYlERu8qAjydi4kJYkEXWyrhVthpVYwgYAMAiDON9asCRJLi++wg7N2dmy8UzJX+CqJCbVNy9oPsM3RsxmazVPpzWoQdftDQl9Qbtyyj7DcBQuoY5Mki2uT7iNCEsrZaNg1BUDZepNHBtdz6D4FG/zbh5M3N/OwAJDgZCCHndScev8LmBhktoakTxb7ZGvE4Pud6ocLyvZY+dZ0tQBvuTqjdKvx4n7EauDgOeE4zpHLhs9C9DgRTp8i+MyNwt/1V2deofLOokcAsBE9N8E4Kmn4VDFVdd/PqBJ71HE3uihOKZCfLUE4LTih4yIigwLj1ddaW+5tJyIj0wbiaWfxLfQ3NmUlqiF45dWNKujsLACC8OIfQ/pIsA77HGb7lbMm9UjHan6urzmQtlsr1pduqg68oVIeAO2l4aC7nrGV7WNpgXDjz6s41YT6FvREwu6ErIRkhguXL/4ByVH1Nw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(7636003)(82740400003)(36860700001)(356005)(86362001)(8936002)(5660300002)(7416002)(2906002)(70586007)(70206006)(40480700001)(4326008)(8676002)(6916009)(41300700001)(82310400005)(40460700003)(2616005)(26005)(16526019)(186003)(83380400001)(336012)(47076005)(426003)(316002)(6666004)(54906003)(36756003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:00:00.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e16b71-a003-4342-1ce7-08daf943250a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4279
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index cb5319c6afe6..54af3ee03491 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -178,6 +178,7 @@ static const struct nla_policy dcbnl_featcfg_nest[DCB_FEATCFG_ATTR_MAX + 1] = {
>  };
>  
>  static LIST_HEAD(dcb_app_list);
> +static LIST_HEAD(dcb_rewr_list);
>  static DEFINE_SPINLOCK(dcb_lock);
>  
>  static enum ieee_attrs_app dcbnl_app_attr_type_get(u8 selector)
> @@ -1138,7 +1139,7 @@ static int dcbnl_app_table_setdel(struct nlattr *attr,
>  static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  {
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
> -	struct nlattr *ieee, *app;
> +	struct nlattr *ieee, *app, *rewr;
>  	struct dcb_app_type *itr;
>  	int dcbx;
>  	int err;
> @@ -1241,6 +1242,26 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_unlock_bh(&dcb_lock);
>  	nla_nest_end(skb, app);
>  
> +	rewr = nla_nest_start_noflag(skb, DCB_ATTR_DCB_REWR_TABLE);
> +	if (!rewr)
> +		return -EMSGSIZE;

This being new code, don't use _noflag please.

> +
> +	spin_lock_bh(&dcb_lock);
> +	list_for_each_entry(itr, &dcb_rewr_list, list) {
> +		if (itr->ifindex == netdev->ifindex) {
> +			enum ieee_attrs_app type =
> +				dcbnl_app_attr_type_get(itr->app.selector);
> +			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
> +			if (err) {
> +				spin_unlock_bh(&dcb_lock);

This should cancel the nest started above.

I wonder if it would be cleaner in a separate function, so that there
can be a dedicated clean-up block to goto.

> +				return -EMSGSIZE;
> +			}
> +		}
> +	}
> +
> +	spin_unlock_bh(&dcb_lock);
> +	nla_nest_end(skb, rewr);
> +
>  	if (ops->dcbnl_getapptrust) {
>  		err = dcbnl_getapptrust(netdev, skb);
>  		if (err)
