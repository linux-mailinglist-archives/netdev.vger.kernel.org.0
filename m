Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E002648869
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLISZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLISZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:25:29 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B141925EB9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:25:27 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id q10so3577344qvt.10
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 10:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p2tFGeL4IKHMOLG8K5mBjsPyTa/gwxZuO/Te7d5SkhM=;
        b=R1vwKVYxDcZhuATY+em4HS+UfJ6NrYR93eYQSQkP/OWCN4igMlPzqxVqlrHNSJdMuk
         /E0ywCJEKO+mIaZDAXA6HXw/X1TV964NRZrcyezSbFFg4WgU4w2lnAS1BSNf5QmFx0kz
         1WkDjTNi3H5RBcykqyMCXLYk65nnMVhnooMyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2tFGeL4IKHMOLG8K5mBjsPyTa/gwxZuO/Te7d5SkhM=;
        b=ylccZV4ku8vX4i9Hz79XRTqg5GwV5QWLbYSwsrBGrz+SdUy+htck6HwNdA2trPKnGo
         2ja+fzsc/jj8iqAL3E5izoxj+xoFjnmXj7ynE2I3uA1jkFXq77MRTvzKydX4tPeBbIob
         Yfm/zwCz8Q5SFo2idz05FnEZaVlC5CdpXHYk2qvAVUnY6MrHSzmDmAMvtBSyhE0oL7pw
         qetf7a/uaXkZyAfTrjn3O+x+a8rr8znDWxMKij/hQnegPpFnVVqi3aYxVFDQYxIi6ZBE
         twZjuZ8cwDlJHzLaDrod2vs0RPCFxSLLEMax0fZi1JcwvBP7MIS0WP6asincgRMyexL0
         uVzw==
X-Gm-Message-State: ANoB5pmgeFW/cMiPhT4nPffE3x5Z16NyTQNr7bHVnOe0VJuq3N+T8ZUv
        AENDumtjPxNPLnChxO2SRrREj7/gPVlHJ5cP
X-Google-Smtp-Source: AA0mqf4kvGFT0/bl+vWU7+btuPTyF5sCwJpa3bFpo39xQ7TWXNhIc8W0IR0uCRhfXGkaa9+tDV9vzQ==
X-Received: by 2002:a05:6214:3b13:b0:4c6:91f8:7093 with SMTP id nm19-20020a0562143b1300b004c691f87093mr8731131qvb.23.1670610326550;
        Fri, 09 Dec 2022 10:25:26 -0800 (PST)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com. [209.85.219.49])
        by smtp.gmail.com with ESMTPSA id dm49-20020a05620a1d7100b006bbc3724affsm379784qkb.45.2022.12.09.10.25.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 10:25:25 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id h10so3589914qvq.7
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 10:25:25 -0800 (PST)
X-Received: by 2002:ad4:4101:0:b0:4b1:856b:4277 with SMTP id
 i1-20020ad44101000000b004b1856b4277mr69642655qvp.129.1670610325096; Fri, 09
 Dec 2022 10:25:25 -0800 (PST)
MIME-Version: 1.0
References: <20221208205639.1799257-1-kuba@kernel.org> <20221208210009.1799399-1-kuba@kernel.org>
In-Reply-To: <20221208210009.1799399-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 9 Dec 2022 10:25:09 -0800
X-Gmail-Original-Message-ID: <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
Message-ID: <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
Subject: Re: [PULL] Networking for v6.1 final / v6.1-rc9 (with the diff stat :S)
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

On Thu, Dec 8, 2022 at 1:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> There is an outstanding regression in BPF / Peter's static calls stuff,

Looks like it's not related to the static calls. Jiri says that
reverting that static call change makes no difference, and currently
suspects a RCU race instead:

  https://lore.kernel.org/bpf/Y5M9P95l85oMHki9@krava/T/#t

Hmm?

                  Linus
