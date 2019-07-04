Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E7A5F0C7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGDAp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:45:56 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39145 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGDAp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:45:56 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so9250944iod.6
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Sg9Sh2j8dtjwp2RuuJW95/yuo1t/IlH7m8F9M1cwbYQ=;
        b=fU99zB9zfQZPMqrOJkiyKea3hItBNw4u+s1rgL5+oDjyAF6t0J4gYvG3msW+MIWpOE
         Rdty6bk+UGLQDRdyma/uBcgR4yiccAErJ9iJCqerQIyTH9H94GfJ8jVRJ53Vlb1r8uof
         fkEzHy9KwaK2SlZfkZEmJ/Jq+dFI/9HmtE2gWqsBSwtgskFwebYL3xK/7qeCOFiJ8zO/
         98M/KK7yZ5TuW2r6qzH13+uTqQP2PPT439NBEualMhG9bR74WCC4SiafOQVADBmc4q+E
         FPKm+WN2FUDV+UkJ3AgM2gvbBzg58hYP9H3f+VLm1ndpJbgv4cKbTs6mXQposjsHpDPg
         F02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sg9Sh2j8dtjwp2RuuJW95/yuo1t/IlH7m8F9M1cwbYQ=;
        b=Udi/KadQEkFNLMpI5oQWSArZx0MQXQB1HQkTt6fau6U7fqI6ABtm3tRE+gaGJYQoix
         cUUOcwoDNyYMXfZg8zki6ZlTi8bily60dGLSvROGHvPYWXt9wEdElDI6FYlPFA3RtYbX
         gP425mKerHVPpIpi0ijeweAwx4V9InVwdbdSLyEc3Z2UCDgLqlU0Rk+bf/myB9PJq4k0
         RvLtSo3bH/jbX2xUlngbQYazGGa6XsaQLN5HtpbFRYXWnE4lDjYUhIG89Yy+wa6IMFTe
         761zTo+XImfUodP8yoyAUmArjmWVoCAV4Pr4+Yj1p2u6R6QokpuyY/cXdSYLWTyAQoKu
         NLRw==
X-Gm-Message-State: APjAAAXSAihZhM5baiQ/uBfJzQ2P3MESE6ZwnPbAZQKRAHqaSRiAwaHQ
        j77GfqP8PYHJdNQwZPfrj/x7JfV0kjoP4z7uN1k=
X-Google-Smtp-Source: APXvYqy3kE2OT1keMuS0cdY87oJ5HrgBli5SR1W1Zn9zZ5wmfV9G1K4FJyIIid31f8uTQevwQ4MF/g==
X-Received: by 2002:a02:c646:: with SMTP id k6mr45694412jan.134.1562201155948;
        Wed, 03 Jul 2019 17:45:55 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:4494:a7b3:9aab:d513])
        by smtp.gmail.com with ESMTPSA id l5sm5619776ioq.83.2019.07.03.17.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 17:45:55 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH v2 net-next 0/3] tc-testing: Add JSON verification and simple traffic generation
Date:   Wed,  3 Jul 2019 20:44:59 -0400
Message-Id: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces JSON as a verification method in tdc and adds a new
plugin, scapyPlugin, as a way to send traffic to test tc filters and actions.
This version includes the patch signoffs missing in the previous submission.

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

