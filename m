Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDDD52BD7E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbiEROQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiEROQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:16:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2064.outbound.protection.outlook.com [40.107.220.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7112C1ADB7;
        Wed, 18 May 2022 07:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QinxZ+9e1qvVRJynQBfHOFXwLzm7/XauHbSOfxtuE4Lft+DMdj99wicJWVvPv0THmR31WidQeK2AAtJja4J9BkR1ysvJGX2DQpkY1VOL1A43iXG4OxagBvzM1+iJ7aQEPpFudlWuZ0eDOJpcMr8NTLivzjeoG4/Kl/kvV6CctfCf2tIe+lK/9p03OsbSCg28TmdM83KXwVNnTbl3UYJjbpO44y/4XYW8qjK1BoINCA9OuymhH17OJLmA6lSbi7G+/9PkVuLPTt3iOJNrTUfmyKT2Z3i3xMYy2SKJk/McMZLg89e45gJCpBbysCjI6cwP+GPgh7dpaoxzFplOZ1KLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB8w1bwrj2X98vp7JK7TeYAwcsdTQrRz86R/83IHEYc=;
 b=l0M1hqpi+dp5XCPN/xsoprVsXnW/23Heo2bUMKzbSbEllzmu7xJ12xJKKOcl15WpKIVQau/iSBWy/4yFUpseUsa911BoqOWlrMkkFbDLbURYdE4E1euWriquqqc6R4spbC2OwAyK7Hd+5ukJ/pK4xbuh9Apjybgv+D413sB9HsgATMMm0c5QRorryGKX4FoSiiBwNEGIdR6W25FC8/iDVB7fimgqM6FFxaFK8lSX7iNr2UKNZRIMj++QHTGye2akf4j/JP7dfZJ6odfWsAYfliievruezIYBeC6GV2uhmiyyNaop1Ac+4o/WoM7kuWObOlQyw9IAdntemrmjksHxvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB8w1bwrj2X98vp7JK7TeYAwcsdTQrRz86R/83IHEYc=;
 b=NJMLqObqU6rGm2tBVz+djWNvKbYSs69rVReP9selab1Onn7jGP9WFeyQNfoVxjpRwGpmbNQVdjQT4upY8XuqnXZuvBOiEDVicf65nYEfYal2IJ1hL3ctI4jgAesWYkZviciI9mu+vqFxl6GiXgvGAB2rtBEwa2m9JZeHgkvt8yyWEa/iMwufP780r6a0CwM4uw8eEZsp271xRZAvtMSv2GFOWdr5nnmOadzRTD2BoYwMQZa9DfxM3CcBJLWwLL+1PyiYtlz3kkRzVI6R8TXyIbMI8rvAq/TLz4eTfHFpN5pQYWfJmBj5J9TK1Xq6l0jP1BseAO1b1aJ/PE40P8ggnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5138.namprd12.prod.outlook.com (2603:10b6:610:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 14:16:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 14:16:28 +0000
Date:   Wed, 18 May 2022 17:16:21 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@kernel.org, Saranya Panjarathina <plsaranya@gmail.com>,
        netdev@vger.kernel.org, Saranya_Panjarathina@dell.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        g_balaji1@dell.com, Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] net: PIM register decapsulation and Forwarding.
Message-ID: <YoT/tea4TZ2lWN8f@shredder>
References: <20220512070138.19170-1-plsaranya@gmail.com>
 <20220516112906.2095-1-plsaranya@gmail.com>
 <20220517171026.1230e034@kernel.org>
 <YoS3kymdTBwRnrRI@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoS3kymdTBwRnrRI@shredder>
X-ClientProxiedBy: VI1PR08CA0249.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 705f6265-1b7d-41bc-5460-08da38d8ff8b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5138:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5138B505785D44920B158483B2D19@CH0PR12MB5138.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOqL9qw6mVkLgIxZ1ADcHI8Ts95d8UpgQqQRawI14xLJKS+uc/5yOX4xTtjYvspna1IvrYg7lPxs654zjzE8nQQ7ZTN61k+TPVapteebNOikGpQFjSJJiaMGa6R/ablXWucEQ+q5oUPPJQdam4yzeV4++ldZfcilLIH65HwEEmskjzzjE4d39/if+TQsyY+EFPk32R/CHuxZzO4A8AkI9gK9LzzE/7y8GDCJDeFG6omYaWZdAro5DtjSzMzO3krFRxz/tR3UXz0+MAS/IBXBVivARut+RlNrYgBSHIkljrEvI8OSCmxq/NHBj7EEmW1WcUU5przwiYR42IJCW5ok2u8YAZJT+nn/BdK2IcgmtMJ9EpKxZYCx6qe7rFD2umV/gxe1Vkmx8kybMNObDejN+VJOoH3DAFoDw3Uz824xj/LpLqHSAYMU7FnAjmcDfMzsmGDfKEUoabyr0ZUHECIRWdpINPIHTtKSCOnFEfwX3TY6whj94FVHx7ozCvKIxKFajuit6zjqgmD2EYjgAizx8SHsx31tAD+kTMVsWROja5geg9OELCkuyF+d6QU/uslI1hXKQltzdmuMEqBeD7LW230rQkHAB5dAd7px3O4IXxl1oRWAfB317pMsrUCWCZDbbGrbuTk1CMySMScfOPlUcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(316002)(6666004)(6506007)(26005)(38100700002)(66946007)(4326008)(66476007)(66556008)(83380400001)(7416002)(6512007)(9686003)(6486002)(8676002)(508600001)(33716001)(2906002)(6916009)(186003)(54906003)(86362001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u7V5TMC6Tz074QFr+YUxOEsbmIU5Y8NpskC5X2++j6ELldq4lg8HNv8LkYMl?=
 =?us-ascii?Q?EHOuvIjzNAjx5wxTwdt9vTgrcAXo+CkE9XUwSYTE3B8M8/uf90eDwaCpEuO2?=
 =?us-ascii?Q?V3xcAhpEi4GDX9tEYRPb2T/ernuf4pNG3OJvNS9ITB8icU5AAehb6asPDGGW?=
 =?us-ascii?Q?TGrBHb7lDYQHt6XukrSHjt4KfUAE08EVQf9+I1nauI3xnXp+D8LkdpNAFUls?=
 =?us-ascii?Q?w5fOYJjIb346FUwtWBq2L7TuhX+C9mgH3RfJvn5TZrSlVnJnTeMZYr/1yj/y?=
 =?us-ascii?Q?p1SHlmPas1KdP4rMc3jdO4yg4nADDC6Z2w78uJKyOotTXE1VjFhrTzGiY70/?=
 =?us-ascii?Q?mpGwKutJArsa/cZVvRUudadjml+s8qWUruLj+KnE3u/yfdV39UNlSi/RKKxy?=
 =?us-ascii?Q?rJq5cEjws1vDgNcubYRpuspbu3n+rZ0iUZS+weWob7qBPE55qmqfGSR+qtHO?=
 =?us-ascii?Q?K7/4hGLqVU1eFqpdAqHkN+pTH3xNM0Jp45d9+VBcd9nf/OBcB5tVq14R9F6c?=
 =?us-ascii?Q?1DU1IQRZtKJ3WMAEBlVPjWld2+YBqhb1yj907AAigiP26eZh/u3EQsLNxHqU?=
 =?us-ascii?Q?GeH/wxsn/yScUoApuNyfLneJmc2Um+wzm/5+LygpiExvEAdk2qnqMOKWoPU/?=
 =?us-ascii?Q?23ksEHlhkJEn7kFueKFgumUy9WkHRjjvoE55b4DHwa7aGa7X+AmsC7MgXV8y?=
 =?us-ascii?Q?Qo9eVNm68LvOApSWtsL0Y471qaAxxTVdBDmwnOidSK1mZ1GWZFKS5kcKP/+c?=
 =?us-ascii?Q?j74st/QTyc2JnxWK6BBuTwc0J4r52YP7ADMVfsg3VeSdT7UkpzP8htNfFGAl?=
 =?us-ascii?Q?q/o2RZV/tEwdLU/jCYRUu4LMbaz25IXJRk4MAKf841ZNxCCGdSpNtELyM3DJ?=
 =?us-ascii?Q?nIw39nWb9xVY76z6vMp5iC590/CsyIlpEowfT03KPnDRJ/SM0yg0aHYL6Prb?=
 =?us-ascii?Q?7Mq3MgNS6mYl8dObe+HmqX5FfWazVL1DLdzO+OvfntyYXcEUyb/6YvElvKub?=
 =?us-ascii?Q?fGVgVtuJTET//Jr8gxpZ9bRA3+LlP8fsB74ePxmocviWb13pPJ+abqgd7DCn?=
 =?us-ascii?Q?bvDxlbSKyoKnrLxmV/LJOeuABv7aj3RiIBTDDEWq5vjJmn7c6qw+u9g3manT?=
 =?us-ascii?Q?s++0TKM145lPTnF2zf7lESkibFvM6qRCzZOvvqFbsiqJ3d/cuFKtxlKLCGgV?=
 =?us-ascii?Q?f67nYOh5bXirL2LW0bK7o6E7nG6TW9bD4i8hAy160sv+3pKjR0YDWVBIs8ch?=
 =?us-ascii?Q?kZpfhZwy4OnSmvKL96BLfgDclT5fe4pGmFVoetR26PLh0yUhsM5BkHd2jT0K?=
 =?us-ascii?Q?pB4kM/vCHagt4w5WzTlfW472xRL4cSnrazw7E//MS4iX28yWAuFssaZhKlpa?=
 =?us-ascii?Q?ra30xOcfuEeYg4FzME821waXwO9y3IIHcn81IxVSwuEOn9JxuEAZzC14r+qA?=
 =?us-ascii?Q?fzejHqEDCG9vDGSEPoHY0ouYJqMYOXq2nq2n4nVhB02K4HGqegwNij7yeba+?=
 =?us-ascii?Q?oxCBDFLhdeAbS8fusoVXvVlKJm1H2WcN3+yKZNfE/zDMsLxtThSRLWtDyQP/?=
 =?us-ascii?Q?kifreCSVoh1YiVqu7N7L71DEOXt8edGXHE2d7Z+Qr/IdmbfL2ji5/iPeuqgS?=
 =?us-ascii?Q?91mU7xtyzc6MAybSZvV73ii+/s0mquyXTHhM3Im53uMz1E9h7X4k4qqMMldN?=
 =?us-ascii?Q?YY+q5aB8KW3FFqEGuIbyL6c8Ehg6qP1Ybe4PiPOWQVj0njfgXyqPz29powZV?=
 =?us-ascii?Q?Q05Pvs+zpg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705f6265-1b7d-41bc-5460-08da38d8ff8b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 14:16:27.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TtAhwf44KCd+z51GgsBL+SWR4Y/UqiJ6xhPP81ASQOxC0wILofETJIWvbCrA5Me9NLcr6FA/Ko6W8D1fbKv2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5138
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 12:08:35PM +0300, Ido Schimmel wrote:
> On Tue, May 17, 2022 at 05:10:26PM -0700, Jakub Kicinski wrote:
> > On Mon, 16 May 2022 04:29:06 -0700 Saranya Panjarathina wrote:
> > > PIM register packet is decapsulated but not forwarded in RP
> > > 
> > > __pim_rcv decapsulates the PIM register packet and reinjects for forwarding
> > > after replacing the skb->dev to reg_dev (vif with VIFF_Register)
> > > 
> > > Ideally the incoming device should be same as skb->dev where the
> > > original PIM register packet is received. mcache would not have
> > > reg_vif as IIF. Decapsulated packet forwarding is failing
> > > because of IIF mismatch. In RP for this S,G RPF interface would be
> > > skb->dev vif only, so that would be IIF for the cache entry.
> > > 
> > > Signed-off-by: Saranya Panjarathina <plsaranya@gmail.com>
> > 
> > Not sure if this can cause any trouble. And why it had become 
> > a problem now, seems like the code has been this way forever.
> > David? Ido?
> 
> Trying to understand the problem:
> 
> 1. The RP has an (*, G) towards the receiver(s) (receiver joins first)
> 2. The RP receives a PIM Register packet encapsulating the packet from
> the source
> 3. The kernel decapsulates the packet and injects it into the Rx path as
> if the packet was received by the pimreg netdev
> 4. The kernel forwards the packet according to the (*, G) route (no RPF
> check)
> 
> At the same time, the PIM Register packet should be received by whatever
> routing daemon is running in user space via a raw socket for the PIM
> protocol. My understanding is that it should cause the RP to send a PIM
> Join towards the FHR, causing the FHR to send two copies of each packet
> from the source: encapsulated in the PIM Register packet and over the
> (S, G) Tree.
> 
> If the RP already has an (S, G) route with IIF of skb->dev and the
> decapsulated packet is injected into the Rx path via skb->dev, then what
> prevents the RP from forwarding the same packet twice towards the
> receiver(s)?
> 
> I'm not a PIM expert so the above might be nonsense. Anyway, I will
> check with someone from the FRR teams who understands PIM better than
> me.

We discussed this patch in FRR slack with the author and PIM experts.
The tl;dr is that the patch is working around what we currently believe
is an FRR bug, which the author will try to fix.

After receiving a PIM Register message on the RP, FRR installs an (S, G)
route with IIF being the interface via which the packet was received
(skb->dev). FRR also sends a PIM Join towards the FHR and eventually a
PIM Register Stop.

The current behavior means that due to RPF assertion, all the
encapsulated traffic from the source is dropped on the RP after FRR
installs the (S, G) route.

The patch is problematic because during the time the FHR sends both
encapsulated and native traffic towards the RP, the RP will forward both
copies towards the receiver(s).

Instead, the suggestion is for FRR to install the initial (S, G) route
with IIF being the pimreg device. This should allow decapsulated traffic
to be forwarded correctly. Native traffic will trigger RPF assertion and
thereby prompt FRR to: a) Replace the IIF from pimreg to the one via
which traffic is received b) Send a PIM Register Stop towards the FHR,
instructing it to stop sending encapsulated traffic.

> 
> > 
> > > diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> > > index 13e6329784fb..7b9586335fb7 100644
> > > --- a/net/ipv4/ipmr.c
> > > +++ b/net/ipv4/ipmr.c
> > > @@ -598,7 +598,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
> > >  	skb->protocol = htons(ETH_P_IP);
> > >  	skb->ip_summed = CHECKSUM_NONE;
> > >  
> > > -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> > > +	skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
> > >  
> > >  	netif_rx(skb);
> > >  
> > > diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> > > index 4e74bc61a3db..147e29a818ca 100644
> > > --- a/net/ipv6/ip6mr.c
> > > +++ b/net/ipv6/ip6mr.c
> > > @@ -566,7 +566,7 @@ static int pim6_rcv(struct sk_buff *skb)
> > >  	skb->protocol = htons(ETH_P_IPV6);
> > >  	skb->ip_summed = CHECKSUM_NONE;
> > >  
> > > -	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
> > > +	skb_tunnel_rx(skb, skb->dev, net);
> > >  
> > >  	netif_rx(skb);
> > >  
> > 
