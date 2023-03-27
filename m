Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CA6CACDB
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjC0SRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC0SRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:17:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8625213C;
        Mon, 27 Mar 2023 11:17:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id fb38so6296936pfb.7;
        Mon, 27 Mar 2023 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679941068;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Vi/Vv4Ii7DOvoFpFwntmDUanvKO2EfmjxpTZ1StCdY=;
        b=I26JdAX+3TuKYJjsCYyzhZ9B09gut/FTRMAvLKPKWdkPU9mZgCjwhb1k94kK8ks8iA
         QJA+vQ3ymv/++GennEwkjrDo9C6Ff7qrdU+IOpbQjBMvD0Tj2Ktkg38a2Exhp33nrJR6
         w2yUoW/LwEAtbqeNkiGyXLqSHPvttQENVcVaZ4/aIXUqjxwZAgyFp9lpzhonluRkcU2l
         O3p3oBDuVEWAzcQaRVWDg5YVUJc7ws78TB/JeNuF0ZRhXxj/xIxiQsJ3YxhaQvVbPDjJ
         yytbG6pdnK5Bte0ZfKA/LOywNxSs2sCO2QIemIzHEnzw58K5+VO1GGxJKjNa8qkcUnh1
         CVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679941068;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+Vi/Vv4Ii7DOvoFpFwntmDUanvKO2EfmjxpTZ1StCdY=;
        b=LaCysDhem23M8ScseagGSppASG2ZHy2ttGTVwX8aQ7mLRVcIOTO+jDuW5OFLb8B0Br
         68PMvnaCFoHqmycq1Q2xr+ZWYcymrxGw5Bj+It+vDKJsZjC3dFnkrN1wJXDN0QAUwDTK
         ElUKcUqplOc1JYA4QPPgASdDWlemHPt0967GCC62L8+4EV1DrG1jYwI3EDGP8YjAEFCy
         Q2LXW0eWNuTsAvIunEwOrPHudWf/ujblSt3TESvAfArTVxRi6ItLM1gI3wkby3eZ+N2K
         Tfyp4nsifjSUGPK9XK420iMr8KmUyN4a+b0ELjy8VpRK+UuJml2oA54E/qyHtQML3Aao
         KClQ==
X-Gm-Message-State: AAQBX9cm9iFzwcJ7fU/XkHPopBCc0h+rC4ebNBHXaN7QEyq5XEF6OzL6
        mMfCwJAzqbb/LdOpxkyIryk=
X-Google-Smtp-Source: AKy350Y8012cAr/N6sF0Ywui6BJ1fiKkY6zGyYY2AJjke0ROq/QFduoR2RbH8S8BdP+vcVAL/vuuKg==
X-Received: by 2002:aa7:9696:0:b0:5a8:bcf2:125 with SMTP id f22-20020aa79696000000b005a8bcf20125mr12462613pfk.21.1679941068276;
        Mon, 27 Mar 2023 11:17:48 -0700 (PDT)
Received: from localhost ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id x4-20020aa79184000000b005a8b4dcd21asm19930470pfa.15.2023.03.27.11.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:17:47 -0700 (PDT)
Date:   Mon, 27 Mar 2023 11:17:45 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, cong.wang@bytedance.com,
        jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Message-ID: <6421ddc9f15b8_18d4f208ec@john.notmuch>
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
Subject: RE: [PATCH bpf v2 00/11] bpf sockmap fixes
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
> Finally patches 10 and 11 add the new tests to ensure we handle
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

Sorry folks on the to line there I resent with the cc list here. I had
suppressed the CC list in the first batch.

.John
