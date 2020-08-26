Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636DA25290F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 10:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHZIR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 04:17:59 -0400
Received: from mail-vi1eur05on2111.outbound.protection.outlook.com ([40.107.21.111]:48032
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgHZIR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 04:17:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfvokVG1TbJgJAl9QpvIoAV9zSopZ6d9uC2tbcIZaGsWSTJlN9wTku3nwie680gUi0vYcemitLelaAKkvDVHxE8avHgHOkqkI6G+Fq+bWNQGUMm34+ZJ+O2Ko2yIRHF7rAySH0lO9BaRXpb9GqSDNjdWTi2Wa862Q+mQ4Orf8kmrAmcfD98nv3tRYuBiCy9ioREE+rU98snwTPYhQnU7/vkMc4d+2DnVQ2imI+0QDfTp+wBZa24IrmNDHcTmMyJ5F0jrgnwBti3EfEtVCWjWjkO7GkQuBIVkfkURIdckCq21nTq9DPuiIs88Qbbr50mA2a4byr+nYYeGxV4K6mIzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaFhmyvTxIsYL8VLptqh00nGlcTSDujn5+8USxGZisg=;
 b=FsO8Pob2hISn17GxxgV5YkFshgo7XBrltQ5KXDuprTmIDbOitPlqL7JS3sxoApbuLPr+oE26rIqhVilS4Tl7pE/8wLzA7wD1JLNINN+WtZURsL3bYkQExB+T8MX4j8pz2TEk18HhsPyLQhZx2rnxVqvQToPsJqRiMNxIxOYPCnIsdiDSTN3oRmQ9Xu3YkL2r5tbtQpCLZkkvBP2JfxRMDOX91Gmpr4ySf+sbumvnEIBSVt4zAX8qIXuURqn1adAmt/nI3lZzAEGosTLE0xy3Wbgq1EWywNcxfvnmwyCeqK4qriOwCMz3hoedNDP4f+CqdcwkCrxRQUQrna2sn/7ZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaFhmyvTxIsYL8VLptqh00nGlcTSDujn5+8USxGZisg=;
 b=CXHYZTW5yW4gHyX1Wpt7EIkCZSqMIy16L5X+OwI7iOuZejjGB+EGbCbM8HF/cCeucrUQQejn5PnZKLphNB6XOTvula6CVgXLwmupm6256sKhP8DqGMBJBHU4zFradZ4f7YoWr+A6b2fh9cvQ6TaDYLw4GD0d64O/4kNDSfC68IA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0153.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.23; Wed, 26 Aug 2020 08:17:53 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::b1a4:e5e3:a12b:1305%6]) with mapi id 15.20.3305.026; Wed, 26 Aug 2020
 08:17:53 +0000
Date:   Wed, 26 Aug 2020 11:17:44 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        volodymyr.mytnyk@plvision.eu, taras.chornyi@plvision.eu,
        andrii.savka@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        mickeyr@marvell.com
Subject: Re: [net-next v5 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200826081744.GA2729@plvision.eu>
References: <20200825122013.2844-1-vadym.kochan@plvision.eu>
 <20200825122013.2844-2-vadym.kochan@plvision.eu>
 <20200825.172003.1417643181819895272.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825.172003.1417643181819895272.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:203:90::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0402CA0022.eurprd04.prod.outlook.com (2603:10a6:203:90::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Wed, 26 Aug 2020 08:17:51 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f7a3c20-9b4e-441b-e1b2-08d849988758
X-MS-TrafficTypeDiagnostic: HE1P190MB0153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0153831B7F69C8FB8068062995540@HE1P190MB0153.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOJGqsKurXCDABRCA2rLHZSKa89GxoAVaqoUeh6JeWaNZgcznRPQ4/n6/em3Fjf/r9ywrbFo773Hk056tOuzgqjVqfj4iBQxfBWtJJUbuWNr9WgifoJVsYBGvMSOSKyyHUSHk50n5TN5TJboWyd8/ZUoCAmv9LtkUkeHul24W99V6AR02x6jHF8/YP8yi/9yaRzAcUWWpQ9GLAHMGN4lnFRFKB4wYfK7nNoJuc1L8FTiHZqRWrI+GdPzDGHjzVIEft16zNzNh475Pty7AVTbZXUqniDsX69OkXIYPneB2ePPPDd6gxUABqHj+Rhs8pNKupustXRhonp6p7N1nWRznw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(396003)(376002)(136003)(366004)(186003)(44832011)(478600001)(8936002)(86362001)(6666004)(16526019)(83380400001)(1076003)(33656002)(55016002)(6916009)(2616005)(316002)(5660300002)(36756003)(956004)(66476007)(2906002)(26005)(7696005)(52116002)(66946007)(8676002)(4326008)(66556008)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fgQnbXoxvpdMqV3bXsxP9Dg6gIyOJaWfM+hyNqo+gBqG8fIKMEkOeaqn6GWPOA5jvs0O2baIDr8ybnQsI/pJUSHp8DwxMFFxTLa8uzXCWz8Kf6vZoUsU8nNNSoYj+b9AsacWBMGk3jC2/dUlojc+5rMJ7w/dZb5chbske7gqMvY79uxbj/PtJnYcvJ442X/qHr3QNc0Z12hvv3/vMlnjDDccF3gDCRG1rRiOCIwT7g50QkTJRX0oZ4fKXulGP0hUenLVEGuVgeme3RZLOHbcMgur9NJaemVDCfKAGaJ/P26px0y3PHJ8kTiDtYmXzDgJTXiNxP5FQu5x927SwErQjtF0FzyKxIgdABxdvFh8nxEyiB68F1HXrDmkYrjnSvMWGkcI+NsRjSL74l/mGbai0eaGDVX2DvDTNSoInaCaEghooopDEdPxu08+52c69wLVfucbDsk6xmKTn4uWIFP5FbzH1/rM8aTS/Ww7jRo32f9hZxzg7Am0L6SwafVE+KIBFGrEW3lxfZbCwoF8pXr1fGxJCNJQfrxrC/mRUN2rU0BXgRqOrfa3XS12VjXDnybl3Gvg7Nd5kuqz5YiP+lz2slaaTV8QkDJccUT+FQsAcUNdW8hYKg1mUpTWliHtrZ9DO1QBxyo1wQLYbdDjaGdyUA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f7a3c20-9b4e-441b-e1b2-08d849988758
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 08:17:53.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Un74EjpZgA+UIyGy7aVlf3ThupaJ24r1HSwbO7BRF92NNR+MA97apgbVrOrnLK97oTdOPXYHHrGgdnkmfEL429JbTR19aHwzkSYeG20Zi2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 05:20:03PM -0700, David Miller wrote:
> From: Vadym Kochan <vadym.kochan@plvision.eu>
> Date: Tue, 25 Aug 2020 15:20:08 +0300
> 
> > +int prestera_dsa_parse(struct prestera_dsa *dsa, const u8 *dsa_buf)
> > +{
> > +	__be32 *dsa_words = (__be32 *)dsa_buf;
> > +	enum prestera_dsa_cmd cmd;
> > +	u32 words[4] = { 0 };
> > +	u32 field;
> > +
> > +	words[0] = ntohl(dsa_words[0]);
> > +	words[1] = ntohl(dsa_words[1]);
> > +	words[2] = ntohl(dsa_words[2]);
> > +	words[3] = ntohl(dsa_words[3]);
> 
> All 4 elements of words[] are explicitly and unconditionally set to something,
> so you don't need the "= { 0 }" initializer.

Right, will fix it.

> 
> > +	INIT_LIST_HEAD(&sw->port_list);
> 
> What locking protects this list?
> 

Initially there was (in RFC patch set), not locking, but _rcu list API
used, because the port list is modified only by 1 writer when creating
the port or deleting it on switch uninit (the really theoretical case
which might happen is that event might be received at that time which
causes to loop over this list to find the port), as I understand
correctly list_add_rcu is safe to use with no additional locking if there is 1
writer and many readers ? So can I use back this approach ?

> > +	new_skb = alloc_skb(len, GFP_ATOMIC | GFP_DMA);
> > +	if (!new_skb)
> > +		goto err_alloc_skb;
> 
> This seems very costly to do copies on every packet.  There should be
> something in the dma_*() API that would allow you to avoid this.

There is a limitation on the DMA range. Current device can't handle
whole ZONE_DMA range, so there is a "backup" mechanism which copies the
entire packet if the mapping was failed or if the packet's mapped
address is out of this range, this is done on both rx and tx directions.

> 
> And since you just need the buffer to DMA map it into the device,
> allocating an entire SKB object is overkill.  You can instead just
> allocate a ring of TX bounce buffers once, and then you just copy
> each packet there.  No allocations per packet.

Yes, this makes sense, thanks.
