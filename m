Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE1A2CDF95
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgLCUQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731849AbgLCUQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:16:28 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A00DC061A52
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:15:48 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id q10so1969507vsr.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dljsbllX4zS14a9ABWPEKmTQRtRoht1NPRssUTiAyy4=;
        b=L5a8wPh1tL1h2GioK1Al+21eqCetCvtglnrAvuW3ad4BLTy3NKGlIK3lYDyfaGpB7N
         Xx/g/4uxu0MTmoeRu3LtpuViypl4z27vp8bmMvA+OD+dCHKQjJCEdGUWhVk85Trt0Fif
         /bmMv83xlnxPMWKmq0602S6xBBd1XXXqY146QB4AufTsnrmHvRjwiehOJvXr3d21IenO
         QGeRszMr7QBrZLGzuU1pkPg2fjSMTk3Rmi4+Q6JCB2br51STYVq8hiVfV6AWnHotDavK
         hcMk/wogLh6O1nvqyMCMVmdQWBoVey/uo86DS5d8xM2i8CDWibHHuDzcC+38OlnMRJJd
         H/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dljsbllX4zS14a9ABWPEKmTQRtRoht1NPRssUTiAyy4=;
        b=L587PADY5VMhETJyRKBdvbaSQ9JsA8eRu5RMQHCAo0KrAUIRv4O485vbYj6FGvjT/6
         w7eEhYyGDtrryJTIpu6MIq61WR6GtBXG3nGEUhfKuduuk73O34u8Rv6XoBUG58Rp4+aD
         pB8nsPQp/JAk8B50Kdl0S4nGR+CT7eVL8r6yhmYyV+LC5GPnruCA2I/48QobYLyiQDGo
         L6RhB1IryfLpP/Ma+H3A1sUvp7D+EmG8z6g2QOtweA4hK3H9J42DPv+kOh86B3UD2piq
         U5z0rYPRErQWHxOysdMtg96nEp2ihf9xRt6zDn1TED/0yTiwWUxOHLkM68DKfpEpDxTN
         8b/Q==
X-Gm-Message-State: AOAM5303nkWcbjYrI8TxjESf3aGjcNwSlWEbnV8ztfgOPiOKpDIUDm1z
        XPLTY2f0kVhzxZW4raoSHXwx8S7kDNRNp1g8hYOSAw==
X-Google-Smtp-Source: ABdhPJypT+JWP198y7byw9Fki6jKweG2BidS8xaLr/CG93yNMUjY0FwJJJlmRwOCWkDm6U5SmBZ0yhd6xJKIgEbblGI=
X-Received: by 2002:a05:6102:126c:: with SMTP id q12mr1100738vsg.9.1607026547053;
 Thu, 03 Dec 2020 12:15:47 -0800 (PST)
MIME-Version: 1.0
References: <20201130225744.3793244-1-danielwinkler@google.com> <7F86588C-4CB8-43C7-A6D0-25C9BF722C56@holtmann.org>
In-Reply-To: <7F86588C-4CB8-43C7-A6D0-25C9BF722C56@holtmann.org>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Thu, 3 Dec 2020 12:15:35 -0800
Message-ID: <CAP2xMbuQSbDSeRCQ9YmC_pg7oSvz9tZeuJw5O_FxwHU7OPa1OQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] Bluetooth: Add new MGMT interface for advertising add
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

I have just rebased onto bluetooth-next/master (commit
e2e03d27190561976f2631c36337299645f7c1a2 from Dec 3) - oddly, I didn't
have any conflicts in my rebase. Please let me know if the issue
continues.

Thanks!
Daniel

On Thu, Dec 3, 2020 at 4:47 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Daniel,
>
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
> > will be used with extended advertising support. After a call to set
> > advertising parameters, the selected transmission power will be
> > propagated in the reponse to alert userspace to the actual power used.
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
> > Changes in v6:
> > - Only populate LE tx power range if controller reports it
> >
> > Changes in v5:
> > - Ensure data/scan rsp length is returned for non-ext adv
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
> >  Bluetooth: Add helper to set adv data
> >  Bluetooth: Break add adv into two mgmt commands
> >  Bluetooth: Use intervals and tx power from mgmt cmds
> >  Bluetooth: Query LE tx power on startup
> >  Bluetooth: Change MGMT security info CMD to be more generic
> >
> > include/net/bluetooth/hci.h      |   7 +
> > include/net/bluetooth/hci_core.h |  12 +-
> > include/net/bluetooth/mgmt.h     |  49 +++-
> > net/bluetooth/hci_core.c         |  47 +++-
> > net/bluetooth/hci_event.c        |  19 ++
> > net/bluetooth/hci_request.c      |  29 ++-
> > net/bluetooth/mgmt.c             | 430 +++++++++++++++++++++++++++++--
> > 7 files changed, 548 insertions(+), 45 deletions(-)
>
> I am having problem with patch 3/5 which does not apply cleanly against bluetooth-next. Can you please fix it and re-send. Thanks.
>
> Regards
>
> Marcel
>
