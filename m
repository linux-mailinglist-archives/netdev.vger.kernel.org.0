Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29818D748
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfHNPhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:37:38 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:36949 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:37:38 -0400
Received: by mail-wm1-f49.google.com with SMTP id z23so4866791wmf.2
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/0s2IcTQuAGAyzHbYITLSI+/AM1NtScquQY52Y6KN8=;
        b=RNKOsHCjwahQSDJH8pAMFssYft51y0nyS+f9p15UEWrMWqZWy4equPSA1EypnC/DCG
         wA4+WtgNXucBYloi+U7O2nYWeQ/oICyebWEMuabCj9MUE8BeAbn40XVFQWEKAekouCik
         r7j8ICilwmbABryLLDv7DLIXO9qzVV1QHjZjkpiGFQqfb7GBVlRpJKml3X8EM4iERHgr
         wTr9Yl59g2mv1c6ASmc1rAiwIdWy+kgT+VMnw3XC6EtqyPhhT44ydduQIsUUzIMLaC3G
         YSo9EEdarOr6eXwHO+tWADYaO2fHpP8yC3e4cMKTheSrPZuNuNEbJmb+9Kb3pY6H2X97
         Astw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M/0s2IcTQuAGAyzHbYITLSI+/AM1NtScquQY52Y6KN8=;
        b=VPuZjRbORRN8BPUz9eR7xpGUqSSD7pj0OG7SOc7ZSR5XV+R+EW4KSxr+8ftIHPNtGV
         sjRf9x6m6uPGjpeUA+PGBkX57w3j9Zr46wnmRtVN5fey3C/KfXFQiI/YmVDlqVE9DzWl
         YZB8a79zb7U9EW1nokYxnxbjpa4Db35lyX/LvHAj6LfNFvs2XkJiGaZs6TkXY8oKq8up
         D6g7EUEZqbsa9xw0hYmPAVl7f593CLDiQHaSANyBsx9YNf34Ye7TvFFZpiYUxZAXMtBz
         AUmdLYFPYIllRiNDkumxIMGwsFH+zKtdg83I00yjtESorw41v+0MYHDLSk33S0jft04i
         1L3g==
X-Gm-Message-State: APjAAAVkvglVXe9XKDguyFFU+b9lnYbKZ3lkXPNvInp1i/PMyLLYUb1O
        3YBw1oP8tfpnJ3WhLE+Bf9MpI8RsOPE=
X-Google-Smtp-Source: APXvYqwTelhiHV0ispMbjCHaUNToEF//U4DasRx4r8J1NGRWTRTBs608vtaSTwbN1xpXuOTsZFA/lg==
X-Received: by 2002:a7b:cd0f:: with SMTP id f15mr6252079wmj.86.1565797056054;
        Wed, 14 Aug 2019 08:37:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e9sm242366wrm.43.2019.08.14.08.37.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:37:35 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 0/2] netdevsim: implement support for devlink region and snapshots
Date:   Wed, 14 Aug 2019 17:37:33 +0200
Message-Id: <20190814153735.6923-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement devlink region support for netdevsim and test it.

---
Note the selftest patch depends on "[patch net-next] selftests:
netdevsim: add devlink params tests" patch sent earlier today.

Jiri Pirko (2):
  netdevsim: implement support for devlink region and snapshots
  selftests: netdevsim: add devlink regions tests

 drivers/net/netdevsim/dev.c                   | 63 ++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 .../drivers/net/netdevsim/devlink.sh          | 54 +++++++++++++++-
 3 files changed, 116 insertions(+), 2 deletions(-)

-- 
2.21.0

