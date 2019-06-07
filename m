Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA9838317
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 05:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFGDVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 23:21:32 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39928 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFGDVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 23:21:32 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so804008edv.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 20:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/rpaEqYm+ZxckNWOe6zhkmzIL2V97JvNRGIarJDqM3U=;
        b=H5qE+aU1yL9KCg6QtSaowhxj8bD2QT5yPSjbRHvCvWThsl1w27Ip5DliRzw4+Y9uG8
         56HgtiSkfHQBZcA6YcFx6EzzLo7RupIW7EhjI0w3xnxCI5mqsUgGpgagUvOkV8h77LX8
         +ieXJGvVSgAUL8SzXOifcFVjgyhyZaz8K2lmfQb22IFCuyDNO2llo40XvcFv9PIEWTGm
         RZkKEfqby0RdJY5cvst2Ac8hZPFi9db3O0mTzCIMwxysvWjFRIUbuaDd+Li5fQTdLV7F
         803dDmxr9JiHdQ1ngExTxbzA9rftqAsfL6FVaI5Xt99R36dwH6BQX0DrPbWYeroRYyZd
         UvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/rpaEqYm+ZxckNWOe6zhkmzIL2V97JvNRGIarJDqM3U=;
        b=jBmlwWXOpmerC1AHGElPfEDNSHarDlWgI7FOAVMhZXvHpDLbex7NEL5A1ms7CyLIPe
         h6JMq7B6iJ1W/0iKj+f1Sn+0bAlyh10I/n4CZzLZIjr5uPefdG1Jr+e0/1qwI7Ytdt1w
         9EjqPGJjLU9J6g8c9gJcvpNttVDcYmlaXD/t/VIsKByUL9S1ag6uyB4+LFA3hyFkbi1u
         wDNK5uHWHlPBEPjhSTkMAknkcbv+UKF+WiFTWgdYMN9SOEN+W7m6NYHzmFBkT60esGZk
         YA6Scoe7ylbS8MIM3pjj39KeNmJvEwr6emoC+IVootPKNVxSNuiHFIuWputQZENRDGNM
         yjsw==
X-Gm-Message-State: APjAAAWnASBxblPoihniA/rGy+u7j1SrUNb0/stjSNxubGxMQ4/s+vFI
        u1NAi7vc8hq6jRIQHIH/mrI=
X-Google-Smtp-Source: APXvYqyObvHIR6YGmnrDoqBJUI0aE9B+8X6oiV68newtu/qX/Avq6c0KUF83yjQrzoipAZPXDSqEWg==
X-Received: by 2002:a17:906:53c1:: with SMTP id p1mr43608530ejo.241.1559877690522;
        Thu, 06 Jun 2019 20:21:30 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id f3sm140140ejo.90.2019.06.06.20.21.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 20:21:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sfp: Stop SFP polling and interrupt
 handling during shutdown
To:     Robert Hancock <hancock@sedsystems.ca>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
References: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
 <20190606180908.ctoxi7c4i2uothzn@shell.armlinux.org.uk>
 <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <1d43c48d-1460-d12b-2213-9a0eeb6affb8@gmail.com>
Date:   Thu, 6 Jun 2019 20:21:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/6/2019 1:57 PM, Robert Hancock wrote:
> On 2019-06-06 12:09 p.m., Russell King - ARM Linux admin wrote:
>>> @@ -1466,6 +1467,11 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
>>>  static void sfp_sm_event(struct sfp *sfp, unsigned int event)
>>>  {
>>>  	mutex_lock(&sfp->sm_mutex);
>>> +	if (unlikely(sfp->shutdown)) {
>>> +		/* Do not handle any more state machine events. */
>>> +		mutex_unlock(&sfp->sm_mutex);
>>> +		return;
>>> +	}
>>>  
>>>  	dev_dbg(sfp->dev, "SM: enter %s:%s:%s event %s\n",
>>>  		mod_state_to_str(sfp->sm_mod_state),
>>> @@ -1704,6 +1710,13 @@ static void sfp_check_state(struct sfp *sfp)
>>>  {
>>>  	unsigned int state, i, changed;
>>>  
>>> +	mutex_lock(&sfp->sm_mutex);
>>> +	if (unlikely(sfp->shutdown)) {
>>> +		/* No more state checks */
>>> +		mutex_unlock(&sfp->sm_mutex);
>>> +		return;
>>> +	}
>>> +
>>
>> I don't think you need to add the mutex locking - just check for
>> sfp->shutdown and be done with it...
> 
> The idea there was to deal with the case where GPIO interrupts were
> previously raised before shutdown and not yet handled by the threaded
> interrupt handler by the time shutdown is called. After shutdown on the
> SFP completes, the bus the GPIO stuff is on could potentially be shut
> down at any moment, so we really don't want to be digging into the GPIO
> states after that. Locking the mutex there ensures that we don't read a
> stale value for the shutdown flag in the interrupt handler, since AFAIK
> there's no other synchronization around that value.
> 
> It may also be helpful that the lock is now held for the subsequent code
> in sfp_check_state that's comparing the previous and new states - it
> seems like you could otherwise run into trouble if that function was
> being concurrently called from the polling thread and the interrupt
> handler (for example if you had an SFP where some GPIOs supported
> interrupts and some didn't).

Would not it be sufficient to call disable_irq() or devm_free_irq() (to
match the devm_request_threaded_irq call) in order to achieve what you
want here?
-- 
Florian
