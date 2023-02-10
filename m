Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F1F692092
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjBJON0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjBJONZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:13:25 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B30C1E299
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:13:24 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso6368967wmp.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HN6YfBW5AAzURBx4wSEEmsOO6j55uhQOqphGruHeu0M=;
        b=EuqbSwZKh+AUE4yWddsE08cG0rjkVpaYrCeV93E2I8MQmsItGI1Fmm9GhSPvKhfCNt
         JLdr9pT4sSYHUiUz/ug8ZCVP+k0goijBXyzEfWr/oxXH4Jv/+jQA0TngOk6/WaNnXTB+
         XoV2jXrIN3Us2cXNhLunzVTqnU6qkL7WQ6wRc/axHGft8dNkYbZTtApZaCI41doh87R5
         nvMaIBIhOqSPjpcF7tLiA36Ehai9LraJwwEY2uD0YrDpV1i/iHbxWDAZXHf5XDLe/ov+
         EnkIol9einn9HDLqbrHbK/SRPj4jXS5c9QupDUqe1MwsK/99EHJj+O1BlfbT7Dx+8AaH
         tK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HN6YfBW5AAzURBx4wSEEmsOO6j55uhQOqphGruHeu0M=;
        b=Z6YB9/om81o7aAj68K8//oZjGfHVmBYNHiGmJ7cp5i4K6eHxTThgwMko4/N4qtG8No
         mOYcfaYGo1fDFgUzNrdXzZByVLbaqxxPZe6yQ/6QysOzHStbOFqL1voyaVCScHgG+NbI
         Rvhv7zqakYZzZNFsSzMMmmOcGa/prO8Zg7DsDLqRHB7MoVTvkeaOP9vjGGISM7yNj1YT
         iewaCufK96Ku1IptAd88vmSUt28pSqL2g5QrI3LesPwJQLB42pLNxAIfCa8M7Qx9wPG4
         3B5IVkdLPfatqGar8aIveJKAN8WU3U4psM+HFlucMTxPtSmCUflFAT/qki/jKVGqdhL0
         1IWA==
X-Gm-Message-State: AO0yUKUBufJpyGzMP/wXUrkufVkLfog4TicG6EAZaOjiI9S+0WwHrfyM
        tkLtMXxeQZzs+AIBD4EvoIPD5OiFu/4fVFeI1MxaYg==
X-Google-Smtp-Source: AK7set9kVv7dlm8l/lWfFWhmDNz8YvhmZegr+5PhLf1E/ew6WlIoOJBLzhMYWq+66bwtFitWYSRCEeDl0ooJFUVMxHE=
X-Received: by 2002:a05:600c:3588:b0:3df:efdc:64fe with SMTP id
 p8-20020a05600c358800b003dfefdc64femr821620wmq.54.1676038402341; Fri, 10 Feb
 2023 06:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20230210002202.81442-1-kuniyu@amazon.com> <20230210002202.81442-3-kuniyu@amazon.com>
In-Reply-To: <20230210002202.81442-3-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Feb 2023 15:13:10 +0100
Message-ID: <CANn89iJAqDMWVXR9x3DuzTkQRZKwUNivxh1b=iYPMQ5eNO+q+Q@mail.gmail.com>
Subject: Re: [PATCH v3 net 2/2] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc)
 from sk_stream_kill_queues().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        Christoph Paasch <christophpaasch@icloud.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
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

On Fri, Feb 10, 2023 at 1:23 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Christoph Paasch reported that commit b5fc29233d28 ("inet6: Remove
> inet6_destroy_sock() in sk->sk_prot->destroy().") started triggering
> WARN_ON_ONCE(sk->sk_forward_alloc) in sk_stream_kill_queues().  [0 - 2]
> Also, we can reproduce it by a program in [3].
>
> In the commit, we delay freeing ipv6_pinfo.pktoptions from sk->destroy()
> to sk->sk_destruct(), so sk->sk_forward_alloc is no longer zero in
> inet_csk_destroy_sock().
>
Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
