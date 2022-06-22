Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC86554EBA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359109AbiFVPJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359071AbiFVPIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:08:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC9E2BF3;
        Wed, 22 Jun 2022 08:08:16 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q15so9416867wmj.2;
        Wed, 22 Jun 2022 08:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZxOn+wGDgrlZgu5R6pd78yHgsnhABm1ikEzbHnNwlo=;
        b=pFG8rg6wtIF2HSc9z1qNlvDHz/ACH/3SyFxQgQQzpyq2IppbKs1km6zRfUFrkbDEHO
         prqzoc2DhUyKHOCzomwpY/4tUzsf4dqdiAeRte6uZ5ieGtajl1E5tguHaywtw92tmffi
         G1lyumoqRbHpBViIAe3gnjR1r2LFunCPi/cjrZ03XhTBo+EBF6txePEXGqGGWfUUopv/
         rdanewfvKqghuZUptbB4pmhyfZgYj7I9wa/hAP/Y1acF0foZU0gQqMrn7NN68l5+nZyh
         GjRBsLfaoMia3vavF9Um8JWjsPJMiw+F+vmcSpJ0827rwBluglAJ8mdAFr1oVEgVjJ2T
         BSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mZxOn+wGDgrlZgu5R6pd78yHgsnhABm1ikEzbHnNwlo=;
        b=1rDrzG5DMfdh9NYk+Od4To5peziPcGckAiSnOQy8+HwC4LNa65pIoRfD4pFQ8WhNi0
         jDO2sFclZ7iTwvnxBbB3H4XkbA4OvBoc4LeCWEuoCmUPsHC++5LFqoToFA198evNXmxM
         nRllv+Jf7xYp4jD6cxxryGSRaNN+cFpK4mLAipHZNM7fHzCEdEr2eGijZVH1lm48K7B/
         N29K5sPWJOoWdfS1pAtNwmb286rm6WNcWcnCoKxoTosrmWDaWAHgfGwBy120P0MMrxF9
         8RNNFBZkIKoFUHl6BvrGrsS3H3ja9qhUPRH7UnTmEfGM7tn1+uCOkNXn3/JnlhILCG0S
         DNNw==
X-Gm-Message-State: AOAM532tZb515pAnNPfLs3es7Skyih7kaMKPoCoYeDi10Kwe5ypS8flK
        4Q25rNLKZgfOo4PVqS9s4dw=
X-Google-Smtp-Source: ABdhPJyd68QRgFKL+CdJnQAxkQam33gqs5XxSyfigGKd7vlUvoEFMwo+8O33Sd8xbB7c6UcR4TWKdg==
X-Received: by 2002:a05:600c:3847:b0:39c:6a85:d20c with SMTP id s7-20020a05600c384700b0039c6a85d20cmr47854662wmr.129.1655910494691;
        Wed, 22 Jun 2022 08:08:14 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c4fcf00b0039c811077d3sm22954101wmq.22.2022.06.22.08.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 08:08:14 -0700 (PDT)
Date:   Wed, 22 Jun 2022 16:08:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <YrMwXAs9apFRdkVo@debian>
References: <YrLtpixBqWDmZT/V@debian>
 <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Wed, Jun 22, 2022 at 08:47:22AM -0500, Linus Torvalds wrote:
> On Wed, Jun 22, 2022 at 5:23 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > I have recently (since yesterday) started building the mainline kernel
> > with clang-14 and I am seeing a build failure with allmodconfig.
> 
> Yeah, the clang build has never been allmodconfig-clean, although I
> think it's starting to get pretty close.
> 
> I build the kernel I actually _use_ with clang, and make sure it's
> clean in sane configurations, but my full allmodconfig build I do with
> gcc.

After yesterday's stable report about clang build, I have now added clang
to my nightly builds apart from running gcc also. Both x86_64 and arm64
gave this error. Trying to add arm, mips, powerpc and riscv with clang
also, which all failed due to some configuration issue and I might ask
for help from Nick, Nathan if I can't figure that out.

> 
> Partly because of that "the clang build hasn't quite gotten there yet"
> and partly because last I tried it was even slower to build (not a big
> issue for my default config, but does matter for the allmodconfig
> build, even on my beefy home machine)

I am going to run them every night and will report back problems.

> 
> I would love for people to start doing allmodconfig builds with clang
> too, but it would require some initial work to fix it... Hint, hint.
> 
> And in the case of this warning attribute case, the clang error messages are
> 
>  (a) verbose
> 
>  (b) useless
> 
> because they point to where the warning attribute is (I know where it
> is), but don't point to where it's actually triggering (ie where it
> was actually inlined and called from).

Yeah, true. I had to check to find out its from the memcpy() in check_image_valid().


--
Regards
Sudip
