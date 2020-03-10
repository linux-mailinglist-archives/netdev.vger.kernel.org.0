Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84D517EDA2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJBHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:07:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41877 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:07:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id z65so5644173pfz.8
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M8oLp27WSSH3ea9qRB9p0NYBbn584saSQRYLIKu22Lg=;
        b=eIo7la5JeoFK4zO/cv8WJB5UTLpwkbYghECR7PEqAyL237ltV7CRZD5pyW1a/8KrUC
         oTBojFGL0W26WCgVhBrhJB6g9yeqx4ShfupeSuYjWiaWbvOcpmAg63yG8IOUDsP+Il9a
         PuKI2ArNpbQeJHdK2Aa7NLprNR5kj8K7+CnJbsD9DQXl632G+c5lveWZmGR5cg4gHU4R
         UI2tQBEYm1+QoJdQ8HL2SHgnhoOljiqVuRZroufkqZaIjisubSyYauf0BvJQVha2j9Jd
         XFLmv0dC1q/ygRXs1HEY3x9piywr6cVYWg4g/tGke/wuv622g3VjVRLHOwf80Du8OS8b
         Azsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8oLp27WSSH3ea9qRB9p0NYBbn584saSQRYLIKu22Lg=;
        b=Woce1G8XuD3QQzehBBoK8knpyE6vF9mC25bR3iAnMAo6b3miRyb9+m+g+KKUrEFGE2
         hQikq1fPC5UyKWbVIRvOnhzw5mqZ+MeAorGlPLhnnz3Uzv7HVjS5qtPgUUt/OHoqTYma
         +VL1DO8zr+kf0V9YozEIVLXuXbpySr5Klwp05Jn82Zu0hWBquvXvDMLH+6Oj7JuWGQgd
         8HJQga78yDJozCednRKLBmN66d09xmZopVht4GCGXbk6WVR7c/u56sG6/UjAioUjQcLd
         flogGPycGLHfnjLAULOjmGNjckzEbRDnoXzVOis3lrvAgJgHssoAECAjcZzWAxYPwTYb
         nW6Q==
X-Gm-Message-State: ANhLgQ1d6w6Rw5AdBxaR+eHyOxDsqiufIGz+jyxCaACcidGww6qjwT9w
        5eEOSYFTu6JwYNnV/o13x/+YFIdY
X-Google-Smtp-Source: ADFU+vv8uwSj71mKtEtewS2tVhjJXBbnJjB0VpygF6+q1Fpr3bJeSRUvedjFRClJFO6uXVH9FdFr7g==
X-Received: by 2002:a62:64d5:: with SMTP id y204mr19846705pfb.90.1583802431710;
        Mon, 09 Mar 2020 18:07:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k3sm44989681pgh.34.2020.03.09.18.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 18:07:10 -0700 (PDT)
Subject: Re: [PATCH net] ipvlan: add cond_resched_rcu() while processing
 muticast backlog
To:     Mahesh Bandewar <maheshb@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        syzbot <syzkaller@googlegroups.com>
References: <20200309225702.63695-1-maheshb@google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <eff143b1-1c88-4ed7-ff59-b25ac0dfd42f@gmail.com>
Date:   Mon, 9 Mar 2020 18:07:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309225702.63695-1-maheshb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 3:57 PM, Mahesh Bandewar wrote:
> If there are substantial number of slaves created as simulated by
> Syzbot, the backlog processing could take much longer and result
> into the issue found in the Syzbot report.
> 

...

> 
> Fixes: ba35f8588f47 (“ipvlan: Defer multicast / broadcast processing to a work-queue”)
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  drivers/net/ipvlan/ipvlan_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
> index 53dac397db37..5759e91dec71 100644
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -277,6 +277,7 @@ void ipvlan_process_multicast(struct work_struct *work)
>  			}
>  			ipvlan_count_rx(ipvlan, len, ret == NET_RX_SUCCESS, true);
>  			local_bh_enable();
> +			cond_resched_rcu();

This does not work : If you release rcu_read_lock() here,
then the surrounding loop can not be continued without risking use-after-free

rcu_read_lock();
list_for_each_entry_rcu(ipvlan, &port->ipvlans, pnode) {
    ...
    cond_resched_rcu();
    // after this point bad things can happen
}


You probably should do instead :

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 30cd0c4f0be0b4d1dea2c0a4d68d0e33d1931ebc..57617ff5565fb87035c13dcf1de9fa5431d04e10 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -293,6 +293,7 @@ void ipvlan_process_multicast(struct work_struct *work)
                }
                if (dev)
                        dev_put(dev);
+               cond_resched();
        }
 }
 
