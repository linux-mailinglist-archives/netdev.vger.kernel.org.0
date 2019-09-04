Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52135A7C9B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfIDHTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:19:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42408 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfIDHTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:19:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so10720340pgb.9;
        Wed, 04 Sep 2019 00:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=n1xJLcKf6G7UK7Awxu+0eoxUIpLlcPu/xrtHp78aqKs=;
        b=kAd/S4ItI9NfrNpl4fV3Iwmom3OvfqoEARr0paqvmqdlwOatMUrX35wBFrH+vd34o9
         82skrRaOLz+25PCNJzD0/wanlpygzPg4D94SOqVmK/bwNXKcBwMzLSFKW/Q7F+IqqNDb
         16E+YzXxzTGFrevpw+oPQmLAZM5kPNxfjwalJJYMA1qL8+8uW5KPSkiQ0V/HgF3o6Y6l
         W8uRNNygMdlbhE5G9awFudVHh6GGQNxcMNKbrcxGnP3n5b+PlGCKUyHA563NZ3p0gEnD
         z6vvHdrJ3GcWZb2eNVn6uzYfAr6rYxjuAAO5N9Fmpg0ZwxTcXakFTj40FpBFWyIgOodq
         N3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=n1xJLcKf6G7UK7Awxu+0eoxUIpLlcPu/xrtHp78aqKs=;
        b=L+Ecjg3f4Pg0K0rtSQ7RbD2gT8I3DFPgzgtSLykD4tuK4evhSQI0RRQiAc64+9EhuU
         tdnuTYytVo6mSBgK6AN/4WQew42YLmDP0Jy9N6ce53I7dseZACmiJVxGIGXCI/bd4d7v
         dUQ9PIcDm3YFv+3kxgjU3646nMd1dIXD3l6wwKsDvm7CZsnrkWzu8RuMrd5+Zx9UQtw8
         WRUdJiK8FXvWNp8BACzayHxvbY+K++M2ALdzJVSkqxQp7Mpxn4ia8x8Z2WLskZv+BK1n
         tLSimpSI3k2A/tBD9+LXvk9Qj5/Wfw0JdWd/wMULAhQOKtIm21XO/RsPRSW1Ed2OXpzF
         kuNQ==
X-Gm-Message-State: APjAAAVOCaQULiHU7sJb11FeeDFEsnNy9i1cAmWjVcWv8hXDzue12k7K
        2ivOSs+BimYycRxUyFyc3dg=
X-Google-Smtp-Source: APXvYqzRaeXZEO+6LGaGeK4K4LMnx1yY/nhZrTQwTO0+RRnG1IFJHv+PBZ1wPsB7+32Gq0gbpGAb7Q==
X-Received: by 2002:a17:90a:8996:: with SMTP id v22mr3517563pjn.131.1567581555849;
        Wed, 04 Sep 2019 00:19:15 -0700 (PDT)
Received: from localhost ([175.223.23.37])
        by smtp.gmail.com with ESMTPSA id s5sm21619783pfm.97.2019.09.04.00.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 00:19:14 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:19:11 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904071911.GB11968@jagdpanzerIV>
References: <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904065455.GE3838@dhcp22.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 08:54), Michal Hocko wrote:
> I am sorry, I could have been more explicit when CCing you.

Oh, sorry! My bad!

> Sure the ratelimit is part of the problem. But I was more interested
> in the potential livelock (infinite loop) mentioned by Qian Cai. It
> is not important whether we generate one or more lines of output from
> the softirq context as long as the printk generates more irq processing
> which might end up doing the same. Is this really possible?

Hmm. I need to look at this more... wake_up_klogd() queues work only once
on particular CPU: irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));

bool irq_work_queue()
{
	/* Only queue if not already pending */
	if (!irq_work_claim(work))
		return false;

	 __irq_work_queue_local(work);
}

softirqs are processed in batches, right? The softirq batch can add XXXX
lines to printk logbuf, but there will be only one PRINTK_PENDING_WAKEUP
queued. Qian Cai mentioned that "net_rx_action softirqs again which are
plenty due to connected via ssh etc." so the proportion still seems to be
N:1 - we process N softirqs, add 1 printk irq_work.

But need to think more.
Interesting question.

	-ss
