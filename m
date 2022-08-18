Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D165982CD
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244350AbiHRL52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbiHRL4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:56:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA925B0B13;
        Thu, 18 Aug 2022 04:56:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28777CE1B1D;
        Thu, 18 Aug 2022 11:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A90C4314E;
        Thu, 18 Aug 2022 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660823785;
        bh=0vWGLWoMslAId8U/c0/qZT+uKTcbimpH55jKl9saZSA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k5z+bAuV6xUmSRwc3sK7G9zQplOrBhXV+MyRHkg7tr4C7/zBVtfF/zW2utYhnyvyU
         nYJY/IFN35p9OUKGuWWKR5Xv5+BZnKEgwpfkaBK2clhGvfmPAZ+zWdV4DGPbrOoq8D
         m0l/7+Z7B9pVKMgUYB3dA9+bB3kREjsi3eTEdMLHbA7zzOrwt6FYBj7Tr8ghTyanzJ
         lp96xNp5NJ/mYCVmgTZXIxPhjk024tGgox1H0DFtRw4j1RrfKgXgYe79R4jcTOReqH
         AXbzi/JtlhgWOSzEli4HQur7la5ZbIs1wZ+9CsTvqDAKL1X6j0GMiONZ3ZJxlLlclO
         TxBI7WjQajxOQ==
Received: by mail-ed1-f49.google.com with SMTP id x21so1582374edd.3;
        Thu, 18 Aug 2022 04:56:25 -0700 (PDT)
X-Gm-Message-State: ACgBeo1yJfneNBqW0IOPD8x6nncYMhEslrKSF1PamioAJEez7mKcbFoy
        RYRXxhJTDfdcnXBimZpYCADrWmwwvdY3Y2gJbcY=
X-Google-Smtp-Source: AA6agR6IKlAUitEGXrRbQXt76mnGLQS5qMMCy3FyWMPYnScJ5YX4g4zokkCx0fL795SpopV8+RLOAcAKYSlDOFA7Yrk=
X-Received: by 2002:a05:6402:3693:b0:43d:1a40:21fd with SMTP id
 ej19-20020a056402369300b0043d1a4021fdmr2039729edb.206.1660823783427; Thu, 18
 Aug 2022 04:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <Yv4lFKIoek8Fhv44@debian>
In-Reply-To: <Yv4lFKIoek8Fhv44@debian>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 18 Aug 2022 13:56:07 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
Message-ID: <CAK8P3a2_YDCS0Ate7b_nBibsbinjNqvMj9h5foA83NJjq8nE0g@mail.gmail.com>
Subject: Re: build failure of next-20220818 due to 341dd1f7de4c ("wifi: rtw88:
 add the update channel flow to support setting by parameters")
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc:     Chih-Kang Chang <gary.chang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 1:40 PM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi All,
>
> Not sure if it has been reported, clang builds of arm64 allmodconfig have
> failed to build next-20220818 with the error:
>
> drivers/net/wireless/realtek/rtw88/main.c:731:2: error: variable 'primary_channel_idx' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/wireless/realtek/rtw88/main.c:754:39: note: uninitialized use occurs here
>         hal->current_primary_channel_index = primary_channel_idx;
>                                              ^~~~~~~~~~~~~~~~~~~
>
> git bisect pointed to 341dd1f7de4c ("wifi: rtw88: add the update channel flow to support setting by parameters").
> And, reverting that commit has fixed the build failure.
>
> I will be happy to test any patch or provide any extra log if needed.

Hi Sudeep,

in my experience, you get the best results by posting a patch instead
of a bug report
when you spot a new warning. If you are unsure it's the right fix,
just state that
in the description. The maintainers will then either be able to just
pick it up if
it looks correct, or be motivated to do a better patch if they don't
like it. ;-)

In this case, I think the best fix would be to merged the 'default'
with the 'case
RTW_CHANNEL_WIDTH_20' in the switch statement, and use
RTW_SC_DONT_CARE. Of course, I have no idea if that is the right fix,
but it would make sense.

Just try to avoid adding initializations to the variable declaration, as that
would prevent the compiler from warning if there is a new uninitialized use.

       Arnd
