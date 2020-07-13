Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECFA21CE99
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgGMFJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgGMFJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:09:24 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F28FC061794;
        Sun, 12 Jul 2020 22:09:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o38so9085956qtf.6;
        Sun, 12 Jul 2020 22:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mgj/wvd79X6Tg0otEw1MjyAhvhEJqLE80+gVPS33EpM=;
        b=Agzoe9FSrpGTKPO+ZjPAOqoT76Xl/XX1v0yMlXP5nbGof6W1/JAmCMjBdIopUjwhw3
         FvslyZbteEaNueMND2tqEw7qxjofYqRQ0e0+kgBwpWN656vEtasQf665kounoqet6iGw
         ui3e9LtGa0wCYk3zVc/2Px7MKpzWlbQjfkvxkO8o2oTDSLoFLW8f0I3N20xDX1llYivr
         s42qm/WZB7hP0OqjAt+u6tVOn3fb1wBcM9/8EWCrd/c1Mdx2YlLiFkKKeQzpvslWBzLr
         PXMcAi8wg6/jmwSp+psa2Yw1mLGSyn4DaoJ8J+2FIeX+vyj9SbFURP3TQ6g09gh0/ylh
         /WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mgj/wvd79X6Tg0otEw1MjyAhvhEJqLE80+gVPS33EpM=;
        b=eYmt97XTYeYGEx/CL1x137GLCcTW2aVrUWhbDWuhrJSHfn5lTz45ZeQJVu971YjoqT
         fvIP60DVbPWJAD/43IJyx+9TycIOV6L4loRX95wE+10WbcGEdPVPNWEV8UTVCi2EI8ur
         QUf+JluhuT+0Pk4IAsTh2XJILh3BArQYZaXQoH4pGa3kV38yZYZ1d3vdHP2RR7tbX1Kg
         vwa7wIXysyvvojI7FgLF+TfmlFybqLvmBYRSnEZS567RzxaMRDdNSfQtDXXuaxtxB5tb
         PgE72RMtNgSyRz5F5/j4Fn+0VX4xv1gmEUu9BgRfS3mAxSAJLC4EMVNSHJtTu/E42WWy
         V8qw==
X-Gm-Message-State: AOAM530msnpKJdt00qb4IXvw/L0X77yPSR+4nvzo5xe5iNlIMppayjTL
        RH37e/gVl5J3B/SHepdnw8Mv5CbGYaFnwbY3iNUXhTUR
X-Google-Smtp-Source: ABdhPJzD7BsbNZXIjdhXtbehLOCjRVk4RfzGsSOpsgLAbeS7Uko6VPVwDPPI9M+P5gIgNFSmYPVC02V9b45NXmkMSiY=
X-Received: by 2002:ac8:40cd:: with SMTP id f13mr79930028qtm.373.1594616963390;
 Sun, 12 Jul 2020 22:09:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200705195110.405139-1-anarsoul@gmail.com> <20200705195110.405139-2-anarsoul@gmail.com>
 <DF6CC01A-0282-45E2-A437-2E3E58CC2883@holtmann.org>
In-Reply-To: <DF6CC01A-0282-45E2-A437-2E3E58CC2883@holtmann.org>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sun, 12 Jul 2020 22:08:57 -0700
Message-ID: <CA+E=qVeYT41Wpp4wHgoVFMa9ty-FPsxxvUB-DJDnj07SpWhpjQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 9:03 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Vasily,
>
> > Some adapters (e.g. RTL8723CS) advertise that they have more than
> > 2 pages for local ext features, but they don't support any features
> > declared in these pages. RTL8723CS reports max_page = 2 and declares
> > support for sync train and secure connection, but it responds with
> > either garbage or with error in status on corresponding commands.
>
> please send the btmon for this so I can see what the controller is responding.

Here is relevant part:

< HCI Command: Read Local Extend.. (0x04|0x0004) plen 1  #228 [hci0] 6.889869
        Page: 2
> HCI Event: Command Complete (0x0e) plen 14             #229 [hci0] 6.890487
      Read Local Extended Features (0x04|0x0004) ncmd 2
        Status: Success (0x00)
        Page: 2/2
        Features: 0x5f 0x03 0x00 0x00 0x00 0x00 0x00 0x00
          Connectionless Slave Broadcast - Master
          Connectionless Slave Broadcast - Slave
          Synchronization Train
          Synchronization Scan
          Inquiry Response Notification Event
          Coarse Clock Adjustment
          Secure Connections (Controller Support)
          Ping
< HCI Command: Delete Stored Lin.. (0x03|0x0012) plen 7  #230 [hci0] 6.890559
        Address: 00:00:00:00:00:00 (OUI 00-00-00)
        Delete all: 0x01
> HCI Event: Command Complete (0x0e) plen 6              #231 [hci0] 6.891170
      Delete Stored Link Key (0x03|0x0012) ncmd 2
        Status: Success (0x00)
        Num keys: 0
< HCI Command: Read Synchronizat.. (0x03|0x0077) plen 0  #232 [hci0] 6.891199
> HCI Event: Command Complete (0x0e) plen 9              #233 [hci0] 6.891788
      Read Synchronization Train Parameters (0x03|0x0077) ncmd 2
        invalid packet size
        01 ac bd 11 80 80                                ......
= Close Index: 00:E0:4C:23:99:87                              [hci0] 6.891832

hci0 registration stops here and bluetoothctl doesn't even see the controller.

> Regards
>
> Marcel
>
