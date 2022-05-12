Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7D565256D1
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358616AbiELVBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358599AbiELVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:01:46 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909C2527E7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:01:45 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id s30so11985034ybi.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OqrE7bRcv39oBwB0RI7tDN3DxCr1y12xEkN7y2T+Fx0=;
        b=jPwJ+LwDgoMZZm8Ibd09BTwTLFw5e0rSA7bHdyWLPrYe/WifghmsA4fbs0LqPXgfTY
         TX2l1cYKDfzRfIbExpWX0oDsO7O26iZj1ocFfyzJ1jUtv/gLIdF/Wh6APzVFiQJiRETS
         H3XcLetsFbcDS3MyVBTW8tBUAGHfiYJxl+XESQilJdyIT4tlm2nsHQssNR3/3BmmaAFq
         MWELVPdvviwb83XLFAOQmlWsNXF7yhsKytTcsMjja2aILDUKskofYSg5hhx2E16ftqwv
         3XQgcO4lNTXAP41lod+HEpxS6d/8TFO7btFJRiK6D8UetacQi95GzJYQQRQv65gbRNNL
         d7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OqrE7bRcv39oBwB0RI7tDN3DxCr1y12xEkN7y2T+Fx0=;
        b=nJ598RAJZZRZOPQEfmvY8btpf0/+1FXs0Qd1K+oJFTVe8KYE+KqZiTHde2WG/jXCEI
         a+kzOmQS81xoD4ShLrqyVNaE34erD0ZcBqst8pncEYZ9Fgdiw6/iE1PNMCpvFGcA3ebf
         QEwA+Mgns0rqeDnDnXSfTNQ9BUS6ccGUepxO+FmVguB/7/xwStV0MgAMmhrwMG+y0pMI
         2848x4PQEENmk9fYVcwoqwgNb/3N4IGwWkN0xqJR9G9STMlasxu3clZz4gdXK1sT11AD
         YZmPJr0iDx2XcUODtx0iSFEcg0IyBhrqgn00DFTUbKlNoau2rvpHph5dR6bG/nb9R287
         AUCA==
X-Gm-Message-State: AOAM533UIqy365UV7Aw+5eBvX50xxQXYme/AzRmAVxdjJj2qLlmNTp0p
        LKyXneAtGlqbmsGLw8CS37kjjHpmpTdAixmWz6zk0g==
X-Google-Smtp-Source: ABdhPJz9lNtOe/+2bLeLzIbcPxKAHm+9f2H4tmkQ2iNFQFAuWctN6eLVstmzD9cqk2RkVogv3BGNj2kmWgI/GkwhAKQ=
X-Received: by 2002:a05:6902:1007:b0:649:7745:d393 with SMTP id
 w7-20020a056902100700b006497745d393mr1737539ybt.407.1652389304565; Thu, 12
 May 2022 14:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220512000546.188616-1-kafai@fb.com>
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 14:01:33 -0700
Message-ID: <CANn89iLHHJeqRBnoe9Eck72sFFo2eX7XDh2w-Ux7HMMvk0=45Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: inet: Retire port only listening_hash
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>, Paolo Abeni <pabeni@redhat.com>
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

On Wed, May 11, 2022 at 5:05 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This series is to retire the port only listening_hash.
>
> The listen sk is currently stored in two hash tables,
> listening_hash (hashed by port) and lhash2 (hashed by port and address).
>
> After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an address")
> and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"),
> the TCP-SYN lookup fast path does not use listening_hash.
>
> The commit 05c0b35709c5 ("tcp: seq_file: Replace listening_hash with lhash2")
> also moved the seq_file (/proc/net/tcp) iteration usage from
> listening_hash to lhash2.
>
> There are still a few listening_hash usages left.
> One of them is inet_reuseport_add_sock() which uses the listening_hash
> to search a listen sk during the listen() system call.  This turns
> out to be very slow on use cases that listen on many different
> VIPs at a popular port (e.g. 443).  [ On top of the slowness in
> adding to the tail in the IPv6 case ]. A latter patch has a
> selftest to demonstrate this case.
>
> This series takes this chance to move all remaining listening_hash
> usages to lhash2 and then retire listening_hash.
>
> Martin KaFai Lau (4):
>   net: inet: Remove count from inet_listen_hashbucket
>   net: inet: Open code inet_hash2 and inet_unhash2
>   net: inet: Retire port only listening_hash
>   net: selftests: Stress reuseport listen
>

Nice patches, thanks Martin.

Reviewed-by: Eric Dumazet <edumazet@google.com>
