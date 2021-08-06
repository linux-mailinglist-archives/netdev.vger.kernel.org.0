Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D923E305F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 22:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhHFUfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 16:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhHFUfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 16:35:03 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53498C0613CF;
        Fri,  6 Aug 2021 13:34:46 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id f33-20020a4a89240000b029027c19426fbeso2537708ooi.8;
        Fri, 06 Aug 2021 13:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PdU525+p8u4WlJJnfxi3e93iSDWBs8v/I5isoPxGs/g=;
        b=mLJJiYq6nWsCgdDuZsSmSx6HgFgexd5N+2N0Xp6qwwBlCq8y9/0mSHKm1Bf4JRQJ0A
         f307s7C3tP8oVIc73N32y6V/YL0K9ebmUWBueaqpRpogl+yoZ/089xsTIyBl2+wleKmk
         aZ3+oPPEOCBQ6HdXxRZFSoPUNb+vb5lYK5s84lQBEwg6XR5fo1DcpLXd/yXiXZUi19wt
         mc7hDTV1To1tGpp0lxpQd+RaNxuUvpIGdpxxj/9o0b9SvpIvtrdbADjyikuNhs9fUaHQ
         gn8Lpe9oWoTQfxlYOKfJjUf8MG2Bwj5EzfH6xK/PnH7v3V8SS3uebEUmOv3TRxkwLRpj
         z5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PdU525+p8u4WlJJnfxi3e93iSDWBs8v/I5isoPxGs/g=;
        b=OfcmecTKI0La4RhGYvbi8s3nXuWiCl/GMh7TRi/C234QQrAfuoNgsu85q5FkjK8oOu
         HQZ2ShH+L4hczsir2YE5hb1yoqdduoWsMsD9bcRPEphzvzrWz33kLxgPCfHxJ8vUQIjm
         zrSOY59pmiDSd4u9hFxRDWMCvj8Z31Si0zpf2b1inlEnUcUbQ9S9Xm3WTKe0C9nP/3+z
         g7WC3H8JWdeq5QDPffFV97bVO/M/qBI+WTbHW75otOCVKxQw56Xb6yUjJbDytB0K22qt
         fgvqWayHlzG08XSKj6iTuZYvo8pu8UWXydtR57f/hqHG65P+oFfDA2hfzyykbOs9KKSW
         wtdg==
X-Gm-Message-State: AOAM532y988zU6ob/BUO8tyrbaknrCOm5Ms5xxmMdUMga7W1TyHSlOZ3
        bifbdc6G0nUW3X4eGU2haoME2LuhzCIkMDHMFh4=
X-Google-Smtp-Source: ABdhPJy9BJ9xeLMVu/ecPOM5rYB2iEef65Xt9WnL3i2JVuWOL/6P+VLREXcpDr8hFn3Z5fwAclheUhg0jb9RbgPye/o=
X-Received: by 2002:a4a:cf07:: with SMTP id l7mr7893206oos.11.1628282085678;
 Fri, 06 Aug 2021 13:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
 <20210806085413.61536-2-andriy.shevchenko@linux.intel.com>
 <CAHNKnsTPQp16FPuVxY+FtJVOXnSga7zt=K8bhXr2YG15M9Y0eQ@mail.gmail.com> <CAHp75VcbucQ4w1rki2NZvpS7p-z5b582HwWXDMW5G67C7C6f3w@mail.gmail.com>
In-Reply-To: <CAHp75VcbucQ4w1rki2NZvpS7p-z5b582HwWXDMW5G67C7C6f3w@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 Aug 2021 23:35:04 +0300
Message-ID: <CAHNKnsQOhpwLFHLbcyLDLDOQjD7uDdsOg4ptVpdVmwWHK01NwQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] wwan: core: Unshadow error code returned by ida_alloc_range))
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 6, 2021 at 5:20 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Aug 6, 2021 at 5:14 PM Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>> On Fri, Aug 6, 2021 at 12:00 PM Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>> ida_alloc_range)) may return other than -ENOMEM error code.
>>> Unshadow it in the wwan_create_port().
>>>
>>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>
>> A small nitpick, looks like "ida_alloc_range))" in the description is
>> a typo and should be "ida_alloc_range()". Besides this:
>
> Shall I resend?

Yes, please. And specify the target tree in the subject, please. See
patchwork warning [1, 2]. The first patch is a clear bug fix, so it
should be targeted to the 'net' tree, while the second patch despite
its usefulness could not be considered a bug fix, so it should be
targeted to the 'net-next' tree. Subjects could be like this:

[PATCHv3 net 1/2] wwan: core: Avoid returning NULL from wwan_create_dev()
[PATCHv3 net-next 2/2] wwan: core: Unshadow error code returned by
ida_alloc_range()

Or since the second patch is not depends on the first one and patches
target different trees, patches could be submitted independently:

[PATCHv3 net] wwan: core: Avoid returning NULL from wwan_create_dev()
[PATCHv3 net-next] wwan: core: Unshadow error code returned by ida_alloc_range()




1. https://patchwork.kernel.org/project/netdevbpf/patch/20210806085413.61536-1-andriy.shevchenko@linux.intel.com/
2. https://patchwork.kernel.org/project/netdevbpf/patch/20210806085413.61536-2-andriy.shevchenko@linux.intel.com/

-- 
Sergey
