Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E183528CD1
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344693AbiEPSXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiEPSXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:23:18 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30126.outbound.protection.outlook.com [40.107.3.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784DB31504;
        Mon, 16 May 2022 11:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkxOgRr8w5HsTzh4izqYbQhfTo23eX2p+o7cI8u0tZ6WGIC+7Pihn9JaPY4bKkEw84Tc0PHMakHQZHWITh2Chea9YXHAmX8m4OwtN1d0akwwN19aGKAxRaVYa4LYv0d/l6Rrk+gZoKiJBn+ZM8pXCIjgshptPm7jRgvmJJST4fS9At3ySdiupMhjWB8prAbvcQlSXet6mYp/O2N8s1UsXz9MEQ7nA1PcgL0ppq+Nds6S3Acmm2fKXdsxzJX+Y/+4QEjIAaAZVpJd+hRRSiHWwg4hFHEw5ZKzMIY/lDnoXBxmELnuugeT4tIcDnZlSg8aBNJA/kSavAUN0/riSGhH5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZNYLqCcd/JNtpcMMzQDVErv5wGkBzce1ApihZVo+Tuo=;
 b=SNdgCXpAZWfWn8CVc9sagnRzZV9F4go+LBKViw414tBS651wjyd7fNkVPMFbifn3I230qVyyLRkS1bnIYQZDCbvl0c+ywDN2QGq7EoifppxW9mKuY64IMo55D3Kw158jwlO3AQSykSKWhkvgd/XPtr0OtaNCRY/MqHdqifHYTbi6/zef1c/Skn4GMgQyJJRutl8krDibV9ngNB+6KlPniF+aXHUfsSeVCmYGkQx0VAEMTvV86v6cvmrJ5N+8Ba1fVKVwLzFTx3yL+Q0Kego8n5kaNFFtjDImPxv9Srreq9iOfOxN9daIqEcgyg5FK2/Bkg90FEnbAa3HfgcgSGe9QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNYLqCcd/JNtpcMMzQDVErv5wGkBzce1ApihZVo+Tuo=;
 b=CegLLLJ0MtRDMbHzLw+5Od1CJ5IxA/Wa/g4L6JfyUV+Qhu8Eh+vLd59A8CT93IYNvFEWzy3IgT+kiN6GbjBWBWS+/OU/bYe3JDFQBPRog79VWj2c51bF+qzayPDkzxmiPkVSagIfyK8xWPWXWB7Hrqu8/90vS0UZbamD5k/cnvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AS1PR05MB9249.eurprd05.prod.outlook.com (2603:10a6:20b:4d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 18:23:14 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 18:23:14 +0000
Date:   Mon, 16 May 2022 20:23:10 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220516182310.iiufw3exfy2xmb2l@Svens-MacBookPro.local>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
 <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
 <YoJG2j0w551KM17k@salvia>
 <20220516130213.bedrzjmvgvdzuzdc@SvensMacbookPro.hq.voleatech.com>
 <YoKO0dPJs+VjbTXP@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoKO0dPJs+VjbTXP@salvia>
X-ClientProxiedBy: AM5PR0301CA0035.eurprd03.prod.outlook.com
 (2603:10a6:206:14::48) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9c6a690-6f86-4e17-8b75-08da376923c9
X-MS-TrafficTypeDiagnostic: AS1PR05MB9249:EE_
X-Microsoft-Antispam-PRVS: <AS1PR05MB924903B2BF079A337788AB36EFCF9@AS1PR05MB9249.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1ebV0mN5j8RofKOuOE/pQvhTjJfoBMJ9kYBrGef+7ntTSS8XvPdsffuywV+q+86+8LvKYhaJE4LoY9BO/N9OkRnUfMDGcsrQ9Hsft4RPhM1oR2or6FTAtig283dAAwvdn6KHrld5wHUjT0HbXRhRq3M7zCU/yZrxTxCiQ7fJVL1zXdAlf3hUYgV4b1Sp40rIbYb7aS5hzHOoTgus2ahCbWD3zSwMoTnjomcytbLEF/f/6a1NZM2vveqapYDKekhJt4TClaPBny8kEOvKOlpsh7aTCA9AODnTbUzWxKGI0mgXVMNWEgquUhewQt2jxrX1GUSL9jA9D1IzHNtaojIctFrSUT9VEumBh1W45fj7bOCNGpfeBqKeBTdqsl+ljzDqDlfV10Ed/CMpeTPZUm+d4mqLA10W3eHhWygYj9iEEPK437mL7tqg0IIDKr4Ga6fJf89Kmv1J3uieJXbwqeYR/GZBZKQ6YPWr+fYl7E5LYaQvYF8ShlCdUYJG4MWiBTQ21eFK9fwmNOMRruD8iIjUOfR1iwT9Nenj39KjfXYMiHjDlFNzE8sjLbPtITgmox1DIw3oFaOlXqNxEycJaIgI37+x1H/Aefv8cR7KxZil5/F2ZPU3pptVmHE7rMANNpPHhUxf9inMXxza1xbwVaYEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39830400003)(136003)(346002)(376002)(366004)(396003)(66946007)(66556008)(4326008)(66476007)(86362001)(8676002)(44832011)(54906003)(316002)(6916009)(8936002)(6486002)(5660300002)(508600001)(38100700002)(1076003)(186003)(6512007)(26005)(2906002)(6666004)(83380400001)(6506007)(9686003)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MWw2G56pPVcKByP4o0oTGrpl+lmw6ULWzrKcd8SdESVz1kvLCwO/3yfX4bN0?=
 =?us-ascii?Q?7FzzbciQvfepANCCEd5FtE0uNQFkvC28htW7aauy1Ncsq6+NGytiPPwO7Ffr?=
 =?us-ascii?Q?Fx0QWYPLs5jjLx3QsixSrf1hwbYSG2K5H+rRRJPS2TW2p1ub2Gqd5L9ZsMy7?=
 =?us-ascii?Q?vIVSJ8ga7+YafvxjfsEp5yj5aznTIixK8kX3Xihzs7ZbGxr8VyHp1OLrRqww?=
 =?us-ascii?Q?E2tERvbxhQoZJVlu4lgFqFythmQ3gHGwN7DqLndTvW9B6tDjRQsOWMcsgQRc?=
 =?us-ascii?Q?1ONd8h0Xe2wKIvicYYJ0QD38WARcqvNi41caqzSs02VYj80stfL7oUJsIYAa?=
 =?us-ascii?Q?0ZsMwUED6rYaNJQLRusnb7Mu+pAbc0qjSRsitILy3En91sJJdoXmoMsKRf2A?=
 =?us-ascii?Q?qNm99pZLqVcnb26TAw6+0OZHaTHevNnymzSg0i1a5f/GMhUQHy/X4VBums2u?=
 =?us-ascii?Q?jph3NyMlG9ykyjnHv2N4HT22qYzbZE2oWFujdF2SI4WXG5u9rsX07OC1ekQi?=
 =?us-ascii?Q?3LQPnX16evtOvPD1XyTMbm8ajoSYVGDq753qAeM1N6daeXSGnQWirj6jaJz7?=
 =?us-ascii?Q?rgNTkSDp816B6yIKepTZaWVSGa9YXHZGh8aZsdk0RXhEcgtwbyV1kbz+cJ4R?=
 =?us-ascii?Q?dHR+Y6sf0yLSWEmODJR+l94NYCRSiEYG1ruK6QXa+prj3NcRNJ6AsepOPd4t?=
 =?us-ascii?Q?X8Dd+MqGulApkR3WSQQGchg0w7Md8llKrzV8IM3gJex1hwjBQXL57QomaZr3?=
 =?us-ascii?Q?zUDGTUvZQ8RXMVcYQVUwQlJussNGdt8W1X/gL/4mV9N3qD02YHF83GteePM/?=
 =?us-ascii?Q?GVJseFDYCb4z2dMPxtd3SHEr+SEIKQG9V9F3u7AbFt6BjBhyUnEZ4ct1wrfg?=
 =?us-ascii?Q?f/RFnbCcwq4oqGWd6xe/Vbj4gT/+TumHp80d9r/WMV4kRGWlr0nyiW43ESLh?=
 =?us-ascii?Q?XKV8u91uki1lYm+m6T1TO2RVcyvHL8+Xq77VVe+PM4Humj0DHFS5GCmlIcz2?=
 =?us-ascii?Q?cVOjUppSwHmVVN0Ua0rvlkGU6BsSckknFhAJGMviaiL+K+cuL4XtgyAsFh/z?=
 =?us-ascii?Q?zWLhPHRGu2n9Zw0HJkW+ESB1gHzMlq/LHwVOBiJQiVcKPikEvyNn/47DT92R?=
 =?us-ascii?Q?RjhVDReC6cxHn+2QQY9FpS9oVcu6zaPgI5cl8OHPmzxV8MNn8yV6c4tS+4cL?=
 =?us-ascii?Q?LusbgNhsxUeX7Ox5vAQlsSo5luY5NJSdWTyMVuRXOQnMEdRc8gFRA2uXglbe?=
 =?us-ascii?Q?H9EO+JW4sFQK/zUayK3E5JJ7Oq+aBLE5CKLA4b/eCRdTLPDFRWd4wUa5kFAI?=
 =?us-ascii?Q?l8i32tBKHzgx6dQWqRCRQE/I49ISdT9pLw66lxWPs1F7ItBRlPV6aMJqjI4L?=
 =?us-ascii?Q?qGcreFEqgei5B9GHDeik7LIL0LQRq8cEOvuCrloj2WlhID0YsPt/71JsZVfh?=
 =?us-ascii?Q?tM7/4FMBviVSnCQ3xrhuMrBU1KUkmGLRyJch+i2nYScA0Jt3/vMBjH5SDQkH?=
 =?us-ascii?Q?xWQVK8ncxtXxS++xo85vvRwHWFAWWe4GvV48WhXZyr6L6sR/9edblzwvYwk1?=
 =?us-ascii?Q?vNzkHZXZsGFeS73lDBNCzNMkyW5SuqAJhKHoLeNik4G13St/hdbaFdgnrzpY?=
 =?us-ascii?Q?KxrdPr4XyCTkauajs9NrrBzzN7EAzaWedI+4vV1CpHDCQOPFI6DuvYfytHBE?=
 =?us-ascii?Q?aeL/6JKlnXs6kWL5rkbixP1rn2HCO8XZrN82m13BsYGll+5dr9UcDtlZhjWn?=
 =?us-ascii?Q?EghVg1SVKzv3GulhO3ogDtIlnidlGpk=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c6a690-6f86-4e17-8b75-08da376923c9
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 18:23:13.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gRYzJcjSDgvQeQSfgbHlDiRmC2iGBLJDlvyXD5g0K6PwVlXvLN/oIjxugBnz9ASg8402cKA3A1w+XIBtjwgywVH0FuBFjJksyMvy3s0aE24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR05MB9249
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 07:50:09PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 16, 2022 at 03:02:13PM +0200, Sven Auhagen wrote:
> > On Mon, May 16, 2022 at 02:43:06PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 16, 2022 at 02:23:00PM +0200, Sven Auhagen wrote:
> > > > On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > > > > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> [...]
> > > > > > [...]
> > > > > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > > > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > > > > >  
> > > > > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > > > > -				nf_ct_offload_timeout(tmp);
> > > > > > 
> > > > > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > > > > path that triggers the race, ie. nf_ct_is_expired()
> > > > > > 
> > > > > > The flowtable ct fixup races with conntrack gc collector.
> > > > > > 
> > > > > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > > > > the closing packets.
> > > > > > 
> > > > > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > > > > in a TCP state that represent closure?
> > > > > > 
> > > > > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > > > >   			goto out;
> > > > > > 
> > > > > > this is already the intention in the existing code.
> > > > > 
> > > > > I'm attaching an incomplete sketch patch. My goal is to avoid the
> > > > > extra IPS_ bit.
> > > > 
> > > > You might create a race with ct gc that will remove the ct
> > > > if it is in close or end of close and before flow offload teardown is running
> > > > so flow offload teardown might access memory that was freed.
> > > 
> > > flow object holds a reference to the ct object until it is released,
> > > no use-after-free can happen.
> > > 
> > 
> > Also if nf_ct_delete is called before flowtable delete?
> > Can you let me know why?
> 
> nf_ct_delete() removes the conntrack object from lists and it
> decrements the reference counter by one.
> 
> flow_offload_free() also calls nf_ct_put(). flow_offload_alloc() bumps
> the reference count on the conntrack object before creating the flow.
> 
> > > > It is not a very likely scenario but never the less it might happen now
> > > > since the IPS_OFFLOAD_BIT is not set and the state might just time out.
> > > > 
> > > > If someone sets a very small TCP CLOSE timeout it gets more likely.
> > > > 
> > > > So Oz and myself were debatting about three possible cases/problems:
> > > > 
> > > > 1. ct gc sets timeout even though the state is in CLOSE/FIN because the
> > > > IPS_OFFLOAD is still set but the flow is in teardown
> > > > 2. ct gc removes the ct because the IPS_OFFLOAD is not set and
> > > > the CLOSE timeout is reached before the flow offload del
> > > 
> > > OK.
> > > 
> > > > 3. tcp ct is always set to ESTABLISHED with a very long timeout
> > > > in flow offload teardown/delete even though the state is already
> > > > CLOSED.
> > > >
> > > > Also as a remark we can not assume that the FIN or RST packet is hitting
> > > > flow table teardown as the packet might get bumped to the slow path in
> > > > nftables.
> > > 
> > > I assume this remark is related to 3.?
> > 
> > Yes, exactly.
> > 
> > > if IPS_OFFLOAD is unset, then conntrack would update the state
> > > according to this FIN or RST.
> > 
> > It will move to a different TCP state anyways only the ct state
> > will be at IPS_OFFLOAD_BIT and prevent it from beeing garbage collected.
> > The timeout will be bumped back up as long as IPS_OFFLOAD_BIT is set
> > even though TCP might already be CLOSED.

I see what you are trying to do here, I have some remarks:

> 
> If teardown fixes the ct state and timeout to established, and IPS_OFFLOAD is
> unset, then the packet is passed up in a consistent state.
> 
> I made a patch, it is based on yours, it's attached:
> 
> - If flow timeout expires or rst/fin is seen, ct state and timeout is
>   fixed up (to established state) and IPS_OFFLOAD is unset.
> 
> - If rst/fin packet is seen, ct state and timeout is fixed up (to
>   established state) and IPS_OFFLOAD is unset. The packet continues
>   its travel up to the classic path, so conntrack triggers the
>   transition from established to one of the close states.
> 
> For the case 1., IPS_OFFLOAD is not set anymore, so conntrack gc
> cannot race to reset the ct timeout anymore.
> 
> For the case 2., if gc conntrack ever removes the ct entry, then the
> IPS_DYING bit is set, which implicitly triggers the teardown state
> from the flowtable gc. The flowtable still holds a reference to the
> ct object, so no UAF can happen.
> 
> For the case 3. the conntrack is set to ESTABLISHED with a long
> timeout, yes. This is to deal with the two possible cases:
> 
> a) flowtable timeout expired, so conntrack recovers control on the
>    flow.
> b) tcp rst/fin will take back the packet to slow path. The ct has been
>    fixed up to established state so it will trasition to one of the
>    close states.
> 
> Am I missing anything?

You should not fixup the tcp state back to established.
If flow_offload_teardown is not called because a packet got bumped up to the slow path
and you call flow_offload_teardown from nf_flow_offload_gc_step, the tcp state might already
be in CLOSE state and you just moved it back to established.
The entire function flow_offload_fixup_tcp can go away if we only allow established tcp states
in the flowtable.

Same goes for the timeout. The timeout should really be set to the current tcp state
ct->proto.tcp->state which might not be established anymore.

For me the question remains, why can the ct gc not remove the ct when nf_ct_delete
is called before flow_offload_del is called?

Also you probably want to move the IPS_OFFLOAD_BIT to the beginning of
flow_offload_teardown just to make sure that the ct gc is not bumping up the ct timeout
while it is changed in flow_offload_fixup_ct.


