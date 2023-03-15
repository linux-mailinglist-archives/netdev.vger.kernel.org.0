Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182396BBB0D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjCORkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCORkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:40:00 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2136.outbound.protection.outlook.com [40.107.105.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C637717
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 10:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3pXdBPrdqddxTzjUZp3OVDTgUd+ggIUFgjUV9Zn7jrA7+a4WQ5JVpvRTd4DoR/brHUoayqMNV+hxhP3H2RebcHm1sNlo+zbrkagjl9FtbiEW1Y0Nog1A05M2uM9LcWA/NTiWP4hkt8E7/pcs+MobYgE6joDLofWFQUXqWJ1N+i2syNjpKD2PNZ8ACf500nmMNphO/+Lr3m7GUv2YNk2LSjiqQaKmUiIpBXvw72tH5+LiRB7hc9p4DBAdSbnz8u6II6QX+d/vzYH5sXYO9at+zkMlLuR41Pg5W+Qc5j4QVVcNPHZSpy6pHsP+T8K5B9J41f4IjDXKsu0RBVyVWcLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aBJPPmu6ilHmOi/5OXZMFT3RMxAmHSEK3YoUhwBSMA=;
 b=lIzB3RXS7LtUmCVbAZl50uMqm+PNId8uXjeqZnmEKYSVNgBE+jzpwH9OR+42pbpD5WEEwlWbRk9my69wzmOyfLTC7ttaJwM9Apa9jvlqtPrcHVfLcOIyxqrPCdAy91LeQOoX5nHyP3tyU+7O7iGdgBhUXGC2GxV6BEpmmKTrFvq80Hb1XG2tjanzW8tb9SjM181uSFDOTQCV7/ipYsL9JdQ2uErYqHZrDiFuL/5u7mEfxHMhQULVl9oPR+ExjC0+gsaWiPz9tfI09XgQ/Vf7y2ZvhLZpADjpDQTT4AAWMHGrH8BkSDBacVv7PHS1tUqLk0DoOp/F6Be1jIR+CgZ+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aBJPPmu6ilHmOi/5OXZMFT3RMxAmHSEK3YoUhwBSMA=;
 b=B7mZ+Myx4Y4w3spvgRyMZDqtmOLqRAvYleYS6YLSSYun39diGmp+dyXBN7BgrtDVpJiEO+FwVmnwQCbKlMS9/3RADTZ8vFinhO1q6KmNoknJ9d6ESyqwwuSrUQoIR/zC/QR0DH1qx82B0loXf5SdQx0oWHjqvmO9RQFbCcuAapY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PAXPR05MB8863.eurprd05.prod.outlook.com (2603:10a6:102:21a::23)
 by PR3PR05MB7212.eurprd05.prod.outlook.com (2603:10a6:102:82::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 17:39:54 +0000
Received: from PAXPR05MB8863.eurprd05.prod.outlook.com
 ([fe80::8449:b69f:5b97:2b3c]) by PAXPR05MB8863.eurprd05.prod.outlook.com
 ([fe80::8449:b69f:5b97:2b3c%8]) with mapi id 15.20.6178.027; Wed, 15 Mar 2023
 17:39:54 +0000
Date:   Wed, 15 Mar 2023 18:39:49 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315173949.nakq7gk7c2wyqt6j@Svens-MacBookPro.local>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
 <20230315083148.7c05b980@pc-7.home>
 <20230315075330.zklzcdt3sukc5jy2@SvensMacbookPro.hq.voleatech.com>
 <20230315111950.04deda46@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315111950.04deda46@pc-7.home>
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To PAXPR05MB8863.eurprd05.prod.outlook.com
 (2603:10a6:102:21a::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR05MB8863:EE_|PR3PR05MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 157c8ff3-1659-4ce5-7844-08db257c4942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwYcXg/7arfyrOpbYu8P3v8m+G0hAaJuoTPz9M1Migdq2AaCJ5M+hC0jGJGSMH/rNZV4DSNF0OReA0yG4RXpm93KFenhxcjOQIvptvdPMHJwU+d8yFlOS0B5P3te58MsJIn3J40SJko2mqLpYkfxSAtAJI4leO6Qdtzw8MszbtIBbPBYrzjbnAGCsRxrZAlYMx0DkMl076V9LATbYqBQiMc9wtv/zmHUU+XfkvVA3jA1ewHJ9Noik0otZvVvZhIN/0UF1zGrwxrmZBsE8L1EpHnpnF489/I97MXU10JGbTPExe4YiCPN6k17jDl2L8FO3gQfz+rHp/51gLyYNqwTSe2AunCnQPSEa9TqFJIsShowIiAXpeuB6MHbPnuymSa0z6Kw4e5QH7ZVHGNa1gWKUJpMVpSahUpZ9/0ziwn7L8N2myMkrudAqC2y/QBzGQ1szmMxTco1MxSify/wqWyyxr4yYzxNrLMOMwub251to6W+a1tEZxcf79X0GNKsa2yT4l72RiV784PRZq5XjXfOIRYiNUMBH7qwGs2fMz9gyLLZYfEtHgloaNGAmWWFVXur7rmMbrUHjv5LI/Crakds6w5zkQ6C/32CNyjhuM0upmQPRljoyXfYxtqsd/Pz6Q12
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR05MB8863.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(396003)(376002)(346002)(366004)(451199018)(66899018)(44832011)(30864003)(5660300002)(41300700001)(8936002)(2906002)(38100700002)(478600001)(45080400002)(6486002)(66556008)(966005)(6666004)(66946007)(8676002)(66476007)(6512007)(6506007)(4326008)(6916009)(83380400001)(316002)(1076003)(186003)(26005)(86362001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T34IYDZGZ7Kjs52slIsjoqbfg29XryOTtsD8V25PxtWU6yyC3d1YL0aokWwP?=
 =?us-ascii?Q?YGgcUShBjtbGx7wRKl1CkzM3w29YzDxo1SP4hTzn2b+818dcKNpKc6tkvOHR?=
 =?us-ascii?Q?Li3lXoDxhky/kQ4FpWz232Ehx4cO2NLgtYi6qMnPpATiEyqOxgUGSHGz1f+D?=
 =?us-ascii?Q?ZpzOhYHEiNNNo9NOt/TZYjwMwGHesIx9U4Tb2DkLIWaY1JjNsChYjOx3vi9n?=
 =?us-ascii?Q?W2vpkWChnCjkk3+Mj71Hwzi7GbDvURM9PK5LB9aF6d7hfxFGOp7SPdec1CFb?=
 =?us-ascii?Q?oZqAYG/CzHTRufrjJbhaLK4Jkl9WJdhk3+iJ5HaAth8BLrgkE6pn1UA1KzCv?=
 =?us-ascii?Q?1k9kBdMBfdARU8EDqVE4JT5BMbXwNdCdLAVUL8J0UnRUzKkSMx9E+oRKbANV?=
 =?us-ascii?Q?u8+IboEfQxE3h9dNz+JtXRDpYMzJRY7AhzqYpk7+mVz1qowtJK/0muNj2mff?=
 =?us-ascii?Q?OW6t5Jk7UTLzKmSZf6C6A1p5uImuPjUBMGiAOs4XBimaNqRHYp/KjGhx+Di2?=
 =?us-ascii?Q?/HORO73J19XtST0bBrHBYMdTlH1A3LTuXGJz746rV0sYy6LWtNZTXVFaArh5?=
 =?us-ascii?Q?KDoO1dEkoBAKYPXuXOS70ldqwwn6208cd8n7wfIAdNqnWyz7rMqkO2whOkA9?=
 =?us-ascii?Q?6mvaKKAQryfOKYWJfkPnWWeQ7Cx3lFd18g+yFSXFiilEGYYwUcN5KAX4wg9f?=
 =?us-ascii?Q?RsTEq7OCN9VIY3Hex4qLDpbVQphr+qxjho9E99KC5Nk4YEA/8egl4uOJ9LuU?=
 =?us-ascii?Q?j035AYbsUNceatZndiPD9XJt+OluDGUtoMwq+RaMn+KvIRnOD2JXKaU4eyfJ?=
 =?us-ascii?Q?7gElMzgz5YufJuakw/cT7WlrJGT7M1lBk0Hx3bOaFuXL6Bv3wicM4Y5EpV06?=
 =?us-ascii?Q?i++KZjx6fBNYJsqEqaSi9o5J6/Aot7/yQWYYcR5vKPwaqGtLmB57rFA/4edg?=
 =?us-ascii?Q?ynkE60PeIQN302MNRPjaar1yFbS40eXBGXTEaRueeavANcpMyBnQZNGyddMO?=
 =?us-ascii?Q?gdaqBMuo0prsDp+T0NTOqtTaOXwu8JokNmgZYVKfTzS45qyZL9Kxw9sRiVci?=
 =?us-ascii?Q?ZdUB5FMKNTxs4AExTSzZ2zyjedEr/+ZaFP/yO/FS4PC7bod/LgguUQPh6lYQ?=
 =?us-ascii?Q?E1SRywXzL3dmH+WmGmcGt9ZpQeYBteN2HJHcwXCdlU1EtGkBXfpEpzfMEm21?=
 =?us-ascii?Q?nd5gnWTtzGvk4JDRL4TKlY1mJjtFPdEO0a2DrXp2mFoJfHYp3EIlGf44hgg6?=
 =?us-ascii?Q?MRLX+DGiB/W+8anUvPQwMB1+U6dD6kpbCZ4xIIVahkcKjZspeDSytKp8wvTj?=
 =?us-ascii?Q?H3no9pEBHWDD6uwh35rlSKljVFuOj0RFat0TyqguvQB+unKg6tR9RT2D4MGX?=
 =?us-ascii?Q?Jb2x83dmBTGPNIJLfPyZuD815Kr2bsDiF7qvr/AgsJiQgJ0caOVaP73zbdM7?=
 =?us-ascii?Q?8DK3AQCyZriFSCI82ast9AUIDYRxYIjn8D8yqLNH8gpdwgQHhw4/F22csyzN?=
 =?us-ascii?Q?PM4CDR47kwCH/RHpyI1DbRAYRys2YUmRdF1deqN4EZ51UvjyIBvkw6w8giLx?=
 =?us-ascii?Q?RDgNZdeJJupBWxOwjsJktvn3/kKdAEdJ0mWaaKG1bNmsSrxxhJgi1zU6cHcF?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 157c8ff3-1659-4ce5-7844-08db257c4942
X-MS-Exchange-CrossTenant-AuthSource: PAXPR05MB8863.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:39:53.9728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0SFEFHIoXtW5t2z+7i7MnJQqzvYB+8mSbr9LTquxbW1zU0UZBBa4pj0+IZFPL1DYd9aufw/z3NM6cYPKPqCQEluyir4MMlrjTpsDf/qe9K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB7212
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:19:50AM +0100, Maxime Chevallier wrote:
> On Wed, 15 Mar 2023 08:53:30 +0100
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> 
> > On Wed, Mar 15, 2023 at 08:31:48AM +0100, Maxime Chevallier wrote:
> > > Hello Sven,  
> > 
> > Hello Maxime,
> > 
> > > 
> > > On Sat, 11 Mar 2023 08:09:48 +0100
> > > Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> > >   
> > > > The classifier attribute MVPP22_CLS_HEK_TAGGED
> > > > has no effect in the definition and is filtered out by default.  
> > > 
> > > It's been a while since I've worked in this, but it looks like the
> > > non-tagged and tagged flows will start behaving the same way with
> > > this patch, which isn't what we want. Offsets to extract the
> > > various fields change based on the presence or not of a vlan tag,
> > > hence why we have all these flow definitions.
> > >   
> > 
> > In the sense of a match kind of.
> > There is one classifier match for no VLAN and one for any number of
> > VLANs. So no VLAN will match twice, correct.
> > 
> > This is the case right now anyway though since
> > mvpp2_port_rss_hash_opts_set is filtering out MVPP22_CLS_HEK_TAGGED
> > for all rss hash options that are set in the driver at the moment.
> > 
> > MVPP22_CLS_HEK_TAGGED is also not compatible with
> > MVPP22_CLS_HEK_IP4_5T which is probably the reason it is filtered out.
> > 
> > The HEK can only have a match on up to 4 fields.
> > MVPP22_CLS_HEK_IP4_5T already covers 4 fields.
> 
> That's not exactly how it works, the HEK comes in play after we have
> identified each flow during the parsing step, see my example below.

Sorry there was something off with my last email.
Yes, understood.

> 
> > I disabled the hash_opts line which removes the HEK_TAGGED and the
> > entire rule will fail out and is not added because of that.
> > 
> > So I am simply removing what is not working in the first place.
> > 
> > > Did you check that for example RSS still behaves correctly when
> > > using tagged and untagged traffic on the same interface ?
> > >   
> > 
> > Yes all RSS work fine, I tested no VLAN, VLAN, QinQ, PPPoE and VLAN +
> > PPPoE.
> > 
> > > I didn't test the QinQ at the time, so it's indeed likely that it
> > > doesn't behave as expected, but removing the MVPP22_CLS_HEK_TAGGED
> > > will cause issues if you start hashing inbound traffic based on the
> > > vlan tag.  
> > 
> > Please see my comment above.
> > 
> > > 
> > > the MVPP22_CLS_HEK_TAGGED does have an effect, as it's defined a
> > > (VLAN id | VLAN_PRI) hashing capability. Removing it will also break
> > > the per-vlan-prio rxnfc steering.
> > > 
> > > Do you have more details on the use-case ? Do you wan to do RSS,
> > > steering ?  
> > 
> > I want to have RSS steering for all cases I tested above.
> 
> Can you provide example commands you would use to configure that, so
> that we are on the same page ?

I did not use any custom rss rules.
I just enabled rxhash ethtool -K eno4 rxhash on
and otherwise the default rss opts are all I need:

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c#L1734

I am trying to make them work with all the different cases I mentioned.
There was a problem with fragmented packets, QinQ and PPPoE.

> 
> > Do you have a different place that I do not know of where
> > MVPP22_CLS_HEK_TAGGED is actually loaded?
> 
> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fnet%2Fethernet%2Fmarvell%2Fmvpp2%2Fmvpp2_cls.c%23L1647&data=05%7C01%7Csven.auhagen%40voleatech.de%7C55114657d9d54ea1d71408db253ed26b%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C638144723979910055%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=u78kzZ3oo%2BIxbhgGR1VGp48GbhQRvEokCIhiynwwDMo%3D&reserved=0
> 
> Here the MVPP22_CLS_HEK_OPT_VLAN is loaded, and by removing
> MVPP22_CLS_HEK_TAGGED, this option will get filtered out.
> 
> In the flow definitions, the MVPP22_CLS_HEK_TAGGED field indicates the
> possible HEK fields we can extract in this flow, not the ones that will
> actually be extracted.
> 
> It is possible for example to use :
> ethtool -N eth0 flow-type tcp4 vlan 0xa000 m 0x1fff action 3 loc 1
> 
> This makes any TCP over IPv4 traffic coming on VLAN with a priority of
> 6 to go in queue 3. In this case, we'll only have the vlan pri in the
> HEK. This will therefore apply regardless of the src/dst IP and src/dst
> port.
> 
> The various flows defined here come from the parser, so when we hit a
> particular flow we know that we are dealing with "tagged TCP over IPv4"
> traffic, it's then up to the user to decide what to do with it, with
> the limitation of 4 HEK fields.

I understand your case now when using ethtool.
I will keep the MVPP22_CLS_HEK_TAGGED in and just fix the fragmented
problem in the first patch.

It does not matter much for my use case since I am using the default RSS
hash opts and not a custom one.
In the default RSS the HEK_TAGGED is filtered out and removed.

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c#L752

> 
> > > 
> > > I however do think that the missing frag flags are correct, and
> > > should be sent in a separate patch.
> > >   
> > 
> > Will do that in v2.
> > 
> > > Thanks,
> > > 
> > > Maxime
> > >   
> > > > Even if it is applied to the classifier, it would discard double
> > > > or tripple tagged vlans.
> > > > 
> > > > Also add missing IP Fragmentation Flag.
> > > > 
> > > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > > 
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> > > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c index
> > > > 41d935d1aaf6..efdf8d30f438 100644 ---
> > > > a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c +++
> > > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c @@ -44,17 +44,17
> > > > @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { /* TCP over IPv4 flows, Not
> > > > fragmented, with vlan tag */ MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > > >  
> > > > @@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4 |
> > > > -		       MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4_OPT |
> > > > -		       MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > -		       MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	/* TCP over IPv4 flows, fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4 |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > > > MVPP2_FL_IP4_TCP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_L4_TCP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
> > > > @@ -114,17 +117,17 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > > >  
> > > > @@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4 |
> > > > -		       MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4_OPT |
> > > > -		       MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_VLAN_NONE |
> > > > MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > -		       MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> > > >  
> > > >  	/* UDP over IPv4 flows, fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4 |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > > > MVPP2_FL_IP4_UDP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_L4_UDP,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > > > +			   MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	/* TCP over IPv6 flows, not fragmented, no vlan tag */
> > > > @@ -178,12 +184,12 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* TCP over IPv6 flows, not fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> > > >  
> > > > @@ -202,13 +208,13 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* TCP over IPv6 flows, fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6,
> > > > MVPP2_FL_IP6_TCP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6 |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6,
> > > > MVPP2_FL_IP6_TCP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > > @@ -228,12 +234,12 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* UDP over IPv6 flows, not fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_5T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_5T,
> > > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> > > >  
> > > > @@ -252,13 +258,13 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* UDP over IPv6 flows, fragmented, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6,
> > > > MVPP2_FL_IP6_UDP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6 |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > >  
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6,
> > > > MVPP2_FL_IP6_UDP_FRAG_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > > > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> > > >  		       MVPP2_PRS_IP_MASK),
> > > > @@ -279,15 +285,15 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* IPv4 flows, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP4,
> > > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OPT,
> > > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > > > -		       MVPP22_CLS_HEK_IP4_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP4_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP4_OTHER,
> > > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > > >  
> > > > @@ -303,11 +309,11 @@ static const struct mvpp2_cls_flow
> > > > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> > > >  	/* IPv6 flows, with vlan tag */
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6,
> > > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > > >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > > > -		       MVPP22_CLS_HEK_IP6_2T |
> > > > MVPP22_CLS_HEK_TAGGED,
> > > > +		       MVPP22_CLS_HEK_IP6_2T,
> > > >  		       MVPP2_PRS_RI_L3_IP6,
> > > >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> > > >    
> > >   
> 
