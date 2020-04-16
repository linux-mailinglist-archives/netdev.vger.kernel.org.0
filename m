Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B051AF2CD
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDRRZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 13:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgDRRZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 13:25:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CD9C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nu11so2524972pjb.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 10:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmnInVhSxEJ571M/gRpmFYBR6HRQDwpx2QscMw6sx84=;
        b=gG552lakYLmQDOOJ9bZhIIeHN37WVIvX5dz3h9uuKxE/aMlKAJ1DSQyy1jNmKj/eOr
         Bovo/CJbpWh5mb+TId5GtCYkiEvrJGNFJ2fiKiwiM3pc0tp2DMoRvOtXTBN7DYYtWb2z
         aEUdpFnoWsOxCSjJKpSPndijB/2MjOne4S5wcLS3YQMQ+rg13uDK/haCfwMIsJvvqZxD
         suTmvvQb59XarNI9cHg9QPsiZF8SUVLMWciYtrnrOYc4L4sIlAs4DigdcejXl7XQHnc9
         j5M7D7+pBS7RMbK6tMVzQYuMP3n7RGnqdUtLEg3fa3IkL1Aq5F2vgymFlUoZ6mz8udwq
         OUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmnInVhSxEJ571M/gRpmFYBR6HRQDwpx2QscMw6sx84=;
        b=NnsInZNtY2ePSuYaf9OFinkEruyVJBr9ys02dGc7/1v9UrWMvTZH/9PxFpJb8Na24s
         AZeg+8WcTGUw5SdrE5cFIs1r1D9GdgoGmZyCqjtIKyDMY0wmzcfnAa1K+CwF7k4mjXHs
         VGRFRvgIawK2xmpAzdcBRESyKaFJ5E7IRShhtNJPF/KtHYQMkhM2XodwHk/wH1NZpCP4
         lcjw1JZwNabCRVkXlAVPXl3VYDZHBdOAuGVJ0HKYDqSWoRRT9G8kT4NThafmHtuW9zu8
         5RkvOgcqaN3qhZfX+WQ5GYFzN+ug6CmBd563fxqB/udbjO55HuSXsU+sd7ZdcUYWmRe8
         Y0Mg==
X-Gm-Message-State: AGi0PuYJphx6vFgUibZPh+Wjw4nEmX1P6UA1QSFRX9Iis2CPKM4FHGvR
        VQOCXs21yGsUscbbu1bkfiJBpz8j
X-Google-Smtp-Source: APiQypK5kPVpTa3ZIXWBD37XLQ6RulrTnln/zqMCpMeHb7zzApdZOucgW2VoIEjw+O5drRTJaM8Iig==
X-Received: by 2002:a17:90a:9202:: with SMTP id m2mr1903717pjo.109.1587230706780;
        Sat, 18 Apr 2020 10:25:06 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([115.171.63.184])
        by smtp.gmail.com with ESMTPSA id s44sm9329251pjc.28.2020.04.18.10.25.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 10:25:06 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, azhou@ovn.org, blp@ovn.org, u9012063@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 0/5] expand meter tables and fix bug
Date:   Thu, 16 Apr 2020 18:16:58 +0800
Message-Id: <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
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

The patch set expands or shrink the meter table when necessary.
and other patch fixes bug or improve codes.

Tonghao Zhang (5):
  net: openvswitch: expand the meters supported number
  net: openvswitch: set max limitation to meters
  net: openvswitch: remove the unnecessary check
  net: openvswitch: make EINVAL return value more obvious
  net: openvswitch: use u64 for meter bucket

 net/openvswitch/datapath.h |   2 +-
 net/openvswitch/meter.c    | 227 ++++++++++++++++++++++++++++---------
 net/openvswitch/meter.h    |  18 ++-
 3 files changed, 188 insertions(+), 59 deletions(-)

--
v2
* change the hash table to meter array
* add shrink meter codes
* add patch 4 and 5
--
2.23.0

