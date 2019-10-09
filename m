Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0426FD0F28
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfJIMtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:49:51 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44375 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbfJIMtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:49:51 -0400
Received: by mail-wr1-f46.google.com with SMTP id z9so2805243wrl.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J3iI054nUee0RxdzacvEXHoc7paVAHNGJ02krX/N6dg=;
        b=I1skJAHpWz5QX3HSGRt7FUDMCZzo+Ty2Wxg0pZG7OU3C1ccuVE1WP2oT+nqYbU7WWQ
         z3IpIyWAQ2yyCrH2ldXJ75f6mpsjMRPEjWqLMPYMOnd68ekMh8XHCRtZhgcwa7MClIzx
         PfZxECFS7sDT7sQLBXff5lXs1HsyqUfEp1K4DCV54zvXVDVLpYqgp8S61c44XmQtdLgI
         RaCybH+MIfurqFYIvoYiLpogZdKI4qWKbfvn/sIgSE29CTUBREaIC67LdRILz3KxUOMb
         ASYlLGwZhgNyb3s0NyB6JlMbre36EQZK2oNezwrGM5MEIor0DDQFJFzIjTqm2E7Xn8HY
         bgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J3iI054nUee0RxdzacvEXHoc7paVAHNGJ02krX/N6dg=;
        b=acjYcIFRndhCHf0+Kru8GN2+sJt+ihWjZrbN0aO/+ElSbEr8cyBdQA/HemPZwJcek2
         S+rCjYwIFPKMZGfCHV5u0xdVwPgwZqO8/0A+0NHOTAq5ZmotuB0ECmehmcjG78Umb7D2
         ZbjeBtHIfmg55Q1ZhjWVn6XuywKOVXPQGRXzJFWdRycd4d7oE985/cCeEcA9AIrAqYj5
         5vqKEoXTttvpTZQzo0mLnT4Gxix/mkUxbZRdPFpdDCtNO6q0pUuYC6p7fQpWK7uzsZso
         VJHPv+zhRMeLL/4AOqHtDpyX2qSN6JfKQAOaV6eWu94CkKDlwdDVpKPPLLbLrfyuYVX8
         LA1w==
X-Gm-Message-State: APjAAAW0rDgAyHS07VIlC9PaJRmi7MfsW8PdQX30iWlnaqAtd5V7oDlj
        D+sZbvDKkJCnQPn6Xc+IFgFD+WhtVok=
X-Google-Smtp-Source: APXvYqzBovYVUZUmC9kJbYeuiTY0JjQ0LmbXUVeUih4FaRjhIUHUa4Kh53LcSHrUUxPexKkfId+p5Q==
X-Received: by 2002:adf:b781:: with SMTP id s1mr2773116wre.343.1570625388633;
        Wed, 09 Oct 2019 05:49:48 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id z189sm4098069wmc.25.2019.10.09.05.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:49:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v3 0/2] ip: add support for alternative names
Date:   Wed,  9 Oct 2019 14:49:45 +0200
Message-Id: <20191009124947.27175-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for alternative names manipulation and usage.

Jiri Pirko (2):
  ip: add support for alternative name addition/deletion/list
  ip: allow to use alternative names as handle

 include/utils.h       |  1 +
 ip/ipaddress.c        | 20 +++++++++-
 ip/iplink.c           | 86 +++++++++++++++++++++++++++++++++++++++++--
 lib/ll_map.c          |  8 ++--
 lib/utils.c           | 19 +++++++---
 man/man8/ip-link.8.in | 11 ++++++
 6 files changed, 132 insertions(+), 13 deletions(-)

-- 
2.21.0

