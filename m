Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544816E9EC8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 00:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDTW1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 18:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDTW1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 18:27:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48A630DD
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:27:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5050491cb04so1408229a12.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682029648; x=1684621648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o31TJ5tZoCsBlp2o0xbjnltm9BzQDN1XsD84HTTJdiE=;
        b=IuUXznK0/krjo47nsrv/vSQehR1jg1V14o2kD0UXTDdBqQw2X4T7jiZsuGHDUf+L2v
         iLDtKz3Kyh1aetBGdR1oSOHpqDPlIUBu8BgsLW0XjG90DXdLkPLIgXLd3uVGxdiaVfcn
         pzReqqFP8NhEMFgRc/3P1EcwVZ7A9i58lirlw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682029648; x=1684621648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o31TJ5tZoCsBlp2o0xbjnltm9BzQDN1XsD84HTTJdiE=;
        b=kXnlAFngSoWfqXowC/2BxHS4IPM5Rpsyeqnc/y3vNNJsC/h7GuCEIXdZzgLLmPWAUn
         i8ikr0hd+WBF55YRb8BPl/pIuQNjQ1i9Rly3Seflza6LHOQ9RFRTyhM3+oVcDev7EkLb
         YxqFe3vZNPJQBUDhDVS4PRUtuqw+FA/fHKhI46pEAWvYmRpRBPOrFWj2Hpknr8ZX1S6U
         duJXJ23wyV5NNl17OR3/WpXpQxi2dlWvSUrWD09Sl0Qs2vtWl4zedFoTpwWzmUvBF/wb
         aBCfKpVtD8w4zrfPT6hedT2PJ/Mro80Rth3jfEU8Pm64n9wVlDrWU9q3d8+GaTOfIZv0
         Ahsw==
X-Gm-Message-State: AAQBX9d74mDisNn2txebpHpQOQJ19GAKUprHbeE1tL5GCS8+9XdankIc
        Pe4HpKS2EJCv4q+UO7g39r1EObLyazN0S5aQUaVZ0Q==
X-Google-Smtp-Source: AKy350Yfcno0ibzp/WFj0/xe0XaYl+zOEx8avF2VJ01zlbPojl7WWVHH+UDsxvDjKH3LXCRG4C6CxQ==
X-Received: by 2002:a17:906:597:b0:94a:8b47:8c66 with SMTP id 23-20020a170906059700b0094a8b478c66mr431619ejn.30.1682029648025;
        Thu, 20 Apr 2023 15:27:28 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0095334355a34sm1215645ejv.96.2023.04.20.15.27.26
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 15:27:26 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5066ce4f490so1390375a12.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:27:26 -0700 (PDT)
X-Received: by 2002:aa7:cb59:0:b0:504:aeb5:89c3 with SMTP id
 w25-20020aa7cb59000000b00504aeb589c3mr2953453edt.5.1682029645826; Thu, 20 Apr
 2023 15:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230413214118.153781-1-toke@toke.dk> <87zg72s1jz.fsf@toke.dk>
In-Reply-To: <87zg72s1jz.fsf@toke.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 20 Apr 2023 15:27:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com>
Message-ID: <CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com>
Subject: Re: One-off regression fix for 6.3 [was: Re: [PATCH] wifi: ath9k:
 Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()]
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 2:09=E2=80=AFPM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@toke.dk> wrote:
>
> So, with a bit of prodding from Thorsten, I'm writing this to ask you if
> you'd be willing to pull this patch directly from the mailing list as a
> one-off? It's a fairly small patch, and since it's a (partial) revert
> the risk of it being the cause of new regressions should be fairly
> small.

Sure. I'm always open to direct fixes when there is no controversy
about the fix. No problem. I still happily deal with individual
patches.

And yes, I do consider "regression in an earlier release" to be a
regression that needs fixing.

There's obviously a time limit: if that "regression in an earlier
release" was a year or more ago, and just took forever for people to
notice, and it had semantic changes that now mean that fixing the
regression could cause a _new_ regression, then that can cause me to
go "Oh, now the new semantics are what we have to live with".

But something like this, where the regression was in the previous
release and it's just a clear fix with no semantic subtlety, I
consider to be just a regular regression that should be expedited -
partly to make it into stable, and partly to avoid having to put the
fix into _another_ stable kernel..

             Linus
