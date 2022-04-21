Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74DC50943D
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383431AbiDUAkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiDUAks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:40:48 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9651FCDA
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:38:00 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i20so5902680ybj.7
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EezyB94mcH2u3O8MSgqE87lzpKnMtnygmB3lDIfDMog=;
        b=Eetna+tMdv2uNJnSeoG1VKVmzXRdo2LibGO7pZVC93O3jeUI3gEWz8k1Da2WU8RgCH
         4HKAn3/gpYsXehqyvU1s6RDTdqrNVGshwKYrjoasj/WEnD2H4oBRuBkjaGordlCGJJg9
         QpL3LoM+o2XF8RzxxhTE+ZUYejgCDAva0Cg5goTCJyGL5Y+7Odn3LuXnV/QuLveeP9dI
         1hf50I2uI6MxXHSil0Yi/svfDbYl23hUS7ZFtThQoFpWXcyTGRrxi93xmKoXZ+H0oiXg
         TR65akK3325P+m8K7vpHlwuHE+s82urQ7VbJmzP5J11niLzMi/4Rw5yHcRb2sGqgpEOe
         jBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EezyB94mcH2u3O8MSgqE87lzpKnMtnygmB3lDIfDMog=;
        b=h/OtiuKJWuaE9h3apmRl8+ldXzmyx3BWeGBgXpuURWf1TrrFS+UYtjLmx7tLJGzaOW
         RHIwMzsKU2IKe+v5F6zS2YGUhonui+cCuj9SMS6CaxwfMWhGuB3mSvqvcdTiihNUv0Lb
         4biXUAt0pSml4FpOxQ/5ojcEa8Q+xRwG2kbhOA8j33DQ5BecwEaiDy+K2UsMpWi00AXg
         5Ea5V6T7VhwVCR5/AL/rzlttxtrTlYlXg8s1/fxquyS/nNEP4f4p2VwnP9Kw4vERPOjs
         gz5uDWY9Ko4yVrXXbolDvsMTztUbDHRFmK79CTFSrAUf6K4AGSHjjiKdvTv5csZFZDs2
         vTrQ==
X-Gm-Message-State: AOAM533EgecIDn1JNq2CQJ5as8FT7qjGoBc4mcU7gpaAmJ6DvcceMMw0
        /buvAtNQ3G+TxC/kZB4QWzhpt2NH1IYdR28tob/6mwztgvuuIP/W
X-Google-Smtp-Source: ABdhPJzAnUTaiOMFcohlheq2reoWfUzVeU1O18jmyG9kHkCYJbIeeHGC6UAsufyMlQrAhRbxkv4FDO6+21DN8aZqp/w=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr22644506ybs.427.1650501479380; Wed, 20
 Apr 2022 17:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220420235659.830155EC021C@us226.sjc.aristanetworks.com>
 <CANn89iJjwV2gAKMc4iydUt_MqtnB-4_EKdVrqQO9q4Dt17Lf9w@mail.gmail.com> <CA+HUmGiGE9sp3fyfobU6kx73-4zKx=i3KeBHqcCyiru3Z+3jrQ@mail.gmail.com>
In-Reply-To: <CA+HUmGiGE9sp3fyfobU6kx73-4zKx=i3KeBHqcCyiru3Z+3jrQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Apr 2022 17:37:48 -0700
Message-ID: <CANn89iLL38HMB2EtaSc9Xt436xg9Jke-3LT+KCt9B6ktxj1yCw@mail.gmail.com>
Subject: Re: [PATCH] tcp: md5: incorrect tcp_header_len for incoming connections
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
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

On Wed, Apr 20, 2022 at 5:32 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> On Wed, Apr 20, 2022 at 5:20 PM Eric Dumazet <edumazet@google.com> wrote:
> > On Wed, Apr 20, 2022 at 4:57 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
> > This seems like a day-0 bug, right ?
> >
> > Do you agree on adding
> >
> > Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")
> >
> > Thanks.
> >
> I also think it is a day-0 bug. Should I resubmit with "Fixes:" ?

I think so. It will make things a bit easier for network maintainers,
because I do not think patchwork catches Fixes: tags added during code review.

Also please add the net prefix, as in [PATCH v2 net] title  (look at
the warning at https://patchwork.kernel.org/project/netdevbpf/patch/20220420235659.830155EC021C@us226.sjc.aristanetworks.com/
)

Thanks.
