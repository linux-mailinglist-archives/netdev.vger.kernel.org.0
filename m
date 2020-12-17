Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3682DCB3B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 04:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLQDTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 22:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgLQDTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 22:19:07 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B043EC061794;
        Wed, 16 Dec 2020 19:18:26 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id e20so7465706vsr.12;
        Wed, 16 Dec 2020 19:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XI6ydnrhXpGqiqNBuJrrntaJSLirU11+aB/V6asSn5A=;
        b=THRZ5wW8iIhZPUE/Yp8az4qhldEtyocNzEeGG03lsb58223kevhXn8ykxBzHc/Y9rN
         OfH44Ocw4ACcMGPcqJ+VPSdNzwuKwHzzKjSTBt4O3od8wDOkqug1bK0yQNlC7J5pPw1g
         Yi9lN3lJlv5NfkMWIH/l/Ohgaf2+5Jbx6PX2wKBtvOPSJXM+Waup8Rats/OQsE4gePhN
         2gYvyJ5qb1v8q8zmNrh9PCu0FBKXPxKkCPIyEZkinRxkM8iiUwQ4u2dfFbFQ9uFsP7Ud
         T9YiKAJGjSVTdqUWzH080vQemxExn+dfNWFAMYA2/XBOL9OuAHxWnRI2oCWn2ZUwKhYW
         Ir2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XI6ydnrhXpGqiqNBuJrrntaJSLirU11+aB/V6asSn5A=;
        b=BdIlyGsuZ6GjyXb8Hh+EYQuYl6UChjNtrEAsdspCRDHy5Y+QjatEc/xYEEpG98+Okq
         6kSdivm3Iq+tFVhWPu4amAKANiyJ6F+mbBF6p64t2Zn1hGfIQ3s6UtHlgpdGoB3cccp3
         3XXZIrwU4V42hwhPLBF2jYCuOTmiyiQbe9PSqUsK1v1H6KNhRgtXrHSzJjTqT3HGbxqW
         5QpnQNjE+Q4ZiHz32H0hV8knyjHRtMf3tZroIwwRb6ffKvA+rYzdLStvU+3c/21wWPNH
         OIx8Po9639M3WljeyNANOV06eXdXV7WTotobK4L7e3rT4eiz0eRFZKby7xsq2Ts+T7Tm
         UBMA==
X-Gm-Message-State: AOAM530cuSn2B7m+0ZiPudww8ahkb9JWkjUMRXav+4GI3eCHqxN2doP5
        HK0aWpe/p3x/xi31L2zl8A2pKNMf370PFEy2TdU=
X-Google-Smtp-Source: ABdhPJyatTENn271OLuIaur5t3+y2gHxklIu84d7pM4iShEIwW9cRvfCAeouJxgxBYusQnNQ2Avuxmc0QIYXk3j6epU=
X-Received: by 2002:a67:2e16:: with SMTP id u22mr30101186vsu.12.1608175105696;
 Wed, 16 Dec 2020 19:18:25 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
 <20201208225125.GA2602479@lunn.ch> <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
 <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com> <CAGngYiUvJE+L4-tw91ozPaq7mGUbh0PS0q7MpLnHVwDqGrFwEw@mail.gmail.com>
 <20201209140956.GC2611606@lunn.ch> <CAGngYiV=bzc72dpA6TJ7Bo2wcTihmB83HCU63pK4Z_jZ2frKww@mail.gmail.com>
 <b0779675-2bbd-d7c1-6e63-070a98dd5d41@gmail.com>
In-Reply-To: <b0779675-2bbd-d7c1-6e63-070a98dd5d41@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 16 Dec 2020 22:18:14 -0500
Message-ID: <CAGngYiWFKeXL6SFMEvVyj1rMU3WuC4jDJKGSY4FB_vd=cCZsiQ@mail.gmail.com>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 8:01 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> x86 is a fully cache and device coherent memory architecture and there
> are smarts like DDIO to bring freshly DMA'd data into the L3 cache
> directly. For ARMv7, it depends on the hardware you have, most ARMv7
> SoCs do not have hardware maintained coherency at all, this means that
> doing the cache maintenance operations is costly. This is even true on
> platforms that use an external cache controller (PL310).

Thank you, that's quite fascinating. The functions my armv7 spends most
time in during ethernet receive (eg. v7_dma_inv_range) do appear to be
just nops on x86.
