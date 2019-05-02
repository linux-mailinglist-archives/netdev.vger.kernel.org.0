Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4B12143
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEBRuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 13:50:03 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:37997 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBRuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 13:50:03 -0400
Received: by mail-yw1-f65.google.com with SMTP id b74so2102847ywe.5
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 10:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4C05sjemEEDudPs213iU2v9Yk+71basnA+u/NaFHvTo=;
        b=eHL0VvFB83MT9MczIaeFOXQyF3uKRQmcqDLj1efm8XVzTaPwjpw5pbqjDnZ3QW9ZJH
         RTtzTgKIJ5nAENYyz0DeL3DZehuYW3ey8XJzpHf7yLr1jXGXilg0yqh4NhlFRWlXMIbJ
         IHU7SpCD1MfpICSXXt+FIKILVNZ0/HoUdhq0XbZduebIhpnCPMoTbkFGS9xCH4k2laUZ
         AZ52YA2Van7Kvsdbb3Bx6CHhfk36+xhpochkH94iX30SnljOCzTUoM/UJ6D9i4kLKfkB
         EFM0yGoCLuwomhJiG5ty/1mAMRPSpoAWg/LUzN1MJa7O0JbT3KA0LiVlUY5NApJhcQh/
         /Yow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4C05sjemEEDudPs213iU2v9Yk+71basnA+u/NaFHvTo=;
        b=Yzh7HoW+gUbdKqoZocL5kWhgK6x0bOu2I2yhAnIgLTmPBmjx5/GjqiMvAkYXLztuny
         YP1eeQQKTPY7qJCwrPjwhdCZVZP34mWJi9tehlrag0KV6rQ7ofe5SeJrbarkxWysJB6C
         Rv8wtI0KM298UWOTzsBPgZijWjkoJONCBPb70IZjvGQN9/ADi0vNOCw6kh2YhFpM4gqv
         HY86aCkFl0Jl+zTXrdHgI3QYPJejoy8dARoHGXXoelGCBy8N/sqNgLw52+cGbCV8jWvS
         MutMIDwXL6AxzZk1z/zkNSrtE/gQmR/rjtqnt+m/TQhCVV6vFF7CPYthf1p6GwhXYtkN
         bfzg==
X-Gm-Message-State: APjAAAUD0zIS5pV67aZSNu7aVh+8ABFVTb93YodDtYVt31hc2ISS3bmW
        4DUCYddtyMqQOcZnQ9GY335USA2q
X-Google-Smtp-Source: APXvYqx9/knLXtoPYCOGfKV6RF6bL6TJWzleeEddMYo4Z/moy5EiuQL6cqOGB0T3vS4mkorQySCWHw==
X-Received: by 2002:a25:6f83:: with SMTP id k125mr4312643ybc.106.1556819401916;
        Thu, 02 May 2019 10:50:01 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id s13sm8190344ywj.58.2019.05.02.10.50.00
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 10:50:01 -0700 (PDT)
Subject: Re: Question re. skb_orphan for TPROXY
To:     Florian Westphal <fw@strlen.de>, Lorenz Bauer <lmb@cloudflare.com>
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org
References: <CACAyw9-pYyvkUBOzdD+XQBEKdGGB9foJ5ph5sdjiuE4_uyEoJg@mail.gmail.com>
 <20190416150002.cbkih4lfrna4ywdu@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c0b633fc-a16d-5172-18a5-b909092173e9@gmail.com>
Date:   Thu, 2 May 2019 13:50:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416150002.cbkih4lfrna4ywdu@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/19 8:00 AM, Florian Westphal wrote:
> Lorenz Bauer <lmb@cloudflare.com> wrote:
>> Apologies for contacting you out of the blue. I'm currently trying to
>> understand how TPROXY works under the hood. As part of this endeavour,
>> I've stumbled upon the commit attached to this email.
>>
>> From the commit message I infer that somewhere, TPROXY relies on a
>> check of skb->sk == NULL to function. However, I can't figure out
>> where! I've traced TPROXY from NF_HOOK(NF_INET_PRE_ROUTING) just after
>> the call to skb_orphan to __inet_lookup_skb / skb_steal_sock called
>> from the TCP and UDP receive functions, and as far as I can tell there
>> is no such check. Can you maybe shed some light on this?
> 
> Without the skb_orphan udp/tcp might steal tunnel/ppp etc. socket
> instead of tproxy assigned tcp/udp socket.
> 

Florian, it is the responsibility of the loopback code to perform the skb_orphan()

I am confident we can revert 71f9dacd2e4d23 and fix the
paths that eventually miss the skb_orphan() call.

loopback_xmit() properly calls skb_orphan(), we also need to make sure that any kind 
of loopback (veth and others) do the same.

This is a prereq so that XDP or tc code can implement early demux earlier.

As a bonus we remove one skb_orphan() in rx fast path ;)

Note that skb_scrub_packet() used to call skb_orphan(), we need to a bit smarter
and insert it only in __dev_forward_skb()

