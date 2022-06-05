Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498E153DD08
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 18:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiFEQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 12:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351242AbiFEQe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 12:34:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE814B1DD
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 09:34:55 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bg6so4961113ejb.0
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 09:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdIVKFSk2eIbeHqEWdMi4/8HFEkUDh1Z4gYM7GW4sa0=;
        b=QiWi8O0uBmOcDTjvLLtS7RJP75oD8QAMzCNIR6xgGGo8LMbdoFvr7/kDyWQLXQ55uU
         K+AiabjxiAwoJ89j+dYMVQGZfwFWy22kGZQb4YLQYDlhkEVn7n7dby8AaXnObgdo72fN
         GZwRjklJ0BMY1TqUhjMmtDoTtyK0M+bX7NU3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdIVKFSk2eIbeHqEWdMi4/8HFEkUDh1Z4gYM7GW4sa0=;
        b=MpceARGtxcmArCA7wl8gWKjzQ+ZnI+l/tC+x6S3hQeCX2l4+JhuHbICdHzunYWuJLF
         P2TlQ+aXkQ/lhjCxI0REP8KhCVLr3wAfr2ia3VOAq9mbUkZD35lug3IViMSuQDoBrScH
         iDTdsMgC2ziIxz75OD4+qUeT+Y0zypxLoeEXWxerWE520AFSKPeti5w4tMAlkXIYvSCH
         lUwsrgvZw8GG0TOeoEGhs6ug0TI6Wix3D3U273ykMuiWW0o/3jOFWeVA2CQJSQV8KCHV
         83n0EAzvJE9XuzR7TdI101heCjaAEmk7jOJ++bQTW9Uw6BOgCeHpVre0ByOrZDANNJLc
         xsjg==
X-Gm-Message-State: AOAM531SsFfHrt4WnCNKT2fyirFTo8NnLSmzaN5YPQFW0+IscgF9W4uT
        n9qGyohXMQjRucNBxZ7fAovu4v9bBvG7nLB3
X-Google-Smtp-Source: ABdhPJzXUXKIu77dCR1n7bY/zESzhacBjn+w41GTSK+TZByBKT8diBoDoEwAjYakuWl3CTZ7Vq3BlA==
X-Received: by 2002:a17:906:84b:b0:70c:d506:7817 with SMTP id f11-20020a170906084b00b0070cd5067817mr14320674ejd.206.1654446894305;
        Sun, 05 Jun 2022 09:34:54 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id oq3-20020a170906cc8300b006fe921fcb2dsm5300854ejb.49.2022.06.05.09.34.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 09:34:53 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id q15so8712601wrc.11
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 09:34:53 -0700 (PDT)
X-Received: by 2002:a05:6000:16c4:b0:20f:cd5d:4797 with SMTP id
 h4-20020a05600016c400b0020fcd5d4797mr17796010wrf.193.1654446893075; Sun, 05
 Jun 2022 09:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220605162537.1604762-1-yury.norov@gmail.com>
In-Reply-To: <20220605162537.1604762-1-yury.norov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Jun 2022 09:34:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
Message-ID: <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Guo Ren <guoren@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-csky@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 5, 2022 at 9:25 AM Yury Norov <yury.norov@gmail.com> wrote:
>
> The commit 0a97953fd221 ("lib: add bitmap_{from,to}_arr64") changed
> implementation of bitmap_from_u64(), so that it doesn't typecast
> argument to u64, and actually dereferences memory.

Gaah.

That code shouldn't use DECLARE_BITMAP() at all, it should just use

    struct bdaddr_list_with_flags {
            ..
            unsigned long flags;
    };

and then use '&br_params->flags' when it nneds the actual atomic
'set_bit()' things and friends, and then when it copies the flags
around it should just use 'flags' as an integer value.

The bitmap functions are literally defined to work as "bit N in a set
of 'unsigned long'" exactly so that you can do that mixing of values
and bit operations, and not have to worry about insane architectures
that do big-endian bit ordering or things like that.

Using a 'bitmap' as if it's some bigger or potentially variable-sized
thing for this kind of flags usage is crazy, when the code already
does

  /* Make sure number of flags doesn't exceed sizeof(current_flags) */
  static_assert(__HCI_CONN_NUM_FLAGS < 32);

because other parts are limited to 32 bits.

I wonder how painful it would be to just fix that odd type mistake.

                  Linus
