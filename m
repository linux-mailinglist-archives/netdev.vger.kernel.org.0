Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141865988F0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbiHRQcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344767AbiHRQb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:31:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917306D559;
        Thu, 18 Aug 2022 09:31:56 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id r15-20020a17090a1bcf00b001fabf42a11cso2353481pjr.3;
        Thu, 18 Aug 2022 09:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cfmi3OyNirEa5wttsK9Gb10HXF33HCsTkOOuVMWiL8I=;
        b=a45Rcl1U4PfGzGWFsl41qXp3yBeE6ygy2KJFRcNqDUzMw4/ix3FbXwritISncAa7b7
         UZM5LmrYXYwI+6GZ6tK53v4yTDsfzOD5O59l5dq34gSzxvrVabvSMwJt4ktd0sozeKUR
         QmA70Eznw3bU8CUpC9FomOAN/l1EBz5/1fjN9GWaBcLJ/7j3lnPraDPkQdMXrLuZwWkJ
         cyA6u7+zQ+Z5m3aPCmMh4sOwHR9RB+YsnMxxf8oMk3kLqCDFP0C+l//0CIwd7bdBhLLO
         IVDYRb+RzSEsjdt/iwseW8Pb5edw0JiNt+YSizipwoOwViE2WG2Hiu7HTLHgUhBbrVDL
         GXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cfmi3OyNirEa5wttsK9Gb10HXF33HCsTkOOuVMWiL8I=;
        b=io7iPI8rb8ML5e3YMkTbesnGwQcdj4afCZdvIZSlP4tMXgB3cgfTJjudg+KzwTiei7
         0v04xfU+77dIDtebj8i3AnOyfsFkkpU1jUnFJlkUiecnE/GIl1dEccjI3K4XtOyLP3Tk
         VIEx7m75WfkNuROnqAgLVMXRZOviSjR2B6dAL4bx+5WW44ArVEKAOvwOgmiZNOQuGrkt
         1Qnnn7pTOT6KLERdY/4K8Tn7Kk2cy5xXVc/4KWogszM4IQkHBVaX32ckSWKZ+NqX8ZQf
         ZJy2HsfixtdX3be9JsSXjKR0zAm8Z/cjkZor7nRsgvDeD72RLue6vgb5GGN5soHtcghc
         Qcwg==
X-Gm-Message-State: ACgBeo3DVw4y6OIF+htzaQd2WeqHBuK2eqG3+9DGUqwd6twVwRaB9aoU
        RH7KfjTMItMVmbC8DMqUamiRdhAPOsFHs+60I/c=
X-Google-Smtp-Source: AA6agR7t3Q8KXhQF+mgzyG+h3C15baJiB3bXOQOJIEFZZcgpdJkiZFHY6OVyxrk6uOq9GuGHwK9HC7UhbA9RfG/QmkM=
X-Received: by 2002:a17:902:d4c7:b0:16e:df4b:89b4 with SMTP id
 o7-20020a170902d4c700b0016edf4b89b4mr3204914plg.142.1660840316041; Thu, 18
 Aug 2022 09:31:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com> <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
In-Reply-To: <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 19 Aug 2022 00:31:44 +0800
Message-ID: <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kuba@kernel.org, miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
On Wed, Aug 17, 2022 at 11:54 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Aug 15, 2022 at 8:29 PM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Sometimes, gcc will optimize the function by spliting it to two or
> > more functions. In this case, kfree_skb_reason() is splited to
> > kfree_skb_reason and kfree_skb_reason.part.0. However, the
> > function/tracepoint trace_kfree_skb() in it needs the return address
> > of kfree_skb_reason().
>
> Does the existing __noclone function attribute help at all here?
>
> If not, surely there's an attribute that's more precise than "disable
> most optimization outright."
>
> https://unix.stackexchange.com/questions/223013/function-symbol-gets-part-suffix-after-compilation
> https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-noclone-function-attribute
>
> Perhaps noipa might also work here?
>

In my testing, both 'noclone' and 'noipa' both work! As for the
'-fdisable-ipa-fnsplit', it seems it's not supported by gcc, and I
failed to find any documentation of it.

I think that the '__noclone' is exactly what I needed! Just like what
saied in this link:

https://stackoverflow.com/questions/34086769/purpose-of-function-attribute-noclone

I appreciate your advice, and it seems it's not needed to
add new attributes to the compiler_attributes.h.

Thanks!
Menglong Dong
