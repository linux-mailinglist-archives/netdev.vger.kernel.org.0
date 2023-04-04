Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18BC6D61B0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbjDDMyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbjDDMyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:54:19 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2903A3A9A;
        Tue,  4 Apr 2023 05:54:12 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5456249756bso611555617b3.5;
        Tue, 04 Apr 2023 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GBoR05ONySxxhgKIii08lMTHzVRyAQG8q9irevkw9T4=;
        b=ZTPeimleyFzVxcEW1lCVGD0FQnOV54vk3xFhJQJIRe2K6svhNx6Wv6rsBX/wXrr8JI
         a3el4IR8fn162mvqmjHyGdv69q4XkTUTlf4O/JnsKvdjCD6RcvQHR3NJJ0eOK5Iz9jY0
         413sZIUxgj+TK7Z/g8Ax8qXs8bv7N8FkUFO6uK4f6L4RNarLZeWkJHYhiGIkoNYVvukI
         n6ef+0Zz9fCcUbfS5hOEUQG3MFSvrRXlIli31ok9shVO1a7QNyvSc1Az3NrLCFNfTgJw
         GDbmASYy3cfZT7fKXtang+F+xB2TkaxSaOyt1cq/8bcE5xdnZIWrZUhL7iBIxeh/U0OY
         mhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBoR05ONySxxhgKIii08lMTHzVRyAQG8q9irevkw9T4=;
        b=vYX9coxpApWYuIUrVL7IcbWwhdzJatLntaN3mW1uYUUaa8Z8jkHQq4cBZ3Kd592sC+
         /T4cNLp/QcWLL9l5XeuSGjWJeKeUSA2r3Pq9pm9CF9iq9NDi9HOooaznjLLaP8x8pD5Q
         5//VwJjAMRFkoKBIMvYcduQqDiEMOkQiNuABc7SPq9IXvVa5F7yeisYlY5t9ZH7Erb+D
         wk1b6rUeNtT97Cj4IN2kJsGC2DhZX/V5ZsPnjlffKimwdT2QVJp5Qi7T29l4NSsu6U9S
         7V+CULdCaWBlQ5aI/i8lLHcI5VODIRTPHLjWhjuqfNk6ZhEYd4c5BjpQ6Lx84bRak3dR
         xnvw==
X-Gm-Message-State: AAQBX9cg+G3TkRlBWYsL89sr9ZOPZUlX4Tbpy6sohIzN5NO7qqLu3jsB
        zs++4FNExAqPTttZDKgglKeK+XNdSU59L3WVfDU=
X-Google-Smtp-Source: AKy350aIsS45OIJCKiiQOXVNjfwbV5m+AHCE0gtJEr/EQuFvqLoDudBbQksBbJ8EAYqscusudninaqqaBy9JV3ZfKow=
X-Received: by 2002:a81:e60d:0:b0:544:94fe:4244 with SMTP id
 u13-20020a81e60d000000b0054494fe4244mr1386664ywl.10.1680612851267; Tue, 04
 Apr 2023 05:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-9-kal.conley@dectris.com> <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
 <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
 <CAJ8uoz0SEkcXQuoqYd94GreJqpCxQuf1QVgm9=Um6Wqk=s8GBw@mail.gmail.com>
 <CAHApi-=ui3JofMr7y+LvuYkXCU=h7vGiKXsfuV5gog-02u-u+Q@mail.gmail.com>
 <CAJ8uoz0GgzzfrgS0189=zwY-zzogZq+=v-NCY7O+RuWrwe1n6w@mail.gmail.com>
 <CAHApi-kVF5dS=ym7PXttCVAz7jEod2cOhh27YYwkidCUogu6-A@mail.gmail.com> <CAHApi-mXt27N0dWW1QN5qZ6OOV9uVGxc-kuEd+SBF8hDJ2NPXA@mail.gmail.com>
In-Reply-To: <CAHApi-mXt27N0dWW1QN5qZ6OOV9uVGxc-kuEd+SBF8hDJ2NPXA@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 14:54:00 +0200
Message-ID: <CAJ8uoz3ORFU1b8Fd8vJ0GGrnCJLcVC+Av=YU4HzbfY9T5P2GDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 at 14:32, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> > > > > > > Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
> > > > > > > xdp_umem_reg()?
> > > > > >
> > > > > > The absolute max is 64K. In the case of HPAGE_SIZE < 64K, then it
> > > > > > would be HPAGE_SIZE.
> > > > >
> > > > > Is there such a case when HPAGE_SIZE would be less than 64K? If not,
> > > > > then just write 64K.
> > > >
> > > > Yes. While most platforms have HPAGE_SIZE defined to a compile-time
> > > > constant >= 64K (very often 2M) there are platforms (at least ia64 and
> > > > powerpc) where the hugepage size is configured at boot. Specifically,
> > > > in the case of Itanium (ia64), the hugepage size may be configured at
> > > > boot to any valid page size > PAGE_SIZE (e.g. 8K). See:
> > > > https://elixir.bootlin.com/linux/latest/source/arch/ia64/mm/hugetlbpage.c#L159
> > >
> > > So for all practical purposes it is max 64K. Let us just write that then.
> >
> > What about when CONFIG_HUGETLB_PAGE is not defined? Should we keep it
> > set to PAGE_SIZE in that case, or would you like it to be a fixed
> > constant == 64K always?
>
> Sorry. Now it's not clear to me if you are suggesting the
> documentation be changed or the code or both?

The documentation.
