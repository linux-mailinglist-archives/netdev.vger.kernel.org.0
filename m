Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046CE1CEDE1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgELHQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 03:16:06 -0400
Received: from mail-eopbgr60115.outbound.protection.outlook.com ([40.107.6.115]:25651
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgELHQF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 03:16:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beh3datbENnYNaL/6QMN3l8pcHruMxZRoOLd6/Qxqpaw1yynp4FRvK78vSWrOkN27W/9wZ+IUOxxgr93qktsgecu6D0j8b89uZq2f137SYPx4ZapmXDLSANhRsNq+b4LsycuQqDhWI7UvClXsLnQO+e0a2lj0SOXicHSIuEVzC3zs7X5JooRMh+MIn0lfSnYAqmm5Qz/EW/3oYiVo7eAWwH7aP2A+Rw9O6TEoWl95CjgRp0nn+YuiYxUvog2fftx7ywD3RZldKXyGjW+Xtomr9yHsy/VTDJ1ytzYMzLnmc7hc7YHHQ8TXVq4zvyryVOKFNtSCVJu3VQjQR2ZLH8cAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+GbaDbn2h4W4XUW+9japFqKY/p0Ora/EcjHsbeO1QE=;
 b=HZK4Rqu1PWje+r1ODzL1DQ9o4TsNHK2LO4UHo1AQZsGgfnTBf+s8BQsf5NjJ6w0s/LObSAEKryntLr16Eshbwgc3zLsZn0I3eBI+SnHiKyKFtvkoHq5ZdSeDTZSWfoJJZkRU0/LJFccu+yWYujVFLnwaHTHIsKrr9yRYR/N1cWTfOlzumy+Zfi3x7Wyfmj7c5/oz5lYqjyntOYmZEY00XP/HnRPMF1qyQ+YZxoJfSMFu7kRwshw1z8nTVGlOf6JNYORvo+ORx+5NO6PsVEHNJS7Tf1vFNN5RsrW0zpXg9qMExabW6rQRv4tiKWVhN3EalJTqmlR24ADunwrn9K+6YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+GbaDbn2h4W4XUW+9japFqKY/p0Ora/EcjHsbeO1QE=;
 b=SecffhJQ2zpbeBEtiarsMb03rvkq2mwXR1M9c94QO9tRh10ZwKdQhIMvt1Yf6SNQmsXLbnhFSxPXbJZtXjHeIW53IWPuU6ig485+VFdzwYso9v3Pa4AwwzvO4BH9dSwR9+ThizgrUzhWFDesHJnM7t0XbcylyjU/sP1NE7USf0o=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0352.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:32::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Tue, 12 May
 2020 07:15:59 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 07:15:59 +0000
Date:   Tue, 12 May 2020 10:15:52 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200512071552.GA17235@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511125723.GI2245@nanopsycho>
 <20200511192422.GH25096@plvision.eu>
 <20200512055536.GM2245@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512055536.GM2245@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR0202CA0068.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::45) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR0202CA0068.eurprd02.prod.outlook.com (2603:10a6:20b:3a::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 07:15:58 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 509d8dc0-0b44-4bf0-c4f2-08d7f6445234
X-MS-TrafficTypeDiagnostic: VI1P190MB0352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB03522F7E6C16F34EF56C547695BE0@VI1P190MB0352.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJE1cfSX90NfCZn/DCocMg2PP+3vQyK3t4EEmxfHtHjF0xL8z9+M2VcQvmRm4NkgGDY3bzuoLyIfnl4alImGDkaUwtrck/8bPs5VjKMr53o7Ro4ko3slYNhXbK0rlnfnAljEP5ebv3TEBTzsSzkUHSHlM3TKfFcGRrIx12fyD0X5oUuSiLu3SssRjY5snT76CPtZ0UesPhbFCv39GwPlhFCR6vWyNSgELvCfZA8oaCPtj/h7wQOYfbMNErYq4ESeP7ZUYGN8wznRaghhmlRfY7CmviaT8vv7/a/Gf2Yc9o8bP9TOQT6y6lwMAWZi5k1dyJZ92E7NRhfuOhrTd18OOmaKYwgUgSnuGqGjGHwCMmIBoaIFwvVDKRo5c2/o7z/Rr2jiMIQeDwv1Qg7SdBlZrE97Hc6vQLu59tIyd0cyq4IvfekA0METlFqEIuyLmxFvE4KszthhRB6PQ5yJuh7imA2Kl+X/1yQZk9OvHODDlVLxPI8HdiM6ECKkPnnolY5w1ssQm9SOT6g0q7vtTtVChg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(396003)(366004)(136003)(39830400003)(33430700001)(33656002)(6666004)(508600001)(36756003)(5660300002)(16526019)(186003)(956004)(2616005)(1076003)(26005)(44832011)(2906002)(54906003)(8676002)(8886007)(316002)(55016002)(33440700001)(6916009)(7696005)(4326008)(66476007)(52116002)(66556008)(8936002)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 37IqkhmyHnG5sbDiuuyktb2WNSYSk11buVQqygmXiSDzSpkf/hP8pEeyK0VEua/uPq4u4PBBs+uOsoaH+AksHE26LMRvolJrzqDb3eIErPVeCyK3fbaXA0gPdD02heHLEAk8M6PdOWwd7H+CqDV3r5f9m3agV8pv3ETJwUkA+olD7er8sc3WXCw6PzIZ9ZTBvcTQ3Y3cXDUgAtapdk2sv37t1thCYwoRakbv9Nx8nnAKm3F53wWOe+7PZqeYf+u3HWv5KChgQNG3/FOFuCWlnUGHBYRnzUjx4lGm0Py9fTIxzlQE3d/QoqgsH/0mLMrc7g5+ZJMSiuscQzQ71IL1ncGG6nBBbrgATaGbH1xf/nJ22MqgSPlE36uP4+e9/5JtgJdL6lDz/jCBpYDhoeHN0QgyqsbmOiydkRWKAqpek+wzB/difMCQIbQ407JT0EqV87wwjAKXFWLmkuvIZoULix8lbBWb5KmC7UGiz2gQPqM=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 509d8dc0-0b44-4bf0-c4f2-08d7f6445234
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 07:15:59.6152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJBT7sa3sKkHWyBOQFV0bj0EEfcaimaZJ7gv/XsrJocYMytJDzgeG4SW0bzEcShA5Y4OxZwbzENns1V7+VBNCxTSzckUSThAHIN57coC3EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0352
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 07:55:36AM +0200, Jiri Pirko wrote:
> Mon, May 11, 2020 at 09:24:22PM CEST, vadym.kochan@plvision.eu wrote:
> >On Mon, May 11, 2020 at 02:57:23PM +0200, Jiri Pirko wrote:
> >> [...]
> >> 
> >> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera_dsa.c b/drivers/net/ethernet/marvell/prestera/prestera_dsa.c
[...]
> >> >+netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct sk_buff *skb)
> >> >+{
> >> >+	struct device *dma_dev = sdma->sw->dev->dev;
> >> >+	struct prestera_tx_ring *tx_ring;
> >> >+	struct net_device *dev = skb->dev;
> >> >+	struct prestera_sdma_buf *buf;
> >> >+	int err;
> >> >+
> >> >+	tx_ring = &sdma->tx_ring;
> >> >+
> >> >+	buf = &tx_ring->bufs[tx_ring->next_tx];
> >> >+	if (buf->is_used) {
> >> >+		schedule_work(&sdma->tx_work);
> >> >+		goto drop_skb;
> >> >+	}
> >> 
> >> What is preventing 2 CPUs to get here and work with the same buf?
> >
> >I assume you mean serialization between the recycling work and xmit
> >context ? Actually they are just updating 'is_used' field which
> 
> No.
> 
> >allows to use or free, what I can see is that may be I need to use
> >something like READ_ONCE/WRITE_ONCE, but the rest looks safe for me:
> >
> >1) recycler updates is_used=false only after fully freeing the buffer,
> >and only if it was set to true.
> >
> >2) xmit context gets next buffer to use only if it is freed
> >(is_used=false), and sets it to true after buffer is ready to be sent.
> >
> >So, yes these contexts both update this field but in strict sequence.
> >
> >If you mean of protecting of xmit on several CPUS so, the xmit should be
> >serialized on kernel, and the driver uses one queue which (as I
> >underand) is bound to particular CPU.
> 
> How is it serialized? You get here (to prestera_sdma_xmit()) on 2 CPUs
> with the same sdma pointer and 2 skbs.
> 

My understanding is:

dev_hard_start_xmit is the entry function which is called by the
networking layer to send skb via device (qos scheduler, pktgen, xfrm,
core - dev_direct_xmit(), etc).

All they acquire the HARD_TX_LOCK which locks particular tx queue. And
since the driver uses one tx queue there should be no concurrent access
inside ndo_start_xmit, right ?

[...]
