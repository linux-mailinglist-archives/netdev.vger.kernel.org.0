Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0961F7872E
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfG2IS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:18:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51438 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbfG2IS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:18:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so52962321wma.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 01:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vHj9NXahSs6iR8Pg+ItC8iS4CBlK8AvLVaxPXNIpuUE=;
        b=xQbnXKF8Y7E+t8j+NkUBwqn2H5QphW/cVaobSbrgpsuHm+4EWO6RX6IzN8M9D2M0RQ
         vYwnuc6bMkTf84yGvMP1JgFPoid5mCkowMdZ0MyW+RKWpJK+zwB5LDHuqYVYyanjhzeG
         3I6WqlRd/fPf8gz1MbhF0/UTB8oYe5Sl/8a2HSb7zJCPnHHzaQD9dQ6Z4oTAh5T6dO9+
         TlIom4yR5AXhYb0+X3LgWDYmbq6JXjeHA7Wh4WugIU+K4wQA2ZnvlBHKa9Eb1K/d1Xn6
         eOl5U8Bia8RTUj8iYkhItoD7RiAgYAJF8pT45eS4sWxouG63GTqtIRrWxJswCz0h91o0
         R5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vHj9NXahSs6iR8Pg+ItC8iS4CBlK8AvLVaxPXNIpuUE=;
        b=jyf260AQKc0wx4/+tR5zXpTfvsn8xU128uyIGnammvGa1lldYdpTnIbM3Z0zXW+RAm
         qhEXRVWBvVMutZXMazGe5XaBaOCJVQs6JEPPvw23Y8irm+7TI4TGjMZoeBaktreA9c9j
         useprrlbnGMZRTL92b70Ip04tbTGycgEsvsExnUNX8JGtOVuRAj59H5b/XUjMAXeKb2x
         Nx5ct0s0mDP/jfDNLgvwnsuQGBe/LgXbbcIzJypD3QEks7cTfHpE5LLEVc3Z35kx4CV/
         WuMA1CKngPuB2hVWiurdqYlh9aD/4MJJeFIBxxmagdIPPbWKzlGxnTxa6f23pu75hRt2
         cUSg==
X-Gm-Message-State: APjAAAUnMT1y16t+j2Cdj6dQteYY4UCDb/wCj82E5LFF4DURefKrV8cu
        eZCwAAQXRe29xP2F0MbykmI=
X-Google-Smtp-Source: APXvYqwmY7Gie5+Musllq20iA/vpGOeb+HpfY7d6X5o963I1/ONCZZ3wYid5aigxUN7L3tNQhUWdSA==
X-Received: by 2002:a1c:1bd7:: with SMTP id b206mr95120334wmb.85.1564388336079;
        Mon, 29 Jul 2019 01:18:56 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id f12sm66058989wrg.5.2019.07.29.01.18.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 01:18:55 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:18:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sched: Fix a possible null-pointer dereference
 in dequeue_func()
Message-ID: <20190729081854.GC2211@nanopsycho>
References: <20190729080018.28678-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729080018.28678-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 10:00:18AM CEST, baijiaju1990@gmail.com wrote:
>In dequeue_func(), there is an if statement on line 74 to check whether
>skb is NULL:
>    if (skb)
>
>When skb is NULL, it is used on line 77:
>    prefetch(&skb->end);
>
>Thus, a possible null-pointer dereference may occur.
>
>To fix this bug, skb->end is used when skb is not NULL.
>
>This bug is found by a static analysis tool STCheck written by us.
>
>Fixes: 79bdc4c862af ("codel: generalize the implementation")

Looks like this is something being there since the beginning:
commit 76e3cc126bb223013a6b9a0e2a51238d1ef2e409
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu May 10 07:51:25 2012 +0000

    codel: Controlled Delay AQM


Please adjust "Fixes:".

The fix itself looks fine to me.
Reviewed-by: Jiri Pirko <jiri@mellanox.com>



>Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>---
>v2:
>* Add a fix tag.
>  Thank Jiri Pirko for helpful advice.
>
>---
> net/sched/sch_codel.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
>index 25ef172c23df..30169b3adbbb 100644
>--- a/net/sched/sch_codel.c
>+++ b/net/sched/sch_codel.c
>@@ -71,10 +71,10 @@ static struct sk_buff *dequeue_func(struct codel_vars *vars, void *ctx)
> 	struct Qdisc *sch = ctx;
> 	struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
> 
>-	if (skb)
>+	if (skb) {
> 		sch->qstats.backlog -= qdisc_pkt_len(skb);
>-
>-	prefetch(&skb->end); /* we'll need skb_shinfo() */
>+		prefetch(&skb->end); /* we'll need skb_shinfo() */
>+	}
> 	return skb;
> }
> 
>-- 
>2.17.0
>
