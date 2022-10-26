Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF860DEBE
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiJZKRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiJZKQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 06:16:58 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2042.outbound.protection.outlook.com [40.107.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07D99938B;
        Wed, 26 Oct 2022 03:16:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7CpjzV/o6SuVZR/Vh6G5J0Rwg6dpiTT2Bpr4onG3yuHxxG9t2j0VGJCrOJuxpPaRPjeLhVwCjnT0/zF5tritXdazTh4vOJw9t9McYA7TFSWIxuupIXSJxyWk5/hj6IqH5Zr2b41CHkxLA0vmxZINE87MakmWWSzgIcG1u1JORa52xHZHVz+ZgFBiWrmNKMTu3pXk/QjO5PzJNNXpHks0cfqXKW+iYOsqeF1blYluOt9IR9Mwt/YpiORuTIMxySYoHmXN+T2DDtJl7J0FQL4HC6qRXaWJXHxzv9HTe16LW7HIehi/o7Wy9dowuwM2B/zHP6/ngsxyennGfra3/O4eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBKBbNO0bOu2v7KsYLLKIJtlTZ3HmDBiQlJZsdZuuZI=;
 b=S2MkspV5BZrmx9Mj+ZJ1vS9dO2w70chizyBlo6Co8VyUV3DwIe0VF4x7dc2T/rxlWDqa9MB9ww9vBdD9XrCjC1YnsJifwyPVQ16yKc8+vSNQOAvMhhuz8nwekWcSmfdPnkE3gJpuOezHfyg4ejULApyYeYXBFpw9OMZYjHDJFPaUKo5tcDS8gz8b5NlsPiZs+D47DC0FoKY/P4vpBK+fcTjldmfddGcorwah56gGxbA9xHNB8XpS9ocrXlgYKKej6FoSWh8LWxAuRYF24QR6Ss5VqZ9N87VZ06PztKyZGWR6Y0OM7eu/K5eK77BFw1a8MiKS0DbxADOgJu/BZ0wgdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBKBbNO0bOu2v7KsYLLKIJtlTZ3HmDBiQlJZsdZuuZI=;
 b=Btjx7i6PuPmgSDOzNSAyu1Wc9/nMJ8lOqUdu2Y0wS9E9W66tX3kqazG4oDcyI7Gs5PTNUl0l4OZyIXrOjMJ9lFXtJQelEgtvEtYIiQTrDeHgePIM3ps/rio7peQbL6O5yw4FVAMxSSU+4bk7vsDK+P/ZCzJOo8HzzSwVwM3llGZii+xa6Uk40jfTJNDdKW7sd8pr0Y74NMCwk5OjHBg1CrDXEHvP0wMs2Ji5f2MoBmFkSxdLDE3SvF8ogzRZmgcMRV76Nkny0nN3XUi3OPzjSU9eude2yVcnHOQnk/M0xtmFwavT6/ICxvVoSVRZuZcaJWJLcYbJ6eHIk95WVHpZtQ==
Received: from DM6PR21CA0013.namprd21.prod.outlook.com (2603:10b6:5:174::23)
 by CH0PR12MB5386.namprd12.prod.outlook.com (2603:10b6:610:d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Wed, 26 Oct
 2022 10:16:52 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::fd) by DM6PR21CA0013.outlook.office365.com
 (2603:10b6:5:174::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.8 via Frontend
 Transport; Wed, 26 Oct 2022 10:16:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Wed, 26 Oct 2022 10:16:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 26 Oct
 2022 03:16:47 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 26 Oct
 2022 03:16:43 -0700
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-2-daniel.machon@microchip.com>
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
Subject: Re: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Date:   Wed, 26 Oct 2022 12:11:08 +0200
In-Reply-To: <20221024091333.1048061-2-daniel.machon@microchip.com>
Message-ID: <874jvq28l3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|CH0PR12MB5386:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d506958-7796-4482-25b0-08dab73b338c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: luPBNY5a6bbJR4uyeqHibCbfWkkCjbrOdE5EQN/IwWZQtVmJD7tBznsVh0CcznrBnohPkGjFSIhuS33PP6wxA4ZnQRzvL5FqzmnalBZ3MlnPa0BUQBaf0I+Qe/j2Xfs8R64PKT0drlHnPh9U4zXt3KdXzN0TDGsqAizPWTjVVV4qqD1SzZQIj2kBDfXvC+ik47C2E/imc1dhI4mHM4AUyWkrLwD2e3tSxZQOfkgiKbPahs/fTNp9D+8rF+5vV190BACKO/ou6NyBjjGjlnydhwwyXLNHmAvCB/qQ0ThYgQfpUuhrfPW9GjDUjQEXQeDvs0KI9tnE1s3FRvCw+Gd+E3akTDl9xqmc2/cf82qlW94ath5AvQMv/oHVUe4/hkN3tNT+wAEjleWwFZkA+LuVWWagelW3BiP7L+RUtCvwseJ/HfoJW520c7H/+/0C+1ghKRr2m/dIDZJIvtGG3P/DQGnl0RL/TBxBEaHDi3t2b1VPvaeSn8Huw5sTjiqjgp7Oi8OceN7R+8n/qzw1x0ie+wS1IYXzGrdk0WtMlGVtb996pOx6YmbLw0hEuutsiXa8s9IjzvrgIymc9aluYe/6XKsj68cMwzvMHhA4LnD3hFkLlFK/zVY/LXDZY5iM4NABQk1yqg55Ij1NQsocmQ59HpBF0vMrqP9FfsRAmGLt+dFV/Fju3g2zd7tIf7ModEKHQoV8cOtTPSS2ibWtTSyLrGiHDiLAYsnFTyLKfMvqhGbNtu5eM+m3LNhe3BvPwMGH
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(54906003)(6666004)(41300700001)(5660300002)(4326008)(8676002)(26005)(70586007)(70206006)(2616005)(8936002)(6916009)(478600001)(316002)(7636003)(83380400001)(186003)(426003)(40480700001)(82740400003)(356005)(2906002)(36756003)(47076005)(86362001)(7416002)(82310400005)(16526019)(40460700003)(336012)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 10:16:52.0560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d506958-7796-4482-25b0-08dab73b338c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5386
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

> Add new PCP selector for the 8021Qaz APP managed object.
>
> As the PCP selector is not part of the 8021Qaz standard, a new non-std
> extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
> helper functions to translate between selector and app attribute type
> has been added. The new selector has been given a value of 255, to
> minimize the risk of future overlap of std- and non-std attributes.
>
> The new DCB_ATTR_DCB_APP is sent alongside the ieee std attribute in the
> app table. This means that the dcb_app struct can now both contain std-
> and non-std app attributes. Currently there is no overlap between the
> selector values of the two attributes.
>
> The purpose of adding the PCP selector, is to be able to offload
> PCP-based queue classification to the 8021Q Priority Code Point table,
> see 6.9.3 of IEEE Std 802.1Q-2018.
>
> PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

>  static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 seq,
>  				    u32 flags, struct nlmsghdr **nlhp)
>  {
> @@ -1116,8 +1143,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
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
> @@ -1495,7 +1523,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
>  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
>  			struct dcb_app *app_data;
>  
> -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
> +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))
>  				continue;
>  
>  			if (nla_len(attr) < sizeof(struct dcb_app)) {
> @@ -1556,7 +1584,7 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
>  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
>  			struct dcb_app *app_data;
>  
> -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
> +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))
>  				continue;
>  			app_data = nla_data(attr);
>  			if (ops->ieee_delapp)

I'm missing a validation that DCB_APP_SEL_PCP is always sent in
DCB_ATTR_DCB_APP encapsulation. Wouldn't the current code permit
sending it in the IEEE encap? This should be forbidden.

And vice versa: I'm not sure we want to permit sending the standard
attributes in the DCB encap.
