Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65485141A6
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 06:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbiD2FC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiD2FC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:02:26 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D042A71C;
        Thu, 28 Apr 2022 21:59:09 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r11so3317095ila.1;
        Thu, 28 Apr 2022 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZozNJbImTlZi92lh7h5eZ93VBLVeVKEC1D84yravxlU=;
        b=e17B5lrT112l/EHfhHCyIOwYW5UNDhwLriJM+d19yK8igKlmjd1lUSKaQ+jjpHzgXX
         D8QrkIL5LV5J82IqSrSRkwZA8kraBRluG04/EfpaUrr174T6SzcamOOHeTzm7SbfFGh5
         LetaX7LXwdhyzfLwqRjnRsE+HoVweBCXE1kxTDZy1IfT7lo7OO8n9MRafkUZ1hQOp1AJ
         uKj15OfYiajn+LowUTE4zL75Mn5eR1tE/YH4CADX2RItRiBdKMsGoIntImwvkdGo/7MT
         Rb3oVxI3quHE35GYeWPuhZpYP2LeHZ4SiHXrTrGDPnCTpLw6Ch4dmkNtzZk0OfvvIdrL
         1Jvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZozNJbImTlZi92lh7h5eZ93VBLVeVKEC1D84yravxlU=;
        b=0lOiELk70o8dC0Msh2NqbZwueyo/9qd2w9pkKCJ3Z3njlFG7fa+xczaW1PgqyO8CjP
         PAr5E8uFU0quGEuvCVje9j2E1LptCKBqPMEDqnVuwUtmcB1A8/7vBYikI8keQjKHUW96
         9aNiuCDZ9eeQBl/0ufWK9VKNUJ83hnIHo5Yc9uFzWFqde+eyVw+w7fBDVlxOlU45cnpC
         WTpsPbznxebkSMVg5LucJA+sxPq3jV0DmM8flJyzJFXcyVYOslh5OtSY7W+FI2aihxvz
         mH5tS9PeTagA74UujWMekohuCbk0nijxqmCH1dM63/aiy92V8pncTOeRZ44oJC39rh3o
         iTIw==
X-Gm-Message-State: AOAM531KbElBWTg/TM4HzzfkSLmNooKVeBP4VDESdfLlw+LI0ei4BNrm
        tyjr4VZoRpOxgzGhjsOIohrx77iymQQ+Wm9H2cg=
X-Google-Smtp-Source: ABdhPJySn0RQKExCJEIS4LiuTMTvP6NmZv+BdotdQSZkoesLiKssvOcwkyIHnfT1jh0u/smVMfu37PuNhBCauQ+1mXU=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr14232288ilb.305.1651208349194; Thu, 28
 Apr 2022 21:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220428110839.111042-1-larysa.zaremba@intel.com>
In-Reply-To: <20220428110839.111042-1-larysa.zaremba@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Apr 2022 21:58:58 -0700
Message-ID: <CAEf4BzZRioYpgsUFP1TLsqtjtvA3WLyuWjSyq12ctUoMqkUorg@mail.gmail.com>
Subject: Re: [PATCH] bpftool: Use sysfs vmlinux when dumping BTF by ID
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
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

On Thu, Apr 28, 2022 at 4:17 AM Larysa Zaremba <larysa.zaremba@intel.com> wrote:
>
> Currently, dumping almost all BTFs specified by id requires

It should and will work only for kernel modules. It won't and
shouldn't work for BTFs coming from BPF programs. We shouldn't blindly
guess and substitute vmlinux BTF as base BTF, let's fetch
bpf_btf_info, check that BTF is from kernel and is not vmlinux, and
only in such case substitute vmlinux BTF as base BTF.

> using the -B option to pass the base BTF. For most cases
> the vmlinux BTF sysfs path should work.
>
> This patch simplifies dumping by ID usage by attempting to
> use vmlinux BTF from sysfs, if the first try of loading BTF by ID
> fails with certain conditions.
>
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  tools/bpf/bpftool/btf.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>

[...]
