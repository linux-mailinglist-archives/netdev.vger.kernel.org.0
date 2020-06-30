Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B920FD1B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgF3TxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgF3TxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:53:09 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19024C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:53:09 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q7so10801080ljm.1
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7YkmHTisRyR+XHwRU8pflDRJ5mhycFuIOFgtKJueDbI=;
        b=WgKX6C2z4yDEi8WLdZvFM/JRkJ4LS/z9z06RY0kgSCh3GfkgDELPfWaRxcAoy8t+m5
         uYu2RHnDe0knQnMjyo9ojiJs07br/VE2CJfx69QgERtjto10gsWNp2JocnSAEom2rRVd
         JKmpjmYgA3HDcCjcfHEG9PdN3vIEiR97lgOeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7YkmHTisRyR+XHwRU8pflDRJ5mhycFuIOFgtKJueDbI=;
        b=JfuWQW+08fKcgQsHMB7fFc2wVnBybR9QAuUaoYFrL6cdvOyXmPjUv+68nH6Ev2jrbJ
         4GN5vowvcXsQ6lSPRbGfmrHQxh/+jQbcMII9MbHw7/ukzLdXnLxNgsH7rTnzDFgFoSHJ
         XRaqVfDKFQEuxCD8d38/z2pm0VpHkadakQZ+xbBrAfYfRSCgWZSXg77Nger3sONtUQKY
         GEQ/bzUPb2VLY9w/tOCEy17/MOQo3SGE4XD3uBpWe2Rkg584zGdDTy4lr7LdUM/h1T0r
         WTrwqqN8IFlt8TbzH1ETXeghgoKwviMmc5vBXWqMgakBCxaXbAlnxOcL45roqv+9ryAS
         I9jw==
X-Gm-Message-State: AOAM53381GyVocvnmSQDa8ZbbsVXVr5LqKVducvFGpxsDYYUYRVHAoCP
        ckLtqMjzMqNtQDG9Ao2yT3YgjZim5GI=
X-Google-Smtp-Source: ABdhPJxD0UQn31MssztO0DBMmqx2y45xolXdeVBeWGLcNvp9I5J0SzC1HFhiH0DPOpnb6nZrP1KW/g==
X-Received: by 2002:a2e:9ac4:: with SMTP id p4mr8199097ljj.143.1593546786032;
        Tue, 30 Jun 2020 12:53:06 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id o21sm836361lfo.2.2020.06.30.12.53.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 12:53:05 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id n23so24073428ljh.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:53:05 -0700 (PDT)
X-Received: by 2002:a2e:9c92:: with SMTP id x18mr6344857lji.70.1593546784711;
 Tue, 30 Jun 2020 12:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
 <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
 <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
 <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
 <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com> <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
In-Reply-To: <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 30 Jun 2020 12:52:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
Message-ID: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Eric Dumazet <edumazet@google.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 12:43 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If you're not willing to do the work to fix it, I will revert that
> commit.

Hmm. I only now noticed that that commit is over two years old.

So I think it's still wrong (clearly others do change passwords
outside of listening state), but considering that it apparently took
people two years to notice, at least some of the onus on figuring out
a better morel is on people who didn't even bother to test things in a
timely manner.

At some point "entreprise vendor kernels" or whatever who stay with
legacy kernels for a long time only have themselves to blame.

             Linus
