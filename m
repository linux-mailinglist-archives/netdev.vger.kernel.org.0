Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC3C66B26F
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjAOQIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjAOQHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:07:31 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC79CC2E
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:05:00 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4e9adf3673aso15325627b3.10
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RToUIkuwi8yeMgADy4fYago0s3h63ui9CT1RSYetlws=;
        b=BgSC8mOao84NC6gs5519Hw9YjObYLGJ3DmJ2SHp5PQSmgt9bxOVL9dfMBsnd5BPc4Q
         bhrwuirceZuq+g2JSZF5QyYPmVAraqqzxmr1RmI8P/mXV5u5G+xIRqtG+tVL7q71j2Xg
         kcwlgokWlpoU/YWq0UDrJtWoDYLTHHlt8olPE+DDxEqs6hKwWlj5CW5mYu29LxzQwBTC
         mFkV34PKsaJDKPszxoxSI2fl9zkj5D+P3XN8BPm+05206v1F8GP6qqxULepp9gmEV84H
         nKGtmTKnxENjvDwob51VItdp2npXLRe1ikLSzlqPoXc198XVpqsh7h0CLzLgKZklC/LT
         wPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RToUIkuwi8yeMgADy4fYago0s3h63ui9CT1RSYetlws=;
        b=sBsmS2cQiCF16sI573/xIaiPEX50iXHgu6uY6XrVsnviaGAopMDInuF6TEcZuXf3eH
         2zLrKSNQF+HOgwalb7aKsg145QxXCC21lq73dKDcW/9rBFH+FvwaGowSSLIY1ckAkPlQ
         lynsa6aVChlxcfmKkiQHwBhM5Ycok4g+X9CdXferIWwghLtf/Ygf61B7QmE0gIHew5UZ
         mt6wbUsSUZzOZk0zfmopgi9HwCrm/MBVI04eYKpAwTVy0sox9d3SZkfAswcWHlNjpVcD
         BWCv7Ro/MMBQbo2ur8h2DeS4LzTFCaf1gxpddJHW/4jdgcHnuoTVWC627F4Okghpee23
         CcHQ==
X-Gm-Message-State: AFqh2kqK/bx/Jqz+AKPoDI/29pAGp3sQBzMRTuVok2Lplzxca/ZPkfp0
        B2BO2SNqleY1TdMURQi/N17W/2rcujajd0qBoHycwQ==
X-Google-Smtp-Source: AMrXdXvTd6/w1dWIi3fm3LjTO3qiyhMAW19eFLb4if3LyBgjDRbeWUR7A3roaV7xyyGy4TSlKZ3LdQoDw0bNQITjL/A=
X-Received: by 2002:a81:7342:0:b0:4df:684b:63b0 with SMTP id
 o63-20020a817342000000b004df684b63b0mr1038648ywc.255.1673798699907; Sun, 15
 Jan 2023 08:04:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 15 Jan 2023 17:04:48 +0100
Message-ID: <CANn89i+Zovpi6rO9755zrCd6R=2a7Wm86n_=xdnhrtjrnapR_g@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] net: support ipv4 big tcp
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
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

On Sat, Jan 14, 2023 at 4:31 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This is similar to the BIG TCP patchset added by Eric for IPv6:
>
>   https://lwn.net/Articles/895398/
>
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
>
> This will work safely, as all BIG TCP packets are GSO/GRO packets and
> processed on the same host as they were created; There is no padding
> in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> packet total length; Also, before implementing the feature, all those
> places that may get iph tot_len from BIG TCP packets are taken care
> with some new APIs:
>
> Patch 1 adds some APIs for iph tot_len setting and getting, which are
> used in all these places where IPv4 BIG TCP packets may reach in Patch
> 2-7, and Patch 8 implements this feature and Patch 10 adds a selftest
> for it. Patch 9 is a fix in netfilter length_mt6 so that the selftest
> can also cover IPv6 BIG TCP.
>
> Note that the similar change as in Patch 2-7 are also needed for IPv6
> BIG TCP packets, and will be addressed in another patchset.
>
> The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> and 1.5K MTU:
>

This is broken, sorry.

There are reasons BIG TCP was implemented for IPv6 only, it seems you
missed a lot of them.

Networking needs observability and diagnostic tools.

Until you come back with a proper way for tcpdump to not mess things,
there is no way I can ACK these changes.
