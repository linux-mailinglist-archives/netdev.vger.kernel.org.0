Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20FC48E46A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiANGu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiANGu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:50:57 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C6CC06173E
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:50:57 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id o9so959409iob.3
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UEqQjSYXkfyW+68nPj0FYib/sLZbBqjDvvEW6pUXEMs=;
        b=MTvLBGb93y4NG3HP9hsj6GJqaPMSV5rCLAODCbScflUq8wqXmhWkGvSnteNIbDp2Ov
         coqxkkfYDIS8/h8F430CX9H5E5Y/GMaNX0hpGuCQwkg9CUPnIOxgENXGSwuJYziPbJgb
         3c6yzf7rGFekQ11xeLKb60r8J6I7i786ywQEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UEqQjSYXkfyW+68nPj0FYib/sLZbBqjDvvEW6pUXEMs=;
        b=h7rBvYlV2ixDan3AWAZvGSpoeZAmXLFeFLLQwo6+QhIFt2o3Q3g54J5JdKUilxv3kY
         t7jPxLAGY+RXKgAFsjJhlo8apFRZ3ltAdJ6a0++x2CN0aCV/F+CTEoJtq8ycOU5PfLgh
         6QnBTLpB+xXG/gvBhN8AOZlBBA+izdBb6QQfd5XZwKAm6+xEaNl3zEHRnIILewp8gN2S
         /PMMlR40M4itY7vmDPelB9bIBDLKLo9TGwTG6kbxrJf8rKAV+CHEP4y4fpQqzBm6FNeG
         ld+52ila1Jysd0jd/d9TIVm69YUwChB9kuDoJNoKb9T+gRBo3f078+gJM13Fu9U7P75L
         AGfA==
X-Gm-Message-State: AOAM532nL3pl1EfDeaECbD7i42050an8gPhvnnN6nNuklUtzvAdP4mpp
        wohJd3VOoxrAcpq5yJsVHj/6qgXxH7Kz1QlzpjwTUQ==
X-Google-Smtp-Source: ABdhPJyRmwBj5vq9rUMU2RWBrfxr/D+hLST7MYzyT0aeXbJX1WVZ0xmbvVIY3hMwgMkjwXWAVzENoDU07Qg/NLr6AIk=
X-Received: by 2002:a05:6602:2b83:: with SMTP id r3mr3812667iov.93.1642143056574;
 Thu, 13 Jan 2022 22:50:56 -0800 (PST)
MIME-Version: 1.0
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
 <CAD=FV=VVzQFK_PwnCXkJ6OK3DcgBnoxmvNG3WXFn30ncdY-E_w@mail.gmail.com>
In-Reply-To: <CAD=FV=VVzQFK_PwnCXkJ6OK3DcgBnoxmvNG3WXFn30ncdY-E_w@mail.gmail.com>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Thu, 13 Jan 2022 22:50:45 -0800
Message-ID: <CACTWRwsT8dEPiVkvk_=FPSAwuN2oti27p8Vb-mVjWE7iJuTNrw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 4:51 PM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Mon, Jan 10, 2022 at 3:15 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
> >
> > +int ath10k_core_parse_default_bdf_dt(struct ath10k *ar)
> > +{
> > +       struct device_node *node;
> > +       const char *board_name = NULL;
> > +
> > +       ar->id.default_bdf[0] = '\0';
> > +
> > +       node = ar->dev->of_node;
> > +       if (!node)
> > +               return -ENOENT;
> > +
> > +       of_property_read_string(node, "qcom,ath10k-default-bdf",
> > +                               &board_name);
> > +       if (!board_name)
> > +               return -ENODATA;
> > +
> > +       if (strscpy(ar->id.default_bdf,
> > +                   board_name, sizeof(ar->id.default_bdf)) < 0)
> > +               ath10k_warn(ar,
> > +                           "default board name is longer than allocated buffer, board_name: %s; allocated size: %ld\n",
> > +                           board_name, sizeof(ar->id.default_bdf));
>
> I suspect, but don't know for sure, that you're going to get another
> builder splat here. Just like sizeof() isn't guaranteed to return an
> "unsigned int", it's also not guaranteed to return an "unsigned long".
> I believe you want %zu. See Documentation/core-api/printk-formats.rst
Thanks for the tip, I will make this fix in V3.
>
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(ath10k_core_parse_default_bdf_dt);
>
> Boy, that function seems like overkill for something that you need
> once at init time. ...and I also suspect that the lifetime of the
> string returned by of_property_read_string() is valid for as long as
> your "of_node" is held and thus probably you could use it directly (it
> likely has a longer lifetime than the location you're storing it).
>
> ...but I guess it matches the ath10k_core_check_dt() function above
> it, so I guess it's fine?
Ya, that was my idea to match it with ath10k_core_check_dt, initially,
I was planning to remodify ath10k_core_check_dt to parse the new
property, but looks it is used it multiple places, so I thought having
a separate parser function would be cleaner, however, I am open to new
ideas.

- Abhishek
