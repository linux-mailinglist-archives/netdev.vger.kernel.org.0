Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B586A20FCE6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgF3Tnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgF3Tnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:43:41 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA53C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:43:40 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f8so11737838ljc.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YsqwdRQFFt3HHRK3xFxPD0d+PNk+87DZe2KkR3X05O4=;
        b=HT7tCbAjQS+Z4+G4SyrMS3j9InGiewKytjMCpTGPeocEMilLSzDoOCC3XIhxcrkAg+
         95aSOjncCnTsTDEsFE4ITphAp+kV64NzgNuu7AJHEnDGSpko+cWd1wtiBEiZjGsxn1A2
         1DjW+cPmNaM7JVxpleTXfH6VRMPkgVOO6wr8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YsqwdRQFFt3HHRK3xFxPD0d+PNk+87DZe2KkR3X05O4=;
        b=LSUFM5sMymI9FqxhX7vOaHXfHGcBZuTqMGayOKqCQ8TPVquSemhkxY87Cl7/fcGjmk
         p1dFjUAzxcL5V8OKaHS7H+MQdOfKve1M0TyRJIO2xHHvLPnvfeks3srYy09idV0BzLA8
         hDTNWowB/NnxsNcu3EGf4uSRZt/gRtb1yHDXpPOwn+t0s7MCSKuw6kkKpinAtt9cD7U3
         eDLWV0CCMOO8Ns1tNGcseqedJFEpAlj5cOnH2SVmeGhAAagl+xVkZWOeAR/fJCF7gx2t
         KrBeTYpDZRLAc2nw8NL9rYsdmdeLxkoN422x1ZEoLSes26sp9eb+sFwkXY2F7kRmqWuk
         g3Dw==
X-Gm-Message-State: AOAM530EEPgB0Jpi6NfCdwCWJDD85I44h0m03AfAdBVt7a41ME3b6mk7
        PzEIJ53su1yOP1CDD+G3byC+XjMZu1o=
X-Google-Smtp-Source: ABdhPJwUwNWulH8exo+AtmG70Qs+DVMupzBP3HLEybu0Dluu6QYtFA9tBLMtftSMhrvmKUjUIAOIrw==
X-Received: by 2002:a05:651c:118f:: with SMTP id w15mr11542652ljo.211.1593546218877;
        Tue, 30 Jun 2020 12:43:38 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id v3sm1033309ljj.110.2020.06.30.12.43.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 12:43:38 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id f8so11737706ljc.2
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:43:37 -0700 (PDT)
X-Received: by 2002:a2e:991:: with SMTP id 139mr10946115ljj.314.1593546217407;
 Tue, 30 Jun 2020 12:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
 <CANn89i+GH2ukLZUcWYGquvKg66L9Vbto0FxyEt3pOJyebNxqBg@mail.gmail.com>
 <CANn89iL26OMWWAi18PqoQK4VBfFvRvxBJUioqXDk=8ZbKq_Efg@mail.gmail.com>
 <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com> <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
In-Reply-To: <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 30 Jun 2020 12:43:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
Message-ID: <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com>
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

On Mon, Jun 29, 2020 at 1:47 PM Eric Dumazet <edumazet@google.com> wrote:
>
> If you want to be able to _change_ md5 key, this is fine by me, please
> send a patch.

Eric, if this change breaks existing users, then it gets reverted.
That's just fundamental.

No RFC's are in the lreast relevant when compared to "this broke
existing users".

If you're not willing to do the work to fix it, I will revert that
commit. Because that's how it works - you can't ask other people to
fix the breakage you introduced.

It really is that simple. We do not allow developers to break things
and then step away and say "not my problem".

         Linus
