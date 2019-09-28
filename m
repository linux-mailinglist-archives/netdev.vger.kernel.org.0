Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71578C121B
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfI1UWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:22:16 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:34689 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfI1UWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:22:15 -0400
Received: by mail-pf1-f169.google.com with SMTP id b128so3390112pfa.1
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PI0aeqUvl2AwoOKbB1apLia3frZ57mixNuwie9TpFMg=;
        b=NWQT3iZjUjQdWikkN7Q9LZ5guTWayeZVjQdWtHm+ZHBs5weqYmjNtRboohKMVfzJ60
         UQB4GPgi3dS+fpdfHZ6CzjT7bswhnY1L/bi+DeQ21T/KIBjgLBQLE+41CF74T/Rypw37
         fFHiAsLqG+LWmsR0AaMl52PJY+MgiioaEPr8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PI0aeqUvl2AwoOKbB1apLia3frZ57mixNuwie9TpFMg=;
        b=JosWDHVWoBxc+TwJ6jKldVLGtpqXbfhgOkZXlYsPtltbf/mIbmfBSav1oJjleGexYD
         YdwHlZkVoS5vrA/2sCIMrTPkxl+Nuk/hLCkwF2svKY1iRPvWyfXPTdtMmH4rsXOa4g29
         6vvOPAWPRubAJfcJ8ay5CVCfF1K813A6nNtoNsd4tyU42mQu1AnCksW9edF/3980b1K7
         bFEdb6Vt7bZtRCm5EocpkK7Ke7duuxyENT46y+P++PGuUaiyr4CY2h/JsNTAdTcUx7UF
         gHfkLtWBKTaF06jKWfr5SkRzW0lvkEhwRICNfocxEPdRSYmz/t3wpgaM47hhbdvJiz5G
         uFoQ==
X-Gm-Message-State: APjAAAWQZQfDMp/6QfOqqyol0DcpAakAENwEzeseCUogaIdPjACJ7Wei
        NCCeDo7g3vZZx20SInHsrb5B6w==
X-Google-Smtp-Source: APXvYqyzM7O7jTuhzZfGyGI5d0iWtBI8z/aE+HNIMXRy7sEXvoyyFXaZibaaPkBec5qxOuUfV7sDGw==
X-Received: by 2002:a62:e416:: with SMTP id r22mr12438815pfh.145.1569702135113;
        Sat, 28 Sep 2019 13:22:15 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id f3sm8325160pgj.62.2019.09.28.13.22.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 28 Sep 2019 13:22:14 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2 net-next v2 0/2] support for bridge fdb and neigh get
Date:   Sat, 28 Sep 2019 13:22:08 -0700
Message-Id: <1569702130-46433-1-git-send-email-roopa@cumulusnetworks.com>
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

