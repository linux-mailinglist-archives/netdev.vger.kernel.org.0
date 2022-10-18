Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E676022CA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 05:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiJRDlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 23:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiJRDlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 23:41:00 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB20F6BD6C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:35:28 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id t186so15515163yba.12
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 20:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ST2l0aH4pM3SDggbskRy/c9QPatZIgYocMVFygXAvnQ=;
        b=GwxeG+t2ZjlcVrpFmC6cK02+VCQCQpyJBaVeXoGUQJvQ0sSi9J2eZbvAuFLrUo29lv
         hMll3iAYziDalti640svgOujYR35X2Gdn79qLf7wZv6I/vG3SdT6CQ9PKw0Dq+Gr109q
         AJKc05XQt47Fa5PnWQ/PIWHvIaBQ0L1DgApn2MVPuXYqszK0XqmjDVxQIm3V5HeMLK7/
         9ISGRbPoQW1msG1GaLBvCb+DsiCAv3JEzz9P+a8YnJoKRqZeUL9NCEQ2BRTgjTj9BjLC
         C25+WH0xGiGbTvNkWoCT5wWL4TMwvAGp+4OJToKhU7ZqqPQYFU/PFCBe41YaW/s0jflX
         RTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ST2l0aH4pM3SDggbskRy/c9QPatZIgYocMVFygXAvnQ=;
        b=EOFG/s5PGbGSmJWB6hE9JPI4xZooc1ZUDsILU+PYtsdn6Dz9qfnWDGeEv/a5Cn4S59
         Ps+NSHxbQN/DdMFSn/n0c0JKzPcsq0/6P1lG9yS0dzM3rNp4fejRcA6r7u6KMzYKzCvF
         0TKyu2VSUIaSDM1t6VCzSPhQwpThbg3IC0CQy4cQb/JUz+fORYMLnG/rigriBYVWLa9Y
         vcPzCm56FfpuQK2d7FVhv3YaR3HV/Qq4n6wuplJzR8B50cX1+Ixyhi+fehEu/UAN9teb
         CYEZ2eVZHzNePiull2uguCGtS9kRbVKcVs32cVV0lgSf8aWz+Rt5wOq8mR1VbxsHtw6T
         Ewqg==
X-Gm-Message-State: ACrzQf1/2nayqFh7QwR9fwiPLW5QKzn/5lHQn/lPHaFJGvJ+QW0UL6i4
        0D6yYH/jE6QZrCrRvG3W3kP8HeaLHY1RuKCKJM7W2g==
X-Google-Smtp-Source: AMsMyM57bTd/GNErk7P389PGaDd9qsHId38tyTFmOK2Qu3SUuuVoOqtehxvkx+CrnDYEDq7S5jA9o1hSrNhGtNcj9hM=
X-Received: by 2002:a5b:bc1:0:b0:6c4:902:f12f with SMTP id c1-20020a5b0bc1000000b006c40902f12fmr744461ybr.231.1666064127515;
 Mon, 17 Oct 2022 20:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221017080331.16878-1-shaozhengchao@huawei.com>
 <CANn89iJdZx=e2QN_AXPiZQDh4u4EY5dOrzgdsqgWTCpvLhJVcQ@mail.gmail.com>
 <c482c66b-a455-ff6e-7a6a-a8c5d717c457@huawei.com> <CANn89iJVFVZwcbZbE8zHUct+UOZNXrwi64Xi0GosP5N+ohPZtg@mail.gmail.com>
In-Reply-To: <CANn89iJVFVZwcbZbE8zHUct+UOZNXrwi64Xi0GosP5N+ohPZtg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Oct 2022 20:35:16 -0700
Message-ID: <CANn89iLHJpzXUQD+NUrfyuSJbzpV9B2eEj54Um4f+bkAjMVWOg@mail.gmail.com>
Subject: Re: [PATCH net] ip6mr: fix UAF issue in ip6mr_sk_done() when
 addrconf_init_net() failed
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 7:33 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Oct 17, 2022 at 6:48 PM shaozhengchao <shaozhengchao@huawei.com> wrote:

> > Hi Eric:
> >         Thank you for your reply. I wonder if fixing commit
> > e0da5a480caf ("[NETNS]: Create ipv6 devconf-s for namespaces")
> > would be more appropriate?
>
> Do you have a repro ?
>
> You could first use scripts/decode_stack.pl to get symbols from your
> traces, to confirm the issue.
>

Hmm... I read again the stack traces, and while addrconf_exit_net() is
not called,
igmp6_net_exit() _is_ called, so I guess your patch is fine, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
