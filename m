Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E871A6D7C
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgDMUnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbgDMUnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:43:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B22C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:43:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cl8so3157269pjb.3
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 13:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Jzl9zw+WWi+s6Kx4ZBqfebz2iDt6ayXKGXNZZjJo2Pk=;
        b=VT1Z726v06Ujmb0lEnnzZAtHRT4apvVynE5ed5Ktp3UGwkACAebRQ9zx2/tlMYHO5F
         rywIuPMKAUti5V6eK/5urkFIHTA2avL3pBcpv8gN80Owcdom1iv5VfXqsI01rnIAsKJM
         rhph9sz5PVaOOwI3UNEZQRB4o7SSiuZeWuVIfQT2JqASu3CFmZUlpXfo30toXIzJhl94
         Ho65K0a43xa3bx6V4R+etOwnd0T+g1i7+JU+XRFRXnG4mBVArkSUa7KSxBRF8wIRSwaP
         kS6YP99wSgijh6YDO/COskWhGnToZT/yF2UvsM9LBykI/oQZrBYpXSEtLHX9qU8G7Haq
         TQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jzl9zw+WWi+s6Kx4ZBqfebz2iDt6ayXKGXNZZjJo2Pk=;
        b=cOi9UBqI8bs5yQb+07keMLdOe+ecmXxIGyrfTc9DwqsxYWF8PHvzYermYtXwJm7e7x
         v0zBG9f5xL3aaSnMZsAyJDUeAseS95aSgN/n7hON9zMIqzbteW759VzV2qLnxfBMMQzU
         Wtg47K6iTCtSfV8sqFNdnBx+sPPwxjc8qA764/dITQ5BdFplYykSfVuZz68n0Hy71iGz
         FZvGcf3nFSKzeMVkYldlyOOmGaZRiw2QKKnMvZBTo4OzSor/t+xWHMh7zMq51eK7CCgX
         VxA5NatnfqKTPg1X8wdELrOcr7aoQo4r0Q1C+ACGwn8kYOX5dEZXowU0+/EEkpshASiZ
         XdeQ==
X-Gm-Message-State: AGi0PubR08yVfSDajbs6OPiLm1luwvZqxkgakR+OJXMzPJml2mnysonM
        rRVa0+BetxQg3MoT2wUhrQwpbg==
X-Google-Smtp-Source: APiQypIRvteVMg0gNs6DmMEEBBIlRcc/01DPdawXCFZi7iOutYc4cJYrlnAN1psu50sBspsa1M3cjw==
X-Received: by 2002:a17:90a:77cb:: with SMTP id e11mr24567922pjs.0.1586810583200;
        Mon, 13 Apr 2020 13:43:03 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id o21sm4763340pjr.37.2020.04.13.13.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 13:43:02 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 0/2] Fixes for deferred_probe_timeout cleanup
Date:   Mon, 13 Apr 2020 20:42:51 +0000
Message-Id: <20200413204253.84991-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just wanted to submit these two fixes for the
deferred_probe_timeout cleanup that landed in the v5.7-rc1 merge
window.

The first resets the default timeout value back to zero so we
have no behavioral change from 5.6. This avoids regressions on
boards that have "optional links" in their device tree.

The scond fixes an issue discovered by Yoshihiro Shimoda
and Geert Uytterhoeven, where if a timeout was set, things
like NFS root might fail due to wait_for_device_probe()
not blocking until the timeout expires.

thanks
-john

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: netdev <netdev@vger.kernel.org>
Cc: linux-pm@vger.kernel.org

John Stultz (2):
  driver core: Revert default driver_deferred_probe_timeout value to 0
  driver core: Ensure wait_for_device_probe() waits until the
    deferred_probe_timeout fires

 drivers/base/dd.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

-- 
2.17.1

