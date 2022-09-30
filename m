Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085725F0BF8
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiI3Msu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiI3Msr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:48:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55E1157B9E;
        Fri, 30 Sep 2022 05:48:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKc5LwqqUY5N1AC+KCzFLfKnWQLaMlysNy4NG301tBbUyxuyQUU52m7vh0PrREse8LFijxPsproaM4oQ5PBwcIyVHkQdrEHil0vJiZar0dazIhBo0w+q3TVlONNd6KSDIEHPdwkufqOMd14SRI3Cyt/+yaAy0ohNLW4EM3kdbx/MjVzG6wH2+jHMl72i3uHLNrYXFQi4eOxYnrdOA2s+CrlsaW46M+gaI/NdXMdvu/NjBvk3cFFtGf1GLg9XqFRsKirPjiefETBOPDVSyoGjs0bgmWwp+SjKAD6Xl9B2l6mpPFgcWfkKHtL7hPo9kOc4ITtMdkfKbtYta7gkvP990g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=590lMgwylW2+bYzvd24Dh7f0i25MbXvNF0d1hW13j4g=;
 b=hfzVyHSH/EJ0RK3wzXBKoskp6pk6kubxVE4jBKDssH+6aNIb9DpKqVoRzJGsY1IFjonTuSqigu55uasB0BEfM3yCrWbQ4zAcL7c17gMYF7TcVYZDA0GM8oM2Y9AMtz+MJcEGFsHbwF9N7pTjhHlGS06RWmUGJ3z++kIKZzjEarNxxQYCr6V2VIoyj+RhdAesxgI2aUX4HQfsoMoTv6tch9SBOJu+5f6+Qd/ElL6rwxYoYCV/ju3JQ5nlTyNUY/RmPEJua/DPMHV2bJoLdUWYbiLWVolNm9Elh7IHYZXc1WATLIdqpaBG9GYONBCFmP9RdfqNvntCqumhYVVlY3EJnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=590lMgwylW2+bYzvd24Dh7f0i25MbXvNF0d1hW13j4g=;
 b=g0P5Vls7+zueZnQqR3tGhYadSh5Sl1Jxi22JDabLah+IDTlfNR7XD+aQoAwUbTWBcOwcYoTS3iSV4pky3WPBowW/tpZSamdk7qey7mN3cvQZCG5wfkbOcXRxXDK6TAkfyg0VG8FWcftZAdy0GXMg8/iPs0QHnv1Nb2NkEeVcGb0G+NxbDphX/pMItd6mHg3PLkYVMScNGNKCaPHXkgf6PYkB00m+zNDFOaaRKXwf1qKiHHJuLxeLDL8Wv3gr5Ouz6b43w3BtLNnWfCA5A/9MVg82AQ510Cw8lGBItQybQHR2FhwKpRI/hh3v2zLILBSZkVe52QXWEN1o/SJWnUI/uA==
Received: from BN8PR12CA0035.namprd12.prod.outlook.com (2603:10b6:408:60::48)
 by MN2PR12MB4376.namprd12.prod.outlook.com (2603:10b6:208:26c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 12:48:43 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::41) by BN8PR12CA0035.outlook.office365.com
 (2603:10b6:408:60::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 12:48:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 12:48:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 30 Sep
 2022 05:48:19 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 30 Sep
 2022 05:48:14 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Fri, 30 Sep 2022 14:20:50 +0200
In-Reply-To: <20220929185207.2183473-2-daniel.machon@microchip.com>
Message-ID: <87leq1uiyc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|MN2PR12MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f43792-af71-4430-edbb-08daa2e21b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qEUvSPmTzgJKMTAeCX2llqOKVoGQQckrIxsyNjqJWEFut737JlDSaZbvAVorQnVTp+MZvR3RniKyODzMr+qcoUuBc74zqaT1BlFk+vdRllneqPJ56G9pzC7qsTwi0IAhAajaNPOuSGGJRepuuDN2pgfYOGAjET2/Z2nT6nL1ValGZQVynxdhEbkOpy3wiAQA0q6WGjpTcZ3QQ07MjWsQcsak8uX0SpSjK0XNPy8u1vEiFDj49/lbgIKxdwZF418bpImMS0mT9+oOCM7v4uskmxLqnMREoEQfAtT+zT0Oz9nPzxjaTLzEl41ige3exdaTSUaioa0NvPzyCRMc+Y+sEl/AEHwCO/Qgf8WRCWH3V8PdOqkLJ9rWaQW0T5i8YEoqn9GLqvpGNScWIgwEq3iVoPIWNgmejSUG6qZhPjqq8l9M7hkPHcxqJdlSw8uUGvsEtadwJPkFzJsVWPPeLIXAwENLoPtzIjbbJQkesECrB15B9D6EsJ+gUSw0AsIqJj5qyAmEw5dr+err0dbl5zECcgKh8YWY1iAt6yTr4F7Z+qS1LatR7vhaDW/ydY7YiWkRvBfUs0NUmceH1eEMyIc5Gt8AxQUX9Pphi2c6+os32kR6PhoLqi4Aki5cpDEtbD8pEMi1aY0limBmI0yNqWKA3OvRm4/8CToFZCFuGc4LNFiiJtu2q0d0c6n3fwJGEPeoMkZa8G7zjpFlQCX5yx5/L2BVlZzelcNc1wpGT8EI+Tawncu17NNF9NtwVb0hKLGZUNHNKpeKapXsNI4RbqtesQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(54906003)(6916009)(36756003)(86362001)(66899015)(36860700001)(356005)(5660300002)(7416002)(336012)(186003)(2616005)(16526019)(83380400001)(7636003)(82740400003)(47076005)(426003)(26005)(6666004)(478600001)(316002)(70586007)(70206006)(8676002)(4326008)(8936002)(82310400005)(2906002)(41300700001)(40460700003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 12:48:42.6684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f43792-af71-4430-edbb-08daa2e21b2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4376
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

> Add new PCP selector for the 8021Qaz APP managed object.
>
> As the PCP selector is not part of the 8021Qaz standard, a new non-std
> extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
> helper functions to translate between selector and app attribute type
> has been added.
>
> The purpose of adding the PCP selector, is to be able to offload
> PCP-based queue classification to the 8021Q Priority Code Point table,
> see 6.9.3 of IEEE Std 802.1Q-2018.

Just a note: the "dcb app" block deals with packet prioritization.
Classification is handled through "dcb ets prio-tc", or offloaded egress
qdiscs or whatever, regardless of how the priority was derived.

> PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.

It would be good to shout out that the new selector value is 255.
Also it would be good to be explicit about how the same struct dcb_app
is used for both standard and non-standard attributes, because there
currently is no overlap between the two namespaces.

> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  include/uapi/linux/dcbnl.h |  6 +++++
>  net/dcb/dcbnl.c            | 49 ++++++++++++++++++++++++++++++++++----
>  2 files changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> index a791a94013a6..9f68dc501cc1 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -218,6 +218,9 @@ struct cee_pfc {
>  #define IEEE_8021QAZ_APP_SEL_ANY	4
>  #define IEEE_8021QAZ_APP_SEL_DSCP       5
>
> +/* Non-std selector values */
> +#define DCB_APP_SEL_PCP		24
> +
>  /* This structure contains the IEEE 802.1Qaz APP managed object. This
>   * object is also used for the CEE std as well.
>   *
> @@ -247,6 +250,8 @@ struct dcb_app {
>  	__u16	protocol;
>  };
>
> +#define IEEE_8021QAZ_APP_SEL_MAX 255

This is only necessary for the trust table code, so I would punt this
into the next patch.

> +
>  /**
>   * struct dcb_peer_app_info - APP feature information sent by the peer
>   *
> @@ -425,6 +430,7 @@ enum ieee_attrs {
>  enum ieee_attrs_app {
>  	DCB_ATTR_IEEE_APP_UNSPEC,
>  	DCB_ATTR_IEEE_APP,
> +	DCB_ATTR_DCB_APP,
>  	__DCB_ATTR_IEEE_APP_MAX
>  };
>  #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index dc4fb699b56c..580d26acfc84 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -179,6 +179,46 @@ static const struct nla_policy dcbnl_featcfg_nest[DCB_FEATCFG_ATTR_MAX + 1] = {
>  static LIST_HEAD(dcb_app_list);
>  static DEFINE_SPINLOCK(dcb_lock);
>
> +static int dcbnl_app_attr_type_get(u8 selector)

The return value can be directly enum ieee_attrs_app;

> +{
> +	enum ieee_attrs_app type;
> +
> +	switch (selector) {
> +	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +	case IEEE_8021QAZ_APP_SEL_STREAM:
> +	case IEEE_8021QAZ_APP_SEL_DGRAM:
> +	case IEEE_8021QAZ_APP_SEL_ANY:
> +	case IEEE_8021QAZ_APP_SEL_DSCP:
> +		type = DCB_ATTR_IEEE_APP;
> +		break;

Just return DCB_ATTR_IEEE_APP? Similarly below.

> +	case DCB_APP_SEL_PCP:
> +		type = DCB_ATTR_DCB_APP;
> +		break;
> +	default:
> +		type = DCB_ATTR_IEEE_APP_UNSPEC;
> +		break;
> +	}
> +
> +	return type;
> +}
> +
> +static int dcbnl_app_attr_type_validate(enum ieee_attrs_app type)
> +{
> +	bool ret;
> +
> +	switch (type) {
> +	case DCB_ATTR_IEEE_APP:
> +	case DCB_ATTR_DCB_APP:
> +		ret = true;
> +		break;
> +	default:
> +		ret = false;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 seq,
>  				    u32 flags, struct nlmsghdr **nlhp)
>  {
> @@ -1116,8 +1156,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_lock_bh(&dcb_lock);
>  	list_for_each_entry(itr, &dcb_app_list, list) {
>  		if (itr->ifindex == netdev->ifindex) {
> -			err = nla_put(skb, DCB_ATTR_IEEE_APP, sizeof(itr->app),
> -					 &itr->app);
> +			enum ieee_attrs_app type =
> +				dcbnl_app_attr_type_get(itr->app.selector);
> +			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
>  			if (err) {
>  				spin_unlock_bh(&dcb_lock);
>  				return -EMSGSIZE;
> @@ -1495,7 +1536,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
>  			struct dcb_app *app_data;
>
> -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
> +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))

Oh no! It wasn't validating the DCB_ATTR_IEEE_APP_TABLE nest against a
policy! Instead it was just skipping whatever is not DCB_ATTR_IEEE_APP.

So userspace was permitted to shove random crap down here, and it would
just quietly be ignored. We can't start reinterpreting some of that crap
as information. We also can't start bouncing it.

This needs to be done differently.

One API "hole" that I see is that payload with size < struct dcb_app
gets bounced.

We can pack the new stuff into a smaller payload. The inner attribute
would not be DCB_ATTR_DCB_APP, but say DCB_ATTR_DCB_PCP, which would
imply the selector. The payload can be struct { u8 prio; u16 proto; }.
This would have been bounced by the old UAPI, so we know no userspace
makes use of that.

We can treat the output similarly.

>  				continue;
>
>  			if (nla_len(attr) < sizeof(struct dcb_app)) {
> @@ -1556,7 +1597,7 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
>  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
>  			struct dcb_app *app_data;
>
> -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
> +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))

Likewise here, unfortunately.

>  				continue;
>  			app_data = nla_data(attr);
>  			if (ops->ieee_delapp)

