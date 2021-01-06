Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5042EBD29
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 12:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbhAFL3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 06:29:08 -0500
Received: from mail-vi1eur05on2126.outbound.protection.outlook.com ([40.107.21.126]:7712
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbhAFL3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 06:29:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgmRIMCWJy96FIG7d7eviDs20gjVBKecOXQEIMMx7UHRtlgHI/dR/+2arV4yn5JkIFWolfeUOQ/VCg3vSG8m2UnDr9JRLCoPcMkPjeYMIuOmNRX1xbzqMSqR72T5OsU9CWRFk7+W9LTNZUhdhfmxKmmWOm+aDbyIOXhm3zRB6hewltS69IatUQ7CrU7AA6wpI2FO21BA042beraHlQPGx7/FxaNPaZ1PEDOvQb3Ym4wr3E6so4KkUbdCsajxgydl3s31vruqkac0Yo0ZcjX9GV3sbSd4wtzJQeIcd81jN+MK+FzGoyz3HWQzGywRvbP3UQIKl8QE497jAmt2fy654g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nDoHMZbIzUsN/9NzaqEA3BwdF1jnTA+OOddfK6pXNk=;
 b=U50QoVI9/LAb88NTaNmYvxN9y/UiSeKDXDutbW3VqPfm8BEBQZCkv92gVPZpA/xZQ2E5yJj7LyIK6w8YIFarQfnj3RFh/KspEVtkvG/OKFJFklK6f8pIZOx33vwIx56JGWw+WR8o1ROLD7SGIsFCiw3xQgN/TRS+1y6TqUNxnMbFHba/LQzY3SGTTSHeflvj74mmQ7RRBGe+XxZUi/A6aJQQSUt0C1Ndrpi4swO7BxGYEGzaI5CfDIsVjZdt04DUV3pfkCWwcjPQKcglrM0Bg3f2lnTJMt89KrWrRZGeQGZnxDWQY0D9kJurRafK4ySyNDSKORkQnGfVA0VARfbw2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nDoHMZbIzUsN/9NzaqEA3BwdF1jnTA+OOddfK6pXNk=;
 b=QqBvxcVT5oc+0PVYsPEyeyFoShCBCYj92jWvd6xNBqDSUojEnofKDLrl4yHFo008gXc4578GxfmHhEAKVtFrekQHzoaECvnOuvyEJtrwQvJJSz+MqDghpyxAVIDYsuLp6/It/xnIVwuC0D/ZHu/4R8nd8KKSfM97ptkVNtD3SWA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM9PR05MB7793.eurprd05.prod.outlook.com (2603:10a6:20b:2c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 11:28:17 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 11:28:17 +0000
Date:   Wed, 6 Jan 2021 12:28:12 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <20210106112812.osgetx6pmuup6cd7@svensmacbookair.sven.lan>
References: <20210105171921.8022-1-kabel@kernel.org>
 <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
 <20210105184308.1d2b7253@kernel.org>
 <20210106113350.46d0c659@carbon>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106113350.46d0c659@carbon>
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: AM9P192CA0029.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::34) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (37.209.79.82) by AM9P192CA0029.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 11:28:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f9a343b-ab1f-4dd2-a024-08d8b2362a2f
X-MS-TrafficTypeDiagnostic: AM9PR05MB7793:
X-Microsoft-Antispam-PRVS: <AM9PR05MB77937E7D908DB421B5706714EFD00@AM9PR05MB7793.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aQ4rJ9NxXqW8GsF4x4nShFj+6j5wL34QBur+m1xSz6hwtrQKVFZ/40w3NwVIKfNXNMI3enLbFPIa1stQnOUQQzdO1GIlvcMcYxykVwd5wzelGt44G+SM2U3juv5QNl8F2DDgrVNk76Sh500pLN2n181PnhwX00pCu/Y7wwncewz2JGz2dggqfIxOp8qaDryzbIIZX9wLXKKuoOkp2c2LB/JeGSAqX8vuTrmIJSztJjwZ2RdV22BSjXkuToehYQbddwTvxEM+eBDKYpzIlbtRoJRibw9zXxWdE6fHA4EM2naowunzuHqWJhEZ0OBeikn0l7rqjunEjRbyILPAvexhmWEYEBKqLKKGgZWrgnUS7J/FdCQoh3SMn8r1rcoGjBLraO0Xl956gM+6LDDmokvL41eUBZMfXQv+fP6bZdRroZyTl19hMTGTlGEl3Vk398kx9iZVbzOdSZ7Nt50s/OD8eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39830400003)(376002)(396003)(66556008)(66946007)(6506007)(1076003)(66476007)(54906003)(55016002)(316002)(86362001)(7696005)(4326008)(6916009)(45080400002)(8936002)(478600001)(44832011)(966005)(956004)(9686003)(5660300002)(2906002)(66574015)(8676002)(186003)(83380400001)(26005)(6666004)(16526019)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?5N8U40C3k/ORMYCMouN88fAxo8srruwfl83Vdl+WDx1icbCBJzcAKz+qTr?=
 =?iso-8859-1?Q?gerP/b3Q8qdSZKT+WzyyC4Fv+bXDHBqXhcX1CWsADw6BPWQjRb1RAKf+H1?=
 =?iso-8859-1?Q?eLTWv+IIp0ULKk17/nTSUy8awRrM5/QV1V28Z1qss+6L3Pk71MYOVYUhnd?=
 =?iso-8859-1?Q?5DLV29vy4Wn2RVKqbioodDWYpTjlCYE0hvNsLNeiZLvndMi4og4nVujZ/f?=
 =?iso-8859-1?Q?etXygNbhXDrT2BU1bFV+TbNZXJaXVaZDiAPIBHxBRLF9Yo5vVWafqRzXX0?=
 =?iso-8859-1?Q?SsH/lWOLrtmVlE7hKg+9JHh7AFXuIVYZLJ1xqnkys2gkqRCe+kfHwYQjt3?=
 =?iso-8859-1?Q?Piel4V3oOrFJXFfNwgaX6i/g/tQx5EjBcImK09mh83J8lEq8A08viz0437?=
 =?iso-8859-1?Q?s2OVQDvBkJUbvjWidyNS7SthqCHlRMNdsiWmRsMeKlUG5HQTGcfKbZDbha?=
 =?iso-8859-1?Q?Iti5PS6NHT762dgrsO+lY+pvZ5WcH0tk0Keyw5qzY6RfI9ALrQOZ9JBVz1?=
 =?iso-8859-1?Q?QbMbEoIgdi+ocfCAa1Y+hqwTKM659b8Xl1ttVAlyYqbrTKFiPNqUtNQJ3X?=
 =?iso-8859-1?Q?2Xv3pJCdT5DHWv+2A97eySphuwPyxRqxbRZl5Sa1KiRqMpZzWbmZONS3t3?=
 =?iso-8859-1?Q?Q/JFnBgSJIXEstKm42SoHLDqP9sBEGhPQKcgozzDyKhkYrEb1jbJsJpsS8?=
 =?iso-8859-1?Q?y3uRbgdvurf9PhbQaeRTMFeUZ8xOKPr/8Qh8szQuNcwMPGzQNiywtCfeu+?=
 =?iso-8859-1?Q?4KUw6Mf2KhhCX0kvtzanLCtnOpR2Y3tRPt9jb4dbkalXJE01y/nYwz4J3A?=
 =?iso-8859-1?Q?VGQ548Ap/cDaIhgyzJ6k04B27RPktkRVDPlj7xNnqN+9u69C9UKBo/6Jog?=
 =?iso-8859-1?Q?ai7q60lGR/5vK7d8e4nUq5ihxw1apaCj/ad8vpofKTTzRAoCgfnOGD20oG?=
 =?iso-8859-1?Q?yxL0swB4OScBpUCLLqr+sBMPsLPO1USrRcYWt3YkQvIn3sJ5R7nXqsBynM?=
 =?iso-8859-1?Q?T41BbprBcdDwqsysHHySn+vGBzVat0fW6jlIrt?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 11:28:17.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9a343b-ab1f-4dd2-a024-08d8b2362a2f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mn8yXHfSxjCOGOOEK+m/stuZIx2h24K+7hVTxD5WSGE90+WyMOaU+I+SQBIj0GZ1yBnqZVLp+hORhaC8NqCIzXPhpbyBwrz6fqxEIdgDVm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB7793
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 11:33:50AM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 5 Jan 2021 18:43:08 +0100
> Marek Behún <kabel@kernel.org> wrote:
> 
> > On Tue, 5 Jan 2021 18:24:37 +0100
> > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > 
> > > On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Behún wrote:  
> > > > Currently mvpp2_xdp_setup won't allow attaching XDP program if
> > > >   mtu > ETH_DATA_LEN (1500).
> > > > 
> > > > The mvpp2_change_mtu on the other hand checks whether
> > > >   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> > > > 
> > > > These two checks are semantically different.
> > > > 
> > > > Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
> > > > mvpp2_rx we have
> > > >   xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > > >   xdp.frame_sz = PAGE_SIZE;
> > > > 
> > > > Change the checks to check whether
> > > >   mtu > MVPP2_MAX_RX_BUF_SIZE    
> > > 
> > > Hello Marek,
> > > 
> > > in general, XDP is based on the model, that packets are not bigger
> > > than 1500.
> 
> This is WRONG.
> 
> The XDP design/model (with PAGE_SIZE 4096) allows MTU to be 3506 bytes.
> 
> This comes from:
>  * 4096 = frame_sz = PAGE_SIZE
>  * -256 = reserved XDP_PACKET_HEADROOM
>  * -320 = reserved tailroom with sizeof(skb_shared_info)
>  * - 14 = Ethernet header size as MTU value is L3
> 
> 4096-256-320-14 = 3506 bytes
> 
> Depending on driver memory layout choices this can (of-cause) be lower.

Got it, thanks.

> 
> > > I am not sure if that has changed, I don't believe Jumbo Frames are
> > > upstreamed yet.
> 
> This is unrelated to this patch, but Lorenzo and Eelco is assigned to
> work on this.
> 
> > > You are correct that the MVPP2 driver can handle bigger packets
> > > without a problem but if you do XDP redirect that won't work with
> > > other drivers and your packets will disappear.  
> > 
> 
> This statement is too harsh.  The XDP layer will not do (IP-level)
> fragmentation for you.  Thus, if you redirect/transmit frames out
> another interface with lower MTU than the frame packet size then the
> packet will of-cause be dropped (the drop counter is unfortunately not
> well defined).  This is pretty standard behavior.

Some drivers do not have a XDP drop counter and from own testing it is very difficult
to find out what happened to the packet when it is dropped like that.

> 
> This is why I'm proposing the BPF-helper bpf_check_mtu().  To allow the
> BPF-prog to check the MTU before doing the redirect.
> 
> 
> > At least 1508 is required when I want to use XDP with a Marvell DSA
> > switch: the DSA header is 4 or 8 bytes long there.
> > 
> > The DSA driver increases MTU on CPU switch interface by this length
> > (on my switches to 1504).
> > 
> > So without this I cannot use XDP with mvpp2 with a Marvell switch with
> > default settings, which I think is not OK.
> > 
> > Since with the mvneta driver it works (mvneta checks for
> > MVNETA_MAX_RX_BUF_SIZE rather than ETH_DATA_LEN), I think it should also work
> > with mvpp2.
> 
> I think you patch makes perfect sense.
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: https://eur03.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.linkedin.com%2Fin%2Fbrouer&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7C2450996aa72245f4a6da08d8b22e971a%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637455260465184088%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=LDmq8nFGgKuzG3rbqmaILTw6W4Qsc04MULSQvwmoVLw%3D&amp;reserved=0
> 
