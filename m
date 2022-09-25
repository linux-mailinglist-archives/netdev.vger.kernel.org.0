Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8595E9414
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiIYPrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiIYPrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:47:37 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9C72BB1E;
        Sun, 25 Sep 2022 08:47:36 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id bu4so1665123uab.6;
        Sun, 25 Sep 2022 08:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date;
        bh=IUa8wfuk/71VgaNbuYluKFoAwM2+Ac9n9e+sqJwT4h4=;
        b=OKC80+Bw2kHZPIGtTh4Lb+BsbA8nQ9lGH+ecY7Awx7InMXPyFgE7lAdTj0DNciZHiR
         OiNMDddgskfsckhf5SHjEMH0kQa/yLBWnHmlGbggQRZhSlpT/JH0ZCEO3ox7LpTEvzVy
         vWGrwujBfiTEEdKlfpQHKGUxoy4GMnKjvICiAPDzvi2wO4iqpH4l807wGS6+pdSq77ek
         8d6IU2Bxo3taiwnpCEFCw2wRZJyvTyRZBueDaGmVpIkd60jF7GvpZx5sTO9LSvQmW/vL
         j3afUzzPUH46UGmJd9cFWalUQcdhvEVJHtbtgBuxDNbwKTY/RjmgWivWEt3Xnt2LrZdx
         L4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IUa8wfuk/71VgaNbuYluKFoAwM2+Ac9n9e+sqJwT4h4=;
        b=C1Pe0lcA97e0J5HCtlpA6q+d0bdhvsOhrdmrhjn5SaDtZ4r4hVxIbxzmAyYSb0Yd7b
         BrHBJCT7yq0OuzcHoEhMqNQ1v04e2OSajDkbjaO68IW6o8jTnwfYwpde6MR/7llRaLgJ
         u9du35CZ7ivEkVmspBitIPISsDJCsKkKQ0PzzEqJ2yYb77lLJ39Fa1JWUrIeZD2fIVKt
         MfFNoqhBHfYJrf1a9yOPn4EUnyaoWdFU9cpLrO2UAoa93+gaGumRPtfY8ueCqWvYRR7I
         ChRxBLbuMq47MO8OzCsxgjFBSMl3oYebn3KUEGrxN8S2bFmJedtms/d8nJG93a+X54V5
         Pc3Q==
X-Gm-Message-State: ACrzQf32Ysi9IH2LQgb3TeifvZpqdTc/u4s7i6Rpy5SqtnryqN5trbbT
        BBDHbt5EHjjMiFN2jTEKamEfkvixK9wadQe/swsubjpT
X-Google-Smtp-Source: AMsMyM4EkXh0LvebuFqrr1Bt/3jI6MxI3NDcmd0KJHVY4W2eEpnWcJnu6FsgoLpAFWzodDQfkH6vbGKdmv4Pywqyhg0=
X-Received: by 2002:a05:6130:64c:b0:390:f639:5ac4 with SMTP id
 bh12-20020a056130064c00b00390f6395ac4mr7103912uab.98.1664120855767; Sun, 25
 Sep 2022 08:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220919210559.1509179-1-yury.norov@gmail.com>
In-Reply-To: <20220919210559.1509179-1-yury.norov@gmail.com>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Sun, 25 Sep 2022 08:47:24 -0700
Message-ID: <CAAH8bW-TtZrvR5rZHVFXAHtfQySD85fqerxAAjUTN+eoh1bP2g@mail.gmail.com>
Subject: Re: [PATCH 0/7] cpumask: repair cpumask_check()
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
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

Ping?

On Mon, Sep 19, 2022 at 2:06 PM Yury Norov <yury.norov@gmail.com> wrote:
>
> After switching cpumask to use nr_cpu_ids in [1], cpumask_check() started
> generating many false-positive warnings. There are some more issues with
> the cpumask_check() that brake it.
>
> This series fixes cpumask_check() mess and addresses most of the
> false-positive warnings observed on boot of x86_64 and arm64.
>
> [1] https://lore.kernel.org/lkml/20220905230820.3295223-4-yury.norov@gmail.com/T/
>
> Yury Norov (7):
>   cpumask: fix checking valid cpu range
>   net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}
>   cpumask: switch for_each_cpu{,_not} to use for_each_bit()
>   lib/find_bit: add find_next{,_and}_bit_wrap
>   lib/bitmap: introduce for_each_set_bit_wrap() macro
>   lib/find: optimize for_each() macros
>   lib/bitmap: add tests for for_each() iterators
>
>  include/linux/cpumask.h   |  37 ++----
>  include/linux/find.h      | 140 +++++++++++++++++-----
>  include/linux/netdevice.h |  10 +-
>  lib/cpumask.c             |  12 +-
>  lib/test_bitmap.c         | 244 +++++++++++++++++++++++++++++++++++++-
>  5 files changed, 375 insertions(+), 68 deletions(-)
>
> --
> 2.34.1
>
