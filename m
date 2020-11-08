Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC462AA9F7
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 08:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgKHHee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 02:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgKHHee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 02:34:34 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF64CC0613CF;
        Sat,  7 Nov 2020 23:34:33 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id gn41so7801498ejc.4;
        Sat, 07 Nov 2020 23:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=EtaEzhxwenaqaXTQFj3napoTw7vDymU9qv/CcKvdwmE=;
        b=ZnE/glUABu9QGDkOHxquGmDxrQqIHjLEvt5SpxMBg5Xx0xSiyv1zagNoZJRPOQMQIx
         qdNM//HIPnmvQW29aMQG231tebEkJrdlrSk/RahX3E7b49r/vxmfvSEughuZumxN+nID
         MVuon/6ytPQ+gyT0bdF6Jkk4z6oxkhEcMHORr8JrosV2NKc6yOI+FaGCSf4Ohu1uAtJM
         kr7rTmyWRdmLt0Z2pOK8DGkoktpJY6GnEahi78kVIqQ+g61w2LOB6Rpipi7owxHMbFmv
         yGqLkRw7isCy4TIuSsh6riO4BqNYCkgy6fpR8kxjKZkRwinisy0lgJ7BWfq9x3BF0fT2
         GP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=EtaEzhxwenaqaXTQFj3napoTw7vDymU9qv/CcKvdwmE=;
        b=Ck43XtnWGlObu2UpURofEgMC32FIwWjEeo681zXase6MDJKf4lZCDRVxExiAtEk0hc
         MyMnsQNVTLMQDh1NSkwnD+/jFReLYw0dpbw76zCmKnZ0DpGfVTDMEbM4+ptwdlhyI38j
         JnxKxR7zznevTtPEevI/H285UuQu2s/UzU2k+0fe/1ueIfgNqkqbW1MEzDnJ/VcXOE9R
         3kvmeE6W3H/XQxiVl8DZrvJNObCXwAQ4+BLgV4Pt4p6JhuaBfZtw5OS/ajqfo9UHxCF5
         sJRXOnZAetW0Ad4IeSIWHIRHSglCSWHacLXBeIwe6ephPTsrzid/YLPj5RibgNimNWhY
         xYqw==
X-Gm-Message-State: AOAM5314BLyxeP7TDRQ/6SO88htj5bgDA5n2Pi+JnfiZtOJlFUdNQ6P4
        nXzOjCMXSBANF9+IqicJT3A=
X-Google-Smtp-Source: ABdhPJwf8HUCG+aejCdj3kNsW0NI3G/bOwmVp0UeenyfCbR1SkEQkajHmqVIoPa6OwQmCefvdWyXAA==
X-Received: by 2002:a17:906:f18f:: with SMTP id gs15mr10050425ejb.474.1604820872490;
        Sat, 07 Nov 2020 23:34:32 -0800 (PST)
Received: from felia ([2001:16b8:2d34:bd00:5df6:61b:5ed6:df51])
        by smtp.gmail.com with ESMTPSA id f25sm5202614edr.53.2020.11.07.23.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 23:34:31 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Sun, 8 Nov 2020 08:34:30 +0100 (CET)
X-X-Sender: lukas@felia
To:     Joe Perches <joe@perches.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>
cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
In-Reply-To: <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
Message-ID: <alpine.DEB.2.21.2011080829080.4909@felia>
References: <20201107075550.2244055-1-ndesaulniers@google.com> <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-296194858-1604820871=:4909"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-296194858-1604820871=:4909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sat, 7 Nov 2020, Joe Perches wrote:

> On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> > Clang is more aggressive about -Wformat warnings when the format flag
> > specifies a type smaller than the parameter. Fixes 8 instances of:
> > 
> > warning: format specifies type 'unsigned short' but the argument has
> > type 'int' [-Wformat]
> 
> Likely clang's -Wformat message is still bogus.
> Wasn't that going to be fixed?
> 
> Integer promotions are already done on these types to int anyway.
> Didn't we have this discussion last year?
> 
> https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
> https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
> https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/
> 
> Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
> of unnecessary %h[xudi] and %hh[xudi]")
> 
> The "h" and "hh" things should never be used. The only reason for them
> being used if if you have an "int", but you want to print it out as a
> "char" (and honestly, that is a really bad reason, you'd be better off
> just using a proper cast to make the code more obvious).
>

Joe, would this be a good rule to check for in checkpatch?

Can Dwaipayan or Aditya give it a try to create a suitable patch to add 
such a rule?

Dwaipayan, Aditya, if Joe thinks it is worth a rule, it is "first come, 
first serve" for you to take that task. 

Lukas

> So if what you have a "char" (or unsigned char) you should always just
> print it out as an "int", knowing that the compiler already did the
> proper type conversion.
> 
> > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> []
> > @@ -50,38 +50,38 @@ print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
> >  
> > 
> >  	switch (l4proto->l4proto) {
> >  	case IPPROTO_ICMP:
> > -		seq_printf(s, "type=%u code=%u id=%u ",
> > +		seq_printf(s, "type=%u code=%u id=%hu ",
> 
> etc...
> 
> 
> -- 
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel%40perches.com.
> 
--8323329-296194858-1604820871=:4909--
