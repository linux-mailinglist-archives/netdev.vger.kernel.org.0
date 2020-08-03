Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3AE23AB9F
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgHCRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHCRZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:25:35 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26420C06174A;
        Mon,  3 Aug 2020 10:25:35 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z20so368772plo.6;
        Mon, 03 Aug 2020 10:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lw7rwZegr3T32+VUPFe8rZDJDj3LjT8WVDyoLJKiqHY=;
        b=SJamImsSC+3Pfe9dFQmZwXGRoUQ5ZFXHYSRfM1CvO1mvpB6V1vxkJ7oi0yxdhbG7g2
         tRQ9yGOWJRnRbY4wKY+l2a3YGtpgEjLb8DSlDZ9wH+17h7cO/SRzg/mS06+AuW9I0TUb
         /WsEmvQ+cYRv1OW0FFArEC7WpEGw5BLHrbsgulteCd4Uxyx9LfPbEcXn11B1UfPgMHe+
         h7Oj4vv7UhJLm19MQQlM6T4P3qN/VhK6xQz8O9cibPvTpzSl80x4eSbCVjnouKkxFnpP
         swFVkAMMxFEjJh3fLdz6mbf5fY+D1kowix+wOmE7boicU6xPmUQ/TDGXTYcG5BYCnyDR
         6T/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lw7rwZegr3T32+VUPFe8rZDJDj3LjT8WVDyoLJKiqHY=;
        b=lRZmAXA5sdXSOugk6SuiN3duV11W+lRlrpEvignbRDcUDct042yfaiY9O/UAZos/tn
         /0m2XJGG9N7r4JK0B2EWI03txWFYC2cB6XHwmZNOldgnVn2ccDkGMYyUJNIL6RoMdZqi
         XiIMNGYkGdeAt7bCu0YjSBKLiPVOm+Hi0o42RXenXwOEssVZlCsNwKoGbTDWhZXBRkDh
         1yPep2OgxkB1eNlq2gBSlu0xPzwp7+4FH2cvjGvRQXV2QTb7kD4VOwEexC96Jo/mkxk4
         YTIbcO8ZzM9BSDa9PqAEPssQuTwZ3uxvtVpgKNCdJ1LXEILnYEbzd/xLOiypaiz/vhh7
         7D7A==
X-Gm-Message-State: AOAM530EDIijxbRv5noLdV+GZ78HPENRR1+koPTdMeXppdNGBHmh4MD6
        Kw7VzWnjsgqHyeb0b68ugzM8537gHsed9ZSyaO4=
X-Google-Smtp-Source: ABdhPJz0zbr7xqm5muQjJfb5wg5KxBpTY2/qocP0f4eZyYi3zUmPy3/7M0XN/md20LnGb7HPFA+Hb5euXjdK5JOXrcI=
X-Received: by 2002:a17:90a:e48:: with SMTP id p8mr362314pja.210.1596475534440;
 Mon, 03 Aug 2020 10:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200802195046.402539-1-xie.he.0141@gmail.com> <CA+FuTSee5EhrH4FgkWFnAPH9o9O6inh3f+7+qJKJW6PtQw=SAg@mail.gmail.com>
In-Reply-To: <CA+FuTSee5EhrH4FgkWFnAPH9o9O6inh3f+7+qJKJW6PtQw=SAg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 3 Aug 2020 10:25:23 -0700
Message-ID: <CAJht_EN-Ko9qZDzGsQu_S5sDxUSbddwGzi3NC+m-A55tp0EaMw@mail.gmail.com>
Subject: Re: [net v3] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks!

On Mon, Aug 3, 2020 at 2:50 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> It's [PATCH net v3], not [net v3]

Sorry. My mistake. I'll pay attention next time.

I'm currently thinking about changing the subject to reflect that we
added a "skb->len" check. Should I number the new patch as v1 or
continue to number it as v4?

> > +       if (skb->len < 1)
> > +               goto drop;
> > +
>
> Might be worth a comment along the lines of: /* upper layers pass a
> control byte. must validate pf_packet input */

OK. I'll add the comment before it to make its meaning clearer.

> > +       dev->hard_header_len = 0;
>
> Technically not needed. The struct is allocated with kvzalloc, z for
> __GFP_ZERO. Fine to leave if intended as self-describing comment, of
> course.

Thanks for pointing out! I think I can leave it as a self-describing comment.

Thanks!
