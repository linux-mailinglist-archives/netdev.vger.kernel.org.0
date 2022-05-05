Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AD151C8BF
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 21:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384907AbiEETRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348852AbiEETRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:17:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058D4252B9
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 12:13:50 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id m128so9265824ybm.5
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 12:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ejpnYDVkll3gsTVSk8MmXOA5fC8xW9WmYnpRjDUT5Q=;
        b=g7oijB9HjOcYL3DCEw6ScrM8dFRK2YivHmtjHSeuDNtmNPs+1S3/NoIOGIkdw3cbfY
         O+au64qAvpGNvrW+MadNTYr/x5N4JRRHyePZ/uOjRwiR5FZ7j0P3TVfbF0H/24olvRKT
         LXR4kgmHYHXVDVxViN56RsgZg+1qDgQpQgk5TVV75X8xZQp4OtPZY/hQkQWs0MJR1Et7
         oTada7MuW1P9DCQLgWO9GeIgnuk5YZoPoE0lfm8pGWyBsgRY6eurNiGJ8mkDxkCCf0fy
         RjcXTU8UjqnfuixeOPco1WtS9Xhqbb/7+hL3IV7RiqpDR0yeVEJaPizWJ09KgRFQzMKp
         60+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ejpnYDVkll3gsTVSk8MmXOA5fC8xW9WmYnpRjDUT5Q=;
        b=ZrRZZ3So3kDe1N+oe5qOR3qWyuWnQKpYoGLTILXjmcOtPzHK3/wH4SBFfXlFL8NRmE
         L5MppoHmtaqFnP4kX3CWMDnwZno7yqI9kC6Dql/G+b8/lq/ujfqV0kyzKoILqkCblGrM
         YEHrurBwxrAJ/+KlFZVS/kmIYns3ENg6WX/hmq+aF1G1UCPf1bvqUB9sEiGafSOKGRUb
         xMcRUIuTx8N+6JYY3YRzNlRN+tDpWqr1wI727T8Eoy1Zt6Uu89Sj5MLcXiLaCWo/0KpQ
         xchlvkYqPiZs91XNkipaLQ28bBXKu8xEEGkeEd4k5kPzaYmvy9PxoOEMeR8HK5OrJ/3g
         aZjw==
X-Gm-Message-State: AOAM532atc8HUgJ/aFeatlxgxE1w5LXFNl53+8CGLRmuKDdaLEPRFZYl
        m+Vt6VK7ByW4x06Bu85DbvZSnfgxEstyQzo6RBVwaQ==
X-Google-Smtp-Source: ABdhPJwjoHxnbZZDryz4CiDpslsBAcVgVgC6PDCH9jwcznIVz9FnRYYjp9f6hIghED7cByEwsA4NU/P22ABSOyUKnYc=
X-Received: by 2002:a25:2a49:0:b0:648:f2b4:cd3d with SMTP id
 q70-20020a252a49000000b00648f2b4cd3dmr23796100ybq.231.1651778028971; Thu, 05
 May 2022 12:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
 <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
 <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
 <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
 <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp>
 <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp> <41d09faf-bc78-1a87-dfd1-c6d1b5984b61@I-love.SAKURA.ne.jp>
In-Reply-To: <41d09faf-bc78-1a87-dfd1-c6d1b5984b61@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 May 2022 12:13:37 -0700
Message-ID: <CANn89iJaairJwd9rqWuTH3vibanugMTG3_4mX3yoqgrNiqHEeA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: rds: use maybe_get_net() when acquiring
 refcount on TCP sockets
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 4, 2022 at 6:54 PM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Eric Dumazet is reporting addition on 0 problem at rds_tcp_tune(), for
> delayed works queued in rds_wq might be invoked after a net namespace's
> refcount already reached 0.
>
> Since rds_tcp_exit_net() from cleanup_net() calls flush_workqueue(rds_wq),
> it is guaranteed that we can instead use maybe_get_net() from delayed work
> functions until rds_tcp_exit_net() returns.
>
> Note that I'm not convinced that all works which might access a net
> namespace are already queued in rds_wq by the moment rds_tcp_exit_net()
> calls flush_workqueue(rds_wq). If some race is there, rds_tcp_exit_net()
> will fail to wait for work functions, and kmem_cache_free() could be
> called from net_free() before maybe_get_net() is called from
> rds_tcp_tune().
>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Fixes: 3a58f13a881ed351 ("net: rds: acquire refcount on TCP sockets")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
