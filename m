Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CD4C0FCE
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 06:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfI1Esd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 00:48:33 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37413 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfI1Esc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 00:48:32 -0400
Received: by mail-pf1-f173.google.com with SMTP id y5so2633690pfo.4
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 21:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HmnsmSczHg2qs47zNKshBIIR0oNk9IrKTs2jKTkK+Jk=;
        b=NKNNJNEgbqaihj8xq9WIcnJeomQSIdE4a3EZQnK9AVOFsxq2zUsqHQqI4l9bbfUI5b
         UB3BS282ZjtNeJlR1zavC651rlbJUDqkR/wDptj0DBJ+zCnVeW+Y+8AFmxE+dcwxHabH
         I5KxTArlFA0nf5AQVu8i5wWVEwe9vNLEdiqj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HmnsmSczHg2qs47zNKshBIIR0oNk9IrKTs2jKTkK+Jk=;
        b=Zy6pOX/5ro9a/ejUpSVlGHYioEJNsoHNP9gJysFUbLBb/7SER+PqQ80CbRUYvsrlD5
         U67CvDZ+iNKVGCdKPYmdwqwfat10vSBqZNerh/zwRQwkKYEx2hjp8SdwPHfNH8+9m2GS
         xjfMDjj2xAHWSD6E7E76DZJxzN0g8elCwfvT3/o9GrfbjMY1P2KcoZu6JK/JHSVEbkaR
         n+lVuoe7j2+Ge4rNyq6JGfX96FhOEnv4jOB2stFL3j3sN3ulpzQwnfQXOaOPOCC533De
         Sk4Yp5uGCIPJQPbEagDe5YK6JivF0Bu21Y9N0e4UR+n5p+RtGOTX3+0O6BMy+NxIk8/Y
         y9hA==
X-Gm-Message-State: APjAAAWZ5N1LVw+nB1mCU5+nFcXilAjn4keM732mnxkxOJZf9bhoyvMb
        NengskG9srX+9VxioTTPIQJAzg==
X-Google-Smtp-Source: APXvYqwrwZYNKe1npRfOLrlPbce4RQvy6LDC4imoN55lt+s3C2yoY+PxSmgDYX0Ho3YdQSGQkJxFZg==
X-Received: by 2002:a17:90a:35c4:: with SMTP id r62mr14261292pjb.17.1569646112142;
        Fri, 27 Sep 2019 21:48:32 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id r185sm4335979pfr.68.2019.09.27.21.48.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 27 Sep 2019 21:48:31 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        stephen@networkplumber.org
Subject: [PATCH iproute2 net-next 0/2] support for bridge fdb and neigh get
Date:   Fri, 27 Sep 2019 21:48:22 -0700
Message-Id: <1569646104-358-1-git-send-email-roopa@cumulusnetworks.com>
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

