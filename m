Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E715BE0E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 12:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBML5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 06:57:14 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:36356 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgBML5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 06:57:14 -0500
Received: by mail-pj1-f46.google.com with SMTP id gv17so2335904pjb.1
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 03:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1m8dAsYMHdGIr97IVQojZKdFixQDZVd8IqFcJO3bnHU=;
        b=FgH6SIm4djg/8sNf2e4qYmi5sH6mpJ/cFu6Xb8yTaS4GzjFbQI+Vl6G0iBoYC3dHVq
         Pd9V3i/fcnY8mvLaCnISW1Z15bFIVbIEsn6vujdd7eEznkm3BIPhfkoqDwixqeOJa8rz
         BpjHCg4W/OfFi/Brbqw5GwdnGd++68agd48UP/iAF23KjFOfBIFTUXewDBxQWxNbrKCm
         ijOw6ffuZWSHAYFY7LNFKTMTMg9bWQh875yTM7a46ntgOUg/Wp3ju7CgbiD1o88W+pgd
         GuqCost22LAxxQHBd/i5DaVIhpJakLOIJCePHTidfk1djMYtWvVXPR8QfA63Dssasgk9
         UFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1m8dAsYMHdGIr97IVQojZKdFixQDZVd8IqFcJO3bnHU=;
        b=A6OrPF4q1183XMt1pCMCL+O3laBwvRXDvepjdvWL4HK1u4vX7LxtkVzr5uVxEntmnJ
         uoOHS06rEOZRGqnOSjUfpew1779ox1JCZyHZTd77P3K2kCRe7TjFGbT1634vHzrq/Qbt
         rG5m9kI1zcGDlpkjUd7DOTZNCshPhFhKI8FEFRqDtaI3uwvTmmAm57C2C7GMe30E6wx6
         y/29fA3L7PuPX/xlRFHF3J52mRCUa5i05zORnLaRi8lyWc9cAgPp9vewnYjiAvfkPR5O
         pFFNWKYA3dWsC9e8MNPe2QTuz8WO9oTwIadWSi9zXiw+EYS6fuq7is9RFW+wJhXPRJIA
         CdSQ==
X-Gm-Message-State: APjAAAV6iG/2IQn03iZgOrrk0LUNjvy3Jf8POomjuhyyZsfXukld/kuz
        Zobnls9FmNxYQfPk1WhTAO1E16LP
X-Google-Smtp-Source: APXvYqyy47grw8gMt0q09uElWAKxUIPbBER42PAHkewd5G52W+wI8J6Yjw6cnLl+gg1TgKpm0plRYg==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr13148745plt.334.1581595033632;
        Thu, 13 Feb 2020 03:57:13 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p24sm2854715pff.69.2020.02.13.03.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 03:57:12 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCHv2 iproute2-next 0/7] iproute2: fully support for geneve/vxlan/erspan options
Date:   Thu, 13 Feb 2020 19:56:58 +0800
Message-Id: <cover.1581594682.git.lucien.xin@gmail.com>
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

Xin Long (7):
  iproute_lwtunnel: add options support for geneve metadata
  iproute_lwtunnel: add options support for vxlan metadata
  iproute_lwtunnel: add options support for erspan metadata
  tc: m_tunnel_key: add options support for vxlan
  tc: m_tunnel_key: add options support for erpsan
  tc: f_flower: add options support for vxlan
  tc: f_flower: add options support for erspan

 ip/iproute_lwtunnel.c    | 364 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/tc-flower.8     |  26 ++++
 man/man8/tc-tunnel_key.8 |  20 ++-
 tc/f_flower.c            | 300 +++++++++++++++++++++++++++++++++++---
 tc/m_tunnel_key.c        | 207 +++++++++++++++++++++++++--
 5 files changed, 889 insertions(+), 28 deletions(-)

-- 
2.1.0

