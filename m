Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5B5F0C32
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiI3NLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiI3NLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:11:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0261739F5;
        Fri, 30 Sep 2022 06:11:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMPCbAgVwIegfyHluWlFIGgBFVk/JJPAPE4IyzOtsOonHy/z2xNPRnwbNw52iww8qb18GTHyj0WQAoIHLrzPmjxEwshBqe7R4NPiRN7Ji64MBIebJLLjJv1WXvHlVRmo/Dh5tr3UT66xOfxCF90TVI22azQr6BO4ePOtmDud2jpT1lcksqZuNMhWW20xvq15D9zYs14k9JgnfstwFNbr54ILKgrdzFNHNHtT/XL4WHbZyC0A0RYoTSXzyENEMbI3Y44fx4Lw2TZa2lP149Wo7U3vXq2Stz+xpTEPMq/iY37/1IcAmN2z3vIhF7bR7IT3aodtMx/HbBjo0MbGbjsUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0v0U2ZSBWhtSkGwbKaDQgDy6Z+xO6AKpJ7v0n3/U6g=;
 b=N0WZn10mF1E5eWuznyq5XuMvKzwjunf6HouVP97wcH8LFs8edfaJs3Vioj1XBENuBl4MXvceuM8nc4/fMbt+k2lq67L/a7bT/Le/sUzTC8Lfvuf7wTbtEXDFFiblMJf1+Hg8O6xZFRPR0B2zOkUmYT5Hgx8/oixTOgcCsFIYOs0h92p9cCw07H7WwOrQ/gvZVfhafU66f4v8Z022YFK1Jg3jKZVs62T22WKgTzVQeqBypBGuxS++nnpTF4nq93++wrZwatdX1Uuz6ygzJxsl7lH5NL6xjBf1PZlaA645cM6J2qiHyzbMs31iAGRH7hDyNV9BLzCZZsbaUxFFQOHuww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0v0U2ZSBWhtSkGwbKaDQgDy6Z+xO6AKpJ7v0n3/U6g=;
 b=YJ36mC5c0NSPwfnH1b5b7+RoxtbzwOGC7AO+RPxqtvO36vxABJggYAvvtKYtec/BVDuVVOXR9BFEVFud1GFdltrF6plteAhEg4XgWk+I397/FiELZNeCX1dpQxxvhnWhjYJw2j7Q232U6JSaKu3SsP5OUxxvLE7KaYQGIhfJt14a7iDZeqb4L61wlW9ayOY2mQStBGnaqAryaPkTq5usYf4HPfE4MTq8irYdAPOeUBjxaktWf5p8Zwr/+P+W6XcnKf0a08v/R1uB0m+ER2xwU4KBhQFMyFE521O9QdD65QUlwJkBMWWNd9Wb8acgPjO+sdXcs4eeqGeg71c90ExKbQ==
Received: from MW3PR06CA0004.namprd06.prod.outlook.com (2603:10b6:303:2a::9)
 by DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Fri, 30 Sep
 2022 13:11:35 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::52) by MW3PR06CA0004.outlook.office365.com
 (2603:10b6:303:2a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 13:11:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 13:11:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 30 Sep
 2022 06:11:26 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 30 Sep
 2022 06:11:22 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-3-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v2 2/6] net: dcb: add new apptrust attribute
Date:   Fri, 30 Sep 2022 15:03:06 +0200
In-Reply-To: <20220929185207.2183473-3-daniel.machon@microchip.com>
Message-ID: <87h70puhvs.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT032:EE_|DS0PR12MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c6490b4-607a-4beb-669c-08daa2e54cc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUMtLLirumYuiM+ZM056b0JjWaakX6FnBwt3/B9OXujBmGAP7EdbThHmGfAagm8oCbwiBw2lUFdHGEIbMY/Hn9RtiXvjTbMnRMW900ZbU/bTkO7nALRqZUt4tpR9LCF05e0CTZIdaek0lAgeLgWb7rlYlHKWH3PV9CczoQHO2fkHApSi7MyRciNrGzVWOneg+XObbNh12Qdro5ujcxkJ0hLHEVE/mS5uS37X0COXssZ+l5C/Yxe7bX2JvXJEC+horHcArusNLVDqU0rGDgyF1c6qrEDYwG+mkA231pc9Fx6t+8Sbjikmk9ZOaF+5DVs3vm5dKyTn5OFb8Xx7mF0TUzsiH+5eSWPuYxdzu10ZNPrW2sHA/BeYhDvat622HEMjN134WARcQQy4Qsj6diJjocUrhJ5BPDs5f/+HLdB3Ya0YzSGo7pf5xnG949GJ+2sOMGX/OBghyvxSOxBO70ltLIw5qJB05YqKKISiD4IKrmW8Yz88BICiAWEO0nGWW1KyHRXq3iXdq9+ZeevzZHjF0HrhQAebS/zVbJJru/n93yKGSHIpYnlmJDT8qycH8U9nHvq+Ait10/O2NHOLsIPkvM5aTg+3w5Y3nzQRKT9u9Uqur55Hh8kFdWyq3dvD4b9zaIG4IZ5at9R/w2+n2slaNS6Irx6fkvnN/ddJlAMDAhN7TsuyV0mLIWdiUCeLGRzQPNGN0SgpZwwbPOwrWtdx2qQCEypqTt3hmcBiMzV3VRCjw64xoY3T1ERvzPP8xvFnZXBEGzxHC83/RXmBXoRc3A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(26005)(2616005)(7636003)(2906002)(86362001)(5660300002)(82740400003)(7416002)(83380400001)(82310400005)(356005)(36756003)(478600001)(36860700001)(40460700003)(40480700001)(16526019)(47076005)(336012)(8676002)(186003)(426003)(6666004)(70206006)(41300700001)(54906003)(70586007)(4326008)(6916009)(8936002)(19627235002)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 13:11:34.4040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6490b4-607a-4beb-669c-08daa2e54cc8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
>  include/uapi/linux/dcbnl.h |  9 +++++
>  net/dcb/dcbnl.c            | 77 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 86 insertions(+), 4 deletions(-)
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
> index 9f68dc501cc1..f892cd945695 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -410,6 +410,7 @@ enum dcbnl_attrs {
>   * @DCB_ATTR_IEEE_PEER_ETS: peer ETS configuration - get only
>   * @DCB_ATTR_IEEE_PEER_PFC: peer PFC configuration - get only
>   * @DCB_ATTR_IEEE_PEER_APP: peer APP tlv - get only
> + * @DCB_ATTR_DCB_APP_TRUST_TABLE: selector trust order
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
> @@ -435,6 +437,13 @@ enum ieee_attrs_app {
>  };
>  #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
>
> +enum dcbnl_attrs_apptrust {
> +	DCB_ATTR_DCB_APP_TRUST_UNSPEC,
> +	DCB_ATTR_DCB_APP_TRUST,
> +	__DCB_ATTR_DCB_APP_TRUST_MAX
> +};
> +#define DCB_ATTR_DCB_APP_TRUST_MAX (__DCB_ATTR_DCB_APP_TRUST_MAX - 1)
> +
>  /**
>   * enum cee_attrs - CEE DCBX get attributes.
>   *
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index 580d26acfc84..ad84f70e3eb3 100644
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
> @@ -1070,11 +1071,11 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
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
> @@ -1174,6 +1175,24 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_unlock_bh(&dcb_lock);
>  	nla_nest_end(skb, app);
>
> +	if (ops->dcbnl_getapptrust) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};

BTW, the MAX value is currently 255, which made some sort of sense when
that was the value used for PCP. But we currently only need 24, and
actually like... 6 or whatever? Since the selectors are not supposed to
duplicate, and there are only about that number of them?

Though actually since the new attribute route won't work (as explained
in the other e-mail), it's an open question what the PCP selector value
will be.

> +		int nselectors;
> +
> +		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
> +		if (!app)
> +			return -EMSGSIZE;
> +
> +		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> +		if (err)
> +			return -EMSGSIZE;
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
> @@ -1467,8 +1486,8 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  {
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
>  	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
> +	int err, i;
>  	int prio;
> -	int err;
>
>  	if (!ops)
>  		return -EOPNOTSUPP;
> @@ -1554,6 +1573,56 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
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

