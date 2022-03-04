Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC154CCCF9
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbiCDFUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238130AbiCDFUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:20:49 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6F0186427;
        Thu,  3 Mar 2022 21:20:02 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id qa43so15080505ejc.12;
        Thu, 03 Mar 2022 21:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxLan5R4EeIuizeHi+1H0RoYbghobbkKvF7qVa/71h4=;
        b=AcsRumGmEs9knFasfsszEbJV3Z2uZwXWlFKcER9c6Y8JV4OvzAfWJYKxT+LY5zITKe
         kPdykaSpKdEoQZICNme1BzMrk7hx3h43v21obv/YFF4qsAh3S0e6Ge4mw3JpMaVtEomJ
         5sxtoCJmHOZW8ABLlX51iZtl1tZbVPlRVoKTb5Q/lD34AQbSP+sPzEi2KhZM4Z1ZBECo
         iXE6Sj0TyRnmg85NCBUdhp3O1JgZ4N04tyEtzKm+fiumZ6dFnezWeu7rt5coerPSFZnG
         OUM4Vt7PuttWidKXOSNF4tRm48tJkHGJWGkz6N4MQ25mm1WpoX2G6aWY6ruvVTyC3+uH
         xjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxLan5R4EeIuizeHi+1H0RoYbghobbkKvF7qVa/71h4=;
        b=4Gqb7tXMn11ean3qgf76uAsSq6zc/nMI4XqL8180bP+HX+19SEgvUk6JKWSO6aFjMp
         5SR5OUvg5FcqS8eSj2bdNyViNl0/wVqNjvw8Do4PiHwZ/LYra3XdCs1zkWVww/ksk+So
         fbjCv+qLDJpCeSpp1UOqTCwmTv/cFqetzkwbwL8tNm9WJqh2q68yjVKmhudxQBaKBft/
         O21EdFi5dA+V1cPVE0w+iF/jolb0zr4mSzLkCkGG4AUhAoCk45bYdhyfpfi1GSrKmVKV
         6rYa+h1HHEJVOfPXa3j28hEAw4f+d0bFVnvSdOXONZLOtplhN6+FHqF9YSUKf8orH9TF
         Vq2A==
X-Gm-Message-State: AOAM533q2ij1CYXbslbavIJlCgivwltktdzvnNgKqxL0mALh3UxFHlK/
        +RO5ZvlGYnmtzRBL7gVxKDWUUjvAaDGAL+9onJw=
X-Google-Smtp-Source: ABdhPJxwn+g2mzmBbi1rvOP1Ykx9QZ70Rxyli+YI+RvQZAI9Yzvi736QIIxR/jXUpPV1FLHYnQ2W2obcNqytltaPyOE=
X-Received: by 2002:a17:907:3f9b:b0:6da:6f2b:4b1c with SMTP id
 hr27-20020a1709073f9b00b006da6f2b4b1cmr8189108ejc.765.1646371200763; Thu, 03
 Mar 2022 21:20:00 -0800 (PST)
MIME-Version: 1.0
References: <20220303174707.40431-1-imagedong@tencent.com> <20220303174707.40431-2-imagedong@tencent.com>
 <20220303202539.17ac1dd5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADxym3ZC1kXYF2_YnY3xKYnRGzPimHnahR5eoAr4fkawkm5aSA@mail.gmail.com> <20220303210544.5036cf7c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303210544.5036cf7c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 4 Mar 2022 13:19:49 +0800
Message-ID: <CADxym3Z48jkRViH2_8mCeymURHoRyV62XmwKBbdKVeaKUBcgJA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] net: dev: use kfree_skb_reason() for sch_handle_egress()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>, flyingpeng@tencent.com,
        Mengen Sun <mengensun@tencent.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Fri, Mar 4, 2022 at 1:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Mar 2022 12:56:40 +0800 Menglong Dong wrote:
> > You are right, I think I misunderstanded the concept of qdisc and tc before.
> > and seems all 'QDISC' here should be 'TC'? which means:
> >
> > QDISC_EGRESS -> TC_EGRESS
> > QDISC_DROP -> TC_DROP
>
> For this one QDISC is good, I think, it will mostly catch packets
> which went thru qdisc_drop(), right?
>

Yeah, you are right.

> > QDISC_INGRESS -> TC_INGRESS
