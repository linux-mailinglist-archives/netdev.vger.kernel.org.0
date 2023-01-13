Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE698669C43
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjAMPbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 10:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjAMPaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 10:30:30 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706C265347;
        Fri, 13 Jan 2023 07:23:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2tGMwBNT24v0TsL+k+IVLtI37LDKcaNFbGe4iHu7PyUCTcYFjfKtXiIG9ecDwj5nkm5zcbbxqyF+MqN0MwfWQhHZ0ZU/Ex427cn5bxzh4/KM7eeAs0M6MZ9PM+fCcsaFgfGQi60mkS0f1QaXdsuNAbN/8P7UkACLqSKsYU8ZSu+a9xczhcevM7uSvtsVmqNlItcYiA0g6Md5pb6DmVOTNyrK5k0JUqAGEgOOPGvlmlf9B3vrLS3rLaolYc8QwVUa9ppkSZu8DhAaL+hhDVNB36tWr6H5P9+VazewUX0q4IS7+vQiw8bK9cXnvi5IXdJIaMN42dY+TFNcmH8b4VDOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oMEoHfJkJ68ghT+1H3PjWU4HDMyg9uM5UFPwxwzNvc=;
 b=c4vSMWUnpgfIRTiJF4vSALpKPs8qpVanbCUmAgJ1SlQK+/74xw2bXPzXuQvwyFYGjSwA2JBFfeQeZMc28oHTAHICVTJctvaxwSo2FZD/cBAlDLvmB3ZWif3oJrbWN3KnFZ9Z8MmBybWKhAk4WdLPWCLW19AnAPluzHNEsjUndNSfkQLy40f2WWFkcSOphGFKch+SHZD/aZKa+fPAuD9kYrMo62LgJr0RqPY6HwSDXb958+ok4TKpM8H6z5TYGjObbZl4dyYBUg0hF9O35mShn3A1rZgIOzAb+cBiNkwUMXxZhwg5iBhDgJbS0HrftC7SwXKPYPiE6L3hD5+X5iGKVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1oMEoHfJkJ68ghT+1H3PjWU4HDMyg9uM5UFPwxwzNvc=;
 b=H5CBejpjBiMsDCHSuY2dJbPe4lzsWsb6Qpjar3FKdXKxrxJHfq7oMpNGX0/7YV5le1CCTX657XnPSWklZrP7LMQFmV3evEqYri8Xq/KdbZ2hrNC4DpgYCGvmx1KpxzdtKDxhFscdGP3YeNYNo0r9fKDAsvdsHbLyWq2sb8c/OpuZwJ1Tol3OxSrctmIU3RDaBQXn7dObJJjycAXMOlZ4TZCvi/zNJJF4YYr72oHWtW/QSzGf1XqLyC6l8SXVOb3nXmY1euQOBw3S0XSeEZeQyVgMpY9zEFsx8MJE+1Lqj/VMQq+z9VD/KRMkFs0zx03AO3uPFwOjR4A067K8IUm00Q==
Received: from BN9PR03CA0892.namprd03.prod.outlook.com (2603:10b6:408:13c::27)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 15:23:24 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::cc) by BN9PR03CA0892.outlook.office365.com
 (2603:10b6:408:13c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 15:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 15:23:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 07:23:11 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 07:23:07 -0800
References: <20230112201554.752144-1-daniel.machon@microchip.com>
 <20230112201554.752144-3-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Date:   Fri, 13 Jan 2023 15:52:27 +0100
In-Reply-To: <20230112201554.752144-3-daniel.machon@microchip.com>
Message-ID: <875ydazcfa.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT050:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f69c7b-a081-4b77-691c-08daf57a1d00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KcYupFj2BoF+6i/vqtAOa1mX8U6aneVUnJ1OTT212CFWCuGGGEESUWaD3aUPZyCSR/AXtbaTs81ShnMl71+l1EAmN6qUEANNc+O5Bia5xfALQeHMhDOVNNfZ6N0NjMjbpZuowlq6ePod27by5hgUX+11tq9794OzfYOW8608lVIni2or8Gw2DOxIWfD6yb6zprbue45vd8jPEYLD0jnpweOmdY28KW+CsGJ3FJwPNj6RiH4O+q2HnT9WalZGlbEVPtzEuzP91RwwPo2mrFTS20B+8tMP1HFZEzIdJWxA5VyLA7vbXsTQv3NouXQW6RN25tM/Az6BOyeMloiIhFGRiMcUXWDUdFGi4zJJZfDoVZU+LCG7OrY4hgLIDNVqpZ295xsqAf4X5h53n+7kPl8L88PXLV44i2YaK274WGTDWs6LwhVZG9R16RQj6/VxoUfP6fu7hlcAPB0IfLhheWHR7A/ARca2SPCQ6EO90dBEsNDtb1v+y0IOThWprpPsqNzB/2cp1R0XT/MUU6lHe8gmtNwMQhfdKiVHsPmvUMuPJ0Dj09Dmr7cgjocPhSfb1kFyimhaIwlDVSjedlD/tEVPuVk87pCh6LuqX5UWkiOhl8zsvoxNlbs0k7XZyXJFkQx1LMqnZPC+KhB+O2FZ/ia90h4EuR70gVGp4gHmvI6MLqUagZa1jnXwxTdPeK4/8+XW/bETrLIA4qzWKiKHAnGCnQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(70206006)(82310400005)(66899015)(2906002)(7416002)(5660300002)(36756003)(6666004)(70586007)(2616005)(8676002)(316002)(19627235002)(4326008)(54906003)(41300700001)(478600001)(40480700001)(8936002)(26005)(186003)(336012)(6916009)(16526019)(426003)(86362001)(83380400001)(36860700001)(47076005)(356005)(82740400003)(7636003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 15:23:24.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f69c7b-a081-4b77-691c-08daf57a1d00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378
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

> In preparation for DCB rewrite. Add a new function for setting and
> deleting both app and rewrite entries. Moving this into a separate
> function reduces duplicate code, as both type of entries requires the
> same set of checks. The function will now iterate through a configurable
> nested attribute (app or rewrite attr), validate each attribute and call
> the appropriate set- or delete function.
>
> Note that this function always checks for nla_len(attr_itr) <
> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
> dcbnl_ieee_del prior to this patch. This means, that any userspace tool
> that used to shove in data < sizeof(struct dcb_app) would now receive
> -ERANGE.

Good.

> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  net/dcb/dcbnl.c | 104 +++++++++++++++++++++++-------------------------
>  1 file changed, 49 insertions(+), 55 deletions(-)
>
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index a76bdf6f0198..6d19564e19a8 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -1099,6 +1099,45 @@ static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
>  	return err;
>  }
>  
> +/* Set or delete APP table or rewrite table entries. The APP struct is validated
> + * and the appropriate callback function is called.
> + */
> +static int dcbnl_apprewr_setdel(struct nlattr *attr, struct net_device *netdev,
> +				int (*setdel)(struct net_device *dev,
> +					      struct dcb_app *app),
> +				int (*ops_setdel)(struct net_device *dev,
> +						  struct dcb_app *app))

The name makes it look like it's rewrite-specific. Maybe make it
_app_table_? Given both DCB app and DCB rewrite use app table as the
database... Dunno. Not a big deal.

> +{
> +	struct dcb_app *app_data;
> +	enum ieee_attrs_app type;
> +	struct nlattr *attr_itr;
> +	int rem, err;
> +
> +	nla_for_each_nested(attr_itr, attr, rem) {
> +		type = nla_type(attr_itr);
> +
> +		if (!dcbnl_app_attr_type_validate(type))
> +			continue;
> +
> +		if (nla_len(attr_itr) < sizeof(struct dcb_app))
> +			return -ERANGE;
> +
> +		app_data = nla_data(attr_itr);
> +
> +		if (!dcbnl_app_selector_validate(type, app_data->selector))
> +			return -EINVAL;
> +
> +		if (ops_setdel)
> +			err = ops_setdel(netdev, app_data);
> +		else
> +			err = setdel(netdev, app_data);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
>  static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  {
> @@ -1568,36 +1607,11 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  	}
>  
>  	if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
> -		struct nlattr *attr;
> -		int rem;
> -
> -		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
> -			enum ieee_attrs_app type = nla_type(attr);
> -			struct dcb_app *app_data;
> -
> -			if (!dcbnl_app_attr_type_validate(type))
> -				continue;
> -
> -			if (nla_len(attr) < sizeof(struct dcb_app)) {
> -				err = -ERANGE;
> -				goto err;
> -			}
> -
> -			app_data = nla_data(attr);
> -
> -			if (!dcbnl_app_selector_validate(type,
> -							 app_data->selector)) {
> -				err = -EINVAL;
> -				goto err;
> -			}
> -
> -			if (ops->ieee_setapp)
> -				err = ops->ieee_setapp(netdev, app_data);
> -			else
> -				err = dcb_ieee_setapp(netdev, app_data);
> -			if (err)
> -				goto err;
> -		}
> +		err = dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
> +					   netdev, dcb_ieee_setapp,
> +					   ops->ieee_setapp);

This could pre-resolve the callback to use and pass one pointer:

		err = dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE], netdev,
					   ops->ieee_setapp ?: dcb_ieee_setapp);

And the same below.

> +		if (err)
> +			goto err;
>  	}
>  
>  	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
> @@ -1684,31 +1698,11 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
>  		return err;
>  
>  	if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
> -		struct nlattr *attr;
> -		int rem;
> -
> -		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
> -			enum ieee_attrs_app type = nla_type(attr);
> -			struct dcb_app *app_data;
> -
> -			if (!dcbnl_app_attr_type_validate(type))
> -				continue;
> -			app_data = nla_data(attr);
> -
> -			if (!dcbnl_app_selector_validate(type,
> -							 app_data->selector)) {
> -				err = -EINVAL;
> -				goto err;
> -			}
> -
> -			if (ops->ieee_delapp)
> -				err = ops->ieee_delapp(netdev, app_data);
> -			else
> -				err = dcb_ieee_delapp(netdev, app_data);
> -			if (err)
> -				goto err;
> -		}
> +		err = dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
> +					   netdev, dcb_ieee_delapp,
> +					   ops->ieee_delapp);
> +		if (err)
> +			goto err;
>  	}
>  
>  err:

