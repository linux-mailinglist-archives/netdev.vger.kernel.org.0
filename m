Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85440CCEF9
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 08:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfJFGaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 02:30:08 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46240 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfJFGaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 02:30:08 -0400
Received: by mail-wr1-f54.google.com with SMTP id o18so11475227wrv.13
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 23:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YER9tB4SHxGHutlIaE3CrQ7ZM2V8uys9OhFiaczeAI=;
        b=1I1c9/qze8i2ENIaNXTd+5sVEw9rRxyhYQYZG9ZvtDkfuzgGb2QARZ5mebMqGC4r9q
         9K86MGJH1sI4zlonbDR0VoiYwvYG24pbVB5iqpb0BV5HEWN0TYRQl+HrEVKaKCa+KcDr
         wUhUQ97rUPdR9O9Q26XhL1AuQfGeY4N5j0hoTk2YIk0lyPq6tgh5lkOnnSM9pfYqthp4
         kJZ0fFgMvyUZaNNryyPMteVBH0dwXjYVGppFMYpKLzZKzK/3pV7iU40/S2v79KlxKmVn
         Cz7/eWrcFwfzhllrEIgDvOPEzwknQ2FAHTCOHUfN2wkmxJe8iRVnYpD+SsvrddI5VAMQ
         6JXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9YER9tB4SHxGHutlIaE3CrQ7ZM2V8uys9OhFiaczeAI=;
        b=F7pYBnmqXQUfy9Uhj4+9JBf28XsYgCzd+qz6A6P6Yu3QQdyc5F0azoojG7U2lzWmHs
         VpV1wz0MlbcnuGwsK5g20GOnw1CA9QmFYWe+Eqq/UtW+2s05iXxxEhalD1LBPA1tmqJc
         EbXhyLTgys4oz5LIWLvSYXDVhJa8e4dMYC5XnQ5a8a8na6dPzhWu1kQXQylaCcCQLvdf
         HuTE2Cf/0wnHSvaGi0k2T6VpPconWa9EEVrJnH2AFo5AoYmU/TN2VhGK1AmijqEXWzvJ
         PnVG3kOVQtm+LrXXwAYJCnhGF1k8FqXe3oGdIMX4DEVDNzVaxP8YzjVuBBhWzvVDLQV6
         QChw==
X-Gm-Message-State: APjAAAVT8ZPy/bEo9uRhkPjxAtlV9sCIZFuNteLFKDum2rT0ZQjQLI7e
        OsCJoouTEOPvpURe+rpguavWFLxfNWw=
X-Google-Smtp-Source: APXvYqzp3tDMOkSse7olQsMb/YZU9fkqkEo7B/qmaICH55GzFxlvXDTQR7jjfH4FPtEnFfn5Aq4bXw==
X-Received: by 2002:adf:ec02:: with SMTP id x2mr5466149wrn.145.1570343403510;
        Sat, 05 Oct 2019 23:30:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m18sm23705368wrg.97.2019.10.05.23.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 23:30:02 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next 0/2] netdevsim: allow to test reload failures
Date:   Sun,  6 Oct 2019 08:30:00 +0200
Message-Id: <20191006063002.28860-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow user to test devlink reload failures: Fail to reload and fail
during reload.

Jiri Pirko (2):
  netdevsim: add couple of debugfs bools to debug devlink reload
  selftests: test netdevsim reload forbid and fail

 drivers/net/netdevsim/dev.c                   | 20 ++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  2 ++
 .../drivers/net/netdevsim/devlink.sh          | 24 +++++++++++++++++++
 3 files changed, 46 insertions(+)

-- 
2.21.0

