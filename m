Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B40C662286
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjAIKJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjAIKIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:08:21 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF4911A00
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:08:20 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-476e643d1d5so106753107b3.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 02:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7tsYsaiahRzA5OyljAtlsD2xlK/lRK41Fn2e6H3K3nI=;
        b=dVNcBqWKS4OFZCA630uJoHi87HCJMYvNKkrxvhzvVp0NsqMYTkdaNS+ci/o6f3Ah24
         txmQEXTmBJax6raeiuy7VB3Xq7Va5lBdoQLZtUWZ7zD9jJOS3yuBiP/rY0TRoQlAP5tc
         ENQHdueG5Cs1JzyjQONHa/iz2CDJfHdQFdi6oohgBUmMbxY2m5nX1KHXW6XhG+O04jbE
         Ug/rky80tgJteWkehuc27GMB9eKnqgR1D5QR/qlAZ5MzVEKlC84h9RbfDpStM2PLuV9P
         4aMk7UehIHXMzerE6b0PegFMsW4pbPzTAs1ScfPm6/SH11NPTG+4VqULI4I7a8wmS172
         5Zuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7tsYsaiahRzA5OyljAtlsD2xlK/lRK41Fn2e6H3K3nI=;
        b=XWm7nJL6akph+svPSxm4w4GOM5bfzLekUXcP5SRrTX1YBwQZPX9h2Zd/RliTfNPwNW
         LXr3lhyR6NtNREZQuo6qcePAIjeI1gneY9hXHU5ojogQcjvi96eMOmWGtez8MqaxySh6
         uGMMrKDV6Nt2hMrX5ol4n/w51eBDCgtzyonIor9eLlCC9XMEev45zGMwWG2d+3ukRePC
         /gHdbj7TdNZeedBrZHglA4/MimPWiejzOhKTb7goOZ/kvwuHasmENyEHHUKQfj7ekjEb
         tc6T4pxG+jBbdiS5r4QUcabKDrrTCQuVOi2JwwJLppuBBG7+qOxOgVvxDsgf+ZS17Xgl
         FdOw==
X-Gm-Message-State: AFqh2kp5ccFsOPz2+4dy2IjV37NlLEesQrAXblK2ChYmnTAMC2Bv2hPB
        lJkujKx96rFl3OwVTD8ptJqRN3LnegZLzgBMaR9P6w==
X-Google-Smtp-Source: AMrXdXuE9GZs19145MlvVJVG9gEFs23V3V3YWS7qd026xfoGVd5QjWXvgfC3Bf69x2gD8d/V+eTtAQWAQ0XPlPTcmxc=
X-Received: by 2002:a0d:d6c2:0:b0:46b:c07c:c1d5 with SMTP id
 y185-20020a0dd6c2000000b0046bc07cc1d5mr819799ywd.55.1673258899575; Mon, 09
 Jan 2023 02:08:19 -0800 (PST)
MIME-Version: 1.0
References: <Y7iQeGb2xzkf0iR7@westworld> <20230106145553.6dd014f1@kernel.org>
 <CADW8OBu8R7tp-SfEwNByZqJaV-j2squT1JigniZLPwe0sWpRWg@mail.gmail.com>
 <CANn89iJTtmdT0HsUtVMBdWeuj8pNY-FN6hkv0Z3QYr8_Yt_3Rg@mail.gmail.com> <Y7vm00H/+oVXqsya@gondor.apana.org.au>
In-Reply-To: <Y7vm00H/+oVXqsya@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Jan 2023 11:08:08 +0100
Message-ID: <CANn89i+B6ZWJpHEPBS=cQxpa=R8LU=fO+CisdbM9bA9aCwE3_Q@mail.gmail.com>
Subject: Re: net: ipv6: raw: fixes null pointer deference in rawv6_push_pending_frames
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 11:05 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jan 09, 2023 at 09:45:14AM +0100, Eric Dumazet wrote:
> >
> > OK, but it seems we would be in an error condition, and would need to
> > purge sk_write_queue ?
>
> No the bug is elsewhere.  We already checked whether the offset
> is valid at the top of the function:
>
>         total_len = inet_sk(sk)->cork.base.length;
>         if (offset >= total_len - 1) {
>                 err = -EINVAL;
>                 ip6_flush_pending_frames(sk);
>                 goto out;
>         }
>
> So we should figure out why the socket cork queue contains less
> data than it claims.
>
> Do we have a reproducer?

Kyle posted one in https://lore.kernel.org/netdev/Y7s%2FFofVXLwoVgWt@westworld/

Thanks.

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
