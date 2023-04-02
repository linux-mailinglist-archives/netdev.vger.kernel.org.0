Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DBD6D3953
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjDBQ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDBQ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:57:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B2AE3B7
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV64kh66cX0zO7m/JWOYo+sPuKGboUT63UphqNyw3PYwuJ7ijgd0H0OR1N3qmsJJUr96xmg98E9ULk7lQ7xlazDD4/N6Fuu4AVAh84WF/vwgnZLeDJpwAyxUW44Ru3zWPPGBry74iI3F3pW/dJdup4BPEINGinM7olePcld+9CV3I+IRQhZ375PDMMAUAWDCg9SnkTJ4n9yEniWnxRAriQ2FmCEHx2hLZoA3h9SLnhmwAZjFWO1eqVHIfQfGisYjRnNTrobyQZeawYalHeV8uRbYF/FrX4q9ApoHfeuaoli1PMSEpbqBuNJc6Eykg7VxjFujTcH2gAcc9P9IWFAnOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1XDCmy5bEgahdHZZ5KWnp3q8Hrilk3kk+aDeYGkGR4=;
 b=O5xrVMwrsWxC15Tk5MYQj7pzdUzWJv4ybiTbIUb1VOslVG1+5olY8UKKcDPlHnVzghMT4frURECjvwo0InmpiZNY/4f1XU+tXGDU8FmYUPLMUhj9UiGIWA8qM40hvNIkfEJwXnZD5f5qO7WjiQy/9HYnf9hTEhNGo0iXBkM2TSbBnPO3lBJ5NptToaYZaiFMsa1PiPIR5KvppSsSrCTc+tb6+lochBeq1mopipgLDJP3BCXLXe1FVqeFS9+NR5CiHQNhIPz353X6qRjOTPtFco7/a34FOve7f2HediACISsg51ahowaxokF+/K2cTPygETSIaeBkXEo/8UqtSDXd2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1XDCmy5bEgahdHZZ5KWnp3q8Hrilk3kk+aDeYGkGR4=;
 b=bmbEfu7/PdIA18o2JDHtba8cQHZn/nnkqK8sUC6Sjljysslm72LDpo82H/d688KPaW3EPhQ73vklnC27TKejAf4CyViDu1+YEv1eFaDDLkgoVR/JwPKmJx0JHx3FJXMNo2uDVYbTgwjmF0KqYk3AeiVCt4+ecPX34SEs84oXM4c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8993.eurprd04.prod.outlook.com (2603:10a6:20b:42c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Sun, 2 Apr
 2023 16:57:00 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 16:57:00 +0000
Date:   Sun, 2 Apr 2023 19:56:56 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230402165656.h5v43cnxdsctkire@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org>
 <20230401191215.tvveoi3lkawgg6g4@skbuf>
 <20230401122450.0fd88313@kernel.org>
 <20230401201818.bxitvurfirsl6rpg@skbuf>
 <CAP5jrPGtdTxt4UOg+pst2q0bxqwZgknO9V2sP4umh9G4PcPebg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP5jrPGtdTxt4UOg+pst2q0bxqwZgknO9V2sP4umh9G4PcPebg@mail.gmail.com>
X-ClientProxiedBy: FR3P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8993:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f40ee9-5996-4bf0-0300-08db339b4663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMGgBq6e+5mlH2e694eiwz/Z9N1WKMeSzSHzdFm7NTG1PGfUYFQKQLwVCqdt1BEPgIdwlK/h22wZoPYYAZwr3ovNtUCDGfh9Bxx6k92Wrxm1Pf4DoUtSmdQnL3dh7QCgl39K+v5hRApV6lMiKX0/Nma7m02ol274g5wSvpaFlmguW3lBEwJqstJefHrBxVPWMTuGJXqa7wQ63UgL8mi+M0On7k4Cv6CxbimmC/ikcpfvzhKS1/rb4KG3bSAsLjlsRAuD+IDK0SwZhd0R5/HjJU4crRqSKZDZtZ5XPUIuFi3NHm7fLcwpFD7ztjBds7hcev5eZ0yQFGgpryzAgtAeHTgcnZGCq86iEUekYA7TGV4NM/ZH3nRlyUqI2eeH9rB98d5XTwfHzGGZf20sGEVJKQ3XyBz49xlnKEmhNJIgeOfATcHh09tH0pS6SFFvQq90OPacGFGEpYq8FQsoZa6PnZrPxqXDas0IEBXn8avMqgQO5X2fh67K91qCvrms0vU0UwoHSJKmio0sFPV4orKfcEMUxxJIUcYOgBYR423OD/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(8936002)(44832011)(5660300002)(41300700001)(38100700002)(53546011)(186003)(966005)(6486002)(6666004)(9686003)(6512007)(6506007)(1076003)(26005)(86362001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFVab2xlUFVkbDdMYUFrV1ZjenZoak4zS0NIWk1mZlNtNGh4dC9SNDZITTQx?=
 =?utf-8?B?S2NxU1lhbTQyaWhzMUtQL2RFQUg1Mjcrbmh1OW5waEJVcTFEdnl2MklqaGlr?=
 =?utf-8?B?K29ZN0p3cU9XTWdCVjFYYTgzZ2Z1VlN3Q3VUMDY2SUczcEVVZjMycTd1b3F4?=
 =?utf-8?B?TDlNa3gzajBZWmRjVGtYTDJjSFdCeVN5c3k3Nlc3aTlDc3pDRy82K2ppbU5J?=
 =?utf-8?B?S1NxT3E4RHY3aFcxWnVrbmphQnJyTUVSOGwzQWI2aXhUMUNkNjV2TXphbGQv?=
 =?utf-8?B?WHJrenpPaEhRUUhINmloYmVxWTNPN1VSVXA1REl3YTk0dCtBSjhtaWVFRTJ1?=
 =?utf-8?B?YkZKcEFacEpNaC9VRHpuMnpHSkdnbEp4dHJEWE9TMTFzaVhIYkR0THFVWVh2?=
 =?utf-8?B?bHpDcTgwYnBYTDU0NE5lRUZuWW9SMm5HMFRjUjBmbnYwTXNNSitUN1c2My84?=
 =?utf-8?B?c1RkRTZqSTc2YmhZRkFjc2xGdCtpY3E2ZGVDMGhycEFIYm83ZXZ4K0lDbjRs?=
 =?utf-8?B?bUU3MmNIUEtPcE1uUXd3a3BiVHp4bmNIQmdLNDNlcVFZdE03M1UzekI5SUtw?=
 =?utf-8?B?Z2o5dGYyTDVIVmEzcThNUldyZjJ6azRacjZ0SWZJZ3dSUUswYnMzNngwNDU2?=
 =?utf-8?B?Wm5zeHV0bGNJaExkVEx0OVVPYi9Ld1loLzNRcnBoL3B6SWJTcVMwbWhveENX?=
 =?utf-8?B?UWpoNHZINHkyYVdqUzRBNzh2dnR4QjBFZFRseVpEWVZWWFYwT1VYSk10eU1C?=
 =?utf-8?B?OGdIaG4vYXM3bFJINXZnRTUyKzVEcFRCVDc4TXVMZnQ5azlJUUtSNmhrY09h?=
 =?utf-8?B?ZVlDRkp6UjgzeFB2Y0lScmIxdnhpc3dvbGhpbSttaGt2M3JIN1BuMHBKQWg1?=
 =?utf-8?B?Q3RSOFFaNld0TlBjaDMvbEZ2L29qbWtsV3phb05wU3E5MjhQWlRGTnV3TWNX?=
 =?utf-8?B?Umh3dTlHRDc2OXoyUVgwVlJ1U3lSQmdFOTRxaE12NkNBMVpJSDJBMCsycmVt?=
 =?utf-8?B?Z3N0SldDRFJpOTNnWlk4cG1OTjRRYW9CWVNZV3RLY1NBd2cwNU1xcnNTb2lB?=
 =?utf-8?B?RnVTemJnWStjUkJzaEt0RU80SlBjNVZaWjRQR1dUbzZ5OGJjc0tCMTk1eFYw?=
 =?utf-8?B?NkhObDhQVmxiUzY4VVBFWDJxZUJyN2M2RjM4cHN1QjduQTU3SWZJVWh6SXdS?=
 =?utf-8?B?VkpKTEprMU8yYmtXNDEzWHV0a0J6a1FKcUE1Tk8xY09LU2ZoUFJZYnZGMy9i?=
 =?utf-8?B?Tmg2YzlseXR4MGNHYjdUR0V4enVhdjZFR0pMZmNxbzNXcmN1QmpIVEVpRXBD?=
 =?utf-8?B?Qks1VFVqbi83UWdWTVBwY0hNTlNDa0FrRThFVWZKVEJrTVlXeHBseVF2RzZn?=
 =?utf-8?B?Qkl6c3Z2L2VHUDZOZlZHZ1lDRFBmWHFlMTUxd1RRbkFIcVByUDc5Z05VV0g4?=
 =?utf-8?B?OTQ1WHlMaytORWo3b0JGOUFTOGhOYmd6SEgyQTYvcXhZSFpiWStsODRwWjlP?=
 =?utf-8?B?WG9BTTJxZDhUYjJrS3pZaE93M1JvelRhYXhUWnFndWpoRVJOczV1NW5zd3lV?=
 =?utf-8?B?MXJYTTJMcWV0WkZHUFNXL2xMdjlYTGxkczRZOE9MY3hIWFVpU2h3aDlWNDdl?=
 =?utf-8?B?ajZuSjVsTjRFUnpMMjlNeTltcE56aVBqb2toV0hkSWFVdnZ6YXVMclpTZXdW?=
 =?utf-8?B?RThlaG45cklhK3pqMnkxMW9xYk9uNHdMK1BPdk82ZmtvclZnZEp0RGpuSUdt?=
 =?utf-8?B?Y2xKUnFjOTdJUndUMXhMeUcwZW9SRlhCWE4yQ3E5Tk1mMzN6VVA2cEl0SE96?=
 =?utf-8?B?UDhDN0FMcmtENzBoRlhlTDVkb3lCaDgzZ0ZKUzFsMFhEUEtWc0JJUHNCWVF3?=
 =?utf-8?B?ZW1nSUJlYnJCVUdjUDNyZXFUN1pVQmhwQzdPSmVUbHh0VURkYzkwelNjM2dM?=
 =?utf-8?B?RmxWbndIc1o0TW9odEI2TFJWcTU4YTFKQ0FCMkVuTFZoZ29laWZ5S3NyaFhk?=
 =?utf-8?B?SnZaRkNUcnNXeDVHMkpOaFl4NGt4U1A5c29LTFZJK1lObDhTUnlZVVZWVFY3?=
 =?utf-8?B?bktFMGw2ZzRJcG5UUEZNN0tza3lhdU5wYmtnYkxFNzljcE5kZUQ1aWtLRldT?=
 =?utf-8?B?ZU9pQXBseGJCTjZNRC9DOTE2K0RsdlRSQWRLa3l6NmRlUzFnN0VRUDJGc2d3?=
 =?utf-8?B?Y0E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f40ee9-5996-4bf0-0300-08db339b4663
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:56:59.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Mmh1gguTglFilMC2O3/vXqTqJjW48YtuZ9TomfbeY6LuVVj57oXwCdIwM8aebT91+BXqznPj6ErGGn6LKMXrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8993
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 08:28:08AM -0600, Max Georgiev wrote:
> On Sat, Apr 1, 2023 at 2:18 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >
> > On Sat, Apr 01, 2023 at 12:24:50PM -0700, Jakub Kicinski wrote:
> > > It should be relatively easy to plumb both the ifr and the in-kernel
> > > config thru all the DSA APIs and have it call the right helper, too,
> > > tho? SMOC?
> >
> > Sorry, this does not compute.
> >
> > "Plumbing the in-kernel config thru all the DSA APIs" would be the
> > netdev notifier that I proposed one year ago. I just need you to say
> > "yes, sounds ok, let's see how that looks with last year's feedback
> > addressed".
> 
> I sent out a second iteration of the ndo_hwtstamp_get/set patch.
> I tried to address all the comments except fixing DSA API - I still
> don't have a full understanding of what is the plan there.

Well, my plan is for this patch set (to which you were copied before
sending out your v2) to be merged, then you could see what remains to be
done on top of that, and that should be easy-peasy:
https://patchwork.kernel.org/project/netdevbpf/cover/20230402123755.2592507-1-vladimir.oltean@nxp.com/

I think that patch set explains quite clearly what's with DSA's API and
what I intend it to become.
