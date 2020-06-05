Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7235A1EF095
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 06:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgFEE3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 00:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgFEE3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 00:29:45 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DD0C08C5C3
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 21:29:45 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id v6so2846121uam.10
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 21:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yh4QPGB6BpMImnDSPQmPa4HQGaoN/XctUaVKXi5QYwY=;
        b=PDrkFN970k1ALTuEhfgcTlUwB71dPxvhGxU0C4VZu6nTHpZ+sXfAM6AMHZbir+bQX3
         7z5G2kw9yGZ+5zsqkvnXyaXOISL9lrVRVLvMfkr2sxLbV2+X63lVdLn9xYSDDlAj7Wgj
         FaiW9XEJ4Ha98qEQZAHR40fvGQ1NwOWOVeP6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yh4QPGB6BpMImnDSPQmPa4HQGaoN/XctUaVKXi5QYwY=;
        b=rft39JCJB2iXzFi2tdYFoCcqKOR8wRve3S5M/d/hdN4GLIjaPdR1XKw8JJY5wR641/
         sFg9lbVoH17dIspmScxjkYb9MhapuKxUKBiWIMftucf/hxhzx5EoXk5GENdt8cL8cS5I
         tfou6gsSZdPExBkpJWZHHIFTv75btnIKl1ZEdYdPWmfkPn2EDKL4bTGLq/Lymc9XHnda
         YjSGEh2L6C5/1/rpaBy6/Gmxn+crIjPk0NxB47vvcIGH8KreoqzPG4rUyzkQsHoivLbB
         D65xPQ6p9OEvhM2IgWSVhcAaXocMfkxC0tPS/3CVY81CLaGDZ9J98IA5snjPPZ+39Tdp
         Khrw==
X-Gm-Message-State: AOAM532IFJgEfv4ZadxqUM5lOz9qyZokxaonoHqSYc2krhF5chPLny0A
        DD4UK3THj5DC0WCrgOS06A35vDLY9cP8Xf8bfmWRnQ==
X-Google-Smtp-Source: ABdhPJxhlP+sLLzHaVKCIe6JgoxP8u6LPLZcqp5spma74BIukNjafi2Z1Xz/y+YXGyeAOVQ0H5gOM4Gf+h35CPbav1Q=
X-Received: by 2002:ab0:2bd4:: with SMTP id s20mr5781588uar.136.1591331384169;
 Thu, 04 Jun 2020 21:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200603132148.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
 <CAJZ5v0i5VPk+HUb6P43Apb=MwanTkeWqjBMEemDo+fiBTM+eOg@mail.gmail.com>
In-Reply-To: <CAJZ5v0i5VPk+HUb6P43Apb=MwanTkeWqjBMEemDo+fiBTM+eOg@mail.gmail.com>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Thu, 4 Jun 2020 21:29:30 -0700
Message-ID: <CANFp7mWHX15oJAe_RgYbN+sHbPXmUYkYtvT9V0oszOc0Y=7TKg@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Allow suspend even when preparation has failed
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Len Brown <len.brown@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sent a v2 with proper fixes and reported-by tags.

Thanks
Abhishek

On Thu, Jun 4, 2020 at 3:46 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Wed, Jun 3, 2020 at 10:22 PM Abhishek Pandit-Subedi
> <abhishekpandit@chromium.org> wrote:
> >
> > It is preferable to allow suspend even when Bluetooth has problems
> > preparing for sleep. When Bluetooth fails to finish preparing for
> > suspend, log the error and allow the suspend notifier to continue
> > instead.
> >
> > To also make it clearer why suspend failed, change bt_dev_dbg to
> > bt_dev_err when handling the suspend timeout.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
>
> Thanks for the patch, it looks reasonable to me.
>
> It would be good to add a Fixes tag to it to indicate that it works
> around an issue introduced by an earlier commit.
>
> Len, Todd, would it be possible to test this one on the affected machines?
>
> > ---
> > To verify this is properly working, I added an additional change to
> > hci_suspend_wait_event to always return -16. This validates that suspend
> > continues even when an error has occurred during the suspend
> > preparation.
> >
> > Example on Chromebook:
> > [   55.834524] PM: Syncing filesystems ... done.
> > [   55.841930] PM: Preparing system for sleep (s2idle)
> > [   55.940492] Bluetooth: hci_core.c:hci_suspend_notifier() hci0: Suspend notifier action (3) failed: -16
> > [   55.940497] Freezing user space processes ... (elapsed 0.001 seconds) done.
> > [   55.941692] OOM killer disabled.
> > [   55.941693] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
> > [   55.942632] PM: Suspending system (s2idle)
> >
> > I ran this through a suspend_stress_test in the following scenarios:
> > * Peer classic device connected: 50+ suspends
> > * No devices connected: 100 suspends
> > * With the above test case returning -EBUSY: 50 suspends
> >
> > I also ran this through our automated testing for suspend and wake on
> > BT from suspend continues to work.
> >
> >
> >  net/bluetooth/hci_core.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index dbe2d79f233fba..54da48441423e0 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -3289,10 +3289,10 @@ static int hci_suspend_wait_event(struct hci_dev *hdev)
> >                                      WAKE_COND, SUSPEND_NOTIFIER_TIMEOUT);
> >
> >         if (ret == 0) {
> > -               bt_dev_dbg(hdev, "Timed out waiting for suspend");
> > +               bt_dev_err(hdev, "Timed out waiting for suspend events");
> >                 for (i = 0; i < __SUSPEND_NUM_TASKS; ++i) {
> >                         if (test_bit(i, hdev->suspend_tasks))
> > -                               bt_dev_dbg(hdev, "Bit %d is set", i);
> > +                               bt_dev_err(hdev, "Suspend timeout bit: %d", i);
> >                         clear_bit(i, hdev->suspend_tasks);
> >                 }
> >
> > @@ -3360,12 +3360,15 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
> >                 ret = hci_change_suspend_state(hdev, BT_RUNNING);
> >         }
> >
> > -       /* If suspend failed, restore it to running */
> > -       if (ret && action == PM_SUSPEND_PREPARE)
> > -               hci_change_suspend_state(hdev, BT_RUNNING);
> > -
> >  done:
> > -       return ret ? notifier_from_errno(-EBUSY) : NOTIFY_STOP;
> > +       /* We always allow suspend even if suspend preparation failed and
> > +        * attempt to recover in resume.
> > +        */
> > +       if (ret)
> > +               bt_dev_err(hdev, "Suspend notifier action (%x) failed: %d",
> > +                          action, ret);
> > +
> > +       return NOTIFY_STOP;
> >  }
> >
> >  /* Alloc HCI device */
> > --
> > 2.27.0.rc2.251.g90737beb825-goog
> >
