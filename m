Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CC8422F90
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhJESD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhJESDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:03:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748DDC061755
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 11:02:04 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id f9so2042295edx.4
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8soODRKahVCrtRlGdz3itpTz6efHriNTM+iAlgAUdyU=;
        b=bYv7DnuO0RwkyA+l2MKeegZst/fh5ECeydJbnQ9QG8NQQ8b2dDTFDpxbhrFgAtrWcO
         PNfl0qr8UxOX9DiiorStolrwbPL57AOAtego0kcSajMSiwv3CSlTuVg3egOK6yxfa4Sw
         MEz6Stdn1nAyy5hLsBb1h69M0tzHD+xBqEThU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8soODRKahVCrtRlGdz3itpTz6efHriNTM+iAlgAUdyU=;
        b=XazuRNKolhtZ0aNyFcfh8AJ1dSA27MRmEsr56ahY6gjRx17oijIbqe1YxS3KN+aQ9V
         dPASgMsypzlbhD5oR35leBGO0XsCEkDdxPY4utX+QsMKwI7p0rZY5DXx994FxW9H6ibi
         y3yf2ay4lLFxHMhtTM9/S1DBsreDgZwUaZL2RxoQL3SRnM56aIsg2OotIAvqJvvmbvpk
         pWeQ3fi1/4xK847NkO/VrNshZQf/F6kOiVcMSmZbN1lMcRwmuPGDVxg4rddiXM4B/jZv
         zB6npyIXoFxKnsAP/FIibEe5Wr3VKxiyp9VhjrVXwGxn1AcAZhym2ckJOfJV9C/QSBi+
         C5CQ==
X-Gm-Message-State: AOAM531Hj7QIcvU4ATxalqb2KBTN6lgipbsr303V3LrqPSrksUZhOCqo
        V/FsjG3XkY3AmkJUloTW9LRbWufIFrPE0JKa
X-Google-Smtp-Source: ABdhPJztLA+4bqrgciuGWV2Utz46byIwXyxUhs5Eyhx9lSWiXnu0KLr/rnzC3xlvcwqMkfGmPec67Q==
X-Received: by 2002:a17:906:c317:: with SMTP id s23mr23300124ejz.127.1633456922542;
        Tue, 05 Oct 2021 11:02:02 -0700 (PDT)
Received: from [192.168.1.149] ([80.208.69.72])
        by smtp.gmail.com with ESMTPSA id e7sm9799784edk.3.2021.10.05.11.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 11:02:02 -0700 (PDT)
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
References: <20211005094728.203ecef2@gandalf.local.home>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
Date:   Tue, 5 Oct 2021 20:01:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211005094728.203ecef2@gandalf.local.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2021 15.47, Steven Rostedt wrote:

> That is, instead of declaring: typeof(*p) *_p; just do:
>  typeof(p) _p;
> 
> Also had to update a lot of the function pointer initialization in the
> networking code, as a function address must be passed as an argument in
> RCU_INIT_POINTER() 

I would think that one could avoid that churn by saying

  typeof((p) + 0)

instead of just "typeof(p)", to force the decay to a pointer.

Rasmus
