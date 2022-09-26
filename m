Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169C5E977C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 02:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiIZAjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 20:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiIZAiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 20:38:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C84193CE
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 17:38:50 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bh13so5186797pgb.4
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 17:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZsMZDiPJ05dqPEjOyzQRRCQyAniieUtquk7D7/uc9oo=;
        b=EloZHChUwOJ+IAK+dqPRjhd24FYS6MkmFqZpedddEJP3NPIP54FWcwg3RKRz6Ai8pZ
         z2DviABmbm5Ne8x7+vcrgYA1N3bmoOgjdNpOgYz+yaXmcZ9y56Pdoen1P+xANPX4dHu4
         HiKqS9DzqPcFKjopFBXMCDEaM898Bv94O7hJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZsMZDiPJ05dqPEjOyzQRRCQyAniieUtquk7D7/uc9oo=;
        b=mIEXnqn/nKMqpN0P/j5XFaq1iyVFG2mg7UPepwwBC4rMq26dH/KGLVj/+fCVwlo8/M
         RHTdyqfEN18c3xnROhS60HoD8ewLlbtrBUY/LbxKGdUi8fS0jK2WlkjRKxFP5F3ozJNT
         7PguiQadmQ7muSBAQLJ9DEhPLAfRAGRzCfC9DkhYMdC4j2rEbJtCbsW01z0SFHDksUR9
         2TLJ6iwHkXAOKuptcC3sfSMpaqflOscDUYsVfUAt56Euo5o6ana67agxDqWkHgXSnkOm
         yY6t+bkUWF75Vae1I8UjV+7yAqx1/KifVQ7IdIQGLIZ9/p0AMkL5WlTPUwVYxBekpFf2
         y8nQ==
X-Gm-Message-State: ACrzQf3zqy8uPg3QX+eNwJ6Uibl1LLTh8aBezmy02zeBCYo0GGOxJVGc
        QbPpLBrcOnF8ncOg5qOTggoVfg==
X-Google-Smtp-Source: AMsMyM7j48vn8CX614C8f5vlUd1g6FcIEIYyyHHTpwyTo0bx6Hew8gRK92T2JHXk4G8JNUKlDJxOQQ==
X-Received: by 2002:a63:4b1d:0:b0:439:e6a4:e902 with SMTP id y29-20020a634b1d000000b00439e6a4e902mr18048148pga.212.1664152730415;
        Sun, 25 Sep 2022 17:38:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t11-20020a17090340cb00b00172951ddb12sm9640855pld.42.2022.09.25.17.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 17:38:49 -0700 (PDT)
Date:   Sun, 25 Sep 2022 17:38:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 14/16] kasan: Remove ksize()-related tests
Message-ID: <202209251738.6A453BC008@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-15-keescook@chromium.org>
 <CACT4Y+bg=j9VdteQwrJTNFF_t4EE5uDTMLj07+uMJ9-NcooXGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bg=j9VdteQwrJTNFF_t4EE5uDTMLj07+uMJ9-NcooXGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 10:15:18AM +0200, Dmitry Vyukov wrote:
> On Fri, 23 Sept 2022 at 22:28, Kees Cook <keescook@chromium.org> wrote:
> >
> > In preparation for no longer unpoisoning in ksize(), remove the behavioral
> > self-tests for ksize().
> >
> > [...]
> > -/* Check that ksize() makes the whole object accessible. */
> > -static void ksize_unpoisons_memory(struct kunit *test)
> > -{
> > -       char *ptr;
> > -       size_t size = 123, real_size;
> > -
> > -       ptr = kmalloc(size, GFP_KERNEL);
> > -       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> > -       real_size = ksize(ptr);
> > -
> > -       OPTIMIZER_HIDE_VAR(ptr);
> > -
> > -       /* This access shouldn't trigger a KASAN report. */
>  > -       ptr[size] = 'x';
> 
> I would rather keep the tests and update to the new behavior. We had
> bugs in ksize, we need test coverage.
> I assume ptr[size] access must now produce an error even after ksize.

Good point on all these! I'll respin.

-- 
Kees Cook
