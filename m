Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4887B20B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfG3SfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:35:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41352 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfG3SfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:35:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so30295902pff.8
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=llJJlHZqAyT7Ml1mT46E53bKNUq81+0xlaUkEEbJISQ=;
        b=zKsTkvevOpOeJOujghLEshlAjuOelf+QiBdJkGGMN/5UBDn1at77psZmoTAB8BiZJH
         k6qUl+81mqYhtADXdWCiwc070kWR36qUgRQIpg/lnAxN5JVGue/wP/13E9HnTv+mim/R
         atmeW1eMAs0mOAUxTEWxQoCLUKEj2Ynv4WYj65MPU5mcj4VUbpB7arMSnizIEF47X667
         4P/EgUDCLSYQcdu9mZ3TflNC0NieFeXNJni7K7ah2joSffJdy02Qw8Io5MoYuIK9rCMb
         U+e5RHRv2bFyJhilNY95zDlWvx364N8ct8kNUJn/MEGYGQJUirt0EmvgYf2QF4labfHG
         7nvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=llJJlHZqAyT7Ml1mT46E53bKNUq81+0xlaUkEEbJISQ=;
        b=TrvituP9jsLPfoufHvQYTK9WWT7SYs3iMpZ0HAGF7m5zBtoqYaalnoRlIY4CbWrHyG
         ybwU1uOssk60qzmjhzNgAaJGNRzQv/G6ub0CHPakNAm9aegbvky1VNK3T4BK+RA+2JID
         +OXf5UZYPj5uAf96HwYPU/AbO44wqLYjfQraz5Rm3FRk6OVr6KCmE+ZaWi7bLFfSNOoK
         oa/OXeILGqsF5x1OnvJtKyPve7P8e3pefZCFqLklgW+GGXaa/TzFxeWxmb2JW6vPoMJA
         FIA1ITItD+ycLZ/vim/28IMlcFyw8Mw3Ky3YbmeTenKUJv0L/PQbYPdR1wITcymjSlP1
         skSA==
X-Gm-Message-State: APjAAAUkMpUM2jw2rL1Y9uZCHyCAd38kaGjiXFMa2Y9JfRLx2NXsLIH0
        5HhEzbPT9TXag754CtoOvyqWdlOlHnaXAg==
X-Google-Smtp-Source: APXvYqzeRDQFCnpbVT36LLReqOvyz5Nz0LMsQHlPmJy27gFpGP3qxMIavbaFN+5WIHhzcdHG6cxIqg==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr110990200pgc.61.1564511703180;
        Tue, 30 Jul 2019 11:35:03 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id w18sm84377614pfj.37.2019.07.30.11.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:35:02 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH v4 net-next 08/19] ionic: Add notifyq support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-9-snelson@pensando.io>
 <879ae2c3f79d5212253811518769cdaa4bf8b9c7.camel@mellanox.com>
Message-ID: <bea92090-fb89-23bf-161e-c9814b3e09d6@pensando.io>
Date:   Tue, 30 Jul 2019 11:35:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <879ae2c3f79d5212253811518769cdaa4bf8b9c7.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 4:21 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> The AdminQ is fine for sending messages and requests to the NIC,
>> but we also need to have events published from the NIC to the
>> driver.  The NotifyQ handles this for us, using the same interrupt
>> as AdminQ.
>>
>> Signed-off-by: Shannon Nelson<snelson@pensando.io>
>> ---
>>   .../ethernet/pensando/ionic/ionic_debugfs.c   |  16 ++
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 181
>> +++++++++++++++++-
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +
>>   3 files changed, 200 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> index 9af15c69b2a6..1d05b23de303 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> @@ -126,6 +126,7 @@ int ionic_debugfs_add_qcq(struct lif *lif, struct
>> qcq *qcq)
>>   	struct debugfs_blob_wrapper *desc_blob;
>>   	struct device *dev = lif->ionic->dev;
>>   	struct intr *intr = &qcq->intr;
>> +	struct dentry *stats_dentry;
>>   	struct queue *q = &qcq->q;
>>   	struct cq *cq = &qcq->cq;
>>   
>> @@ -219,6 +220,21 @@ int ionic_debugfs_add_qcq(struct lif *lif,
>> struct qcq *qcq)
>>   					intr_ctrl_regset);
>>   	}
>>   
>> +	if (qcq->flags & QCQ_F_NOTIFYQ) {
>> +		stats_dentry = debugfs_create_dir("notifyblock",
>> qcq_dentry);
>> +		if (IS_ERR_OR_NULL(stats_dentry))
>> +			return PTR_ERR(stats_dentry);
>> +
>> +		debugfs_create_u64("eid", 0400, stats_dentry,
>> +				   (u64 *)&lif->info->status.eid);
>> +		debugfs_create_u16("link_status", 0400, stats_dentry,
>> +				   (u16 *)&lif->info-
>>> status.link_status);
>> +		debugfs_create_u32("link_speed", 0400, stats_dentry,
>> +				   (u32 *)&lif->info-
>>> status.link_speed);
>> +		debugfs_create_u16("link_down_count", 0400,
>> stats_dentry,
>> +				   (u16 *)&lif->info-
>>> status.link_down_count);
>> +	}
>> +
> you never write to these lif->info->status.xyz ..

This is data coming out of DMA memory from the nic, the driver only 
reads it.

> and link state and speed are/should be available  in "ethtool <ifname>"
> so this looks redundant to me. you can also use ethtool -S to report
> linkdown count.

The notifyblock is a chunk of data that usually stays together, but 
isn't really something for ethtool -S, I'd prefer to leave this here.

[...]
>> +	case EVENT_OPCODE_LOG:
>> +		netdev_info(netdev, "Notifyq EVENT_OPCODE_LOG
>> eid=%lld\n", eid);
>> +		print_hex_dump(KERN_INFO, "notifyq ",
>> DUMP_PREFIX_OFFSET, 16, 1,
>> +			       comp->log.data, sizeof(comp->log.data),
>> true);
> So your device can generate log buffer dump into the kernel log ..
> I am not sure how acceptable this is, maybe trace buffer is more
> appropriate for this.

It turns out that this early design feature has gone unused, so I'll 
drop it out of here for now.

Thanks,
sln
