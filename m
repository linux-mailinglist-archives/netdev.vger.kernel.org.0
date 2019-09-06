Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8D1AB1AB
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 06:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfIFEca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 00:32:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36337 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfIFEc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 00:32:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so3482837pfr.3;
        Thu, 05 Sep 2019 21:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=/FnnT+XGY6LiCYmK28My012gZf6Sb+2aTvY99K4lAnU=;
        b=Q3BuF2fBnREwoZv5O0AULfEwU50686QrzaKhLHMbWisLQZzidLcHnWw7inOhq+X5d0
         A7knkkQ3nLa7oS8l1UsfvfKguV8y5dLyN1LfgryRRtb3GWx6t4b8WXdkq3QbZUbh+70i
         BxNMcc5vP4B3FudQvzW0CJLc/VZEYAvqa2DXFt89TaP8Hw1i+W3BnmPyWO0M7A3wFSvH
         nhkXpPqf1fDndZZZQkIMX9cgFVSpB5beYnftiuo3f2HCETrBTme40co3jJXniSJmbrdG
         s1+UqzUA1KIPC7d3657NGcX5QQTDBTnN6ABFTeuGkvx8XadIGA4C1F//o59yUrr5Rx10
         vAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/FnnT+XGY6LiCYmK28My012gZf6Sb+2aTvY99K4lAnU=;
        b=c6PROcx6FQDZp/Fx2WAW/7oyyxU9NY53qj4dve4NrjNV/tx6gomIWiNeWseFQHQBmF
         fZ6dx1o8d10EtehNPzgOcxwnd+7BRF1xVnbJd5fGlXefBLK5hyjth9PwB0Ke7Mmb6i1W
         bNWr0n8O+XAdlU2T1SWidnVnpeqkz7uMgdHXg5/RGhthxPTPxp6obNSYzQjhQhLg3hWB
         Q/yxGQ/PM1N2Dg7AjIWqrHCMo3neC6dwEGOzGWyzW8ZsDS9nGfRUg8fD6jQYcES1qWbw
         J2+Nwy0FP66F623Fx9GXP+kSjXCbb53fH5B1VvAz782hNtF5sJpfb1OTPAi67zXyF3QN
         V5Tg==
X-Gm-Message-State: APjAAAWcv9bA1qBrG3TPkSZ1ww9zVkI8RShAlLhsHJRuzZP87dXETOiV
        OVri0no3FPpZLU/cEJ0dyLA=
X-Google-Smtp-Source: APXvYqxc2uuv0Y76XwL+zuFYgZvhJZ59EpeDPE8ua3TPxZjuvmHYXMQb7gErTzcoocI8nf9EL8w66A==
X-Received: by 2002:a63:e901:: with SMTP id i1mr6181363pgh.451.1567744349121;
        Thu, 05 Sep 2019 21:32:29 -0700 (PDT)
Received: from localhost ([175.223.27.235])
        by smtp.gmail.com with ESMTPSA id w13sm4344619pfi.30.2019.09.05.21.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 21:32:28 -0700 (PDT)
Date:   Fri, 6 Sep 2019 13:32:24 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190906043224.GA18163@jagdpanzerIV>
References: <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
 <20190905113208.GA521@jagdpanzerIV>
 <1567699393.5576.96.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1567699393.5576.96.camel@lca.pw>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/05/19 12:03), Qian Cai wrote:
> > ---
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index cd51aa7d08a9..89cb47882254 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	pending_output = (curr_log_seq != log_next_seq);
> >  	logbuf_unlock_irqrestore(flags);
> >  
> > +	if (!pending_output)
> > +		return printed_len;
> > +
> >  	/* If called from the scheduler, we can not call up(). */
> > -	if (!in_sched && pending_output) {
> > +	if (!in_sched) {
> >  		/*
> >  		 * Disable preemption to avoid being preempted while holding
> >  		 * console_sem which would prevent anyone from printing to
> > @@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  		if (console_trylock_spinning())
> >  			console_unlock();
> >  		preempt_enable();
> > -	}
> >  
> > -	if (pending_output)
> > +		wake_up_interruptible(&log_wait);
> > +	} else {
> >  		wake_up_klogd();
> > +	}
> >  	return printed_len;
> >  }
> >  EXPORT_SYMBOL(vprintk_emit);
> > ---

Qian Cai, any chance you can test that patch?

	-ss
