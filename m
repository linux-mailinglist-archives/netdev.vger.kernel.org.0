Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667EB2A4383
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgKCKy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgKCKyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:54:25 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88F3C0613D1;
        Tue,  3 Nov 2020 02:54:25 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y14so13837800pfp.13;
        Tue, 03 Nov 2020 02:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pr70uaXWQ5V9OEnpZUw1+PkE5bFME26YS/kMKBh3/j4=;
        b=Z1nxH0jDHYEqq8hm0bVNqvQCGIZiEpIpb3zSwcYXQieBLtra1nCwDJgpu5pP89uJzE
         AkhrBgNlD6HCyN456iYZGK8zXMn2VqjNio/0ngfT65e6vFKeH9P/k+YNx0fz0NX90SQM
         JId+N9RTHwMw0LwsVjrJ0K/iWTlm+/5RRX+O/Qjs6Unhw7bP80fuwGuRg+eAD4HDASkn
         xBbZ2MPC8C7aomhpP8xQDtCO64OoJw54a0Ax1nTLubP8Yh2DLws0e+6UO7/9eRpRrt3U
         p4wJZFBQok7bOE/bbaJc+Lng79kYbok1iizF3WW9gFugdQUddODfxMzleDA0d88pCHQj
         0aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pr70uaXWQ5V9OEnpZUw1+PkE5bFME26YS/kMKBh3/j4=;
        b=KhYowi0p4JPdFuQDL4U9C4tbhOF93OAKZnlct2EApYZEkm/24aWOSHYQST80UYw9Yr
         Hz01mQ38VeKsuixq6djqtVEoXAlbimS/G/zPd50fUq7s0C/pxudSwE3FQOzVzJo8CnfV
         iy61KrGMAsAafRBFNq6k1+rqPSr6r7WIyenCwsw1XDuuVJqijnJEsH9jdb2PStpPicKK
         uDTrXLeVkXzIiTOIByj7cSE+E9UGQItmNd1Z4BbFgAdJqpTIPeAhCzELhISZiLioM3Sf
         jSSm7nk0JPTdIbz9lMiiKM3jZovJY6MKPKF3jsnV4fayJzJsC7/+iAij1IPup5UdBJ4p
         tsJw==
X-Gm-Message-State: AOAM531idUhQ0JUOmkBoRSoMwZZ/WLb3JPWwg3u/SYLz0VIGF8kiZbut
        p/DvF7A2AeJcQI+yQoEGswWkx0SmSbiCDSRpoCE=
X-Google-Smtp-Source: ABdhPJzFEjyEEdc+kSmf/T1nHeNhjOJHPnuC+7t9Znx2RJFmaAHHYOf4fCTxwiGuX4v/1cJJtqmJw1ySNSiuUS5bxLE=
X-Received: by 2002:a17:90a:430b:: with SMTP id q11mr3222009pjg.129.1604400865170;
 Tue, 03 Nov 2020 02:54:25 -0800 (PST)
MIME-Version: 1.0
References: <20201102152037.963-1-brgl@bgdev.pl> <21d80265fccfcb5d76851c84d1c2d88e0421ab85.camel@perches.com>
 <CAMRc=Me4-4Cmoq3UdpYEEhERP6fvt97bEJsZYhrcFSQf+a_voA@mail.gmail.com>
In-Reply-To: <CAMRc=Me4-4Cmoq3UdpYEEhERP6fvt97bEJsZYhrcFSQf+a_voA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 3 Nov 2020 12:55:14 +0200
Message-ID: <CAHp75VdpriwuktGrMpcXXQuHgfDL6SzqmQTsGFNKLBb=QiKuGg@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] slab: provide and use krealloc_array()
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Joe Perches <joe@perches.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 12:13 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> On Tue, Nov 3, 2020 at 5:14 AM Joe Perches <joe@perches.com> wrote:
> > On Mon, 2020-11-02 at 16:20 +0100, Bartosz Golaszewski wrote:
> > > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

> Yeah so I had this concern for devm_krealloc() and even sent a patch
> that extended it to honor __GFP_ZERO before I noticed that regular
> krealloc() silently ignores __GFP_ZERO. I'm not sure if this is on
> purpose. Maybe we should either make krealloc() honor __GFP_ZERO or
> explicitly state in its documentation that it ignores it?

And my voice here is to ignore for the same reasons: respect
realloc(3) and making common sense with the idea of REallocating
(capital letters on purpose).

-- 
With Best Regards,
Andy Shevchenko
