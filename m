Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11E95B5DEF
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiILQPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiILQO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:14:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE6DFD1
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:14:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBqNFvPHlkIaSQ5VUJayEO3SdfiVt2/Yhd07UyXsKalp3iZMVtO2LjFCZmqc1OoG8OkLhOXHTNbn8MeZSBd57a897mkzuKZYLiC7rrivSV2MNllFt7vl8bc4Pl/24O0JKA9sUA+0G2W3qWdF8TX7ylpJ3bZRtUWI9jlIShRrhutAtWN9yqevlJJ9TNEV2T9fLeupFBgqS9HkZB2e2b8+lNNsOo//Gkrn/eC3EOplFUlOVNme5Cg8GGX09yESTiQtUGEPkxnFcFDgDBhR9LURl54jGZkV7t/lxL6aN6naRWj1u+gqxsiXEgXLXR5VEFQA5GBLLvryjbXjDVudyjLb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FddiO6oU0FR8xojCbBsGGaPhpeQdUrnvrGSgB0V4LtY=;
 b=SPIXzYs9yI9ORdzYGx4yWKnUFGmonSecmpfSRIpEP+DpNOLF7DIY0Iq2KUf9LKBokB2Waq1QKx+vZ7iXc7sN9TUgEK0eSYjfoU5eQ7zRi2NS4ibdAHb+ZCwOXY1JvioPETRPOCwFd7zPLds7Usp3DHQo7/zoODxiRUCaLysIhB2uQ8K3LluvdceTR+2CeGp+CDo1e0D2EGm/o337CCE2RhUyISnmFhZRJ4K5N/al3nOoEV8aECeHAXUETOf5BcWEOkXzdjBXCEbhShkf1hHrRz2Uq2glPetgvsqzPIg1j5xoQvoV2/rVp0+aQuVuL/rn6d4gsS/5cpWlvIz7oHpqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FddiO6oU0FR8xojCbBsGGaPhpeQdUrnvrGSgB0V4LtY=;
 b=lMRdsfXP6legrcObeJrsEwRbVvgHAVnB6U6NqS/fn9wEWa85QEk2uQ9sgA3wKVPc+aIfT1mymUiExpfJRqsBW5A6WmFUqQ4ZWZsGnXqzG9nQ7YutSfjh5zj0QaTgR4bSAr3U+AI8XI0QMsppSCbbcvHlFG7mPo9CoIc9Q5EkkV29p1kp1S717YdsbIEJ5la5QoZCX1v/Y9vqkxOUZAhk4AKhzRy8CDQfPOp4rjL6wdNHuNU8K++Ms58IZTILxFOIJJsaTRycB+DjHrEz7d1DfPPdAI4mOZpH0yKwwkP57ZbVcv414rOg/oSc3WC5p3AEYhEN1DR3uJW0LC8DJeL7UQ==
Received: from BN0PR04CA0123.namprd04.prod.outlook.com (2603:10b6:408:ed::8)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 12 Sep
 2022 16:14:53 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::82) by BN0PR04CA0123.outlook.office365.com
 (2603:10b6:408:ed::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Mon, 12 Sep 2022 16:14:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 16:14:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 12 Sep
 2022 16:14:51 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 09:14:47 -0700
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Date:   Mon, 12 Sep 2022 16:31:34 +0200
In-Reply-To: <20220908120442.3069771-3-daniel.machon@microchip.com>
Message-ID: <87czc0efij.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: a983f04e-ac1a-4d47-f062-08da94d9ed15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vk2c5WXGt+VCDcWjZP0Xcn5QZwZvwQEoqOc05cA9WBbjhCgOp1Y52dD3FQCL9Pz7H/fn7uASZknu8cTGy8bwBJ4ZB1cqG38z7CiVkHQD2WgslG5I4EZcVsfgdOCtEkgk6aSrCZnSr5UGMqZrnVfuLi8QRbBZ7I1Z2Fyzca8/XHZojwrUiED1092THAa1eZ0TOIpjyPZ/OVYgr+VoS42SE9ylTjfsalGm6nVcvpIXjFtZcTtGUONtIo1c3MQnWj/MA0y3k2+h1+iB/7ew2syXFP9T/jRxsJnjCqS8Q5LbS9RyqmLXkRBZolhTh153fA3LT4B/kJkjGfPBoISKZkYUZ+JOTQqXQ0gNSgyInxNTwLKzR5lp2ptT/P8/79TFxmR4U1MBRpRf3p2WX5EeUUbIUO8mdDZPXftq4xm32X0KVTN5vBRSVr2Ydfv56Sq0Bu3GqLh5iA+dr5nBpzROFtz0pU2K6H7Ebo0awJV6RJlW9ReJgssuS0NE+HD6EOtF/+rq0vPz9uIe65u8+VEVoL/Yf28MSpA8UHoXgGDm8J/uXSribE+wmKodiWERS6P1MCTZytE9tVgW9x5wnHUXB30kWGps8hxy1vr1Z+5vjMBOFQgTPHN6mSRzeeWe6Xq33gxxmeCC8GFmFrj8EHFEm2GXE0xFNxK+661xZWqJU33CsX3qeb3dFs3iE0lcy/Pftg6lP/UCl2zZQc239s/yold+s4gJ5MhJ59qhrL7mOLE1/FAmJRPRD6LvmasKR9zc1HU55gjm3VzKVYS1Nitk71J+vO2/pVuwN6MU94rKzDxxSZcTS+fRQEL5CwYukuSjY6mP
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230017)(4636009)(39860400002)(396003)(136003)(376002)(346002)(40470700004)(46966006)(36840700001)(26005)(336012)(2616005)(2906002)(426003)(5660300002)(8936002)(8676002)(54906003)(81166007)(47076005)(316002)(4326008)(40480700001)(70586007)(36860700001)(82310400005)(70206006)(356005)(478600001)(82740400003)(16526019)(36756003)(86362001)(6666004)(186003)(41300700001)(83380400001)(6916009)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:14:53.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a983f04e-ac1a-4d47-f062-08da94d9ed15
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add a new apptrust extension attribute to the 8021Qaz APP managed
> object.
>
> The new attribute is meant to allow drivers, whose hw supports the
> notion of trust, to be able to set whether a particular app selector is
> to be trusted - and also the order of precedence of selectors.
>
> A new structure ieee_apptrust has been created, which contains an array
> of selectors, where lower indexes has higher precedence.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  include/net/dcbnl.h        |  2 ++
>  include/uapi/linux/dcbnl.h | 14 ++++++++++++++
>  net/dcb/dcbnl.c            | 17 +++++++++++++++++
>  3 files changed, 33 insertions(+)
>
> diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
> index 2b2d86fb3131..0c4b0107981d 100644
> --- a/include/net/dcbnl.h
> +++ b/include/net/dcbnl.h
> @@ -61,6 +61,8 @@ struct dcbnl_rtnl_ops {
>  	int (*ieee_getapp) (struct net_device *, struct dcb_app *);
>  	int (*ieee_setapp) (struct net_device *, struct dcb_app *);
>  	int (*ieee_delapp) (struct net_device *, struct dcb_app *);
> +	int (*ieee_setapptrust)  (struct net_device *, struct ieee_apptrust *);
> +	int (*ieee_getapptrust)  (struct net_device *, struct ieee_apptrust *);
>  	int (*ieee_peer_getets) (struct net_device *, struct ieee_ets *);
>  	int (*ieee_peer_getpfc) (struct net_device *, struct ieee_pfc *);
>  
> diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> index 8eab16e5bc13..833466dec096 100644
> --- a/include/uapi/linux/dcbnl.h
> +++ b/include/uapi/linux/dcbnl.h
> @@ -248,6 +248,19 @@ struct dcb_app {
>  	__u16	protocol;
>  };
>  
> +#define IEEE_8021QAZ_APP_SEL_MAX 255
> +
> +/* This structure contains trust order extension to the IEEE 802.1Qaz APP
> + * managed object.
> + *
> + * @order: contains trust ordering of selector values for the IEEE 802.1Qaz
> + *               APP managed object. Lower indexes has higher trust.
> + */
> +struct ieee_apptrust {

Trust level setting is not standard, so this should be something like
dcbnl_apptrust.

Ditto for DCB_ATTR_IEEE_APP_TRUST below. I believe DCB_ATTR_DCB_BUFFER
is in the DCB namespace for that reason, and the trust level artifacts
should be as well. Likewise with the DCB ops callbacks, which should
IMHO be dcbnl_get/setapptrust.

> +	__u8 num;

Is this supposed to be a count of the "order" items?
If yes, I'd call it "count", because then it's clear the value is not
just a number, but actually a number of items.

> +	__u8 order[IEEE_8021QAZ_APP_SEL_MAX];

Should be +1 IMHO, in case the whole u8 selector space is allocated. (In
particular, there's no guarantee that IEEE won't ever allocate the
selector 0.)

But of course this will never get anywhere close to that. We will end up
passing maybe one, two entries. So the UAPI seems excessive in how it
hands around this large array.

I wonder if it would be better to make the DCB_ATTR_IEEE_APP_TABLE
payload be an array of bytes, each byte a selector? Or something similar
to DCB_ATTR_IEEE_APP_TABLE / DCB_ATTR_IEEE_APP, a nest and an array of
payload attributes?

> +};
> +
>  /**
>   * struct dcb_peer_app_info - APP feature information sent by the peer
>   *
> @@ -419,6 +432,7 @@ enum ieee_attrs {
>  	DCB_ATTR_IEEE_QCN,
>  	DCB_ATTR_IEEE_QCN_STATS,
>  	DCB_ATTR_DCB_BUFFER,
> +	DCB_ATTR_IEEE_APP_TRUST,
>  	__DCB_ATTR_IEEE_MAX
>  };
>  #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
> diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> index dc4fb699b56c..e87f0128c3bd 100644
> --- a/net/dcb/dcbnl.c
> +++ b/net/dcb/dcbnl.c
> @@ -162,6 +162,7 @@ static const struct nla_policy dcbnl_ieee_policy[DCB_ATTR_IEEE_MAX + 1] = {
>  	[DCB_ATTR_IEEE_ETS]	    = {.len = sizeof(struct ieee_ets)},
>  	[DCB_ATTR_IEEE_PFC]	    = {.len = sizeof(struct ieee_pfc)},
>  	[DCB_ATTR_IEEE_APP_TABLE]   = {.type = NLA_NESTED},
> +	[DCB_ATTR_IEEE_APP_TRUST]   = {.len = sizeof(struct ieee_apptrust)},
>  	[DCB_ATTR_IEEE_MAXRATE]   = {.len = sizeof(struct ieee_maxrate)},
>  	[DCB_ATTR_IEEE_QCN]         = {.len = sizeof(struct ieee_qcn)},
>  	[DCB_ATTR_IEEE_QCN_STATS]   = {.len = sizeof(struct ieee_qcn_stats)},
> @@ -1133,6 +1134,14 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
>  	spin_unlock_bh(&dcb_lock);
>  	nla_nest_end(skb, app);
>  
> +	if (ops->ieee_getapptrust) {
> +		struct ieee_apptrust trust;

I believe checkpatch warns if there's no empty line between the variable
declaration block and the rest of the code.

Maybe it's just because this is an RFC, but for the final submission
please make sure you run checkpatch.pl --max-line-length=80. The
80-character limit is not really a hard requirement anymore, but it's
still strongly preferred in net.

> +		memset(&trust, 0, sizeof(trust));
> +		err = ops->ieee_getapptrust(netdev, &trust);
> +		if (!err && nla_put(skb, DCB_ATTR_IEEE_APP_TRUST, sizeof(trust), &trust))
> +			return -EMSGSIZE;
> +	}
> +
>  	/* get peer info if available */
>  	if (ops->ieee_peer_getets) {
>  		struct ieee_ets ets;
> @@ -1513,6 +1522,14 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  		}
>  	}
>  
> +	if (ieee[DCB_ATTR_IEEE_APP_TRUST] && ops->ieee_setapptrust) {

Hmm, weird that none of the set requests are bounced if there's no set
callback. That way the request appears to succeed but doesn't actually
set anything. I find this very strange.

Drivers that do not even have any DCB ops give -EOPNOTSUPP as expected.
I think lack of a particular op should do this as well. We can't change
this for the existing ones, but IMHO the new OPs should be like that.

> +		struct ieee_apptrust *trust =
> +			nla_data(ieee[DCB_ATTR_IEEE_APP_TRUST]);

Besides invoking the OP, this should validate the payload. E.g. no
driver is supposed to accept trust policies that contain invalid
selectors. Pretty sure there's no value in repeated entries either.

> +		err = ops->ieee_setapptrust(netdev, trust);
> +		if (err)
> +			goto err;
> +	}
> +
>  err:
>  	err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
>  	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);

