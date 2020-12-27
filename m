Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8572E3294
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 20:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgL0TZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 14:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgL0TZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 14:25:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C75BC061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 11:24:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 4so4652190plk.5
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 11:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eiUUfNOh73c1otiF2vp36kp9qEHR99n0DuF632n0jFg=;
        b=cJRUng40XZYxeapuJL92QgknDSxvv1BR4StjXREVtC7dUvN9abHHF35omCG3lOONcX
         YAcD0uiLuj24/b6NkbuFWGW8ZMSNblhm8iGFkJZCXZ/RZoiC79XKXVcWcOtk9UQdHvfM
         a2IRwP7/jU6XDektiL4czXhfI5bPVFfYlM/CjZ38hCeLCYREj9CjuPa9n7ve43KLS8Ra
         oWtg2qjtfjgcwwtnG6mhAil0jfCLCLowjTrVb4t/WLvwUBNMIRJtpUx055lmPZNbZEga
         iGYCs/ZWY0eEwjtGYSERBFWjWFeDBsTh99cq47+MWMPW2yDjThFA5ppNgxKIJOnBbhfw
         1eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eiUUfNOh73c1otiF2vp36kp9qEHR99n0DuF632n0jFg=;
        b=NUBs0NLhDx47HNcPx0+6Bfe/flR21CNTGVn3JOLgj11Wu4w+FR8NdLAdANYTGeUw+g
         WAk9VXebQTOlsaUQTEH6pbERgdQQ6S67UuDl9HJnq6xPJyc1Q7HjSdUrGc4qrmJjODxi
         9IFcas6g5ZfiGHKg45iXI4Zln68FvNvT33QRZh+LBFdDuk7ba+gSwZ2Ry9vwfqqwZ2I6
         A/IzKWYRVo6YGFWs+hEv1VfgLPqd+/Ilp02CaO5JUp9o1J6F83xd2UwpQ9VeXhFbeZRi
         jPYewyTY9GRiWzyjJqbk7qS2vYwsT9YZUDTsifa/uZtIk3HN926t8Mf/60p50n3hp8Bs
         ArVg==
X-Gm-Message-State: AOAM532SKgaJ6IuK2HzIVdNDWckwkWqUXHa/1wnw9zZAfsVQSiE/sM9G
        ryS1Rm26Phoojc1rXqKE7rkcflSeD/oHWrHuT78=
X-Google-Smtp-Source: ABdhPJzL9M94nBHFZXIUabO2hrLv2X+5xr7m0Z7jEaIm7girWCQNojTvkGyrGWspZYL8P61jJ8InK2P8fs/4jAcRDFw=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr41789046pll.77.1609097079563; Sun, 27
 Dec 2020 11:24:39 -0800 (PST)
MIME-Version: 1.0
References: <20201223165250.14505-1-ap420073@gmail.com> <CAM_iQpW_Mc4HzjtVt+AmfPYEJhafVmxwsW_ZVuLVvG0kRCAufg@mail.gmail.com>
 <CAMArcTWCY49YxbVnYjWxH=e+J+oFVjXQ1cJKxLorULXYw-c=+Q@mail.gmail.com>
In-Reply-To: <CAMArcTWCY49YxbVnYjWxH=e+J+oFVjXQ1cJKxLorULXYw-c=+Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 27 Dec 2020 11:24:28 -0800
Message-ID: <CAM_iQpWHYF4SJRi+pjVpFNOpUxkJh-802Cdwa-Z_-NthFNUubw@mail.gmail.com>
Subject: Re: [PATCH net] mld: fix panic in mld_newpack()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 27, 2020 at 6:40 AM Taehee Yoo <ap420073@gmail.com> wrote:
> But I'm so sorry I didn't understand some points.
>
> 1. you said "both side" and I understand these as follows:
> a) failure of allocation because of a high order and it is fixed
> by 72e09ad107e7
> b) kernel panic because of 72e09ad107e7
> Are these two issues right?

Yes, we can't fix one by reverting the fix for the other.

>
> 2. So, as far as I understand your mention, these timers are
> good to be changed to the delayed works And these timers are mca_timer,
> mc_gq_timer, mc_ifc_timer, mc_dad_timer.
> Do I understand your mention correctly?
> If so, what is the benefit of it?
> I, unfortunately, couldn't understand the relationship between changing
> timers to the delayed works and these issues.

Because a work has process context so we can use GFP_KERNEL
allocation rather than GFP_ATOMIC, which is what commit 72e09ad107e7
addresses.

Thanks.
