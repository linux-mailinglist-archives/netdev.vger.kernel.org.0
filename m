Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D5515F7F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243611AbiD3RU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbiD3RU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:20:56 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B35BD2C
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:17:33 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ec42eae76bso113509957b3.10
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A76+Sc9EA1Hm/695lfZUvIR89PQsdwIdeUNqiPSUvZI=;
        b=RAYv7YHg9UgqmBt2zU7YjnDp5ht2r0OzKYPxxc+a9FgtN5SdHickR6oAzCWHmMbetA
         2iX9vUI9DGN7UpatO8YzfvRJF7RWrutiNekn9D4tEkTK5qZPTjEGeYL3Yuyl73dtlv1l
         usy4xY3nsr5d3MFXIVoklfGdoNifGDzDtLpcEajYJI/ZDVGEp3vvvarLDVpAO6PnNhwf
         lV2QZ/m9pp5/hEomPY2D1UiqEu+9/HpU6Xh4mIh9QWmtUIaqVrt3kmYGntTBwirFpvdx
         3aYqB4fgGk7j4elW2M33PqRMaqqNb8z+9fpr4mKjxEZwdvTxPnVC6LOxg9lF1I+m2P/c
         jZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A76+Sc9EA1Hm/695lfZUvIR89PQsdwIdeUNqiPSUvZI=;
        b=dj2WKJUu2I+dF3sJqCOpeUQcgqiuhSWtCTA/3h2WmmUdpI4ubdRGeEj6k+iOlem3ah
         8bST40d6ld8itdTKgcbAKlFayB0JX4LMX8JIgE005NYhmDbBJTG+ad9iK6mo6JAOPl3G
         OlsEcpFU/GSiKvKZvgVaqV3U90OvSGABZlS6GcyZLBrJF1bM9Jk2NEIabWcK32xXCunY
         4n1i/mXd71w/E/2yk2NGlv+qb0azcyRaUnGy1YwNCusUh9bi66lZamZzehoXQdgtSaZP
         NsdFktdTDN7vPXwQJNRQvZr/yF/gCNeeV2KkGZtrNq42GImDqiecyAnBtwiQKPXCQ3dL
         mB0A==
X-Gm-Message-State: AOAM530yiuIc+p2AXZrZ5t4QUY6w371WVcGgouN4hxtNFsJAhGq3C/BO
        vpeJUdWpJxT1jnNSvZ9KRuIxpSfRHogtkwaMZoA=
X-Google-Smtp-Source: ABdhPJxIfZ0/mHsrkE9IDcpg2OmgXB7LLcnNhxI80MgLFNEzPRsxuzdYMdSLD6dXPUOQANNa2qIPa4o00L2bBGMzxzs=
X-Received: by 2002:a81:9b06:0:b0:2f7:cebb:9f4b with SMTP id
 s6-20020a819b06000000b002f7cebb9f4bmr4816346ywg.59.1651339052884; Sat, 30 Apr
 2022 10:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com> <6255da425c4ad_57e1208f9@john.notmuch>
 <CAM_iQpWQwsJ1eWv9X9O5DqJUhH3Cx-gz+CfHXQsyjeqF04bJPQ@mail.gmail.com> <626790c940273_6b2c0208ca@john.notmuch>
In-Reply-To: <626790c940273_6b2c0208ca@john.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Apr 2022 10:17:22 -0700
Message-ID: <CAM_iQpVN+Ozdtdbt6RFkisb+0PTaWnvTfhsnd=uhgLq2t+G0qw@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
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

On Mon, Apr 25, 2022 at 11:27 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> For now no more comments. If its not used then we can drop the offset
> logic in this patch and the code looks much simpler.

Good point, it is left there mainly for tcp_recv_skb(), but it can be dropped
for the rest.

Thanks.
