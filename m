Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D41280AD0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733207AbgJAXEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbgJAXEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:04:08 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61ACC0613E3
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 16:04:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ng5so2642236pjb.0
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 16:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=SYkjzmHFW92g1u0iAj/d9/R1oxk7yMhLalzdQrXLW6g=;
        b=iotYm0s3V+JzsFWofE3lKyuM/DHCsQ9dJ7zW2qpHPzLNEJy5rqPTV2RhxquNhkLR6g
         nVWf7yStU6Z4j0Q5MMgw99hbFZPz8c0LcXTnvvGC45xd39i/KunaHmgiQsV7rJjlItSR
         Y/fihW2NOuK2qJPMj6Be3UTdNNhpEd1zoNGMD/bMd/3OiMaEWZZZQanMqqHGZowCma1X
         X97yg3YwuEgtvaC9wOhETEevyztu58TQMISZjFR4CrqdzibqlCN1zilgmRxm/U5Le8TM
         NkAbe7A/nwd1x69LIxS+lD8WjzH0JP6/frVJiCWROUukO600PVT0PLYY//y+KUL2mhhG
         9cmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=SYkjzmHFW92g1u0iAj/d9/R1oxk7yMhLalzdQrXLW6g=;
        b=XxyLlh36yZvbX0oQ458lShlmPFp9qg6fpp5s39ni5ar6sNraJUO6IjPafxf6VRwUnf
         vP9V/db4G04/mAxaGk8cFlRNM+kxatXLfVBxBucNj7HJCDwVa5/gB8vhqhQY5/Xul/S8
         YbWLZQey3vaXRz0dxIg1EEfKKq38+qZqWTctZ+Gad4Nt3B+W3qUXdkRJo/mgBeL63UE5
         pJZRY3T/a7XluqFBnodDMbJ7VFiDmQcK6VEneZ4pcD66h7T9PUY5uEhTjpMQGaPqGtvW
         dhbCb6HXo98APRqT5wA3DjDuww0bEc1D1xgqgMePrqN6PHVCVQTuyUXPH2SbTdM7Y313
         AHFw==
X-Gm-Message-State: AOAM532hwP9sWXiZxaXLJ5ru7g+0yzHA2kjP6SaIKLsNopyz8enRKNa2
        lLbM96rPK5nQeFhncdkiiG9wPGh4Ev/zFM8MnkhF
X-Google-Smtp-Source: ABdhPJxbRmht+XuQKfm+o0dxqFIW/rY7ZRwIpueWR+bm/TkaAYnkz/ntvGowaNeniRuVC3fdIZa8TlLe42lC6Li9RiwQ
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a65:42c2:: with SMTP id
 l2mr8310670pgp.61.1601593448059; Thu, 01 Oct 2020 16:04:08 -0700 (PDT)
Date:   Thu,  1 Oct 2020 16:03:58 -0700
Message-Id: <20201001230403.2445035-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 0/5] Bluetooth: Add new MGMT interface for advertising add
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
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
 net/bluetooth/mgmt.c             | 424 +++++++++++++++++++++++++++++--
 7 files changed, 542 insertions(+), 45 deletions(-)

-- 
2.28.0.709.gb0816b6eb0-goog

