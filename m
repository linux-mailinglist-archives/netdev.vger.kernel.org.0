Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1980E53A5E8
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 15:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348774AbiFANZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 09:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiFANZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 09:25:12 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE2A4FC5A
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 06:25:10 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id x65so1274207qke.2
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K9Nc1Tu0/8ihCdAEMWgjDcSe3eiR1jGVE5lLxirGSF4=;
        b=OvJ+65Ln6clO1r0Wm9+1tnB8CfOMlWBLWn8Gt3f4oECyp+mG4cwm82xbK9bgrDkndb
         CzdIinyOkk72UD4y5w5eBLVQv9ncjxTe3wCvJgG3K2q+VEW5feX33f2XFtzWfDetKARv
         abAi7gQh0yprF/VT6mcX+ec/ecRVBZmxN2CPfxIs5rXKf0p2vr/rtDGUH7trK2D+jgAy
         i/4rScmxfUiBewySeZMz75sAIi1W8g/7G3kq6/nNcCiW2lsBCWxVyn5cs1sOzMOmHr12
         xIqHenHEHQVWnXfoqDYRjzGk8kvSFGEqKkeOMWvazYoM7vFYu1nnZKhGHh2jSDdrwPtp
         +mug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K9Nc1Tu0/8ihCdAEMWgjDcSe3eiR1jGVE5lLxirGSF4=;
        b=S2SSBEeL+lMQZQwWOKSr3c+89EFeBd+majxizt/dxDSp1VeYU1GaxozMzFC8oFXLe2
         AyngIkR122+EvBxrx6sOT6cNT7vdgmwlchKJutAHhiPRhcN+fIHcoiimiKk1GWTcZLqd
         RhubyO7QhtK6JuafK2vy9AwH6uyrMEbeyOR/6Ch59CJKCa1IExr71oftWqZ8vZVaiRpW
         BiNw6krGvyv1m/H1gVUsO0A65wtEdRhjpXUxbmgfJaJlWRgvt6yXsF7WPvvCcXBnUjDn
         xMTUrIBD8V1IVDZ9oh0pn8klXZGv+WtJoOBPH9KDMzp6gVBa4KiKVTSmP4vfHivS8jCq
         eiIA==
X-Gm-Message-State: AOAM530JE3uw8oLNYmxpm1RlwIXNZ9Osw0HNANj4HO6kj3vi1t4Cpo4S
        fVgPrW3duddRkzzTJW2xJP8ETLaDth0=
X-Google-Smtp-Source: ABdhPJxwa/d72qaubuZYJJXEFX6+U1DnBKDVg9+MuVxoW0dyc6usU8kzIotNVowmiha3oOEIBzFaqA==
X-Received: by 2002:a05:620a:89b:b0:6a3:62b8:83c4 with SMTP id b27-20020a05620a089b00b006a362b883c4mr38171908qka.676.1654089909515;
        Wed, 01 Jun 2022 06:25:09 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id k4-20020a05620a138400b006a650276ecesm1231402qki.14.2022.06.01.06.25.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 06:25:09 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id g4so2854008ybf.12
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 06:25:08 -0700 (PDT)
X-Received: by 2002:a05:6902:138b:b0:64f:cb1c:9eac with SMTP id
 x11-20020a056902138b00b0064fcb1c9eacmr48228399ybu.457.1654089908549; Wed, 01
 Jun 2022 06:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
In-Reply-To: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Jun 2022 09:24:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
Message-ID: <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
Subject: Re: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
To:     Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc:     netdev@vger.kernel.org
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

On Tue, May 31, 2022 at 10:48 PM Frederik Deweerdt
<frederik.deweerdt@gmail.com> wrote:
>
> Hi folks,
>
> Based on my understanding, retransmissions of zero copied buffers can
> happen after `close(2)`, the patch below amends the docs to suggest how
> notifications should be handled in that case.

Not just retransmissions. The first transmission similarly may be queued.

>
> Explicitly mention that applications shouldn't be calling `close(2)` on
> a TCP socket without draining the error queue.
> ---
>  Documentation/networking/msg_zerocopy.rst | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
> index 15920db8d35d..cb44fc1f3e3e 100644
> --- a/Documentation/networking/msg_zerocopy.rst
> +++ b/Documentation/networking/msg_zerocopy.rst
> @@ -144,6 +144,10 @@ the socket. A socket that has an error queued would normally block
>  other operations until the error is read. Zerocopy notifications have
>  a zero error code, however, to not block send and recv calls.
>
> +For protocols like TCP, where retransmissions can occur after the
> +application is done with a given connection, applications should signal
> +the close to the peer via shutdown(2), and keep polling the error queue
> +until all transmissions have completed.

A socket must not be closed until all completion notifications have
been received.

Calling shutdown is an optional step. It may be sufficient to simply
delay close.
