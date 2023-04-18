Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F246E5F54
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjDRLHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjDRLHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:07:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C129186A1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:07:17 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a5so15584823ejb.6
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681816036; x=1684408036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YbMGtsMl4LpEBDeV5WLUhPfH8r/0zxNhz5yfYBfk980=;
        b=cwpsX1sZICDQqgYMD9UDCYwC4hVap3RpdtRCdrJvDs1rxJ+1QvV22hoQpr7Q6GV5QX
         ABxPlXFqSpoPY4lYYBxsayodX8bymIE+Ga+pjI9ZPJohoNpAy5AJ6NxGGRRDxHxcjFYK
         lDGJwKBkcoXQl+dQAEa6c++cqj6Z0VCBUfzLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681816036; x=1684408036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YbMGtsMl4LpEBDeV5WLUhPfH8r/0zxNhz5yfYBfk980=;
        b=B7s40rQTqHQ3kxXbG/JnXRMoFkV6S/lsPBh6MoWjUbbkYs98dQoLKAQkJRRQh4ic5c
         m+BL43bJqXWYG61EZ9LLQbI4d9ofOVgzSa4aVoiyhT0eYZ0RBNwjpBg7vkegLfS/VeFf
         Cs61wIa4wBqCP+lKqvCvNLLJ2ncUKVaUmrXx/H2LFPF9ZWYnW5GYAL3SZiZn1fqCqHPA
         nJ52Wph3ROx8J4MzCaaJtmypdLk0SBCAcVvB3jlMNtRrr0URCZzeW9auflhjwSOxtIIg
         OD4X8knNIZyWL6cFUB3kPH+tfbnzhiyYmj2Z74Km8/QJ/A54U/1RLa5YFLZ144x6vKaj
         fPGw==
X-Gm-Message-State: AAQBX9dOVLfscGrGfgdvFZsTIll5KnCPMLt8VsWgNloBOuV9aHfynfrU
        FKdbZGw68eTYEuVJvvfJiDWZjV3ciQarU0SgxgONPw==
X-Google-Smtp-Source: AKy350bLdPifKZWFxQXyzOxtWqmD1ybL9R/DMpY4vTvy+NCfkiJ6z8iL8CLw6GFEgVLibKq1GL/MQw5qb1V0e8pFm6E=
X-Received: by 2002:a17:906:af1a:b0:8b8:aef3:f2a9 with SMTP id
 lx26-20020a170906af1a00b008b8aef3f2a9mr4546919ejb.0.1681816036230; Tue, 18
 Apr 2023 04:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk> <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk> <CAHApi-=ODe-WtJ=m6bycQhKoQxb+kk2Yk9Fx5SgBsWUuWT_u-A@mail.gmail.com>
 <874jpdwl45.fsf@toke.dk>
In-Reply-To: <874jpdwl45.fsf@toke.dk>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Tue, 18 Apr 2023 13:12:00 +0200
Message-ID: <CAHApi-kcaMRPj4mEPs87_4Z6iO5qEpzOOcbVza7vxURqCtpz=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> In addition, presumably when using this mode, the other XDP actions
> >> (XDP_PASS, XDP_REDIRECT to other targets) would stop working unless we
> >> add special handling for that in the kernel? We'll definitely need to
> >> handle that somehow...
> >
> > I am not familiar with all the details here. Do you know a reason why
> > these cases would stop working / why special handling would be needed?
> > For example, if I have a UMEM that uses hugepages and XDP_PASS is
> > returned, then the data is just copied into an SKB right? SKBs can
> > also be created directly from hugepages AFAIK. So I don't understand
> > what the issue would be. Can someone explain this concern?
>
> Well, I was asking :) It may well be that the SKB path just works; did
> you test this? Pretty sure XDP_REDIRECT to another device won't, though?
>

I was also asking :-)

I tested that the SKB path is usable today with this patch.
Specifically, sending and receiving large jumbo packets with AF_XDP
and that a non-multi-buffer XDP program could access the whole packet.
I have not specifically tested XDP_REDIRECT to another device or
anything with ZC since that is not possible without driver support.

My feeling is, there wouldn't be non-trivial issues here since this
patchset changes nothing except allowing the maximum chunk size to be
larger. The driver either supports larger MTUs with XDP enabled or it
doesn't. If it doesn't, the frames are dropped anyway. Also, chunk
size mismatches between two XSKs (e.g. with XDP_REDIRECT) would be
something supported or not supported irrespective of this patchset.
