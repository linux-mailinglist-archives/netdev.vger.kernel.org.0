Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372CC4F0AB
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFUWNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:13:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33809 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfFUWNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:13:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so4277436pfc.1
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4wGy/EHTtgR+nb6HgklMzpGmIfgU3V/xGQjb3MbOQ2U=;
        b=EJPtGQiJHQPEUhCdzbPiH7MTsYxP1RD/0RzpgOjTE2v0GMEWRsp9KM7M3C/h5rQzkQ
         tsmbWiI4EQt6Q26JsWZV3k99VvP6KAVxvJnU12MikgX60Ov+KniDyt61MxyofoH6KLZW
         OVbwXCxmCbbM7gvKhlpLXGF2d5nP7UtXHZA8hOARYMzmtX2hG6x1dq1MHn2sXYS8KTAd
         ox+xY5TWUMEurVj7aKGOvecRzL9Ad5mMsRa2Zb0+43ZrKJQ14aJ769YvN0EL6VvS9xiT
         kj51K7QGHMilyHFdO+FQV4wzvLiNlIaUUnwSteG+3osbH3IkvYUFRx/EdjXhA5yN5KJW
         QvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4wGy/EHTtgR+nb6HgklMzpGmIfgU3V/xGQjb3MbOQ2U=;
        b=atk5vh1GuoMq+5IcN4tLHVZ6Tbvzj/ytoxZLyNg5jHwO9CZ9G6DE79dZM0Jughspxi
         cIPq9NYFyuG/ntJ5k2mX4ILIVJnkoG3bZ9PtaD0sfPGtHiimoyx9+iWPxGXAqs/izBjI
         1JBccx4OB5q2ebfa58hwmwmn2dJ+oOXhdpwF8q4WWHnQlNGQoX2Sj2VNvzEaFHu6dqmm
         CykdA9KHXWV1DBpaP8D68e/OEsIqZauiWHpIjd38ZBbMY1HVDPqOT8ToVqiruq9lBBkK
         +2rbQZYc/3a1vh3DQ/Jb0U6ihdKGp/OPMpnghifvoHmPvV1/BUlsj8ecW6Vj3MgB1llx
         4wxA==
X-Gm-Message-State: APjAAAXNjQLVmEnR4Gvwn3Rb0X/rGU/b48kkIJQ0+8ktLC3aYMO87Ner
        qKKfs4NNf9uPkxNkb9BFkeOQgYvLXYA=
X-Google-Smtp-Source: APXvYqxGseV+ahhksRjXHHshlvXOqI3cr2k0QmjAhajRQvuOVfXk1DAh4GxXvIhaLcfOPFL2Hzh6OA==
X-Received: by 2002:a17:90a:b011:: with SMTP id x17mr9512062pjq.113.1561155213823;
        Fri, 21 Jun 2019 15:13:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id f10sm3820369pfd.151.2019.06.21.15.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:13:33 -0700 (PDT)
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-2-snelson@pensando.io> <20190620212447.GJ31306@lunn.ch>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7f1fcda2-dce4-feb6-ec3a-c54bfb691e5d@pensando.io>
Date:   Fri, 21 Jun 2019 15:13:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620212447.GJ31306@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 2:24 PM, Andrew Lunn wrote:

Hi Andrew, thanks for your time and comments.  Responses below...

>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -0,0 +1,27 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#ifndef _IONIC_H_
>> +#define _IONIC_H_
>> +
>> +#define DRV_NAME		"ionic"
>> +#define DRV_DESCRIPTION		"Pensando Ethernet NIC Driver"
>> +#define DRV_VERSION		"0.11.0-k"
> DRV_VERSION is pretty useless. What you really want to know is the
> kernel git tree and commit. The big distributions might backport this
> version of the driver back to the old kernel with a million
> patches. At which point 0.11.0-k tells you nothing much.
Yes, any version numbering thing from the big distros is put into 
question, but I find this number useful to me for tracking what has been 
put into the upstream kernel.  This plus the full kernel version gives 
me a pretty good idea of what I'm looking at.

>> +
>> +// TODO: register these with the official include/linux/pci_ids.h
>> +#define PCI_VENDOR_ID_PENSANDO			0x1dd8
> That file has a comment:
>
>   *      Do not add new entries to this file unless the definitions
>   *      are shared between multiple drivers.
>
> Is it going to be shared?

Yes, there is an instance of sharing planned.

>
>   +
>> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
>> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
>> +#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT	0x1004
>> +
>> +#define IONIC_SUBDEV_ID_NAPLES_25	0x4000
>> +#define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
>> +#define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
>> +
>> +struct ionic {
>> +	struct pci_dev *pdev;
>> +	struct device *dev;
>> +};
>> +
>> +#endif /* _IONIC_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
>> new file mode 100644
>> index 000000000000..94ba0afc6f38
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
>> @@ -0,0 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#ifndef _IONIC_BUS_H_
>> +#define _IONIC_BUS_H_
>> +
>> +int ionic_bus_register_driver(void);
>> +void ionic_bus_unregister_driver(void);
>> +
>> +#endif /* _IONIC_BUS_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> new file mode 100644
>> index 000000000000..ab6206c162d4
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -0,0 +1,61 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#include <linux/module.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/etherdevice.h>
>> +#include <linux/pci.h>
>> +
>> +#include "ionic.h"
>> +#include "ionic_bus.h"
>> +
>> +/* Supported devices */
>> +static const struct pci_device_id ionic_id_table[] = {
>> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF) },
>> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF) },
>> +	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT) },
>> +	{ 0, }	/* end of table */
>> +};
>> +MODULE_DEVICE_TABLE(pci, ionic_id_table);
>> +
>> +static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct ionic *ionic;
>> +
>> +	ionic = devm_kzalloc(dev, sizeof(*ionic), GFP_KERNEL);
>> +	if (!ionic)
>> +		return -ENOMEM;
>> +
>> +	ionic->pdev = pdev;
>> +	pci_set_drvdata(pdev, ionic);
>> +	ionic->dev = dev;
>> +	dev_info(ionic->dev, "attached\n");
> probed would be more accurate. But in general, please avoid all but
> the minimum of such info messages.
Sure
>
>> +
>> +	return 0;
>> +}
>> +
>> +static void ionic_remove(struct pci_dev *pdev)
>> +{
>> +	struct ionic *ionic = pci_get_drvdata(pdev);
>> +
>> +	pci_set_drvdata(pdev, NULL);
>> +	dev_info(ionic->dev, "removed\n");
> Not very useful dev_info().
It has been useful in testing, but it can go away.
>
> Also, i think the core will NULL out the drive data for you. But you
> should check.
I'll check.
>> +}
>> +
>> +static struct pci_driver ionic_driver = {
>> +	.name = DRV_NAME,
>> +	.id_table = ionic_id_table,
>> +	.probe = ionic_probe,
>> +	.remove = ionic_remove,
>> +};
>> +
>> +int ionic_bus_register_driver(void)
>> +{
>> +	return pci_register_driver(&ionic_driver);
>> +}
>> +
>> +void ionic_bus_unregister_driver(void)
>> +{
>> +	pci_unregister_driver(&ionic_driver);
>> +}
> It looks like you can use module_pci_driver() and remove a lot of
> boilerplate.
Thanks, I'll look at that.

Cheers,
sln
>
> 	Andrew

