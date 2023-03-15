Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E3C6BAA10
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjCOHyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjCOHxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:53:51 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2103.outbound.protection.outlook.com [40.107.15.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7492062DBF
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlEcqNIzBaBmBQZgUUXqlwc+Y5TBfkTqZlI5nQzxWflAjgOGz03jO4z9uz+HhVt6GHLw3R+CcA3g75yheNLFWVid4/2DaJbZJWy8VM1i1QlzQuz/D/5XYlS5OQN0+auvwPj/RNyIT6SlsTB2YRlLWbKiRV7Ve1+qdrYAuGj5DMy6Xf+gDXstUgJ6hu/S8YMBnneDtIbvhP8cFRTwXo4BLucmE22l/Pg3nKqzDMqCaXYSXV6Ti/O9vp4vMD7yY6NAX1k1OHDznmVjiQtcuhOWXo0DFBs1zx8rBXzyn9fohgkPWYElIqm/IRZVVA4wvdd9wNkrwsRC/i/ZLL+OpPeABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+j66/mZMfdhOKu1pSTFDtfWVm1trs7zyjpCUKJoioKk=;
 b=b2SUaNOwOYITuexPK7UcJLkSvdYOVJzPwIXapKFzXrlP07MtOHoRw5apbPuXRQbhgFwoBhKQLuf+xBHEVomKfbwpF8Cy8zXLeWogXgBeFzZzrkJmvf2Pbt/a0hgEVH3jpsIk4c3hoSZGR//U2j0o5dr9286NUnHyFyLPDiXMrl23vBPxvtemupLqx/kXM8cC1GBKWlWSr8SD7s7MdIvgijGbbt7cN9NAJBlcKSrlh5U1zYunhhulxa3jn2g+yC7WuLuvwYYiySfptwml2yp9nuL21VJ1cjSafqoWuOPAwLu0UUK+cZdaEjR9t3q+bWJY53XNbDQAsMd9VOhc6+c8HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+j66/mZMfdhOKu1pSTFDtfWVm1trs7zyjpCUKJoioKk=;
 b=iFyMUK6DY6JbsjgshsijKcvpCawCkspHf0D4B6abFbFfe1JVP2tE0KKwJRlplyYWnQDNFFIOur/v4JP24TCRe44kGF2lIDKKbgKlZU/QTTGCnKZTFatK7tqd20QiDEjBhwCs/xCxu1QLgtKjWMknr+Rp54K7/fllesnQm17Pd+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AM8PR05MB8259.eurprd05.prod.outlook.com (2603:10a6:20b:368::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 07:53:34 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 07:53:34 +0000
Date:   Wed, 15 Mar 2023 08:53:30 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315075330.zklzcdt3sukc5jy2@SvensMacbookPro.hq.voleatech.com>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
 <20230315083148.7c05b980@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315083148.7c05b980@pc-7.home>
X-ClientProxiedBy: FR3P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::20) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AM8PR05MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c1d10e-e46b-41c8-6b94-08db252a60bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2hkphihOLj+JLNKZi9/wVwBviWEBtqak8lUPuDYmiN6L518jVJYePy69D6vNWZaamSM5CoVsEdVOtqxGEgZOtAPVDTTiGnnPLg61QXAnFkmRDsDFxCTYQ0o1rcNBtkPoqanTCEWgf+Q8U+EVoF9SiwobB/sR9OhtpfiFxEyscEXynFvaZh2BsqpQRYpvBVDxutUZsvaXFmVuryoJuDQ0/37Qz3LWJcTvneOv+ZiX4VbRJC3F928IdHy+H7wXjnLsn68viMsG2GH2jdjkEZtFNNfd7wedLYFrIWuZJDvAIImUF46xUA2UNh9BKjg1tYM5R/c/nhhiNqmF1uDFxKv3XlQ07vIZ7FqZT+NgZ067oRcn06WuFwt6nSd6PO2ptUQwDyWp+87WAcfJHV7DaOm9wbwKFD6IBLg/VGHiNL1bruGfu9Auwm3emDLxG1KjZzU79ADs8o4CCd6tCOHAeWE+zBemku7pM7tWd8J3Qw4lrE54B9R7n9pr52u847M8nDuZ+Ra2oePW42H44BNMQ7QIt/JVSv6kyBJBJMngylvH6gZ5VCpL3ONHggSbRxA5rEyGrVaYEsCWKEeJyEZ+MHwWsYPOEsfe8oYdv0p7TNz8Yp4rmOHgJwAgzmntFevqi+BVjOZQ4kPykbpkhaNljON3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199018)(44832011)(8936002)(5660300002)(30864003)(41300700001)(6916009)(4326008)(8676002)(86362001)(38100700002)(2906002)(6506007)(1076003)(6512007)(9686003)(186003)(478600001)(83380400001)(6486002)(6666004)(26005)(66476007)(66556008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vT5QvFUDD92zpKITqG+JF18pnIALoH+44o/uAThRixVD/Wa6XlXxyFG91UbC?=
 =?us-ascii?Q?QXYfX3TDK6AtcSoD+0vGqitP9e3K9yhV+ofcBL5ar8Ckso6NJOhCBre2Knxq?=
 =?us-ascii?Q?7JR52CmXMnU2JgJem/Ia8UQqsFA/TRptHJb9Yc26qspzSxLWRMCXAsAoFIR3?=
 =?us-ascii?Q?WEmCkz7SdVXKo5p+AKmwSJdMSmOzuy+lnGQeoU3fa34zDCNQtcHhud5o4Ub2?=
 =?us-ascii?Q?Lf0m1OJivOPjwwJRnod076I16/xXwNoqa9qJVWqr8ab5LRnRYWLS0YpMIMDp?=
 =?us-ascii?Q?K3Nx4IAd3JRYNJlsxE2NjPLWxk8T2jKOXysbLw+DaLZf7HTzeV/oBMfBPzfU?=
 =?us-ascii?Q?wKymrufK2t8LX9iEbiWPTCUXNAztEUFjm5vpG8LIVJylrEFFstzlk0YkQ2Ax?=
 =?us-ascii?Q?/qpR8TvWteFH3Ef+h0kxoJE3eZyTLb+1hSoYcQRyYYpVxrIXRtHs6SU0efKP?=
 =?us-ascii?Q?iQtiHAKkdoDoqOG4pZ6Jcq1O+RM9QT6klmW61CMT5iFpiIuST/OrMGVeA0IM?=
 =?us-ascii?Q?0v9+rNySvSrWXNlZ7Hef5h+ZPsn3ZP/kRuhET/f6gMeKD3Db6+ejID5pSMaN?=
 =?us-ascii?Q?0UvH1YX7NLPOMvyZ4NpktmgE3B4YLstDZgSOjheBLlYK7GzpGDCVXKLDpm9T?=
 =?us-ascii?Q?mgQnPpJzCJ8PPQgYgS487EbmbgkIdDImNeJ8N/pgY0bYF6f3oyVIzpv6+1L3?=
 =?us-ascii?Q?9Orpf4VQIVNSexUxxyeJ00UMS2jCB6oz0rEZvyapY+03VQhpjwIeuoBd4qbc?=
 =?us-ascii?Q?dPS7rpww4JMwbug28+In4Wgh84MFTbJ8K/mRja7TeMGf2HJTXyA8Qc7XsthZ?=
 =?us-ascii?Q?CRyzyMCCO2mvvmbfH81tAjeKHxXNW8xKqOdMSKl42yBmW5tCAQG6kkSEsE+i?=
 =?us-ascii?Q?OjDO7MUSDU9F+jQzLWfTq1FRbggMQUwH7q1wefrqI8GbBf/VVueFgzMzqAKl?=
 =?us-ascii?Q?zK5OlCI6yLlfbLTmjMNr8L2evc6J48o3/lmgLpAHcwhhB0ZKdfHsh5aUsG3n?=
 =?us-ascii?Q?+qbNapwsALEPYOyWaX08oWuR1OojVpsOobrpDtusAPgCFNThOIqCBeZoaadP?=
 =?us-ascii?Q?ukdhJtokDcCuq9IPOqyspIxISkHTosZRE5A2a0569nxIt6QnJ/c/L9FLBbzp?=
 =?us-ascii?Q?yUyLwi88FTH5j/YqbmDEhAvcokP3ZLThX+QutEHCL7JDib841925FK6S42qZ?=
 =?us-ascii?Q?ULCZ0CMw/RWm+taB1hlNi73oiucvJKEd02hpGAxITKJwF1DJSb0MJb4nyxDD?=
 =?us-ascii?Q?qwxAHYHzuJGZIO554gmkvVoZ5iVoSUKKASSM8p5bQhfA6G7AbrOrPam5zWyi?=
 =?us-ascii?Q?hzZaXTEXO6w86NR9HCH+d3a1l/mnQMCXx08c2yU5Zj6Tg2i5yTbKJCcckdnb?=
 =?us-ascii?Q?XZrZNolA9AksvFyl9rW2Tl30iBGguG1Dd02XwbxUIraH+k+hHXhUWEZ7DQVi?=
 =?us-ascii?Q?nAkmLIqm3LW4gYsUxYA4dK9yKZwfgAw9imdzlTmDeMMDV3ih2VYyGBF6b4oA?=
 =?us-ascii?Q?7C261lplS/hl70O/V1+BZ4c8lTN+POXG9Ho5aKEZ9ZdwiNwMbcqaK7Y7dIoC?=
 =?us-ascii?Q?UaDV8vea4UMUkPeCZuosEWqnoMPHjtMOpMvNihjozFVPTnp0mT5dTVrGYE1q?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c1d10e-e46b-41c8-6b94-08db252a60bf
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 07:53:34.6766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6JL8KrVv+NA40RLl+dgRnhtOj086ONvAgk04Vr7h9sBcFtbSqvqbMLAoJrRmgCeVA+Ts1SXMIZKKL00J8mAz5QBL7LrBoXsiUZ7WlFNeKew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB8259
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 08:31:48AM +0100, Maxime Chevallier wrote:
> Hello Sven,

Hello Maxime,

> 
> On Sat, 11 Mar 2023 08:09:48 +0100
> Sven Auhagen <Sven.Auhagen@voleatech.de> wrote:
> 
> > The classifier attribute MVPP22_CLS_HEK_TAGGED
> > has no effect in the definition and is filtered out by default.
> 
> It's been a while since I've worked in this, but it looks like the
> non-tagged and tagged flows will start behaving the same way with this
> patch, which isn't what we want. Offsets to extract the various fields
> change based on the presence or not of a vlan tag, hence why we have
> all these flow definitions.
> 

In the sense of a match kind of.
There is one classifier match for no VLAN and one for any number of VLANs.
So no VLAN will match twice, correct.

This is the case right now anyway though since mvpp2_port_rss_hash_opts_set
is filtering out MVPP22_CLS_HEK_TAGGED for all rss hash options that
are set in the driver at the moment.

MVPP22_CLS_HEK_TAGGED is also not compatible with MVPP22_CLS_HEK_IP4_5T
which is probably the reason it is filtered out.

The HEK can only have a match on up to 4 fields.
MVPP22_CLS_HEK_IP4_5T already covers 4 fields.
I disabled the hash_opts line which removes the HEK_TAGGED and the entire
rule will fail out and is not added because of that.

So I am simply removing what is not working in the first place.

> Did you check that for example RSS still behaves correctly when using
> tagged and untagged traffic on the same interface ?
> 

Yes all RSS work fine, I tested no VLAN, VLAN, QinQ, PPPoE and VLAN + PPPoE.

> I didn't test the QinQ at the time, so it's indeed likely that it
> doesn't behave as expected, but removing the MVPP22_CLS_HEK_TAGGED
> will cause issues if you start hashing inbound traffic based on the
> vlan tag.

Please see my comment above.

> 
> the MVPP22_CLS_HEK_TAGGED does have an effect, as it's defined a
> (VLAN id | VLAN_PRI) hashing capability. Removing it will also break
> the per-vlan-prio rxnfc steering.
> 
> Do you have more details on the use-case ? Do you wan to do RSS,
> steering ?

I want to have RSS steering for all cases I tested above.
Do you have a different place that I do not know of where
MVPP22_CLS_HEK_TAGGED is actually loaded?

> 
> I however do think that the missing frag flags are correct, and should
> be sent in a separate patch.
> 

Will do that in v2.

> Thanks,
> 
> Maxime
> 
> > Even if it is applied to the classifier, it would discard double
> > or tripple tagged vlans.
> > 
> > Also add missing IP Fragmentation Flag.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c index
> > 41d935d1aaf6..efdf8d30f438 100644 ---
> > a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c +++
> > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c @@ -44,17 +44,17 @@
> > static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* TCP over IPv4 flows, Not fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK),
> >  
> > @@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4,
> > MVPP2_FL_IP4_TCP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> > -		       MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
> >  		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE |
> > MVPP2_PRS_RI_L3_IP4_OPT |
> > -		       MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
> >  		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE |
> > MVPP2_PRS_RI_L3_IP4_OTHER |
> > -		       MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_TCP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	/* TCP over IPv4 flows, fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4 |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_L4_TCP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	/* UDP over IPv4 flows, Not fragmented, no vlan tag */
> > @@ -114,17 +117,17 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_5T,
> >  		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK),
> >  
> > @@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4,
> > MVPP2_FL_IP4_UDP_FRAG_UNTAG, MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> > -		       MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
> >  		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE |
> > MVPP2_PRS_RI_L3_IP4_OPT |
> > -		       MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
> >  		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_VLAN_NONE |
> > MVPP2_PRS_RI_L3_IP4_OTHER |
> > -		       MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP2_PRS_RI_IP_FRAG_TRUE |
> > MVPP2_PRS_RI_L4_UDP, MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
> >  
> >  	/* UDP over IPv4 flows, fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4 |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4_OPT |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > -		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_L4_UDP,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> > +		       MVPP2_PRS_RI_L3_IP4_OTHER |
> > MVPP2_PRS_RI_IP_FRAG_TRUE |
> > +			   MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	/* TCP over IPv6 flows, not fragmented, no vlan tag */
> > @@ -178,12 +184,12 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* TCP over IPv6 flows, not fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_5T,
> >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_5T,
> >  		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> > @@ -202,13 +208,13 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* TCP over IPv6 flows, fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6 |
> > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
> >  		       MVPP2_PRS_IP_MASK),
> > @@ -228,12 +234,12 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* UDP over IPv6 flows, not fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_5T,
> >  		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
> > -		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_5T,
> >  		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> > @@ -252,13 +258,13 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* UDP over IPv6 flows, fragmented, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6 |
> > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> >  
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6_EXT |
> > MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
> >  		       MVPP2_PRS_IP_MASK),
> > @@ -279,15 +285,15 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* IPv4 flows, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_L3_IP4,
> >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_L3_IP4_OPT,
> >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
> > -		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP4_2T,
> >  		       MVPP2_PRS_RI_L3_IP4_OTHER,
> >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> >  
> > @@ -303,11 +309,11 @@ static const struct mvpp2_cls_flow
> > cls_flows[MVPP2_N_PRS_FLOWS] = { 
> >  	/* IPv6 flows, with vlan tag */
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6,
> >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> >  	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
> > -		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
> > +		       MVPP22_CLS_HEK_IP6_2T,
> >  		       MVPP2_PRS_RI_L3_IP6,
> >  		       MVPP2_PRS_RI_L3_PROTO_MASK),
> >  
> 
