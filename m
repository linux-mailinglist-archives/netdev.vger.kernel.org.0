Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6149D4AF1DA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiBIMhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBIMhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:37:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835B5C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:37:49 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id s21so6791860ejx.12
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 04:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1+NIHmF3jGIfwBL0llP4PbdZW7hIYHsdBm0P162GCfc=;
        b=YqY7IvoRN2VJE/ISpb30G7u8eFvgUhwVHhTwpq/lXcixis6CJbASmwQNQfu89Lnh03
         wPgaiaETxPI4ByH6zx7YGSBvAo8fLpGmqHfLDP7MR48rkjBbXOOhQH9ihLEx+YLuDV38
         MrknQM8FcHHeMYuYTqpyRbjgEIskyEmj1cUB7DyzRE6btCT+dXvKYvknIkaVB+t9xRYn
         AySrmeYFnhrjzOd6kW8LZCr7vvGdOJfNIrhNQM3ryRjtAcFa5UR5pI2ZfraKeX8SioOM
         h1x72WlIlDQPPX179JALo3HyKq7Jr00i7ttgxSpaQaXkCveY45VigI8bwKXlQ1A2vhMu
         737A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1+NIHmF3jGIfwBL0llP4PbdZW7hIYHsdBm0P162GCfc=;
        b=au7wJMt0ZaE5dj1XPuAniIuW5d/yT0MFhhDceSdtEYXGVQBqW9db4VanUfYOg0Cb96
         CzUOCNVciqULTr8srn89jvTMcZr/oi/VJLFACCJsUCbrnM4BhenSjqEaRrp6elXVwzKA
         O0CRoIHoue7qo5Qa5OJJdJOTfHZ8IOCk50bEuLjqe6/Z4sBNtl7ZGmTCZFM7/W4iFUpf
         ZXQWpO3dONMD5Pn7w0oo1yJ5xZec49g7EbOoQoNoUdBco9V++YeHhtb8NLmK41PMm/7b
         FsS5dHG6ZSuXzw05PMh09303Qokh43PE99Glw8F2OfLzP1/efesWxA1p9nanXQfOpgYD
         Pk5w==
X-Gm-Message-State: AOAM533GHwktp5ZZBkgQEcDmnl4s9CYk6+CFjt/6WQhfK9csXlngNBGF
        EYKh7mH7yUL4FJeyGx7y8C4VaQ==
X-Google-Smtp-Source: ABdhPJyVnRGCQEtCz6n0Nu8dZw5CN/7XYH7nUmD70QYey/HvLYE9vvM/4hJb9s/zvCVrRChfJuCJLQ==
X-Received: by 2002:a17:906:2ed0:: with SMTP id s16mr1737592eji.327.1644410267908;
        Wed, 09 Feb 2022 04:37:47 -0800 (PST)
Received: from [192.168.1.8] ([149.86.66.80])
        by smtp.gmail.com with ESMTPSA id m4sm885982ejl.45.2022.02.09.04.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 04:37:47 -0800 (PST)
Message-ID: <82da0b01-af9f-ea0d-17a4-76a4c48bc879@isovalent.com>
Date:   Wed, 9 Feb 2022 12:37:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2 3/3] bpftool: Update versioning scheme, align
 on libbpf's version number
Content-Language: en-GB
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220208120648.49169-1-quentin@isovalent.com>
 <20220208120648.49169-4-quentin@isovalent.com>
 <CAEf4BzaH1OKZpJ8-CC4TbhGmYe+jv_0iqOTwhOG9+98Lze9Lew@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4BzaH1OKZpJ8-CC4TbhGmYe+jv_0iqOTwhOG9+98Lze9Lew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-02-08 16:39 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Tue, Feb 8, 2022 at 4:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Since the notion of versions was introduced for bpftool, it has been
>> following the version number of the kernel (using the version number
>> corresponding to the tree in which bpftool's sources are located). The
>> rationale was that bpftool's features are loosely tied to BPF features
>> in the kernel, and that we could defer versioning to the kernel
>> repository itself.
>>
>> But this versioning scheme is confusing today, because a bpftool binary
>> should be able to work with both older and newer kernels, even if some
>> of its recent features won't be available on older systems. Furthermore,
>> if bpftool is ported to other systems in the future, keeping a
>> Linux-based version number is not a good option.
>>
>> Looking at other options, we could either have a totally independent
>> scheme for bpftool, or we could align it on libbpf's version number
>> (with an offset on the major version number, to avoid going backwards).
>> The latter comes with a few drawbacks:
>>
>> - We may want bpftool releases in-between two libbpf versions. We can
>>   always append pre-release numbers to distinguish versions, although
>>   those won't look as "official" as something with a proper release
>>   number. But at the same time, having bpftool with version numbers that
>>   look "official" hasn't really been an issue so far.
>>
>> - If no new feature lands in bpftool for some time, we may move from
>>   e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
>>   versions which are in fact the same.
>>
>> - Following libbpf's versioning scheme sounds better than kernel's, but
>>   ultimately it doesn't make too much sense either, because even though
>>   bpftool uses the lib a lot, its behaviour is not that much conditioned
>>   by the internal evolution of the library (or by new APIs that it may
>>   not use).
>>
>> Having an independent versioning scheme solves the above, but at the
>> cost of heavier maintenance. Developers will likely forget to increase
>> the numbers when adding features or bug fixes, and we would take the
>> risk of having to send occasional "catch-up" patches just to update the
>> version number.
>>
>> Based on these considerations, this patch aligns bpftool's version
>> number on libbpf's. This is not a perfect solution, but 1) it's
>> certainly an improvement over the current scheme, 2) the issues raised
>> above are all minor at the moment, and 3) we can still move to an
>> independent scheme in the future if we realise we need it.
>>
>> Given that libbpf is currently at version 0.7.0, and bpftool, before
>> this patch, was at 5.16, we use an offset of 6 for the major version,
>> bumping bpftool to 6.7.0.
>>
>> It remains possible to manually override the version number by setting
>> BPFTOOL_VERSION when calling make.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>> Contrarily to the previous discussion and to what the first patch of the
>> set does, I chose not to use the libbpf_version_string() API from libbpf
>> to compute the version for bpftool. There were three reasons for that:
>>
>> - I don't feel comfortable having bpftool's version number computed at
>>   runtime. Somehow it really feels like we should now it when we compile
> 
> Fair, but why not use LIBBPF_MAJOR_VERSION and LIBBPF_MINOR_VERSION to
> define BPFTOOL_VERSION (unless it's overridden).

I forgot the macros were exposed, which is silly, because I was the one
to help expose them in the first place. Anyway.

> Which all seems to be
> doable at compilation time in C code, not in Makefile. This will work
> with Github version of libbpf just as well with no extra Makefile
> changes (and in general, the less stuff is done in Makefile the
> better, IMO).
> 
> Version string can also be "composed" at compile time with a bit of
> helper macro, see libbpf_version_string() implementation in libbpf.

Sounds good, I can do that.

This won't give me the patch number, though, only major and minor
version. We could add an additional LIBBPF_PATCH_VERSION to libbpf.
Although thinking about it, I'm not sure we need a patch version for
bpftool at the moment, because changes in libbpf's patch number is
unlikely to reflect any change in bpftool, so it makes little sense to
copy it. So I'm considering just leaving it at 0 in bpftool, and having
updates on major/minor numbers only when libbpf releases a major/minor
version. If we do want bugfix releases, it will still be possible to
overwrite the version number with BPFTOOL_VERSION anyway. What do you think?

Quentin
