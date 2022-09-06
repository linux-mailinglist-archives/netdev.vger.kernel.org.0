Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6382C5AF3CC
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 20:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiIFSiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIFSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 14:38:13 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA18880039;
        Tue,  6 Sep 2022 11:38:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gh9so3374724ejc.8;
        Tue, 06 Sep 2022 11:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2vJ8FGNUWqNGrwFrjilO8GSXb55Nwy+/cJ8JAN+vf/Q=;
        b=SUKr1jsDOLNqamb/0igyvl0avGj607M0DPUstfTFcJTLuWl4LanT0/YoRCYm9eA69u
         1kj4fVTiWUjtqCnFI0C6ZoFg5/RqkmqAv98TqohWLkwkUomyZAcUp1dsGY+pQq6u+q+w
         tOjNN1cBakyHjgUr+MPj1XXwywhuJ1z6JmzTF5sqGB4jAMUH7+BLZy8fOn3pCu3NXQQg
         z33jqnAPLObqF8syJeAU1+viuExfeIdnfLvhtgx1RKxaa+ywUEk/vuS7cVplJK7ofQIb
         MDZX3vYfbZSTXO77p6gMRjdYdm+gKaNqZ0+Iv4tRrwj9ndqopTptF6xzlsPY6BHhmmq2
         q14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2vJ8FGNUWqNGrwFrjilO8GSXb55Nwy+/cJ8JAN+vf/Q=;
        b=v7Aq+IXoJFIKs/LNQOjaK/M8PE9V9c+BG7Rr9AdDgyV4UPVCJ0NVbOnfIe1c6Kgllh
         hhiAgfOBjigE+4JZ/C+Jj3dBXj09G/DSvNPajeenpashYRprFSebwSCmhLRR8qErUwxh
         s7VD7QTL4cK1O3hgp11TQUMaaf0wx0Ug9y66m0usUiRFXWuLLzAsz+yRhE2XKdiFyOiR
         bOEsx7piXmF+SPyHSxsNHtl18yd+6eLItM1lAw8zRbh4zlWe/HmaOkb+lkgf+Y2VaAlN
         /KBzanoz1dlZIJso+TQlx5kS6OOTGOSY/UfiLIE7oN1vMJwh3VDuan2fyWJqmB7LgmoR
         n+qA==
X-Gm-Message-State: ACgBeo0Wn+9lSw2Kyfo852YK/5FSAoVtnmhhqgCIwQ5CekIZHAmFN8u6
        XrFWhIC2n441Ab98i+5lwaNgQHqh335XrBLc56s=
X-Google-Smtp-Source: AA6agR6Fao8GdRMU9Boeo6RrjyWxi8jemda0qoa7GZAmSudyHUWqHOtxrprir6nYy7TaNbFl5BgDhJcydhPRqP6/mJY=
X-Received: by 2002:a17:906:58d1:b0:76d:af13:5ae3 with SMTP id
 e17-20020a17090658d100b0076daf135ae3mr6712594ejs.708.1662489491088; Tue, 06
 Sep 2022 11:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220906165131.59f395a9@canb.auug.org.au> <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
In-Reply-To: <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 11:37:59 -0700
Message-ID: <CAADnVQJTDdA=vpQhrbAbX7oEQ=uaPXwAmjMzpW4Nk2Xi9f2JLA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the slab tree
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 12:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 9/6/22 08:51, Stephen Rothwell wrote:
> > Hi all,
>
> Hi,
>
> > After merging the slab tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > kernel/bpf/memalloc.c: In function 'bpf_mem_free':
> > kernel/bpf/memalloc.c:613:33: error: implicit declaration of function '__ksize'; did you mean 'ksize'? [-Werror=implicit-function-declaration]
> >    613 |         idx = bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE_SZ));
> >        |                                 ^~~~~~~
> >        |                                 ksize
>
> Could you use ksize() here? I'm guessing you picked __ksize() because
> kasan_unpoison_element() in mm/mempool.c did, but that's to avoid
> kasan_unpoison_range() in ksize() as this caller does it differently.
> AFAICS your function doesn't handle kasan differently, so ksize() should
> be fine.

Ok. Will change to use ksize().
