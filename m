Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8ED149DEF
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgA0AOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:14:22 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41397 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgA0AOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 19:14:22 -0500
Received: by mail-pl1-f196.google.com with SMTP id t14so3100620plr.8;
        Sun, 26 Jan 2020 16:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RePHoP9if/ifB4EayDrLQHlkxI790unFJKfopkrGCxE=;
        b=nmic+qEUpZ+ObPzKyCT5uvP8uP8dCaFsJ9nZN+f1SUQ+Xy6k3S59sYukR4B6SaJN6D
         pWLQZCoT2oE/8lyXdRvrb0rPkdBsyQLZu8+l2gKHYcZS+NrfZV2ZCEj53rQyfZij5u/e
         7k+zuksHtzJ8SwRkHuTt9R9BvXPxmt5+VsnhZixsY8zdkbvq37Mq94G/1L1Q9W8fmcFV
         7Lov3rhIWRsdydYX4P614lDZ679s436R/OQ20eBI+k/d6KQFnYZKz65iGEZuzU2hZtV5
         91DpwFAXmt4KeUdZHouQhHW1foNOrazBmxSRQayrD2ZE1Zy/MWN2Tq61qu6yCSPcIxi/
         /i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RePHoP9if/ifB4EayDrLQHlkxI790unFJKfopkrGCxE=;
        b=ooxIVJHdrXCsopzV8fN1B9BhR+bvP5VwPjABcp/iirz9qlGHdCycvauEFoInQdnOuS
         JxGHxJjx3YNVA0hqWaF9o6AL4fStpi2UdKl0gDKXNfiaRDymSrV3/5x3M1jTF6dbvzrP
         sKghHvxlPGWRmuV2muUF6Jvm/MSf7kPTT8sdUh+cUtqD8SHodSrAjl2ANrHL5SM7fHHi
         2OOMBPWZHjV7IqvfgGvQ45AcNEWD8x0XO8QBiKoVECvxQp7z45iZDQNQUXqhQSxJdTWf
         zIW1ZMIat1cs/Kvjwe8SE1FpJMQNZzHBfRfszgcac931VfrHC6TCInhn3z/iKuW8Mj/D
         2wWg==
X-Gm-Message-State: APjAAAVNg97L3jmz5t8s1uzSHi9eQKUW2/dzAqzUR9polkeMvkE+TV1Q
        O7Yok44+NrWEYz2FCyBjjcet/wgY
X-Google-Smtp-Source: APXvYqxyJiftr4JoVDz5WSOMdVKQS5lH8ZU6y+ESK4BuKpeR8eGZraMQMbQNMo0VqFuKfhPGkctBPQ==
X-Received: by 2002:a17:90a:804a:: with SMTP id e10mr11768749pjw.41.1580084061237;
        Sun, 26 Jan 2020 16:14:21 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i23sm13326949pfo.11.2020.01.26.16.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 Jan 2020 16:14:20 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 0/3] XDP flush cleanups
Date:   Sun, 26 Jan 2020 16:13:59 -0800
Message-Id: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple updates to cleanup some of the XDP comments and rcu usage.

It would be best if patch 1/3 goes into current bpf-next with the
associated patch in the fixes tag so we don't have out of sync
comments in the code. Just noting because its close to time to close
{bpf|net}-next branches.

v2->v3: Jesper noticed I can't spell, so fixed spelling. If we
are fixing comments its best to have correct spelling.

v1->v2: Added 2/3 patch for virtio_net to use rcu_access_pointer
and avoid read_lock.

John Fastabend (3):
  bpf: xdp, update devmap comments to reflect napi/rcu usage
  bpf: xdp, virtio_net use access ptr macro for xdp enable check
  bpf: xdp, remove no longer required rcu_read_{un}lock()

 drivers/net/veth.c       |  6 +++++-
 drivers/net/virtio_net.c |  2 +-
 kernel/bpf/devmap.c      | 26 ++++++++++++++------------
 3 files changed, 20 insertions(+), 14 deletions(-)

-- 
2.7.4

