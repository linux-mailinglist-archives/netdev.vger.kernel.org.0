Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C4F60FD0F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbiJ0Q25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236561AbiJ0Q2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:28:55 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F503EA73
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:28:54 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-368edbc2c18so20259087b3.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/twLMWw16uAE+n6BRsXXihWMHHuPUSy05Q/il/C7lHk=;
        b=EtMfw7YoKHuJZm/wHL9s/OzTtTAPLgngkqz/eQFP2+h274lhVyRMh2abXnQvTdO4GY
         VCMtYDVT70Q+lJi5lcFkVuY/1X4O0F1O/t8BU14MV0c06ReZ+P7hJIb4Ujv2xO7T30ps
         KWeDXRhFJT6QUOwvEhzwfFC4kYUgnw9+Sp2qFgfAIFBaf36NwvNYnQIi941EOn9mwPSo
         WUwv5d6O2ycvayl+vlEDAXVx5VlvzgO+MGGh4NIdAkbr4DWkn+9udzfQIYx24aCL3l1g
         2RXiXmwNjN3IduQzypNgvkW7K14Xzr1a541+GVbEjMI5oN6MjT+46iEEsDpHQM39FC73
         BZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/twLMWw16uAE+n6BRsXXihWMHHuPUSy05Q/il/C7lHk=;
        b=RxxhBuIuggy7tBCJ3xsmm3RXCLdOO8bGK2VLzueDRZhEvlD6WUOAeXTWNsYZsMDfk+
         p4T64gylK2wKQvT1yptKItsXU01kaz6L+CNvEXf3yRwT1UsW9VQvLyboA3GAEkKIcXl8
         ySywJAlBILUuPskmveQb5HZTiukDOH1HWIfxKO2L9+QZ1TK85q02x0wXCwCEx20M94o/
         4L+1U1hiw+9+wjMh/0cWK2zsi6BLY7wI6F83MdkHSGK7CvznxA4OC1ZF43A1oScYo2UY
         WXLItRE9oUiZYv1ZocwVZGkl9+5Vu/4ZhPQdBbEiNr0y7Q1g9aaZAjP5VwIgkQvi8Cvl
         pAjg==
X-Gm-Message-State: ACrzQf0uZ4FHkF9Gr5oGd+PAD2agtU6Z5O+3xc0X13If55JgVemNTtyL
        6qN1yOavvtsUBerM/nkGVngduzL+gJoikCOQ5KdxgQ==
X-Google-Smtp-Source: AMsMyM67mvVRzQAcDIhH1GuVnNabzz1YBbDtdPr57xgs6+J2jg0eMPdUFQms3czCKEOQcKCYIIifsCQ/2jUAGTzNhHk=
X-Received: by 2002:a81:ad09:0:b0:370:5b7:bef2 with SMTP id
 l9-20020a81ad09000000b0037005b7bef2mr2515251ywh.47.1666888133447; Thu, 27 Oct
 2022 09:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220902141715.1038615-1-imagedong@tencent.com>
 <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
 <20220905103808.434f6909@gandalf.local.home> <CANn89i+qp=gmhx_1b+=hEiHA7yNGkfh46YPKhUc9GFbtNYBZrA@mail.gmail.com>
 <20221027114407.6429a809@gandalf.local.home>
In-Reply-To: <20221027114407.6429a809@gandalf.local.home>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 27 Oct 2022 09:28:42 -0700
Message-ID: <CANn89iL7EvdBhZGtxDOATeznLUwVaFm2gf4XCYeMPXE5CR=BTw@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ian Rogers <irogers@google.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 8:43 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 27 Oct 2022 08:32:02 -0700
> Eric Dumazet <edumazet@google.com> wrote:
>
> > This seems broken again (tried on latest net-next tree)
> >
> > perf script
>
> Do you also have the latest perf and the latest libtraceevent installed?
>

I tried a more recent perf binary we have, but it is also not right.

I guess I will have to request a new perf binary at Google :/

perf5 script
         swapper     0 [030]  4147.704606: skb:kfree_skb: [UNKNOWN EVENT]
 kworker/30:1-ev   308 [030]  4147.704615: skb:kfree_skb: [UNKNOWN EVENT]
         swapper     0 [030]  4148.048173: skb:kfree_skb: [UNKNOWN EVENT]
 kworker/30:1-ev   308 [030]  4148.048179: skb:kfree_skb: [UNKNOWN EVENT]
         swapper     0 [008]  4148.048773: skb:kfree_skb: [UNKNOWN EVENT]
         swapper     0 [030]  4148.112271: skb:kfree_skb: [UNKNOWN EVENT]
 kworker/30:1-ev   308 [030]  4148.112280: skb:kfree_skb: [UNKNOWN EVENT]
         swapper     0 [030]  4148.720149: skb:kfree_skb: [UNKNOWN EVENT]
 kworker/30:1-ev   308 [030]  4148.720155: skb:kfree_skb: [UNKNOWN EVENT]
         swapper     0 [030]  4149.072141: skb:kfree_skb: [UNKNOWN EVENT]
 kworker/30:1-ev   308 [030]  4149.072149: skb:kfree_skb: [UNKNOWN EVENT]
