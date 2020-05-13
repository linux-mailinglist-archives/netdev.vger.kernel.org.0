Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BE31D1FA3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403792AbgEMTuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390696AbgEMTuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:50:10 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC111C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:50:10 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id f189so589346qkd.5
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AUaD8zHVYLcIfWsl1FLc6ajJYNyiXfBdqAf26hlsdlk=;
        b=AtuhJVK/9EjCL98+Yw35pZxzbfKOIo8uwjsEyXJI73TCo6OdEmzRCB6GafnVR/udUd
         Oms1h6C0cS889ZeX4eeSwZwBhQIVEU9SU8IYOM8rncYKW3ylm6QYFF4KFFFXDpgozwnv
         Im7XpENGDN0mEYdxgRWqZ62xHMtl34BWXWAClepMqE1OvqPrwLq47Z/fjJ/3HUP98gNt
         kikqlJQmIIqXPwC6TolLNm8BUOzrQrxfrrMKIl2ypWuYPn6QpCEcFpDswo13KpeiM5Io
         sFrmIkK9lmMTYHPLT/LBhLOZqT8dVZ4Z1cMeDO9fSQqy5v+vzLwBj70xlS5INn6B+5Zv
         lXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AUaD8zHVYLcIfWsl1FLc6ajJYNyiXfBdqAf26hlsdlk=;
        b=n0IRGuKSMonT7FcM18/x2jbHnqFn+3dLNPF5dwEZiFt/c5dDQuSqzcAtYwX4Kr5T4C
         xPBz3JXt/QSwJ+q/fpHAw0LyPr9/li+07hJwbQQEwNlhlaH/sicGZte9ssWSNw25oCnK
         lf1mGYaJ6+OKTFU3kLxxT2w+USfD7TCd6dpmN0wUN42a61jUbW/avyFzO/eJOy5Rrb+H
         pOgqZbRKZaww7sExWshSzqcWnFV6DcYwkBwiY2t1WnNb74sBK7JrSi2jFz8+0Mpie+/y
         fqlZiQ2/A6nzTWSLjBKyIOm+rS9RlslDlwd4tCbrOfjt9rpB2sogPR9h1EOiZv8xh1RA
         eT+A==
X-Gm-Message-State: AOAM530adqMUrznQir36k4hWRsq2lEOJretXZsSDn9Yy6gIW6snKCav0
        QdDexKOikojy464qB/Z8m+ZRzix+7JcnqO+pyfiDKw==
X-Google-Smtp-Source: ABdhPJzorgEMfRBdWZ+5yfHQMZz9u4bzScMyDeJDWPasebb9ILGmCbrD8VwbwlWw13jXYyklYFZf0RgLx00++YGlP34=
X-Received: by 2002:a25:1484:: with SMTP id 126mr1118259ybu.380.1589399408708;
 Wed, 13 May 2020 12:50:08 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
In-Reply-To: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 May 2020 12:49:57 -0700
Message-ID: <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
Subject: Re: [regression] TC_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I do not think we want to transition sockets in the middle. since
packets can be re-ordered in the network.

MD5 is about security (and a loose form of it), so better make sure
all packets have it from the beginning of the flow.

A flow with TCP TS on can not suddenly be sending packets without TCP TS.

Clearly, trying to support this operation is a can of worms, I do not
want to maintain such atrocity.

RFC can state whatever it wants, sometimes reality forces us to have
sane operations.

Thanks.

On Wed, May 13, 2020 at 12:38 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Hi,
>
> I am reporting a regression with respect to use of TCP_MD5SIG/TCP_MD5SIG_EXT
> on established sockets. It is observed by a customer.
>
> This issue is introduced by this commit:
>
> commit 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"
>
> The intent of this commit appears to be to fix a use of uninitialized value in
> tcp_parse_options(). The change introduced by this commit is to disallow setting
> the TCP_MD5SIG{,_EXT} socket options on an established socket.
>
> The justification for this change appears in the commit message:
>
>    "I believe this was caused by a TCP_MD5SIG being set on live
>     flow.
>
>     This is highly unexpected, since TCP option space is limited.
>
>     For instance, presence of TCP MD5 option automatically disables
>     TCP TimeStamp option at SYN/SYNACK time, which we can not do
>     once flow has been established.
>
>     Really, adding/deleting an MD5 key only makes sense on sockets
>     in CLOSE or LISTEN state."
>
> However, reading through RFC2385 [1], this justification does not appear
> correct. Quoting to the RFC:
>
>    "This password never appears in the connection stream, and the actual
>     form of the password is up to the application. It could even change
>     during the lifetime of a particular connection so long as this change
>     was synchronized on both ends"
>
> The paragraph above clearly underlines that changing the MD5 signature of
> a live TCP socket is allowed.
>
> I also do not understand why it would be invalid to transition an established
> TCP socket from no-MD5 to MD5, or transition from MD5 to no-MD5. Quoting the
> RFC:
>
>   "The total header size is also an issue.  The TCP header specifies
>    where segment data starts with a 4-bit field which gives the total
>    size of the header (including options) in 32-byte words.  This means
>    that the total size of the header plus option must be less than or
>    equal to 60 bytes -- this leaves 40 bytes for options."
>
> The paragraph above seems to be the only indication that some TCP options
> cannot be combined on a given TCP socket: if the resulting header size does
> not fit. However, I do not see anything in the specification preventing any
> of the following use-cases on an established TCP socket:
>
> - Transition from no-MD5 to MD5,
> - Transition from MD5 to no-MD5,
> - Changing the MD5 key associated with a socket.
>
> As long as the resulting combination of options does not exceed the available
> header space.
>
> Can we please fix this KASAN report in a way that does not break user-space
> applications expectations about Linux' implementation of RFC2385 ?
>
> Thanks,
>
> Mathieu
>
> [1] RFC2385: https://tools.ietf.org/html/rfc2385
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
