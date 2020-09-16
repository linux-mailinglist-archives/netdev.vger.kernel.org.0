Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0642826CAFA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgIPUUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgIPUQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:16:10 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A9C061756
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:10 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 60so7062994qtf.21
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MdhjrW4vcBDFIsP592gsDVtZRkvVNqCEWObBUfpScyE=;
        b=S/LoxaBxieC8lVQIkT05JmeKWV2q00m0KOl6lbdUZjttEi6gPmAODOXo+OXyxqrhp5
         jxPED41CrMMYGGYzgcLlvcapQJkQdfTUu9i2QXM7GJj+w4SlufZvPPq7CGx+WtQs5XXo
         I7YllF7a+UdR+tYaO2wRl5ZyHZ08LTfmccXArvii4SlsuqhTQSdMvOeJoNCanj/J/7Wq
         Vk8TR0Obzm/HN+IlfEHsaQMXotor2YyiQBI+pjYMRM8fXogZlhgu+SnJz3gWWC4Fqk3b
         iMPaxRdAqigrr2GENqry48MO3EbiyvN+S1Mii7DlJQe0FygQPQ4B5YRNsIT0vZcGSpL4
         sXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=MdhjrW4vcBDFIsP592gsDVtZRkvVNqCEWObBUfpScyE=;
        b=sIfjFZwvxSLUE7RHcgZLIkM294y7znluJEIM3W5xHZ/0EHwui+FWKiStftRy3AJSib
         +NIJ7TuBeDXDzC8wCfSHZuiY3eWxx33eCmH2kC7QVrixoC+LqNYbuDF06MBkF/zFjNMD
         RliKQp2Jw2FmkdGw6ApaA/M3gyvuSJ/7HNItpL693KZYaajHzOeeSTEZxqu0POQIk2wc
         pbXtul3+s5BI6F+PgX61Q/bvNbolji82nZKxVZDmv6y10d6EX8W28mBxpGMj8vORRZ/T
         vPJmHMppBbHGfkutuUcAIdslxGBX+wwTPiwV1H9jjchO3nhRTwKiqRYbPq0e0iPR6kWI
         0oOQ==
X-Gm-Message-State: AOAM533FYT9by5w+Fo3pvKQ4Sl5i4B80kenOkJLyBED1hHnFK2LQIT76
        kErBg1eAVh5EQxsIPWz4j/BwQGXTLQp4L2Cp2jHJ
X-Google-Smtp-Source: ABdhPJywYsxto73uCa5oqtF8W1GKrdTZFnMdhJn+ZM5F44wJqwc0/cZMV6OE3nz415keyKpfasZRfYqZsOwq7WwwtBWA
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:57a7:: with SMTP id
 g7mr25361605qvx.10.1600287369377; Wed, 16 Sep 2020 13:16:09 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:15:56 -0700
Message-Id: <20200916201602.1223002-1-danielwinkler@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH 0/6] Bluetooth: Add new MGMT interface for advertising add
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
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
capabilities for the client's benefit, this series also adds an MGMT
command to query controller capabilities, which returns a flexible TLV
format for future flexibility.

All changes have been tested on hatch (extended advertising) and kukui
(no extended advertising) chromebooks with manual testing verifying
correctness of parameters/data in btmon traces, and our automated test
suite of 25 single- and multi-advertising usage scenarios.

A separate patch series will add support in bluetoothd. Thanks in
advance for your feedback!

Daniel Winkler



Daniel Winkler (6):
  Bluetooth: Add helper to set adv data
  Bluetooth: Break add adv into two mgmt commands
  Bluetooth: Use intervals and tx power from mgmt cmds
  Bluetooth: Emit tx power chosen on ext adv params completion
  Bluetooth: Query LE tx power on startup
  Bluetooth: Add MGMT command for controller capabilities

 include/net/bluetooth/hci.h      |   7 +
 include/net/bluetooth/hci_core.h |  14 +-
 include/net/bluetooth/mgmt.h     |  48 ++++
 net/bluetooth/hci_core.c         |  47 +++-
 net/bluetooth/hci_event.c        |  22 ++
 net/bluetooth/hci_request.c      |  29 ++-
 net/bluetooth/mgmt.c             | 420 ++++++++++++++++++++++++++++++-
 7 files changed, 561 insertions(+), 26 deletions(-)

-- 
2.28.0.618.gf4bc123cb7-goog

