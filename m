Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5F35B5C3
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhDKPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhDKPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:04:04 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1C4C061574;
        Sun, 11 Apr 2021 08:03:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x4so12025503edd.2;
        Sun, 11 Apr 2021 08:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EL3XG3U4nOPPjPf5ktq9P0xicEfDjcpc68S3RrtHXaA=;
        b=XIXNlF4oWRt93jhtnb83EjkuKgdTHjbFmp+cEBnM5qpCY4iX0qzpThcooux7oAcORL
         A8Pvr5yuTp4F0q5eVYE6+b+wNkvZBZ45r2y1fgpFiTEMwb0hpyysMNRwHymhJ1PLW4q4
         YY6gkKuVQ+hx2KXJooB9I3Tye7s7u4cONuVEnc/5UbOa2lotA5rriMoaMM6HwLZj817Q
         RRrpjsB4++ajqDP2z7ZGp3xsTTP6prjf5KvKPtaPKFTjFiIlRQrCFBpuSqp/18YbIP5R
         huZkrrpDWlQvsmXniANu7lQeytjsEn1SNz8tzF4t87BDsRTi8VusfUiBnedBbfEXDtIa
         kccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EL3XG3U4nOPPjPf5ktq9P0xicEfDjcpc68S3RrtHXaA=;
        b=sEiRFdGn5nXE5nPxSwXshDUDUgKSMNA7WSchhoa84oq4u3GTrJLWgW1qq0XaE+rbbx
         fc+BOeXcNYg3wDmwO7Alfn4AE10nVi0V1Ao7E1kO43KvTzderBSa+ZqWA4tQrV0fHy4l
         Gage3skptHGN9RVfxOZl1GPucgXB5O258rhS+ln22NYtfokWBxkxsDYejRAmpuory8yM
         KZj7N2MnJV0n95Fo+0ZB5NAej7aYJPR8jllQjCyNv4Vlj6CGyBmbO4JvlMGzOFf1olpH
         cnXy5hPIEmi3DWdlrcPrS+5cbCoBeI3Muw/nuH7XBExPaeDWhGtK4YuzBwQFfI8e5fOz
         1pXg==
X-Gm-Message-State: AOAM533TWdgnpAwosgNo9TlQTKWXIfLKnE84XRp3W3+AkSU2roMYKM0y
        zco9x+Jk3gGVoK8RUBVnmC5GWaEEsL7Vvg==
X-Google-Smtp-Source: ABdhPJzgqL+1rukI7bPvTIphQ7rSUJpK6THP3WvUEdZFSx+TzLJLT95CAwFEmljDlaEf5jaEric5Mw==
X-Received: by 2002:a05:6402:2787:: with SMTP id b7mr25636641ede.225.1618153426914;
        Sun, 11 Apr 2021 08:03:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.googlemail.com with ESMTPSA id l15sm4736146edb.48.2021.04.11.08.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:03:46 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Date:   Sat, 10 Apr 2021 15:34:46 +0200
Message-Id: <20210410133454.4768-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
this is a respin of the Marek series in hope that this time we can
finally make some progress with dsa supporting multi-cpu port.

This implementation is similar to the Marek series but with some tweaks.
This adds support for multiple-cpu port but leave the driver the
decision of the type of logic to use about assigning a CPU port to the
various port. The driver can also provide no preference and the CPU port
is decided using a round-robin way.

(copying the Marek cover letter)
Patch 2 adds a new operation to the net device operations structure.
Currently we use the iflink property of a net device to report to which
CPU port a given switch port si connected to. The ip link utility from
iproute2 reports this as "lan1@eth0". We add a new net device operation,
ndo_set_iflink, which can be used to set this property. We call this
function from the netlink handlers.

Patch 3 implements this new ndo_set_iflink operation for DSA slave
device. Thus the userspace can request a change of CPU port of a given
port. The mac address is changed accordingly following the CPU port mac
address.

There are at least 2 driver that would benefit from this and currently
now works using half their capabilities. (qca8k and mv88e6xxx)
This current series is tested with qca8k. 

Ansuel Smith (1):
  net: dsa: allow for multiple CPU ports

Marek Behún (2):
  net: add ndo for setting the iflink property
  net: dsa: implement ndo_set_netlink for chaning port's CPU port

 include/linux/netdevice.h |  5 +++
 include/net/dsa.h         |  7 +++++
 net/core/dev.c            | 15 +++++++++
 net/core/rtnetlink.c      |  7 +++++
 net/dsa/dsa2.c            | 66 ++++++++++++++++++++++++++++-----------
 net/dsa/slave.c           | 31 ++++++++++++++++++
 6 files changed, 112 insertions(+), 19 deletions(-)

-- 
2.30.2

