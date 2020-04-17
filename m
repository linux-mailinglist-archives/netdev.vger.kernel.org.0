Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3211AD830
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgDQIGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729495AbgDQIGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:06:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC7C061A0C;
        Fri, 17 Apr 2020 01:06:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so859229wmg.1;
        Fri, 17 Apr 2020 01:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=+kuS6BUfuBu5HQsWBXUl7gRKx/aytxpOX/9Vd+bRiDU=;
        b=UhE3qYTId31hQmEicQpRzqVTz/HaCzfv2XHh+zezamt3bMmFiWFfIi9lnKbWmlLsxL
         FVvrx6ojJiGisLq51N1uek+EP7NQbUZBk+AXhj0h5EJOgfk1zAdUJWN2g437P/z8QGU7
         7bSxtaGlWCht3ouQ8krcoVnLUEh6HO9Kzflu96jOZn/vg2BLZfx3dQ8CCrvRs44kfEJ4
         MpQbayGNRQuSvt/fYtDHNFh0CcOC4oTWYTgEoYwRjiJY1g4gQUI1FsuPTLXgF76Uyr4Y
         /bpkdB01JJJ5rhGCXze3B080L6oRQZCtfD5HbQ/IKhQZvXHd0lfgmrRSpzNbFwLa04gT
         QuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=+kuS6BUfuBu5HQsWBXUl7gRKx/aytxpOX/9Vd+bRiDU=;
        b=gfR+gK9N2lw+mITu/SnzJbhxDzoDiusE1rzzLtjwq11BZKcadN8HZx1OY5lfo+4nn5
         +r3yXbBKka7fjc/9sp3CxmDatvFn5nC3rdiuHHwYJgbG3e60OUo5soMph6BNs2QFf2Be
         gp5jkSv6X1np7g6QPamrCzVyaI8NPzUtxoLNuUcyiVe/IJ5juKuS2vno4GI4VALrTB/w
         yHRfukU3qzBlYvRlbKJ3T3QInDeheab/tm1vKtiRIHPl0LSREh8umsHY9XwH8SXajGeX
         FNwBjhQPPVWR4ysW9knwYESbu6cmPFLjY2XQzl9fbMNnVmBKvLmY4aZadw3HOGwiqQbV
         RfXw==
X-Gm-Message-State: AGi0PuZEJcX4PkbDZKhztGrJfGo1TdCROJrEoJ3YXVYhALik15ukO4/h
        QMxfU5suQqmXzfDbz1uc4JAM4QZvqudFfWmTqrg=
X-Google-Smtp-Source: APiQypI2US9O1jjsCOONSDLCRDOJ6V5P1ZOIQ4Y/j+Qbd7NUwkHmokUZzSEMhs1xsBgG22ouN4nGv+P1mws7n9z3HEM=
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr1977493wmi.64.1587110775555;
 Fri, 17 Apr 2020 01:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200417074558.12316-1-sedat.dilek@gmail.com> <87pnc6pmiw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87pnc6pmiw.fsf@kamboji.qca.qualcomm.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 17 Apr 2020 10:06:04 +0200
Message-ID: <CA+icZUUuC5axCJvGm68tCgRmhNA=PG5EZ2ioNfKwiZwfpz-yDQ@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers v3] iwlwifi: actually check allocated
 conf_tlv pointer
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Rorvick <chris@rorvick.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:03 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Sedat Dilek <sedat.dilek@gmail.com> writes:
>
> > From: Chris Rorvick <chris@rorvick.com>
> >
> > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> > check correctly.
> >
> > Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> > Tweeted-by: @grsecurity
> > Message-Id: <20200402050219.4842-1-chris@rorvick.com>
> > Signed-off-by: Chris Rorvick <chris@rorvick.com>
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Thanks, looks good to me. I'll just remove the Message-Id tag, it's not
> really needed in this case.
>

Thanks for all your suggestions and taking care, Kalle.

- Sedat -

> --
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
