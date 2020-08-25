Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E404251C59
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHYPd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHYPdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:33:25 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306FEC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:33:23 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z3so6979503qkz.7
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yy8fwKjPJwUQ6ad92J+IQZsOtreG8cS2EHL/AcKAcdE=;
        b=sIPduKcBpcPkQTf+dqdwcHjlQidEBPDfGeLb5AZLnfcMLflYGzNr0AKFXS64d/MQsq
         Va2l9nz+kkjhM5Yfu18H+hdHDvUL1ElA42qPBa6f5OdElPeyS/vV3eVGI+eIMRNT1Qd2
         CbMX5lbgDVeUEVF7LWLyetdaSVBcqzpLKUAt3oG9zoOv/DQ18vfED1Bg0YWrTnxRn67X
         5krRQBdWnCPPuKjmwIiZ0b4ZZEMk9SFOHHLQ2p3PYS19ShOXhiZecF7AHh5LbYvQNHUp
         GQlBdKVdnRwgu44vAK4AZ5FQdSazWLxzNDT4D0arUhLN7D9+kZMw3tXk/k47RIOk5Lqj
         rYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yy8fwKjPJwUQ6ad92J+IQZsOtreG8cS2EHL/AcKAcdE=;
        b=L4aw3D3z+UPBAodrGiD6PeXFg+c9mtQOTFxDslKm9oyd2wkEnzsr7O2SXEQBasxtYH
         pl6sgywVQ5apc9YLTzjGPs5/9RcZMdbu7xLv0DRDqVnajtZi+QCwpZh5JlV0n1jzTBgW
         O959/JfzoPNCE2SiwFzNo5+npSYBE41SPw6mcc1ChlV3AFaxvKtY60mdWmUSWLZacTaU
         VKitIuM5esLj+i0EpXNcr7UzyL6FCCrC62Vu2XfFkbJ12yeHyz9R8v2MUxRj0mZE/tZ2
         aAkO0Xy1/H7FwuRB7dE+xvClHoi09NfdrjM5Ay4BMN3rvp/Sp0OrdpffBtZ2QHgcb/T6
         48OA==
X-Gm-Message-State: AOAM5338X9knksngel3A34qpbXl8HYGqMdz7daOLRXNkPPwINXjtjMHG
        ecUKwAgEJ4hKzEyhZ2dDIqs=
X-Google-Smtp-Source: ABdhPJwSAXK+PO/Iw7fq9zJAovayXWR/UdH3gYY7UI83NStwkv32XNlde2hMl/ZZensmsRSoD3vlhw==
X-Received: by 2002:a05:620a:5ee:: with SMTP id z14mr9298560qkg.48.1598369602264;
        Tue, 25 Aug 2020 08:33:22 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.63])
        by smtp.gmail.com with ESMTPSA id x13sm13413566qts.23.2020.08.25.08.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:33:21 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6C43AC4BDE; Tue, 25 Aug 2020 12:33:18 -0300 (-03)
Date:   Tue, 25 Aug 2020 12:33:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net/sched: add act_ct_output support
Message-ID: <20200825153318.GA2444@localhost.localdomain>
References: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598335663-26503-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 02:07:43PM +0800, wenxu@ucloud.cn wrote:
...
> +static LIST_HEAD(ct_output_list);
> +static DEFINE_SPINLOCK(ct_output_list_lock);
> +
> +#define CT_OUTPUT_RECURSION_LIMIT    4
> +static DEFINE_PER_CPU(unsigned int, ct_output_rec_level);

Wenxu, first of all, thanks for doing this.

Hopefully this helps to show how much duplicated code this means.
Later on, any bug that we find on mirrer, we also need to fix in
act_ct_output, which is not good.

Currently act_ct is the only one doing defrag and leading to this
need, but that may change in the future. The action here, AFAICT, has
nothing in specific to conntrack.  It is "just" re-fragmenting
packets. The only specific reference to nf/ct I could notice is for
the v6ops, to have access to ip6_fragment(), which can also be done
via struct ipv6_stub (once added there). That said, it shouldn't be
named after conntrack, to avoid future confusions.

I still don't understand Cong's argument for not having this on
act_mirred because TC is L2. That's actually not right. TC hooks at L2
but deals with L3 and L4 (after all, it does static NAT, mungles L4
headers and classifies based on virtually anything) since beginning,
and this is just another case.

What I can understand, is that this feature shouldn't be enabled by
default on mirred. So that we are sure that users opting-in know what
they are doing. It can have a "l3" flag, to enable L3 semantics, and
that's it. Code re-used, no performance drawback for pure L2 users (it
can even be protected by a static_key. Once a l3-enabled mirred is
loaded, enable it), user knows what to expect and no confusion on
which action to use.

  Marcelo
