Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFB43D0A8F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbhGUHli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 03:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbhGUHg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:36:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7EBC061574;
        Wed, 21 Jul 2021 01:17:29 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t2so1281242edd.13;
        Wed, 21 Jul 2021 01:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZgcPfQLiN9iP9K4OpawNyYKs238DZ60Ej7j3i33PTA=;
        b=OWIZZmB+kIm0L5SFnNjmFXOtx+bO53YvZhJcG7R70xFGex0eMBAMLdTJXlS+t0r/nh
         Q+g3yCP4m7Y2dULwwJGcmVHLmR/7LlaPJeBkAlSa86z+O7dVdcoi4qDbDucCvrpXvJHZ
         wFD2jjuMGM7Aozet9MGX01lm6zre/oAwv7EUzSKbT6MFqzJuOpJN/1pZehO2PZ0Jh8CP
         39SHRKcjd72t4ErLKDTz8JEhfdEQoqpZLFYQV9jJJHmRfG6e/KOyHnc0lEUqi1Bab/eY
         3lFD5vEu2EgZzeEWUuscyE7cKWrmCAXIGkwXlSiKL+O47B2g3e7KjacfZ51kPe9Dhojc
         0fTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZgcPfQLiN9iP9K4OpawNyYKs238DZ60Ej7j3i33PTA=;
        b=QsUzu2FiRT4ODH+TkO4Ac/pnW6EfOHAa+1kAueTLOIAONo55ObMSF32YMtXHABaopD
         GumP2ReL2ZZ2I55BKLc3Ejj6ngLrfXEit/5hS4Tdb2VEuj38tQz0FAoCRVnD/h1ztRLy
         HMWe85njxWBhn6HjBURjiJhvHOJVJ2e0jhHK3NfXIVzgbRbQTmArRSWC8g3vB+tM1GbH
         svoSwo7NhgJ+OfaUk5fpABpLmjFNuRzeM+fCki/p6M3yj9KpSZBYK9BisqPp/kq/4ZDv
         LSc8HHRWBjs5BQgpeQ4B35NB9SSAyU7Yv13Y15xDpmYjQCir/WLpPoOmlmmTjnIlevYi
         3Jew==
X-Gm-Message-State: AOAM531Ehn8f0xtF6hXcCOwpBrVD6WzWpMO24SlnQDP8dwVAE4ktSmZc
        HjcdwukX5gTj/y64TyIsPu3Ho1OFQkoyfbG77Fc=
X-Google-Smtp-Source: ABdhPJxpJM6V8VTne3Bjivlmwlbhl1eoSQv2ktowYhYbL60h/j9SjuBb6rO4vAECr8gosa4TYfYCq7cynOjY+rhJCRA=
X-Received: by 2002:a05:6402:270d:: with SMTP id y13mr46970258edd.66.1626855448078;
 Wed, 21 Jul 2021 01:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210714091327.677458-1-mudongliangabcd@gmail.com> <YPfOZp7YoagbE+Mh@kroah.com>
In-Reply-To: <YPfOZp7YoagbE+Mh@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 21 Jul 2021 16:17:01 +0800
Message-ID: <CAD-N9QVi=TvS6sM+jcOf=Y5esECtRgTMgdFW+dqB-R_BuNv6AQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] usb: hso: fix error handling code of hso_create_net_device
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>, linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 3:36 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 14, 2021 at 05:13:22PM +0800, Dongliang Mu wrote:
> > The current error handling code of hso_create_net_device is
> > hso_free_net_device, no matter which errors lead to. For example,
> > WARNING in hso_free_net_device [1].
> >
> > Fix this by refactoring the error handling code of
> > hso_create_net_device by handling different errors by different code.
> >
> > [1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe
> >
> > Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
> > Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> > v1->v2: change labels according to the comment of Dan Carpenter
> > v2->v3: change the style of error handling labels
> >  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
>
> Please resend the whole series, not just one patch of the series.
> Otherwise it makes it impossible to determine what patch from what
> series should be applied in what order.
>

Done. Please review the resend v3 patches.

> All of these are now dropped from my queue, please fix up and resend.
>
> thanks,
>
> greg k-h
