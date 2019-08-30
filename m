Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1DDA3A10
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfH3PMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:12:02 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36478 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3PMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:12:01 -0400
Received: by mail-wr1-f45.google.com with SMTP id y19so7355335wrd.3;
        Fri, 30 Aug 2019 08:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=76/UUed01Y3Y8i/aDowNMkQyy3LjmrVlq62x46O+5HI=;
        b=B0Mtxovh7YJ1xZ64U7SiGekZ9o7RHn1C7kzg4weTyPz+1pkpuPjKUVgY8eY5lVYl9K
         1S2+Z8UC8ZqTjtRFrfs9dnjTkEHQ/jZ13wgyzCCDCd7LBw+leUHYVLUPX5nTew6aZedz
         VwQWtr3NeciSNUMC69YBebngNsOpYL2Ha3bz8IYfAB91TUQyd/E5LC20BK8ghQZ82IGO
         x5HdFpGbpa+yvnKS5TBBj1ed6fr++5lxlFQ7N+0nnkILxUuQL4soAXP0u2WhLJHsuLi3
         C7Fv/QuxM3LVzCFX/s3ankIJGLWRkQZo/APO6QBQezDPGzVoCdm1yO+t9ZlkOkxzAo0o
         +M2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=76/UUed01Y3Y8i/aDowNMkQyy3LjmrVlq62x46O+5HI=;
        b=Rw53OwmwE+GNKDpPIDqx1rrQIOgBzt01qh7RF4LMHj6gzxWbipFZCNcd1EWUDbhmLx
         pp56RtkR39V4NXp6KcESrmsAhyCxTfrHjw8l3hdeEccsZ8jOra5WiydEMAWjh3c6EQAG
         oSFgk2NyLlogQBI4/qMlADFtGbatQsEC4CLdWW80JRuw/rso1mIIDqDpRjpljhsmVB9S
         6KlVrr2+HuMaxyMQj4t9QRcBPKSnZoZbZhevyn5ykDTVQZRGjA43k2Xl7l1u8dJFU6Yl
         sUU0iSV+pStkj6PEFCmKzPnxa8OsCQq7r38FE9jlwb06yI7x9Nux+QMSfBdgshsy3aY3
         zhMw==
X-Gm-Message-State: APjAAAVIvahWxmDlOVb5IISZAEx5GXxO/b0dfxV2b6iz2+wqzzq/fP3P
        0GSRhtCfh8YrVtzy+dcyPEdsZ60I
X-Google-Smtp-Source: APXvYqzKBXu6wZXLHUG8+KW0xkXVfuQI1179U3Ts3qO5WmEIh6+JXMocNScNDvnxocLwtNECOiHZ4A==
X-Received: by 2002:adf:e846:: with SMTP id d6mr19068750wrn.263.1567177919401;
        Fri, 30 Aug 2019 08:11:59 -0700 (PDT)
Received: from [192.168.8.147] (95.168.185.81.rev.sfr.net. [81.185.168.95])
        by smtp.gmail.com with ESMTPSA id d69sm5515728wmd.4.2019.08.30.08.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:11:58 -0700 (PDT)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
Date:   Fri, 30 Aug 2019 17:11:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567177025-11016-1-git-send-email-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/19 4:57 PM, Qian Cai wrote:
> When running heavy memory pressure workloads, the system is throwing
> endless warnings below due to the allocation could fail from
> __build_skb(), and the volume of this call could be huge which may
> generate a lot of serial console output and cosumes all CPUs as
> warn_alloc() could be expensive by calling dump_stack() and then
> show_mem().
> 
> Fix it by silencing the warning in this call site. Also, it seems
> unnecessary to even print a warning at all if the allocation failed in
> __build_skb(), as it may just retransmit the packet and retry.
> 

Same patches are showing up there and there from time to time.

Why is this particular spot interesting, against all others not adding __GFP_NOWARN ?

Are we going to have hundred of patches adding __GFP_NOWARN at various points,
or should we get something generic to not flood the syslog in case of memory pressure ?

