Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D268E2EB0
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407657AbfJXKU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:20:56 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:44618 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407553AbfJXKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:20:56 -0400
Received: by mail-wr1-f49.google.com with SMTP id z11so2051433wro.11
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 03:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgWTQhA8a49nlevhImPixj7ub2veuxBeebHf1j6GteU=;
        b=ZRc0PEtZVXdqbzzl+spZjiaHkdS65I9GZ8ie/C9vOI+l+JpLmKwgO4f4L5RrgjdKWu
         jNYppavbuj89gUttWP9Lq5CHWnfwSLmK8Uy4VTgJuphLRe13OaBGOhNeFHLkiBt7S2Eh
         S/45C+ZuX1dHaWbdGjUbWu8LPz4K2/xda5ZIiSxqDiIdu8QXoXJjl36MwHV0ENRhrjp2
         9nnZjobu2vRJziOcDqyvGGfr20jxSjyHJIwPnXaL1HgyG4ZfwOpsO4JlLZuyUbt7HBJx
         rn5Lv3qvUCmarxKrFWSnlaaNw9n04MIWTYsPctmtzti8XCxPB4q3Ke/YbvKc6+ayz3k0
         E0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fgWTQhA8a49nlevhImPixj7ub2veuxBeebHf1j6GteU=;
        b=RigyWOpAaXVJimn1blkfxZ+72QCkrcBJnq62yyLNS9gnVT2Uq9MYwPLmUB/R6f4d/u
         lmmjXrhh1uWY4JXnN/cTf8SWKZpe4ShYDaPkpcyOxJDIobfgCf88AZ0zfxDCsBCBaQmG
         cTGwL6mmvZtbLBoAkbtQwVeyJg+bL/BVy/k/u7utlBmBW1QWrBffcD4tHr1JSehQPUJU
         6bUTwAUYsB3mWJYpo6ejaPrC5hYsYlUq3lBoHaxl5u5iXWWHWdGL+JfW0ifgHX34KSua
         rRl2Q2VG50wfhIAZJmchMXwgBalmNMF+gP/5dAsKqTc8+bIGw3tXM5T23JiWBAShGHPi
         r94A==
X-Gm-Message-State: APjAAAUuRxmxfPI9szx7mJgdAvEDBpNgG2Pkhn0kocZcaHgn/qRdD7Tx
        hL0IC+pXbmavMIjK0qKEV7P0b9tVE8k=
X-Google-Smtp-Source: APXvYqz5XbUAJxiY8sdNg8mV9jYbBzmkA1YhijiFcTrYUNLw40IJj5eBs9lpiq3HABY3o2eSCdQCkA==
X-Received: by 2002:adf:e903:: with SMTP id f3mr3277523wrm.121.1571912453600;
        Thu, 24 Oct 2019 03:20:53 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q22sm1801171wmj.31.2019.10.24.03.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 03:20:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v5 0/3] ip: add support for alternative names
Date:   Thu, 24 Oct 2019 12:20:49 +0200
Message-Id: <20191024102052.4118-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for alternative names caching,
manipulation and usage.

Jiri Pirko (3):
  lib/ll_map: cache alternative names
  ip: add support for alternative name addition/deletion/list
  ip: allow to use alternative names as handle

 include/utils.h       |   1 +
 ip/ipaddress.c        |  20 ++++-
 ip/iplink.c           |  86 +++++++++++++++++-
 lib/ll_map.c          | 197 +++++++++++++++++++++++++++++++++---------
 lib/utils.c           |  19 ++--
 man/man8/ip-link.8.in |  11 +++
 6 files changed, 283 insertions(+), 51 deletions(-)

-- 
2.21.0

