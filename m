Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04FEAB0BB
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 04:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392033AbfIFCu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 22:50:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42095 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391203AbfIFCu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 22:50:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id w22so3288162pfi.9;
        Thu, 05 Sep 2019 19:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VgjVGE6lmfxhygBnBRcl9Vrz9pus5n253xhtFVc0NKA=;
        b=o68BclrxtpBqJvfD6tSNsOFflIRQ/l2ADb5wWCZzJFChRYr6SktchPaV1FNPE8jsaq
         nS1tdR7qtKYNTi4a95CJW5tOvBGQ7Az5OmBlRAbJMVp07NepKODC2NDEf+Ke3OkPiZtC
         KzMfZec26XSCrNPUxtNQrTVXVUTZeiWr6w8RNxY/5Bj06hPLduV6m0ZKbpAjoQTXOInB
         KRt5CgZJvv1kLuUgv6j223ouAe8bcR1pi8/KUnaLSenkuN0huOyjSav85wLh2Pr2572F
         peq8dLUF4fxx1mxfUxzUF5Y0N/bMi21gt2QnIFhHhYV253NTJ4WRSOFj0dFwKnnrXfo/
         zuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VgjVGE6lmfxhygBnBRcl9Vrz9pus5n253xhtFVc0NKA=;
        b=tqwVi4TlVAT7g0CRv017P6U+RjvwanZ6/Jd0U6qTPKqY6HsePXh0fezkpt8yQg+2Vw
         V8oH0sM1OVt5fO0jHvbhHdOzodbDmO7xNkOPwiMszpZzVPA6Hx4Gfeq0TYRNxNWs5yRN
         0j7BHTYVcs9wtdmpal3qrKDHpkcKDMOxC6ZiW83LTlFWB75iPfBhNu4cEWS3bWu0s5OD
         XjvOWMeiYK6/xY/83z/UtVAHp8SONAlxUGS1wSLgr0H7mjl58E1+DnGeZIt1ThlZAUf6
         baWJ+u2GDyFpN8j39s3p1qrjPjHj4ahuI+EvnTbt8OUuHDmQMlK7Wvsx+ENTZ4Vv8g36
         WpCw==
X-Gm-Message-State: APjAAAXaXwLnK/Vd+SL98nnjZdSBXdFNWWqA2CxRkNgzIE/5bwe6Lh4x
        6rQyUcz5Oo4enP1bZBr6T74=
X-Google-Smtp-Source: APXvYqyh56I11YbI0Ls757lx16cnPwBBUbXbnLk+XuviLZKkM437vuzYWKlS3jQNm4KSJM77TTynwA==
X-Received: by 2002:a17:90a:2e15:: with SMTP id q21mr7246465pjd.97.1567738226815;
        Thu, 05 Sep 2019 19:50:26 -0700 (PDT)
Received: from localhost ([175.223.27.235])
        by smtp.gmail.com with ESMTPSA id p68sm8147568pfp.9.2019.09.05.19.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 19:50:25 -0700 (PDT)
Date:   Fri, 6 Sep 2019 11:50:22 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Qian Cai <cai@lca.pw>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906025022.GA1253@jagdpanzerIV>
References: <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1567699393.5576.96.camel@lca.pw>
 <20190905131413.0aa4e4f1@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905131413.0aa4e4f1@oasis.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/05/19 13:14), Steven Rostedt wrote:
> > Hmm, from the article,
> > 
> > https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
> > 
> > "Since transmission of a single or multiple characters may take a long time
> > relative to CPU speeds, a UART maintains a flag showing busy status so that the
> > host system knows if there is at least one character in the transmit buffer or
> > shift register; "ready for next character(s)" may also be signaled with an
> > interrupt."
> 
> I'm pretty sure all serial consoles do a busy loop on the UART and not
> use interrupts to notify when it's available.

Yes. Besides, we call console drivers with local IRQs disabled.

	-ss
