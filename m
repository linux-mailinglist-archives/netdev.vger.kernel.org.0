Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D908B127F44
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfLTP2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:28:15 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53744 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbfLTP2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:28:15 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so4250751pjc.3;
        Fri, 20 Dec 2019 07:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GZPCEvTkQBcE0MkWf0wsjsT/U2bWse2KUq7jRUE3VSc=;
        b=sTBffexju1W2lYD4Nzsim/64ZnYR8BCtM/yzwIWySePc8qD1ZaDo537POMdRGfJtc5
         uQoau9wJxX1jJ0hT6gmVPT1uexYZB6irL1/mRepbdy4i9EQNFN2NhaLJCzT/KbnhPYb9
         hC72KGNGP6qV9wVzqcwN2t059a2z+XKzJ4xof+PrSdGjjSkSeuElWwFq2edOJWKhmNI4
         pzbSTqAhGVORWmDdzs7Fym/z4sCMidom6d6+wwNCBT9s5tPn0NGTL5dBFLIHOa/pjhoW
         DXiSnQPKiM79BUvG6rqjoMaRTgsR1tAjsGqTKg6D3jeVO5OiXFHVsOL/IFZd9qyI7Wkv
         lccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GZPCEvTkQBcE0MkWf0wsjsT/U2bWse2KUq7jRUE3VSc=;
        b=ScPLDmAqBxuQ1E+xyLopBrh4Ae0nEP51k9J+NC4lskHDkgQYJnmvHpbWjuXRLcAfAw
         qf0byziQPGHbY6KMD/eEBhYHvQHQ7m+2RvzC1wtyXbfNzrWKET5whbTdQyhy9Nd3TU/V
         5e+c1hdOSgzsMcYp48uFoxBtoCkv95L1Mr4jyJcsS8/vJo4TOPJlLlwpKNXs9D2yvoCl
         N6OlSy8MRi4F87ahO9dF1g1WOFuSoYjvI9z8WgZzqcGY8u8S+q1LQ240WmeClg7UEKuZ
         p/5ac8Ya+AyS+PHT/zlHRZtDwBRfp8yZkCr6Cuf9tXM2XXKOx15ldIIq2t9jz1ecy49+
         J2Og==
X-Gm-Message-State: APjAAAUHeMi+ZP27bquLDXufNHRMYrCcVieEEHY8rwkXoeG0JjnrBl1s
        D93zrl/ZhtrQOFbh4/bPweTjpdfAdf7NoA==
X-Google-Smtp-Source: APXvYqwN583GT21VCNYIdu4eOGCxYptUDhCM7V0OyVU+QMsL1dpSQO5jno4LZj6NxqwbLl5ZCLDT0g==
X-Received: by 2002:a17:902:124:: with SMTP id 33mr15019308plb.115.1576855694327;
        Fri, 20 Dec 2019 07:28:14 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:b9c8:9c5e:a64b:e068:9fbd])
        by smtp.gmail.com with ESMTPSA id p185sm13678019pfg.61.2019.12.20.07.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 07:28:13 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id B62CEC161F; Fri, 20 Dec 2019 12:28:10 -0300 (-03)
Date:   Fri, 20 Dec 2019 12:28:10 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     syzbot <syzbot+9a1bc632e78a1a98488b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Subject: Re: general protection fault in sctp_stream_free (2)
Message-ID: <20191220152810.GI4444@localhost.localdomain>
References: <0000000000001b6443059a1a815d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001b6443059a1a815d@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 07:45:09PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    6fa9a115 Merge branch 'stmmac-fixes'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c4fe99e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=216dca5e1758db87
> dashboard link: https://syzkaller.appspot.com/bug?extid=9a1bc632e78a1a98488b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ada71e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144f23a6e00000
> 
> The bug was bisected to:
> 
> commit 951c6db954a1adefab492f6da805decacabbd1a7
> Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date:   Tue Dec 17 01:01:16 2019 +0000
> 
>     sctp: fix memleak on err handling of stream initialization

Ouch... this wasn't a good fix.
When called from sctp_stream_init(), it is doing the right thing.
But when called from sctp_send_add_streams(), it can't free the
genradix. Ditto from sctp_process_strreset_addstrm_in().

