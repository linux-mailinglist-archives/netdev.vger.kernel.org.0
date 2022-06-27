Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F159955B48C
	for <lists+netdev@lfdr.de>; Mon, 27 Jun 2022 02:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiF0AFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 20:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF0AFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 20:05:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8102BC9
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 17:05:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4jmS1GBv0qexnrmN+vKyqwl3TF21bN6R5gd6hW4Nr+4ysXclVbJp7LyDOW9dKODc+WeIy9ZsAi09ol55lIfHcCvPPSg5pL+IOyRFc9hdKbik4/9BYPxWO75E5j1w+eu6JSLfwg+s9NtyJsS9NsgvLTvZjyfG4C0b3LYd8IbjYk2w6MgMV1fjk7e2cwfD3IfEv/kPTYnDaT5EIQfQklcJPx7rhExgJYuIJcaO8V/vyJcggc0XGvjO800gADQuq/MLlifp1TitZUByGXC+trW8UJ9optpgpbbpsqNBiA1JyhYJyHP1zoM93sq554RTLeGWDth4zKIDYORRYrhqgFnZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0v3yu4lJPs/CVLqMqWPkQZSMH+2CWM3gVc4uAeKx4gM=;
 b=RbXdeR61xJN+OW/U76L+9JV7flY6LC+cbxynnGgd9tpUPn0gejtU1Fwzkr7p36YDx9S9XwpYHcueUq0ZVcqmE3xV+mCcvV0HNnW8sEaFh7fwNhH/SWQ+fi7Os4jyFnx9/VHBwayKvwEW6Ur5zcmtQAve5hgCU3N+EFlUJkVK552VxP35gQP3K4C0M2p2ClZk9qxgDQodcTAOr01eZVg6xZOxfK44aXHiONevFSN/M6z6R2VSCRfVDL4SpW0kxwc7HfrFGlr5zvSYWGyMwvbShGyQG9XpaOBwcUimwxotiNzU/ZLGQNuEoe/5HjNHbiHL8j/ImSSKwjz4l4JEkogTEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0v3yu4lJPs/CVLqMqWPkQZSMH+2CWM3gVc4uAeKx4gM=;
 b=HfU1tewglZuLX0RMqg7EvSreBLFHKYuCfz2Qno+Cu9CrkNK5A+GVmcXzcp0WJD0QdrnqNEdiY8l+wvtWgJ5WjN+Y31FRnGoR9voYW0V7Y/TxUjJhYR9j1uJzLZkeVeizoP4Jc/zrbmxWHdStTLPtRnaajVrgucuMBrtRRyEOVxiPWcobNXW1jkwahCcdr0eLx2rqGwF0Av9h62tXTcPPdUkbdxwvd7SL1YIKwvSAGx1sto+pb8X+x/ztOG8AFE9KZAlGbjNsYjHhUoQKEamHaj4egcM6Ob40k89e2rE18PKwAXnDkr0rZXOeiuvztQAcuBH88qVlqV8hF3aYd9HMeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 00:05:49 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e1b5:e575:d59e:91aa%8]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 00:05:43 +0000
Date:   Mon, 27 Jun 2022 09:05:37 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Mike Manning <mvrmanning@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Saikrishna Arcot <sarcot@microsoft.com>,
        Craig Gallek <kraig@google.com>
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Message-ID: <Yrj0UWOQM8QNqJqu@d3>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
 <YqarphOzFTnQRq29@d3>
 <9b37fcae-214c-3a5b-d976-8c94632184d0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b37fcae-214c-3a5b-d976-8c94632184d0@gmail.com>
X-ClientProxiedBy: TYAPR01CA0157.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::25) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e096ff3-5d1a-4733-da10-08da57d0c722
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcmsuBPH1eQu93fLWqk1uXHdSypNUPpGP2gMRs3xnnTSPxMC7fgRFd6we1tM6t0quFd1PtsSREBUp2+056mgs2OKFLN6rsoHPN3MXaa22ZrcMHhWzS+T+zunisG8/XHK0NzcQIERzlXFjIwVqa3xKRTbE+2vPEHMResfrzXIB2NRqTK2yw/E+hY30ZjZxI4m56bzkpvt5tlS3TX9GO+AwL/nGpTX9eCr6s42wwUTVOtrvzyPMqi2Kkz9m6qX8ACOupVEWhxHiK7lXhDy4EK58H2fSfS5UNmrU0qH5B9HAZBnwuEOv4IkLeoqFDGIkQ/0Ymf99/z8ubkcxeS5odjclGymVIVWcSYGY2UhXnD9evQsjA98pL5BiXBSToWvLzXX7+z40l17/6L1kkEzLHXEbdi2WxyipwJ6Kz3YJbGnOVCRKGqAHCAJIt0p9eIG4X2HxBxju87Y2CeVgqHehPklzMqh7gu5iHpFNhbcEx0lRl40+zqzOPt41loDSj5GXX26uj9i5/OAbK3U56ETgsq9DzM6XfxhIPVA3b5Xig9RLYtQHCCGEdIoRNX0wYRa67RvzwDbOjszLhwYyZXW6QIJ4CUr0R25y8fP4Iv3DAlG+TNoWHsiqrJDJ/Srdvz8FnnzVF2XOIvuwobnPwPATqn/GkZb1mPzGYCY6yEaI4+99jv/gdkPHFGE4Uc7QBE1/xJa3YS9PBCZqTiWl1H0OcLH7AK7rNWzYn8cDfNMPKCxPtw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(6486002)(2906002)(8676002)(6512007)(478600001)(53546011)(54906003)(26005)(316002)(9686003)(8936002)(66946007)(5660300002)(86362001)(66476007)(41300700001)(66556008)(4326008)(6916009)(83380400001)(186003)(6666004)(6506007)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBIK/xUA4NCDwzh1kJstdE/w3A72VCOkOg2Y99hUcb4pB5KSd6f/HItjwFa0?=
 =?us-ascii?Q?XnbBjkV/ot60k8/e5bT83EbCJ20ih/bCjPGuEg62h4s5A9ttPs2o0ZgIBWKa?=
 =?us-ascii?Q?c/bTOSGFgJ3aO3y+hyT2/ul3dgu3AJo5wJjhIkZoR1a3hG5C4/L0t0OdLoa4?=
 =?us-ascii?Q?F3+XXfI487vQCJaWrzEpBQyzW1w8TNxzL+pfxsZEAmOcsKEcgxpwgeFbG+ep?=
 =?us-ascii?Q?d2NczqNMypDNzDimC2DzU1y4jHiVeGRfYbiFIIrvD4aefk0g85tvmSGyi2i2?=
 =?us-ascii?Q?mnHMu1uwTFUs9WwBzZpzAyHiKkpBF54INzL7SqaOjHvYiWr5sCEkvdfe1w1f?=
 =?us-ascii?Q?gio7OG/0TQwLR3hohp5UAssBoUHG5o7Wde4WBOZAQLwtOtmpopVM559kKH9+?=
 =?us-ascii?Q?Q3teKy8ZWrMTwq9eeYofpvN3mX+gCbEpzN03/U/9yxzPtxgq1vo1rwf5IcZP?=
 =?us-ascii?Q?zhmqyHCdXnDQ/pN9B+jTyse8xntfpM5Fh4n0UuV08frBxlT+nn6pLAsXFgyq?=
 =?us-ascii?Q?6WrSpw6CmiVkSpUfdKRyvbKXv1fIGcrtRsLUp5s+Ml7b6rTNWbS4k6qZz4XG?=
 =?us-ascii?Q?gwleqXuZYo31Juxm5du3vHN+W6hZbRTDIoDRZFPi0oBN+8/R9YX/oS0lNReR?=
 =?us-ascii?Q?VZWKh+EkcEks1K4OQnFM+94y2iOAkBAEH0ax/x3NYIre38UvM8Hv9Lc4DAue?=
 =?us-ascii?Q?/yvty1RKN6xsx5RP+8cgBcONSxBaz4s7k90dk39oMaOQaGdDky5hN92zaFcV?=
 =?us-ascii?Q?awMGb9nUGbsD4KzKGgNI5KuJtmRb30cUNkesp5NClYk6qFnubZLWFplPTYEC?=
 =?us-ascii?Q?fdw0j2j0f6UK4SpZNoqdfcvYzsjpPenIllRr2p70GwilPMrjJZZnR/I5AX0u?=
 =?us-ascii?Q?MDtc/DfV26B4DsYM4kakCMImHHOfjztlWLUlUE5UCDTu26Yrmadfeods5HCM?=
 =?us-ascii?Q?Apz9BhWF+mp33UBCeDsTsAjuiQSn9FfYJocje7CNWqbBZzma+o9h3UQZHnWB?=
 =?us-ascii?Q?RNoJptLT+Hoy6/G3aI4LH0+HBa2xm10Ilw9OR6FYZUhdTKu0L8EXn62LVc3K?=
 =?us-ascii?Q?Kqgs2sTOWrhJD7NdHhKGNkBbTvfHJ41qpqsEkbNuaHWYi68b9Aj5tNAyAFql?=
 =?us-ascii?Q?TwyWNoRh7v6W0vSFeCCnT9x3VRbc6z+MQuls0ZrR9PE+yFEIem7YFV4kN+Uu?=
 =?us-ascii?Q?TWCWiTCpzulGvbOsKVFN8/uv7IhkkEsE1GTt18yMHiLTV+mquhaBs7R/M211?=
 =?us-ascii?Q?bfkbe8rl5YyibCX5BA/TmAXgeNCEwGZVZ6t669ESYAZLBJ/5djhrcCES5Ogz?=
 =?us-ascii?Q?u4RF964oHfSHCSw+yVJTUxkqv+D4wZEs1hqvEHX/s4cxpKTD+XB9v+uwpRXd?=
 =?us-ascii?Q?S9NzDL9tj+ihSaAK6dULYV+gATFBrcIsx0on73npEBXR6z4jcCGloYbFQOmI?=
 =?us-ascii?Q?wihnh0nGvi7+tfuXzQVaN+PNlwfB0at8OQsWXjorCafkznqbGOsOW7kiGqpv?=
 =?us-ascii?Q?AoXBwOBO7/E37tVJDz9GmVdSXsZ6SlUF4UVKYqr2263bEIqmdYCmBQuUOUr+?=
 =?us-ascii?Q?An9lH0IJgBSRJ4x46jA6Sy5aW36WAKekSGhHK11t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e096ff3-5d1a-4733-da10-08da57d0c722
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 00:05:43.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VrZcLyseqHBXTafbaU2QjMJwwzpjyk2ZUdCkEiGQ/P6YtZ+K6QZ1lK8qtm9vL/KbhD7GqCfgfyN6pp+ffmgV+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-26 23:25 +0100, Mike Manning wrote:
> On 13/06/2022 04:14, Benjamin Poirier wrote:
> > On 2021-10-05 14:03 +0100, Mike Manning wrote:
[...]
> > Hi Mike,
> >
> > I was looking at this commit, 8d6c414cd2fb ("net: prefer socket bound to
> > interface when not in VRF"), and I get the feeling that it is only
> > partially effective. It works with UDP connected sockets but it doesn't
> > work for TCP and UDP unconnected sockets.
> >
> > The compute_score() functions are a bit misleading. Because of the
> > reuseport shortcut in their callers (inet_lhash2_lookup() and the like),
> > the first socket with score > 0 may be chosen, not necessarily the
> > socket with highest score. In order to prefer certain sockets, I think
> > an approach like commit d894ba18d4e4 ("soreuseport: fix ordering for
> > mixed v4/v6 sockets") would be needed. What do you think?
> 
> Hi Benjamin,
> 
> We had never observed any issues with any of our configurations. The VRF changes introduced
> 
> in 7e225619e8af result in a failure being returned when there is no device match, which satisfies
> 
> the requirements for VRF handling so unbound vs. bound to an l3mdev - the score is irrelevant.
> 
> However, 8d6c414cd2fb was subsequently needed as unbound and bound sockets were scored
> 
> equally, so that fix reinstated a higher score needed for sockets bound to an interface. Wrt to
> 
> your query, the scoring resolved the issue. I am unaware of any problematic use-cases, but in
> 
> any case, my changes are in line with the current approach.

The problematic use case involves sockets that have SO_REUSEPORT +
SO_BINDTODEVICE. Earlier in the thread I've included a test that
demonstrates the issue.

For the Cumulus kernel I've put in place a workaround that removes the
reuseport optimization (see below). I probably won't have time to work
on a proper upstream solution.

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index b9d995b5ce24..1765ac837358 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -253,16 +253,20 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &ilb2->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, sdif);
 		if (score > hiscore) {
-			result = lookup_reuseport(net, sk, skb, doff,
-						  saddr, sport, daddr, hnum);
-			if (result)
-				return result;
-
 			result = sk;
 			hiscore = score;
 		}
 	}
 
+	if (result) {
+		struct sock *reuse_sk;
+
+		reuse_sk = lookup_reuseport(net, result, skb, doff,
+					    saddr, sport, daddr, hnum);
+		if (reuse_sk)
+			result = reuse_sk;
+	}
+
 	return result;
 }
 
> > Extra info:
> > 1) fcnal-test.sh results
> >
> > I tried to reproduce the fcnal-test.sh test results quoted above but in
> > my case the test cases already pass at 8d6c414cd2fb^ and 9e9fb7655ed5.
> > Moreover I believe those test cases don't have multiple listening
> > sockets. So that just added to my confusion.
> 
> The fix was not targeting those 2 failed test cases, the output was only to show the before/after
> 
> test results. It is unclear why they failed for me with with the 9e9fb7655ed5 baseline,

Thanks for taking a look, that was also my guess.
