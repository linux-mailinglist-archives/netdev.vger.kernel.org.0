Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B15A7C36
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfIDHAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:00:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46739 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfIDHAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:00:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so4763436pfg.13;
        Wed, 04 Sep 2019 00:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0jgAF8J58aWl0sjFxiXtsOlB308+Q67iE1jg4iTF8/A=;
        b=c0ktxI2d6mLipekS0Gyb/pF9PPPM9kTMCdtTBrqZBmBoxhFgDHL83YHdISem/zmndi
         fBr3HDDmvC8mM9PrN+jNEE/b7TQdwSH6nFsLgKiypVevSXBsgFhioq5L0YuMud4RK9pq
         rLzDgafT+CKTGnz2+oMYSHtS7Chx2y3X0aA1JZL8qd7BfgqkpDHTKc6xfogU+w8mxAv+
         ohessldjc/M4d0bn7Bvpz/dEzgLdiH7/QoPXMumNToUidXiX0sVXd9Vcxp7cA+reoZ3g
         v9Egr9JYvBeb7/D3e4X9Qc0yZDXmzMwBo25ujSNXQKfiTjsmYQegHGBR+0qQJpSb1YVX
         PByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0jgAF8J58aWl0sjFxiXtsOlB308+Q67iE1jg4iTF8/A=;
        b=Vp/xCK4HmbdbP5XYhbEFbXwCBJEOJ7PoSH3hZoGQzWBah4d0BqT8IYW8+gGCBlcXbe
         JdcUyEGY3wXUX0elpRkoU8j0fsNjw2gSzI5n5CpNG4bZ/7pFDFvgb3uST3hDbVT9BotO
         M8QT5iX09UZofu1k/1Sr+Yn9BApVq3WcA32asA6Zb88B4eaE+tKnoVKR+2H697Ua9nTd
         4o8mwdypsC9hAxKAF40d2GfyyUB/6DfSt15s+CASnUQRB9mfQ87UO8QGKpDZqFGtglyp
         16t8lgj1810nUIjRpQolCD0trKjsAyDtnpzonBAntumx/YSDeluKjB9LMe6UvAwYOvxj
         ETjQ==
X-Gm-Message-State: APjAAAWp2GqfGQ6r45VfEAJ56L8Jd0m8KMzSzAqEuobejRwDv+j6j2oB
        WG95KOelgG/XwSH9+jo0IIQ=
X-Google-Smtp-Source: APXvYqwzHahC/ZrTpolUl6fKkmnQKYzORYyELnj9JSN1bbSC7s7LQjrvvGR6/yrUpDLjvrNjP3jOyg==
X-Received: by 2002:a62:7790:: with SMTP id s138mr42802476pfc.243.1567580447147;
        Wed, 04 Sep 2019 00:00:47 -0700 (PDT)
Received: from localhost ([175.223.23.37])
        by smtp.gmail.com with ESMTPSA id v20sm18223934pfm.63.2019.09.04.00.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 00:00:46 -0700 (PDT)
Date:   Wed, 4 Sep 2019 16:00:42 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904070042.GA11968@jagdpanzerIV>
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904064144.GA5487@jagdpanzerIV>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 15:41), Sergey Senozhatsky wrote:
> But the thing is different in case of dump_stack() + show_mem() +
> some other output. Because now we ratelimit not a single printk() line,
> but hundreds of them. The ratelimit becomes - 10 * $$$ lines in 5 seconds
> (IOW, now we talk about thousands of lines).

And on devices with slow serial consoles this can be somewhat close to
"no ratelimit". *Suppose* that warn_alloc() adds 700 lines each time.
Within 5 seconds we can call warn_alloc() 10 times, which will add 7000
lines to the logbuf. If printk() can evict only 6000 lines in 5 seconds
then we have a growing number of pending logbuf messages.

	-ss
