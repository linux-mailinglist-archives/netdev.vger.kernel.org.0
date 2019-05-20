Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1022ADD
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 06:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfETEh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 00:37:29 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:38424 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfETEh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 00:37:28 -0400
Received: by mail-pf1-f169.google.com with SMTP id b76so6562628pfb.5
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 21:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wwfWY6FSbwyVdWsQtUA6l/1TAwUmzXDOsKQ/Gs6fNJE=;
        b=Xt2oqYYK5bvqLckIhr+Gy23FSgcnRa1jQrpUo361YH4F63xrYgxLF8jXdorzEZUEGP
         i4qxFNP0j1laUTP0dJiMZawtNjrfU0n23f0IIEuFQJf025rxGgi2uB3RD5iIi0Uc0Ggy
         azxtG1l6DOcF6FeGKQlogpD05d0UgjE7SwtmrTTOpv6Caw84Qu+WD68aHXWOcRJ13/ON
         UjkG5ljXOuuvvnDsaQ53nTYlhU+VmfLfV+Ol1kSh8XkyJUISYnigrrM4CtukXjQg1Bu5
         17ZevY411kx8nclAyVpvbjtgOWW9lYYa7Y6/DPVAubH2vpWKA2f3BTaBM0X2Ptlj0sTr
         JCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wwfWY6FSbwyVdWsQtUA6l/1TAwUmzXDOsKQ/Gs6fNJE=;
        b=HWs/gGyjlDNaX6FBcil8OuKfobb/jN282y/OMqjnJRlaqF64bDQ9iPxU6/GIk+PojB
         7YV6j31rUJ6Nf1LNHKbf0fVwB9+CNmW5PpY9e0b0pz/NQrc1cOlhqFpakMSDKuwh5gsl
         iJkLYdPWyDJvfgK3G3zn328M/4/G4Q8aLktcbu3C58EUgntrIJqSfW6g6doD8YsUuq+c
         edNt8rSNsv9O/1Px4uQ7gaxsQvgYqp/xLHCOO1qQ0YSjgACQIrA1pW7Z+z9n2LBny026
         ZdyERTY32WmvwXg7Vwh5U7VFamhO8bqELMJTx82B3NqKL0RRk9m90fbMPpIMr2VDny3F
         rh8A==
X-Gm-Message-State: APjAAAVWSJ4H6yEWVxnLmtBCWyW9uPasy+oY7JYvr8QkmzR61it52kZF
        mOSlINVCUf8vXQq9LoJi+LwR1Eybcyo=
X-Google-Smtp-Source: APXvYqxUB8KQYN2/syUXSoNSxUtAVk9/UhlakiVrGRCdBANA1TwtJ8UoluHCS/PS1+mSvwk0HC7TWA==
X-Received: by 2002:a62:d286:: with SMTP id c128mr78818522pfg.159.1558327048128;
        Sun, 19 May 2019 21:37:28 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 85sm20933953pgb.52.2019.05.19.21.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 21:37:27 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] kselftests: fib_rule_tests: fix "from $SRC_IP iif $DEV" match testing
Date:   Mon, 20 May 2019 12:36:53 +0800
Message-Id: <20190520043655.13095-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all the IPv4 testing addresses are in the same subnet and egress device ==
ingress device, to pass "from $SRC_IP iif $DEV" match test, we need enable
forwarding to get the route entry.

Hangbin Liu (2):
  selftests: fib_rule_tests: fix local IPv4 address typo
  selftests: fib_rule_tests: enable forwarding before ipv4 from/iif test

 tools/testing/selftests/net/fib_rule_tests.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.19.2

