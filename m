Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BD08BBF7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfHMOsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 10:48:47 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37268 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfHMOsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 10:48:46 -0400
Received: by mail-wm1-f46.google.com with SMTP id z23so1700678wmf.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 07:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc4z5qup8hBYukOvaqUNV82jI5nSWP7sIh5DdzwOas0=;
        b=szttC9ITKSkq/q5cWRlLSAPldjEo/oXVdC1TF3V1ngJtVqUlsIadq0l1pS92RtGiqx
         +TBW1cApSSfiixHGMYzlvEQe0YqaFAQMJe1zO8m/G5+rGE8y2Ig7HH67EAYQR1yi1grJ
         nyJx7oNZV/SvnwTIbgcH7QstbUBSnIfz2aum7feej1oqNhY+H9CqC6VTtBtVRoosjW08
         5vBqWFgPFmsZWcpx6iR8+1o5TXtmWbfryxRt22Px8GKJ61WAG4cQXCznKHs0O4TvoK7z
         TaE7fg7syLGGTozdF141s/xIw2vKfNPuO2e5LhbDT834f2CCu4YnO7vyjxkMR9p1BekF
         vM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jc4z5qup8hBYukOvaqUNV82jI5nSWP7sIh5DdzwOas0=;
        b=m2W3Pv2KHKYVzPsUuU8RnWAD6grD7isbVogql9p5deClKn84LOzZrJBbAcaZFLvMUK
         OWfMjwjba7IcfAQzVu+OWWCxUS0HKMV7e3oWAP8ZB/hCn3u3/oAVfyTf7anw2jwNjB5V
         pSc4JCzwx2/eGmG/9wWDsOrQO4RiSxRrxuTWxjeyt8VxqTkfv+ImB9c49iRgLrsw3P0j
         Bihy1OLsFaX37C4jQnTMXPU4YgQNaLPTjYEjwGwYGwC7fag1hBHROB9l6n2Z3RVS+zCm
         fe3Do+FkJYKsKsgRKqfxZL6ozgxhLtGbTU0R3xyfjWZOmPeU/xdXtoQSiXe1WWrvKnKY
         HnNA==
X-Gm-Message-State: APjAAAUPQBCp3bb68wT94CZhReWrgyMOQvwtBY7udpGsecjBaDeR0li4
        5Q6uaDVQM7ZtFEnXkRZAPrBwpryAIDM=
X-Google-Smtp-Source: APXvYqx4gcC/0VMcShfTwjJCpuDSbQ8E6+goe+UvX4uUXKM5mXRkWvUeFCj/Bap+skwh9NcfE5jgkg==
X-Received: by 2002:a1c:a514:: with SMTP id o20mr3645949wme.149.1565707724439;
        Tue, 13 Aug 2019 07:48:44 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id n9sm161138368wrp.54.2019.08.13.07.48.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 07:48:44 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 0/2] netdevsim: implement support for devlink region and snapshots
Date:   Tue, 13 Aug 2019 16:48:41 +0200
Message-Id: <20190813144843.28466-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Implement devlink region support for netdevsim and test it.

---
Note the selftest patch depends on "[patch net-next] selftests:
netdevsim: add devlink params tests" patch sent earlier today.

Jiri Pirko (2):
  netdevsim: implement support for devlink region and snapshots
  selftests: netdevsim: add devlink regions tests

 drivers/net/netdevsim/dev.c                   | 66 ++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 .../drivers/net/netdevsim/devlink.sh          | 54 ++++++++++++++-
 3 files changed, 119 insertions(+), 2 deletions(-)

-- 
2.21.0

