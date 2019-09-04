Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9FA7CF2
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfIDHnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:43:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39829 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDHnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:43:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id bd8so2868080plb.6;
        Wed, 04 Sep 2019 00:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qj+DAxsSIX3ZqKCcNj9WFrsINQyctNKm0DapU8GePMg=;
        b=lCya9oPWLL6Z2sCvMqFx61guCAYb06hPqKEzeto7EkIbJJkzeWfSzu7uAmnoTtP8ml
         xwSSllg+7Cg/uFNKX3vW16GYIPDhCkAmstIR4IRc7GPm9D3jCJl1sgbuWkmzesSTQa1k
         VJyOgK5+Mv7W53iq0EhizOvaAZvrpzkaEotfxKWSziTRO3SQwvKiakik9sZQSga92v12
         CF8lOSfMAKCJw8Qxi7kpK3/tCDkU3CULfpbAp+Lj3IGZp+WZtzlPfFHzYLA1zDI9nhXY
         hxsUV472mag4UDl6Vv5Go5942fXu/+UV8xMWd9JR43SMVyF30BYgkHYkcg/JrLxHLCR7
         mUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qj+DAxsSIX3ZqKCcNj9WFrsINQyctNKm0DapU8GePMg=;
        b=fl5WoNzprwaFMwDohNLAX4kGjzktXPhNFP/9IYnyPT8xhBt7Pj4aYj5BVqoN0K/uHq
         JlMktfuZM0BUpWyVRMEG6/9BLbetsIG6PUYPBfOryhb9b8WEk8oZdwZTe9fvhCwsm33M
         P4vXYiC/Qf40xtpeueTkuWMIClO7Q2bcNJmJJRnAzS/s+3f71b5LHlm0qHY2moHdhb+9
         AUNw/jEz0221gKVnDWYfDXYxPJOP3Z25s3jXbXlk4MMmblXAZtIGssxcGjHOjtS/Vnjv
         /8ce1QVridC85kmELe6aDNwK5oLmXqzawo+26JLuARVMOI6zI/EERH7ocyBHXJX/QSC3
         LQGg==
X-Gm-Message-State: APjAAAV+McYaoy/UQ4hRn2dkblOqi7wW4QlYFXqhhS/oA1pNEVFSqX1T
        pm0pybJpUQcnZUINYu5a9qc=
X-Google-Smtp-Source: APXvYqwf8YuF18rL+t+nFsRll+w6Tgkdib8E7Z6IJLldxGfK/Upkt0ST6okY6POe2h+lSN5PdkHtzw==
X-Received: by 2002:a17:902:6b88:: with SMTP id p8mr38148119plk.95.1567582996648;
        Wed, 04 Sep 2019 00:43:16 -0700 (PDT)
Received: from localhost ([175.223.23.37])
        by smtp.gmail.com with ESMTPSA id c6sm14214884pgd.66.2019.09.04.00.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 00:43:15 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:43:12 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904074312.GA25744@jagdpanzerIV>
References: <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904071911.GB11968@jagdpanzerIV>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 16:19), Sergey Senozhatsky wrote:
> Hmm. I need to look at this more... wake_up_klogd() queues work only once
> on particular CPU: irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
> 
> bool irq_work_queue()
> {
> 	/* Only queue if not already pending */
> 	if (!irq_work_claim(work))
> 		return false;
> 
> 	 __irq_work_queue_local(work);
> }

Plus one more check - waitqueue_active(&log_wait). printk() adds
pending irq_work only if there is a user-space process sleeping on
log_wait and irq_work is not already scheduled. If the syslog is
active or there is noone to wakeup then we don't queue irq_work.

	-ss
