Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA99349985
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCYScG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCYSbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:31:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBF8C06174A;
        Thu, 25 Mar 2021 11:31:34 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id o19so3555254edc.3;
        Thu, 25 Mar 2021 11:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiL9j/suNPiqT63LXOFnc8ju7FQs9EVh9TDhZe4Iqpk=;
        b=RL2QPcuSQkyYutZ0Z2BpbrGCf/+8SF8LifMZrVPIkd0/3WtwtAiS+wBwkiOr/675GF
         QgUGfXii13EJWRi6zgL1Oeva3Q0r6MtmoYKCjmZSyw9s5jDV4LLSBD44kiSRCG5W1Le4
         P8I3bjMmDg+v89C0RoZd8NBz/yTM5h8C+Swwe9KYcNCPeKYyR0nUsguUk+1Fr7e1U6Bl
         BD59+RTnMoo+AP/UkXHtiLR7EptD+D/S2VpjPLsXuutTAslDbjLI592OyavRnZilvQO/
         RRIATJjreWrYVtB3xqnkqDZHgBTQ5pQmABA9tNhfZjeZlUNE4ECRCgn8Ti0pG4slm0x0
         H9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiL9j/suNPiqT63LXOFnc8ju7FQs9EVh9TDhZe4Iqpk=;
        b=ZcSwIidTZDI4EGoQEq3nR7Dpfb0PlGtlX5vTtMFdVVmGh785vPOnMXn1FEfsW6D7bD
         Mxbxwk/5NYATbtKyiTg9svlPfNmNALWUPUTeMTK8RJJ496BNIcyvAB6MvLz9Zz/ywsmC
         t2YHkvbn7p7KlOvLBzViZdkmRdcSa7N5X5ijOuQ3mRFYg7G7yR8FUHLX1xTJLwhvcOLw
         MrL7mK5q5Us60+WfIhpfEYM96D/V84SwAGpepJaT8YuEZ+KzYIAOVer1ffOMmVSriBI8
         i2q6SWOoia26Vo/H0p6Nyh61FcjKLWRBizjgMg5hqVAPDW7ksZthMFKeWAJqD8AXFSzE
         2wlA==
X-Gm-Message-State: AOAM531popn9i53GQQgp5kOYRIheMZO9GPPjhRqKzRGW5mUlKQc1KX6/
        rNSjJXVQtbqd5IqB6PG6VuYNLZQemYw+lXZIjrw=
X-Google-Smtp-Source: ABdhPJy4dwOVypqWw1k25ARoLWwqpz0Q7tBFT8mFFf0JVmLOt5xSw/jZpBjfAkWmkPeaxvBt1cF4z2IG5Sz/FyEok5M=
X-Received: by 2002:a05:6402:2ce:: with SMTP id b14mr10578652edx.13.1616697093235;
 Thu, 25 Mar 2021 11:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com> <a5c0e846-c838-83b8-9c85-34b3f53dc54e@gmail.com>
In-Reply-To: <a5c0e846-c838-83b8-9c85-34b3f53dc54e@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 25 Mar 2021 19:31:22 +0100
Message-ID: <CAFBinCBLdMnHtXk1-oTS1fC_r=-JTrbzucTVxBE4iH0Hz_sUVQ@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: Let GSWIP automatically set
 the xMII clock
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Thu, Mar 25, 2021 at 7:09 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
[...]
> > It would be great to have this fix backported to Linux 5.4 and 5.10 to
> > get rid of one more blocker which prevents OpenWrt from switching to
> > this new in-tree driver.
>
> Given there is a Fixes: tag this should land at some point in the stable
> tree auto-selection. Stable fixes for networking patches follows a
> slightly different path:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n145
thank you very much for this link - I missed the news that net patches
should now also be Cc'ed to linux-stable
I think this simplifies the process (at least for me as contributor)

Also thank you for the Reviewed-by!


Best regards,
Martin
