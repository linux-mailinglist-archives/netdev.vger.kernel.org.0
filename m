Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C91E26E7
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgEZQ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:26:58 -0400
Received: from mail-eopbgr70105.outbound.protection.outlook.com ([40.107.7.105]:28259
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbgEZQ05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 12:26:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bT6MIKNfoT0VfJ/nniB0VlG3al6dzMnev5sx3QqvmsY9+gzyYvqqbFo9J69/3rvix70PQLrx6WtkAq596CrxAf1oLqroCDC2Gf/sZTT8NqEchcgU0VxrLKuQDtiu3cQsARCMIEATHfchmqZtP8AQwiNg6HIRP/YO5cFHWIU/n8TBEJNJ0vfpbY/sdIQ/VkH/janN21Nbb29bWwcpvGOK2hylVZVKRLdpj7ak5Pm/DVfr1TkZwyOXpldcYzm99iJAZ3G8V+XrbR9R058+PC+xnQD4EI476lM8V9llhDjo5jUhWjnJ+6UfMT6ARUfM/IMWZL+9CbCeeTNcRjPkuWc+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqaTJd/4h8LPF41NTuH+5LpQ0UNjZNLcjrp4V2ueno0=;
 b=mYruujUmMMYqdZpkQpmgGzu4tvOqVdTROPXeaSzsPTdY1OQ4pDrvcFhbFvIyIcSi6CM2r1jFrOJ/XcgOts6ZwNovWC3RELlLpbdcamJHbRPcvJ98e7w+vEEhnlN1Qfm8KashIJ+bA3AOyFPyM1yRflhB8yoEie1eakOlrBlT44KYOqSvhr8JinJba7w3J360YZ9DLfTlWMrFKFW9y56U6zlrOA0qUbY2pbM8GqU6w2H73sofe76dpbB1+d/ZeXcyATUNTlpLTX8ljK09k6+Uh5L0l0OeVgU3YMZhR4LkWNDb4r0EdbbPe85/DmU+GC4cE7vRGnkZWQoZ6hd02Rj64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EqaTJd/4h8LPF41NTuH+5LpQ0UNjZNLcjrp4V2ueno0=;
 b=wrJHFfzGPEiQxsXxvmKVzAraM+/r/5Kd9XGgnBgRNr38hrtaxJI09MwpIHfQ5DczKcttvtFbJJuv09Oln2z67xnII/d7A/ZuSQ98Une7eYRqbdRI5QlyDge1sGk/Cf/koxgWdcdDmOh36O7qvl485SY8a6qmb8mNP9mTm4JNW+I=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0528.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Tue, 26 May
 2020 16:26:53 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 16:26:53 +0000
Date:   Tue, 26 May 2020 19:26:44 +0300
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
Subject: Re: [RFC next-next v2 2/5] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200526162644.GA32356@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-3-vadym.kochan@plvision.eu>
 <20200511112346.GG2245@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511112346.GG2245@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR0202CA0068.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::45) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR0202CA0068.eurprd02.prod.outlook.com (2603:10a6:20b:3a::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 26 May 2020 16:26:51 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f0974cd-f241-4fd5-19ce-08d801919961
X-MS-TrafficTypeDiagnostic: VI1P190MB0528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0528FA1EEA202BBA97DF469595B00@VI1P190MB0528.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgL7ZEk5ieu0x7ElVuHyhOHEmI1anld1hvU6JTsa6qk9JsYW6fBVbcM10WIDL5yUrVec9QGMaj/56AjqVasF8JgLBnB2Bx7Tr6WlVBxKuhNOHy0KHBKiVkapioJ8l3CZzABxXZp3LVOTjpCPlJz0mrI5wxuZVz/V/t/Te4JZBWipQWIyU1m/UrLPtzicRQl+N9fJfA+/7CNjO4MNUNJRY2rRy873g2xcBprQd3olR91YtSrqXYgyfUZdVyUlNWVZW7JdO6mnwLRQyw88F/yp/R/R4S8mb7uK584FiXV9a7wBQJLNnV+nC7AQn5qpTMpk+fhhQGZKOQPXDrwKTzj67Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(39830400003)(396003)(366004)(26005)(8936002)(2906002)(5660300002)(4326008)(54906003)(8886007)(316002)(7696005)(52116002)(956004)(2616005)(36756003)(66476007)(508600001)(4744005)(66556008)(44832011)(55016002)(33656002)(8676002)(6666004)(186003)(1076003)(16526019)(6916009)(66946007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: b+fg0MVE73ej37oFmKzc83POTdAuMnEMdvMLXznMtdvFFSwOCKjC655ABRs/YtcZPgtkS7XWMwwYwU/expsvJxtrXUG6OWL7Gel4Gas25QGx94b/cvAXhBBfovQ3+Ryly4zW2EFG3MrROh3K9QUvcIFy0Hd85yOXcjQfYZvgqwDEf1BDEipRx+OKeVaYKsrCd8JYXBoshiESfo0CZnumA2MFHzzmRBguEwOojuKZ+S3i8bDdt6jm9d8eXes2/IUjuueEl3lrZlR0y0w2IvLmqBNPXBMgXFGyJzTxKwq3je+Xb8Gsc8DRSyk2ysq7nDW8D48R4Vn66+J0VvEzunnkjGvovfQu3KdgF9AWfla+MdhFP/ZxDTCGr4e1AwF1JbzLITcxk6YN//s60Bl6vaO0rhAVRU82utxdRYe+0FjtCz8NL4+OKSpB0wH5PV7gfZiniUZb2sWqvbh4YOuBSGWCB7oTbulHhosEKFFIPNFkGlnP42PeY6v3fo96YFNnTR06
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0974cd-f241-4fd5-19ce-08d801919961
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 16:26:53.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2i3PAtwUxXBAe1pbB+JAxX4evlB5RMhsycDNMTep0lVzCWBcc3FXhKn7eRrDcZMGpRF4He25EFjgFJVjG+/WtKx9UE0lPBScZWVSPj5TP9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0528
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 01:23:46PM +0200, Jiri Pirko wrote:
> Fri, May 01, 2020 at 01:20:49AM CEST, vadym.kochan@plvision.eu wrote:
> >Add PCI interface driver for Prestera Switch ASICs family devices, which
> >provides:

[...]
> 
> This looks very specific. Is is related to 0xC804?
> 
Sorry, I missed this question. But I am not sure I got it.

> 
> >+	.id_table = prestera_pci_devices,
> >+	.probe    = prestera_pci_probe,
> >+	.remove   = prestera_pci_remove,
> >+};
> >+
> >+static int __init prestera_pci_init(void)
> >+{
> >+	return pci_register_driver(&prestera_pci_driver);
> >+}
> >+
> >+static void __exit prestera_pci_exit(void)
> >+{
> >+	pci_unregister_driver(&prestera_pci_driver);
> >+}
> >+
> >+module_init(prestera_pci_init);
> >+module_exit(prestera_pci_exit);
> >+
> >+MODULE_AUTHOR("Marvell Semi.");
> 
> Author is you, not a company.
> 
> 
> >+MODULE_LICENSE("Dual BSD/GPL");
> >+MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
> >-- 
> >2.17.1
> >
