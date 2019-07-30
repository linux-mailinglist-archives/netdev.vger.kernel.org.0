Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7566B7A582
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbfG3KFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:05:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50782 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732243AbfG3KFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:05:37 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so56575910wml.0;
        Tue, 30 Jul 2019 03:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nWsdDv8R2tGLchGaF4PGPY0GASGLiDUIzfP22Nt29ew=;
        b=ne55/2FTOx3tJMVt7EFAaneKifpHsGoTH2DSjZW3ToElYkp8R+xDur6XZS42kb6VaS
         MuF5IGR0HTd1zr/UR1LMyQoFG1GokcSPa/BxI8GDpVWyXo5HdAviZg23qpBb+XVGV2Y0
         4AeQK9DOM2YXzFcLO0QKtkNCGCbCJxA7x3bk71j7TxsGEGPnXr67kM228q6YfscnGiGh
         nDaATk1dA+NVYm+QjnOhsBFg2ph11FamOpwvqVQ9af3d8SCrH4KXQvS2vrIdZcwySeRv
         qv6JwUgcRHxXkHa+MVCRtpWf2o+M0vZIyICn6XqCqUhvIIDUj6EQfDpwl+x29aAVJTU9
         k39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nWsdDv8R2tGLchGaF4PGPY0GASGLiDUIzfP22Nt29ew=;
        b=HQT4vrNQyj82YCZN/L+R3fKP/JGwxPfIyneYm6jnux2bfYOKJNSo8w4H4J1MhhpuUc
         gctVGHnfJ+SC+HHNCXUw5mevdlyulPqUcQQb0l0IHGKccxsFxA4LhHHRZhH3q5m27dJr
         42/EBY2z4HfPAhfnHvk2ixrhF9TZgmjuE/ptXmgK1DwhZMxkcEgWEeJsQVqQ3yREzyc2
         RhfQjeMyBpjtnvkHdl0qBsvR2CxZKkMDyCGa8JfSr+6+qopPffUY3Xk4QU0sA9uc5qID
         lKI5NgYQSKeHMiioUEHONGzQCcuwHnXUNUK79xZvsZLNhUz1ifLX3rphvWKsgRVSkwif
         +hcQ==
X-Gm-Message-State: APjAAAVbI0BL4pv5lk8xohEM3+fZz5ZBxdylUZ1U1mDpDs9f9lLR8nQC
        R5zzXCIaEqqk63vfuMy3P0M4fubHOJ4=
X-Google-Smtp-Source: APXvYqwVSfOlNuasAb0NhEu0frGuirVCtRDas0xR7y2y0Qi6Yu9fb1nHPEXybUzLC3o1dlv0K5SEwQ==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr24088044wmc.1.1564481135682;
        Tue, 30 Jul 2019 03:05:35 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id n9sm108236322wrp.54.2019.07.30.03.05.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 03:05:34 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 0/4] net: dsa: mv88e6xxx: add support for MV88E6220
Date:   Tue, 30 Jul 2019 12:04:25 +0200
Message-Id: <20190730100429.32479-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the MV88E6220 chip to the mv88e6xxx driver.
The MV88E6220 is almost the same as MV88E6250 except that the ports 2-4 are
not routed to pins.

Furthermore, PTP support is added to the MV88E6250 family.

Hubert Feurstein (4):
  net: dsa: mv88e6xxx: add support for MV88E6220
  dt-bindings: net: dsa: marvell: add 6220 model to the 6250 family
  net: dsa: mv88e6xxx: setup message port is not supported in the 6250
    family
  net: dsa: mv88e6xxx: add PTP support for MV88E6250 family

 .../devicetree/bindings/net/dsa/marvell.txt   |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c              | 63 +++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  8 +-
 drivers/net/dsa/mv88e6xxx/port.h              |  1 +
 drivers/net/dsa/mv88e6xxx/ptp.c               | 73 +++++++++++++------
 5 files changed, 120 insertions(+), 27 deletions(-)

-- 
2.22.0

