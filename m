Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1530610A5F0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfKZVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:23:54 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45000 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfKZVXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:23:53 -0500
Received: by mail-pg1-f171.google.com with SMTP id e6so9616744pgi.11
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 13:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YqnEZ62n/MZ+bufQD8p9KB/MltAeQpl5SUeDzDcQkc8=;
        b=axzou+g8nPMLNZG02TJCWX+PKbDMG5CvN+v3eigzISet9Vigr7Uiq2aCONfmfSWy2S
         TqgFBcXSrv2r5LVQl2Su5Ko+x4mHfR4qfPb7uYEF5+f4WLOzX8ptV2VnEFLMmV+8MV/f
         1+uHnYM9kwOCVVH9CvpE/ss1XD//tm45jpxEkNfm+l9Lwy6WemZXXUpD+PhsoAvcmXQt
         LxoNsNZhlKPnF/Vw+iC42+2AsOMxn99Rumy1M70hszy9ctUS3W3FriSfFgnWIc/IAkGS
         TTBdr8SKpxC1FIRcvqeTDJk64brJiBnfcJueNdE0Z6hC8a8/yE/CDa8lQQixZ0n5LRaA
         mXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YqnEZ62n/MZ+bufQD8p9KB/MltAeQpl5SUeDzDcQkc8=;
        b=NfolHGBgSfbHa7f/7WPELmY09+61yl+Chmfp7WxrcKa7j+F7hRxZCVKpo6F3QSmTld
         q/037tSyGL23eX1vadreCGtiybA6cH6LK7VGtFvzIG5itprhZ/t5cAFCbsBswbAO1s8V
         Z7DExO7K7PRyoGiX4eG6QyAy0Lb273Dz4uuFWj+5cmRnFnhKnfM6vkZhOhjGPcjJc3nO
         DaZ0MZx2cU/DUvqimNeWIN8JsStur+sLp8gISUZw7n9dxmr91vcTcpwev8S6aOhs+xjZ
         D8yLylSFmm7CtnAWFUuIvoLp4WVSMLazKDK5lVfQQfYB5kim5CGXDthIJsdTFfZSFWH3
         CmNg==
X-Gm-Message-State: APjAAAXo70WTKBGhogjTrry1OE/Slfi7CUE0wFvevOwO2uKrKnnn0eH7
        jHAjagKQGxsHwTBfTBJtH0QjEB1/9aUfOg==
X-Google-Smtp-Source: APXvYqy6CnVzeHgivzouJ7v9KfhHiN95OhqzSHwckzVQWJt7fdA3F/n07xnvLgGD2c39ZJKQxUd81w==
X-Received: by 2002:aa7:8396:: with SMTP id u22mr43803839pfm.137.1574803432508;
        Tue, 26 Nov 2019 13:23:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id f25sm14001981pfk.10.2019.11.26.13.23.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 13:23:51 -0800 (PST)
Subject: Re: iwlwifi broken in current -git
To:     David Miller <davem@davemloft.net>
Cc:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <49461e53-e2fe-8a7a-47a3-7de966cb1298@kernel.dk>
 <20191126.131654.606125577060239139.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7b720ff-3c2c-d274-4b8b-e3e6cc79f8d4@kernel.dk>
Date:   Tue, 26 Nov 2019 14:23:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126.131654.606125577060239139.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/19 2:16 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Tue, 26 Nov 2019 14:04:01 -0700
> 
>> Just upgraded my laptop, and iwlwifi won't connect. Not specific to
>> the AP, tried a few and no go. Here are the dmesg from loading and
>> trying to connect, at some point it just gives up and asks me for
>> a password again. v5.4 works just fine.
> 
> We know and are working on a fix, the iwlwifi driver does NAPI
> completions improperly.
> 
> You can set /proc/sys/net/core/gro_normal_batch to '1' as a
> temporary workaround.

Great thanks, that works for me.

-- 
Jens Axboe

