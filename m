Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94545607D9
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfGEO2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:28:18 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39417 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEO2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 10:28:18 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so4009774ioh.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 07:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NPq0WihBXfIIIGpQocBmiVcY+JuiOESvD/Tk2IWEX/Q=;
        b=KoGYTwpgVjTXOCfpJyHC6rlkFPLQQ5lYJCzFURSIkpBuBrC4UWGTxex3Z/dFgzodeV
         QwWAaJPFDDm3BmNeVqr+9hrbt7rcTDNaSv/7iG2qSB4TO/U05aVgykxXl/Jrdv7kEilZ
         oVbr6rh21Ib8FQ/ioozI4k84tocKFwTIwss6XaHCHSH7zPMQWjOLqUcpTrcKIfT6guHR
         ZUROHzzCAtlEuKQl3LHxoJ7f6a2c22Ylsyfvvb8zBrR5VT/vGKlpQX7SDxAm5rmkvRQA
         tL1FV4FOcgd12IyZTxI30dMN9wz0wqrSg55BzE8XeF9X9ydtruFqC15Or9QqKMr22TkH
         O0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NPq0WihBXfIIIGpQocBmiVcY+JuiOESvD/Tk2IWEX/Q=;
        b=KBP08g2qC4Ok45ESo24EmfVCFm86z/FfWHemi3FTAEkGLIds9wIHPsXZM7nI+d5HiN
         uU+93vjUMZyYPqoytnDoWUVOWYNVWuI4JsgWS81iBI4AMobUoCRYY8eS+/zmwPt+fzLS
         G2P12P98+D2/9DL6T2lmcuSPYdIIZrRTIdBYsyRiXHdIG02PRn6tdaNWxS2QZevS2eyi
         rgyELkNWYoxdKjlNHZObLw5AZo+8cYj++ovpEalMkFLbMYl79kPN3y8O3jCweqYmWrlh
         xYt2xzDnQV4sYGb5hWnsaezp25wGW6hez6mIcJxqEx6X+NtiBjEmwRRT3JODyHM/74xP
         PBtQ==
X-Gm-Message-State: APjAAAVawJV2vLyVRQJda5GPHX9EWM2+CUxIsuAKk4X+DdyaXR+BkKSn
        3c78urLUlmouKacR6PYkACo=
X-Google-Smtp-Source: APXvYqxCb7bkI8IjcVj5Zzlsf2WT2qLLG9t+SCEtvpOESU9J1rXUhDjQ+2vZcRS7Gt6Q+btgkWefqw==
X-Received: by 2002:a6b:bbc1:: with SMTP id l184mr4790320iof.232.1562336897861;
        Fri, 05 Jul 2019 07:28:17 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:24ad:1b47:cd28:1699? ([2601:284:8200:5cfb:24ad:1b47:cd28:1699])
        by smtp.googlemail.com with ESMTPSA id n21sm6263072ioh.30.2019.07.05.07.28.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 07:28:16 -0700 (PDT)
Subject: Re: NEIGH: BUG, double timer add, state is 8
To:     Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
References: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1f4be489-4369-01d1-41c6-1406006df9c5@gmail.com>
Date:   Fri, 5 Jul 2019 08:28:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/19 3:59 PM, Marek Majkowski wrote:
> I found a way to hit an obscure BUG in the
> net/core/neighbour.c:neigh_add_timer(), by piping two carefully
> crafted messages into AF_NETLINK socket.
> 
> https://github.com/torvalds/linux/blob/v5.2-rc7/net/core/neighbour.c#L259
> 
>     if (unlikely(mod_timer(&n->timer, when))) {
>         printk("NEIGH: BUG, double timer add, state is %x\n", n->nud_state);
>         dump_stack();
>      }
> 
> The repro is here:
> https://gist.github.com/majek/d70297b9d72bc2e2b82145e122722a0c
> 
> wget https://gist.githubusercontent.com/majek/d70297b9d72bc2e2b82145e122722a0c/raw/9e140bcedecc28d722022f1da142a379a9b7a7b0/double_timer_add_bug.c

Thanks for the report - and the reproducer. I am on PTO through Monday;
I will take a look next week if no one else does.
