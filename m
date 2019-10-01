Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A3BC2CB5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 06:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfJAEw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 00:52:29 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:42614 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJAEw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 00:52:28 -0400
Received: by mail-pf1-f182.google.com with SMTP id q12so7024584pff.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 21:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=OG0pkZNZcWl/U4txSf71sbo4PGMytDStDoGpMfRyMZI=;
        b=Rx+TmNNfDDTHiHE8+Z/qjqhNhlyxT4WKOqf1/4QVIBa6cRy5HJz3dNBQvtuUQi/wys
         +ElZLxF3wgMbk29IzGgXAULSnTxe5R7JC3//m6t31vJeYQ76pZz4fegBaiT3CdtmHpE8
         KrYED2IX9UvnFswfN92L+w6HgaP+1G7HgZUU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OG0pkZNZcWl/U4txSf71sbo4PGMytDStDoGpMfRyMZI=;
        b=tn8UGjy6p3wYAKS7DHEmY/MpITAiNtNmF/4VsUqGS2OaARGF0J7T20L7TyMCKDOnEA
         r12vR627opTmadV58U1Jxw8FmGum7Feaaj0R4GnDdQoBIyZewtoHkgI8SVXWCvO2xf1K
         ffKzZKmApMNU/zsjtz9+4NV4T6AWZI0101RSZyU6z3bmgUxm9r6TYDIEfSxrrl/yT2Zq
         ais+pV3MBa2Rp0p3fFz0gSi9+CKkD8V9RVJCV65B+CnpjHTeoDSZSUEfOl/IobFQVrRP
         3DjFOeXp60YVCi5FXavtakAoIxPDV7puP2C0IKhcjjM6qFbBHYNgpgSxZRwwaGNN+x1L
         cr5w==
X-Gm-Message-State: APjAAAWjf0yCu0V9fA8cPIXqnwADFO/k1ajEFTBtfl361EXc2RvIzkRM
        HWZjrDYtycQcsQZjXdbIJHeSbw==
X-Google-Smtp-Source: APXvYqyq2d2WD6DtflEVcf330J60sWK+O96FdPfhvdpUKccLEM1J9pW/+uMRrOm1OOxDgyTthjAJRA==
X-Received: by 2002:a17:90a:fb91:: with SMTP id cp17mr3334968pjb.51.1569905548046;
        Mon, 30 Sep 2019 21:52:28 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id h66sm1896638pjb.0.2019.09.30.21.52.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Sep 2019 21:52:27 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, ivecera@redhat.com,
        nikolay@cumulusnetworks.com, stephen@networkplumber.org
Subject: [PATCH iproute2 net-next v3 0/2] support for bridge fdb and neigh get
Date:   Mon, 30 Sep 2019 21:52:21 -0700
Message-Id: <1569905543-33478-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This series adds iproute2 support to lookup a bridge fdb and
neigh entry.
example:
$bridge fdb get 02:02:00:00:00:03 dev test-dummy0 vlan 1002
02:02:00:00:00:03 dev test-dummy0 vlan 1002 master bridge

$ip neigh get 10.0.2.4 dev test-dummy0
10.0.2.4 dev test-dummy0 lladdr de:ad:be:ef:13:37 PERMANENT


v2 - remove cast around stdout in print_fdb as pointed out by stephen

v3 - add Tested by Ivan. and address feedback from david ahern


Roopa Prabhu (2):
  bridge: fdb get support
  ipneigh: neigh get support

 bridge/fdb.c            | 113 +++++++++++++++++++++++++++++++++++++++++++++++-
 ip/ipneigh.c            |  72 ++++++++++++++++++++++++++++--
 man/man8/bridge.8       |  35 +++++++++++++++
 man/man8/ip-neighbour.8 |  25 +++++++++++
 4 files changed, 240 insertions(+), 5 deletions(-)

-- 
2.1.4

