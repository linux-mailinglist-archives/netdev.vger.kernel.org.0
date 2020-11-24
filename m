Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E082C2F9D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404063AbgKXSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404211AbgKXSHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:07:52 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D7C0617A6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:07:51 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id w88so16859118qtd.4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Z/kyOoGlIHKVXedcCMowMmqq3ZBuH+yZQTVdupa8w8w=;
        b=lCoNQAieJCOZuLHuiVlOMI4NqBdljo5E6elepEWZFsyFJCp3400ZJqpd5TGfaX1Wxe
         IobtRh2jGl0raUg1cXFBriOWci5qkon4Wc6DxqX6Z+oe8lAanLAgLaTc3bAyjR+cZR+f
         iL84Mmh6jOkc88h5kAUjPBvL9VvQl+j5ess63UC/LKv+jVK7rk/Px2texfid3Qm8uCEu
         fWkJH/fVjnJJOn1+K03fur02YKRQ9aSOclHUN0uVtL98C/sTejATqhThW/rzWFXfKoJo
         QtIKvOn+70WJ+wbX2Wf0WpGatnFrA5sUsxJ6RuZXMVvW+RMYNjzgW31C0/tVGNz5Qxi9
         LLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Z/kyOoGlIHKVXedcCMowMmqq3ZBuH+yZQTVdupa8w8w=;
        b=XYVJLIC9+r1e5rG4lrPdIhrV1sMeZ7fpbkobTiTz0/IUvGD/p5r0ZdxWX5yPran3AX
         GwAXnhb0E0Aj7cSRv3oThqArf3u/XAl5xoP2GgD5W5nIB5o1kj2HrAeqLTXdbBrM3lmf
         muotNEUe7eVVBGqz1QSirbBJ9QhC4Qbq601c8UqrS6nv0Ia6m25WveEJXcmwNvv6gh6A
         cXdER7X9zP1Pfx/qYQJOrWL0FOTOQORyl10s63a7NljdBNRJNxsvytaAd/MzHWQqXKnz
         auStpbVjcltPfdtrRvzifhl55CeawnhZCUt82dkKAHbMtdD3kFkFWznrZ6Fffp4exc4C
         ++fw==
X-Gm-Message-State: AOAM530Yxm/UFh557wIxWIer0dqKkymvnBtDUwVKb9blwWUGgOmgiqcM
        MDEx4aetsJfnNFHNr3OmgTt7mx6O/qyAu0BLWgCB
X-Google-Smtp-Source: ABdhPJyD2631V/wR+F3T0pRH+ZXLv1g13FWYBZsAp6JMokcjw9zpuWX4MrbJ/8satQGkRtsZVXQyMuD2ms7WRxKJXTjY
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:3252:: with SMTP id
 y79mr7127511yby.404.1606241271032; Tue, 24 Nov 2020 10:07:51 -0800 (PST)
Date:   Tue, 24 Nov 2020 10:07:41 -0800
Message-Id: <20201124180746.1773091-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v5 0/5] Bluetooth: Add new MGMT interface for advertising add
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maintainers,

This patch series defines the new two-call MGMT interface for adding
new advertising instances. Similarly to the hci advertising commands, a
mgmt call to set parameters is expected to be first, followed by a mgmt
call to set advertising data/scan response. The members of the
parameters request are optional; the caller defines a "params" bitfield
in the structure that indicates which parameters were intentionally set,
and others are set to defaults.

The main feature here is the introduction of min/max parameters and tx
power that can be requested by the client. Min/max parameters will be
used both with and without extended advertising support, and tx power
will be used with extended advertising support. After a call for hci
advertising parameters, a new TX_POWER_SELECTED event will be emitted to
alert userspace to the actual chosen tx power.

Additionally, to inform userspace of the controller LE Tx power
capabilities for the client's benefit, this series also changes the
security info MGMT command to more flexibly contain other capabilities,
such as LE min and max tx power.

All changes have been tested on hatch (extended advertising) and kukui
(no extended advertising) chromebooks with manual testing verifying
correctness of parameters/data in btmon traces, and our automated test
suite of 25 single- and multi-advertising usage scenarios.

A separate patch series will add support in bluetoothd. Thanks in
advance for your feedback!

Daniel Winkler


Changes in v5:
- Ensure data/scan rsp length is returned for non-ext adv

Changes in v4:
- Add remaining data and scan response length to MGMT params response
- Moving optional params into 'flags' field of MGMT command
- Combine LE tx range into a single EIR field for MGMT capabilities cmd

Changes in v3:
- Adding selected tx power to adv params mgmt response, removing event
- Re-using security info MGMT command to carry controller capabilities

Changes in v2:
- Fixed sparse error in Capabilities MGMT command

Daniel Winkler (5):
  Bluetooth: Add helper to set adv data
  Bluetooth: Break add adv into two mgmt commands
  Bluetooth: Use intervals and tx power from mgmt cmds
  Bluetooth: Query LE tx power on startup
  Bluetooth: Change MGMT security info CMD to be more generic

 include/net/bluetooth/hci.h      |   7 +
 include/net/bluetooth/hci_core.h |  12 +-
 include/net/bluetooth/mgmt.h     |  49 +++-
 net/bluetooth/hci_core.c         |  47 +++-
 net/bluetooth/hci_event.c        |  19 ++
 net/bluetooth/hci_request.c      |  29 ++-
 net/bluetooth/mgmt.c             | 426 +++++++++++++++++++++++++++++--
 7 files changed, 544 insertions(+), 45 deletions(-)

-- 
2.29.2.454.gaff20da3a2-goog

