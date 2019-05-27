Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B69C2AECF
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfE0Giw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:38:52 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40776 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfE0Giv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:38:51 -0400
Received: by mail-qk1-f196.google.com with SMTP id c70so2115999qkg.7
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHxpS8GHNFczohBNmU/4hGO+nucs8Ap0lRCjYNwMm+U=;
        b=Z3+ujjmXN4PtI+z7DMZcCXWOgT9fcIZii2m6C0wngPB6ltt55kx7UFgpm7+ldQrDdb
         M9HmuXhYGolCOseNPBd7ucxDAawtYlZBROSShy6h8NougfZbYckdRpBmYVJikkNi923L
         Smw/6I1tZquqKSkMC+GlaX/KudPYUh5KQEz/iNSNqjqzZuSG90izIFke6A38g4dj7F0b
         0dZXj7k8AypGiyssOh4MtMsjYYcsKqdryGoMoqJMFP/l9wb9Bhy4yqM3LhnI/YHx29OA
         RIbQ3C7biSTc9TSPG2buxIE1BI0vC2Dz1yapS9vuzSJssE1e/f0hNVWOwMJ9Potc0teC
         fq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHxpS8GHNFczohBNmU/4hGO+nucs8Ap0lRCjYNwMm+U=;
        b=JVf+fNuuzgpqLDQuD4LMgltA5qOvenvU6wMTkPaNBgFOCk26/8zjuWWA9p3LktQ04W
         w1qI89RRrlXUVFozE80jLBcvkNBTLd6jEIzDpslnwb27zp2r0RBnj0PG2siK5OoaJX6S
         GVIZYcj9qSC9BVWLiAZ8KgJJytqgBqFFGcOZ0lGpXcPKvUTyApOsEjAqSyI7NzxlBUQB
         c9j2NAbbjpWIDFjatUUxOR8UQ1ofM1rqAQTrAWuTnnE33IVjICvAIJPzwZ4g7W0lnmjG
         hZMcaLkAg7b+uAeTF5cAE8c/Uk5oxGIYvGuYNZaWcFqZT/LsLrEVh2pYG0emqSx0MohR
         dYhQ==
X-Gm-Message-State: APjAAAXdAnEqXP23SrB1I3kzFk9491buHQJY0OyGnVAKvZEGqPC+2Mmv
        n3bGbOfQuEjB8JfVKJatqIRN9tXznNrQ546JUOu9gQ==
X-Google-Smtp-Source: APXvYqwXmCCSkefGNRFAEBLGtLWO8/FD3BjQ6UIoj//q1bJvMH9lNtKnGCPeUFP7BXWy7Q9aAj3RnvVKFLZBU3RFjug=
X-Received: by 2002:a05:620a:1ee:: with SMTP id x14mr650094qkn.70.1558939130658;
 Sun, 26 May 2019 23:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190503072146.49999-1-chiu@endlessm.com> <20190503072146.49999-3-chiu@endlessm.com>
 <CAD8Lp47_-6d2wCAs5QbuR6Mw2w91TyJ9W3kFiJHH4F_6dXqnHg@mail.gmail.com>
 <CAB4CAweQXz=wQGA5t7BwWYdwbRrHCji+BWc0G52SUcZFGc8Pnw@mail.gmail.com>
 <CAD8Lp46hcx0ZHFMUdXdR6unbeMQJsfyuEQ7hUFpHY2jU9R7Gcw@mail.gmail.com>
 <CAB4CAwf26pdCY7FJA5H7d1aEY2xpjSto4JxARwczmVJ==41yng@mail.gmail.com> <CAD8Lp47K0Jn2wotANdQV3kT9yPP7bLnVd0eYhWui-vNDOEXBTA@mail.gmail.com>
In-Reply-To: <CAD8Lp47K0Jn2wotANdQV3kT9yPP7bLnVd0eYhWui-vNDOEXBTA@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Mon, 27 May 2019 14:38:38 +0800
Message-ID: <CAB4CAwf7O9tyUwc+gPSZrBES+Bt7iTjhE1fbbVxYKqzjtmZBxw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] rtl8xxxu: Add watchdog to update rate mask by
 signal strength
To:     Daniel Drake <drake@endlessm.com>
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

On Wed, May 22, 2019 at 2:38 AM Daniel Drake <drake@endlessm.com> wrote:
>
> On Fri, May 10, 2019 at 2:37 AM Chris Chiu <chiu@endlessm.com> wrote:
> > I've verified that multiple virtual interface can not work simultaneously in
> > STA mode. I assigned different mac address for different vifs, I can only
> > bring only one interface up. If I want to bring the second vif up, it always
> > complains "SIOCSIFFLAGS: Device or resource busy".
>
> Interesting. Can you go deeper into that so that we can be more
> confident of this limitation?
>
> ieee80211_open() is the starting point.
> ieee80211_check_concurrent_iface() is one candidate to generate -EBUSY
> but from inspection, I don't think that's happening in this case,
> perhaps you can keep following through in order to figure out which
> part of the code is not allowing the 2nd STA interface to come up.
>
> Daniel

The -EBUSY is returned by the ieee80211_check_combinations() in the
ieee80211_check_concurrent_iface() function which is invoked each time
doing ieee80211_open().
The ieee80211_check_combinations() returns the -EBUSY because of
cfg80211_check_combinations() will iterate all interfaces of different types
then checks the combination is valid or not, which in this case the number
of interface combination accumulated by cfg80211_iter_sum_ifcombos is 0
when I'm trying to bring up the second station interface.

Chris
