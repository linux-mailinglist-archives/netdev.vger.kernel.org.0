Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4859263FF0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgIJIc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730212AbgIJIbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:31:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5E4C061756;
        Thu, 10 Sep 2020 01:31:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b17so2689617pji.1;
        Thu, 10 Sep 2020 01:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0y2x8BiD2jptL2ZlFD9al3tEepgcvno9MvSo+C6e0lE=;
        b=dgHIUbooW0aLgh+Giwo+o2Ug4JfCHzbLfbZxTi7pcvzIUEP0Bd+YVx/s+GJIi1qKsh
         bitmVAREddbN70xJRoMojKvPtR5gCZYsvo27czcD19q93V4fMK1uv1ccTzuuOJjOMA59
         i+EicsBPoLCQQ8tmXv4bPkbuxcBv1IdXcmZ5NehtCqKOf96eyldOCETVbIaUsFNdm+ZN
         UPv33CXrjvt7ghPfJm/HydRshoGdzT6DtP2lalJ0NcaJ5SFlt76GbCJad3Nh0cM7/R8W
         FvMm1WonE+P3RaTTb1tB1QMeFZa1r7eMx/ipYSeYWx30leJ/DawF7hEmr9r+J1FR3AvS
         GM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0y2x8BiD2jptL2ZlFD9al3tEepgcvno9MvSo+C6e0lE=;
        b=Iz5ugW4CCn8CniSNCY/eidG54piH8J8YWA0oiBNpXA/bRaCWXw62bH88wgxqMdCMm+
         UOtT0JIXZu6zTyFr1oVkxbtqY76KPfPSpzSMyjxvBFF7eFYs9zbJLJKESmF2wIoXVzsG
         3ygMyYRY8H+FNyNNykM3Dc8KnZnFD0kvRx61PFbrVBUwlxzecM2KJ2Mvn/Sdig2hAttL
         ElLnjvfbBqsPorUGm1En4ZArq2XTMDDUSNGYZGRQ68Tx9T5Ezy6Qtdpa9hX1XYzJ6ZaS
         qLEOEHxcecjOS4/yao+1KwD+Kv/ZvMmeM8SB2J4LooZNYS4p4LEWcPL9YNbHCbuLV857
         pblA==
X-Gm-Message-State: AOAM533S6JenJ5FbZDBmFT5t91J68rWNJ2wklWdSRsrlKIn0b7CPOTI/
        Un1SSl2fZx4TI3IMrbYcdlM=
X-Google-Smtp-Source: ABdhPJyYRCfQ+nFOb3PiocXWqKukgplvIaFfNXnL8Qmz7f8ZNdWztZ18ynlLeL5ArckE8UU2wiWNKQ==
X-Received: by 2002:a17:90a:1f07:: with SMTP id u7mr1649055pja.219.1599726680024;
        Thu, 10 Sep 2020 01:31:20 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c7sm5183438pfj.100.2020.09.10.01.31.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 01:31:19 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/3] samples/bpf: improve xdpsock application
Date:   Thu, 10 Sep 2020 10:31:03 +0200
Message-Id: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series improves/fixes three things in the xdpsock sample
application. Details can be found in the individual commit messages,
but a brief summary follows:

Patch 1: fix one packet sending in xdpsock
Patch 2: fix possible deadlock in xdpsock
Patch 3: add quiet option to xdpsock

This patch has been applied against commit 8081ede1f731 ("perf: Stop using deprecated bpf_program__title()")

Thanks: Magnus

Magnus Karlsson (3):
  samples/bpf: fix one packet sending in xdpsock
  samples/bpf: fix possible deadlock in xdpsock
  samples/bpf: add quiet option to xdpsock

 samples/bpf/xdpsock_user.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

--
2.7.4
