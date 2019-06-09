Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821A03AC72
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 00:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbfFIWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 18:33:04 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35954 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfFIWdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 18:33:04 -0400
Received: by mail-oi1-f194.google.com with SMTP id w7so4969115oic.3;
        Sun, 09 Jun 2019 15:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQ6OXqNlqQEo6o5SfdnUHG+Qbo6dDyANNmGJ9zTJBy4=;
        b=XTxQbKpLzQ9x7Lmv1HiWlTTLcazVga8prIV+POououfauSrpy2rz1T/twEaGYpD6IJ
         34PV1g5fl4LsumDhAJRAnA2WYCrABePeD/FfLnaSJoHK3zqoo1ySkA7okZeef5a+JFb4
         1Q56ts203Vbq9hlkOLxfCQOm3K+smc1hNcHZh6JZAXFLB8KbmTTOI7F0Ob/T4DU3ISPZ
         B90RQHVmo1KmOuE8scNqc+o3bXLrqX0+KuzDV4zbTFyPUQdlE/oH6zNrkH5RfsZSovnM
         SKpAIYSU1/+GJzc07PM3JO7M5dIeXpnXTmy2OAi7AclW8DTb/cutOg2vqgUYQMS8z21y
         lefw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQ6OXqNlqQEo6o5SfdnUHG+Qbo6dDyANNmGJ9zTJBy4=;
        b=caLUdPt+4OuEZtd8PGoCLQf0V/2MxQMCoZclKAfPBzRMwoVfBCtZ5hTcdpbLQ4HwJ+
         Y5cDYmEtyZLSKaoXN+fvdSgvt28N8/hcGvItJCU06A4XDz9lLi5jzW9sXl8tHxiRk2DK
         XE4YXYPWR25TpQh8dV6nElyV4WXH98xk72eIZmrK+La2qstgtbdi0rFIiQ6fBJ+ja0hW
         Zicx6fElwVLHkInhHkbQ3Y7jtbygeL+FYuv6Cvc/6bn3tUXSqNKAoHKAm1lwWsBx9Zuy
         9OZs48EPaPiwogDIwQQvvdfa6L7On2tHiE2yynxeDa/pOr51YppfrUCa66xhFS95pEkX
         XqcQ==
X-Gm-Message-State: APjAAAWiJWMbGWTm7BcP8bg7gT+2JGBPVAwoE+xjwYAogw6dqNnCUl6B
        WaMXn/GImNxeMvqf+WdMHKY2jYS39PDmQ+robSQ=
X-Google-Smtp-Source: APXvYqyXfo8/VGaQnyvN3uUtUHo2ZPZdhQIigQnxCO0sgva0FRuMUYSkKUNsX1joxCo2ygNdPLmPelw9KQW+AJnJEQc=
X-Received: by 2002:aca:51cf:: with SMTP id f198mr8511263oib.140.1560119583220;
 Sun, 09 Jun 2019 15:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com> <20190609204510.GB8247@lunn.ch>
In-Reply-To: <20190609204510.GB8247@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 10 Jun 2019 00:32:52 +0200
Message-ID: <CAFBinCB3SLoVOt_jy6-OW=2=5671o+bXQwMn006u56gHLTOpBw@mail.gmail.com>
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset GPIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Jun 9, 2019 at 10:45 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> > "Always leave the campground cleaner than you found it."
>
> > I
> > am also looking for suggestions how to handle these cross-tree changes
> > (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> > go through the net-next tree. I will re-send patch #5 separately as
> > this should go through Kevin's linux-amlogic tree).
>
> Hi Martin
>
> Patches 1 and 4 don't seem to have and dependencies. So i would
> suggest splitting them out and submitting them to netdev for merging
> independent of the rest.
OK, I will do that but after the GPIO changes are applied because only
then I can get rid of that "np" variable

> Linus can probably create a stable branch with the GPIO changes, which
> David can pull into net-next, and then apply the stmmac changes on
> top.
let's go this way since Linus is happy with that route also.
I'll re-spin v2 tomorrow


Martin
