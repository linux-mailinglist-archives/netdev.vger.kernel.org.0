Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACDBEDB1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfD3A3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:29:07 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:38795 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729214AbfD3A3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 20:29:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 718091079D;
        Mon, 29 Apr 2019 20:29:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Apr 2019 20:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PUfwhBqQiuelCDdVE
        fv1BguoRsrTQ+mCQVYuoDSCS/I=; b=lxwwlA6SG7R/O2xZawf2WLhFjylXN+iYM
        fd3qbehO+26oL7RxMDCJ19NFuatJz5fJ2xiUS8auEqqOo6gcix7tQ9L4QZ2PKjeR
        8YRYxQTwQX03ix+DGYYzXCnHPDThVh6lx0qZo+RX1JxqUwF/8/PcdeTxaAHfupaX
        VfurUS+f3Ddl5k7gEpdWi+cw5f94TRZ4qM8wBboOCdVfet4wu62jJV+cAzySrBpg
        qyJkCtuQR28anNWYNnsjBF7UPOgnSxm8F0Mbem3lqYnKILCcOrHrIwVN/y9jbwwo
        YJDoqCTYixFXwe4p7lR2wf0JvRSeR7doqxtaD71YmXbNtEqqD/9pQ==
X-ME-Sender: <xms:0JbHXHKhd0a6iIuIHN4ifelH0_hBCUUxHtL9fhranWmF28sMfaS3nQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhnucev
    rdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkphepud
    dvuddrgeegrddvfedtrddukeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgsihhn
    sehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:0JbHXNNF-E4vRHRUisgWo0WoKr1Mzpj9jxYzpD6BhFS4OTX5cZcnhw>
    <xmx:0JbHXAMCl9GErnEVgTXknHPGPTdb7ebuCl2u7zdzpiJSYSMEe2ZXFg>
    <xmx:0JbHXFJADdgU1W8hMCP5rxBOMOvPYsKl6uI3rQZJe3ohmw7jhYMJZw>
    <xmx:0ZbHXAJ6VU_4ypOuuDLympybyocUe4CGfGmUKs0dqUu-lHiG2J3DlA>
Received: from eros.localdomain (ppp121-44-230-188.bras2.syd2.internode.on.net [121.44.230.188])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECE061037C;
        Mon, 29 Apr 2019 20:28:59 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix error path for kobject_init_and_add()
Date:   Tue, 30 Apr 2019 10:28:14 +1000
Message-Id: <20190430002817.10785-1-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

There are a few places in net/ that are not correctly handling the error
path after calls to kobject_init_and_add().  This set fixes all of these
for net/

This corrects a memory leak if kobject_init() is not followed by a call
to kobject_put()

This set is part of an effort to check/fix all of these mem leaks across
the kernel tree.

For reference this is the behaviour that we are trying to achieve

void fn(void)
{
	int ret;

	ret = kobject_init_and_add(kobj, ktype, NULL, "foo");
	if (ret) {
		kobject_put(kobj);
		return ret;
	}

	ret = some_init_fn();
	if (ret)
		goto err;

	ret = some_other_init_fn();
	if (ret)
		goto other_err;

	kobject_uevent(kobj, KOBJ_ADD);
	return 0;

other_err:
	other_clean_up_fn();
err:
	kobject_del(kobj);
	return ret;
}


Testing: No testing done, built with config options

CONFIG_NET=y
CONFIG_SYSFS=y
CONFIG_BRIDGE=y


thanks,
Tobin.

Tobin C. Harding (3):
  bridge: Fix error path for kobject_init_and_add()
  bridge: Use correct cleanup function
  net-sysfs: Fix error path for kobject_init_and_add()

 net/bridge/br_if.c   | 6 ++++--
 net/core/net-sysfs.c | 8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.21.0

