Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799D835BB9F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbhDLIFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 04:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237075AbhDLIFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 04:05:44 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3E5C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:05:26 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a25so977152ljm.11
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 01:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=UJUZ5l+pwb94CXGmjUo0/e251C6xLvaEkwpXTFxqWxA=;
        b=iVAb7vJAZL3xNbiRZqDlWuRDPrbzftnEC07YIJlZos4pNad3eScwPFC3jTXMufI8LX
         8KQbvRT+N9A1drMSvHycGWVjBIN74tTOFqdvBiuSQAE4EqHyUGNckgzikDEEFjVoH6fD
         jMKe6RRjaVS+3u4DBiAfkA8bn09AdzvDwJMn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=UJUZ5l+pwb94CXGmjUo0/e251C6xLvaEkwpXTFxqWxA=;
        b=lfBuRmcUqPaznF9hVmR/DU9lCNIEBtIyIxKHn9AxTN9zUgNF1486tys8EkDQc+xnnc
         9sCVVxd956Y72iu1OVH4GaQjz79UJDqDwcjwit94PJuULQiALEGJvt5wZkutJaG12vok
         C3xBbEZ57SlxfdEQM7Ln7ru4mz8ldAgUYky2r3w1vWFMVB982OTGbfo4lZJCgIFGnX6d
         C3nlnx+etsdHidcy/vvu9MBrvp2J4R6uBnSo3KcQOaX2OlIumApij80lrKW2d2J+DHQj
         mHv41V4eXGL4Is2PIU3nhaSS5qIgpFA+S5luUZAc2AA9Tk7tNEqkFnz0WGnTYNt0aL/q
         CwWQ==
X-Gm-Message-State: AOAM5320ovFN3EAsbMD8+cZe1xs8VmxMbAZneIISo+R6uPt0R1jZMSul
        bhppJT4ICKzpAWfubBOmltcLDQ==
X-Google-Smtp-Source: ABdhPJzzvWmMcZuSAAXGirY2acPsow1EdDKCC5gv1xy4oJ1TSAImzbsK5/th4asQ6X9yL7Gq+mImMA==
X-Received: by 2002:a05:651c:1243:: with SMTP id h3mr17555000ljh.128.1618214724994;
        Mon, 12 Apr 2021 01:05:24 -0700 (PDT)
Received: from cloudflare.com (79.184.75.85.ipv4.supernova.orange.pl. [79.184.75.85])
        by smtp.gmail.com with ESMTPSA id d7sm2131512lfv.268.2021.04.12.01.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 01:05:24 -0700 (PDT)
References: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next] skmsg: pass psock pointer to
 ->psock_update_sk_prot()
In-reply-to: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
Date:   Mon, 12 Apr 2021 10:05:23 +0200
Message-ID: <87r1jg2aik.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 05:21 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Using sk_psock() to retrieve psock pointer from sock requires
> RCU read lock, but we already get psock pointer before calling
> ->psock_update_sk_prot() in both cases, so we can just pass it
> without bothering sk_psock().
>
> Reported-and-tested-by: syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com
> Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

We don't necessarily need to pass both sk and psock.  psock has a
backpointer to sk that owns it.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
