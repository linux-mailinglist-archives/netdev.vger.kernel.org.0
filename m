Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117172274D3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgGUBme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbgGUBmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:07 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46D1C061794;
        Mon, 20 Jul 2020 18:42:06 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id e3so8614734qvo.10;
        Mon, 20 Jul 2020 18:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1vjrqjzNSqRifLTZqYgTtHp3AnNqNbKTNs2D0klGxoo=;
        b=NA3c/rnu1p5SwQqnXMh7D6RU98oJnG4jGzGySXWI+Fis8bNpLZbN6oUncSQBwem4zw
         Guq9C2GqUDaX8aXCCg9mqIVyLzCJc4xEk5iQI2dSTYSUQNX/NIT9+mHdYQqLp3rSGYXn
         a/X6L8xiOcM4FsCd2e4P/iOEQ8Bt9LnaS7bD50LGMcM8xe8eEqzSAZcPq/y16fzRKEMR
         YNoPvaIf0sSZBY3uDHl4oW8qK9lsT0WNmGlC4oRzDtrLFrwE29owkTv46OVdKiSBvICQ
         PqDj01tfUGZzUNpaeuMnr9HpP5XYhtyEKqomp628UWzBU4MN43Dm3VwK0Eu5oJ4BSkgi
         31aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vjrqjzNSqRifLTZqYgTtHp3AnNqNbKTNs2D0klGxoo=;
        b=jaUpssx6sN2e8VS6vvOqLWrzb2iCwsU/77lrea/Pd6ByGGyACK1rbquKL2EeAZzxLE
         +TkqVVLOPOKj8j3moAya4iDosZpVKJFAdFTGqaXVTuzXm/NsX3p4o4BtEeKrMlgH7U+W
         x24CMOYNkoongtygQMc4Q2defL/bVO9qIexIEW/U21+velF0sIHiqGib9VlMVv34q/q1
         uKl14Z1StNUsQmlbju/wZb32iLmcAo4flzWFwc0dcIIyNhgAR4DWG1Or9dS6vo+L/3e7
         9jmQ1v7DAtneaAt89DulXp5Y06gqC3czTgRPWkNH0kb9r4LY4ObSOKOaqGdVE3IklNWl
         Stgg==
X-Gm-Message-State: AOAM531Hknf/2hrJ+didvbWn5UnYn4DswgIFMNukc/I0gu3Kx5UdSEhM
        +RgSggwkiIErvRbFl8QJRp4=
X-Google-Smtp-Source: ABdhPJyCV4cHqa3zHGq0XXdUf7BF0VO9uxjrvhSQSq66Zg9enS9Ci/doGp2xS/cHgK1QBbILet7Aqw==
X-Received: by 2002:ad4:4112:: with SMTP id i18mr24536059qvp.109.1595295726141;
        Mon, 20 Jul 2020 18:42:06 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id r35sm21244939qtb.11.2020.07.20.18.42.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:05 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 2474327C0058;
        Mon, 20 Jul 2020 21:42:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:05 -0400
X-ME-Sender: <xms:7UcWX4COKmTgVkCnPWBwQMktP-MlWGBupoEt0hyID-EqHMdLq5dKcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:7UcWX6jIG4i2spMrKI9TaoBB5O0d6Jp5usGQqe690-Esuk3AdwR1ug>
    <xmx:7UcWX7m3W4xEDhyLSPUae86GYiZ-Teysvc-yFUnOmb3mlKdrph54Qw>
    <xmx:7UcWX-zbjDshhZXB_OcGEhqU_8ECiWZaaXjPOLfEm1EYLrMsxFMiAQ>
    <xmx:7UcWX5rSB5j57ZXtYN_kfPqLEzm1hUfJsir-4sA9LuwN74O5ccw-dllnCKM>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96B66306005F;
        Mon, 20 Jul 2020 21:42:04 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 08/11] Input: hyperv-keyboard: Make ringbuffer at least take two pages
Date:   Tue, 21 Jul 2020 09:41:32 +0800
Message-Id: <20200721014135.84140-9-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
least 2 * PAGE_SIZE: one page for the header and at least one page of
the data part (because of the alignment requirement for double mapping).

So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
using vmbus_open() to establish the vmbus connection.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/input/serio/hyperv-keyboard.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index df4e9f6f4529..77ba57ba2691 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
 
 #define HK_MAXIMUM_MESSAGE_SIZE 256
 
-#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
-#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
+#define KBD_VSC_SEND_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
+#define KBD_VSC_RECV_RING_BUFFER_SIZE		max(40 * 1024, 2 * PAGE_SIZE)
 
 #define XTKBD_EMUL0     0xe0
 #define XTKBD_EMUL1     0xe1
-- 
2.27.0

