Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983C51CF898
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgELPHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:07:24 -0400
Received: from mail-am6eur05on2113.outbound.protection.outlook.com ([40.107.22.113]:18337
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbgELPHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:07:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d48bREqCT7y3BFK+ReQrhiakSBY860tHGgcg38/Hc/uputsBWhCXdU9g9dwUcRwHCj8DKGT/1OT6Vf/0t27KlVMdJjYk3tPx7QjHWtsGtWWjMrhtymibE1SPPhikgRk50l6VE31rcfGvLmw8sNP1rVx6KiTS3GdU1BI1H0LeJKZOvC/7zRdQlQwf+csz3kAsCurTtzlhuRSdP+Ql8D5QvBej5CPHezThV9GKL6hOTn2uSdUEVSwr7r42XV7Tg1hfMLA9Yo3/AT1k8oKS+N8rcaiavDssBWNHAC3S95ADhe+l9gw8hSbX9xxYm5yWJe6oe/enmrHb5LpcW4PHpYFPbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66CTW1gnTAdaK8iF4z8tlsxzvsQ0orVWZphpKrKFsu8=;
 b=KFmEP5XYyt8oCjoxr5GJI8D/iZ+TntN7HR1Q3by4/crThV3Lg0r8EGnk7JlPhGBYKnIFayPPSiHHUq6ceNLDIt9ifGnfd5GNVTTpvN3PA4euk68a0kySzrj/GdMw1dolBnK6cK+9BzHgGWu2j2RWDYDpqch0ikj3Hbtq6nrBwf/4dIboiwrz02CsEAih1YHFpV+lzAR6n14IGvvjetFQYphHP3TKAzIQLfrpKpZJ7JbPyHuG2czNtQSSxuKqh5vIhdxTUDLuGHzQ1c9a1eN2ZBUKBPp5VVdWHtNMNLBcF/UXSXY9Dg9qMsKAXeS1kIwj6B6dAucfP94lAkGPipqiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66CTW1gnTAdaK8iF4z8tlsxzvsQ0orVWZphpKrKFsu8=;
 b=ZBVJ2jaaetqDkoEzKnUziNM/2BGvxXV6XYYMNzr4lvvR108ER5qEMAz1VECZO5DKLRjy3OjsWf20mOZKYzrHMvKRRowX7IJp/3QnxpvdoLjmlIJTNdHYHPeJQZokA1pGj8AZxv7Fzf+uKcHbUMejeCSDT28cIR4GOr7duzVYqQ4=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0094.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:99::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 12 May
 2020 15:07:18 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:07:18 +0000
Date:   Tue, 12 May 2020 18:07:14 +0300
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
Message-ID: <20200512150714.GE31516@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200512145352.GC31516@plvision.eu>
 <20200512150306.GP2245@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512150306.GP2245@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P195CA0038.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::15) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P195CA0038.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:07:17 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a4c1a2-1b4e-4cc7-c790-08d7f68629bd
X-MS-TrafficTypeDiagnostic: VI1P190MB0094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB00948F9D65101EDC053292FF95BE0@VI1P190MB0094.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: szhjvi/E7ikFuZsEm9+FqfFAdHBsFOGZs965KMOtwYK7TU2ulrOl5VllDOxa5tImIXtUEIMO3yRU0iEEqO1CMFNt4NG1V7n+WDA2B2qXZQxTc3NxjMaqFk4HU7M2APZuQwBnybgKgslNglypQVvEmxH5gu6xxd6yeLpkaAO4uQ3SPh174R1Re9YxheJXvlK0bTv74tJ4IMX/4AonWZTXobjZ2dnnCMTAgtBot14sP84LucgltdubbnenfjYUrn+44de1NTfy11SdSTy0OMLWGx+Xv7aUi/vsUnnfyoQC/1VYtxSqq9UfUVVefiJ8FwaV87t+AERd/inJesAYXHZVoDy6iwqvemibj/uOtucus4veNB4gA88Ui5fqrj4dhOMX3sv+Rnp6+D97ETvvdO0bs0PujWtzu3eCD92lcZCURSGzxI0RYhPI5liAgyYl8IfYFdqjt4Ezq4PUsP60wIf+u8pgQBVhwCH2OGuZP8NOyx3MhONhzZWObs5NK5PKH7i3JBHNo46DP8IUiBZtkhuC4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(39830400003)(346002)(396003)(33430700001)(55016002)(8676002)(956004)(54906003)(316002)(44832011)(26005)(16526019)(2616005)(186003)(5660300002)(86362001)(2906002)(33656002)(52116002)(7696005)(1076003)(508600001)(4326008)(8936002)(6916009)(66946007)(66556008)(36756003)(66476007)(8886007)(33440700001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MHR1u5jmyQnDCgf0JUuWslycAyyRkSUNG2bBXf1Tff+f10JGKSik+HLwMxpvArH33G0pv0L5OnS0PT3bhsGw6CEjZmIyXB+XYK0qAT51qSkxBkNZDl8drnJnWhA4SQFBx60z9/hAVPmNUx/bvC/Bf1hPez6EmPrkZge9YZ7I5zrGn7kobWJxmseh6PibxlQ00EWM/6GmRbPcfhgRZyDcxnTX7SWh5w7425hFIhAl0YOqTpXHCJffvrPz9VDTKP7lj4MeJoim2oXiJgiZjaFPDF8kVxqOWHu5IYZ1p3du7bI42asyQoinSTzNqIt7SJumw7XHdnH5p7rO9dsXRx3RkpPyE3qRSfSRkdRe3Eelv7U6iebZav3z/klUlVJlSqswYNgsZVjX/GwtdX6M8dxxcUdsQUs9m0SLbuWJjHUwfQROwKezHD+qhEBt9UW7dui7Ztco8vLoe/qLlSY1tRLLtByPdSpZM+TG+Qrn2bTEXlXh63uXHWvwJbbTHMl9Xoyn
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a4c1a2-1b4e-4cc7-c790-08d7f68629bd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:07:18.4017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgVcmPSBRGMdw4y2udGxrEaViWx6JXci2mq6xEgnl6j0z83gXyULVYOaiqR2zbXgRQPAgs22loztVp2zXWuO+9TX4uTtQa+ArEGTiQBYd7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 05:03:06PM +0200, Jiri Pirko wrote:
> Tue, May 12, 2020 at 04:53:52PM CEST, vadym.kochan@plvision.eu wrote:
> >On Mon, May 11, 2020 at 12:32:22PM +0200, Jiri Pirko wrote:
> >
> >[...]
> >
> >> 
> >> This is RCU list. Treat it accordingly.
> >> 
> >> 
> >> >+	spin_unlock(&sw->ports_lock);
> >> 
> >> I don't follow, why do you need to protect the list by spinlock here?
> >> More to that, why do you need the port_list reader-writer
> >> protected (by rcu)? Is is possible that you add/remove port in the same
> >> time packets are flying in?
> >> 
> >> If yes, you need to ensure the structs are in the memory (free_rcu,
> >> synchronize_rcu). But I believe that you should disable that from
> >> happening in HW.
> >> 
> >> 
> >> >+
> >
> >[...]
> >
> >> >+
> >> >+static int prestera_switch_init(struct prestera_switch *sw)
> >> >+{
> >> >+	int err;
> >> >+
> >> >+	err = prestera_hw_switch_init(sw);
> >> >+	if (err) {
> >> >+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
> >> >+		return err;
> >> >+	}
> >> >+
> >> >+	memcpy(sw->base_mac, base_mac_addr, sizeof(sw->base_mac));
> >> >+	spin_lock_init(&sw->ports_lock);
> >> >+	INIT_LIST_HEAD(&sw->port_list);
> >> >+
> >> >+	err = prestera_hw_switch_mac_set(sw, sw->base_mac);
> >> >+	if (err)
> >> >+		return err;
> >> >+
> >> >+	err = prestera_rxtx_switch_init(sw);
> >> >+	if (err)
> >> >+		return err;
> >> >+
> >> >+	err = prestera_event_handlers_register(sw);
> >> >+	if (err)
> >> >+		goto err_evt_handlers;
> >> >+
> >> >+	err = prestera_create_ports(sw);
> >> >+	if (err)
> >> >+		goto err_ports_create;
> >> >+
> >> >+	return 0;
> >> >+
> >> >+err_ports_create:
> >> 
> >> You are missing prestera_event_handlers_unregister(sw); call here.
> >> 
> >it is handled below in prestera_switch_fini().
> 
> Sure, but you should call it here in the error path as well. That is my
> point.
> 
I understand your point - to make error path more clear, and symmetric ?

> >
> >> 
> >> >+err_evt_handlers:
> >> >+	prestera_rxtx_switch_fini(sw);
> >> >+
> >> >+	return err;
> >> >+}
> >> >+
> >> >+static void prestera_switch_fini(struct prestera_switch *sw)
> >> >+{
> >> >+	prestera_destroy_ports(sw);
> >> >+	prestera_event_handlers_unregister(sw);
> >> >+	prestera_rxtx_switch_fini(sw);
> >> >+}
> >> >+
> >> >+int prestera_device_register(struct prestera_device *dev)
> >> >+{
> >> >+	struct prestera_switch *sw;
> >> >+	int err;
> >> >+
> >> >+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> >> >+	if (!sw)
> >> >+		return -ENOMEM;
> >> >+
> >> >+	dev->priv = sw;
> >> >+	sw->dev = dev;
> >> >+
> >> >+	err = prestera_switch_init(sw);
> >> >+	if (err) {
> >> >+		kfree(sw);
> >> >+		return err;
> >> >+	}
> >> >+
> >> >+	registered_switch = sw;
> >> >+	return 0;
> >> >+}
> >> >+EXPORT_SYMBOL(prestera_device_register);
> >> >+
> >> >+void prestera_device_unregister(struct prestera_device *dev)
> >> >+{
> >> >+	struct prestera_switch *sw = dev->priv;
> >> >+
> >> >+	registered_switch = NULL;
> >> >+	prestera_switch_fini(sw);
> >> >+	kfree(sw);
> >> >+}
> >> >+EXPORT_SYMBOL(prestera_device_unregister);
> >> >+
> >> >+static int __init prestera_module_init(void)
> >> >+{
> >> >+	if (!base_mac) {
> >> >+		pr_err("[base_mac] parameter must be specified\n");
> >> >+		return -EINVAL;
> >> >+	}
> >> >+	if (!mac_pton(base_mac, base_mac_addr)) {
> >> >+		pr_err("[base_mac] parameter has invalid format\n");
> >> >+		return -EINVAL;
> >> >+	}
> >> >+
> >> >+	prestera_wq = alloc_workqueue("prestera", 0, 0);
> >> >+	if (!prestera_wq)
> >> >+		return -ENOMEM;
> >> >+
> >> >+	return 0;
> >> >+}
> >> >+
> >> >+static void __exit prestera_module_exit(void)
> >> >+{
> >> >+	destroy_workqueue(prestera_wq);
> >> >+}
> >> >+
> >> >+module_init(prestera_module_init);
> >> >+module_exit(prestera_module_exit);
> >> >+
> >> >+MODULE_AUTHOR("Marvell Semi.");
> >> >+MODULE_LICENSE("Dual BSD/GPL");
> >> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
> >> >+
> >> >+module_param(base_mac, charp, 0);
> >> 
> >> No please.
> >> 
> >> 
> >> [..]
> >> 
