Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6B24C7150
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 17:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiB1QJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 11:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiB1QJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 11:09:16 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF05D3CFE7
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 08:08:37 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d66f95f1d1so114366187b3.0
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 08:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zr1KhrQOBP+ckaHGDXQrPDutiyt9xPRrC0whU+iVKI=;
        b=jxIpSTGGji0xor+tLpfeaOQ7m7XuQsBuHWuyrbyYh7wpOFWmV+dtZw2W4MytPcQDGl
         jNGfiy2kTT6xlkFT4zIrDsHVLTGQ7IH+r8v/g3+rHDqtl/kdCKrj1OE1o3d23SJn08XB
         fSq5OyK0/eSgbut4b9Jwp8Bx2/+ZzMBlhzsFh0+jgi2Klwuf1LOiu88BysVVe23+QI72
         mIsTRDGVvunw0wOvcFDiQix9uiJQilmGlKBRf7nDztKUF4TvFW6G7j1/71/urXHXP7SA
         HeP2caYU13MoR9asC4BK3XXw/aPsShkXf5qaEfrjkcvGg9nw/GqkV0aKkRsGJ4jURDHn
         S9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zr1KhrQOBP+ckaHGDXQrPDutiyt9xPRrC0whU+iVKI=;
        b=bzIMW8RcKVZB4dDd0D0l1Rwl0rIKx9XVFFVxgGYaGKzaLwqBZjlW+5mJYviYK9RAdL
         Bapx3eC9sZiRALbgtkuGgDEcQsE26KSN/d+6eutVkZKFKKnAzgJgQFKs53BADm4cj7Eq
         0v9+lPcdKpDNuvb/HsazE+tnWCMzf3jfERYHNoiIFlguk4vuZWSL6p/ZhqeKduZlt8rB
         kud1F0zjmNbl3uS8sx14rJAr5j3AQ7NZLmaGVl/+NTbQQoHCR1k01PbQsdZybLf0cn5V
         XkvLA1vS1inyYmOiewIFoQ4JmHZ/dJLZwIWorAF4Rw5JhT/4+j1tAy/xpkIK5cHxE+k9
         98Sw==
X-Gm-Message-State: AOAM532IRuWFEsIrn8MVkl/kNhjRtyyiif2Lgv9u4UCwb5/YYVQqX4Fz
        OKLY/EojywOMRc1e99QmRHbdGLoh0ELb5sCmWcQ02Q==
X-Google-Smtp-Source: ABdhPJyjwcR7rC1lAz4tbkYr5YLNPh89ineoXH4dC5PWQxMjASYjP1eVJNQcPTmdgavfdK5PzENtMHc8zjdwfjxHewk=
X-Received: by 2002:a81:1d5:0:b0:2d0:e2aa:1ae0 with SMTP id
 204-20020a8101d5000000b002d0e2aa1ae0mr20460032ywb.278.1646064516835; Mon, 28
 Feb 2022 08:08:36 -0800 (PST)
MIME-Version: 1.0
References: <ME3P282MB3326B9CED47E29DFD3B7B41886019@ME3P282MB3326.AUSP282.PROD.OUTLOOK.COM>
 <CANn89iJ=hehGt4utoiuZD4R7ut6dcfxXLRDJ36N-rfH5u91JLw@mail.gmail.com>
In-Reply-To: <CANn89iJ=hehGt4utoiuZD4R7ut6dcfxXLRDJ36N-rfH5u91JLw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 28 Feb 2022 08:08:25 -0800
Message-ID: <CANn89i+_48N62mA63RpNhTtG0hGcv78Arj99jSqLt79+Gi7+rA@mail.gmail.com>
Subject: Re: [PATCH] tcp: Remove the unused api
To:     Chen Tao <chentao3@hotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resend in non HTML mode, sorry for duplicates.


On Mon, Feb 28, 2022 at 8:07 AM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Mon, Feb 28, 2022 at 7:02 AM Chen Tao <chentao3@hotmail.com> wrote:
>>
>> From: Tao Chen <chentao3@hotmail.com>
>>
>> It seems that no one uses the tcp_write_queue_head after the
>> commit <75c119afe147>, so remove it.
>
>
> Wrong commit, also please use the standardized way of citing commit.
>
> Last tcp_write_queue_head() use was removed in commit
> 114f39feab36 ("tcp: restore autocorking")
>
>>
>> Signed-off-by: Tao Chen <chentao3@hotmail.com>
>> ---
>>
>
> Other than this changelog glitch, the patch is fine, thank you.
>
