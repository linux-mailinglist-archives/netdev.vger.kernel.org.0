Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28965E4754
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438690AbfJYJco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:32:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47009 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfJYJcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:32:43 -0400
Received: by mail-pl1-f196.google.com with SMTP id q21so926310plr.13;
        Fri, 25 Oct 2019 02:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DXh+yrlEGWqyM/YeU+cYaVv7lpfTaFS2kr3FXz/JMY8=;
        b=WB3BOpuoPqlDTju2hNP5McPQOiOl4crQpHxo4q3N4Yz0CohdBoNDZIDfahNJbAYHec
         w0lEpYAUbBB8fN1UjxDUSiNduwGjXCB+5IKeUYjPpoWq8jrjXzqaBCJIKJ+2jMMEXePa
         /b2SVLmTcKFZjtcxF4F41TLjWdGdhUdNPmbMqDJ4M2D2S/kZ6BcOgXfxL0GEaFyTHR6n
         1ClbD9Wi5kN8mBjf3E0xz5Uy39AJMsd4o7taP7AnV3O3Ppz9O3vnAInMZgpVtUFxRUsQ
         Gw0E/sKvtzPYSuDVXFeFCNmlA5jrbvpF/N2h2rh+tHcqyMbbE7iLVpxGKlJPuX9Q2/wY
         WvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DXh+yrlEGWqyM/YeU+cYaVv7lpfTaFS2kr3FXz/JMY8=;
        b=acfdKq9jMEH0CSKt7CNp4fPPIrJfZJglupd8HzCAswX5qgbOWiYc13J/7n17VakgjD
         mpW61r+srmpyEy2X9yLUKYUoyepyGgxDzP0BcTi8UaMUAAPXHOemnI8KIm9N9bNPx+LZ
         3mKTSNVeuJvkQFvxo9bX6+U3P99QMi7mgtEeK2+Shdj87AUM4Xj9RKF+uEd5SagZpQhG
         3KumGK09kRT/B7grZuxjcjuf1S+D3Sp8+bYRuvbZJmeO2VdgO5UFOXn1oTrPrGmqpc87
         LTasLs90jZ5gGlyzfz0LTbVXKTaoSOj7KcJ/4yl+B3BFxiT8J9gnwVtlfAuacInWCcI4
         y6SA==
X-Gm-Message-State: APjAAAXLxShydwmZMCr9aUY5d/jvTuK4MvjDjgX0vwjpJAPdy81Iffi0
        c2cKbqOzqvOuErsrR6nSsBn01fLiCg5Pyw==
X-Google-Smtp-Source: APXvYqyea9xEQnf5IVYarffboMct+GEhzm5RoJIhGU1v0SzOrz19m6dlSOsz5GOEEB3H/2PgWYxg2w==
X-Received: by 2002:a17:902:9888:: with SMTP id s8mr2739782plp.193.1571995962799;
        Fri, 25 Oct 2019 02:32:42 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id k24sm1110557pgl.6.2019.10.25.02.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:32:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        jonathan.lemon@gmail.com, toke@redhat.com
Subject: [PATCH bpf-next v3 0/2] xsk: XSKMAP lookup improvements
Date:   Fri, 25 Oct 2019 11:32:17 +0200
Message-Id: <20191025093219.10290-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's try that again. I managed to mess up Maciej's commit message.

This small set consists of two patches from Maciej and myself which
are optimizing the XSKMAP lookups.  In the first patch, the sockets
are moved to be stored at the tail of the struct xsk_map. The second
patch, Maciej implements map_gen_lookup() for XSKMAP.

Based on the XDP program from tools/lib/bpf/xsk.c where
bpf_map_lookup_elem() is explicitly called, this work yields a 5%
improvement for xdpsock's rxdrop scenario.

Cheers,
Björn and Maciej

v1->v2: * Change size/cost to size_t and use {struct, array}_size
          where appropriate. (Jakub)
v2->v3: * Proper commit message for patch 2.

Björn Töpel (1):
  xsk: store struct xdp_sock as a flexible array member of the XSKMAP

Maciej Fijalkowski (1):
  bpf: implement map_gen_lookup() callback for XSKMAP

 kernel/bpf/xskmap.c | 72 +++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 32 deletions(-)

-- 
2.20.1

