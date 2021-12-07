Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823DF46AEE8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbhLGAUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbhLGAUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:20:52 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:17:23 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id d10so36119512ybe.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0PtSuYa2S4kN+yBUO3UMo0RyXEqtOktSV2sDSenmkM=;
        b=hxyJIImGuct3q7MdV6tcl7MPZBH3NGOEz9j/rA1NzRxKz0ESBNc1W62i9rapqnXmBg
         B8xgEaimXEOcFUYnDlchG53pnDDLg7FR2/VS/RRE4PuHQ7p+1IXm/CEza62qgOVw8dDc
         JtU/dM/DOwH4JixGI+tdJPKs3SAZYpdDiviYmGjkRKkjhKlNt7Lqni/4zvB7ecX655du
         TnyeE6GTaz/T44iSMNSxyV6u/OMTTEgmJoUB4y5D5V+mmiQscV3VN2Oz5331V5krsApR
         tHiQVEzLndhB8YKVIHQobyKDans1JnHO4gc4E5EJuK1T6QRSeABl+0xurBx35Q0uixQO
         gZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0PtSuYa2S4kN+yBUO3UMo0RyXEqtOktSV2sDSenmkM=;
        b=vLKjkSavBP4Dp2tBZmt6faN4/FgYAFg30aTuzX3U4dwEzopDi+kgotIh5YlGtL2LX2
         gL27P8odxJBGAfi1HaUWy8nZFS8pQMKIbOGPa2vWG8Ojn6VoItMJ67IA0x2xIVb7hAlm
         dGbfTE/w4SMZTWrMfYBcSYhW28tQ7H+ib4vUh/1ZlC6LrIgZUTnFvKVYgjgT4h0HPi6J
         jZrfnKInEolChRY2cmlQcqAkW4CMH6e4yA8665aa1Ceur9anvCyvKwu4lIQedE/2nkiY
         3OuiWIwnVaL9HDT95eJStOcRDw7VPSCK7VGTLJC5zwhWiXehhUuJGMAsG0QOfLKlw66M
         vptA==
X-Gm-Message-State: AOAM533dv8stRMuBzahWCqlacFW9GtVXejmMwLljBamshjo9jWI/9bbv
        reGisQaU6O635gGyaaXvTQFSob+QtTO4AWdGFH0LHx2Kp5xoOQ==
X-Google-Smtp-Source: ABdhPJzyumql1O/nXltOkyaTh3UnJQe5Bn5njYotdSYWK1XldD84BwqbKC08BeDT85WTODMh5AIzlvCEd+JGjZb1mo4=
X-Received: by 2002:a25:3252:: with SMTP id y79mr45384365yby.5.1638836242424;
 Mon, 06 Dec 2021 16:17:22 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
 <Ya6kJhUtJt5c8tEk@lunn.ch> <CANn89iL4nVf+N1R=XV5VRSm4193CcU1N8XTNZzpBV9-mS3vxig@mail.gmail.com>
 <Ya6m1kIqVo52FkLV@lunn.ch>
In-Reply-To: <Ya6m1kIqVo52FkLV@lunn.ch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 16:17:11 -0800
Message-ID: <CANn89i+b_6R820Om9ZjK-E5DyvnNUKXxYODpmt1B6UHM1q7eoQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 4:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
>
> Hard to say. It looks like some sort of race condition. Sometimes when
> i shut down the GNS3 simulation, i get the issues, sometimes not. I
> don't have a good enough feeling to say either way, is it an existing
> problem, or it is my code which is triggering it.

OK got it.

I think it might be premature to use ref_tracker yet, until we also
have the netns one.
(Seeing the netns change path from your report, this might be relevant)

Path series adding netns tracking:

1fe7f3e6bf91 net: add networking namespace refcount tracker
14d34ec0eaad net: add netns refcount tracker to struct sock
648e1c8128a1 net: add netns refcount tracker to struct seq_net_private
fa5ec9628f3e net: sched: add netns refcount tracker to struct tcf_exts
fa9f11a0a627 netfilter: nfnetlink: add netns refcount tracker to
struct nfulnl_instance
8e3bbdc619d0 l2tp: add netns refcount tracker to l2tp_dfs_seq_data
323fd18ce64c ppp: add netns refcount tracker
d01d6c0df780 netfilter: nf_nat_masquerade: add netns refcount tracker
to masq_dev_work
1b7051234a99 SUNRPC: add netns refcount tracker to struct svc_xprt
44721a730a24 SUNRPC: add netns refcount tracker to struct gss_auth
648e8fd765b7 SUNRPC: add netns refcount tracker to struct rpc_xprt
c1d5973f3af0 net: initialize init_net earlier
75285dbd40cd net: add netns refcount tracker to struct nsproxy
0fbde1282785 vfs: add netns refcount tracker to struct fs_context
5a0c6bd0445f audit: add netns refcount tracker to struct audit_net
145f70501bfb audit: add netns refcount tracker to struct audit_reply
b5af80d1c341 audit: add netns refcount tracker to struct audit_netlink_list
