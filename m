Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BFA14ACBC
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 00:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgA0Xyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 18:54:39 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:38879 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgA0Xyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 18:54:39 -0500
Received: by mail-pj1-f74.google.com with SMTP id 14so298779pjo.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0WVlBZ9h/3UAmHAjFKk1i1lby5ArQALhCHp8vRDwf6s=;
        b=B0D4GdH37zFLkAB6DLlyqBHlLmNEXHfnkYgFffeTOmOr475hSOENtNB8TIo3G4sGe0
         FGQeW1LRFZFwEwZe0xYBNGSrbzuvSB/n522fs6/iqw0svGmiqpGIgfsGVIAnWpo0xe6b
         BoM87ucGn23bNOQFBFwtOThLn+0+3twkPtHYFFqqNHT27mvPiaZYPxgu4N/l/e8eaXcg
         7jQiGP//cNxEUu+McL7virtX6XQNY1Tl0esKP2c/WrVvCyn1rDqO+BVfbr+AnTAAodm8
         8eaZUZJdgvoPLStiKNbl0DHxWBNzGU98A6D6t+uV4+grA51Z1w5tPzJYd+kP7DcwXnGr
         FQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0WVlBZ9h/3UAmHAjFKk1i1lby5ArQALhCHp8vRDwf6s=;
        b=cAYiVylRJbmVJuTnhF23nidmXtAa4bX6mdFQVg0Q3VGCqAYU7eUcLRWMEcEugaO/iI
         hfEGWQSwVq2Yi3F3QcxV1cYp2YkJTJITPYEVR1dUKU8KrcC0EdYbAGMoCSFlAA34FnOC
         4mwmi1hFz3vcgUmcp9mJOL33TXLJeNdMrCi8pgq7gnKwwfLTh+31rPWQMaAxWam1r0xg
         T2dqmAVTsIb0wT3IMTjpThbz6dnqpzHJWBE5G9No3/Ks5gltBTHAYpHIXOwt8LrjKAFX
         /IQfgpQgaIcCN8DJp8geOc9XBMfKjFWkxwIwB5BX8L4cz5SUMTzEs3j3GTPINdU7nZZL
         6QZw==
X-Gm-Message-State: APjAAAVFohqk6elUiVckRExxVyf3F9OLoAcjjb/KFdtU+SP/xxtqAwyl
        M0c9SW37x0hQ2PpaZAVvjf68aYRYaUerf5r25J6rJg==
X-Google-Smtp-Source: APXvYqxuHlif8YoC09sMp36DADFxZKUEjmOezwoOELE8SswXmvcrc2Cpl4SiqOBpXxHMb1qSYM81/g2GJjm81WrtmsBS6w==
X-Received: by 2002:a63:ea4c:: with SMTP id l12mr20867620pgk.29.1580169278383;
 Mon, 27 Jan 2020 15:54:38 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:53:51 -0800
Message-Id: <20200127235356.122031-1-brendanhiggins@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v1 0/5] uml: add more unspecified HAS_IOMEM dependencies
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Robert Hancock <hancock@sedsystems.ca>,
        Esben Haabendal <esben@geanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, heidifahim@google.com,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

# TL;DR

This patchset adds a missing HAS_IOMEM dependency to several drivers in
an attempt to get allyesconfig closer to working for ARCH=um. Although I
had caught all the broken ones in early 5.5[1], some new ones have
broken since then.

# What am I trying to do?

This patchset is part of my attempt to get `make ARCH=um allyesconfig`
to produce a config that will build *and* boot to init, so that I can
use it as a mechanism to run tests[2].

# Why won't allyesconfig break again after this series of fixes?

Well, in short, it will break again; however, as I mentioned above, I am
using UML for testing the kernel, and I am currently working on getting
my tests to run on KernelCI. As part of our testing procedure for
KernelCI, we are planning on building a UML kernel using allyesconfig
and running our tests on it. Thus, we will find out very quickly once
someone breaks allyesconfig again once we get this all working. So this
will keep breaking until we have a build test on KernelCI running, but
we will need to send out these fixes anyway.

Brendan Higgins (5):
  net: axienet: add unspecified HAS_IOMEM dependency
  reset: brcmstb-rescal: add unspecified HAS_IOMEM dependency
  reset: intel: add unspecified HAS_IOMEM dependency
  ptp: 1588_clock_ines: add unspecified HAS_IOMEM dependency
  power: avs: qcom-cpr: add unspecified HAS_IOMEM dependency

 drivers/net/ethernet/xilinx/Kconfig | 1 +
 drivers/power/avs/Kconfig           | 2 +-
 drivers/ptp/Kconfig                 | 1 +
 drivers/reset/Kconfig               | 3 ++-
 4 files changed, 5 insertions(+), 2 deletions(-)

[1] https://lore.kernel.org/lkml/20191211192742.95699-1-brendanhiggins@google.com/
[2] https://bugzilla.kernel.org/show_bug.cgi?id=205223

-- 
2.25.0.341.g760bfbb309-goog

