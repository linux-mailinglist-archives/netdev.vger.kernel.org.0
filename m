Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1EE691
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbfD2Pc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:32:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36711 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbfD2Pc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:32:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so4755680wra.3
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 08:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jm6QDHUao+fmhsEgeeVvgd+wkNrUYKnME477xuih/hc=;
        b=PR3flQxhNbaAFxKjtv7FejaFDY6VRQ1kij1nO95FfSRPYPeQBy69TFJprPhIjzQzZH
         dQ/HpqfI3WmNigkA46Wn3RNcxVxRiCND8GViaEzK5JBaceiS/G9lPhX/ZaRd+p1YBzt6
         50e0CdLWrG5XcEdu+82Q82nHi9WF4/OJl3tFNRmjPP3fvbcc8etq2BhF17xh8d7cbIEa
         wGXxpatqpW28jQ/UsH3FcsDgMJ8IQCI49FLBf+qjwbDyrcIdiFDIui0TOTpXuF+lzGcz
         Mu2nBs4E7iEyZInVoIR7ZTGRadFbivpvBsKSTafqF7gZWnX3HSN7MYl9viipyR7oKOd/
         UiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Jm6QDHUao+fmhsEgeeVvgd+wkNrUYKnME477xuih/hc=;
        b=Mx6IpWdA3uFcRZiqmH01UYqYyumZDfy9Gu9c8TOLGEx9IR1N+pBMMICm3VDhHKFW5K
         slnohUk/hte58Oyu+ugEms7Wz67RxBk6gFoRVNDsL4tdm9WyzxKhVRbih59BAKNFAocO
         VcCx1n0oSwj5FfA0l7nlj/pK9rXydAVEx7IDU3wqn8PRHF4pTVqhB2QLpStTlReFUMf3
         Xw1Hd48sfXpC7jBpO8eN2uWYU0BX//e+TXzzqCXmWyvB7K4iDEh65hRYA7WW/5cVHJ9d
         91CbvR+k1bFpE4L0bP/Rsl2119x/58is8Rbr7xwIwCNMLpf5MxOkOsxYaZ36WQO0PMwN
         K9qA==
X-Gm-Message-State: APjAAAWw1byavSwVEnvO3rJBi/jbuKG8s1nceCRghQaHJn1p7xbKyIXM
        J5hOp9Fubs4H/mDrwnYJpznpKg==
X-Google-Smtp-Source: APXvYqysad4oREcw0QAUigGM16Cg5nBTyW/rr1rQECUTzgHeB4ew+1HRtxprS3wo4qEv4QCDFB03Mw==
X-Received: by 2002:a5d:69cb:: with SMTP id s11mr10410137wrw.315.1556551946678;
        Mon, 29 Apr 2019 08:32:26 -0700 (PDT)
Received: from [172.20.1.250] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t18sm839634wrg.19.2019.04.29.08.32.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 08:32:25 -0700 (PDT)
To:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Sirio Balmelli <sirio@b-ad.ch>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
References: <1556549259-16298-1-git-send-email-yamada.masahiro@socionext.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [PATCH] bpftool: exclude bash-completion/bpftool from .gitignore
 pattern
Message-ID: <ec1d2c14-ae27-38c7-9b79-4e323161d6f5@netronome.com>
Date:   Mon, 29 Apr 2019 16:32:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556549259-16298-1-git-send-email-yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-04-29 23:47 UTC+0900 ~ Masahiro Yamada <yamada.masahiro@socionext.com>
> tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
> intended to ignore the following build artifact:
> 
>   tools/bpf/bpftool/bpftool
> 
> However, the .gitignore entry is effective not only for the current
> directory, but also for any sub-directories.
> 
> So, the following file is also considered to be ignored:
> 
>   tools/bpf/bpftool/bash-completion/bpftool
> 
> It is obviously version-controlled, so should be excluded from the
> .gitignore pattern.
> 
> You can fix it by prefixing the pattern with '/', which means it is
> only effective in the current directory.
> 
> I prefixed the other patterns consistently. IMHO, '/' prefixing is
> safer when you intend to ignore specific files.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---

Hi,

“Files already tracked by Git are not affected” by the .gitignore (says
the relevant man page), so bash completion file is not ignored. It would
be if we were to add the sources to the index of a new Git repo. But
sure, it does not cost much to make the .gitignore cleaner.

> 
>  tools/bpf/bpftool/.gitignore | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
> index 67167e4..19efcc8 100644
> --- a/tools/bpf/bpftool/.gitignore
> +++ b/tools/bpf/bpftool/.gitignore
> @@ -1,5 +1,5 @@
>  *.d
> -bpftool
> -bpftool*.8
> -bpf-helpers.*
> -FEATURE-DUMP.bpftool
> +/bpftool
> +/bpftool*.8
> +/bpf-helpers.*

Careful when you add all those slashes, however. "bpftool*.8" and
"bpf-helpers.*" should match files under Documentation/, so you do NOT
want to prefix them with just a "/".

Quentin

> +/FEATURE-DUMP.bpftool
> 

