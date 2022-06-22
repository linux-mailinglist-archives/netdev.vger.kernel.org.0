Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0345550DD
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358635AbiFVQID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358263AbiFVQIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:08:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9D4140C6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:08:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id fd6so21807235edb.5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AplRqfnN0oWkS+2VNQi8ZStoPrmgxPvXHgqZuEE6ulA=;
        b=RjrOyWJQLKFLoF69Y4cw8jPAZQd/5a73i8kXm9/eqxT4hqXK39Co8UGdIrRTlokSAF
         LdKTNyP83Rc4J+75iaPsPpCji4Sc36JQRHgHEvJyiTS7qBTq5n4ELSWPbP4ibEDb5vh+
         WEgDhWOy38aHbqmCKRCMRkcgJB88OKHWthfFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AplRqfnN0oWkS+2VNQi8ZStoPrmgxPvXHgqZuEE6ulA=;
        b=FrhcrnucdkVNxkqHXWvs000E+3Aj5aihDCOrehim1Vrnyx6Cd59ufJVm/BDDdHFIgK
         CpBDp4ZzY0p2fr1ewgASeBYtFE9pLxyMQ8Y4Vu9r1WfLTNybQnP3hSpcOoRhtPlY1k+x
         vFbdzzpUm8/rIs2IKRYG2B6kNJPc5Ww8R8mzVWbptwBLK5gJVpU9o7W+jaQjEi/3YMIv
         mkHzEb/QL/8+BWUBB1wyfzoYTvFrLXlO1uvDxDj+J/A6Wn2T0ODvIyThG4gFsMhPF4xv
         HwHpaJ4QN8SojjBgiELipxyYPpteawywKHDGxaUFr8vH48CqCQgnocR4qAUFNAxlFYr/
         Uqvw==
X-Gm-Message-State: AJIora/kQ3RHfwKjbv9EMjN2//ax5ZwAWKkROv4duPlAFuBjd1XNFXvl
        zr/R3AZBNpoGhR0FALY3SfIzoQXgJvnCvTSP
X-Google-Smtp-Source: AGRyM1u05y44Ud8GmSS5N/ZVvTLw8hfGZHfQVOOHZka4qKYnBa8cu77wqPPG+w9oIWFANmcZq76D/A==
X-Received: by 2002:a05:6402:3689:b0:435:95b0:edf2 with SMTP id ej9-20020a056402368900b0043595b0edf2mr4963411edb.279.1655914078486;
        Wed, 22 Jun 2022 09:07:58 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b006f3ef214debsm9583890ejh.81.2022.06.22.09.07.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 09:07:57 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id r20so3669531wra.1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:07:57 -0700 (PDT)
X-Received: by 2002:a5d:48c1:0:b0:21a:3574:e70c with SMTP id
 p1-20020a5d48c1000000b0021a3574e70cmr3983380wrs.97.1655914076974; Wed, 22 Jun
 2022 09:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <YrLtpixBqWDmZT/V@debian> <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMwXAs9apFRdkVo@debian> <CAHk-=wjmREcirYi4k_CBT+2U8X5VOAjQn0tVD28OdcKJKpA0zg@mail.gmail.com>
 <YrM8kC5zXzZgL/ca@debian>
In-Reply-To: <YrM8kC5zXzZgL/ca@debian>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Jun 2022 11:07:40 -0500
X-Gmail-Original-Message-ID: <CAHk-=wjdjrx_bORk3Th+rk66Rx-U2Zgoz1AOTE_UwVtCpD3N1A@mail.gmail.com>
Message-ID: <CAHk-=wjdjrx_bORk3Th+rk66Rx-U2Zgoz1AOTE_UwVtCpD3N1A@mail.gmail.com>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang support")
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_RED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:00 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> imho, there is no check for 'i' and it can become more than MAX_FW_TYPE_NUM and
> in that case it will overwrite.

No. That's already checked a few lines before, in the

        if (fw_image->fw_info.fw_section_cnt > MAX_FW_TYPE_NUM) {
                .. error out

path. And fw_section_cnt as a value is an unsigned bitfield of 16
bits, so there's no chance of some kind of integer signedness
confusion.

So clang is just wrong here.

The fact that you can apparently silence the error with an extra bogus
check does hopefully give clang people a clue about *where* clang is
wrong, but it's not an acceptable workaround for the kernel.

We don't write worse source code to make bad compilers happy.

My "use a struct assignment" is more acceptable because at least then
the source code doesn't get worse. It arguably should have been done
that way the whole time, even if 'memcpy()' is the traditional C way
of doing struct assignments (traditional as in "_really_ old
traditional C").

               Linus
