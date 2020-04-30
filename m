Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1651C00E5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgD3Pw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbgD3Pwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 11:52:55 -0400
X-Greylist: delayed 73 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Apr 2020 08:52:55 PDT
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E825C035494;
        Thu, 30 Apr 2020 08:52:55 -0700 (PDT)
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 1C2A22E0DF9;
        Thu, 30 Apr 2020 18:52:54 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id IzgCQHeQg3-qqWCa3ML;
        Thu, 30 Apr 2020 18:52:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588261974; bh=IwWYfZ95VkylOXCM3VJO+DrpjWTgky1qDpEwYCiPyRI=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=PCtz+7jQwduzLeildSxc/5dR74mBbGa2uoIZoH5jN8kj2hK1CRQd2zh2ID5T4qY64
         zYOHRLWdTaVkHv4Hv67Iad6lDL2VXmzdaFy8kznlr6w//0T9sVY4yIw2i7hS2Yt8VG
         Cfmjv3HLzEjbwbefPwdxQz2S2CazZ8foC3zasQcE=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.215.84])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ItUiLwion6-qqWGaRBP;
        Thu, 30 Apr 2020 18:52:52 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH iproute2-next 0/2] ss: add support for cgroup v2 information and filtering
Date:   Thu, 30 Apr 2020 18:52:43 +0300
Message-Id: <20200430155245.83364-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds usage of two proposed kernel features:
cgroup bytecode filter (INET_DIAG_BC_CGROUP_COND) and
cgroup v2 ID attribute (INET_DIAG_CGROUP_ID)
for discovering and filtering sockets by cgroups.

Dmitry Yakunin (2):
  ss: introduce cgroup2 cache and helper functions
  ss: add support for cgroup v2 information and filtering

 include/cg_map.h               |   7 +++
 include/uapi/linux/inet_diag.h |   2 +
 include/utils.h                |   4 +-
 ip/ipvrf.c                     |   4 +-
 lib/Makefile                   |   2 +-
 lib/cg_map.c                   | 133 ++++++++++++++++++++++++++++++++++++++++
 lib/fs.c                       | 135 ++++++++++++++++++++++++++++++++++++++++-
 man/man8/ss.8                  |   9 +++
 misc/ss.c                      |  61 +++++++++++++++++++
 misc/ssfilter.h                |   2 +
 misc/ssfilter.y                |  22 ++++++-
 11 files changed, 374 insertions(+), 7 deletions(-)
 create mode 100644 include/cg_map.h
 create mode 100644 lib/cg_map.c

-- 
2.7.4

