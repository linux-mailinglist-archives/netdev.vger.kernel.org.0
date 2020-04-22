Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F360C1B4B54
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgDVRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:10:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7BC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:17 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 145so1394260pfw.13
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m2myf09f32ZWUhYNf41DERUMamAn2ogmeGu9WTISXc0=;
        b=OAlsUT/Wp3a4X2wnVZq14eshemUi0NgsWpz/YKGzsR/l2KpP/iPil7fH4SFZGkEGgm
         vD/IcYSiu0zyoM3j2Zc3RD2lWiqkjLAHpAvU3AgBpQbOfcCD0Nr6IHf0fwH8lwKP9Ql2
         UE8OTCz1ajSlJ/Hx44AJj/KbPj1hF/KUhLb5z7gI7v3KUD5Gb1VuD+8W+d/xgTwtkgXF
         9/DxeyqeJuDjmghaQ5kF1965UpXWiGj/JtiIgAPVm/U5zWoQ6+AIy0PSmnf1sGjpriQx
         PN8ZyYqDFsxrCL63cphB3Z7a1v5yNwv0fc534/DY0ltVS95ils4aqqLYKn+tytp7ziQS
         ICaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2myf09f32ZWUhYNf41DERUMamAn2ogmeGu9WTISXc0=;
        b=b46iblTRDpIkHoZgn/8psFRm/h80AJpwyKL839e7LiFqZ3iBjqchEL9/fBqLdVyGod
         M87sUziqe+xJQW5NRLF5Kym5WcdSkE/dpZpV1qpL01UztlyPe8qqP3iD04qajDkI0ZH9
         DRcyOjflmv7vi8WWiImrgb04cOj6uGMin3AjkJOgUa6Prr2w4ieFlna3k8wcL41m+E49
         O/CRpTJtqQ719Dc9IRsqwJKNHW/n4mBEvg/Jx1qCJ2U6daAddTwa7byPfk8xL779JCXv
         4Q5uDVkqSfQY8yUeOqa8WlKra0qp9c7Rj32gjPVWS0Rna6tD9R4TP2rmcFn0CEj0npHp
         usFA==
X-Gm-Message-State: AGi0PuYzobhrhR03L8Z+Io2sAGsTui6gcafm4+ZWyDtjRbwtjKELG8s9
        U/nwcxJeiv11rkWaeQddzX0=
X-Google-Smtp-Source: APiQypJfy3bPqmxPrzBaaeeGnIbAM49xUbg7e5n7WYwWNokwAWsieoUdMDlNtfJ/jTzTIrKfUjkv6g==
X-Received: by 2002:a62:1b87:: with SMTP id b129mr14299525pfb.162.1587575417413;
        Wed, 22 Apr 2020 10:10:17 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id n16sm28549pfq.61.2020.04.22.10.10.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 10:10:16 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 0/5] expand meter tables and fix bug
Date:   Thu, 23 Apr 2020 01:08:55 +0800
Message-Id: <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The patch set expand or shrink the meter table when necessary.
and other patches fix bug or improve codes.

Tonghao Zhang (5):
  net: openvswitch: expand the meters supported number
  net: openvswitch: set max limitation to meters
  net: openvswitch: remove the unnecessary check
  net: openvswitch: make EINVAL return value more obvious
  net: openvswitch: use u64 for meter bucket

 net/openvswitch/datapath.h |   2 +-
 net/openvswitch/meter.c    | 303 ++++++++++++++++++++++++++++---------
 net/openvswitch/meter.h    |  20 ++-
 3 files changed, 247 insertions(+), 78 deletions(-)

-- 
v3:
* attach_meter return -EBUSY, not -EINVAL
* change the return type of detach_meter
* add comments
* the meter max number limited by memory and DP_METER_NUM_MAX
* fix checkpatch warnning
v2:
* change the hash table to meter array
* add shrink meter codes
* add patch 4 and 5
--
2.23.0

