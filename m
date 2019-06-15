Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E154546F9D
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfFOKjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:39:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32943 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfFOKjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:39:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so1087079wme.0;
        Sat, 15 Jun 2019 03:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EWaWjBLfgDeqQMeH6hpzSxjXl2/kKEQOmTgrAj3YJGg=;
        b=q4/8iFDv/T3DcaMC2SysEKqDtCxF3c7gcO9kFC6QhAQ8Ex2o7CwvTeaOo3VXylWkt4
         YtbxW1khkg1DKRwBV1F2J2Dx7XsWT6rv7r8yWVXm4CBoo4yVH/vislaPW/LkR2ChisMx
         j8czCpHUS5RtVrKyJjtzW8TPdYApVAt6hXdf+z+bEjCgoussLKr8dbuyIZnjrvJBzU8p
         3v1fwA87rIJQ0l4yCuDEVLyQ0HIrdeB/ovFmI7Cx42GS4Xq9b+WPRwNLXlVje9c09Tz5
         dHtJbavxvfEoLGIDWDTzo/YLgR9zA5T8dPelO8cn3of6uTO2tuh8JYZLTaaRzEE+JYEG
         D2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EWaWjBLfgDeqQMeH6hpzSxjXl2/kKEQOmTgrAj3YJGg=;
        b=U9dNjMEpGeSwFxz5YsOYLqpFRibipKnf76hCsljSQ/fubkLIF/cAZ10ZBb/e1eKvKS
         gOcQTw/+KbdnYeij1slxoYaPqngNeHvgRlXRtJ4e9gAPDxX/78wj4yqQuBPDfeolZxkW
         BuVsEc/UZlpOyd7y+B7KZpYtT+hN1YmSCZSkNpakP6Fw6qO7efTRpnFuGdBWheuVVbf7
         VsswocGDwunJsZsHrTFkBmHmAo9IbKxHxrzYqls47ESNnCJKQYyMqt0cEmLfKwNlqkTJ
         OqszgZy1xPaxFK4ImGfHaFwteU3ZBk9Fh6lEr33LeK/rSPIruvrWFOYj1WTzEMlsmZuI
         43Tw==
X-Gm-Message-State: APjAAAXHO2bvTtMt/VeVO9fnSxOjkRFuPYVowD+FYT7HX/pjDITUKQFL
        UL5rQtrBVQ8LkozBhqagmZQ=
X-Google-Smtp-Source: APXvYqw7KUGm67auqn07Aq7kGxt/BE4gLpTyvUOVo7p1zIlBqBC3k9rX5VurjgaPLbfEwXXhKwRLZw==
X-Received: by 2002:a1c:2dd2:: with SMTP id t201mr10541354wmt.136.1560595152890;
        Sat, 15 Jun 2019 03:39:12 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id o126sm12209031wmo.31.2019.06.15.03.39.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:39:12 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com, narmstrong@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 0/4] Ethernet PHY reset GPIO updates for Amlogic SoCs
Date:   Sat, 15 Jun 2019 12:38:28 +0200
Message-Id: <20190615103832.5126-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While trying to add the Ethernet PHY interrupt on the X96 Max I found
that the current reset line definition is incorrect. Patch #1 fixes
this.

Since the fix requires moving from the deprecated "snps,reset-gpio"
property to the generic Ethernet PHY reset bindings I decided to move
all Amlogic boards over to the non-deprecated bindings. That's what
patches #2 and #3 do.

Finally I found that Odroid-N2 doesn't define the Ethernet PHY's reset
GPIO yet. I don't have that board so I can't test whether it really
works but based on the schematics it should. 

This series is a partial successor to "stmmac: honor the GPIO flags
for the PHY reset GPIO" from [0]. I decided not to take Linus W.'s
Reviewed-by from patch #4 of that series because I had to change the
wording and I want to be sure that he's happy with that now.

One quick note regarding patches #1 and #4: I decided to violate the
"max 80 characters per line" (by 4 characters) limit because I find
that the result is easier to read then it would be if I split the
line.


Changes since v1 at [1]:
- fixed the reset deassert delay for RTL8211F PHYs - spotted by Robin
  Murphy (thank you). according to the public RTL8211E datasheet the
  correct values seem to be: 10ms assert, 30ms deassert
- fixed the reset assert and deassert delays for IP101GR PHYs. There
  are two values given in the public datasheet, use the higher one
  (10ms instead of 2.5)
- update the patch descriptions to quote the datasheets (the RTL8211F
  quotes are taken from the public RTL8211E datasheet because as far
  as I can tell the reset sequence is identical on both PHYs)

Changes since v2 at [2]:
- add Neil's Reviewed/Acked/Tested-by's (thank you!)
- rebased on top of "arm64: dts: meson-g12a-x96-max: add sound card"


[0] https://patchwork.kernel.org/cover/10983801/
[1] https://patchwork.kernel.org/cover/10985155/
[2] https://patchwork.kernel.org/cover/10990863/


Martin Blumenstingl (4):
  arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
  ARM: dts: meson: switch to the generic Ethernet PHY reset bindings
  arm64: dts: meson: use the generic Ethernet PHY reset GPIO bindings
  arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line

 arch/arm/boot/dts/meson8b-ec100.dts                   |  9 +++++----
 arch/arm/boot/dts/meson8b-mxq.dts                     |  9 +++++----
 arch/arm/boot/dts/meson8b-odroidc1.dts                |  9 +++++----
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts             |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts    |  7 ++++---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts  |  4 ++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts  |  9 +++++----
 .../arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts   |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts       |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi  |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi     |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts  | 11 ++++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 10 +++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts   |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts        | 11 ++++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts    |  8 ++++----
 17 files changed, 80 insertions(+), 66 deletions(-)

-- 
2.22.0

