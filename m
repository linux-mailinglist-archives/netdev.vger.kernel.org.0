Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE91CF7EF
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbgELOyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:54:03 -0400
Received: from mail-eopbgr80099.outbound.protection.outlook.com ([40.107.8.99]:1159
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727832AbgELOyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 10:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leG+IF7w70uvqBKBmJ2ibXRQw8Bonwx6T4++VKahj/UQYkR9xNVqRyIWSY2buu8EAkmJrh9Wlv/dyXHu49TsziRy9lEPS9L3ZCnuCYMpsHLScbMwfT3D0L6xZZ5ijBaGsoJg4M6/RC38b+1JfWLPmd49uSEMI/heWOBczIKlq+cQNlIWBZYjam5a8VAufi/Q5ht8T0nyLw5mqih5aaLs85fS22XAoQur2NplhyttztzpgrvEvUgSYv4i5IgNIgQfJBaZ91cNp8lsoHFVgIwEA55gXXGC6KNKqqyPI5u4itCxotmLWT0shA2BRe1kAU+vLIXNAiRlYCqlX2pGS5SSvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvYA5O3CNhXnW0umi52fYe+5ahOzX/k7AcySd9Xo780=;
 b=hi9+OQXfMR4j7m4JqzkgzOhiqy+MBMWOI0ksxWiYFtRbPTA4vq3oOfTuJwRynoR9T3HD190mZTah0dIceE4vGP9CV704yMc6po9eJRx0jPWykWSJXU5wTffiSoCsFhEKLgOWnQdz84yPqZZE5fpN6MhXxA2I7OIfKoRMc+/Uv4yiPwJo1DlTotvbvOHSrDStzisIMfO6Ct8GDoU9F2ClfPg4G1vjNWxXNVZzt1anbEXiU5EcChbAQA+NpfUosYCYws/0mieBTtpf3XAy6gwGzm/cIsPKnA6Yo+8U++dpPcUUjq//AmOIOp4UKUvUOKYa6VZFZHkVzJCVMy3LcI/G5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvYA5O3CNhXnW0umi52fYe+5ahOzX/k7AcySd9Xo780=;
 b=esnQDRbd4IL49oKssCiWk8qa9DUJCGk7gtEmSEW6ONqXc9TmXqKrck4BSxB1Q77VQTTRurO6Ei8A4qIoHZvW/gEMIJ/pDzy6OV1tUaipVmo4K/ZokZ8mO4DQHBf8p+5S0hr3caZmnvAUYptUwpWKYcH3W8f5NfUbKVZ0MyWLr3Y=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0525.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:30::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Tue, 12 May
 2020 14:53:56 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 14:53:56 +0000
Date:   Tue, 12 May 2020 17:53:52 +0300
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
Message-ID: <20200512145352.GC31516@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511103222.GF2245@nanopsycho>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0402CA0022.eurprd04.prod.outlook.com
 (2603:10a6:203:90::32) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0402CA0022.eurprd04.prod.outlook.com (2603:10a6:203:90::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Tue, 12 May 2020 14:53:55 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7316c85-fec0-4c18-b171-08d7f6844bb9
X-MS-TrafficTypeDiagnostic: VI1P190MB0525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0525A031D3EB8FD361BAB77F95BE0@VI1P190MB0525.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDxVHDxfUorGeVC+l+xwxhay0+xN+zlTZMzazvJNwFgx64NG8ilG08h83wYBAxKt5DT7vW1nyui38OxIG36fRGMprnof0veC/SRIZvqvBOz1YCUFuJQgHEBL+ASAfHMzTlln/GdZtmDTbUvHiApCFmvhlFfW9TLoG+5FMks1+sJnPfT5qybr1kzUbKKFwNrN3NlelfiXmJB0SjcScfUMq+QwEhBVw5JxIu4VgcBucheCW+jz7nRAC1/drHwaLqD80Dwa7wuzX4GGU7zSF6zGvP4BgBrB9nA1RAKt0N0QdDYiTV4j8JE1ZT9hQDscQhzZ6lVh3KeNBPWPWQO2+Dz2TiMZIkwZrjmSsIBmo7mHuXpktX05jcCrSzyfGVbXoPpq0b7xRVibCAusdKCY0rpWNRFgYKqdjBEFDgZNqVR9FJLMP3zz23rnf03LTHt9MOJmP0N5OgNV5EbLCA54IDRO60Qv9Tjal19zYw9JYzQPZ1rxQEXCVc26wiTzJRKtML0EEoE/ew1HqLLaoPvhHwv+mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(396003)(39830400003)(366004)(346002)(33430700001)(8886007)(26005)(66476007)(2906002)(16526019)(186003)(6916009)(86362001)(33440700001)(508600001)(316002)(8676002)(6666004)(7696005)(54906003)(52116002)(2616005)(4326008)(8936002)(956004)(66946007)(66556008)(33656002)(36756003)(1076003)(44832011)(5660300002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: YtLj0w7EFYHYWZ+OfTWBVQ64QPKiclofEkTwUj7UrlLUZL+63qaU63LETkJ613+bGsIsIKV05ziiWTMtvnEzMfcsJPBsdbxOQOOO+i2HgV4M6UQowR4ufHh5gQm2KBkEYPlxzy1XEJUIsYdohnPU18QE+/faOBQfdGlWXuMdxkMs03Crm75cuo8q0mHfax/0zy5lyyvQHV9EC6WwGSXjkRo068B9sU1DEB20CbbEuFT+gRPGO8hoYc9iX+LLHmAKv51/sOI/Jnmu9tvLmKRzHuZMYvzGCLrLWsTwaMe9cJHgi+VJDxN7QLRWZ1khV/6qRqHQrPmlrpE0KFzzXqtn/+nEUyFr50de8YU2CW23SfJE6xIVM5julTUsXnPZ7MahoLOJPxYwowAfIk0u40cglFn7ikR5jHxWgCfbusCBHO3H04Hm1n5YolYtG5hyV3YJYXKHoMAx20PxDxGamrq+2XAsCIMwVYVPQTNGBhZ5wy8=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e7316c85-fec0-4c18-b171-08d7f6844bb9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 14:53:56.3940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eWrHmCzpqjeUxN3GiHqwf8UpMevlcjbfvnSor1uoh6xUM7mNnEt1IylCFHR5SUAb793KdfNXUrVAjwb5iic0N+OcPmSlirDewQUpahLzYUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0525
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 12:32:22PM +0200, Jiri Pirko wrote:

[...]

> 
> This is RCU list. Treat it accordingly.
> 
> 
> >+	spin_unlock(&sw->ports_lock);
> 
> I don't follow, why do you need to protect the list by spinlock here?
> More to that, why do you need the port_list reader-writer
> protected (by rcu)? Is is possible that you add/remove port in the same
> time packets are flying in?
> 
> If yes, you need to ensure the structs are in the memory (free_rcu,
> synchronize_rcu). But I believe that you should disable that from
> happening in HW.
> 
> 
> >+

[...]

> >+
> >+static int prestera_switch_init(struct prestera_switch *sw)
> >+{
> >+	int err;
> >+
> >+	err = prestera_hw_switch_init(sw);
> >+	if (err) {
> >+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
> >+		return err;
> >+	}
> >+
> >+	memcpy(sw->base_mac, base_mac_addr, sizeof(sw->base_mac));
> >+	spin_lock_init(&sw->ports_lock);
> >+	INIT_LIST_HEAD(&sw->port_list);
> >+
> >+	err = prestera_hw_switch_mac_set(sw, sw->base_mac);
> >+	if (err)
> >+		return err;
> >+
> >+	err = prestera_rxtx_switch_init(sw);
> >+	if (err)
> >+		return err;
> >+
> >+	err = prestera_event_handlers_register(sw);
> >+	if (err)
> >+		goto err_evt_handlers;
> >+
> >+	err = prestera_create_ports(sw);
> >+	if (err)
> >+		goto err_ports_create;
> >+
> >+	return 0;
> >+
> >+err_ports_create:
> 
> You are missing prestera_event_handlers_unregister(sw); call here.
> 
it is handled below in prestera_switch_fini().

> 
> >+err_evt_handlers:
> >+	prestera_rxtx_switch_fini(sw);
> >+
> >+	return err;
> >+}
> >+
> >+static void prestera_switch_fini(struct prestera_switch *sw)
> >+{
> >+	prestera_destroy_ports(sw);
> >+	prestera_event_handlers_unregister(sw);
> >+	prestera_rxtx_switch_fini(sw);
> >+}
> >+
> >+int prestera_device_register(struct prestera_device *dev)
> >+{
> >+	struct prestera_switch *sw;
> >+	int err;
> >+
> >+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
> >+	if (!sw)
> >+		return -ENOMEM;
> >+
> >+	dev->priv = sw;
> >+	sw->dev = dev;
> >+
> >+	err = prestera_switch_init(sw);
> >+	if (err) {
> >+		kfree(sw);
> >+		return err;
> >+	}
> >+
> >+	registered_switch = sw;
> >+	return 0;
> >+}
> >+EXPORT_SYMBOL(prestera_device_register);
> >+
> >+void prestera_device_unregister(struct prestera_device *dev)
> >+{
> >+	struct prestera_switch *sw = dev->priv;
> >+
> >+	registered_switch = NULL;
> >+	prestera_switch_fini(sw);
> >+	kfree(sw);
> >+}
> >+EXPORT_SYMBOL(prestera_device_unregister);
> >+
> >+static int __init prestera_module_init(void)
> >+{
> >+	if (!base_mac) {
> >+		pr_err("[base_mac] parameter must be specified\n");
> >+		return -EINVAL;
> >+	}
> >+	if (!mac_pton(base_mac, base_mac_addr)) {
> >+		pr_err("[base_mac] parameter has invalid format\n");
> >+		return -EINVAL;
> >+	}
> >+
> >+	prestera_wq = alloc_workqueue("prestera", 0, 0);
> >+	if (!prestera_wq)
> >+		return -ENOMEM;
> >+
> >+	return 0;
> >+}
> >+
> >+static void __exit prestera_module_exit(void)
> >+{
> >+	destroy_workqueue(prestera_wq);
> >+}
> >+
> >+module_init(prestera_module_init);
> >+module_exit(prestera_module_exit);
> >+
> >+MODULE_AUTHOR("Marvell Semi.");
> >+MODULE_LICENSE("Dual BSD/GPL");
> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
> >+
> >+module_param(base_mac, charp, 0);
> 
> No please.
> 
> 
> [..]
> 
