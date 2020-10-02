Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF15281149
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgJBLeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBLeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 07:34:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529AC0613D0;
        Fri,  2 Oct 2020 04:34:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b17so630643pji.1;
        Fri, 02 Oct 2020 04:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=K/VaKn9dzizOyY0tltyu5tEET9jo6PeHo4lcG4paeq0=;
        b=N/P8MSVo1U7BtuFJNE+SodhonKVZR1CF9QluHq6s1h4xYwl0pq+ntYF26z+gMRnOXE
         6LgTRMiqijNo2Y8ssN8VEjntS9nRhWXTYwT6dDNpxSsbFvbewFF3QRgZzC1jTqcF7agX
         jiWOxq9ewa5mxXWI4qmX7PTTmptU+gNdS50sf4IywX8iEzX8NMPwOf/JNQ9jw4S3s7DQ
         gJFdOzqvBT0OA6fih/uObjx9sR9b4X7Fgq9jU/IZcmnyt5NyDSVuVvpQ1qQkrsGlDp1u
         wPqFVsk4SjzaaYe83DRml7OcBvcw75TrRcuL/X6CqctILk25k6ty9wW5wPVGyTLW88Jb
         BpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=K/VaKn9dzizOyY0tltyu5tEET9jo6PeHo4lcG4paeq0=;
        b=fbozXZjA2ICcGoF9D9XcND0ihG2SUZkd1+Tv5q89tRNLCVJFPqi1p/rJ3w4lIcZOmD
         zDGQbfhlnPaVEIrxO3DBxfgjRkNlDb9vi6nVxfxTnLCp5PABMkTLi+n2a4OeZR58p1Hd
         e2Bnthb0PrmcCidTX+DH4WN5w0FZghRDMXmkHgnYC79PhBJXqDeSNHQmC2uS+PZU0lDe
         6EIwnz59qdk7ckjShVm2GcE8d3MV7HEmD6n/te1qkgV0UUEh/bML6hwqomSgYeUg5WXT
         VOBxw/Ml7ExnOVGg0bnSkKyjM3mcJ9E4wSCzv2H0ZD75sLQzyySiSVfAfC4B0ndUUbEG
         AIsA==
X-Gm-Message-State: AOAM533hhNEDrXbgcuzqJYVYlJ4PaxC4iTsC0yDN+bJ844EVLU+z0J68
        goOoxKehKLujIqcS2gJ8HXIQgrhS3Mn/eBG/sCs=
X-Google-Smtp-Source: ABdhPJxPrRC7D283hGCMowzaj1PXBI6zxmqIXpXGnLKzL8vrGcn+vdjdMI1G45WDEiowYR/4q7PJWg==
X-Received: by 2002:a17:90a:ea0a:: with SMTP id w10mr2245628pjy.165.1601638458700;
        Fri, 02 Oct 2020 04:34:18 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.217.69])
        by smtp.gmail.com with ESMTPSA id f5sm1468026pgg.68.2020.10.02.04.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 04:34:17 -0700 (PDT)
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
Date:   Fri, 2 Oct 2020 17:04:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001.191522.1749084221364678705.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/10/20 7:45 am, David Miller wrote:
> From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> Date: Thu,  1 Oct 2020 13:02:20 +0530
>
>> When get_registers() fails (which happens when usb_control_msg() fails)
>> in set_ethernet_addr(), the uninitialized value of node_id gets copied
>> as the address.
>>
>> Checking for the return values appropriately, and handling the case
>> wherein set_ethernet_addr() fails like this, helps in avoiding the
>> mac address being incorrectly set in this manner.
>>
>> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> Acked-by: Petko Manolov <petkan@nucleusys.com>
> First, please remove "Linux-kernel-mentees" from the Subject line.
>
> All patch submitters should have their work judged equally, whoever
> they are.  So this Subject text gives no extra information, and it
> simply makes scanning Subject lines in one's mailer more difficult.
I will keep that in mind for all future submissions. Thank you.

> Second, when a MAC address fails to probe a random MAC address should
> be selected.  We have helpers for this.  This way an interface still
> comes up and is usable, even in the event of a failed MAC address
> probe.

Okay... I see.
But this patch is about ensuring that an uninitialized variable's
value (whatever that may be) is not set as the ethernet address
blindly (without any form of checking if get_registers() worked
as expected, or not). And I didn't think uninitialized values being
set as MAC address was considered a good outcome (after all, it
seemed to have triggered a bug), especially when it could have
been avoided by introducing a simple check that doesn't break
anything.
However, if I was mistaken, and if that is something that we can live
with after all, then I don't really see the understand the purpose of
similar checks being made (in all the many places that the return
value of get_registers() (or a similar function gets checked) in the first
place at all.

In all honesty, this confused me a little more than it provided clarity,
and I hope someone could help me shift that balance back to clarity
again.

Thank you for your time.

Thanks,
Anant
