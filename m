Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0764D362F9
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFERu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:50:27 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34138 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfFERu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:50:27 -0400
Received: by mail-ed1-f65.google.com with SMTP id c26so7006333edt.1;
        Wed, 05 Jun 2019 10:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iSoLQiJZbq8dHcU25ejXYMgL717M98Dzet05yZNBEC4=;
        b=IkSPWEcb9lK0vrQWFLFk1f8zEUYj6D4LaQaoRypmVUM5h9FoTEkre8MDJA9t9uNYgA
         V5h2tA9SB3s5BCt4vAvlvv7IeN0xwdr069qmsBruMW2IpGiF0E+fDu5MKSXr1iXuzT/q
         S1vqU0xVY4WkkxKO9ZN15tGcaXXn7OmTJHl4OGkCsXDvKY1WWFdlwmzteM62RKz6QYBs
         u0ojHCsbDjW1m08PY5dQoerlxtq71lVAvaZ8E4NtOw2qbndRK8Bh0O+RS08hWdqSl3pL
         FWdzpnCD83/S/a/33NFRLyMoRCoAevaIkr1/cAL0XxKniSa3WKK0luCgt+8Xn0ElzP0e
         HDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iSoLQiJZbq8dHcU25ejXYMgL717M98Dzet05yZNBEC4=;
        b=UgxeWGNGH2r8kJSNoTBfzCK08NZRKKBIDj9fs6xkI9QHbFHbylWo7jQFFJmIfi4VU5
         aYFAJvAPO9IfRxYLBbA7BXF0XJs4c+KwkLH90NRU1S9CvQIk/3p0QbshKLv53NuLeMZt
         9uH779G2PccIQ093BUPFaNfFDlQOJ4M8LI2YUTRkeiXk3xuIWCV09JgPu0mC5rzEJY5Z
         MkKi03FbwL/SG4Hnd0Y/Jgh4q8DE+kmqm36lXGONpJ5FhoURCBy7iivig7+Fo5ylAyxF
         ybwdnTlEcahOveW28pdYtxtjCF80Jdw4R/pNUfQJF3vJBpxHJEcq1OayW7DgCp915K7T
         WfJg==
X-Gm-Message-State: APjAAAXkpE0pe6uhxxWJqKjE3jwtj24TdoE8H51B8NSlZyBRPdThti3d
        vU/7w9f4YdxsduDyBYMgf/E7v+r8eZE/IMTuepo=
X-Google-Smtp-Source: APXvYqxEeVMukTXCt/WHBCYPweUbBJwy2Is7cZq2g5+bjr+Xi2N2XRz/7kmUH407ao+FnY27WfLdei6BaKCBQ1Czw9o=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr43800313eds.117.1559757025835;
 Wed, 05 Jun 2019 10:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com> <20190605174547.b4rwbfrzjqzujxno@localhost>
In-Reply-To: <20190605174547.b4rwbfrzjqzujxno@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 20:50:15 +0300
Message-ID: <CA+h21hqeWSqZ0JmoC_w0gu+UJqCxpN7yWktRZsppe8LZ5Q_wMg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 20:45, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, Jun 05, 2019 at 02:33:52PM +0300, Vladimir Oltean wrote:
> > In the meantime: Richard, do you have any objections to this patchset?
>
> I like the fact that you didn't have to change the dsa or ptp
> frameworks this time around.  I haven't taken a closer look than that
> yet.
>
> > I was wondering whether the path delay difference between E2E and P2P
> > rings any bell to you.
>
> Can it be that the switch applies corrections in HW?
>

Yes it can be. It was one of the first things I thought of.
Normally it updates the correction field with its own residence time
in 1-step L2 event messages (but I use 2 step).
It also has a bit called IGNORE2STF (ignore 2-step flag) by which it
updates the correction field in all L2 event messages (including sync,
thereby violating the spec for a switch, as far as I'm aware). But I'm
not setting it.
I also looked at egress frames with wireshark and the correction field is zero.

> Thanks,
> Richard

Thanks,
-Vladimir
