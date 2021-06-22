Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648003B10CF
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFVXzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFVXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:55:46 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FC7C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:29 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id k8so510042lja.4
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jS+w9MqJMCPmCvru/MriRzOYAmVBhyt5Fjp9X8NFXRE=;
        b=iSkUKN6yBQfLIfwr8H06SiAWgMiTtJzMcs58PoEIZhMLGhB0p0E6XcDePZZJMXON7F
         Qi5Tr8nkl1e4PR/YKPTbuOSIay1M0CXtpw8z89/Xj/np8fKHcqoBSr9HbB4ovtCTRMhB
         eC2QTiEa1s7mX8omQC8hWaSz+dCsnwsVzMiG4B2uwK0jC8XlkTugmToAceWWOHaIAWf9
         XlBERB5KG418MA82OlzABwx84FzdBRxohMNDsRmATE1eHCT528ubc7f3yLlwq7dnM5lS
         zU/BLr9fZTcKecPudSLexhKwDHpppH2FNzp9rdjCVr1WJRwEy9JSmPOseMhQemKcEw4l
         chsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jS+w9MqJMCPmCvru/MriRzOYAmVBhyt5Fjp9X8NFXRE=;
        b=rdDeSTaQhRqwtk92/598Bk6IF/0P0owKsHNGBtRid3n3MIldGUj8n8Ay6lk/71lA7R
         yf0uF/DjD8UJKBVlpYkYiIgDz3OD+gcqpoWfPP3XEIUYaQt9iXNgifWU41wJL6Ip2jEx
         qZYtSfZKa0e201Gvoc9LJbZGibB77w/rwhYfgK0Kla9KLy2ZzH9fJYm9ZTbNmXzlGszp
         abDlkgO2S/j4MSZdJGKdgGS+doYMA4yBDwghOhz4uQcrSXOwGLJfq3bhqA7CS7zjoh4i
         6yb2zs49bS0p5HCE/IhBYhBXpOyfgWzhKy+Te/ODZC7yoK5+NPSZ3zU6kgMe9HaUg8t9
         1JUw==
X-Gm-Message-State: AOAM531OC1T5Vqvv2ZG6C85aZJV5OOlrNDDV/vHurpcjzHiFiKl9DVUG
        fCHb4B96luT5629idu6h3wY=
X-Google-Smtp-Source: ABdhPJxrfHFO+SkDFYQOKrjaswCJoxqTjFJApVR09A2il8ncvrF0xDNA0HgRo7dINdMVWTJ5MTgl5g==
X-Received: by 2002:a2e:b0d2:: with SMTP id g18mr986611ljl.145.1624406006135;
        Tue, 22 Jun 2021 16:53:26 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id y23sm1680092lfg.173.2021.06.22.16.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:53:25 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next v2 0/2] ip: wwan links management support
Date:   Wed, 23 Jun 2021 02:52:54 +0300
Message-Id: <20210622235256.25499-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This short series introduces support for WWAN links  support.

First patch adds support for new common attributes: parent device name
and parent device bus name. The former attribute required to create a
new WWAN link. Finally, the second patch introduces support for a new
'wwan' link type.

Changelong:
  v1 -> v2
    * shorten the 'parentdevbus' parameter to 'parentbus', as Parav
      suggested and Loic recalled
  RFC -> v1
    * drop the kernel headers update patch
    * add a parent device bus attribute support
    * shorten the 'parentdev-name' parameter to just 'parentdev'

Sergey Ryazanov (2):
  iplink: add support for parent device
  iplink: support for WWAN devices

 ip/Makefile      |  2 +-
 ip/ipaddress.c   | 14 ++++++++++
 ip/iplink.c      |  9 ++++--
 ip/iplink_wwan.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_wwan.c

-- 
2.26.3

