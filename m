Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F242B3080ED
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhA1WHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhA1WHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:07:50 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A9CC061573;
        Thu, 28 Jan 2021 14:07:09 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j11so1523080plt.11;
        Thu, 28 Jan 2021 14:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwbhYTYlKJc3qWdffrQGsNa7auYkd8037d2LbAoaq+4=;
        b=db/3JuT74AtHbaNhPY2iun2rxxrUDTOmNcTQ6ISyxUVI80SvBONASBZrgcArON/+Dx
         sODZKu+kRLiq/khuiNm/HKLWRc8fAiF/157bhEUHqqfIMbLB6o9auw/wjx9LXaEzSIx7
         9DrA63JAq/e1DFj/sZ0FShOYkVaNit+f/UhRoaxN+oxD6C0r47FXz1muA3xlsnMwoepc
         AnUTV7wnnkvlp/9vBmGtzZASlGWhSnDmKdtnthItkTQUIXi8Ym2415vaiWjFOb3m+764
         I5W3QDM2PF9Ta5jfeGPIyocwaLbaJ2E/XoXgGmDOdqy+zBiL4hyBLkSICq3bpvSXj9Fg
         OrVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwbhYTYlKJc3qWdffrQGsNa7auYkd8037d2LbAoaq+4=;
        b=kkKgfkU7aXGFds1zBG+mmLinoW4Wn9Ik+CIOTQe+VEvtC6UmNg48klM4XaBBNeE82Y
         icS5xS5bqCvFay+pVx5Bf32rJIzhCzlxG+p2W4MzSrwXEFlg2lXC35dRrJG8jA5wyQF4
         tHtcQX6jSkpXh6ZC/y7Gjna80RQAbiUvf7eOZX1wG6c0BvbIbINI+K1Qs2muWebYQ4KS
         fYwgOMY8Pgldox5YwZBpHg9m3S1KifrBhnx3vT36S8HmvQt1Pdyvy0AQ9V73ynWpp+mP
         eMPIByWv7HB0k63M+Tya+eeH3H1qZd8Nr8+zH9DovFV4SAk/dYuPZbmhCJUrlrOP3rZC
         dhDg==
X-Gm-Message-State: AOAM5316QGtKpRPafCpBTBcS8j12eGLIybjcGXCJQRuEzpCx0N+IUuWk
        gts3PB0zF8EvGIxSpxTwVuBJGvHbhY3FviqqE9Q=
X-Google-Smtp-Source: ABdhPJw9WypNzW1bzGBwSjcGr7cz3aeXqXGoZrWbxvCJdbVifHCjIQb2bmi/DpUFIJ8LZOiMsiypkYhnBRSd5wUlPJY=
X-Received: by 2002:a17:902:9a4a:b029:dc:435c:70ad with SMTP id
 x10-20020a1709029a4ab02900dc435c70admr1408753plv.77.1611871629557; Thu, 28
 Jan 2021 14:07:09 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com> <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 28 Jan 2021 14:06:58 -0800
Message-ID: <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 11:47 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Noob question - could you point at or provide a quick guide to layering
> here? I take there is only one netdev, and something maintains an
> internal queue which is not stopped when HW driver stops the qdisc?

Yes, there is only one netdev. The LAPB module (net/lapb/) (which is
used as a library by the netdev driver - hdlc_x25.c) is maintaining an
internal queue which is not stopped when the HW driver stops the
qdisc.

The queue is "write_queue" in "struct lapb_cb" in
"include/net/lapb.h". The code that takes skbs out of the queue and
feeds them to lower layers for transmission is at the "lapb_kick"
function in "net/lapb/lapb_out.c".

The layering is like this:

Upper layer (Layer 3) (net/x25/ or net/packet/)

^
| L3 packets (with control info)
v

The netdev driver (hdlc_x25.c)

^
| L3 packets
v

The LAPB Module (net/lapb/)

^
| LAPB (L2) frames
v

The netdev driver (hdlc_x25.c)

^
| LAPB (L2) frames
| (also called HDLC frames in the context of the HDLC subsystem)
v

HDLC core (hdlc.c)

^
| HDLC frames
v

HDLC Hardware Driver

> Sounds like we're optimizing to prevent drops, and this was not
> reported from production, rather thru code inspection. Ergo I think
> net-next will be more appropriate here, unless Martin disagrees.

Yes, I have no problem in targeting net-next instead. Thanks!
