Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76F0235437
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 21:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgHATsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 15:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgHATst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 15:48:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D252FC06174A;
        Sat,  1 Aug 2020 12:48:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g19so6306634plq.0;
        Sat, 01 Aug 2020 12:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D/zKsPT50/brRt6TQ94qvPI8VW7jt5RqidXgO91dbKA=;
        b=cxXfQUbdWAv5Q1PSHtTmYyxr4TWeAH2VpZs7yypxRFxoctSqlLGqImL3/wJeRI12SP
         9jbrwT1oRJSvTo1cxVm8JCLGKMn7uk5KWjYBnS7pE1IvV9jSsl/xS7XwWXP0Xs1DuIe2
         wD358QjSfLvbk5nq/ND1+Jen8VIKBNTOMhkVP3314bv+0TAf3+MjWWHSYlDPzUJtf0xC
         po7jVaP3lakpIkxsnqw9NbhGx56vxinDxhwEWADfqMgdgOek8KHSr2+aCp4Az+ioByS1
         cYVspwvAEByNv+oC8uBj/CSSh2usnS4RJ6ibkM3z1Ndwt7/xTo3sLq/vLJbsvL4k5iHb
         gc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D/zKsPT50/brRt6TQ94qvPI8VW7jt5RqidXgO91dbKA=;
        b=t+XtR1cTQ1RHKU7a5LkbS5YgF/uveafTqtmpa3J3q4vxCpKPtYHGlWaxp7lqjlK5wj
         PoIMSCKIdT+LOcIYM+99zCJUFTC8xDWlKXkALVw8NJq+EDoAxnbsw1IBigMFGK398C/b
         vxCccLbuiIwVnUvcMwcpn1969JIyf0ITGyqRyJbwl2aYUu9wF4yprhLbbJ7tx5xnnMZB
         Ro2lY/f09H9WlWgM+cDLUS1wpoetWwMgAGykXfZ9O4jAiPLhUjGO/kvg8sbXJG4tJXgM
         JPqsFdPrKqunzrOyp+qNkC1dW8cU9Jx2F9lqWGVeLtsVbyOh8+gFtOq03GDv0GkkO8w8
         q+0g==
X-Gm-Message-State: AOAM532BMZuouSMKvd+9jtCom2fogPJCw9/A8Wk+xJAZL9FSXYm6nKq5
        KDUQaPTldJvhi1k7bY2WfO8=
X-Google-Smtp-Source: ABdhPJyZmsSRAtwKHUgKvrRVZquGxxpXMiTCw6T+Na+Re7YXxks6NrlDC9q5U48690eyjt3T1ajvjw==
X-Received: by 2002:a17:90a:5208:: with SMTP id v8mr10250476pjh.29.1596311329344;
        Sat, 01 Aug 2020 12:48:49 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:65b5])
        by smtp.gmail.com with ESMTPSA id u66sm14834950pfb.191.2020.08.01.12.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 12:48:48 -0700 (PDT)
Date:   Sat, 1 Aug 2020 12:48:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Christoph Hellwig <hch@lst.de>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Rodrigo Madera <rodrigo.madera@gmail.com>
Subject: Re: [PATCH net] net/bpfilter: initialize pos in
 __bpfilter_process_sockopt
Message-ID: <20200801194846.dxmvg5fmg67nuhwy@ast-mbp.dhcp.thefacebook.com>
References: <20200730160900.187157-1-hch@lst.de>
 <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
 <03954b8f-0db7-427b-cfd6-7146da9b5466@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03954b8f-0db7-427b-cfd6-7146da9b5466@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 02:07:42AM +0200, Daniel Borkmann wrote:
> On 7/30/20 6:13 PM, Christian Brauner wrote:
> > On Thu, Jul 30, 2020 at 06:09:00PM +0200, Christoph Hellwig wrote:
> > > __bpfilter_process_sockopt never initialized the pos variable passed to
> > > the pipe write.  This has been mostly harmless in the past as pipes
> > > ignore the offset, but the switch to kernel_write no verified the
> > 
> > s/no/now/
> > 
> > > position, which can lead to a failure depending on the exact stack
> > > initialization patter.  Initialize the variable to zero to make
> > 
> > s/patter/pattern/
> > 
> > > rw_verify_area happy.
> > > 
> > > Fixes: 6955a76fbcd5 ("bpfilter: switch to kernel_write")
> > > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Reported-by: Rodrigo Madera <rodrigo.madera@gmail.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Tested-by: Rodrigo Madera <rodrigo.madera@gmail.com>
> > > ---
> > 
> > Thanks for tracking this down, Christoph! This fixes the logging issue
> > for me.
> > Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Applied to bpf & fixed up the typos in the commit msg, thanks everyone!

Daniel,
why is it necessary in bpf tree?

I fixed it already in bpf-next in commit a4fa458950b4 ("bpfilter: Initialize pos variable")
two weeks ago...

