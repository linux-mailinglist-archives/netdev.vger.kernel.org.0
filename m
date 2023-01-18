Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED25672191
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjARPm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjARPmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:42:24 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598BD1EFC4;
        Wed, 18 Jan 2023 07:42:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8ARTirEDTDggH2Fib6o18VcnUqM8aW10aJnYxQEeGpexad0n5KGGqyh6rgbFN/vPoGCrB5ZFaZQbjO5jJQ3aUbwYU6w2HeGyHlewRx4uvgIeOkUYE9Dzpz+0R0knigBbNHfgLIXHsfnGYnqE8wqFazUsV974PnyDMkyUUoxKgIgjtuBJmfNTxu07T6H3vPyBQlEBgWmfFkbh/J3UA2TLnsvA0NtGXbOiHXr7DcZIayKI9VnB6HR2Ie/5i0ZMGa6umNSIdlrdEHKGPxyXwovyXQyyrFKe4NXb4gqN27tD2rsA87jffgEsrrLHqwfPXimGaSWX5XF8SJ0OPn8mclfeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbZfDUOyO4Gt1CHvqreHMDYxWc2uL9jRbQ50MSdZjpo=;
 b=n9js2EvK3JLyfRuaMmZTdUd7ueKY/hEwgUvKb9RXpgQvSkPDuDBozuwZribuQkvNwC+9sxGRKhv+CQ23fWMuHowl+078R56YatQvfF3ln+3TqrSdIjegmivG2KGO7te0grgeBizEqs9JvRdovs7h+6nHgNLSjDGFAdM7qGyktN7PFAy15yeNp0+GUzBiTbI2nUcfPtyIQpVP6ecbtXY5iS3+VukzRdkqw7e1Z1YvF1yyQgmuF+T0Ld2SzsGr5Vn8YS3rzrq92ACVbJY3hx/to7M0/ApZqL7quG9PeBx5K+lvbWMOgMKJZwLiYWT5HOdbASdk3wNk1EOm233MMxaKbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbZfDUOyO4Gt1CHvqreHMDYxWc2uL9jRbQ50MSdZjpo=;
 b=n3QuHTwCM4AvCg5hfU4e4kZr8V2LHtBZPTtt/9Bs4U/lhGMtbAsQ8gdAf59aeQbPDHQ+kjX0OTq0CGhvLbEobl9TgaFlDIuOlxmTP7QjmDtced1dE6g+yYZkZ8iBmZNpEyRCNoQPniJ4xq5AnTiLM23+YBn38/WJb/RJOUxybnFHDtdmplZujRPTK+nBJyXIYhz587FNXU6hG8RRpytfzMbZHIVfFK+0yLw3kiIZIuhiKMvFmj1Wu2UfzqbA0uNkQgctDITKuamM+9SkCgJEfmDqjPgZ/y6X5f5cwIN+N7/yHnne+0tUms3QnK2MXHUkxtuOAEZXi2zdjJJSG55ZEQ==
Received: from MW4PR03CA0061.namprd03.prod.outlook.com (2603:10b6:303:b6::6)
 by SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 15:42:20 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::21) by MW4PR03CA0061.outlook.office365.com
 (2603:10b6:303:b6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 15:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 15:42:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 07:42:08 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 07:42:02 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
 <87lem0w1k3.fsf@nvidia.com> <Y8f4i2ablWnNO9Op@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <error27@gmail.com>,
        <Horatiu.Vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Date:   Wed, 18 Jan 2023 16:20:31 +0100
In-Reply-To: <Y8f4i2ablWnNO9Op@DEN-LT-70577>
Message-ID: <874jsnalyv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT012:EE_|SN7PR12MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cbf5749-2b00-40de-a80e-08daf96a9606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Se9eIK1DOoS4EJ5Ja8ef+Xs4AqwuHsLgbM8EjexvRKuO8v41WPIXuaEblxbiMbw23fmLW5hSyiOy0Jl81DTE3CDPi0U/pkSbjSov/C4jnPOaRUm95Z24lyfrWcdAjV2U8FNulBBAbitU+vL9eMw5Ap7KYWw7xNUN08c24kMK3oq9m+j9mGNcQfhszHoJ1rFGOoBBGODCy9vpv/V6TjeyYLNBjM/JZRKRGpqHSjQDU3XYcV5hVKwerrdeOn11HoSIu8fkL5H6hjNfLM1DCya4qDHZ6ZAR+Jm4OkQ97QMR3WtiSbZ48eW8RxYDWuT+1K/RtwRZkapgtzaCUJF1hWFqOGX1LD8jUTpddVNpFElf19azKORp24OZyDNKgGwN4BKGYIPSQrQ1Q+sH48SAT9AQP497e9EcOZq+vDLAO+CHknBsBESMYvgBRNh07eJjDxU956nRkaJHhiaTLPYswMX7GLY8Qxq+QHLT6pIxfC++2yXYtYieFnWqzV2MGtr9gpGHwR0QML7S3GyJxODq/d0lmQbtSFBkgYTb9dZBAG+ccKA4YPZ+vcXQLqnd7sE91F2MnK5cYoSago/2vpzSy9jXNHT9Pg3XWD7RbzH04W0UIgeapxa0SESJwXchv1/3GTeW/nf1n+C0DwYpCnkqS24VA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(451199015)(36840700001)(46966006)(83380400001)(7636003)(36860700001)(6916009)(70586007)(4326008)(8676002)(82310400005)(54906003)(2906002)(7416002)(426003)(8936002)(26005)(498600001)(2616005)(47076005)(336012)(5660300002)(16526019)(6666004)(356005)(70206006)(86362001)(66899015)(186003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:42:20.3652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbf5749-2b00-40de-a80e-08daf96a9606
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > +     rewr = nla_nest_start_noflag(skb, DCB_ATTR_DCB_REWR_TABLE);
>> > +     if (!rewr)
>> > +             return -EMSGSIZE;
>> 
>> This being new code, don't use _noflag please.
>
> Ack.
>
>> 
>> > +
>> > +     spin_lock_bh(&dcb_lock);
>> > +     list_for_each_entry(itr, &dcb_rewr_list, list) {
>> > +             if (itr->ifindex == netdev->ifindex) {
>> > +                     enum ieee_attrs_app type =
>> > +                             dcbnl_app_attr_type_get(itr->app.selector);
>> > +                     err = nla_put(skb, type, sizeof(itr->app), &itr->app);
>> > +                     if (err) {
>> > +                             spin_unlock_bh(&dcb_lock);
>> 
>> This should cancel the nest started above.
>
> Yes, it should.
>
>> 
>> I wonder if it would be cleaner in a separate function, so that there
>> can be a dedicated clean-up block to goto.
>
> Well yes. That would make sense if the function were reused for both APP
> and rewr.

I meant purely for to make the cleanup clear. The function would be
approximately:

static int dcbnl_ieee_fill_rewr(struct sk_buff *skb, struct net_device *netdev)
{
	struct dcb_app_type *itr;
	struct nlattr *rewr;
	int err;

	rewr = nla_nest_start_noflag(skb, DCB_ATTR_DCB_REWR_TABLE);
	if (!rewr)
		return -EMSGSIZE;

	spin_lock_bh(&dcb_lock);
	list_for_each_entry(itr, &dcb_rewr_list, list) {
		if (itr->ifindex == netdev->ifindex) {
			enum ieee_attrs_app type =
				dcbnl_app_attr_type_get(itr->app.selector);
			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
			if (err)
				goto err_out;
		}
	}

	spin_unlock_bh(&dcb_lock);
	nla_nest_end(skb, rewr);
        return 0;

err_out:
	spin_unlock_bh(&dcb_lock);
	nla_nest_cancel(skb, rewr);
	return err;
}

Which uses an idiomatic style with the cleanup block at the end, instead
of stashing the individual cleanups before the return statement. I find
it easier to reason about.

But it's not a big deal. Your thing is readable just fine.

> Though in the APP equivalent code, nla_nest_start_noflag is used, and
> dcbnl_ops->getdcbx() is called. Is there any userspace side-effect of
> using nla_nest_start for APP too?

Yeah, the clients would be looking for code DCB_ATTR_IEEE_APP_TABLE, but
would get DCB_ATTR_IEEE_APP_TABLE | NLA_F_NESTED, and get confused.

For reuse between APP_TABLE and REWR_TABLE, you could just always call
_noflag in the helper, and pass the actual attribute in an argument.
Then the argument would be either DCB_ATTR_DCB_REWR_TABLE | NLA_F_NESTED,
or just plain DCB_ATTR_IEEE_APP_TABLE.

But that makes the code less clear, and I don't feel it brings much.

> dcbnl_ops->getdcbx() would then be left outside of the shared function.
> Does that call even have to hold the dcb_lock? Not as far as I can tell.
>
> something like:
>
> err = dcbnl_app_table_get(ndev, skb, &dcb_app_list,
> 			  DCB_ATTR_IEEE_APP_TABLE);
> if (err)
> 	return -EMSGSIZE;
>
> err = dcbnl_app_table_get(ndev, skb, &dcb_rewr_list,
> 			  DCB_ATTR_DCB_REWR_TABLE);
> if (err)
>         return -EMSGSIZE;
>
> if (netdev->dcbnl_ops->getdcbx)
> 	dcbx = netdev->dcbnl_ops->getdcbx(netdev); <-- without lock held
> else
> 	dcbx = -EOPNOTSUPP;
>
> Let me hear your thoughts.

Yeah, and the dcbx stuff is the added wrinkle.

Dunno, I'd not force it. This redundancy is not great, but the code is
small and easy to understand, so I find it's not an issue.
