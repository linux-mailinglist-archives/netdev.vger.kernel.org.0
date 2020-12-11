Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE99E2D758E
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405900AbgLKM1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404339AbgLKM05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:26:57 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FFCC0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id a9so13082098lfh.2
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 04:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gB30ehk8UZyoMwpz0hSLD+9cGbhzDWX3duh1tfty0GA=;
        b=iCQnzFVfwB5DnMuWyCImmz9881RveCvtC/eWm/dtjmQ5XUURkfYffB1qsVCu5ymJz3
         57vrkbza39gI9HuuTxmThC+xpJcxQqf1GXCSaV3jZmLp/Kte5GQ7HilrmzalDdQ+1aEj
         4yinqWATygCqttGfgg57Yu7HjBHxMXadX/2vI0QgU3zKKUoftgq00Qj2PIROuwNNl2eq
         nHuS6dQ83Quyjt8h93j3UYbFUsMUAFyuHKS0thvxYxhomwfQ8mKq363/cHpoga/VoIYx
         2/mxw2VVQ0EyZKkefDSEKnO58bNBwxdM/bV9g+IVy11ZLwK1AQD8Kf0wkrITGycgrZzl
         zgrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gB30ehk8UZyoMwpz0hSLD+9cGbhzDWX3duh1tfty0GA=;
        b=UQMdXuwxji8NWlrhRShmL/T0+b17O+Frc06qvXyQCgoYgQCC8B72xXoo9k9bjvXu0W
         c03p83TBVz3ERL6eQ1eAbwhanSV81rIfEZNm9P6gfHHcyRyap04si6TA0ezqTaUUzPbL
         kFsMYaL3SwXiwerad2gWfjoDrDWqcQHTZY9twQuZtJ8BwqM99WarAQIN1DrpkqGI0cFo
         5rISbio4TSeJNCQRwnTig1eF9kRiJ0FfuSvchtn99i4B5N67hzhPH1PH2at8V/7sIzAj
         /m/kuhEarxknVXRJI6YKZY2lcypzM6N5kkr27UH02L64HJUFabwTSxDyxy7bxZ3+oPr5
         DBoA==
X-Gm-Message-State: AOAM533b49ekxMrTNfWkPtRgGrzNKVMmg/gU0yDPB6hCX+SQKSlBuTQG
        wn80nBexGkUMzyIRBvC/xqJo+laEyTYcag==
X-Google-Smtp-Source: ABdhPJy0xjBkV39yFj84ECSzhGwA38HrpK4wi/Xy0fSFGlbbG9xcvTL7lWz+WO6faHREsPJwXCKhZg==
X-Received: by 2002:a05:6512:1112:: with SMTP id l18mr4712388lfg.538.1607689574651;
        Fri, 11 Dec 2020 04:26:14 -0800 (PST)
Received: from mimer.emblasoft.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id s8sm335818lfi.21.2020.12.11.04.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 04:26:14 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, laforge@gnumonks.org,
        Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH net-next v2 00/12] gtp: IPv6 support
Date:   Fri, 11 Dec 2020 13:26:00 +0100
Message-Id: <20201211122612.869225-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds IPv6 support to the GTP tunneling driver.  This comes
by way of a series of fixes that lay the groundwork for IPv6, along with
some performance work including:

- support for GSO and GRO
- cleanups that align the GTP driver a bit closer to the bareudp and
geneve drivers, including use of more generic helpers where possible

This is v2.  v1 was just the five patches at the bottom of this series
that I had hoped would get a quicker review given that they are mostly
trivial.  The one comment I did get has been addressed here.

Changed in v2:
- added patches 6-12
- addressed comment from Jeremy Sowden on patch 2/5

Jonas Bonn (12):
  gtp: set initial MTU
  gtp: include role in link info
  gtp: really check namespaces before xmit
  gtp: drop unnecessary call to skb_dst_drop
  gtp: set device type
  gtp: rework IPv4 functionality
  gtp: use ephemeral source port
  gtp: set dev features to enable GSO
  gtp: support GRO
  gtp: add IPv6 support
  gtp: netlink update for ipv6
  gtp: add dst_cache to tunnels

 drivers/net/Kconfig      |   1 +
 drivers/net/gtp.c        | 774 +++++++++++++++++++++++++++++----------
 include/uapi/linux/gtp.h |   2 +
 3 files changed, 591 insertions(+), 186 deletions(-)

-- 
2.27.0

