Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC113109213
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 17:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfKYQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 11:44:38 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40312 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfKYQoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 11:44:38 -0500
Received: by mail-oi1-f193.google.com with SMTP id d22so13697105oic.7
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 08:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AvmJGu0+9BVqN/CUBtyW4HCFThFz2I1sLKj0UkqtpSA=;
        b=WEAHLDM/NBuLzAHzgmWrYT54j96SFFQNzcnAJZRaKcEK66zx+AuBNx6Zz4/duWTBt8
         3veGnuXHm0nbyxYIau6cE3Kmgjub9eOe+inCSkr5so2XGL28ZcIoohwn6n/dz7/zTy0X
         L85kNMdWE1Ah5HGo5lc67sohCIaIpCWDc7dsdWSKOMd+V7b8OGsOvk5c15/0klh4jJl8
         OAI4n+G/A7FyZXI12uvwMcN0MN6D6CgEz438z78+jC5ngkec3C1MZiRwj4F/dfrSxKs/
         sjXYnjyxVSWm84NVli/uNKt6xmZiZBfBDdZafaR+5S0EGlltAm8+qQDey7RLnPnB0DwE
         bNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AvmJGu0+9BVqN/CUBtyW4HCFThFz2I1sLKj0UkqtpSA=;
        b=RHYAsd+OSgzRc/ZQbOK8QxWlpHJk9nUkEGgGwdOnloGATsZKBSbkWGxMdnn3JuZjJT
         S3JA32r6S6hoFPaPORq+ZPpIOhq5hKhqe2NzW6ynRe5gmPviEdCzivuzm8ENRlG5orvL
         6STKQZeUtMpLAYsK+mIGnz/SimA3mwIy+bUoEktm2vcLW6ROV86TmxYwyQN4MFNzgfTm
         aNj3uMFRZCQdn8q16YdMXBVVMyBoknFopa9oR6xDAmOMMoyVXqxJfWtmyARzqn8UPDGJ
         M0uABwpHiMIH27qsIcmTITL346J656ruc9TcIsr6i2N1fL4cW1cgpBeB96Pjlwtxcl02
         Wp0w==
X-Gm-Message-State: APjAAAUbyBMMOr2m0lrwjP/Om2A0Hi7T1o2xRPt+wQmYvQlt532jYKjC
        uLgMN052hxcSJJRjyjOenTgtE25v6Gq+8xwvUDQ=
X-Google-Smtp-Source: APXvYqzocJxj8eHINvlBv++gnJtYeltGdEJTWRjtRQwYJg6sG/05+lW0yW34tem7KRkkh+/n7wBWd25840i+5VznsDs=
X-Received: by 2002:aca:c753:: with SMTP id x80mr22536632oif.115.1574700277010;
 Mon, 25 Nov 2019 08:44:37 -0800 (PST)
MIME-Version: 1.0
References: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com> <adee745d-6522-309d-a944-7a54869ac945@mellanox.com>
In-Reply-To: <adee745d-6522-309d-a944-7a54869ac945@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 25 Nov 2019 17:44:26 +0100
Message-ID: <CAJ8uoz2xsdEqy5OoK_GRLZ8+nX1TdOPQAQ+pCrgELjSX6uw3+Q@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net 1/2] i40e: need_wakeup flag might
 not be set for Tx
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 4:40 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> Hi Magnus,
>
> On 2019-11-08 21:58, Magnus Karlsson wrote:
> > This happens if there is at least one
> > outstanding packet that has not been completed by the hardware and we
> > get that corresponding completion (which will not generate an
> > interrupt since interrupts are disabled in the napi poll loop) between
> > the time we stopped processing the Tx completions and interrupts are
> > enabled again.
>
> > But if this completion interrupt occurs before interrupts
> > are enable, we lose it
> Why can't it happen for regular traffic? From your description it looks
> to me as if you can miss a completion for non-AF_XDP traffic, too. Is
> there any detail that makes this issue AF_XDP-specific?

It can happen for regular traffic too, but it does not matter in that
case since the application is not dependent on getting a notification
on completion. The only thing that will happen is that there is some
memory and HW descriptors being used for longer than necessary. It
will get completed and reused next time there is some Tx action.

In the cases where it matters, the skb path code has feature that arms
a later interrupt. I need to introduce something similar for the
AF_XDP ZC path.

/Magnus

> Thanks,
> Max
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
