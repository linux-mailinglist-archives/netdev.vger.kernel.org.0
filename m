Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F766528419
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbiEPMXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiEPMXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:23:09 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70138.outbound.protection.outlook.com [40.107.7.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764482D1C0;
        Mon, 16 May 2022 05:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQx7bekqcp7huDC7NiXig1UudP94+bVZ2A5WGLfDrPl486ffZjf2MgeqAnXEKHxAAj/jUYw/jE0/E+ezi/NtUNNCqhCEUXIyS4IsGHyiTH4UtNh7UhRl2gYwyTqZTuv3jrszGiYfdSVnBXsDR6fefzg4ggwkYCRP4ClMDDdr8ZwJ4U3AmPHleNHImxeZ1fZo2NRomkTxnctPsKz8hneJQqV8u/DNId2vZVJkS6UppoRHNGxKgD8q65tgsT22sF8n4CbgOZ+qdj7EUb3Xx5f1ONI/0qNDg7mB7AWPxbonxROQ0vKGjJqR/ZGA2W0N0kTtqNpDOmTi4DUwV/+kApYmtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yK8zFjWzFE3r5PwHbPXMKPFzHoWl/lyrQNdRquDE+E=;
 b=EwMCPLF6jjFyvSBroZGCoYAX2AaNg9iuwX8TXmv5Ga4a5q/yOq1IvmMYsyIAQAH8l47oKoaEgHFSHOZfGei86Z8uA2w/kA2FUkBSWKSk6mMzdWOIkVAx2Fw+Ilkm2fFMXd/JdQPQSuVjvSA52m1WhLS3fUyAUJeYUuH5OjQp3YhJ7KN3y0e+W5fKUux03LduEoPLjjVspNFHy3YnGZnoMHfGdE2yLwwUmdqs70hh+sB42t53OheiMTItNzPd5tdNoJfQJYUEMjt8k6UGfFVX9kbJDwjc/fsnXJazBObS524hz3odhWpKVQc+18yxKXcKEp3e2mvuEmUlK0noX8tCSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yK8zFjWzFE3r5PwHbPXMKPFzHoWl/lyrQNdRquDE+E=;
 b=OL7bUF3IU2V9VlOZyAmNc/1Bf4zjPI7U+kwKpOsIyzwrgXrysuwpFMkivHLbm3oE/xmOZH4+qLr6uxbiGTdi2b5xGvqUYEktHXuYQyMlNn3noC+F2dK3c9Px39DAE01Vj6b6OwhulTdFXE1dSxvC5MBThFqbrL6VkPVVmD5beOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AS1PR05MB9697.eurprd05.prod.outlook.com (2603:10a6:20b:478::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 12:23:05 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 12:23:05 +0000
Date:   Mon, 16 May 2022 14:23:00 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoI/z+aWkmAAycR3@salvia>
X-ClientProxiedBy: AM6PR0202CA0071.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::48) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dfaf81a-f9e4-42fa-92ee-08da3736d3d8
X-MS-TrafficTypeDiagnostic: AS1PR05MB9697:EE_
X-Microsoft-Antispam-PRVS: <AS1PR05MB969745E7E44B45506DFA3C3EEFCF9@AS1PR05MB9697.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DaN0l7pC4fcKg76FVsrFjygpKVdIvzy/KAqkz5eO6PHh8j9kSr1aNFwQZjZ3X79moGGUyTtgF5jhblFvOvfFCOu7/qsSDVRj2BUD8sU0XHeHRMzqFKdhii7ZCS3e4JKuTeRKVDkLd+CabRtYLf36xCPRco/Yh/wp4uXQG8LhaPvZ+HpaPnGX+CYN7ON9k+BB1U+ODMP+E80RxuFEByA1JkWB7oF2/oU3m7Cdwa+V8UFhZSlYgylYhlEzKgQb6zYrOkqtrDGV5v5g9JSGbuu+cQNerDAkkfBTArR4bp+JnFah50v7YtZEPm77rhmMbpb5MvrCgkpq45l/RkxlId6ekP84ap4McH/QcRYbXIOZXOp/33QhNAXel1MiJOefXde21VzZ8nqhxTwZqhnz1uoUmCag7mzj9WHbNlLuNAQ4hlMzspugPpFnIpuvAbJNUj2gtk+VODELrZ1q2mhsyHr25NqKWFJH+/7hSc/krF8X5S1mT9N5nvp6HvYGhPBs32fPf2+ZU3lD1QyDhKNJer6NV6UssDIyoRohLt58iUeGZ41TnHkWfUraoCa35PS9wttVCgA9v2fDQW6a5BZ/o8gQ9oam/zoS/ajFBgd4i6qWTaL3SQlkaXHQOFrW7KB3jGgVv4wAXA/afphb447TLQ21sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(39830400003)(366004)(396003)(346002)(136003)(316002)(6916009)(186003)(44832011)(5660300002)(54906003)(508600001)(6486002)(4326008)(41300700001)(86362001)(66946007)(66556008)(66476007)(2906002)(8936002)(1076003)(8676002)(6512007)(38100700002)(83380400001)(26005)(6506007)(6666004)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EiDM/knbDzlv9dpiVJzoXy0dKCCvU2GLQWdAeW8Wn6p2n1VHBjDPKG+DdGH7?=
 =?us-ascii?Q?A2+rg8EGDDjplKK2ikSQ48OzGqcpyDlxN3Rm6xP7hIqmAFTIuBhfDeISAdB3?=
 =?us-ascii?Q?AsI9ykmQiveL5y+5490EmIu8MJz9a6J+HOBapfzGd2VLGaYlI2FtWDYWW9e9?=
 =?us-ascii?Q?giASR3IWkNZ2negcI2hgxD+nmk+Uvwj6m/J90/tICJTUrn4XgGs66tanbh08?=
 =?us-ascii?Q?WSKZIvdwrgf9GcALXhzs5QUnbvfTSd/5hhrCM0WsJUCVjQpA01EUoT8AeG1b?=
 =?us-ascii?Q?2dXLD6X2khZe85riLRJoTXbEGZpNXPUvO9m/uzMaDikm7AN3tgMMsMtqX+dM?=
 =?us-ascii?Q?U506rcWD2Bz76aEX5IaGnwXGLcC7tuDcvZGyc0oDOL8sayYlVxPtygtlbGq4?=
 =?us-ascii?Q?XKDBDbHrGKUAWMhVH72nh1l2qHCpWpPum0mv5uzgwoVxxue8/CAtXwDjmP3h?=
 =?us-ascii?Q?JBR5+IeEwAIaffs+q4KtZnjCKgRPXqqk68iNq0/6hI7zP0Dbu/EnR8O39pwO?=
 =?us-ascii?Q?WPgJ+bcVLRkUo2EHBqxDfbvPbbe6nEwS2Y3vvW/BmsGwf90qxwLIZx30jvJs?=
 =?us-ascii?Q?i+Z2sfYb2u3v3F2tF/TRg/bkdZ6h6U9o4D+ylbDDL3Y+ikkJakfeCtqrCCr1?=
 =?us-ascii?Q?jHjEDKjzThpxdZbDZ0QDazz9G4w0rH5q60rtyCW0QeutcAr8WHimF6g+Cugk?=
 =?us-ascii?Q?oTIlv43bglIrXBEgJturTGdZcgDAGidVsDXokhUyDlkTX/PS30TTmdYxcCtj?=
 =?us-ascii?Q?+KmjDw0CHQyWuuHtGhAbQ9DhbKoJIuQtlrmIYfaHlGd+7CJtgDeD8q0uZpo8?=
 =?us-ascii?Q?Uz4XjpPWj2pAZFhcnuYdrbZ+ZfxfyREGp/qxAlRovSEDzRJXPoWUxh6RbKnm?=
 =?us-ascii?Q?ZTpwg49ne+bNn+hRQSjgf2ijMsANZp1uRIlRS32a16WJcQnI4WUQxjz2R6qg?=
 =?us-ascii?Q?bSFHkx48rGxQ+fvjXH3FkErGU/fV364ED0ERqeVWdFlfP7f8erO4kfxcL+ev?=
 =?us-ascii?Q?NiZHqM1fC7QVKFYIu791rGwPxMrrsG4AU4KjvuaQVJKTPVrxTpg31vjB8UKc?=
 =?us-ascii?Q?AjTqwlBBvvoTyz+9y3UWWPlmYVX5DcWM/vU+v8m9jnF2gXySttgrslo18Rdx?=
 =?us-ascii?Q?eaqLXQuFC9Spj+0uYSWdcQG45BpN3ITdGxEt7GL0U19oQSWqBo+yQRAujEF3?=
 =?us-ascii?Q?WGWmovNIwOrgryHs+e/jG5QtESwv8vDEjwRoV/ZdRPHzzIiO/DjVWS7XMvp8?=
 =?us-ascii?Q?WzcBrPcB4qe3Oc365I4ibnPFgDmRHC2Ve2nbDDna7TvQhLPeI1AzDRLNRhLj?=
 =?us-ascii?Q?k+Pfxu+9dOb2osvZjRdGhqPIN9dxeVo8CUn+8KFZvzMjpUYsiUNIKXgAjgti?=
 =?us-ascii?Q?3+38RWFuR1wnRZV5/sXa/HMWkcOaaxvO02hFBpMShmcf1BnVvTboQiD+KoAP?=
 =?us-ascii?Q?5GpsSxUCIPmkzVUi5+P3hmbwgDmIhwYkImSYd+0ULHYURL5033JyscL5UjwY?=
 =?us-ascii?Q?0NXxo9ClYtEGnwyV3NADC58OGWAarwyCaIoNGVqufIoibBlTF3+ZZQ4kaSRx?=
 =?us-ascii?Q?4chHDD3/z2EoVOZBYvGUb0EoDAgAy3vwkY10QCzz4JUyfX9ihhrA6g903ToP?=
 =?us-ascii?Q?Ep16jTe+V1wle0zfHNQY7HFj2rFssSdgTGjpw7Zt3WBJytjT4ZpzNyp274dt?=
 =?us-ascii?Q?r6u8Y0SAgDqgwdjdvu52eaT+JC+ZAYJq08D9LsMU2yRAK15SCbGuTddT8J+3?=
 =?us-ascii?Q?SkdPLoBxfDUS0EY8QmglakzpefBF4oM=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dfaf81a-f9e4-42fa-92ee-08da3736d3d8
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 12:23:04.9856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgXGDH8m8Gn93GmumXPI9TMntvyMzPemBIg4y9b5TMLTo0G6koG8dUaG3FZrSuVAcCdlEVqoSYMLKR5qrglpwan2H4gHscVCF1tHmw1HLbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR05MB9697
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > set the flow table teardown flag. The packet path continues to set lower
> > > timeout value as per the new TCP state but the offload flag remains set.
> > >
> > > Hence, the conntrack garbage collector may race to undo the timeout
> > > adjustment of the packet path, leaving the conntrack entry in place with
> > > the internal offload timeout (one day).
> > >
> > > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > > connections.
> > >
> > > On the nftables side we only need to allow established TCP connections to
> > > create a flow offload entry. Since we can not guaruantee that
> > > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > > and only fixes up established TCP connections.
> > [...]
> > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > index 0164e5f522e8..324fdb62c08b 100644
> > > --- a/net/netfilter/nf_conntrack_core.c
> > > +++ b/net/netfilter/nf_conntrack_core.c
> > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > >  
> > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > -				nf_ct_offload_timeout(tmp);
> > 
> > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > path that triggers the race, ie. nf_ct_is_expired()
> > 
> > The flowtable ct fixup races with conntrack gc collector.
> > 
> > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > the closing packets.
> > 
> > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > in a TCP state that represent closure?
> > 
> >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> >   			goto out;
> > 
> > this is already the intention in the existing code.
> 
> I'm attaching an incomplete sketch patch. My goal is to avoid the
> extra IPS_ bit.

You might create a race with ct gc that will remove the ct
if it is in close or end of close and before flow offload teardown is running
so flow offload teardown might access memory that was freed.
It is not a very likely scenario but never the less it might happen now
since the IPS_OFFLOAD_BIT is not set and the state might just time out.

If someone sets a very small TCP CLOSE timeout it gets more likely.

So Oz and myself were debatting about three possible cases/problems:

1. ct gc sets timeout even though the state is in CLOSE/FIN because the
IPS_OFFLOAD is still set but the flow is in teardown
2. ct gc removes the ct because the IPS_OFFLOAD is not set and
the CLOSE timeout is reached before the flow offload del
3. tcp ct is always set to ESTABLISHED with a very long timeout
in flow offload teardown/delete even though the state is already
CLOSED.

Also as a remark we can not assume that the FIN or RST packet is hitting
flow table teardown as the packet might get bumped to the slow path in
nftables.

Best
Sven


