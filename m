Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60104599DD1
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349044AbiHSOzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348695AbiHSOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:55:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F30EF026;
        Fri, 19 Aug 2022 07:55:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o14-20020a17090a0a0e00b001fabfd3369cso5099781pjo.5;
        Fri, 19 Aug 2022 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=T6fT7nNCKMbrfNAmBcVL3KD2JL0FCBDvC1i8ixlnj/U=;
        b=fI8RNHiH7NjW7J/Lgfb3by039mnaaWUyN/QgoqUb6q7HiMtAl2mDJp9+IpjpE/MW2F
         RewMTs80lbmLNZNhISmcQsxP/60aKoYW8aoC9P7gTmON+85CVs7fUCg5j4jV/lRI3R50
         diAV3zZZsNyg0c6wCLlbfhjRQ0OfxiU1arT4QJ24bvxwz0fath/Gh2C1FUfrX4w8TXRZ
         hV47nU1kQQtl6fRWGZDcX1GY7IYNKCEhc+07NcBF8w+J08uuMCv7asTgUVNxoSHygKzv
         CFFJw5RfTfFfZWG8k68SbQtz5/AVsP7sQo5nyYAmc0+A1e1UoKWkKAAw1RUtu+x2UDsy
         mScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=T6fT7nNCKMbrfNAmBcVL3KD2JL0FCBDvC1i8ixlnj/U=;
        b=TvusYwXtK3xGaGnRwJBGQAVlc1N0sS0hR1slE+mO6cH/ouS+vfiNVETSvYEEQzBZgV
         yEtkV6QOKKXo1xp/clbuEml461C3TQmEKq3L1WhEhd9eo7kX5ViFAmi6Td+6kpOmr8iO
         N1xskS++pzDpPRTOLVA6JMnJTZien5BX6XXEqLrRasOgETFxmgmeZB2hTFl33HzHWTdS
         v0Gpp1QrWCXsnnN6QNwtTYJH2w/QJsGG0O5jyNTfjnz4x0ZjqnHUrpHhlnOm2eYi6K3h
         /1MqgsjpQLtTteusLedN6ZjywP5bAZPGaV5On+5LQAgGvJGcN7z4qif2vEuo1fA9vYak
         haRg==
X-Gm-Message-State: ACgBeo2OY7KTFa+mwT7ueo7XkbkC6wuKJMlDNg5L6NhvRK4mc/s3WFI7
        yLoDrKViPzce/cjDsmICAEcs8sElYdnZDuaTAj4=
X-Google-Smtp-Source: AA6agR5HLWtU4kIuacFtn9NcvNyumJOZEFnRj3NuvQuBgNNzXADaPTLiSvl8QiUHheM91qJcI3a1P4Yuqq7jAInCYNs=
X-Received: by 2002:a17:902:d4c7:b0:16e:df4b:89b4 with SMTP id
 o7-20020a170902d4c700b0016edf4b89b4mr7525425plg.142.1660920953520; Fri, 19
 Aug 2022 07:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com>
 <CAKwvOd=accNK7t_SOmybo3e4UcBKoZ6TBPjCHT3eSSpSUouzEA@mail.gmail.com>
 <CADxym3Yxq0k_W43kVjrofjNoUUag3qwmpRGLLAQL1Emot3irPQ@mail.gmail.com> <20220818165838.GM25951@gate.crashing.org>
In-Reply-To: <20220818165838.GM25951@gate.crashing.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 19 Aug 2022 22:55:42 +0800
Message-ID: <CADxym3YEfSASDg9ppRKtZ16NLh_NhH253frd5LXZLGTObsVQ9g@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, kuba@kernel.org,
        miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        linux-toolchains <linux-toolchains@vger.kernel.org>
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

Hello,

On Fri, Aug 19, 2022 at 1:00 AM Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>
> Hi!
>
> On Fri, Aug 19, 2022 at 12:31:44AM +0800, Menglong Dong wrote:
> > On Wed, Aug 17, 2022 at 11:54 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > > Perhaps noipa might also work here?
> >
> > In my testing, both 'noclone' and 'noipa' both work! As for the
> > '-fdisable-ipa-fnsplit', it seems it's not supported by gcc, and I
> > failed to find any documentation of it.
>
> noipa is noinline+noclone+no_icf plus assorted not separately enablable
> things.  There is no reason you would want to disable all
> inter-procedural optimisations here, so you don't need noipa.
>
> You need both noinline and no_icf if you want all calls to this to be
> actual function calls, and using this specific function name.  If you
> don't have noinline some calls may go missing (which may be fine for
> how you use it).  If you don't have no_icf the compiler may replace the
> call with a call to another function, if that does the same thing
> semantically.  You may want to prevent that as well, depending on
> exactly what you have this for.
>

Thanks for your explanation about the usage of 'noinline' and 'no_icf'!
I think 'noclone' seems enough in this case? As the function
'kfree_skb_reason' we talk about is a global function, I think that the
compiler has no reason to make it inline, or be merged with another
function.

Meanwhile, I think that the functions which use '__builtin_return_address'
should consider the optimization you mentioned above, and
I'll have a check on them by the way.

Thanks!
Menglong Dong

>
> Segher
