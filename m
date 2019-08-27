Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A069F506
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfH0VW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:22:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39712 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfH0VW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:22:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so165206pgi.6
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 14:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jJJ/UKjrKrd1OLUjQN7kHS+bQcbmH7J/0L1Cv2U5Q+g=;
        b=aL6hLo8xqXm6o1bAArhyxkSfap0qTCAx+2iEyjgULugDzMHUXk0wEluTI4X/MF3noI
         9SvPnwsZGegWenVqq8pBPUw80zRMk37Y+STdYSOyPoWPgE+ipGlgaXXL7+cS7i3QlM9v
         qr+Rt8KvoLCMrJ6Up25/ngZ/9Sy8afU9dsq322xcIjGmNHD16Mhsj8cODXotAaGrmr74
         J86AydfGDdnLYp+rconEosdqTVYOFv8iL7x1iF4rgC2YIpKt5UmgfQ/kIrkMufwgiKeN
         ZuuqMS6n4qhY6PA0DDU9xTvAKNiMtXFyDQKOLzn4xYy5QKkI6z3XHlNMfaQDSqoCzrJC
         z4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jJJ/UKjrKrd1OLUjQN7kHS+bQcbmH7J/0L1Cv2U5Q+g=;
        b=DdUZS6idLMIB4VeZ+kaE0aHVzNud/7hCekMj9t7hRPg8TpDOvEU/4kqSuETlVrFihM
         oGced3Un+vs2WMZUIGb5b+lbjDbiPSB3EudDTP71bqB6C4lxyEd/w8M32KL3PAjRwS58
         rzJrLuWAbaamSXcDq7CYUd+9jl7XYhCLugg6UHNbv5us3WD1knnI+9+rdn9u5unlesxg
         N2ZK0rzbzftLo+t6PKQHNrR10IMzjEwNDKUNzXNXN7EyIv8P4txuhtgAyY67xDWVrE9e
         fCQbntMmKGCuT49IkDS/JI7OcTIi3bfw44X+j3+irSrYv7AE59oU1FOsb/8PJ/brQ6WG
         Kzag==
X-Gm-Message-State: APjAAAWcWmwinkO+0saJnmuZVbZihS7KJGA3TU+Lp/73NMZF4WqIwPgv
        V5VgDECwrCNCX4MrRAn20Bpayw==
X-Google-Smtp-Source: APXvYqwcaI0Gs6Y7IsBQfVG6gJIBhXNh1drGIpG0Gub3FP0mKOpLmga/cjxPi9Ib8Mw9JtlhGxD4+Q==
X-Received: by 2002:a17:90a:ac0a:: with SMTP id o10mr776933pjq.143.1566940977647;
        Tue, 27 Aug 2019 14:22:57 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id r3sm242175pfr.101.2019.08.27.14.22.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 14:22:57 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io>
 <20190826212404.77348857@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a2ed5049-14c6-749c-9a9b-f826d9a88cb0@pensando.io>
Date:   Tue, 27 Aug 2019 14:22:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826212404.77348857@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 9:24 PM, Jakub Kicinski wrote:
> On Mon, 26 Aug 2019 14:33:23 -0700, Shannon Nelson wrote:
>> The ionic device has a small set of PCI registers, including a
>> device control and data space, and a large set of message
>> commands.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
>> index f174e8f7bce1..a23d58519c63 100644
>> --- a/drivers/net/ethernet/pensando/ionic/Makefile
>> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
>> @@ -3,4 +3,5 @@
>>   
>>   obj-$(CONFIG_IONIC) := ionic.o
>>   
>> -ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o
>> +ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>> +	   ionic_debugfs.o
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index d40077161214..1f3c4a916849 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -4,6 +4,10 @@
>>   #ifndef _IONIC_H_
>>   #define _IONIC_H_
>>   
>> +#include "ionic_if.h"
>> +#include "ionic_dev.h"
>> +#include "ionic_devlink.h"
>> +
>>   #define IONIC_DRV_NAME		"ionic"
>>   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
>>   #define IONIC_DRV_VERSION	"0.15.0-k"
>> @@ -17,10 +21,27 @@
>>   #define IONIC_SUBDEV_ID_NAPLES_100_4	0x4001
>>   #define IONIC_SUBDEV_ID_NAPLES_100_8	0x4002
>>   
>> +#define devcmd_timeout  10
> nit: upper case?

Sure

>
>>   struct ionic {
>>   	struct pci_dev *pdev;
>>   	struct device *dev;
>>   	struct devlink *dl;
>> +	struct devlink_port dl_port;
> devlink_port is not used in this patch

I can move that to patch 09 where it gets used

>
>> +	struct ionic_dev idev;
>> +	struct mutex dev_cmd_lock;	/* lock for dev_cmd operations */
>> +	struct dentry *dentry;
>> +	struct ionic_dev_bar bars[IONIC_BARS_MAX];
>> +	unsigned int num_bars;
>> +	struct ionic_identity ident;
>>   };
>> +	err = ionic_init(ionic);
>> +	if (err) {
>> +		dev_err(dev, "Cannot init device: %d, aborting\n", err);
>> +		goto err_out_teardown;
>> +	}
>> +
>> +	err = ionic_devlink_register(ionic);
>> +	if (err)
>> +		dev_err(dev, "Cannot register devlink: %d\n", err);
>>   
>>   	return 0;
>> +
>> +err_out_teardown:
>> +	ionic_dev_teardown(ionic);
>> +err_out_unmap_bars:
>> +	ionic_unmap_bars(ionic);
>> +	pci_release_regions(pdev);
>> +err_out_pci_clear_master:
>> +	pci_clear_master(pdev);
>> +err_out_pci_disable_device:
>> +	pci_disable_device(pdev);
>> +err_out_debugfs_del_dev:
>> +	ionic_debugfs_del_dev(ionic);
>> +err_out_clear_drvdata:
>> +	mutex_destroy(&ionic->dev_cmd_lock);
>> +	ionic_devlink_free(ionic);
>> +
>> +	return err;
>>   }
>>   
>>   static void ionic_remove(struct pci_dev *pdev)
>>   {
>>   	struct ionic *ionic = pci_get_drvdata(pdev);
>>   
>> +	if (!ionic)
> How can this be NULL? Usually if this is NULL that means probe()
> failed but 'err' was not set properly. Perhaps WARN_ON() here?

Yes, pretty unlikely, but seems worth checking.

>
>> +		return;
>> +
>> +	ionic_devlink_unregister(ionic);
>> +	ionic_reset(ionic);
>> +	ionic_dev_teardown(ionic);
>> +	ionic_unmap_bars(ionic);
>> +	pci_release_regions(pdev);
>> +	pci_clear_master(pdev);
>> +	pci_disable_device(pdev);
>> +	ionic_debugfs_del_dev(ionic);
>> +	mutex_destroy(&ionic->dev_cmd_lock);
>>   	ionic_devlink_free(ionic);
>>   }
>>   
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> new file mode 100644
>> index 000000000000..30a5206bba4e
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -0,0 +1,143 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#ifndef _IONIC_DEV_H_
>> +#define _IONIC_DEV_H_
>> +
>> +#include <linux/mutex.h>
>> +#include <linux/workqueue.h>
>> +
>> +#include "ionic_if.h"
>> +#include "ionic_regs.h"
>> +
>> +struct ionic_dev_bar {
>> +	void __iomem *vaddr;
>> +	phys_addr_t bus_addr;
>> +	unsigned long len;
>> +	int res_index;
>> +};
>> +
>> +static inline void ionic_struct_size_checks(void)
>> +{
>> +	/* Registers */
>> +	BUILD_BUG_ON(sizeof(struct ionic_intr) != 32);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_doorbell) != 8);
>> +	BUILD_BUG_ON(sizeof(struct ionic_intr_status) != 8);
>> +
>> +	BUILD_BUG_ON(sizeof(union ionic_dev_regs) != 4096);
>> +	BUILD_BUG_ON(sizeof(union ionic_dev_info_regs) != 2048);
>> +	BUILD_BUG_ON(sizeof(union ionic_dev_cmd_regs) != 2048);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_stats) != 1024);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_admin_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_admin_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_nop_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_nop_comp) != 16);
>> +
>> +	/* Device commands */
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_identify_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_identify_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_init_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_init_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_reset_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_reset_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_getattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_getattr_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_setattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_dev_setattr_comp) != 16);
>> +
>> +	/* Port commands */
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_identify_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_identify_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_init_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_init_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_reset_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_reset_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_getattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_getattr_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_setattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_port_setattr_comp) != 16);
>> +
>> +	/* LIF commands */
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_init_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_init_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_reset_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(ionic_lif_reset_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_getattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_getattr_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_setattr_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_lif_setattr_comp) != 16);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_q_init_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_q_init_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_q_control_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(ionic_q_control_comp) != 16);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_rx_mode_set_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(ionic_rx_mode_set_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rx_filter_add_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rx_filter_add_comp) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rx_filter_del_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(ionic_rx_filter_del_comp) != 16);
>> +
>> +	/* RDMA commands */
>> +	BUILD_BUG_ON(sizeof(struct ionic_rdma_reset_cmd) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rdma_queue_cmd) != 64);
>> +
>> +	/* Events */
>> +	BUILD_BUG_ON(sizeof(struct ionic_notifyq_cmd) != 4);
>> +	BUILD_BUG_ON(sizeof(union ionic_notifyq_comp) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_notifyq_event) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_link_change_event) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_reset_event) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_heartbeat_event) != 64);
>> +	BUILD_BUG_ON(sizeof(struct ionic_log_event) != 64);
>> +
>> +	/* I/O */
>> +	BUILD_BUG_ON(sizeof(struct ionic_txq_desc) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_txq_sg_desc) != 128);
>> +	BUILD_BUG_ON(sizeof(struct ionic_txq_comp) != 16);
>> +
>> +	BUILD_BUG_ON(sizeof(struct ionic_rxq_desc) != 16);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rxq_sg_desc) != 128);
>> +	BUILD_BUG_ON(sizeof(struct ionic_rxq_comp) != 16);
> static_assert() for all of those? That way you don't need this fake
> function.

Sure

>
>> +}
>> +
>> +struct ionic_devinfo {
>> +	u8 asic_type;
>> +	u8 asic_rev;
>> +	char fw_version[IONIC_DEVINFO_FWVERS_BUFLEN + 1];
>> +	char serial_num[IONIC_DEVINFO_SERIAL_BUFLEN + 1];
>> +};
>> +
>> +struct ionic_dev {
>> +	union ionic_dev_info_regs __iomem *dev_info_regs;
>> +	union ionic_dev_cmd_regs __iomem *dev_cmd_regs;
>> +
>> +	u64 __iomem *db_pages;
>> +	dma_addr_t phy_db_pages;
>> +
>> +	struct ionic_intr __iomem *intr_ctrl;
>> +	u64 __iomem *intr_status;
>> +
>> +	struct ionic_devinfo dev_info;
>> +};
>> +
>> +struct ionic;
>> +
>> +void ionic_init_devinfo(struct ionic *ionic);
>> +int ionic_dev_setup(struct ionic *ionic);
>> +void ionic_dev_teardown(struct ionic *ionic);
>> +
>> +void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd);
>> +u8 ionic_dev_cmd_status(struct ionic_dev *idev);
>> +bool ionic_dev_cmd_done(struct ionic_dev *idev);
>> +void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp);
>> +
>> +void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
>> +void ionic_dev_cmd_init(struct ionic_dev *idev);
>> +void ionic_dev_cmd_reset(struct ionic_dev *idev);
>> +
>> +#endif /* _IONIC_DEV_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> index e24ef6971cd5..1ca1e33cca04 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
>> @@ -11,8 +11,28 @@
>>   static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>>   			     struct netlink_ext_ack *extack)
>>   {
>> +	struct ionic *ionic = devlink_priv(dl);
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	char buf[16];
>> +
>>   	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
>>   
>> +	devlink_info_version_running_put(req,
>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
>> +					 idev->dev_info.fw_version);
> Are you sure this is not the FW that controls the data path?

There is only one FW rev to report, and this covers mgmt and data.

>
>> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
>> +	devlink_info_version_fixed_put(req,
>> +				       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
>> +				       buf);
> Board ID is not ASIC. This is for identifying a board version with all
> its components which surround the main ASIC.
>
>> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
>> +	devlink_info_version_fixed_put(req,
>> +				       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
>> +				       buf);
> ditto

Since I don't have any board info available at this point, shall I use 
my own "asic.id" and "asic.rev" strings, or in this patch shall I add 
something like this to devlink.h and use them here:

/* Part number, identifier of asic design */
#define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID    "asic.id"
/* Revision of asic design */
#define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV    "asic.rev"


>> +	devlink_info_serial_number_put(req, idev->dev_info.serial_num);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -41,3 +61,22 @@ void ionic_devlink_free(struct ionic *ionic)
>>   {
>>   	devlink_free(ionic->dl);
>>   }
>> +
>> +int ionic_devlink_register(struct ionic *ionic)
>> +{
>> +	int err;
>> +
>> +	err = devlink_register(ionic->dl, ionic->dev);
>> +	if (err)
>> +		dev_warn(ionic->dev, "devlink_register failed: %d\n", err);
>> +
>> +	return err;
>> +}
>> +
>> +void ionic_devlink_unregister(struct ionic *ionic)
>> +{
>> +	if (!ionic || !ionic->dl)
>> +		return;
> Impossiblu

Sure.


Thanks,
sln

