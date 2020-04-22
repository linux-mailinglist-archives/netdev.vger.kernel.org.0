Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5B1B35A6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgDVDl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726294AbgDVDl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:41:28 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5635C0610D6;
        Tue, 21 Apr 2020 20:41:26 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id k28so433491lfe.10;
        Tue, 21 Apr 2020 20:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+aIQ7CAWOBcU4ts0/fedMSy1OdIZkB+G+ss8GRXa6l8=;
        b=quZ3GSH+esBmeLJV8D7JiyC3UPdJ0/5yQxctsMpeaF/D8vgU4N2v3gHtHOedzCBT2z
         tZlfa3q1E+t33luzTRHSk5REzYwU0E45OkQ1hZ/vnO/FwhMVSRQDdY3QXFrTvu1wziYR
         DuEYDWxbh2sCeBK38DN8lztLAUw3iaMHi/PdBKjIBqa4cZzcX/TI2x5BGdIVFe1qtogI
         ZcU9zamOpuKRc5GFGguB+e92b/wywvu6kko8ennoddy4QYDlnUPC1iaybqEg9MwDFhHe
         +yhoo0yXbZbAl66aDlOfWtJfp16Y9UxUMvyIeTMDrd8czfK8Se6t5bEjM7pQBXTuXIam
         pWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+aIQ7CAWOBcU4ts0/fedMSy1OdIZkB+G+ss8GRXa6l8=;
        b=C/b0F9KKrOc5njzYTtaIOSGpTGVRFUcqetucHtPEkjR1m5MOBIyFS6cNH8sFfG4Y+e
         +5+qRnGuZqxoWcvZ5Wftu4C83UnpH0h43ApaG36Mq4ol6bs1C4DqF1J1CWnCUJdzCKoF
         D+NqRxKcoG7GQdLkwbV9OoEQdp0l6lSZ7l0SkEDAaE5LOVnZIzYmCV55rilEMfQV7D+D
         1xTGzvA47qcxuBdy/Lc3AGTqOcvBwpwm49jSyIGX2HaQyeAvvzrQvKPO8EcLyZhrqY+I
         wgJ6QViC2xzD825YohRlvOfn5uWaEq0WdjjAjSOLhpFF1dKfdZyFDNrniFwKPtGQk4Wb
         VWLQ==
X-Gm-Message-State: AGi0PuaChg1+gL3lAaKDmuJNjKwSGSLE1bguu881WxUDUAIMNy4tRun2
        m9acQDXYCMLcomFafEs0ah2UYs+G2KWMsX2HVkE=
X-Google-Smtp-Source: APiQypI6wnLRl5s6t4tdi3/cwsUKlabwjgDKHYpmJWgDL18pOtOH9PlAvqqm5FalEfxT3wk0dwtXpypKwHapAbghghg=
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr15774262lfi.204.1587526885412;
 Tue, 21 Apr 2020 20:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com> <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
 <CABa6K_HWsy9DdjsKXE2d_JrC+OsNuW+OALS+-_HiV3r2XgC1bw@mail.gmail.com>
In-Reply-To: <CABa6K_HWsy9DdjsKXE2d_JrC+OsNuW+OALS+-_HiV3r2XgC1bw@mail.gmail.com>
From:   Changli Gao <xiaosuo@gmail.com>
Date:   Wed, 22 Apr 2020 11:41:14 +0800
Message-ID: <CABa6K_Ev9d8wsb6HRCRPceOF7grDDjm41cV_CTjOiMHwoNsjTw@mail.gmail.com>
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:38 AM Changli Gao <xiaosuo@gmail.com> wrote:
> At the same time, we'd better extend other syscalls, which set the
> FD_CLOEXEC when  creating FDs. i.e. open, pipe3...
>

Ignore me, I missed the latter patches.



-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
