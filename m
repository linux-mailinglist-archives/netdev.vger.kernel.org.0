Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16E51E6FA
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfEOC4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:56:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35989 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEOC4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 22:56:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id a3so571222pgb.3
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 19:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9kqRrsb++I0tVWKRUhKyYkTTZ79beQ5XiFr2tm4fXGg=;
        b=U/GuCKuLv0GYA0b2ZYYNgEW1VQTtESo1ytzGpUW6kAGFzfRs7tUMuw90tLk4Zy7Q8Z
         IKyx4Rg/OULhyxTKzIdYiQggiIthiElOtVoJ23r5srnHOh1j6r/xBkIGj0pD5RTwpNF5
         7TdbqnVk0+EX8pliMdOY7LkFdBrEGskbtb0qYhBHcutC9fNnjzAw2DcX/y24M5ALj5rP
         givk9LY3gLiwfYSioy9DkJma+BLcmK1NNOAXlP3lDT8U3OKAufpEHj29D6e+or+qubA0
         WpQHdmo16hY4jev+OkLdezQkqDpWYiOJU4nfpik9cmgn2ml4QTVtpEdcnonhoaybUD5h
         +T9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9kqRrsb++I0tVWKRUhKyYkTTZ79beQ5XiFr2tm4fXGg=;
        b=XjXbOTlQKiT64Wd90ZsmDpmTmdzGk4l3b7ldfp/T4AfhP6+UgbogDyi6NZzc76Y05+
         +QqJ9O1uPawKAcQgDnzKesofPzJZ50MmeLD9B+DyUMsoAUiiv10PjgXoGk5L4RZRB6gF
         7F71IH8+CuQRWZLSAkuUGGFAOyX68Lc7te+rGBGFET3IAu9KyZOZe7DCU/yojFt72K6P
         kgwGQp8h/Nfe9625xT+9Qk7KA8Q17uKquuku1ZfQtybninnEk3c2GsAFz0yIqQAh5vRc
         idsRdwAe8onIMFpFQAIOojkwUeeampbt8FQ/AjEKobIym54BTC55ujzpdmYvFShGzRtn
         gDsQ==
X-Gm-Message-State: APjAAAUOYBi/AxmKtcgmwLwIPmHMrcdol2PeLVRIIIo3Lt7e37OEj7f4
        iGK1sfciC1qEFDX5TZ0XYb2E0Q==
X-Google-Smtp-Source: APXvYqzdPymztt59JMUNleYEqUbzDYVsx7mCTKC9cg/A90es9XlqLNTr11m2a8yQ1JhssNNINOnrXg==
X-Received: by 2002:a65:554d:: with SMTP id t13mr41127593pgr.171.1557888998050;
        Tue, 14 May 2019 19:56:38 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s18sm550594pgg.64.2019.05.14.19.56.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 19:56:37 -0700 (PDT)
Date:   Tue, 14 May 2019 19:56:36 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
Message-ID: <20190515025636.GE10244@mini-arch>
References: <20190508181223.GH1247@mini-arch>
 <20190513185724.GB24057@mini-arch>
 <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch>
 <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch>
 <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch>
 <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
 <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14, Eric Dumazet wrote:
> 
> 
> On 5/14/19 7:27 PM, Alexei Starovoitov wrote:
> 
> > what about activate_effective_progs() ?
> > I wouldn't want to lose the annotation there.
> > but then array_free will lose it?
It would not have have it because the input is the result of
bpf_prog_array_alloc() which returns kmalloc'd pointer (and
is not bound to an rcu section).

> > in some cases it's called without mutex in a destruction path.
Hm, can you point me to this place? I think I checked every path,
maybe I missed something subtle. I'll double check.

> > also how do you propose to solve different 'mtx' in
> > lockdep_is_held(&mtx)); ?
> > passing it through the call chain is imo not clean.
Every caller would know which mutex protects it. As Eric said below,
I'm adding a bunch of xxx_dereference macros that hardcode mutex, like
the existing rtnl_dereference.

> Usage of RCU api in BPF is indeed a bit strange and lacks lockdep support.
> 
> Looking at bpf_prog_array_copy_core() for example, it looks like the __rcu
> in the first argument is not needed, since the caller must have done the proper dereference already,
> and the caller knows which mutex is protecting its rcu_dereference_protected() for the writer sides.
> 
> bpf_prog_array_copy_core() should manipulate standard pointers, with no __rcu stuff.
> 
> The analogy in net/ are probably the rtnl_dereference() users.
