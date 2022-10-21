Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6AC606CFB
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 03:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJUBUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 21:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJUBUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 21:20:08 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68F449B7A;
        Thu, 20 Oct 2022 18:20:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e18so2133048edj.3;
        Thu, 20 Oct 2022 18:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d19Jg4n1pA+iJSj+aPh6XOwN24eSBbfyfE7RBeI7WxM=;
        b=RiDiWnxFR8UjCoGmFpB52bd5D/KwrRSpm7xEhorLsvDIHi+aUR+uZvrN7wnyTXyrEO
         kQESAHqXsn93wgRY5EEmkHOsn8SXW2VAjn0DVhd1PKomPtsOVZBUgU4JCJiBpum+ql5O
         oFpFMJk1oRUH70UWxxLu+5oVbzQO2o5U377XwxSCmf+jJHKfQwZ3Se+iJ8FsLuwBgYbW
         G4NKRqKDSEBtHr9VCnirGRP0hPI/zYvuo8RsIXvtFSKuViIlWQ5jFhSEJIgt2zSmGGo2
         qKfyCRJ9QCm8GnOFs5aH4iB2xpYpS/i2g87JwNVOqTbhKU3grVbKFi0f1aZAyUylC5OU
         Gh7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d19Jg4n1pA+iJSj+aPh6XOwN24eSBbfyfE7RBeI7WxM=;
        b=uoFpmFead4D50gCszGrPik+/3HwmFEhfjEWsdYDpqTE3J8Kk9N2SmUNzH7U9YMHNsy
         HJJWc7bHNSgCA79NnlyAaonvqd/VL4B317EHjHNMk6GNKQqDsX9xdMnKGwTcIiQ6zsug
         NbgyTMVjFxmfOg3r2nhruQw9MjKT+wg96IrkpZGt+DK0MN/QDr0E2S1qJwmQ0p+/u6X9
         318NgBlTwErAxOeiBSSWs16UGG+D4vZpDhpx4RUGUJhcfoyfrg6QRBduTYPIhXbI/z2V
         oKEfZ+lqOu1LfLNeEhH9dcUMt1gjP+hnjaQ5TBu76kDL1zLHkW7q1OX4NFi5wPPR6WxO
         lUfw==
X-Gm-Message-State: ACrzQf0/l9FrByv7OkWhIknP/46amQ7V7BpoGtpcz4lmgbz3JYX/o+GB
        qMMhpgGnawtJJUZpANopTrxlk/FwOGJstO5/zhk=
X-Google-Smtp-Source: AMsMyM75JokUr/PNAjb7Vhbh80X51rztcQ4+ukADsQBJ6dxKLHAD3L4jYtMlRJuFrhsvJpDxa9tlknq4CwQe1uxWSWA=
X-Received: by 2002:a05:6402:524a:b0:45c:e2c6:6ef7 with SMTP id
 t10-20020a056402524a00b0045ce2c66ef7mr15319304edd.421.1666315204053; Thu, 20
 Oct 2022 18:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20221021011510.1890852-1-joannelkoong@gmail.com>
In-Reply-To: <20221021011510.1890852-1-joannelkoong@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Oct 2022 18:19:52 -0700
Message-ID: <CAADnVQKhv2YBrUAQJq6UyqoZJ-FGNQbKenGoPySPNK+GaOjBOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/3] Add skb + xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
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

On Thu, Oct 20, 2022 at 6:15 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
>
> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> packet parsing:
>     * allowing operations on sizes that are not statically known at
>       compile-time (eg variable-sized accesses).
>     * more ergonomic and less brittle iteration through data (eg does not need
>       manual if checking for being within bounds of data_end)
>
> When comparing the differences in runtime for packet parsing without dynptrs
> vs. with dynptrs for the more simple cases, there is no noticeable difference.
> For the more complex cases where lengths are non-statically known at compile
> time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
> for cls redirection). Patch 3 contains more details as well as examples of how
> to use skb and xdp dynptrs.

Before proceeding with this patchset I think we gotta resolve the
issues with dynptr-s that Kumar found.
