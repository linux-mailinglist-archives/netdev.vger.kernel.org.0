Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B97139395
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgAMOVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:21:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:21:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so9832504wmj.4
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 06:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yc+iDpB2Dn/DjtEoNOvfQIR6jS4TteHK34jAmTkEacI=;
        b=onUU4JlvpXh8i8TxYWvXYZEF50Ek5K7ql9AXxYket9K37ifyv39JuGH+c2ShaurYwJ
         ieLJDZH1GJQuIpg2IQWlrLv1YU/gUuio6NWtjhh1Y12RAav4Q6hNj+kCVkWdJsnZk6XC
         zoasCmqTKT+92RLWWt3KNJzdyqeLdTiVHHigkFxEwo46zLmXvZ9cZTEdZs16Edrxl3fv
         Y8YVRiWREuqxPS3aDm7gtWtl1RpSdzUWCFDUmk6PklbVf0x+HfZ/jd1vvCxE23JkCAOr
         zHG91wAdMKpGpFE79D7/U8GfyNyRgACppEIEhEegn2oaR6rmyr4i1yIdK7FOrTVKTjo8
         OMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yc+iDpB2Dn/DjtEoNOvfQIR6jS4TteHK34jAmTkEacI=;
        b=mAXpXliYoVIrmVxOMLTetle5SmSx1g1Hqj7E5iPkPW+UoKe4lLByzmBZzB58/aeZLs
         YLXdeYwhtHLLCZ4eAUSs6fnDfdwLN0Wp6tpkUpmK4QOMK6/My3MPkBiHUiTP1czS12+E
         BIE3UBl5EpNxMklmPU0ADfQhPN6xXBoR5+Xu16CNV3lSRJQc4fFBMIZ/ytAsF8wkygar
         Lf3Z1iKoaJyMnhMOBt7atD2zpUezf+mzK6pchPGo4P0y9Oz6BBUWDhItiFYexTNJCOU7
         GBAp7oN6poQFAJNvMYWgiE7/DMh3lX26Ztan1Bw7S/3tyjptrnY11L4zoUIrb5oqHmVJ
         YEhA==
X-Gm-Message-State: APjAAAUahEVN+gMCt0ttTjh5GYVVrUJ5NOdWXf7x8jF90xEhxBEtPz4i
        rCBnzYN9+HSoh1ndvMBRS9T3KlHQTRE=
X-Google-Smtp-Source: APXvYqxYaYi7mX37xV6BUACLH/iY/3yY51IVlLl9ag5RdyG4KDC0JMXzIHXJJv2bQ0VAg2JWFfYnlg==
X-Received: by 2002:a05:600c:2383:: with SMTP id m3mr21564926wma.32.1578925277141;
        Mon, 13 Jan 2020 06:21:17 -0800 (PST)
Received: from localhost.localdomain (ip-213-220-234-169.net.upcbroadband.cz. [213.220.234.169])
        by smtp.gmail.com with ESMTPSA id g9sm15243476wro.67.2020.01.13.06.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 06:21:16 -0800 (PST)
From:   Petr Machata <pmachata@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <pmachata@gmail.com>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 0/2] Add support for the ETS Qdisc
Date:   Mon, 13 Jan 2020 15:16:27 +0100
Message-Id: <cover.1578924154.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new Qdisc, "ETS", has been accepted into Linux at kernel commit
6bff00170277 ("Merge branch 'ETS-qdisc'"). Add iproute2 support for this
Qdisc.

Patch #1, changes libnetlink to admit NLA_F_NESTED in nested attributes.
Patch #2 then adds ETS support as such.

Examples (taken from the kernel patchset):

- Add a Qdisc with 6 bands, 3 strict and 3 ETS with 45%-30%-25% weights:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 4500 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 

- Tweak quantum of one of the classes of the previous Qdisc:

    # tc class ch dev swp1 classid 1:4 ets quantum 1000
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 6 strict 3 quanta 1000 3000 2500 priomap 0 1 1 1 2 3 4 5 5 5 5 5 5 5 5 5 
    # tc class ch dev swp1 classid 1:3 ets quantum 1000
    Error: Strict bands do not have a configurable quantum.

- Purely strict Qdisc with 1:1 mapping between priorities and TCs:

    # tc qdisc add dev swp1 root handle 1: \
	ets strict 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 strict 8 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 

- Use "bands" to specify number of bands explicitly. Underspecified bands
  are implicitly ETS and their quantum is taken from MTU. The following
  thus gives each band the same weight:

    # tc qdisc add dev swp1 root handle 1: \
	ets bands 8 priomap 7 6 5 4 3 2 1 0
    # tc qdisc sh dev swp1
    qdisc ets 1: root refcnt 2 bands 8 quanta 1514 1514 1514 1514 1514 1514 1514 1514 priomap 7 6 5 4 3 2 1 0 7 7 7 7 7 7 7 7 

Petr Machata (2):
  libnetlink: parse_rtattr_nested should allow NLA_F_NESTED flag
  tc: Add support for ETS Qdisc

 include/libnetlink.h |   3 +-
 man/man8/tc-ets.8    | 192 ++++++++++++++++++++++++
 man/man8/tc.8        |   7 +
 tc/Makefile          |   1 +
 tc/q_ets.c           | 342 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 544 insertions(+), 1 deletion(-)
 create mode 100644 man/man8/tc-ets.8
 create mode 100644 tc/q_ets.c

-- 
2.20.1

