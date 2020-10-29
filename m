Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDF29F71B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJ2VpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2VpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 17:45:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8B6C0613CF;
        Thu, 29 Oct 2020 14:45:10 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 32so3767632otm.3;
        Thu, 29 Oct 2020 14:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcnHBJQrqekr4gwiB3cKmvgto9Dg2gyndVgzAIAwgv8=;
        b=FqMpA1FS3IE0hRrgOCQf1L3zx8V2OmAxYfC0PWER+r6D7Dwyy66OSLzfgnzzYSPZmL
         6RXDXlYzITA0cbpkFUXikADoXo349K0Ihyr8NIdKmzxCFiHXSfk1YAaukLr3MDPAqjkP
         3NMkkBybv897u0+ySRyMprTa2gNVaQqToFERWsjoZA9oP/fxJEDVGglK+Ug7ab8kPfoU
         oCdnfi33x82qZ6yXNRSYBoeqdoUrNHqDQDiiRKJWJSya3+CNMM1uz8KJ6N3v69JUmUVB
         VEmlPtE2mKYmoiI69SmOlPXDOCTzBuQOSuRR03OQhH/yIl7IavvQP4UOWesopb6gBDYl
         l2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcnHBJQrqekr4gwiB3cKmvgto9Dg2gyndVgzAIAwgv8=;
        b=cmVd1w2479/Jk4ynzjrSfZDPQUqjDDImWsUY6jLCXpBLLlWieuNgQIcfl9Wu4ajxxF
         EAt3CGZGM5/AfDhv8ZVfL++VE6ZRcrK+HqLBWJDDYS0smAXSqF7XdNcTuNbXSizhOA01
         ypk0KT9esjrgbUGhtyXmX189wyDofCNaTx/8MFfAOyHiSlf5T56G7Eib6192fmcyIjw+
         cu3CQsBlV1PaLEugJcZWYqpBwUsNzEhZdSl0tvqOr7SZ86SSeIhwD2cdmFLv6yZS7uwK
         TB0O9mb3vD8bW32Dbog9M3B2e7tdEuUqd0ldmgcscYxyVK4Uol+AXSEcicS9kHILGvL8
         pZWA==
X-Gm-Message-State: AOAM5306As5yOB7V5p91i6vyHcW4NARcN0KJIgyc/8Z6cc+97l496q/2
        APnXBhR7mMFwKsLa38IWe/Y9RgfY/finG4kWiuI=
X-Google-Smtp-Source: ABdhPJy/C5bBQMmDA7CF2+j1cwBggT6fEtt4NcAfPDsxH/0Fyy6CpGOfkb3eIn+HBk/R1YD67ExWv7ChIDPyHhrZOHI=
X-Received: by 2002:a05:6830:134c:: with SMTP id r12mr4630467otq.240.1604007909012;
 Thu, 29 Oct 2020 14:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com> <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
In-Reply-To: <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 29 Oct 2020 14:44:57 -0700
Message-ID: <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Daniel Winkler <danielwinkler@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, Oct 29, 2020 at 2:35 PM Daniel Winkler <danielwinkler@google.com> wrote:
>
> Hello Maintainers,
>
> Just a friendly reminder to review this kernel patch series. I may
> have accidentally named this series the same as the userspace series,
> so I apologize if it has caused the set to be hidden in anybody's
> inbox. I'll be sure not to do this in the future.

I will review them coming next, one of the things that seems to be
missing these days is to update mgmt-tester when a new command is
introduced, this should actually be added along side the kernel
changes since we do plan to have the CI verify the kernel patches as
well, also there is a way to test the kernel changes directly in the
host with use of tools/test-runner you just need insure the options
mentioned in doc/test-runner are set so you can run the kernel with
the changes directly.

> Thanks in advance for your time!
>
> Best regards,
> Daniel Winkler
>
> On Thu, Oct 1, 2020 at 4:04 PM Daniel Winkler <danielwinkler@google.com> wrote:
> >
> > Hi Maintainers,
> >
> > This patch series defines the new two-call MGMT interface for adding
> > new advertising instances. Similarly to the hci advertising commands, a
> > mgmt call to set parameters is expected to be first, followed by a mgmt
> > call to set advertising data/scan response. The members of the
> > parameters request are optional; the caller defines a "params" bitfield
> > in the structure that indicates which parameters were intentionally set,
> > and others are set to defaults.
> >
> > The main feature here is the introduction of min/max parameters and tx
> > power that can be requested by the client. Min/max parameters will be
> > used both with and without extended advertising support, and tx power
> > will be used with extended advertising support. After a call for hci
> > advertising parameters, a new TX_POWER_SELECTED event will be emitted to
> > alert userspace to the actual chosen tx power.
> >
> > Additionally, to inform userspace of the controller LE Tx power
> > capabilities for the client's benefit, this series also changes the
> > security info MGMT command to more flexibly contain other capabilities,
> > such as LE min and max tx power.
> >
> > All changes have been tested on hatch (extended advertising) and kukui
> > (no extended advertising) chromebooks with manual testing verifying
> > correctness of parameters/data in btmon traces, and our automated test
> > suite of 25 single- and multi-advertising usage scenarios.
> >
> > A separate patch series will add support in bluetoothd. Thanks in
> > advance for your feedback!
> >
> > Daniel Winkler
> >
> >
> > Changes in v4:
> > - Add remaining data and scan response length to MGMT params response
> > - Moving optional params into 'flags' field of MGMT command
> > - Combine LE tx range into a single EIR field for MGMT capabilities cmd
> >
> > Changes in v3:
> > - Adding selected tx power to adv params mgmt response, removing event
> > - Re-using security info MGMT command to carry controller capabilities
> >
> > Changes in v2:
> > - Fixed sparse error in Capabilities MGMT command
> >
> > Daniel Winkler (5):
> >   Bluetooth: Add helper to set adv data
> >   Bluetooth: Break add adv into two mgmt commands
> >   Bluetooth: Use intervals and tx power from mgmt cmds
> >   Bluetooth: Query LE tx power on startup
> >   Bluetooth: Change MGMT security info CMD to be more generic
> >
> >  include/net/bluetooth/hci.h      |   7 +
> >  include/net/bluetooth/hci_core.h |  12 +-
> >  include/net/bluetooth/mgmt.h     |  49 +++-
> >  net/bluetooth/hci_core.c         |  47 +++-
> >  net/bluetooth/hci_event.c        |  19 ++
> >  net/bluetooth/hci_request.c      |  29 ++-
> >  net/bluetooth/mgmt.c             | 424 +++++++++++++++++++++++++++++--
> >  7 files changed, 542 insertions(+), 45 deletions(-)
> >
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >



-- 
Luiz Augusto von Dentz
