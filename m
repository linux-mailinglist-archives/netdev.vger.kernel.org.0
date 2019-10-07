Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84942CDD3E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJGI1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:27:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40890 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfJGI1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 04:27:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so5368558wrv.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4udHZndUQFYsvFZtOogCUp1I4WFuuIj9oc+PhhR9hsQ=;
        b=x30IUrKpkM4TYK8SD9N1eyMKY0IIKrA/W36335CE9AagQe7Rk079bzps9Lvabq40a6
         lfq2EwX8Ow81cPFdhaHlanEDbypvL2cjxsLjJRDlTa3OvDMwPE7atFoqynDQ/uLZAaQa
         688rMAaij7wphrzyZQlbtrXUDO4yreMz5CLz+71N/urAJd1GwmpJ2AS+mS2b1ijxftJC
         nJRT0FRp0bosPNU6S6Bvmf+vM7murs+rMF3YcZVDHhbZPPhjsq9JqzRg8eoue0eRiUSl
         bG33OESEz9tUufryalKV/vcLiueidlna47dJiY/KpDevxuMHh7RmWdFoT3KXqoWciSxn
         +DUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4udHZndUQFYsvFZtOogCUp1I4WFuuIj9oc+PhhR9hsQ=;
        b=UWX8TMtz+eXgTYZzGxdt7MjFWc5ArvKsM3IvuADlJEw0DGWYkYnGbti+zdYQq1XRRt
         B7zJ5gDvucdCUxSjZQOw22fAL7EOXOmwc2Y1ADpvO8KmaU7yjfHfQXwkCuf23VA1qNT1
         6QMVAlcl/c8tuEJ/qm0HRQchRhP0snBNKJgDNkRZKW5RQQJLTkCFlk8t2a/wRFkIgdcZ
         L2EZR+RJ2APziytICzIslPgpFqx75jy1A83pWNhW3uhlPVhQHwczRDWb38AxgEnfiGRB
         p027UXsSEbrfpUf24Pm0PcqGsyjQd9VtFF513L4x8+Etw8BOA0BvsCmWmFaiGUz3iJjc
         agWg==
X-Gm-Message-State: APjAAAUBALmiH0v713I0HWPzxuxd1tbq1cnYy7+/FkOvGA6OEHPnfu84
        SAyhuVlAfGG5TughJpAzslDx/spwZGc=
X-Google-Smtp-Source: APXvYqw1/QhQA/R2hkSNgWMuypfywleKL0/zu+oWTALV9MSAyeaSl2ZeFgupMxbCA4jTp8w9AsRaEg==
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr22344559wro.300.1570436831277;
        Mon, 07 Oct 2019 01:27:11 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id h7sm14303120wrs.15.2019.10.07.01.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 01:27:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 0/2] netdevsim: implement devlink dev_info op
Date:   Mon,  7 Oct 2019 10:27:07 +0200
Message-Id: <20191007082709.13158-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Initial implementation of devlink dev_info op - just driver name is
filled up and sent to user. Bundled with selftest.

Jiri Pirko (2):
  netdevsim: implement devlink dev_info op
  selftests: add netdevsim devlink dev info test

 drivers/net/netdevsim/dev.c                   |  8 +++++++
 .../drivers/net/netdevsim/devlink.sh          | 21 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

-- 
2.21.0

