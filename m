Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643986D8B88
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjDFAOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjDFAOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:14:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365115B9A;
        Wed,  5 Apr 2023 17:14:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id kq3so35949697plb.13;
        Wed, 05 Apr 2023 17:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680740056; x=1683332056;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qInFTMVuma/1U/ExvGc6BZLbekGojBtLyDDjkV4HnlU=;
        b=QbcFAsF0nJsFYsGxawligS9Oggy4lOA3uZwDLUK4pDRBpVCrmUNvSHb9UtvZWn3U73
         7GdsQPwxyDwuQ5/4MvwXlIUzJpjUtMKikozJe1x8LhaVkaGrj8INWgDP/revaC8sNanA
         +djKmXrx3rdcqYiB0nz8xnxQZBhIRLP2ll8C9BPWhzdt5j4YlGDr5r2o99o6b5q2WMUf
         T8Om2PhZJlVtqcwiHkQz8bvn6hq/a3T0bA38g4O4I2AyrfC8gUPmifmiBSWGk59Q8Qbw
         Wn4cyi2PijH4BStkoDs/wyK336eI/YQZdxWrjzfSy+uQvWXTe1fpSKDpM1wKUOk3NwKB
         PIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680740056; x=1683332056;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qInFTMVuma/1U/ExvGc6BZLbekGojBtLyDDjkV4HnlU=;
        b=fDQD78DuVMTrSg6NQlFXD2jFIq9eJG4t3JIFWvKpOG8Lkq2R0/vrwioGN6gH/pEFXH
         ih3i97+piTEt313RsGHDG5dch3mrrkYlOua6mYJMHtjyn3aPNSiv/EfdMr+kGEe6vGkD
         HpUXkfo3lzwGOfH/Sqx808Wt42MEKTtAtV42m9adBbs1X/0hSwA8ZgpZgTBQcNaEFMLk
         urmzuZl5WdTtLKrpFKe1ae/CcUXo9Msk6UO4maBG3MRiBs6AVGzNOCZQ4E2pXP4oGrRe
         iEUqHsxHteNBz8He3ByjYwaw1zoDZ2BnlzUNXTLWOyjaK5QcOH1e800FhMCWrzbLNu2a
         wo4w==
X-Gm-Message-State: AAQBX9cADk/dSVG85uJgQzd+WwUfjjAYlgeXhh27YqpBNSRdeZb1nI+q
        ZfgMMCrCwFb/WN7pa2NZ/ek=
X-Google-Smtp-Source: AKy350YFdh/WfNfq5FSxt7gKSoI4EMNZOfE9joSY9SydyNN/tHC+wUOdluIJyggg0fRXYDfEeMJW+A==
X-Received: by 2002:a17:902:fa87:b0:1a1:7899:f001 with SMTP id lc7-20020a170902fa8700b001a17899f001mr7523281plb.42.1680740055651;
        Wed, 05 Apr 2023 17:14:15 -0700 (PDT)
Received: from localhost ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id bf2-20020a170902b90200b00186cf82717fsm93926plb.165.2023.04.05.17.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 17:14:15 -0700 (PDT)
Date:   Wed, 05 Apr 2023 17:14:13 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com,
        daniel@iogearbox.net, edumazet@google.com, cong.wang@bytedance.com,
        lmb@isovalent.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Message-ID: <642e0ed567494_37d6a208a5@john.notmuch>
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf v4 00/12] bpf sockmap fixes
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

Will send a v5 with typo fix. Thanks.
