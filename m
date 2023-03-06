Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370D96ACB38
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCFRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCFRs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:48:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7363A5D896
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 09:48:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x3so41994295edb.10
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678124872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHxMDJkAMxG+U7tsJ3okEl2/ScLLX/X7tonuUjq/u1I=;
        b=ckVkcyPoPmhakiRDn8WT3GtuhY1iVz4TCIFpaSpRNFSI5T5+f5NLSEXb7HrV0L1aIA
         3njxBfRcnIMISOh8QOdW8d7OHbEvEK/fUE8EFBWiiwlx+uAecoKDuJY/UGdrpdtvTDmu
         dvlI7sFA1gNjKGDa4lQafh2mXWwvBTIsa6xpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678124872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yHxMDJkAMxG+U7tsJ3okEl2/ScLLX/X7tonuUjq/u1I=;
        b=yr3LnxnJxENfmyZVHlAB3rCPNw9X+ZO5Fsje61d0VHFPM9uQTo9nN06yhMlJlpphOo
         7D0KhK6vhKnjAujhArqc8W5DJ0K6sC7mG+VFnsA7Lp8uGNJmUh3e4lxZoszjpJd0Sck8
         haf8NCq7T5laQ0h7WaK3mwDsTpF7F2ETdqJvWu2pLRi63kkx8uS57VqgWo/pIw+opKqz
         /hP+v4Vxff1Pl3OCo4scayyFG+IdsmkVD8j4YJ71Y8eyw1uZ9fmSrOig136WC1BteHGN
         yEocnIgxtIB1f6asgOwLStbgYQ02qJVR+a+0ABtwdTKUmPiuANYkxk83LUfETJA8QHpz
         DOLw==
X-Gm-Message-State: AO0yUKWs8MQHRT9u7El6+bVqE1tjQKIadWAd1bQl/tr1N0F45GFdm3nU
        XveNHWsHHFV1Oyk0vtnbLlj9OTHI0hjCkRJ3x1l4ug==
X-Google-Smtp-Source: AK7set9OrPBZdHpylzFUEDBCEeCalPtH4Kdgdug3ENsJgtmfxzwg4Uv0GX1Ly61ggHNBWaS5284nOQ==
X-Received: by 2002:a17:907:3f18:b0:8f6:5a70:cccc with SMTP id hq24-20020a1709073f1800b008f65a70ccccmr15545384ejc.66.1678124872601;
        Mon, 06 Mar 2023 09:47:52 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id q24-20020a50aa98000000b004acc02d1531sm5409008edc.14.2023.03.06.09.47.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 09:47:51 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id k10so18188849edk.13
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 09:47:51 -0800 (PST)
X-Received: by 2002:a17:906:4997:b0:877:7480:c75d with SMTP id
 p23-20020a170906499700b008777480c75dmr5674931eju.0.1678124871381; Mon, 06 Mar
 2023 09:47:51 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
In-Reply-To: <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 09:47:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
Message-ID: <CAHk-=witXXeQuP9fgs4dDL2Ex0meXQiHJs+3JEfNdaPwngMVEg@mail.gmail.com>
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

On Mon, Mar 6, 2023 at 9:29=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The correct thing to do is always that
>
>    * Returns >=3D nr_cpu_ids if no cpus set.
>
> because nr_cpu_ids is always the *smallest* of the access sizes.
>
> Of course, right now Guenter seems to be reporting a problem with that
> optimization, so unless I figure out what is going on I'll just need
> to revert it anyway.

Ahh. And the reason is exactly that people do *not* follow that
"Returns >=3D nr_cpu_ids" rule.

The drivers/char/random.c code is very wrong, and does

             if (cpu =3D=3D nr_cpumask_bits)
                             cpu =3D cpumask_first(&timer_cpus);

which fails miserably exactly because it doesn't use ">=3D".

Oh well.

I'll have to look for more of this pattern, but basically all those
"xyz_cpumask_bits" things were supposed to always be just internal to
that header file implementation, which is *exactly* why you have to
check the result for ">=3D nr_cpu_ids".

       Linus
