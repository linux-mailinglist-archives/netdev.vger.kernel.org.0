Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD41C40BC
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgEDRES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729938AbgEDREQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:04:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56119C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:04:16 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so10420732ljn.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ylw/rVQ5uqDbHMoBEoqRYKRrSFsR0xjBGTCKci2YdMA=;
        b=XEYCKlpcxCa4Yj1hBe1EPO8dgoDM2lJYKR9mj/CVqv5dDTLl+4T8bazaW1eLrSHqCj
         TourY/FU0op5zaB6vPTBwaemfEu/JcWi7QaTZa5Ay6rctmHyqAQv06t6XNI0saMrXiG/
         Fj8XwttesOC1EtU7rbpbTUZbRpZTDorDCE2og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylw/rVQ5uqDbHMoBEoqRYKRrSFsR0xjBGTCKci2YdMA=;
        b=PN1ko1RMjDdC2oW4f46oHSObDDDQ7B9A8L7HWqro3R1oOKtoOZs02XxqvjZC8+8BQB
         bqiuGTguvEyI66zOor7F39H7zuEUs+ZowOYiNxQff2IPc1hp+Ma0/3wc1bE2lT2Ut2cr
         2UmDVEKa3p3gLGGLi2oMyK+GlFJ973dZ57XpKL/Pjmu0jqRkhETgs1PpyvtVD/+qgnaz
         ast2nRG6jpyZCM1wrBYgh4ZWKnzEEdH+bELN76+y2EGKJTMxcU6z3n4l7wHtfButYBGp
         fkBXFbTzCYrXyp0/uIdA+vcwPZ7fRRsBPSpV15+2Ei7h3YlrdpSTKCijSjv85rqQFvaA
         jaAg==
X-Gm-Message-State: AGi0PubyTZRJWUcd51NJxw1xR4MOTJBOkcw9ExirDVd1oyXXsLi5ek/l
        XmUuwlPNgSLZEU7UmmhIH12Ag7wpnp8=
X-Google-Smtp-Source: APiQypJdPJsLU1h7vG0VBsFCGecOfCiLw+r1MagDzMlxpDlbZuIaBtIpDJ5Uco0XntD7G9u+66tfCg==
X-Received: by 2002:a2e:8753:: with SMTP id q19mr11148942ljj.6.1588611854527;
        Mon, 04 May 2020 10:04:14 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id o23sm11187487ljh.63.2020.05.04.10.04.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:04:13 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id w20so10480447ljj.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:04:11 -0700 (PDT)
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr10921197ljp.186.1588611851101;
 Mon, 04 May 2020 10:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de> <20200504144206.GA5409@nuc8i5>
 <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
In-Reply-To: <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 4 May 2020 10:03:59 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
Message-ID: <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
Subject: Re: [PATCH] net: rtw88: fix an issue about leak system resources
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Markus Elfring <Markus.Elfring@web.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Markus is clearly not taking the hint, but FYI for everyone else:)

On Mon, May 4, 2020 at 8:00 AM Markus Elfring <Markus.Elfring@web.de> wrote:
> > BTW, In the past week, you asked me to change the commit comments in my
> > 6 patches like this one. Let me return to the essence of patch, point
> > out the code problems and better solutions will be more popular.
>
> I would appreciate if various update suggestions would become nicer somehow.

Markus is not really providing any value to the community. Just search
for his recent mail history -- it's all silly commit message
nitpicking of little value. He's been blacklisted by a number of
people already:

https://lkml.kernel.org/lkml/20190919112937.GA3072241@kroah.com/

Some people continue to humor him, but it's mostly just a waste of
their time, as this has been going on for years. Just look at searches
like this, and tell me whether they produce anything useful:

https://lkml.kernel.org/lkml/?q=%22markus+elfring%22&o=5000

Brian
