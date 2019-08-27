Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976D49F571
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfH0Vou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:44:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40439 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfH0Vou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:44:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so245056pfn.7
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=eg8haDmLIw2Wvdralhy+zopQ46pnFXlHLS3hbLaf8jc=;
        b=Q6oBRhmBunX5Ktou0b+2Ao4MZPWAwOWhDUlQR+OcZQ7hx2mZagBZL5Dyj2ww498uxt
         vCjPiydsFVjmYUIEHXP85shPsscpZSnMrxIHBUYCOujBsObFg3sufwOwc/7rPXrdGkjr
         wWNK9ISfQrAiq7rXxg0ihODgihsRlXWX36oJQEz6Je0S+oeOGc4NJtMrkXlZJL85oWLn
         C6l4B4ZCx0hGZPvT07s5nIm3A0wKHS5cLWbXWofIiGSV2nCNdYxGc8sP+vG6S6p6AAxU
         +IJHpjMvWc7MZb1P+ZihUOgUJ9g7naHqp0/KHilFMwj0LT5bNYcfvCvCfQiX3Jflo3Ig
         SIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eg8haDmLIw2Wvdralhy+zopQ46pnFXlHLS3hbLaf8jc=;
        b=tyO761mXUs/+ID2KUcoJeC9fvvGsiygCmP1p3yZgCHjO6LIJVTsJHtnInCJj+8CRqq
         c8o1lK4I175OwAqbK8aeEyZ+gUiidJQf1CTmzcVkLKs0CS4ikl5hyMDLcymcWWbZtR7O
         Zu9hhE8ANjy0pBVmV+q3VOO5PSv2T3DVcgwva3TtlrSIFt+cMQOTnfpEO6uIVJtgKXmF
         Df2RiTYYaEaczYBJmEUs2T9akmDW7JZbapmSDHvQhVppHUJSsqGaBUGeF9OomjlTDmV1
         P8rCFLNgXnWLYAXzf34pWJ/P2qUYYbashfF+1D/j4NiHOPgbqcTUsdnUX9bxyJOSqiKg
         vffA==
X-Gm-Message-State: APjAAAUFk61P20O4F/4QtuDRd9la+eaZMNfsOANH69DRvoZ84Jpj/SD6
        ztrmMdWaRRXP2nOck1NAxmhigw==
X-Google-Smtp-Source: APXvYqxrlnQXD3L9OJzSi1RGdjb6kvZZfpU6Z4oWdCK8EiApUN4UKCmzmYY6ejZchtOqp0IfcLO6bg==
X-Received: by 2002:a17:90b:289:: with SMTP id az9mr903418pjb.5.1566942289518;
        Tue, 27 Aug 2019 14:44:49 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id x9sm291490pgp.75.2019.08.27.14.44.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 14:44:48 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 03/18] ionic: Add port management commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-4-snelson@pensando.io>
 <20190826213631.37b8f56d@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <128b4ac5-2cc5-2f85-ae21-8a142de90595@pensando.io>
Date:   Tue, 27 Aug 2019 14:44:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826213631.37b8f56d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 9:36 PM, Jakub Kicinski wrote:
> On Mon, 26 Aug 2019 14:33:24 -0700, Shannon Nelson wrote:
>> The port management commands apply to the physical port
>> associated with the PCI device, which might be shared among
>> several logical interfaces.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
[...]

>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> index 30a5206bba4e..5b83f21af18a 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
>> @@ -122,6 +122,10 @@ struct ionic_dev {
>>   	struct ionic_intr __iomem *intr_ctrl;
>>   	u64 __iomem *intr_status;
>>   
>> +	u32 port_info_sz;
>> +	struct ionic_port_info *port_info;
>> +	dma_addr_t port_info_pa;
>> +
>>   	struct ionic_devinfo dev_info;
>>   };
>>   
>> @@ -140,4 +144,15 @@ void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
>>   void ionic_dev_cmd_init(struct ionic_dev *idev);
>>   void ionic_dev_cmd_reset(struct ionic_dev *idev);
>>   
>> +void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_init(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_reset(struct ionic_dev *idev);
>> +void ionic_dev_cmd_port_state(struct ionic_dev *idev, u8 state);
>> +void ionic_dev_cmd_port_speed(struct ionic_dev *idev, u32 speed);
>> +void ionic_dev_cmd_port_mtu(struct ionic_dev *idev, u32 mtu);
>> +void ionic_dev_cmd_port_autoneg(struct ionic_dev *idev, u8 an_enable);
>> +void ionic_dev_cmd_port_fec(struct ionic_dev *idev, u8 fec_type);
>> +void ionic_dev_cmd_port_pause(struct ionic_dev *idev, u8 pause_type);
>> +void ionic_dev_cmd_port_loopback(struct ionic_dev *idev, u8 loopback_mode);
> I don't think you call most of these functions in this patch.

No, but most get used in the ethtool code added a few patches later.  
The port_mtu probably won't get used, so I can pull that out.  The 
port_loopback will get used when I add a loopback test, but I can pull 
that out for now until that test is added.

>
>>   #endif /* _IONIC_DEV_H_ */
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> index f52eb6c50358..47928f184230 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
>> @@ -309,6 +309,92 @@ int ionic_reset(struct ionic *ionic)
>>   	return err;
>>   }
>>   
>> +int ionic_port_identify(struct ionic *ionic)
>> +{
>> +	struct ionic_identity *ident = &ionic->ident;
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	size_t sz;
>> +	int err;
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +
>> +	ionic_dev_cmd_port_identify(idev);
>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +	if (!err) {
>> +		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
>> +		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
>> +	}
>> +
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +
>> +	return err;
>> +}
>> +
>> +int ionic_port_init(struct ionic *ionic)
>> +{
>> +	struct ionic_identity *ident = &ionic->ident;
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	size_t sz;
>> +	int err;
>> +
>> +	if (idev->port_info)
>> +		return 0;
>> +
>> +	idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
>> +	idev->port_info = dma_alloc_coherent(ionic->dev, idev->port_info_sz,
>> +					     &idev->port_info_pa,
>> +					     GFP_KERNEL);
>> +	if (!idev->port_info) {
>> +		dev_err(ionic->dev, "Failed to allocate port info, aborting\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +
>> +	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
>> +	ionic_dev_cmd_port_init(idev);
>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +
>> +	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
>> +	(void)ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +	if (err) {
>> +		dev_err(ionic->dev, "Failed to init port\n");
> The lifetime of port_info seems a little strange. Why is it left in
> place even if the command failed? Doesn't this leak memory?
>
>> +		return err;
>> +	}
>> +
>> +	return 0;
> return err; work for both paths
>
>> +}
>> +
>> +int ionic_port_reset(struct ionic *ionic)
>> +{
>> +	struct ionic_dev *idev = &ionic->idev;
>> +	int err;
>> +
>> +	if (!idev->port_info)
>> +		return 0;
>> +
>> +	mutex_lock(&ionic->dev_cmd_lock);
>> +	ionic_dev_cmd_port_reset(idev);
>> +	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
>> +	mutex_unlock(&ionic->dev_cmd_lock);
>> +	if (err) {
>> +		dev_err(ionic->dev, "Failed to reset port\n");
>> +		return err;
> Again, memory leak if command fails? (nothing frees port_info)
>
>> +	}
>> +
>> +	dma_free_coherent(ionic->dev, idev->port_info_sz,
>> +			  idev->port_info, idev->port_info_pa);
>> +
>> +	idev->port_info = NULL;
>> +	idev->port_info_pa = 0;
>> +
>> +	return err;
> Well, with current code err can only be 0 at this point.

I'll revisit these bits.

sln


