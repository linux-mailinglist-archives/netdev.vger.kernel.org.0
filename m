Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C54DD9CD
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJSRhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 13:37:53 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44486 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfJSRhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 13:37:53 -0400
Received: by mail-wr1-f50.google.com with SMTP id z9so9413043wrl.11
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 10:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnvKGNx67YCaMXZynTd6OYUlFpbgmHqFCOYshnCd970=;
        b=OyBFfkx+cVMNv9AecjSV6o/LRPSfYLnkgj/yX0DkDctVMtwtK5vRhXCXOT4RMzuMRH
         xACYBGKgMo7Qq49flwUB8eNWTJa6txdDIGk5U+SwjR2zQ15Mnk/XIXZl3G2WI0bKkOfj
         yV/uCivUuzgUL09DSj/simsL2r1npK+xl0UVtEn7uFpMpLqWFZMcBegNCsZlbW8i/mc8
         nzqXx4pOxrycXu7zPn+CjMvWEkwyah/Q/W6LQhWfX+NvWwdHbuh1JowBDrsgXiNuh93X
         lQBPQCFDD081grQ4tUmPYz09VTpta1gYFi6ps4SXiWEYWOPhFdOyDZz7WTAqPKjpbcCr
         VKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnvKGNx67YCaMXZynTd6OYUlFpbgmHqFCOYshnCd970=;
        b=RAhsJZpQb+z352GoLPTZ4B8cantYEtNz0WlXdlvcmNzJIfw+bDWtE3xYSh3b2gq7KC
         2aZ+rRKPKEyCrQCWctvNjap5S6KyVcr6WwJgb3K39ILD9is9cfLWV8ztOAV/R2gcIn/y
         e8MLl1STiTRaWoycmbKU0jc+4HKY33yYzRdY7kUg8K43saLIdDpnaXLXbtCHN8s61Az4
         cwL3PqCLNKAq2s472riM3AERRLIjRV00ndf69IyFdnpyXWZ3z6qMLSvrDtWVNv5B5aKo
         QyKqRICuURhtX0kTBrQH7bEzv7Z8nw4k8IuGjPmAEEZNPaLxgAJ2kXVLahlgTov0TOE7
         8mRA==
X-Gm-Message-State: APjAAAXazQmiY4jZl3euQ6ZpVvHsPYLWUNajSPye6ng/b5/QY8QAJdec
        Z63vj2ckNjlCK/aCwW9soKRGMiiNWn8=
X-Google-Smtp-Source: APXvYqzimYJa5w07soQVCzrHOKFdZ52bvSgBblxaLiF1m/5N8/tc5WmWAzZo+xcTEyOJznSAFzb6BQ==
X-Received: by 2002:a5d:424a:: with SMTP id s10mr7852032wrr.108.1571506671099;
        Sat, 19 Oct 2019 10:37:51 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id g5sm5505876wmg.12.2019.10.19.10.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 10:37:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v4 0/3] ip: add support for alternative names
Date:   Sat, 19 Oct 2019 19:37:46 +0200
Message-Id: <20191019173749.19068-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for alternative names caching,
manipulation and usage.

Jiri Pirko (3):
  lib/ll_map: cache alternative names
  ip: add support for alternative name addition/deletion/list
  ip: allow to use alternative names as handle

 include/utils.h       |   1 +
 ip/ipaddress.c        |  20 ++++-
 ip/iplink.c           |  86 +++++++++++++++++-
 lib/ll_map.c          | 196 +++++++++++++++++++++++++++++++++---------
 lib/utils.c           |  19 ++--
 man/man8/ip-link.8.in |  11 +++
 6 files changed, 282 insertions(+), 51 deletions(-)

-- 
2.21.0

