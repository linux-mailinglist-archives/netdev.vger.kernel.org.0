Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3123F8D0
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 22:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHHUxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 16:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHUw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 16:52:58 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24D4C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 13:52:57 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id g6so5673422ljn.11
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 13:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OB3GAa0Qn78dNiugi5A9sq+A1ic7+l5Zp7oAIGdm1hE=;
        b=BrBh1idcKULXXVVWwi6j4605pTX1qIR3kjUj/BP+PpMd8rTlFjAgByIkLqtYda9b3u
         E3g+pifNEDu3LTDg5EiXR6wehY5pqWbB3xWiDVkoL/gcqjTGrXTp4pwOw/jgsqVsgc+Q
         PJ5VDC4cgYFujnmogaqb9cfB6udj5xr+85LAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OB3GAa0Qn78dNiugi5A9sq+A1ic7+l5Zp7oAIGdm1hE=;
        b=FaUmkg5FA/Nm9doJx1uxNUyB15rFO8twIRgL/KEdJnANSD87Q5Aj5ejVmM+4WfJ37C
         Jycgk2r/O7YgQIu97rkVTRu0vnesG5Z9GTYRJ0qar3flqL6V7lhKyVOUcQx4+JJ1noLt
         eLMaGSvCo4K1/AFSzrnDkK3sXZgR1RvisTbsOyAgwmcGmOA6uPb7cPrcsc2WcMqRrHDF
         zvqtAv0S2AZZEQ+VceBUhQACoePrFGupcJIcqd04idXwC0fk8h61lycccVaJHlgHZXrE
         G/Nvx6I+B4oG4woXEs3DlsBEFd5pSBucsdy79BqxbcTGdx362jdqrjj30GTrLAyWHh6r
         wBig==
X-Gm-Message-State: AOAM5304DkKaMkXatB+ZKt93NUOg803Lg9iA8XiEo1TugVQCJB2gJwQ1
        NCFNsE9zIbwxKX8qv+yb5REteH3jVRs=
X-Google-Smtp-Source: ABdhPJxyjKX2hnYKR4Ql0cUP7oxbNn2nKgBvrSgiQPcE2Cq/6k2C39I4OnjHHxrfKjjYUq78GulNIQ==
X-Received: by 2002:a05:651c:d0:: with SMTP id 16mr9316947ljr.313.1596919975836;
        Sat, 08 Aug 2020 13:52:55 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id 80sm5599244ljf.38.2020.08.08.13.52.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 13:52:54 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id 140so2769278lfi.5
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 13:52:53 -0700 (PDT)
X-Received: by 2002:a19:408d:: with SMTP id n135mr9293411lfa.192.1596919973318;
 Sat, 08 Aug 2020 13:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com> <20200808204729.GD27941@SDF.ORG>
In-Reply-To: <20200808204729.GD27941@SDF.ORG>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Aug 2020 13:52:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
Message-ID: <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     George Spelvin <lkml@sdf.org>
Cc:     Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 1:47 PM George Spelvin <lkml@sdf.org> wrote:
>
> I *just* finished explaining, using dribs and drabs of entropy allows an
> *information theoretical attack* which *no* crypto can prevent.

The key word here being "theoretical".

The other key word is "reality".

We will have to agree to disagree. I don't _care_ about the
theoretical holes. I care about the real ones.

We plugged a real one. Deal with it.

              Linus
