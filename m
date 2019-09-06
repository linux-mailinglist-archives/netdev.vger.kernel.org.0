Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF8AAB12E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 05:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404441AbfIFDjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 23:39:06 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37560 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392155AbfIFDjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 23:39:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id b10so2436492plr.4;
        Thu, 05 Sep 2019 20:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PXYF1M03RrcZFiPVCr+oafxI5KwHAQlJ1LzSSGxpPe0=;
        b=Q21vkhzuAlNVXS4iv5SGd/V6DPV1QKXyuezlpF/KupK8aco7bH8L6xFRe+3rzjhuIi
         LAAgTEASWHEHYVoAj7FVyFx3Xp5PZbquc6w1OkYAtwZ31L53Gw7JXTOe8GkX29sSmyjV
         NqjvYJ/6KjMr5tH9UVt7rQsEBIztiZMRWNJ+YYvVx2fp9XRuNC/ZzQX2uySLo8ZgybfR
         GJGLOSv0jY6mSzp91+tHXpjAgj9SSldX+EL6SzTMQdjoT8/KD5f31faQ7+RyIc/SPXp6
         /32KsQdGPtu1HZwBEeCpce7NjL4p+ZDjPUPLNPaKFefZuIpcg1hxseD8csAyztj6AZPM
         R4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PXYF1M03RrcZFiPVCr+oafxI5KwHAQlJ1LzSSGxpPe0=;
        b=KFjEmvV0PE6sLGmE3TzJcVADHJWUxvkp24P6MFU0P2NNZrZWG60gXOUWHSDTdzT64L
         vpdJxNtxff9Gict5x/8JOyp7NXNVIC4WUSUbmHdS3UdXjRINJTbQ1R3AY/28PKN8cajo
         WnlP3LiA7JN03KpN1nPZDXqCgJ+EqJw3qO/z7Y4TjVG+25L3a6P4tJReGFYQQaxsnOZO
         j2rWD2MzOIoW9Q76kRkW4bwZBvjqsST1jxuKGiQA6AsLo5YGoCvwyxNN12NjKCG6Qwh1
         LKRnAGzuF50BEuTMYX9LDEnYx1ifToPmv+GPFkASd3TDw3YpeUEG3jIJnAvrbv0JHL6/
         L3mg==
X-Gm-Message-State: APjAAAXVfXJZ0w63jQpfgWtINdcuhVkyXLBPUbceCD74/3oMcpy5zs8p
        LPn6hXdld2VkHTIZ8r51/7WHe5QR
X-Google-Smtp-Source: APXvYqzgmhLuIsIaUW3PQSBJiLj2kLVGPu55mYjmZmnUcycRvpUbGvdC1nBjLxYMCIJYaHa9rSMSYA==
X-Received: by 2002:a17:902:4381:: with SMTP id j1mr6842157pld.318.1567741145109;
        Thu, 05 Sep 2019 20:39:05 -0700 (PDT)
Received: from localhost ([175.223.27.235])
        by smtp.gmail.com with ESMTPSA id i6sm9072040pfq.20.2019.09.05.20.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 20:39:03 -0700 (PDT)
Date:   Fri, 6 Sep 2019 12:39:00 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906033900.GB1253@jagdpanzerIV>
References: <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <20190905132334.52b13d95@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905132334.52b13d95@oasis.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/05/19 13:23), Steven Rostedt wrote:
> > I think we can queue significantly much less irq_work-s from printk().
> > 
> > Petr, Steven, what do you think?

[..]
> I mean, really, do we need to keep calling wake up if it
> probably never even executed?

I guess ratelimiting you are talking about ("if it probably never even
executed") would be to check if we have already called wake up on the
log_wait ->head. For that we need to, at least, take log_wait spin_lock
and check that ->head is still in TASK_INTERRUPTIBLE; which is (quite,
but not exactly) close to what wake_up_interruptible() does - it doesn't
wake up the same task twice, it bails out on `p->state & state' check.

Or did I miss something?

	-ss
