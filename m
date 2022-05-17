Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D31C529C9E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243392AbiEQIhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiEQIhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:37:02 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20096.outbound.protection.outlook.com [40.107.2.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC7036151;
        Tue, 17 May 2022 01:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIm43zQwCIamqaYBP1gRn3kmX3Cc5NrjHhoZzrzzQdf9tM2wco/F240G2WSSSmrBkQNOygGWjOwAEV1iVsDTcp/p4jQGXaDyH/VBQ2JsO0WGyRCdGDW8wxAz0zbfJmjSDD9v/Gbbl04Q4Gk5ChY09Y4Vv3JNYB3XQtrv+7gPDKy0hNxA4STOjUmMM8N1QVQypvTa4vVKNl1QFRWBssCv87+3cFxa8qEvUrW2S8LQX1yI4JVSJ+IXETxts82i0AtAkEtL9nyy0T8O1vWVnL+o0ouzzxF8vF8jfAiw9B4BVr6sVPgeyWWCk85Ov99osvHDQPByentSyYMIatnjPSvU6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKVPGW/CueHG6UGMEvGXuOXSkeq0fs3lmjNbhrdB28I=;
 b=PHGfcKIO4Viaq3+QRal34CSqeKu0cCLC176+/UjIfptfH3IVZO1yRJqtynbT9V4MU5lT19kafMLN91LnaKe+C8GuMS2A0I9MkgND/My6p9IZi6UGax0vFYZBfDO7pQc7zSlXHOWDm+HO3IECGy7fEK0Q/PJD71CQ3EVoZVG+AqtnwRSubRN7U31YpJmWOYwVJ28UtuM2k2rIaY/4eEOydWSA762agyEofhvmmBYxxi1x4x4az6GId07ZX1Do/RCIV/KBhv+FQ0+TqVZWpKk5ntiQeig/S+C1GQTD0ztwR6ZMWDBfg81UIhcVOjeLLc5R0FhWgFWd3VzRV+jFkwcWfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKVPGW/CueHG6UGMEvGXuOXSkeq0fs3lmjNbhrdB28I=;
 b=GJuSZGtH7X5pvmnFrjnhU1KrqYB7k5phYhf7D2l/4cVApMsML23gYt4Arf1ehRnRbNguaG/mQKuXKBuNAb934Jnsm675Z74Kp9b22sAESlGM+9LlnOtpJHOQbcINIIkO5wva3QjecKnPW4T7ep/u2JDXHS4936tQzZ7NfLPPhdg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AM6PR0502MB3928.eurprd05.prod.outlook.com (2603:10a6:209:a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 08:36:56 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 08:36:56 +0000
Date:   Tue, 17 May 2022 10:36:52 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220517083652.xid6n5ssbi3dlsem@SvensMacbookPro.hq.voleatech.com>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <YoI/z+aWkmAAycR3@salvia>
 <20220516122300.6gwrlmun4w3ynz7s@SvensMacbookPro.hq.voleatech.com>
 <YoJG2j0w551KM17k@salvia>
 <20220516130213.bedrzjmvgvdzuzdc@SvensMacbookPro.hq.voleatech.com>
 <YoKO0dPJs+VjbTXP@salvia>
 <20220516182310.iiufw3exfy2xmb2l@Svens-MacBookPro.local>
 <YoNdg/5IBucYJ+hi@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoNdg/5IBucYJ+hi@salvia>
X-ClientProxiedBy: AS9PR06CA0070.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::21) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e72f7c97-6153-4eb0-c572-08da37e066c7
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3928:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0502MB39281D969041573E18D23613EFCE9@AM6PR0502MB3928.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktGT7Evc78qVRNwv8Nc7UnGd53h9IJSzuaiE6riuHAjRC6wW/jSBB4/c5FshGzsYR9qeG59H0zlEj+PJmLfk4xpkPR8SI1HPRfyVZ6KyDSU/Rf1VY64AQDxRTKtaLnLqvIErvaeXNUXzCXccQ4jAeNyHXTLJRHj7jXIMOh3tbIH9v0NLY9P9sdFTUgHBmFlYuc7nCOK0y9uRl2Z7gdt1bUKSp+s/FBMwkZpWYVyZW7TopH5rcJjquOqOpwqxgXMTvn5IPs9rcRwFQSxfqS5lKQZoTR5FXAMOKgHHDvsgivWDImwcddNwGxq4bHoqXN4n8hIyGYIwi14evxrN36801f+K4xMe22SlsequrF/GlUfaZgYweZt7jCWKcVXxKhCRDEoMIuNFHWfY3RQW9VzCMQ2/L/zJxMx/oBukr8humD6kp96kE4i4RJ2ij/T9n2wFOMQTHyO3GTBGJ5I9pIbidPvZgHc9ow1JMDIIbO2Sxcrg98D9kDSdLU2tq8dS84bWTjy4BAVeV7dlU39BGuMyfQVpNQZwbAOySSywmoSpsXS3NSKP7OXSYu7JFeXka7/TiQuF0MkOnxZnIcKylj+nGuu7uWICt7UcVgmn7cJKK5KH9KeNvkux59iviF0QU/4YmLReuDRf+4MRruFCALkhhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(39830400003)(396003)(366004)(376002)(346002)(54906003)(186003)(8676002)(4326008)(26005)(6916009)(6506007)(5660300002)(41300700001)(66946007)(316002)(66476007)(66556008)(6486002)(6666004)(44832011)(2906002)(38100700002)(9686003)(6512007)(8936002)(86362001)(1076003)(83380400001)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSOplnEwaw6EY62sdUUl1WKMY08JohLZo0utmq1Sx6hwfftGv0EflZrOdjhF?=
 =?us-ascii?Q?3+TpSOGwYigFmzSiSL+QViijmoPc6vVhgi9z2bfP82yRyxDMA509yTVoJeq2?=
 =?us-ascii?Q?6EvmYje+nEqpIHG27yq6aB/Wv523JxPDOHrsg35xghb7rGy5f0hEuVoZYCea?=
 =?us-ascii?Q?foWrnKMX1RujA+UXbBxl9l0N3LdgW8IQkJPXRZ07B17P/N8ltXiBHXgC5ZL3?=
 =?us-ascii?Q?DzQGbaEm4OOOlmq72P+m3Ljaagg6zz1BQOH3xSe1MsuQJqy/q2OA46uYL/Bw?=
 =?us-ascii?Q?+NOqnDVZq2v/5okPSjfmAheQOF7OVOtJut9jexUHJQTWukcdhL5cCrx2kQ6S?=
 =?us-ascii?Q?NPnxNSkbqWRj2UPGT3VaXruu33ogg8iNVqYcb0BziQpAOl+8vhK6uoyiv8zm?=
 =?us-ascii?Q?a2L/q9ih5L5TEBKi0J1wlVHzFnLVjqEGPVSBLfWVBqL5nLpjL0uyhy3jNYrT?=
 =?us-ascii?Q?ombv7D9u8SdYn0zxMweeTu8671Uc8Ncy+HUghT+31D+EdsRH6SwDCCQz6AIW?=
 =?us-ascii?Q?Mj1xMe8Rvf86bGsQ0A2uz4OKf1rN8iBB4+axGXNmVlK4daOIFFkbTofMdcyN?=
 =?us-ascii?Q?Umc+u8xWBiTNGrQpLFhriOKuxuoC/Lx0geqaV2uUfuXYmi4rjlTjcQulg+yk?=
 =?us-ascii?Q?RTLdUEquyl5Q8bNX7YiffxM1G8rzmyP3KhuI5KhU4sijY7y7M4ATVspvt8oy?=
 =?us-ascii?Q?zex+Dy73RGXwCNFcaF260F9Uj14Z84m902RcnWrvSJUr94i4j2EF++Jhw79r?=
 =?us-ascii?Q?GAHSMYUf6BuWdbTCjr05JftxjdZnvrF5mJEDcUPPz6HlkbEPfXt3jeFzMYNu?=
 =?us-ascii?Q?DfxGJR2KQ3pQU0YA0r2pgOGy10i4gjc0qOOiWFXoDx6T1X+MrZ3NKi+nArRN?=
 =?us-ascii?Q?ZDmeOSriwozQoc2xjxRVENP/ex4OmxStubESwbzn10MqybmEm6OAH9fuzjFe?=
 =?us-ascii?Q?Z8/khGogpbsi+IEmKH7sfFYNfzpT3ypz7cv5lW/MZWMI4DDvn6q+II0rBKji?=
 =?us-ascii?Q?0vqvTBKWH/VNzMxU7uNagMQyV/0Lb6qDql0BtH8qOGG1Pu5fRZNdvbUo5kXK?=
 =?us-ascii?Q?LeXjlkkCtOYiEy4EQo9f+h7YjgRwdSbTxFSXv23SSjOkJOjBPhQmuTkTSySa?=
 =?us-ascii?Q?s8yURVVIksig1Hn0dY2a1iF74/vLCZ1sIIhne4xpo3HH684EGpRQBArkTefX?=
 =?us-ascii?Q?syRE2yL8LoaJ5YpDNDiNeuxYlHGf/9/Fh6BddamPS7eG0aDJ1UxtDhhVlVM1?=
 =?us-ascii?Q?qfRekZBftSjApv7XYt21tHCthykfuuwUFonoNiwDZogZcjJvmf/XLomHyilD?=
 =?us-ascii?Q?+yZHtMcrjXX9SS3z4y92sWvu1K/JpTs1WQgCgF4gNF1hl8xLVjbnSi6J9Ypt?=
 =?us-ascii?Q?TCLcJul31d2EAc0BoJ37qixMWMfLsYO7LyrZ9JwhWRStHKmL/ikXjn0qk+9C?=
 =?us-ascii?Q?jqqsEDpWd4R9D7KGVpgf/wODspFVGBhT/bJRAlfRvTR8N+PH1Ec4vm/mv39a?=
 =?us-ascii?Q?Plj4j++QVn+h/394zdxgwf521h7dS6QmB29O/xGezu9pSi5pL3VKkRmtMfRi?=
 =?us-ascii?Q?DaBbOmMxAauMNdW+aIhP3/0ZJ3v0iyprS4zwrW57xm08ceeSgf5HDUsTBmjA?=
 =?us-ascii?Q?4LsQ+k2qeW6d1ThZKg/QxWN/u/HtGzRMAi658fVWWXZBzhGOHd+w6BRcZP9O?=
 =?us-ascii?Q?oeGksktdbyKpGSOo77RNn0XuraqLhznLZfDvtvCDCdWZ8yGyzGv1NCDaEJTg?=
 =?us-ascii?Q?aaM4anP0yV+9dlUWl3HXas8MHQH4rsA=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e72f7c97-6153-4eb0-c572-08da37e066c7
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 08:36:56.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkfAnO9ALPY2WKSFp/HwWfG5/gBkLQHgo21WngCAYkqJZGa5zhruyCZFD03Nem6GpglOnxWxvxn/DWT8k9xys49V09G52N1rcqOKkTR3Qks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3928
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 10:32:03AM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 16, 2022 at 08:23:10PM +0200, Sven Auhagen wrote:
> > On Mon, May 16, 2022 at 07:50:09PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, May 16, 2022 at 03:02:13PM +0200, Sven Auhagen wrote:
> > > > On Mon, May 16, 2022 at 02:43:06PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Mon, May 16, 2022 at 02:23:00PM +0200, Sven Auhagen wrote:
> > > > > > On Mon, May 16, 2022 at 02:13:03PM +0200, Pablo Neira Ayuso wrote:
> > > > > > > On Mon, May 16, 2022 at 12:56:41PM +0200, Pablo Neira Ayuso wrote:
> > > > > > > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > > [...]
> > > > > > > > [...]
> > > > > > > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > > > > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > > > > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > > > > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > > > > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > > > > > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > > > > > > >
> > > > > > > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > > > > > > -				nf_ct_offload_timeout(tmp);
> > > > > > > >
> > > > > > > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > > > > > > path that triggers the race, ie. nf_ct_is_expired()
> > > > > > > >
> > > > > > > > The flowtable ct fixup races with conntrack gc collector.
> > > > > > > >
> > > > > > > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > > > > > > the closing packets.
> > > > > > > >
> > > > > > > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > > > > > > in a TCP state that represent closure?
> > > > > > > >
> > > > > > > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > > > > > >   			goto out;
> > > > > > > >
> > > > > > > > this is already the intention in the existing code.
> > > > > > >
> > > > > > > I'm attaching an incomplete sketch patch. My goal is to avoid the
> > > > > > > extra IPS_ bit.
> > > > > >
> > > > > > You might create a race with ct gc that will remove the ct
> > > > > > if it is in close or end of close and before flow offload teardown is running
> > > > > > so flow offload teardown might access memory that was freed.
> > > > >
> > > > > flow object holds a reference to the ct object until it is released,
> > > > > no use-after-free can happen.
> > > > >
> > > >
> > > > Also if nf_ct_delete is called before flowtable delete?
> > > > Can you let me know why?
> > >
> > > nf_ct_delete() removes the conntrack object from lists and it
> > > decrements the reference counter by one.
> > >
> > > flow_offload_free() also calls nf_ct_put(). flow_offload_alloc() bumps
> > > the reference count on the conntrack object before creating the flow.
> > >
> > > > > > It is not a very likely scenario but never the less it might happen now
> > > > > > since the IPS_OFFLOAD_BIT is not set and the state might just time out.
> > > > > >
> > > > > > If someone sets a very small TCP CLOSE timeout it gets more likely.
> > > > > >
> > > > > > So Oz and myself were debatting about three possible cases/problems:
> > > > > >
> > > > > > 1. ct gc sets timeout even though the state is in CLOSE/FIN because the
> > > > > > IPS_OFFLOAD is still set but the flow is in teardown
> > > > > > 2. ct gc removes the ct because the IPS_OFFLOAD is not set and
> > > > > > the CLOSE timeout is reached before the flow offload del
> > > > >
> > > > > OK.
> > > > >
> > > > > > 3. tcp ct is always set to ESTABLISHED with a very long timeout
> > > > > > in flow offload teardown/delete even though the state is already
> > > > > > CLOSED.
> > > > > >
> > > > > > Also as a remark we can not assume that the FIN or RST packet is hitting
> > > > > > flow table teardown as the packet might get bumped to the slow path in
> > > > > > nftables.
> > > > >
> > > > > I assume this remark is related to 3.?
> > > >
> > > > Yes, exactly.
> > > >
> > > > > if IPS_OFFLOAD is unset, then conntrack would update the state
> > > > > according to this FIN or RST.
> > > >
> > > > It will move to a different TCP state anyways only the ct state
> > > > will be at IPS_OFFLOAD_BIT and prevent it from beeing garbage collected.
> > > > The timeout will be bumped back up as long as IPS_OFFLOAD_BIT is set
> > > > even though TCP might already be CLOSED.
> >
> > I see what you are trying to do here, I have some remarks:
> >
> > >
> > > If teardown fixes the ct state and timeout to established, and IPS_OFFLOAD is
> > > unset, then the packet is passed up in a consistent state.
> > >
> > > I made a patch, it is based on yours, it's attached:
> > >
> > > - If flow timeout expires or rst/fin is seen, ct state and timeout is
> > >   fixed up (to established state) and IPS_OFFLOAD is unset.
> > >
> > > - If rst/fin packet is seen, ct state and timeout is fixed up (to
> > >   established state) and IPS_OFFLOAD is unset. The packet continues
> > >   its travel up to the classic path, so conntrack triggers the
> > >   transition from established to one of the close states.
> > >
> > > For the case 1., IPS_OFFLOAD is not set anymore, so conntrack gc
> > > cannot race to reset the ct timeout anymore.
> > >
> > > For the case 2., if gc conntrack ever removes the ct entry, then the
> > > IPS_DYING bit is set, which implicitly triggers the teardown state
> > > from the flowtable gc. The flowtable still holds a reference to the
> > > ct object, so no UAF can happen.
> > >
> > > For the case 3. the conntrack is set to ESTABLISHED with a long
> > > timeout, yes. This is to deal with the two possible cases:
> > >
> > > a) flowtable timeout expired, so conntrack recovers control on the
> > >    flow.
> > > b) tcp rst/fin will take back the packet to slow path. The ct has been
> > >    fixed up to established state so it will trasition to one of the
> > >    close states.
> > >
> > > Am I missing anything?
> >
> > You should not fixup the tcp state back to established.
> > If flow_offload_teardown is not called because a packet got bumped up to the slow path
> > and you call flow_offload_teardown from nf_flow_offload_gc_step, the tcp state might already
> > be in CLOSE state and you just moved it back to established.
> 
> OK.
> 
> > The entire function flow_offload_fixup_tcp can go away if we only allow established tcp states
> > in the flowtable.
> 
> I'm keeping it, but I remove the reset of the tcp state.
> 
> > Same goes for the timeout. The timeout should really be set to the current tcp state
> > ct->proto.tcp->state which might not be established anymore.
> 
> OK.
> 
> > For me the question remains, why can the ct gc not remove the ct when nf_ct_delete
> > is called before flow_offload_del is called?
> 
> nf_ct_delete() removes indeed the entry from the conntrack table, then
> it calls nf_ct_put() which decrements the refcnt. Given that the
> flowtable holds a reference to the conntrack object...
> 
>  struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
>  {
>         struct flow_offload *flow;
> 
>         if (unlikely(nf_ct_is_dying(ct) ||
>             !refcount_inc_not_zero(&ct->ct_general.use)))
>                 return NULL;
> 
> ... use-after-free cannot happen. Note that flow_offload_free() calls
> nf_ct_put(flow->ct), so at this point the ct object is released.
> 
> Is this your concern?

Ah yes, thank you.
I did not catch the refcount_inc_not_zero call.

> 
> > Also you probably want to move the IPS_OFFLOAD_BIT to the beginning of
> > flow_offload_teardown just to make sure that the ct gc is not bumping up the ct timeout
> > while it is changed in flow_offload_fixup_ct.
> 
> Done.
> 
> See patch attached.
> >
> >

The patch looks good to me, one remark.

This has to be

-		if (unlikely(!tcph || tcph->fin || tcph->rst))
+		if (unlikely(!tcph || tcph->fin || tcph->rst ||
+			     !nf_conntrack_tcp_established(&ct->proto.tcp)))
 			goto out;

You are currently go to out if the tcp state is established but you
want the opposite, not established.

I think this will cover all cases.

Best
Sven

