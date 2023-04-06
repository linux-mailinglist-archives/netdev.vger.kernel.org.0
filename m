Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0136DA4A7
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 23:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDFVZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 17:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjDFVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 17:25:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7B810E5;
        Thu,  6 Apr 2023 14:25:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v9so2368654pjk.0;
        Thu, 06 Apr 2023 14:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680816319; x=1683408319;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVlOlkoXNAtZlrEiaIusqat9aNgJfbSvvGWuZy6PpLM=;
        b=lBLBoW0dYYKV3gmElyZfVwV7tiEbKOjqAkHnuLeFzlDudSKS4xPjI+Yo1MRbwAZ/YX
         JGCcenM5TsOFzNuG2NDGPYFsVmRa2YLte5byyJlxE74/lsrQvcJ0O/ebU54XMjJ+6y5j
         izDvJIJZb9zQQ+S5Dc8RwvR+hmPKBk97Oj3ZYY41aldHyvTCmCh1r0tVTidsF+Fm7TlQ
         C7tYyxz2ac49oR2jLYlOMBs1FUQD1aDyeicWxvA2tEF0WFyoA88a4yKCTh8pyH5z4r/u
         Ln+qn2eYHutwKEp3J4VPaRrWzeYh6hEoGKRmbV36KuieRivsG8MtDyzXpc/dSD2nSGyE
         Y6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680816319; x=1683408319;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jVlOlkoXNAtZlrEiaIusqat9aNgJfbSvvGWuZy6PpLM=;
        b=SmWBcEXadokjIawPhsDXtJ1/+WzJ5ZMTBhmvbC9dhNTROe9kJhtSiwMAR1kFSXTDTy
         Kusst/Z+b7wrh2IFzbPZ0sXaZVYqC58U3N2UO5N7eZIYZphh2GposmCGi59obw25IT6X
         JSkWn0K4rNpyvhBVx/5pkjNKSABykLvYjZf0Fe4Wl2E6kn2suC9VIOKjQV3ljo+XjDHJ
         IJ8QTQTb3eNCBfm2ifNKS6Xx7vdy7XZri04rUgG5vHfxOfC+PE6NpBwGEZnrTJ7DWDKr
         Dm+aOMxlPlHi22IJ5ZOkMuxVfxR74Z90URsbcGBVeRxn/hNQrW8smHHA1CUYIADdI9G8
         TYsQ==
X-Gm-Message-State: AAQBX9fqBdcCucAVC0zRYtOk0SMn/OGLYlPdpio7G0b25w9vy6+5hUDJ
        FjPM1o7PEYNobmv2AaI4/h0=
X-Google-Smtp-Source: AKy350aFX3Jnil974ISMRxBWnDWUfrQcQntiN20c67FNwf3zF7DQspOer8zH0Jsl0FYhRUSqt7xpGw==
X-Received: by 2002:a17:902:e752:b0:1a1:cae6:cfd with SMTP id p18-20020a170902e75200b001a1cae60cfdmr7814151plf.34.1680816318763;
        Thu, 06 Apr 2023 14:25:18 -0700 (PDT)
Received: from localhost ([67.170.148.130])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902700500b001a1c2ee06e0sm1803889plk.15.2023.04.06.14.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 14:25:18 -0700 (PDT)
Date:   Thu, 06 Apr 2023 14:25:17 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com,
        daniel@iogearbox.net, edumazet@google.com, cong.wang@bytedance.com,
        lmb@isovalent.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Message-ID: <642f38bd52cac_10ba920879@john.notmuch>
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf v5 00/12] bpf sockmap fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Fixes for sockmap running against NGINX TCP tests and also on an
> underprovisioned VM so that we hit error (ENOMEM) cases regularly.
> 
> The first 3 patches fix cases related to ENOMEM that were either
> causing splats or data hangs.
> 
> Then 4-7 resolved cases found when running NGINX with its sockets
> assigned to sockmap. These mostly have to do with handling fin/shutdown
> incorrectly and ensuring epoll_wait works as expected.
> 
> Patches 8 and 9 extract some of the logic used for sockmap_listen tests
> so that we can use it in other tests because it didn't make much
> sense to me to add tests to the sockmap_listen cases when here we
> are testing send/recv *basic* cases.
> 
> Finally patches 10, 11 and 12 add the new tests to ensure we handle
> ioctl(FIONREAD) and shutdown correctly.
> 
> To test the series I ran the NGINX compliance tests and the sockmap
> selftests. For now our compliance test just runs with SK_PASS.
> 
> There are some more things to be done here, but these 11 patches
> stand on their own in my opionion and fix issues we are having in
> CI now. For bpf-next we can fixup/improve selftests to use the
> ASSERT_* in sockmap_helpers, streamline some of the testing, and
> add more tests. We also still are debugging a few additional flakes
> patches coming soon.
> 
> v2: use skb_queue_empty instead of *_empty_lockless (Eric)
>     oops incorrectly updated copied_seq on DROP case (Eric)
>     added test for drop case copied_seq update
> 
> v3: Fix up comment to use /**/ formatting and update commit
>     message to capture discussion about previous fix attempt
>     for hanging backlog being imcomplete.
> 
> v4: build error sockmap things are behind NET_SKMSG not in
>     BPF_SYSCALL otherwise you can build the .c file but not
>     have correct headers.
> 
> v5: typo with mispelled SOCKMAP_HELPERS
> 

Still another build problem apparently we can have the
CONFIG_NET_SOCK_MSG option set with CONFIG_INET disabled.
OK I can fix it but seems a bit strange to me a sockmap
deployment without inet is mostly useless I suspect.
