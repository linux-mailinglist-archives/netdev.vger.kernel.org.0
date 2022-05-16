Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14805284E2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiEPNC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiEPNCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:02:25 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2128.outbound.protection.outlook.com [40.107.21.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199B39B8A;
        Mon, 16 May 2022 06:02:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr8T5R8fihm0h5GLAQWqlsEemrPBmTV6y4Vm7mJj816RHxl6IAOKaThG+78CJyAkepu5aDGBbqhSK7prhCdnyKVog2x6KmNiuiTvl86jK78DFYOVuvqsDPPezRlMyPy8RNFH33AePSNoGwEv0FbVN67CP0PyLq8j6DBQRSBLTzHz6Y5Zl+fMKZzrICuG+Q4QtIgnA89Cj/C2LcUc2OjpKhog9aFhzlYyeu3BUGxCcreqJecT3Tch++AArpyHqR3oz7zD2lxYMU7yKiC5m4JMYAV5pf0a1GNikWbwaDXJlIaEb7GEXwoc3wS6sQ3R6c+ilhxuvO/4S/YaFMdbpmBYDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvPyprQxFvTxs5Bes+ISe+EiUUiLxN1AcQOMiS2aEsQ=;
 b=A99P5+np3zf5wn0mEtVh1H+Dd9EbCK/vjTOaeBFC/fGpJPdL+SBJ/J+nutW1+YrTHQPd6nUvVHlMTTEDo6zF6zMGM6ZpAH/d2NiA1zEPF84t+TUnxaa0IrW5IWBRovxdsgXCJbp/Yq7i7YG7GUo4l0DggORnWIGscLakhrgW8WHJNGacNRQ0E1GrDC8wZVa6k9K64z3y4jnQRpo+KDW08KMMAYjqgRm2+jXaV/148HoDUAEtfM2I4SD1/N0A3pwRPvnwIlyZwc4vHhqk8I3JUH8E1S/PQ2RuHo4D1QGHTA9489q5jkxbU6DqN0N2M8M8UxpyqTUrBZVVNLaPoTi+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvPyprQxFvTxs5Bes+ISe+EiUUiLxN1AcQOMiS2aEsQ=;
 b=e4hzMd7STWBJi3HGKTfB8yqmtZNCuqbrkqzAfcR0iG2OERS+v/CRaF3OYrhKS650A05NqiP7eGz6NF4LOAoMsDf+qWt6y17Wj5CN4XvliMgZUrfZI6rD7bRPcDrUFydZNRsLe+ZJUZDhrHX0/tL4fF7E2W/nezccoRQ2cWBVRTs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by HE1PR0501MB2842.eurprd05.prod.outlook.com (2603:10a6:3:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 13:02:19 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 13:02:19 +0000
Date:   Mon, 16 May 2022 15:02:13 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220516130213.bedrzjmvgvdzuzdc@SvensMacbookPro.hq.voleatech.com>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
 <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
 <YoJG2j0w551KM17k@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoJG2j0w551KM17k@salvia>
X-ClientProxiedBy: AS9PR06CA0753.eurprd06.prod.outlook.com
 (2603:10a6:20b:484::9) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd614552-e50e-4cf5-c67e-08da373c4f34
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2842:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0501MB28425C3816C1D516002F0CA3EFCF9@HE1PR0501MB2842.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rA2Ku2S0rsbYOrFGru1Ku0C2t9sgZe047j5kc7bqjqTsCiRbncUjBXRUa5c8S0VEc720xsSibdg9JgIqcDaCFWxlKpT9ZUe5nedeRVRvd+MGbCkrj4Q5um6TU5pwmJ5TziHOnxUi2/dry0kqFhwTUvr0T6Ss7K5SbYRXUwZorm0Ima4u0z0WuA78rECXJk2EcjixA/MZ9zZAXqtRDyU02D/JxhoznoSa/XvclPQ+pBDahZOMSbbEYCGE+HEWuvDUry9kfk9eWnoZ1hqqRtB+BCQDaagbEyY2Xqjn9KOmvB7cvNhth5CJaQm5g834TAwFNd/3Fx3QL+e7aHuzKgHhy4GF+hRyMYUvs617h8xks6mrFM3MpVUGbB/3ukzT6rV2VZhl3fcJ+BCJTwBNhOxPMBvkBh/cRKtOVdV8OLl26vRVYyeGS6gS6eQiMxnTnnLibFWrj05gjC8iS7UbW2BTTtN/xaD89+GWuMBeRIkfAo3bmfr4MdQtr2b8dGoj9TAfQxAimhBbqyrakMeIjqsE4l1vrv49uK8a6GgbV3cpAXny+pGnImadWW+QlwCXV+HH6fgapRaJ3gLxXcbHKh6yTcV8VCtrLgUit64kxSCxHsTUUN04ExN1ZDlO7lHtBJq7idthar0cDrc7qgb+9aCRQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(39830400003)(376002)(366004)(396003)(136003)(186003)(66476007)(26005)(54906003)(1076003)(9686003)(41300700001)(6512007)(8936002)(316002)(6916009)(8676002)(5660300002)(66556008)(6486002)(4326008)(86362001)(508600001)(44832011)(6506007)(66946007)(83380400001)(6666004)(3716004)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wHGYgy4wsfPrVhkcPK8unhhrXpOLUrPIFP4Uhcn1C5/QFafhRzlmrGE8RU6d?=
 =?us-ascii?Q?Lk2ztssUUXeni1nLqd5s9TmjlxEEEUQ8j6wkCSw0rlKCV9lM+vo1RfYgGIox?=
 =?us-ascii?Q?3OtKeTnrZrobHD7IpNMxhK4nyQMmUDtK1aZRLHxMrhPbuijKDdJ+VYp0or0G?=
 =?us-ascii?Q?Z1zV4VwxqZ4Ytem2XBGL8EVu1q0GGFdcBQKqyOtEra4ZAzVt1ctMwFuoWBdf?=
 =?us-ascii?Q?0mCTi7IQ3GgHOVaW2ojhzBB7tbwiVsSrMYUuk2nX6wGUimA9S8ZGgtn2lz6c?=
 =?us-ascii?Q?FJ4/fJZE4HLSiLBbEforT1Z5QhOOi3HjQbrplqR/8/m9BxHvj+MxapVeEE0a?=
 =?us-ascii?Q?fabqmM3Ex5RE12HCtXeZXPPAkQ2xTf7mzWvnsrVSfUzNcIGjCw4au0A5zcUz?=
 =?us-ascii?Q?O9yRBeLdu4zgHJgGCU3hQrtBkPj9yRiraklCSkVfRIhGKrFiNSbQxur2FNkA?=
 =?us-ascii?Q?bDgYcM2W01cTsE33Q3WMi1cbzFp9qMK+iCo+QC04koKiGD8lKO6XtNV39l32?=
 =?us-ascii?Q?PtzZVgW+RLa9gBCm0ZOkzGykvqsuIC+3HgzPBfNRR66WjSjn6WAOvWjOT1Mt?=
 =?us-ascii?Q?tOKVU/GyolvbFBFnSVEukGS7LwfaceJZlbKR+T3mjMr2CucyWWDbELUs/Fg7?=
 =?us-ascii?Q?0sXRk2YVzQZoqW+b53NPxvuzhb+vfUpjcfhWNuvuEhhwfNpziKgKNcfRmFN1?=
 =?us-ascii?Q?XbK/WlggT7pEl7AyJn4IEArUzp8jUNYioVFMZmEZCmiNjmmrmi8R+K/pUDHd?=
 =?us-ascii?Q?wygEdLrTVKVSXkJWytJiocd6/heLyRxeiCVlkqhL4s2gHKA0M8wfa891ldEt?=
 =?us-ascii?Q?1+QpYiJRbA5kWVN5CNhWH4SFRJaNSZVOtc7o4nN54BT/kkjHEk5yIq5Ie26r?=
 =?us-ascii?Q?+VLR1s6d4byWhl5LNu9wqTGHf2UF4z5OchLyQOmdfFxCZFN0KXxvscsDxCrw?=
 =?us-ascii?Q?wttoJUloM3LxtAaulZIBZUli5OupNfqjX1N0T3jNTtQUtnPRylLTzfqyqA0d?=
 =?us-ascii?Q?IJgGOh0XKu1FPTr7e/CBhJm744nzGwvtqQfvBm3yX+NZtyBgfENk59V6f7OG?=
 =?us-ascii?Q?HgXdbWJbwoP4AY+8q3oSKezwKT0UpVrcByzHBYxAu+fwnWlRamI/nZpeD2ht?=
 =?us-ascii?Q?lfbGb7TwcfgZCTMPgoDj4O80Mq8WXinEu6B6h4bMWeYtApVU/LFrRk6yGfbt?=
 =?us-ascii?Q?vWSZ1L/mGjIMsGTXud3wXyCyl2/YYLLFW1JgFOo6uPrt6BdFolE3DV3jcMSd?=
 =?us-ascii?Q?ZA0eg2TElF7drh1swvXW/GJEM3bzB6GwWEKm4KAQ6h7gH08wJulh00kDQyzE?=
 =?us-ascii?Q?c9hYqqfcwM/IrpKvZM5t8ojG/5dRpPrWt0jFW70DAFrUvCR4Lg79LOBHZGns?=
 =?us-ascii?Q?B48mJ9qDWc6MWKR2Xkw37TyGOFw54cvLHsTbOtV4aYOQYoxjnge9pGND8XdV?=
 =?us-ascii?Q?pmCXNabqkxN4PrSjAnMFMHYh4BLCp8v3D7sTJfPXzpTd6llyAAxEmtmmgsi9?=
 =?us-ascii?Q?TObWI+9vJI7m1eZ72zVDmvjr5zk028NxLXnJTpWiJ8JR2hADdcyjsxM65+Qv?=
 =?us-ascii?Q?IPc/NT5EUe6K25bhlTYUcHTLjpyoWT2ZqaJQPy7y4nMbcWWHmG4qzTaRPHoB?=
 =?us-ascii?Q?xwXTH1BVwYeLZ/rIzvAXuxgOX+k6UfD5JqktoNn4teWoDAftqKyxyMxk3mBr?=
 =?us-ascii?Q?7vQeaD7T5zagegms6skTEjei7/xYYrIJdRa1SYEiaQfYpDzy6ZyHHRW1cvur?=
 =?us-ascii?Q?jA9i3J4QFpg/0ZhAJrUoawIISyjeT8o=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: fd614552-e50e-4cf5-c67e-08da373c4f34
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 13:02:19.4346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9ploRWS0s33NLPMOLmIFgaBoChf/5qCQ7j2WT6n1MUEa1aLN5SB2D+r1F/f4C/UYXoRj6jAxO0XmonSfdhnw1SufgJypQ3/6AwYle2FPpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2842
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 02:43:06PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 16, 2022 at 02:23:00PM +0200, Sven Auhagen wrote:
> > On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > > > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > > > set the flow table teardown flag. The packet path continues to set lower
> > > > > timeout value as per the new TCP state but the offload flag remains set.
> > > > >
> > > > > Hence, the conntrack garbage collector may race to undo the timeout
> > > > > adjustment of the packet path, leaving the conntrack entry in place with
> > > > > the internal offload timeout (one day).
> > > > >
> > > > > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > > > > connections.
> > > > >
> > > > > On the nftables side we only need to allow established TCP connections to
> > > > > create a flow offload entry. Since we can not guaruantee that
> > > > > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > > > > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > > > > and only fixes up established TCP connections.
> > > > [...]
> > > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > > >  
> > > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > > -				nf_ct_offload_timeout(tmp);
> > > > 
> > > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > > path that triggers the race, ie. nf_ct_is_expired()
> > > > 
> > > > The flowtable ct fixup races with conntrack gc collector.
> > > > 
> > > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > > the closing packets.
> > > > 
> > > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > > in a TCP state that represent closure?
> > > > 
> > > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > >   			goto out;
> > > > 
> > > > this is already the intention in the existing code.
> > > 
> > > I'm attaching an incomplete sketch patch. My goal is to avoid the
> > > extra IPS_ bit.
> > 
> > You might create a race with ct gc that will remove the ct
> > if it is in close or end of close and before flow offload teardown is running
> > so flow offload teardown might access memory that was freed.
> 
> flow object holds a reference to the ct object until it is released,
> no use-after-free can happen.
> 

Also if nf_ct_delete is called before flowtable delete?
Can you let me know why?

> > It is not a very likely scenario but never the less it might happen now
> > since the IPS_OFFLOAD_BIT is not set and the state might just time out.
> > 
> > If someone sets a very small TCP CLOSE timeout it gets more likely.
> > 
> > So Oz and myself were debatting about three possible cases/problems:
> > 
> > 1. ct gc sets timeout even though the state is in CLOSE/FIN because the
> > IPS_OFFLOAD is still set but the flow is in teardown
> > 2. ct gc removes the ct because the IPS_OFFLOAD is not set and
> > the CLOSE timeout is reached before the flow offload del
> 
> OK.
> 
> > 3. tcp ct is always set to ESTABLISHED with a very long timeout
> > in flow offload teardown/delete even though the state is already
> > CLOSED.
> >
> > Also as a remark we can not assume that the FIN or RST packet is hitting
> > flow table teardown as the packet might get bumped to the slow path in
> > nftables.
> 
> I assume this remark is related to 3.?

Yes, exactly.

> 
> if IPS_OFFLOAD is unset, then conntrack would update the state
> according to this FIN or RST.
> 

It will move to a different TCP state anyways only the ct state
will be at IPS_OFFLOAD_BIT and prevent it from beeing garbage collected.
The timeout will be bumped back up as long as IPS_OFFLOAD_BIT is set
even though TCP might already be CLOSED.

> Thanks for the summary.
