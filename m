Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F7F491063
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 19:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242743AbiAQSfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 13:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242721AbiAQSf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 13:35:28 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABC1C061747;
        Mon, 17 Jan 2022 10:35:17 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id x11so35269422lfa.2;
        Mon, 17 Jan 2022 10:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z2LAhV4KSzEZogKZQmx+VN5D6iQExMOg1CIIQQv1a6c=;
        b=h87/EoWOnR4jHU5VsE3cQlywU1F5aajaPPF6NBrQ7B136ytNj+vUCmFT2Ff6mEnICk
         OZaElTNLEXhiiNqUQh2XXjICn19cekST5Z96lwa8zcLZv272+0CfD0ulWkMivlp3QOL5
         +aBOX1Z9CMnKHcOn5lVUa9k98Ydyluw5/wLspul1yTAnJzAJ2ZGqJfRf/uy/zm7S09xC
         265GFZFjCtzlvA6mY8PIl3JdTya3GQqM6K1Q+CB/gxRP4nC7esdQ7cW0MhXyTlWiK80u
         GAmRqvNuiJMoBO6PpL9L1vcJrzTaqE4VACExsA0Tp2jUF8fSEEbGaB6dynLQ5kPQW0Lj
         ONBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z2LAhV4KSzEZogKZQmx+VN5D6iQExMOg1CIIQQv1a6c=;
        b=znkQwNKjF07d2VP74WVOEOKUV695euIbqCyiiEBLDuXN5HiM7StAKZPm/8cHMuNU89
         /1SiQEWvj2ZdVR6ZTxyGYwjWYmfpNNa6sJ1mK3HwTAZ0sFcq5i2aWOYOztJDWLSE/m5t
         A1K2IEKl4Q3AyGmtfj19SWJ8RR8MqwjzTm3UAI7uNdPMMymfNrOEYPuTYbdmgLy/BYex
         W9KR9KZ+Z/EcwFJOIuC5Jcj8/tTjBAGUg0C/9dUFDYHnBX0JDrIoQQas+S/WqX8BkrpI
         YbYo/XtZS/7ag0mGRzYcpBAcVZ8p/MVdBan398NbTjQf3CvS/b+9oi+lFnxb8Q6UgDkb
         2oXw==
X-Gm-Message-State: AOAM532RaGYPwCsTWXc4cknnUYrCwEn+YqTTR9xRJdClikVMsYLAaHlx
        sXm/wp2AJrKuRe68LH/9Bhg=
X-Google-Smtp-Source: ABdhPJwPjWeTQQzIRDbxUo/5CKG8WBZxjXWryCjlZG50Z7qK7RwRsmt5226luHOYipkbH83k9xAeDA==
X-Received: by 2002:a05:651c:547:: with SMTP id q7mr5630262ljp.464.1642444515624;
        Mon, 17 Jan 2022 10:35:15 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id k12sm1455871lfu.252.2022.01.17.10.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 10:35:15 -0800 (PST)
Message-ID: <a63d6d9b-7e95-3e88-fcd2-2fe5e623dd5b@gmail.com>
Date:   Mon, 17 Jan 2022 21:35:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ath9k_htc: fix uninit value bugs
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com,
        vasanth@atheros.com, Sujith.Manoharan@atheros.com,
        senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
References: <20220115122733.11160-1-paskripkin@gmail.com>
 <164242422410.16718.5618838300043178474.kvalo@kernel.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <164242422410.16718.5618838300043178474.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On 1/17/22 15:57, Kalle Valo wrote:
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> How did you test this? As syzbot is mentioned I assume you did not test this on
> a real device, it would help a lot if this is clearly mentioned in the commit
> log. My trust on syzbot fixes is close to zero due to bad past history.
> 

You are right, I've tested only with syzbot's reproducer. I've followed 
simple guess: if code works properly with random values in these fields 
for 14+ years, then zeroing them won't hurt much.

I might be missing something, but unfortunately I don't have suitable hw 
piece to test the change.




With regards,
Pavel Skripkin
