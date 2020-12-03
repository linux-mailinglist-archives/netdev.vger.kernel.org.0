Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187F02CE07B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgLCVTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgLCVTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:19:19 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006EEC061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 13:18:32 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id s27so4828283lfp.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJRKnqjCgWHhm3DXxiGPglLb7n4zSVyCYpnqLdcdiZo=;
        b=TBvZ8cT+n+pese6T9ygSu73P9cc8jXepQ+bP4M1qPKZTgVR/VxJCes/IPiqB3zVaRZ
         dm9AAoxOgzmzlj6bvdGb4sfWZ+FhCyhNrL80+Spt99mgn9W4suTyGjHaCg8x4l/sbZlQ
         zVFKModYzVc0g2ZULXQBME729MQtdKXVNqm4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJRKnqjCgWHhm3DXxiGPglLb7n4zSVyCYpnqLdcdiZo=;
        b=PGXdXlfpYqqHtkva9d7aT+AtlAdQ5D4qLC/3jShs+nIi91sD+p6kQj0QEkR5gTEh3C
         Y08hKJf0tB5B3GEKQRmxhnT/eQ9Unh96e5LdYtZxP50Saggwq3RXyBFl8AJK/X4C793Z
         H2wS+8g59AgMUFtQpe6pqIGd5i8qWLlw0j6kCzvZsh2NeLto4qe0YG/c8mvNDFMGYo+u
         L0r+arQmDEEjyBcOCpjUA9pnWDgOzrEVtEsKUlFgL85vNRnCoy97mJWGsdTK64l4EpEc
         DqNCHAulkem3UQ1EHI37IdeVyOlxCPv8A8AfiiwLrhfZq9WN39+LFazzfBw0aVVovkc+
         iZZg==
X-Gm-Message-State: AOAM533myTpI04+T0d7N+2CX3Va3rRjawKLS9CWakoVX8glmYPzAdKlM
        LUhT3eamqrGx1tssn5VKPTfs0oAZrGGGzg==
X-Google-Smtp-Source: ABdhPJzZjg36d2VEzhDu2rQEoauZrLIeR1dXEU/pjdMQyif4WJ411bCU7uzfVbBfLQjUt4IlFGfphA==
X-Received: by 2002:a19:ca19:: with SMTP id a25mr2162530lfg.89.1607030311209;
        Thu, 03 Dec 2020 13:18:31 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id r8sm911537lff.238.2020.12.03.13.18.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 13:18:30 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id d8so4852151lfa.1
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:18:30 -0800 (PST)
X-Received: by 2002:a19:ed0f:: with SMTP id y15mr1977548lfy.352.1607030309965;
 Thu, 03 Dec 2020 13:18:29 -0800 (PST)
MIME-Version: 1.0
References: <20201203204459.3963776-1-kuba@kernel.org>
In-Reply-To: <20201203204459.3963776-1-kuba@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 3 Dec 2020 13:18:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgBDP8WwpO-yyv0fvdc0w9qoQwugywvwsARp4HMfUkD1g@mail.gmail.com>
Message-ID: <CAHk-=wgBDP8WwpO-yyv0fvdc0w9qoQwugywvwsARp4HMfUkD1g@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 5.10-rc7
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 12:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Networking fixes for 5.10-rc7, including fixes from bpf, netfilter,
> wireless drivers, wireless mesh and can.

Thanks, pulled.

And btw - maybe I've already talked about this, but since next week is
(hopefully) going to be the last week of rc release: since the
networking pulls tend to be some of the bigger ones, one thing I've
asked David to do in the past is to (a) not send a big networking pull
request right before the final release and (b) let me know whether
there is anything worrisome going on in networking.

So if you send it on a Thursday (like this one), then that's all good
- it's the "Oh, it's Sunday noon, I was planning on a final release in
the afternoon, and I have a big networking fix pull request in my
mailbox" that I'd prefer to not see.

A heads up on the "Uhhuh - we have something bad going in the
networking tree" kind of situation you can obviously send at any time.
If there are known issues, I'll just make an rc8 - I prefer not to
_have_ to, of course, but I'd always much rather be safe than release
the final kernel just because I didn't know of some pending issue.

(And the reverse - just a note saying "everything looks fine, none of
this is scary and there's nothing pending that looks at all worrisome
either" - for the last rc pull is obviously also always appreciated,
but generally I'll assume that unless something else is said, we're in
good shape).

            Linus
