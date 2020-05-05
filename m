Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E42A1C5158
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgEEIwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgEEIwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:52:47 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3536C061A0F;
        Tue,  5 May 2020 01:52:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f8so549489plt.2;
        Tue, 05 May 2020 01:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7cQk7pF/mJajFQaSSU85xF78l0bXJ0d6kMejPz6/Nog=;
        b=R7Hl7zvkRCmGCZo+Y+k1frNvlY6oRuv2JaMzTNmjatcP7VjSq14xXSl1nRa4JFhV6v
         LHlCHYO+FRqPxaJbiwMCM7MSEo6gvHq5U5uoZyIIJ7IFJSnl8cMn/J8vyJpFx0VytWpI
         x4dBnoccrK+GiKtPaXNJJoAuQRh/ipER2xrWcIPjFs38wC02+otbrrUNkhxIXsWcUbCD
         ZdoSQ2Qim1pr4On7Tr+4EUNATph/SBhNx+m9ckhQD3O6Rf/6YzWNNLi2+Ob8rQEqCz9k
         oDZAQIeyIoI+hDgZP4UKD2gDaGgJLhrb9epECl+Vvxt2u6OR4sCDZK3FmXUjmz3xkG0c
         YU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7cQk7pF/mJajFQaSSU85xF78l0bXJ0d6kMejPz6/Nog=;
        b=V8526oEtbfsehzp/1I6dKT8V9Lh/B9IX29z/mfLTNIRq6n0PXw5WvuOrMypjKnRihS
         eXUiZep7sZBjAghOkSE44lYQNbqhvA26nUhx6dGj9/Yp1DUPE9M1QeZLuO1z2Ol5wSwU
         0vMEHFlIhzvzC9jgAYpczFXmxnu5Q6RDgCWGnmTUtoXG+vVYGzopEIs6vY2q0Q09lLt4
         kjfaySX4jAvF+YOmUNEooHV8k1pULgaV8liorcUdOLLVG0DtgVNmSUy7wGyRhyLNXy9L
         a68kz1MZCXVxQhfclWcFESR5xhy/9Ho/a5ctejhYrpYVSYhr4sJFQBJmxXkE7Kr1WU7f
         QdOw==
X-Gm-Message-State: AGi0PuY12YwGDTE4kdsMYUqbgUE9ciFMavbBCGo9pXmHOCD5wF+yfBt1
        2MEim+Nd7rFNydATXXJxDOSGTZ+Dle97ifNb960=
X-Google-Smtp-Source: APiQypJCqrsKIRIAh9oAe9wdDOOmIUIBKEdw1b9bLeV+6sUrVMUdhGgHff/47vnE0T+Z4L8wiYwEGwhhIFW+hS63xbc=
X-Received: by 2002:a17:902:7003:: with SMTP id y3mr2221660plk.18.1588668766464;
 Tue, 05 May 2020 01:52:46 -0700 (PDT)
MIME-Version: 1.0
References: <79591cab-fe3e-0597-3126-c251d41d492b@web.de> <20200504144206.GA5409@nuc8i5>
 <882eacd1-1cbf-6aef-06c5-3ed6d402c0f5@web.de> <CA+ASDXOJ2CSzdgos4Y8Wd7iZjRUkrMN=Ma0_-ujG8bihGzPKkQ@mail.gmail.com>
 <20200505005908.GA8464@nuc8i5>
In-Reply-To: <20200505005908.GA8464@nuc8i5>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 5 May 2020 11:52:34 +0300
Message-ID: <CAHp75Ve43za_hAQbECPTFS0eEqSeYJtq3bvojmed=-6g=3DhvA@mail.gmail.com>
Subject: Re: [PATCH] net: rtw88: fix an issue about leak system resources
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
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

On Tue, May 5, 2020 at 3:59 AM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> On Mon, May 04, 2020 at 10:03:59AM -0700, Brian Norris wrote:
> > (Markus is clearly not taking the hint, but FYI for everyone else:)

> Brian, Thanks very much for your reminder, These comments have always
> bothered me. Now I can put it on my blacklist. Thank you very very much!

Perhaps we need to find a good researcher student who may do a MD
dissertation out of the case :-)

-- 
With Best Regards,
Andy Shevchenko
