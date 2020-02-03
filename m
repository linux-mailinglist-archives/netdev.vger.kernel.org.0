Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71751150180
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 06:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBCFkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 00:40:07 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:37660 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgBCFkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 00:40:07 -0500
Received: by mail-pf1-f179.google.com with SMTP id p14so6952634pfn.4
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 21:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b78MPDv27w2VH0Ys8reOzwsLybXz/a8z4MKbMmewv30=;
        b=TXtwTso0G1xKPh64JiDm1Q2OKN83T5QDuSRb+XzDdRFyYDGqMVuiRPat+M0OdZDvYo
         N/ZpDtSiqRWMve+aSWO5Tk5RYydM2ejaoLmjMKfwRdT6U6vzaTsgb0SwWCk+DummvI8I
         1qNZSP1wgXD3qCirMHF2IyL5WCCz8+IfaZ1NPpOxd2g+TXamaaYFEyNcpI0gRtEA3Xfo
         y9FSwJKIESL67P1uTJLrUhpoWsf++k79Bkrcd5kn3BeRBWzEPwuk8s9H5h++h2O0BwU0
         w786vxS2Gw2fVu459wSxliCIW9B8Da6DB9PMvaHEi+Ihkv7jxkKgH2p/BVr2rvoDTJ2o
         T2Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b78MPDv27w2VH0Ys8reOzwsLybXz/a8z4MKbMmewv30=;
        b=eL8yIsBQspCXnaif8vT/UaTYDlzczqd4PqXdqqaFZxiV15Ag7j9nNX8Iz5OLekYINf
         P4wIJcVLHI9MKH9OI1ud6v/JhsSsLzJVIL8b/FBVqW3JvIJcV3l8+QWfq0DlIFnRIhZ2
         yDCSvrc0kDNtjs1OKKxStFJCI9pOMUqwin6UlzUtVdrCJNPTzAMo61FMYl4/o9owGKSQ
         oGs8ueGhC3q6OP+xqfRTw3H4Sx1/zynD2B4zf/pfCEfzRXVGFIMaYz17zYnYyTEv75eN
         bF6ZZH4mUzd5cAj1qoufQOBv2jNKFBoO4c3HuiZMG97xoaQJx7NnrtJ/pCs9r/1hyoZ6
         TO4Q==
X-Gm-Message-State: APjAAAWWdLKmckPOASANY9TISIqaj9HCMJPFZF/FF8sPc6Gsv6Fv0Fvm
        0mfTR4SOOO7IBYdxq3v1HS7P+/UE
X-Google-Smtp-Source: APXvYqw62Mb5cCpkXHnzROaNvdVIeX/63ndVcOl8GnvZPt2L+PKf+JVKk4co6z4otNP3vEmu8LwmOw==
X-Received: by 2002:a63:e243:: with SMTP id y3mr18127370pgj.361.1580708406690;
        Sun, 02 Feb 2020 21:40:06 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r28sm17921259pgk.39.2020.02.02.21.40.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Feb 2020 21:40:06 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH iproute2-next 0/7] iproute2: fully support for geneve/vxlan/erspan options
Date:   Mon,  3 Feb 2020 13:39:51 +0800
Message-Id: <cover.1580708369.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1-3 add the geneve/vxlan/erspan options support for
iproute_lwtunnel, and Patch 4-5 add the vxlan/erspan options
for tc m_tunnel_key, and Patch 6-7 add the vxlan/erspan options
for tc f_flower.

In kernel space, these features have been supported since these
patchsets:

  https://patchwork.ozlabs.org/cover/1190172/
  https://patchwork.ozlabs.org/cover/1198854/

Xin Long (7):
  iproute_lwtunnel: add options support for geneve metadata
  iproute_lwtunnel: add options support for vxlan metadata
  iproute_lwtunnel: add options support for erspan metadata
  tc: m_tunnel_key: add options support for vxlan
  tc: m_tunnel_key: add options support for erpsan
  tc: f_flower: add options support for vxlan
  tc: f_flower: add options support for erspan

 ip/iproute_lwtunnel.c    | 362 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/tc-flower.8     |  26 ++++
 man/man8/tc-tunnel_key.8 |  20 ++-
 tc/f_flower.c            | 300 ++++++++++++++++++++++++++++++++++++---
 tc/m_tunnel_key.c        | 209 +++++++++++++++++++++++++--
 5 files changed, 889 insertions(+), 28 deletions(-)

-- 
2.1.0

