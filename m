Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62819188DD
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfEILYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:24:22 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41477 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfEILYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 07:24:21 -0400
Received: by mail-qk1-f195.google.com with SMTP id g190so1170864qkf.8
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 04:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCnlS/Os4iGWNFisP3kaeJDg2CdWLlxOhgRwG4awIx4=;
        b=KBD05kY1U/p8AkeRQqKt9DacXyP8UQYpamDfplN6tJcVhL/BskcqjpJI9Nopif++ln
         bp1FlfXIu8sfMMqXBcXLve4fnRhSRUjJw/wPFLvYitGGT1+TRgYKozqzpubNShKAbV5P
         9zIQes4kTP21dtL/wRF0nXGdfu5gTNqTuJKJs2UAz9QDlakBRfufoA1CAGd3JuwOpsiq
         s2kn+hhcPuBieVnK+qRtC+5klBsrzieeJ+fqVhPKTL16hVVMQ2b6oIEDnALx0rwClPPz
         J3TO+t9Jswjux3vYA0ITXSMbulWyT2Ba8FLklcVDli1sSV6a9Y8IyoRGs6AYClviOoo2
         ffTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCnlS/Os4iGWNFisP3kaeJDg2CdWLlxOhgRwG4awIx4=;
        b=N9lim+cDSJTg+nPIkI2+HRxNu3m4nljheq6dwJ/TZ6WrVnvGZMEGsgTnD7T/fWukNJ
         L/v4ir+DrDc1CmB5H7oEbLiAuTNkYM4O3kwGO+ok65xWY4TjI6aeXl5Kv/W5jKBN9z8s
         1pn566HoPEqyvVbIc5LWbkRAAQPslZqw99Pfm7uRjbuwkEveaM7AnM5XFz3SZ5whbG5X
         v26CGpWfmTfFfCb6JWpt0ny7gue74aRtoab5zDmWMQK51xRhN4aIcvdqz3rp7YZm83vV
         3QMKgCWqO23oGHRb4v1aITPRumXJNzGL+U0ZUB5bUAyx1LeEKzxjmDhGA/VtnaCwE2T8
         PNww==
X-Gm-Message-State: APjAAAWqNileTVMkKpZ49zdxu+hvy7o5loaz1fWj0h3VLAduXUYfsM9Z
        Sqz2jaUrshOmQPDZo7vLl9EKvNS5R/gw+64OmCSUjbSw
X-Google-Smtp-Source: APXvYqzwIaznoFAT/zWqbH4CeaZXP5SqI/lPwmVbnP/H/Hxa5P/Zsau6AOS0KHx/uOaaP009y/M2WPeFkeEbu4pxRZo=
X-Received: by 2002:a37:f50c:: with SMTP id l12mr2768120qkk.175.1557401060787;
 Thu, 09 May 2019 04:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190503072146.49999-1-chiu@endlessm.com> <20190503072146.49999-3-chiu@endlessm.com>
 <CAD8Lp47_-6d2wCAs5QbuR6Mw2w91TyJ9W3kFiJHH4F_6dXqnHg@mail.gmail.com> <CAB4CAweQXz=wQGA5t7BwWYdwbRrHCji+BWc0G52SUcZFGc8Pnw@mail.gmail.com>
In-Reply-To: <CAB4CAweQXz=wQGA5t7BwWYdwbRrHCji+BWc0G52SUcZFGc8Pnw@mail.gmail.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Thu, 9 May 2019 19:24:09 +0800
Message-ID: <CAD8Lp46hcx0ZHFMUdXdR6unbeMQJsfyuEQ7hUFpHY2jU9R7Gcw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] rtl8xxxu: Add watchdog to update rate mask by
 signal strength
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 5:17 PM Chris Chiu <chiu@endlessm.com> wrote:
> I need the vif because there's seems no easy way to get RSSI. Please
> suggest if there's any better idea for this. I believe multiple vifs is for AP
> mode (with more than 1 virtual AP/SSIDs) and the Station+AP coexist
> mode. But the rtl8xxxu driver basically supports only Station mode.

Yes, the driver only lets you create station interfaces, but it lets
you create several of them.
I'm not sure if that is intentional (and meaningful), or if its a bug.
Maybe you can experiment with multiple station interfaces and see if
it works in a meaningful way?

Daniel
