Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88C5BC3BE
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 09:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiISHyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 03:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISHyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 03:54:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A54C1EAE6
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 00:54:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtmZ52qbNGN6g/ArPpY3gXp+GcFM28ll8/LyXYwJZh5YRap3EmwtNuzZqmdpVBIBDwkASCjCdEIkuVPMtAwPy9WpkskwKJmVfaWssT3FK1os6v3orlwKhiqY7p2Mvv9DsbYs95LQ+EfsdSyVFQKvIJn51O4sBDLF4dBg9styBT/DWMHqU7PH172m0jokammcW1zYPcnLp2lECHxvWL6XquiLEf+bhqEGNqNw2BrzhFTnX+UnhB0EGb1MIOxivYWzWmFYl5n9pbldcYj/lDaKN/izivt40Kqk9ViarR2FOCWaog2vBVy4A8e6vnOLnc4ln4oacAA8CQRoJ6bVFhRf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuBU8FxfZbQ3TapjjMzoX0oSg/v9XibArS870VO45ss=;
 b=heheiw7FzysBb06GMdSKWJO4Wkpu9QfvCFje0sCq0vn8iyss/T462bdwlLsCCYOC1kZpRieUmvI6YBwKTzY/rRc2bVHoDoRs+QLyOR8efyfi3OZMTY8xxTbI18LOqxwuI/etb9Q3uzqnDx2MCnzCeg73yecXK9JQxAcwq7CX7SAcIHsyZSBQfNwS0qdW4Urualxk+FOdpX95ciNw1GZ7Ezd14O9Rye7Kl1FFyGFSdhWCqbJsyGwulN2EqKoTJguDngIBxkBO9a/7zU4GojsJOeyG0gIVkTwdiK/aQ5E9FRQa/pow6ueY7Qd3ZY0q1NLP5jFXVH0VkpPQhClR8mWDwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bootlin.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuBU8FxfZbQ3TapjjMzoX0oSg/v9XibArS870VO45ss=;
 b=IBAkFhCVQFV9oDVHwuDGzsKKO188GOupq/6aeYi+GOOOQ/lg3lZ+592W3cxj71SrUIof6mu3unawegve7x/M4vYwvBSgu88VFOGw5htHe7h9bDKEUL+0la8JzwfHW1tKLHG+rcpB2AN1f7WCsPX6pHvhr1C0eN1LMcanFZGORQeBI63gK2AyN+ACjyHPCU5BDbYldny5j2i8AlBrRGye/IrvqzrBKf3oCqJ/5Ow3fFECdkPRxd9wu66d8sHLlcdI7PYNd3CArA91JjBBdTJ7MAeZhvdBIzCtH/P1z1NyNCzX1lqS4SH+VNwy44cqj894id2KLM6BTJV9LU/K/+9wSA==
Received: from DM5PR07CA0112.namprd07.prod.outlook.com (2603:10b6:4:ae::41) by
 PH0PR12MB5436.namprd12.prod.outlook.com (2603:10b6:510:eb::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Mon, 19 Sep 2022 07:54:19 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::da) by DM5PR07CA0112.outlook.office365.com
 (2603:10b6:4:ae::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 07:54:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 07:54:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 19 Sep
 2022 00:54:06 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 19 Sep
 2022 00:54:03 -0700
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <20220915095757.2861822-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 2/2] net: dcb: add new apptrust attribute
Date:   Mon, 19 Sep 2022 09:30:21 +0200
In-Reply-To: <20220915095757.2861822-3-daniel.machon@microchip.com>
Message-ID: <87mtavyf3b.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|PH0PR12MB5436:EE_
X-MS-Office365-Filtering-Correlation-Id: ae429876-60da-445b-cf99-08da9a142841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GnDFe8mobE0FJiHh65iv+PcOcYTvSVMqeKTYUKaWOXKdovfJ3dqBLdpup5QQ44TUXJwhxK7h3T6C82kDdqoHNLk28Ud1FsfmCtPQRWtw0vqbsJcgtEc0hew+fz276Yh0JKeOOIe0i/uSW1SHiB/oKY9cjVDpomyBE4Kd0BhwTNwMZ5x4JuCSrb8MntR9amm9T+S9fPaHOOpeT2SnwaCofl2m0ltqUI2BfLbzHziOHEh6z1Kdlzt5dA524zbcyKWN2YGAq6wwoyAcW3qgFjtmHTGBBAbGBYw0TBBxMpLaJRsGZGAglixfc3xFc86Datu/f151Vd0yjfJAltMtY25rL18zuQePgKptR0ctU3ZSOCFrmcMds8HwdogotXbnSr7+7kumkFUxrnKcS7BETQYeNwCqpLde80hYj0pWhF57iVddxPOuldZNijd+nu1zXRlphB9lL4sOEy5pFsCM0ipe5JoPSs2f6+VmOtx8Bwd57YW0wBI0vF/Sqzs8oHWO0FdHCw5a/88TIAGTMnRFrLqJ7H5o31LUTldu2vTLno1SvdhogCe7QgdtHH72E0yLt221zMzB0mY6JFLS3iy6jdLfz0feaCNwmfTPZkPoaKrd9To8HNdymYBL/ODwlHB0UBQWcbOwTo3lLBknR3e6SVaRmz0cRvzZwr2hb8BtP6vyqnCC5yFn6LxS0/84kPEvdBmLGdpvtUKUs0vmFYJqrIPxtWzNtQ8+UMMUemrj9WQv9Tv6o8rnvnHvtbLiL9vE3dWe8+qK5IBHM+w8YhzFH6hiCw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(40480700001)(2906002)(36756003)(19627235002)(316002)(36860700001)(82740400003)(426003)(47076005)(4326008)(8676002)(5660300002)(70206006)(70586007)(8936002)(86362001)(6916009)(54906003)(336012)(16526019)(186003)(478600001)(7636003)(2616005)(26005)(356005)(83380400001)(40460700003)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 07:54:19.0052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae429876-60da-445b-cf99-08da9a142841
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5436
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

> Add new apptrust extension attributes to the 8021Qaz APP managed
> object.
>
> Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
> DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
> the nested attribute (TRUST_TABLE), in order of precedence.
>
> The new attributes are meant to allow drivers, whose hw supports the
> notion of trust, to be able to set whether a particular app selector is
> to be trusted - and also the order of precedence of selectors.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  include/net/dcbnl.h        |  4 +++
>  include/uapi/linux/dcbnl.h |  4 +++
>  net/dcb/dcbnl.c            | 64 ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 69 insertions(+), 3 deletions(-)
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
> index 8eab16e5bc13..ede72aefd88f 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -248,6 +248,8 @@ struct dcb_app {
>  	__u16	protocol;
>  };
>  
> +#define IEEE_8021QAZ_APP_SEL_MAX 255
> +
>  /**
>   * struct dcb_peer_app_info - APP feature information sent by the peer
>   *
> @@ -419,6 +421,8 @@ enum ieee_attrs {
>  	DCB_ATTR_IEEE_QCN,
>  	DCB_ATTR_IEEE_QCN_STATS,
>  	DCB_ATTR_DCB_BUFFER,
> +	DCB_ATTR_DCB_APP_TRUST_TABLE,
> +	DCB_ATTR_DCB_APP_TRUST,
>  	__DCB_ATTR_IEEE_MAX
>  };

I find it odd that APP_TRUST is at the same level as APP_TRUST_TABLE. I
think it would be better to have a separate enum ala what APP_TABLE has
with enum ieee_attr_app.

>  #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index dc4fb699b56c..6f5d2b295d09 100644
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
> @@ -1030,11 +1031,11 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
>  /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
>  static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  {
> -	struct nlattr *ieee, *app;
> +	struct nlattr *ieee, *app, *apptrust;
>  	struct dcb_app_type *itr;
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
>  	int dcbx;
> -	int err;
> +	int err, i;

Move "err, i" up before dcbx so that it observes the reverse xmass tree
principle, please.

>  
>  	if (nla_put_string(skb, DCB_ATTR_IFNAME, netdev->name))
>  		return -EMSGSIZE;
> @@ -1133,6 +1134,24 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_unlock_bh(&dcb_lock);
>  	nla_nest_end(skb, app);
>  
> +	if (ops->dcbnl_getapptrust) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
> +		int nselectors;
> +
> +		apptrust = nla_nest_start_noflag(skb,
> +						 DCB_ATTR_DCB_APP_TRUST_TABLE);
> +		if (!app)
> +			return -EMSGSIZE;

I agree with Vladimir that this should not be _noflag.

> +
> +		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> +		if (err)
> +			return -EMSGSIZE;
> +
> +		for (i = 0; i < nselectors; i++)
> +			nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST, selectors[i]);
> +		nla_nest_end(skb, apptrust);
> +	}
> +
>  	/* get peer info if available */
>  	if (ops->ieee_peer_getets) {
>  		struct ieee_ets ets;
> @@ -1427,7 +1446,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
>  	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
>  	int prio;
> -	int err;
> +	int err, i;

RXT this as well, please.

>  
>  	if (!ops)
>  		return -EOPNOTSUPP;
> @@ -1513,6 +1532,45 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  		}
>  	}
>  
> +	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
> +		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
> +		struct nlattr *attr;
> +		int nselectors = 0;
> +		u8 selector;
> +
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

I'm assuming you tested this code, I just wrote it into the email
client, so all guarantees are off :)

> +
> +			selector = nla_get_u8(attr);
> +			/* Duplicate selector ? */
> +			for (i = 0; i < nselectors; i++) {
> +				if (selectors[i] == selector) {
> +					err = -EINVAL;
> +					goto err;
> +				}
> +			}

This should validate the selector values as well IMHO. Maybe something
like this?

			switch (selector) {
			...
			case IEEE_8021QAZ_APP_SEL_DGRAM:
			case IEEE_8021QAZ_APP_SEL_ANY:
			case IEEE_8021QAZ_APP_SEL_DSCP:
			case IEEE_8021QAZ_APP_SEL_PCP:
				break;
			default:
				err = -EINVAL;
				goto err;
			}

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

