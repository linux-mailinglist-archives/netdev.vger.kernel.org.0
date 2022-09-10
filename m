Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B9E5B4367
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiIJA2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 20:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiIJA2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 20:28:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794C8E622B;
        Fri,  9 Sep 2022 17:28:15 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 62so2740528iov.5;
        Fri, 09 Sep 2022 17:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=LHVU+QXiGt07dK7ESmFeMKaxf7KrWiJkDIp3MS3i/HA=;
        b=Yh7QAXEfHv5nIZFxP53NrXPMw5luZg5JL/pAqwL6379WEmjgn1w0epRFMVOgseoHFy
         Rl5DtXHyWdXAJCBeT3w6I83CTF9sZXQV7NN+yD8p5MNQGjroKoK0F6pk0+32R+XoRrek
         2jDpAULtRmdvYgm0Rhr3DvXv6gsqOKqeKnvZmlv02AAU3GRgHKZNG0+LQ9kS/3Wqzie8
         YmlweZSrKVpATvTs8I/OssEU0k0ovsTecFXID+RgAjNJSaFA/1Xe2ea+zpawRJObyMgu
         19cztYLUx1NH0JiZHCqMpTvMDeQFFxvfgHIm+IY1C/Mc7G7WmigbnAWE9e4IQ/d5dXCK
         rR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LHVU+QXiGt07dK7ESmFeMKaxf7KrWiJkDIp3MS3i/HA=;
        b=aYRP+5xSBohyHzhZNP0RppOQNsv/zA4x/CjJ7wbkMHcuoZtdcl4Ee0WjRQHkofJVXv
         6mNvRc0+O5cDUG1jc0KPjFK6YWLdbn57HacgnWq9BCpw+4HDrI47bD1TeYGMSufEbWMR
         12xB+LZcH6sWx9bnP6tdVnWtGbBY9xme2Uot4blYd7ho8cNDPqfdVjGZqQulos4Q2QLT
         0GvAK4aPG37fJqGuIU345yDl/Yk/Gyb6HKvmx40s8aWrrANhmFfJTycx1tRC2pE9Vq2I
         2TUhuIfz0ZhWOwVWpGSzXSt5P6K1gwn5xbYX62hMerQmz2wgfAfhXuL/jvSKGfBuABUN
         XoUQ==
X-Gm-Message-State: ACgBeo1iKn3BZWtJs+nbtzs40NKXXTmsv51XJwTlT4nsnHVwOzEzfNzD
        xeP1xV1s4CeiqjGNhM1t8+Fa/9hF1YS07y4T3LWEt2quBzo=
X-Google-Smtp-Source: AA6agR4vsOByx7G2EqdM2wGeNdWjrxldUVUoAMh8pyLq9YUoOy40B4L6IfeYpNMlie8KjTBoQ6ZcmmiYLpEtk7rhxtA=
X-Received: by 2002:a05:6638:2388:b0:34a:e033:396b with SMTP id
 q8-20020a056638238800b0034ae033396bmr8302215jat.93.1662769694877; Fri, 09 Sep
 2022 17:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662568410.git.dxu@dxuuu.xyz>
In-Reply-To: <cover.1662568410.git.dxu@dxuuu.xyz>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Sat, 10 Sep 2022 02:27:38 +0200
Message-ID: <CAP01T77JFBiO84iezH4Jh++vu=EEDf63KepK_jKFmjgjrHPgmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] Support direct writes to nf_conn:mark
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Wed, 7 Sept 2022 at 18:41, Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Support direct writes to nf_conn:mark from TC and XDP prog types. This
> is useful when applications want to store per-connection metadata. This
> is also particularly useful for applications that run both bpf and
> iptables/nftables because the latter can trivially access this metadata.
>
> One example use case would be if a bpf prog is responsible for advanced
> packet classification and iptables/nftables is later used for routing
> due to pre-existing/legacy code.
>

There are a couple of compile time warnings when conntrack is disabled,

../net/core/filter.c:8608:1: warning: symbol 'nf_conn_btf_access_lock'
was not declared. Should it be static?
../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
declared. Should it be static?

Most likely because extern declaration is guarded by ifdefs. So just
moving those out of ifdef should work.
I guess you can send that as a follow up fix, or roll it in if you end
up respinning.

Otherwise, for the series:
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
