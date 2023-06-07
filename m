Return-Path: <netdev+bounces-8919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51ACB7264BB
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:34:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A863281383
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDEA370CD;
	Wed,  7 Jun 2023 15:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BCC14AA5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:34:09 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2050.outbound.protection.outlook.com [40.107.20.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11826EA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6vFVs9p9TI5h4edjOVISd9Skfl9vZvtqIb53KcG2CvRgq4njeL7xFawslbxTJtYZT+diLACZPHk1kX4nE54O1MquAPwdtg6V4Ycl0KnHRp4SXN5PLxx+evTzTlFt1x05A4UCLTL3b8dIVXiVA+uAH2vlcGWVgfeUVRZzac5s9Nll+jonm3fncSApukM6fPQHMIe3I/Z7LAydicqYM9fLIgNOkoKbR74BK5+kqjpqydNajkP6UuhCj7O4lyU7bnMoM1JQYjsyk6gRkYqoAMDREhdm/Kqrtl+AxrfPVkEOP1rYc9cYkPqQX/E1eptLP4PBNIstEdLkKgqh/nJJIIXmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=udiO2jc0S2ipsy7Tmv/8Jg1smfkm6TN/ZQ//6dUgo+k=;
 b=KGWpqGidwtIWXE0ytz52gNfyPzPZ5vW4xFRnY82KipGSfDb7CVtYx8ZB0vkWboUDsZe4FM4wVe2/0hmj/PeyvXuvGN+fYmJudviWwpeSgKdsD1KvuMVOoXGa1Yrg9sx1eBe18ZyBqeofDbPKo8JAzNG1AT8Aevw2Hv7N8g9j62x+aeJvfWaOtfIBTjZoMtwXX3vRk3ExJI23AaIcTLT4iz78emoUBH/wcLFCqB5XUls6dUxveLqttkVPmq1hqV+PECyEbpSwrepuazpiC4WsHVH7PL9+nqQfKzhaI8zJcqfV2IXHby8fvybw62Fc8nNwIZiWYlp5+ui9TYr29Q1m4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udiO2jc0S2ipsy7Tmv/8Jg1smfkm6TN/ZQ//6dUgo+k=;
 b=dKfLSeBhvaYlzApJf4z1lrQTCPXzUSNMmWYBAEuA8MTc4782FK8M1sror4dXnwDgNe8vptITiqxCyuh7kTkHPeL3oy9D7msTtnE3M8XlfuZdLJdpHZRfOOzPQAnbCZBsozAJebq4jWwMrCH73Yg0TCmlNjWV8/qn6c/KXyMJNok=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8261.eurprd04.prod.outlook.com (2603:10a6:20b:3b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 15:34:01 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 15:34:01 +0000
Date: Wed, 7 Jun 2023 18:33:57 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] tc/taprio: print the offload xstats
Message-ID: <20230607153357.mqbgu46notm4ujpq@skbuf>
References: <20230607125441.3819767-1-vladimir.oltean@nxp.com>
 <20230607081335.7b799b9c@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607081335.7b799b9c@hermes.local>
X-ClientProxiedBy: VI1PR09CA0144.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c1ea87-9776-4b92-ae02-08db676c9e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WlmXxS1TRxbtunH87HJitsxDHASeBIz6orK0WuTYWC1z+iq6UWijI+u3xMrVwcIPR8HyCEDKkbYhLnot/F4LRF7E2CQFvhdk/KI7dhcgr/EI9mUL0bKwTwxViVr1bBxIBMgwQnA1g43H8rrKkkM4+7669UZfEwHofYVl9O6WvD88irMv41Kq85Xgfx2Po0QZa9+RaL6/NBQh+ERtF+GN/gypppyOWVV6aHnfA5CpXBpSKlwsyTo7Dp+VydK/+/EONF24TiShZUG7tf/Ly/U6LS9FQpwWreLk6s3jp91FMDex9329W5SoWvCnJEuJySDz1jmNsbcOEOFH/3WIAUyGdD4tl1OKq9qqBQi1jylCLGv+Y4zqNAxUKdS7T85H4arMWJ8zKQq8SYUUhJPrK1Xxi7soHp/84EgX7OiekMqwc+8ljPWMOQ1ff3NJDRIc4FVczFOsCqjukcWp3TAvrbCTuy7p5Q24Ta+bULHONCjm4K3pHK4GsArmBjONX3BzgTGfhWSrtHEhgYLhnAoGPAcj7mFe4ZeSXqWlbXWj6TKgWBhN1iHJsR1kArMExrzhgG2J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(33716001)(1076003)(26005)(6512007)(186003)(41300700001)(5660300002)(6506007)(9686003)(44832011)(316002)(4326008)(66556008)(6666004)(66946007)(66476007)(8676002)(8936002)(478600001)(6916009)(86362001)(4744005)(2906002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YbWrtrTK86uHqH4zMAo50yp9rppazkqSvxkdCzCmSdCVArQrTzLGPiMQeffp?=
 =?us-ascii?Q?gtZO8KxTYqkOgMleep/n5dedP1Wr53EUUOCkgrFPtAdB5/LXFoWwmVvns00c?=
 =?us-ascii?Q?AQk5J0nPOwVgGUV9H5cwawwQ2HUNbUkUIirvTpADFgMosG/P0ctqhlta6oqf?=
 =?us-ascii?Q?xKn+b/RBqigc+Q1GowTG4SKp1zKHslAv0kInSV6Xar1aufTomoxokkwwdU2G?=
 =?us-ascii?Q?5+QWGgq1npyl3JQ+Jf8qVsCZEY91T57zcHdO22RN+dUkHI1CQ3Xj/QAdQYAl?=
 =?us-ascii?Q?cHI5viMDwT+PHtjyXxbJtT2KH9Mjx/VyUgsn1WjZrKnfHwMWliI7+plTxSB7?=
 =?us-ascii?Q?HzTxVXXO0W9AGROGp5GSgTGqwK5U+wL+TLJlnSCpvE+Dc668oltdDfeYxj0h?=
 =?us-ascii?Q?u0sSqK6zNznjfJrBY5cvpJTw29nGMaMeWRJ+KpaBlYG94FQUkm5HEtj29TBK?=
 =?us-ascii?Q?l3UZ253tiQSWdrmkSkd45cnjDGqqpBAHw2lDOnf/ttQ3JktzNxETRJQyUtID?=
 =?us-ascii?Q?Z+6I8U7B6JDFd6E8mTI3jXyvv4Pi4ApA52rEoL3vzp+sZODNrYdX66obeDfh?=
 =?us-ascii?Q?Hm5O+K2EMlo/mjcG2yXAnISfhsxHfak7GvSn9i6ZX6cOOsRBQ+HOP3d4ODGN?=
 =?us-ascii?Q?JfjhSZsluX1e6iR9zMXrzskWjwxfnMt6RFZzd3hMQBkZ75jRR1YnHutrB6SP?=
 =?us-ascii?Q?DC1iv+wog9JU6NhZnfwj9qUsdea2B5AHL6FvfX6Hdlaql6n1QOD/rmA/m/fX?=
 =?us-ascii?Q?mTsrcYL/ML8Sx922RoT1NDXet3LSY/636Oe4JbtNOVKbJSLPz2/3ohdtlFA3?=
 =?us-ascii?Q?ZzpIdGu1OaLTtq0mOcKmJZ+ZA68BE7u7xWxpIjtqoYuyqz7QRIFJ4Pji7sKq?=
 =?us-ascii?Q?tB/8V2+UkXDhiS/U9vNZ27iL5GRBiRJ3AHZvmko1oJQaktDz9SmXt4k5qtg2?=
 =?us-ascii?Q?mmXAlnsdDJ5UgUJEmOXeiF0xyYh1vCd8StbBGfC6D7AO8fc6TLIUzIKfDIkP?=
 =?us-ascii?Q?NmpTxjFGIz3Ca1xx9xgex21ygLcc02m0ZFNHToajwmKYfE/NSzfg8yWuU2vg?=
 =?us-ascii?Q?WHCkOek8Uhgp5szy51K9aIsi3Mvht0bwdNk8pBriWTqkCgz7QU6GWS4Yg2TQ?=
 =?us-ascii?Q?GlFhICU4Ntr7A1D7l+jSlEovEzJdGzUBw4w3hhqB16i6sIDMQfB8qtvdRx7m?=
 =?us-ascii?Q?uJROQcj+fW6LDdPVVOalAAznaH0jtJ2gXEXHMbYu0u9BcpMjAwJOidTfYBGW?=
 =?us-ascii?Q?g8Ae/Q5J4PRZlPPhaswNiW8DJ2O65AitI9ensYq9M6xqH/71iGmJI93jEf0b?=
 =?us-ascii?Q?7iF74S6QN3ePsSirNwk+/eVn2R8vL1XuA40JhQ2Hz9m+OsuV7zFm6rGs1ahB?=
 =?us-ascii?Q?yhaw1qaZSS0BPgFSpTuwleUh1Yl+AYZb6tVyi8/NMYvrMqLLDTHTzoisSa7s?=
 =?us-ascii?Q?qBb7BmqlzFcAw3f/gi+zF9DBntIqheo3x2qSK8zaUlEhoOAfe1fiOInStKUO?=
 =?us-ascii?Q?YPNDRM5A8ohXb/+nqI9UY5QvQjS/WdMlE8gTHIleguqft56hZGEaQ37GJrD7?=
 =?us-ascii?Q?9d8/azWNEP7Rm1dJZruRxZ62fV1DnLwRswtSV12tagbg6g6A8+VCEs6ol2Go?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c1ea87-9776-4b92-ae02-08db676c9e10
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:34:01.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrxDQ8jIUjAzhgHd9j3SqNiUkp3CHhv82VRCDjmQ4hjivS8UYIQR/y4ree8Ed660bNhyfAb701SweHqC9VC1Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 08:13:35AM -0700, Stephen Hemminger wrote:
> Ok, but the choice of wording here is off. It makes taprio stats different
> in style than other qdisc. The convention in other qdisc is not to use upper case,
> and use a one word key.
> 
> In other words, not "window-drops", " Window drops: %llu" but instead
>       "window_drops", " window_drops %llu",

Ok. v2 coming.

