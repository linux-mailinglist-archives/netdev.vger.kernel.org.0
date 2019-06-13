Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C10F440EC
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbfFMQKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:10:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46091 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbfFMQKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 12:10:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so12118212pfy.13
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 09:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DvY26Du1th1GgD3VAP9trjb3pQSfFkZH5hxAJJMMCSs=;
        b=d1x3U5wpCFoW2Pl7gno/f7ZWGPlDhX1O25F7nGpo93sF3I9xWbPpalZO/MLnTworV1
         E2vAaQdbUkQe1T+s7OXcv5qHf0OzhTcoC7tvz/fXcKOw/b0kYs9WHBn1cA7Z9VYDxnDJ
         m8Atj0PVGNASebTbplKePh1RpZTky6SnAfZvOjmuTFwpiq9RynAinSo5a+eQym6kQZhL
         w32zJYeiqqvt4QFVljmi/DiikPhNYhQcM1c/3fPyOpMHVUPs3yOlhv9hOnlfXARhIAYO
         Hia3hq2bh3oUli4hVylL+RIYYRbMa6JnMFpIhHtrUpcY/m/zZb+lbNOph+r71DBPTMAZ
         qgTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DvY26Du1th1GgD3VAP9trjb3pQSfFkZH5hxAJJMMCSs=;
        b=D7jYUrppbqAJo1GQ1PPtGBNTBshawQul9pmcHx5eJps79yyEZ467pForobuhu0jq5C
         LBnwf/+vbkAOy8oOPctbhbI5fF3BTnS9QveqEkbscUE+kedl+E9y62aZwCkW8zBcNN2u
         8L8fdZdwjzaqoM0NV8aKgrZdMHTNp725IeJYcpJSzBH/An4oFA0wSvOTu9h5mr3olaol
         /bRSAD9Nw1HpfVNZghhL0ufrYAgsmePmyLxayQ9HABo3YK/v57i7O4YNieCbHatzu+7U
         hrp6mgzLIgTlDZy4TXG6Yh1U4LDfb5mOK3xD9sw8Zpmxvg2oeJBELUK2GUU2euYeIl0a
         ruCQ==
X-Gm-Message-State: APjAAAXsr7B2caqCvR8s8tRgeNfPUXHfFMxJw2l5zmtMkhWyfIVoqIkL
        NNJNm+BIYRx041UcEIMibjoARd8Q9Go=
X-Google-Smtp-Source: APXvYqxUAwd5QdHP00Wvc8+L1qyr3KhCNToVq4bGGkEdovyUIpgi1/n5PzdQYS0bVsHM4cL//UUtKg==
X-Received: by 2002:a63:6881:: with SMTP id d123mr5821337pgc.201.1560442242639;
        Thu, 13 Jun 2019 09:10:42 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id l2sm254350pgs.33.2019.06.13.09.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 09:10:42 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [RFC PATCH net-next 0/1] Allow 0.0.0.0/8 as a valid address range
Date:   Thu, 13 Jun 2019 09:10:36 -0700
Message-Id: <1560442237-6336-1-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My talk's slides and video at netdev 0x13 about

"Potential IPv4 Unicast expansions" is up, here: 

https://netdevconf.org/0x13/session.html?talk-ipv4-unicast-expansions

There are roughly 419 million IPv4 addresses that are unallocated and
unused in the 0, localhost, reserved future multicast, and 240/4
spaces.

Linux already supports 240/4 fully. SDN's such as AWS already support
the entire IPv4 address space as a unicast playground.

This first patch for 0/8 is intended primarily as a conversation
starter - arguably we should rename the function across 22 fairly
"hot" files - but:

Should Linux treat these ranges as policy, and no longer enforce via
mechanism?

A full patchset for the remainder of the address spaces is on github:
https://github.com/dtaht/unicast-extensions

with the very few needed patches for routing daemons and BSD also
available there.

Dave Taht (1):
  Allow 0.0.0.0/8 as a valid address range

 include/linux/in.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.17.1

