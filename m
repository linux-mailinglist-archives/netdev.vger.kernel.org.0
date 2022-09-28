Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE05EE2CC
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 19:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiI1ROM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 13:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiI1RNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 13:13:45 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CD0F1854
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:13:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v1so12270260plo.9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 10:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=d6n7vVcWWAUhY50nx1oX+SjTLgFqeY1Yq8iTalyfqd0=;
        b=lIRHIZiWHITqRmakxRZHSG2SU2bpWinoR3Swar+fPYJBmT1qOO/MT6WnWN5yBDlhGu
         /lQXgjvlz0O4V2+hnYy+98Yh09p4wB3YUjZ22bnBWEa9dMSwUm7gVI6Ae5kXcacwBn8L
         BoOjiPYblWsCdJGhH6goLGXzHmU5/JoB80oyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=d6n7vVcWWAUhY50nx1oX+SjTLgFqeY1Yq8iTalyfqd0=;
        b=0Yb49KZb68S6h4pxZ3shgnhUnr8m6a5bDDTmesaSzUdjx97RIXbRBOFZxTjtRp3yBh
         xzCm0gDClnZlWoNNSAL64xDouBFTuyQmRs09pSi8IvodTBACHih7VDau6D16FYl//ZkT
         Rlb5MI1LbxicouZzZoz+RKWHvXyNR+4LANjVVcBiVS0TOOEdlLHflQm4nNSfTuOpt1U/
         +CIuKukugE+quM2Mhdf3r7qWxtX+97Fi6CfUtTWAsrSd2wNSzYoC642u/Z2pHbiYZf+K
         UlXelAzhDF5D10T4cHLmO+5y17YnXABZEFNaHWugrpE+O5tyQqOOtubSPuY4Ti1b39hg
         sW+Q==
X-Gm-Message-State: ACrzQf3CcQ7AgcxDEt4+/HgUEY+fAydfk1bBe2wshVVFnotZLVvV/xWe
        P8CYn4Cgo7efK1ppjAie26PTMw==
X-Google-Smtp-Source: AMsMyM6sCBBdOCLg/ekAp2unP2+2il2GSYEdTvWU2WPyIonTKW/L3Ua/pLmu7ZGbcH4WrqStMgqaPQ==
X-Received: by 2002:a17:902:db08:b0:176:d40e:4b57 with SMTP id m8-20020a170902db0800b00176d40e4b57mr799977plx.172.1664385194575;
        Wed, 28 Sep 2022 10:13:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b00177faf558b5sm4082449plx.250.2022.09.28.10.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 10:13:13 -0700 (PDT)
Date:   Wed, 28 Sep 2022 10:13:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Marco Elver <elver@google.com>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
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
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc
 functions
Message-ID: <202209281011.66DD717D@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-2-keescook@chromium.org>
 <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 09:26:15AM +0200, Geert Uytterhoeven wrote:
> Hi Kees,
> 
> On Fri, Sep 23, 2022 at 10:35 PM Kees Cook <keescook@chromium.org> wrote:
> > The __malloc attribute should not be applied to "realloc" functions, as
> > the returned pointer may alias the storage of the prior pointer. Instead
> > of splitting __malloc from __alloc_size, which would be a huge amount of
> > churn, just create __realloc_size for the few cases where it is needed.
> >
> > Additionally removes the conditional test for __alloc_size__, which is
> > always defined now.
> >
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > Cc: Marco Elver <elver@google.com>
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Thanks for your patch, which is now commit 63caa04ec60583b1 ("slab:
> Remove __malloc attribute from realloc functions") in next-20220927.
> 
> Noreply@ellerman.id.au reported all gcc8-based builds to fail
> (e.g. [1], more at [2]):
> 
>     In file included from <command-line>:
>     ./include/linux/percpu.h: In function ‘__alloc_reserved_percpu’:
>     ././include/linux/compiler_types.h:279:30: error: expected
> declaration specifiers before ‘__alloc_size__’
>      #define __alloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__) __malloc
>                                   ^~~~~~~~~~~~~~
>     ./include/linux/percpu.h:120:74: note: in expansion of macro ‘__alloc_size’
>     [...]
> 
> It's building fine with e.g. gcc-9 (which is my usual m68k cross-compiler).
> Reverting this commit on next-20220927 fixes the issue.
> 
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/14803908/
> [2] http://kisskb.ellerman.id.au/kisskb/head/1bd8b75fe6adeaa89d02968bdd811ffe708cf839/

Eek! Thanks for letting me know. I'm confused about this --
__alloc_size__ wasn't optional in compiler_attributes.h -- but obviously
I broke something! I'll go figure this out.

-Kees

-- 
Kees Cook
