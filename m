Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA731BB35
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBOOgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhBOOgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 09:36:16 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B65C061574;
        Mon, 15 Feb 2021 06:35:36 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o38so4299951pgm.9;
        Mon, 15 Feb 2021 06:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=6y2TjDWm6GiCRVPHYsBwGulwO9kJcdSY7Gz+WazHK7Q=;
        b=aGDHSlDDZbKZt95gh3ah8dMEA/+GcEgpoPdTL+N0PiBuKG7dHaiOmLB/ZBgKn/kHMR
         aQwoTHght8CqJdMoPgJNAZZYCCe3v658URzmGp4J7YgOqov5wgf71zBK5+a8/jHpxGqq
         JEDg9CTsQHITqk8u5bdRh86+vgW7jNLYQs56vxCIe4c+Ga8SsgJ6niDjD/YlHvMI2jQB
         95/scIu82dy6RyuGsNXSJt7XRP/RrW2RtBkiAPfDdMzgNBDroF9grTIHFqiEM2pVE0pP
         qyta0R1bS5DRwm5M7gjhAik5AcjtA/LI9LmjeKICG8lV1WTdLLsfmqrqOJGY/W9auQhn
         5qTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=6y2TjDWm6GiCRVPHYsBwGulwO9kJcdSY7Gz+WazHK7Q=;
        b=iV5ITGqDUKpC3S4F+nj4ygNl4D13hlLoy7jLiYHuqL1anGSKes9qOXsccjYe/y51rv
         b7Hs/imii2mRmDzJ3PpiJdBexqvKodHNHh8uyVo+69IvnCR1YCtOwMVt3lDzfEyaglOo
         WydisMNCT2mDvaQVin91byQVR/DVOcnD6p7QpwfAEcDWlRKAY1rqcAmxT/gEWhzH76b/
         V1lQpizTeSc0Cj3+46JI4ujC7YKe2oH443JQBDXYRePUq6MWwkaNAU+uHNdI/PRQbo7H
         RCIQcgXBqQNprpqE3/ak3fK7n4rcVyoQUm2yrksmRQdG92qJe4VG1mq6JBf9x1i4pWLv
         rLvw==
X-Gm-Message-State: AOAM532H7NBA/wmrNEUYOOVjueH5qIHfoUtmUfEtyoywIiNBGda6hh+l
        MtG1srT7CON0h87XhBJrVl9utnPvZ7pW4Nzk58+eeHK6Vr01Oe8Y
X-Google-Smtp-Source: ABdhPJwY2EqGHBgBjsq4KCFfJqmQEIwzjxAWCQ16mrZpT+kriAPiRr8ZlKT2W1mUfqGgicuynb6kvre6HBKiteoUCfQ=
X-Received: by 2002:a65:5ac9:: with SMTP id d9mr14884798pgt.74.1613399735737;
 Mon, 15 Feb 2021 06:35:35 -0800 (PST)
MIME-Version: 1.0
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Feb 2021 16:35:19 +0200
Message-ID: <CAHp75VecgvsDqRwmyJZb8z0n4XAUjEStrVmXDZ9-knud7_eO3A@mail.gmail.com>
Subject: commit 0f0aefd733f7 to linux-firmware effectively broke all of the
 setups with old kernels
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?Q?=EF=BF=BCPeter_Robinson?= <pbrobinson@gmail.com>,
        Josh Boyer <jwboyer@kernel.org>, Ferry Toth <fntoth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Seems the commit 0f0aefd733f7 to linux-firmware effectively broke all
of the setups with the old kernels. Firmware name is an ABI (!) and
replacing it like this will definitely break systems with older
kernels. Linux firmware package likely, but unfortunately, should
carry on both versions as long as it's needed. Alternative solution is
to provide the links during installation.

Btw, I haven't seen the driver change for that. Care to provide a
commit ID in upstream?

-- 
With Best Regards,
Andy Shevchenko
