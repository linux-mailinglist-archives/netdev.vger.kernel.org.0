Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956714BD339
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 02:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiBUBsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 20:48:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245458AbiBUBsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 20:48:00 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ECF49258
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 17:47:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=govmoCUx9AfCGK+0HOLf7y5wbDzLHawOthlrUHEVgXe5EQg9qviXxb3d+ypGy4P6cXnmx79vxQ8BCwDzsopcbmpCL1xkv4HcwEhAo81O042Jk3nXKYl2A8nbmyYVa1ygh2LoUdlGMR6yVQr+onreu4NcmuJmIZFzsfIttCuwNk01Zs9huCmOyZJEIYwNs6m0lJaY3g0RRos5UgWZN9UuLKJksVexKX2hR6l27iXiv/kUMrt3k63N21ubVfRl4xk9i7vjT05sMsH72s3Xm90yroE36YbDD6OMRZmZtulBLb6C4pbzK5srjGc7B5bU3PdJkfOzx++rFKQ76CHWgk5VdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZJubbnkPpYEpNDgPXZsZa4H+cda2y7Xn9Wk2Ijbpz8=;
 b=FnA5V60QWo2h9OmR14uZnNspTmcc2RHAi7RXxTELdtJJB2dd3roHAJvwAXia5bFei6cOjlrHXwTKYSHZ7QFmHGyREvWgVSM9Mhy6lA7w/1+ZnokScP1vIg4Klr9ggk13bDZu1nJKvS5SftXn304ev5AK+J3MQAx/3lYD91byAdNB1l9EqC8Q5olP6L0qve26KOQtQqc8IQ3As85KeQ4hfJ/pKZZTukZ1ABEoo3W2mh1tHEysFtpN8crivN4jAW7g5we/WQDs9SP4b4Svc9njlgaw6d64VLwhikgg7vnzflg40Dyq0O9rA5XNF8/phcR2V6LWNfUUGb9nadprVpoVZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZJubbnkPpYEpNDgPXZsZa4H+cda2y7Xn9Wk2Ijbpz8=;
 b=LIHi0+rrBOXpLjOtmbJ3HYGGCRzy/rB/poU37I4ldtrHLVn6ojAOLM1RZsk8bm386jhGGrbELOMGWRLAMIejyT04T9A1ecr7AiOZB58S1GIyVb4qlNelKUcFbtn1rvYbhdhSC1XofH9hhQR4u5tTUUSqe5adseTe/SHdTUsdcVFlA6DcTkAHSpH+4wOeMR6DjtNgDSKGV3+fB6M83YU72K4erMNCwtV/18ByCuqdSALgRPW3sI+TIQb4j7bTFe2sdJujB+Xlj5k36H8SgUqHnkUL01M97B1Zs+1aRx+EfT49U6LY9kbQFk01WywYG4540hXxrYl0rFKgsGtMZPJ7TA==
Received: from MWHPR14CA0048.namprd14.prod.outlook.com (2603:10b6:300:12b::34)
 by DM6PR12MB3417.namprd12.prod.outlook.com (2603:10b6:5:118::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Mon, 21 Feb
 2022 01:47:35 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::f1) by MWHPR14CA0048.outlook.office365.com
 (2603:10b6:300:12b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Mon, 21 Feb 2022 01:47:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 01:47:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 01:47:34 +0000
Received: from d3 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 17:47:32 -0800
Date:   Mon, 21 Feb 2022 10:47:29 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Roopa Prabhu <roopa@nvidia.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>
Subject: Re: [PATCH net-next 10/12] selinux: add support for RTM_NEWTUNNEL,
 RTM_DELTUNNEL, and RTM_GETTUNNEL
Message-ID: <YhLvMVGIsyvu1dXK@d3>
References: <20220220140405.1646839-1-roopa@nvidia.com>
 <20220220140405.1646839-11-roopa@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220220140405.1646839-11-roopa@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4128f7-249c-4e72-f6dc-08d9f4dc2234
X-MS-TrafficTypeDiagnostic: DM6PR12MB3417:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3417AFF04CAB3502A7901CF4B03A9@DM6PR12MB3417.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGdAJb5n2tCb70L/HVQbNdOdMNTpdXZ6BM1tNtaMRA8Dm/3SQHI8fxMwZgUQB/1gvU3AX4hfm3Z2ADo98n9wLkJm9gVtUQOy7kVgndhBak1Ab8J5ILwDzBRK5PvhQUSiw5s9VIJCepAERXY5SDZv/KpR0GjaZo+CZ4d+BnE3AhcQveCAfQT1z6uKIpKEjjz/2km7YEo9KpJ+aMo/ppeY+r/JylCKzjiGsI58lStrVasQsbWLPKKt9whZwxKzrXb/wQ4vO8d7mz9+w18DSbY0ReKQGcGq0MOBp3uogrNwWyS0gOZgHHofOQa7joRK2khUNWxb2ICbAu4C5SpiiFIx7FAPIG+Tah6p68cLVyHu/7xmtylLavoqNvsrv+QMhXo1V1ofBkmE1BscA/XFjY9hhLs3xmqf4Lg1nDh2zvvBlf5TAUqeuHmnDQeyMVJvEoWpVR8bm1/UDRxsKsyMUi7lPLtvk9bZ8eDtRJPWq4d94sWTYW9p4Wb4HlZgRavFF65iFSpey2a4/IGY0RvC7andYlX+OZt7mh8VpeRmdf99jZH47SwQcMdYp95bmclU0+LWaJpokcUldD3BZzZeD9JX/+khgEG9lI7v386jgA6IopT/2eY7ull5Q6P2IfW4HajDK6+eTspNoMbuW0rsV/wF8T//veibZ1KJyLlaayzO9QXCOzZFt6KkzxvWJ6f3ewigSipJREBS7K2zU62dlzxxkg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(9686003)(6666004)(70586007)(5660300002)(4326008)(6862004)(508600001)(6636002)(26005)(186003)(336012)(426003)(16526019)(70206006)(316002)(83380400001)(47076005)(8676002)(9576002)(8936002)(40460700003)(36860700001)(55016003)(2906002)(33716001)(81166007)(53546011)(356005)(54906003)(82310400004)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 01:47:35.2264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4128f7-249c-4e72-f6dc-08d9f4dc2234
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3417
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-20 14:04 +0000, Roopa Prabhu wrote:
> From: Benjamin Poirier <bpoirier@nvidia.com>
> 
> This patch adds newly added RTM_*TUNNEL msgs to nlmsg_route_perms
> 
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---
>  security/selinux/nlmsgtab.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
> index 94ea2a8b2bb7..6ad3ee02e023 100644
> --- a/security/selinux/nlmsgtab.c
> +++ b/security/selinux/nlmsgtab.c
> @@ -91,6 +91,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
>  	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>  	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>  	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
> +	{ RTM_NEWTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> +	{ RTM_DELTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
> +	{ RTM_GETTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
>  };
>  
>  static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
> @@ -176,7 +179,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
>  		 * structures at the top of this file with the new mappings
>  		 * before updating the BUILD_BUG_ON() macro!
>  		 */
> -		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOPBUCKET + 3));
> +		BUILD_BUG_ON(RTM_MAX != (RTM_NEWTUNNEL + 3));

This patch should be folded with patch 06 ("rtnetlink: add new rtm
tunnel api for tunnel id filtering") otherwise there is build breakage
partway through the series when compiling with
CONFIG_SECURITY_SELINUX=y:

  CC      security/selinux/nlmsgtab.o
In file included from <command-line>:
security/selinux/nlmsgtab.c: In function ‘selinux_nlmsg_lookup’:
././include/linux/compiler_types.h:349:45: error: call to ‘__compiletime_assert_516’ declared with attribute error: BUILD_BUG_ON failed: RTM_MAX != (RTM_NEWNEXTHOPBUCKET + 3)
  349 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                             ^
