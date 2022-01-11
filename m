Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCDB48B4A1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344432AbiAKRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiAKRym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A8AC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id hv15so139463pjb.5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8j/zkv1WSNyDdSRd2mI2tr1wtJ2+eBijzIudLJqfL9o=;
        b=mZlE219pdPDyPaxQitkjPK9ZhFyujLI65VB1j6lG9i3FILiOD2dV+1rOBizXnj7z8J
         ET1JVDAMRTYiG7gmfFFI2/9dl44cqLSD90bDkK7+DHrs72J2HSHj4B/Ilzp6GeKQFlBy
         fioBQWlsmEojTelr5YlPdCeknctcWniRZYRZin0xExocNpUcS0uWpt9A/1xL5IY7XCWg
         6knCa0lYj3jic6UuFdfCsUD1vZCwWJuXn7Wvurj5XJRwIel8KHMQVVIp8ta910WqSvV3
         arEl5WJTC6ykbeaDORi01WOTMRrljSOjHb91Vc1CraSdPU3ZaWq4lcTMIzdg0fKOBCuN
         9aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8j/zkv1WSNyDdSRd2mI2tr1wtJ2+eBijzIudLJqfL9o=;
        b=knmCZgO6wQv1b/ZtoKIZopI6jvRglk+1cWMBbICuQPKhuOx9a1CE9m7L+VWfLgqEjz
         WsUvQCsqg99b245PmgQB/78816Qol5N3832EsUOyX5qHNG1Y40r8IwoVjx3VZjQaeX1n
         x0WJ0q8dvtyspVShX0ad9LHwHgmtpQjm/6T2xqzsopTxr1IG/VMdXJTmr0wDTdmO9r/Y
         iAnoSBJd7M4OOS62SCEjwHwlwX8QlMf38taa1fy1WX3O19IvS4KoFHueN74XntTEG9Uw
         15LjhNHEF/EAEczVcabkqKgccms3ieAklC4qrp7AgB5fxiLrxYD7jT7wXsx/KfHkJkMm
         qtmw==
X-Gm-Message-State: AOAM530ePt+vzgde5SsKoT4U1xfZGDKh8dh5GduoSiVi+/MKcKbZLwJW
        AD2a4smzVQXD+4xtr5h0g7akI3wYnRweeg==
X-Google-Smtp-Source: ABdhPJxc4hUsn+rJbP3Y4I6gFs9jRxQGACTyQIaBluq2k0YHh3nx8j9FjVUhKoSICF7in2tDL28cxg==
X-Received: by 2002:a63:89c7:: with SMTP id v190mr5052218pgd.335.1641923681848;
        Tue, 11 Jan 2022 09:54:41 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:41 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH v2 iproute2-next 00/11] clang warning fixes
Date:   Tue, 11 Jan 2022 09:54:27 -0800
Message-Id: <20220111175438.21901-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes iproute2-next main branch compile without warnings
on Clang 11 (and probably later versions).

Still needs more testing before merge. There are likely to be some
unnecessary output format changes from this.

v2
  - use print name value


Stephen Hemminger (11):
  tc: add format attribute to tc_print_rate
  utils: add format attribute
  netem: fix clang warnings
  flower: fix clang warnings
  tc_util: fix clang warning in print_masked_type
  ipl2tp: fix clang warning
  can: fix clang warning
  tipc: fix clang warning about empty format string
  tunnel: fix clang warning
  libbpf: fix clang warning about format non-literal
  json_print: suppress clang format warning

 include/utils.h  |  4 +++-
 ip/ipl2tp.c      |  5 +++--
 ip/iplink_can.c  |  5 +++--
 ip/tunnel.c      |  9 +--------
 lib/bpf_libbpf.c |  6 ++++--
 lib/json_print.c |  8 ++++++++
 tc/f_flower.c    | 38 ++++++++++++--------------------------
 tc/q_netem.c     | 33 ++++++++++++++++++++-------------
 tc/tc_util.c     | 20 +++++++-------------
 tipc/link.c      |  2 +-
 10 files changed, 62 insertions(+), 68 deletions(-)

-- 
2.30.2

