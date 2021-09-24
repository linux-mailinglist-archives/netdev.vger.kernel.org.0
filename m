Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A42416FDE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 12:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbhIXKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 06:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245408AbhIXKEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 06:04:39 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B50C061574;
        Fri, 24 Sep 2021 03:03:06 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id f133so4595038yba.11;
        Fri, 24 Sep 2021 03:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVejgvgIUbivqyF/zB9MH9U5S0LClVfNnIpvUNItikM=;
        b=pwOwbiLfIOsD1XcZjiRAJrF33ma579B98sVu1DU2oquPgI92sJVZWWLbqaV28FzjaB
         dcjmbeze6xncXnmOrNxCyAj3IyFdLg/ZjsIPNIz8ccMvPeqQFTSzUoe19txujG6gbQQa
         Du+pGkoNj1I2q5+w0+hpZQ1mOSELvm6XLHLa8x8U3pgfS0v3YUyZfpGiD7zum4xsXzUS
         /94rJdeSBxkwtwrrDoSjgIYBAA+BiqvrgppICl+iNuGspqiZHwkTkyRd7hRF/weRQLQN
         ZJpR5a9qLD7CwaLrnlEo6C3qKWA1jFGWuMe2q6kgnzBMXrlrbN73Eyqp43/diKS10aLr
         BA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVejgvgIUbivqyF/zB9MH9U5S0LClVfNnIpvUNItikM=;
        b=tBMemGmLrwPIFobHntwD9ApxcVtySSeraeZ/tH7FwAS49A/RJ49dysEDL7qlL33gAP
         aJmnc6L3yYUNgamc7DCG8bPoZvsQOWwCwOl+JijXTuCFQD57m5ZlzTwZzFj29+CRqf+r
         SVfHEuul+Pa7lAJ3QFDtsa1aj423cFQU3gq81+HRhWloZuDRdcVYyCnEfAhqDwfKohIT
         kVr2aEUfHlKeNxMc5kYi1WnJ2hxY7rkSWqraOnQO//U4IenP2zJGNtRTxe9HWPio6gIc
         zTLVEaTOY+oPVjb6+yNMEFfe++QIRR6C865EX4/Ms1Q6MFFLBSCJpv3b0dNBwjVRQo2n
         V3hA==
X-Gm-Message-State: AOAM531VCnEglTF6IOI4F2f5+VrHoNIBeA68gcRRFhYAginRTB1gPAKe
        1yiKULRBWAegI032+g8Kmnp1iSVKSpv0yXHIioG3H4g+Yh57rw==
X-Google-Smtp-Source: ABdhPJx7+assTM0fM2QmlRjFZOu+MuBmwOysciOarH0pW/5VTVCe6BBumlJ8phLGSftAI7jMOHMKUZ9yZXMo2yWN+ZM=
X-Received: by 2002:a25:3086:: with SMTP id w128mr12171475ybw.139.1632477784123;
 Fri, 24 Sep 2021 03:03:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAFcO6XOvGQrRTaTkaJ0p3zR7y7nrAWD79r48=L_BbOyrK9X-vA@mail.gmail.com>
 <CAK8P3a0kG_gdpaOoLb5H2qeq-T7orQ+2n19NNWQaRKgVNotDkw@mail.gmail.com>
In-Reply-To: <CAK8P3a0kG_gdpaOoLb5H2qeq-T7orQ+2n19NNWQaRKgVNotDkw@mail.gmail.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 24 Sep 2021 18:02:53 +0800
Message-ID: <CAFcO6XOgtizsTQbeWcD14yiMAaRp82QomNhSehCJ4t=d2CRx+g@mail.gmail.com>
Subject: Re: There is an array-index-out-bounds bug in detach_capi_ctr in drivers/isdn/capi/kcapi.c
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When I last touched the capi code, I tried to remove it all, but we then
> left it in the kernel because the bluetooth cmtp code can still theoretically
> use it.
>
> May I ask how you managed to run into this? Did you find the bug through
> inspection first and then produce it using cmtp, or did you actually use
> cmtp?

I fuzz the bluez system and find a crash to analyze it and reproduce it.

> If the only purpose of cmtp is now to be a target for exploits, then I
> would suggest we consider removing both cmtp and capi for
> good after backporting your fix to stable kernels. Obviously
> if it turns out that someone actually uses cmtp and/or capi, we
> should not remove it.
>
Yes, I think this should be feasible.

Regards
  butt3rflyh4ck.


-- 
Active Defense Lab of Venustech
