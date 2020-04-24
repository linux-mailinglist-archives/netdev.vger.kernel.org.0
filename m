Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0701B6A35
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgDXAIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbgDXAIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:08:48 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50859C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:48 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o15so3755674pgi.1
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CYWarLRsOY8jDrH+4qq27zO/eaW4JRLH+muudvIroVs=;
        b=Qv0JVCvT7jEHuSVBu8G9Ji1exBX0u7BQ0/K/y2Gxpzkg+AW0e3eoj1rSCZiRjQvkoq
         vFedt39y05Dk7Uv5ww4foWtuH41cq3amCafWVUTvcFkoyTePsKZQBPWPAzlWb/S8bi3B
         phVd2GKrAviRMM2mLzFIBvxdWCkvuLouLSAjvD5r+EetAQU+8klXIrJQSXfQ6L8pZju2
         Vr7GT2x9/7dC0HzHRvYXgh7C0rlyyPRY6NxLbG2lLHZ+Omt5bxGKw5SS9C1mWPIPY+Gw
         GuYktDnczzKSLVruO0mSgcWR585R39MJzeUqkXjNkl3x4jaxohR1f/sJ0dtYCBI0y1hG
         lirg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CYWarLRsOY8jDrH+4qq27zO/eaW4JRLH+muudvIroVs=;
        b=Hevi4eocEWrYX4X4v5lotLmghJwsPiM2Ij1WwmZDNpRIz1j/gPc2iIs2YnX/h9LTQM
         J/u7A8X4fgCgYYbq7XsoX4Vcgz3eSxxoibBUOfH1TH52556yrRtvXBnINWJ3PpGtoel6
         qt1QNaJ7oCsPCKUj/LS+uL7JA4qrrT49gZ+SVe15coLDlv6/bn34zZ43SGODYg5LIbSS
         pCbm78Wqwg2LFm9YiFigk9xl6zcAM+xFo7IZzuB1LlhynGgPH9YaWW+wGLWvXTXmIElO
         hxHxIhNrZID6P+bJQt6CVeIjDMZKhJK8ScJv+tfZC81DppQtZKLogHlTqM5LwktY/G75
         63xw==
X-Gm-Message-State: AGi0Pua7HKhgKTI3lVhJ7J+r1k/cW6WWkok3I5AcRV350Cj5jEzmIw0N
        4RPvwyutZFNGA/WSvb9hzEM=
X-Google-Smtp-Source: APiQypLcao1rsKiuuZaE+Y6OC+ix9JB3SvdvE90jBdvl0pd3R5G8ZXx01b3aqTrOICy125uvwJG0uw==
X-Received: by 2002:aa7:8a9a:: with SMTP id a26mr6077815pfc.77.1587686927885;
        Thu, 23 Apr 2020 17:08:47 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id p10sm3836100pff.210.2020.04.23.17.08.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:08:47 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 0/5] expand meter tables and fix bug
Date:   Fri, 24 Apr 2020 08:08:01 +0800
Message-Id: <1587686886-16347-1-git-send-email-xiangxia.m.yue@gmail.com>
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
v4:
* patch 2, fix min() build warning which found with gcc-9.x
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

