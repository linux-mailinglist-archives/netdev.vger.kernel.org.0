Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC360BC7C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJXVtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiJXVs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:48:59 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1904DF13
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 13:01:38 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a5so6773931qkl.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 13:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G03O7nkbOw/imrCRBctbDfwXE89sOi9G3x2TRrvXC0Y=;
        b=R4dVPEZ9Y3nrZb/ASmBd8LmQ7bbbjg70MAHMGV54ly0w4psIqNkDZQ9CXzZdshZl7U
         4gtVMctjjKpTcDp14y8lCRF5utSbNiOku5YgFV9Tjz2QEFfBF4pwgIq5Vq9qTbR1sqx1
         vzNXIYzbFphq8qLnkDenpl5+vGyXN0+OaMrCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G03O7nkbOw/imrCRBctbDfwXE89sOi9G3x2TRrvXC0Y=;
        b=pt9AYf4yVugpYc20K2OQWMvacT9uMOz/ai605E1zok26s4iUSy0JpA/BdNHMWtD1hj
         c+nph5VkJ6K19bGNCBljj2xhbtgKZlRLGwhtkvt7VOvdLQ8cxIhLQeydD5HZ/NtS6A9y
         HqsztKpp2SEDxWTY0yeb5Smz84TA3T34fQ7GnzUDqQ1BMnJDQDKSHYeKHbMWIEcZKr51
         naMwI8GselA7B5lK8lvF5J1U7ju+8Lr027Wy6NBx++TOalhlICeQgDoWfhk/xwc1yEYd
         e+rMCb0UuTa8ibCAJNpwCopkwRcoO9p8MvmbnkFbgSYAnaVL+MyX2gcGRfY/C/NnEj5a
         hvXA==
X-Gm-Message-State: ACrzQf18f16WnmrAB078mxEbE/GM5HkZqKWq5dsH9/V14Yr1zigzaOSb
        pEZXKfwV22YH18vUhQzMDxIXwr92j4LcbA==
X-Google-Smtp-Source: AMsMyM4C/2gFfPlkA3Y/EBcfUg7xPR1xnulQw0HjzJAHqMnZuZYZ/0CNjXFIM4XOIpnEdCamq81RQA==
X-Received: by 2002:ae9:e70b:0:b0:6f4:ecbe:533a with SMTP id m11-20020ae9e70b000000b006f4ecbe533amr5307433qka.346.1666641131463;
        Mon, 24 Oct 2022 12:52:11 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id a18-20020a05622a02d200b003998bb7b83asm413577qtx.90.2022.10.24.12.52.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 12:52:10 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-36847dfc5ccso95653417b3.0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:52:09 -0700 (PDT)
X-Received: by 2002:a0d:e252:0:b0:369:36b0:b9de with SMTP id
 l79-20020a0de252000000b0036936b0b9demr18936281ywe.235.1666641129653; Mon, 24
 Oct 2022 12:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221024181835.475631-1-kuba@kernel.org>
In-Reply-To: <20221024181835.475631-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 24 Oct 2022 12:51:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBvN6Qztvdx3ROOaNsHHif8fFz4926DCw+1P9wo26L4A@mail.gmail.com>
Message-ID: <CAHk-=wjBvN6Qztvdx3ROOaNsHHif8fFz4926DCw+1P9wo26L4A@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.1-rc3 (part 1)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 11:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> I give up on the GCC 8 / objtool warning, Alexei says is a known compiler
> bug. I haven't seen anyone else complaining, either.

Yeah, the only mention of it that I have seen is in your pull requests.

We have a few other objtool warnings for other odd situations, and as
long as they don't get so verbose that it hides real issues, I haven't
tried to get all hung up about them. Some of the objtool warnings are
about objtool getting things wrong, and some of them are about
compilers doing odd things that don't actually matter in real life.

                Linus
