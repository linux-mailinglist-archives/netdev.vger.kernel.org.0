Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E914F3E26F9
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbhHFJNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbhHFJNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:13:42 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E18C061798;
        Fri,  6 Aug 2021 02:13:26 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id o20so11194288oiw.12;
        Fri, 06 Aug 2021 02:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PoecnVoD3Bxqi3xm6UevMA69VoNd0wqCyLoJplrzsfI=;
        b=GLbGHlp4Tzgp/lxH8C8MSLFVzRHnJWq+da96tM2fohROhaR/4o2rSQ3PycwAXsRSS7
         OraSgbLTNReLBaNU/yinXcvpQJKbHMqJ/KtBwSpapHdHQY/MA8W068ZYCFpced9luynD
         uFyX0lv8fAgK40p7a70DjOSUpx/5ThPVwdwenyU+AedIdXQAwQ0xQ6704YovGxSztZ/J
         h67htb/VuzfOyvKUdheL/XU4oqSDN9ZDSRQZrIftdtvV2dbYjRDPOews/rzQtH8XsEJw
         GRBJJRZ95N2JSD+kZnrThvjnYGbP0fZTxedQs1THUlj5uAc3HpvrVUuBpMKvSDKn7L6L
         NWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PoecnVoD3Bxqi3xm6UevMA69VoNd0wqCyLoJplrzsfI=;
        b=QeCdiOYOzr/VPo0Dqfon8Ngo16pM5Z4U0/7egEbxlDBh26qDuKx+/whJwRdHKqW/Uk
         ATnIukIeknKEs524NDvML67uex1x2ZpO5JTZbGh7eF3RrsHBdDhi77zWB169dj++bcJo
         /HKJ/H3TONV5gtyhA8RZAfHJiYEIF/KIB7LjTQfliNMQ7hRysCc7sHix55QbukEWy1xU
         Uh3mGZOaKX0Y5dld82xnabki4uTRZBigzKoBEe9UbdRhE97AWZSc79Jk/7oq8JJlWwZu
         aYQn5lwoWnW8Wiez9QjwSYCrYUj+MZY1wBGSplijtHqa/g0IA+W7OYnLZFWdrKe47s9B
         KL/A==
X-Gm-Message-State: AOAM530/VojcPsKUO4zK4JngnBBCmCZC3saiej5ZozAkLkaJI6b1xDop
        38SW0zTyxjzFKgWBpFeLNYtEDzfTS00ZM9SYHyM=
X-Google-Smtp-Source: ABdhPJx0pU969KNy9/wc2riYYj7RNK2B+BdZ1TnGYVPL90fN4QasAdlCkXv+AIBarXL/meUiuXRb6ITibvea0SsYmo8=
X-Received: by 2002:aca:eb0f:: with SMTP id j15mr4701991oih.63.1628241206045;
 Fri, 06 Aug 2021 02:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210805183100.49071-1-andriy.shevchenko@linux.intel.com>
 <CAMZdPi_+GpG8h2tJ1AxOj6HaPiXXDh6aC2RvO=+zXRy_AQpWkg@mail.gmail.com> <YQz75yaecp016zOb@smile.fi.intel.com>
In-Reply-To: <YQz75yaecp016zOb@smile.fi.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 6 Aug 2021 12:13:15 +0300
Message-ID: <CAHNKnsSDX_vRJ7ot1SBfGxcFfd+EoYtdz-fyF66U=t8egmfu9g@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] wwan: core: Avoid returning error pointer from wwan_create_dev()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andy,

On Fri, Aug 6, 2021 at 12:08 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On Thu, Aug 05, 2021 at 09:53:57PM +0200, Loic Poulain wrote:
>> On Thu, 5 Aug 2021 at 20:38, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>>
>>> wwan_create_dev() is expected to return either valid pointer or NULL,
>>> In some cases it might return the error pointer. Prevent this by converting
>>> it to NULL after wwan_dev_get_by_parent().
>>
>> wwan_create_dev is called both from wwan_register_ops() and
>> wwan_create_port(), one using IS_ERR and the other using NULL testing,
>> they should be aligned as well.
>
> Ah, good catch!
>
> I just sent v2, but eventually I have decided to switch to error pointer since
> it seems the most used pattern in the code.

I agree that returning the error pointer is a good solution here.
Thank you for the fix.

-- 
Sergey
