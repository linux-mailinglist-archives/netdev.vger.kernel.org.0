Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DC66A9CF8
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCCRPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjCCRPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:15:31 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0CB1514E
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 09:15:30 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cw28so13113010edb.5
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 09:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1677863728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dejo+taKqFXKEPsJAmGlrOgHL3TO5mxqXJfByirse6o=;
        b=KRvqO6Lh/gDFsuJcFUdeZSciPr/ij4riozGWTQ64nV1uut/eUd+jcrasdB2/rKvZ5R
         3/e/JWbJWNYq8Ffh5RfSmlTCVrYNmFmCvPYsr4HQWifCpIM/dOlDjYMtqwaxcclkfJTm
         IARTe4wV8jqo0KaWjGNL682ywgADFPaRHIbBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677863728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dejo+taKqFXKEPsJAmGlrOgHL3TO5mxqXJfByirse6o=;
        b=gomg2khUZI85xS7E28boMvXUpdD2GS8yN+1N+4OmN9saLmARLnQAOwNYku8BAGLoTs
         yEYzgseF3xhNzEB3EsxY5Yyo9ylqNDy8t6t/HPagUQ1WQs8l6j51a6GpHXEvu9As2M1K
         8HOA7awigykqEgKXDGa2b313Z+zEJAFAF9LrISWUE34XZpBP6TrazEi8OGu6F740t4Es
         IdybQIkmwXdDduXz3Pg0AVP9saZdsXOnV0vFj8NEtha/gU3hy7gq8Yy8DDpo5gW2Zl+U
         BfMKSeyB81DsRU5MxcT3sNGq8avoSys+OG7WShTCDVlxo0H2W2C50Me0p58o7u3C5grD
         0KPg==
X-Gm-Message-State: AO0yUKXYwrxGLzQ/hZmJSQb+sCgGLRvsxYLAeBt9uYawqgXyRDwmaQL+
        LGea2hd+dhrYeNzGxAOpltogIl6LlfzYsfaxtm2/Ug==
X-Google-Smtp-Source: AK7set8wlVk33CwEz72KcCvLREZtH6TBQgultItLl33KDX0PFiuMGAjei88c42nMNe1j/FJwmtIEtQ==
X-Received: by 2002:aa7:d6c6:0:b0:4af:59c0:d303 with SMTP id x6-20020aa7d6c6000000b004af59c0d303mr2493894edr.26.1677863728394;
        Fri, 03 Mar 2023 09:15:28 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a25-20020a1709064a5900b008d69458d374sm1155132ejv.95.2023.03.03.09.15.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 09:15:27 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id f13so13088987edz.6
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 09:15:27 -0800 (PST)
X-Received: by 2002:a50:8750:0:b0:4c2:ed2:1196 with SMTP id
 16-20020a508750000000b004c20ed21196mr1507287edv.5.1677863727416; Fri, 03 Mar
 2023 09:15:27 -0800 (PST)
MIME-Version: 1.0
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
In-Reply-To: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 3 Mar 2023 09:15:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiS+QhwBa6iZcTtiK-zSCR0BhyC8u7x41g=X2=K==2sHg@mail.gmail.com>
Message-ID: <CAHk-=wiS+QhwBa6iZcTtiK-zSCR0BhyC8u7x41g=X2=K==2sHg@mail.gmail.com>
Subject: Re: [PATCH v1] netdevice: use ifmap isteand of plain fields
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 3, 2023 at 7:09=E2=80=AFAM Vincenzo Palazzo
<vincenzopalazzodev@gmail.com> wrote:
>
> P.S: I'm giving credit to the author of the FIXME commit.

That isn't actually me.

Yes, 'git blame' claims it's me, but that's just because the comment
goes back to the original git import.

In fact, it goes back even to before the BitKeeper days, so it goes
back to some time before 2002. It might be discoverable through some
old networking code CVS tree or trawling old newsgroups for the
original patch before 2002 or something like that, but that's more
archaeology than I'm willing to do.

               Linus
