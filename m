Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFB65E5752
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIVAaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIVAaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:30:07 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB477AC30;
        Wed, 21 Sep 2022 17:30:05 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y17so17480871ejo.6;
        Wed, 21 Sep 2022 17:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4rURt1DFOtISyLJtoae819CeZa5xS4/hkXaK4AZO9qU=;
        b=Ix0VX7eQU7Mv7prm3r1CmEPl5iN5WTGOTanC8yFr4H+P/snjCzc2MjLKBEuCZMsIqu
         5iQv6oyuMbbnjsVWEP8vlhSYNS/3RucwMOX1Zwyj50yPD7FjpZeezoKmlkJO6pjIif9b
         XzlTDmonQTCrdcHtdUUp5NzAnbuREoGMf+HHASkIY7MqAoBl4C3tTer8DmaXs6IzFhJz
         I0XHNiqXzPRqoN6mmex9Rl/unSx8SJbHl+mTwN2zabxqX53tawOyvvweUEV2fUkgd1SV
         GdqD87D7J+1BSjC2tH2qiJ8akSG9z1wKq7FKrNVj38MNiVc/oBRvNgw0titgSQlQP0b0
         yXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4rURt1DFOtISyLJtoae819CeZa5xS4/hkXaK4AZO9qU=;
        b=jJ3IX33ixvbntu7YhpLDLMqKUIuI4DPwPHs9DSbE/+bqgiEaA8smUucHjasCoam2B7
         5pkaMOE9GdVgzHlNymnN/MCOFV6I1OJN4oERMOywmRNqRAQjiYBjIvGf7byoDCFIDq3H
         U3BPYAagyRIHnLAyF467OL9vY1oOOIFn8M9sF4Nwrtawyuy/V5IZysJvoL8eBPI6loVJ
         7+PUHMapClITfkOaYxRHmlCiyNIXhqNS84OYGpRSZVH8i1J174HK7nfcR6YaUkrSqu7v
         s/ThjOCvQ1AYLGuvapemjAV0/Uk8asjE2289cpNmVO6FikeRSYBMd3maYgNUYMh00c6J
         VsZg==
X-Gm-Message-State: ACrzQf121j8KKuECWGkz5YxiT06uoVcsV3d7eqW2n3fBqQb0olaJCmQP
        tMROLvg8XPtWRqu6+BYSecbQMNlMZ4hwvhN9R2P2h4xp
X-Google-Smtp-Source: AMsMyM7+I+Hycyrz36s/LjHcujOEHaIb/PBiXwMFLCmdnBFbCqwzxv2P5VoosmOMNh2D1oZxUNQoGOFsFt1bDpp39o0=
X-Received: by 2002:a17:907:96a3:b0:780:633:2304 with SMTP id
 hd35-20020a17090796a300b0078006332304mr666798ejc.115.1663806604116; Wed, 21
 Sep 2022 17:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <3f59fb5a345d2e4f10e16fe9e35fbc4c03ecaa3e.1662999860.git.chentao.kernel@linux.alibaba.com>
 <d4ef24e4-0bbb-3d24-e033-e3935d791fb9@fb.com>
In-Reply-To: <d4ef24e4-0bbb-3d24-e033-e3935d791fb9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 17:29:52 -0700
Message-ID: <CAEf4BzYTXPhiXYDoqDgU5o4rPWZ-OXo0f4xtuJdi22tHYyWrqA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Support raw btf placed in the default path
To:     Yonghong Song <yhs@fb.com>
Cc:     Tao Chen <chentao.kernel@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, Sep 19, 2022 at 8:40 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/12/22 9:43 AM, Tao Chen wrote:
> > Now only elf btf can be placed in the default path(/boot), raw
> > btf should also can be there.
>
> There are more default paths than just /boot. Also some grammer
> issues in the above like 'should also can be'.
>
> Maybe the commit message can be changed like below.
>
> Currently, the default vmlinux files at '/boot/vmlinux-*',
> '/lib/modules/*/vmlinux-*' etc. are parsed with 'btf__parse_elf'
> to extract BTF. It is possible that these files are actually
> raw BTF files similar to /sys/kernel/btf/vmlinux. So parse
> these files with 'btf__parse' which tries both raw format and
> ELF format.
>

Thanks, Yonghong, I used this description verbatim when applying. Also
added a sentence on why users might use this instead of providing the
btf_custom_path option.

> It would be great if you can add more information on why
> '/boot/vmlinux-*' or '/lib/modules/*/vmlinux-*' might be
> a raw BTF file in your system.
>
> >
> > Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
>
> Ack with some commit message changes in the above.
>
> Acked-by: Yonghong Song <yhs@fb.com>
