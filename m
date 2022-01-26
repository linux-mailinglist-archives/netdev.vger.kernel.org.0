Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1423B49C17A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiAZCyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:54:46 -0500
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:62848
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236514AbiAZCyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 21:54:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNrRcI2+iRG674I+urkN6JaWp+bKGTYn56UIBnUCOaeJKNEcZEq+sPEjYP4i+p1hIYhJy4Q5ezH1a2q1cTzNJ5DfH6UfcwxkXroJuEURxldik0CqJFVOK4L8ZE5/zs4nDwtWDyjAsspc7J8tsT772zuMtukeXtkeztD7pW3qwhENZNYfmrH7e3yBuhmGS2eGaITXLtP3P4qq3IIoHu3rGWI5Evf2yTzWaa+iHtRJRJcvdZ2vTNLviUdxv838rAkN1Z7YF0dqXFV1SFIgtOMIK1LUOiwSwX2wkJ+kOUBLmR3yGjnlUQ/EA4ygY75LHkmMr8EOQt8CWriOLm5VRHdZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3UU6MorBUNmbg3AiobR+szu8JhD3o+Y0PfbqYjTzIY=;
 b=eIE6g7D8e7dlykqtRsbcIrY2oWYd9uFfxIXs0T0gJQzRxhaIw8eZdHG+vfqBTQv86jq6VtEIt5ZohJ83yslx+YjaeKPG2Po9rYHU8VYXpExprJZIJe1oop2cqRUPBcNKAMgyw4v2QVUVjDDNJ8PiPai0auGuim+u6f4fFHZlPmwtw7iXrzavPxpyNNsa3Tb1dPSotVHDUF4r81lbts/hzjcFS4YaAKm4vO8aSiq0gibbQf6GYFx57hkudAxxLC7lmNB86ONmuWqifLKe509LeuTz7whZyf9Q2DEj6J/zEv097Yy/fba3it0sfsG8nvN31sqsL+/PtYSMSkmzlZziqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3UU6MorBUNmbg3AiobR+szu8JhD3o+Y0PfbqYjTzIY=;
 b=Z4vyIxJWpw7GwtXBGQbD7LOhtFSA+5jDeQBFRel3Y4qqNDut3cSi0Pb/FPynhOtoLjnDRfwDEYG6g0vrWO40qDHxgG6kzn9oLkhs4Na/8rtweePFVV8cQt4xhD+2c/dC5ktTuKhhUakalZRpYiU+dUS8GD03FOiWPW6uGI4Aaojf4piI05NnXWXnZZQ2drBK4ltxc7az5xvw0rlzocZFdZ61OSkd+n11R48A/XRLaR76ClsCL/IBaCWxSo9c+kJ3B3s3qrZQ01NZDfHDoagfEiWITRhutE+qS8RldCI1yqcFJaxjphaXoenG2fdrwNIxSZQ+oXfC8+CynWUBwQce4g==
Received: from BN0PR02CA0059.namprd02.prod.outlook.com (2603:10b6:408:e5::34)
 by DM5PR12MB1225.namprd12.prod.outlook.com (2603:10b6:3:7a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 02:54:43 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::8f) by BN0PR02CA0059.outlook.office365.com
 (2603:10b6:408:e5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Wed, 26 Jan 2022 02:54:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 02:54:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 02:54:41 +0000
Received: from d3 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 25 Jan 2022
 18:54:40 -0800
Date:   Wed, 26 Jan 2022 11:54:37 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: bridge: vlan: Fix dumping with ifindex
Message-ID: <YfC37T23elbsAD0R@d3>
References: <20220125061903.714509-1-bpoirier@nvidia.com>
 <cc425efa-1e20-286a-ba96-bc9555142c9c@nvidia.com>
 <25ec6925-8ebf-d2fa-7d73-708ba72cec0a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <25ec6925-8ebf-d2fa-7d73-708ba72cec0a@nvidia.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b94930-20e2-4f22-c3ea-08d9e07733ec
X-MS-TrafficTypeDiagnostic: DM5PR12MB1225:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1225EF98F7F4685E2D629014B0209@DM5PR12MB1225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sh3MijeRHfVHgwC7FWPGs7PYIg58zZTUiCQIaf1MYt8RZXYZD2rfnWwQNLxdZTR41yhEzi7PwCNEp/JGlXHoFETqBcu229Fm2qlfanoPXJ6AwwYZRyw2j1/FD9BDisRouejQIWOgZG0WJM8QOIVGk0rMxunLwAjqNq2hah9ywfVZpq6Uz4ePfCrpiYFbupPjyperFawsaS0v9ChJnRmzarOFY7elHhduiXA8Pkp9P3clwkOS9HYNiPQLd4IabCxiHfyl9yOhISWUPOnG7CPnD/Vl//l6gJ/jGlyeEqBnczbHPk6Hdf4Q8aIha8PrAY4h0IL6ANg98Fh6AvuX4X0p+qzAUb6txOtyh179zi3LlZ/rWGPPxMGw7M0GdkyFMzezcFodXLc9QwE/QSJwI2QJ1RpfmXOry1TfQu4XEwgUXyNxbgEo0L4Q89ks0MIYEYVciva2EWJxJvCi775Cw6JdubHjeoTHmRmB5+RSRXatyIBfV0ZHC+QE/wZOs3+51L2+/oMQZwS19qkwr+RlVcYZ0MjjNgjntJZyhxOp42mITx0CC5a0fDRg5NhbmMlkKSolgDzKRsb9zLTdaJ9jt6b0aaR8HnP8k7DurOjbK1YMuqO1839OE0MBYhCd5D2UMIlRNqmYjwhY9wWOykR5zZi6jPqHkIGxErWmaNZT9L3cpa8R9WYlJlzRkkcjJBnEvN9QbXJ7Bd2xFmFwWdOw/2pDfDZTGiCxila4GVVE1cWYyALrUfJvwwZHJW9dq93+IcEGoUlMaVXqimFJHem/gwa/gdO/LXlNs/Ng7mNbJ5Q9BrM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(16526019)(53546011)(36860700001)(82310400004)(33716001)(83380400001)(186003)(9686003)(55016003)(47076005)(426003)(508600001)(81166007)(40460700003)(316002)(336012)(6666004)(4326008)(86362001)(356005)(6636002)(26005)(70586007)(8676002)(2906002)(54906003)(9576002)(8936002)(5660300002)(6862004)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 02:54:42.4801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b94930-20e2-4f22-c3ea-08d9e07733ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-25 11:51 +0200, Nikolay Aleksandrov wrote:
> On 25/01/2022 10:24, Nikolay Aleksandrov wrote:
> > On 25/01/2022 08:19, Benjamin Poirier wrote:
> >> Specifying ifindex in a RTM_GETVLAN dump leads to an infinite repetition
> >> of the same entries. netlink_dump() normally calls the dump function
> >> repeatedly until it returns 0 which br_vlan_rtm_dump() never does in
> >> that case.
> >>
> >> Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
> >> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> >> ---
> >>  net/bridge/br_vlan.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> > [snip]
> >>
> >> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> >> index 84ba456a78cc..2e606f2b9a4d 100644
> >> --- a/net/bridge/br_vlan.c
> >> +++ b/net/bridge/br_vlan.c
> >> @@ -2013,7 +2013,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
> >>  		dump_flags = nla_get_u32(dtb[BRIDGE_VLANDB_DUMP_FLAGS]);
> >>  
> >>  	rcu_read_lock();
> >> -	if (bvm->ifindex) {
> >> +	if (bvm->ifindex && !s_idx) {
> >>  		dev = dev_get_by_index_rcu(net, bvm->ifindex);
> >>  		if (!dev) {
> >>  			err = -ENODEV;
> >> @@ -2022,7 +2022,9 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
> >>  		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
> >>  		if (err && err != -EMSGSIZE)
> >>  			goto out_err;
> >> -	} else {
> >> +		else if (!err)
> >> +			idx++;
> >> +	} else if (!bvm->ifindex) {
> >>  		for_each_netdev_rcu(net, dev) {
> >>  			if (idx < s_idx)
> >>  				goto skip;
> > 
> > Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Actually I'd prefer an alternative that would encapsulate handling the single
> device dump in its block, avoid all the "else if"s and is simpler (untested):
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 84ba456a78cc..43201260e37b 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -2020,7 +2020,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>                         goto out_err;
>                 }
>                 err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
> -               if (err && err != -EMSGSIZE)
> +               /* if the dump completed without an error we return 0 here */
> +               if (err != -EMSGSIZE)
>                         goto out_err;
>         } else {
>                 for_each_netdev_rcu(net, dev) {

LGTM, thank you.
