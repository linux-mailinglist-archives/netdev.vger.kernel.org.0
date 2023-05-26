Return-Path: <netdev+bounces-5646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF877124F6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A84E8281800
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A15742CF;
	Fri, 26 May 2023 10:41:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EC742CA
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:11 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB67F12C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTDNA/R/yBBq7aXtIFokvO79q02UZGAkpeI7fNXN89PR9rAPwonr6n51a/4FlyKYnkhWVeEEqVa3Rz52lChm5FM+vHLUVLPAOtmKalo3hSyElPtMC723ft0kQyK/A7rBUmbUqXbsQmzsZlLgxHC5X/EiqObwrHANksQWS3Ly5T8HurotaXyzvvYeLQX206TU3Dh9M6lqFUFiU8PYwvOPgzivn2g1AN5VRcmdlROc3VIUGnjtcW5Cluntcw//DXQ70Nn9Ld6pI6tqWrS46orl7fYgRBABQ97eYWh6eht1lDx3GP+sqUEwpUmJf87G9gJiCqOfyByfB4gi5q4QxdBFmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ad+MzGLv+zyvsaH7O6EkwTvayLJSanIxW+R0DzJu/Z4=;
 b=k7sMCr2I3fRrLmxqkEM6K4Jzqeq2w4wWqpw2agAxKrF/ycq+0Wb2IPVqY5KZ9STyjaTsldPwTizpl50kbifaeIG66oTrfMgw4ijSKEElp6ub32DjhTyimnr0Uk/fN6UUvRcyhWFiDAG2XnhuGVVP2A4cke52Ap8LLGEw6dys9sEDzJMp5N+lomM5bb1cPiGJnm0ODKjxgvyqTgdh4PxKMOa3Ki+3otsg636RhwZ9WbCU6UH201tYxAYQ2CzAFbRJlWMYYXvBCnYeF/LvObdAkscOJP3DIg0LYamZQ+yKepGZvCztwIzKXazDO9vaB/4J7ywyrELDhUk9N2++rl9iEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad+MzGLv+zyvsaH7O6EkwTvayLJSanIxW+R0DzJu/Z4=;
 b=Hp39SWGkskU/Ypvj5HiKZKPxsx0AJo8KNZzPDuT5U39M3yKfIIbiU7z4jqRfaUB9J0mUN3y1xRXYJh1uiPi4nvxX1QFPKMDWAwEeTW47ZTKYNueOymhOLpNAngxpwfgvr5zI0YiLYna+9w5h91cmkILfZNb4O5r2Di2ACV2fmw0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5465.namprd13.prod.outlook.com (2603:10b6:806:230::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 10:41:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 10:41:08 +0000
Date: Fri, 26 May 2023 12:41:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net 3/3] rtnetlink: add the missing IFLA_GRO_ tb check in
 validate_linkmsg
Message-ID: <ZHCMvdQPlwccCdwo@corigine.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
 <b1fb9330f06ad743b51e50f398b1208d2fb47af6.1685051273.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1fb9330f06ad743b51e50f398b1208d2fb47af6.1685051273.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM3PR05CA0151.eurprd05.prod.outlook.com
 (2603:10a6:207:3::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5465:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dcdde71-38f6-4791-7ef4-08db5dd5b6df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XA59sm6xUWW5tmLgilyuzgCjYcpmTwODMXFdGBDbz+e1+T3jaT+0nKWDa+QneR3HgbmE1dm5Fwjiz7W2ywu5z+rQeIgMe44IdTrvb3OFqzdjr7ElUr+Oin6sz/KYNHKYcK92q3IIifVzFutiljAEgggIk1xG8YAD/xtBfoMGnCtST3y4/sMUMb5lrdPUsYxllIKA4//kW79XCND8wGcvtIzkiYSerMOonaYv96apoSENuSAgm4nx5CZ9+9Y9PPiOc9PKm6p5NXmtrfrM+vITaFdHbUY6vK3WHbbktYci4RS4kF4hvG6fiMe9WeAeMw0bnaK7uVOdmiyT0T8ttwYD6ul3DMhy9S9k7gyVnX4Lbdj9LgRdKDPqpV+Ndfaz2S5UvKA1u8w9odsWE0ekRjt+hCUqbfDd5qbSLluJmK4VAn6icBUN8qDhUiSVYYVTzAEPBXzC6wPrg3Kl4oQ3rejGEp3+CD5DrhG9eyiEnTf6pmFG9zfbeOmCeIVL7Kr8OhNi94Lnd6U/b/ywzUZp9RjOPaNlwVjKo4FzuPF9hA9T3g2AkLGc3VPwELtdK6pY0zYC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(136003)(376002)(346002)(451199021)(66946007)(6916009)(66476007)(4326008)(66556008)(36756003)(8936002)(8676002)(5660300002)(44832011)(316002)(54906003)(478600001)(6486002)(41300700001)(6666004)(38100700002)(6512007)(4744005)(186003)(2906002)(83380400001)(6506007)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XFYX7HZfy0Iq8Wae5y2cuDCZXnCd/qdU/THJal4EamWdbd6WtS74JZBPhdRJ?=
 =?us-ascii?Q?7jMPWf1THg+FxE5T6C6HBhn4kHa1he/rwEzV3iVIw4/iHMzOd0OEQ8dlSDpY?=
 =?us-ascii?Q?M8Dk1zyqtPqmpXLcRF0MhcQIyBs/4X0SVjdOHqgVHk9cxuovGfjNJ/HnV7BN?=
 =?us-ascii?Q?JpaExK53n/tRn6L7oLJpSE+0l91cTuKW2Yrd8VXuM5FXQywm/4QgUy9cYhh3?=
 =?us-ascii?Q?x5MKAioNTVX8lSU045E/lG1do2s7V6hTD650QwZqhkqQPIWxLU/8/p8fWeQM?=
 =?us-ascii?Q?UB8rBnsTUtX3jHDpVtzhk1Xpcbv43NY8ZspxciPj0L4vXG4v504Rdp+wu2xa?=
 =?us-ascii?Q?+SQgZnpuz8WEm5NwZ0EoLTmfv9El1TygHhQlbKHd/3+ILeyUzAt5Jv4ONeH5?=
 =?us-ascii?Q?Q0yUc2Es3GGvTYDXdVpwKJDdfmErIEsNwRJRhtjhyBPqc17Vy//1QIL9TYj5?=
 =?us-ascii?Q?qhJZ3ZXzxNKw8Cf+Yy84PtaPHTujTOi38Ps8rs2T7/aFhgBlEsFuO9Mg5CkQ?=
 =?us-ascii?Q?VEyEntVElGFWPjcIPkTGutmVI+ED8tSqrlaRn/B0gZkgPhTlTQ+Tm7CTr7ll?=
 =?us-ascii?Q?YGT+tH1qELk1cYW0WLRhICQqG+l0+thEzgG6U1U88vlAcJ1ww0R0SsO/mkLb?=
 =?us-ascii?Q?ljDVlmvdA18QECS1WEp4hFYZxFRzhnq95nL6Hg1aOz6YFZGpAVaWmtvt1lCj?=
 =?us-ascii?Q?rO/bEFcna0rzW7NuhPX15z3ujfI9/apGAt9wLibR+53qhTdroYt4I3xs3616?=
 =?us-ascii?Q?ZFf6Q3+XoNwXLynQtcOKZtAYQN8Iu93LTZRDErDVWIwzh/Jqqvb57GtTAjbb?=
 =?us-ascii?Q?06MqOkh+6mmj4ctyVAhAyuKZDzQd6hGAHyulzbU05RE3ZggZl4//mzdC1IEc?=
 =?us-ascii?Q?5ZlveJAVLuzKoSO5A8JDdM/KcEx0pniUcJ7HmdiMFccUSSpr+WeylD6A/2LS?=
 =?us-ascii?Q?A2C3LkYMbM+MfLivIe2NMHXc9AvABIwwPGSg2VnUebIw9RiD2KIjBxbAejye?=
 =?us-ascii?Q?2XtYndfANTOcxp1ttwbxCX0BsVpG9hj2WN8lbFZXX5OOEfmCxJlKM9Xlnukp?=
 =?us-ascii?Q?ocuNZ1TMPysF4+uYyXWd9wnofk8HmzLWLCu9Jox1a4ySguRbe6R/CYiyK615?=
 =?us-ascii?Q?eiU1Ben3H76wcA/dL4GR8wfEx2tQY6qMZDoq/9ZY0dtLfhpeLL+NIwCX7la9?=
 =?us-ascii?Q?nrDFGoA52PE80IKie7ZgcSSHMCp5420Il+5MDPyENxZcWPAv8Hu7rT3QxuqK?=
 =?us-ascii?Q?S6hOxfYGWZ1uzVsFTuZ8hyuPlW/Drd35IFj7RExuUxPPPGmNX0IO/xrIPFoA?=
 =?us-ascii?Q?Wq6bglwbMDEnM7+v6WJJtmeb+IaF55PtPqzkxw9EyYTyaDwpAG4+MQ5yniQa?=
 =?us-ascii?Q?bUR0TQOzRleL6Uk1Nebpkg4PXjLOVdxb4esGZDAgO4pH4hqyJQwiryOb04KB?=
 =?us-ascii?Q?AD+RuKlAOlOkjQUmkvUdAtWmVsUpygPlQbdom4SmF8QBr8pmIxh8yYekzqtb?=
 =?us-ascii?Q?te1Ptb9gdt2OwIeZHmKta6v8V9pmhdBHQDo1eUGMltpcWY8/V9CxKErqJpjT?=
 =?us-ascii?Q?0LIplD9d65W8mA3XdJnjNcYARrQK6FKbkocyIc8U7SpBO9TCSr3TRi6whDP5?=
 =?us-ascii?Q?0u2LY1kdQts2ZyCL5wOVImYi//5HgMrJjvU8GvXpfV9uiyUWN0REafB3VwC6?=
 =?us-ascii?Q?PyDpIQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcdde71-38f6-4791-7ef4-08db5dd5b6df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 10:41:08.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OC1A8PW895XiMgnVRT0zAkzVtgDM0iv4H9HPbZSU+49JALyq6PbmIVtLfeIfMCNU+xJpMYFd4xd4P49Cq1CO1GQfH1qlIzioOG1ovMtB7So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5465
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 05:49:17PM -0400, Xin Long wrote:
> This fixes the issue that dev gro_max_size and gso_ipv4_max_size
> can be set to a huge value:
> 
>   # ip link add dummy1 type dummy
>   # ip link set dummy1 gro_max_size 4294967295
>   # ip -d link show dummy1 |grep gro_max_size
>     dummy addrgenmode eui64 ... gro_max_size 4294967295
> 
> Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
> Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


