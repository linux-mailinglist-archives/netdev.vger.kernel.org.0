Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A947378594
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 08:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfG2G4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 02:56:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41553 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfG2G4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 02:56:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so57289503wrm.8
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 23:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=77kBMlKTAenEQAkiXPo05Wm16zYsJQ8LVBsU59Q9oVA=;
        b=pPD/sBPWrxLVysfk2Ps6tNucGWwJlCOr6XR//BG7RR8oyJv9v2k0wFNw+aXtAtsXYm
         luzVZfhEqo8WA7WT/fSQnZtLwComZEEyj8mBmG+fymQinBJIgbaFF7evSjaTfz2+9Jol
         2kUHUh75XX13bm33it4tEGzQXVUJxh83BJ/xYgTjF4zu0Ddf23BiggfphU3EaRAJctJM
         Bh+an0KVkI7Z0NnC+O2OUljKfZ26Iq8iDoRE6D8JEdsKtNDEeVU2Mh0cLcsxyhaZW5SH
         2HmMkqHzIIN65y/5FRFy5MVWQsGTiAc5O+XD9DHQPA+sFP7xWlzl0Jkw0UevTMw/Mxm0
         fX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=77kBMlKTAenEQAkiXPo05Wm16zYsJQ8LVBsU59Q9oVA=;
        b=aJ2iqkKS/TYLHK49K+pNii4/JhFgUR6P+MkESIYFqAdXRbwYvt7B53UR+4+kRD1K+x
         yatEzRtOPE1LKUf2mmytrpoJFig/IFBip81Wsjluz0V+B8LYW3GzMuyuHDdrltKIuqL+
         Wca1TnopQbrKeKHvDAoLGG0j8EuUhtPy5voo698FldsY9xGU4CpTWcBgxMRwr6igw9TC
         +IkWBn7opBo/GRY5rNQQhifZXUaQEko8Vt3cHRppJqKFW1SG+GPc40HraTl6OTtAhBDM
         grFZ0Dk8d96EQV7ApsgWG+0txYg0Bh8IdRCyQvB3k7GWStgAQHhf64ITagv7fMwe000m
         4aKg==
X-Gm-Message-State: APjAAAXDULVO2URKHunGHlzSm9ha/KjKUsYzLTvi5dOAYD5GJADu4d3b
        odvJHnJd9rBM/+YgA0+rtyc=
X-Google-Smtp-Source: APXvYqwltHE9iEWxKnbbh87k8UY3j+nd3lsQOuNtcbriLQ+0SNoXQVr2iH8MQnAoJMCtZAHoz6/ZDg==
X-Received: by 2002:adf:fd08:: with SMTP id e8mr122286409wrr.147.1564383414116;
        Sun, 28 Jul 2019 23:56:54 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id e7sm54869909wmd.0.2019.07.28.23.56.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 23:56:53 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:56:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: Fix a possible null-pointer dereference in
 dequeue_func()
Message-ID: <20190729065653.GA2211@nanopsycho>
References: <20190729022157.18090-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729022157.18090-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 29, 2019 at 04:21:57AM CEST, baijiaju1990@gmail.com wrote:
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
>Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Fixes tag, please?


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
