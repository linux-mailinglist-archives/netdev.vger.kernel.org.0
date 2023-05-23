Return-Path: <netdev+bounces-4591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F16A170D6CB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACA2E281267
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA93D1DDF4;
	Tue, 23 May 2023 08:11:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D251D2BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:11:24 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2040.outbound.protection.outlook.com [40.107.95.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A60E1980
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 01:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHrC6MODICeoSoksTj6HxheTpynNpsKK18Vn5KHwseKsO89xlnxsUuWMEivk0Md72CSkIrsrwuRcM0cPXeyHQd8Q2C65AucxpgRZ19XZrdDf0Vu4eHXXxhDaeYAMp0duh4MyRvCqedIqRVvT0BkMrE5SXEProziHyQXYNziBsfL7RKQRNEW3ItBN/qwLDSZaoqmHN6hdGuPc7pF9V99zbL7x2acTgHHizpuk+0N2SSMHX9+dPnBwKnlY2mdV4eVtsnWZ9LJwxPkirCCkjy6IKGOefwnBKQVEJpW83Q9N2qV4uSe1tMjVy6yJOqYa+0ZbEZqblUlWxHzs/qxE2bm7Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZueTtt0AD4Zkz6gRNUOVHfwxQzF+RhTeQHA0ozMz2w=;
 b=A5EwiryWb6SkojpJEkhcWTvSzWLMk8gV1URfn5jdUECAkXfyDQR0L8jFO9csZifxk2Pe1SAmOcfpexe2IixUDRUUutiOkPVjkEagPnMCZa+9Q+iQ9CVNWDhRlxP2uVG2UlzE2L/MGonPY86O0xnV23Enu8EoabWlqldRR9pUWTenACRsjOpWqOs3XXlGKoObrfNu7gGE1ezkRvJy3rTj1DWmIyy07EVfpDSFlc4OD7QCyYFO4SXt2HpI7z4XyfSCNaJm+zZs7VcC8CWwf67JVEvMuVhAUAJkpZ8ibh7Rr3+LRNVWEFFsqm1AVNWtX1Wa3XiH5Uxz1tKmnNWENaXUHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZueTtt0AD4Zkz6gRNUOVHfwxQzF+RhTeQHA0ozMz2w=;
 b=ch00Fv8UxXQF9fUvTZtiy3k03Ix1EUNor09liRXVU+sUVpE5VDIp83niLgJbTvmMr/aVA5owoUhWAQACcKfDIRsTPz1EoYIasbTeuMSAhKqcjwk+ZohRLbv2WUZLPK2ACCc3800u/G+GwGc1myv54thaUJ2JhldXVKc4ElWtupUvykf6UJqX7CcLm9TwX1Y4CEh8oi8V3rulw1HPPKelkYEQ4BSw0r2bnQvRV2zAlIfTNv7ifkj6Tr33bRJ7PyM8248XKkzY2tOXarkjXzg0wnh9zypePf5l8n7RsgJ/moC21gmuNllPbz8gcf7TskxHy3kAwburMz/kR3qHYkfSGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB7119.namprd12.prod.outlook.com (2603:10b6:303:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 08:10:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 08:10:46 +0000
Date: Tue, 23 May 2023 11:10:38 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>, razor@blackwall.org
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	roopa@nvidia.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
	leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
	claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
	UNGLinuxDriver@microchip.com, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, taspelund@nvidia.com
Subject: Re: [PATCH net-next 1/5] skbuff: bridge: Add layer 2 miss indication
Message-ID: <ZGx0/hwPmFFN2ivS@shredder>
References: <20230518113328.1952135-1-idosch@nvidia.com>
 <20230518113328.1952135-2-idosch@nvidia.com>
 <1ed139d5-6cb9-90c7-323c-22cf916e96a0@blackwall.org>
 <ZGd+9CUBM+eWG5FR@shredder>
 <20230519145218.659b0104@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519145218.659b0104@kernel.org>
X-ClientProxiedBy: VI1PR0902CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:1::48) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf4e46c-7bb8-4a37-2093-08db5b6535b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jdLIK1I91yHzkAphaCrJSxH7z+QnOziLgDu1Zcvzq84qLztvfMphEaON+6GF2W1E8dhiZaOMrV6xho8Nxdy5ccMA9uUqTE8QWgZU5z6W1tYac8eTuPyz0phLSl4aUk6nASo683Brb/OM80+6BjhGRFd5wrNp4ZfvucHpv+1kHZ4PVxgJptvTwz0/7OqfXEXmIkPdAzyZCOxsc82vPiwM6Fy4DWue02ohSo9TvOoFgQcwrw3vdXxxI9nFuq43Hh0vtSlt2ym5U6IQ0jchN5MZkupSKoT9+cMsFE5e9Tbgxjw/+JabwmpaZW82/k3/3hiO/nSqZbxyipn4lp/igXV+53hVHDgl0NfMZIoYEFiHV3Jr3mDLgXMhQ+/ATdewgJWlecuzs9J5Ca4Ea+USglFr0JIrGLglvdklGoUh4+v6ImAT2Hn4JxMJrAb08FRcOsf4VKOkDMbCaLQtak9fhchSjdjGfDSJE/pS48txd4E1ofTw6D5QnupjOcugt/MTc5HrNadxqOBrzqCKndmMPZ7yMuSfVa2AuC+iomxVhCE96sXF57CtgkUzrOIoVKKIkKVaNF67f41S2Ok5d7lso50PzFz0KUrRx/ZVWP9JfiZ5P0tjBaUXyn379YccGKbeA/6dzf9FMCErGKsHU2xAJvs6tQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(136003)(346002)(39860400002)(376002)(396003)(451199021)(6512007)(6506007)(26005)(9686003)(316002)(6666004)(41300700001)(6486002)(66476007)(4326008)(66556008)(66946007)(478600001)(966005)(8936002)(8676002)(7416002)(5660300002)(83380400001)(107886003)(33716001)(86362001)(38100700002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Kh3E/u/jEjv9Yp+5fY3krS6E80WL8JtuiIDttyBO5rIZNaS7SHSUHJbvtS4?=
 =?us-ascii?Q?N1/l8Z7cDsY4O67U+VkR3DNmhVq80lKaSz8B3p+MS3R092IJrJ0teJj7sARa?=
 =?us-ascii?Q?56aM65YdufwJLWBY8hY0Mt/EeRLusi25Y9sO/e3yvoA2+pV8KpOH+ctLSCLM?=
 =?us-ascii?Q?KyHWsL7ipWH4znWKydPi5wTpF9QazWlN+OTD/DbzAKBxMzskXLjuS7eQ+TZ0?=
 =?us-ascii?Q?2x6P7llRf2gI7AOBHPcEJ3om5N2Yva1rdgqQrvXDFKefAtvRz8C7u55SMKbm?=
 =?us-ascii?Q?hmxlUghN3fwznbGdHocPcqwajaY8U5ElPxoRtHYfYjX1skIoLScp3QJztvud?=
 =?us-ascii?Q?0BtzbRMMxN9lca9rdfEFdU64sjsl4g/Q7dJpX3NMp7DX1yK8W3kJU7lFdMYE?=
 =?us-ascii?Q?cHttFvEuQ2KLtOAaSC7A+G2Fs3814DXl3FH6BvXItcJpqEOqa+vvA0eTNEbm?=
 =?us-ascii?Q?SrUMrutWFtVVF8SeyqURiiyohxHCDbTpPRVloqxc2GNpYaovYIJRWHJZOwB/?=
 =?us-ascii?Q?iH3Qd+C8OxPRmELWq5Evp0f28xavtzWw+3FYB4W42kfxkkpJ2bdJF1qhqYZT?=
 =?us-ascii?Q?FRbzpJYLscPoknqKWoWgilM2k3tnq1z27VEel1jPwHVb6jyUPtDTumyg4++F?=
 =?us-ascii?Q?M1/Bhka6N9EtalvpRqTcva79p7MIb50lxOYVpdaa6I2kCZPvJ0REliPU88RS?=
 =?us-ascii?Q?sJdJgLFBYD5f44YLo864msAfU43SWB4JmmHqc7ygsrf+gKZFl3bYBpifWifV?=
 =?us-ascii?Q?vZeWt8rGbUx++1/8MdsNDpTZiDJF9lBhgXDY1HFc6m9wLg2SP9GBg1wjUA8k?=
 =?us-ascii?Q?Hhk3IsYrQx2ZX6KXx0BG/hU9MxEEEwEuxUhdxkB3kFRIks8+K0kkkNzs8yz5?=
 =?us-ascii?Q?FAZ6lDNzEZIDFja8KqhBqNVy81gYvVOWKlFbmOkYSMVHxiugLVdOAhxCZ5iX?=
 =?us-ascii?Q?IFzwMiWU7rehLYivVi9glUu69lxFg3xIcwz+oAsNe+1BR9xQwAFGj0VX9tnw?=
 =?us-ascii?Q?u3u02bUVxmNnnk9vvN/rxEliI8iKrA8+vAKxaeZ8DRIlq2rDBKqTGsxJwr9t?=
 =?us-ascii?Q?l9IbDVoc5gZOHfq6qW2lcuPYKCVy6VxFPd2PWcMa+5jDXonnAno7jjROhgUy?=
 =?us-ascii?Q?2xV1e8xFbydOcQgU6VtuCtfiusbbzWMi8k0xVaDmLqcZkc215HZYTUO6sJfx?=
 =?us-ascii?Q?CBBskMKijPvcmQh7W4y3SRaRxczPdTNxel9P8tSqOEZT7KwoItlhpnEsQs/C?=
 =?us-ascii?Q?pG3/vyugntuPeHZLD79cyJ+DAdzB5ThZMy115zqslU1naK44kjhBCtlXWdmt?=
 =?us-ascii?Q?lIywOGXPaJQmkzKvfikq0NM9suWbl7DGpWn0niEyg2ZIuNZynUtY7PsiR/tJ?=
 =?us-ascii?Q?6jPt42w1sr0/c9Vbt3NhvdjKIrnuURIPDK7dtcB2yDWEiMtTtIROj7GCrAqn?=
 =?us-ascii?Q?Jl93m8iKFZLnB9EgqoR5CqFnbP1u3OVGvdu+g2MIWtiqmGyMrD7fsa+EkK7A?=
 =?us-ascii?Q?B6dkiMoSXOdozX8sRgTR4G0rJz5Y70ietNJTgGxee2SS/oUIWtFwk1Bk572R?=
 =?us-ascii?Q?Uw7oVWmT2WP5XHNbcijs8Dnudf3CCHDe3j2StyKd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf4e46c-7bb8-4a37-2093-08db5b6535b0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 08:10:45.6578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uqhvkbRMkeajiJu9Z02JFzD/5B0k3Q4ysDfOKzjgH8lvfkMm/elKyGpEPWwZonUZ8+xNedKDPGM9xkG4r4xhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7119
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:52:18PM -0700, Jakub Kicinski wrote:
> On Fri, 19 May 2023 16:51:48 +0300 Ido Schimmel wrote:
> > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > index fc17b9fd93e6..274e55455b15 100644
> > --- a/net/bridge/br_input.c
> > +++ b/net/bridge/br_input.c
> > @@ -46,6 +46,8 @@ static int br_pass_frame_up(struct sk_buff *skb)
> >          */
> >         br_switchdev_frame_unmark(skb);
> >  
> > +       skb->l2_miss = BR_INPUT_SKB_CB(skb)->miss;
> > +
> >         /* Bridge is just like any other port.  Make sure the
> >          * packet is allowed except in promisc mode when someone
> >          * may be running packet capture.
> > 
> > Ran these changes through the selftest and it seems to work.
> 
> Can we possibly put the new field at the end of the CB and then have TC
> look at it in the CB? We already do a bit of such CB juggling in strp
> (first member of struct sk_skb_cb).

Using the CB between different layers is very fragile and I would like
to avoid it. Note that the skb can pass various layers until hitting the
classifier, each of which can decide to memset() the CB.

Anyway, I think I have a better alternative. I added the 'l2_miss' bit
to the tc skb extension and adjusted the bridge to mark packets via this
extension. The entire thing is protected by the existing 'tc_skb_ext_tc'
static key, so overhead is kept to a minimum when feature is disabled.
Extended flower to enable / disable this key when filters that match on
'l2_miss' are added / removed.

bridge change to mark the packet:
https://github.com/idosch/linux/commit/3fab206492fcad9177f2340680f02ced1b9a0dec.patch

flow_dissector change to dissect the info from the extension:
https://github.com/idosch/linux/commit/1533c078b02586547817a4e63989a0db62aa5315.patch

flower change to enable / disable the key:
https://github.com/idosch/linux/commit/cf84b277511ec80fe565c41271abc6b2e2f629af.patch

Advantages compared to the previous approach are that we do not need a
new bit in the skb and that overhead is kept to a minimum when feature
is disabled. Disadvantage is that overhead is higher when feature is
enabled.

WDYT?

To be clear, merely asking for feedback on the general approach, not
code review.

Thanks

