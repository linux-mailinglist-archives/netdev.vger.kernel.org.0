Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D31512A547
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfLYA54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:57:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33221 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfLYA54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:57:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id d139so2799113wmd.0;
        Tue, 24 Dec 2019 16:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VotzchowBWia33SBZNWvtqHuElucwAtYumoZTzGpWCQ=;
        b=aNXqgDezUiPP92OPEEgyn6ex0MJJ6tkJa1iQLQ3x7tPeF92q1JidZhcqqXoZq/cqIe
         hI33UVV6w97dO3Io4itkMlCA5gfJh3Cv5DjCYNlz0Fb5nUGZMkuN5wYA52KfiTqvISIU
         XeVzRKIDZMV33Qs9uzua+D3v4QYNQFOwOlWhRUWqGRGUnJTg/gD51DETHTr2P34cg77i
         8KgduyphFPuHG9G+ZMHQQ1pJJyTOlk+JzCQTFC2+mU1hc1TKLyaV2eCQGcVhQlcq2UUK
         lhNnaA040a2/80/4FSVcGuKrfqG+FW/GzMixMLDW5ccq2YA82/i6ttml9s/VY0qWjYfl
         mAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VotzchowBWia33SBZNWvtqHuElucwAtYumoZTzGpWCQ=;
        b=pV3snGY3o/P10kqVx9ByRbLCqOK3j39Y0rNtEmUXOnlcdBiUCoLow1A3n4ZsRxzLkI
         AoIPD7jw5k9tWnWQCMnNOehhnWVDC+rAvFhKWU4fYTBoY5eDHbEVbapu7q/XTrCZGieh
         Vmx/kP/EMf4UcuMxPSJiE9UXzmvLhUv1+6ULotN4vfGo+PDpzQcAANUXTvn+jzCrWxbR
         dh02OumZW3GcT+ilvPFRyZM9+9ltEWQxSmJ2QNtPWUuFVzZhmEPStNVFJlzHTxlkhmxh
         VOXkAB44drOK1GDF3MdQ76J61bHdL54B8nX1oYEP5o7YEPwKYzmnF4ie9tMgYYHioJAY
         8mGQ==
X-Gm-Message-State: APjAAAUwolsLWsiaLK4w50MlPX79SG7y88v4WkCpXFxPoSqLybA5HZ81
        dw7beLM4BxPQwzAFTPahiS8=
X-Google-Smtp-Source: APXvYqxT1GuAR0B1XYM3pxm/0fTXXYbqGvbrMnzYbqu3FXAimku+BcOGTgmHUUv4jgJzrLt3vo/FbA==
X-Received: by 2002:a05:600c:2046:: with SMTP id p6mr6444994wmg.110.1577235473304;
        Tue, 24 Dec 2019 16:57:53 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id e18sm26034448wrw.70.2019.12.24.16.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 16:57:52 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbes-150@yandex.ru, ingrassia@epigenesys.com,
        jbrunet@baylibre.com, linus.luessing@c0d3.blue,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/3] Meson8b/8m2: Ethernet RGMII TX delay fixes
Date:   Wed, 25 Dec 2019 01:56:52 +0100
Message-Id: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ethernet TX performance has been historically bad on Meson8b and
Meson8m2 SoCs because high packet loss was seen. Today I (presumably)
found out why this is: the input clock (which feeds the RGMII TX clock)
has to be at least 4 times 125MHz. With the fixed "divide by 2" in the
clock tree this means that m250_div needs to be at least 2.

Now the PRG_ETH0 register in Linux matches what u-boot and the vendor
3.10 kernel use. iperf3 output on my Odroid-C1 (where this series has
been tested):
# iperf3 -c 192.168.1.100
Connecting to host 192.168.1.100, port 5201
[  5] local 192.168.1.163 port 42636 connected to 192.168.1.100 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   105 MBytes   878 Mbits/sec    0    609 KBytes       
[  5]   1.00-2.00   sec   106 MBytes   885 Mbits/sec    0    683 KBytes       
[  5]   2.00-3.09   sec  73.7 MBytes   570 Mbits/sec    0    683 KBytes       
[  5]   3.09-4.00   sec  81.9 MBytes   754 Mbits/sec    0    795 KBytes       
[  5]   4.00-5.00   sec   104 MBytes   869 Mbits/sec    0    877 KBytes       
[  5]   5.00-6.00   sec   105 MBytes   878 Mbits/sec    0    877 KBytes       
[  5]   6.00-7.00   sec  68.0 MBytes   571 Mbits/sec    0    877 KBytes       
[  5]   7.00-8.00   sec  80.7 MBytes   676 Mbits/sec    0    877 KBytes       
[  5]   8.00-9.01   sec   102 MBytes   853 Mbits/sec    0    877 KBytes       
[  5]   9.01-10.00  sec   101 MBytes   859 Mbits/sec    0    877 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   927 MBytes   778 Mbits/sec    0             sender
[  5]   0.00-10.01  sec   927 MBytes   777 Mbits/sec                  receiver


@David: please only apply patch #1 from this series. I included the .dts
changes so others can test them together with the driver update (as the
.dts has to be updated to fully fix the TX packet loss - with the old TX
delay in the .dts there is still packet loss, even with a fixed driver).

I will ask Kevin to apply patches #2 and #3 through his linux-amlogic
tree - or resend them. When applying the .dts patches without the fix in
the driver then I get 100% packet loss on my Odroid-C1. So unfortunately
there's a hard dependency between patch 1 and 2/3.


Martin Blumenstingl (3):
  net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs
  ARM: dts: meson8b: odroidc1: use the same RGMII TX delay as u-boot
  ARM: dts: meson8m2: mxiii-plus: use the same RGMII TX delay as u-boot

 arch/arm/boot/dts/meson8b-odroidc1.dts             |  2 +-
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts          |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    | 14 +++++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.24.1

