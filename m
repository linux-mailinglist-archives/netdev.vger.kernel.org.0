Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BDB280D30
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJBFuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgJBFt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:49:59 -0400
Received: from mail.kernel.org (ip5f5ad59f.dynamic.kabel-deutschland.de [95.90.213.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85847208C7;
        Fri,  2 Oct 2020 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601617798;
        bh=FBPwZnSsMqIWKQkD2zCJOP8xtefKz0VFKlRBsQSz4YE=;
        h=From:To:Cc:Subject:Date:From;
        b=ejgMZ/l6FXxzU+YdRTwMxdT0f1Q+4gbrj+84EBxH2JN9yIe9vDe8W07jPvUyVE/UW
         pwqbFJ9yYWMl5Ms1dxYbPS7KEwa6ATt81MqjfNpvhhwgtMSJSrT18+F2izm1Y7rpLF
         3mFQ7DT+0UPX36PDklpu0eXa1Raxyyql02Wb8Kf4=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kODx6-006hij-79; Fri, 02 Oct 2020 07:49:56 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Balbir Singh <sblbir@amazon.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Taehee Yoo <ap420073@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Wolfram Sang <wsa@kernel.org>, kvm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-um@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 0/6] Fix new html build warnings from next-20201001
Date:   Fri,  2 Oct 2020 07:49:44 +0200
Message-Id: <cover.1601616399.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some new warnings when building the documentation from
yesterday's linux next. This small series fix them.

- patch 1 documents two new kernel-doc parameters on a net core file.
  I used the commit log in order to help documenting them;
- patch 2 fixes some tags at UMLv2 howto;
- patches 3 and 5 add some new documents at the corresponding
  index file.
- patch 4 changes kernel-doc script for it to recognize typedef enums.

Patch 4 should probably be merged via docs tree, but the others
are against stuff recently added at linux-next. So, the better is to
merge them directly at the trees which introduced the issue.

-

As a reference, the patches fixing all html build warnings are at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=sphinx3-fixes-v3

Such series also adds support for Sphinx versions 3.1 and above.

It should be noticed that, with Sphinx version 3 and above, there
are a few new warnings, because currently Sphinx assumes a
that names are unique for all C symbols. There are a few cases
where we have the same name for a function and for a struct at
the Kernel. Upstream is already working on a solution for that.

So, for now, I recomend doing html builds with version < 3.


Mauro Carvalho Chehab (6):
  net: core: document two new elements of struct net_device
  docs: vcpu.rst: fix some build warnings
  docs: virt: user_mode_linux_howto_v2.rst: fix a literal block markup
  docs: i2c: index.rst: add slave-testunit-backend.rst
  scripts: kernel-doc: add support for typedef enum
  docs: gpio: add a new document to its index.rst

 Documentation/admin-guide/gpio/index.rst      |  1 +
 .../admin-guide/hw-vuln/l1d_flush.rst         |  3 +--
 Documentation/i2c/index.rst                   |  1 +
 Documentation/virt/kvm/devices/vcpu.rst       | 26 +++++++++----------
 .../virt/uml/user_mode_linux_howto_v2.rst     |  1 +
 include/linux/netdevice.h                     |  5 ++++
 scripts/kernel-doc                            | 15 ++++++++---
 7 files changed, 33 insertions(+), 19 deletions(-)

-- 
2.26.2


