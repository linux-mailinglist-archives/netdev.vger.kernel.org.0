Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD72BBBC9
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 20:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfIWSqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 14:46:24 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33699 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbfIWSqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 14:46:23 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so16590845qkb.0
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 11:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2cHf9VDIbI+X/zeqHiyzEC60gqW5IxwBdtZT5njA8vA=;
        b=f9gr9d+Dmw5rLfrgwNFomqzHgs51WAUPWo2ZnFJ/G9nWaCeKLphtFdcle7Izpwueo0
         jM0SO30DvxRtKs7O4dBB42m3ew1jWZdI64Oo76P5WxC5uhsEzljCQClCV87nB4tGdAzS
         l6SuRKoO9qi+nxuW00JX6S5jatvMZCpn8Qmwowg0OzGVC3Q28BBaJo0GD6gPnmf6h6AR
         fCzIjDOJcLDwIITFNyDDsltx3aPGTubopWffb30RhOuHh92nf+vvH+PLHgQBIPNPm0i3
         Rh+KNTpathykZo02CWw/IT/czPiwf9SQfqWR101vAZBLg8EbUUBlhUx2wkikgrYusGam
         xBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2cHf9VDIbI+X/zeqHiyzEC60gqW5IxwBdtZT5njA8vA=;
        b=AQrbvsk7IkZfynYraGkrFspc7p9v5FkjEvm0XLabdBiSyxk9r8pLJIFv5PGwi+iZxp
         uKVCBMI21lfJu6/2DsMzSb7iXYv3h26owglyb9maV3ijntFu3bNegY1PlwT0WIlsBpTw
         r4aGkJN72Ib8bsgP0c4s+FC+HzAWaHSyGd27efDDUb29Epo3k4Ulsszft3+b0SphzFBV
         et8yp0Nf4HFKR+DQ/3f9Cl/pPF6YCmvWCgluXxJmBrkCnL/s2LWFyBbyWnQYKoEqfPCJ
         g9r0j7lGM/WaOUup6r9jrdwEKsUk8aTxc3dpjC7ljv9m2sWTc6Q8SwK6fq7bn0BSDrEQ
         ONyg==
X-Gm-Message-State: APjAAAUgM8LWTX+IlObiNIjT/WdNJUy8nN9DC1Os/Q/5ZhkO1t3mVGoV
        3a/2OunQrHzUK559GEKcqbI=
X-Google-Smtp-Source: APXvYqyYgURXECkyZNbbAX5wx8oRl1i1fELFfVIUHc4UcxpHFNqvDJuQ/IQfvZjxaiOvZ5asmCQ0XQ==
X-Received: by 2002:a37:84c3:: with SMTP id g186mr1391603qkd.71.1569264382568;
        Mon, 23 Sep 2019 11:46:22 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:7026:d217:e8a5:4fa4:5b13])
        by smtp.gmail.com with ESMTPSA id 29sm6282478qkp.86.2019.09.23.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 11:46:21 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 34B0CC4A54; Mon, 23 Sep 2019 15:46:19 -0300 (-03)
Date:   Mon, 23 Sep 2019 15:46:19 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Paul Blakey <paulb@mellanox.com>, Pravin Shelar <pshelar@ovn.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: CONFIG_NET_TC_SKB_EXT
Message-ID: <20190923184619.GA3498@localhost.localdomain>
References: <CAADnVQJBxsWU8BddxWDBX==y87ZLoEsBdqq0DqhYD7NyEcDLzg@mail.gmail.com>
 <1569153104-17875-1-git-send-email-paulb@mellanox.com>
 <20190922144715.37f71fbf@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922144715.37f71fbf@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 02:47:15PM -0700, Jakub Kicinski wrote:
> On Sun, 22 Sep 2019 14:51:44 +0300, Paul Blakey wrote:
...
> > ------------------------------------------------------------
> > 
> > Subject: [PATCH net-next] net/sched: Set default of CONFIG_NET_TC_SKB_EXT to N
> > 
> > This a new feature, it is prefered that it defaults to N.
> > 
> > Fixes: 95a7233c452a ('net: openvswitch: Set OvS recirc_id from tc chain index')
> > Signed-off-by: Paul Blakey <paulb@mellanox.com>
> > ---
> >  net/sched/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> > index b3faafe..4bb10b7 100644
> > --- a/net/sched/Kconfig
> > +++ b/net/sched/Kconfig
> > @@ -966,7 +966,6 @@ config NET_IFE_SKBTCINDEX
> >  config NET_TC_SKB_EXT
> >  	bool "TC recirculation support"
> >  	depends on NET_CLS_ACT
> > -	default y if NET_CLS_ACT
> >  	select SKB_EXTENSIONS
> >  
> >  	help
> 
>  - Linus suggested we hide this option from user and autoselect if
>    possible.
>  - As Daniel said all distros will enable this.
>  - If correctness is really our concern, giving users an option to
>    select whether they want something to behave correctly seems like
>    a hack of lowest kind. Perhaps it's time to add a CONFIG for TC
>    offload in general? That's a meaningful set of functionality.

Now that we have the static branch in place on OvS code, maybe we can
remove this option and rely just on NET_CLS_ACT instead (such as in
cls_api.c and skbuff.h).

Probing by OvS userspace is still somewhat possible, as the flag
OVS_DP_F_TC_RECIRC_SHARING wouldn't be known and be rejected
otherwise. 'somewhat because there is a limitation, as prior versions
(prior to this commit) didn't validate if the flags being set were at
least known.  But this is not news.

General OvS performance won't suffer, thanks to the static branch.

Drivers won't allocate the skb extension just because. They will only
do it when tc offloading is being done and, as already explained in
the thread and other places, it's needed for correct operation. So
general performance is also ok here.

For tc sw datapath, maybe we can have another static branch in there,
more specifically at tcf_classify(). Not sure how to control/toggle
it, though.
