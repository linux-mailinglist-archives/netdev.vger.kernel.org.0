Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92938484783
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiADSL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiADSL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:11:28 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63320C061761;
        Tue,  4 Jan 2022 10:11:28 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h7so38924272lfu.4;
        Tue, 04 Jan 2022 10:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SwnVw/SiATSMFYtdV81zng3Pvd+zDkySvHzChGqV1zI=;
        b=HEFoguWtofBQbkgCS9YmycC2OsfWcV6EnHVaZWA5xLdwSacYLul4y1JXyPeuOT2DAj
         3Q+Tj1pjpfyVsubK931TKGtflfI7fbSBiChjkQjqlVABqPXAoHsF5udy+HRSuy0ArQLQ
         puLwVu/WOm3dYVG0nTLnDm6wQDBKLBMCBIL9fJ4GK0sH0KN0CZV5qnNgUd3N2cLxwdRa
         aAmQ8GqvivZ1Jv/wyRA+e1nhiFwWN5kDIozNxzXpYfnHZJVZbCaqxDukTiQ2g2XEeU9+
         p0zEAqz+UdGcTjhMnzva0rKCdWkQKQUY4mzYSZ6n5a4HdQtcj/mTftdUqK6bQ9FF/7h6
         oXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SwnVw/SiATSMFYtdV81zng3Pvd+zDkySvHzChGqV1zI=;
        b=Oat/iQNFp4tKvLyR4nteF+JEb8YZlJvUObFjIa6A90QXotbePvy0vuqNpGVPi5URHk
         XM/lo+lmQkqBt+dxC37n4sL54pcXDhVGdAVOs/SLM/6UNz9mezWU94CJyQnFAAbr3MQG
         Fq8X342sZsKhtT53xopkw8jDiS+rAgdzEUSbhvG0i/5cGSuIhCBmHYbAuXAuRqX9tqxa
         4WY4xxizI7JCyw/fTE16ubpVN09520ywF9kjdNB3TvwUuyEFLliCN/4jIQZM7mNUilk9
         mTjBdqmLkJTz05LjYhGuEGqsYCBm0lwkHyAhXGmAd9TTTkGII1dIvg7j5fWyfZyzYvfY
         PXWg==
X-Gm-Message-State: AOAM533UNImkyZpQI+BMnLVxYTm28BPNiIsD22hjkanDXm9BYVuIDtyj
        OA4ALgxm5db+Z63JigGh5Gw=
X-Google-Smtp-Source: ABdhPJyJqaV0NQGWX8BdYzjEE7zgijv2NGHZYq8ADDv3RIQG8ux3EIgRARvgxP8gjWMm9JwKFMeL0Q==
X-Received: by 2002:ac2:528a:: with SMTP id q10mr42919559lfm.28.1641319886721;
        Tue, 04 Jan 2022 10:11:26 -0800 (PST)
Received: from [192.168.1.11] ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id u12sm623551ljj.134.2022.01.04.10.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 10:11:26 -0800 (PST)
Message-ID: <a1f63e82-7a3f-7cf9-ddb3-fc0a863dce40@gmail.com>
Date:   Tue, 4 Jan 2022 21:11:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2] ieee802154: atusb: fix uninit value in
 atusb_set_extended_addr
Content-Language: en-US
To:     Stefan Schmidt <stefan@datenfreihafen.org>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
 <20220103120925.25207-1-paskripkin@gmail.com>
 <ed39cbe6-0885-a3ab-fc30-7c292e1acc53@datenfreihafen.org>
 <5b0b8dc6-f038-bfaa-550c-dc23636f0497@gmail.com>
 <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <e8e73fcc-b902-4972-6001-84671361146d@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/22 21:04, Stefan Schmidt wrote:
>> Hi Stefan,
>> 
>> thanks for testing on real hw.
>> 
>> It looks like there is corner case, that Greg mentioned in this thread. 
>> atusb_get_and_show_build() reads firmware build info, which may have 
>> various length.
>> 
>> Maybe we can change atusb_control_msg() to usb_control_msg() in 
>> atusb_get_and_show_build(), since other callers do not have this problem
> 
> That works for me.
> 

Nice! Will prepare v3.


Thanks for testing once again!

> I will also have a look at the use of the modern USB API for next. The
> fix here has a higher prio for me to get in and backported though. Once
> we have this we can look at bigger changes in atusb.
> 


With regards,
Pavel Skripkin
