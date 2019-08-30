Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55CAA40E9
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfH3XSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:18:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38034 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfH3XSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:18:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id e11so4253788pga.5
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 16:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jBKPZEkPAH/8mDDfCkV8iDvKX3LoyVfZMLimUokVOZc=;
        b=a+sbnv/R/AO4GqvW8VxYoheQZdDp47+yAzDVrCKAA3J/tEPzBoofyiwG9MEAJwDvx7
         bWgDonMgQHV82IsuQP6xZIpwHO2TjuITwkmQ5lHiwUtkHew2ONLlgBnQj2CzQGhMzSuf
         j+Yt1QHrVRfHIp0iakFGLtxv9IHd1M+GxEqiusVQ3PfWX1gsG+9zI//tsQnGURM7Vycz
         9pEAvd4M2+Fody/lT5Y7vISdzyQCSQxS1Tbjkb+BdcsWyxrd/V9QI9id6D6Aa68uc2+E
         HxkL0o1wqjxwT5N7Ym6799tlRKrndYyNZ9kVX2c87QS/tjd/3HCoVLDeVq5vdPBsBZyY
         PYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jBKPZEkPAH/8mDDfCkV8iDvKX3LoyVfZMLimUokVOZc=;
        b=EEVjTt+ZI1Txi742OLwJmBkRXP+KBiVq/WXxuv4m7oFLrztLcMVtzUCLjgAfZzduCf
         cGt9Vsvd4LS/LMeczsUynUhhZynA8OQSrEBliDtCQvWW0COyMSX3G3T26cziCt59DiyU
         1bwCes0WXtdyX2VP/lfQkCDfPXoUbSocNY3MlWh7U0b46E97Wlyh0tjMCLYo41foCZbU
         LEVasARnmHh3mro7IF0wAzDSQL6lOmk621P9qgYbDN2po9Vf0jObMFOQIMdrFK8toX8Y
         Ns0YQ8KOxH/UYcId3HE8Bj4EGI1clxwFTX1ppBIQzSqbQHOsvLnFm/o4KKJyQLsjoslS
         TfPw==
X-Gm-Message-State: APjAAAWXhqais3+Z/i8tXh0GVmPgpIZWQFCgVyeNPdk8KkhHZGsGzGPP
        +p0efbH27YOj3/N63jNnnNNDthXa2VM=
X-Google-Smtp-Source: APXvYqyoY+I215cnncGBAaB8tEEih+wHecShwR09iUQVZqs1LpdZ8yWlcwimVSsMv2Nbw0wRLvDVkg==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr14754093pgd.241.1567207129240;
        Fri, 30 Aug 2019 16:18:49 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 15sm8056447pfh.188.2019.08.30.16.18.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 16:18:48 -0700 (PDT)
Subject: Re: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
To:     David Miller <davem@davemloft.net>, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
References: <20190829155251.3b2d86c7@cakuba.netronome.com>
 <bad39320-8e67-e280-5e35-612cbdc49b6f@pensando.io>
 <20190830151604.1a7dd276@cakuba.netronome.com>
 <20190830.151711.704306282464276122.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9a0d505b-dc43-ea2e-ae9f-5a37056651fa@pensando.io>
Date:   Fri, 30 Aug 2019 16:18:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190830.151711.704306282464276122.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 3:17 PM, David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Fri, 30 Aug 2019 15:16:04 -0700
>
>> On Fri, 30 Aug 2019 12:31:07 -0700, Shannon Nelson wrote:
>>> On 8/29/19 3:52 PM, Jakub Kicinski wrote:
>>>> On Thu, 29 Aug 2019 11:27:08 -0700, Shannon Nelson wrote:
>>>>> +static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
>>>>> +{
>>>>> +	struct ionic_dev *idev = &lif->ionic->idev;
>>>>> +	struct device *dev = lif->ionic->dev;
>>>>> +
>>>>> +	if (!qcq)
>>>>> +		return;
>>>>> +
>>>>> +	ionic_debugfs_del_qcq(qcq);
>>>>> +
>>>>> +	if (!(qcq->flags & IONIC_QCQ_F_INITED))
>>>>> +		return;
>>>>> +
>>>>> +	if (qcq->flags & IONIC_QCQ_F_INTR) {
>>>>> +		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
>>>>> +				IONIC_INTR_MASK_SET);
>>>>> +		synchronize_irq(qcq->intr.vector);
>>>>> +		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
>>>> Doesn't free_irq() basically imply synchronize_irq()?
>>> The synchronize_irq() waits for any threaded handlers to finish, while
>>> free_irq() only waits for HW handling.  This helps makes sure we don't
>>> have anything still running before we remove resources.
>> mm.. I'm no IRQ expert but it strikes me as surprising as that'd mean
>> every single driver would always have to run synchronize_irq() on
>> module exit, no?
>>
>> I see there is a kthread_stop() in __free_irq(), you sure it doesn't
>> wait for threaded IRQs?
> I'm pretty sure it does.

Yes, deeper in there are the kthread_stop() calls that make the 
synchronize_irq() unneccessary.  I'll pull it out.

Thanks,
sln

