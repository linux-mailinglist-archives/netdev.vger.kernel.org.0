Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73924CCB43
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 02:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiCDB0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 20:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiCDB0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 20:26:11 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD45171292
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 17:25:23 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id dr20so14307684ejc.6
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 17:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXcSKTcmdpOP9qB5JWi69d94VS7YUiud5rTzmfXw224=;
        b=Zt6PJJCSc1XuoIGW6ImAMgqm5JJ7xy580+kyR+qqFz2zO+zFqA9YgoZjSC5/Y4QkAU
         33fupdsEwU0NBMyH+G2R+WeF6Bhbdo1lTUOpPaUWKjFd1fSCndB64M24NEH1oRj4Kgna
         tuyfyOhofy0XuKyjYjds8VaQW5baRZ90xHei6yQEtuLV/uBRjXrZSlI5DhPCciyox9FH
         MZcD/X5qm2dLei78wLRhMvDOtBs78mVvhN9vKzreUPAanzzrp3nnSyMqrImvVwqms6EL
         7ClNdn1V0jBw7lo2ngBBtIotWVEnZWWmCEpa55T2zEKD2VRYU60osXYJvqNnMtZ9tNgm
         qDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXcSKTcmdpOP9qB5JWi69d94VS7YUiud5rTzmfXw224=;
        b=nU+5GF2aQ/IZwwLM0It/79gq5y+QBbCvj9lhK41n0+CP1QmS4W/Qejd/JHB0YyDljC
         41HePoJFmQg/EIML52uBcUNrvF69QDiEL67uNViU5Dp4SN4zlhi1qIAuSgcttRRkRqr/
         Zpg8/SKUku9mNsCj+sVbcSrBPY6x3C0i7NQgKJDgZB0kkJh0L0O5FkSght9cMACgLFEi
         2OkWnhxFeLCn8FYWyKwFM4z7mFs4B9ZPCfAnC6d+SxBWLQprOuxvqrUQvigQ1eT19jZR
         BLRdy73o+lXVFac93ESEhtyu97Il1ufCB4eU7ajvyh/UmNLH/eca1a7t2wDyXuz9AlgC
         8DLQ==
X-Gm-Message-State: AOAM53043rtVjfSgTztacaA5rRt1IuAQz1vDZbeup6jv1FWTuINj5a4K
        9EPxjOx4zMfrmGB8lU5TrBr09rzDWqZXELPW2Eo=
X-Google-Smtp-Source: ABdhPJzyQXkK9qEtBI7XFWdTWr7A7gILdx2tx8+JO1f4exUDPonFTW3AmD/QcgBEF+NPB++Y9tmD8zyGv/6v9uoa+lQ=
X-Received: by 2002:a17:907:8693:b0:6d9:67df:b21c with SMTP id
 qa19-20020a170907869300b006d967dfb21cmr8993972ejc.536.1646357122337; Thu, 03
 Mar 2022 17:25:22 -0800 (PST)
MIME-Version: 1.0
References: <20220222112326.15070-1-xiangxia.m.yue@gmail.com>
 <20220302112420.4bc0cd79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <702ea05e-c9e3-8b2a-21df-59f3980a5818@mojatatu.com>
In-Reply-To: <702ea05e-c9e3-8b2a-21df-59f3980a5818@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 4 Mar 2022 09:24:45 +0800
Message-ID: <CAMDZJNUa5cpA4BXqE7cj=8ZBw0n1dR_a_x-L8hHPjVhOSbdHZA@mail.gmail.com>
Subject: Re: [net-next v9 0/2] net: sched: allow user to select txqueue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 7:33 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-03-02 14:24, Jakub Kicinski wrote:
> > On Tue, 22 Feb 2022 19:23:24 +0800 xiangxia.m.yue@gmail.com wrote:
> >> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> Patch 1 allow user to select txqueue in clsact hook.
> >> Patch 2 support skbhash, classid, cpuid to select txqueue.
> >
> > Jamal, you had feedback on the previous version,
> > does this one look good?
>
> No it doesnt.
> Maybe i wasnt clear enough to Tonghao because they sent out
> a patch right after that discussion which didnt address my
> last comments. Here's my take:
>
> Out of the three options in 2/2 that Tonghao showed - I agree with
> Cong on the last two (cpu and class): that user space can correctly set
> policy without needing the specified mechanisms being added to the
> kernel.
Sorry, I miss that.
I will remove the cpu and class hash in next version.
> skbhash otoh is meaningful.
>
> Patch 1 is useful irrespective of patch 2.
>
> cheers,
> jamal



-- 
Best regards, Tonghao
