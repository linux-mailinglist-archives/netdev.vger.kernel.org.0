Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF652B5DE
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiERJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiERJIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:08:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF34413F1E1;
        Wed, 18 May 2022 02:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGPO4CkiFqWCqc6/UPXVrju4dJO015CFBRfjE/jHjL/uu58L5CC8C6fDBF0XCBEONh5fd/nxeWjFH0StdfaYVV/dgnNK9iBbd+i6sjIm9J7nQQkUAK9zrJyFzM1eHccSwGvvn2yM2S1azB6SBXh4CQ1xlveqEt5AKf4s1QhTSh6XkIRaTKJyYD3yTNES2c32PuHcOW74/BdsGPJk/i7MHm48HC8zVooNXf3uWk8wYPSDvgoh3XQG2/Izbaw+X3I4Vcdjv6Qov1MEe+WDKnnsSPgsL9GjuOnVwGIfaPhWomxomhirjmsB8+4TkQmTf7Xq5s72Kgg6QplBHTQBV5rnYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ib76XUlZlz8cRzc3HwL/El6U/duUJEgG1RhQdKQGv8=;
 b=Lk0R2ZRYMUUehmfQn1NaDWKXU5V6ADRJwvB2MSrxD7ZnmHRnaiyPmIkg0+K1dQp98tXBwm6UkF2hD4RVDg/RK4Bb7D7I0A2j8Jt9RdeScYaOdAXFuqIljIBt9deTF86iEyX4626xRII2Q12zJPSCZbRmxCnIpX1Yug+5bmoe1ua5M/rgUngh/qU9eg36sAnmVj6FU3gAtA8crdsMCA/ThxxaNMrb6Y1UnxkflBxiJLndZJr2X+kDa9l9g4hA3FcsXJVteNvDi1MeBxPW60f6Q8UoZ0xKB2XtzKm2cu+N3RvQPxaojELwYJ1kWKJxpDOoUmSxbWbBYji9+WshqwXBow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ib76XUlZlz8cRzc3HwL/El6U/duUJEgG1RhQdKQGv8=;
 b=kcbO8URA9CEzPgwMDCQKiujsi1gj7spWN16lV5nmoOKWwIGyhzlhyO/VcHh5rV8yb3dnHk1Htca0A9nNNkDmpVJEnGD2WkA8zHAOsmQ4bxEY4uwudQXbpIB7rQ8cdNgVj13VQgHD2AVh63wk/+nYlEzj4/OssakAd4YmgLAw71701mlsbmxpaiyQfotYUXDjDwbglZ0YRnRFwURDD6GySWEWTxr0qrtRWMzhgHaOpfGZdjJVLa842NUSSC0NNsgk81Ez5uagsXTvFUqZijcX5ZEMTbyW8Otf1XBV4Q+yX8tVPhFI92y5v0JWF6dv/Sbcr1VV+yXp+nrXryCd34RLxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5488.namprd12.prod.outlook.com (2603:10b6:a03:3ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Wed, 18 May
 2022 09:08:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 09:08:41 +0000
Date:   Wed, 18 May 2022 12:08:35 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@kernel.org, Saranya Panjarathina <plsaranya@gmail.com>,
        netdev@vger.kernel.org, Saranya_Panjarathina@dell.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        g_balaji1@dell.com, Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] net: PIM register decapsulation and Forwarding.
Message-ID: <YoS3kymdTBwRnrRI@shredder>
References: <20220512070138.19170-1-plsaranya@gmail.com>
 <20220516112906.2095-1-plsaranya@gmail.com>
 <20220517171026.1230e034@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517171026.1230e034@kernel.org>
X-ClientProxiedBy: VI1P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f851f1c6-953e-4d07-1982-08da38ae006a
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5488:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5488DA4DE930C99B71B31B81B2D19@SJ0PR12MB5488.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /lWC7IknNeObuisWLr9wk+qVv/ApBNuLVI1KlOfJUR5mVt4v3SP+KJnyhfixDrICDQ7Te72p2/2ooSHW1A2Bn8qPg3Vp0U4hl9Ypo6irxPZYZNF+DpKbyHeyAZkvE98qXfai5SGqkj9hOu+j2DJTHOlvxLCvf0SgXhLwiRIYSmCXd1RfG8qopYKE76dtOqN2unLJzC6V0+Tpyi0iyQCzvy1RAnb13xqmoM8wydbul26svOrgzvZtgm6q44a+/9Pip6tRSzfxp3yG3LfYz5XPMVSu04EuJGdZQSUDb75RZPGXQkAZQuYP7sdsWd78aOMtjrswsVUINAzMWa/pZfyihIzVEjqXP3QWZ4Z8BxGMB1dr+TOsK6ayKBx0n/0R38JqGqQ2DJ2NBbP9H7WGkb+Ljnc5BxiopRFpms4O5iUSK+rVaIK8fuYRPUnc83gVl3Ku5pguO2txQIq93rCYg4xKWM97jUeor596tD91f13NkFaiNTygVo64euN/BFf1aBOGh7PDJK5k+/9Vt1BIYb7bBHLNfKxHvjDqFd/+YnZ3R4PiTLf8YM5onpHrTmU/+WlXF+k69WLQSLd+AbnGv+l80CgzgN5wz+CrbEeGLnZhmdvFkRDwFeBeSBrwl+J6BgfozJL3diB2kkdSqLaKP6Ms+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(186003)(2906002)(7416002)(54906003)(8676002)(6486002)(4326008)(6506007)(5660300002)(6666004)(38100700002)(26005)(66476007)(66946007)(66556008)(33716001)(9686003)(6512007)(8936002)(86362001)(83380400001)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DYYHWSuHt9ih9xK6wldSvIBJ4M1d4hT3xHj3e+eOTunLiXJL8t5xs/rYl1fN?=
 =?us-ascii?Q?KsJcZdlMB7vBS6INQr2cPw1KkPXWzNszoiLS7fFJ3kVAHeNuytmF641LI2bH?=
 =?us-ascii?Q?gy8+jPvCJMUGpab1HZz6aK9fg8wwJrKknmhHVivWgFtDevPwxEsjef6p0e8T?=
 =?us-ascii?Q?x7Ne63dUu9OpMMFUwCjhSrTms1P7ji+J4UH3zuNToE8m8fWA6KBazj0o5WLo?=
 =?us-ascii?Q?FdQVIQ7L+jlepJUzsqBgPfk5JS36k7/k/x5NOgaEa9z2K4r8q9wsrxAy5Gyp?=
 =?us-ascii?Q?IFbMSmWs81dAbeqyEsaYPwyd1au5fp4p+jSvJqXRBNeAba4SP9IR9xqsUXic?=
 =?us-ascii?Q?kPlo8YVrRO+kMllZlhSKFpI+WtLYCu+fiLEp9HpTppOdGkMoQdQMJgKe4HU/?=
 =?us-ascii?Q?jM427ph6kwRn9tAZba2OiOV2+4aSZ0zKuzDHRjO0Tn40pE7bPyi/1BGHun1n?=
 =?us-ascii?Q?y6n0Hp53cmVGGxFNn4ccS+zrKNAI2qNAmwwGvS/nhVA6HlqscZnOOQZ/BGCR?=
 =?us-ascii?Q?OwswbQCkBjmyg2OXLBQcy2kr7d74VV3MAobjXb4EWZoTLVt4t6utEY2kCR7k?=
 =?us-ascii?Q?myIi9GDiYnOX6KMzSAZQdrrzpmXb6giu4VipdPqWJo2p8MJVwRyyLLmXv04i?=
 =?us-ascii?Q?nMXFjP+iN+gTdfIbOMnqchWUGkUEbY1lIu/LQiAbnDkgJn9g/P6sqgXNOnGZ?=
 =?us-ascii?Q?ATPAPIRvIbZBjhivzjsNt3+HnMfCL6hZsKKNH7jSynGnme+0G14j2b4iVJwu?=
 =?us-ascii?Q?7qjW6jGepSKtXdMCV9cPNomzqfmMZbB+YkC38bSy1TQYdzVBPJDcwpySUsgf?=
 =?us-ascii?Q?eOaWNNqY0/Ev1nFwN+UrDy141F/I9NBtwnoGX7mmoDiL2DWrCu4TVwHtdqN4?=
 =?us-ascii?Q?/w+77KYALue8J8JlFHTo1JXmcikza62t3KvU1hSsN1b7rd95MdwqfEqGhetE?=
 =?us-ascii?Q?N3udx1RhrgJ8u2KJMgF5oWNSSuSIR/EBlR+BBuRCKdGSSCJe33EiLR1LFhtc?=
 =?us-ascii?Q?1zHZ36JUgMvZt6CLoUMsS/HUwZU3LNOOCZsatHGtrQugbD7qBFtsab2b25IP?=
 =?us-ascii?Q?2IxxuFF6LHuKniygQFp2pKPxR28C4rFMMEBdrdNRbk8sOttuyJ/fkrNHrxjD?=
 =?us-ascii?Q?8mYurS7Glg4RWk6rPz8tuZRIU4vfWqTffHTgfzg3+zD62QIWe9BqMUX1aoDF?=
 =?us-ascii?Q?zOuVQMjyfws/0Ia1o/CoqRQUkZnDFX/XCWLfLEIEOF6MElgJjUffH1Ek1mwr?=
 =?us-ascii?Q?6IC7AzUNoNCFIgVE3uSZ8fQHxcz0TYrm6E20T3ghGDYzpj9HfS0Xwz2gnISF?=
 =?us-ascii?Q?ToO1C8qoAGdLXKEiPfAP1jK9DcSWUIJgjTx572YaPz01NfRRvmzzyHlL5xOX?=
 =?us-ascii?Q?TDwHUbYs5fP+Tl+SZdrExUUqGyfFgNQgeB+MjxUEQ9cX47Y10hMo4k1xMFQK?=
 =?us-ascii?Q?RWyhuq/kq3C1e4Qk1175hmgViPzyGS6+HspPaJ34GTkaglukniHrv1OC8qKn?=
 =?us-ascii?Q?//VAfB6ZZ5Eqs9bitWsCrQLAL2x4JYzA8uHGd9UP6mr3GUDhlHyQR7xP1E/r?=
 =?us-ascii?Q?Jzp9B1Xh1lXJInT7aHtAnxJBw5QIb6SZRh37A2VOYmqr3fUo1rDkyTrtuNXJ?=
 =?us-ascii?Q?6JIihymO732TR9oqp3lRrPCJZvrs0wql1WVMrBFlTIir28nZArQ/fOk3A0qq?=
 =?us-ascii?Q?r5t+luRAjNKlfGrAwtDQwJmymqLYzY6zZc/c2iU18GqVDV8QvZ87QmSRtN00?=
 =?us-ascii?Q?A+PihQoI/w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f851f1c6-953e-4d07-1982-08da38ae006a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 09:08:41.0339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTejO0Jxkfx1KGc+SC59CpfQbR8YW5SZ88lS2Hwx10mieg1i3QjOYMRBr8i28WKow6fGHg30PyK5aZVGHOatKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5488
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 05:10:26PM -0700, Jakub Kicinski wrote:
> On Mon, 16 May 2022 04:29:06 -0700 Saranya Panjarathina wrote:
> > PIM register packet is decapsulated but not forwarded in RP
> > 
> > __pim_rcv decapsulates the PIM register packet and reinjects for forwarding
> > after replacing the skb->dev to reg_dev (vif with VIFF_Register)
> > 
> > Ideally the incoming device should be same as skb->dev where the
> > original PIM register packet is received. mcache would not have
> > reg_vif as IIF. Decapsulated packet forwarding is failing
> > because of IIF mismatch. In RP for this S,G RPF interface would be
> > skb->dev vif only, so that would be IIF for the cache entry.
> > 
> > Signed-off-by: Saranya Panjarathina <plsaranya@gmail.com>
> 
> Not sure if this can cause any trouble. And why it had become 
> a problem now, seems like the code has been this way forever.
> David? Ido?

Trying to understand the problem:

1. The RP has an (*, G) towards the receiver(s) (receiver joins first)
2. The RP receives a PIM Register packet encapsulating the packet from
the source
3. The kernel decapsulates the packet and injects it into the Rx path as
if the packet was received by the pimreg netdev
4. The kernel forwards the packet according to the (*, G) route (no RPF
check)

At the same time, the PIM Register packet should be received by whatever
routing daemon is running in user space via a raw socket for the PIM
protocol. My understanding is that it should cause the RP to send a PIM
Join towards the FHR, causing the FHR to send two copies of each packet
from the source: encapsulated in the PIM Register packet and over the
(S, G) Tree.

If the RP already has an (S, G) route with IIF of skb->dev and the
decapsulated packet is injected into the Rx path via skb->dev, then what
prevents the RP from forwarding the same packet twice towards the
receiver(s)?

I'm not a PIM expert so the above might be nonsense. Anyway, I will
check with someone from the FRR teams who understands PIM better than
me.

> 
> > diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> > index 13e6329784fb..7b9586335fb7 100644
> > --- a/net/ipv4/ipmr.c
> > +++ b/net/ipv4/ipmr.c
> > @@ -598,7 +598,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
> >  	skb->protocol = htons(ETH_P_IP);
> >  	skb->ip_summed = CHECKSUM_NONE;
> >  
> > -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> > +	skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
> >  
> >  	netif_rx(skb);
> >  
> > diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> > index 4e74bc61a3db..147e29a818ca 100644
> > --- a/net/ipv6/ip6mr.c
> > +++ b/net/ipv6/ip6mr.c
> > @@ -566,7 +566,7 @@ static int pim6_rcv(struct sk_buff *skb)
> >  	skb->protocol = htons(ETH_P_IPV6);
> >  	skb->ip_summed = CHECKSUM_NONE;
> >  
> > -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> > +	skb_tunnel_rx(skb, skb->dev, net);
> >  
> >  	netif_rx(skb);
> >  
> 
