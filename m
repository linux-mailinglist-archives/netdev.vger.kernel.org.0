Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FD45DC95
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfGCClx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:41:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34407 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCClx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:41:53 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so1254511iot.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 19:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=IwRzlfYjzFXhQuJnGD7aDluurmU9HsQFhfVonHpGweY=;
        b=XRTYUwIIMqWiOU6mcWXLiPQUBqLe3JBMLT1Tv447S/d+BNXEnXYZO9FYyt5x85Gou6
         J9PyKUR6ibZv1faY65Bz0PqWExfxUIFGh1S5pFY0eu+uJSUcIBPfsTpmOuRm61B2xJfD
         tZMmwf51gbUZXY4HFKB/nP80f3h3k2ovi1n+F3ESlIJJ+QpjZDbctXIc478H5mkY6F+r
         BYFm5PeHcmnx0nYw9ZY0+CUsSVfSoONRVS1vKWkWTwr9wyxVrLIrAZJCx6PtsW7BhgfQ
         SI4uYOnJo9dC0hFuX3/Bh7x02WAM99TGYdPXoUDSW9eSKaA42+14Wli2NxDhSwhWYmMQ
         Xeaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IwRzlfYjzFXhQuJnGD7aDluurmU9HsQFhfVonHpGweY=;
        b=uX0pLMJTkLDwpD2Q4RGhDZ2TOUvjImQtpUsDKHVG3OSL82fXdBAzS3AQFGhsS1swi+
         pqklI84sTpYpLoH4ByHL3q07sW51sp4S0gnQap0Km6fJ7Bj8W6pbL9Fc17glbrf+BgED
         wgtJJojMx2kuvLVerl6jgLusoALLe+e0hOB20k7JMfGtzzXQwlbFXXBMe9GQaLbq9DCG
         te6f/FrgGUlFt1PXYFOG1l3stBSZed5LlYTLtg0ZO5ON/EfuB5BhNlW9c7b0w4VE3mOR
         u856V9vLcKGfjJFm08FrDU/YI5/FuNxi/YM5Rm7J+JaYVj8JLJ8Ty+N0/XjPst1PWbKd
         huug==
X-Gm-Message-State: APjAAAXXNP8MevB2nGdY5E0i35lcl1aeFP1YN1IOO3m+OPtcefEj49Ho
        gl5dI8SiyS+bXuRMwfJ0550P8g==
X-Google-Smtp-Source: APXvYqzs+ZdSggDVOvfj8xydVyS0SnS9PQZRFunSvRWJ66F4EgLcSqOtgOLuStqSAXKsU0XkUYoocw==
X-Received: by 2002:a5d:8b52:: with SMTP id c18mr9961300iot.89.1562121712699;
        Tue, 02 Jul 2019 19:41:52 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:57:4bb:2258:42f6])
        by smtp.gmail.com with ESMTPSA id w26sm1638114iom.59.2019.07.02.19.41.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 02 Jul 2019 19:41:52 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net-next 0/3] tc-testing: Add JSON verification and simple traffic generation
Date:   Tue,  2 Jul 2019 22:41:18 -0400
Message-Id: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces JSON as a verification method in tdc and adds a new
plugin, scapyPlugin, as a way to send traffic to test tc filters and actions.

The first patch adds the JSON verification to the core tdc script.

The second patch makes a change to the TdcPlugin module that will allow tdc
plugins to examine the test case currently being executed, such that plugins
can play a more active role in testing. This feature is needed for the
new plugin.

The third patch adds the scapyPlugin itself, and an example test case file to
demonstrate how the scapy block works.


Lucas Bates (3):
  tc-testing: Add JSON verification to tdc
  tc-testing: Allow tdc plugins to see test case data
  tc-testing: introduce scapyPlugin for basic traffic

 tools/testing/selftests/tc-testing/TdcPlugin.py    |   5 +-
 .../creating-testcases/scapy-example.json          |  98 ++++++++++++++
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py |  51 +++++++
 tools/testing/selftests/tc-testing/tdc.py          | 146 ++++++++++++++++++---
 4 files changed, 279 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/creating-testcases/scapy-example.json
 create mode 100644 tools/testing/selftests/tc-testing/plugin-lib/scapyPlugin.py

--
2.7.4

