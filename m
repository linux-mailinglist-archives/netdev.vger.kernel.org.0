Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADC47236A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfGXAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:25:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37996 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfGXAZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:25:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id f5so11408451pgu.5
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=pDRTvrmvqKsP84q842BSckSaJERLMu+M91wwntsowaI=;
        b=0Mf7m0t4Px9ZcnBgX/Fu64NEJ1zMAGoltW8yJU86wiFw8ZgQDjGPb0hYkZdOPRChD5
         M6d8opmGT8odu1UFJpqrEEONQ1VaxPSjbKOhmGUhzboNOM6okRWExI7aEufwnfDTSgWZ
         jNS9urERtii3sMa7TbZUyHoBDZLLzdbx2DfM8TvGBFo6Z6nPQwcNLU9maQh55XWJu4cb
         v7CvCWRfl0oH6EP9NP6h680GhvtJyRiGyw4Zsv+VShKIoSxNoP+xMPL8SZA5mquG0ers
         FOTBCF873bToZ7JOnUG+xBiT2QOMB/y1gtoUX180tlPFoJlFShbFle78pQgXmqOeXH2t
         tHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pDRTvrmvqKsP84q842BSckSaJERLMu+M91wwntsowaI=;
        b=JEsUJem2DfQtDMMGxdMgxpafFw5oCfCCiHQPxBhOOoWYsNBteNfxeGCUvaeV1/5Sbd
         AqtQUAPagnzn5R8b+Jhf+hS+yvofLBkGAp++uEN5LYt8TYgDsOnTD9V78XA33DpdLghm
         kT5Sd1SMzr+k3FtieER84gQsBsgvZWRfxmDOGuY1WgZ8w7jJc55rrDlRSmiT6djCkQKO
         gZNxmhN/k72Y+gUmxH0tAtPOAsk8Zjpjur5qDaH7NfSJV/oLT0/6d+trst2pioVjEqwt
         0oGivbBRMeJnEDjVAw1jujKT3fvweoI0uVo9IDXO/0jvj5lzlsc4Q+J4b3f4bt+ka1BF
         mKkA==
X-Gm-Message-State: APjAAAVwq0n6y4meZYczdVb8KfqV8AN6ZsgzkOnXYmCWqzeW3qkcieL3
        DmrZxl/uRGpzatkyE/5UrVGdXA==
X-Google-Smtp-Source: APXvYqxptN/4Mq35kPJ/mGubH8R1QC4KQedHJnnAwCqF6JmaFOY3m94O92JGl5BFVCv1f+BjUqsgxg==
X-Received: by 2002:a65:6846:: with SMTP id q6mr39980105pgt.150.1563927903657;
        Tue, 23 Jul 2019 17:25:03 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id a25sm18337377pfo.60.2019.07.23.17.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 17:25:03 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-3-snelson@pensando.io>
 <a402ea5d2badda79cf205e790d3eb967f2cb7084.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <10005fdb-51e8-42fc-3a7c-ea7c0dddb584@pensando.io>
Date:   Tue, 23 Jul 2019 17:25:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a402ea5d2badda79cf205e790d3eb967f2cb7084.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:47 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> The ionic device has a small set of PCI registers, including a
>> device control and data space, and a large set of message
>> commands.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>> ---
>>   drivers/net/ethernet/pensando/ionic/Makefile  |    2 +-
>>   drivers/net/ethernet/pensando/ionic/ionic.h   |   20 +
>>   .../net/ethernet/pensando/ionic/ionic_bus.h   |    1 +
>>   .../ethernet/pensando/ionic/ionic_bus_pci.c   |  140 +-
>>   .../ethernet/pensando/ionic/ionic_debugfs.c   |   67 +
>>   .../ethernet/pensando/ionic/ionic_debugfs.h   |   28 +
>>   .../net/ethernet/pensando/ionic/ionic_dev.c   |  132 +
>>   .../net/ethernet/pensando/ionic/ionic_dev.h   |  144 +
>>   .../net/ethernet/pensando/ionic/ionic_if.h    | 2552
>> +++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_main.c  |  296 ++
>>   .../net/ethernet/pensando/ionic/ionic_regs.h  |  133 +
>>   11 files changed, 3512 insertions(+), 3 deletions(-)
>>   create mode 100644
>> drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>>   create mode 100644
>> drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.c
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.h
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_if.h
>>   create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_regs.h
>>
> [...]
>   
>>   static void ionic_remove(struct pci_dev *pdev)
>>   {
>>   	struct ionic *ionic = pci_get_drvdata(pdev);
>>   
>> -	devm_kfree(&pdev->dev, ionic);
>> +	if (ionic) {
> nit, in case you are doing another re-spin  maybe early return here:
> if (!ionic)
>       return;
> //do stuff

Sure

>
>> +		ionic_reset(ionic);
>> +		ionic_dev_teardown(ionic);
>> +		ionic_unmap_bars(ionic);
>> +		pci_release_regions(pdev);
>> +		pci_clear_master(pdev);
>> +		pci_disable_sriov(pdev);
>> +		pci_disable_device(pdev);
>> +		ionic_debugfs_del_dev(ionic);
>> +		mutex_destroy(&ionic->dev_cmd_lock);
>> +
>> +		devm_kfree(&pdev->dev, ionic);
>> +	}
>>   }
>>
> [...]
>
>>   
>> +
>> +/* Devcmd Interface */
>> +u8 ionic_dev_cmd_status(struct ionic_dev *idev)
>> +{
>> +	return ioread8(&idev->dev_cmd_regs->comp.comp.status);
>> +}
>> +
>> +bool ionic_dev_cmd_done(struct ionic_dev *idev)
>> +{
>> +	return ioread32(&idev->dev_cmd_regs->done) & DEV_CMD_DONE;
>> +}
>> +
>> +void ionic_dev_cmd_comp(struct ionic_dev *idev, union dev_cmd_comp
>> *comp)
>> +{
>> +	memcpy_fromio(comp, &idev->dev_cmd_regs->comp, sizeof(*comp));
>> +}
>> +
>> +void ionic_dev_cmd_go(struct ionic_dev *idev, union dev_cmd *cmd)
>> +{
>> +	memcpy_toio(&idev->dev_cmd_regs->cmd, cmd, sizeof(*cmd));
>> +	iowrite32(0, &idev->dev_cmd_regs->done);
>> +	iowrite32(1, &idev->dev_cmd_regs->doorbell);
>> +}
>> +
>> +/* Device commands */
>> +void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver)
>> +{
>> +	union dev_cmd cmd = {
>> +		.identify.opcode = CMD_OPCODE_IDENTIFY,
>> +		.identify.ver = ver,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_init(struct ionic_dev *idev)
>> +{
>> +	union dev_cmd cmd = {
>> +		.init.opcode = CMD_OPCODE_INIT,
>> +		.init.type = 0,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
>> +
>> +void ionic_dev_cmd_reset(struct ionic_dev *idev)
>> +{
>> +	union dev_cmd cmd = {
>> +		.reset.opcode = CMD_OPCODE_RESET,
>> +	};
>> +
>> +	ionic_dev_cmd_go(idev, &cmd);
>> +}
> [...]
>
>> +int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long
>> max_seconds)
>> +{
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	unsigned long max_wait, start_time, duration;
>> +	int opcode;
>> +	int done;
>> +	int err;
>> +
>> +	WARN_ON(in_interrupt());
>> +
>> +	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
>> +	 * but don't wait any longer than max_seconds.
>> +	 */
>> +	max_wait = jiffies + (max_seconds * HZ);
>> +try_again:
>> +	start_time = jiffies;
>> +	do {
>> +		done = ionic_dev_cmd_done(idev);
> READ_ONCE required here ? to read from coherent memory modified
> by the device and read by the driver ?

Good idea, I'll add that in.

>
>> +		if (done)
>> +			break;
>> +		msleep(20);
>> +	} while (!done && time_before(jiffies, max_wait));
> so your command interface is busy polling based, i am relating here to
> Dave's comment regarding async command completion, is it possible to
> have interrupt (MSIX?) based command completion in this hw ?

As I wrote elsewhere, this is only the low-level dev_cmd that does 
polling; the adminq does a wait that is completed by an MSI-x handler.

sln

