Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A012E1CF8F9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgELPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgELPVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:21:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F6CC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:21:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m24so12620713wml.2
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90DD10RY4joWElriLCMqaOsEIQrfnTdEsQyb4QCeLb4=;
        b=Dl4jSBuOwdC7uD0PbaT1fucy/m/4hIuZDTIgUV97ZyNT0od0b/0XHY1JNRJ+fvF5Rw
         +Q1HLqm6jpX84Bis77Yqc+BN4X1e1qT3hooq5HbqZGN7PflQK2N+ixdoi0I1AWDu6ZEm
         K5gR714DW5VDkBmBUIXQ7B3uMnhGC+XO2kF5nktKZF1KrAsBFacmCnq3DpdGOBzFVRlW
         O/cvuJJIBfP5q51TJplmKEUAWygHBROtYWFqnjPAv4l8x0XkcygQdKVEWYwpQGO4Y4s7
         HKfjRenZy4EQLAwte8rpBUgg9JANHAUVwht/ODVOlb0jWIIurIYZ4FTQ/HRvdmAznXrf
         BqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=90DD10RY4joWElriLCMqaOsEIQrfnTdEsQyb4QCeLb4=;
        b=WQCMGZsIgsN0fI6JfxEwfBJSGBmdlpCiVolDniPO+tcbZO5SWP0d/t+lrMNH6VVm/W
         MRwVCjKlJFQ7OZlRCCBW5aWeaN17EqTegVBcQ1vw++OS2+gGYo7QpNMXB/VbDYkwsMvs
         BC6XaTayzYTBMITVc4dhxDUnjXkS+M0u89qcobtLCPamSFyBcfyCqqmuyBRJbXhnzalc
         azU3veNFgJqlKXQE7YyMns2xEG87zqdj0mL67LTxbewqsQGc11fiytBcNog3Ies4Q8RE
         bHJtu1LWCKOcp6/tfQnHDx5MWBVSduCXIc8qrWlIJss1gZLPmwK7MJBQpUAU6DT0utET
         6kCQ==
X-Gm-Message-State: AGi0PuZNR9cG9KG/qzMGI/LuaJtafTzq3OeIcwIlQpGbzaohMSpEuSRP
        QG6XE8WX9bHOVV9b/5wXE9zo4n7Jstk=
X-Google-Smtp-Source: APiQypLWgg2L1k6DgJzoR5GwhBZ/1TPP2+LrSE+fjUxST4cL2k6L2Jqjjbiua+9o4JsQB0n3y1oH1Q==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr22556904wmc.10.1589296898298;
        Tue, 12 May 2020 08:21:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l13sm6925635wrm.55.2020.05.12.08.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 08:21:37 -0700 (PDT)
Date:   Tue, 12 May 2020 17:21:36 +0200
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
Message-ID: <20200512152136.GQ2245@nanopsycho>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200512145352.GC31516@plvision.eu>
 <20200512150306.GP2245@nanopsycho>
 <20200512150714.GE31516@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512150714.GE31516@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 12, 2020 at 05:07:14PM CEST, vadym.kochan@plvision.eu wrote:
>On Tue, May 12, 2020 at 05:03:06PM +0200, Jiri Pirko wrote:
>> Tue, May 12, 2020 at 04:53:52PM CEST, vadym.kochan@plvision.eu wrote:
>> >On Mon, May 11, 2020 at 12:32:22PM +0200, Jiri Pirko wrote:
>> >
>> >[...]
>> >
>> >> 
>> >> This is RCU list. Treat it accordingly.
>> >> 
>> >> 
>> >> >+	spin_unlock(&sw->ports_lock);
>> >> 
>> >> I don't follow, why do you need to protect the list by spinlock here?
>> >> More to that, why do you need the port_list reader-writer
>> >> protected (by rcu)? Is is possible that you add/remove port in the same
>> >> time packets are flying in?
>> >> 
>> >> If yes, you need to ensure the structs are in the memory (free_rcu,
>> >> synchronize_rcu). But I believe that you should disable that from
>> >> happening in HW.
>> >> 
>> >> 
>> >> >+
>> >
>> >[...]
>> >
>> >> >+
>> >> >+static int prestera_switch_init(struct prestera_switch *sw)
>> >> >+{
>> >> >+	int err;
>> >> >+
>> >> >+	err = prestera_hw_switch_init(sw);
>> >> >+	if (err) {
>> >> >+		dev_err(prestera_dev(sw), "Failed to init Switch device\n");
>> >> >+		return err;
>> >> >+	}
>> >> >+
>> >> >+	memcpy(sw->base_mac, base_mac_addr, sizeof(sw->base_mac));
>> >> >+	spin_lock_init(&sw->ports_lock);
>> >> >+	INIT_LIST_HEAD(&sw->port_list);
>> >> >+
>> >> >+	err = prestera_hw_switch_mac_set(sw, sw->base_mac);
>> >> >+	if (err)
>> >> >+		return err;
>> >> >+
>> >> >+	err = prestera_rxtx_switch_init(sw);
>> >> >+	if (err)
>> >> >+		return err;
>> >> >+
>> >> >+	err = prestera_event_handlers_register(sw);
>> >> >+	if (err)
>> >> >+		goto err_evt_handlers;
>> >> >+
>> >> >+	err = prestera_create_ports(sw);
>> >> >+	if (err)
>> >> >+		goto err_ports_create;
>> >> >+
>> >> >+	return 0;
>> >> >+
>> >> >+err_ports_create:
>> >> 
>> >> You are missing prestera_event_handlers_unregister(sw); call here.
>> >> 
>> >it is handled below in prestera_switch_fini().
>> 
>> Sure, but you should call it here in the error path as well. That is my
>> point.
>> 
>I understand your point - to make error path more clear, and symmetric ?

Yes.

>
>> >
>> >> 
>> >> >+err_evt_handlers:
>> >> >+	prestera_rxtx_switch_fini(sw);
>> >> >+
>> >> >+	return err;
>> >> >+}
>> >> >+
>> >> >+static void prestera_switch_fini(struct prestera_switch *sw)
>> >> >+{
>> >> >+	prestera_destroy_ports(sw);
>> >> >+	prestera_event_handlers_unregister(sw);
>> >> >+	prestera_rxtx_switch_fini(sw);
>> >> >+}
>> >> >+
>> >> >+int prestera_device_register(struct prestera_device *dev)
>> >> >+{
>> >> >+	struct prestera_switch *sw;
>> >> >+	int err;
>> >> >+
>> >> >+	sw = kzalloc(sizeof(*sw), GFP_KERNEL);
>> >> >+	if (!sw)
>> >> >+		return -ENOMEM;
>> >> >+
>> >> >+	dev->priv = sw;
>> >> >+	sw->dev = dev;
>> >> >+
>> >> >+	err = prestera_switch_init(sw);
>> >> >+	if (err) {
>> >> >+		kfree(sw);
>> >> >+		return err;
>> >> >+	}
>> >> >+
>> >> >+	registered_switch = sw;
>> >> >+	return 0;
>> >> >+}
>> >> >+EXPORT_SYMBOL(prestera_device_register);
>> >> >+
>> >> >+void prestera_device_unregister(struct prestera_device *dev)
>> >> >+{
>> >> >+	struct prestera_switch *sw = dev->priv;
>> >> >+
>> >> >+	registered_switch = NULL;
>> >> >+	prestera_switch_fini(sw);
>> >> >+	kfree(sw);
>> >> >+}
>> >> >+EXPORT_SYMBOL(prestera_device_unregister);
>> >> >+
>> >> >+static int __init prestera_module_init(void)
>> >> >+{
>> >> >+	if (!base_mac) {
>> >> >+		pr_err("[base_mac] parameter must be specified\n");
>> >> >+		return -EINVAL;
>> >> >+	}
>> >> >+	if (!mac_pton(base_mac, base_mac_addr)) {
>> >> >+		pr_err("[base_mac] parameter has invalid format\n");
>> >> >+		return -EINVAL;
>> >> >+	}
>> >> >+
>> >> >+	prestera_wq = alloc_workqueue("prestera", 0, 0);
>> >> >+	if (!prestera_wq)
>> >> >+		return -ENOMEM;
>> >> >+
>> >> >+	return 0;
>> >> >+}
>> >> >+
>> >> >+static void __exit prestera_module_exit(void)
>> >> >+{
>> >> >+	destroy_workqueue(prestera_wq);
>> >> >+}
>> >> >+
>> >> >+module_init(prestera_module_init);
>> >> >+module_exit(prestera_module_exit);
>> >> >+
>> >> >+MODULE_AUTHOR("Marvell Semi.");
>> >> >+MODULE_LICENSE("Dual BSD/GPL");
>> >> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
>> >> >+
>> >> >+module_param(base_mac, charp, 0);
>> >> 
>> >> No please.
>> >> 
>> >> 
>> >> [..]
>> >> 
