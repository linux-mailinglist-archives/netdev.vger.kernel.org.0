Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDAF5102F5
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352850AbiDZQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352708AbiDZQQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:16:59 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02659D4F1
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 09:13:51 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v59so20940969ybi.12
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 09:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCGX3SR1P5hc5jt5umlhrJ4pWqxunMPOTPtIzs5Vys8=;
        b=mvcDXUtSUZS3BBNf6y5uaceUSYPSaFl8GV1NgbK5k38jpehG4MIKCxSHvKOXx2YPGt
         3x/fyxHCAecj7p56h/8ZOYbL8TDf0tw/Ws1DLP9vt0TxtSTPkPGFzho81J/rqc2GLDwi
         cYb8MXogEdnI+IFqEeZkd/t5Hk/xOFaabMZhFYeH3t5Zg8iIw2yrybf1EGkgyvoz/wY0
         yuWG/XHmNAsKjbzjDvERTiRU+Mn73iuRDJF9wZcpEMlNec1/RXwB+/BZH4lp9lGHn8Hm
         TPZHmoMdxncDjTXnXP7bKu9Grvg0R+3aJz8O76FSw+X3+vn5sWJcpVNfwETiyILMr1xI
         LtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCGX3SR1P5hc5jt5umlhrJ4pWqxunMPOTPtIzs5Vys8=;
        b=6xFef+PqeqvGheHQqUSdZEtgG8cBJOWScgknDkv3w2QVb3G/B/as1pE9zU4NBKxAEu
         ze09bufrSLtqJKZj1yky1bWJpyqI3h8qFhxBDKwwODlAb2JLwgB8cd/0H4i4euIYZrcX
         fIkfHYUmmUS4PWN+SbgoBPdL7JCKHx9OQpYxObdLugIQXMkkqJcOwHDbcM2GIKJ3q8u8
         eTci16BX9OM4kSxa4ZCKB3wLJn+rr/AE4ZUvJdVD7oxI+rL/C6ZM7RngaOcecEPsTx/L
         ianxAc1SmfUYEJX8fvV51ZVwQ0Bi8Y/Aga5pw3GdPe8cZpSHpAbDmGnHFlV0z4W/nffJ
         SlsA==
X-Gm-Message-State: AOAM530gIIz+/wTtLaCm83UT0GT/CDPy3DVSNzSGStGqgMdgERpvzI0n
        idpnGD8gyc8OPOXK/z1Izo3Z6cXXeqdLx4yvTzT9ww==
X-Google-Smtp-Source: ABdhPJysJxBYzJ/5QtCMhhRYvsYaFkoyPDVAfYWLVvyhcDqHRKV2wBNVREkGjN5Q47ADZ1t3de4XkXDU4/T9Lmb1Urk=
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr20927217ybb.36.1650989630929; Tue, 26
 Apr 2022 09:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
 <2c092f98a8fe1702173fe2b4999811dd2263faf3.camel@redhat.com>
 <CANn89iLuqGdbHkyUcTZd+Ww6vUxqNg0L4eC5Xt8bqLMDmDM18w@mail.gmail.com> <b4df9653b93b9b0bdc8a91f5560ec027848200a9.camel@redhat.com>
In-Reply-To: <b4df9653b93b9b0bdc8a91f5560ec027848200a9.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Apr 2022 09:13:39 -0700
Message-ID: <CANn89iJq1mZepnW3XMPOP298ZxoPF8Rwy0Em-NKwYs+CMUo9nw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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

On Tue, Apr 26, 2022 at 8:28 AM Paolo Abeni <pabeni@redhat.com> wrote:
>

> I'm unsure I explained my doubt in a clear way: what I fear is that the
> compiler could emit a single read instruction, corresponding to the
> READ_ONCE() outside the lock, so that the spin-locked section will
> operate on "old" defer_list.
>
> If that happens we could end-up with 'defer_count' underestimating the
> list lenght. It looks like that is tolerable, as we will still be
> protected vs defer_list growing too much.

defer_count is always read/written under the protection of the spinlock.
It must be very precise, unless I am mistaken.

>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>
>

Thanks !
