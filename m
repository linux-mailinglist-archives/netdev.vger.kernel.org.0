Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894741961C4
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgC0XLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:11:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37647 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0XLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 19:11:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so13704110wrm.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 16:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FUIf61nj6WNrWinT63BmaXtbZzAzUjwLPPhP2AVIBOQ=;
        b=IMYh6gF7g0pxA5sRJyrFZ6lb32oZFDXvomI8QsStezKVCDm/tOgGcY2fx4myMjtBnk
         01BA3nWBKbujlc5iiZT4QkHg/zwIsjtEndalC+LqPy7FsLqM7POMjNiChkjEHy3DPxLy
         q7Y6wIGbRGpV8FVSYpKy3XHSi6wUMs9MTe4qgzBBH5blvUZpYhnqUAJ1QAcGcuEey0rx
         O2IMBt9KJxxkaG9KsIYXEjZyS3/PoAT7opHD7DwJvD5MchteEa7+5RjFUD+Fp6zehGAF
         T4Empe2KIY4RklhAoHwbmpgxRWCN4gQH8J/AXyKsjMQpDMV9NOBQmJU8S4xMHtqZnB1U
         vcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FUIf61nj6WNrWinT63BmaXtbZzAzUjwLPPhP2AVIBOQ=;
        b=sgz/kmbObUIfTUFHtCqtWMAs3VasDi+mQ1UJ02Ek2SK6lkMapmBwssoYfo41tF6ZQS
         QqTDcUBvPYD1tK4RhHdH69ZkeoyqrptYtvAWE5GR8tS4EryW7BnUBU4oEYoynfDh1mEC
         EKPXdmZYxRCyYTY6Wt9DM9/e05BkLh/5EcpqNHqXa1QKaZ3a+xNbrxFdOL/4PRZV7ARn
         zLDMra90zj03owIRzZN5rfTRPMXBx8FOUQQmScsHsOaDJXjGwC0Wyh16X4B0T7K4HcSx
         jR2vAOi0bziMys3XrJPOUqWXmZ7MbaFUzJ4fYuObX3q+dVPqfpekN/4MjsOXRI4Aro67
         hWUw==
X-Gm-Message-State: ANhLgQ3vtHayCzSiqPrNLCWt2oaDLnuxwz77nLpRLgSTXzFR0T9H5Fxp
        YUnO5DmJFsPoDwq11Rt0QF+RVkVB
X-Google-Smtp-Source: ADFU+vvKqRh15U18feZKMlwTUoplxrf6pUqFW7MSYi6WWg+lJXKBMlxZrv5DKTaQUyFuPM8/Gu3EGA==
X-Received: by 2002:adf:feca:: with SMTP id q10mr1849188wrs.199.1585350662733;
        Fri, 27 Mar 2020 16:11:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:9d76:401f:98cb:c084? (p200300EA8F2960009D76401F98CBC084.dip0.t-ipconnect.de. [2003:ea:8f29:6000:9d76:401f:98cb:c084])
        by smtp.googlemail.com with ESMTPSA id d5sm10893701wrh.40.2020.03.27.16.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 16:11:02 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix PHY driver check on platforms w/o module
 softdeps
To:     David Miller <davem@davemloft.net>
Cc:     nic_swsd@realtek.com, cwhuang@android-x86.org,
        netdev@vger.kernel.org
References: <40373530-6d40-4358-df58-13622a4512c2@gmail.com>
 <20200327.155753.1558332088898122758.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d2a7f1f1-cf74-ab63-3361-6adc0576aa89@gmail.com>
Date:   Sat, 28 Mar 2020 00:10:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327.155753.1558332088898122758.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 23:57, David Miller wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> Date: Fri, 27 Mar 2020 17:33:32 +0100
> 
>> On Android/x86 the module loading infrastructure can't deal with
>> softdeps. Therefore the check for presence of the Realtek PHY driver
>> module fails. mdiobus_register() will try to load the PHY driver
>> module, therefore move the check to after this call and explicitly
>> check that a dedicated PHY driver is bound to the PHY device.
>>
>> Fixes: f32593773549 ("r8169: check that Realtek PHY driver module is loaded")
>> Reported-by: Chih-Wei Huang <cwhuang@android-x86.org>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> Please apply fix back to 5.4 only. On 4.19 it would break processing.
> 
> Applied, but am I missing something here?  The Fixes: tag is a v5.6 change
> which was not sent to -stable.
> 
Somehow that change made it to -stable. See e.g. commit
85a19b0e31e256e77fd4124804b9cec10619de5e for 4.19.
