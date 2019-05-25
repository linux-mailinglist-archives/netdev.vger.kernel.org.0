Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557902A50E
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 17:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfEYPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 11:13:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33002 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfEYPNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 11:13:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so7073579pfk.0
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 08:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gDYlxyd152+1w9S8zMyz35eAQ6cyVABNiRfqXvw3Cr8=;
        b=KGwUUpm5yF+a1zp9PPwHCNtF7nzme9aULPDglMtIdKemUjLFxeQt3gfWOHnjXxN3gf
         OMFy/DnnhFhD7adRtQIQMv8pvVYSEk6PG/KJBywOv4aFB29GosfXywHgqoA2L37FdEm0
         WQ1JpPJJjIEt8VOguYtMLmfbGbowBPUebT993+WNyp9ZW5DiXhz5KAZnyygodqo6x9E8
         NIMrOAy973esGcARYpbGbCbvWBH0C7CXrtxcXgrJq+ydL+Jt36sbY1SdaGnG9mkT8K/3
         bocH+pvEqyoivhsAXk565Si8CVc8fUj0UehM0cfNidRDc3oRUyXTWX/kpLJMaHq5dKFt
         Uebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gDYlxyd152+1w9S8zMyz35eAQ6cyVABNiRfqXvw3Cr8=;
        b=VifEGVAsd5JpJgmEjTM2OtfYfp6oGD33RoCK9aCwaXx7B9tOv3Bm/R5XrwnFEVil2k
         +tVO2O9VLeQOznSjKhXj3Dc+nSPefZFwnJTvbl3zICZXQ5c6N4VpM+E/5bSguBF7wddz
         jUGBFMGqCC2DfLcHiCLAABALmbu1KSh1QrsOwrr5aIrJY9EMCQHjIlqZSnsxAZ8YYWyl
         CY8klH4KMUqCWM1E7fLDrcTQGyARE9F2P4tuSuzB8/TTAJfDOMjVWp5UzM8ZVtaHfZXS
         dZ/O0JEo7qHy/lSQJypZ3MA7/+rBRl68jj46otT//8s69gUG6+oZCnSwxGxbKUYv2kBD
         jbqQ==
X-Gm-Message-State: APjAAAWS9SYj8pZsQ5P8p/fiOjLud4Y/nLY2LO6p7IXbI3bqGScNvmYl
        7VBi0sLAiUadziFK6Ok5p8YhjybY
X-Google-Smtp-Source: APXvYqzIq4IWaqBhx2WyXK8Sey7s6qibmXhLYgJRGbTmRj2f1pFGDQEvu/4W1oqTv1T7OtC/0T5OPg==
X-Received: by 2002:aa7:9356:: with SMTP id 22mr19080870pfn.188.1558797196209;
        Sat, 25 May 2019 08:13:16 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:540b:11a5:8181:7fba? ([2601:282:800:fd80:540b:11a5:8181:7fba])
        by smtp.googlemail.com with ESMTPSA id d14sm12348979pjc.29.2019.05.25.08.13.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 08:13:15 -0700 (PDT)
Subject: Re: [PATCH net-next] vrf: local route leaking
To:     George Wilkie <gwilkie@vyatta.att-mail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
Date:   Sat, 25 May 2019 09:13:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190525070924.GA1184@debian10.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/19 1:09 AM, George Wilkie wrote:
> 
> That was my initial thought, although it needs a 2nd lookup.
> The problem I hit though was I couldn't figure out how to make it work
> when leaking from global into a VRF. I couldn't see how to indicate
> a lookup in the global table.  Is there a way to do this?
> Using a loopback doesn't work, e.g. if 10.1.1.0/24 was on a global interface:
>    ip ro add vrf vrf-a 10.1.1.0/24 dev lo

That works for MPLS when you exit the LSP and deliver locally, so it
should work here as well. I'll take a look early next week.

> 
> It seemed if something new was needed, leaking the locals was neater approach?
> 

I would prefer to avoid it if possible. VRF route leaking for forwarding
does not have the second lookup and that is the primary use case. VRL
with local delivery is a 1-off use case and you could just easily argue
that the connection should not rely on the leaked route. ie., the
control plane is aware of both VRFs, and the userspace process could use
the VRF-B path.
