Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D692293921
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393139AbgJTK16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:27:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32898 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388880AbgJTK16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603189675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PdZl73UkO228CMKkGpG7RCB+Mqm8Rde2aTDWhxT5jWc=;
        b=A/Fv3JrNwD4uizdnEA9h5hbrmY0jTl8X06jB7Adw5z/3+KsS1CYdk8wFaC2If056fEkyss
        AFHIkVshyuKB8V1geJtQn1AZi7HHs7bVzs4hHzmDOm2U3aAfVLtT8mc7ZaxiN/l2hpTFGw
        057im7TP/rOUMhgA04PKLfTnNvntAiQ=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-baJakCy-OZOIl5ao64_ptQ-1; Tue, 20 Oct 2020 12:27:53 +0200
X-MC-Unique: baJakCy-OZOIl5ao64_ptQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBiSLMA1Q6JEXWNgCsGBY+WpoLnWAipcmN3Q8mghlLgIF+DmJxY3gw2k7uamtO7b1msisVwIlWZmx+c1CfrwJaMTye0LxZQGqSGCF+WxmDYyTECioDXcQgHtT3zVyOZ4flklUym+NYbRkP5c3bVshBPhnRj6k3zIgyy01ooSBeyQfBLcVDqxGpsxRBZKN39vp7IoqQ9UK0AZug+pteJU4AM1U+j++DqI87h6w7P/0IYxsEcaEux50s5nR0+ZeM+3zsqxxdbtTQeKUhuW5+F7nKdCNGyFHyDZELo0oneIdRz33INRuAqHYjEwEFDDoaIYeceydfz1KJrhPRbqFrjTbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdZl73UkO228CMKkGpG7RCB+Mqm8Rde2aTDWhxT5jWc=;
 b=WlcVUQCjHxaVIYzuDvleKvgmdGvByjZ35jAF69IH7hgMxk5Peg+IYvyvzfYBpivtg0+7dm7Df1yW5BU4loIIpUUg9PMGYdqXPAgBeAN/nEubWpyI56wE2ZLi+eF74eBWfTzqlArIN+lsDmwUyqvL9Sj6F/OsyDAPKp7MSZhmUc281l0cBELDO+tpFDOHiR/op1HjKxwhV6vEsgQ5eVe7y9buBNqxjO7HjMKCamNe6fbc4r+vEDsF8OAj/fROIwh7RL45lCUE+KQ6vuSsLjFpg1RwP3bdKDUHl/G6UZ3kQ8DVa3QYOJo7mFF+7JYaFn2xrfNtlv99zV1wPQvvhYqlyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB8PR04MB7113.eurprd04.prod.outlook.com (2603:10a6:10:12a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 10:27:51 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 10:27:51 +0000
Date:   Tue, 20 Oct 2020 18:27:41 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201020102741.GE23594@syu-laptop>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
 <20201016115407.170821-3-coiby.xu@gmail.com>
 <20201020085711.GM7183@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201020085711.GM7183@syu-laptop>
X-Originating-IP: [2001:b400:e256:5604:908c:43ff:fe8c:2fe3]
X-ClientProxiedBy: AM0PR06CA0078.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::19) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (2001:b400:e256:5604:908c:43ff:fe8c:2fe3) by AM0PR06CA0078.eurprd06.prod.outlook.com (2603:10a6:208:fa::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 10:27:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eebca617-8bfc-4757-84c8-08d874e2cc33
X-MS-TrafficTypeDiagnostic: DB8PR04MB7113:
X-Microsoft-Antispam-PRVS: <DB8PR04MB7113078B45A6A021238335A2BF1F0@DB8PR04MB7113.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7pneU13RNd7OIRybxvXkbsqoO9ZON2R4Oa46RezXi/g4JySjvodvw0f1+YYxxH6uyeQmoqag7qhR0TveHOQCt4kFtuBGhDNLl1mwOFZB1lx6bsw2mPYEq867zZOlblypgMAGlLP0fninbTx99YInp+O1105vVSSU/XKIeRzoWTYm5Iewp1RFeWYB9rPAq3pV42BjipjleHeyxz1s7fvicFrfDOnTwkg6wgq6+WXbbfC58roxVRUwlFZctzU8cyMqVdwMN0OX5QaAUU1qn0EHHp7XVtltxt+173Fbbo4IoAu0Y31wl/Su92ZDacEajVbLWjHCxbOvzgH3GnnzmdQ1lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(366004)(396003)(136003)(66946007)(4326008)(86362001)(6496006)(54906003)(33716001)(6666004)(8676002)(8936002)(316002)(55016002)(7416002)(33656002)(2906002)(66556008)(66476007)(6916009)(9686003)(5660300002)(83380400001)(478600001)(52116002)(16526019)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GmwTzXrQWs+dNLcwXgRWTLV3yvhqeCfxOm0JvoREj8Njf90Izbxr6399uCsO4YfDDnKfcTCPEoaygDVxqAiwORzQ0mhAheawowbAfDT8NPGyQ9oFb/XYyFxYWWGj12nGWrsbx2Z+ZfkACb/ny34HkwWllalfk9J0c8X6aknKTpU0E5QK6xUjLlOAfRzSQXHqLdKEa03V3RARCMC0pl02l8Pc1bRZJTzR3z49RH8OhE+c4NC9oXkuL1Tb0zns3uPBjENi0ihbg2sxkxGB+1PaKYGAxc5Jx8Lyw9Qyma5R7vjuEA8ClcpN87BBwQmUBqhEWEkgGsmoWfJRE6RD3zL13W/80xVokmkkJlsrMAzRQFteh6a6QeoLptL5tKiLHTSlnZHQnUVlp+QSJ21em+KbyN6FK4OasXA6ekUavW7Bn+y/rCQZ3UFeXf/09+J8rCZ3r6xW+qJRSya5OUdP5GDHFIFlAxI0kbTyRLGnDzE3tANk5ivHmrBsQ29QwjMtKbQnlrOPDa/cG4f/Wxh8SmrTOWFouii0+qsVNYeACIfEC3xhaQjksSv1EAPoIUzqwusCHXPHpiVdY7DDyNzdyOGRWqtNaw+/J9w4/17Pin0nJLK6xDfd4uLBUkH+5bXcW9rcErlD0bbjc6jxp7Hww9ja4nHOIwiABb3J5UDlcAVMkhC91YwgGEEH/DtqPqRL6jW2+ZiQnkIWyr4Fgmc9sBKRGQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eebca617-8bfc-4757-84c8-08d874e2cc33
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 10:27:51.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZb3kKLR3Tmt3I4VwCSzPW7d1hwBCU0PsQdK7u9KY4OD59AnTFGNPtBoZfQDqXxEkyUUG6NybTwxt9tMUopt0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:57:11PM +0800, Shung-Hsi Yu wrote:
> Hi,
> 
> This patch trigger the following KASAN error inside qlge_init_device().
> 
> [...] general protection fault, probably for non-canonical address 0xdffffc000000004b: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [...] KASAN: null-ptr-deref in range [0x0000000000000258-0x000000000000025f]
> [...] CPU: 0 PID: 438 Comm: systemd-udevd Tainted: G         C  E     5.9.0-kvmsmall+ #7
> [...] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-
> g...ilt.opensuse.org 04/01/2014
> [...] RIP: 0010:qlge_get_8000_flash_params+0x377/0x6e0 [qlge]
> [...] Code: 03 80 3c 02 00 0f 85 57 03 00 00 49 8b af 68 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bd 5f 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 c6 02 00 00
> [...] RSP: 0018:ffffc90000f97788 EFLAGS: 00010207
> [...] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [...] RDX: 000000000000004b RSI: ffffffffc08cb843 RDI: 000000000000025f
> [...] R10: fffffbfff5f718a0 R11: 0000000000000001 R12: dffffc0000000000
> [...] R13: ffff888111085d40 R14: ffff888111085d40 R15: ffff888111080280
> [...] FS:  00007f315f5db280(0000) GS:ffff8881f5200000(0000) knlGS:0000000000000000
> [...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [...] CR2: 000055bb25297170 CR3: 0000000110674000 CR4: 00000000000006f0
> [...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [...] Call Trace:
> [...]  ? qlge_get_8012_flash_params+0x600/0x600 [qlge]
> [...]  ? static_obj+0x8a/0xc0
> [...]  ? lockdep_init_map_waits+0x26a/0x700
> [...]  qlge_init_device+0x425/0x1000 [qlge]
> [...]  ? debug_mutex_init+0x31/0x60
> [...]  qlge_probe+0xfe/0x6c0 [qlge]
> <snip>
> 
> With qlge_get_8000_flash_params+0x377/0x6e0 corresponding to the following:
> 
> 	if (qdev->flash.flash_params_8000.data_type1 == 2)
> 		memcpy(mac_addr,
> 		       qdev->flash.flash_params_8000.mac_addr1,
> 		       qdev->ndev->addr_len); // <---- Here

This is because qdev->ndev == 0.

The reason is that before qlge_get_8000_flash_params() get called qdev is memset-ed inside qlge_init_device().

static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
				    int cards_found)
	{
	struct net_device *ndev = qdev->ndev;
	int err = 0;

	memset((void *)qdev, 0, sizeof(*qdev));

	// ...

	// qlge_get_8000_flash_params() get's called
	err = qdev->nic_ops->get_flash(qdev);

	// ...
	}

