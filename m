Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3406E51AE84
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377820AbiEDUCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377828AbiEDUBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:01:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D894EDEB
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 12:58:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so4873848ejo.12
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 12:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y+sByE56HbVf5kRX6gGxIKl4lkDcQYxYxjANal7cqo4=;
        b=Fisf8qNfLenDK0j792maHiYPMMvmyhGB9B3J/xS9stoAM/UZoSn3s9eWa4z58SqqtN
         zwNzc/F7jGucn3q+uOerwwvhkYcHR8WadSDg35wFqZ6iJOtuV3DgeIHYCsICPjn3FRC5
         ijS3ruVDVcid8vwK6Aeyu8cvVWuqX4vHHcMprgjz8mGjIqaTTVh5y7xE1A9w5vPgc3/M
         9OL1YFUN+X3Smqy7ONv67Xs9IxNQQJThHBH0mRzDjCqw6Y6Boyru+xViNBlwab5eTP66
         Ql7OyvNLc8tFoVxvf1pFaiO/JKRt9GNoTAQHusID9bvyAzw/qXdqG5nBEcpTVWJq8YZ4
         Z1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y+sByE56HbVf5kRX6gGxIKl4lkDcQYxYxjANal7cqo4=;
        b=hV0LhteAqNNhP761jXXjaJzZhfEnqvRvEiKt2Y4TcHvAg094PIutJA+5TdW2CCDJYg
         xWpwvFayWZVdzuRqXnPJ+NP2ZJunXzuYz9Ditzg8KJUd95iXXFhNXK0dXJmEqTNOPUAF
         DOcbIarn3JxtdNX9YSn2FbO+CmSiLO1dHY/kZhHAAPx2i+GnJ7B8Pw7Na5wDGBQ/grk2
         8X6dJJlNcFtTiBpawp//OLeojp7t0cvJCRKn1otF7zYUPli2rMMJzy6jMoz0zy6vr7Cv
         429wffjMF/GA5ChGVgJ17LKnju6bkKdzyhiRHx/Y4Lh469Gdsw1T2sJqgzXQrwN1Sal9
         MjIA==
X-Gm-Message-State: AOAM530XZwDE8O1mhTmFDexd+Gvsg0lRQ405pvhios1f+GRFC8LDtNUg
        Pb1J8Zv3qDdu8o7QnSiiEvrK5wwhspHiyZhuJpWk4A==
X-Google-Smtp-Source: ABdhPJyNqylHJlc3dOLmSwn3LLwT4ktliGhTIZtJUbCp6p9cyFNeSQSMHaaSeuuF72ZsBGrGa7DMKOVMS/2gIc+sdec=
X-Received: by 2002:a17:907:9726:b0:6f4:c0e:40ce with SMTP id
 jg38-20020a170907972600b006f40c0e40cemr21300141ejc.170.1651694293700; Wed, 04
 May 2022 12:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220504014440.3697851-1-keescook@chromium.org> <20220504014440.3697851-4-keescook@chromium.org>
In-Reply-To: <20220504014440.3697851-4-keescook@chromium.org>
From:   Daniel Latypov <dlatypov@google.com>
Date:   Wed, 4 May 2022 14:58:02 -0500
Message-ID: <CAGS_qxrPauYtkrfB37ne9bOXJR2JQc4=jaJP5tGN4mnha7mANg@mail.gmail.com>
Subject: Re: [PATCH 03/32] flex_array: Add Kunit tests
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        David Gow <davidgow@google.com>, kunit-dev@googlegroups.com,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 8:47 PM Kees Cook <keescook@chromium.org> wrote:
> +#define COMPARE_STRUCTS(STRUCT_A, STRUCT_B)    do {                    \
> +       STRUCT_A *ptr_A;                                                \
> +       STRUCT_B *ptr_B;                                                \
> +       int rc;                                                         \
> +       size_t size_A, size_B;                                          \
> +                                                                       \
> +       /* matching types for flex array elements and count */          \
> +       KUNIT_EXPECT_EQ(test, sizeof(*ptr_A), sizeof(*ptr_B));          \
> +       KUNIT_EXPECT_TRUE(test, __same_type(*ptr_A->data,               \
> +               *ptr_B->__flex_array_elements));                        \

Leaving some minor suggestions to go along with David's comments.

Should we make these KUNIT_ASSERT_.* instead?
I assume if we have a type-mismatch, then we should bail out instead
of continuing to produce more error messages.

> +       KUNIT_EXPECT_TRUE(test, __same_type(ptr_A->datalen,             \
> +               ptr_B->__flex_array_elements_count));                   \
> +       KUNIT_EXPECT_EQ(test, sizeof(*ptr_A->data),                     \
> +                             sizeof(*ptr_B->__flex_array_elements));   \
> +       KUNIT_EXPECT_EQ(test, offsetof(typeof(*ptr_A), data),           \
> +                             offsetof(typeof(*ptr_B),                  \
> +                                      __flex_array_elements));         \
> +       KUNIT_EXPECT_EQ(test, offsetof(typeof(*ptr_A), datalen),        \
> +                             offsetof(typeof(*ptr_B),                  \
> +                                      __flex_array_elements_count));   \
> +                                                                       \
> +       /* struct_size() vs __fas_bytes() */                            \
> +       size_A = struct_size(ptr_A, data, 13);                          \
> +       rc = __fas_bytes(ptr_B, __flex_array_elements,                  \
> +                        __flex_array_elements_count, 13, &size_B);     \
> +       KUNIT_EXPECT_EQ(test, rc, 0);                                   \

Hmm, what do you think about inlining the call/dropping rc?

i.e. something like
KUNIT_EXPECT_EQ(test, 0, __fas_bytes(ptr_B, __flex_array_elements, \
                        __flex_array_elements_count, 13, &size_B));

That would give a slightly clearer error message on failure.
Otherwise the user only really gets a line number to try and start to
understand what went wrong.

> +
> +#define CHECK_COPY(ptr)                do {                                            \
> +       typeof(*(ptr)) *_cc_dst = (ptr);                                        \
> +       KUNIT_EXPECT_EQ(test, _cc_dst->induce_padding, 0);                      \
> +       memcpy(&padding, &_cc_dst->induce_padding + sizeof(_cc_dst->induce_padding), \
> +              sizeof(padding));                                                \
> +       /* Padding should be zero too. */                                       \
> +       KUNIT_EXPECT_EQ(test, padding, 0);                                      \
> +       KUNIT_EXPECT_EQ(test, src->count, _cc_dst->count);                      \

This also seems like a good place to use ASSERT instead of EXPECT.


> +       KUNIT_EXPECT_EQ(test, _cc_dst->count, TEST_TARGET);                     \
> +       for (i = 0; i < _cc_dst->count - 1; i++) {                              \
> +               /* 'A' is 0x41, and here repeated in a u32. */                  \
> +               KUNIT_EXPECT_EQ(test, _cc_dst->flex[i], 0x41414141);            \
> +       }                                                                       \
> +       /* Last item should be different. */                                    \
> +       KUNIT_EXPECT_EQ(test, _cc_dst->flex[_cc_dst->count - 1], 0x14141414);   \
> +} while (0)
> +
> +/* Test copying from one flexible array struct into another. */
> +static void flex_cpy_test(struct kunit *test)
> +{
> +#define TEST_BOUNDS    13
> +#define TEST_TARGET    12
> +#define TEST_SMALL     10
> +       struct flex_cpy_obj *src, *dst;
> +       unsigned long padding;
> +       int i, rc;
> +
> +       /* Prepare open-coded source. */
> +       src = kzalloc(struct_size(src, flex, TEST_BOUNDS), GFP_KERNEL);

Looks like we could use kunit_kzalloc() here and avoid needing the
manual call to kfree?
This also holds for the other test cases where they don't have early
calls to kfree().

Doing so would also let you use KUNIT_ASSERT's without fear of leaking
these allocations.

> +       src->count = TEST_BOUNDS;
> +       memset(src->flex, 'A', flex_array_size(src, flex, TEST_BOUNDS));
> +       src->flex[src->count - 2] = 0x14141414;
> +       src->flex[src->count - 1] = 0x24242424;
> +
> +       /* Prepare open-coded destination, alloc only. */
> +       dst = kzalloc(struct_size(src, flex, TEST_BOUNDS), GFP_KERNEL);
> +       /* Pre-fill with 0xFE marker. */
> +       memset(dst, 0xFE, struct_size(src, flex, TEST_BOUNDS));
> +       /* Pretend we're 1 element smaller. */
> +       dst->count = TEST_TARGET;
> +
> +       /* Pretend to match the target destination size. */
> +       src->count = TEST_TARGET;
> +
> +       rc = flex_cpy(dst, src);
> +       KUNIT_EXPECT_EQ(test, rc, 0);
> +       CHECK_COPY(dst);
> +       /* Item past last copied item is unchanged from initial memset. */
> +       KUNIT_EXPECT_EQ(test, dst->flex[dst->count], 0xFEFEFEFE);
> +
> +       /* Now trip overflow, and verify we didn't clobber beyond end. */
> +       src->count = TEST_BOUNDS;
> +       rc = flex_cpy(dst, src);
> +       KUNIT_EXPECT_EQ(test, rc, -E2BIG);
> +       /* Item past last copied item is unchanged from initial memset. */
> +       KUNIT_EXPECT_EQ(test, dst->flex[dst->count], 0xFEFEFEFE);
> +
> +       /* Reset destination contents. */
> +       memset(dst, 0xFD, struct_size(src, flex, TEST_BOUNDS));
> +       dst->count = TEST_TARGET;
> +
> +       /* Copy less than max. */
> +       src->count = TEST_SMALL;
> +       rc = flex_cpy(dst, src);
> +       KUNIT_EXPECT_EQ(test, rc, 0);
> +       /* Verify count was adjusted. */
> +       KUNIT_EXPECT_EQ(test, dst->count, TEST_SMALL);

Just an FYI, macros get evaluated before the expect macros can stringify them.
So the error message would look something like
  Expected dest->count == 10
     but dest->count = 9

Not a big concern, but just noting that "TEST_SMALL" won't be visible at all.
Could opt for

KUNIT_EXPECT_EQ_MSG(test, dst->count, TEST_SMALL, "my custom extra message");

if you think it'd be usable to make the test more grokkable.

> +       /* Verify element beyond src size was wiped. */
> +       KUNIT_EXPECT_EQ(test, dst->flex[TEST_SMALL], 0);
> +       /* Verify element beyond original dst size was untouched. */
> +       KUNIT_EXPECT_EQ(test, dst->flex[TEST_TARGET], 0xFDFDFDFD);
> +
> +       kfree(dst);
> +       kfree(src);
> +#undef TEST_BOUNDS
> +#undef TEST_TARGET
> +#undef TEST_SMALL
> +}
> +
> +static void flex_dup_test(struct kunit *test)
> +{
> +#define TEST_TARGET    12
> +       struct flex_cpy_obj *src, *dst = NULL, **null = NULL;
> +       struct flex_dup_obj *encap = NULL;
> +       unsigned long padding;
> +       int i, rc;
> +
> +       /* Prepare open-coded source. */
> +       src = kzalloc(struct_size(src, flex, TEST_TARGET), GFP_KERNEL);
> +       src->count = TEST_TARGET;
> +       memset(src->flex, 'A', flex_array_size(src, flex, TEST_TARGET));
> +       src->flex[src->count - 1] = 0x14141414;
> +
> +       /* Reject NULL @alloc. */
> +       rc = flex_dup(null, src, GFP_KERNEL);
> +       KUNIT_EXPECT_EQ(test, rc, -EINVAL);
> +
> +       /* Check good copy. */
> +       rc = flex_dup(&dst, src, GFP_KERNEL);
> +       KUNIT_EXPECT_EQ(test, rc, 0);
> +       KUNIT_ASSERT_TRUE(test, dst != NULL);
> +       CHECK_COPY(dst);
> +
> +       /* Reject non-NULL *@alloc. */
> +       rc = flex_dup(&dst, src, GFP_KERNEL);
> +       KUNIT_EXPECT_EQ(test, rc, -EINVAL);
> +
> +       kfree(dst);
> +
> +       /* Check good encap copy. */
> +       rc = __flex_dup(&encap, .fas, src, GFP_KERNEL);
> +       KUNIT_EXPECT_EQ(test, rc, 0);
> +       KUNIT_ASSERT_TRUE(test, dst != NULL);

FYI, there's a new KUNIT_ASSERT_NOT_NULL() macro in the
-kselftest/kunit branch,
https://patchwork.kernel.org/project/linux-kselftest/patch/20220211164246.410079-1-ribalda@chromium.org/

But that's not planned for inclusion into mainline until 5.19, so
leaving this as-is is better for now.
