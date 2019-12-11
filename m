Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C82611A01A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 01:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfLKAjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 19:39:45 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33069 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLKAjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 19:39:45 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so9855885pgk.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 16:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=SMl0afGetTBKoq+adKW6Y9mp7iK570TiW8HXDr9MEaU=;
        b=3kD1bvp6FJj0RMb+GJ9SUbZvgWcvQ9MaxIOUo8szOxxPcU1dcShoRneRCXhowm2IVm
         EcrCZUuUq0Vy/7Ayk9Z+DZ/dC4OFIrqBFVNemp7VAmp4P9QlIwV9SMq3lZpmu9Z08YE1
         FU/nrMcJC99kP+cHpULa7/OFrWLD8AiaY5paCnqvzBs2x71tr/fCmHnhg5fdMPgI+pjv
         MXMelFKJ5AmOdl2VHvIt5Put6O+6DDPWSa92jHQqSv/kBi2x1dDGqeC+QBCxtZoKAfVB
         nxJHo0N2qc6djl7/punIBKDxCyxGro/a4wn8QyenWBheslHRWKaCFT5roxCVOfGsiRN3
         a+Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SMl0afGetTBKoq+adKW6Y9mp7iK570TiW8HXDr9MEaU=;
        b=rX8iMb48ezv3rVh7wZkO1UqDgfFODPa0jnv3oKJSxcfG5saAvO2UCy5i+aa3VZgg/s
         DhaJm8mbvDbpixtYgSP9GtAi0tpkrPdKta5eBQ8GI+mPQDQCKLmQ5FOPml8N1lMCvikh
         uXJZkbEpMaGk6VFC1OGjNNGO2z+entLKZtZFb3mmQKEz7xF3y7WPgqedEiX2BppiTmTI
         1xcy11IA6uzWiUCZoRZQyNKTiO9NdVWamf/Ir+hLI4LpT1+m2G0Zg8IMYaToLUwIRAUL
         BqcpL12FTSWA6C8ys6I9lPD3lDdzUOXebNCtyC9QjNynA3OwGo4QvVzDbENnv4nh+zAa
         GgDQ==
X-Gm-Message-State: APjAAAW1FfzcsFTrG2p9u+KFoi1yG/Tx+B95NnnlQ5CM4PHZ4GvbU5vn
        QEl1VDMMnmNLs2M4DQrLgP+E6cgvYB0=
X-Google-Smtp-Source: APXvYqxDsZRWW1VAJa87Na6jT+iEhPP/tFgzIB7UriU1zysc/Z0xvfQQc2hs37LfIjH2OizE5f2rOQ==
X-Received: by 2002:a63:5211:: with SMTP id g17mr1061154pgb.426.1576024784330;
        Tue, 10 Dec 2019 16:39:44 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b4sm237286pfd.18.2019.12.10.16.39.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 16:39:43 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] ionic: support sr-iov operations
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20191210225421.35193-1-snelson@pensando.io>
 <20191210225421.35193-3-snelson@pensando.io>
 <06e51df6-1da1-97fd-0765-a0efbece45c5@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e40b9299-fd5c-5f62-0c5c-91f254c7a895@pensando.io>
Date:   Tue, 10 Dec 2019 16:39:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <06e51df6-1da1-97fd-0765-a0efbece45c5@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 3:25 PM, Parav Pandit wrote:
> On 12/10/2019 4:54 PM, Shannon Nelson wrote:
>> Add the netdev ops for managing VFs.  Since most of the
>> management work happens in the NIC firmware, the driver becomes
>> mostly a pass-through for the network stack commands that want
>> to control and configure the VFs.
>>
>> We also tweak ionic_station_set() a little to allow for
>> the VFs that start off with a zero'd mac address.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |  16 +-
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   |  75 +++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   |  61 ++++++
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 188 +++++++++++++++++-
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
>>   .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +
>>   7 files changed, 349 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
>> index 98e102af7756..d4cf58da8d13 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
>> @@ -12,7 +12,7 @@ struct ionic_lif;
>>   
>>   #define IONIC_DRV_NAME		"ionic"
>>   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
>> -#define IONIC_DRV_VERSION	"0.18.0-k"
>> +#define IONIC_DRV_VERSION	"0.20.0-k"
>>   
>>   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>>   
>> @@ -25,6 +25,18 @@ struct ionic_lif;
>>   
>>   #define DEVCMD_TIMEOUT  10
>>   
>> +struct ionic_vf {
>> +	u16	 index;
>> +	u8	 macaddr[6];
>> +	__le32	 maxrate;
>> +	__le16	 vlanid;
>> +	u8	 spoofchk;
>> +	u8	 trusted;
>> +	u8	 linkstate;
>> +	dma_addr_t       stats_pa;
>> +	struct ionic_lif_stats stats;
>> +};
>> +
>>   struct ionic {
>>   	struct pci_dev *pdev;
>>   	struct device *dev;
>> @@ -46,6 +58,8 @@ struct ionic {
>>   	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
>>   	struct work_struct nb_work;
>>   	struct notifier_block nb;
>> +	int num_vfs;
> Please drop num_vfs and use pci_num_vf() in ionic_get_vf_config() and
> other friend functions.

Sure.

>> +	struct ionic_vf **vf;
>>   	struct timer_list watchdog_timer;
>>   	int watchdog_period;
>>   };
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> index 9a9ab8cb2cb3..fe4efe12b50b 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
>> @@ -274,11 +274,86 @@ static void ionic_remove(struct pci_dev *pdev)
>>   	ionic_devlink_free(ionic);
>>   }
>>   
>> +static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
>> +{
>> +	struct ionic *ionic = pci_get_drvdata(pdev);
>> +	struct device *dev = ionic->dev;
>> +	unsigned int size;
>> +	int i, err = 0;
>> +
>> +	if (!ionic_is_pf(ionic))
>> +		return -ENODEV;
>> +
> This check is already done by pci core kernel. No need for ionic driver
> to do this. If SR-IOV capability is not enabled, it won't reach here.

Got it

>
>> +	if (num_vfs > 0) {
>> +		err = pci_enable_sriov(pdev, num_vfs);
>> +		if (err) {
>> +			dev_err(&pdev->dev, "Cannot enable SRIOV: %d\n", err);
>> +			return err;
>> +		}
>> +
>> +		size = sizeof(struct ionic_vf *) * num_vfs;
>> +		ionic->vf = kzalloc(size, GFP_KERNEL);
> Please use kcalloc()

Sure

Thanks for the comments,
sln

