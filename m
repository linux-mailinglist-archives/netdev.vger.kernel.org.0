Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE0D4B7D3E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbiBPCBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:01:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245757AbiBPCA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:00:58 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97490FBA42;
        Tue, 15 Feb 2022 18:00:47 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id q17so1372811edd.4;
        Tue, 15 Feb 2022 18:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sconlSkVQr84rv45aJ7gGXdI67TbSdkvanV4Zo/rcjc=;
        b=hLZszkoPv+HNK6bt+me14aeW2OrbCDmi6YgRFKks65sbnzrkpb91K6m5v47kmrVn1+
         BCm+PpfO8XPVgQu2vGltQ6ptoytIAOjRZ27ZkQXHNtV4rjhuXFoHptYxZk7BwoO54NCm
         6k4CA9cdCN2svdGlYES5pL/awM5kmlvGLYpiM1CJ2hW9yk8M3udRN2p4jo9xhZoDAMQ2
         mNcKyRFxfoYkGA2xYIICvx8Lhbs2HgWDFhgR4/bpaVITfcONhl9+h+g9woXRqcIIxNVs
         dN/VO4ZP0LVuuVlZJfGFFAoJJvBmb548eJ4cuC6dj7ZhwoBaAHPzjEE6xSf/IAjkyFSg
         E3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sconlSkVQr84rv45aJ7gGXdI67TbSdkvanV4Zo/rcjc=;
        b=Kbl+P/A2whR/gueRExCWNrooLbLGjCzlYx5Lfv5ifik+Fxfz2JZZiOzG1AjPvEVeeS
         4jF6zzpJ4zyFjZ3Zmpn9gCyV1jbKXAwEhDtx42D6RlJMV2l7hx3USyffJ1mKX2QaFo/Y
         oHxCo9yrt1BbzORQsKDoArvSbpjeLYf9f//tQ9otMjBvr+jU7cp5WvVtuVt4i2L2qtiT
         tBkTUAkuPEpgLWntokHr2DtLCFW2Bt0OCtWjBkP1HNB+SuQhXagzV5PrYQFGb0OXf0Qt
         93+7P36PACoByXCQV7Pk/cO4Nsb2p9vR+tS9DC6iTWKf5tzNFvhYygco7bpREwhGpiDG
         vNbQ==
X-Gm-Message-State: AOAM532LbVAc+Aawj83qrfvlcSBd7luIVMI94x5KP2+Bn4pbEnUoheB7
        11hfZoxh4MoixaTHx0SahkFstlbkHLP5z0NUq3E=
X-Google-Smtp-Source: ABdhPJwyUho5csN/Qney7PVE0iId1O0lOc2NtN7/RpdmKciiVquz11cDbaMpq6sMoo0cOYsdD+kNlv6zhxD//ya0Fck=
X-Received: by 2002:aa7:d7c8:0:b0:3f9:3b65:f2b3 with SMTP id
 e8-20020aa7d7c8000000b003f93b65f2b3mr603272eds.389.1644976846121; Tue, 15 Feb
 2022 18:00:46 -0800 (PST)
MIME-Version: 1.0
References: <20220215112812.2093852-1-imagedong@tencent.com>
 <20220215080452.2898495a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <71823500-3947-0b9a-d53f-5406feb244ac@kernel.org>
In-Reply-To: <71823500-3947-0b9a-d53f-5406feb244ac@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 16 Feb 2022 09:55:34 +0800
Message-ID: <CADxym3baA1j6soeS9frXd4Qi=7pG83jgdjJm5jj8MQ4oT16Lag@mail.gmail.com>
Subject: Re: [PATCH net-next 00/19] net: add skb drop reasons for TCP, IP, dev
 and neigh
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>, ilias.apalodimas@linaro.org,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        atenart@kernel.org, bigeasy@linutronix.de,
        Paolo Abeni <pabeni@redhat.com>, linyunsheng@huawei.com,
        arnd@arndb.de, yajun.deng@linux.dev,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>, vvs@virtuozzo.com,
        Cong Wang <cong.wang@bytedance.com>, luiz.von.dentz@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
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

On Wed, Feb 16, 2022 at 12:09 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 2/15/22 9:04 AM, Jakub Kicinski wrote:
> > There's no reason to send 19 patches at a time. Please try to send
> > smaller series, that's are easier to review, under 10 patches
> > preferably, certainly under 15.
>
> +1. It takes time to review code paths and make sure the changes are
> correct.
>
> Send the first 9 as set; those target the TCP stack and then wait for
> them to be merged before sending more.

Ok, I'll make the amount of patches at a proper level, thanks!
