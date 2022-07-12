Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C14570EA7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiGLALi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiGLALd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:11:33 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BBD52DE4;
        Mon, 11 Jul 2022 17:11:32 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id d12-20020a4aeb8c000000b004214e709b72so1245744ooj.6;
        Mon, 11 Jul 2022 17:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wX4uw378nHlZZknwBrLqu9hUejNkdIA+CIdUtRzeQzk=;
        b=NymimtnM+Y30KQXD7Cptxk5Z4ryzMYPBT7zbkpkh6jPgLhmRchiDCaO8jl9xkAMUST
         nGHBw9018BZcw8Tz31l+LjHaEfLPg8rGKF314uGxeJlmjJBamvCZmbCneXkVGHtROPyv
         6Ec69hspGGyNPw9H8ELkRPKwANwJ0L+Lknc6RsZbSjOhM5hv/EZocwpQ25HSBFaaBuSC
         73pj98+DVOkgdJZNktgftZ7H1Vsi3jYaMU8mpmZhvfoLWEsD9Gh3V72enJwP8/45ujPj
         pPxeud2eDQb4TVaemhXgK2v9l/E1lBt11VKujjtX375TLdOY4d6vQDmJjd9Jv3UkLzkU
         gG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wX4uw378nHlZZknwBrLqu9hUejNkdIA+CIdUtRzeQzk=;
        b=1Hg0hLG5UK4mo/ibESrROJeJkoTVni5zzV8fZ61h5K4DSEy/RgeaJ8oqqz98ds1iA9
         7COMrFAF/a8O7zENvq8mECGDm6xcuzrjqcCrKl7PCpuLTFIqZckj0Ta5/huB7AYGziAq
         LCyXoTQv2uXkqsEK1JZ2jmAc/JGStaEFojDoStXa8YofBQwE1WPS1C5mz6mTPkIqeB+A
         UKmnkLOnAz3sS3qrHSxGAd7606+7Yz/5/skSebH3ipKDLSyXHqhXVlfWdrAE45TNbxxV
         i2/zVwVy/yIiostru5qojgxtuuKiD25RFCFrvhbf4F2iv36IoezqrxFQ3viECbCB7GzQ
         BUQQ==
X-Gm-Message-State: AJIora9jRkVNeWqDt9sVcxNbEHoID9YYZCpKSrHQLImUTzXmO+ozzj+/
        9yMVkfmiDcDFHqL4LhtzgFNlKCczdHCODE6JTVM=
X-Google-Smtp-Source: AGRyM1vj4LOisBgu89jgkYWeP2kS6EPd2McSLFszQseAIDiNr82gXEopeUU2DNf4jJeHxtDqAtMFWYaryxSEAWCMR4w=
X-Received: by 2002:a4a:5107:0:b0:41b:873e:895f with SMTP id
 s7-20020a4a5107000000b0041b873e895fmr7619919ooa.22.1657584692166; Mon, 11 Jul
 2022 17:11:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220706172814.169274-1-james.hilliard1@gmail.com> <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
In-Reply-To: <a0bddf0b-e8c4-46ce-b7c6-a22809af1677@fb.com>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Mon, 11 Jul 2022 18:11:21 -0600
Message-ID: <CADvTj4ovwExtM-bWUpJELy-OqsT=J9stmqbAXto8ds2n+G8mfw@mail.gmail.com>
Subject: Re: [PATCH v2] bpf/scripts: Generate GCC compatible helpers
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 5:36 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/6/22 10:28 AM, James Hilliard wrote:
> > The current bpf_helper_defs.h helpers are llvm specific and don't work
> > correctly with gcc.
> >
> > GCC appears to required kernel helper funcs to have the following
> > attribute set: __attribute__((kernel_helper(NUM)))
> >
> > Generate gcc compatible headers based on the format in bpf-helpers.h.
> >
> > This adds conditional blocks for GCC while leaving clang codepaths
> > unchanged, for example:
> >       #if __GNUC__ && !__clang__
> >       void *bpf_map_lookup_elem(void *map, const void *key) __attribute__((kernel_helper(1)));
> >       #else
> >       static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) 1;
> >       #endif
>
> It does look like that gcc kernel_helper attribute is better than
> '(void *) 1' style. The original clang uses '(void *) 1' style is
> just for simplicity.

Isn't the original style going to be needed for backwards compatibility with
older clang versions for a while?

>
> Do you mind to help implement similar attribute in clang so we
> don't need "#if" here?

That's well outside my area of expertise unfortunately.

>
> >
> >       #if __GNUC__ && !__clang__
> >       long bpf_map_update_elem(void *map, const void *key, const void *value, __u64 flags) __attribute__((kernel_helper(2)));
> >       #else
> >       static long (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) 2;
> >       #endif
> >
> > See:
> > https://github.com/gcc-mirror/gcc/blob/releases/gcc-12.1.0/gcc/config/bpf/bpf-helpers.h#L24-L27
> >
> > This fixes the following build error:
> > error: indirect call in function, which are not supported by eBPF
> >
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> > Changes v1 -> v2:
> >    - more details in commit log
> > ---
> >   scripts/bpf_doc.py | 43 ++++++++++++++++++++++++++-----------------
> >   1 file changed, 26 insertions(+), 17 deletions(-)
> >
> [...]
