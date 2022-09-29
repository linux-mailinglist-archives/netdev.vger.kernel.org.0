Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595F45EF34D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiI2KT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiI2KS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:18:59 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE93712ED9F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:18:28 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-131dda37dddso293332fac.0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1Cl0X39qkQEt/y9Mr2rlDhC6cvyU1oB8bqUhsRPfFjw=;
        b=oKXPJbkf45R1vzWZcxh4YaF25ZAkn4xfL1s/pYp2qTAZiSUrtiJ44rgSQI1VfGTQjH
         vClfq5dYd8DiJ+2lMY8t8pT02diUCStyJykW4WeGUv3fgFetRDkA7VpkRFw6Sw8Z4UwI
         QJrkB0bbE0OgnaA/xoSDRrFQJVRlVOrRdEFQpDJAphXLbsOFLeOh0LPQDsQt5vZBC9xq
         mAi36oTLrnTchR7U4zksdaUwv6HzcIZBlzBfD6ls+K6JMewBOiBovZ9DmD9fu+1oUmMp
         G4TQL7NKWwrJkPefPX7P/QimpvV6kTEeDNSbpTfKFzK2JR6/ZFmcB5dR2pZE3HDwH65n
         0w3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1Cl0X39qkQEt/y9Mr2rlDhC6cvyU1oB8bqUhsRPfFjw=;
        b=EAgkTN6YSVqhdEcoQGnqkPaJj0rwksxlEy2O6ndcnli4YIvZ4vkNGZXpw/Wkh9nw7t
         MxDtrnGhk2T7ddN9KJBGjcEU8Hj7acwFOwzlIBYkRAVINDx+7nT/kw5L1nxOnwObbRal
         nBpugLBQxNTRizr3RCefou9Ba1dG6gTJV1jMoxY2qUiKN1bkg06Ay5j9rR83zqfR+pAJ
         2m5xFn8M8afeOK86+uvvhbdbPR1gI1uvMlR8nn3EHjQ5VbX73/bwfGDwTbpl6SctTIFt
         7JatU8ggOc65kRaCRqFtHuiBQyTYDPp4NhQqwhnvwGiacSGgnHBxnotA8uj5ckW+GKYK
         yr5w==
X-Gm-Message-State: ACrzQf3u+9VfxYpX/Ne6T+ehySbVKSjKn9sz1vYIcwkGx7ClpaVGUEan
        PY8Et1+/ilkOB4OYNPoNamTtO5RsBjUJ8hJlrY/t3A==
X-Google-Smtp-Source: AMsMyM4w85ys+LTV212qG29Xx/YrH+bZHF0Uy+vFG3Y/DUYbV2ChkuLHHdknY7dc+LEqTrikKz9uRVJ4xSMLyjSgruQ=
X-Received: by 2002:a05:6870:a10c:b0:131:c133:39bd with SMTP id
 m12-20020a056870a10c00b00131c13339bdmr1338610oae.106.1664446707905; Thu, 29
 Sep 2022 03:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220927153700.3071688-1-keescook@chromium.org>
In-Reply-To: <20220927153700.3071688-1-keescook@chromium.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 29 Sep 2022 06:18:17 -0400
Message-ID: <CAM0EoMnGbS-KHknPU+3gf2CaQO7XtKt-jFRZEZ42ZxAS=3ZzMQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: cls_u32: Avoid memcpy() false-positive warning
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 11:37 AM Kees Cook <keescook@chromium.org> wrote:
>
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), use unsafe_memcpy(), as the sizing,
> bounds-checking, and allocation are all very tightly coupled here.
> This silences the false-positive reported by syzbot:
>
>   memcpy: detected field-spanning write (size 80) of single field "&n->sel" at net/sched/cls_u32.c:1043 (size 16)
>
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org
>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Reported-by: syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/lkml/000000000000a96c0b05e97f0444@google.com/
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
