Return-Path: <netdev+bounces-6105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2D4714D50
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44BD7280EF0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57AD78F5B;
	Mon, 29 May 2023 15:46:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF88F5A
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:46:15 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2079.outbound.protection.outlook.com [40.107.105.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E362FDE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:46:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AL9lamNGbZc+HKNRjW56k3HnWcKQMpZc7hqkT14YgbndcxKegk3ycuKNo6QVTzbKWozuVFKsSnv2vHznfk8Q53JK/ipR/Co8FAIPtDSm+9u0cnjtwtvux9xk15MLGpkzqiixD7W3YijHJ01hiGthEi8POR7+5b92pJVk43lkEwr73lkfLVRITqKSWGjEgv7wFsr0DjAv1njGqCYYIBKQUXrSr547aZz5gigHk/i4XpdMjNgcLo8vMfZ4vmpFAIQu9OAbpMxxx/nzCqW+XHR1FinAt94EkM61d7lz5kMf764kCfyz9jv5rLAwnqYC49h7FQnZnYg5jIUrQQpJ8ycOmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugWYv9WDPqEGvV3depHeacZSDp2d3x32gBW4h181Wo0=;
 b=jgF9wzLy+/kAXS7D65sbS8lGlC3ZyQD6o+rryDYyKhUqfQybBI7MUNEP82srEYlqffUf3F66Wl9xOHVsRTtdMGlFWNtJXA+44OHkMKp4DXP4etP88KXNfdJpwU1g7XGJzt6H3GwWxlvHIyfO26Pbel6CXJLx4rN4nk/zTfCD/8rtdigVRA7qwXmGKGPBty9xTukQH9YUmUUcJ3Hi+ukC3YYe7Fthf4hzQZmx5kA2kWASi72j5FV7SkkoayUMBRE7cmeLxxAPutPmGsvi+l38a3SOXHeKyM3pZh0ReMjLyvG4oy/FM/1TH0EGkhcfAvpfqz0iYKpqhGD5+LuXHbMFEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugWYv9WDPqEGvV3depHeacZSDp2d3x32gBW4h181Wo0=;
 b=hmJciHHexyAOl39P3RvHImTMYY7RZSqpepvltqdrep1iQ5KGqZmF+YvllIIod87M8g70frkfqmxUnvZN43MPcp519xdEDt9Do48wXtw6bjBixHWqQ7KS1Nhsf2654Roe49mRQcDS6byoXVankDqqpTaKcW4dAPUc1atPHsgJxYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9255.eurprd04.prod.outlook.com (2603:10a6:102:2bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Mon, 29 May
 2023 15:46:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 15:46:07 +0000
Date: Mon, 29 May 2023 18:46:03 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: enetc: use lynx_pcs_create_mdiodev()
Message-ID: <20230529154603.jmq7vn2pvrbxamha@skbuf>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2UTC-008PAx-1m@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2UTC-008PAx-1m@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: VI1PR08CA0095.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9255:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d9986d-4bb3-42af-7ec2-08db605bd16b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dr3gXUCCuH319QZBBS6XuCA67RK/kP7oXJp6nyS53630o55FnaSWqY828aAx4ij1T8eIIUJzRosLVxO6mc2rlkwKi04zTyi/BK5u8MrCi4gDsp9K877ZdOk5n9hmcVmIQFN9tZqjZbQpSrSqnS7wLBurqtwL6jX7q2KhcFr3ajjtqkhx+CPcVKBW0nTiaDtksLXUaMQ/rOJ6WvXysNakpEA5xNyXZHDyONfPiGJGknPLizgnukKHaetGHsGWG1/QWzpB7x3GzSS0iGbP/qNajyqAITovgpULDzChv5jlG/bOeQnB8zrhuwIsFaz5lPmvf9zyJxBJxd/kOSL+QoeEhHcJio9uLhe1X2jsnq0w15W+jh+MrFTBM/Jyiw99YwSTnhIgsB5LbIigiXhhVcpUoLEMapUQ8IU2kcnJZgJXMFSog5MYNN8mMkck8P/LixVTgLqP4gvSj0g9lamb3HXs5fwnlUyl+gQbEsv+FGMeI1aLAB1HkKFVJ89nZM4RTD+b0MmvKroyKTiI5nR+n+Db/139HFYVAb7J81Npas2a7Sx2b+P0WcjuVMu0qj2wVpTp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(86362001)(5660300002)(66946007)(6666004)(316002)(66556008)(66476007)(7416002)(4326008)(33716001)(41300700001)(6486002)(8676002)(38100700002)(8936002)(54906003)(2906002)(4744005)(6512007)(6506007)(9686003)(186003)(44832011)(478600001)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vxj0xzhLSTjlBURxQKMQhBBWsknJo6R5dRJxgzuf9qm50y0agjaywBS5n2hS?=
 =?us-ascii?Q?aSex8KFc8miYNMx9LqW24jtk5sKgqC0ynh6/eNUihzqzaKAYZnBc5eBZqYBe?=
 =?us-ascii?Q?lF10bTq9QrZVaW/b9P7yuKt3m6XQ9+xBVxusf2qDAt4Qh3T9Gb00tx5u/cHV?=
 =?us-ascii?Q?Cg3ZXq8JEaMVn9RkyNPIwcY4fVg/MX9F2kMBFE29JkTnjeWSPXLtIAeaNyln?=
 =?us-ascii?Q?j/aWsvMQvsiN7/jrWmsefYp/9o7knGlqRyvsC0pixFf62ydolm5Ev4Rz7qBb?=
 =?us-ascii?Q?m1uTZd7U6l0KPZvfQndO4rcimik5vtfCBvORWDUNpsz6ZX/rZz4GMcFRVRGd?=
 =?us-ascii?Q?N4diWPhb7xy6/1UXWcg8q66ZHLQ6FhEoj6mgsMgmu032LvErzbQyexutIEYc?=
 =?us-ascii?Q?x1ig7I/vs1hEfsYZpmVEqhTpJZi5WdlC1DDtFOS6N2ZUBczoSISWUb0GFvAT?=
 =?us-ascii?Q?kN6huG5mcmg0iOds1otVJ+dnIeDcEjhDbUCIwfApex1h5lkd7KUXh7pZP/x5?=
 =?us-ascii?Q?sYkLGZUgLMBX3RWoHTh21IsVjA9IGbkzSO+PgOe6ux4FNRGA8y6MkytvIC6E?=
 =?us-ascii?Q?hV2G6W2iCSBeNkvvIiquevFcxOC56X0a/MeIU90sqq1rX/RySMTUe/HklnZS?=
 =?us-ascii?Q?y+4/oVbkdcw3a3lHAUoUWlJ7m/5TR5zd7fKf4tYSy1m4GHeIqtcJm+pm5T7a?=
 =?us-ascii?Q?PM/SUoGJZZLlI9qxu2jJ9Q/HKSCb6VKGuEf2irW1LE3CdckGnYOMRiDuUlaR?=
 =?us-ascii?Q?8dwj7yyql2MF6ZMvGU+WC7yjkai8ZLpBlkcyF86oYdpZpA5aeKxVHv9Yv+mF?=
 =?us-ascii?Q?x619LnTyXEyLwhKEPL/nmM//4QoQb4j1aMRwpxQwAJQZJ3yymWHLOfkf4+oT?=
 =?us-ascii?Q?tQUpl6mgqUM9UTKCU94zVF8EfpUbfMDP57tuJ0uWY07IZo0f2s92ERPvSbe3?=
 =?us-ascii?Q?2nIAo6A8zNYx7UmBp9hPt9wSqMO/Mb4H38vwMCMWlK1dxKTdOorcuNTfVV7X?=
 =?us-ascii?Q?CaVIV4uVMhY8H5H54zXs4/ZDc2pNLoyQa1KfUkiCMqCa9eIqsR/8J5W1Qxhx?=
 =?us-ascii?Q?Vwse98XDvKCd6u+HiwYPhQVEhqmvBePAnbo5InCY5KpNjV3n5PI0IBjsetcO?=
 =?us-ascii?Q?40UU5NLCsX9M/4rc0vHDh6qo/LNVk4rSO5JZnZcZDcI8vOFwf4wxP/A/0I4Z?=
 =?us-ascii?Q?qPJbKSX2l/eFTBiMTKm4aled1TOHlKemrnhgxHrW5PKBsRwDJFqfMAFA5Dcv?=
 =?us-ascii?Q?N7emljag3dwaOYv0zPN5jd4QFqSVj1+Ohd+QJWUBFH8O2Yffo2vqyDbmE+qq?=
 =?us-ascii?Q?GayqwkxQgHHfFG1rMCMO939vYTDhu0UY7Z9CHWPEKT3uQX5qYLI/8kRr21+z?=
 =?us-ascii?Q?aU+gZgPpTOW2qfr29aJctK3mhUnQxOosPPgaQPIa78ut9IrRo1mJnBAcg1XT?=
 =?us-ascii?Q?LSFl5bare/qis1P+QpmAV1k7wkBA6E6f56106UKcnS3kkVTSF+4mu7hpnhYb?=
 =?us-ascii?Q?x/oT6MOJ+ZhRYLbGkJPCMiZmfO6Y1PHhGhaqJWsAkTgoXPplZt+ZMU1eJ2Rc?=
 =?us-ascii?Q?gBqCp0Hbii3+QO/GJM39tf/6yfNAYgYjuT5Duo8RlC555DUG7/h/D+sK5IS0?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d9986d-4bb3-42af-7ec2-08db605bd16b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 15:46:07.6153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvqvPrrUVWMTLVMCjYv8cVRgNlEyiWy1rEsxn3Q5aHdT0YgOPizXhp+RWJX651NB4nZNfVYHb8T8NTAelvK5TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9255
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:14:50AM +0100, Russell King (Oracle) wrote:
> Use the newly introduced lynx_pcs_create_mdiodev() which simplifies the
> creation and destruction of the lynx PCS.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

