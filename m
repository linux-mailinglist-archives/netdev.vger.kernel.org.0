Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40071287F67
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgJIAMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgJIAMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 20:12:53 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02793C0613D2;
        Thu,  8 Oct 2020 17:12:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k8so5357164pfk.2;
        Thu, 08 Oct 2020 17:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tDCoNYwagkzJSr2QDS3ZkDLTKptDhAuMhwpgxkIv1zQ=;
        b=M3a4uGNM6VSWuB00vxUKAsP9geJcLDYmn+gH+hVpKdFgbR15R3knFzX+t9sQhc0IEL
         NNv1TSx8eG0DuAzcnPllxd9EDoDwRavAkl0LKLFKgPvlSINGmjp6VRI9f7KVuzXm+C8t
         9yqeqUB/fALfA++aU240d+pnqCw7P6WIc7OSTN/VLSPJjdRSFfXFnf4AiQQJmxqAxl9k
         uTwPBec9xBseWaJ14RIEP/kTnsbj+BpON+mNZWftJLzFrg2yaeP3chuBQlnHVU5Tbfyl
         Ux4AZbfFGsHaWl0WeWz0/qItcPJQeyvd+tYsa91Qj5QikOvBafE7APOR8zPWU1wWRFpl
         83IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tDCoNYwagkzJSr2QDS3ZkDLTKptDhAuMhwpgxkIv1zQ=;
        b=gmsqNewjwCYOk2M+BoahdPO4P1hcR8rJ1qOq7nIDnpsMLe9SujgBvTx+bSfNgRlaYP
         tub+7xfun49dxL2SpI5TmHAFYQF67TQeVFLv9k5mzbKaGchAEwfHCKcRbKBdI00jDYph
         w1NWXeHWAJ5Xc3doMSZuOdCO8wofwa7rO1t/MitPyZ7pOlS8L1EIA1P3PmKqeuMds7x3
         XMvZEnfNk9SlhZ9FT+umAc55FvCWkYK3ICJPkZ5aWUQWXahlgxdHy9WkKNNBYRe3FozD
         1YgrEwIJXxMXJGjvW2zAkcK8Z8q5SvK5wGRSa139EJ3SfqCfTsCrKRtuyrnf+rQ1BGsU
         FiSg==
X-Gm-Message-State: AOAM530mfQUwQu06MAQ13xJGt4gIY7f9mUKBM8xcyqPKpSWrO43wIF25
        QNgf8+0gc/lueYngTuc17BQ=
X-Google-Smtp-Source: ABdhPJzZqiLRnLN4JBeJPUbDQtcgNNU7byvp64iKGhnvi8gO2Z3NvDKc+MYLYLmjM64ga5vtW7YuMg==
X-Received: by 2002:a63:ff5d:: with SMTP id s29mr1240282pgk.442.1602202372414;
        Thu, 08 Oct 2020 17:12:52 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a9sm8945275pjm.40.2020.10.08.17.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 17:12:52 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 9 Oct 2020 08:12:45 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201009001245.dhtyvhbkdpmaadng@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201008133142.GB1042@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201008133142.GB1042@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 04:31:42PM +0300, Dan Carpenter wrote:
>On Thu, Oct 08, 2020 at 07:58:03PM +0800, Coiby Xu wrote:
>> Initialize devlink health dump framework for the dlge driver so the
>> coredump could be done via devlink.
>>
>> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
>> ---
>>  drivers/staging/qlge/Kconfig        |  1 +
>>  drivers/staging/qlge/Makefile       |  2 +-
>>  drivers/staging/qlge/qlge.h         |  9 +++++++
>>  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
>>  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
>>  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
>>  6 files changed, 85 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/staging/qlge/qlge_devlink.c
>>  create mode 100644 drivers/staging/qlge/qlge_devlink.h
>>
>> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
>> index a3cb25a3ab80..6d831ed67965 100644
>> --- a/drivers/staging/qlge/Kconfig
>> +++ b/drivers/staging/qlge/Kconfig
>> @@ -3,6 +3,7 @@
>>  config QLGE
>>  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
>>  	depends on ETHERNET && PCI
>> +	select NET_DEVLINK
>>  	help
>>  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>>
>> diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
>> index 1dc2568e820c..07c1898a512e 100644
>> --- a/drivers/staging/qlge/Makefile
>> +++ b/drivers/staging/qlge/Makefile
>> @@ -5,4 +5,4 @@
>>
>>  obj-$(CONFIG_QLGE) += qlge.o
>>
>> -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
>> +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
>> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
>> index b295990e361b..290e754450c5 100644
>> --- a/drivers/staging/qlge/qlge.h
>> +++ b/drivers/staging/qlge/qlge.h
>> @@ -2060,6 +2060,14 @@ struct nic_operations {
>>  	int (*port_initialize)(struct ql_adapter *qdev);
>>  };
>>
>> +
>> +
>
>Having multiple blank lines in a row leads to a static checker warning.
>Please run `checkpatch.pl --strict` over your patches.
>
>> +struct qlge_devlink {
>> +        struct ql_adapter *qdev;
>> +        struct net_device *ndev;
>> +        struct devlink_health_reporter *reporter;
>> +};
>> +
>>  /*
>>   * The main Adapter structure definition.
>>   * This structure has all fields relevant to the hardware.
>> @@ -2077,6 +2085,7 @@ struct ql_adapter {
>>  	struct pci_dev *pdev;
>>  	struct net_device *ndev;	/* Parent NET device */
>>
>> +	struct qlge_devlink *ql_devlink;
>>  	/* Hardware information */
>>  	u32 chip_rev_id;
>>  	u32 fw_rev_id;
>> diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
>> new file mode 100644
>> index 000000000000..aa45e7e368c0
>> --- /dev/null
>> +++ b/drivers/staging/qlge/qlge_devlink.c
>> @@ -0,0 +1,38 @@
>> +#include "qlge.h"
>> +#include "qlge_devlink.h"
>> +
>> +static int
>> +qlge_reporter_coredump(struct devlink_health_reporter *reporter,
>> +			struct devlink_fmsg *fmsg, void *priv_ctx,
>> +			struct netlink_ext_ack *extack)
>> +{
>> +	return 0;
>> +}
>> +
>> +static const struct devlink_health_reporter_ops qlge_reporter_ops = {
>> +		.name = "dummy",
>> +		.dump = qlge_reporter_coredump,
>
>Indented too far.
>
>> +};
>> +
>> +int qlge_health_create_reporters(struct qlge_devlink *priv)
>> +{
>> +	int err;
>> +
>
>No blanks in the middle of declarations.
>
>> +	struct devlink_health_reporter *reporter;
>> +	struct devlink *devlink;
>
>Generally this driver declares variables in "Reverse Christmas Tree"
>order.  The names are orderred by the length of the line from longest
>to shortest.
>
>	type long_name;
>	type medium;
>	type short;
>
>> +
>> +	devlink = priv_to_devlink(priv);
>> +	reporter =
>> +		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
>> +					       0,
>> +					       priv);
>
>Break this up like so:
>
>	reporter = devlink_health_reporter_create(devlink, &qlge_reporter_ops,
>						  0, priv);
>
>
>> +	if (IS_ERR(reporter)) {
>> +		netdev_warn(priv->ndev,
>> +			    "Failed to create reporter, err = %ld\n",
>> +			    PTR_ERR(reporter));
>> +		return PTR_ERR(reporter);
>
>No point in returning an error if the caller doesn't check?
>
>> +	}
>> +	priv->reporter = reporter;
>> +
>> +	return err;
>
>err is uninitialized.  "return 0;"
>
>> +}
>> diff --git a/drivers/staging/qlge/qlge_devlink.h b/drivers/staging/qlge/qlge_devlink.h
>> new file mode 100644
>> index 000000000000..c91f7a29e805
>> --- /dev/null
>> +++ b/drivers/staging/qlge/qlge_devlink.h
>> @@ -0,0 +1,8 @@
>> +#ifndef QLGE_DEVLINK_H
>> +#define QLGE_DEVLINK_H
>> +
>> +#include <net/devlink.h>
>> +
>> +int qlge_health_create_reporters(struct qlge_devlink *priv);
>> +
>> +#endif /* QLGE_DEVLINK_H */
>> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
>> index 27da386f9d87..135225530e51 100644
>> --- a/drivers/staging/qlge/qlge_main.c
>> +++ b/drivers/staging/qlge/qlge_main.c
>> @@ -42,6 +42,7 @@
>>  #include <net/ip6_checksum.h>
>>
>>  #include "qlge.h"
>> +#include "qlge_devlink.h"
>>
>>  char qlge_driver_name[] = DRV_NAME;
>>  const char qlge_driver_version[] = DRV_VERSION;
>> @@ -4549,6 +4550,8 @@ static void ql_timer(struct timer_list *t)
>>  	mod_timer(&qdev->timer, jiffies + (5 * HZ));
>>  }
>>
>> +static const struct devlink_ops qlge_devlink_ops;
>> +
>>  static int qlge_probe(struct pci_dev *pdev,
>>  		      const struct pci_device_id *pci_entry)
>>  {
>> @@ -4556,6 +4559,13 @@ static int qlge_probe(struct pci_dev *pdev,
>>  	struct ql_adapter *qdev = NULL;
>>  	static int cards_found;
>>  	int err = 0;
>> +	struct devlink *devlink;
>> +	struct qlge_devlink *ql_devlink;
>> +
>> +	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
>> +	if (!devlink)
>> +		return -ENOMEM;
>> +	ql_devlink = devlink_priv(devlink);
>>
>>  	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>>  				 min(MAX_CPUS,
>> @@ -4614,6 +4624,16 @@ static int qlge_probe(struct pci_dev *pdev,
>>  		free_netdev(ndev);
>>  		return err;
>>  	}
>> +
>> +	err = devlink_register(devlink, &pdev->dev);
>> +	if (err) {
>> +		goto devlink_free;
>> +	}
>
>Checkpatch warning.
>

Thank you for the reminding!

>regards,
>dan carpenter
>

--
Best regards,
Coiby
