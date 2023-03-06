Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA13D6ACAC2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCFRh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCFRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:37:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CC56A9CF
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 09:37:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ec29so11117998edb.6
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678124185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyTtB/4llIx7xJW4yBF6B/aJvNGYAxGhl43lVEfQF64=;
        b=axUowq0Zk1SHQzPulJY0QSq6tAIBBacsm8F3M8n+dGtxH1wkT/RS8ZOZ8fpQ9JRDCW
         OubiQ00Djww81LE4+cgpUgSDPjMZ5G0RTeq+jkEmO58Vgyb/jg844zHlYFLVa0Z5QcCG
         wRC93T0bKUtb2xetb8QAYZ+uHaRuJ7b3L7+nE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678124185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hyTtB/4llIx7xJW4yBF6B/aJvNGYAxGhl43lVEfQF64=;
        b=4xNI5y8lpovM3RtbUbo5kXdF9WeV6H+Hrx9COvFgWUBaStT/eVPlMMLvGJjiDOLf5i
         ZbUin/23D4HtN+ohOGvuOEgx4+SqhWbxkIcvqiSd6RXxWNGERY7oNQzWaY15dEITbsAP
         qGcuCyrbhSwY6O7oInJE8EsAu7s4SfajCno9HyiCBNJLDfkdVHcU7Ut5TsRX8nUcNoNd
         i8v9PkBK2+R1+lY0Vs+2JrIr5HkJrgEaZlkeGKvksxWIObric0Z8gmZnV3/Lcs5pt8+I
         4AHXItncLANhqcgn7K/EN8MjTRRkFpYMrUPloTxNEwJKs6TQ6nk+E8v4M6SCyxaXsUdw
         MzbA==
X-Gm-Message-State: AO0yUKU+F+0NDmN/BINF1HVjnZLTHmwA241zrg3zBluj1t65gEtdCaeS
        sJgntOqd8LaZls6vfdSOM16lf/XJUk+iZp3fNyM+vA==
X-Google-Smtp-Source: AK7set90SqArmnOqtOZGazGJNYcrxQrKusMNz4RZC8SO55W+Vl8W+hiZi/+5JD0DojPyp+jJvaXg5A==
X-Received: by 2002:aa7:c14e:0:b0:4ac:d2cd:81c7 with SMTP id r14-20020aa7c14e000000b004acd2cd81c7mr11596009edp.5.1678124184877;
        Mon, 06 Mar 2023 09:36:24 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id k21-20020a05640212d500b004aee4e2a56esm5388062edx.0.2023.03.06.09.36.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 09:36:24 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id da10so42031263edb.3
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:36:24 -0800 (PST)
X-Received: by 2002:a17:906:4997:b0:877:7480:c75d with SMTP id
 p23-20020a170906499700b008777480c75dmr5644673eju.0.1678123768103; Mon, 06 Mar
 2023 09:29:28 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
In-Reply-To: <20230306160651.2016767-6-vernon2gm@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 09:29:10 -0800
X-Gmail-Original-Message-ID: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
Message-ID: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     tytso@mit.edu, Jason@zx2c4.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
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

On Mon, Mar 6, 2023 at 8:07=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), the cpumask size is divided into three different case,
> so fix comment of cpumask_xxx correctly.

No no.

Those three cases are meant to be entirely internal optimizations.
They are literally just "preferred sizes".

The correct thing to do is always that

   * Returns >=3D nr_cpu_ids if no cpus set.

because nr_cpu_ids is always the *smallest* of the access sizes.

That's exactly why it's a ">=3D". The CPU mask stuff has always
historically potentially used a different size than the actual
nr_cpu_ids, in that it could do word-sized scans even when the machine
might only have a smaller set of CPUs.

So the whole "small" vs "large" should be seen entirely internal to
cpumask.h. We should not expose it outside (sadly, that already
happened with "nr_cpumask_size", which also was that kind of thing.

So no, this patch is wrong. If anything, the comments should be strengthene=
d.

Of course, right now Guenter seems to be reporting a problem with that
optimization, so unless I figure out what is going on I'll just need
to revert it anyway.

                Linus

                Linus
