Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2450BCEC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388807AbiDVQ3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388271AbiDVQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:29:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF865EBD5;
        Fri, 22 Apr 2022 09:26:12 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id v1so6874968ljv.3;
        Fri, 22 Apr 2022 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUrh1efILjSaXAe3E+x72wbjb4Twp+oR0/Kr58Ftb1I=;
        b=neTqDyK4aAIR67hd1swkp8mYa9tzbLhOQWDj+BlQv9zVZKesSfhf4hbdYhES2RrGi+
         wdkyLVrY/H9uld+HjfN2z8GZYN5vPnAvVA2EaGPbADSjaNLzia315Hae9wpp2cbxKtzu
         XIGbsxc69sSCh42qP+S9Tmg00rn4QInpT2BjwfHsh/PmVMqOqad1h1aPch5BerJMNXgY
         q4VHWzYOLK8XvTio3vDY1U5p4e/+pKOAW5K4H6VsJDzX2wc+RMTw/41H5R2Ei2Thnasa
         ibLk3Z7ky0yLPVY0xhTdpZYzBaTsh1UqF5AftDVPBSXbAcxKESQ1fL25UBvdhEWZ9IwT
         Z+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUrh1efILjSaXAe3E+x72wbjb4Twp+oR0/Kr58Ftb1I=;
        b=o4S7fPNuFAk1R9vRMSWiVHK5IEeoPddm5HTx8Pjr83jk/u3f1yPVE/3NnPkc74Z9I4
         YfdRmsjO5hIS96ts3vG/GlrmZTI0m9QCSVst81Xr5m3TDQP8tffoSWcwtkShqi4cpVUw
         /SKi4mtDbZDPqoz058pjl+EIhyoVAvRTmhJjBv25FL4MVz4ltuGBosnS6eILPonZSnby
         J64tuhgOQ8hqWJxO7nWhirpiZA8bI2ZFw1+J3nU9QOLyMhKICAqeEbWv3I80hQkIELI4
         578IZ/wZyc7jPf9W4HWPzKFMNVq6t/fE0RDBKdM3jtSMgHL48p/pKuIzIq7e2fWfoQNN
         RSxQ==
X-Gm-Message-State: AOAM531F6qwA/9avifp++rCL9QfA4XzoAo3+ixDpShaoIGSz0Oj/RXE9
        Nsv5xJXo33BTS8ocvO48DArDwRbo4ZIRc1zHCqo=
X-Google-Smtp-Source: ABdhPJxl93mRTqmHk5RcUeYPYvix1Cpy+0bZNXL/KAiekKHLEbjGStmDNS+MrDAw/M/kWuqw6DqHw126o2x4x2WvQIs=
X-Received: by 2002:a05:651c:1991:b0:24a:c757:e5c9 with SMTP id
 bx17-20020a05651c199100b0024ac757e5c9mr3209733ljb.222.1650644770240; Fri, 22
 Apr 2022 09:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1650575919.git.peilin.ye@bytedance.com> <dd63f881729052aa4e08a5c7cb9732724c557dfd.1650575919.git.peilin.ye@bytedance.com>
In-Reply-To: <dd63f881729052aa4e08a5c7cb9732724c557dfd.1650575919.git.peilin.ye@bytedance.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 22 Apr 2022 09:25:33 -0700
Message-ID: <CALDO+SZqYGWnFLDBqQ+qUE7Tjg4M06aAQWsC6tomx406sN=93A@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ip_gre: Make o_seqno start from 0 in native mode
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "xeb@mail.ru" <xeb@mail.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 3:08 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> For GRE and GRETAP devices, currently o_seqno starts from 1 in native
> mode.  According to RFC 2890 2.2., "The first datagram is sent with a
> sequence number of 0."  Fix it.
>
> It is worth mentioning that o_seqno already starts from 0 in collect_md
> mode, see gre_fb_xmit(), where tunnel->o_seqno is passed to
> gre_build_header() before getting incremented.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

LGTM
Acked-by: William Tu <u9012063@gmail.com>
