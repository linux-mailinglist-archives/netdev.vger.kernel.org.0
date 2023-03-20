Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7419F6C08C5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 03:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCTB76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjCTB7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:59:53 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E141EF91
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 18:59:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id k37so126931lfv.0
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 18:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679277586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=OIegsQzNjWN8D3O7HJ7cFh3uaO5rdGzzoZGl5blV4F6m920xg8pUoFP1HwrRH1pFjl
         L7uDibYF43PgkoFJ8dS4utdgy1t46/TqB6rwVyMbdQPVOvWiBZPKHIUeTohlPVPF2EAi
         8z6AD8gr9VXgmQysG+Ossen5DIfmnfE9T9V7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679277586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veHR4OeBVdmMM7ZoMMD2LEaF+ZQb01kUcsthEQZ+G8o=;
        b=DZgh2LK41Fl8CoCN9cxJUJZdj/WG89oX99ztqnPAVuNbm7otrqwGzhNlUpKzHDljE0
         uPggYkSs0BQbHHDJ+fgHOanrJbAzs+CD1Z0HCqrt2v6DCPriurICUC+hj/ztupDDo+Wn
         tXJfcjH+hnf2yrirHb8vgIywtzGMEqsXPaSwsX7vmEEtOboPO8ZrrI58bQaBkBf++FQv
         ZMlzbwAAMGynLAibXVy1KVmZ5Zur1Ck3aYyhiW9lmT77eX8EIooCrIPBjBuVWt2MKS/f
         J8hZE02YMNqRtUVNK3rA5tOJ034e1yUbL+jBLw/iaircMthOpOSouQQx7AWcNMEhppxB
         DJwA==
X-Gm-Message-State: AO0yUKV4Mjtu3Ca9gYHZ5v1srZWwC8unTsEK55uxCkR9Uauz1I1H11vk
        uFQfBEWRL9GH0sz1QhttUoxcvx0XSLhz7t/lQUPy9w==
X-Google-Smtp-Source: AK7set9Ua9RQ9kXY7VmRU+/zx6QqamQ+y+ObraibmtJUsOf9J6Wt9TeAg4pjgYw7A/EwZLY3rtPOIQ==
X-Received: by 2002:ac2:5509:0:b0:4db:ee9:7684 with SMTP id j9-20020ac25509000000b004db0ee97684mr6367327lfk.56.1679277585810;
        Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id f21-20020ac25335000000b004d86808fd33sm1494667lfh.15.2023.03.19.18.59.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id h25so1404742lfv.6
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 18:59:45 -0700 (PDT)
X-Received: by 2002:a17:906:2294:b0:927:912:6baf with SMTP id
 p20-20020a170906229400b0092709126bafmr2817236eja.15.1679277564111; Sun, 19
 Mar 2023 18:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230320005258.1428043-1-sashal@kernel.org> <20230320005258.1428043-9-sashal@kernel.org>
In-Reply-To: <20230320005258.1428043-9-sashal@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 19 Mar 2023 18:59:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Message-ID: <CAHk-=wgpK-Gm-nOybRKs1LTD5yb7rPHQ4+=PCDvq61mUpBskYw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.2 09/30] cpumask: fix incorrect cpumask scanning
 result checks
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vernon Yang <vernon2gm@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, mpe@ellerman.id.au,
        tytso@mit.edu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, dmitry.osipenko@collabora.com, joel@jms.id.au,
        nathanl@linux.ibm.com, gustavoars@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
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

On Sun, Mar 19, 2023 at 5:53=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> [ Upstream commit 8ca09d5fa3549d142c2080a72a4c70ce389163cd ]

These are technically real fixes, but they are really just "documented
behavior" fixes, and don't actually matter unless you also have
596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), which doesn't look like stable material.

And if somebody *does* decide to backport commit 596ff4a09b89, you
should then backport all of

  6015b1aca1a2 sched_getaffinity: don't assume 'cpumask_size()' is
fully initialized
  e7304080e0e5 cpumask: relax sanity checking constraints
  63355b9884b3 cpumask: be more careful with 'cpumask_setall()'
  8ca09d5fa354 cpumask: fix incorrect cpumask scanning result checks

but again, none of these matter as long as the constant-sized cpumask
optimized case doesn't exist.

(Technically, FORCE_NR_CPUS also does the constant-size optimizations
even before, but that will complain loudly if that constant size then
doesn't match nr_cpu_ids, so ..).

                   Linus
