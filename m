Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546AB1CF847
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgELPDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgELPDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:03:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E919C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:03:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so23770658wma.4
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BrkV75yQEgZywxMlfrK+TQDKltWP5eI+ca2mgcmB20w=;
        b=Lj8WwxFYtyUMIrz7yKJ8hI5YbOTLRFsKk5epHTAQTbNyKfYYoyRrptoBNRXWQun8ZM
         pxGQZiu2LcNWqeIlL9yZpfNWaKgyhjC3vNc7wv2o8vOYKZJV5YtACIR8qLbEbd1THXU/
         7vo+Ek0eBG5McapOWRqSvf84z5jo8OIbWwZE4J+2C9FD9qJ7wFdPwzV7QXhdlqgpqd2+
         qG+jdgKpJPrHoHBwKZi1Aalc1h+v4jVgpqUWH/7B4bR9GMGQlqM4fjk3HAHNPRCEoOD1
         5DrHQYXIWIW7LQsKll1BQH3lD0wUmuf5CmmVhGQyCJnOmbV6Ih+odNgSu2pyetbELbVN
         9Vlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BrkV75yQEgZywxMlfrK+TQDKltWP5eI+ca2mgcmB20w=;
        b=iXOMlI/timSM5zet7thWHTJZwPwZRcXIuYE9nl/yiG175+gPG1yDpSdNVdYgO4nBIl
         3Kuru4UelONKUv6Oxk72+d96aRGz+GweLo8lZtr9GGqbgqp/5pYNSHgNuJaWLYV/UUGD
         R6hmVXAZGAYcgz8LMfSi+DXxV20mlKivX2W9htB9fyie8Ty8j2JOphrxQavW1OZf9dvb
         /RdZ9Ad7D0IrQY9Wy/lAMQNyPqHA2t9lIicqiVpcKWqFOvWIIUcXFiPX8j1+A/+lE9EX
         YJCNPA5FEcqRfU/f73UiOmfeWmbW7PVtC4728qQcQb8ca6ooigZxYyoL1k2HrnL5ynRS
         4tWQ==
X-Gm-Message-State: AGi0PubDC7PNEAbH1iJ5cfljVhfQdS6fclYuZoLN7USkwzkGm7DC1Sct
        SHDk9gQ7TAQ39F6kYQ2WxUvJx0e9i5E=
X-Google-Smtp-Source: APiQypKkDCfUi7Osmvh0HpEwwnsfpCmAe610F8DfD86rAbHTaTjg4d2cwQwhRNL3tJVACzkotWzJtw==
X-Received: by 2002:a05:600c:293:: with SMTP id 19mr18238404wmk.71.1589295787361;
        Tue, 12 May 2020 08:03:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m82sm21018777wmf.3.2020.05.12.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 08:03:06 -0700 (PDT)
Date:   Tue, 12 May 2020 17:03:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
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
Message-ID: <20200512150306.GP2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200512145352.GC31516@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512145352.GC31516@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 12, 2020 at 04:53:52PM CEST, vadym.kochan@plvision.eu wrote:
>On Mon, May 11, 2020 at 12:32:22PM +0200, Jiri Pirko wrote:
>
>[...]
>
>> 
>> This is RCU list. Treat it accordingly.
>> 
>> 
>> >+	spin_unlock(&sw->ports_lock);
>> 
>> I don't follow, why do you need to protect the list by spinlock here?
>> More to that, why do you need the port_list reader-writer
>> protected (by rcu)? Is is possible that you add/remove port in the same
>> time packets are flying in?
>> 
>> If yes, you need to ensure the structs are in the memory (free_rcu,
>> synchronize_rcu). But I believe that you should disable that from
>> happening in HW.
>> 
>> 
>> >+
>
>[...]
>
>> >+
>> >+static int prestera_switch_init(struct prestera_switch *sw)
>> >+{
>> >+	int err;
>> >+
>> >+	err = prestera_hw_switch_init(sw);
>> >+	if (err) {
>> >+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
>> >+		return err;
>> >+	}
>> >+
>> >+	memcpy(sw->base_mac, base_mac_addr, sizeof(sw->base_mac));
>> >+	spin_lock_init(&sw->ports_lock);
>> >+	INIT_LIST_HEAD(&sw->port_list);
>> >+
>> >+	err = prestera_hw_switch_mac_set(sw, sw->base_mac);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	err = prestera_rxtx_switch_init(sw);
>> >+	if (err)
>> >+		return err;
>> >+
>> >+	err = prestera_event_handlers_register(sw);
>> >+	if (err)
>> >+		goto err_evt_handlers;
>> >+
>> >+	err = prestera_create_ports(sw);
>> >+	if (err)
>> >+		goto err_ports_create;
>> >+
>> >+	return 0;
>> >+
>> >+err_ports_create:
>> 
>> You are missing prestera_event_handlers_unregister(sw); call here.
>> 
>it is handled below in prestera_switch_fini().

Sure, but you should call it here in the error path as well. That is my
point.

>
>> 
>> >+err_evt_handlers:
>> >+	prestera_rxtx_switch_fini(sw);
>> >+
>> >+	return err;
>> >+}
>> >+
>> >+static void prestera_switch_fini(struct prestera_switch *sw)
>> >+{
>> >+	prestera_destroy_ports(sw);
>> >+	prestera_event_handlers_unregister(sw);
>> >+	prestera_rxtx_switch_fini(sw);
>> >+}
>> >+
>> >+int prestera_device_register(struct prestera_device *dev)
>> >+{
>> >+	struct prestera_switch *sw;
>> >+	int err;
>> >+
>> >+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
>> >+	if (!sw)
>> >+		return -ENOMEM;
>> >+
>> >+	dev->priv = sw;
>> >+	sw->dev = dev;
>> >+
>> >+	err = prestera_switch_init(sw);
>> >+	if (err) {
>> >+		kfree(sw);
>> >+		return err;
>> >+	}
>> >+
>> >+	registered_switch = sw;
>> >+	return 0;
>> >+}
>> >+EXPORT_SYMBOL(prestera_device_register);
>> >+
>> >+void prestera_device_unregister(struct prestera_device *dev)
>> >+{
>> >+	struct prestera_switch *sw = dev->priv;
>> >+
>> >+	registered_switch = NULL;
>> >+	prestera_switch_fini(sw);
>> >+	kfree(sw);
>> >+}
>> >+EXPORT_SYMBOL(prestera_device_unregister);
>> >+
>> >+static int __init prestera_module_init(void)
>> >+{
>> >+	if (!base_mac) {
>> >+		pr_err("[base_mac] parameter must be specified\n");
>> >+		return -EINVAL;
>> >+	}
>> >+	if (!mac_pton(base_mac, base_mac_addr)) {
>> >+		pr_err("[base_mac] parameter has invalid format\n");
>> >+		return -EINVAL;
>> >+	}
>> >+
>> >+	prestera_wq = alloc_workqueue("prestera", 0, 0);
>> >+	if (!prestera_wq)
>> >+		return -ENOMEM;
>> >+
>> >+	return 0;
>> >+}
>> >+
>> >+static void __exit prestera_module_exit(void)
>> >+{
>> >+	destroy_workqueue(prestera_wq);
>> >+}
>> >+
>> >+module_init(prestera_module_init);
>> >+module_exit(prestera_module_exit);
>> >+
>> >+MODULE_AUTHOR("Marvell Semi.");
>> >+MODULE_LICENSE("Dual BSD/GPL");
>> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
>> >+
>> >+module_param(base_mac, charp, 0);
>> 
>> No please.
>> 
>> 
>> [..]
>> 
