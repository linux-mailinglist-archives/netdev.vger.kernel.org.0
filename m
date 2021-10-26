Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5875B43B524
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhJZPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJZPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:12:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218F2C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:34 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l203so9900829pfd.2
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=h7c6opOGxSxW8HrwrQi9vaspPw2bxvVZPvGy6MAQkko=;
        b=HAHQsERYYMXIIEZTkam8ndKhzQAy2auDVUTzWLviPI8iRzZrReOwsYnJuk9Rh2k4C2
         5T/UY29eq6TYdATxuQHFRm8h4OYcUFBDVXUhSzmLYlWTDBX4pkQKWewAu0U2iMDwAwZZ
         HfFD8n1P1wXjSJFVqCrZp5MK0c+mVKzzavdwHRxiHc0vas6GIzRtaJFy7rKRnbgnMxFP
         KRgBjFgb1RwhO5KDVDdYZKL7NakRgaCnVxBKsdV4mp30y6fbD4g6quHD2zPUNb+9xs7M
         Qrf8JyZf9fTG7j2OumEKdjX5glDlqWYLAUcJMCHZELppFepJmdSOHXZM8MNi0w1I4fnD
         eY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=h7c6opOGxSxW8HrwrQi9vaspPw2bxvVZPvGy6MAQkko=;
        b=zPl+NeYQOxfvKZSxNTKj0gqLcSCEegva0WlhK0q+VUFfmfZx8ioCEj+3MQvzXuQhYc
         2Lmseb0RxnGcnY4jbSkofzQ9drL35YE4jg4Ef7xB0U1xNVX7+A5yDyFFNPs79kuurYDZ
         Ru0ElD8Nr2sEta7Z7bs8Fu35+wdWOLR2LPOzJyvr4CY9+pqpcGbhwoMULRQJMi/fRPYR
         YI9PrVVR73XN0LYI4YgZB9Z2J3QbSR8pBLhGy4mZSmj8pv7f892DesmLmr1G4GnBNTNg
         BWavWCXhSt9lKbmmYtz6U6sPVXjLFUdgxhwjWPt4+86z7YDwFhSMsQm0+BWqIeHl4wr6
         DvYw==
X-Gm-Message-State: AOAM530Rj7NJK8rzq6K3IPgFC55xcKInbxW9hWgLwF+dKwhSTDbRecNe
        p4UNNScOIQPFOaCZo1j/1fc=
X-Google-Smtp-Source: ABdhPJwa+sIjFnWc2lbuPBNwVohujubBgq6elOYSexay3sedmd+RPnig1qjQKFt77vbD2+0IMIBMgg==
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr23692164pfj.76.1635261033581;
        Tue, 26 Oct 2021 08:10:33 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id p1sm10911009pfo.143.2021.10.26.08.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 08:10:32 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next 0/4 v4] amt: add initial driver for Automatic Multicast Tunneling (AMT)
Date:   Tue, 26 Oct 2021 15:10:12 +0000
Message-Id: <20211026151016.25997-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
https://datatracker.ietf.org/doc/html/rfc7450

This implementation supports IGMPv2, IGMPv3, MLDv1. MLDv2, and IPv4
underlay.

 Summary of RFC 7450
The purpose of this protocol is to provide multicast tunneling.
The main use-case of this protocol is to provide delivery multicast
traffic from a multicast-enabled network to sites that lack multicast
connectivity to the source network.
There are two roles in AMT protocol, Gateway, and Relay.
The main purpose of Gateway mode is to forward multicast listening
information(IGMP, MLD) to the source.
The main purpose of Relay mode is to forward multicast data to listeners.
These multicast traffics(IGMP, MLD, multicast data packets) are tunneled.

Listeners are located behind Gateway endpoint.
But gateway itself can be a listener too.
Senders are located behind Relay endpoint.

    ___________       _________       _______       ________
   |           |     |         |     |       |     |        |
   | Listeners <-----> Gateway <-----> Relay <-----> Source |
   |___________|     |_________|     |_______|     |________|
      IGMP/MLD---------(encap)----------->
         <-------------(decap)--------(encap)------Multicast Data

 Usage of AMT interface
1. Create gateway interface
ip link add amtg type amt mode gateway local 10.0.0.1 discovery 10.0.0.2 \
dev gw1_rt gateway_port 2268 relay_port 2268

2. Create Relay interface
ip link add amtr type amt mode relay local 10.0.0.2 dev relay_rt \
relay_port 2268 max_tunnels 4

v1 -> v2:
 - Eliminate sparse warnings
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Use CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY
 - Fix compile error

Taehee Yoo (4):
  amt: add control plane of amt interface
  amt: add data plane of amt interface
  amt: add multicast(IGMP) report message handler
  amt: add mld report message handler

 MAINTAINERS              |    8 +
 drivers/net/Kconfig      |   16 +
 drivers/net/Makefile     |    1 +
 drivers/net/amt.c        | 3300 ++++++++++++++++++++++++++++++++++++++
 include/net/amt.h        |  383 +++++
 include/uapi/linux/amt.h |   31 +
 6 files changed, 3739 insertions(+)
 create mode 100644 drivers/net/amt.c
 create mode 100644 include/net/amt.h
 create mode 100644 include/uapi/linux/amt.h

-- 
2.17.1

