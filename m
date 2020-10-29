Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F9229F7E5
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgJ2WZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2WZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:25:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670EEC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:25:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id 7so6022420ejm.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPkhgoZCoNKuZkNqzsqClmWwArbIz2ujzRy7ZbDQUHM=;
        b=hCJto95vVJWBZh6PlFrZzA02+c8UlOoFn/0AczIF0zP9yfPZP3G1LakX1j0CF3mxKj
         APXUHMnjYX40Bv6/v3kc4+cOJUA619HdD2VbnT3hK4BM5aqbW1FuRNaaeiqSeIS06iE5
         NrQ5mxfboRZ9lsaJzw+G4+EKb2ma3fVKQBRqC9f9G7W//MlW8crN9VvY0hRN2kcNGjD0
         gt93WrVJVi9R7Kgdy7gQzii+3PMIRne36GjNWE48yy4cAaSVXYl7j3FiGJ9fxwv4k+Ht
         ga+vpsaYHR7uEPakK0+G7lCKowjVPBMehB8t72acXip2vRALqaaf5vIegdc+a9Oy5OVb
         PAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPkhgoZCoNKuZkNqzsqClmWwArbIz2ujzRy7ZbDQUHM=;
        b=unYZKJjVOe1UstmobJXIbQtRTrepOJd49zTuzJlEGUuZtQHKF9MeDKnuR26FfAZCRd
         gsF9I1X0mY0AciMMX/ALhlb8FBe7+I8nGpNNiY8adNVJOA2z4MYOsMMXBFkvxN3a4ICj
         YLniz1goDLF5x8H69m5V52X5eBoTvJtWF5G3n6ZdLyMSpBHZExRhYyXjqKaC7yrgqRYR
         qDdRRzrd08c6ByMQTQBG0l8Fys0VXtTPm5cVkN3QdBlVD7rMGc3oVltKo13FcR5cJZ19
         yTdwHnIC2OZn0HOt+6SPiqsZz2JmcNT3rW5DwTP5hLv9amEEHTD+pejTfg9KrcSWGOxg
         yowA==
X-Gm-Message-State: AOAM531ff84/q7XtwI5PehYHc9e8UW0CzTHOxzxBuPaZUexmw5SB06Fe
        30iSdhtWXpYUwbou1hc4M2SYfAtEp2kzSLo6VWJ6Wg==
X-Google-Smtp-Source: ABdhPJxEm6s6k6aY+2eV8lHzRVSz1PBzcREy/9GRw7FLKBKZfcrVByKidut7Z6qAQev0K1F+JQaZMKcnrU3aqNEXSuY=
X-Received: by 2002:a17:906:4351:: with SMTP id z17mr6185859ejm.110.1604010346851;
 Thu, 29 Oct 2020 15:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201001230403.2445035-1-danielwinkler@google.com>
 <CAP2xMbtC0invbRT2q6LuamfEbE9ppMkRUO+jOisgtBG17JkrwA@mail.gmail.com> <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
In-Reply-To: <CABBYNZJ65vXxeyJmZ_L_D+9pm7uDHo0+_ioHzMyh0q8sVmREsQ@mail.gmail.com>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Thu, 29 Oct 2020 15:25:35 -0700
Message-ID: <CAP2xMbs4sUyap_-YAFA6=52Qj+_uxGww7LwmbWACVC0j0LvbLQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
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

Hi Luiz,

Thank you for the feedback regarding mgmt-tester. I intended to use
the tool, but found that it had a very high rate of test failure even
before I started adding new tests. If you have a strong preference for
its use, I can look into it again but it may take some time. These
changes were tested with manual and automated functional testing on
our end.

Please let me know your thoughts.

Thanks,
Daniel

On Thu, Oct 29, 2020 at 2:45 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Daniel,
>
> On Thu, Oct 29, 2020 at 2:35 PM Daniel Winkler <danielwinkler@google.com> wrote:
> >
> > Hello Maintainers,
> >
> > Just a friendly reminder to review this kernel patch series. I may
> > have accidentally named this series the same as the userspace series,
> > so I apologize if it has caused the set to be hidden in anybody's
> > inbox. I'll be sure not to do this in the future.
>
> I will review them coming next, one of the things that seems to be
> missing these days is to update mgmt-tester when a new command is
> introduced, this should actually be added along side the kernel
> changes since we do plan to have the CI verify the kernel patches as
> well, also there is a way to test the kernel changes directly in the
> host with use of tools/test-runner you just need insure the options
> mentioned in doc/test-runner are set so you can run the kernel with
> the changes directly.
>
> > Thanks in advance for your time!
> >
> > Best regards,
> > Daniel Winkler
> >
> > On Thu, Oct 1, 2020 at 4:04 PM Daniel Winkler <danielwinkler@google.com> wrote:
> > >
> > > Hi Maintainers,
> > >
> > > This patch series defines the new two-call MGMT interface for adding
> > > new advertising instances. Similarly to the hci advertising commands, a
> > > mgmt call to set parameters is expected to be first, followed by a mgmt
> > > call to set advertising data/scan response. The members of the
> > > parameters request are optional; the caller defines a "params" bitfield
> > > in the structure that indicates which parameters were intentionally set,
> > > and others are set to defaults.
> > >
> > > The main feature here is the introduction of min/max parameters and tx
> > > power that can be requested by the client. Min/max parameters will be
> > > used both with and without extended advertising support, and tx power
> > > will be used with extended advertising support. After a call for hci
> > > advertising parameters, a new TX_POWER_SELECTED event will be emitted to
> > > alert userspace to the actual chosen tx power.
> > >
> > > Additionally, to inform userspace of the controller LE Tx power
> > > capabilities for the client's benefit, this series also changes the
> > > security info MGMT command to more flexibly contain other capabilities,
> > > such as LE min and max tx power.
> > >
> > > All changes have been tested on hatch (extended advertising) and kukui
> > > (no extended advertising) chromebooks with manual testing verifying
> > > correctness of parameters/data in btmon traces, and our automated test
> > > suite of 25 single- and multi-advertising usage scenarios.
> > >
> > > A separate patch series will add support in bluetoothd. Thanks in
> > > advance for your feedback!
> > >
> > > Daniel Winkler
> > >
> > >
> > > Changes in v4:
> > > - Add remaining data and scan response length to MGMT params response
> > > - Moving optional params into 'flags' field of MGMT command
> > > - Combine LE tx range into a single EIR field for MGMT capabilities cmd
> > >
> > > Changes in v3:
> > > - Adding selected tx power to adv params mgmt response, removing event
> > > - Re-using security info MGMT command to carry controller capabilities
> > >
> > > Changes in v2:
> > > - Fixed sparse error in Capabilities MGMT command
> > >
> > > Daniel Winkler (5):
> > >   Bluetooth: Add helper to set adv data
> > >   Bluetooth: Break add adv into two mgmt commands
> > >   Bluetooth: Use intervals and tx power from mgmt cmds
> > >   Bluetooth: Query LE tx power on startup
> > >   Bluetooth: Change MGMT security info CMD to be more generic
> > >
> > >  include/net/bluetooth/hci.h      |   7 +
> > >  include/net/bluetooth/hci_core.h |  12 +-
> > >  include/net/bluetooth/mgmt.h     |  49 +++-
> > >  net/bluetooth/hci_core.c         |  47 +++-
> > >  net/bluetooth/hci_event.c        |  19 ++
> > >  net/bluetooth/hci_request.c      |  29 ++-
> > >  net/bluetooth/mgmt.c             | 424 +++++++++++++++++++++++++++++--
> > >  7 files changed, 542 insertions(+), 45 deletions(-)
> > >
> > > --
> > > 2.28.0.709.gb0816b6eb0-goog
> > >
>
>
>
> --
> Luiz Augusto von Dentz
