Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3026352B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIIR6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgIIR6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:58:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC503C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 10:58:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id k15so2810951pfc.12
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 10:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7zaMM4OL+S1zFzXGaipmk1GZoJZdZuwdoAqfQj/JQgA=;
        b=kpEj0v08HQ1y2flprxaeg7BUN+CdUeyXCl8VUxwkzVrd1UsOFF9tJFgPk4IZEpVma7
         iE+LxuaFqkOpIXpe3PAJXo2DcgS9y0Ltb3GJW3zYBl0HqfAOXHxFNrdKkH5z5szdvoXX
         +OkSKOACgituYlB/r/JlSwA5zAVtNHmQF7E8l0tazvmkwIpA6B7Q0c9YjTaADmSC933f
         3oDr4AebUV6siycxBqo84BaQNVCSy0VbHc5GQC8ejJJzPpUg7RunjR9ViOPLchUvpa64
         oKPg6qWYankQByLYcbDbBsW8KUEi5csfXS66y6Q5HbkuvoMJRqMjZ1q1DXqgYb47olni
         56gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7zaMM4OL+S1zFzXGaipmk1GZoJZdZuwdoAqfQj/JQgA=;
        b=B5vN+a1OTEKzLRHvpr5A/JUpZbHinsGtL100CQq/bl1yA8/MXJFvDDegW31FnmmsEo
         HR1xqPIGNf9IprZO0HbjnAgxPqXFVfubkXbK8+3PKItflTES+6DUSjuhTFt72qcJH1v6
         GH838jVty8curM7yQRRJ+jA9/rjwafZCWExDlRbnh453dQ+nzAz7fabhYlxjuZM+wU/5
         ZDn2AxCtiffqe/VhJWHhs7NIwfCD06EZEhyZ6skwtiL/9VP2anEmbc3FNrVgf/Qv8IG3
         IfxTShgZFoCKtX9hWt0gH0Ch5ocgrGl2c/soBhvddDg1gXqnLFkv4gGkJjEoZyx4Kynn
         xBsA==
X-Gm-Message-State: AOAM533W3QBxViHnUlktDng0+nVsKLMvQl59+GO8X0y/rC2t3OGnpRCl
        lKogJRqizMw+Ivg794dYz8nS3ZWwbTU5Mw==
X-Google-Smtp-Source: ABdhPJy1Vadyq0JxgPyp6mn/e1A+CCVtcaVC/zHdZNY5iW4n5xNVBZJ1fG2nfVCV0RLwjhez0bdv8w==
X-Received: by 2002:a63:cd4f:: with SMTP id a15mr1527640pgj.416.1599674301317;
        Wed, 09 Sep 2020 10:58:21 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c199sm3359344pfc.128.2020.09.09.10.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 10:58:20 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200908224812.63434-1-snelson@pensando.io>
 <20200908224812.63434-3-snelson@pensando.io>
 <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
 <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
Date:   Wed, 9 Sep 2020 10:58:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/20 9:44 AM, Jakub Kicinski wrote:
> On Wed, 9 Sep 2020 09:23:08 -0700 Shannon Nelson wrote:
>> On 9/8/20 4:54 PM, Jakub Kicinski wrote:
>>> On Tue,  8 Sep 2020 15:48:12 -0700 Shannon Nelson wrote:
>>>> +	dl = priv_to_devlink(ionic);
>>>> +	devlink_flash_update_status_notify(dl, label, NULL, 1, timeout);
>>>> +	start_time = jiffies;
>>>> +	end_time = start_time + (timeout * HZ);
>>>> +	do {
>>>> +		mutex_lock(&ionic->dev_cmd_lock);
>>>> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
>>>> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
>>>> +		mutex_unlock(&ionic->dev_cmd_lock);
>>>> +
>>>> +		devlink_flash_update_status_notify(dl, label, NULL,
>>>> +						   (jiffies - start_time) / HZ,
>>>> +						   timeout);
>>> That's not what I meant. I think we can plumb proper timeout parameter
>>> through devlink all the way to user space.
>> Sure, but until that gets worked out, this should suffice.
> I don't understand - what will get worked out?

I'm suggesting that this implementation using the existing devlink 
logging services should suffice until someone can design, implement, and 
get accepted a different bit of plumbing.  Unfortunately, that's not a 
job that I can get to right now.

sln

