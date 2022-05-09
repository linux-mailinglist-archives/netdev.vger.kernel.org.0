Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458DF51FCCE
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiEIMbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbiEIMbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:31:52 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2114.outbound.protection.outlook.com [40.107.104.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111C1194AC;
        Mon,  9 May 2022 05:27:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kci1qsxpNBV1FxYKzt5bsvzdh0ynjkUUeYArU2k95pSAo+VLRgrFZ5RW/4KpGWhj9UU/MBHbH+wj3+2KGACKy5mqrD8O9tzvQYuBe/KrPCqvm3HVkwNZp9IkaR8xJP88MkyrzOa42wkBgeEse3mgcqy6S2guLnLP66zHFCYrR/xJr6lyT767vP1YnsMC9dKSGGsjSNXRcSd4P09rkBlXSpJ3GzWD3fyr9VZhaMLmgMa+JPoFYtsDR7ge6v3qElTwI1rrbqAZDA398bqtZqFI3f2cjv14nQC6T2kwHStL9Vo5LT3FJKJRRTcEh6tV4FoLAIZAhGX1ZUsKxmkwcEzY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5YQylQ7ZguG+0LmgMJuz434AFhp7CzFa2+NEh9WRtU=;
 b=DsiMPIqTbvoD2FvamyWK4dAL0eeLIM8LoorqUefTX868nAwyTZJNI+JTqhGiW6T6Y8Ktr7DKzBwWbgbmlOqTrJFkGkpmRhOgAwb5x6Y7e2SCv/+3iwDvA4cQRpKghozHnk5ncEffCFGArAXKF5uj/3QjnzWPZhBcuEb3+XpZ+cOxteJCqeySTLyCaTs5qEyn2bJVVWWUWWlRecnEu+WsjIxeubyXxAnTGQNclIcUCHNshigpplKgokDJnkz2qFjsFSM/xZZ9G1qXkVWyY+JLdj8fTIuYGk79P8sia3XuLMVYTjhz1CyUwbLqTnzUErTcd0Sp38GTH9GmoDnSUBpWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5YQylQ7ZguG+0LmgMJuz434AFhp7CzFa2+NEh9WRtU=;
 b=SU1h3HpMMJxTdq57wAUp/Cnw9l/1+bDLxETdpQYYxCsYmhXjU3WU+il7OuzjCX/3gD1Ps/81sjvcc5pmEMqLAsjI8SGX+RKD5FMyzQAkFRqpDuX6S6g74hPVgjbFvcO4ElMcjBA25NpaEhsDlAk0kmDOw/NPAmXhvg/9Vfp3EmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by DBAPR05MB6984.eurprd05.prod.outlook.com (2603:10a6:10:185::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 12:27:56 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 12:27:56 +0000
Date:   Mon, 9 May 2022 14:27:49 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Message-ID: <20220509122749.yrxfzee4lzdpfkcc@SvensMacbookPro.hq.voleatech.com>
References: <20220509072916.18558-1-ozsh@nvidia.com>
 <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
 <acba99bf-975d-54d8-01cf-938d2579f06e@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acba99bf-975d-54d8-01cf-938d2579f06e@nvidia.com>
X-ClientProxiedBy: FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::22) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beb074a7-f1c7-4371-f928-08da31b75865
X-MS-TrafficTypeDiagnostic: DBAPR05MB6984:EE_
X-Microsoft-Antispam-PRVS: <DBAPR05MB6984B87EB091FA797260FAB9EFC69@DBAPR05MB6984.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OLpVQginuT+s5rWUry2N3KU9jRWvaF9WKs737IYqDy+HhxQdL7x8hVzaqgk5CXg0yk3/ozoy4I1NrtNv4/4DAWbVEIx9TeCgS63hIzvB7N/nEJ62CHhyNcdTfe+Uv7chh2xGLP2avrQZCcIIheME/jS/C4vLUeQdGMNNJzxG3huOt57r4A0yC7cBNf6dGjw5BMDhMb/hP57manTOyDnW282gEcgHvroQWLvLSI4CRt8kXI+brQ754q+Eb5PBlIxKkrJBDJ+Kcz0HLjWP5i1nKMB9AjlGyzaT0PkWu0hadiG4pHvEOgZyvnpweXsSutbjMbMOPNhoqgqWpJkLjA06uVlhxzP1OMyOmNtuyUmKuZsWuT3hDdWSNNgNkhhA0UZrDetiIWxU9WS53yfKD3v9IU5r9xKVp2hGmyUJCGEvTn2lsUyRRZ2OHKjtaoX54d1kA7gb9341fIAdkmtlTWm4KXO9d5dompZHISACDP6RiclfCdP7KRMlKQY5ZxkY58IGY5YGw2dI2m3YKCOvhDXkKWHtdZn3SCcsSdiv3uNFbGA9cU8FzJcSFzsziQ8s2lIE8cs1qeb15El2cZRH7XSGO5uqq0X0H4YSLVZfpXwq1FhLIpiVgn0Xzkt8Q5VSObYeIGSf72PHPRM7tvKyT9LxKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(136003)(366004)(396003)(346002)(39830400003)(66946007)(66556008)(86362001)(6506007)(6512007)(9686003)(54906003)(26005)(8676002)(4326008)(6916009)(66476007)(38100700002)(83380400001)(1076003)(53546011)(2906002)(8936002)(508600001)(316002)(6666004)(6486002)(44832011)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ueXxwUHbktctBjmyhnpYTUqMie4Yo94uxA10QrUbFDbdu5qtjB8dzNnq1fe?=
 =?us-ascii?Q?fwVDRp2LPE1wnDLmTWMvT5hhYdG2x/D3a+K4l9YVyuQm0U4M3ubUKalpZBjO?=
 =?us-ascii?Q?JJISts1tcCECaAY7ba2DQG3lYtDxOeRwS9L9quhlg9aRWMF4oAYTm4xL2u5s?=
 =?us-ascii?Q?6MUOY2ZZRByvhFgscVWYMj0W7N5UImH2eyFApsnwMyTe14L61Bd8OVK6p9cN?=
 =?us-ascii?Q?Lc0HPoCE1u02EetPSGLqRoBAOsr++oWBO39zLB5ng1gSsFDv9eBwqzlIt7Gk?=
 =?us-ascii?Q?aKE+6SLEUoVKP+TlGUTyY9Nziu52gkdMPwJsftt6W+TSa7QulaM8DxeNbfH0?=
 =?us-ascii?Q?lK96U4cyWDq/wmEc3Ef8CGNLGBAe3jQwESRXTxZCB0L8OmXGHjJBRL8fqMNU?=
 =?us-ascii?Q?f7+2t67cy09Zkc8LX2WcwUeGM0NkDRqjKrQX0JIB0V777jHwdno7leKuvfjl?=
 =?us-ascii?Q?ARp4angsD5OEJjibh8wPkIbT8/5V6e5JH1gsl6eZC8GfM4MdSdAuyioxFVaH?=
 =?us-ascii?Q?d+xtEIBaGVTQyJAJy21BnW/x/XAGKe2LghN4BBi+Zbt4kNEwoG2EHKl+MT9l?=
 =?us-ascii?Q?78y8htEup+L/eOE1mYIO/kf34ak10HtDSXNntd3O22CchlmK//RQ6rp1aAUN?=
 =?us-ascii?Q?4pFqk0+irbCVRYuYZnlTzrSVv1kovU1CdkJlY8MtzB7VfGCnsPxHQBQ/fAvN?=
 =?us-ascii?Q?Zb2TOuk685bV0qaJlgI/icheDJTNE1gv0m86viqnqSUxrVtRbF8btaUaUkyf?=
 =?us-ascii?Q?Gpc/AD6KDcDHNk6Wmtz0NFq5vNvWaIWwiYxiMz3qUNoSLTD8HNwLSa80JFr+?=
 =?us-ascii?Q?G7OT61x1YauQZ+qKQ55vwnjbC3H1fM5WGa+1pzKkmxBqMT+Tg/AiGNyCxyWh?=
 =?us-ascii?Q?LRq7fWldxIusCf7JyuOr4dW9QE/WkkT+rDi54iN5wmPpp6LIHQvftw9R76/a?=
 =?us-ascii?Q?Oo+hWtaaKx6mKjrCc8GWw4aHA5WDE9S4Jr3RUab+wbQS9V8XW/IrflvQP8L8?=
 =?us-ascii?Q?O3HB7hVSLNsPJ7lbppWs5PSuJSb3VI1QRJWQUqsG4QQ7GbIA+KPjvAdgyVUE?=
 =?us-ascii?Q?A3yRfiSlYHag+TQEvjkgbeOnT5p+Czs8Ir7XmVka80j3fNXKjuUlzb4752qL?=
 =?us-ascii?Q?iKhwcY6ZdXOp4p0hcLx6ecUlwOJj3lIbqJC/9sDSC9ua2Vym3/bBWCHa9qgb?=
 =?us-ascii?Q?gHh6vhdrWf0NXrDZOhHJLBTiKMD031KUJHd2jbukI0HPOAVqxLw8gVyV9QY+?=
 =?us-ascii?Q?4N60P4WDK7uKAUYbaIymyZxgAOxyoJWuk49sUde9sYp7nbTOiMz/wXYluGA7?=
 =?us-ascii?Q?Lq3nLcR6spas2cR7K1Z0b7OS7QSOYSuCYWZMIs8fITSsxNFifgiLZsXJvi7V?=
 =?us-ascii?Q?Lagy5ai6CQaTyDb8m0M2rdPdQvEgfKTr5AuVUu1WFMle5l7QQyYnONxZOrNr?=
 =?us-ascii?Q?5a5Fk7BeqWvflkykoSf3OMsjsXngxFh7cW70rwWe7hFx3gEZsYUqkkl/KR+V?=
 =?us-ascii?Q?S/olI+YkWuGT2tAeqvJAhABOYIO0H/hR9OobhIL/yETpdRXCZrtYpMQU+mA1?=
 =?us-ascii?Q?OZZYLPfXCw3w+zAMkcSGiakk4ENGZvGdqwKpfzvrPWQ091TV4CceFH3+pO6E?=
 =?us-ascii?Q?NCFzyMtFyIiDlIDp/r+aYvOQzkV86hO0zxqgM7LnWTqY5YKG6zTLhf+/W3JG?=
 =?us-ascii?Q?0U2zq0T6WBFb2rs/m1uluq7laPLq7EXE4g+m64MBulNmiHNqe+jnekcIEFDy?=
 =?us-ascii?Q?D/VhWp7dYNJPyO2JH2k4idsOLdBQBjk=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: beb074a7-f1c7-4371-f928-08da31b75865
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 12:27:56.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EORenYzkPgUhEO4EXTxBayXDnogdt8xkHXQTlnmmmN5GadZccvRpKrv9rvSYLXqCpEXbVUHEY5gw476IZP6zRN2LPZzlVIPsRa72qcxnP4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB6984
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 03:18:42PM +0300, Oz Shlomo wrote:
Hi Oz,

> Hi Sven,
> 
> On 5/9/2022 11:51 AM, Sven Auhagen wrote:
> > Hi Oz,
> > 
> > thank you, this patch fixes the race between ct gc and flowtable teardown.
> > There is another big problem though in the code currently and I will send a patch
> > in a minute.
> > 
> > The flowtable teardown code always forces the ct state back to established
> > and adds the established timeout to it even if it is in CLOSE or FIN WAIT
> > which ultimately leads to a huge number of dead states in established state.
> 
> The system's design assumes that connections are added to nf flowtable when
> they are in established state and are removed when they are about to leave
> the established state.
> It is the front-end's responsibility to enforce this behavior.
> Currently nf flowtable is used by nft and tc act_ct.
> 
> act_ct removes the connection from nf flowtable when a fin/rst packet is
> received. So the connection is still in established state when it is removed
> from nf flow table (see tcf_ct_flow_table_lookup).
> act_ct then calls nf_conntrack_in (for the same packet) which will
> transition the connection to close/fin_wait state .
> 
> I am less familiar with nft internals.
> 

It is added when the ct state is established but not the TCP state.
Sorry, I was probably a little unclear about what is ct and what is TCP.

The TCP 3 way handshake is basically stopped after the second packet
because this will create the flow table entry.
The 3rd packet ACK is not seen by nftables anymore but passes through
the flowtable already which leaves the TCP state in SYN_RECV.

The flowtable is passing TCP FIN/RST up to nftables/slowpath for
processing while the flowtable entry is still active.
The TCP FIN will move the TCP state from SYN_RECV to FIN_WAIT and
also at some point the gc triggers the flowtable teardown.
The flowtable teardown then sets the TCP state back to ESTABLISHED
and puts the long ESTABLISHED timeout into the TCP state even though
the TCP connection is closed.

My patch basically also incorporates your change by adding the clearing
of the offload bit to the end of the teardown processing.
The problem in general though is that the teardown has no check or
assumption about what the current status of the TCP connection is.
It just sets it to established.

I hope that it explains it in a better way.

Best
Sven

> > 
> > I will CC you on the patch, where I also stumbled upon your issue.
> 
> I reviewed the patch but I did not understand how it addresses the issue
> that is fixed here.
> 
> The issue here is that IPS_OFFLOAD_BIT remains set when teardown is called
> and the connection transitions to close/fin_wait state.
> That can potentially race with the nf gc which assumes that the connection
> is owned by nf flowtable and sets a one day timeout.
> 
> > 
> > Best
> > Sven
> > 
> > On Mon, May 09, 2022 at 10:29:16AM +0300, Oz Shlomo wrote:
> > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > set the flow table teardown flag. The packet path continues to set lower
> > > timeout value as per the new TCP state but the offload flag remains set.
> > > Hence, the conntrack garbage collector may race to undo the timeout
> > > adjustment of the packet path, leaving the conntrack entry in place with
> > > the internal offload timeout (one day).
> > > 
> > > Return the connection's ownership to conntrack upon teardown by clearing
> > > the offload flag and fixing the established timeout value. The flow table
> > > GC thread will asynchonrnously free the flow table and hardware offload
> > > entries.
> > > 
> > > Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
> > > Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> > > Reviewed-by: Paul Blakey <paulb@nvidia.com>
> > > ---
> > >   net/netfilter/nf_flow_table_core.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > index 3db256da919b..ef080dbd4fd0 100644
> > > --- a/net/netfilter/nf_flow_table_core.c
> > > +++ b/net/netfilter/nf_flow_table_core.c
> > > @@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
> > >   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > >   	flow_offload_fixup_ct_state(flow->ct);
> > > +	flow_offload_fixup_ct_timeout(flow->ct);
> > > +
> > > +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > >   }
> > >   EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > > -- 
> > > 1.8.3.1
> > > 
