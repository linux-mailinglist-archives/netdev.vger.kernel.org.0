Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50CE60DF5B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiJZLRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiJZLRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:17:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E359411F;
        Wed, 26 Oct 2022 04:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXIyjZNoOA0eYPrMU+CoPGHHIODLWVVLffBcuXsZBxT6XXLaTuLaAJCanOjwLJj4gqJt3JaxK9sKrQnsVB7BKvvfw52vH/0VgOaa3LSaLU+QOo53HMe6miwJed3MkT8uQoSGpooTLfD2qL6fAjN5jft1K+JCdNWh2kM3A57PIEdfyUAG7KckDqQfA9uqAXx+5KMdZblUyiW9nhR4sBDZflXUnW2OoIZBo/+JDF4sjF136P2gwMwO40m3XRNpDmfSfGeyMA1BEP4nglGKWcFRJP9f8+l2Fe9/grrFOpn5SYiih4t95DTim0TEBdyL9n4MyzzoCIuE9uaTu4V1Kz+s/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEy1Ug1Mhf2OIz/y5rt6Ff3GNTCr+81AUihY3/++38o=;
 b=QlEF41MFGLCQsk5eXqqEG/Jitfchm7lZ44FtwXxI5Nj/VcjR3CjHl1canGny71NXA/9ZGnJwuKxmNjny9uqQhu9Ix3zHJVxYR/NtvvNpTA7la3lUcwt9UuPgowomi2WE8DHCBqqFzF2vTwFeimy2K2BH/M9pvAm4w9RAUq9TnjhgMwhPjg9sfIfAFyebPeXaBlBdGEiUfMZeZZvpDl8s10lUDqtQMdgFq5E1AfVWAbP+LzyTd/tZ+x0j111CAF7VPr4Ic8vcHADPS8pAiVP21NjOuiWHvzYkxHtchD2D+wLjfO+KfYeTTISqWinjNTEKKtJaIcb+3RREdkxX3XiLOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEy1Ug1Mhf2OIz/y5rt6Ff3GNTCr+81AUihY3/++38o=;
 b=ry8J0mJPeQAcus+7hjutLbXqbZDe5mg+EpDfY7/M/U997wUMNcbBX7zMhGX3zjKgSQBId2jQ3nYTeRLiWTTDD9xfugoSza2+Vu3rJKPmf4aR4MRIbfDsZedoqRZ0VlXOrnUZY8WgMaM9E35yEE0xzVbTipVnIdfxJuJAklLa3u6MBUodIxXAZzUBtjNLkf8fGYQmwW8eSsRj551f1MxZROE9+OxK7rnTp0TNLI4nCOyP4IdAJC3iXHbJWnsCSJtcrY/tiKy4BAPOJ85mC0untpg5UZ/2knh58hR60s9sadodZRfMIBxfBAqHb3uODkp5Td48r/Ru7pH4hVk0lWb8TA==
Received: from CY5PR15CA0140.namprd15.prod.outlook.com (2603:10b6:930:67::10)
 by IA1PR12MB6579.namprd12.prod.outlook.com (2603:10b6:208:3a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Wed, 26 Oct
 2022 11:17:03 +0000
Received: from CY4PEPF0000B8ED.namprd05.prod.outlook.com
 (2603:10b6:930:67:cafe::34) by CY5PR15CA0140.outlook.office365.com
 (2603:10b6:930:67::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23 via Frontend
 Transport; Wed, 26 Oct 2022 11:17:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8ED.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Wed, 26 Oct 2022 11:17:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 26 Oct
 2022 04:16:49 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 26 Oct
 2022 04:16:44 -0700
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [net-next v3 2/6] net: dcb: add new apptrust attribute
Date:   Wed, 26 Oct 2022 13:06:13 +0200
In-Reply-To: <20221024091333.1048061-3-daniel.machon@microchip.com>
Message-ID: <87zgdizvfq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8ED:EE_|IA1PR12MB6579:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d0dd34-92a5-41d0-2b7e-08dab7439c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yb2Bb1KdLGXpqzjYc3TNNAQvBbqLrOIjmvT+JfT4IMyE64ro/KKKsRQF6MUPLHK7Fo40nkHfmOK2HT/2KcKagnfL7IRC72g+O45+mGPJc9lg8nHcyyoQDDynIl4dtzUunAusV1vlum3s6I+8c+43ZKXyzqcGnNStaWqJhsSBf6qAfpMlLPKWA8GpRrzdFc1oup3Pwsa9hIypd1eAAvRK5aC6faLP/eGD4z63I8RIp8a1U/oC4mc0LUNRg1OPVpQbChr62PjV5DXzSgZ4rWAMvNqBJ3qTRYsH634tdFLRJH2CJqq2/zjHz1gI2wiBqN+tw/b9sDGDWWRWtGjA4uP7qX1Px7jhvUOFzsX8AJ0hFOebjZ+DSe2PY4cC92x4bI9JVeITKWii6GIWvj5zs0y8YGIA3TUPf8UctX12SH4RLl1L7n+EyD/15Ny1YgCmXXXWUfyh6BTbzMOupXtfOu34aGA+79c+khxce5MbBN2JygOn7x6nlikmpXahycQwzkQpl9lXWJkRA9JcJzLG/kAT47iiSW0PyzB99gfsRWybEGWzvr1VkfqMO+s4QVaMv5P0VtUAHY7nZw99h6eT08LAIbZ6Y8l1HVQ8j9H71V1QpieRJYe94xdMJU1vNtL6JlaZTpVKFhnESe4dIH9iXhlxa49x68bTz3iYkSdIzYCp53lgKWZE/0PCcpvx7hluH6O9MC3f8T9nHlu5MU76Fjlaawtottru1/Fj1ebk40Vqcml2YkRRhUwJ4v7whtmzy0CmYnOoGViWe7OU5ygUed1xw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(7636003)(82310400005)(82740400003)(478600001)(356005)(6666004)(316002)(5660300002)(19627235002)(40480700001)(8936002)(83380400001)(36756003)(54906003)(6916009)(41300700001)(4326008)(2906002)(426003)(186003)(70206006)(336012)(8676002)(47076005)(36860700001)(70586007)(86362001)(16526019)(2616005)(26005)(7416002)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 11:17:03.2735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d0dd34-92a5-41d0-2b7e-08dab7439c00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6579
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new apptrust extension attributes to the 8021Qaz APP managed object.
>
> Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
> DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
> the nested attribute DCB_ATTR_DCB_APP_TRUST, in order of precedence.
>
> The new attributes are meant to allow drivers, whose hw supports the
> notion of trust, to be able to set whether a particular app selector is
> trusted - and in which order.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  include/net/dcbnl.h        |  4 ++
>  include/uapi/linux/dcbnl.h | 10 +++++
>  net/dcb/dcbnl.c            | 77 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 87 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
> index 2b2d86fb3131..8841ab6c2de7 100644
> --- a/include/net/dcbnl.h
> +++ b/include/net/dcbnl.h
> @@ -109,6 +109,10 @@ struct dcbnl_rtnl_ops {
>  	/* buffer settings */
>  	int (*dcbnl_getbuffer)(struct net_device *, struct dcbnl_buffer *);
>  	int (*dcbnl_setbuffer)(struct net_device *, struct dcbnl_buffer *);
> +
> +	/* apptrust */
> +	int (*dcbnl_setapptrust)(struct net_device *, u8 *, int);
> +	int (*dcbnl_getapptrust)(struct net_device *, u8 *, int *);
>  };
>  
>  #endif /* __NET_DCBNL_H__ */
> diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> index dc7ef96207ca..9344e3ba5768 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -410,6 +410,7 @@ enum dcbnl_attrs {
>   * @DCB_ATTR_IEEE_PEER_ETS: peer ETS configuration - get only
>   * @DCB_ATTR_IEEE_PEER_PFC: peer PFC configuration - get only
>   * @DCB_ATTR_IEEE_PEER_APP: peer APP tlv - get only
> + * @DCB_ATTR_DCB_APP_TRUST_TABLE: selector trust table
>   */
>  enum ieee_attrs {
>  	DCB_ATTR_IEEE_UNSPEC,
> @@ -423,6 +424,7 @@ enum ieee_attrs {
>  	DCB_ATTR_IEEE_QCN,
>  	DCB_ATTR_IEEE_QCN_STATS,
>  	DCB_ATTR_DCB_BUFFER,
> +	DCB_ATTR_DCB_APP_TRUST_TABLE,
>  	__DCB_ATTR_IEEE_MAX
>  };
>  #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
> @@ -435,6 +437,14 @@ enum ieee_attrs_app {
>  };
>  #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
>  
> +enum dcbnl_attrs_apptrust {
> +	DCB_ATTR_DCB_APP_TRUST_UNSPEC,
> +	DCB_ATTR_DCB_APP_TRUST,
> +	__DCB_ATTR_DCB_APP_TRUST_MAX
> +};
> +
> +#define DCB_ATTR_DCB_APP_TRUST_MAX (__DCB_ATTR_DCB_APP_TRUST_MAX - 1)
> +
>  /**
>   * enum cee_attrs - CEE DCBX get attributes.
>   *
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index 92c32bc11374..01310edf6d1b 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -166,6 +166,7 @@ static const struct nla_policy dcbnl_ieee_policy[DCB_ATTR_IEEE_MAX + 1] = {
>  	[DCB_ATTR_IEEE_QCN]         = {.len = sizeof(struct ieee_qcn)},
>  	[DCB_ATTR_IEEE_QCN_STATS]   = {.len = sizeof(struct ieee_qcn_stats)},
>  	[DCB_ATTR_DCB_BUFFER]       = {.len = sizeof(struct dcbnl_buffer)},
> +	[DCB_ATTR_DCB_APP_TRUST_TABLE] = {.type = NLA_NESTED},
>  };
>  
>  /* DCB number of traffic classes nested attributes. */
> @@ -1057,11 +1058,11 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
>  /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
>  static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  {
> -	struct nlattr *ieee, *app;
> -	struct dcb_app_type *itr;
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
> +	struct nlattr *ieee, *app, *apptrust;
> +	struct dcb_app_type *itr;
> +	int err, i;
>  	int dcbx;
> -	int err;
>  
>  	if (nla_put_string(skb, DCB_ATTR_IFNAME, netdev->name))
>  		return -EMSGSIZE;
> @@ -1161,6 +1162,24 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_unlock_bh(&dcb_lock);
>  	nla_nest_end(skb, app);
>  
> +	if (ops->dcbnl_getapptrust) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
> +		int nselectors;
> +
> +		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
> +		if (!app)
> +			return -EMSGSIZE;
> +
> +		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> +		if (err)
> +			return -EMSGSIZE;

This should return the error coming from the driver instead of
-EMSGSIZE.

Also, it should cancel the nest before returning.

> +
> +		for (i = 0; i < nselectors; i++)
> +			nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST, selectors[i]);
> +
> +		nla_nest_end(skb, apptrust);
> +	}
> +
>  	/* get peer info if available */
>  	if (ops->ieee_peer_getets) {
>  		struct ieee_ets ets;
> @@ -1454,8 +1473,8 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  {
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
>  	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
> +	int err, i;
>  	int prio;
> -	int err;

I don't really mind, but I have to wonder why this new variable is not
with the rest of them in the trust table scope.

>  
>  	if (!ops)
>  		return -EOPNOTSUPP;
> @@ -1541,6 +1560,56 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  		}
>  	}
>  
> +	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
> +		struct nlattr *attr;
> +		int nselectors = 0;
> +		u8 selector;
> +		int rem;
> +
> +		if (!ops->dcbnl_setapptrust) {
> +			err = -EOPNOTSUPP;
> +			goto err;
> +		}
> +
> +		nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE],
> +				    rem) {
> +			if (nla_type(attr) != DCB_ATTR_DCB_APP_TRUST ||
> +			    nla_len(attr) != 1 ||
> +			    nselectors >= sizeof(selectors)) {
> +				err = -EINVAL;
> +				goto err;
> +			}
> +
> +			selector = nla_get_u8(attr);
> +			switch (selector) {
> +			case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +			case IEEE_8021QAZ_APP_SEL_STREAM:
> +			case IEEE_8021QAZ_APP_SEL_DGRAM:
> +			case IEEE_8021QAZ_APP_SEL_ANY:
> +			case IEEE_8021QAZ_APP_SEL_DSCP:
> +			case DCB_APP_SEL_PCP:
> +				break;
> +			default:
> +				err = -EINVAL;
> +				goto err;
> +			}
> +			/* Duplicate selector ? */
> +			for (i = 0; i < nselectors; i++) {
> +				if (selectors[i] == selector) {
> +					err = -EINVAL;
> +					goto err;
> +				}
> +			}
> +
> +			selectors[nselectors++] = selector;
> +		}
> +
> +		err = ops->dcbnl_setapptrust(netdev, selectors, nselectors);
> +		if (err)
> +			goto err;
> +	}
> +
>  err:
>  	err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
>  	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);

