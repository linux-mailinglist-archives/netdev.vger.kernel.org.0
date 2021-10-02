Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC06E41FC24
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhJBNQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhJBNQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 09:16:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97138C0613EC;
        Sat,  2 Oct 2021 06:14:47 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y26so50314455lfa.11;
        Sat, 02 Oct 2021 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OhHHCzlMgZvLWJFP20yhx+508qKL28Oh/kpWOolKVRM=;
        b=gv73SbrDjN5pzr5b//j4VGBVro+LPvHlU3xFZPDlkEfLwuq3YH1r+S7DRTaNwm6z16
         tm4vSf7jQaIAkXSRO6dvsYc0/CEWJLUD5N79vjRelW9fRorduhlXLesGPgpSBZ/3u8Z+
         T7GQHLpPCH3In1a61V1LQkxiOAuIZ6i99lEKup0gvSGAYYUY9Y9FMBDhJY4UK+Nkcg8O
         yKE7VeB5LH5vE9PPofG3PpL8kPw3N2C4sP/wxwtf5L62A8LGIWeyHLNvSxSqcktzxkT1
         +cwzpi6Wh5JpMFmyc6pXEHLNva2K+U8nLsG/z+3MGQwnaTeuX5irsqnOv2uQx3MM4aNW
         bILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OhHHCzlMgZvLWJFP20yhx+508qKL28Oh/kpWOolKVRM=;
        b=h+s6+QVDObXg5Id02i3C4ldzRfTdNzAebivAvzexGSZEyDKG1nKRs+1mimdOEPp7Ee
         mDRkfSzEZGpHOZvmSUXgbWpa89kTX6eLuxm/j+3i80h1nFHwdV5uqywdID5nwPGEK56n
         3pkyFku3uISyuGda6AdcICBwT4ziacVrOLAqfcwdJPEmBRhozfHaj8EtSRXMG5ZibAkW
         jXYc40yzCiIsrhYiuDCpHdLYxQlAeHT9zxbll0ZkeR97lSeih1CSS1fCOqqG79plN9r9
         sVi3gIaV5rolkp9gmHvyE3gpOJHmDNI8sT6H1dKWcy/VAEgRkDAyETV/YQfp61b/IlDU
         6BXQ==
X-Gm-Message-State: AOAM533jze6OjZWLjEqReErUc0qP0k8JCQsdIedpIIeJYZd1bENjWpYX
        mA5GVv6LlWvZxwPKRNHxl6eB3CqTZQQ=
X-Google-Smtp-Source: ABdhPJyxqlH2S1YDNpyQ0x/82vPQB5X6YfkrWc+55iZdwUMGkTIkAnojtwebbBHjRBnInVa8O9R98g==
X-Received: by 2002:ac2:4116:: with SMTP id b22mr3954778lfi.587.1633180485790;
        Sat, 02 Oct 2021 06:14:45 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id n1sm448302lft.266.2021.10.02.06.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 06:14:45 -0700 (PDT)
Message-ID: <215bf5da-d69d-a764-62e8-6b6e0702d5db@gmail.com>
Date:   Sat, 2 Oct 2021 16:14:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH RESEND] net: ath9k: fix use-after-free in
 ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        Sujith.Manoharan@atheros.com, linville@tuxdriver.com,
        vasanth@atheros.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
 <20210922164204.32680-1-paskripkin@gmail.com>
 <9bbf1f36-2878-69d1-f262-614d3cb66328@gmail.com>
 <87pmsnh8qx.fsf@codeaurora.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <87pmsnh8qx.fsf@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/21 16:11, Kalle Valo wrote:
>> Hi, ath9k maintainers!
>>
>> Does this patch need any further work? I can't see any comments on it
>> since 8/6/21 and I can't see it on wireless patchwork.
>>
>> If this bug is already fixed and I've overlooked a fix commit, please,
>> let me know. As I see syzbot hits this bug really often [1]
> 
> See my other mail I just sent about ath9k syzbot patches:
> 
> https://lore.kernel.org/linux-wireless/87tuhzhdyq.fsf@codeaurora.org/
> 
> In summary: please wait patiently once I'm able to test the syzbot
> patches on a real device.
> 

I see, thank you clarifying the situation. I understand, that 
maintaining ath9k devices alone is not easy task

Thanks again


With regards,
Pavel Skripkin
