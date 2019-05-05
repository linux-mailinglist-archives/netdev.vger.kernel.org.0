Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A355141C0
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfEESOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:14:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40404 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEESOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:14:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so5180585plr.7
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lFVqGchoRPUGEbB9Lfzbqoukai2vLfPNNo5J+MPgv+4=;
        b=CL7exIvxfite/y7nsIm//x54Z4+Eyc7v4jkVzEDWKmmuDpRNzY5bQQ8FIfMeeIFX7+
         L5q724mx2JyoiHUfrOzwx0glWSryqGcYMSLq7PGONLasz8RxLm1CjFvGM4creJWP8aG3
         kSwf46ykKbb93v2dvEU3q27hUNabZXxU/go5lvFSisQKbA4rnJOn+4RCoVwdG4Nr6Uag
         QfgTSEW2cVqIylC6xYRPWLELSJTkTWBtPHUa+kiyvAd+9rbBTQWRTJ3j3jqOS7NJQzWe
         8vDzPAXgzr5DfxDps6zymYP1oJnkMiqEabMetlTV5qfrthhuv4KZqG93bW+29c3XawA6
         YlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lFVqGchoRPUGEbB9Lfzbqoukai2vLfPNNo5J+MPgv+4=;
        b=XcwQnREO2d2vJpBhLoltj3NHC2xV4eVN1Ok5zJr1FunspW3mGXNTH3BKtRHD/KU4s3
         9geu5Et2C7I7Cuf2kFhXWmRzayToytTlOfOXCPA78vTyrnHmZxF1dn9rE72EF8Eu7AH+
         OOl5m9GVa3I5x5Jt4nnXUhV5jm0+pFi9f6yNw/Y8yQV6kCBxQNsXXGZWe+GdQzkU5c4h
         43LUD5aJb5cB0Z96cAc8cCmnQ/ltltq2eQyLxD/IaI0RAQOd8+8tStdb0tESttQIXQF7
         8o4feNxKamVOmIkPBd4O+KAGwX+af3cMrQ55bz4blfhe13oHq+awCcxgdRP4+UVM0gKD
         YFSQ==
X-Gm-Message-State: APjAAAW6RFBNqPaoEajrRGvhAlGmo6bEhG4F/X5R6M+QkQaKxJWfb/Yi
        qJIQ5FIWoXUMrdneuoi08ec=
X-Google-Smtp-Source: APXvYqzF2V0zqjx0envQf+Iip7rno8+GTakncEjOVAvs2QghrgiETqbaLlQwZHzlXjiMwgAtjL5Fnw==
X-Received: by 2002:a17:902:8d83:: with SMTP id v3mr26966185plo.283.1557080070158;
        Sun, 05 May 2019 11:14:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id w190sm12205323pfb.101.2019.05.05.11.14.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:14:28 -0700 (PDT)
Subject: Re: [Patch net-next v2] sch_htb: redefine htb qdisc overlimits
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <20190504184342.1094-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <10635059-e5a2-5c72-fdad-0f26e041f73d@gmail.com>
Date:   Sun, 5 May 2019 11:14:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504184342.1094-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 2:43 PM, Cong Wang wrote:
> In commit 3c75f6ee139d ("net_sched: sch_htb: add per class overlimits counter")
> we added an overlimits counter for each HTB class which could
> properly reflect how many times we use up all the bandwidth
> on each class. However, the overlimits counter in HTB qdisc
> does not, it is way bigger than the sum of each HTB class.
> In fact, this qdisc overlimits counter increases when we have
> no skb to dequeue, which happens more often than we run out of
> bandwidth.
> 
> It makes more sense to make this qdisc overlimits counter just
> be a sum of each HTB class, in case people still get confused.
> 
> I have verified this patch with one single HTB class, where HTB
> qdisc counters now always match HTB class counters as expected.
> 
> Eric suggested we could fold this field into 'direct_pkts' as
> we only use its 32bit on 64bit CPU, this saves one cache line.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

