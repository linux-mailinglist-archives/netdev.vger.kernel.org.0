Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E549C1BA10F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgD0K2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgD0K2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:28:01 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6910FC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id n11so393170pgl.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8LZtKTvTlBKWcEMe9ampBzBCR9qLC8XKKcDZNSGnCRs=;
        b=QgG9QmvaB397BdUDAGxFCZ0VtzfuokZViMbIJKFhWoTeWytfKOz3N+PO/3Ooym60c1
         xarhSMDEMQgCakacfEbN3CAGnfHJO+ti5xWHk0e41l3Mg7BHs2IC0wvSwWazekKAae0K
         BEm53cvJEHexlTo3o4klkFfavxfTq6eKwy2n5PI/xwH3a2qdSU4e/C5oSGwaAwdRa2cS
         s8zqOCaGJ+iAZClN9z7oGizr2nvQ12Ly4XPuGCtiK726F7yK+kSCnnr2lYdKMdQ3TNP4
         MbvOJoyFtZ9+F3dpm6tk0rJWrrrYxkJyXKlcow0wZlIugOYuifrze/JSlNM2UN5z/+c0
         wZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8LZtKTvTlBKWcEMe9ampBzBCR9qLC8XKKcDZNSGnCRs=;
        b=QsRTCbgAbp7gXkzFZKpvk/4Ig5Tpg+g5T0R9d+u9mtJA4yvurNhHRj6DfQaZZOA1++
         iQjWuNGvbS9/5gzAjKnyLiH1dqApkyhNPOITEXKf216424+F0rhQQ+ydghcLDdLrDS4F
         0pS5IrR/+bemEv3doaIgooL9DWE1VridjxT5oQFddV5BisgfB89fZVaywy7N2eH5n27C
         Yh8TN5GQRrvsTv7k42luRVX3M8ON11h8xOe1aBahnZuJwSpBFumYUJx5h+qrGw2pWitN
         +ByKztMatF4M1msh0cSI6aGMiViwK0Sg8X22CgIj/HDQyJpteb4d7HDF+HyWYALpGbHD
         GUrg==
X-Gm-Message-State: AGi0PuZBEOEPeXPSN9zxeBIWjM3aP816Gb6R8CDlfwhvWASXGpAPg0vZ
        fTlBdwYYpPtbN+bO02xS6r5RhaCt
X-Google-Smtp-Source: APiQypLOXtzMr4pdYKG71NE0TINieJEYWxhq8ozkRytoFWWIPc88CIrbAdh07EfDHZX2D/N068FRXA==
X-Received: by 2002:a63:5724:: with SMTP id l36mr12538110pgb.317.1587983280467;
        Mon, 27 Apr 2020 03:28:00 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f9sm10415063pgj.2.2020.04.27.03.27.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 03:27:59 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCHv4 iproute2-next 0/7] iproute2: fully support for geneve/vxlan/erspan options
Date:   Mon, 27 Apr 2020 18:27:44 +0800
Message-Id: <cover.1587983178.git.lucien.xin@gmail.com>
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

v1->v2:
  - improve the bash commands in changelog as David A. suggested.
  - use PRINT_ANY to support dummping with json format as Stephen
    suggested.
v2->v3:
  - implement proper JSON array for opts as Stephen suggested.
v3->v4:
  - Basically we print all options as uint, other than 'data' in
    the 1st patch as a hex string.
  - As Stephen's suggestion, we keep all those options of the same
    format between input and output, and between json and non json.

Xin Long (7):
  iproute_lwtunnel: add options support for geneve metadata
  iproute_lwtunnel: add options support for vxlan metadata
  iproute_lwtunnel: add options support for erspan metadata
  tc: m_tunnel_key: add options support for vxlan
  tc: m_tunnel_key: add options support for erpsan
  tc: f_flower: add options support for vxlan
  tc: f_flower: add options support for erspan

 ip/iproute_lwtunnel.c    | 382 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/tc-flower.8     |  25 ++++
 man/man8/tc-tunnel_key.8 |  20 ++-
 tc/f_flower.c            | 301 +++++++++++++++++++++++++++++++++++--
 tc/m_tunnel_key.c        | 199 ++++++++++++++++++++++--
 5 files changed, 899 insertions(+), 28 deletions(-)

-- 
2.1.0

