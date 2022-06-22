Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6913E555121
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376435AbiFVQQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355693AbiFVQQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:16:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4641E39685;
        Wed, 22 Jun 2022 09:16:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o16so24129057wra.4;
        Wed, 22 Jun 2022 09:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t8fTjKPiEXxcK49dMKmR/PvQlfLitTyw5aVyNr6LTuw=;
        b=h73cmD/Od55jah8HUzrGD1NefEtgw1Ii7PExR9LdRJURRyiBpTReiYwfEHl+/04ZRz
         ThgHar8ri3QI0BT9zFcOrSe94IWs2xbMBkkGhLhCcWoCZdIucEYYugA1+rKpkjfvdTY/
         NqiNg3R28HIqQBXGPLP8/H1EYQ5MH8hWm3XSHcsSAxluzlgjoXLnFrfuyer0dIlAx3Ln
         grvr1XYIGWABrpxPHY3EY2DA4dvNMFJShKIYFovCSTRpeo7T34/hdOe0/luZhWEeW5Q8
         g9LGZCmqam/HJLFFe/s273SheTmN8G+Ak1f1FCnUqUeaH1n1s89BF2AEw0mfaT3KvY3k
         m0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t8fTjKPiEXxcK49dMKmR/PvQlfLitTyw5aVyNr6LTuw=;
        b=cY9vP0VMDSicWBBJn8oIPb7wZo4PvsJ2FwVxnRSPtRpNeOB6/nnnPXFu1d7Due6nIy
         VUHWCQPj5vVStcPf7awM+ikhSzEkOKaHw8NY5n+fIuVNyO5iJagv138RH1FMBixMeVdJ
         DNrbadoCxxepLe6ka5T4JpHhYGoorQM98QJ6l9Jpli+RwCDhfNm2yIOcSOXN4iHforGp
         sGfkDWZmSAPiGsf9e46lXLfq35rEr47Xsy88sWcIVQ0tEnoE+C0MRUXfMA8RNjeZT5Dy
         wOWbv6SJfpjgwEjSZWkB37juOEUyTuK7/ub49O1LuLu3bjjM5SP0jV+yubsHB7OauWm3
         /I+Q==
X-Gm-Message-State: AJIora/Fy34oLv4c6hM8MNc17QYKO5JNI11Dro5W6FcRGPgNmEou1udL
        25IZY4xPWk6BS69MijqtgeBb7N+pYxc=
X-Google-Smtp-Source: AGRyM1vizB7tgtcwmyIXHwnLNTGWhyYwtCSDtHPFvceoqZaoyGZ7qYyjxj50a8Z4+k/Sg+sFFs0ifw==
X-Received: by 2002:a05:6000:a13:b0:21a:3d94:c7aa with SMTP id co19-20020a0560000a1300b0021a3d94c7aamr4120237wrb.12.1655914605832;
        Wed, 22 Jun 2022 09:16:45 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id r64-20020a1c4443000000b003942a244f39sm31775253wma.18.2022.06.22.09.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 09:16:45 -0700 (PDT)
Date:   Wed, 22 Jun 2022 17:16:43 +0100
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
Message-ID: <YrNAazYbqA1sOa7D@debian>
References: <YrLtpixBqWDmZT/V@debian>
 <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMwXAs9apFRdkVo@debian>
 <CAHk-=wjmREcirYi4k_CBT+2U8X5VOAjQn0tVD28OdcKJKpA0zg@mail.gmail.com>
 <YrM8kC5zXzZgL/ca@debian>
 <CAHk-=wjdjrx_bORk3Th+rk66Rx-U2Zgoz1AOTE_UwVtCpD3N1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjdjrx_bORk3Th+rk66Rx-U2Zgoz1AOTE_UwVtCpD3N1A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:07:40AM -0500, Linus Torvalds wrote:
> On Wed, Jun 22, 2022 at 11:00 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > imho, there is no check for 'i' and it can become more than MAX_FW_TYPE_NUM and
> > in that case it will overwrite.
> 
> No. That's already checked a few lines before, in the
> 
>         if (fw_image->fw_info.fw_section_cnt > MAX_FW_TYPE_NUM) {
>                 .. error out
> 
> path. And fw_section_cnt as a value is an unsigned bitfield of 16
> bits, so there's no chance of some kind of integer signedness
> confusion.

oops. yeah, sorry missed that.

> 
> So clang is just wrong here.
> 
> The fact that you can apparently silence the error with an extra bogus
> check does hopefully give clang people a clue about *where* clang is
> wrong, but it's not an acceptable workaround for the kernel.
> 
> We don't write worse source code to make bad compilers happy.
> 
> My "use a struct assignment" is more acceptable because at least then
> the source code doesn't get worse. It arguably should have been done
> that way the whole time, even if 'memcpy()' is the traditional C way
> of doing struct assignments (traditional as in "_really_ old
> traditional C").

Incidentally, its same as what Kees sent.

2c0ab32b73cf ("hinic: Replace memcpy() with direct assignment") in next-20220622.


--
Regards
Sudip
