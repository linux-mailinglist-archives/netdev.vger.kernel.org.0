Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6741F610119
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiJ0TGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiJ0TF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 15:05:57 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E3E54CBB;
        Thu, 27 Oct 2022 12:05:57 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id d18-20020a05683025d200b00661c6f1b6a4so1634799otu.1;
        Thu, 27 Oct 2022 12:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A1XprAgWB0s7wiMtyLLvIEnH2hN1akKHT1cSrZfMn0g=;
        b=Sqz2uDjbQlvvJWBpIM/mzfHIsX9oc4U1Fvobpx7j4awZ289LhDdgt28RgrQ7eUUrYb
         bd/0+diGJAN9IGyFXNpPjroo3xxI7q5obkLaSI9dnXviOhXHyiaC0YPBi3sEikUxPPVL
         xUdSTHktkBwkoN6/HQ9/REsmPkc4LFqNsw4o5T+4mAZ5LYgDyPs1IJhEL5RxVwgq8DFw
         bO/aXGKYUNL2Ab3Fq2mfiDB00NJScK6qG5AWF+4LrN2F8fg9zybgp/OMWI/GzYIrPNTg
         /FL+1zOWNkqqBMHCXP0DrsKWvv92+4659qPZzhbk08RzU1aA1lFOo0kJdjkrhWkMobU5
         i02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A1XprAgWB0s7wiMtyLLvIEnH2hN1akKHT1cSrZfMn0g=;
        b=E1Y2zvUjsBh2d61ki7j3T8zhLrMCPCukfguVoOWb9jVCNPuk770r/Ln2ir1ok6F8r0
         ZddSDcqjwX7p+wzt8spykis2+CFgWvZkbl9KNI8P2hdEqB+msvr4tVExEckv4ukT/ooF
         tSf0hBJJEffATw7fJUaYyHJSyifEaBt9hAGQiJyd0tZW+3shOoW9GDcc/wEQBS65lV/y
         swlBPEW4hadIl/oOy0Yl4aumwtEwPpx5lCOb+BtCXCRn8kqo3C38b3q349SiJg/eWh8D
         0VEtbI8U6so2VaTUYsy4kwS9Hc2GoMBYAzfpRPhNKvoyEXKvYnaRHotSWfFw47U/MCIp
         4xMg==
X-Gm-Message-State: ACrzQf1jxtbzRCdwvn1JZXul6Jr+kDhfOuTyZDRQSynJ//IcUepeTTIn
        LkyFWb87k5k/eEbOdEjQo9zAfOLSyApd0DkW/tE=
X-Google-Smtp-Source: AMsMyM62sEmSG5aCY0b4YK8+TARwW55i4i3cprSqu9DEfEpzzWfueCTetYFLRwjOVkDhkr+y6lZqaDEu+nmEdLaT55w=
X-Received: by 2002:a9d:5c02:0:b0:65c:20e6:46a with SMTP id
 o2-20020a9d5c02000000b0065c20e6046amr23632464otk.213.1666897556488; Thu, 27
 Oct 2022 12:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221022180455.never.023-kees@kernel.org>
In-Reply-To: <20221022180455.never.023-kees@kernel.org>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Thu, 27 Oct 2022 21:05:45 +0200
Message-ID: <CA+fCnZcj_Hq1NQv1L2U7+A8quqj+4kA=8A7LwOWz5eYNQFra+A@mail.gmail.com>
Subject: Re: [PATCH] mm: Make ksize() a reporting-only function
To:     Kees Cook <keescook@chromium.org>
Cc:     Christoph Lameter <cl@linux.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 8:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> With all "silently resizing" callers of ksize() refactored, remove the
> logic in ksize() that would allow it to be used to effectively change
> the size of an allocation (bypassing __alloc_size hints, etc). Users
> wanting this feature need to either use kmalloc_size_roundup() before an
> allocation, or use krealloc() directly.
>
> For kfree_sensitive(), move the unpoisoning logic inline. Replace the
> some of the partially open-coded ksize() in __do_krealloc with ksize()
> now that it doesn't perform unpoisoning.
>
> Adjust the KUnit tests to match the new ksize() behavior.

Hi Kees,

> -/* Check that ksize() makes the whole object accessible. */
> +/* Check that ksize() does NOT unpoison whole object. */
>  static void ksize_unpoisons_memory(struct kunit *test)
>  {
>         char *ptr;
> @@ -791,15 +791,17 @@ static void ksize_unpoisons_memory(struct kunit *test)
>
>         ptr = kmalloc(size, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> +
>         real_size = ksize(ptr);
> +       KUNIT_EXPECT_GT(test, real_size, size);
>
>         OPTIMIZER_HIDE_VAR(ptr);
>
>         /* This access shouldn't trigger a KASAN report. */
> -       ptr[size] = 'x';
> +       ptr[size - 1] = 'x';
>
>         /* This one must. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
> +       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);

How about also accessing ptr[size] here? It would allow for a more
precise checking of the in-object redzone.

>
>         kfree(ptr);
>  }

Thanks!
