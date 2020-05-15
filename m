Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663381D5328
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgEOPHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgEOPHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:07:50 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34CC061A0C;
        Fri, 15 May 2020 08:07:50 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u5so1074419pgn.5;
        Fri, 15 May 2020 08:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkPZgbRyoXj8VgKHhN72c04Ed4oZhZQXxzUIYhF5Dm0=;
        b=dUZ7BnOmpGSvC7Z0FaCtXXr6VD4kjhC58W567jEPdN3Iyz5uyhH0/EFIakTj1UZ3w+
         w9k89SUtJk4CVOctr5kJmGeAXQlSXWtLVx+u3I0a6Tf5CViC1Mu9NXQvT4MN7hIesW7J
         Ffl/4B0Fj//Hj1W24c9qNe/4hN8x0c/MQjoSr1CJlCphOZibHvqCF2e+7nLhDCpmlHuE
         ekf0D57PWmjmGzH/ZUWf4zjHVH8q+TdpFdQlZlIjtOErWjZr9ZvjrXB/D/VAMYQdR+va
         oIqPmyqWDwtn6m7EU0kncBJM7CquK+n6/7y7xIx+/cni0KJRHqj108Df+9JnHTwjxdrI
         PCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkPZgbRyoXj8VgKHhN72c04Ed4oZhZQXxzUIYhF5Dm0=;
        b=PeNahV0+7vhsvbQoGmrTuKol70Fxs3Skt+aQkqRDU7+miCQqDaKjhifCS/ExCgOGno
         6sMSIbxa6qKFQtV4VffcFb8qkoZ2OqSXVeby1boP4jy+dlqgLDhkzAWAPMshs7KJFzk7
         ZJBwTU7BpC4FNBn6/ugz8yoGanZvs4ZlIwPimdSXuRqq5UzQjuh0WfgFnS49TzrC6FkP
         0BvPmtaAc0HMTBjDC1AGu5bSMtcrESX3HHGSpbTaIkG7op8Tff+r9wEJcIz9PbLn6S02
         GqE7+EW4v/t2hO+/YmXP2VHsHLhfU0xx/qpNFRgoRkO6zV0Aq3jtZzgIMdYdbwF6AtkT
         4ZPQ==
X-Gm-Message-State: AOAM531O7x5PpMVEtZeMz8gT4Y2LvTHkMPwxiwQpuolV8WCFWH9wvNG7
        8z8DSSelJAH5JVILISCGlhmqsQJB
X-Google-Smtp-Source: ABdhPJx8pHG0A+/S60CIk3UTKuVVYMOSYiluSnebUoU+6sgqtB2gciuqOOqpIyt61M638XI+FGlT4g==
X-Received: by 2002:a65:6810:: with SMTP id l16mr3436636pgt.390.1589555270151;
        Fri, 15 May 2020 08:07:50 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:6ccd])
        by smtp.gmail.com with ESMTPSA id k6sm2194209pfp.111.2020.05.15.08.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:07:49 -0700 (PDT)
Date:   Fri, 15 May 2020 08:07:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 05/17] inet: Run SK_LOOKUP BPF program on
 socket lookup
Message-ID: <20200515150742.obhv4sdps5chduay@ast-mbp>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511185218.1422406-6-jakub@cloudflare.com>
 <20200511204445.i7sessmtszox36xd@ast-mbp>
 <87wo5d2xht.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo5d2xht.fsf@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 02:28:30PM +0200, Jakub Sitnicki wrote:
> On Mon, May 11, 2020 at 10:44 PM CEST, Alexei Starovoitov wrote:
> > On Mon, May 11, 2020 at 08:52:06PM +0200, Jakub Sitnicki wrote:
> >> Run a BPF program before looking up a listening socket on the receive path.
> >> Program selects a listening socket to yield as result of socket lookup by
> >> calling bpf_sk_assign() helper and returning BPF_REDIRECT code.
> >>
> >> Alternatively, program can also fail the lookup by returning with BPF_DROP,
> >> or let the lookup continue as usual with BPF_OK on return.
> >>
> >> This lets the user match packets with listening sockets freely at the last
> >> possible point on the receive path, where we know that packets are destined
> >> for local delivery after undergoing policing, filtering, and routing.
> >>
> >> With BPF code selecting the socket, directing packets destined to an IP
> >> range or to a port range to a single socket becomes possible.
> >>
> >> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> >> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> 
> [...]
> 
> > Also please switch to bpf_link way of attaching. All system wide attachments
> > should be visible and easily debuggable via 'bpftool link show'.
> > Currently we're converting tc and xdp hooks to bpf_link. This new hook
> > should have it from the beginning.
> 
> Just to clarify, I understood that bpf(BPF_PROG_ATTACH/DETACH) doesn't
> have to be supported for new hooks.

Yes. Not only no need. I don't think attach/detach fits.
