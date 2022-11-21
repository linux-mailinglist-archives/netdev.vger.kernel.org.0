Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF51632DED
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiKUU24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiKUU2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:28:55 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80085.outbound.protection.outlook.com [40.107.8.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204DC72D1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:28:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgWl8Wyz/cRGMnT11BFP571zB8w5I8CPMKvRnnmvGis1Vr/S/04vpwKxqOfvgQKhuBkC9xZgxKd3bk2YwiwIsZZ0p9zNSDPqBwMmhr1wsm2vPETE9xcbdn+rnJIPbzC70HUeGs4PuUng7NZe+xkfh37S1JHTenSTaLR0llZyK6SGZcMzKfpF3sbuOv3BYgdnLr3gFXc5rt8LKf6wgSk8LFJDc/6LBtux0UbH4daxw4JtaJ8O2WF+mxJI4CU9eEZXp9W5Y2kz/RZp3cxEH+G5GVlCSio5EDiCuFLGeMsgbBzRwlXOBzBean629PJXgtXQsNpiAXj07EzJX29IpGdOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcHdFh7Ab6Yn+Tnxm55q5y+s6hIKvaqr2To3lLavjNM=;
 b=jnq9iw1/QsCFIb7LqXNxsufolVD6jJrNUbFPRp59hEZ1NmrJUYzwBTj9a/45wHKW/cRUpYlVTtOkNAKjqE7pd4dToojdPq514c/uNzIE0z7u3hC+rUkJJohbZWU+47Gn1yKeFufiEr8tvEHnlzYU44nyZNnrQlHcwB8eT6uOQyg6tUgADou2ke5QdujmjMsl7sbwTYCs+A/3Tl+nH0PKbwvb98XHpIvlL7X5efn642oPf4ukoMYtdah3UfeW19XxfbPyuhkjrFOy0vv++yc/F582s+pV8W0BnDHN0UMRQBWbFQDWkKAbNn0pUzf72oinIsA/A7S0Lakw9z9tyDXiHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcHdFh7Ab6Yn+Tnxm55q5y+s6hIKvaqr2To3lLavjNM=;
 b=iymsKaLqadSWwb7qSpX4rJowkHtGUOm+h/Lt2wvYbe/pQYiSNMLedr64c93wRupyfVcGURvf1U6g+DdXXbWiasGuqCkG6DoehCrjl3+g5asYdxHWd/n8lyOhtX6W+Knfc8F1uwRK1xhaYww9lQJcVRO1nXWBUzxpzG/b7n3zmXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB7107.eurprd04.prod.outlook.com (2603:10a6:208:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 20:28:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 20:28:51 +0000
Date:   Mon, 21 Nov 2022 22:28:48 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 00/17] Remove dsa_priv.h
Message-ID: <20221121202848.mrtvv6a27qq5ftv6@skbuf>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <260e9aa4-cc62-7cb9-f899-a30c1e802868@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <260e9aa4-cc62-7cb9-f899-a30c1e802868@gmail.com>
X-ClientProxiedBy: AM3PR07CA0096.eurprd07.prod.outlook.com
 (2603:10a6:207:6::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM0PR04MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: a767de01-5557-406e-ac1b-08dacbff007e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTRrcsj7jBQpi8Fe8LGULR1xStFlkDT8LQZhk2L/cyjfaamrReC1SL1PdFeFVQv2AYQ4ICH8kImbRx2tPP65fD45FjLMpcFCZ5P/v4OJdHgjEPziJhOjsfusTz6goPq7TC6e0xy/HqrK0k6RTnNlcOPnpXCDmfdWUiu4Ba0ZblOimYXAJmJjd/9CB6oHWoH8ixpX+iRiwdlgTs1HamRSzuucAozAu1Ps/tVLNv+4Ex3nmWc4fEODhL94fSf4PoPzIbMQpIAS70gVUm9u02UnbVHKvUfSn7pYUWXOpBBTE7tkdffQ8hmRGGKB3mLSIJPjIPZ14A9IogzTYFB3rFGjJAeZ9+FyyTpv1r1aGBnlnfwWpW0pGxQ6WUqFMR5JpIJoC8ZAvXKvSVEIrNJwpzgYpO9fBxtfYjhtV+Zjp6hEV5AcjBqVN20qnheGfPEoupoA+Zzpur6gHbJUWGFMeA9OLJg39jeqB2Hb8sGxFDvE36+tS7oAdIhs373bJdoBCMw0yCOhMCD1dsCOx0yS9T/sSjXfU2qhss8ho4Arc1o457vgWR8iJUibLDhb/mmMOjzh0Uzrax2m2gBU+tqjVhRIAYV54gAqqAw9L688zYF4oWM6FW0XTPNiD6ZM4eTq+A7ydjRRz0ZztqxBNLnB40n6yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(26005)(54906003)(2906002)(6916009)(316002)(8936002)(186003)(66556008)(4326008)(66476007)(66946007)(5660300002)(6512007)(8676002)(33716001)(41300700001)(9686003)(1076003)(6486002)(86362001)(478600001)(38100700002)(44832011)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZsOv9GN706o0Hz1igZ6lEqCwpBYac6Kw1oBOec0VRUosOSYNbW+4Y1VyXHFy?=
 =?us-ascii?Q?ChdWYYeNDRcK5km1EgWDxp+tfiWRHmfhoOo+nBhm9jbYIkgS07GEh/Hq7aqx?=
 =?us-ascii?Q?CE2vV0h3FhGSWFL3ZqYua1lK9hyD7dbLulyxS7mhX5gN5NH8pcZbQrxO+Gdl?=
 =?us-ascii?Q?d28wmeTG6zQYsS22KlxDAUBGWLcLXqTKRnA+lZD3KsbYw3iZHLJ7ZMIIN0tO?=
 =?us-ascii?Q?OsMq41YRooAfPPDUR/MSF3bce+HRDfbtRndkGmE3DICnOgrO7df3EkBodXWC?=
 =?us-ascii?Q?cLFmcvgZbSLOTxHTvMMHhtH/I2YAhWKK7CQ16v6fySDOvLQMELUBzaWKqBks?=
 =?us-ascii?Q?XKfdfJFkZjhCf8k45DYUtFwWSPdgiHo1AwLRpDtjpGSfhPu/MJUWYg2OHzqr?=
 =?us-ascii?Q?QxB6EQskV6vOUoPOpPoehCJSHYJD/nTz4lSZ5+/ZJilxrHd5WA9lAwe9pccx?=
 =?us-ascii?Q?Oy8zZDBr17BUJNj/acEvoKfRW+jMQylFkRxwzSKeIZYCsyBzFFww61AlnySt?=
 =?us-ascii?Q?CMq0FvrKZrbbkbBuGVTyNH1MVxkbZmW43RcLpKechFzEsmGcF9cRaTvMs08Y?=
 =?us-ascii?Q?7z9wfBoiz4fUiljMwtklIj/ENpHs98boCfmyqDihdApwuaYf3f3tz5xJq6YG?=
 =?us-ascii?Q?n1V4X2eZVYb+PMUlZp9FAJjjhzIfGFY3/ftli8BEYnuF+o6DIgZLOsyjC2P2?=
 =?us-ascii?Q?HxDF1hLCqVAyv53CwKVVcaDyIR20aMP4qTXvLg7hpAWT0IOl0jCwuvO81psm?=
 =?us-ascii?Q?jZFWlSFmUGUYH5Pzkg6eTe/cHLn1N06IQJwTZbU58I3Ayo3J3VFudBhzMiE5?=
 =?us-ascii?Q?wlNDg0GYoSIwN2adz2iWkZL13/ZrVlux0GqsFscl+RKTxgdSYAQ6M6pd1XXp?=
 =?us-ascii?Q?k6xG5iArzkexia21xiU9DfmiSV+xYYiPoPfnDemTQ623BA6KR/yw1pex7ZEN?=
 =?us-ascii?Q?zWnlqB+Vkvp9r9NmX1rfqjYtmRV6mSQw0rwEv4EJNe4RByT/N4JK9UGO1FeQ?=
 =?us-ascii?Q?eUuarMW2f2BDUybujwHw5G1Xf3q0RMRBQRrcSpZnakcLKHBvkVg9+5sFUlwe?=
 =?us-ascii?Q?gQn445PVA8/xGbPdSxnCl6o+TWDcVAHfEq7Uu+kLL/Sy8qix82b6bhGjuvsm?=
 =?us-ascii?Q?jCuqWsnGdZlZgGrORdFoKvTSgOmTye1RS6ya3yhYESzRyBTEhP/zKS496kaY?=
 =?us-ascii?Q?d4mOUI+jSI7WLdQtbv5cMmTYnP/vOVY2frYsaM5BxV98HMN6a0U0Ms7rt/RW?=
 =?us-ascii?Q?LcKVdxDz2gcDw2/xSDpcTkGmoPWKV+KtDVbgIfOrslMf8J1dbrPMcGbXM23M?=
 =?us-ascii?Q?TzAAnRoUc5KIHEiGiKZOHMugefY72q8vtd/mUCrrP8s7/aceVgwrq6bNYlSD?=
 =?us-ascii?Q?zq4PMo4WTckLunW1QpCJoVqW3jc4tmf4wUmdi/OawMjACtv+345Kg/ftoMwK?=
 =?us-ascii?Q?xpct7M9CTxPtamxSsZffU2K+Y5RWE8l5nZkddvfKZQkwWnK6loDTl/0IRTQ2?=
 =?us-ascii?Q?Y5s++uvvLFDfT1iDz2Xx2zufUa6Vwv/eb7Ll5PNFeuI92YEQDzqZ55aIF7p7?=
 =?us-ascii?Q?+AoyZIL0q1VvYd1xqL+hVN+Umev1T/6Y7YMVXMRqmh7M/btx0YPh6ItKqlDw?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a767de01-5557-406e-ac1b-08dacbff007e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 20:28:51.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGntqg5ulF7gP+uZKY33M7dVu+dCxT40VLnJbK4Hb2LKn3OET10DcBDfX4vruuqONDwlHlwlHfw3++sfCQyAdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7107
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 11:16:07AM -0800, Florian Fainelli wrote:
> This all looks fine on paper, only concern is that it will make our lives so
> much more miserable for back porting fixes into older kernels, if you are
> fine with that as a co-maintainer, then so am I.
> 
> That argument could always be used to make zero re-structuring and it would
> be sad for DSA to ossify, so obviously should not be the major reason for
> not making changes.

I think the opposite of restructuring is not ossification as you say,
but rather disorganized growth which will become even harder to
disentangle later on.

The next step (at some point) is going to be reorganization of what gets
exported to include/net/dsa.h and how, since to me, there's already a
worrying amount of uncontrolled information being scavenged by certain
DSA master drivers, even if the intended recipient for that header is
switch drivers. I didn't start with include/net/dsa.h because, well,
I think first you need to make your own bed before you rule the world,
but in general, what is here can be seen only a small piece of what's to
come.

I'm not sure what to say about backports.. it doesn't scare me too much.
Maybe that's also the lack of experience speaking.
