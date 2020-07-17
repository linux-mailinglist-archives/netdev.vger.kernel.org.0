Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5247E224620
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGQWEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgGQWEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:04:31 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EC7C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:04:31 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id k6so9190356oij.11
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 15:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GxQOU91DFp6JQYSHh4cy70vG6nSnVcAgMkLeqielMPg=;
        b=ji/wp44PPW5LMEr1qiQ5MYzw7/QmCI3WbxiFYlTPLjRZSr7WJa+DphOuzobfEPEIRA
         MA1Pj9qgFHLd5NEvOS4Fwl0Dye0b/dTv3vcKsdlOCgi/h2fRfbEpiudV/IxcJaV1CaWg
         yqH2aMoGvXMRglY0l+4+7xLlZ4qkfu2pcGrYDm17LTSq7xPevQgAsrTZEmyq5ixm9a9C
         DS8IX45pMqyTOzB/mdHS2mPBQflA4yk5sJq0s4Mv3Whx3Qvpp4T4G1s0g6l2vd20Kc+v
         Qp/diUwHXu/J4rsuJxSM7DQQymUwT3/yPrfUOD1YvrxomaNQ0GnduiNhZPY/dNZLYGKW
         DDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GxQOU91DFp6JQYSHh4cy70vG6nSnVcAgMkLeqielMPg=;
        b=jun7lUzVW0AIkAYxs7Sa28SNwUEHUzKUgNrslzPiAZu42mU31jlIJaAd1MLf7T/hXh
         MdC9EpBCZKeZioXwWJceZGkNK39byKs3hFMq3AGOQwrvC+paFslRjY4kdAJC/zRdzAmb
         HRNEeTBCZCj0tYriEyD5/5coGuKAj5QL11NL5c9S9/useiWDzfJAfvEkktyXqbzNTFxj
         n95kxCecQbTnPBhzZ5ea8JD88iNwJbf4TPExIWLBOIjdwZtRPjxwur55rG4MU1PNrQO1
         6P/fJxHGXgOfXqt025xHsn2RiHSfODVrEQPvmhdyp1PeH1vEgKpWuRjBZaE2ynmKxP/p
         uDkA==
X-Gm-Message-State: AOAM530wvPSJymGQpzQJzpZ8tmI4sazJRj9fil6PHAe6MiXH+M4P/a6b
        l/IqdNZdeo75mA4owJ5lSLbFG9xWssTCXZRWbYVweA==
X-Google-Smtp-Source: ABdhPJzltPfRaisMq9QTkvviNzELgXyJHLDQumsx7pPHB+WblBs9/QwF+wZqSgXGHmRMlwmhJs0HQ2DzLNr7lSXJGyE=
X-Received: by 2002:a05:6808:7cc:: with SMTP id f12mr8947129oij.52.1595023470910;
 Fri, 17 Jul 2020 15:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU30cU36bvgoyKFMzB4z3PAhEPB7OX_ikRQeCZPhSCZztQ@mail.gmail.com>
 <20200717170843.GB1339445@lunn.ch>
In-Reply-To: <20200717170843.GB1339445@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 17 Jul 2020 15:04:19 -0700
Message-ID: <CAJ+vNU0vyUnatC0Lkjw8yFCsZT+GJV+cqPeUfN0=-LDat5_AWg@mail.gmail.com>
Subject: Re: Assigning MAC addrs to PCI based NIC's
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 10:08 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Jul 17, 2020 at 08:58:26AM -0700, Tim Harvey wrote:
> > Greetings,
> >
> > We make embedded boards that often have on-board PCIe based NIC's that
> > have MAC addresses stored in an EEPROM (not within NIC's NVRAM). I've
> > struggled with a way to have boot firmware assign the mac's via
> > device-tree and I find that only some drivers support getting the MAC
> > from device-tree anyway.
> >
> > What is the appropriate way to assign vendor MAC's to a NIC from boot
> > firmware, or even in userspace?
>
> Hi Tim
>
> From user space you can always use
>
> ip link set address XX:XX:XX:XX:XX:XX dev enp42s0
>
> But that assumes the MAC driver actually supports setting its MAC
> address. As with getting the MAC address from DT, this is also
> optional in the driver. But i guess it is more often implemented.
>
> I don't know of any universal method. So i think you probably do need
> to work on each of the MAC drivers you are interested in, and add DT
> support.
>

Andrew,

Doing it from device-tree becomes very complicated for example in the
case where a NIC is behind a on-board switch and the PCI bus topology
changes if an add-in card on a port before the NIC ends up having a
switch on it (as the NIC's bus/device changes). Such a situation
requires that boot firmware enumerates the PCI bus and rebuild's the
nested topology to properly place/update the 'local-mac-address'
property.

I realize in userspace you can use 'ip' to set a hwaddr I'm just not
clear if there is a common pattern like a udev hook or something that
helps assign MAC addr that might be present in a common location.
Maybe the norm is to skip assigning board vendor mac's and let the
drivers choose a random addr?

Tim
