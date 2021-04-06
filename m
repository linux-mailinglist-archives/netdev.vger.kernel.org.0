Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C149355CF7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347163AbhDFUfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhDFUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:35:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441B3C06174A;
        Tue,  6 Apr 2021 13:35:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j199-20020a1c23d00000b0290123bb155f6aso2798wmj.2;
        Tue, 06 Apr 2021 13:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMvPjW2QsAPyvCJfq+a499dbQHhdrOdxzTvFTum5SZ0=;
        b=JHV20ae0MBX5q2tzrKWwlH9dQ9tYw9NPzWzoZPW5EH77drSNHHBWkJdHLsHNkj+XIT
         fyoGMQ7+96mBli6Z5kBAbaT/ZrAduaeDAzdlUswg7hAYCct0mJqgopUhFnzTKH45fMOB
         w7Zvvu9SvzrQoLNirNg0F6G6VUwTvN/dNMyxLg0TKDHVyquDYA27edurf8PI3IvwFGqQ
         LZfQjF/tMT0uO+fk0Lv1O/PXdOx58E3H3n1bJU+f7bRpze5Ev78qN/II4oA107wxtLSM
         /Dnsz6yHZuiNPCUlJAmGtM+BRB5ERQoAUSiQrjkrZv8HCnTevCGFloKTCxJh8Vt9hMHb
         ApEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMvPjW2QsAPyvCJfq+a499dbQHhdrOdxzTvFTum5SZ0=;
        b=i6P3/ULlhh5dQCpL9DexThE0v9RC/74/6Vv85hcaEUIgh2e52k/Z2b1TgArBbrOn7V
         vPlm0O2yGP+YeHbP3+WRJ6M3coH5Zk9lsAXReJsG6UqmGDQnWGgcOBQHnovQGXENoftR
         hFSat72CE5rxcyC6vaG/HLZJE1k0KvRwaHYARFiY46I0eXI1PnQ8FUaarllddt4mGn0l
         9ByAuqrw4p9k/BkXR3/9nGh08t8y9coPizThXt27VcSyArx0IHyniXcrFUi8rDboZeNZ
         3U//q9fo0K2AdBCkgoJcOnvPu6FApV5x9MdcDCUVJeV4yIKC43Y8Zk6PthNW61CGN7pm
         3peQ==
X-Gm-Message-State: AOAM530+rUV8xnzcKYte0GPoxaDCQu5oFDs+yiRPRH7Y0ZfbihphpgXP
        vy3HM2CQ2wDWuSGkxDnU6UA=
X-Google-Smtp-Source: ABdhPJyQf/vCXmZnQsg/E6b6pMHI6gzqN5X4KCtRwWKlowKn3ffANf4uYT1j9HsA4D/c7lw5V2XFxQ==
X-Received: by 2002:a1c:5446:: with SMTP id p6mr5750611wmi.44.1617741323902;
        Tue, 06 Apr 2021 13:35:23 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370b4300428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370b:4300:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q14sm14040564wrg.64.2021.04.06.13.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 13:35:23 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC net 0/2] lantiq: GSWIP: two more fixes
Date:   Tue,  6 Apr 2021 22:35:06 +0200
Message-Id: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

after my last patch got accepted and is now in net as commit
3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set
the xMII clock") [0] some more people from the OpenWrt community
(many thanks to everyone involved) helped test the GSWIP driver: [1]

It turns out that the previous fix does not work for all boards.
There's no regression, but it doesn't fix as many problems as I
thought. This is why two more fixes are needed:
- the first one solves many (four known but probably there are
  a few extra hidden ones) reported bugs with the GSWIP where no
  traffic would flow. Not all circumstances are fully understood
  but testing shows that switching away from PHY auto polling
  solves all of them
- while investigating the different problems which are addressed
  by the first patch some small issues with the existing code were
  found. These are addressed by the second patch

Why am I sending this as RFC then?
Because I am not sure where to place the link configuration bits
in the first patch (as I don't understand why phylink_mac_config
and also phylink_mac_link_up both have the required parameters
to configure the link, just in differnet formats):
- in gswip_phylink_mac_config
- in gswip_phylink_mac_link_up
- in both

Any feedback is very welcome on this topic!

I have already gotten Hauke's Acked-by off-list. He's Cc'ed so he
can speak up if he changes his opinion or finds some issue with
the patches still.


Best regards,
Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e6fdeb28f4c331acbd27bdb0effc4befd4ef8e8
[1] https://github.com/openwrt/openwrt/pull/3085


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Don't use PHY auto polling
  net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

 drivers/net/dsa/lantiq_gswip.c | 211 ++++++++++++++++++++++++++++-----
 1 file changed, 183 insertions(+), 28 deletions(-)

-- 
2.31.1

