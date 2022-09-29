Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC66D5EF09E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiI2Ige (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiI2Igc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:36:32 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7E211C16F;
        Thu, 29 Sep 2022 01:36:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MdRXW0Bs9z4xGG;
        Thu, 29 Sep 2022 18:36:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1664440575;
        bh=Zm00l+zmqsCWLK3LqHtfXzxyyxS1KKRiDBtm93jjX9o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HvksgIIi1oeSL3sCDaWnCOeWcGonlpaPKJKiI3OtvAu+BHn2yjS8AR76e3Ton4Nmy
         +EG26HHK0KGq8vBvYX1EeVNsxcIp9mIU6us0cOvxy60zyQiQGRFQuv/txggXaNqN90
         ZKWhlWHVgkpzhtZMxMhIP2Bw8oAKyLOzGZWe9yuxbUXzVLSr62mIeEvbWCpkSHrZlO
         Twy98ZJlAAXDut/ui87OToN2gdrJMOcxFt0qGiH5Q17PEp3FYZEI4DXZJQ30tNXk1t
         9aFxJpinn/zEKI8MPHuL3gndj8LsbUTOOq0tZEPF560BHpeqU2OY2AdZ4ghD6NHw5p
         pKXBKh32qbh6A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
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
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
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
In-Reply-To: <202209281011.66DD717D@keescook>
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-2-keescook@chromium.org>
 <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
 <202209281011.66DD717D@keescook>
Date:   Thu, 29 Sep 2022 18:36:05 +1000
Message-ID: <874jwqfuh6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> On Wed, Sep 28, 2022 at 09:26:15AM +0200, Geert Uytterhoeven wrote:
>> On Fri, Sep 23, 2022 at 10:35 PM Kees Cook <keescook@chromium.org> wrote:
>> > The __malloc attribute should not be applied to "realloc" functions, as
>> > the returned pointer may alias the storage of the prior pointer. Inste=
ad
>> > of splitting __malloc from __alloc_size, which would be a huge amount =
of
>> > churn, just create __realloc_size for the few cases where it is needed.
>> >
>> > Additionally removes the conditional test for __alloc_size__, which is
>> > always defined now.
>> >
>> > Cc: Christoph Lameter <cl@linux.com>
>> > Cc: Pekka Enberg <penberg@kernel.org>
>> > Cc: David Rientjes <rientjes@google.com>
>> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> > Cc: Andrew Morton <akpm@linux-foundation.org>
>> > Cc: Vlastimil Babka <vbabka@suse.cz>
>> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> > Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
>> > Cc: Marco Elver <elver@google.com>
>> > Cc: linux-mm@kvack.org
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>=20
>> Thanks for your patch, which is now commit 63caa04ec60583b1 ("slab:
>> Remove __malloc attribute from realloc functions") in next-20220927.
>>=20
>> Noreply@ellerman.id.au reported all gcc8-based builds to fail
>> (e.g. [1], more at [2]):
>>=20
>>     In file included from <command-line>:
>>     ./include/linux/percpu.h: In function =E2=80=98__alloc_reserved_perc=
pu=E2=80=99:
>>     ././include/linux/compiler_types.h:279:30: error: expected
>> declaration specifiers before =E2=80=98__alloc_size__=E2=80=99
>>      #define __alloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__) __ma=
lloc
>>                                   ^~~~~~~~~~~~~~
>>     ./include/linux/percpu.h:120:74: note: in expansion of macro =E2=80=
=98__alloc_size=E2=80=99
>>     [...]
>>=20
>> It's building fine with e.g. gcc-9 (which is my usual m68k cross-compile=
r).
>> Reverting this commit on next-20220927 fixes the issue.
>>=20
>> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/14803908/
>> [2] http://kisskb.ellerman.id.au/kisskb/head/1bd8b75fe6adeaa89d02968bdd8=
11ffe708cf839/
>
> Eek! Thanks for letting me know. I'm confused about this --
> __alloc_size__ wasn't optional in compiler_attributes.h -- but obviously
> I broke something! I'll go figure this out.

This fixes it for me.

cheers

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index f141a6f6b9f6..0717534f8364 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -275,8 +275,13 @@ struct ftrace_likely_data {
  * be performing a _reallocation_, as that may alias the existing pointer.
  * For these, use __realloc_size().
  */
-#define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
-#define __realloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__)
+#ifdef __alloc_size__
+# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
+# define __realloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__)
+#else
+# define __alloc_size(x, ...)	__malloc
+# define __realloc_size(x, ...)
+#endif
=20
 #ifndef asm_volatile_goto
 #define asm_volatile_goto(x...) asm goto(x)
