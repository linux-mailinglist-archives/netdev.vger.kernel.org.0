Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3F53110F8
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhBERhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbhBEP5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:57:35 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200AC061786;
        Fri,  5 Feb 2021 09:39:42 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id f2so8686072ljp.11;
        Fri, 05 Feb 2021 09:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zq2tq6yHR4pXHFIL3vLqBUHAT4JaMWz+MiyU0v1vu0g=;
        b=ckxEdHFrze9QuOrIRS+B3/v6N2YraDq30qDnuUaSEdKPKbzDHr5v+Gt+ggms8kDxLb
         KRM67GI+AlAc0Mt9x3QXeMnLuVERRs3HzqIK1OYS9DWNRSDt8+CE3wu+7+S/y2kCH+ZN
         vm2jkwZoTwkLSFKNvCIpag+GwrGsqgSkdLzvOjljamTXzVmuCKqyeQ2SDJrakIrbO0Gq
         iNL+1goLIoCL4vK72mfo4AskKtq8tPdIFU9KeCPLZAqMbqE3ck7e5KVHALAgfByEZmtI
         sOpY9Z4FpCfRoEvCtAY46x9yZ7244UyytkRl9nU5E36B/ExGPZnsadsvizd1w2jn+6Lv
         twfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zq2tq6yHR4pXHFIL3vLqBUHAT4JaMWz+MiyU0v1vu0g=;
        b=aSBWAdr6jXyhAKpKiUEDM3CC2CMy7BO/7bkur5qimc0OnPEfGO/wuUb+LG1ZZBD8CT
         cPzzi/pR9r1CNNypsTNM8PIR7bfX6w55SbeVHGSxjYe0hcd7dZ8bJ149HVUpVah7KF0l
         xL3ug1Lduc2s4f8FKUhwtXFxlGdari2PekDYIR3pJnENFZnRDLJNxHYtNUqORgg1+WfX
         bla234jKA/xmcdeIxhle8GwPKYR0VydD/ZM8VRImQXnRQbtz8J+viQ3Vzgax8+szBQ8P
         d3UPFay2cri4MAZ1kSfY+SThoNQvW7pzzRAF8G6boGxYCfWL1rPjdc5X36YSN2JUU5MQ
         +8hQ==
X-Gm-Message-State: AOAM530ZWBu8XPRXcsuyqHuFFRDIaJOMSrRwQ+isszaQswWCFHU9zz5R
        W469Ek8/8CXe20nZ3NhAmFyI5mVXECugUQ==
X-Google-Smtp-Source: ABdhPJye+i4t95Pl5+mUsUtHEvOgzCgVI4mT0d2KP5HJBj+JAKY5Bw2XvHTI2RhQuE/h1RHgd0ZlDQ==
X-Received: by 2002:a2e:9f06:: with SMTP id u6mr3298965ljk.494.1612546781370;
        Fri, 05 Feb 2021 09:39:41 -0800 (PST)
Received: from rafiki.local (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.gmail.com with ESMTPSA id n16sm1053230lfq.301.2021.02.05.09.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:39:40 -0800 (PST)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>
Subject: [PATCH v2 0/2] usb: add full support for ZTE P685M modem
Date:   Fri,  5 Feb 2021 18:39:02 +0100
Message-Id: <20210205173904.13916-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This modem is used in ZTE MF283+ LTE SOHO router, and carriers usually
identify it as such. This series is a part of effort to get this router
fully supported by OpenWrt. With this series, all interfaces of the modem
are fully supported, and it can establish connection through QMI interface.


Lech Perczak (2):
  net: usb: qmi_wwan: support ZTE P685M modem
  usb: serial: option: add full support for ZTE P685M

 drivers/net/usb/qmi_wwan.c  | 1 +
 drivers/usb/serial/option.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.20.1

