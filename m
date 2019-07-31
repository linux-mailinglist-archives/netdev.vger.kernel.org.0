Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D24C7B76B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfGaBK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:10:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35783 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfGaBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:10:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id u14so30826327pfn.2
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hmYwmB7S/DH+BSYT5btCmZHKNN4HrJ3ME8asduYbfZo=;
        b=q1S5TWnl6TFhkNoDrZsWCPA7F+3q1hcKBsx9DB2X4A9G4fW/FLcDNni4l3UgUZEJhT
         Bb+5oeSvCgNhpHYfjNkPTr3siUYcYKzNFsSIVj1VSxqoAHqjIY/lx1/damLLv4rxY6ZC
         LwjWzP7h1hbnwoQdRk1a+7edukla0cgAOQecDO6VJUJh+8Ni1Ab92+Ybzgm6/+Q6wFPy
         8flmbOXrPHUfslnAGChrrBsG2kUTvZ8FS1EZbnUsQcIqnrEKqwUWhdT4BEyQLgmaoCA2
         sWi1P8MINeXYxXSeixhLbCUuT+qxZgck3YQRUxKDAenBFB9lFjiIwqsZd/Ba83IKjmpB
         ZTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hmYwmB7S/DH+BSYT5btCmZHKNN4HrJ3ME8asduYbfZo=;
        b=t8fvROwqE5ooGi1u9762DxodxJuBMOSclkjq9Zh4Mi3vDCY50tYBrU04obGUrmZ+QM
         BDpq3Dm4192At70Zm1g/Kq1PT3clzULIAgWHKeYaXU4ENdjHjndqnVEkv72CeJZnSHV5
         cSa+HbcEjvpT7OFG7r21j1/3FdHXvfFrgWaCz/ZzX80lYzEd/A8Ik+2DPwSlNHPqtE8w
         CAAIPMlSXX2aR0wbkwYzo6gMMUSjF5nr9AZcU059xC8gbacKUO6LTl6MZy1Y5BZTcbCn
         zJ5qoyymwVxXT0KlxKjONsjoUndC274JsDBzb+Q2/k3NkBdGcOewVno/j+uVysUeJQXc
         SB2Q==
X-Gm-Message-State: APjAAAXiXr4U+3OgNVlqKEihP9EYKWm+iFTFQkUbZyWNhPHEVVrilWgi
        gfpOaqeXUC4Q38lkNSCwGQM4lRMcdt42uA==
X-Google-Smtp-Source: APXvYqxPZZNNeX4hObYQ+x4dlrTk6KMQP2Jeh5daIvHv5qVw/osgqzggRNgvRA/9X4Jl1lKflVPdfA==
X-Received: by 2002:a17:90a:4806:: with SMTP id a6mr231865pjh.38.1564535427579;
        Tue, 30 Jul 2019 18:10:27 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k22sm71487871pfk.157.2019.07.30.18.10.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 18:10:26 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-16-snelson@pensando.io>
 <20190730163947.3e730f25@hermes.lan>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <087179c7-4cc4-f77b-1d6e-915c6c4877c6@pensando.io>
Date:   Tue, 30 Jul 2019 18:10:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730163947.3e730f25@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 4:39 PM, Stephen Hemminger wrote:
> On Mon, 22 Jul 2019 14:40:19 -0700
> Shannon Nelson <snelson@pensando.io> wrote:
>
>> +
>> +static void ionic_lif_set_netdev_info(struct lif *lif)
>> +{
>> +	struct ionic_admin_ctx ctx = {
>> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
>> +		.cmd.lif_setattr = {
>> +			.opcode = CMD_OPCODE_LIF_SETATTR,
>> +			.index = cpu_to_le16(lif->index),
>> +			.attr = IONIC_LIF_ATTR_NAME,
>> +		},
>> +	};
>> +
>> +	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
>> +		sizeof(ctx.cmd.lif_setattr.name));
>> +
>> +	dev_info(lif->ionic->dev, "NETDEV_CHANGENAME %s %s\n",
>> +		 lif->name, ctx.cmd.lif_setattr.name);
>> +
> There is already a kernel message for this. Repeating the same thing in the
> driver is redundant.

True, except for the lif name information.  But since that really is 
debugging information, and I was getting tired of seeing those redundant 
messages, I was planning to remove them soon anyway. Thanks for the 
extra nudge.

sln

