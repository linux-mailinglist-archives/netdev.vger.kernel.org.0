Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A620FDDE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgF3Ujk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbgF3Ujk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:39:40 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA058C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:39:39 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 187so10766800ybq.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i0YqT6m3QtaAiDI6grIJlvbolRVDowogWllB0TSpYPE=;
        b=AW4tqNB+BgRpKkfQRGV1Z/vkYn0fzNhc2eLPusihMPDvXcGu6gra+VNscBfk9xuFZY
         ArtotMYiGS9mbfWPGVDez5YKt9DwuVV2suJcC2TmLxwvDVhYxfhwl88hepl1aePYPlXt
         M14CXbyA6FPNAcyuVyWrGuizTBAqFjGlVmH3YQ29cWRsuobQF4jZq39DEb2EznPF75Hm
         UsnHBONXYRh1YNbEuzyDMUq2x7xT8yVzSeYGVNKYSH8tebRR7ALzuTn5Lb9v9wcPtgyb
         qhDWWntg6tv9CJl0KFkmp8sV1xzPbUMF4rDFl0Uq4Ho0dW3HKKqJsNIfMtG+sa1275hg
         i8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i0YqT6m3QtaAiDI6grIJlvbolRVDowogWllB0TSpYPE=;
        b=dFPGm0/BpEBnOrK5k+TP2bE8xmqN35ys3ss5OHvL5wpuxKavI36vgUeK+IjyEEFFgY
         JqUqCwvpyC/2tGXKeroqwE1WZTKXpz/y+zpDAyXKFnwa3R0kjks3x7ovDpKRqL7bidTQ
         kmEoFiUXXDPyox1YU95NTTkMGjSQN3RcwtFLUMVgDAZFqnHp13Br6gtuBj+ksCQJFusw
         Sj4LFy+hSs6V1DFKcWWb0ZUrH1qNz8qbD+a1VQL9mHz33c8p7K+fI6JQc8q/mojpW98h
         Oqp5Iyg+Qh1+JswoHPNUkc3H5NS1yTAVCmGCt6ot24bG/S/Z7y86iQ275kXp+Om8vyrX
         CqqQ==
X-Gm-Message-State: AOAM532MJM7A59EVrHKoIrkE5sWVe42ENFjIHixik6cVs6zQHmWTCSev
        swhqo9XXSxQ3eSGy1TLZlxCsVvig8oJcptKlNr68pA==
X-Google-Smtp-Source: ABdhPJxEFyG47Mk9/fEa8byqvXhpzEmiNHg3MBfmfHwrUOS8Da/0w7Kf6vsTk/ftSM2oheIYGIfcqw5V1nqZefvbUuo=
X-Received: by 2002:a25:cd87:: with SMTP id d129mr34851710ybf.395.1593549578616;
 Tue, 30 Jun 2020 13:39:38 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
 <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
 <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
 <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
 <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
 <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
 <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com> <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
In-Reply-To: <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 13:39:27 -0700
Message-ID: <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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

On Tue, Jun 30, 2020 at 1:34 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> ----- On Jun 30, 2020, at 3:52 PM, Linus Torvalds torvalds@linux-foundation.org wrote:
>
> > On Tue, Jun 30, 2020 at 12:43 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> [...]
> > So I think it's still wrong (clearly others do change passwords
> > outside of listening state), but considering that it apparently took
> > people two years to notice, at least some of the onus on figuring out
> > a better morel is on people who didn't even bother to test things in a
> > timely manner.
>
> I'm fully willing to work with Eric on finding a way forward with a
> fix which addresses the original issue Eric's patch was trying to
> fix while preserving ABI compatibility.
>
> The main thing we need to agree on at this stage is what is our goal. We
> can either choose to restore the original ABI behavior entirely, or only
> focus on what appears to be the most important use-cases.
>
> AFAIU, restoring full ABI compatibility would require to re-enable all
> the following scenarios:
>
> A) Transition of live socket from no key -> MD5 key.
> B) Transition of live socket from MD5 key -> no key.
> C) Transition of live socket from MD5 key to a different MD5 key.
>
> Scenario (C) appears to be the most important use-case, and probably the
> easiest to restore to its original behavior.
>
> AFAIU restoring scenarios A and B would require us to validate how
> much header space is needed by each SACK, TS and MD5 option enabled
> on the socket, and reject enabling any option that adds header space
> requirement exceeding the available space.
>
> I welcome advice on what should be the end goal here.
>

The (C) & (B) case are certainly doable.

A) case is more complex, I have no idea of breakages of various TCP
stacks if a flow got SACK
at some point (in 3WHS) but suddenly becomes Reno.
