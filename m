Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EAB36302
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFERwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 13:52:31 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:47013 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFERwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 13:52:31 -0400
Received: by mail-ed1-f68.google.com with SMTP id h10so6920233edi.13;
        Wed, 05 Jun 2019 10:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYtfOuzsaIuaSCe9W5O3jDRlIoV2Xik6ZeqGacqfMT8=;
        b=QhNVfc8UAyKCfw0lMsGrvSQB5DGZEG+0lRhcABpf3ISc9fVMumM+I4BxIb88xDw/TS
         mHTNvYD8cyRctLAPyDv5YpTKHZV/Ep5PgR7x6hHhhNDcK4YQ5t+NPEhKnJZnZzdledlL
         2F5H69wTnGfZBSqhIM9QxYH+MSQIQtl6w00o1HdYn6+Bfsc+uygnVHUyH8Nd//JfGz5P
         IqHy4znz3/JCp1YLlMSRymp+VvlIzqdQOQj8rO6dEj2XnGviyvAUaBDxyaauD/uuTAJK
         wyjIGYtBOyIu5/CsQjCqk1VMv4gg4MP20VCIWGv0utI+OrZSuHulRQL7N74nhfCbK7iM
         8Y4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYtfOuzsaIuaSCe9W5O3jDRlIoV2Xik6ZeqGacqfMT8=;
        b=rmnR6zCE9tJV1hAwRcpZX9xvha/18grDn9WzkfQBqnt/5ejjFglHW7brPg85psblIg
         O2ubrqYPcX6sp707fkkcTY0Oa5ULXnqNNKUgoyarML/7Uowie2daSBhAy9Q3FSjRndY4
         96Hvtv/tRM/09sNe2ECC9flaGVlsjg1fIWtSLmaJRPxP4tqlmDEnhPxu6SlkbaQeeIX1
         uvAhvnjqo2cirfr5H0CcKvmREBz3IUu17uyecjDovYXvGDJk+PbYAiPUpgTFf0bdaNBo
         /+uKUVOyR1K+nEdSjuAoKGPAgG/cSIKKGVAb+0JhTwhLzsVb3LYYJloEcn/okL/KP5+5
         imWQ==
X-Gm-Message-State: APjAAAW1JTWNpmSpW/ZHwWcNuX5kamGfpwC21WxnHWnq8FlkBRgghMh/
        RHizQ7hi0nW08BHTKTXKK1owVGsR5Ji7NIWgywQ=
X-Google-Smtp-Source: APXvYqz1ATl70MIRDqfc+yMDdMP5LDqUSNlcwQkf8ecIoqYwEwPl33WK/uyq7xAGxpTBn9bkoJlSP+7ti270ZgnoOxo=
X-Received: by 2002:a50:987a:: with SMTP id h55mr4460498edb.108.1559757149756;
 Wed, 05 Jun 2019 10:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
 <20190605174547.b4rwbfrzjqzujxno@localhost> <CA+h21hqeWSqZ0JmoC_w0gu+UJqCxpN7yWktRZsppe8LZ5Q_wMg@mail.gmail.com>
In-Reply-To: <CA+h21hqeWSqZ0JmoC_w0gu+UJqCxpN7yWktRZsppe8LZ5Q_wMg@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 20:52:18 +0300
Message-ID: <CA+h21hqB0_r_5zdkEMLTx0iOtxqAC9NSe66R8KxmT6kLdvEy6A@mail.gmail.com>
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

On Wed, 5 Jun 2019 at 20:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 5 Jun 2019 at 20:45, Richard Cochran <richardcochran@gmail.com> wrote:
> >
> > On Wed, Jun 05, 2019 at 02:33:52PM +0300, Vladimir Oltean wrote:
> > > In the meantime: Richard, do you have any objections to this patchset?
> >
> > I like the fact that you didn't have to change the dsa or ptp
> > frameworks this time around.  I haven't taken a closer look than that
> > yet.
> >
> > > I was wondering whether the path delay difference between E2E and P2P
> > > rings any bell to you.
> >
> > Can it be that the switch applies corrections in HW?
> >
>
> Yes it can be. It was one of the first things I thought of.
> Normally it updates the correction field with its own residence time
> in 1-step L2 event messages (but I use 2 step).
> It also has a bit called IGNORE2STF (ignore 2-step flag) by which it
> updates the correction field in all L2 event messages (including sync,
> thereby violating the spec for a switch, as far as I'm aware). But I'm
> not setting it.
> I also looked at egress frames with wireshark and the correction field is zero.
>

I also changed around the values of ptp_dst_mac and p2p_dst_mac in
linuxptp in the hope that I'd throw off whatever hardware parser it
has to identify the event frames, but I still get negative path delay
with E2E nonetheless. So it's probably not that.

> > Thanks,
> > Richard
>
> Thanks,
> -Vladimir

-Vladimir
